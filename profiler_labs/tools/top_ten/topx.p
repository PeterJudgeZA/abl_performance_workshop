/* topx.p
 *
 * identify the most expensive lines executed (globally)
 *
 * relatively fast
 *
 * sorts by total time per line
 *
 * december 23, 1997 */

{profdefs.i}

define input parameter p_file as character no-undo.

define variable c  as integer no-undo.
define variable i  as integer no-undo.
define variable t1 as decimal no-undo format ">>,>>9.999999".
define variable t2 as integer no-undo format ">>,>>>,>>9".
define variable t3 as integer no-undo format ">>9".

find first profile no-lock no-error.	/* assuming that they're all the same date... */

if p_file <> "" then
  output to value( p_file ).
 else
  pause before-hide.	/* helpful if this is going to a terminal... */

if p_file <> "" then
  display
    profile.description  label "Description" skip
    profile.pdate        label "Date" skip
    "Top Total Time Lines" skip
   with frame prof-hdr
     side-labels
     overlay
     row 1.

i = 0.

for each bad_line no-lock by bad_line.t1 descending:

  i = i + 1.

  display
    bad_line.pname    label "Program"
    bad_line.src_line label "Line"
    bad_line.t4       label "Avg Time"
    bad_line.t1       label "Time"
    bad_line.t2       label "Calls"
/*
    bad_line.t3       label "Sessions"
 */ 
  with frame prof-rpt
     width 132
     overlay
     down
     row 5.

  if i > 50 then leave.		/* after the 1st 50 there isn't (usually) much point... */

end.

if p_file <> "" then
  output close.
 else
  do:
    pause.
    hide all.
  end.

return.
