/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : deactivate.p
    Purpose     : AppServer DEACTIVATE event procedure
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

/* ***************************  Main Block  *************************** */
if profiler:enabled then
do:
    assign profiler:profiling = false
           profiler:enabled   = false.
    profiler:write-data().
end.
/* eof */