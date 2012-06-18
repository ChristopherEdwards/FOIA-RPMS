BGP9DCHA ; IHS/CMI/LAB - ihs area GPRA 02 Sep 2004 1:11 PM 02 Jul 2008 2:14 PM ; 
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
 ;
 W:$D(IOF) @IOF
 S BGPA=$E($P(^AUTTLOC(DUZ(2),0),U,10),1,2),BGPA=$O(^AUTTAREA("C",BGPA,0)) S BGPA=$S(BGPA:$P(^AUTTAREA(BGPA,0),U),1:"UNKNOWN AREA")
 W !!,$$CTR(BGPA_" Area Aggregate Height and Weight Data Export",80)
 W !!,"This option is used to produce an area aggregate Height and"
 W !,"Weight Export file. This is a single delimited file that will be comprised"
 W !,"of height and weight data.  This file will be used by the Division"
 W !,"of Epidemiology, where it will construct frequency curves of BMI as"
 W !,"a GPRA developmental performance measure.",!!
INTRO ;
 D EXIT
TP ;
 S BGPAREAA=1
 S BGPRTYPE=1,BGPBEN=1,BGP9RPTH=""
 S X=$O(^BGPCTRL("B",2009,0))
 S Y=^BGPCTRL(X,0)
 S BGPBD=$P(Y,U,8),BGPED=$P(Y,U,9)
 S BGPPBD=$P(Y,U,10),BGPPED=$P(Y,U,11)
 S BGPBBD=$P(Y,U,12),BGPBED=$P(Y,U,13)
 S BGPPER=$P(Y,U,14),BGPQTR=3
 ;BEGIN TEST
 G NT  ;comment out when testing in TEHR
 W !!,"for testing purposes only, please enter a report year",!
 D F
 I BGPPER="" W !!,"no year entered..bye" D EXIT Q
 S BGPQTR=3
 S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 S BGPPBD=($E(BGPPER,1,3)-1)_"0101",BGPPED=($E(BGPPER,1,3)-1)_"1231"
 W !!,"for testing purposes only, please enter a BASELINE year",!
 D B
 I BGPBPER="" W !!,"no year entered..bye" D EXIT Q
 S BGPBBD=$E(BGPBPER,1,3)_"0101",BGPBED=$E(BGPBPER,1,3)_"1231"
 G START
NT ;END TEST STUFF
START ;
 W !,"This file will contain height and weight data for the time period"
 W !,$$FMTE^XLFDT(BGPBD)," through ",$$FMTE^XLFDT(BGPED)," for all Active Clinical"
 W !,"patients 0-18 who have both a height and weight value documented"
 W !,"on a visit and for all Active Clinical patients age 19-65 who"
 W !,"have a height and/or weight value documented on visits during this time"
 W !,"period."
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
 D EN^BGP9ASL
 I '$D(BGPSUL) W !!,"No sites selected" D EXIT Q
 S X=0,C=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S C=C+1
 W !!,"A total of ",C," facilities have been selected.",!!
