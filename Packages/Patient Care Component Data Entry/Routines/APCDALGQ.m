APCDALGQ ; IHS/CMI/LAB - PRINT ALLERGY LIST FROM PROBLEM LIST ;
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;
START ;
 D XIT
 I '$D(IOF) D HOME^%ZIS
 W @(IOF),!!
 W "*******  LIST OF PATIENTS WITH ALLERGIES ENTERED ONTO THE   *******",!
 W "    ******* PCC PROBLEM LIST IN A SPECIFIED TIME PERIOD *******"
 W !!,"This report will produce a list of patients who have had allergies entered"
 W !,"onto their problem list in a specified date range.  If you are using"
 W !,"this list to populate the Allergy Tracking module you should"
 W !,"first run the Option 'List all patients with Allergies on their"
 W !,"problem list'.  You would use that report to enter the allergies"
 W !,"into the Allergy tracking module.  When you have finished that list"
 W !,"you can use this list to pick up any allergies entered onto the problem"
 W !,"list after you have ran and processed that list.",!
 W !
GETDATES ;
BD ;get beginning date
 W !,"Please enter the date range for which allergies have been entered",!,"onto the problem list.",!
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCDBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCDBD_":DT:EP",DIR("A")="Enter ending Date:  " S Y=APCDBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCDED=Y
 S X1=APCDBD,X2=-1 D C^%DTC S APCDSD=X S Y=APCDBD D DD^%DT S APCDBDD=Y S Y=APCDED D DD^%DT S APCDEDD=Y
 ;
ZIS ;
 S XBRC="PROC^APCDALGQ",XBRP="PRINT^APCDALGQ",XBNS="APCD",XBRX="XIT^APCDALGQ"
 D ^XBDBQUE
XIT ;
 D EN^XBVK("APCD")
 D ^XBFMK
 Q
XTMP(N,T) ;EP
 I $G(N)="" Q
 S ^XTMP(N,0)=$$FMADD^XLFDT(DT,14)_U_DT_U_T
 Q
 ;
PROC ;EP - entry point for processing
 S APCDJOB=$J,APCDBTH=$H,APCDTOT=0,APCDBT=$H
 D XTMP("APCDALGQ","PCC PROBLEM LIST ALLERGY LIST")
 S APCDET=$H
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D PROC1
 Q
PROC1 ;
 Q:$$DOD^AUPNPAT(DFN)]""  ;no deceased patients
 I $P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,5)="I" Q  ;no inactive patients
 ;Q:'$$LASTVD(DFN,APCDBD,APCDED)  ;no visit in time perio
 S APCDX=0 F  S APCDX=$O(^AUPNPROB("AC",DFN,APCDX)) Q:APCDX'=+APCDX  S G=0 D  I G S ^XTMP("APCDALGQ",APCDJOB,APCDBTH,DFN,APCDX)=""
 .Q:$P(^AUPNPROB(APCDX,0),U,8)<APCDBD
 .Q:$P(^AUPNPROB(APCDX,0),U,8)>APCDED
 .I $P(^AUPNPROB(APCDX,0),U,12)="D" Q  ;deleted
 .S APCDP=$P($G(^AUPNPROB(APCDX,0)),U)
 .Q:APCDP=""
 .;S APCDICD=$P($G(^ICD9(APCDP,0)),U)
 .S APCDICD=$P($$ICDDX^ICDCODE(APCDP),U,2)
 .Q:APCDICD=""
 .I $P(^AUPNPROB(APCDX,0),U,5)="" Q  ;IHS/CMI/LAB - no narr
 .S APCDSNKA=0
 .I APCDICD="692.3" S G=1 Q
 .I APCDICD="693.0" S G=1 Q
 .I APCDICD="995.0" S G=1 Q
 .I APCDICD=995.2 S G=1 Q
 .I (+APCDICD'<999.4),(+APCDICD'>999.8) S G=1 Q
 .I APCDICD?1"V14."1E S G=1 Q
 .I APCDICD="692.5" S G=1 Q
 .I APCDICD="693.1" S G=1 Q
 .I APCDICD["V15.0" S G=1 Q
 .I $E(APCDICD,1,3)=692,APCDICD'="692.9" S G=1 Q
 .I APCDICD="693.8" S G=1 Q
 .I APCDICD="693.9" S G=1 Q
 .I APCDICD="989.5" S G=1 Q
 .I APCDICD="995.3" S G=1 Q
 .I APCDICD="995.2" S G=1 Q
 .S N=$P(^AUTNPOV($P(^AUPNPROB(APCDX,0),U,5),0),U) I APCDICD="799.9"!(APCDICD="V82.9"),N["NO KNOWN ALLERG"!(N["NKA")!(N["NKDA")!(N["NO KNOWN DRUG ALLERG") S APCDSNKA=1 S G=1 Q
 Q
LASTVD(P,BDATE,EDATE) ;
 I '$D(^AUPNVSIT("AC",P)) Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:"SAHOIRCT"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .S G=1
 .Q
 Q G
PRINT ;
 S APCD80D="-------------------------------------------------------------------------------"
 S Y=APCDBD D DD^%DT S APCDBDD=Y S Y=APCDED D DD^%DT S APCDEDD=Y
 S APCDPG=0
 I '$D(^XTMP("APCDALGQ",APCDJOB,APCDBTH)) D HEAD W !!,"NO PATIENTS TO REPORT" G DONE
 D HEAD
 S DFN=0 F  S DFN=$O(^XTMP("APCDALGQ",APCDJOB,APCDBTH,DFN)) Q:DFN'=+DFN!($D(APCDQ))  D
 .I $Y>(IOSL-6) D HEAD Q:$D(APCDQ)
 .W !!,$P(^DPT(DFN,0),U),?31,$$HRN^AUPNPAT(DFN,DUZ(2)),?42,$$DOB^AUPNPAT(DFN,"E")
 .W !?3,"DATE ADDED",?17,"DX",?24,"PROVIDER NARRATIVE"
 .W !?3,"----------",?17,"--",?24,"------------------"
 .S APCDP=0 F  S APCDP=$O(^XTMP("APCDALGQ",APCDJOB,APCDBTH,DFN,APCDP)) Q:APCDP=""!($D(APCDQ))  D
 ..W !?3,$$VAL^XBDIQ1(9000011,APCDP,.08),?17,$$VAL^XBDIQ1(9000011,APCDP,.01),?24,$$VAL^XBDIQ1(9000011,APCDP,.05)
DONE ;
 K ^XTMP("APCDALGQ",APCDJOB,APCDBTH),APCDJOB,APCDBTH
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
         ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
         ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
HEAD I 'APCDPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W $P(^VA(200,DUZ,0),U,2),?72,"Page ",APCDPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 S X="PATIENTS WITH ALLERGIES OR DOCUMENTED NO KNOWN ALLERGIES ON PCC PROBLEM LIST" W $$CTR(X),!
 S X="ALLERGIES ADDED TO THE PROBLEM:  "_APCDBDD_"  TO  "_APCDEDD W $$CTR(X),!
 W "PATIENT NAME",?31,"CHART #",?45,"DOB",!,APCD80D
 Q
