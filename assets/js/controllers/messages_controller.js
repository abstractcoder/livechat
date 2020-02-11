import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["messageAlert"]

  connect() {
    this.scrollToBottom(false)

    this.element.addEventListener("scroll", this.scrollHandler.bind(this))

    this.observer = new MutationObserver(this.mutationCallback.bind(this))
    this.observer.observe(this.element, { childList: true })
  }

  disconnect() {
    this.element.removeEventListener("scroll", () => this.scrollHandler())
    this.observer.disconnect()
  }

  mutationCallback(mutationsList, _observer) {
    for (let mutation of mutationsList) {
      if (mutation.addedNodes.length > 0) {
        this.showMessage()
      }
    }
  }

  showMessageAlert() {
    this.messageAlertTarget.removeAttribute("hidden")
  }

  hideMessageAlert() {
    this.messageAlertTarget.setAttribute("hidden", true)
  }

  scrollHandler() {
    // Assume at bottom if within the cushion
    const bottomCushion = 20

    if (this.element.scrollHeight - this.element.clientHeight - this.element.scrollTop < bottomCushion) {
      this.hideMessageAlert() 
      this.atBottom = true
    }
    else {
      this.atBottom = false
    }
  }

  scrollToBottom(smooth = true) {
    let opts = { top: this.element.scrollHeight }

    if (smooth) {
      opts["behavior"] = "smooth"
    }

    this.element.scrollTo(opts)

    this.atBottom = true
  }

  showMessage() {
    if (this.atBottom) {
      this.scrollToBottom()
    }
    else {
      this.showMessageAlert()
    }
  }
}