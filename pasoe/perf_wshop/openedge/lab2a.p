
/*------------------------------------------------------------------------
    File        : lab2a.p
    Purpose     : Test CAN-FIND() limitations

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Thu Jun 23 06:59:43 UTC 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
def var cntOrder as int.
def var msg as char init "Hit spacebar in ProTop and note table and index reads".
def var vsr as char init "EEE".
def var vcar as char init "UPS".

run logmgr.p.

message "Hit spacebar in ProTop to zero counters" view-as alert-box. 

for first order no-lock where order-date = 08/20/2016 
                          and sales-rep = "EEE"
                          and carrier = "UPS"
                          //and ship-date = 12/15/2016
                          //and terms = "net120"
                          .

end.

message "After for first" msg view-as alert-box. 

if can-find(first  order where order-date = 08/20/2016 
                          and sales-rep = "EEE"
                          and carrier = "UPS"
                          // and ship-date = 12/15/2016
                          // and terms = "net120"
                          ) then 
  message "FOUND" msg view-as alert-box.
  else message "NOT FOUND" msg view-as alert-box.
  
