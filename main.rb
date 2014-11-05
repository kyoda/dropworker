require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'psych'
require 'pdf/reader'
require './conf.rb'
require './sql.rb'
require './mail.rb'


### DATA INIT
data = ID.getInitData()

def mainProcess(data, time, code, name, pdf_url, post_day)

  io = open(pdf_url, "rb")
  reader = PDF::Reader.new(io)
  pdf = ""

  begin

    reader.pages.each do |page|
      pdf = page.text
    end

  rescue
    pdf = "pdf error\n"
    p "pdf error"
  end

  #db
  Company.create(time: time, code: code, name: name, url: pdf_url, data: pdf, day: post_day)

  #mail
  m = PostMail.new(data)
  m.sendMail(name, code, pdf)


end




### URL ANALYZE
charset = nil
html = open(data['url']) do |f|
  charset = f.charset 
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)


# frame
frame_url = File.dirname(data['url']) + "/" + doc.css('frame')[1]['src']
#frame_url = data['pre_test_url'] + "20141029" + ".html"

post_day = File.basename(frame_url).split(".")[0].split("_")[3].to_date.to_s

html = open(frame_url) do |f|
  charset = f.charset 
  f.read
end


### HTML ANALYZE
doc = Nokogiri::HTML.parse(html, nil, charset)
doc.xpath('//table/tbody/tr').each do |l|

  if l.css('td')[3].content.include?(data['search_word'][0]) then

    time = l.css('td')[0].content.strip
    code = l.css('td')[1].content.strip
    name = l.css('td')[2].content.strip
    pdf_url = data['pre_url'] + l.css('td a').attribute('href').value

    p time + ": " + name + ": " + l.css('td')[3].content.strip
    com = Company.where(day: post_day)


    if com.any?{|a| a.name === name} then
      p "Already there"
    else
      p "insert..."
      mainProcess(data, time, code, name, pdf_url, post_day)
      p "finish"
    end


  else
    #p "Nothing..."
  end

end

