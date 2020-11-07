################################################
# Incomplete list of imports and environment setup
################################################
def module CobbleVision_API do

  environmentType=false
  serverAdress="https://cobblevision.com"

  valid_price_categories=["high, "medium", "low"]
  valid_job_types=["QueuedJob"]

  debugging=false

  if environmentType==false || environmentType==="demo" do
    BaseURL="https://www.cobblevision.com"
  else
    BaseURL=serverAdress + "/api/"
  end

  apiUserName=""
  apiToken=""


################################################
# Handy functions for setting auth and debug
################################################

  # Function allows you to set the Username and Token for CobbleVision
  # @function setApiAuth()
  # @param {String} apiusername
  # @param {String} apitoken
  # @returns {Boolean} Indicating success of setting Api Auth.

  def setApiAuth(apiusername, apitoken)
    apiUserName=apiusername
    apiToken=apitoken
    returnBool=true
  end
  
  # Function allows you to set the debugging variable
  # @function setDebugging()
  # @param {Boolean} debugBool
  # @returns {Boolean} Indicating success of setting Api Auth.

  def setDebugging(debugBool)
     debugging=debugBool
     returnBool=true
  end   

################################################
# Functions for using the CobbleVision API
################################################

  # Return of the following functions is specified within this type description
  # @typedef {Map} Response
  # @property {Number} status_code Returns Status Code of Response
  # @property {String} body returns string of response
  # @property {List} headers Returns Headers of Response

  # This function uploads a media file to CobbleVision. You can find it after login in your media storage. Returns a response object with body, response and headers properties, deducted from npm request module
  # @async
  # @function uploadMediaFile()  
  # @param {String} price_category - Either high, medium, low
  # @param {Boolean} publicBool - Make Media available publicly or not?
  # @param {String} name - Name of Media (Non Unique)
  # @param {List} tags - Tag Names for Media - Array of Strings
  # @param {Binary} file - ImageFile as binary from file.read
  # @returns {Task} Task with the UploadMediaResponse. The body is in JSON format.
  def uploadMediaFile (price_category, publicBool, name, keys, file)
    try do
      uploadMediaTask=Task.async(fn->
        endpoint="media"
        if String.at(BaseURL, String.length(BaseURL)-1]="/" do
          raise "BaseURL for CobbleVision is incorrect. Must end with slash!"
        end
    
        keyArray=["price_category", "publicBool", "name", "tags", "Your Api User Key", "Your API Token"]
        valueArray=[price_category, publicBool, name, tags, apiUserName, apiToken]
        typeArray=["String", "Boolean", "String", "Array", "String", "String"]
    
        try do
          checkTypeOfParameter(valueArray, typeArray)
        rescue=>e
          err_message=String.to_integer(e.toString())
          if is_integer(err_message) do
            raise "The provided data is not valid: ", keyArray[err_message] + "is not of type " + typeArray[err_message]
          else
            raise e.message
          end
        end

        if is_binary(file) do
          raise "The file must be provided as binary"
        end

        if enum.find_index(valid_price_categories, fn x -> x === price) != -1 do
          raise "Your price indicator is not valid!"
        end

        jsonObject = %{"price_category" => price_category,"public" => publicBool,"name" => name,"tags" => tags,"file" => file}
      
        auth = [hackney => [ basic_auth => { apiUserName => apiToken }]]
        headerObject = %{"Content-Type" => "application/json", "Accept" => "application/json"}
      
        HTTPPoison.Response reqResponse = HTTPPoison.post(BaseURL + endpoint, jsonObject, headerObject, auth)
      
        if debugging == true do
         IO.puts "Response from Media Upload: " + reqResponse.body
        end

        response = reqResponse)
      response = uploadMediaTask
    rescue => e
      if debugging == true do
        IO.puts e.message
      end
      raise e.message
    end
  end

  # This function deletes Media from CobbleVision
  # @async
  # @function deleteMediaFile()  
  # @param {List} IDArray Array of ID's as Strings
  # @returns {Task} Task with the DeleteMediaResponse. The body is in JSON format.

  def deleteMediaFile (IDArray)
    try do
      deleteMediaTask = Task.async(fn->
        endpoint = "media"

        if String.at(BaseURL, String.length(BaseURL)-1] = "/" do
          raise "BaseURL for CobbleVision is incorrect. Must end with slash!"
        end

        keyArray = ["IDArray", "Your Api User Key", "Your API Token"]
        valueArray = [IDArray, apiUserName, apiToken]
        typeArray = ["Array", "String", "String"]
    
        try do
          checkTypeOfParameter(valueArray, typeArray)
        rescue => e
          err_message = String.to_integer(e.toString())
          if is_integer(err_message) do
            raise "The provided data is not valid: ", keyArray[err_message] + "is not of type " + typeArray[err_message]
          else
            raise e.message
          end
        end
        
        if !(checkListForInvalidObjectID(IDArray)) do
          raise "You supplied a media ID that is not valid!"
        end
    
        auth = [hackney => [ basic_auth => { apiUserName => apiToken }]]
        headerObject = %{"Content-Type" => "application/json", "Accept" => "application/json"}
    
        HTTPPoison.Response reqResponse = HTTPPoison.delete(BaseURL + endpoint + "&id=" + Poison.encode(IDArray), headerObject, auth)
    
        if debugging == true do
         IO.puts "Response from Delete Media: " + reqResponse.body
        end

        response = reqResponse)
      response = deleteMediaTask
    rescue => e
      if debugging == true do
        IO.puts e.message
      end
      raise e.message
    end
  end
    

  # Launch a calculation with CobbleVision's Web API. Returns a response object with body, response and headers properties, deducted from npm request module;
  # @async
  # @function launchCalculation() 
  # @param {List} algorithms Array of Algorithm Names
  # @param {List} media Array of Media ID's  
  # @param {String} type Type of Job - Currently Always "QueuedJob"
  # @param {String} [notificationURL] Optional - Notify user upon finishing calculation!
  # @returns {Task} Task with the LaunchCalculationResponse. The body is in JSON format.  

  def launchCalculation(algorithms, media, type, notificationURL)
    try do
      launchCalculationTask = Task.async(fn->
        endpoint = "calculation"
    
        if String.at(BaseURL, String.length(BaseURL)-1] = "/" do
          raise "BaseURL for CobbleVision is incorrect. Must end with slash!"
        end

        keyArray = ["algorithms", "media", "type", "notificationURL", "Your Api Username", "Your API Token"]
        valueArray = [algorithms, media, type, notificationURL, apiUserName, apiToken]
        typeArray = ["Array", "Array", "String", "String", "String", "String"]
    
        try do
          checkTypeOfParameter(valueArray, typeArray)
        rescue => e
          err_message = String.to_integer(e.toString())
          if is_integer(err_message) do
            raise "The provided data is not valid: ", keyArray[err_message] + "is not of type " + typeArray[err_message]
          else
            raise e.message
          end
        end
        
        if enum.find_index(valid_job_types, fn x -> x === type) != -1 do
          raise "Your job type is not valid!"
        end

        if !(checkListForInvalidObjectID(media)) do
          raise "You supplied a media ID that is not valid!"
        end
      
        if !(checkListForInvalidObjectID(algorithms)) do
          raise "You supplied an algorithm ID that is not valid!"
        end

        jsonObject = %{"algorithms" => algorithms, "media" => media, "type" => type}
    
        auth = [hackney => [ basic_auth => { apiUserName => apiToken }]]
        headerObject = %{"Content-Type" => "application/json", "Accept" => "application/json"}

        if notificationURL != nil && URI.parse(notificationURL) && URI.parse(notificationURL).scheme != nil && URI.parse(notificationURL).host =~ "." do
          Map.put(jsonObject, "notificationURL", notificationURL)
        end
    
        HTTPPoison.Response reqResponse = HTTPPoison.post(BaseURL + endpoint, jsonObject, headerObject, auth)
    
        if debugging == true do
         IO.puts "Response from  launch Calc: " + reqResponse.body
        end

        response = reqResponse)
      response = launchCalculationTask
    rescue => e
      if debugging == true do
        IO.puts e.message
      end
      raise e.message
    end
  end
    
  # This function waits until the given calculation ID's are ready to be downloaded!
  # @async
  # @function waitForCalculationCompletion() 
  # @param {List} calculationIDArray Array of Calculation ID's
  # @returns {Task} Task with the WaitForCalculationResponse. The body is in JSON format.   

  def waitForCalculationCompletion(calculationIDArray)
    try do
      waitForCalculationTask = Task.async(fn->
        endpoint = "calculation"
    
        if String.at(BaseURL, String.length(BaseURL)-1] = "/" do
          raise "BaseURL for CobbleVision is incorrect. Must end with slash!"
        end

        keyArray = ["calculationIDArray", "Your Api Username", "Your API Token"]
        valueArray = [calculationIDArray, apiUserName, apiToken]
        typeArray = ["Array", "String", "String"]
    
        try do
          checkTypeOfParameter(valueArray, typeArray)
        rescue => e
          err_message = String.to_integer(e.toString())
          if is_integer(err_message) do
            raise "The provided data is not valid: ", keyArray[err_message] + "is not of type " + typeArray[err_message]
          else
            raise e.message
          end
        end
        
        if !(checkListForInvalidObjectID(calculationIDArray)) do
          raise "You supplied a calculation ID which is not valid!"
        end
    
        auth = [hackney => [ basic_auth => { apiUserName => apiToken }]]
        headerObject= %{"Content-Type" => "application/json", "Accept" => "application/json"}
    
        calculationFinishedBool = False
    
        while calculationFinishedBool == false do
          HTTPPoison.Response reqResponse = HTTPPoison.get(BaseURL + endpoint + "&id=" + Poison.encode(calculationIDArray) + "&returnOnlyStatusBool=true", headerObject, auth)
      
          try do
            result = Poison.decode(reqResponse.body[1].data)
            if is_list(result) do
              Enum.each(result, fn(element ->
                if Map.has_key(element, "status") do
                  if element.status === "finished" do
                    calculationFinishedBool = true
                  end
                else
                  calculationFinishedBool = false
                  raise "Interrupt"
                end
              )
            else
              if Map.has_key(result, "error") do
                calculationFinishedBool = True
              end
            end
          rescue => e
            if e.message === "Interrupt" do
              calculationFinishedBool = false
            else
              raise e.message
            end
          end
      
          if calculationFinishedBool == false do
            wait(3000)
          end
        end

        if debugging == true do
          IO.puts "Response from Wait For Calc: " + reqResponse.body
        end

        response = reqResponse)
      response = waitForCalculationTask
    rescue => e
      if debugging == true do
        IO.puts e.message
      end
      raise e.message
    end
  end

  # This function deletes Result Files or calculations in status "waiting" from CobbleVision. You cannot delete finished jobs beyond their result files, as we keep them for billing purposes.
  # @async
  # @function deleteCalculation()
  # @param {List} IDArray Array of ID's as Strings
  # @returns {Task} Task with the DeleteCalculationResponse. The body is in JSON format.
       
  def deleteCalculation(IDArray)   
    try do
      deleteCalculationTask = Task.async(fn->
        endpoint = "calculation"
    
        if String.at(BaseURL, String.length(BaseURL)-1] = "/" do
          raise "BaseURL for CobbleVision is incorrect. Must end with slash!"
        end

        keyArray = ["IDArray", "Your Api User Key", "Your API Token"]
        valueArray = [IDArray, apiUserName, apiToken]
        typeArray = ["Array", "String", "String"]
    
        try do
          checkTypeOfParameter(valueArray, typeArray)
        rescue => e
          err_message = String.to_integer(e.toString())
          if is_integer(err_message) do
            raise "The provided data is not valid: ", keyArray[err_message] + "is not of type " + typeArray[err_message]
          else
            raise e.message
          end
        end

        if !(checkListForInvalidObjectID(IDArray)) do
          raise "You supplied a calc ID that is not valid!"
        end

        auth = [hackney => [ basic_auth => { apiUserName => apiToken }]]
        headerObject = %{"Content-Type" => "application/json", "Accept" => "application/json"}
    
        HTTPPoison.Response reqResponse = HTTPPoison.delete(BaseURL + endpoint + "&id=" + Poison.encode(IDArray), headerObject, auth)
      
        if debugging == true do
          IO.puts "Response from Delete Calc: " + reqResponse.body
        end

        response = reqResponse)
      response = deleteCalculationTask
    rescue => e
      if debugging == true do
        IO.puts e.message
      end
      raise e.message
    end
  end
    
  # Get Calculation Result with CobbleVision's Web API. Returns a response object with body, response and headers properties, deducted from npm request module;
  # @async
  # @function getCalculationResult()
  # @param {List} IDArray ID of calculation to return result Array 
  # @param {Boolean} returnOnlyStatusBool Return full result or only status? See Doc for more detailed description!
  # @returns {Task} Task with the GetCalculationResult. The body is in json format.
  def getCalculationResult(IDArray, returnOnlyStatusBool)
    try do
      getCalculationResultTask = Task.async(fn->
        endpoint = "calculation"
    
        if String.at(BaseURL, String.length(BaseURL)-1] = "/" do
          raise "BaseURL for CobbleVision is incorrect. Must end with slash!"
        end

        keyArray = ["IDArray", "returnOnlyStatusBool", "Your Api Username", "Your API Token"]
        valueArray = [IDArray, returnOnlyStatusBool, apiUserName, apiToken]
        typeArray = ["Array", "Boolean", "String", "String"]
    
        try do
          checkTypeOfParameter(valueArray, typeArray)
        rescue => e
          err_message = String.to_integer(e.toString())
          if is_integer(err_message) do
            raise "The provided data is not valid: ", keyArray[err_message] + "is not of type " + typeArray[err_message]
          else
            raise e.message
          end
        end

        if !(checkListForInvalidObjectID(IDArray)) do
          raise "You supplied a calc ID that is not valid!"
        end

        auth = [hackney => [ basic_auth => { apiUserName => apiToken }]]
        headerObject= %{"Content-Type" => "application/json", "Accept" => "application/json"}
   
        HTTPPoison.Response reqResponse = HTTPPoison.get(BaseURL + endpoint + "&id=" + Poison.encode(IDArray) + "&returnOnlyStatusBool=" + Poison.decode(returnOnlyStatusBool), headerObject, auth)
    
        if debugging == true do
          IO.puts "Response from Delete Calc: " + reqResponse.body
        end

        response = reqResponse)
      response = getCalculationResultTask
    rescue => e
      if debugging == true do
        IO.puts e.message
      end
      raise e.message
    end
  end

  # Request your calculation result by ID with the CobbleVision API. Returns a response object with body, response and headers properties, deducted from npm request module;
  # @async
  # @function getCalculationVisualization()
  # @param {String} id ID of calculation to return result/check String
  # @param {Boolean} returnBase64Bool Return Base64 String or image buffer as string?
  # @param {Integer} width target width of visualization file
  # @param {Integer} height target height of visualization file
  # @returns {Task} Task with the GetCalculationVisualization Result. The body is in binary format.

  def getCalculationVisualization(id, returnBase64Bool, width, height)
    try do
      getCalculationVisTask = Task.async(fn->
        endpoint = "calculation/visualization"
    
        if String.at(BaseURL, String.length(BaseURL)-1] = "/" do
          raise "BaseURL for CobbleVision is incorrect. Must end with slash!"
        end

        keyArray = ["id", "returnBase64Bool", "width", "height", "Your Api Username", "Your API Token"]
        valueArray = [id, returnBase64Bool, width, height, apiuserName, apitoken]
        typeArray = ["String", "Boolean", "Number", "Number", "String", "String"]
    
        try do
          checkTypeOfParameter(valueArray, typeArray)
        rescue => e
          err_message = String.to_integer(e.toString())
          if is_integer(err_message) do
            raise "The provided data is not valid: ", keyArray[err_message] + "is not of type " + typeArray[err_message]
          else
            raise e.message
          end
        end

        if !(checkListForInvalidObjectID([id])) do
          raise "You supplied a calc ID that is not valid!"
        end

        if width==0 do
          raise "The width cannot be zero."
        end

        if height==0:
          raise "The height cannot be zero."
        end

        auth = [hackney => [ basic_auth => { apiUserName => apiToken }]]
        headerObject= %{"Content-Type" => "application/json", "Accept" => "application/json"}
    
        HTTPPoison.Response reqResponse = HTTPPoison.get(BaseURL + endpoint + "?id=" + id + "&returnBase64Bool=" + Poison.decode(returnBase64Bool) + "&width=" + to_string(width) + "&height=" + to_string(height), headerObject, auth)
    
        if debugging == true do
          IO.puts "Response from Delete Calc: " + reqResponse.body
        end

        response = reqResponse)
      response = getCalculationVisTask
    rescue => e
      if debugging == true do
        IO.puts e.message
      end
      raise e.message
    end
  end
  
###################################################
## Helper Functions
###################################################

  # TypeChecking of Values
  # @sync
  # @function checktypeOfParameter()
  # @param {List} targetArray Array of values to be checked
  # @param {List} typeArray Array of types in strings to be checked against
  # @returns {Boolean} Success of Check
  def checktypeOfParameter(targetArray, assertTypeArray)
    try do
      Enum.each(Enum.with_index(targetArray), fn (targetElement, index) ->
        if !(getRealType(targetElement) != assertTypeArray[index]) do
          raise Exception(to_string(index))
        end
      )
      return true
    rescue => e
      raise e.message

  def getRealType(element)
      cond do
            is_number(element) -> "Number"
            is_boolean(element) -> "Boolean"
            is_list(element) -> "Array"
            is_string(element) -> "String"
      end    
  end

  # Check Array of Mongo IDs for Invalid Values
  # @sync
  # @function checkIDArrayForInvalidValues()
  # @param {List} IDArray Array of Mongo IDs
  # @returns {Boolean} Success of Check
  def checkListForInvalidObjectIDs(IDArray)
    try do
      Enum.each(IDArray, fn x -> BSON.ObjectID(x))
      return true
    rescue => e
      return false
    end
  end
 
  # Wait using sleep function
  # @async
  # @function wait()
  # @param {Number} timeInMS time to wait in ms
  # @returns {Boolean} Success of Wait
  def wait(timeInMS)
    Process.sleep(timeInMS)
  end
end