ZIS ;call to XBDBQUE
EISSEX ;
 S BGPEXCEL=""
 S BGPUF=$$GETDIR^BGP9UTL2()
 ;I ^%ZOSF("OS")["PC"!(^%ZOSF("OS")["NT")!($P($G(^AUTTSITE(1,0)),U,21)=2) S BGPUF=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT")
 ;I $P(^AUTTSITE(1,0),U,21)=1 S BGPUF="/usr/spool/uucppublic/"
 S BGPASUF=$P(^AUTTLOC(DUZ(2),0),U,10)
 S BGPNOW=$$NOW^XLFDT() S BGPNOW=$$NOW^XLFDT() S BGPNOW=$$D($P(BGPNOW,"."))_$P(BGPNOW,".",2)
 S BGPC=0,X=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S BGPC=BGPC+1
 I BGPUF="" W:'$D(ZTQUEUED) !!,"Cannot continue.....can't find export directory name. File not written." Q
 ;S BGPFN="CRSHW"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D(BGPBBD)_$$D(BGPED)_BGPNOW_".TXT"
 S BGPFN="CRSHW"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D(BGPBD)_$$D(BGPED)_BGPNOW_"_001_of_001"_".TXT"
 ;W !!,"A file will be created called ",BGPFN,!,"and will reside in the ",BGPUF," directory. This file can be used in Excel.",!
 S BGPASUF=$P(^AUTTLOC(DUZ(2),0),U,10)
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 W !
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I 'Y D EXIT Q
ONEF ;
 S BGPONEF=""
 W !!!,"An Area wide Height/Weight Export file will be created.  You can choose"
 W !,"to create one file of data or multiple files of data.  If you are"
 W !,"planning to review this data using Microsoft Excel please keep in"
 W !,"mind that Excel can only handle 65,536 records per file.  If you"
 W !,"are using this data for your own use and will be using Microsoft"
 W !,"Excel to review the data you must choose to create multiple files."
 W !,"If you are creating this file to send to the Division of Epidemiology"
 W !,"then you should select to create one file.  If you want to both review"
 W !,"and export your data you will need to run this option twice."
 W !,"If you choose to create one file it will be called:"
 W !?5,BGPFN,!?5,"and will reside in the ",BGPUF," directory."
 W !,"If you have multiple files generated they will all have the"
 W !,"same name with the last 10 characters of the filename being a"
 W !,"of the number of files (e.g. _001_of_003)."
 ; 
 S DIR(0)="S^O:ONE File of data;M:MULTIPLE Files of data",DIR("A")="Do you want to create one file or multiple files",DIR("B")="M" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S BGPONEF=Y
DRIVER ;
 D GS
 D ^%ZISC
 D EXIT
 Q
 ;
EXIT ;
 D ^%ZISC
 D EN^XBVK("BGP") I $D(ZTQUEUED) S ZTREQ="@"
 D KILL^AUPNPAT
 D ^XBFMK
 Q
 ;
GS ;EP - write out file
 ;K ^TMP($J)
 ;L +^BGPDATA:300 E  W:'$D(ZTQUEUED) "Unable to lock global" Q
 ;NOTE:  Kill of unsubscripted global.  Export to area.  Using standard name.
 ;S (BGPC,BGPX)=0 F  S BGPX=$O(BGPSUL(BGPX)) Q:BGPX'=+BGPX  D
 ;.S BGPY=0 F  S BGPY=$O(^BGPGPDCN(BGPX,88888,BGPY)) Q:BGPY'=+BGPY  D
 ;..S BGPC=BGPC+1
 ;..S ^BGPDATA(BGPC)=^BGPGPDCN(BGPX,88888,BGPY,0)
 ;..Q
 ;.Q
 ;S XBGL="BGPDATA"
 ;S XBMED="F",XBFN=BGPFN,XBTLE="SAVE OF HT/WT DATA FOR - "_$P(^AUTTLOC(DUZ(2),0),U,10),XBF=0,XBFLT=1
 ;D ^XBGSAVE
 ;L -^BGPDATA
 K ^TMP($J) ;NOTE:  kill of unsubscripted global for use in export to area.
 I '$D(ZTQUEUED) W !!,"Writing out Ht/Wt file...."
 ;count up total # of records and divide by 65,536
 K BGPFNX
 S BGPRPT=0,BGPTOT=0 F  S BGPRPT=$O(BGPSUL(BGPRPT)) Q:BGPRPT'=+BGPRPT  D HWSF2
 D HWSF3
 Q
HWSF2 ;
 S BGPX=0 F  S BGPX=$O(^BGPGPDCN(BGPRPT,88888,BGPX)) Q:BGPX'=+BGPX  S BGPTOT=BGPTOT+1,^TMP($J,"HTWTR",BGPTOT)=^BGPGPDCN(BGPRPT,88888,BGPX,0)
 Q
HWSF3 ;
 I BGPONEF="O" D HWSF1 Q
 S BGPNF1=BGPTOT/65536
 S BGPNF=$S($P(BGPNF1,".",2)]"":BGPNF1+1,1:BGPNF1)
 S BGPNF=$P(BGPNF,".")
 S BGPX=0,BGPLX=0
 F BGPZ=1:1:BGPNF D
 .S BGPFN="CRSHW"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D(BGPBD)_$$D(BGPED)_BGPNOW_"_"_$$LZERO^BGP9UTL(BGPZ,3)_"_of_"_$$LZERO^BGP9UTL(BGPNF,3)_".TXT"
 .S BGPFNX(BGPZ)=BGPFN
 .S Y=$$OPEN^%ZISH(BGPUF,BGPFN,"W")
 .I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file." Q
 .U IO
 .W "SERVICE UNIT^ASUFAC^UNIQUE DB ID^DATE RUN^BEG DATE^END DATE^PATIENT UID^DOB^TRIBE CODE^GENDER^STATE OF RESIDENCE^UNIQUE VISIT ID^DATE OF VISIT^TIME OF VISIT^HT CM^WT KG",!
 .S BGPC=1,BGPX=$S(BGPLX:BGPLX,1:0)
 .F  S BGPX=$O(^TMP($J,"HTWTR",BGPX)) Q:BGPX'=+BGPX!(BGPC>65535)  D
 ..W $G(^TMP($J,"HTWTR",BGPX)),!
 ..S BGPC=BGPC+1
 ..S BGPLX=BGPX
 .D ^%ZISC
 Q
HWSF1 ;EP
 ;write out one flie only
 S BGPZ=1,BGPFN="CRSHW"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D(BGPBD)_$$D(BGPED)_BGPNOW_"_001_of_001.TXT"
 S BGPFNX(BGPZ)=BGPFN
 I '$D(ZTQUEUED) U IO W !?10,BGPFN
 S Y=$$OPEN^%ZISH(BGPUF,BGPFN,"W")
 I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file." Q
 U IO
 W "SERVICE UNIT^ASUFAC^UNIQUE DB ID^DATE RUN^BEG DATE^END DATE^PATIENT UID^DOB^TRIBE CODE^GENDER^STATE OF RESIDENCE^UNIQUE VISIT ID^DATE OF VISIT^TIME OF VISIT^HT CM^WT KG",!
 S BGPC=1,BGPX=0
 F  S BGPX=$O(^TMP($J,"HTWTR",BGPX)) Q:BGPX'=+BGPX  D
 .W $G(^TMP($J,"HTWTR",BGPX)),!
 D ^%ZISC
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
