BNIRP7 ; IHS/CMI/LAB - date report ;
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
LIST ;
 K BNILIST
 K DIR S DIR(0)="Y",DIR("A")="Do you want a list of the records",DIR("B")="N" KILL DA D ^DIR K DIR
 I $D(DIRUT) G GETDATES
 S BNILIST=Y
ZIS ;call to XBDBQUE
 S XBRP="PRINT^BNIRP7",XBRC="PROCESS^BNIRP7",XBRX="XIT^BNIRP7",XBNS="BNIG"
 D ^XBDBQUE
 D XIT
 Q
PROCESS ;EP - called from xbdbque
 S BNIJ=$J,BNIH=$H,BNIGTOTR=0,BNIGTOTT=0
 K BNIGDATA
 S ^XTMP("BNIRP7",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^BNI CPHAD ACTIVITY REPORT"
 S BNIGSD=BNIGSD_".9999"
 F  S BNIGSD=$O(^BNIREC("B",BNIGSD)) Q:BNIGSD=""!($E(BNIGSD,1,5)>$E(BNIGED,1,5))  D
 .S BNIR=0 F  S BNIR=$O(^BNIREC("B",BNIGSD,BNIR)) Q:BNIR'=+BNIR  D PROC1
 .Q
 Q
PROC1 ;
 S BNIREC=$G(^BNIREC(BNIR,0))
 Q:BNIREC=""
 D SET
 Q
SET ;
 I BNILIST S ^XTMP("BNIRP7",BNIJ,BNIH,"RECORDS",$P(BNIREC,U),BNIR)=""
 S BNIGTOTR=BNIGTOTR+1
 S BNIGTOTT=BNIGTOTT+$P(BNIREC,U,9)
 S BNIPRV=$$VALI^XBDIQ1(90510,BNIR,.01)
 I BNIPRV="" S BNIPRV="UNKNOWN/BLANK"
 I '$D(BNIGDATA(BNIPRV)) S BNIGDATA(BNIPRV)=""
 S $P(BNIGDATA(BNIPRV),U,1)=$P(BNIGDATA(BNIPRV),U,1)+1
 S $P(BNIGDATA(BNIPRV),U,2)=$P(BNIGDATA(BNIPRV),U,2)+$P(BNIREC,U,9)
 Q
PRINT ;EP - called from xbdbque
 S BNIGPG=0,BNIGQUIT=""
 D HEADER
 S BNIPRV="" F  S BNIPRV=$O(BNIGDATA(BNIPRV)) Q:BNIPRV=""!(BNIGQUIT)  D
 .I $Y>(IOSL-2) D HEADER Q:BNIGQUIT
 .W !,$$DATE(BNIPRV),?15,$$DOW^XLFDT(BNIPRV)
 .W ?55,$$C($P(BNIGDATA(BNIPRV),U,1),0,8),?68,$$C($P(BNIGDATA(BNIPRV),U,2),2,12)
 I $Y>(IOSL-4) D HEADER Q:BNIGQUIT
 W !!!,"GRAND TOTALS:",?55,$$C(BNIGTOTR,0,8),?68,$$C(BNIGTOTT,2,12)
 I BNILIST D LISTP
 W ! D EOP
 Q
LISTP ;
 D LHDR
 S BNID=0 F  S BNID=$O(^XTMP("BNIRP7",BNIJ,BNIH,"RECORDS",BNID)) Q:BNID'=+BNID!(BNIGQUIT)  D
 .S BNIR=0 F  S BNIR=$O(^XTMP("BNIRP7",BNIJ,BNIH,"RECORDS",BNID,BNIR)) Q:BNIR'=+BNIR!(BNIGQUIT)  D
 ..I $Y>(IOSL-4) D LHDR Q:BNIGQUIT
 ..W !,$$D($P(^BNIREC(BNIR,0),U)),?13,$E($$VAL^XBDIQ1(90510,BNIR,.08),1,15),?30,$P(^BNIREC(BNIR,0),U,9)
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
 K ^XTMP("BNIRP7",BNIJ,BNIH)
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
D(D) ;EP
 I D="" Q ""
 Q $$FMTE^XLFDT(D)
 ;
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
 W !,$$CTR("*** Activity Time by Date of Activity ***",80)
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
 W !,$$CTR("*** Computerized Public Health Actvity Datasystem ***",80)
 W !,$$CTR("***  Activity Time by Date of Activity  ***",80)
 W !,$$CTR($P(^DIC(4,DUZ(2),0),U),80)
 S X="Activity Dates: "_$$FMTE^XLFDT(BNIGBD)_" to "_$$FMTE^XLFDT(BNIGED) W !,$$CTR(X,80)
 W !,$$REPEAT^XLFSTR("-",80)
 W !,?1,"DATE OF ACTIVITY",?55,"# RECORDS",?73,"Hrs"
 W !?55,"---------",?73,"---"
 W !
 Q
 ;
XIT ;
 D EN^XBVK("BNI")
 K X,X1,X2,IO("Q"),%,Y,POP,DIRUT,ZTSK,ZTQUEUED,H,S,TS,M
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !!,$$CTR($$LOC)
 W !!,$$CTR("TIME SPENT by Date of Activity")
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
BNIG(BNIERR,BNIJOB,BNIBTH,BNIGBD,BNIGED,BNILIST,BNIRDT) ;PEP - gui call
 I $G(BNIJOB)="" S BNIIEN=-1 Q
 I $G(BNIBTH)="" S BNIIEN=-1 Q
 I $G(BNIBG)="" S BNIIEN=-1 Q
 I $G(BNIED)="" S BNIIEN=-1 Q
 I $G(BNILIST)="" S BNIIEN=-1 Q
 S BNIGBDD=$$FMTE^XLFDT(BNIGBD),BNIGEDD=$$FMTE^XLFDT(BNIGED)
 S X1=BNIBG,X2=-1 D C^%DTC S BNIGSD=X
 ;create entry in fileman file to hold output
 N BNIOPT  ;maw
 S BNIOPT="Date of Activity"
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
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^BNIRP7",ZTDESC=BNIOPT D ^%ZTLOAD
 D XIT
 Q
GUIEP ;EP - called from taskman
 D PROCESS
 K ^TMP($J,"BNIRP7")
 S IOM=80  ;cmi/maw added
 D GUIR^XBLM("PRINT^BNIRP7","^TMP($J,""BNIRP7"",")
 S X=0,C=0 F  S X=$O(^TMP($J,"BNIRP7",X)) Q:X'=+X  D
 . S C=C+1
 . N BNIDATA
 . S BNIDATA=$G(^TMP($J,"BNIRP7",X))
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
