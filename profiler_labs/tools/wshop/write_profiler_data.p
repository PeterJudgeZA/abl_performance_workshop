/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : write_profiler_data.p
    Purpose     : Writes profilter data from the profileData dataset to disk
                  in the correct format.
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.Lang.AppError.

/* ***************************  Definitions  ************************** */
{profiledata.i}

define input parameter pcFilename as character no-undo.
define input parameter pcSessionId as character no-undo.
define input parameter dataset for profileData.

define stream strData.

/* ***************************  Main Block  *************************** */
output stream strData to value(pcFilename).

find profilerSession where profilerSession.sessionId eq pcSessionId no-error.
if not available profilerSession then     
    return error new AppError(substitute('Unable to find profiler session &1', pcSessionId), 0).

export stream strData 
    profilerSession.profilerVersion
    date(profilerSession.sessionDateTime)
    profilerSession.sessionDesc
    string(interval(profilerSession.sessionDateTime, datetime-tz(date(profilerSession.sessionDateTime), 0), 'seconds':u), 'HH:MM:SS':u)
    profilerSession.sessionUser
    .
put stream strData unformatted ".":u skip.

for each moduleData where moduleData.sessionId eq pcSessionId:
        export stream strData
            moduleData.moduleId 
            moduleData.moduleName
            moduleData.debugListingFile
            moduleData.crcValue   
            .
end.
put stream strData unformatted ".":u skip.

for each callTree where callTree.sessionId eq pcSessionId:
    export stream strData
        callTree.callerId
        callTree.callerLineNum
        callTree.calleeId
        callTree.callCount
        .
end. 
put stream strData unformatted ".":u skip.

for each lineSummary where lineSummary.sessionId eq pcSessionId:
    export stream strData
        lineSummary.moduleId
        lineSummary.lineNum
        lineSummary.execCount
        lineSummary.actualTime
        lineSummary.cumulativeTime 
        .
end. 
put stream strData unformatted ".":u skip.

for each traceData where traceData.sessionId eq pcSessionId:
    export stream strData
        traceData.moduleId
        traceData.lineNum
        traceData.actualTime
        traceData.startTime
        .
end.
put stream strData unformatted ".":u skip.

for each coverageData where coverageData.sessionId eq pcSessionId:
    export stream strData
        coverageData.moduleId
        coverageData.entryName
        coverageData.lineCount
        .
end.
put stream strData unformatted ".":u skip.

if profilerSession.profilerVersion ge 2 then
do:
    for each operatorsData where operatorsData.sessionId eq pcSessionId:
        export stream strData
            operatorsData.moduleId
            operatorsData.operationCode
            operatorsData.operationCount
            operatorsData.operationDesc
            .
    end.
    put stream strData unformatted ".":u skip.
    
    for each moduleDetail where moduleDetail.sessionId eq pcSessionId:
        export stream strData
            moduleDetail.moduleId
            moduleDetail.numUndoVar
            moduleDetail.numNoundoVar
            moduleDetail.numUdfOrMethods
            moduleDetail.numIntProc
            moduleDetail.numStaticTT
            moduleDetail.avgFieldsPerTT
            moduleDetail.medianFieldsPerTT
            moduleDetail.lowFieldsPerTT
            moduleDetail.highFieldsPerTT
            moduleDetail.numStaticQuery
            moduleDetail.numStaticBuffer
            moduleDetail.numStaticDataSource
            moduleDetail.numStaticDataset
            moduleDetail.numParameters
            (if moduleDetail.isClass then 1.0 else 0.0)
            moduleDetail.numPublicMembers
            moduleDetail.numProtectedMembers
            moduleDetail.classHierarchyDepth
            moduleDetail.rcodeInitialSegmentSize
            moduleDetail.rcodeExpressionSegmentSize
            moduleDetail.rcodeActionCodeSegmentSize
            moduleDetail.rcodeTextSegmentSize
            .
    end.
    put stream strData unformatted ".":u skip.
    
    for each sessionWatermark where sessionWatermark.sessionId eq pcSessionId:
        export stream strData 
            sessionWatermark.moduleId
            sessionWatermark.highNumInstances
            sessionWatermark.highStaticTT
            sessionWatermark.highNumTT
            .
    end.
    put stream strData unformatted ".":u skip.
    
    for each sessionDb where sessionDb.sessionId eq pcSessionId:
        export stream strData
            0
            sessionDb.dbNum
            sessionDb.connectionParam
            .
        export stream strData
            sessionDb.logicalName
            sessionDb.numTables
            .
    end.
    put stream strData unformatted ".":u skip.
end.    // v2+ 

for each userData where userData.sessionId eq pcSessionId:
    export stream strData
        userData.writeTime
        userData.userData
        .
end.
put stream strData unformatted ".":u skip.

finally:
    output stream strData close.
end finally.
/* eof */