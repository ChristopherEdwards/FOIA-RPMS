ACD4P1N ;IHS/ADC/EDE/KML - NOTES ON CHANGES FOR V4.1;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
START ;
 ;
 ;Albuquerque PSG meeting.
 ;^ACDFUL0, moved NEW.
 ;^ACDFUL2 - skipped deceased patients for followup report
 ;June Albq - Hardcopy didn't allow user to force HC even though
 ;  patient had no 3rd party coverage.  Works fine on tucdev.
 ;Removed .01 fields from add templates, including multiples.
 ;Checked follow-up report for Marty, NSRTC.  Six month begins
 ;  as of tdc date.
 ;Removed "Not an open component" message.  Didn't seem like it
 ;  was necessary.
 ;Modified cdmis visit edit template to allow date change.
 ;Hardcopy bill not printing on Lori's laptop - works fine on tucdev.
 ;Modified hardcopy bill to print 3rd party coverage.
 ;Added DVM option to list visits for 1 month, includes all CSs.
 ;Support call from Cherokee - they need to install patch.
 ;Support call from Oklahoma - repointed BWP to correct site.
 ;Modified entry of TDC to exit if patient moved, died, or refused
 ;  service.
 ;Add FT name field to CDMIS VISIT file for Crisis Brief (OT) type
 ;  visits.
 ;Changed CDMIS INTERVENTIONS field 1 CLIENTS NAME to FT from a
 ;  pointer.  Modified data entry routines and templates.
 ;Added patch level to menu header
 ;Added pharmacotherapy drug file and field in client svcs file
 ;  that is only asked when service provided is pharmacotherapy.
 ;  This file is laygo so new drugs can be added.
 ;Deleted tobacco from drug multiple and drug file.  Set values
 ;  in new tobacco field.
 ;Deleted previous treatment from other problems multiple and
 ;  from problem file.
 ;Removed DINUM from workload provider multiple of client svc
 ;  file.
 ;Fixed report 106.  Had left out ACDTGSUB so no data printed.
 ;Wrote provider workload report.
 ;Changed length of .02 field of 9002170 CDMIS INIT/INFO/FU file
 ;  from 40 to 100 per Wilbur.
 ;Did the same for 101 field of 9002171 CDMIS TRANS/DISC/CLOSE file.
 ;Added ALCOHOL to summary report for drug combinations.
 ;Added average length of stay by component code/type to summary
 ;  report.
 ;Added DUZ(0) check to ^ACD so user without M access cannot enter
 ;  menu.
 ;Added menu option to manage billing file; print bills, purg bills,
 ;  etc.
 ;Modified followup report to ignore all components except the last
 ;  component TDCed from.
 ;Added menu option to display patient CS history for one month
 ;  by provider.
 ;Added logic to ^ACDCLN to delete any entries in ^ACDCS that do
 ;  not have a 2nd piece.
 ;Added new option ACDMGR that includes ACDMENU and new option
 ;  ACDUNLOCK to unlock locked menus.  This is for the CDMS MGR.
 ;Added preventions to ascii flat file.
 ;Included file 3,6,16,200 conversion to postinit ^ACD4P1P
 ;Added new component of ASSESSMENT and CODEPENDENCY.
 ;Added new services of ASSESSMENT CODEPENDENCY, ASSESSMENT DUI,
 ;  ASSESSMENT OTHER
