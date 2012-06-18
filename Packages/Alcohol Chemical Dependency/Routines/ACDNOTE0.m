ACDNOTE0 ;IHS/ADC/EDE/KML - NEW FEATURES IN VERSION 4 "COMPLETION";
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ;Auto duplication of a reopen or initial if user entered
 ;a tdc.
 ;
 ;Auto duplication of exact client service new entry with the
 ;visit and all attached clients service days being duplicated
 ;for other select patients decided upon by the software user.
 ;
 ;The secondary problem flat single field has been changed to
 ;other problems and made multiple for selection during data
 ;entry. This means the extract utilities have been re-worked
 ;to capture the new data form. This also means the import utilities
 ;have been re-worked to file the new multiple data as needed.
 ;This also means that the first item on this list (above) has
 ;been re-worked for the same reasons.
 ;
 ;The management reports will now report by tribe. Either a selected,
 ;all, or a category may be selected.
 ;
 ;A new tribe category file has been set up to accomplish the above
 ;mentioned task of tribe reports.
 ;
 ;The ACDVIS file has been changed to store the tribe code for
 ;any cdmis visit containing a client (i.e., NOT certain contact types
 ;not containing clients like 'brief').
 ;
 ;Data dictionaries for ^ACDIIF and ^ACDTDC have been changed to
 ;house the new multiple problem data field 'other problems'
 ;
 ;Routine ACDWVAR continues to be updated with new key variables
 ;and their descriptions of use.
 ;
 ;A new post init routine ACDPOST1 has been coded to convert
 ;field data bases with regards to secondary problems and their
 ;conversions to multiples (i.e., new field 'other problems').
 ;
 ;Routines ACDWIIF AND ACDTDC have been updated to capture the
 ;multiple problems and held in array ACDPTA. (see RTN ACDVAR)
 ;
 ;Reports 7 and 64 have been updated to function properly
 ;with the new multiple 'other problem' changes made
 ;and will now do the problem combination lists
 ;
 ;File ^ACDIIF has dd mods to allow 1-999 to be entered for some
 ;fields like days used alcohol or days hospitalized so the user
 ;will enter 999 for unknown answers. The reports 9,10,15,16 now
 ;check for the '999' value in relevant fields and when found, skips
 ;that record from reports.
 ;This was the best solution and did not want to change field dd's
 ;to not required.
 ;
 ;Global ^ACDPD has a new field into the 'day' multiple and it is called
 ;COMMUNITY EDUCATION. Routine ACDPDA has been changed to ask the
 ;user for this field during data entry for preventions.
 ;As of now the local variable ACDCOED contains the 'Y' or 'NO'
 ;reply to the new field but it is not printed anywhere on outputs.
 ;
 ;Headquarters may import their hq created extract (archive) (i.e.,
 ;they may read the HQ archives back into their system).
 ;
 ;Hours and Disposition added to data entry and data edit
 ;for 'Ot' Crisis Brief Int
 ;
 ;Client detail reports for 'Ot' and the staff reports updated
 ;to reflect the 'OT' hours and disposition.
 ;
 ;Invalid difference reasons are removed from the ^ACDIIF
 ;and ^ACDTDC globals if: an edit to the visit puts the
 ;actual/recommended placement (code & type) back the same.
 ;
 ;Intervention module built in cdmis. Add/Edit/Delete options.
 ;New file ^ACDINTV, routine ACDCINV,ACDWCINV
 ;
 ;Interventions are now purged with visit/prevention data
 ;
 ;client detail 107 in routine ^ACDWDRV3 has been coded for
 ;interventions
 ;
 ;CDMIS client category file now asks for all demographic
 ;data concerning patient. Auto duplicate on cs goes to this
 ;file now to get demographics, instead of ^DPT
 ;Templates to add/edit vist data now ask for all demographic
 ;data on a client
 ;
 ;New report 107 added to client service reporting menu
 ;
X ;
