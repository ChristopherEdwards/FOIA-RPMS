BDMSELFM ; IHS/CMI/LAB - print Self Monitoring Pts for dm patients ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3,4**;JUN 14, 2007
 ;SELF MONITORING REPORT
 ;
 ;This routine will go through the any selected Register
 ;and then see if the patient has an Self Monitoring Glucose Health Factor
 ;or SELF MONITORING DRUG TAXONOMY
EP ;EP - called from option interactive
 D EOJ
 W:$D(IOF) @IOF
 W !!,"This option will provide a list of patients on a register"
 W !,"(e.g. IHS Diabetes) that either are doing Self Monitoring of"
 W !,"Glucose or who are not doing Self Monitoring of Glucose."
 W !,"The following definitions/logic is used:"
 W !?5,"Yes, Doing self monitoring:"
 W !?7,"- the last health factor documented in the 365 days prior to the"
 W !?7,"end date is SELF MONITORING BLOOD GLUCOSE-YES"
 W !?7,"- the patient has had strips dispensed through pharmacy in "
 W !?7,"the 365 days prior to the end date."
 W !?5,"No, not doing self monitoring"
 W !?7,"- the last health factor documented in the 365 days prior to"
 W !?7,"the end date is SELF MONITORING BLOOD GLUCOSE-NO or SELF MONITORING"
 W !?7,"BLOOD GLUCOSE-REFUSED"
 W !?7,"- the patient has had no strips dispensed through pharmacy"
 W !?7,"- the patient has had neither strips dispensed nor a health"
 W !?7,"factor documented in the 365 days prior to the end date"
 W !!,"In the case of the following conflict:  the patient's last"
 W !,"health factor states NO or REFUSED but they have had strips"
 W !,"dispensed they will show up on each report with a status of"
 W !,"Maybe."
 ;W !!,"This option will print a list of all patients on a register"
REGISTER ;get register name
 S BDMREG=""
 W ! S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register: " D ^DIC
 I Y=-1 S BDMREG="" W !,"No Register Selected." G EOJ
 S BDMREG=+Y
 ;get status
 S BDMSTAT=""
 S DIR(0)="Y",DIR("A")="Do you want to select register patients with a particular status",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G REGISTER
 I Y=0 S BDMSTAT="" G REPORT
 ;which status
 S DIR(0)="9002241,1",DIR("A")="Which status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G REGISTER
 S BDMSTAT=Y
REPORT ;
 S BDMRPT=""
 S DIR(0)="S^Y:YES, Doing Self Monitoring;N:NO, Not doing Self Monitoring;B:Both",DIR("A")="What list of patients do you want",DIR("B")="N" K DA D ^DIR KILL DIR
 I $D(DIRUT) G REGISTER
 S BDMRPT=Y
ENDDATE ;
 S BDMED=""
 W !!,"Enter the end date to use in calculating the 365 day time period."
 S DIR(0)="D^::EPX",DIR("A")="Enter the End Date" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G REPORT
 S BDMED=Y
SORTED ;
 K DIR S DIR(0)="SO^H:HRN;P:PATIENT NAME;C:COMMUNITY OF RESIDENCE",DIR("A")="How would you like the report sorted",DIR("B")="H" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G ENDDATE
 S BDMSORT=Y
ZIS ;
 S XBRP="PRINT^BDMSELFM",XBRC="PROC^BDMSELFM",XBRX="EOJ^BDMSELFM",XBNS="BDM"
 D ^XBDBQUE
 Q
EOJ ;
 D ^XBFMK
 K DIC,DIR
 D EN^XBVK("BDM")
 Q
 ;
