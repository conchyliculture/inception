#!/usr/bin/ruby
#encoding: utf-8

require "json"
require "pp"
require "net/https"

class Shortener
    def name ()
        return self.class
    end
end

######### POST

class GooGL < Shortener
    def get_short(url)
        http=Net::HTTP.new("www.googleapis.com",443)
        http.use_ssl=true
        res = JSON.parse(http.post("/urlshortener/v1/url", JSON.dump({"longUrl" => url}),{"Content-Type"=>"application/json"}).body)
        if res["error"]
            return nil
        else
            return res["id"]
        end
    end

end
class TwtFi < Shortener

    def get_short(url)
        http=Net::HTTP.new("twt.fi")
        res =http.post("/", URI.encode_www_form({"url"=>url}))
        lolilol=nil
        res.body.each_line do |l|
            if l=~/<h1>Shortened (.+)<\/h1>/
                lolilol = $1
            end
        end
        return lolilol 
    end

end
class CpcCx < Shortener
    def get_short(url)
        http=Net::HTTP.new("cpc.cx")
        res =http.post("/", URI.encode_www_form({"long_link"=>url}))
        lolilol=nil
        res.body.each_line do |l|
            if l=~/<input  class="inputext" value='(http:\/\/cpc.cx\/[^']+)'/
                lolilol = $1
            end
        end
        return lolilol 
    end

end

######### GET
class SCoop < Shortener
    def get_short(url)
        res= Net::HTTP.get(URI.parse("http://s.coop/devapi.php?action=shorturl&url=#{url}&format=JSON"))
        return res
    end

end

class VaMu < Shortener
    def get_short(url)
        res= Net::HTTP.get(URI.parse("http://va.mu/api/create?url=#{url}&canonical=1&type=json")).gsub('"','')
        return res

    end
end

class ToLy < Shortener
    def get_short(url)
        res= Net::HTTP.get(URI.parse("http://to.ly/api.php?&longurl=#{url}"))
        return res
    end
end

class TinyURL < Shortener 
    
    def get_short(url)
        res=Net::HTTP.get(URI.parse("http://tinyurl.com/api-create.php?url=#{url}"))
        if res=="ERROR"
            return nil
        else
            return res
        end
    end
end

class DurlMe < Shortener
    def get_short(url)
        res= JSON.parse(Net::HTTP.get(URI.parse("http://durl.me/api/Create.do?type=json&longurl="+url)))
        if res["status"] == "ok"
            return res["shortUrl"]
        else
            return nil
        end
    end
end

class JoiNu < Shortener
    def get_short(url)
        res=JSON.parse(Net::HTTP.get(URI.parse("http://joi.nu/api.phtml?url=#{url}")))
        if res["result"]=="ok"
            return res["short_url"]
        else
            return nil
        end
    end
end

class IsGd < Shortener
    def get_short(url)
        res=JSON.parse(Net::HTTP.get(URI.parse("http://is.gd/create.php?format=json&url=#{url}")))
        return res["shorturl"]
    end
end

class Inception
    def initialize()
        @slist=[]
    end
    def add_shortener(*s)
        @slist.concat( s)
    end
    def inception(url)
        res=url
        @slist.each do |shortener|
            prev=res
            res=shortener.get_short(prev) 
            unless res
                puts "#{shortener.name} REFUSED TO CONVERT #{prev}"
                res=prev
            end
            puts "#{res} =>#{prev}" 
        end
    end
end

i=Inception.new()


i.add_shortener(
                CpcCx.new(),
                IsGd.new(),
                CpcCx.new(),
                GooGL.new(),
                CpcCx.new(),
                TwtFi.new(),
                CpcCx.new(),
                JoiNu.new(),
                CpcCx.new(),
                TinyURL.new(),
                CpcCx.new(),
                VaMu.new(),
                CpcCx.new(),
#                DurlMe.new(),
               )
i.inception("http://free.fr")
