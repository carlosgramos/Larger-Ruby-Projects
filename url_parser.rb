# Begin class
class UrlParser

	#These are the instance attribute reader_writer  methods:
	attr_writer :url
	attr_reader :scheme, :domain, :port, :path, :query_string, :fragment_id

	#This is the beginning Instance Methods:

	#Initialize - Set the initial atributes of a .new UrlParser type object
	def initialize(url)
		@url = url
		@scheme = extract_scheme(@url)
		@domain = extract_domain(@after_scheme)
		@port = extract_port(@after_domain)
		#Check if @port is nil, and then mutate it depending on whether the
		#scheme is http or https
		assign_port_number(@scheme, @port)
		@path = extract_path(@after_port)
		@query_string = extract_query_string(@after_path)
		@fragment_id = extract_fragment_id(@after_query)
	end

	#In this step we extract the url's scheme. It receives a url from
	#the extract_scheme method call in initialize
	def extract_scheme(url)
		scheme_split = url.split("://")
		#puts "extract_scheme #{scheme_split}"
		scheme, @after_scheme = scheme_split[0], scheme_split[1]
		return scheme
	end

	#After extracting the scheme, we then extract the domain. It' tricky, because
	#if there is a port we .split at ":", else we .split at "/".
	def extract_domain(after_scheme)
		if after_scheme.include?(":") #port included? - Split at the ":"
			domain_split = after_scheme.split(":")
			#puts "extract_domain using the ':' = #{domain_split}"
			domain, @after_domain = domain_split[0], domain_split[1]
			return domain
		else #port not included? - Split at the "/"
			domain_split = after_scheme.split("/")
			#puts "extract_domain using the '/' =  #{domain_split}"
			domain, @after_domain = domain_split[0], domain_split[1]
			return domain
		end
	end

	#Extract_port will check if the incoming string (after_domain) includes a "/"
	# if it means that thre is a port and needs to be split at the "/",
	#elsif there is no "/", it means there is no port number and @port must
	#be set to nil.
	def extract_port(after_domain)
		if after_domain.include?("/")
			port_split = after_domain.split("/")
			#puts "extract_port #{port_split}"
			port, @after_port = port_split[0], port_split[1]
			return port
		else
			@after_port = after_domain
			#puts "@after_port gets assigned => '#{@after_port}'"
			#puts "No port number, set @port to nil"
			return nil
		end
	end

	#Once extract_port has done it's thing, if the value of @port is nil, then
	#assign_port_number will assign port 80 for http, or port 443 for https
	def assign_port_number(scheme, port) #We already know that @port == nil when we call this method
		if scheme == "http" && port == nil
			@port = "80" #(then assign "80" to @port)
			#puts "This is @port being assigned '80' => #{@port}"
		elsif scheme == "https" #(my scheme is https, assign "443" to @port)
			@port = "443"
			#puts "This is @port being assigned '443' => #{@port}"
		end
	end

	#Extract path based on the presence or abscense of a "?" in the incoming string
	#after_port
	def extract_path(after_port)
		if not after_port.include? ("?")
			puts "after_port with no change: '#{after_port}'"
			return after_port
		elsif after_port.index("?") == 0
			@after_path = after_port.delete("?")
			puts "@after_path with ? stripped: '#{@after_path}'"
			return nil
		elsif after_port.include?("?")
			path_split = after_port.split("?")
			puts "path_split: #{path_split}"
			path, @after_path = path_split[0], path_split[1]
			return path
		end
	end


	#After extracting the path
	def extract_query_string(after_path)
		#puts "This is after_path as it enters the extract_query method => '#{after_path}'"
		if after_path == nil
			return nil
		else #split at the "#"
			query_split = after_path.split("#")
			#puts "extract_query_string using the '#' = #{query_split}"
			query, @after_query = query_split[0], query_split[1]
			#puts "This is query after query_split => '#{query}'"
			#At this point query must be turned into a hash and reasigned
			query = Hash[*query.split(/=|&/)] #=> {"a"=>"b", "c"=>"d"}
			#puts "This is query after query to hash => '#{query}'"
			return query
		 end
	end

	#Set @fragment_id to either nil or the url's fragment id
	def extract_fragment_id(after_query)
		if after_query == nil
			return nil
		else
			fragment_id = after_query
			#puts "This is fragment_id being returned => '#{fragment_id}'"
  		return fragment_id
  	end
	end

end #end for the class