PROC ;
 S BDMJ=$J,BDMH=$H
 S ^XTMP("BDMSELFM",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"REGISTER PTS WITH SELF MONITORING"
 S BDMDMX=0 F  S BDMDMX=$O(^ACM(41,"B",BDMREG,BDMDMX)) Q:BDMDMX'=+BDMDMX  D
 .;check to see if patient has Self Monitoring or not
 .;check register status
 .I BDMSTAT]"",$P($G(^ACM(41,BDMDMX,"DT")),U,1)'=BDMSTAT Q
 .S DFN=$P(^ACM(41,BDMDMX,0),U,2)
 .Q:$$DOD^AUPNPAT(DFN)]""  ;don't display deceased patients
 .S BDMHF=$$LASTHF(DFN,"DIABETES SELF MONITORING",$$FMADD^XLFDT(BDMED,-365),"B")
 .I BDMHF["YES" S BDMHFG=1
 .I BDMHF="" S BDMHFG=""
 .I BDMHF["NO" S BDMHFG=0
 .I BDMHF["REFUSE" S BDMHFG=0
 .K BDMMED
 .S X=DFN_"^MEDS [DM AUDIT SELF MONITOR DRUGS"_";DURING "_$$FMADD^XLFDT(BDMED,-365)_"-"_BDMED S E=$$START1^APCLDF(X,"BDMMED(")
 .I $D(BDMMED(1)) S BDMMEDG=1
 .I '$D(BDMMED(1)) S BDMMEDG=0
 .D SETVAL
 .I BDMRPT="Y",BDMVAL="N" Q
 .I BDMRPT="N",BDMVAL="Y" Q
 .S ^XTMP("BDMSELFM",BDMJ,BDMH,"SELF",$$SORT(DFN,BDMSORT),DFN)=BDMHF_"||"_$G(BDMMED(1))_"||"_BDMVAL
 .Q
 Q
SORT(P,BDMSORT) ;
 NEW X S X=""
 I BDMSORT="H" S X=$$HRN^AUPNPAT(P,DUZ(2))
 I BDMSORT="P" S X=$P(^DPT(P,0),U)
 I BDMSORT="C" S X=$$COMMRES^AUPNPAT(P)
 I X="" S X="----"
 Q X
SETVAL ;
 S BDMVAL=""
 I BDMMEDG=1,BDMHFG=1 S BDMVAL="Y" Q
 I BDMMEDG=1,BDMHFG="" S BDMVAL="Y" Q
 I BDMMEDG=1,BDMHFG=0 S BDMVAL="M" Q
 I BDMHFG=1 S BDMVAL="Y" Q
 I BDMHFG=0 S BDMVAL="N" Q
 I BDMHFG="" S BDMVAL="N" Q
 Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K BDMTS,BDMS,BDMM,BDMET
 K ^XTMP("BDMSELFM",BDMJ,BDMH),BDMJ,BDMH
 Q
 ;
PRINT ;EP - called from xbdbque
 K BDMQ S BDMPG=0 D HEADER
 I '$D(^XTMP("BDMSELFM",BDMJ,BDMH)) W !!,"NO DATA TO REPORT",! G DONE
 S BDMSV="" F  S BDMSV=$O(^XTMP("BDMSELFM",BDMJ,BDMH,"SELF",BDMSV)) Q:BDMSV=""!($D(BDMQ))  D
 .S DFN=0 F  S DFN=$O(^XTMP("BDMSELFM",BDMJ,BDMH,"SELF",BDMSV,DFN)) Q:DFN'=+DFN!($D(BDMQ))  D
 ..I $Y>(IOSL-4) D HEADER Q:$D(BDMQ)
 ..I BDMRPT="Y" W !
 ..W !,$$HRN^AUPNPAT(DFN,DUZ(2)),?7,$E($P(^DPT(DFN,0),U),1,28),?38,$E($$COMMRES^AUPNPAT(DFN,"E"),1,15),?54,$$LASTVD^APCLV1(DFN,"E")
 ..S BDMVAL=$P(^XTMP("BDMSELFM",BDMJ,BDMH,"SELF",BDMSV,DFN),"||",3)
 ..S BDMMED=$P(^XTMP("BDMSELFM",BDMJ,BDMH,"SELF",BDMSV,DFN),"||",2)
 ..S BDMHF=$P(^XTMP("BDMSELFM",BDMJ,BDMH,"SELF",BDMSV,DFN),"||",1)
 ..S X="",BDMLHF="",BDMLMED=""
 ..I BDMVAL="Y" S X="Yes"
 ..I BDMVAL="N" S X="No"
 ..I BDMVAL="M" S X="Maybe"
 ..;I BDMHF="",BDMMED="" S BDMLHF="Not documented" G PRINT1
 ..S BDMLHF=BDMHF
 ..S BDMLMED=$P(BDMMED,U,2)_$S($P(BDMMED,U,2)]"":" on ",1:"")_$$FMTE^XLFDT($P(BDMMED,U),2)
PRINT1 ..W ?75,X
 ..I BDMLHF]"" W !?3,"Health Factor: ",BDMLHF
 ..I BDMLMED]"" W !?3,"Medication Dispensed: ",BDMLMED
 D DONE
 Q
HEADER ;EP
 G:'BDMPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQ="" Q
