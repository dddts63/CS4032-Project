class PeerSearchSimplified
  # To change this template use File | Settings | File Templates.
  # CS4032 project
  # Stephen Dodd
  # 08363030

  #initial requires
  require 'socket'
  require 'JSON'

  @host = 'localhost'		# Initialise hostname and port
  @port = 2000

  #function to initialise a single node
 def init (s)

 nodeListen(s)
 storagearray = Array.new()
  #@pastry_Table = CreateRoutingTable
 end
   

  #begins the listen thread that processes any incoming messages
  def nodeListen(socket)
    t1 = Thread.new {
      puts "thread active"
      while(true)

   mesg,sender = socket.recvmsg(65536)

   p socket.recvfrom(16)
   ans = socket.recvfrom(16)
   message = JSON.parse(mesg)
   # process incoming messages
   if message["type"] = "JOINING_NETWORK_SIMPLIFIED"
     #process join message

   end


   if message["type"] = "JOINING_NETWORK_RELAY_SIMPLIFIED"
     #process join relay message

   end

   if message["type"] = "Leaving_Network"
     #process leave message

   end

   if message["type"] = "Search"
     #process search message


     word =  message["word_id"]
     target_id = message["target_id"]
     sender_id = message["sender_id"]

     if hashID(word) == @node_id

       data = getdata()
       msg = SearchResponseMSG(word,sender_id,@node_id,data)
       sendmsg(msg)

     else

       newtarget_id = getfromRoutingTable(target_id,@node_id, @pastry_Table)
       msg = SearchMSG(word,newtarget_id,@node_id)
       sendmsg(msg)
     end
   end

   if message["type"] = "Index"
     #process index message
     keyword =  message["keyword"]
     data = message["link"]
     sender_id = message["sender_id"]

     if message["target_id"] = @node_id



      indexdata(keyword,data)
      msg = ACK_INDEXMSG(target_id,keyword)
      sendmsg(msg)

   else
     target_id = message["node_id"]
     newtarget_id = getfromRoutingTable(target_id,@node_id, @pastry_Table)
     msg = INDEXMSG(target_id,sender_id,keyword,data)
     sendmsg(msg)
   end
     starttimeout()
   end

   if message["type"] = "Search_Response"
     #process  search response message
     word =  message["word_id"]
     response =  message["response"]
     #output results to console
     puts response

   end

   if message["type"] = "PING"
     #process ping message
      if message["target_id"] == @node_id

     target_id = message["sender_id"]
     msg = ACKMSG(target_id,@ip_address)
     sendmsg(msg)
      else
      target_id = message["target_id"]
      newtarget_id = getfromRoutingTable(target_id,@node_id, @pastry_Table)
      msg = PINGMSG(newtarget_id,@node_id,@ip_address)
      sendmsg(msg)
      end

   end

   if message["type"] = "ACK"
       #process ack message
     if message["target_id"] == @node_id

    timeroff()
     else
       target_id = message["target_id"]
       newtarget_id = getfromRoutingTable(target_id,@node_id, @pastry_Table)
       msg = ACKMSG(newtarget_id,@ip_address)
       sendmsg(msg)
     end
   end

   if message["type"] = "ACK_INDEX"
     #process ack index message
     if message["target_id"] == @node_id

       timeroff()
     else
       target_id = message["target_id"]
       keyword = message["keyword"]
       newtarget_id = getfromRoutingTable(target_id,@node_id, @pastry_Table)
       msg = ACK_INDEXMSGMSG(newtarget_id,keyword)
       sendmsg(msg)
     end
   end

    # debug output sent to console
    puts "received"
    puts ans


      end
    }
    sleep(1)
    puts "not reached"
  end

  def starttimeout
    #start a timer for 30 seconds to

    #if timer expires then send ping and restart timer

    #if timer expires again remove node from routing table
  end

  def stoptimeout
      # end 30 second timer as ack was received

  end

  #function sends out a join message to the network
  def joinNetwork(ipaddr,keyword,gatewayword)

    @node_id = hashID(keyword)
    target_id = hashID(gatewayword)
    msg = joinNetworkMSG(ipaddr,@node_id,target_id)

    sendmsg(msg)


  end

  def sendmsg(msg)

    target_id = message["target_id"]
    s.bind(target_id, @port)
    s.send(msg)

  end

    #function adds a node to the routing table if there is a node in this nodes psotion on the table then the precious node is deleted as only the most actively recent nodes are stored
   def AddtoRoutingTable(node,inputnode_id,homenode_id, pastry_Table)
        unique_ID = hashID(node)

        inputnode_id_temp = inputnode_id.to_s.split('')         #Separates the node id into its separate digits
        homenode_id_temp = homenode_id.to_s.split('')      #Separates the target id into its separate digits
        c= 0
        target_id_temp.each do |i|
          if inputnode_id_temp[c] != homenode_id_temp[c]
            row = c
            col = target_id_temp[c]
          end
        end

        pastry_Table_key = "#{row}#{col}"

     if  pastry_Table.has_key?(pastry_Table_key)

       pastry_Table.delete(pastry_Table_key)

     end

       pastry_Table[pastry_Table_key] = node_ID

   end

  def initRoutingTable(init_nodes,init_node_ids,homenode_id) # function initalises the pastry table by taking in a start set of nodes

    pastry_Table = CreateRoutingTable()
      for i in 0 .. init_nodes.length
        AddtoRoutingTable(init_nodes[i],init_node_ids[i],homenode_id,pastry_table)

      end

  end

   def CreateRoutingTable

        pastry_Table = Hash[]
        return pastry_Table
   end

  def getfromRoutingTable(node,homenode_id, pastry_Table)
  # function returns the closest node id from a input node id on the routing table

    inputnode_id_temp = node.to_s.split('')         #Separates the node id into its separate digits
    homenode_id_temp = homenode_id.to_s.split('')      #Separates the target id into its separate digits
    c= 0
    target_id_temp.each do |i|
      if inputnode_id_temp[c] != homenode_id_temp[c]
        row = c
        col = target_id_temp[c]
      end
    end

    pastry_Table_key = "#{row}#{col}"

   return new_target_node =  pastry_Table[pastry_Table_key]

  end

  def removefromRoutngTable(node,homenode_id)    # function to remove a node id froma nodes routing table

    inputnode_id_temp = node.to_s.split('')         #Separates the node id into its separate digits
    homenode_id_temp = homenode_id.to_s.split('')      #Separates the target id into its separate digits
    c= 0
    target_id_temp.each do |i|
      if inputnode_id_temp[c] != homenode_id_temp[c]
        row = c
        col = target_id_temp[c]
      end
    end

    pastry_Table_key = "#{row}#{col}"
    @pastry_Table.delete(pastry_Table_key)


  end

  def hashID(keyword) # function to return the hash of a keyword, hash is a nodes ID
    hashno = 0

    for i in 0..keyword.length


      hashno = hashno*31 +  keyword.ord
    end

    hashno.abs

    return hashno
  end

  #function takes in keyword and creates + sends search message across network
   def search(keyword)

    targetnode_id = hashID(keyword)#get target node id from hash of keyword

    searchmsg = Search(keyword,targetnode_id,homenode_id)

    Routemsg(searchmsg)

   end

  #function that takes in data to be indexed, then creates and sends an index messsage to the target node
  def indexdata(keyword,data)

    target_id = hashID(keyword)  #hash of keyword is the target id
    socket = getsocket()  # gets socket
    port, sender_id = Socket.unpack_sockaddr_in(socket.getpeername)
    indexmsg = INDEX(target_id,sender_id,keyword,data)#create index message

    sendmessage(indexmessage)



  end

  #add a url to the nodes storeage array, array stores all URLS for the Word associated with a node
  def storedata(keyword,data,storagearray)

      storagearray = [data]


  end

  #-------------------------------------------------------------------------------------------------------------------
  # get message functions
  #each function defines a message type and returns a JSON forateed message
  #-------------------------------------------------------------------------------------------------------------------

  def joinNetworkMSG(addrIP,jmessage,routeto)
    hjoin = Hash[]

    hjoin["type"] = "JOINING_NETWORK_SIMPLIFIED"
    hjoin["node_id"] = jmessage
    hjoin["target_id"] =  routeto
    hjoin["ip_address"] = addrIP

    return joinmessage = JSON.generate(hjoin)

  end

  def joinNetworkRelayMSG(node_id,target_id,gateway_id)
    hjoinrealy = Hash[]

    hjoin["type"] = "JOINING_NETWORK_RELAY_SIMPLIFIED"
    hjoinrelay["node_id"] = node_id
    hjoinrelay["target_id"] =  target_id
    hjoinrelay["gateway_id"] = gateway_id

    return joinrelaymessage = JSON.generate(hjoinrelay)

  end

  def LeavingNetworkMSG(node_id)
    hleaving = Hash[]

    hleaving["type"] = "Leaving_Network"
    hleaving["node_id"] = node_id

    return hleavingmessage = JSON.generate(hleaving)

  end

  def SearchMSG(word,target_id,sender_id)
    hsearch = Hash[]

    hsearch["type"] = "Search"
    hsearch["word_id"] = word
    hsearch["target_id"] = target_id
    hsearch["sender_id"] = sender_id

    return hsearchmessage = JSON.generate(hsearch)

  end

  def INDEXMSG(target_id,sender_id,keyword,link)
    hindex = Hash[]

    hindex["type"] = "Index"

    hindex["node_id"] = target_id
    hindex["sender_id"] = sender_id
    hindex["keyword"]  = keyword
    hindex["link"]  = link

    return hindexmessage = JSON.generate(hindex)

  end

  def SearchResponseMSG(word,node_id,sender_id,response)
    hsearchResponse = Hash[]

    hsearchResponse["type"] = "SearchResponse"
    hsearchResponse["word_id"] = word
    hsearchResponse["node_id"] = node_id
    hsearchResponse["sender_id"] = sender_id
    hsearchResponse["response"]  = response

    return hsearchResponsemessage = JSON.generate(hsearchResponse)

  end

  def PINGMSG(target_id,sender_id,ip_address)
    hping = Hash[]

    hping["type"] = "PING"
    hping["target_id"] = target_id
    hping["sender_id"] = sender_id
    hping["ip_address"] = ip_address

    return hpingmessage = JSON.generate(hping)

  end

  def ACKMSG(node_id,ip_address)
    hack = Hash[]

    hack["type"] = "ACK"
    hack["node_id"] = node_id
    hack["ip_address"] = ip_address

    return hackmessage = JSON.generate(hack)

  end

  def ACK_INDEXMSG(target_id,keyword)
    hack = Hash[]

    hack["type"] = "ACK_INDEX"
    hack["node_id"] = target_id
    hack["keyword"] = keyword

    return hackmessage = JSON.generate(hack)

  end


end