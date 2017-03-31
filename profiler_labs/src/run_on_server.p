block-level on error undo, throw.

/* ***************************  Definitions  ************************** */
define variable hServer as handle no-undo.

/* ***************************  Main Block  *************************** */
create server hServer.

hServer:connect('-URL http://localhost:8860/apsv').

MESSAGE hserver
skip
hserver:connected()
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* Run one thing */                                      
run slow_http_call.p on hServer.

finally:
    hServer:disconnect().
    delete object hServer.
end finally.
