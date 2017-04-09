require './cmd/user'
require './cmd/interface'
require './cmd/repl'
require './config/keys.local'
require 'uri'
require 'net/http'
require 'json'
require 'open-uri'
require 'logger'


# this file is an REPL (read-eval-print loop) used to compute a test file for a finite state machine. Every instruction is stored and can be replayed to test the bot.


repl = Test::REPL.new
repl.introduction
repl.repl
