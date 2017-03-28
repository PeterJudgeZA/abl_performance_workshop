/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : lab_1c.p
    Purpose     : Lab 1(c) test/run code. ABL is easiest; we could call via
                  REST too
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

/* ***************************  Definitions  ************************** */
define variable hServer as handle no-undo.

/* ***************************  Main Block  *************************** */
create server hServer.
hServer:connect('-URL http://localhost:XXXX/perf_wshop/apsv').

/* Run one thing */
run slow_http_call.p on hServer.

/* Run another  */
run tt_create.p on hServer.

finally:
    hServer:disconnect().
    delete object hServer.
end finally.