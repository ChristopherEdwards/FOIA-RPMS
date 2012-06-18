APCLDMSM ; IHS/CMI/LAB - print Self Monitoring Pts for dm patients ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;this routine will go through the Diabetes Register
 ;and then see if the patient has an Self Monitoring Glucose Health Factor
 ;
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
 ;W !,"(e.g. Diabetes Register) who have a Health Factor "
 ;W !,"for SELF MONITORING BLOOD GLUCOSE.",!!
 ;W "You will be asked to enter the name of the register & the date range of the"
 ;W !,"Visits.  The Report will Display YES or NO or REFUSED Self Monitoring",!
REGISTER ;get register name
 S APCLREG=""
 W ! S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register: " D ^DIC
 I Y=-1 S APCLREG="" W !,"No Register Selected." G EOJ
 S APCLREG=+Y
 ;get status
 S APCLSTAT=""
 S DIR(0)="Y",DIR("A")="Do you want to select register patients with a particular status",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G REGISTER
 I Y=0 S APCLSTAT="" G REPORT
 ;which status
 S DIR(0)="9002241,1",DIR("A")="Which status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G REGISTER
 S APCLSTAT=Y
REPORT ;
 S APCLRPT=""
 S DIR(0)="S^Y:YES, Doing Self Monitoring;N:NO, Not doing Self Monitoring;B:Both",DIR("A")="What list of patients do you want",DIR("B")="N" K DA D ^DIR KILL DIR
 I $D(DIRUT) G REGISTER
 S APCLRPT=Y
ENDDATE ;
 S APCLED=""
 W !!,"Enter the end date to use in calculating the 365 day time period."
 S DIR(0)="D^::EPX",DIR("A")="Enter the End Date" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G REPORT
 S APCLED=Y
SORTED ;
 K DIR S DIR(0)="SO^H:HRN;P:PATIENT NAME;C:COMMUNITY OF RESIDENCE",DIR("A")="How would you like the report sorted",DIR("B")="H" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G ENDDATE
 S APCLSORT=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G SORTED
 S XBRP="PRINT^APCLDMSM",XBRC="PROC^APCLDMSM",XBRX="EOJ^APCLDMSM",XBNS="APCL"
 D ^XBDBQUE
 Q
EOJ ;
 D ^XBFMK
 K DIC,DIR
 D EN^XBVK("APCL")
 Q
 ;
