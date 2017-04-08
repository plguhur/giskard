require './cmd/user'
require './cmd/interface'
require './config/keys.local'
require 'uri'
require 'net/http'
require 'json'
require 'open-uri'
require 'socket'


### TESTING USER CREATION


user = Test::User.new
puts "Creating a new test user"
# user.create
user.id = 111933986021812
puts "Id: #{user.id}"
puts "Reading informations about the user..."
u = user.read
if u.id.to_i == user.id and u.last_name == user.last_name and u.first_name == user.first_name then
puts "Looks great!"
else
    puts u
    puts user.id
    puts user.last_name
    puts user.first_name
    raise "Error when reading informations about the test user"
end





commands = ["home", "btn_mail", "ex_mail"]
commands.each do |command|
    begin
        res = Test::Interface::sendCommand(command, user)
        res = res[1..-2]
        puts "Received: #{res}"
        if not Test::Interface::correctAnswer?(command, user, res) then
            answer = Test::Interface::answer(command)
            raise "Error: we did not receive the correct answer for #{command} (correct answer: #{answer})"
        end
    rescue
        puts "Something went wrong..."
    end
end
