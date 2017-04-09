# encoding: utf-8

=begin
   Copyright 2016 Telegraph-ai

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
=end


module Test
  class REPL
    attr_reader :user
    attr_reader :fsm
    attr_reader :iterator

    def ask
      print "> "
      return STDIN.gets
    end

    def initialize
        @user = Test::User.new
        @user.create
        @fsm = Test::Interface.new
        @iterator = 0
    end


    def introduction
      puts <<-eos
Welcome to Giskard test module.
In which file do you want to save your test?
      eos
      @filename = ask[0..-2]
    end

    def repl
      puts <<-eos
Let's write some commands and observe how the bot should react.
You can write "#save" to save the conversation, and "#exit" to stop it (only #exit does not save the conversation!). Ctrl+C is not the best option because it does not delete the user.
      eos
      while looping
      end
    end

    def looping
        command = ask[0..-2]
        if command == "#save" then
            @fsm.save @filename
        elsif command == "#exit" then
            @user.delete
            return false
        else
            @iterator += 1
            @fsm.commands[@iterator] = [command, ""]
            reps = @fsm.sendCommand(@iterator, @user)
            puts "< #{reps}"
            @fsm.commands[@iterator] = [command, reps[1..-2]]
            @fsm.order.push(@iterator)
        end
        return true
    end



    end  # end class
end # end module
