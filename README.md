# nim-electron

An example for how you can run Nim code in an Electron application. This was based on the [Electron Quick Start Guide](http://electron.atom.io/docs/tutorial/quick-start).

## To Use

To clone and run this repository you'll need [Git](https://git-scm.com), [Nim](https://nim-lang.org) and [Node.js](https://nodejs.org/en/download/) (which comes with [npm](http://npmjs.com)) installed on your computer. From your command line:

```bash
# Clone this repository
git clone https://github.com/PMunch/nim-electron
# Go into the repository
cd nim-electron
# Install Electron dependencies
npm install
# Compile the Nim code
nim js -d:node -o:main.js main.nim
nim c app.nim
# Run the native app
./app
# Run the Electron app
npm start
```

The native app should start listening on port 1234 and the Electron app will connect to this port and send a "Hello, world" message.

