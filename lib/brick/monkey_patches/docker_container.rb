require 'date'

class Docker::Container
  
  def self.search_by_name(name_filter, conn, query={"all"=>true})
    result=[]
    hashes = Docker::Util.parse_json(conn.get('/containers/json', query)) || []
    list=hashes.map { |hash| Docker::Container.get(hash["Id"]) }
    
    list = list.select{|e| e.info["Name"].include? name_filter}
    
    result=list.sort_by{|e| -Date.parse(e.info["Created"]).to_time.to_i}
    
    return result
  end
  
  def is_running?
   running= Docker::Container.get(id).info["State"]["Running"] 
  end
  
  # Check if an image exists.
    def self.exist?(id, opts = {}, conn = Docker.connection)
      get(id, opts, conn)
      true
    rescue Docker::Error::NotFoundError
      false
    end
end