/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : lab_1b.p
    Purpose     : 
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

/* ***************************  Definitions  ************************** */
define temp-table ttOrder no-undo like Order.

define temp-table ttOrder2 no-undo like Order
    index idxFast orderdate.

define temp-table ttOrder3 no-undo
    field ordernum  like Order.Ordernum
    field orderdate like Order.OrderDate
    index idxNum as primary unique ordernum
    index idxDate orderdate.

/* ***************************  Main Block  *************************** */
for each order  no-lock:
    // 1.
    create ttOrder.
    buffer-copy Order 
        using ordernum
         to ttOrder.
    // 2.
    create ttOrder2.
    buffer-copy Order 
         to ttOrder2.
    // 3.
    create ttOrder3.
    buffer-copy Order 
         to ttOrder3.
end.

