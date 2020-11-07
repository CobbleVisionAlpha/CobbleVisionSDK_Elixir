################################################
# Incomplete list of imports and environment setup
################################################
def module CobbleVision_API do

  environmentType=false
  serverAdress="https://cobblevision.com"

  valid_price_categories = ["high, "medium", "low"]
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
    apiUserName = apiusername
    apiToken = apitoken
    returnBool=true
  end
  
  # Function allows you to set the debugging variable
  # @function setDebugging()
  # @param {Boolean} debugBool
  # @returns {Boolean} Indicating success of setting Api Auth.

  def setDebugging(debugBool)
     debugging = debugBool
     returnBool=true
  end   

################################################
# Functions for using the CobbleVision API
################################################

  # Return of the following functions is specified within this type description
  # @typedef {Map} Response
  # @property {Number} status_code Returns Status Code of Response
  # @property {String} body returns json of response
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
      endpoint = "media"
      if String.at(BaseURL, String.length(BaseURL)-1] = "/" do
        raise "BaseURL for CobbleVision is incorrect. Must end with slash!"
      end
    
    keyArray = ["price_category", "publicBool", "name", "tags", "Your Api User Key", "Your API Token"]
    valueArray = [price_category, publicBool, name, tags, apiUserName, apiToken]
    typeArray = ["String", "Boolean", "String", "Array", "String", "String"]
    
    try do
      checkTypeOfParameter(valueArray, typeArray)
    rescue => e
      err_message = String.to_integer(e.toString())
      if is_integer(err_message) do
        raise "The provided data is not valid: ", keyArray[err_message] + "is not of type " + typeArray[err_message]
      else
        raise e.toString()
      end
    end

    if is_binary(file) do
      raise "The file must be provided as binary"
    end

    if enum.find_index(valid_price_categories, fn x -> x === price) != -1 do
      raise "Your price indicator is not valid!"
    end

    jsonObject = {
      "price_category": price_category,
      "public": publicBool,
      "name": name,
      "tags": tags,
      "file": file
    }
    
    headerJSON={
      "Content-Type":"application/json",
      "Accept": "application/json"
    }
    
    r=requests.post(BaseURL + endpoint, json=jsonObject, auth=(apiUserName, apiToken), headers=headerJSON)
    
    if debugging == True:
      print("Response from Media Upload: ", r.text)
    
    return r
  except Exception as e:
    exc_type, exc_object, exc_tb = sys.exc_info()
    print(exc_type, exc_object, exc_tb)
    raise Exception(str(e))

# This function deletes Media from CobbleVision
# @async
# @function deleteMediaFile()  
# @param {array} IDArray Array of ID's as Strings
# @returns {Task} Task with the DeleteMediaResponse. The body is in JSON format.

async def deleteMediaFile (IDArray):
  try:
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
        raise e.toString()
      end
    end
        
    if !(checkListForInvalidObjectID(IDArray)) do
      raise "You supplied a media ID that is not valid!"
    end
    
    headerJSON={
      "Content-Type": "application/json",
      "Accept": "application/json"
    }
    
    r=requests.delete(BaseURL + endpoint + "?id=" + json_dumps(IDArray), headers=headerJSON, auth=(apiUserName, apiToken))
    
    if debugging == True:
      print("Response from Media Deletion: ", r.text)
    
    return r
  except Exception as e:
    exc_type, exc_object, exc_tb = sys.exc_info()
    print(exc_type, exc_object, exc_tb)
    raise Exception(str(e))
    

# Launch a calculation with CobbleVision's Web API. Returns a response object with body, response and headers properties, deducted from npm request module;
# @async
# @function launchCalculation() 
# @param {array} algorithms Array of Algorithm Names
# @param {array} media Array of Media ID's  
# @param {string} type Type of Job - Currently Always "QueuedJob"
# @param {string} [notificationURL] Optional - Notify user upon finishing calculation!
# @returns {Task} Task with the LaunchCalculationResponse. The body is in JSON format.  

async def launchCalculation(algorithms, media, type, notificationURL):
  try:
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
        raise e.toString()
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
      
    jsonObject = {
      "algorithms": algorithms,
      "media": media,
      "type": type,
    }
    
    headerJSON={
      "Content-Type": "application/json",
      "Accept": "application/json"
    }
    
    urlNotificationBool = False
    if(notificationURL != None):
      urlNotificationBool = validate_url(notificationURL)
    if(notificationURL != None && urlNotificationBool == True:
      jsonObject["notificationURL"] = notificationURL
    
    r=requests.post(BaseURL + endpoint, json=jsonObject, headers=headerJSON, auth=(apiUserName, apiToken))
    
    if debugging == True:
      print("Response from Calculation Launch: ", r.text)
    
    return r
  except Exception as e:
    exc_type, exc_object, exc_tb = sys.exc_info()
    print(exc_type, exc_object, exc_tb)
    raise Exception(str(e))
    
# This function waits until the given calculation ID's are ready to be downloaded!
# @async
# @function waitForCalculationCompletion() 
# @param {array} calculationIDArray Array of Calculation ID's
# @returns {Task} Task with the WaitForCalculationResponse. The body is in JSON format.   

async def waitForCalculationCompletion(calculationIDArray):
  try:
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
        raise e.toString()
      end
    end
        
    invalidCalcs = listfilter(lambda calcID:checkForValidObjectID(calcID), calculationIDArray))
    if len(invalidCalcs) > 0:
      raise Exception("You supplied an ID that is not valid!")
    
    headerJSON={
      "Content-Type": "application/json",
      "Accept": "application/json"
    }
    
    calculationFinishedBool = False
    
    while calculationFinishedBool == False:
      r=requests.get(BaseURL+endpoint+"?id=" + json_dumps(calculationIDArray) + "$returnOnlyStatusBool=true", auth=(apiUserName, apiToken))
    
      if type(json.loads(r.text)) === "list":
        responseArray=json.dumps(r.text)
        for resp in responseArray:
          if hasAttr(resp, "status")
            if resp["status"] === "finished":
              calculationFinishedBool = True
            else
              calculationFinishedBool = False
              break
          if calculationFinishedBool == False:
            await wait(3000)
      else:
        if hasAttr(resp, "error"):
          calculationFinishedBool = True
    
    if debugging == True:
      print("Response from Calculation Launch: ", r.text)
    
    return r
  except Exception as e:
    exc_type, exc_object, exc_tb = sys.exc_info()
    print(exc_type, exc_object, exc_tb)
    raise Exception(str(e))


# This function deletes Result Files or calculations in status "waiting" from CobbleVision. You cannot delete finished jobs beyond their result files, as we keep them for billing purposes.
# @async
# @function deleteCalculation()
# @param {array} IDArray Array of ID's as Strings
# @returns {Task} Task with the DeleteCalculationResponse. The body is in JSON format.
       
function deleteCalculation(IDArray)
  try:
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
        raise e.toString()
      end
    end
        
    invalidCalcs = listfilter(lambda calcID:checkForValidObjectID(calcID), IDArray))
    if len(invalidCalcs) > 0:
      raise Exception("You supplied a calc ID that is not valid!")    
    
    headerJSON={
      "Content-Type": "application/json",
      "Accept": "application/json"
    }
    
    r=requests.delete(BaseURL + endpoint + "?id=" + json_dumps(IDArray), headers=headerJSON, auth=(apiUserName, apiToken))
    
    if debugging == True:
      print("Response from Media Deletion: ", r.text)
    
    return r
  except Exception as e:
    exc_type, exc_object, exc_tb = sys.exc_info()
    print(exc_type, exc_object, exc_tb)
    raise Exception(str(e))
    
