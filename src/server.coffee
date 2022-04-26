net = require("net")
fs = require("fs")
path = require("path")
http = require("http")
WebSocket = require('ws')
WebSocketServer = WebSocket.Server
parseArgs = require("minimist")
Encryptor = require("./encrypt").Encryptor

options =
  alias:
    'b': 'local_address'
    'r': 'remote_port'
    'k': 'password',
    'c': 'config_file',
    'm': 'method'
  string: ['local_address', 'password', 'method', 'config_file']
  default:
    'config_file': path.resolve(__dirname, "config.json")

inetNtoa = (buf) ->
  buf[0] + "." + buf[1] + "." + buf[2] + "." + buf[3]

configFromArgs = parseArgs process.argv.slice(2), options
configFile = configFromArgs.config_file
configContent = fs.readFileSync(configFile)
config = JSON.parse(configContent)

config['remote_port'] = +process.env.PORT if process.env.PORT
config['password'] = process.env.KEY if process.env.KEY
config['method'] = process.env.METHOD if process.env.METHOD

for k, v of configFromArgs
  config[k] = v

timeout = Math.floor(config.timeout * 1000)
LOCAL_ADDRESS = config.local_address
PORT = config.remote_port
KEY = config.password
METHOD = config.method

if METHOD.toLowerCase() in ["", "null", "table"]
  METHOD = null

server = http.createServer (req, res) ->
  res.writeHead 200, 'Content-Type': 'text/plain'
  res.end("asdf.")

wss = new WebSocketServer server: server

wss.on "connection", (ws) ->
  console.log "server connected"
  console.log "concurrent connections:", wss.clients.length
  encryptor = new Encryptor(KEY, METHOD)
  stage = 0
  headerLength = 0
  remote = null
  cachedPieces = []
  addrLen = 0
  remoteAddr = null
  remotePort = null
  ws.on "message", (data, flags) ->
    data = encryptor.decrypt data
    if stage is 5
      ws._socket.pause() unless remote.write(data)
      return
    if stage is 0
      try
        addrtype = data[0]
        if addrtype is 3
          addrLen = data[1]
        else unless addrtype is 1
          console.warn "unsupported addrtype: " + addrtype
          ws.close()
          return
        # read address and port
        if addrtype is 1
          remoteAddr = inetNtoa(data.slice(1, 5))
          remotePort = data.readUInt16BE(5)
          headerLength = 7
        else
          remoteAddr = data.slice(2, 2 + addrLen).toString("binary")
          remotePort = data.readUInt16BE(2 + addrLen)
          headerLength = 2 + addrLen + 2

        # connect remote server
        remote = net.connect(remotePort, remoteAddr, ->
          console.log "connecting", remoteAddr
          i = 0

          while i < cachedPieces.length
            piece = cachedPieces[i]
            remote.write piece
            i++
          cachedPieces = null # save memory
          stage = 5
        )
        remote.on "data", (data) ->
          data = encryptor.encrypt data
          if ws.readyState is WebSocket.OPEN
            ws.send data, { binary: true }
            remote.pause() if ws.bufferedAmount > 0
          return

        remote.on "end", ->
          ws.close()
          console.log "remote disconnected"

        remote.on "drain", ->
          ws._socket.resume()

        remote.on "error", (e)->
          ws.terminate()
          console.log "remote: #{e}"

        remote.setTimeout timeout, ->
          console.log "remote timeout"
          remote.destroy()
          ws.close()

        if data.length > headerLength
          # make sure no data is lost
          buf = new Buffer(data.length - headerLength)
          data.copy buf, 0, headerLength
          cachedPieces.push buf
          buf = null
        stage = 4
      catch e
        # may encouter index out of range
        console.warn e
        remote.destroy() if remote
        ws.close()
    else cachedPieces.push data if stage is 4
      # remote server not connected
      # cache received buffers
      # make sure no data is lost

  ws.on "ping", ->
    ws.pong '', null, true

  ws._socket.on "drain", ->
    remote.resume() if stage is 5

  ws.on "close", ->
    console.log "server disconnected"
    console.log "concurrent connections:", wss.clients.length
    remote.destroy() if remote

  ws.on "error", (e) ->
    console.warn "server: #{e}"
    console.log "concurrent connections:", wss.clients.length
    remote.destroy() if remote

server.listen PORT, LOCAL_ADDRESS, ->
  address = server.address()
  console.log "server listening at", address

server.on "error", (e) ->
  console.log "address in use, aborting" if e.code is "EADDRINUSE"
  process.exit 1
