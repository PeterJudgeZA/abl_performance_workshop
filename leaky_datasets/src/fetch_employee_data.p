/*------------------------------------------------------------------------
    File        : fetch_employee_data.p
    Purpose     : Gets employee data in a variety of ways
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using BE.Employee from propath.
using Progress.Json.ObjectModel.JsonObject from propath.
using Progress.Lang.AppError from propath.

/* ***************************  Definitions  ************************** */
define input parameter poBE as Employee.
define input parameter pcMethodName as character.
define output parameter poData as JsonObject.
    
define variable hDataset as handle no-undo.

case pcMethodName:
    when 'InputDataset' then
        poBE:InputDataset(input-output dataset-handle hDataset).
        
    when 'InputHandle' then
        poBE:InputHandle (input-output hDataset).
    
    when 'OutputDataset' then
        poBE:OutputDataset(output dataset-handle hDataset).
        
    when 'ReturnDataset' then
        hDataset = poBE:ReturnDataset().
                
    otherwise
        undo, throw new AppError(substitute('unsupported method &1', pcMethodName), 0).                
end case.

poData = new JsonObject().
poData:Read(hDataset).
poData:Add('handle', hDataset:handle ).        


/* eof */