# Get Calculation Result with CobbleVision's Web API. Returns a response object with body, response and headers properties, deducted from npm request module;
# @async
# @function getCalculationResult()
# @param {array} IDArray ID of calculation to return result Array 
# @param {boolean} returnOnlyStatusBool Return full result or only status? See Doc for more detailed description!
# @returns {Task} Task with the GetCalculationResult. The body is in json format.

async def getCalculationResult(IDArray, returnOnlyStatusBool)
  try:
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
        raise e.toString()
      end
    end
        
    invalidCalcs = listfilter(lambda calcID:checkForValidObjectID(calcID), IDArray))
    if len(invalidCalcs) > 0:
      raise Exception("You supplied an ID that is not valid!")
    
    headerJSON={
      "Content-Type": "application/json",
      "Accept": "application/json"
    }
    
    r=requests.get(BaseURL+endpoint+"?id=" + json_dumps(IDArray) + "&returnOnlyStatusBool=" + json_dumps(returnOnlyStatusBool), auth=(apiUserName, apiToken))
    
    if debugging == True:
      print("Response from Calculation Launch: ", r.text)
    
    return r
  except Exception as e:
    exc_type, exc_object, exc_tb = sys.exc_info()
    print(exc_type, exc_object, exc_tb)
    raise Exception(str(e))

# Request your calculation result by ID with the CobbleVision API. Returns a response object with body, response and headers properties, deducted from npm request module;
# @async
# @function getCalculationVisualization()
# @param {string} id ID of calculation to return result/check String
# @param {boolean} returnBase64Bool Return Base64 String or image buffer as string?
# @param {integer} width target width of visualization file
# @param {integer} height target height of visualization file
# @returns {Task} Task with the GetCalculationVisualization Result. The body is in binary format.

