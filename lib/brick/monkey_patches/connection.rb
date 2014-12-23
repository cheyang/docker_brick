module Excon
  class Connection
     def error_call(datum)
      if datum[:error]
        message = datum[:response][:body] rescue nil
        
        if !message.nil? and  message.length>0
            raise(datum[:error],message)
          else
            raise(datum[:error])
        end
      end
    end
  end
end