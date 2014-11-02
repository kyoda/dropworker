require 'yaml'

class InitData


  def initialize()
    @@data = YAML.load_file("./conf.yaml")
  end

  def getInitData
    @@data
  end


end

