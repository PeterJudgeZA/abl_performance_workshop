
/*------------------------------------------------------------------------
    File        : lab1c.p
    Purpose     :  Find all the orders of customers that come from a state that
                   begins with the letter "N" and was shipped using UPS.

    Syntax      :

    Description : 

    Author(s)   : Paul Koufalis
    Created     : Thu Jun 23 03:42:08 UTC 2016
    Notes       : Fix my lazy code! 
                  This query reads: 41K orders and 83 customers 
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
def var cntCust  as int init 0.
def var cntOrd   as int init 0.

run logmgr.p.


// Table reads: 41K ORDER, 83 Customer
// Index reads: 39K order.cust-Order, 84 customer.cust-num


for each customer no-lock where country NE "USA":
  assign cntCust = cntCust + 1.
  
  for each order no-lock where order.cust-num = customer.cust-num
                           and (sales-rep = "AAA" or sales-rep = "BBB")
                           and (carrier = "UPS" or carrier = "FEDEX").
                           
    assign cntOrd = cntOrd + 1.
  end.                              
end.

displ cntCust cntOrd.


