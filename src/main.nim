import jsffi

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

app.on("ready", createWindow)

app.on("window-all-closed", proc () =
  if process.platform.to(cstring) != "darwin":
    app.quit()
)

app.on("activate", proc() =
  if mainWindow == nil:
    createWindow()
)