async def getCalculationVisualization(id, returnBase64Bool, width, height): 
  try:
    endpoint = "calculation/visualization"
    
    if String.at(BaseURL, String.length(BaseURL)-1] = "/" do
      raise "BaseURL for CobbleVision is incorrect. Must end with slash!"
    end

    keyArray = ["id", "returnBase64Bool", "width", "height", "Your Api Username", "Your API Token"]
    valueArray = [id, returnBase64Bool, width, height, apiuserName, apitoken]
    typeArray = ["String", "Boolean", "Number", "Number" "String", "String"]
    
    try do
      checkTypeOfParameter(valueArray, typeArray)
    rescue => e
      err_message = String.to_integer(e.toString())
      if is_integer(err_message) do
        raise "The provided data is not valid: ", keyArray[err_message] + "is not of type " + typeArray[err_message]
      else
        raise e.toString()
      end
    end
        
    invalidCalcs = listfilter(lambda calcID:checkForValidObjectID(calcID), [id]))
    if len(invalidCalcs) > 0:
      raise Exception("You supplied an ID that is not valid!")
    
    if width==0:
      raise Exception("The width cannot be zero.")
    
    if height==0:
      raise Exception("The height cannot be zero.")
    
    headerJSON={
      "Content-Type": "application/json",
      "Accept": "application/json"
    }
    
    r=requests.get(BaseURL + endpoint + "?id=" + id + "&returnBase64Bool=" + json_dumps(returnBase64Bool) + "&width=" + width + "&height=" + height, auth=(apiUserName, apiToken))
    
    if debugging == True:
      print("Response from Calculation Launch: ", r.text)
    
    return r
  except Exception as e:
    exc_type, exc_object, exc_tb = sys.exc_info()
    print(exc_type, exc_object, exc_tb)
    raise Exception(str(e)) 
  
###################################################
## Helper Functions
###################################################

# TypeChecking of Values
# @sync
# @function checktypeOfParameter()
# @param {array} targetArray Array of values to be checked
# @param {array} typeArray Array of types in strings to be checked against
# @returns {boolean} Success of Check
async def checktypeOfParameter(targetArray, assertTypeArray):
  try:
    for counter,tArr in enumerate(targetArray):
      if type(tArr) != assertTypeArray[counter]:
        if type(targetArray != "list"):
          raise Exception(counter)
      else:
        raise Exception(counter)
      return True
  except Exception as e:
    exc_type, exc_object, exc_tb = sys.exc_info()
    print(exc_type, exc_object, exc_tb)
    raise Exception(str(e))

def typeof(self) do
        cond do
            is_float(self)    -> "float"
            is_number(self)   -> "number"
            is_atom(self)     -> "atom"
            is_boolean(self)  -> "boolean"
            is_binary(self)   -> "binary"
            is_function(self) -> "function"
            is_list(self)     -> "list"
            is_tuple(self)    -> "tuple"
            true              -> "idunno"
        end    
    end

# Check Array of Mongo IDs for Invalid Values
# @sync
# @function checkIDArrayForInvalidValues()
# @param {array} IDArray Array of Mongo IDs
# @returns {boolean} Success of Check
async def checkForValidObjectID(IDArray):
  try:
    for id in IDArray:
      ObjectId(id)
    return True
  except Exception as e:
    exc_type, exc_object, exc_tb = sys.exc_info()
    print(exc_type, exc_object, exc_tb)
    raise Exception(str(e))

# Verify url using python regex combination
# @sync
# @function validate_url()
# @param {tURL} URL target URL to verify
# @returns {boolean} Success of Check
def validate_url(tURL):
  try:
    regex=re.compile(r'^(?:http/ftp)s?://'
                     r'(?:(:?:[A-Z0-9][?:[A-Z0-9]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?/[A-Z0-9-]{2,3/.?)/'
                     r'localhost'
                     r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/'
                     r'\[?[A-F0-9]:[A-F0-9:]+\]?)'
                     r'(?::\d+)?'
                     r'(?:/?/[/?]\s+)$', re.IGNORECASE)
    match=regex.match(str(tURL))
    return bool(match)
  except Exception as e:
    exc_type, exc_object, exc_tb = sys.exc_info()
    print(exc_type, exc_object, exc_tb)
    raise Exception(str(e))
 
# Wait using python sleep function
# @async
# @function wait()
# @param {number} timeInMS time to wait in ms
# @returns {boolean} Success of Wait
 async def wait(timeInMS):
  try:
    time.sleep(timeInMS/1000)
    return True;
  except Exception as e:
    exc_type, exc_object, exc_tb = sys.exc_info()
    print(exc_type, exc_object, exc_tb)
    raise Exception(str(e))  

