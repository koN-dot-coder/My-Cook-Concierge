import { Controller } from "@hotwired/stimulus"

// Prevents duplicate form submissions across all diagnosis question forms.
export default class extends Controller {
  static values = { timeout: { type: Number, default: 30000 } }

  connect() {
    this.busy = false
    this.safetyTimer = null
  }

  disconnect() {
    this.clearSafetyTimer()
  }

  // Capture phase blocks a second form submit while one is in flight.
  guard(event) {
    if (this.busy) {
      event.preventDefault()
      event.stopImmediatePropagation()
      return
    }

    this.busy = true
    this.setBusy(true)
    this.startSafetyTimer()
  }

  complete(event) {
    if (event.detail.success) return

    this.reset()
  }

  clearTimer() {
    this.clearSafetyTimer()
  }

  reset() {
    this.busy = false
    this.clearSafetyTimer()
    this.setBusy(false)
  }

  startSafetyTimer() {
    this.clearSafetyTimer()
    this.safetyTimer = window.setTimeout(() => this.reset(), this.timeoutValue)
  }

  clearSafetyTimer() {
    if (this.safetyTimer) {
      window.clearTimeout(this.safetyTimer)
      this.safetyTimer = null
    }
  }

  setBusy(busy) {
    this.element.classList.toggle("opacity-70", busy)
    this.element.classList.toggle("pointer-events-none", busy)
    this.element.querySelectorAll("button[type='submit']").forEach((button) => {
      button.disabled = busy
      button.toggleAttribute("aria-busy", busy)
      button.classList.toggle("cursor-wait", busy)
    })
  }
}
