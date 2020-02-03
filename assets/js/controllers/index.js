import { Application } from "../../node_modules/stimulus/index"
import { definitionsFromContext } from "../../node_modules/stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)

application.load(definitionsFromContext(context))