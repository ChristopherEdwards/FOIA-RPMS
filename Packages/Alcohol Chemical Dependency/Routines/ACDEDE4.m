ACDEDE4 ;IHS/ADC/EDE/KML - DOCUMENTATION FOR V4;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
60 ;Routines added/edited since v4.0 sent to verifier:
 ;
 ; Added ^ACDGMRG, ^ACDGSAVE
 ; Deleted ^ACDV4FD2, ^ACDV4FD3, ^ACDV4FD4
 ; Changed ^ACDEDE4, ^ACDPCCL*, ^ACDAUTO1, ^ACDAUTO3, ACDNOTE
 ;         ^ACDPVDSP, ^ACDDEU
 ;         ^XBPFTV
 ;
61 ;Dictionaries added/edited since v4.0 sent to verifier:
 ;
 ; 9002173 CDMIS PROGRAM - deleted all fields except .01 and 1100
 ;   series.  This will require a post init when it is distributed.
 ;
62 ;Templates added/edited since v4.0 sent to verifier:
 ;
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
63 ;PSG meeting in Albuquerque the week of May 22.
 ;
64 ;Deleted 52 RELAPSE and 54 UNLISTED PROBLEM iaw PSG.
 ;
65 ;Modified ^XBPFTV to return IEN if pointed to entry doesn't exist.
 ;
66 ;Deleted CDMIS GLOSSARY file, option, and routine iaw PSG.
 ;
67 ;Made DIFFERENCE REASON required when asked iaw PSG.
 ;
68 ;No longer loop on patient for IN, TD, RE iaw PSG.
 ;
69 ;Only provide option to add new patients or edit old patients for
 ;CDMIS CLIENT CATEGORY when editing an existing entry.
 ;
70 ;Changed edit mode visit date to a screened lookup so ?? will get
 ;all visits that match.
 ;
71 ;Added CREATED BY USER to CDMIS VISIT and CDMIS CLIENT SVCS and
 ;stuffed DUZ.  PCC has no user editing field.
 ;
72 ;Wrote ^ACDVFIX  to set missing SEX in CDMIS VISIT records.
 ;
73 ;Had note from PSG meeting about 'sorry editing visit' when locked.
 ;It already has an incremental lock that says that. ?????
 ;
74 ;Changed CDMIS VISIT HISTORY so it lists complete history with client
 ;svcs when going to a printer.  Otherwise it lists one screen of
 ;visits only, in reverse date order.
 ;
75 ;Modified ^ACDCS which edits a GRP or CLIENT CATEGORY to not ask
 ;edit question when adding a new group.
 ;
76 ;Have PSG note about asking hours on initial.  It already does that
 ;here.
 ;
77 ;Have PSG note to look at LOC/TYPE default when SCHOOL.  Problem
 ;only occurs on SCHOOL  because there are several entries that begin
 ;with word SCHOOL.  Left it as is.
 ;
78 ;Have PSG note about PRIMARY PROVIDER question not being appropriate
 ;for client services.  Leaving it because that conflicts with info
 ;I got here.  Will address it later.
 ;
79 ;Have PSG note about DAY: question after coming back from a copy
 ;set.  I left it for now.  Will look at it again later.
 ;
80 ;Have PSG  note about a pause after 'ADD 2 SVC' then on next line
 ;'GRP'.  Left as is because I don't know what it is about.
 ;
81 ;Have PSG note to say visit extracted when attempt to select it
 ;for editing.  What it does not is just not show it to you because
 ;I use a DIC("S") screen.  Left it alone because if I showed it and
 ;then said you couldn't edit it if you selected it I would get
 ;complaints about that too.  Much more reasonable complaints too.
 ;
82 ;Have PSG note that says 'INTERVENTIONS ADD PATIENTS ON FLY' and
 ;I have it marked out so I assume I made the change but I can't
 ;imagine what that is about.
 ;
83 ;Have PSG note 'PAUSE WHEN ADDING'.  Don't know what that is about.
 ;
84 ;Per Wilbur removed demographic change portion of data entry.  Still
 ;stores demo data in CDMIS visit though.
 ;
