 
 /*------------------------------------------------------------------------
    File        : perf_workshopHandler
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Administrator
    Created     : Thu Jun 16 16:59:53 UTC 2016
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.Web.WebResponseWriter.
USING OpenEdge.Net.HTTP.StatusCodeEnum.
USING OpenEdge.Web.WebHandler.


CLASS perf_workshopHandler INHERITS WebHandler: 

	
		
	/*------------------------------------------------------------------------------
            Purpose: Handler for unsupported methods. The request being serviced and
            		 an optional status code is returned. A zero or null value means 
            		 this method will deal with all errors.                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	METHOD OVERRIDE PROTECTED INTEGER HandleNotAllowedMethod( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
	
		/* Throwing an error from this method results in a 500/Internal Server Error response. 
        The web handler will attempt to log this exception.
 	    
        See the HandleGet method's comments on choosing a value to return from this method. */
        	
		UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
	END METHOD.


	/*------------------------------------------------------------------------------
            Purpose: Handler for unknown methods. The request being serviced and an 
                     optional status code is returned. A zero or null value means 
                     this method will deal with all errors.                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	METHOD OVERRIDE PROTECTED INTEGER HandleNotImplemented( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
	
		/* Throwing an error from this method results in a 500/Internal Server Error response. 
        The web handler will attempt to log this exception.
 	    
        See the HandleGet method's comments on choosing a value to return from this method. */	
		UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
   	END METHOD.
 	
	
	/*------------------------------------------------------------------------------
            Purpose: Default handler for the HTTP GET method. The request being 
                     serviced and an optional status code is returned. A zero or 
                     null value means this method will deal with all errors.                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
 	METHOD OVERRIDE PROTECTED INTEGER HandleGet( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
 	
	
		DEFINE VARIABLE oResponse AS OpenEdge.Net.HTTP.IHttpResponse NO-UNDO.
        DEFINE VARIABLE oWriter   AS OpenEdge.Web.WebResponseWriter  NO-UNDO.
        DEFINE VARIABLE oBody     AS OpenEdge.Core.String            NO-UNDO.
            
        /* The WebResponse body is a wrapper around an entire HTTP response message.
           It contains a status code and reason; headers; cookies and a message body.
           
           API-level doc for this and related classes can be found at
           https://documentation.progress.com/output/oehttpclient/      */
        ASSIGN 
            oResponse            = NEW OpenEdge.Web.WebResponse()
            oResponse:StatusCode = INTEGER(StatusCodeEnum:OK)
            .
        /* This body object can be a string or something else (JsonObject for instance) */               
        ASSIGN 
            oBody = NEW OpenEdge.Core.String(
                             'Hello Administrator'
                           + '~r~n':u   /*CRLF */
                           + 'This message was returned by HandleGet in perf_workshopHandler.'
                           ).
        
        ASSIGN 
            oResponse:Entity        = oBody
            /* HTTP messages require a content type */
            oResponse:ContentType   = 'text/plain':u
            /* ContentLength is good too */
            oResponse:ContentLength = oBody:Size
            .
        
        /* The WebResponseWriter ensures that the status line and
           all headers are writted out before the message body/entity. */
        ASSIGN 
            oWriter = NEW WebResponseWriter(oResponse).
        oWriter:Open().
        
        /** HTTP MESSAGE ENTITY APPROACH **/
        /* The Progress.IO.OutputStream Write() methods take multiple overloads, for 
           a variety of data types. See the doc for more information. */
        oWriter:Write(oBody:Value).
        
        /* Finish writing the response message */
        oWriter:Close().
        
        /* A response of 0 means that this handler will build the entire response;
           a non-zero value is mapped to a static handler in the webapp's /static/error folder.
           The mappings are maintained in the webapps's WEB-INF/web.xml 
           A predefined set of HTTP status codes is provided in the OpenEdge.Net.HTTP.StatusCodeEnum 
           enumeration */
        RETURN 0.
		
 	END METHOD. 
 	
 	
   	
	
END CLASS.