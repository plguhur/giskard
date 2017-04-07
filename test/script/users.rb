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
  class Users
    :attr_accessor users


      # users test users
      def load
          params = {
            "access_token" => "1634660943461178|QmeOgYLBuxJQhoP4Aun3nmUqHmQ"
          }
          res = RestClient.post "https://graph.facebook.com/v2.8/#{FB_APPID}/accounts/test-users",JSON.dump(params)
          puts res
      end


      # create a new user
      def create
          return true
      end
  end  # end class
end # end module