PROC ;
 K ^XTMP("APCLDMSM")
 S APCLJ=$J,APCLH=$H
 S ^XTMP("APCLDMSM",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"REGISTER PTS WITH SELF MONITORING"
 S APCLDMX=0 F  S APCLDMX=$O(^ACM(41,"B",APCLREG,APCLDMX)) Q:APCLDMX'=+APCLDMX  D
 .;check to see if patient has Self Monitoring or not
 .;check register status
 .I APCLSTAT]"",$P($G(^ACM(41,APCLDMX,"DT")),U,1)'=APCLSTAT Q
 .S DFN=$P(^ACM(41,APCLDMX,0),U,2)
 .Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 .Q:$$DOD^AUPNPAT(DFN)]""  ;don't display deceased patients
 .S APCLHF=$$LASTHF(DFN,"DIABETES SELF MONITORING",$$FMADD^XLFDT(APCLED,-365),"B")
 .I APCLHF["YES" S APCLHFG=1
 .I APCLHF="" S APCLHFG=""
 .I APCLHF["NO" S APCLHFG=0
 .I APCLHF["REFUSE" S APCLHFG=0
 .K APCLMED
 .S X=DFN_"^MEDS [DM AUDIT SELF MONITOR DRUGS"_";DURING "_$$FMADD^XLFDT(APCLED,-365)_"-"_APCLED S E=$$START1^APCLDF(X,"APCLMED(")
 .I $D(APCLMED(1)) S APCLMEDG=1
 .I '$D(APCLMED(1)) S APCLMEDG=0
 .D SETVAL
 .I APCLRPT="Y",APCLVAL="N" Q
 .I APCLRPT="N",APCLVAL="Y" Q
 .S ^XTMP("APCLDMSM",APCLJ,APCLH,"SELF",$$SORT(DFN,APCLSORT),DFN)=APCLHF_"||"_$G(APCLMED(1))_"||"_APCLVAL
 .Q
 Q
SORT(P,APCLSORT) ;
 NEW X S X=""
 I APCLSORT="H" S X=$$HRN^AUPNPAT(P,DUZ(2))
 I APCLSORT="P" S X=$P(^DPT(P,0),U)
 I APCLSORT="C" S X=$$COMMRES^AUPNPAT(P)
 I X="" S X="----"
 Q X
SETVAL ;
 S APCLVAL=""
 I APCLMEDG=1,APCLHFG=1 S APCLVAL="Y" Q
 I APCLMEDG=1,APCLHFG="" S APCLVAL="Y" Q
 I APCLMEDG=1,APCLHFG=0 S APCLVAL="M" Q
 I APCLHFG=1 S APCLVAL="Y" Q
 I APCLHFG=0 S APCLVAL="N" Q
 I APCLHFG="" S APCLVAL="N" Q
 Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K APCLTS,APCLS,APCLM,APCLET
 K ^XTMP("APCLDMSM",APCLJ,APCLH),APCLJ,APCLH
 Q
 ;
PRINT ;EP - called from xbdbque
 K APCLQ S APCLPG=0 D HEADER
 I '$D(^XTMP("APCLDMSM",APCLJ,APCLH)) W !!,"NO DATA TO REPORT",! G DONE
 S APCLSV="" F  S APCLSV=$O(^XTMP("APCLDMSM",APCLJ,APCLH,"SELF",APCLSV)) Q:APCLSV=""!($D(APCLQ))  D
 .S DFN=0 F  S DFN=$O(^XTMP("APCLDMSM",APCLJ,APCLH,"SELF",APCLSV,DFN)) Q:DFN'=+DFN!($D(APCLQ))  D
 ..I $Y>(IOSL-4) D HEADER Q:$D(APCLQ)
 ..I APCLRPT="Y" W !
 ..W !,$$HRN^AUPNPAT(DFN,DUZ(2)),?7,$E($P(^DPT(DFN,0),U),1,28),?38,$E($$COMMRES^AUPNPAT(DFN,"E"),1,15),?54,$$LASTVD^APCLV1(DFN,"E")
 ..S APCLVAL=$P(^XTMP("APCLDMSM",APCLJ,APCLH,"SELF",APCLSV,DFN),"||",3)
 ..S APCLMED=$P(^XTMP("APCLDMSM",APCLJ,APCLH,"SELF",APCLSV,DFN),"||",2)
 ..S APCLHF=$P(^XTMP("APCLDMSM",APCLJ,APCLH,"SELF",APCLSV,DFN),"||",1)
 ..S X="",APCLLHF="",APCLLMED=""
 ..I APCLVAL="Y" S X="Yes"
 ..I APCLVAL="N" S X="No"
 ..I APCLVAL="M" S X="Maybe"
 ..;I APCLHF="",APCLMED="" S APCLLHF="Not documented" G PRINT1
 ..S APCLLHF=APCLHF
 ..S APCLLMED=$P(APCLMED,U,2)_$S($P(APCLMED,U,2)]"":" on ",1:"")_$$FMTE^XLFDT($P(APCLMED,U),2)
PRINT1 ..W ?75,X
 ..I APCLLHF]"" W !?3,"Health Factor: ",APCLLHF
 ..I APCLLMED]"" W !?3,"Medication Dispensed: ",APCLLMED
 D DONE
 Q
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ="" Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W !,$$CTR("PATIENTS ON THE "_$P(^ACM(41.1,APCLREG,0),U)_" REGISTER - BLOOD GLUCOSE SELF MONITORING",80),!
 I APCLRPT="Y" W $$CTR("Patients Doing Self Monitoring",80),!
 I APCLRPT="N" W $$CTR("Patients NOT Doing Self Monitoring",80),!
 I APCLRPT="B" W $$CTR("List of Patients w/Self Monitoring of Blood Glucose Status",80),!
 S X="End Date: "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80),!
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
 S X=$$ADD^XPDMENU("APCL M MAIN DM MENU","APCL DM REG APPT CLN","APCL")
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
