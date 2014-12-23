module Excon
  class Connection
     def error_call(datum)
      if datum[:error]
        message = datum[:response]
        
        unless message.nil? or message.length==0
            raise(datum[:error])
          else
            raise(datum[:error], message)
        end
      end
    end
  end
end