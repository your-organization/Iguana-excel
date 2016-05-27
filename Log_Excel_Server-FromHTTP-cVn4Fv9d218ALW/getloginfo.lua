local log = require 'log.analyse'
local excel = require 'excel.converter'

local function GetLogInfo(R,A)
   local C = log.connection()
   -----------------
--local pTime = log.setNextPollTime('2014/01/01 00:00:00')-----------
--local pTime = log.pollTime()----------------
--   log.MapTime(
--   log.
--   log.MapTime(os.time())
--   os.time():S()
--   log.queryLogs{ user='admin',password='password',polltime='2016/05/27 16:20:00'}
   log.queryLogs{user='admin',password='password',polltime='2016-05-27 16:57:00'}
   local Results = C:query{sql='SELECT * FROM LogInfo LIMIT 5000', live=true}
   trace(#Results)
   local C = log.connection()
   log.reset(C)
   local Results = C:query{sql='SELECT * FROM LogInfo LIMIT 5000', live=true}
   trace(#Results)
--   log.reset(
   --------------
   local Start = os.ts.time()
   local Sql = "SELECT * FROM LogInfo"
   if (R.params.channel) then
      Sql = Sql.." WHERE Channel = "..C:quote(R.params.channel)
   end
   Sql = Sql.." LIMIT "..(R.params.limit or 5000)
   trace(Sql)
   
   local Results = C:query{sql=Sql, live=true}
   trace(#Results)

   local T = excel.convertResultSet(Results)
   local TimeStampI = excel.lookupColumn(T, 'TimeStamp')
   for i=2, #T do
      local Time = tonumber(T[i][TimeStampI])
      T[i][TimeStampI] = os.ts.date("%c", Time)
   end
   local Body = excel.flatwire(T)
   
   local TimeTaken = os.ts.difftime(os.ts.time(), Start)
   iguana.logInfo("Query took "..TimeTaken.." seconds for "..#Results.." rows")
   net.http.respond{body=Body}
end

return GetLogInfo