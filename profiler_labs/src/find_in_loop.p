/*------------------------------------------------------------------------
    File        : find_in_loop.p
    Purpose     : 
    Author(s)   : pjudge 
    Created     : 2017-03-02
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

/* ***************************  Main Block  *************************** */
def var grandTotal as int.

    find first Salesrep no-lock no-error.
    
for each order where
         Order.OrderStatus = 'Approval Pending'
         no-lock,
    each OrderLine of Order 
         no-lock:

/*
    if    not available Salesrep 
       or Salesrep.SalesRep <> Order.SalesRep then   
*/
        find salesrep of order no-lock  no-error.    
    
    grandTotal = grandTotal + 1.
end.

message 
grandTotal
view-as alert-box.
