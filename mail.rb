require "mail"
require "./conf.rb"


class PostMail

  @@data = nil

  def initialize(conf_data)

    @@data = conf_data

  end


  def sendMail(content = nil)

    mail = Mail.new do

    from    @@data['mail']['from']
    to      @@data['mail']['to'][0]
    cc      @@data['mail']['to'][1]
    subject name + "(" + code + ")" + @@data['search_word'][0]
    body    pdf
    charset = "UTF-8"

    end

    mail.delivery_method(:smtp,
        address:        @@data['mail']['host'], 
        port:           25,
        )
    mail.deliver

  end


end
