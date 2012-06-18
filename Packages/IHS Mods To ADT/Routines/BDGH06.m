BDGH06 ; IHS/ANMC/LJF - INTRO TEXT FOR INCOMPLETE CHART MENU ; 
 ;;5.3;PIMS;**1004**;MAY 28, 2004
 ;IHS/OIT/LJF 09/08/2005 PATCH 1004 added ICV and SET subroutines
 ;            09/22/2005 PATCH 1004 added NICE subroutine
 ;
 Q
 ;
CODE ;EP; intro text for Inpatient Chart Coding
 NEW BDGX
 S BDGX(1)="Use this option to code all inpatient charts. Any changes"
 S BDGX(2)="made to data stored in both ADT and PCC will be updated"
 S BDGX(3)="if the change is made in this option.  You may also view"
 S BDGX(4)="all In Hospital Visits for the date range of the inpatient"
 S BDGX(5)="stay, run the PCC edit check and print a final A Sheet."
 D DISPLAY(5)
 Q
 ;
ECD ;EP; intro text for Edit Chrt Deficiency List     
 NEW BDGX
 S BDGX(1)="Use this option to add, modify or inactivate any chart"
 S BDGX(2)="deficiency entries.  This file is maintained locally."
 D DISPLAY(2)
 Q
 ;
FVH ;EP; intro text for Fix V Hospitalization Entries
 NEW BDGX
 S BDGX(1)="Use this option to add v hospitalization and/or visit"
 S BDGX(2)="entries to admissions where those entries were not added"
 S BDGX(3)="automatically during admission and discharge.  These are"
 S BDGX(4)="entries that show up on the Coding Status Report as errors."
 D DISPLAY(4)
 Q
 ;
ICE ;EP; intro text for Incomplete Charts Edit
 NEW BDGX
 S BDGX(1)="Use this option to update all incomplete charts, both"
 S BDGX(2)="inpatients and day surgeries.  You can track deficiencies"
 S BDGX(3)="by provider and completion dates for different phases of"
 S BDGX(4)="the incomplete chart process.  Entries can no longer be"
 S BDGX(5)="deleted upon completion, just marked as completed.  For"
 S BDGX(6)="more information, see the IC Online help on this menu."
 D DISPLAY(6)
 Q
 ;
ICF ;EP; intro text for Incomplete Chart Forms
 NEW BDGX
 S BDGX(1)="Use this option to access the various printed forms used"
 S BDGX(2)="in the Incomplete Chart process.  See the on-line help"
 S BDGX(3)="for details on each form."
 D DISPLAY(3)
 Q
 ;
ICR ;EP; intro text for Incomplete Chart Reports
 NEW BDGX
 S BDGX(1)="Use this option to access the various ways of listing"
 S BDGX(2)="incomplete and delinquent charts.  See the on-line help"
 S BDGX(3)="for details on each report."
 D DISPLAY(3)
 Q
 ;
ICS ;EP; intro text for incomplete Chart Statistics
 NEW BDGX
 S BDGX(1)="Use this option to access all reports giving statistics"
 S BDGX(2)="on current and past incomplete/deliquent charts.  See"
 S BDGX(3)="the on-line help for details on each report."
 D DISPLAY(3)
 Q
 ;
ICV ;EP; intro text for Fix Visit in ICE   ;IHS/OIT/LJF 09/08/2005 PATCH 1004 added subroutine
 NEW BDGX
 S BDGX(1)="Use this option to fix the link between the incomplete"
 S BDGX(2)="chart record and the PCC visit.  You must know the visit date"
 S BDGX(3)="AND exact time.  If more than one visit at that date and time"
 S BDGX(4)="exists, make sure to select the one for your patient."
 D DISPLAY(4)
 Q
 ;
SET ;EP; intro text for Set UP IC Parameters  ;IHS/OIT/LJF 09/08/2005 PATCH 1004 added subroutine
 NEW BDGX
 S BDGX(1)="Use this option to set up and modify parameters dealing with"
 S BDGX(2)="how you use the Incomplete Chart module.  You can select"
 S BDGX(3)="which dates to use in tracking the process of your charts."
 D DISPLAY(3)
 Q
 ;
NICE ;EP; intro text for BDG IC EDIT NEW ;IHS/OIT/LJF 09/22/05 PATCH 1004
 NEW BDGX
 S BDGX(1)="Use this option in place of ICE for an easier way of updating"
 S BDGX(2)="information for incomplete charts.  You can now add and resolve"
 S BDGX(3)="many deficiencies for one provider very quickly."
 D DISPLAY(3)
 Q
 ;
DISPLAY(N) ; -- display array with N lines
 S BDGX(1,"F")="!!!?5"
 F I=2:1:N S BDGX(I,"F")="!?5"
 S BDGX(N+1,"F")="!!"
 D EN^DDIOL(.BDGX)
 D VAR^BDGVAR      ;makes all options able to run independently
 Q
