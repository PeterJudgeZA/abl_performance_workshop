def var x as int.
def var cntCust as int.
def var cntOrd as int.

// LAB 1C
def var cList as char.
def var cNotList as char.

for each order no-lock where (sales-rep = "AAA" and carrier = "UPS")
                          or (sales-rep = "AAA" and carrier = "FEDEX")
                          or (sales-rep = "BBB" and carrier = "UPS")
                          or (sales-rep = "BBB" and carrier = "FEDEX")
                          :

  if lookup(string(order.cust-num),cNotList) NE 0 then next.

  if lookup(string(order.cust-num),cList) = 0 then
  do:
    find customer no-lock where customer.cust-num = order.cust-num 
                          no-error.
    if not available customer then next.
    if customer.country = "USA" then 
    do:
      Assign cNotList = cNotList + string(customer.cust-num) + ",".
      next.
    end.

    Assign cList = cList + string(customer.cust-num) + ",".
  end.
  //pause.
                           
  assign cntOrd = cntOrd + 1
         .
end.                     

displ cntCust cntOrd.
