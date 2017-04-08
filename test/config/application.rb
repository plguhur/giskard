require 'net/http'
require 'uri'

require 'json'
#
# Net::HTTP.post URI('http://www.example.com/api/search'),
#                { "q" => "ruby", "max" => "50" }.to_json,
#                "Content-Type" => "application/json"

# require "net/http"
# require "uri"
#
uri = URI.parse("http://localhost:8080/jaimebienlesbananes/fbmessenger")

http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri)
request.add_field('Content-Type', 'application/json')
request.body = JSON.dump({
        'object' => "page",
        'entry' => [
            {
                "id"=> "280888182276686",
                "time"=> 1491398753467,
                "messaging"=> [
                    {
                        "sender"=> {
                            "id"=> "1259636124081609"
                        },
                        "recipient"=> {
                            "id"=> "280888182276686"
                        },
                        "timestamp"=> 1491398753295,
                        "message"=> {
                            "quick_reply"=> {
                                "payload"=> "Mon email"
                            },
                            "mid"=> "mid.$cAAClhDrchvRhb5BED1bPkr7mJJ3A",
                            "seq"=> 92674,
                            "text"=> "Mon email"
                        },
                        "test" => true
                    }
                ]
            }
        ]
    })
res=http.request(request)
puts res
puts res.body


#
# # # Will print response.body
# # Net::HTTP.get_print(uri)
# #
# # # Full
# # http = Net::HTTP.new(uri.host, uri.port)
# # response = http.request(Net::HTTP::Get.new(uri.request_uri))
#
# # require 'boot'
# #
# # # listen 8080, :backlog => 64
# #
# #
# #
# # http = Net::HTTP.new("localhost", "8080")
# # http.use_ssl = true
# # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
# # request = Net::HTTP::Post.new("/3.0/lists/"+MCLIST+"/interest-categories/"+MCGROUPCAT+"/interests")
# # request.basic_auth 'hello',MCKEY
