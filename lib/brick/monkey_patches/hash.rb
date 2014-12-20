require 'ostruct'

class Hash
   def to_ostruct
    ostruct = inject({}) {|result, (key, value)|
      if value.is_a?(Array)
        value = value.map {|v| v.respond_to?(:to_ostruct) ? v.to_ostruct : v }
      end

      result[key] = value.respond_to?(:to_ostruct) ? value.to_ostruct : value
      result
    }
    
    OpenStruct.new(ostruct)
  end
end