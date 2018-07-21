require 'open-uri'
require 'nokogiri'
require 'watir'
require 'webdrivers'

url = 'https://www.dilvin.com.tr'
kategori = ".nav.navbar-nav li a" 
urun = ".product .image-hover a"

def crawler(url,kategori_link,urun_link)
    go = Watir::Browser.start url
    go.window.move_to(0, 0)
    go.window.resize_to(1920, 1080)
    kategoriarr = Array.new
    urunler = Array.new
    document = Nokogiri::HTML(go.html)
    #kategori ve alt kategorileri ceker
    navbar = document.css(kategori_link)
    i = 0;
    loop do
        kategoriarr.push(url + navbar[i].attr("href"))
        # kategoriarr.push(navbar[i].attr("href"))
        i += 1
        if i == navbar.length
            break
        end
    end
    kategoriarr = kategoriarr.uniq
    kategoriarr -= %w{url}
    puts kategoriarr
    puts kategoriarr.length.to_s + " tane kategori var"
    j = 0;
    loop do
        begin
            go.goto kategoriarr[j]
            document2 = Nokogiri::HTML(go.html)
            #urunleri ceker
            document2.css(urun_link).each do |item|
                #if item.attr("href").include?("javascript:void(0)") == false || item.attr("href").include?("#") == false

                # domainli
                urunler.push(url + item.attr("href"))

                # domainsiz
                # urunler.push(item.attr("href"))
                #end
            end
            urunler = urunler.uniq
            puts urunler
            puts urunler.length.to_s + " tane urun var"
            urunler.each_with_index do |prod, index|
                # urunleri gezer
                go.goto urunler[index]
                # go.execute_script("window.scrollBy(0,500)")
                sleep(2)
            end
        rescue
        end
        j += 1
        if j == kategoriarr.length
            break
        end
    end
end
crawler url, kategori, urun
