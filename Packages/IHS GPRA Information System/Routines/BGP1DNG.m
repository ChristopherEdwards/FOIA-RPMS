BGP1DNG ; IHS/CMI/LAB - NATL COMP EXPORT 13 Nov 2006 12:31 PM ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
 W:$D(IOF) @IOF
 W !,$$CTR("IHS 2011 National GPRA & PART Report",80)
INTRO ;
 D XIT
 W !!,"This will produce a National GPRA & PART report."
 W !,"You will be asked to provide the community taxonomy to determine which patients"
 W !,"will be included.  This report will be run for the Report Period July 1, 2010"
 W !,"through June 30, 2011 with a Baseline Year of July 1, 1999 through"
 W !,"June 30, 2000.  This report will include beneficiary population of "
 W !,"American Indian/Alaska Native only.",!
 W !!,"You can choose to export this data to the Area office.  If you"
 W !,"answer yes at the export prompt, a report will be produced in export format"
 W !,"for the Area Office to use in Area aggregated data.  Depending on site specific"
 W !,"configuration, the export file will either be automatically transmitted "
 W !,"directly to the Area or the site will have to send the file manually.",!
 K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 ;
 ;
 D TAXCHK^BGP1XTCN
 S X=$$DEMOCHK^BGP1UTL2()
 I 'X W !!,"Exiting Report....." D PAUSE^BGP1CL,XIT Q
TP ;get time period
 D XIT
 S BGPRTYPE=1,BGP1RPTH=""
 S X=$O(^BGPCTRL("B",2011,0))
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
BEN ;
 S BGPBEN=1
