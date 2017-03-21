/*------------------------------------------------------------------------
    File        : enable_profiler.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Thu Mar 02 13:07:59 EST 2017
    Notes       :
  ----------------------------------------------------------------------*/
/*
-profile C:\devarea\eclipse\workspaces\presentations\17-pug-uki\.metadata\.plugins\com.openedge.pdt.project\temp.dir\profiler_config_4599791839798078651.txt


*/
/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** *
profiler:
      DEFINE VARIABLE cCalls     AS CHARACTER  NO-UNDO INITIAL
    "FILE-NAME,COVERAGE,DESCRIPTION,DIRECTORY,ENABLED,LISTINGS,PROFILING,TRACING,TRACE-FILTER".
  DEFINE VARIABLE cCallType  AS CHARACTER  NO-UNDO INITIAL
    "CHARACTER,LOGICAL,CHARACTER,CHARACTER,LOGICAL,LOGICAL,LOGICAL,CHARACTER,CHARACTER".
    
1) show code
2) where would add this?
    - ui code (gui/tty)
    - server code (activate/deactivate)
3) how to read / parse profiler info


 ***************************  Main Block  *************************** */
procedure enable_profiler:
    profiler:file-name = session:temp-dir + 'my-profile-data.' + guid + '.prof'.
    
    profiler:description = 'Profiling request XXX from client YYY'.
        
    profiler:enabled = true.
    profiler:profiling = true.
end procedure.
 
procedure disable_profiler:
  profiler:profiling = false. 
  profiler:write-data().
end procedure.
 