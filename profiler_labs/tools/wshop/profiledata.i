/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : profiledata.i
    Purpose     : Dataset definition for profiler data
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define temp-table profilerSession {&NO-UNDO}
    field sessionId as character initial ?    //GUID
    field profilerVersion as decimal
    field sessionDesc as character
    field sessionUser as character
    field sessionDateTime as datetime-tz
    index idx1 as primary unique sessionId
    index idx2 sessionDateTime
    index idx3 as word-index sessionDesc 
    .

define temp-table moduleData {&NO-UNDO}
    field sessionId as character initial ?    //GUID
    field moduleId as integer
    field moduleName as character
    field debugListingFile as character
    field crcValue as integer
    index idx1 as primary unique sessionId moduleId
    index idx2 sessionId crcValue
    index idx3 as word-index moduleName 
    .

define temp-table callTree {&NO-UNDO}
    field sessionId as character initial ?    //GUID
    field callerId as integer
    field callerLineNum as integer
    field calleeId as integer
    field callCount as integer
    index idx1 as primary sessionId callerId callerLineNum
    .

define temp-table lineSummary {&NO-UNDO}
    field sessionId as character initial ?    //GUID
    field moduleId as integer
    field lineNum as integer
    field execCount as integer
    field actualTime as decimal decimals 6
    field cumulativeTime as decimal decimals 6
    index idx1 as primary unique sessionId moduleId lineNum.
    
define temp-table traceData {&NO-UNDO}
    field sessionId as character initial ?    //GUID
    field moduleId as integer
    field lineNum as integer
    field actualTime as decimal decimals 6
    field startTime as decimal decimals 6
    index idx1 as primary sessionId moduleId lineNum.

define temp-table coverageData {&NO-UNDO}
    field sessionId as character initial ?    //GUID
    field moduleId as integer
    field entryName as character
    field lineCount as integer 
    index idx1 as primary unique sessionId moduleId entryName.

define temp-table userData {&NO-UNDO}
    field sessionId as character initial ?    //GUID
    field writeTime as decimal decimals 6
    field userData as character
    index idx1 as primary unique sessionId writeTime.

define temp-table operatorsData {&NO-UNDO}
    field sessionId as character initial ?    //GUID
    field moduleId as integer
    field operationCode as integer
    field operationDesc as character
    field operationCount as integer
    field operatorType as character         // STATEMENT or EXPRESSION 
    index idx1 as primary unique sessionId moduleId operationCode.

define temp-table moduleDetail {&NO-UNDO}
    field sessionId as character initial ?    //GUID
    field moduleId as integer
    field numUndoVar as integer                 /* 1.Number of undo program variables */
    field numNoundoVar as integer               /* 2.Number of no-undo program variables*/
    field numUdfOrMethods as integer            /* 3.Number of udf/methods*/
    field numIntProc as integer                 /* 4.Number of internal procedures*/
    field numStaticTT as integer                /* 5.Number of static temp-tables*/
    field avgFieldsPerTT as integer             /* 6.Average number of fields per temp-table*/
    field medianFieldsPerTT as integer          /* 7.Median number of fields per temp-table*/
    field lowFieldsPerTT as integer             /* 8.Low number of fields per temp-table*/
    field highFieldsPerTT as integer            /* 9.High number of fields per temp-table*/
    field numStaticQuery as integer             /* 10.Number of static queries*/
    field numStaticBuffer as integer            /* 11.Number of static buffers */
    field numStaticDataSource as integer        /* 12.Number of datasources */
    field numStaticDataset as integer           /* 13.Number of static datasets*/
    field numParameters as integer              /* 14.Number of parameters*/
    field isClass as logical                    /* 15.Is class or not (1 or 0)*/
    field numPublicMembers as integer           /* 16.Number of public elements*/
    field numProtectedMembers as integer        /* 17.Number of protected elements*/
    field classHierarchyDepth as integer        /* 18.Depth of class hierarchy (leaf class's only)*/
    field rcodeInitialSegmentSize as integer    /* 19.Size of r-code Initial Value Segment */
    field rcodeExpressionSegmentSize as integer /* 20.Size of r-code Expression Cell Segments*/
    field rcodeActionCodeSegmentSize as integer /* 21.Size of r-code Action Code Segment */
    field rcodeTextSegmentSize as integer       /* 22.Size of r-code Text Segment*/
    index idx1 as primary sessionId moduleId.

define temp-table sessionWatermark {&NO-UNDO}
    field sessionId as character initial ?    //GUID
    field moduleId as integer
    
    field highNumInstances as integer   /*high water mark for # of instances of each proc*/
    field highStaticTT as integer       /*list of all static temp-tables*/
    field highNumTT as integer          /*high water mark for # of temp tables*/
    
    index idx1 as primary sessionId moduleId.

define temp-table sessionDb {&NO-UNDO}
    field sessionId as character initial ?    //GUID
    field dbNum as integer
    field connectionParam as character
    field logicalName as character
    field numTables as integer
    index idx1 as primary unique sessionId dbNum.
    
define dataset profileData for profilerSession, moduleData, callTree, lineSummary, traceData, coverageData, 
                                operatorsData, moduleDetail, sessionWatermark, sessionDb, userData
        data-relation for profilerSession, moduleData relation-fields (sessionId, sessionId) nested
        data-relation for profilerSession, userData relation-fields (sessionId, sessionId) nested
        data-relation for profilerSession, callTree relation-fields (sessionId, sessionId) nested
        data-relation for profilerSession, sessionDb relation-fields (sessionId, sessionId) nested
        data-relation for moduleData, lineSummary relation-fields (sessionId, moduleId, sessionId, moduleId) nested
        data-relation for moduleData, traceData relation-fields (sessionId, moduleId, sessionId, moduleId) nested
        data-relation for moduleData, coverageData relation-fields (sessionId, moduleId, sessionId, moduleId) nested
        data-relation for moduleData, operatorsData relation-fields (sessionId, moduleId, sessionId, moduleId) nested
        data-relation for moduleData, moduleDetail relation-fields (sessionId, moduleId, sessionId, moduleId) nested
        data-relation for moduleData, sessionWatermark relation-fields (sessionId, moduleId, sessionId, moduleId) nested
        .

/*eof*/
