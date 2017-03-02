/*------------------------------------------------------------------------
    File        : fetch_customer_data.p
    Purpose     : Gets a dataset full of customers 
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.Json.ObjectModel.JsonObject from propath.

/* ***************************  Definitions  ************************** */
define input parameter poBE as BE.Customer.
define input parameter pcFilter as character.
define output parameter poData as JsonObject no-undo.
    
/* ***************************  Main Block  *************************** */
define variable hDataset as handle no-undo.

poBE:ReadData(pcFilter, output dataset-handle hDataset).

poData = new JsonObject().
poData:Read(hDataset).
poData:Add('handle', hDataset:handle ).        

finally:
    delete object hDataset.
end finally.
/* eof */