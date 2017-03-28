/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : analyse_profiler_data.p
    Purpose     : Loads the output from a profile session into a set of TT's 
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.Lang.AppError.

/* ***************************  Definitions  ************************** */
{profiledata.i}
define input  parameter pcFileName as character no-undo.
define output parameter pcSessionId as character.
define output parameter dataset for profileData.

define variable inputData as character no-undo extent.
define stream strData.

/* ***************************  Main Block  *************************** */
assign file-info:file-name = pcFileName.
if file-info:full-pathname eq ? then
    undo, throw new AppError(substitute('Unable to find profiler output data file &1', pcFileName), 0).

input stream strData from value(file-info:full-pathname).

assign pcSessionId  = guid.
LOAD-SECTION:
do while true transaction:
    assign extent(inputData) = 2.
    repeat on endkey undo, leave LOAD-SECTION:
        create profilerSession.
        
        import stream strData
            profilerSession.profilerVersion
            inputData[1]
            profilerSession.sessionDesc
            inputData[2]
            profilerSession.sessionUser
            .
        assign profilerSession.sessionId       = pcSessionId
               profilerSession.sessionDateTime = datetime-tz(datetime(inputData[1] + ' ':u + inputData[2]))
               .
    end.
end.    // LOAD-SECTION:

LOAD-SECTION:
do while true transaction:
    repeat on endkey undo, leave LOAD-SECTION:
        create moduleData.
        import stream strData
            moduleData.moduleId
            moduleData.moduleName
            moduleData.debugListingFile
            moduleData.crcValue
            .
        assign moduleData.sessionId = pcSessionId.
    end.
end.    // LOAD-SECTION:

LOAD-SECTION:
do while true transaction:
    repeat on endkey undo, leave LOAD-SECTION:
        create callTree.
        import stream strData
            callTree.callerId
            callTree.callerLineNum
            callTree.calleeId
            callTree.callCount
            .
        assign callTree.sessionId = pcSessionId.
    end.
end.    // LOAD-SECTION:

LOAD-SECTION:
do while true transaction:
    repeat on endkey undo, leave LOAD-SECTION:
        create lineSummary.
        import stream strData
            lineSummary.moduleId
            lineSummary.lineNum
            lineSummary.execCount
            lineSummary.actualTime
            lineSummary.cumulativeTime
            .
        assign lineSummary.sessionId = pcSessionId.
    end.
end.    // LOAD-SECTION:

LOAD-SECTION:
do while true transaction:
    repeat on endkey undo, leave LOAD-SECTION:
        create traceData.
        import stream strData
            traceData.moduleId
            traceData.lineNum
            traceData.actualTime
            traceData.startTime
            .
        assign traceData.sessionId = pcSessionId.
    end.
end.    // LOAD-SECTION:

LOAD-SECTION:
do while true transaction:
    repeat on endkey undo, leave LOAD-SECTION:
        create coverageData.
        import stream strData
            coverageData.moduleId
            coverageData.entryName
            coverageData.lineCount    
            .
        assign coverageData.sessionId = pcSessionId.
    end.
end.    // LOAD-SECTION:

if profilerSession.profilerVersion ge 2 then
do:
    LOAD-SECTION:
    do while true transaction:
        repeat on endkey undo, leave LOAD-SECTION:
            create operatorsData.
            import stream strData
                operatorsData.moduleId
                operatorsData.operationCode
                operatorsData.operationCount
                operatorsData.operationDesc
                .
            assign operatorsData.sessionId = pcSessionId.
            if operatorsData.operationCode ge 10000 then
                assign operatorsData.operatorType = 'STATEMENT':u.
            else
                assign operatorsData.operatorType = 'EXPRESSION':u.            
        end.
    end.    // LOAD-SECTION:
    
    LOAD-SECTION:
    do while true transaction:
        assign extent(inputData) = ?
               extent(inputData) = 1
               .
        repeat on endkey undo, leave LOAD-SECTION:
            create moduleDetail.
            import stream strData 
                moduleDetail.moduleId
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
                inputData[1]        //isClass 1.0 / 0.0
                moduleDetail.numPublicMembers
                moduleDetail.numProtectedMembers
                moduleDetail.classHierarchyDepth
                moduleDetail.rcodeInitialSegmentSize
                moduleDetail.rcodeExpressionSegmentSize
                moduleDetail.rcodeActionCodeSegmentSize
                moduleDetail.rcodeTextSegmentSize
                .
            assign moduleDetail.sessionId = pcSessionId
                   moduleDetail.isClass   = logical(integer(inputData[1]))
                   .
        end.
    end.    // LOAD-SECTION:
    
    LOAD-SECTION:
    do while true transaction:
        repeat on endkey undo, leave LOAD-SECTION:
            create sessionWatermark.
            import stream strData 
                sessionWatermark.moduleId
                sessionWatermark.highNumInstances
                sessionWatermark.highStaticTT
                sessionWatermark.highNumTT
                .
            assign sessionWatermark.sessionId = pcSessionId.
        end.
    end.    // LOAD-SECTION:
    
    LOAD-SECTION:
    do while true transaction:
        repeat on endkey undo, leave LOAD-SECTION:
            create sessionDb.
            import stream strData
                ^
                sessionDb.dbNum
                sessionDb.connectionParam
                .
            // therre's a line break after the connection params for some reason                 
            import stream strData
                sessionDb.logicalName
                sessionDb.numTables
                .
            assign sessionDb.sessionId = pcSessionId.
        end.
    end.    // LOAD-SECTION:
end.    // v2+ 
    
LOAD-SECTION:
do while true transaction:
    repeat on endkey undo, leave LOAD-SECTION:
        create userData.
        import stream strData
            userData.writeTime
            userData.userData
            .
        assign userData.sessionId = pcSessionId.
    end.
end.    // LOAD-SECTION:

finally:
    input stream strData close.
end finally.
/* EOF */
