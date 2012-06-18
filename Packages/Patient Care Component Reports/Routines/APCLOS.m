APCLOS ; IHS/CMI/LAB - PCC Operational Summary ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;CMI/TUCSON/LAB - patch 3 fixed FY date calculations
 ;
START ;
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",! Q
 W:$D(IOF) @IOF
 W !,"**********          PCC OPERATIONS SUMMARY REPORT          **********",!
 W !!,"This report displays data for a single month or for FY-to-Date for a specific",!,"facility or for the entire SU if all data for the SU is processed on this",!,"computer."
 W !!,"When selecting the period for which the report is to be run, consider whether",!,"or not all data has been entered for that period.",!!
 S APCLJOB=$J,APCLBTH=$H
SELTYP K DIC S DIC=9001003.1,DIC("A")="Select operations summary type: ",DIC(0)="AEQM"
 D ^DIC I Y<0 G EOJ
 S APCLRPT=+Y
 ;does this contain ambulatory?
 S Y=$O(^APCLOSC("B","AMBULATORY",0)),APCLAMBS=0,X=0 F  S X=$O(^APCLOST(APCLRPT,1,X)) Q:X'=+X  I $P(^APCLOST(APCLRPT,1,X,0),U,2)=Y S APCLAMBS=1
SU S B=$P(^AUTTLOC(DUZ(2),0),U,5) I B S S=$P(^AUTTSU(B,0),U),DIC("A")="Please Identify your Service Unit: "_S_"//"
 S DIC="^AUTTSU(",DIC(0)="AEMQZ" W ! D ^DIC K DIC
 I X="^" G EOJ
 I X="" S (APCLSU,APCLSUF)=B G SUF
 G:Y=-1 SUF
 S APCLSU=+Y,APCLSUF=$P(^AUTTSU(APCLSU,0),U)
SUF ;
 S APCLLOC="" D XTMP^APCLOSUT("APCLSU","PCC OPERATIONS SUMMARY") K APCLQUIT,^XTMP("APCLSU",APCLJOB,APCLBTH)
 K DIR S DIR(0)="S^O:ONE Particular Facility/Location;S:All Facilities within the "_$P(^AUTTSU(APCLSU,0),U)_" SERVICE UNIT;T:A TAXONOMY or selected set of Facilities"
 S DIR("A")="Enter a code indicating what FACILITIES/LOCATIONS are of interest",DIR("B")="O" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) EOJ
 S APCLLOCT=Y
 D @APCLLOCT
 G:$D(APCLQUIT) SUF
 I '$D(^XTMP("APCLSU",APCLJOB,APCLBTH)) W !!,$C(7),$C(7),"No facilities selected.",! G SUF
 W !!!,"Only patients who have charts at the facilities you selected will be included",!,"in this report.  Also, only visits to these locations will be counted in the ",!,"visit sections.",!
MFY ;MONTH OR FYTODATE
 W !!
 S DIR(0)="SO^1:A Single Month;2:Fiscal Year;3:Date Range",DIR("A")="Run report for" D ^DIR K DIR W !!
 G:$D(DIRUT) SUF
 S APCLMFY=Y
 G:Y=2 2
 G:Y=3 3
1 ;
 S %DT="AEP",%DT(0)="-NOW",%DT("A")="Enter the Month/Year: " D ^%DT I $D(DTOUT) G MFY
 I X="^" G MFY
 I Y=-1 D ERRM G 1
 I $E(Y,6,7)'="00" D ERRM G 1
 S APCLMON=Y
 S APCLFYB=$E(Y,1,5)_"01",APCLFYE=$E(Y,1,5)_"31"
 K %DT,Y,X
 G EXCL
