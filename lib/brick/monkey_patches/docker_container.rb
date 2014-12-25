class Docker::Container
  
  def self.search_by_name(name_filter, conn, query={"all"=>true})
    result=[]
    hashes = Docker::Util.parse_json(conn.get('/containers/json', query)) || []
    list=hashes.map { |hash| new(conn, hash) }
    
    list = list.select{|e| names = e.info["Names"];names.select!{|name| name.include? name_filter};names.length>0}
    
    result=list.sort_by{|e| -e.info["Created"]}
    
    return result
  end
end