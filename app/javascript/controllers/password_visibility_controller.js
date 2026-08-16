import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "showIcon", "hideIcon", "toggle"]

  toggle() {
    const visible = this.inputTarget.type === "text"

    this.inputTarget.type = visible ? "password" : "text"
    this.showIconTarget.classList.toggle("hidden", !visible)
    this.hideIconTarget.classList.toggle("hidden", visible)
    this.toggleTarget.setAttribute("aria-label", visible ? "パスワードを表示" : "パスワードを隠す")
  }
}
