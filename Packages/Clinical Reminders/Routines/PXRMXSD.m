PXRMXSD ; SLC/PJH - Reminder Reports DIR Prompts;26-Jan-2006 16:32;MGH
 ;;1.5;CLINICAL REMINDERS;**6,1004**;Jun 19, 2000
 ;Called by PXRMXD
 ;IHS/CIA/MGH Modifed to use HRCN instead of SSN
 ;
BED(YESNO) ;Option to sort by inpatient location and bed
 N X,Y,TEXT,DIR
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="YA0"
 S DIR("A")="Sort by Inpatient Location/Bed: "
 S DIR("B")="N"
 S DIR("?")="Enter Y or N. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMXSD(11)"
 W !
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S YESNO=$E(Y(0))
 I YESNO="Y" S YESNO="B"
 Q
 ;
COMB(YESNO,LIT,DEF) ;Option to combine report
 N X,Y,DIR,TEXT
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="YA0"
 S DIR("A")="Combined report for all "_LIT_" : "
 S DIR("B")=DEF
 S DIR("?")="Enter Y or N. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMXSD(9)"
 W !
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S YESNO=$E(Y(0))
 Q
 ;
FUTURE(YESNO) ;Option to display all future appointments on detail report
 N X,Y,DIR,TEXT
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="YA0"
 S DIR("A")="Display All Future Appointments: "
 S DIR("B")="N"
 S DIR("?")="Enter Y or N. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMXSD(5)"
 W !
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S YESNO=$E(Y(0))
 Q
 ;
PREV(TYPE) ;Future Appts/Prior Encounters selection
 N X,Y,DIR
 S NREM=0
 K DIROUT,DIRUT,DTOUT,DUOUT
 I 'PXRMINP D
 .S DIR(0)="S"_U_"P:Previous Encounters;"
 .S DIR(0)=DIR(0)_"F:Future Appointments;"
 .S DIR("A")="PREVIOUS ENCOUNTERS OR FUTURE APPOINTMENTS"
 .S DIR("B")="P"
 .S DIR("??")=U_"D HELP^PXRMXSD(3)"
 I PXRMINP D
 .S DIR(0)="S"_U_"A:Admissions to Location in date range;"
 .S DIR(0)=DIR(0)_"C:Current Inpatients;"
 .S DIR("A")="CURRENT INPATIENTS OR ADMISSIONS"
 .S DIR("B")="C"
 .S DIR("??")=U_"D HELP^PXRMXSD(7)"
 S DIR("?")="Select from the codes displayed. For detailed help type ??"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S TYPE=Y
 Q
 ;
PRIME(TYPE) ;Primary Provider patients only or All
 N X,Y,DIR
 S NREM=0
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="S"_U_"P:Primary care assigned patients only;"
 S DIR(0)=DIR(0)_"A:All patients on list;"
 S DIR("A")="PRIMARY CARE ONLY OR ALL"
 S DIR("B")="P"
 S DIR("?")="Select from the codes displayed. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMXSD(4)"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S TYPE=Y
 Q
 ;
REP(TYPE) ;Report type selection
 N X,Y,DIR
 S NREM=0
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="S"_U_"D:Detailed;"
 S DIR(0)=DIR(0)_"S:Summary;"
 S DIR("A")="TYPE OF REPORT"
 S DIR("B")="S"
 I PXRMSEL="I" S DIR("B")="D"
 S DIR("?")="Select from the codes displayed. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMXSD(2)"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S TYPE=Y
 Q
 ;
SELECT(TYPE) ;Patient Sample Selection
 N X,Y,DIR
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="S"_U_"I:Individual Patient;"
 S DIR(0)=DIR(0)_"L:Location;"
 S DIR(0)=DIR(0)_"O:OE/RR Team;"
 S DIR(0)=DIR(0)_"P:PCMM Provider;"
 S DIR(0)=DIR(0)_"T:PCMM Team;"
 S DIR(0)=DIR(0)_"D:Designated Provider;"
 S DIR("A")="PATIENT SAMPLE"
 S DIR("B")="L"
 S DIR("?")="Select from the codes displayed. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMXSD(1)"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S TYPE=Y
 Q
 ;
SRT(YESNO) ;Option to sort by next appointment date on detail report
 N X,Y,TEXT,DIR
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="YA0"
 S DIR("A")="Sort by Next Appointment date: "
 S DIR("B")="N"
 S DIR("?")="Enter Y or N. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMXSD(6)"
 W !
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S YESNO=$E(Y(0))
 Q
 ;
SSN(YESNO) ;Option to combine multifacility report
 N X,Y,DIR,TEXT
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="YA0"
 ;IHS/CIA/MGH Modified to print HRCN and to use health record numer
 S DIR("A")="Print full HRCN: "
 I $P($G(^PXRM(800,1,"FULL SSN")),U)="Y" S DIR("B")="Y"
 E  S DIR("B")="N"
 S DIR("?")="Enter Y or N. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMXSD(12)"
 W !
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S YESNO=$E(Y(0))
 Q
 ;
TABS(YESNO) ;Option print compressed report
 N X,Y,DIR,TEXT
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="YA0"
 S DIR("A")="Print Delimiter Separated output only: "
 S DIR("B")="N"
 S DIR("?")="Enter Y or N. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMXSD(13)"
 W !
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S YESNO=$E(Y(0))
 Q
 ;
TABSEL(TYPE) ;Select DELIMITER CHARACTER
 N X,Y,DIR
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="S"_U_"C:Comma;"
 S DIR(0)=DIR(0)_"M:Semicolon;"
 S DIR(0)=DIR(0)_"S:Space;"
 S DIR(0)=DIR(0)_"T:Tab;"
 S DIR(0)=DIR(0)_"U:Up arrow;"
 S DIR("A")="Specify REPORT DELIMITER CHARACTER"
 S DIR("B")="U"
 S DIR("?")="Select from the codes displayed. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMXSD(14)"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S TYPE=Y
 Q
 ;
