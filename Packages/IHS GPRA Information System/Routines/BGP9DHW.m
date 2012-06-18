BGP9DHW ; IHS/CMI/LAB - NATL COMP EXPORT 13 Nov 2006 12:31 PM ; 
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
 ;
 W:$D(IOF) @IOF
 W !,$$CTR("IHS 2009 National GPRA & PART Height and Weight Local Data File",80),!
INTRO ;
 D XIT
 D TERM^VALM0
 S BGPCTRL=$O(^BGPCTRL("B",2009,0))
 F X=1:1:18 W !,^BGPCTRL(BGPCTRL,73,X,0)
 D EOP
 S X=18 F  S X=$O(^BGPCTRL(BGPCTRL,73,X)) Q:X'=+X  D
 .W !,^BGPCTRL(BGPCTRL,73,X,0)
 W ! K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 ;
 D TAXCHK^BGP9XTCN
TP ;get time period
 D XIT
 S BGPRTYPE=1,BGP9RPTH=""
 S X=$O(^BGPCTRL("B",2009,0))
 S Y=^BGPCTRL(X,0)
 S BGPBD=$P(Y,U,8),BGPED=$P(Y,U,9)
 S BGPPBD=$P(Y,U,10),BGPPED=$P(Y,U,11)
 S BGPBBD=$P(Y,U,12),BGPBED=$P(Y,U,13)
 S BGPPER=$P(Y,U,14),BGPQTR=3
 ;BEGIN TEST STUFF
 G NT  ;comment out when testing in TEHR
 W !!,"for testing purposes only, please enter a report year",!
 D F
 I BGPPER="" W !!,"no year entered..bye" D XIT Q
 S BGPQTR=3
 S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 S BGPPBD=($E(BGPPER,1,3)-1)_"0101",BGPPED=($E(BGPPER,1,3)-1)_"1231"
 W !!,"for testing purposes only, please enter a BASELINE year",!
 D B
 I BGPBPER="" W !!,"no year entered..bye" D XIT Q
 S BGPBBD=$E(BGPBPER,1,3)_"0101",BGPBED=$E(BGPBPER,1,3)_"1231"
NT ;END TEST STUFF
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
BEN ;
 S BGPBEN=1 W !!,"The beneficiary population for this report is AI/AN only."
COMM ;
 W !!,"Specify the community taxonomy to determine which patients will be",!,"included in the report.  You should have created this taxonomy using QMAN.",!
 K BGPTAX
 S BGPTAXI=""
 D ^XBFMK
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: "
 S B=$P($G(^BGPSITE(DUZ(2),0)),U,5) I B S DIC("B")=$P(^ATXAX(B,0),U)
 D ^DIC K DIC
 I Y=-1 D XIT Q
 S BGPTAXI=+Y
COM1 ;
 S X=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S BGPTAX($P(^ATXAX(BGPTAXI,21,X,0),U))=""
 .Q
 I '$D(BGPTAX) W !!,"There are no communities in that taxonomy." G COMM
 S X=0,G=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S C=$P(^ATXAX(BGPTAXI,21,X,0),U)
 .I '$D(^AUTTCOM("B",C)) W !!,"***  Warning: Community ",C," is in the taxonomy but was not",!,"found in the standard community table." S G=1
 .Q
 I G D  I BGPQUIT D XIT Q
 .W !!,"These communities may have been renamed or there may be patients"
 .W !,"who have been reassigned from this community to a new community and this"
 .W !,"could reduce your patient population."
 .S BGPQUIT=0
 .S DIR(0)="Y",DIR("A")="Do you want to cancel the report and review the communities" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPQUIT=1
 .I Y S BGPQUIT=1
 .Q
MFIC K BGPQUIT
 I $P($G(^BGPSITE(DUZ(2),0)),U,8)=1 D  I BGPMFITI="" G COMM
 .S BGPMFITI=""
 .W !!,"Specify the LOCATION taxonomy to determine which patient visits will be"
 .W !,"used to determine whether a patient is in the denominators for the report."
 .W !,"You should have created this taxonomy using QMAN.",!
 .K BGPMFIT
 .S BGPMFITI=""
 .D ^XBFMK
 .S DIC("S")="I $P(^(0),U,15)=9999999.06",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Location/Facility Taxonomy: "
 .S B=$P($G(^BGPSITE(DUZ(2),0)),U,9) I B S DIC("B")=$P(^ATXAX(B,0),U)
 .D ^DIC
 .I Y=-1 Q
 .S BGPMFITI=+Y
