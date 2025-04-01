# Monkey patch for Ruby >= 3.0 where `tainted?` is removed

if RUBY_VERSION >= '3.2'
  class Object
    def tainted?
      false
    end
  end
end
