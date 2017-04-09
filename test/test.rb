require './cmd/user'
require './cmd/interface'
require './config/keys.local'
require 'uri'
require 'net/http'
require 'json'
require 'open-uri'
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
    fsm = Test::Interface.new
    fsm.load "data/finite-state-machine.json"

    fsm.order.each do |command|
        begin
            res = fsm.sendCommand(command, user)
            res = res[1..-2]
            logger.debug "Received: #{res}"
            if not fsm.correctAnswer?(command, user, res) then
                answer = fsm.answer(command)
                raise "Error: we did not receive the correct answer for #{command} (correct answer: #{answer})"
            end
        rescue
            retry if user.retry
            raise "Could not check the command #{command}"
        end
    end


    # delete user
    if  user.delete then
        logger.debug "Correctly deleted the user"
    end
end
