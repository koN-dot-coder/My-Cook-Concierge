import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    delay: { type: Number, default: 3000 }
  }

  connect() {
    requestAnimationFrame(() => {
      this.element.classList.remove("opacity-0", "-translate-y-4")
      this.element.classList.add("opacity-100", "translate-y-0")
    })

    this.timeout = setTimeout(() => this.dismiss(), this.delayValue)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  dismiss() {
    clearTimeout(this.timeout)
    this.element.classList.remove("opacity-100", "translate-y-0")
    this.element.classList.add("opacity-0", "-translate-y-4")

    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
