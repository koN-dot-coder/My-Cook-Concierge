import { Controller } from "@hotwired/stimulus"

// Prevents duplicate form submissions when users click diagnosis choices rapidly.
export default class extends Controller {
  connect() {
    this.locked = false
  }

  // Block follow-up clicks without disabling the button (which would cancel submit).
  prepare(event) {
    if (this.locked) {
      event.preventDefault()
      event.stopImmediatePropagation()
      return
    }

    this.locked = true
  }

  // Disable UI only after Turbo has started the request.
  submitStart() {
    this.element.classList.add("opacity-70", "pointer-events-none")
    this.setButtonsBusy(true)
  }

  // Re-enable when submission fails so the user is not stuck on the same question.
  complete(event) {
    if (event.detail.success) return

    this.reset()
  }

  reset() {
    this.locked = false
    this.element.classList.remove("opacity-70", "pointer-events-none")
    this.setButtonsBusy(false)
  }

  setButtonsBusy(busy) {
    this.element.querySelectorAll("button[type='submit']").forEach((button) => {
      button.disabled = busy
      button.toggleAttribute("aria-busy", busy)
      button.classList.toggle("cursor-wait", busy)
    })
  }
}
