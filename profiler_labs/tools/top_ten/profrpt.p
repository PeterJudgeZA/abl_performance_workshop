/* profrpt.p
 *
 */

{profdefs.i}

define input parameter p_file as character no-undo.

for each profile exclusive-lock: delete profile. end.
for each source  exclusive-lock: delete source.  end.
for each tree    exclusive-lock: delete tree.    end.
for each ptime   exclusive-lock: delete ptime.   end.

if profiler:enabled and profiler:profiling then profiler:write-data().

run profload.p ( p_file + ".prf" ).	/* load the data */
run profproc.p.			/* process the collected data */
run topx.p ( p_file + ".rpt" ).	/* 1st to a file */

/***
display skip(2)
        "  Output is in " + p_file + ".rpt  " format "x(70)" skip
        skip(2)
  with frame prof-out
       overlay
       centered
       row 5.

pause.

hide frame prof-out.
  ***/

run topx.p ( "" ).			/* then to the screen */

return.
