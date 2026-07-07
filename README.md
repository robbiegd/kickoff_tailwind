![Kickoff Tailwind](https://f001.backblazeb2.com/file/webcrunch/kt.jpg)

A free and simple starting point for Ruby on Rails 8 applications. This template utilizes [Tailwind CSS v4](https://tailwindcss.com/), a utility-first CSS framework for rapid UI development — with **no Node.js required**.

### Included gems

- [devise](https://github.com/heartcombo/devise) (4.9+, with native Turbo support)
- [friendly_id](https://github.com/norman/friendly_id)
- [name_of_person](https://github.com/basecamp/name_of_person)
- [stripe](https://github.com/stripe/stripe-ruby)
- [tailwindcss-rails](https://github.com/rails/tailwindcss-rails) — Tailwind CSS v4 via the standalone CLI, no JavaScript build step

### Modern Rails defaults

The template leans on what Rails 8 already gives you out of the box:

- **Propshaft** for the asset pipeline
- **Import maps + Hotwire** (Turbo and Stimulus) for JavaScript — no bundler, no `node_modules`
- **Solid Queue** as the production Active Job backend (no Redis required)
- **Solid Cache** and **Solid Cable** for caching and Action Cable
- **Kamal** and **Thruster** for deployment

> Earlier versions of this template shipped Sidekiq. Rails 8's Solid Queue now covers background jobs by default; if you prefer Sidekiq, add it back with a couple of lines in your Gemfile and `config.active_job.queue_adapter`.

## How it works

When creating a new Rails app simply pass the template file through:

```bash
rails new sample_app -m template.rb
```

Prefer PostgreSQL? Add `-d postgresql`.

### Want React?

Generate your app with a JS bundler and the template wires React up automatically:

```bash
rails new sample_app -j esbuild -m template.rb
```

You get `react`/`react-dom`, an `app/javascript/components/` directory, esbuild configured with the automatic JSX runtime, and a Turbo-aware mounting system that cleanly mounts/unmounts components across Turbo navigations. Render a component from any ERB view:

```erb
<div data-react-component="HelloReact" data-react-props='{"name": "Rails"}'></div>
```

Register new components in `app/javascript/components/index.jsx`. React coexists with Hotwire — use Turbo/Stimulus for most of the app and reach for React where you need rich client-side interactivity. The default (no `-j` flag) setup remains 100% Node-free.

### Once installed what do I get?

- [Tailwind CSS v4](https://tailwindcss.com) with the first-party `@tailwindcss/forms` and `@tailwindcss/typography` plugins enabled via the CSS-first `@plugin` directive in `app/assets/tailwind/application.css`. (`line-clamp` and `aspect-ratio` utilities are part of Tailwind core now.)
- [Devise](https://github.com/heartcombo/devise) with a `name` field already migrated in, mapping to `first_name`/`last_name` thanks to [`name_of_person`](https://github.com/basecamp/name_of_person). Turbo-native — no `data-turbo="false"` workarounds.
- Enhanced views and Devise views styled with Tailwind CSS.
- A Stimulus-powered responsive navbar.
- An `admin` boolean on `User` (default `false`) for gating admin-only features.
- The [Stripe](https://rubygems.org/gems/stripe/) gem for accepting payments. Be sure to add your own API keys.
- [friendly_id](https://github.com/norman/friendly_id) installed with its generator run. You'll still need to configure your models to use it.
- Custom view helper defaults for basic button and form elements (`app/helpers/application_helper.rb`).
- Custom scaffold templates made with Tailwind CSS.
- Active Storage and Action Text preinstalled.

### Boot it up

```bash
bin/dev
```

This runs the Rails server and the Tailwind watcher via `Procfile.dev`.

### Requirements

- Ruby 3.2+ (3.4 recommended)
- Rails 8.0+
- No Node.js, no Yarn, no Redis (Node is only needed if you opt into React via `-j esbuild`)

### Credits

Made by @justalever (yours truly). Find me on [Twitter](https://twitter.com/justalever), [web-crunch.com](https://web-crunch.com), [GitHub](https://github.com/justalever).
