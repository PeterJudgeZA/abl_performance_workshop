// LAB 1B

def var StList as char extent 2 format "x(60)".
def var x as int.
def var cntCust as int.
def var cntOrd as int.

for each state no-lock where state-name begins "N":
 assign stList[1] = stList[1] + state + ","
        stList[2] = stList[2] + state-name + ",".

end.

displ stList[1] stList[2].
for each customer no-lock:
  x = lookup(customer.state,stList[1] ).
  
//  displ customer.state lookup(customer.state,stList[1]).
  if x = 0 then next.
  if substring(entry(x,stList[2]),1,1) NE "N" then next.
  
  Assign cntCust = cntCust + 1.
  for each order no-lock where order.cust-num = cust.cust-num
                         //and order.sales-rep = "XXX"
                         //and carrier = "UPS"
                         //use-index cust-order
                         :

     if order.carrier NE "UPS" then next.						 
     assign cntOrd = cntOrd + 1.
      
     //displ order.order-num format ">>>>>>9" order.cust-num 
    //      customer.cust-num customer.state sales-rep.

  end.

end.
displ cntCust cntOrd.

