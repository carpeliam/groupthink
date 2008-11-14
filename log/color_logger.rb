module Merb
  class Logger
    # 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white # 30 = black 31 = red 32 = green 33 = yellow blue 34 = 35 = magenta 36 = cyan 37 = white
    Colors = Mash.new({
      :fatal => 31,
      :error => 31,
      :warn => 33,
      :info => 38,
      :debug => 36
    })
    
    Levels.each_pair do |name, number|
      class_eval <<-LEVELMETHODS, __FILE__, __LINE__
def #{name}(message = nil)
self << "[1;#{Colors[name]}m%s[0m" % message if #{number} >= level
self
end
def #{name}!(message = nil)
self << "[1;#{Colors[name]}m%s[0m" % message if #{number} >= level
flush if #{number} >= level
self
end
LEVELMETHODS
    end
    
    def my_debug(message = nil)
      self << "[1;35m%s[0m" % message
      self
    end
  end
end
