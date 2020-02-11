// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import smoothscroll from "smoothscroll-polyfill"
smoothscroll.polyfill()

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let setupTrix = function() {
  const trix = document.querySelector(`trix-editor[input=${this.el.id}]`)
  if (trix) {
    trix.value = this.el.value
    if (trix.value.length > 0) {
      trix.focus()
      trix.editor.setSelectedRange(trix.editor.getDocument().getLength() - 1)
    }
  }

  // Noscript tags are added to support javascript being disabled
  // Make sure noscript tags are inside elements with phx-update="ignore"
  // otherwise Live View will re-add them to the DOM on update
  for(let e of document.getElementsByTagName("noscript")) { e.remove() }
}

let Hooks = {}
Hooks.Trix = {
  mounted() {
    setupTrix.call(this)
  },
  updated() {
    setupTrix.call(this)
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks});
liveSocket.connect()

require("trix/dist/trix")
import "./controllers"
