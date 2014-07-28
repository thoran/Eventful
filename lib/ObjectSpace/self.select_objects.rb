# ObjectSpace/self.select_objects
# ObjectSpace.select_objects

# 20111117
# 0.0.1

module ObjectSpace
  
  def self.select_objects(klass = Object, &block)
    selected_objects = []
    each_object(klass){|o| selected_objects << o if block.call(o)}
    selected_objects
  end
  
end
