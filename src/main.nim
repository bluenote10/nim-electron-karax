import jsffi except `&`

#{.experimental: "notnil".}
#import karax/prelude
#import karax/kdom
#import karax/vdom
#import karax/karax
include karax/prelude
import karax_utils

{.emit: """
const electron = require('electron')
const path = require('path')
const url = require('url')
const net = require('net');
""".}

var
  electron {. importc, nodecl .}: JsObject
  path {. importc, nodecl .}: JsObject
  url {. importc, nodecl .}: JsObject
  console {. importc, nodecl .}: JsObject
  process {.importc, nodecl.}: JsObject
  net {.importc, nodecl.}: JsObject
  dirname {.importc: "__dirname", nodecl.}: JsObject

let app = electron.app
let browserWindow = electron.BrowserWindow

var mainWindow: JsObject
#var client = jsnew net.createConnection(JsObject{ port: 1234 }, proc () =
#  console.log("Connected to server!")
#)


type
  # Elm's `model`
  Model = ref object
    toggle: bool


proc init(): Model =
  # Elm's `init`
  Model(toggle: true)


proc onClick(model: Model, ev: Event, n: VNode) =
  # Elm's `update`. Note that we could have
  # a global `update` like Elm as well. In this case
  # the event handlers would construct a message type
  # and pass it to a model update function.
  # See second ElmLike demo for an example
  kout(ev)
  kout(model)
  model.toggle = model.toggle xor true


proc view(model: Model): VNode =
  # Elm's `view`.
  result = buildHtml():
    tdiv:
      # message handler close over the model using the curry macro
      button(onclick=curry(onClick, model)):
        text "click me"
      tdiv:
        text "Toggle state:"
      tdiv:
        if model.toggle:
          text "true"
        else:
          text "false"

# Putting it all together
proc runMain() =
  var model = init()

  proc renderer(): VNode =
    view(model)

  kout("Setting renderer...")
  setRenderer(renderer, "ROOT")


proc createWindow() =
  mainWindow = jsnew electron.BrowserWindow(JsObject{width: 800, height: 600})
  mainWindow.loadURL(url.format(JsObject{
    pathname: dirname.to(cstring) & "/index.html",
    protocol: "file".cstring,
    slashes: true
  }))

  mainWindow.on("closed", proc () =
    mainWindow = nil
  )

  #client.write "Hello, world\r\n"

  runMain()


app.on("ready", createWindow)

app.on("window-all-closed", proc () =
  if process.platform.to(cstring) != "darwin":
    app.quit()
)

app.on("activate", proc() =
  if mainWindow == nil:
    createWindow()
)