HOME ;
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
AI ;gather all gpra measures
 ;F X=1:100 I $D(^BGPINDB("GPRA",1,X)) S BGPIND(X)=""
 S X=0 F  S X=$O(^BGPINDB("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
 S BGPINDB="G"
EXPORT ;export to area or not?
 S BGPEXPT="",BGPYWCHW=0
 S DIR(0)="Y",DIR("A")="Do you wish to export this data to Area" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G COMM
 S BGPEXPT=Y I BGPEXPT S BGPYWCHW=$S($P($G(^BGPSITE(DUZ(2),0)),U,11)=0:0,1:1) I 'BGPYWCHW D  I 'Y D XIT Q
 .W !!,"***WARNING***  Because your site parameter for exporting height and weight "
 .W !,"data to the Area Office is set to ","""","No",""""," your Area Office export file (file "
 .W !,"beginning with ","""","BG11","""",") will not contain height and weight data."
 .W !,"This data is sent to the IHS Division of Epidemiology to track and analyze "
 .W !,"BMI data over time.  All IHS and Urban facilities should have the site "
 .W !,"parameter set to ","""","Yes",""""," and only Tribal facilities have the option"
 .W !,"of setting it to ","""","No","""",".  If you want to include the height and weight "
 .W !,"data in your Area Office export file, please change the site parameter export "
 .W !,"option to ","""","Yes",""""," in Setup and then run your National GPRA & PART Report."
 .W !
 .S DIR(0)="Y",DIR("A")="Do you wish to continue with generating this report",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 .Q
EISSEX ;
 S BGPEXCEL=""
 S BGPUF=$$GETDIR^BGP1UTL2()
 I BGPUF="" W !!!,"Cannot find export or pub directory.  Notify your IT staff." D XIT Q
 ;
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF NATIONAL GPRA & PART REPORT TO BE GENERATED")
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(BGPTAXI,0),U)
 I $G(BGPMFITI) W !!,"The MFI Location Taxonomy to be used is: ",$P(^ATXAX(BGPMFITI,0),U)
 ;I BGPHOME W !,"The HOME location is: ",$P(^DIC(4,BGPHOME,0),U)," ",$P(^AUTTLOC(BGPHOME,0),U,10)
 ;I 'BGPHOME W !,"No HOME Location selected."
 D PT^BGP1DSL
 I BGPROT="" G BEN
ZIS ;call to XBDBQUE
 D REPORT^BGP1UTL
 I $G(BGPQUIT) D XIT Q
 I BGPRPT="" D XIT Q
 I BGPEXPT D
 .W !!,"A file will be created called BG11",$P(^AUTTLOC(DUZ(2),0),U,10)_"."_BGPRPT," and will reside",!,"in the ",BGPUF," directory.",!
 .W !,"Depending on your site configuration, this file may need to be manually",!,"sent to your Area Office.",!
 ;I BGPYWCHW=2 D ONEF I BGPONEF="" G SUM
 ;.;W !,"A Height/Weight File will be created and called: ",!?5,BGPFN,!?5,"and will reside in the ",BGPUF," directory. "
 ;.;W !,"Only 65,536 records will be placed into a file.  If your site has"
 ;.;W !,"more than 65,536 ht/wt records you will have multiple files,"
 ;.;W !,"all having the same name with the last 10 characters of the filename"
 ;.;W !,"being counter of the number of files (e.g. 001_of_003).These files"
 ;.;W !,"can be used in Excel.",!
 K IOP,%ZIS I BGPROT="D",BGPDELT="F" D NODEV,XIT Q
 K IOP,%ZIS W !! S %ZIS=$S(BGPDELT'="S":"PQM",1:"PM") D ^%ZIS
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDCB(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDPB(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDBB(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 I $D(ZTQUEUED) S ZTREQ="@"
 D ^BGP1D1
 U IO
 D ^BGP1DP
 D ^%ZISC
 I BGPEXPT D GS^BGP1UTL
 ;I $G(BGPEXCEL) D EXCELGS^BGP1UTL
 I $G(BGPYWCHW)=2 D HWSF
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
 S XBRP="",XBRC="NODEV1^BGP1DNG",XBRX="XIT^BGP1DNG",XBNS="BGP"
 D ^XBDBQUE
 Q
 ;
NODEV1 ;
 D ^BGP1D1
 D ^BGP1DP
 D ^%ZISC
 I BGPEXPT D GS^BGP1UTL
 ;I $G(BGPEXCEL) D EXCELGS^BGP1UTL
 I $G(BGPYWCHW)=2 D HWSF
 D XIT
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP1DNG",ZTDTH="",ZTDESC="NATIONAL GPRA REPORT 11" D ^%ZTLOAD D XIT Q
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
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
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
CHKY ;
 W !!,"The baseline year and the previous year time periods are the same.",!!
 S DIR(0)="Y",DIR("A")="Do you want to change the baseline year",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S Y="" Q
 Q
F ;fiscal year
 S (BGPPER,BGPVDT)=""
 W !!,"Enter the year for the report.  Use a 4 digit ",!,"year, e.g. 2011"
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
 ;count up total # of records and divide by 65,536
 I BGPONEF="O" D HWSF1 Q
 S BGPX=0,BGPTOT=0 F  S BGPX=$O(^BGPGPDCB(BGPRPT,88888,BGPX)) Q:BGPX'=+BGPX  S BGPTOT=BGPTOT+1
 S BGPNF1=BGPTOT/65536
 S BGPNF=$S($P(BGPNF1,".",2)]"":$P(BGPNF1,".")+1,1:BGPNF1)
 S BGPNF=$P(BGPNF,".")
 S BGPX=0,BGPLX=0
 F BGPZ=1:1:BGPNF D
 .S BGPFN="CRSHW"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D^BGP1UTL(BGPBD)_$$D^BGP1UTL(BGPED)_$$D^BGP1UTL(BGPHWNOW)_"_"_$$LZERO^BGP1UTL(BGPZ,3)_"_of_"_$$LZERO^BGP1UTL(BGPNF,3)_".TXT"
 .S Y=$$OPEN^%ZISH(BGPUF,BGPFN,"W")
 .I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file." Q
 .U IO
 .W "SERVICE UNIT^ASUFAC^UNIQUE DB ID^DATE RUN^BEG DATE^END DATE^PATIENT UID^DOB^TRIBE CODE^GENDER^STATE OF RESIDENCE^UNIQUE VISIT ID^DATE OF VISIT^TIME OF VISIT^HT CM^WT KG",!
 .S BGPC=1,BGPX=$S(BGPLX:BGPLX,1:0)
 .F  S BGPX=$O(^BGPGPDCB(BGPRPT,88888,BGPX)) Q:BGPX'=+BGPX!(BGPC>65535)  D
 ..W $G(^BGPGPDCB(BGPRPT,88888,BGPX,0)),!
 ..S BGPC=BGPC+1
 ..S BGPLX=BGPX
 .D ^%ZISC
 Q
HWSF1 ;EP
 ;write out one flie only
 S BGPZ=1,BGPFN="CRSHW"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D^BGP1UTL(BGPBD)_$$D^BGP1UTL(BGPED)_$$D^BGP1UTL(BGPHWNOW)_"_001_of_001.TXT"
 I '$D(ZTQUEUED) U IO W !?10,BGPFN
 S Y=$$OPEN^%ZISH(BGPUF,BGPFN,"W")
 I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file." Q
 U IO
 W "SERVICE UNIT^ASUFAC^UNIQUE DB ID^DATE RUN^BEG DATE^END DATE^PATIENT UID^DOB^TRIBE CODE^GENDER^STATE OF RESIDENCE^UNIQUE VISIT ID^DATE OF VISIT^TIME OF VISIT^HT CM^WT KG",!
 S BGPC=1,BGPX=0
 F  S BGPX=$O(^BGPGPDCB(BGPRPT,88888,BGPX)) Q:BGPX'=+BGPX  D
 .W $G(^BGPGPDCB(BGPRPT,88888,BGPX,0)),!
 .S BGPC=BGPC+1
 D ^%ZISC
 Q
 ;CHILDHOOD HT/WT
CHW ;
 W !!,"Height and Weight data is contained in this report.  Do you wish to create"
 W !,"a file of all the heights and weights in this file?  You can use this file"
 W !,"to upload to another system like SAS or Microsoft ACCESS."
 W !,"WARNING:  This file can be very large as it contains 1 record for each"
 W !,"height and weight taken on the patients in the active clinical population."
 W !,"This file may be too large for EXCEL.  If you don't plan on using this"
 W !,"data for a study some kind, please answer NO to the next question.",!
 S DIR(0)="Y",DIR("A")="Do you wish to create a HEIGHT/WEIGHT Output file",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G EXPORT
 I Y S BGPYWCHW=2 D  I BGPONEF="" G CHW
 .S BGPHWNOW=$$NOW^XLFDT() S BGPHWNOW=$P(BGPHWNOW,".")_"."_$$RZERO^BGP1UTL($P(BGPHWNOW,".",2),6)
 .I BGPUF="" W:'$D(ZTQUEUED) !!,"Cannot continue.....can't find export directory name. EXCEL file",!,"not written." Q
 .S BGPFN="CRSHW"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D^BGP1UTL(BGPBD)_$$D^BGP1UTL(BGPED)_$$D^BGP1UTL(BGPHWNOW)_"_001_of_001"_".TXT"
 .D ONEF
 .Q
 Q
