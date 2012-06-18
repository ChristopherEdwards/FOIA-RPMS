BNIRP1 ; IHS/CMI/LAB - person report ;
 ;;1.0;BNI CPHD ACTIVITY DATASYSTEM;;DEC 20, 2006
 ;
START ; 
 D INFORM
GETDATES ;
BD ;get beginning date
 W !
 S BNIGBD=""
 S DIR(0)="FO^6:7",DIR("A")="Enter Beginning Month (e.g. 01/2006)",DIR("?")="Enter a month and 4 digit year in the following format:  1/1999, 01/2000.  The slash is required between the month and year.  Date must be in the past."
 KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 Q:X=""
 I Y'?1.2N1"/"4N W !,"Enter the month/4 digit year in the format 03/2005.  Slash is required and ",!,"4 digit year is required.",! G BD
 K %DT S X=Y,%DT="EP" D ^%DT
 I Y=-1 W !!,"Enter a month and 4 digit year.  Date must be in the past.  E.g.  04/2005 or 01/2000." G BD
 I Y>DT W !!,"No future dates allowed!",! G BD
 S BNIGBD=Y
ED ;get ending date
 W !
 S BNIGED=""
 S DIR(0)="FO^6:7",DIR("A")="Enter Ending Month (e.g. 01/2006)",DIR("?")="Enter a month and 4 digit year in the following format:  1/1999, 01/2000.  The slash is required between the month and year.  Date must be in the past."
 KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 Q:X=""
 I Y'?1.2N1"/"4N W !,"Enter the month/4 digit year in the format 03/2005.  Slash is required and ",!,"4 digit year is required.",! G ED
 K %DT S X=Y,%DT="EP" D ^%DT
 I Y=-1 W !!,"Enter a month and 4 digit year.  Date must be in the past.  E.g.  04/2005 or 01/2000." G ED
 I Y>DT W !!,"No future dates allowed!",! G ED
 S BNIGED=Y
 S BNIGBDD=$$FMTE^XLFDT(BNIGBD),BNIGEDD=$$FMTE^XLFDT(BNIGED)
 S X1=BNIGBD,X2=-1 D C^%DTC S BNIGSD=X
 ;
PROV ;
 S BNIGQUIT=""
 S BNIGPRVT="" K BNIGPRVS
 K DIR
 S DIR(0)="S^O:ONE Provider;A:ALL Providers;T:Selected Set or TAXONOMY of Providers;D:Selected Set or Taxonomy of Provider DISCIPLINES",DIR("A")="Include which Providers",DIR("B")="O" KILL DA D ^DIR K DIR
 I $D(DIRUT) G GETDATES
 S BNIGPRVT=Y
 D @(BNIGPRVT_"PRV")
 I BNIGQUIT K BNIGPRVT,BNIGPRVS G PROV
SUB ;
 K BNIGSUB
 K DIR S DIR(0)="S^P:by PUBLIC HEALTH CONCERN;S:by SPECIFIC HEALTH TOPIC;T:by TYPE OF ACTIVITY;E:by ACTIVITY SETTING;G:by GROUP SERVED;R:by GPRA Elements"
 S DIR(0)=DIR(0)_";D:by DATE of ACTIVITY;N:NO sub totals (None of the above)"
 S DIR("A")="How would you like to Sub Total the report",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PROV
 S BNIGSUB=Y
LIST ;
 K BNILIST
 K DIR S DIR(0)="Y",DIR("A")="Do you want a list of the records",DIR("B")="N" KILL DA D ^DIR K DIR
 I $D(DIRUT) G SUB
 S BNILIST=Y
ZIS ;call to XBDBQUE
 S XBRP="PRINT^BNIRP1",XBRC="PROCESS^BNIRP1",XBRX="XIT^BNIRP1",XBNS="BNIG"
 D ^XBDBQUE
 D XIT
 Q
