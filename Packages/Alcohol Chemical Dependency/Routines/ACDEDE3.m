ACDEDE3 ;IHS/ADC/EDE/KML - DOCUMENTATION FOR V4;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
41 ;Made corrections recommended by verifier.  Modified all ^DIE calls
 ;to use DIE^ACDFMC which does locks, with the exception of the ^DIE
 ;calls that file shift from the CDMIS PROGRAM file.
 ;
42 ;Ran SAC checker on all ACD routines.  Made appropriate changes
 ;based on SAC checker.
 ;
43 ;Ran ^DIFROM and gave package to Al to test locally and sent it to
 ;the verifier in Albuquerque.
 ;
44 ;Discussed PCC link/billing with Joy Bradbury and Teresa Stevens.  My
 ;current plan is to generate a V POV of 'chemical dependency ???' and
 ;a V PROCEDURE for each client service provided.
 ;
45 ;Routines changed after sending v4 to verification:
 ; ^ACDBILL, ^ACDDE3, ^ACDDE3B, ^ACDDEM, ^ACDIIF, ^ACDDIK, ^ACDKILL,
 ; ^ACDPDA, ^ACDCSD, ^ACDFMC, ^ACDCINV2, ^ACDDE3A, ^ACDDE3C
 ; ^ACDV4FD*, ^ACDAUTO3
 ; ^ACDPFACE, ^ACDPVDSP, ^ACDWCD1, ^ACDWCD2, ^ACDWCD4, ^ACDWCD60,
 ; ^ACDWCD70, ^ACDWCD80, ^ACDWTDC, ^ACDWVIS
 ;
46 ;Templates changed after sending v4 to verification:
 ; ACD VISIT EDIT attached to CDMIS VISIT
 ; ACD INIT/INFO/FU ADD attached to CDMIS VISIT
 ; ACD TRANS/DISC/CLOSE ADD attached to CDMIS VISIT
 ; ACD PREVENTION EDIT attached to CDMIS PREVENTION
 ;
47 ;Options changed/added after sending v4 to verification:
 ; ACD REPORT added ACD PRINT FACE SHEETS as an item
 ; ACD PRINT FACE SHEETS ..created it..
 ;
48 ;Dictionaries changed/added after sending v4 to verification:
 ; 9002171 CDMIS TRANS/DISC/CLOSE add field 29 HOURS & STATUS
 ; 9002170 CDMIS INIT/INFO/FU added description to STATUS
 ; 9002170.7 CDMIS PREVENTION made field #1 of multiple 5 an ID
 ;
49 ;Talked to Perry Richmond about Billing conversion problem.  Worked
 ;on routine ^ACDBILL to get it ready.
 ;
50 ;Met with Wilbur, Joy, and Al about various CDMIS issures.  We also
 ;met with Lori to discuss PCC link and using Mental Health system.
 ;
51 ;Made modifications to face sheet option to print a face sheet for
 ;an initial, reopen, or transfer/discharge/close.
 ;
52 ;Wilbur and I made the decsision to remove compound problems from
 ;the CDMIS problem list and make them multiple single problems.  This
 ;will require conversion logic in the pre/post inits.
 ;
53 ;Sent ACDBILL to Billings Area bilbao using uucp.  This was so Joy
 ;could get started checking out the data to be moved.
 ;
54 ;Added display/edit functionality to the option to add and edit
 ;prevention data.
 ;
55 ;Added HOURS to file 9002171 CDMIS TRANS/DISC/CLOSE and added the
 ;new field to the appropriate templates.
 ;
56 ;For input templates that use the staging tool I added a display of
 ;the average stage.
 ;
57 ;Wilbur and I made the decision to delete problem '8 DUAL DISORDER'
 ;and convert any entries pointing to it to two entries.  One to
 ;'1 ALCOHOL' and one to '8 MENTAL HEALTH NOL'.
 ;
58 ;Taking a lot of time to get CDMIS code to conform to IHS standards.
 ;I don't like having to change other peoples code.
 ;
59 ;Added INTENSIVE OUTPATIENT to CDMIS COMP file.  Per Wilbur for John R.
 ;Halfmoon.
