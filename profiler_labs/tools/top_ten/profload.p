/* profload.p
 *
 * load a profiling session
 *
 * september 10, 1997 */


&global-define	chunk	100

{profdefs.i}

define input parameter p_file as character no-undo.

define variable i   as integer no-undo.
define variable v   as integer no-undo.
define variable dt  as date no-undo.
define variable dsc as character no-undo.

define variable profile_id as integer no-undo.

for each profile: delete profile. end.
for each source:  delete source.  end.
for each tree:    delete tree.    end.
for each ptime:   delete ptime.   end.


if search( p_file ) = ? then
  do:
    message "Cannot find source file:" p_file.
    return.
  end.

/****************************************
input through value( 'grep "^.\$" ' + p_file + ' | wc -l' ).
import i.
input close. 


if i <> 7 then
  do:
    message "Invalid source file:" p_file.
    return.
  end.
**************************/

input from value( p_file ).

repeat:
  import v dt dsc.
end.

if v <> 1 then
  do:
    message "Invalid version:" v.
    return.
  end.

do for profile:
  find first profile where profile.pdate = dt and profile.description = dsc no-lock no-error.
  if available profile then
    do:
      message "A profile from" dt "with description" dsc "already exists.".
      return.
    end.
end.

pause 0 before-hide.

/* create the profile header record
 *
 */

/* */
message "loading header" p_file dt dsc.
pause.
/* */

load: do while true transaction:

  i = i + 1.

  repeat for profile
    while ( i modulo {&CHUNK} <> 0 )
    on endkey undo, leave load:
/*
    profile_id = next-value( profile ).
 */
    profile_id = profile_id + 1.

    create profile.
    assign
      profile.id          = profile_id
      profile.pdate       = dt
      profile.description = dsc
      i = i + 1.

    leave load.

  end.
end.

/* read in all the source information
 *
 */

/* */
message "loading source".
pause.
/* */

i = 0.

load: do while true transaction:

  i = i + 1.

  repeat for source
    while ( i modulo {&CHUNK} <> 0 )
    on endkey undo, leave load:

    create source.
    source.id = profile_id.
    import source.pid source.pname source.debug_name.
    if i modulo 10 = 0 then message "loading source" i.
    i = i + 1.

  end.

end.

message "Loaded" i "records".
/* read in all the call tree information
 *
 */

/* */
message "loading call tree".
pause.
/*  */

i = 0.

load: do while true transaction:

  i = i + 1.

  repeat for tree
    while ( i modulo {&CHUNK} <> 0 )
    on endkey undo, leave load:

    create tree.
    tree.id = profile_id.
    import tree.caller tree.src_line tree.callee tree.call_count.
    if i modulo 100 = 0 then message "loading call tree" i.
    i = i + 1.

  end.
end.

/* read in all the profile timing information
 *
 */

/*
message "loading profile timings".
pause.
 */

i = 0.

load: do while true transaction:

  i = i + 1.

  repeat for ptime
    while ( i modulo {&CHUNK} <> 0 )
    on endkey undo, leave load:

    create ptime.
    ptime.id = profile_id.
    import ptime.pid ptime.src_line ptime.exec_count ptime.exe_time ptime.tot_time.
    ptime.avg_time = ptime.exe_time / ptime.exec_count.
    if i modulo 100 = 0 then message "loading profile timings" i.
    i = i + 1.

  end.
end.

hide message no-pause.

return.
