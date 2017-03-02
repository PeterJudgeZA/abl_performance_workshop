
/*------------------------------------------------------------------------
    File        : scratch.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Thu Jun 23 02:22:07 UTC 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
run src/logmgr.p.
for each customer: 
    displ name. 
    pause 0 no-message.
end.