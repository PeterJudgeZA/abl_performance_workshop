/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : slow_http_call.p
    Purpose     : 
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.LoggerBuilder.

/* ********************  Preprocessor Definitions  ******************** */
define variable req as IHttpRequest no-undo.
define variable logger as ILogWriter no-undo.
define variable client as IHttpClient no-undo. 
define variable resp as IHttpResponse no-undo.

/* ***************************  Main Block  *************************** */
logger = LoggerBuilder:GetLogger('slow_http_call').
client = ClientBuilder:Build():Client.

req = RequestBuilder:Get('http://httpbin.org/delay/2')
        :Request.

logger:Info(substitute('Request URI: &1', req:URI:ToString())).
        
resp = client:Execute(req).   

logger:Info(substitute('Status code: &1', resp:StatusCode)).

message 
resp:StatusCode
view-as alert-box.

catch e as Progress.Lang.Error :
    logger:Error(substitute('Whoops!', e)).
    
    message  
        e:GetMessage(1) skip(2)
        e:CallStack
    view-as alert-box.
end catch.