PROCESS ;EP - called from xbdbque
 S BNIJ=$J,BNIH=$H,BNIGTOTR=0,BNIGTOTT=0
 K BNIGDATA
 S ^XTMP("BNIRP1",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^BNI CPHAD ACTIVITY REPORT"
 S BNIGSD=BNIGSD_".9999"
 F  S BNIGSD=$O(^BNIREC("B",BNIGSD)) Q:BNIGSD=""!($E(BNIGSD,1,5)>$E(BNIGED,1,5))  D
 .S BNIR=0 F  S BNIR=$O(^BNIREC("B",BNIGSD,BNIR)) Q:BNIR'=+BNIR  D PROC1
 .Q
 Q
PROC1 ;
 S BNIREC=$G(^BNIREC(BNIR,0))
 Q:BNIREC=""
 S BNIPRV=$P(BNIREC,U,8)
 Q:BNIPRV=""  ;no provider entered????
 I BNIGPRVT="D" D DISC Q
 I $D(BNIGPRVS),'$D(BNIGPRVS(BNIPRV)) Q  ;not a provider of interest for this run
 D SET
 Q
DISC ;
 S BNIPRV=$$VALI^XBDIQ1(200,BNIPRV,53.5) Q:BNIPRV=""
 I $D(BNIGPRVS),'$D(BNIGPRVS(BNIPRV)) Q
 D SET
 Q
SET ;
 I BNILIST S ^XTMP("BNIRP1",BNIJ,BNIH,"RECORDS",$P(BNIREC,U),BNIR)=""
 S BNIGTOTR=BNIGTOTR+1
 S BNIGTOTT=BNIGTOTT+$P(BNIREC,U,9)
 I '$D(BNIGDATA(BNIPRV)) S BNIGDATA(BNIPRV)=""
 S $P(BNIGDATA(BNIPRV),U,1)=$P(BNIGDATA(BNIPRV),U,1)+1
 S $P(BNIGDATA(BNIPRV),U,2)=$P(BNIGDATA(BNIPRV),U,2)+$P(BNIREC,U,9)
 ;sub totals
 I BNIGSUB="P" D
 .S X=$$VAL^XBDIQ1(90510,BNIR,.11)
 I BNIGSUB="S" D
 .S X=$$VAL^XBDIQ1(90510,BNIR,.12)
 I BNIGSUB="T" D
 .S X=$$VAL^XBDIQ1(90510,BNIR,.13)
 I BNIGSUB="E" D
 .S X=$$VAL^XBDIQ1(90510,BNIR,.15)
 I BNIGSUB="G" D
 .S X=$$VAL^XBDIQ1(90510,BNIR,.14)
 I BNIGSUB="N" Q
 I BNIGSUB="R" D
 .S X=$$VALI^XBDIQ1(90510,BNIR,.12)
 .I X="" Q
 .S X=$P(^BNISHT(X,0),U,4)
 .I X="" S X="Non GPRA Element" Q
 .S X=$P(^BNISHT(X,0),U)
 I BNIGSUB="D" D
 .S X=$P(BNIREC,U)
 I X="" S X="UNKNOWN"
 S $P(BNIGDATA(BNIPRV,X),U,1)=$P($G(BNIGDATA(BNIPRV,X)),U,1)+1
 S $P(BNIGDATA(BNIPRV,X),U,2)=$P($G(BNIGDATA(BNIPRV,X)),U,2)+$P(BNIREC,U,9)
 Q
PRINT ;EP - called from xbdbque
 S BNIGPG=0,BNIGQUIT=""
 D HEADER
 ;S BNIGDATA(1)=223456_U_423900.8733
 S BNIPRV="" F  S BNIPRV=$O(BNIGDATA(BNIPRV)) Q:BNIPRV=""!(BNIGQUIT)  D
 .I $Y>(IOSL-2) D HEADER Q:BNIGQUIT
 .I BNIGPRVT="D" W !!,$P(^DIC(7,BNIPRV,0),U)
 .I BNIGPRVT'="D" W !!,$P(^VA(200,BNIPRV,0),U)
 .W ?55,$$C($P(BNIGDATA(BNIPRV),U,1),0,8),?68,$$C($P(BNIGDATA(BNIPRV),U,2),2,12)
 .S BNIS="" F  S BNIS=$O(BNIGDATA(BNIPRV,BNIS)) Q:BNIS=""!(BNIGQUIT)  D
 ..I $Y>(IOSL-2) D HEADER Q:BNIGQUIT
 ..W !?2,$S(BNIGSUB="D":$$DATE(BNIS),1:$E(BNIS,1,50)),?55,$$C($P(BNIGDATA(BNIPRV,BNIS),U,1),0,8),?68,$$C($P(BNIGDATA(BNIPRV,BNIS),U,2),2,12)
 I $Y>(IOSL-4) D HEADER Q:BNIGQUIT
 W !!!,"GRAND TOTALS:",?55,$$C(BNIGTOTR,0,8),?68,$$C(BNIGTOTT,2,12)
 I BNILIST D LISTP
 W ! D EOP
 Q
LISTP ;
 D LHDR
 S BNID=0 F  S BNID=$O(^XTMP("BNIRP1",BNIJ,BNIH,"RECORDS",BNID)) Q:BNID'=+BNID!(BNIGQUIT)  D
 .S BNIR=0 F  S BNIR=$O(^XTMP("BNIRP1",BNIJ,BNIH,"RECORDS",BNID,BNIR)) Q:BNIR'=+BNIR!(BNIGQUIT)  D
 ..I $Y>(IOSL-4) D LHDR Q:BNIGQUIT
 ..W !,$$DT($P(^BNIREC(BNIR,0),U)),?13,$E($$VAL^XBDIQ1(90510,BNIR,.08),1,15),?30,$P(^BNIREC(BNIR,0),U,9)
 ..W ?37,$E($$VAL^XBDIQ1(90510,BNIR,.15),1,20),?59,$E($$VAL^XBDIQ1(90510,BNIR,.13),1,15),?75,$$GPRA(BNIR)
 ..W !?3,$$VAL^XBDIQ1(90510,BNIR,.11)
 ..W !?3,$$VAL^XBDIQ1(90510,BNIR,.12)
 ..Q:'$O(^BNIREC(BNIR,14,0))
 ..S BNIX=0 F  S BNIX=$O(^BNIREC(BNIR,14,BNIX)) Q:BNIX'=+BNIX!(BNIGQUIT)  D
 ...I $Y>(IOSL-4) D LHDR Q:BNIGQUIT
 ...W !?1,^BNIREC(BNIR,14,BNIX,0)
 ...Q
 ..Q
 .Q
 K ^XTMP("BNIRP1",BNIJ,BNIH)
 Q
GPRA(R) ;
 S X=$$VALI^XBDIQ1(90510,BNIR,.12)
 I X="" Q ""
 I $P(^BNISHT(X,0),U,4) Q "GPRA"
 Q ""
DATE(D) ;EP
 I D="" Q ""
 ;Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
 Q $$FMTE^XLFDT(D)
 ;
DT(D) ;EP
 I D="" Q ""
 Q $$FMTE^XLFDT(D)
 ;
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
LHDR ;
 I 'BNIGPG G LHDR1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BNIGQUIT=1 Q
LHDR1 ;
 W:$D(IOF) @IOF S BNIGPG=BNIGPG+1
 I $G(BNIGUI) W "ZZZZZZZ",!  ;maw
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BNIGPG,!
 W !,$$CTR("*** Computerized Public Health Actvity Datasystem ***",80)
 W !,$$CTR("*** Activity Time by Person Performing Activity ***",80)
 W !,$$CTR("*** Record Listing ***",80)
 W !,$$CTR($P(^DIC(4,DUZ(2),0),U),80)
 S X="Activity Dates: "_$$FMTE^XLFDT(BNIGBD)_" to "_$$FMTE^XLFDT(BNIGED) W !,$$CTR(X,80)
 W !!,"DATE",?10,"PROVIDER",?30,"Hrs",?37,"SETTING",?59,"ACTIVITY",?75,"GPRA"
 W !,$$REPEAT^XLFSTR("-",80)
 W !
 Q
HEADER ;
 I 'BNIGPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BNIGQUIT=1 Q
HEAD1 ;
 W:$D(IOF) @IOF S BNIGPG=BNIGPG+1
 ;I $G(BNIGUI) W "ZZZZZZZ",!  ;maw
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BNIGPG,!
 W !,$$CTR("*** Computerized Public Health Actvity Datasystem  ***",80)
 W !,$$CTR("***  Activity Time by Person Performing Activity  ***",80)
 W !,$$CTR($P(^DIC(4,DUZ(2),0),U),80)
 S X="Activity Dates: "_$$FMTE^XLFDT(BNIGBD)_" to "_$$FMTE^XLFDT(BNIGED) W !,$$CTR(X,80)
 I BNIGSUB'="N" S X="Subtotalled by: " S Y=$T(@BNIGSUB) W !,$$CTR(X_$P(Y,";;",2),80)
 W !,$$REPEAT^XLFSTR("-",80)
 W !?55,"# RECORDS",?73,"Hrs"
 W !?55,"---------",?73,"---"
 W !
 Q
P ;;PUBLIC HEALTH CONCERN
S ;;SPECIFIC HEALTH TOPIC
T ;;TYPE OF ACTIVITY
E ;;ACTIVITY SETTING
G ;;GROUP SERVED
R ;;GPRA ELEMENT
D ;;DATE OF ACTIVITY
 ;
XIT ;
 D EN^XBVK("BNI")
 K X,X1,X2,IO("Q"),%,Y,POP,DIRUT,ZTSK,ZTQUEUED,H,S,TS,M
 Q
OPRV ;one provider
 K DIC S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Enter PROVIDER: " D ^DIC
 I Y=-1 S BNIGQUIT=1 K BNIGPRVS Q
 S BNIGPRVS(+Y)=""
 Q
APRV ;all providers
 K BNIGPRVS
 Q
TPRV ;taxonomy of providers
 K BNIGPRVS
 W !!,"At the prompt enter provider names or enter a taxonomy by ",!,"prefacing the taxonomy name with a '[' e.g. [LAM PROVIDERS",!
 S X="PRIMARY PROVIDER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D ^AMQQGTX0(+Y,"BNIGPRVS(")
 I '$D(BNIGPRVS) G PROV
 I $D(BNIGPRVS("*")) K BNIGPROV Q
 Q
DPRV ;discipline
 W !!,"At the prompt enter provider disciplines or enter a taxonomy of disciplines",!,"by prefacing the taxonomy name with a '[' e.g. [LAM PHYSICIANS.",!
 K BNIGDISP,BNIGPRVS
 S X="DISCIPLINE",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D ^AMQQGTX0(+Y,"BNIGPRVS(")
 I '$D(BNIGPRVS) S BNIGQUIT=1 K BNIGPRVS,BNIGDISP Q
 I $D(BNIGPRVS("*")) W !!,"All providers will be included." K BNIGPRVS,BNIGDISP Q
 ;S X=0 F  S X=$O(^VA(200,X)) Q:X'=+X  S Y=$$VALI^XBDIQ1(200,X,53.5) I Y,$D(BNIGDISP(Y)) S BNIGPRVS(X)=""
 K BNIGDISP
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !!,$$CTR($$LOC)
 W !!,$$CTR("TIME SPENT BY PERSON PERFORMING ACTIVITY")
 W !!,"This report will tally up all time spent by the person performing"
 W !,"the activity.  You can optionally subtotal by other data elements."
 W !
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!$D(IO("S"))
 NEW DIR
 K DIR,DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR KILL DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
BNIG(BNIERR,BNIJOB,BNIBTH,BNIGBD,BNIGED,BNILIST,BNIRDT,BNIGPRVT,BNIGSUB,BNIGPRVS) ;PEP - gui call
 I $G(BNIJOB)="" S BNIIEN=-1 Q
 I $G(BNIBTH)="" S BNIIEN=-1 Q
 I $G(BNIBG)="" S BNIIEN=-1 Q
 I $G(BNIED)="" S BNIIEN=-1 Q
 I $G(BNILIST)="" S BNIIEN=-1 Q
 I BNIGPRVT="A" K BNIGPRVS
 I BNIGPRVT="TP" K BNIGTAXZ M BNIGTAXZ=BNIGPRVS K BNIGPRVS D
 .NEW X,Y
 .S X=0 F  S X=$O(BNIGTAXZ(X)) Q:X'=+X  S Y=0 F  S Y=$O(^ATXAX(X,21,"B",Y)) Q:Y'=+Y  S BNIGPRVS(Y)=""
 I BNIGPRVT="DT" K BNIGTAXZ M BNIGTAXZ=BNIGPRVS K BNIGPRVS D
 .NEW X,Y,Z
 .S X=0 F  S X=$O(BNIGTAXZ(X)) Q:X'=+X  S Y=0 F  S Y=$O(^ATXAX(X,21,"B",Y)) Q:Y'=+Y  D
 ..S Z=0 F  S Z=$O(^VA(200,Z)) Q:Z'=+Z  S A=$$VALI^XBDIQ1(200,Z,53.5) I A=Y S BNIGPRVS(Z)=""
 S BNIGBDD=$$FMTE^XLFDT(BNIGBD),BNIGEDD=$$FMTE^XLFDT(BNIGED)
 S X1=BNIBG,X2=-1 D C^%DTC S BNIGSD=X
 ;create entry in fileman file to hold output
 N BNIOPT  ;maw
 S BNIOPT="Time Spent by Persons Performing Activity"
 D NOW^%DTC
 S BNINOW=$G(%)
 K DD,D0,DIC
 S X=BNIJOB_"."_BNIBTH
 S DIC("DR")=".02////"_DUZ_";.03////"_BNINOW_";.05////"_$G(BNIOPT)_";.06///R;.07///R"
 S DIC="^BNIGUI(",DIC(0)="L",DIADD=1,DLAYGO=90512.08
 D FILE^DICN
 K DIADD,DLAYGO,DIC,DA
 I Y=-1 S BNIIEN=-1 Q
 S BNIIEN=+Y
 S BNIGIEN=BNIIEN  ;cmi/maw added
 D ^XBFMK
 K ZTSAVE S ZTSAVE("*")=""
 ;D GUIEP ;for interactive testing
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^BNIRP1",ZTDESC="BNI Persons Performing Activity" D ^%ZTLOAD
 D XIT
 Q
GUIEP ;EP - called from taskman
 D PROCESS
 K ^TMP($J,"BNIRP1")
 S IOM=80  ;cmi/maw added
 D GUIR^XBLM("PRINT^BNIRP1","^TMP($J,""BNIRP1"",")
 S X=0,C=0 F  S X=$O(^TMP($J,"BNIRP1",X)) Q:X'=+X  D
 . S C=C+1
 . N BNIDATA
 . S BNIDATA=$G(^TMP($J,"BNIRP1",X))
 . I BNIDATA="ZZZZZZZ" S BNIDATA=$C(12)
 . S ^BNIGUI(BNIIEN,11,C,0)=BNIDATA
 S ^BNIGUI(BNIIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=BNIIEN,DIK="^BNIGUI(" D IX1^DIK
 D ENDLOG
 S ZTREQ="@"
 Q
 ;
ENDLOG ;-- write the end of the log
 D NOW^%DTC
 S BNINOW=$G(%)
 S DIE="^BNIGUI(",DA=BNIIEN,DR=".04////"_BNINOW_";.06///C"
 D ^DIE
 K DIE,DR,DA
 Q
 ;