TOTALS(TYPE,LIT1,LIT2,LIT3) ;Totals Selection
 N X,Y,DIR
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="S"_U_"I:"_LIT1_";"
 S DIR(0)=DIR(0)_"R:"_LIT2_";"
 S DIR(0)=DIR(0)_"T:"_LIT3_";"
 S DIR("A")="REPORT TOTALS"
 S DIR("B")="I"
 S DIR("?")="Select from the codes displayed. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMXSD(10)"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S TYPE=Y
 Q
 ;
HELP(CALL) ;General help text routine
 N HTEXT
 N DIWF,DIWL,DIWR,IC
 S DIWF="C70",DIWL=0,DIWR=70
 ;
 I CALL=1 D
 .S HTEXT(1)="Summary reports total the number of reminders applicable "
 .S HTEXT(2)="and due for the above patient samples."
 .S HTEXT(3)="Detailed reports list patients with reminders due in "
 .S HTEXT(4)="name order or by appointment date."
 I CALL=2 D
 .S HTEXT(1)="DETAILED reports list in alpha order patients in the"
 .S HTEXT(2)="selected patient sample with reminders due."
 .S HTEXT(3)="SUMMARY reports give totals of reminders due for the"
 .S HTEXT(4)="selected patient sample."
 I CALL=3 D
 .S HTEXT(1)="PREVIOUS will report on patients who visited the selected"
 .S HTEXT(2)="locations in the date range specified"
 .S HTEXT(3)="FUTURE will report on patients who have appointments at"
 .S HTEXT(4)="selected locations in the date range specified."
 I CALL=4 D
 .S HTEXT(1)="PRIMARY CARE ONLY excludes patients who are not assigned"
 .S HTEXT(2)="to the PCMM team as primary care."
 I CALL=5 D
 .S HTEXT(1)="Selecting Y will display all future appointments for"
 .S HTEXT(2)="patients with reminders due. Selecting N will display"
 .S HTEXT(3)="for patients with due reminders only the next appointment"
 .I PXRMSEL="L" D
 ..S HTEXT(4)="AT THE SELECTED LOCATION"
 I CALL=6 D
 .S HTEXT(1)="Selecting Y will display patients with reminders in"
 .S HTEXT(2)="appointment date order. Selecting N will display patients"
 .S HTEXT(3)="with reminders in patient name order."
 I CALL=7 D
 .S HTEXT(1)="ADMISSIONS will report on inpatients admitted in the"
 .S HTEXT(2)="selected locations in the date range specified. "
 .S HTEXT(3)="CURRENT INPATIENTS will report on inpatients currently at"
 .S HTEXT(4)="selected locations."
 I CALL=8 D
 .S HTEXT(1)="Reports for ALL OUTPATIENT LOCATIONS, ALL INPATIENT LOCATIONS and ALL "
 .S HTEXT(2)="CLINIC STOPS produce a combined list of reminders due for"
 .S HTEXT(3)="for all locations in each facility selected."
 .S HTEXT(4)=""
 .S HTEXT(5)="Reports for SELECTED HOSPITAL LOCATIONS, SELECTED CLINIC STOPS and"
 .S HTEXT(6)="SELECTED CLINIC GROUPS list reminders due by location for "
 .S HTEXT(7)="each location selected."
 I CALL=9 D
 .I LIT="Facilities" D
 ..S HTEXT(1)="Selecting Y will display one report for all facilities combining"
 ..S HTEXT(2)="locations/teams with the same name. Selecting N will create a"
 ..S HTEXT(3)="separate report for each facility."
 .I LIT'="Facilities" D
 ..S HTEXT(1)="Selecting Y will display one report for all "_LIT_" selected."
 ..S HTEXT(2)="Selecting N will create a separate report for each "_LIT_"."
 I CALL=10 D
 .S HTEXT(1)="This option is only available if more than one location, team or provider is selected."
 .S HTEXT(2)="Selecting I prints only the individual reports. Selecting R prints"
 .S HTEXT(3)="the individual report plus overall totals for all locations, teams or providers."
 .S HTEXT(4)="Selecting T prints only the overall totals for all locations, teams or providers."
 I CALL=11 D
 .S HTEXT(1)="Selecting Y will display patients with reminders in ward/bed"
 .S HTEXT(2)="order. Selecting N will display patients with reminders in"
 .S HTEXT(3)="patient name order."
 I CALL=12 D
 .;IHS/CIA/MGH Modified to use HRCN instead of SSN
 .S HTEXT(1)="Selecting Y will display the full patient HRCN. Selecting N"
 .S HTEXT(2)=" will display only the last 4 digits of the patient HRCN."
 I CALL=13 D
 .S HTEXT(1)="Selecting Y will display the report as fields separated by"
 .S HTEXT(2)="a selected delimiter character. Headings are suppressed. This"
 .S HTEXT(3)="format of report is intended for import into PC spreadsheet (e.g. MS Excl)."
 .S HTEXT(4)="Selecting N will display the normal report with headings"
 I CALL=14 D
 .S HTEXT(1)="Select the character to be output as a delimiter in the report."
 K ^UTILITY($J,"W")
 S IC=""
 F  S IC=$O(HTEXT(IC)) Q:IC=""  D
 . S X=HTEXT(IC)
 . D ^DIWP
 W !
 S IC=0
 F  S IC=$O(^UTILITY($J,"W",0,IC)) Q:IC=""  D
 . W !,^UTILITY($J,"W",0,IC,0)
 K ^UTILITY($J,"W")
 W !
 Q
