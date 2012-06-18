BIPATER ;IHS/CMI/MWR - VIEW/EDIT PATIENT ERRORS ; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT/CORRECT PATIENT ERRORS.
 ;
 ;
 ;----------
START ;EP
 ;---> Loop through Patient Errors, view/edit/correct.
 D SETVARS^BIUTL5 K ^TMP("BIPTER",$J) N BITMP
 ;
 ;---> If Vaccine Table is not standard, display Error Text and quit.
 I $D(^BISITE(-1)) D ERRCD^BIUTL2(503,,1) Q
 ;
 D TITLE^BIUTL5("VIEW/EDIT PATIENT ERRORS"),TEXT1
 N BIACT,DIR
 S DIR("A")="     Enter ALL or ONLY ACTIVE: ",DIR("B")="ALL"
 S DIR(0)="SAM^0:ALL;1:ONLY ACTIVE"
 D ^DIR K DIR
 Q:($D(DIRUT)!(Y=-1))
 S BIACT=+Y
 W !!?5,"Please hold...",!
 ;
 D EN(BIACT)
 D EXIT
 Q
 ;
 ;
 ;----------
EN(BIACT) ;EP
 ;---> Call Listman to View/Edit Patient Errors.
 ;---> Parameters:
 ;     1 - BIACT (opt) 0=ALL PATIENTS, 1=ONLY ACTIVE.
 ;
 N BIT
 D EN^VALM("BI PATIENT ERRORS EDIT")
 Q
 ;
 ;
 ;----------
PRINT ;EP
 ;---> Print Vaccine Table.
 ;---> Called by Protocol BI VACCINE TABLE PRINT, which is the
 ;---> Print List Protocol for the List: BI VACCINE TABLE EDIT.
 ;
 D DEVICE(.BIPOP)
 I $G(BIPOP) D RESET Q
 ;
 D INIT^BIPATER1(.BIT,$G(BIACT)),HDR(1)
 D PRTLST^BIUTL8("BIPTER")
 D RESET
 Q
 ;
 ;
 ;----------
HDR(BIPRT) ;EP
 ;---> Header code for both Listman Screen and Print List.
 ;---> Parameters:
 ;     1 - BIPRT  (opt) If BIPRT=1 array is for print: Change column
 ;                      header line and add Site Header line.
 ;
 N BILINE,X,Y S BILINE=0 K VALMHDR
 N BICRT S BICRT=$S(($E($G(IOST))="C")!(IOST["BROWSER"):1,1:0)
 ;
 D:'$G(BIPRT) WH^BIW(.BILINE)
 S X=$$REPHDR^BIUTL6(DUZ(2)),BIDASH=$L(X)+2 D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;S X=$$SP^BIUTL5(BIDASH,"-") D CENTERT^BIUTL5(.X)
 S X=$$SP^BIUTL5(32,"-") D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X=$S($G(BIACT):"ACTIVE",1:"ALL")_" PATIENT ERRORS (Total: "
 S X=X_$G(BIT)_")"
 D CENTERT^BIUTL5(.X)
 S:BICRT X=IOINHI_X_IOINORM
 D WH^BIW(.BILINE,X)
 ;
 D:$G(BIPRT)
 .D WH^BIW(.BILINE)
 .S X="Printed: "_$$NOW^BIUTL5() D CENTERT^BIUTL5(.X)
 .D WH^BIW(.BILINE,X,1)
 .S X="   #  Patient               Active   HRCN#     Age   V Grp"
 .S X=X_"  Error"
 .D WH^BIW(.BILINE,X)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;---> Variables:
 ;     1 - BIT   (ret) Total Patient Errors.
 ;     2 - BIACT (opt) 0=ALL PATIENTS, 1=ONLY ACTIVE.
 ;
 D INIT^BIPATER1(.BIT,$G(BIACT))
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR() Q
 ;
 ;
 ;----------
DEVICE(BIPOP) ;EP
 ;---> Get Device and possibly queue to Taskman.
 ;---> Parameters:
 ;     1 - BIPOP (ret) If error or Queue, BIPOP=1
 ;
 K %ZIS,IOP S BIPOP=0
 S ZTRTN="DEQUEUE^BIPATER"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;---> Print Patient Data screen.
 N BIT
 D INIT^BIPATER1(.BIT,$G(BIACT)),HDR(1)
 D PRTLST^BIUTL8("BIPTER"),EXIT
 Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1 N BIPOP
 D TITLE^BIUTL5("EDIT PATIENT ERRORS - HELP, page 1 of 2")
 D TEXT2,DIRZ^BIUTL3(.BIPOP)
 I $G(BIPOP) D RE^VALM4 Q
 D TITLE^BIUTL5("EDIT PATIENT ERRORS - HELP, page 2 of 2")
 D TEXT3,DIRZ^BIUTL3()
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;In the View/Edit Patient Errors screen you may display either
 ;;ALL Patients with errors or only those Patients with errors who
 ;;have a Status of ACTIVE.
 ;;
 ;;Enter ALL to include ALL Patients, or enter ONLY ACTIVE to select
 ;;only Active Patients.
 ;;
 ;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;This screen displays patients who whose Immunization Histories
 ;;contain errors, according to the Immserve Forecasting Utility, and
 ;;provides you with the ability to correct or delete those errors.
 ;;
 ;;The columns, from left to right, list:
 ;; 1) Patient Name
 ;; 2) Active/Inactive Status (A=Active, I=Inactive, N=Not In Register)
 ;; 3) HRCN# (Health Record Number or Chart#)
 ;; 4) Age (y=years, m=months, d=days)
 ;; 5) Vaccine Group in which the error is occurring
 ;; 6) An abbreviated statement of what the error is
 ;;
 ;;The three actions at the bottom of the screen allow you to make
 ;;corrections to patient errors on the list or to delete them,
 ;;either individually or all at once.
 ;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;Please note that EACH TIME a patient's forecast is computed (whether
 ;;individually or during the processing of a report), any errors found
 ;;in the patient's history will be stored in the Patient Errors File,
 ;;which is displayed here.
 ;;
 ;;Therefore, if you simply delete a patient error (rather than correct
 ;;it), the error will be placed in the Patient Errors File again the
 ;;next time the patient is is viewed or included in a report.
 ;;
 ;;There may be some cases in which the error cannot be corrected.
 ;;In these cases the Patient History reflects a situation that in fact
 ;;occurred and cannot be "edited".  If these are old cases that are
 ;;rarely called up, then simply deleting them from the Error File is
 ;;probably the best action to take.
 ;;
 ;
 D PRINTX("TEXT3")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> EOJ cleanup.
 D KILLALL^BIUTL8()
 K ^TMP("BIPTER",$J),^TMP("BIPTER1",$J),^TMP("BIPTER2",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
