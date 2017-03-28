/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : lab_1d.p
    Purpose     : Read profile output data form somewhere and process or
                  transform it; optionally write it back out for viewing in
                  a pretty UI  
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

session:debug-alert = true.
session:error-stack-trace = true.
/* ***************************  Definitions  ************************** */
{profiledata.i}

define variable sessionId as character no-undo.
define variable inputFile as character no-undo.
define variable outputFile as character no-undo.

/* ***************************  Main Block  *************************** */
inputFile = '<<your file here>>'. 
run read_profiler_data.p (inputFile, output sessionId, output dataset profileData).

// DO WHAT YOU NEED TO DO HERE

// write the changed values out for consumption by a tool
run write_profiler_data.p (outputFile, sessionId, dataset profileData by-reference).

catch e as Progress.Lang.Error :
    message 
        e:GetMessage(1) skip(2)
        e:CallStack
    view-as alert-box.
end catch.
/* eof */        
