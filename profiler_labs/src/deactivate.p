/*------------------------------------------------------------------------
    File        : deactivate.p
    Purpose     : AppServer DEACTIVATE event procedure
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

/* ***************************  Main Block  *************************** */
if profiler:enabled then
do:
    assign profiler:enabled = false.
    profiler:write-data().    
end.

/* eof */