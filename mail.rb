require "mail"
require "./conf.rb"


class PostMail

  @@data = nil
  @@count = 0
  @@limit = 20

  def initialize(conf_data)

    @@data = conf_data

  end


  def sendMail(name = 'test', code = '0000', pdf = 'test')

    if @@count < @@limit then

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

      @@count += 1

    end

  end


end
