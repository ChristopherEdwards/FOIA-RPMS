BEDDEHRS ;VNGT/HS/BEE-BEDD Patient Routing Slip  ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;;Jun 04, 2014;Build 13
 ;
 ;Adapted from BEDDEHRRS/CNHS/RPF
 ;
 ; Input:
 ; BEDDDFN (optional) - Patient DFN
 ;
 Q
 ;
EN(BEDDDFN) ;EP - Patient Routing Slip
 ;
 S BEDDDFN=$G(BEDDDFN,"")
 ;
 NEW %,AGE,%ZIS,AGPATDFN,AUPNDAYS,AUPNDOB,AUPNDOD,AUPNPAT,AUPNSEX,DFN,DIC,DOB
 NEW POP,REC,RHIFLAG,SEX,SSN,X,Y
 ;
 ;
 ;Select Patient
 S:BEDDDFN]"" DFN=BEDDDFN
 I BEDDDFN="" D PTLK^AG
 Q:'$D(DFN)
 ;
 ;Select Device
 S %ZIS="QA"
 D ^%ZIS
 I POP N IOP S IOP=ION D ^%ZIS Q
 I $G(IO("Q")) D QUE D HOME^%ZIS Q
 U IO
 D START
 D ^%ZISC
 D HOME^%ZIS
 Q
 ;
START ;Display Report
 ;
 NEW PNAME,PSEX,PDOB,PSITE,PCHRT,RPTDTM,ELIG,LINE,ALINE,I
 ;
 S PNAME=$$GET1^DIQ(2,DFN_",",.01,"E")
 S PSEX=$$GET1^DIQ(2,DFN_",",.02,"E")
 S PDOB=$$FMTE^BEDDUTIL($$GET1^DIQ(2,DFN_",",.03,"I"))
 S PSITE=$$GET1^DIQ(4,DUZ(2)_",",.01,"E")
 S PCHRT=$$GET1^DIQ(9000001.41,DUZ(2)_","_DFN_",",.02,"E")
 S RPTDTM=$TR($$XNOW^BEDDUTIL("5FMZ"),"@"," ")
 S ELIG=$$GET1^DIQ(9000001,DFN_",",1112,"E")
 S $P(LINE,"_",78)="_"
 S $P(ALINE,"*",79)="*"
 ;
 ;Print the Routing Slip
 ;
 ;Display Header
 D HDR
 ;
 ;Current Visit Section
 W !,ALINE
 W !,"Other Information / Instructions: ",!
 F I=1:1:3 W !,LINE
 ;
 W !,ALINE
 W !,"Departments for Patient to visit today:"
 W !,"(Patient: Please check in at any indicated department)"
 W !!,?4,"Return to Clinic Today",?35,"___ Yes    ___ No  "   ;; added for modifications
 W !!,"***Note to Surgery Patient: You must go to all indicated departments TODAY,"
 W !,"or your surgery may be cancelled!"
 ;
 W !!,"_____ Lab",?26,"_____ Imaging",?53,"_____ Tribal Health Prog."
 W !!,"_____ Testing Ctr Imaging",?26,"_____ Pharmacy",?53,"_____ Respiratory Therapy"
 W !!,"_____ Cardiology",?26,"_____ Medisaw",?53,"_____ BC Orientation"
 W !!,"_____ Admissions",?26,"_____ Behavioral Health",?53,"_____ ___________________"
 W !!,"***Note to nurses: For pre-op patient, please complete the following:"
 W !,"Surgery Date:",$E(LINE,1,19)
 W !!,"Diagnosis:",$E(LINE,1,45)
 W ?56,"Surgeon:",$E(LINE,1,14)
 W !!,"Procedure:",$E(LINE,1,45)
 W ?56,"LOS:",$E(LINE,1,18)
 ;
 ;Follow-Up Section
 W !,ALINE
 W !,"Follow-Up"
 W !,"Return to Clinic in: _____________ ",?40,"Days",?50,"Weeks",?60,"Months",?70,"PRN"
 W !!,"Appointment date/time:",$E(LINE,1,20)
 W !,"For:  ___ 15 mins ___ 20 mins ___ 30 mins ___ 40 mins ___ 60 mins"
 W !!,"With: ",$E(LINE,1,35)
 W !!,"Purpose of appt:",$E(LINE,1,62)
 W !!,"Other instructions:",$E(LINE,1,59)
 W !,LINE
 W !!,"Other Appointments Needed: ",$E(LINE,1,45)
 ;
 ;Bottom Section
 W !,ALINE
 W !,"PATIENT: ",PNAME
 W !,"___ Was seen in clinic today."
 W !,"___ Should not work or attend school from _______________ to _______________"
 W !,"___ Should be excused from Phys Ed from ________________ to ________________"
 W !,"___ ",$E(LINE,1,74)
 W !!,"Signature:",$E(LINE,1,44)
 W "Date:",$E(LINE,1,19)
 ;
END ; KILL VARIABLES
 I $E(IOST)'="C" D CLOSE^%ZISH(IO)
 Q
 ;
HDR ;EP - Display Report Header
 ;
 NEW ALERT,PRINT,PCOPY,TITLE
 ;
 ;Handle Screen Printing
 ;
 U IO
 S ALERT="***ALERT - THIS PAPER CONTAINS YOUR ELIGIBILITY***"
 S TITLE="PATIENT ROUTING SLIP - PRINTED: "_RPTDTM
 S PCOPY="***PATIENT COPY***"
 ;
 W !,?((80-$L(PSITE))/2),PSITE
 W !,?((80-$L(TITLE))/2),TITLE
 W !,?((80-$L(ALERT))/2),ALERT
 W !!,"PATIENT NAME: ",PNAME
 W ?46,"SEX: ",PSEX
 W !,?5,"CHART #: ",PCHRT,?46,"DOB: ",PDOB
 W !," ELIGIBILITY: ",ELIG
 ;
 Q
 ;
QUE ;Queue Task
 NEW ZTRTN,ZTSAVE,ZTDESC
 K IO("Q")
 S ZTRTN="START^BEDDEHRS",ZTDESC="Patient Routing Slip"
 S ZTSAVE("*")=""
 K ZTSK D ^%ZTLOAD
 I $D(ZTSK)[0 W !!?5,"Report Cancelled!"
 E  W !!?5,"Task # ",ZTSK," queued.",!
 H 3
 Q
