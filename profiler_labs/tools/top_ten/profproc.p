/* profproc.p
 *
 * organize the data and identify the most expensive lines executed
 *
 * december 23, 1997 */

{profdefs.i}

define variable c  as integer no-undo.
define variable i  as integer no-undo.
define variable t1 as decimal no-undo format ">>,>>9.999999".
define variable t2 as integer no-undo format ">>,>>>,>>9".
define variable t3 as integer no-undo format ">>9".

pause 0 before-hide.

for each bad_line: delete bad_line. end.

for each ptime no-lock by ptime.avg_time descending:     
  if exec_count < 1 or src_line = 0 then next.

  find source where
       source.id = ptime.id and
       source.pid = ptime.pid no-lock no-error.

  /* if source.pname begins "" then next. */ /* don't include the profiler */

  find bad_line where
    bad_line.pname = source.pname and
    bad_line.src_line = ptime.src_line no-lock no-error.

  if not available bad_line then
    do transaction:
      create bad_line.
      assign
        i = i + 1
        bad_line.pname = source.pname
        bad_line.src_line = ptime.src_line.
    end.

/*
  if i >= 100 then leave.
 */

end.

for each bad_line:

  assign
    bad_line.t1 = 0
    bad_line.t2 = 0.

  for
    each source where
      source.pname = bad_line.pname no-lock,
    each ptime where
      ptime.id = source.id and
      ptime.pid = source.pid and
      ptime.src_line = bad_line.src_line no-lock:      

    assign
      bad_line.t1 = bad_line.t1 + ptime.exe_time
      bad_line.t2 = bad_line.t2 + ptime.exec_count
      bad_line.t3 = bad_line.t3 + 1.

  end.

end.

for each bad_line:
  bad_line.t4 = ( bad_line.t1 / bad_line.t2 ).	/* calculate the average time... */
end.

return.
