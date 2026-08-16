import { Controller } from "@hotwired/stimulus"

// Prevents duplicate form submissions when users click diagnosis choices rapidly.
export default class extends Controller {
  connect() {
    this.locked = false
  }

  guard(event) {
    if (this.locked) {
      event.preventDefault()
      event.stopImmediatePropagation()
      return
    }

    this.locked = true
    this.element.querySelectorAll("button[type='submit']").forEach((button) => {
      button.disabled = true
      button.setAttribute("aria-busy", "true")
      button.classList.add("opacity-60", "cursor-wait")
    })
  }
}
