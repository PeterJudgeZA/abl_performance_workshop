/*------------------------------------------------------------------------
   File        : FirstEntity
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : pjudge
   Created     : Mon Jun 13 15:18:01 EDT 2016
   Notes       : 
 ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.BusinessLogic.BusinessEntity.

class BE.Employee inherits BusinessEntity:
    
    define public property MaxRows as integer no-undo
        get.
        set.
     
    define temp-table ttEmployee 
        field EmpNum    as integer   label "Emp No"
        field LastName  as character label "Last Name"
        field FirstName as character label "First Name"
        field Birthdate as date      label "Birthdate"
        field StartDate as date      label "Start Date"
    
        /* used to return the MLE for the employee photo */
        field EmpPhoto  as character        
    
        index EmpNo is primary unique EmpNum   ascending 
        index Name LastName ascending FirstName ascending . 
    
    define dataset dsEmployee for ttEmployee.
    
    constructor public Employee():
        super(dataset dsEmployee:handle).
        // default 
        assign this-object:MaxRows = 20.
    end constructor.

    /* refrence only return value */
    method public handle ReturnDataset():
        OutputDataset(output dataset dsEmployee).
        
        return dataset dsEmployee:handle.
    end method.

    method public void OutputDataset(output dataset-handle phDataset):
        define variable iLoop as integer no-undo.
        
        phDataset = dataset dsEmployee:handle.

        do iLoop = 1 to this-object:MaxRows:
            create ttEmployee.
            assign ttEmployee.EmpNum = iLoop
                ttEmployee.LastName  = 'samson'
                ttEmployee.FirstName = 'sam, ' + chr(random(asc('A'), asc('Z')))
                ttEmployee.StartDate = add-interval(now, -32, 'months')
                ttEmployee.Birthdate = add-interval(now, -1 * random (27, 54), 'years')
                ttEmployee.EmpPhoto  = 'output dataset-handle phDataset'
                .
        end.
    end method.
        
    method public void OutputDataset(output dataset dsEmployee):
        define variable iLoop as integer no-undo.
        
        do iLoop = 1 to this-object:MaxRows:
            create ttEmployee.
            assign ttEmployee.EmpNum = iLoop
                ttEmployee.LastName  = 'Samson'
                ttEmployee.FirstName = 'Sam, ' + chr(random(asc('A'), asc('Z')))
                ttEmployee.StartDate = add-interval(now, -32, 'months')
                ttEmployee.Birthdate = add-interval(now, -1 * random (27, 54), 'years')
                ttEmployee.EmpPhoto  = 'output dataset dsEmployee'
                .
        end.
    end method.
    
    method public void InputDataset(input-output dataset dsEmployee):
        for each ttEmployee:
            assign ttEmployee.EmpNum = -1 * ttEmployee.EmpNum. 
        end.
    end method.

    method public void InputDataset(input-output dataset-handle phDataset):
        if not valid-handle(phDataset) then
        do:            
            assign phDataset = dataset dsEmployee:handle.
            OutputDataset(output dataset-handle phDataset).
        end.
        
        for each ttEmployee:
            assign ttEmployee.EmpNum = -1 * ttEmployee.EmpNum. 
        end.
    end method.
    
    method public void InputHandle(input-output phDataset as handle):
        define variable hBuffer as handle no-undo.
        define variable hQuery as handle no-undo.
        
        if not valid-handle(phDataset) then
            OutputDataset(output dataset-handle phDataset).
        
        hBuffer = phDataset:get-buffer-handle('ttEmployee').
        
        create query hQuery.
        hQuery:set-buffers(hBuffer).
        hQuery:query-prepare('for each ' + hBuffer:name).
        
        hQuery:query-open().
        hQuery:get-first().
        
        do while not hQuery:query-off-end:
            assign hBuffer::EmpNum = -1 * hBuffer::EmpNum.
            hQuery:get-next().
        end.
        
        finally:
            if valid-handle(hQuery) then 
                hQuery:query-close() no-error.
            delete object hQuery no-error.                
        end finally.
    end method.
    
end class.