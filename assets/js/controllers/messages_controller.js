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
      if (mutation.removedNodes.length > 0) {
        this.resetScrollPosition()
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
    this.scrollTop = this.element.scrollTop
    this.scrollHeight = this.element.scrollHeight

    if (this.element.scrollHeight - this.element.clientHeight - this.element.scrollTop < 10) {
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
      this.element.scrollTo(0, this.scrollTop)
    }
  }

  resetScrollPosition() {
    const adjustment = this.scrollHeight - this.element.scrollHeight
    this.element.scrollBy(0, adjustment)
  }

}