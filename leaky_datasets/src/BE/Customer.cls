/*------------------------------------------------------------------------
    File        : Customer
    Syntax      : 
    Author(s)   : pjudge
    Created     : Wed Jun 15 13:51:48 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.BusinessLogic.BusinessEntity.

class BE.Customer inherits BusinessEntity:
    define data-source srcCustomer for Customer.

	define temp-table eCustomer no-undo like Customer.
	
	define dataset dsCustomer for eCustomer. 
    
	/*------------------------------------------------------------------------------
            Purpose:                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    constructor public Customer():
    	
    	define var hDataSourceArray as handle no-undo extent 1.
        define var cSkipListArray as char no-undo extent 1.
        
        super (dataset dsCustomer:HANDLE).
        
        /* Data Source for each table in dataset. Should be in table order as defined 
     	   in DataSet */ 
        hDataSourceArray[1] =  data-source srcCustomer:HANDLE.

     	/* Skip-list entry for each table in dataset. Should be in temp-table order 
           as defined in DataSet */
        /* Each skip-list entry is a comma-separated list of field names, to be
 	       ignored in create stmt */
     	cSkipListArray[1] = 'custPDF'. 
     	
     	this-object:ProDataSource = hDataSourceArray.
        this-object:SkipList = cSkipListArray.
    end constructor.
    	
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void ReadData(input filter as character, output DATASET dsCustomer):
    	super:ReadData(filter).
    end method.
	  
    /*------------------------------------------------------------------------------
            Purpose: Create one or more new records                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void CreateCustomer(input-output DATASET dsCustomer):    		
    	       
        super:CreateData(DATASET dsCustomer by-reference).        
    end method.    
	
    /*------------------------------------------------------------------------------
            Purpose:  Update one or more records                                                                  
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void UpdateCustomer(input-output DATASET dsCustomer):    		
	
        super:UpdateData(DATASET dsCustomer by-reference).          
    end method.
	
    /*------------------------------------------------------------------------------
            Purpose:    Delete a record                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    method public void DeleteCustomer(input-output DATASET dsCustomer):     		       
	
        super:DeleteData(DATASET dsCustomer by-reference).
    end method.
	 
    method override protected void AttachDataSources():
        ValidateDataSources().
        
        define variable hCurBuffer as handle no-undo.
        define variable iIndex as integer no-undo.
           
        repeat iIndex = 1 to ProDataSet:num-buffers:
            hCurBuffer = ProDataSet:get-buffer-handle(iIndex).
            hCurBuffer:attach-data-source(ProDataSource[iIndex],?, this-object:SkipList[iIndex]).
        end.
    end method.
    
end class.