2 ;
 S APCL("FYEND FLAG")=0
 D ^APCLFY
 ;beginning Y2K
 ;G:Y=-1 MFY ;Y2000
 G:APCL("FY")=-1 MFY ;Y2000
 ;I $G(APCL("FY"))=$E(DT,2,3)&(DT'>APCL("FY END DATE")) W !!?6,"Current FISCAL Year date range:  ",APCL("FY PRINTABLE BDATE")," - ",APCL("FY TODAY") ;Y2000
 I APCL("FY BEG DATE")>DT W $C(7),$C(7),!!?6,"You have selected a FY with a beginning date that is in the future!!",!,?6,$$FMTE^XLFDT(APCL("FY BEG DATE")),"  Select again!",! G 2 ;Y2000
 W !!?6,"FISCAL Year date range: ",$$FMTE^XLFDT(APCL("FY BEG DATE"))," - ",$S(APCL("FY END DATE")>DT:$$FMTE^XLFDT(DT),1:$$FMTE^XLFDT(APCL("FY END DATE"))) ;Y2000
 ;E  W !!?6,"FISCAL Year date range:  ",APCL("FY PRINTABLE BDATE")," - ",APCL("FY PRINTABLE EDATE") ;Y2000
 S APCLFYB=APCL("FY BEG DATE")
 ;S APCLFYBY=APCL("FY PRINTABLE BDATE") ;Y2000
 S APCLFYBY=$$FMTE^XLFDT(APCL("FY BEG DATE")) ;Y2000
 W !
 ;S:$G(APCL("FY"))=$E(DT,2,3)&(DT'>APCL("FY END DATE")) %DT("B")=APCL("FY TODAY") ;Y2000
 ;E  S %DT("B")=APCL("FY PRINTABLE EDATE") ;Y2000
 K %DT S %DT("B")=$S(APCL("FY END DATE")>DT:$$FMTE^XLFDT(DT),1:$$FMTE^XLFDT(APCL("FY END DATE"))) ;Y2000
 ;end Y2K
 ;S:$D(APCL("FY PRINTABLE EDATE")) %DT("B")=APCL("FY PRINTABLE EDATE")
 S %DT(0)="-NOW",%DT("A")="Enter As-of-Date: ",%DT="AEPX" W ! D ^%DT
 I Y=-1 G MFY
 I Y<APCL("FY BEG DATE") W !!,"As-of Date cannot be prior to Fiscal Beginning Date!",! H 2 G MFY
 S (X1,APCLFYE)=Y,X2=$S(+$E(Y,4,7)>930:0,1:-365) D C^%DTC
 G EXCL
3 ;date range
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G MFY
 S APCLFYB=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLFYB_":DT:EP",DIR("A")="Enter ending Visit Date:  " S Y=APCLFYB D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLFYE=Y
 ;
EXCL ;
 I 'APCLAMBS G ZIS
 K APCLEXCL,APCLDXT
 W !!,"Since you have chosen a operations summary type that contains the ambulatory",!,"section, you have the option of excluding certain ICD-9 diagnoses from the",!,"list of top ten diagnoses for ambulatory visits.",!
 W !,"For example, to eliminate Pharmacy refill diagnoses, you need to exclude",!,"V68.1 from this report."
 ;exclude any diagnoses codes?
 S APCLEXCL=""
 S DIR(0)="Y",DIR("A")="Do you wish to exclude any diagnoses codes from the ambulatory section",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G MFY
 S APCLEXCL=Y
EXCL1 ;which ones to exclude
 K APCLDXT
 I 'APCLEXCL G ZIS
 W !,"Enter the diagnoses to be excluded.",!
DX1 ;
 S X="DIAGNOSIS",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G EOJ
 D PEP^AMQQGTX0(+Y,"APCLDXT(")
 I '$D(APCLDXT) G EXCL
 I $D(APCLDXT("*")) K APCLDXT
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G MFY
 S Y=DT D DD^%DT S APCLDTP=Y
 S Y=APCLFYE D DD^%DT S APCLFYEY=Y
 W !!!,"THIS REPORT WILL SEARCH THE ENTIRE PATIENT FILE!",!!,"IT IS STRONGLY RECOMMENDED THAT YOU QUEUE THIS REPORT FOR A TIME WHEN THE",!,"SYSTEM IS NOT IN HEAVY USE!",!
 S XBRP="^APCLOSP",XBRC="^APCLOS1",XBRX="EOJ^APCLOS",XBNS="APCL"
 D ^XBDBQUE
 ;
EOJ ;ENTRY POINT
 D EOJ^APCLOSUT
 Q
O ;
 W ! S DIC("A")="Which Facility: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA I Y<0 S APCLQUIT=1 Q
 S ^XTMP("APCLSU",APCLJOB,APCLBTH,+Y)=""
 Q
S ;
 W !!,"Gathering up all the facilities..."
 S X=0 F  S X=$O(^AUTTLOC(X)) Q:X'=+X  I $P(^AUTTLOC(X,0),U,5)=APCLSU S ^XTMP("APCLSU",APCLJOB,APCLBTH,X)=""
 Q
T ;taxonomy - call qman interface
 K APCLLOC
 S X="ENCOUNTER LOCATION",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCLQUIT=1 Q
 D PEP^AMQQGTX0(+Y,"APCLLOC(")
 I '$D(APCLLOC) S APCLQUIT=1 Q
 I $D(APCLLOC("*")) K APCLLOC,^XTMP("APCLSU",APCLJOB,APCLBTH) W !!,$C(7),$C(7),"ALL locations is NOT an option with this report",! G T
 S X="" F  S X=$O(APCLLOC(X)) Q:X=""  S ^XTMP("APCLSU",APCLJOB,APCLBTH,X)=""
 K APCLLOC
 Q
ERRM W !,$C(7),$C(7),"Must be a valid Month/Year.  Enter only a Month and a Year!",! Q
