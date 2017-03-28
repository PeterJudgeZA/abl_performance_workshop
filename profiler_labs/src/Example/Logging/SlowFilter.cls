/*------------------------------------------------------------------------
    File        : SlowFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 16 11:33:33 EDT 2017
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.

class Example.Logging.SlowFilter implements ILoggerFilter:
    define static public property LOCAL_COUNTRY as character no-undo init 'GB':u get.
    
    method public void ExecuteFilter( input poEvent as LogEvent ):
        define variable sessionDateFormat as character no-undo.
        
        assign sessionDateFormat = session:date-format
               
               // write logfiles in the localised format
               session:date-format = GetLocalDateFormat()
               
               poEvent:Message:Message = '[' + string(today) + '] ' + poEvent:Message:Message
               .
        finally:
            assign session:date-format = sessionDateFormat.
        end finally.
    end method.
    
    method private character GetLocalDateFormat():
        define variable countryCode as character no-undo.
        define variable countryName as character extent no-undo.
        define variable jsonData as JsonArray no-undo.
        define variable countryData as JsonObject no-undo.
        define variable loop as integer no-undo.
        define variable max as integer no-undo.
        
        assign countryCode = Example.Logging.SlowFilter:LOCAL_COUNTRY.
        
        find LocalDefault where 
             LocalDefault.Country eq countryCode 
             no-error.
        if not available LocalDefault then
        do stop-after 2:
            assign jsonData = cast(new ObjectModelParser():ParseFile('country_list.json'), JsonArray)
                   max      = jsonData:Length
                   .
            //do loop = 1 to max
            do loop = jsonData:Length to 1 by -1
               while not available LocalDefault:
                   
                assign countryData = jsonData:GetJsonObject(loop).
                                                      
                find LocalDefault where
                     LocalDefault.Country eq countryData:GetCharacter('Name') 
                     no-lock no-error.
            end.
        end.
        
        if available LocalDefault then
            return LocalDefault.DateFormat. 
        else
            return session:date-format.
    end method.
    
    method private character GetLocalDateFormat2():
        define variable countryCode as character no-undo.
        define variable countryName as character no-undo.
        
        assign countryCode = Example.Logging.SlowFilter:LOCAL_COUNTRY.
        
        find LocalDefault where 
             LocalDefault.Country eq countryCode 
             no-error.
        if not available LocalDefault then
        do stop-after 2:
            input from 'country_list.csv':u.
            
            repeat while not available LocalDefault:
                import delimiter ',':u
                    countryName
                    countryCode
                    .
                find LocalDefault where
                     LocalDefault.Country eq countryName 
                     no-lock no-error.
            end.
        end.
        
        etime(yes).
        repeat while etime le 200:
        end.
        
        if available LocalDefault then
            return LocalDefault.DateFormat. 
        else
            return session:date-format.
    end method.
end class.