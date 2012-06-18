BGP6DCHA ; IHS/CMI/LAB - ihs area GPRA 02 Sep 2004 1:11 PM ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 W:$D(IOF) @IOF
 S BGPA=$E($P(^AUTTLOC(DUZ(2),0),U,10),1,2),BGPA=$O(^AUTTAREA("C",BGPA,0)) S BGPA=$S(BGPA:$P(^AUTTAREA(BGPA,0),U),1:"UNKNOWN AREA")
 W !!,$$CTR(BGPA_" Area Aggregate Height and Weight Data Export",80)
 W !!,"This option is used to produce an area aggregate Height and"
 W !,"Weight Export file. This is a single delimited file that will be comprised"
 W !,"of height and weight data.  This file should be exported to the Division"
 W !,"of Epidemiology, where it will construct frequency curves of BMI as"
 W !,"a GPRA developmental performance measure.",!!
INTRO ;
 D EXIT
TP ;
 S BGPAREAA=1
 S BGPRTYPE=1,BGPBEN=1,BGP6RPTH=""
 ;W !!,"for testing purposes only, please enter a report year",!
 ;D F
 ;I BGPPER="" W !!,"no year entered..bye" D EXIT Q
 ;S BGPQTR=3
 ;S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 ;S BGPPBD=($E(BGPPER,1,3)-1)_"0101",BGPPED=($E(BGPPER,1,3)-1)_"1231"
 ;W !!,"for testing purposes only, please enter a BASELINE year",!
 ;D B
 ;I BGPBPER="" W !!,"no year entered..bye" D EXIT Q
 ;S BGPBBD=$E(BGPBPER,1,3)_"0101",BGPBED=$E(BGPBPER,1,3)_"1231"
 ;END TEST STUFF
 S BGPBD=3050701,BGPED=3060630
 S BGPBBD=2990701,BGPBED=3000630
 S BGPPBD=3040701,BGPPED=3050630
 S BGPPER=3060000,BGPQTR=3
 W !,"This file will contain height and weight data for the time period"
 W !,$$FMTE^XLFDT(BGPBBD)," through ",$$FMTE^XLFDT(BGPED)," for all Active Clinical"
 W !,"patients 0-18 who have both a height and weight value documented"
 W !,"on a visit and for all Active Clinical patients age 19 and older who"
 W !,"have a height and/or weight value documented on a visit."
 ;W !!,"The date ranges for this report are:"
 ;W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 ;W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 ;W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
ASU ;
 S BGPSUCNT=0
 W !!!,"You will now be able to select which sites to use in the export.",!
 S DIR(0)="E",DIR("A")="Press Enter to Continue" KILL DA D ^DIR KILL DIR
 K BGPSUL
 S BGPCHWE=1
 D EN^BGP6ASL
 I '$D(BGPSUL) W !!,"No sites selected" D EXIT Q
 S X=0,C=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S C=C+1
 W !!,"A total of ",C," facilities have been selected.",!!
ZIS ;call to XBDBQUE
EISSEX ;
 S BGPEXCEL=""
 S BGPUF=""
 I ^%ZOSF("OS")["PC"!(^%ZOSF("OS")["NT")!($P($G(^AUTTSITE(1,0)),U,21)=2) S BGPUF=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT")
 I $P(^AUTTSITE(1,0),U,21)=1 S BGPUF="/usr/spool/uucppublic"
 S BGPASUF=$P(^AUTTLOC(DUZ(2),0),U,10)
 S BGPNOW=$$NOW^XLFDT() S BGPNOW=$$NOW^XLFDT() S BGPNOW=$$D($P(BGPNOW,"."))_$P(BGPNOW,".",2)
 S BDWC=0,X=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S BDWC=BDWC+1
 I BGPUF="" W:'$D(ZTQUEUED) !!,"Cannot continue.....can't find export directory name. File not written." Q
 S BGPFN="HW"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D(BGPBBD)_$$D(BGPED)_BGPNOW_".TXT"
 W !!,"A file will be created called ",BGPFN,!,"and will reside in the ",BGPUF," directory. This file can be used in Excel.",!
 S BGPASUF=$P(^AUTTLOC(DUZ(2),0),U,10)
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 W !
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I 'Y D EXIT Q
DRIVER ;
 D GS
 D ^%ZISC
 D EXIT
 Q
 ;
EXIT ;
 D EN^XBVK("BGP")
 D KILL^AUPNPAT
 D ^XBFMK
 Q
 ;
GS ;EP - write out file
 K ^TMP($J)
 L +^BGPDATA:300 E  W:'$D(ZTQUEUED) "Unable to lock global" Q
 ;NOTE:  Kill of unsubscripted global.  Export to area.  Using standard name.
 S (BGPC,BGPX)=0 F  S BGPX=$O(BGPSUL(BGPX)) Q:BGPX'=+BGPX  D
 .S BGPY=0 F  S BGPY=$O(^BGPGPDCS(BGPX,88888,BGPY)) Q:BGPY'=+BGPY  D
 ..S BGPC=BGPC+1
 ..S ^BGPDATA(BGPC)=^BGPGPDCS(BGPX,88888,BGPY,0)
 ..Q
 .Q
 S XBGL="BGPDATA"
 S XBMED="F",XBFN=BGPFN,XBTLE="SAVE OF HT/WT DATA FOR - "_$P(^AUTTLOC(DUZ(2),0),U,10),XBF=0,XBFLT=1
 D ^XBGSAVE
 L -^BGPDATA
 K ^TMP($J),^BGPDATA ;NOTE:  kill of unsubscripted global for use in export to area.
 Q
 ;
B ;fiscal year
 S (BGPBPER,BGPVDT)=""
 W !!,"Enter the BASELINE year for the report.  Use a 4 digit ",!,"year, e.g. 2005"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter BASELINE year"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPBPER=BGPVDT
 Q
F ;fiscal year
 S BGPPER=""
 W !
 S BGPVDT=""
 W !,"Enter the Fiscal Year (FY) for the report END date.  Use a 4 digit",!,"year, e.g. 2002, 2005"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter FY"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR
 K DIC
 I $D(DUOUT) S DIRUT=1 S BGPQUIT="" Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPPER=BGPVDT,BGPBD=($E(BGPVDT,1,3)-1)_"1001",BGPED=$E(BGPVDT,1,3)_"0930"
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
D(D) ;EP
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)
