
/*------------------------------------------------------------------------
    File        : test_load.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Mon Mar 27 16:44:02 EDT 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.

/* ********************  Preprocessor Definitions  ******************** */
session:debug-alert = true.
session:error-stack-trace = true.

/* ***************************  Main Block  *************************** */
{profiledata.i}
define variable sessionId as character no-undo.

run read_profiler_data.p (
        input 'out/slow_http_call (no-src, no-listing)_1490708475153.prof', 
        output sessionId,
        output dataset profileData).

buffer moduleData          :write-json('file', session:temp-dir + 'profile_data.json':u, true, ?, ?, true).
buffer profilerSession     :write-json('file', session:temp-dir + 'profile_data_profilerSession.json':u, true, ?, ?, true).
buffer moduleData          :write-json('file', session:temp-dir + 'profile_data_moduleData.json':u, true, ?, ?, true).
buffer callTree            :write-json('file', session:temp-dir + 'profile_data_callTree.json':u, true, ?, ?, true).
buffer lineSummary         :write-json('file', session:temp-dir + 'profile_data_lineSummary.json':u, true, ?, ?, true).
buffer traceData           :write-json('file', session:temp-dir + 'profile_data_traceData.json':u, true, ?, ?, true).
buffer coverageData        :write-json('file', session:temp-dir + 'profile_data_coverageData.json':u, true, ?, ?, true).
buffer userData            :write-json('file', session:temp-dir + 'profile_data_userData.json':u, true, ?, ?, true).
buffer operatorsData       :write-json('file', session:temp-dir + 'profile_data_operatorsData.json':u, true, ?, ?, true).
buffer moduleDetail        :write-json('file', session:temp-dir + 'profile_data_moduleDetail.json':u, true, ?, ?, true).
buffer sessionWatermark    :write-json('file', session:temp-dir + 'profile_data_sessionWatermark.json':u, true, ?, ?, true).

dataset profileData:write-json('file', session:temp-dir + 'profile_data.json':u, true, ?, ?, true).

def var jsonData as JsonObject.

jsonData = new JsonObject().
//jsonData:Read(dataset profileData:handle).

//jsonData:writeFile(session:temp-dir + 'profile_data.json':u, true).

catch e as Progress.Lang.Error :
    
    message 
    e:GetMessage(1) skip(2)
    e:CallStack
    view-as alert-box.
        
end catch.



