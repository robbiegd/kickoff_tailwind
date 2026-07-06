import { Controller } from "@hotwired/stimulus"

// Toggles the mobile navigation menu in shared/_navbar.html.erb
export default class extends Controller {
  static targets = ["menu"]

  toggleMenu() {
    this.menuTarget.classList.toggle("hidden")
  }
}
