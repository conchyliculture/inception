#!/usr/bin/ruby
#encoding: utf-8

require "json"
require "pp"
require "net/https"

class Shortener
    def name ()
        return self.class
    end
    def picky()
        return false
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

    def picky
        return true
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

class PpfrIt < Shortener
    def get_short(url)
        http=Net::HTTP.new("ppfr.it")
        res =http.post("/", URI.encode_www_form({"url"=>url}))
        lolilol=nil
        res.body.each_line do |l|
            if l=~/ <p>URL raccourci: <code><a href="([^"]+)">/
                lolilol = $1
            end
        end
        return lolilol 
    end

end

class AresTl < Shortener
    def get_short(url)
        http=Net::HTTP.new("ares.tl")
        res =http.post("/", URI.encode_www_form({"url"=>url}))
        lolilol=nil
        res.body.each_line do |l|
            if l=~/<h2>Votre lien court<\/h2>\s+<p><input id="copylink" class="texturl" size="32" value="([^"]+)" \/>/
                lolilol = $1
            end
        end
        return lolilol 
    end

end

class PpirAt < Shortener
    def get_short(url)
        http=Net::HTTP.new("ppir.at")
        res =http.post("/", URI.encode_www_form({"url"=>url}))
        lolilol=nil
        res.body.each_line do |l|
            if l=~/<\/h2>\s+<p><input id="copylink" class="text" size="\d+" value="([^"]+)" \/>/
                lolilol = $1
            end
        end
        return lolilol 
    end

end
class NqSt < Shortener
    def get_short(url)
        http=Net::HTTP.new("nq.st")
        res =http.post("/", URI.encode_www_form({"url"=>url}))
        lolilol=nil
        res.body.each_line do |l|
            if l=~/<a href="(http:\/\/nq.st\/[^"]+)">http:\/\/nq.st\/([^"]+)<\/a>/
                lolilol = $1
            end
        end
        return lolilol 
    end
end

class XtwMe < Shortener
    def get_short(url)
        http=Net::HTTP.new("xtw.me")
        res =http.post("/", URI.encode_www_form({"url"=>url,"btn_submit.x"=>"75","btn_submit.y"=>"20"}))
        lolilol=nil
        res.body.each_line do |l|
            if l=~/<input type='text' size='50' value='([^']+)' \/><\/div>/
                lolilol = $1
            end
        end
        return lolilol 
    end
end

class WkTk < Shortener
    def get_short(url)
        http=Net::HTTP.new("wk.tk")
        res =http.post("/create", URI.encode_www_form({"url"=>url}))
        lolilol=JSON.parse(res.body)
        if lolilol["error"]
            return nil
        else
            return lolilol["sURL"]
        end
    end

    def picky
        return true
    end
end
class SkrocPl < Shortener
    def get_short(url)
        http=Net::HTTP.new("home.skroc.pl")
        res =http.post("/create.php", URI.encode_www_form({"url"=>url,"adres"=>"skroc","skroc"=>"/","expired"=>"","password"=>""}))
        lolilol=nil
        res.body.each_line do |l|
            if l=~/<input readonly="readonly" style="width: 250px; text-align:center; font-size: 16px;" name="k1" value="([^"]+)"/
                lolilol=$1
            end
        end
        return lolilol
    end

    def picky
        return true
    end
end
class XurlPl < Shortener
    def get_short(url)
        http=Net::HTTP.new("xurl.pl")
        res =http.post("/index.html", URI.encode_www_form({"longUrl"=>url,"shortUrlDomain"=>"1","submitted"=>"1","customUrl"=>"","shortUrlPassword"=>"","shortUrlExpiryDate"=>"","shortUrlUses"=>"0","shortUrlType"=>"0"}))
        res=http.get(res["location"]) # lolilol!
        res=http.get(res["location"]) # lolilol!   
        lolilol=nil
        res.body.each_line do |l|
            if l=~/<a href="(http:\/\/xurl.pl\/[^"]+)" target="_blank"/
                lolilol=$1
            end
        end
        return lolilol
    end

    def picky
        return true
    end
end


##FAIIIIIL
#class IcbMe < Shortener
#    def get_short(url)
#        http=Net::HTTP.new("icb.me")
#        lol=http.get("/")
#        pute1=""
#        pute2= lol["set-cookie"][/^([^;]+);/,1]
#        puts pute2
#        lol.body.each_line do |l|
#            case l 
#            when /<input type="hidden" name="form_build_id" id="(form-[^"]+)"/
#                pute1=$1
#            end
#        end
#        res =http.post("/", URI.encode_www_form({"long_url"=>url,"op"=>"Shrink it","form_build_id"=>pute1,"form_id"=>"shurly_create_form"}),{"Cookie"=>pute2})
#        lolilol=nil
#        res.body.each_line do |l|
#            puts l
#            if l=~/<a href="(http:\/\/nq.st\/[^"]+)">http:\/\/nq.st\/([^"]+)<\/a>/
#                lolilol = $1
#            end
#        end
#        return lolilol 
#    end
#
#end

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

class VGd < Shortener
    def get_short(url)
        res=Net::HTTP.get(URI.parse("http://v.gd/create.php?format=simple&url=#{url}"))
        return res
    end
end

class UrlzFr < Shortener
    def get_short(url)
        res=Net::HTTP.get(URI.parse("http://urlz.fr/api_new.php?url=#{url}"))
        return res
    end
end

class SyPe < Shortener
    def get_short(url)
        res=Net::HTTP.get(URI.parse("http://sy.pe/save_n_check_url.php?url=#{url}"))
        return res[/value='([^']+)'/,1]
    end
end

class GotPl < Shortener
    def get_short(url)
        res=Net::HTTP.get(URI.parse("http://got.pl/api?x=#{url}&domain=on"))
        return JSON.parse(res[3..-1])["content"]
    end
end

class U42Pl < Shortener
    def get_short(url)
        res=Net::HTTP.get(URI.parse("http://u.42.pl/index.php?descr=&url=#{url}"))
        puts res
        return res[/<a href="(http:\/\/u.42.pl\/[^"]+)"/,1]
    end
end

class XlsCz < Shortener
    def get_short(url)
        res=Net::HTTP.get(URI.parse("http://xsl.cz/index.php?alias=&url=#{url}"))
        res.each_line do |l|
            if l=~/<p>Short URL: <strong><a href="([^"]+)"/
                return $1
            end
        end
        return nil
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
                puts "Error With #{shortener.name} (asked to shorten #{prev})"
                res=prev
            end
            puts "#{res} =>#{prev}" 
        end
    end
end

i=Inception.new()

#i.add_shortener(GotPl.new())
#i.inception('http://www.free.fr/lol')
#exit

i.add_shortener(
                XlsCz.new(),
                U42Pl.new(),
                XurlPl.new(),
                AresTl.new(),
                IsGd.new(),
                CpcCx.new(),
                GooGL.new(),
                TwtFi.new(),
                NqSt.new(),
                UrlzFr.new(),
                JoiNu.new(),
                PpirAt.new(),
                XtwMe.new(),
                AresTl.new,
                VGd.new(),
                PpfrIt.new(),
                SkrocPl.new(),
                GotPl.new(),
                TinyURL.new(),
                VaMu.new(),
#                DurlMe.new(),
               )
i.inception("http://free.fr")
