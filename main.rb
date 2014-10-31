require 'rubygems'
require './conf.rb'
require './sql.rb'
require './mail.rb'


### DATA INIT

data = ID.getInitData()




def mainProcess(data, time, code, name, pdf_url)

  io = open(pdf_url, "rb")
  reader = PDF::Reader.new(io)

  pdf = ""
  reader.pages.each do |page|
    pdf = page.text
  end


  Company.create(time: time, code: code, name: name, url: pdf_url, data: pdf)

  m = PostMail.new(data)
  m.sendMail()


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
    com = Company.where(day: Date::today.to_s)

    if com.empty? then

      p "insert..."
      mainProcess(data, time, code, name, pdf_url)
      p "finish"

    else

      com.each do |db_data| 

        if ! db_data['name'].include?(name) then

          p "insert..."
          mainProcess(data, time, code, name, pdf_url)
          p "finish"

        else 
          p "Already there"
        end

      end

    end

  else
    #p "Nothing..."
  end

end

