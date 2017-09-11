import net

var socket = newSocket()
socket.bindAddr(Port(1234))
socket.listen()

var client = newSocket()
var address = ""
var running = true
echo "Awaiting client connection"
socket.acceptAddr(client, address)
echo("Client connected from: ", address)
while running:
  let message = client.recvLine()
  case message:
  of "":
    running = false
  else:
    echo message
