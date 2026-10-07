import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "showIcon", "hideIcon", "toggle"]

  toggle() {
    const visible = this.inputTarget.type === "text"

    this.inputTarget.type = visible ? "password" : "text"
    this.syncUi()
  }

  syncUi() {
    const isVisible = this.inputTarget.type === "text"

    this.showIconTarget.classList.toggle("hidden", !isVisible)
    this.hideIconTarget.classList.toggle("hidden", isVisible)
    this.toggleTarget.setAttribute(
      "aria-label",
      isVisible ? "パスワードを表示" : "パスワードを隠す"
    )
  }
}
