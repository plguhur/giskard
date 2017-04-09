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
    attr_reader :id_msg
    attr_accessor :order
    attr_accessor :commands

    def initialize
        @order = []
        @commands = {}
    end

    def send_fb(message)
        uri = URI.parse("http://localhost:#{PORT_NUMBER}/#{FB_WEBHOOK_PREFIX}/fbmessenger")

        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri)
        request.add_field('Content-Type', 'application/json')
        request.body = JSON.dump(message)
        res=http.request(request)
        return res.body
    end

    # send a defined command from json
    def sendCommand(cmd_name, user)
        cmd = @commands[cmd_name]
        user.id_msg += 1
        user.seq += 1
        msg = {
            "id"=> user.id_msg,
            "time"=> Time.now()+ 10,
            "messaging"=> [
                {
                    "sender"=> {
                        "id"=> user.id
                    },
                    "recipient"=> {
                        "id"=> "280888182276686"
                    },
                    "timestamp"=> Time.now(),
                    "message"=> {
                        "text" => cmd[0],
                        "mid"=> "mid.$cAAClhDrchvRhb5BED1bPkr7mJJ3A",
                        "seq"=> user.seq,

                    },
                    "test" => true
                }
            ]
        }
        content = {
                'object' => "page",
                'entry' => [ msg ]
            }
        return send_fb(content)
    end


    def correctAnswer?(cmd_name, user, res)
        cmd = @commands[cmd_name]
        if res.to_s == cmd[1] then
            return true
        end
        return false
    end

    def answer(cmd_name)
        return @commands[cmd_name][1]
    end

    def load filename
        file = File.read(filename)
        data_hash = JSON.parse(file)
        @order = data_hash['order']
        @commands = data_hash['commands']
    end

    def save filename
        open(filename, 'w') { |f|
          f.puts JSON::dump({'order' => @order, 'commands' => @commands})
        }
    end

    end  # end class
end # end module
