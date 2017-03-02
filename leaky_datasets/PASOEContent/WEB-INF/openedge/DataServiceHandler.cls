/*------------------------------------------------------------------------
    File        : DataServiceHandler
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jun 15 13:53:25 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using BE.Customer from propath.
using BE.Employee from propath.
using OpenEdge.BusinessLogic.BusinessEntity from propath.
using OpenEdge.Core.ByteBucket from propath.
using OpenEdge.Core.Session from propath.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter from propath.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterBuilder from propath.
using OpenEdge.Net.HTTP.IHttpResponse from propath.
using OpenEdge.Net.HTTP.StatusCodeEnum from propath.
using OpenEdge.Web.IWebRequest from propath.
using OpenEdge.Web.WebHandler from propath.
using OpenEdge.Web.WebResponse from propath.
using OpenEdge.Web.WebResponseWriter from propath.
using Progress.Json.ObjectModel.JsonArray from propath.
using Progress.Json.ObjectModel.JsonObject from propath.
using Progress.Lang.AppError from propath.
using Progress.Lang.Error from propath.

class DataServiceHandler inherits WebHandler:

    method override protected integer HandleNotAllowedMethod( input poRequest as OpenEdge.Web.IWebRequest ):
        return integer(StatusCodeEnum:MethodNotAllowed).
    end method.

    method override protected integer HandleNotImplemented( input poRequest as OpenEdge.Web.IWebRequest ):
        return integer(StatusCodeEnum:NotImplemented).
    end method.
    
    method override protected integer HandleGet( input poRequest as OpenEdge.Web.IWebRequest ):
        define variable iStartAt as integer no-undo.
        define variable oBody as JsonObject no-undo.
        define variable oData as JsonObject no-undo.
        define variable oResp as IHttpResponse no-undo.
        define variable cValue as character no-undo.
        define variable cOldTypes as character no-undo.
        define variable lDbg as logical no-undo. 
        define variable iMaxRows as integer no-undo.
        define variable oBE as BusinessEntity no-undo.
        define variable cMethod as character no-undo.
        define variable cEntity as character no-undo.
        define variable oDebug as JsonObject no-undo.
        define variable lShowStats as logical no-undo.
        define variable lErrStack as logical no-undo.
        
        assign oDebug = new JsonObject().
        
        cValue = poRequest:URI:getQueryValue('log').
        if cValue ne '' and cValue ne ? then
        do:
            oDebug:Add('logTypes', cValue).
            
            cOldTypes = log-manager:log-entry-types. 
            log-manager:log-entry-types = cValue.
            log-manager:write-message('LOGGING TYPES=: ' + cValue, 'DSH').
        end.
                 
        lShowStats  = logical(poRequest:URI:getQueryValue('stats')).
        if lShowStats then
        do:
            show-stats clear.
            oDebug:Add('showStats', true).
        end.
                 
        oResp = new WebResponse().
        oBody = new JsonObject().
        oResp:Entity = oBody.
        oResp:ContentType = 'application/json'.

        lDbg = logical(poRequest:URI:getQueryValue('dbg')).
        log-manager:write-message('DEBUG=' + string(lDbg), 'DSH').
    
        if lDbg then
        do:
            oBody:Add('dbg', oDebug).
            lErrStack = session:error-stack-trace. 
            session:error-stack-trace = true.
        end.
        
        oDebug:Add('sessionId', session:current-request-info:SessionId).
        oDebug:Add('numDSBefore', GetNumDatasets()).
        
        cEntity = poRequest:GetPathParameter('entity').
        oDebug:Add('entity', cEntity).
        
        cMethod = poRequest:GetPathParameter('method').
        iStartAt = mtime.
        case cEntity:
            when 'Employee' then
            do:
                oBE = new BE.Employee().

                iMaxRows = integer(poRequest:URI:getQueryValue('maxRows')).
                if iMaxRows ne ? then 
                    cast(oBE, Employee):MaxRows = iMaxRows.
                
                oDebug:Add('maxRows',    iMaxRows).
                oDebug:Add('methodName', cMethod).
                
                run fetch_employee_data.p (input cast(oBE, Employee), cMethod,
                                           output oData).
            end.
            
            when 'Customer' then
            do:
                oBE = new BE.Customer().
                cValue = poRequest:URI:getQueryValue('filter').
                if cValue eq ? then
                    cValue = ''. 
                oDebug:Add('filter', cValue).
                
                run fetch_customer_data.p (input cast(oBE, Customer), cValue,
                                           output oData).
            end. 
        end case.
        
        oDebug:Add('timeElapsed', mtime - iStartAt).
        
        oData:WriteFile(session:temp-dir + '/data_' + string(session:current-request-info:SessionId, '99999') + '.json', true).
        oBody:Add('data', oData).
        
        oDebug:Add('numDSAfter', GetNumDatasets()).
        
        WriteResponse(oResp).
        
        oDebug:WriteFile(session:temp-dir + '/request_' + string(session:current-request-info:SessionId, '99999') + '.json', true).
        
        return 0.
        finally:
            if lShowStats then
                show-stats.
            if cOldTypes ne log-manager:log-entry-types then 
                log-manager:log-entry-types = cOldTypes.
            
            session:error-stack-trace = lErrStack.
        end.
     end method.
     
     method private int GetNumDatasets():
         define variable hDS as handle no-undo.
         define variable i as integer no-undo.
         
         hDS = session:first-dataset.
         do while valid-handle(hDS):
             i = i + 1.
             hDS = hDS:next-sibling.
         end.
         
         return i.
    end method. 
     
    method private void WriteResponse(input poResp as IHttpResponse):
        define variable oWriter as WebResponseWriter no-undo.
        define variable oBytes as ByteBucket no-undo.
        define variable mEntity as memptr no-undo. 
                  
        /* dump to stream */
        oWriter = new WebResponseWriter(poResp).
        oWriter:Open().
        
        /* Convert from an image to bytes */
        if valid-object(poResp:Entity) then
        do on error undo, throw:         
            cast(poResp:Entity, JsonObject):Write(mEntity).

            poResp:ContentLength = get-size(mEntity).
            oWriter:Write(mEntity).
            finally:
                set-size(mEntity) = 0.
            end finally.
        end.
        
        oWriter:Close().
    end method.
    
    /* Handles an exception that has been raised while dealing with the request 
    
       @param Progress.Lang.Error The as-yet-unhandled exception
       @param IWebRequest The request that resulting in the exception
       @return integer A non-null status code use to deal with errors */
    method override protected integer HandleException(input poError as Progress.Lang.Error,
                                                      input poRequest as IWebRequest):
        define variable oResp as IHttpResponse no-undo.
        define variable oException as JsonObject no-undo.
        
        assign oResp = new WebResponse()
               oResp:StatusCode  = 500
               oResp:ContentType = 'application/json':u
               oException = WriteError(poError)
               oResp:Entity = oException.               
        oException:Add('req':u, substitute('&1 &2':u, poRequest:Method, poRequest:URI:Path)).
        
        WriteResponse(oResp).
        
        return 0.
    end method.
        
    method private JsonObject WriteError(input poError as Error):
        define variable oResponse as JsonObject no-undo.
        define variable oError as JsonObject no-undo.
        define variable oErrorList as JsonArray no-undo.
        define variable iLoop as integer no-undo.
        define variable cRetVal as character no-undo.
        define variable iMax as integer no-undo.

        assign oResponse  = new JsonObject()
               oError     = new JsonObject()
               oErrorList = new JsonArray().
        
        oResponse:Add('type':u, poError:GetClass():TypeName).
        oResponse:Add('origin':u, oErrorList).
        
        oErrorList:add(program-name(3)).
        if session:error-stack-trace then
            oErrorList:add(poError:CallStack).
        
        if type-of(poError, AppError) then
            oResponse:Add('retVal':u, cast(poError, AppError):ReturnValue).
        
        assign oErrorList = new JsonArray().
        oResponse:Add('err':u, oErrorList).
        do iLoop = 1 to poError:NumMessages:
            assign oError = new JsonObject().
            oErrorList:Add(oError).
            
            oError:Add('_errorMsg':u, poError:GetMessage(iLoop)).
            oError:Add('_errorNum':u, poError:GetMessageNum(iLoop)).
        end.
        
        oResponse:WriteFile(session:temp-dir + '/error_' + string(session:current-request-info:SessionId, '99999') + '.json', true).
        
        return oResponse.
    end method.

	method override protected integer HandleDelete( input poRequest as IWebRequest ):
        define variable iNumRec as integer no-undo.
        define variable oBody as JsonObject no-undo.
        define variable oData as JsonObject no-undo.
        define variable oArray as JsonArray no-undo.
        define variable oResp as IHttpResponse no-undo.
        define variable iLoop as integer no-undo.
        define variable hDS as handle no-undo.
        define variable hQuery as handle no-undo.
        
		if poRequest:PathInfo eq '/perf/clean' then
		do:
    		oResp = new WebResponse().
            oBody = new JsonObject().
            oResp:Entity = oBody.
            oResp:ContentType = 'application/json'.
            
            oArray = new JsonArray().
            oBody:Add('datasets', oArray).
            
            hDS = session:first-dataset.
            do while valid-handle(hDS)on error undo, throw:
                create query hQuery.
                hQuery:set-buffers(hDS:get-buffer-handle(1)).
                hQuery:query-prepare('preselect each ' + hDS:get-buffer-handle(1):name).
                hQuery:query-open().
                
                oData = new JsonObject().
                oArray:Add(oData).
                
                oData:Add('name', hDS:name).
                oData:Add('hdl', hDS:handle).
                oData:Add('numRec', hQuery:num-results).
                
                delete object hDS.
                hDS = session:first-dataset.
                
                finally:
                    hQuery:query-close().
                    delete object hQuery.
                end finally.
            end.
            
            WriteResponse(oResp).
	    end.
	    else
	       return HandleNotImplemented(poRequest).
        
		return 0.
	end method.
    
end class.