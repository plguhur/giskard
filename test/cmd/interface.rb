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
    attr_reader :id_msg

    @@all_cmds = {
        "home" => [
            "accueil",
            "Que voulez-vous faire ? Utilisez les boutons du menu ci-dessous pour m'indiquer ce que vous souhaitez faire.\\n"
        ],
        "btn_mail" => [
            "Mon email",
            "Quel est votre email ?\\n"
        ],
        "ex_mail" => [
            "hello@world.com",
            "Votre email est hello@world.com !\\nQue voulez-vous faire ? Utilisez les boutons du menu ci-dessous pour m'indiquer ce que vous souhaitez faire.\\n"
        ]
    }
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

    def self.send_fb(message)
        uri = URI.parse("http://localhost:#{PORT_NUMBER}/#{FB_WEBHOOK_PREFIX}/fbmessenger")

        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri)
        request.add_field('Content-Type', 'application/json')
        request.body = JSON.dump(message)
        res=http.request(request)
        return res.body
    end

    # send a defined command from json
    def self.sendCommand(cmd_name, user)
        cmd = @@all_cmds[cmd_name]
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
        puts "Sending: #{content}"
        return send_fb(content)
    end


    def self.correctAnswer?(cmd_name, user, res)
        cmd = @@all_cmds[cmd_name]
        if res.to_s == cmd[1] then
            return true
        end
        return false
    end

    def self.answer(cmd_name)
        return @@all_cmds[cmd_name][1]
    end

    end  # end class
end # end module
