
/*------------------------------------------------------------------------
    File        : lab1b.p
    Purpose     :  Find all the orders of customers that come from a state that
                   begins with the letter "N" and was shipped using UPS.

    Syntax      :

    Description : 

    Author(s)   : Paul Koufalis
    Created     : Thu Jun 23 03:42:08 UTC 2016
    Notes       : Fix my lazy code! 
                  This query reads: 112K orders, 664 customers and 51 states 
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
def var cntState as int init 0.
def var cntCust  as int init 0.
def var cntOrd   as int init 0.

run logmgr.p.


// Table Reads: 112K ORDER, 664 Customer, 51 State
// Index Reads: 109K order.carrier-ship, 672 customer.cust-num, 51 state.state


for each state no-lock where state-name begins "N":
  Assign cntState = cntState + 1.
  
  for each customer no-lock where customer.state = state.state:
    Assign cntCust = cntCust + 1.
  
    for each order no-lock where order.cust-num = cust.cust-num
                             //and order.sales-rep = "XXX"
                             and carrier = "UPS"
                             :
      assign cntOrd = cntOrd + 1.
      
      //displ order.order-num format ">>>>>>9" order.cust-num 
      //      customer.cust-num customer.state sales-rep.

    end.
  
  end.
end.

displ cntState cntCust cntOrd.

