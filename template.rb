=begin
Template Name: Kickoff - Tailwind CSS
Author: Andy Leverenz
Author URI: https://web-crunch.com
Instructions: $ rails new myapp -d <postgresql, mysql, sqlite3> -m template.rb
              Add -j esbuild to also get React wired up.
=end

# Prepend this template's directory so copy_file/directory find our files,
# while keeping Rails' own generator source paths intact.
def add_template_to_source_path
  source_paths.unshift(File.expand_path(File.dirname(__FILE__)))
end

def add_gems
  gem "devise", "~> 4.9"
  gem "friendly_id", "~> 5.5"
  gem "name_of_person", "~> 1.1"
  gem "stripe"
  gem "tailwindcss-rails", "~> 4.0"
end

def add_tailwind
  rails_command "tailwindcss:install"
end

def add_storage_and_rich_text
  rails_command "active_storage:install"
  rails_command "action_text:install"
end

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  # Use Turbo-compatible response statuses (Devise 4.9+ supports Turbo natively)
  gsub_file "config/initializers/devise.rb",
    "# config.responder.error_status = :unprocessable_entity",
    "config.responder.error_status = :unprocessable_entity"
  gsub_file "config/initializers/devise.rb",
    "# config.responder.redirect_status = :see_other",
    "config.responder.redirect_status = :see_other"

  route "root to: 'home#index'"

  # Create Devise User
  generate :devise, "User", "first_name", "last_name", "admin:boolean"

  # set admin boolean to false by default
  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"
  end

  # name_of_person gem
  append_to_file("app/models/user.rb", "\nhas_person_name\n", after: "class User < ApplicationRecord")
end

def copy_templates
  directory "app", force: true
  directory "lib", force: true
end

def add_friendly_id
  generate "friendly_id"
end

# When the app is generated with a JS bundler (e.g. -j esbuild), wire up
# React with a Turbo-aware component mounting system. The default
# importmap setup stays Node-free and skips this entirely.
def add_react
  return unless File.exist?("package.json")

  package_add = if File.exist?("yarn.lock")
    "yarn add"
  elsif File.exist?("bun.lock") || File.exist?("bun.lockb")
    "bun add"
  else
    "npm install"
  end
  run "#{package_add} react react-dom"

  # Use React's automatic JSX runtime so components don't need `import React`
  gsub_file "package.json",
    "esbuild app/javascript/*.*",
    "esbuild app/javascript/*.* --jsx=automatic"

  copy_file "react/components/index.jsx", "app/javascript/components/index.jsx"
  copy_file "react/components/hello_react.jsx", "app/javascript/components/hello_react.jsx"

  append_to_file "app/javascript/application.js", %(import "./components"\n)

  # Bundled apps load the compiled bundle instead of import maps
  gsub_file "app/views/shared/_head.html.erb",
    "<%= javascript_importmap_tags %>",
    %(<%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>)

  # Show off a live React component on the homepage
  insert_into_file "app/views/home/index.html.erb",
    %(  <div class="mt-6 p-4 rounded-lg bg-indigo-50" data-react-component="HelloReact" data-react-props='{"name": "React"}'></div>\n\n),
    before: %(  <p class="text-xs text-gray-600 max-w-lg mt-6">)
end

# Main setup
add_template_to_source_path

add_gems

after_bundle do
  add_tailwind
  add_storage_and_rich_text
  add_users
  copy_templates
  add_react
  add_friendly_id

  # Create and migrate the database
  rails_command "db:prepare"

  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit" }

  say
  say "Kickoff app successfully created! \u{1F44D}", :green
  say
  say "Switch to your app by running:"
  say "$ cd #{app_name}", :yellow
  say
  say "Then run:"
  say "$ ./bin/dev", :green
end
