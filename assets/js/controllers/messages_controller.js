import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["messageAlert"]

  connect() {
    this.scrollToBottom(false)

    this.element.addEventListener("scroll", this.scrollHandler.bind(this))

    const callback = (mutationsList, observer) => {
      for (let mutation of mutationsList) {
        for (let node of mutation.addedNodes) {
          this.showMessage(node)
        }
      }
    }
    this.observer = new MutationObserver(callback)
    this.observer.observe(this.element, { childList: true })
  }

  disconnect() {
    this.element.removeEventListener("scroll", () => this.scrollHandler())
    this.observer.disconnect()
  }

  showMessageAlert() {
    this.messageAlertTarget.removeAttribute("hidden")
  }

  hideMessageAlert() {
    this.messageAlertTarget.setAttribute("hidden", true)
  }

  scrollHandler() {
    if (this.element.scrollHeight - this.element.offsetHeight - this.element.scrollTop < 10) {
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

  showMessage(node) {
    if (this.atBottom) {
      this.scrollToBottom()
    }
    else {
      this.showMessageAlert()
      this.element.scrollBy(0, -node.clientHeight)
    }
  }

}