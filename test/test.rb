require './cmd/user'
require './cmd/interface'
require './config/keys.local'
require 'uri'
require 'net/http'
require 'json'
require 'open-uri'
require 'socket'
require 'logger'
require 'workers'

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

Workers.map([1, 2]) do |i|

    logger.info "Worker: #{i}"

    # user creation
    user = Test::User.new
    logger.debug "Creating a new test user"
    user.create
    logger.debug "Id: #{user.id}"
    # uncomment this line to check the test user itself
    # user.test(logger)

    # finite state machine
    commands = ["home", "btn_mail", "ex_mail"]
    commands.each do |command|
        begin
            res = Test::Interface::sendCommand(command, user)
            res = res[1..-2]
            logger.debug "Received: #{res}"
            if not Test::Interface::correctAnswer?(command, user, res) then
                answer = Test::Interface::answer(command)
                raise "Error: we did not receive the correct answer for #{command} (correct answer: #{answer})"
            end
        rescue
            retry if user.retry
            raise "Something went wrong..."
        end
    end


    # delete user
    if  user.delete then
        logger.debug "Correctly deleted the user"
    end

end
