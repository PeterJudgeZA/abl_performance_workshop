/* profdefs.i
 *
 * ok, ok so there's a bunch of "new global shared" stuff in here...
 *
 */

&IF DEFINED(profdefs) &THEN

/** skipping the definitions **/

&ELSE

/** definitions **/

&GLOBAL-DEFINE profdefs "yes"

define new global shared variable prof-state as logical no-undo.
define new global shared variable prof-desc  as character format "x(50)" no-undo.
define new global shared variable prof-file  as character format "x(50)" no-undo initial "profile".

define new global shared temp-table profile
  field id as integer format ">,>>9"
  field pdate as date format "99/99/99"
  field description as character format "x(30)"
  index profile-idx is unique primary id
  index profile-date pdate.

define new global shared temp-table source
  field id as integer format ">,>>9"
  field pid as integer format ">>,>>9"
  field pname as character format "x(40)"
  field debug_name as character format "x(40)"
  index source-idx is unique primary id pid
  index source-name pname.

define new global shared temp-table tree
  field id as integer format ">,>>9"
  field caller as integer format ">>,>>9"
  field src_line as integer format ">>,>>9"
  field callee as integer format ">>,>>9"
  field call_count as integer format ">>,>>9"
  index tree-idx is primary id caller src_line callee.

define new global shared temp-table ptime
  field id as integer format ">,>>9"
  field pid as integer format ">>,>>9"
  field src_line as integer format ">>,>>9"
  field exec_count as integer format ">>,>>>,>>9"
  field exe_time as decimal format ">>,>>9.999999"
  field tot_time as decimal format ">>,>>9.999999"
  field avg_time as decimal format ">>,>>9.999999"
  index ptime-idx is unique primary id pid src_line
  index avg-idx avg_time descending
  index line-idx src_line
  index ptime-pid-t1 id pid exe_time
  index ptime-pid-t3 id pid avg_time
  index ptime-t1 id exe_time
  index ptime-t3 id avg_time.

define new global shared temp-table bad_line
  field src_line as integer format ">>>>9"
  field pname    as character format "x(40)"
  field t1       as decimal format ">>,>>9.999999"
  field t2       as integer format ">>,>>>,>>9"
  field t3       as integer format ">>9"
  field t4       as decimal format ">>,>>9.999999"
  index bad-idx1 is unique primary
    pname src_line
  index bad-idx2
    t2 t3
  index bad-idx3
    t1
  index avg-idx
    t4.

&ENDIF

/* end profdefs.i */
