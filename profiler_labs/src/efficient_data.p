/*------------------------------------------------------------------------
    File        : efficient_data.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Thu Mar 02 13:43:24 EST 2017
    Notes       :
  ------    ----------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */
def var numRecs as int.

numRecs = 0.
run cust_order_useindex.
message 
    numRecs
    view-as alert-box.

numRecs = 0.
//run order_cust.
message 
    numRecs
    view-as alert-box.
catch e as Progress.Lang.Error :
       message e:GetMessage(1)
       view-as alert-box. 
end catch.
/* ***************************  Main Block  *************************** */
procedure order_cust:   
    for each s2k.Order where 
        orderdate = 12/23/2011
        no-lock,
        first s2k.Customer of s2k.Order where
        creditlimit >= 100
            no-lock:

        /* create report */
        run CreateReport.
    end.
end procedure.

procedure cust_order:
    for each s2k.Customer where
        creditlimit >= 100 
        no-lock,
        each s2k.Order of s2k.Customer where
        orderdate = 12/23/2011
            no-lock:

        /* create report */
        run CreateReport.
    end.
end procedure.

procedure cust_order_where:
    for each s2k.Customer where
        creditlimit >= 100 
        no-lock,
        each s2k.Order  
        where orderdate = 12/23/2011
         and  Order.CustNum = Customer.CustNum
            no-lock:

        /* create report */
        run CreateReport.
    end.
end procedure.

procedure cust_order_useindex:
    for each s2k.Customer where
        creditlimit >= 100 
        no-lock,
        each s2k.Order of s2k.Customer where
        orderdate = 12/23/2011
            no-lock
            use-index custorder :

        /* create report */
        run CreateReport.
    end.
end procedure.


procedure CreateReport:
    
    numRecs = numRecs + 1.
/*
  put unformatted 
      Order.Order-num order-date.
  */        
end procedure.