
/*------------------------------------------------------------------------
    File        : logmgr.p
    Purpose     : Enable LOG-MANAGER logging

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Thu Jun 23 00:52:03 UTC 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

  assign log-manager:logfile-name    = "C:\abl_performance_workshop\log\wshop.log"
         log-manager:logging-level   = 3
         log-manager:log-entry-types = "4GLTrace,4GLTrans,QryInfo".