/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : activate.p
    Purpose     : AppServer ACTIVATE event procedure
    Notes       : * enables the PROFILER if a profilter.json file can be found
                    {
                        "enabled": true,
                        "description": "",
                        "listings": false,
                        "coverage": true,
                        "file-name": "",
                        "directory": "",
                        "trace-filter": ""
                    }
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.

/* ***************************  Definitions  ************************** */
define variable jsonData as JsonObject no-undo.
define variable outputDir as character no-undo.
define variable fileName as character no-undo.
define variable fileExt as character no-undo.
define variable dotPos as integer no-undo.

/* ***************************  Main Block  *************************** */
assign file-info:file-name = 'profiler.json':u
       jsonData = cast(new ObjectModelParser():ParseFile(file-info:full-pathname), JsonObject) 
       // don't fail the whole request just because we can't profile it 
       no-error.

if     valid-object(jsonData)
   and jsonData:GetLogical('enabled':u)
   then
do:
    // directory is used for the profile output file and listings 
    assign outputDir           = jsonData:GetCharacter('directory':u)
           file-info:file-name = outputDir
           .
    if file-info:full-pathname eq ? then
        assign outputDir = session:temp-dir.
    
    assign outputDir = right-trim(replace(outputDir, '~\':u, '/':u), '/':u)
           fileName  = jsonData:GetCharacter('file-name':u) no-error.
    if    fileName eq '':u
       or fileName eq ?
       then
        assign fileName = 'request':u
               fileExt  = 'prof':u
               .
    else
        assign dotPos   = r-index(fileName, '.':u)
               fileExt  = substring(fileName, dotPos + 1)
               fileName = substring(fileName, 1, dotPos - 1)
               .
    assign profiler:enabled   = true
           profiler:profiling = true
           profiler:file-name = substitute('&1/&2_&3.&4':u,
                                           outputDir, fileName, guid, fileExt).
    
    // identify this request's profile file
    assign profiler:description = substitute('&1 (RequestId=&2)':u,
                                        jsonData:GetCharacter('description':u),
                                        session:current-request-info:RequestId).
    
    if jsonData:GetLogical('listings':u) then
        assign profiler:listings  = true.
               profiler:directory = outputDir.
    
    assign profiler:coverage     = jsonData:GetLogical('coverage':u)
           profiler:statistics   = not profiler:coverage
           profiler:trace-filter = jsonData:GetCharacter('trace-filter':u)
           .
    log-manager:write-message('PROFILER:FILE-NAME=' + profiler:file-name, 'ACTIV8':u).
    log-manager:write-message('PROFILER:DESCRIPTION=' + string(profiler:description), 'ACTIV8':u).
    log-manager:write-message('PROFILER:LISTINGS=' + string(profiler:listings), 'ACTIV8':u).
    log-manager:write-message('PROFILER:DIRECTORY=' + profiler:directory, 'ACTIV8':u).
    log-manager:write-message('PROFILER:COVERAGE=' + string(profiler:coverage), 'ACTIV8':u).
    log-manager:write-message('PROFILER:STATISTICS=' + string(profiler:statistics), 'ACTIV8':u).
    log-manager:write-message('PROFILER:TRACE-FILTER=' + profiler:trace-filter, 'ACTIV8':u).
end.

catch e as Progress.Lang.Error :
    log-manager:write-message('ERROR: ACTIVATE', 'ACTIV8':u).
    log-manager:write-message(e:GetMessage(1), 'ACTIV8':u).        
end catch.

/* eof */