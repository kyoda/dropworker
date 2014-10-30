require 'yaml'

class InitData


  def initialize()
    @@data = YAML.load_file("./conf.yaml")
  end

  def getInitData

    return @@data

  end


end

