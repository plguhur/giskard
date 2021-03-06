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
  class User

        attr_accessor :id
        attr_accessor :email
        attr_accessor :id_msg
        attr_accessor :seq
        attr_accessor :last_name
        attr_accessor :first_name
        attr_accessor :retry

        def initialize
            @id = 0
            @email = ""
            @id_msg = 1
            @seq = 1
            @first_name="Newname"
            @last_name="Newname"
            @retry = false
        end


        # users test users
        def create
            params = {
            "access_token" => "#{FB_APPTOKEN}",
            "installed" => true,
            "owner_access_token" => "#{FB_APPID}",
            "name"=>"Newname"
            }

            uri = URI.encode("https://graph.facebook.com/v2.8/#{FB_APPID}/accounts/test-users")
            uri = URI.parse(uri)

            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            request = Net::HTTP::Post.new(uri)
            request.add_field('Content-Type', 'application/json')
            request.body = JSON.dump(params)
            res=http.request(request)
            rep = JSON.parse(res.body)
            @id = rep['id']
            @email = rep['email']

        end

        # read informations about the test user
        def read
            uri = URI.encode("https://graph.facebook.com/v2.8/#{@id}?fields=first_name,last_name&access_token=#{FB_APPTOKEN}")
            res         = URI.parse(uri).read
            u           = JSON.parse(res)
            u           = JSON.parse(JSON.dump(u), object_class: OpenStruct)
            return u
        end

        def delete
            uri = URI.encode("https://graph.facebook.com/v2.8/#{@id}?access_token=#{FB_APPTOKEN}")
            uri = URI.parse(uri)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            request = Net::HTTP::Delete.new(uri)
            response = http.request(request)
            return response
        end

        def test(logger)
            u = read
            if u.id.to_i == @id.to_i and u.last_name == @last_name and u.first_name == @first_name then
                logger.debug "Looks great!"
            else
                logger.error "Error users are different"
                logger.error u
                logger.error user.id
                logger.error user.last_name
                logger.error user.first_name
                raise "Error when reading informations about the test user"
            end
        end

  end  # end class
end # end module
