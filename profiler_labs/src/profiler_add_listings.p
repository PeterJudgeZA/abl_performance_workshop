/*------------------------------------------------------------------------
    File        : profilter_add_listings.p
    Purpose     : Inserts COMPILE LISTING files from a known location into profiler output  
    Created     : 2017-03-20
    Notes       : * This assumes the files are in a nested directory structure (matching the module name()
                  * This assumes we only have .P or .CLS files (not .W or custom) 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.

/* ********************  Definitions  ******************** */
define variable inputFile as character no-undo.
define variable outputFile as character no-undo.
define variable listingDir as character no-undo.

define variable moduleName as character no-undo.
define variable CRCVal as integer no-undo.
define variable inputLine as character no-undo.
define variable oututLine as character no-undo.
define variable startPos as integer no-undo.
define variable endPos as integer no-undo.
define variable readModuleBlock as logical no-undo.

define stream strIn.
define stream strOut.

/* ***************************  Main Block  *************************** */
assign listingDir   = dynamic-function('getParameter':u in source-procedure, 'listingDir':u)
       inputFile    = dynamic-function('getParameter':u in source-procedure, 'inputFile':u)
       outputFile   = dynamic-function('getParameter':u in source-procedure, 'outputFile':u)
       
       readModuleBlock = true
       .

input stream strIn from value(inputFile).
output stream strOut to value(outputFile).

// Dump the first two lines as-is 
import stream strIn unformatted inputLine.
put stream strOut unformatted inputLine skip.

import stream strIn unformatted inputLine.
put stream strOut unformatted inputLine skip.

repeat:
    import stream strIn unformatted
        inputLine.
    
    if not readModuleBlock then
        put stream strOut unformatted
            inputLine
            skip.
    else
    do:
        if inputLine eq '.':u then
        do:
            assign readModuleBlock = false.
            
            put stream strOut unformatted
                inputLine
                skip.
            next.
        end.
        
        assign CRCVal = integer(entry(num-entries(inputLine, StringConstant:SPACE), inputLine, StringConstant:SPACE))
               .               
        if CRCVal gt 0 then
        do:
            assign startPos   = index(inputLine, StringConstant:DOUBLE_QUOTE)
                   endPos     = index(inputLine, StringConstant:DOUBLE_QUOTE, startPos + 1)
                   moduleName = substring(inputLine, startPos + 1, endPos - startPos - 1)
                   
                   // start end end pos for debug listing 
                   endPos   = r-index(inputLine, StringConstant:DOUBLE_QUOTE)
                   startPos = r-index(inputLine, StringConstant:DOUBLE_QUOTE, endPos - 1)
                   .
            
            put stream strOut unformatted
                substring(inputLine, 1, startPos)
                listingDir '/':u replace(moduleName, '.':u, '/':u) 
                
                (if index(moduleName, '.':u) eq 0 then '.p':u else '.cls':u)
                substring(inputLine, endPos)
                skip
                .
        end.
        else
            put stream strOut unformatted
                inputLine
                skip.
    end.    //module data 
end.

return '0':u.

catch e as Progress.Lang.Error :
    message e:GetMessage(1)
    view-as alert-box.
    return string(e:GetMessageNum(1)).
end catch.

finally:
    input stream strIn close.
    output stream strOut close.
end finally.
