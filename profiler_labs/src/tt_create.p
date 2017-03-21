/*------------------------------------------------------------------------
    File        : tt_create.p
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */
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
    //21.
    create ttOrder2.
    buffer-copy Order 
         to ttOrder2.
    // 3.
    create ttOrder3.
    buffer-copy Order 
         to ttOrder3.
end.

