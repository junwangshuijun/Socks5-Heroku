{spawn} = require 'child_process'

build = (callback) ->
  os = require 'os'
  if os.platform() == 'win32'
    coffeeCmd = 'coffee.cmd'
  else
    coffeeCmd = 'coffee'
  coffee = spawn coffeeCmd, ['-c', '-o', '.', 'src']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    console.log data.toString()
  coffee.on 'exit', (code) ->
    console.log 'build completed'
    callback?() if code is 0
    process.exit code

test = (callback) ->
  os = require 'os'
  coffee = spawn 'node', ['test.js']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    console.log data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0
    process.exit code

task 'build', 'Build ./ from src/', ->
  build()

task 'test', 'Run unit test', ->
  test()