HEADER1 ;
 W:$D(IOF) @IOF S BDMPG=BDMPG+1
 I $G(BDMGUI),BDMPG'=1 W !,"ZZZZZZZ"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BDMPG,!
 W !,$$CTR("PATIENTS ON THE "_$P(^ACM(41.1,BDMREG,0),U)_" REGISTER - BLOOD GLUCOSE SELF MONITORING",80),!
 I BDMRPT="Y" W $$CTR("Patients Doing Self Monitoring",80),!
 I BDMRPT="N" W $$CTR("Patients NOT Doing Self Monitoring",80),!
 I BDMRPT="B" W $$CTR("List of Patients w/Self Monitoring of Blood Glucose Status",80),!
 S X="End Date: "_$$FMTE^XLFDT(BDMED) W $$CTR(X,80),!
 W !,"HRN",?7,"PATIENT NAME",?38,"COMMUNITY",?54,"LAST VISIT",?75,"SMBG?"
 W !,$TR($J("",80)," ","-")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
POST ;
 NEW X
 S X=$$ADD^XPDMENU("BDM M MAIN DM MENU","BDM DM REG APPT CLN","BDM")
 I 'X W "Attempt to new appt list of reg pats failed.." H 3
 Q
LASTHF(P,C,BDATE,F) ;EP - get last factor in category C for patient P
 I '$G(P) Q ""
 I $G(C)="" Q ""
 I $G(F)="" S F=""
 S C=$O(^AUTTHF("B",C,0)) ;ien of category passed
 I '$G(C) Q ""
 NEW H,D,O S H=0 K O
 F  S H=$O(^AUTTHF("AC",C,H))  Q:'+H  D
 .  Q:'$D(^AUPNVHF("AA",P,H))
 .  S D=$O(^AUPNVHF("AA",P,H,""))
 .  Q:'D
 .  Q:(9999999-D)<BDATE
 .  S O(D)=$O(^AUPNVHF("AA",P,H,D,""))
 .  Q
 S D=$O(O(0))
 I D="" Q D
 I F="N" Q $$VAL^XBDIQ1(9000010.23,O(D),.01)
 I F="S" Q $P($G(^AUPNVHF(O(D),0)),U,6)
 I F="B" Q $$VAL^XBDIQ1(9000010.23,O(D),.01)_" "_$$FMTE^XLFDT((9999999-D),2)
 Q 9999999-D
 ;
BDMGA(BDMRET,BDMREG,BDMSTAT,BDMRPT,BDMED,BDMSORT,BDMGUI) ;PEP - gui call
 S BDMJ=$J
 S BDMH=$H
 I $G(BDMJ)="" S BDMRET=-1 Q
 I $G(BDMH)="" S BDMRET=-1 Q
 ;create entry in fileman file to hold output
 N BDMOPT  ;maw
 S BDMOPT="Glucose Self Monitoring"
 D NOW^%DTC
 S BDMNOW=$G(%)
 K DD,D0,DIC
 S X=DUZ_"."_BDMH
 S DIC("DR")=".02////"_DUZ_";.03////"_BDMNOW_";.05///1;.06///"_$G(BDMOPT)_";.07///R"
 S DIC="^BDMGUI(",DIC(0)="L",DIADD=1,DLAYGO=9003002.4
 D FILE^DICN
 K DIADD,DLAYGO,DIC,DA
 I Y=-1 S BDMRET=-1 Q
 S BDMIEN=+Y
 S BDMRET=BDMIEN
 D ^XBFMK
 K ZTSAVE S ZTSAVE("*")=""
 ;D GUIEP  ;for interactive testing
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^BDMSELFM",ZTDESC="GUI GLUCOSE SELF MONITORING" D ^%ZTLOAD
 D EOJ
 Q
GUIEP ;EP - called from taskman ;Visiual DMS Entry Point
 D PROC
 K ^TMP($J,"BDMSELFM")
 S IOM=80  ;cmi/maw added
 D GUIR^XBLM("PRINT^BDMSELFM","^TMP($J,""BDMSELFM"",")
 ;Q:$G(BDMDSP)  ;quit if to screen
 S X=0,C=0 F  S X=$O(^TMP($J,"BDMSELFM",X)) Q:'X  D
 . N BDMGDATA
 . S BDMGDATA=^TMP($J,"BDMSELFM",X)
 . I BDMGDATA="ZZZZZZZ" S BDMGDATA=$C(12)
 . S ^BDMGUI(BDMIEN,11,X,0)=BDMGDATA
 . S C=C+1
 S ^BDMGUI(BDMIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=BDMIEN,DIK="^BDMGUI(" D IX1^DIK
 D ENDLOG
 S ZTREQ="@"
 Q
 ;
ENDLOG ;-- write the end of the log
 D NOW^%DTC
 S BDMNOW=$G(%)
 S DIE="^BDMGUI(",DA=BDMIEN,DR=".04////"_BDMNOW_";.07///C"
 D ^DIE
 K DIE,DR,DA
 Q
 ;