HOME ;
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
AI ;gather all gpra measures
 S X=0 F  S X=$O(^BGPINDN("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
 S BGPINDT="G"
EXPORT ;export to area or not?
 S BGPYWCHW=2
 S BGPEXPT=1,BGPYWCHW=0
EISSEX ;
 S BGPEXCEL=""
 S BGPUF=$$GETDIR^BGP9UTL2()
 I BGPEXPT,BGPUF="" W:'$D(ZTQUEUED) !!,"Cannot continue.....can't find export directory name. EXCEL file",!,"not written." D PAUSE^BGP9CL,XIT Q
 ;
CHW ;
 S BGPYWCHW=2 D  I BGPONEF="" G COMM
 .S BGPHWNOW=$$NOW^XLFDT() S BGPHWNOW=$P(BGPHWNOW,".")_"."_$$RZERO^BGP9UTL($P(BGPHWNOW,".",2),6)
 .I BGPUF="" W:'$D(ZTQUEUED) !!,"Cannot continue.....can't find export directory name. EXCEL file",!,"not written." Q
 .S BGPFN="CRSHW"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D^BGP9UTL(BGPBD)_$$D^BGP9UTL(BGPED)_$$D^BGP9UTL(BGPHWNOW)_"_001_of_001"_".TXT"
 .D ONEF
 .Q
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF NATIONAL GPRA & PART HEIGHT AND WEIGHT")
 W !,$$CTR("LOCAL DATA FILE TO BE GENERATED")
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(BGPTAXI,0),U)
 I $G(BGPMFITI) W !!,"The MFI Location Taxonomy to be used is: ",$P(^ATXAX(BGPMFITI,0),U)
 W !!,"The height and weight data file will be named: ",!,BGPFN
 W !,"and will reside in the ",BGPUF," directory."
 I BGPONEF="M" D
 .W !,"Since you opted to create multiple files, if additional files are"
 .W !,"generated they will all have the same name as the one listed above"
 .W !,"with the last 10 characters of the filename being the number of "
 .W !,"files (e.g. 001_of_003)."
 ;I BGPHOME W !,"The HOME location is: ",$P(^DIC(4,BGPHOME,0),U)," ",$P(^AUTTLOC(BGPHOME,0),U,10)
 ;I 'BGPHOME W !,"No HOME Location selected."
 S BGPROT="P",BGPDELT="" ;D PT^BGP9DSL
 I BGPROT="" G BEN
ZIS ;call to XBDBQUE
 D REPORT^BGP9UTL
 I $G(BGPQUIT) D XIT Q
 I BGPRPT="" D XIT Q
 K IOP,%ZIS I BGPROT="D",BGPDELT="F" D NODEV,XIT Q
 K IOP,%ZIS W !! S %ZIS=$S(BGPDELT'="S":"PQM",1:"PM") D ^%ZIS
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDCN(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDPN(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDBN(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 I $D(ZTQUEUED) S ZTREQ="@"
 D ^BGP9D1
 D HWSF
 U IO
 D PRINT^BGP9DHW
 D ^%ZISC
 D KITM
 Q
 ;
ONEF ;
 S BGPONEF=""
 W !!!,"A Height/Weight Export file will be created.  You can choose"
 W !,"to create one file of data or multiple files of data.  If you are"
 W !,"planning to review this data using Microsoft Excel please keep in"
 W !,"mind that Excel can only handle 65,536 records per file.  If you"
 W !,"expect that your site has more than 65,536 records you will need"
 W !,"to create multiple files in order to use this data in Excel.  If"
 W !,"you choose to create one file it will be called:"
 W !?5,BGPFN,!?5,"and will reside in the ",BGPUF," directory."
 W !,"If you have multiple files generated they will all have the"
 W !,"same name with the last 10 characters of the filename being"
 W !,"the number of files (e.g. 001_of_003)."
 ; 
 S DIR(0)="S^O:ONE File of data;M:MULTIPLE Files of data",DIR("A")="Do you want to create one file or multiple files",DIR("B")="M" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S BGPONEF=Y
 Q
NODEV ;
 S XBRP="",XBRC="NODEV1^BGP9DHW",XBRX="XIT^BGP9DHW",XBNS="BGP"
 D ^XBDBQUE
 Q
 ;
NODEV1 ;
 D ^BGP9D1
 D HWSF
 D PRINT^BGP9DHW
 D ^%ZISC
 D KITM
 D XIT
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP9DHW",ZTDTH="",ZTDESC="NATIONAL GPRA LOCAL HW DATA" D ^%ZTLOAD D XIT Q
 Q
 ;
XIT ;
 D ^%ZISC
 D EN^XBVK("BGP") I $D(ZTQUEUED) S ZTREQ="@"
 K DIRUT,DUOUT,DIR,DOD
 K DIADD,DLAYGO
 D KILL^AUPNPAT
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K BD,ED
 D KILL^AUPNPAT
 D ^XBFMK
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)
 NEW DIR,X
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
CHKY ;
 W !!,"The baseline year and the previous year time periods are the same.",!!
 S DIR(0)="Y",DIR("A")="Do you want to change the baseline year",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S Y="" Q
 Q
F ;fiscal year
 S (BGPPER,BGPVDT)=""
 W !!,"Enter the year for the report.  Use a 4 digit ",!,"year, e.g. 2009"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter year"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPPER=BGPVDT
 Q
B ;fiscal year
 S (BGPBPER,BGPVDT)=""
 W !!,"Enter the BASELINE year for the report.  Use a 4 digit ",!,"year, e.g. 2000"
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
HWSF ;EP
 I '$D(ZTQUEUED) W !!,"Writing out Ht/Wt file...."
 K BGPFILES
 ;count up total # of records and divide by 65,536
 I BGPONEF="O" D HWSF1 Q
 S BGPX=0,BGPTOT=0 F  S BGPX=$O(^BGPGPDCN(BGPRPT,88888,BGPX)) Q:BGPX'=+BGPX  S BGPTOT=BGPTOT+1
 S BGPNF1=BGPTOT/65536
 S BGPNF=$S($P(BGPNF1,".",2)]"":$P(BGPNF1,".")+1,1:BGPNF1)
 S BGPNF=$P(BGPNF,".")
 S BGPX=0,BGPLX=0
 F BGPZ=1:1:BGPNF D
 .S BGPFN="CRSHW"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D^BGP9UTL(BGPBD)_$$D^BGP9UTL(BGPED)_$$D^BGP9UTL(BGPHWNOW)_"_"_$$LZERO^BGP9UTL(BGPZ,3)_"_of_"_$$LZERO^BGP9UTL(BGPNF,3)_".TXT"
 .S BGPFILES(BGPZ)=BGPFN
 .S Y=$$OPEN^%ZISH(BGPUF,BGPFN,"W")
 .I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file." Q
 .U IO
 .W "SERVICE UNIT^ASUFAC^UNIQUE DB ID^DATE RUN^BEG DATE^END DATE^PATIENT UID^DOB^TRIBE CODE^GENDER^STATE OF RESIDENCE^UNIQUE VISIT ID^DATE OF VISIT^TIME OF VISIT^HT CM^WT KG",!
 .S BGPC=1,BGPX=$S(BGPLX:BGPLX,1:0)
 .F  S BGPX=$O(^BGPGPDCN(BGPRPT,88888,BGPX)) Q:BGPX'=+BGPX!(BGPC>65535)  D
 ..W $G(^BGPGPDCN(BGPRPT,88888,BGPX,0)),!
 ..S BGPC=BGPC+1
 ..S BGPLX=BGPX
 .D ^%ZISC
 Q
HWSF1 ;EP
 ;write out one file only
 S BGPZ=1,BGPFN="CRSHW"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D^BGP9UTL(BGPBD)_$$D^BGP9UTL(BGPED)_$$D^BGP9UTL(BGPHWNOW)_"_001_of_001.TXT"
 S BGPFILES(1)=BGPFN
 I '$D(ZTQUEUED) U IO W !?10,BGPFN
 S Y=$$OPEN^%ZISH(BGPUF,BGPFN,"W")
 I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file." Q
 U IO
 W "SERVICE UNIT^ASUFAC^UNIQUE DB ID^DATE RUN^BEG DATE^END DATE^PATIENT UID^DOB^TRIBE CODE^GENDER^STATE OF RESIDENCE^UNIQUE VISIT ID^DATE OF VISIT^TIME OF VISIT^HT CM^WT KG",!
 S BGPC=1,BGPX=0
 F  S BGPX=$O(^BGPGPDCN(BGPRPT,88888,BGPX)) Q:BGPX'=+BGPX  D
 .W $G(^BGPGPDCN(BGPRPT,88888,BGPX,0)),!
 .S BGPC=BGPC+1
 D ^%ZISC
 Q
KITM ;EP - kill tmp globals
 K ^TMP($J)
 K ^XTMP("BGP9D",BGPJ,BGPH)
 K ^XTMP("BGP9DNP",BGPJ,BGPH)
 K ^XTMP("BGP08CPL",BGPJ,BGPH)
 Q
PRINT ;EP
 S BGPQUIT=0,BGPGPG=0
 S BGPIOSL=$S($G(BGPGUI):55,1:$G(IOSL))
 D HEADER
 W !
 W !?10,"Community Taxonomy Name: ",$P(^ATXAX(BGPTAXI,0),U)
 W !?10,"The following communities are included in this report:",! D
 .S BGPZZ="",BGPN=0,BGPY="" F  S BGPZZ=$O(BGPTAX(BGPZZ)) Q:BGPZZ=""!(BGPQUIT)  S BGPN=BGPN+1,BGPY=BGPY_$S(BGPN=1:"",1:";")_BGPZZ
 .S BGPZZ=0,C=0 F BGPZZ=1:3:BGPN D  Q:BGPQUIT
 ..I $Y>(BGPIOSL-2) D HEADER Q:BGPQUIT
 ..W !?10,$E($P(BGPY,";",BGPZZ),1,20),?30,$E($P(BGPY,";",(BGPZZ+1)),1,20),?60,$E($P(BGPY,";",(BGPZZ+2)),1,20)
 ..Q
 Q:BGPQUIT
 I $G(BGPMFITI) W !!?10,"MFI Visit Location Taxonomy Name: ",$P(^ATXAX(BGPMFITI,0),U)
 I $G(BGPMFITI) W !?10,"The following Locations are used for patient visits in this report:",! D
 .S BGPZZ="",BGPN=0,BGPY="" F  S BGPZZ=$O(^ATXAX(BGPMFITI,21,"B",BGPZZ)) Q:BGPZZ=""  S BGPN=BGPN+1,BGPY=BGPY_$S(BGPN=1:"",1:";")_$P($G(^DIC(4,BGPZZ,0)),U)
 .S BGPZZ=0,C=0 F BGPZZ=1:3:BGPN D  Q:BGPQUIT
 ..I $Y>(BGPIOSL-2) D HEADER Q:BGPQUIT
 ..W !?10,$E($P(BGPY,";",BGPZZ),1,20),?30,$E($P(BGPY,";",(BGPZZ+1)),1,20),?60,$E($P(BGPY,";",(BGPZZ+2)),1,20)
 ..Q
 I $Y>(IOSL-3) D HEADER Q:BGPQUIT
 W !!,"Delimited Height and Weight File(s): "
 S BGPX=0 F  S BGPX=$O(BGPFILES(BGPX)) Q:BGPX'=+BGPX  D
 .I $Y>(IOSL-2) D HEADER Q:BGPQUIT
 .W !?5,BGPFILES(BGPX)
 I $Y>(IOSL-2) D HEADER Q:BGPQUIT
 W !!,"Directory Name: ",BGPUF
 K BGPX,BGPQUIT
 Q
HEADER ;EP
 G:'BGPGPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BGPGPG=BGPGPG+1
 I $G(BGPGUI) W "ZZZZZZZ",!  ;maw
 W $P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BGPGPG,!
 W $$CTR("*** IHS 2009 National GPRA & PART Height and Weight Local Data File ***",80),!
 W !!,$$CTR($$RPTVER^BGP9BAN,80)
 W !,$$CTR("Date File Run: "_$$FMTE^XLFDT(DT),80)
 W !,$$CTR("Site where Run: "_$P(^DIC(4,DUZ(2),0),U),80)
 W !,$$CTR("File Generated by: "_$$USR,80)
 S X="Report Period:  "_$$FMTE^XLFDT(BGPBD)_" to "_$$FMTE^XLFDT(BGPED) W !,$$CTR(X,80)
 W !,$TR($J("",80)," ","-"),!
 Q
