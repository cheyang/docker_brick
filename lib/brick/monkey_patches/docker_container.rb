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
  
end