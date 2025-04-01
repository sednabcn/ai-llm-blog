# Monkey patch for Ruby >= 3.0 where `tainted?` is removed
unless String.method_defined?(:tainted?)
  class String
    def tainted?
      false
    end
    
    def taint
      self
    end
    
    def untaint
      self
    end
  end
end
