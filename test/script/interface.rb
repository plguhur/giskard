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
  class Interface
    attr_reader :output
    attr_reader :input



    def ask
      print "> "
      return STDIN.gets
    end

    def introduction
      puts <<-eos
Welcome to Giskard Simulator.
To exit simply crtl-C.
      eos
    end

    def initialize
      introduction
      while true
          looping
      end
    end

    def looping
        puts receive
        send(ask)
    end

    def send(message)
        uri = URI.parse("http://localhost:8080/jaimebienlesbananes/fbmessenger")

        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri)
        request.add_field('Content-Type', 'application/json')

    end


    end  # end class

end # end module
