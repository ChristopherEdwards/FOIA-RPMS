AGSSP ; IHS/ASDS/EFG - PRINT SSN REPORTS ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;the report selection is loaded into an array:  AGSSP(report #)=type
S ;
 K AGSSP,AGSSP1,AGSSPC
 S DIC="^DIC(4,",DIC(0)="AEMQ"
 S DIC("A")="Reports for Facility?  "
 S DIC("B")=$P(^DIC(4,DUZ(2),0),"^",1)
 D ^DIC K DIC Q:+Y<0  S AGSSITE=+Y
 I '$G(^AGSSTEMP(AGSSITE,0,"END-PROCESS")) D  Q
 .W !!,"Process NOT complete for facility ",$P(^DIC(4,AGSSITE,0),"^",1),".",!!
 .K DIR S DIR(0)="E" D ^DIR K DIR
S1 D DISP
S1A F  D ASK Q:'$D(AGSSP1)
 I '$D(AGSSP) W !,"NO Reports Selected" Q
 G ASK2
ASK ;EP
 W ! I $D(AGSSP) D DISP W !,"You may continue to edit or add other reports"
 K DIR,AGSSP1 S DIR(0)="LO^1:5",DIR("A")="Please select the report or range of reports. ex 1,2,3-5 ",DIR("??")="^D DISP^AGSSP" D ^DIR
 Q:(+$G(DUOUT)+$G(DTOUT)+$G(DROUT)+$G(DIROUT))  Q:Y=""
 S AGSSP1=Y
 K DIR S DIR(0)="SO^S:Statistics;C:Complete",DIR("B")="S",DIR("A")="Please Select the type of report " D ^DIR
 Q:(+$G(DUOUT)+$G(DTOUT)+$G(DROUT)+$G(DIROUT))  Q:Y=""
 F AGSSI=1:1 S AGSSX=$P(AGSSP1,",",AGSSI) Q:'AGSSX  S AGSSP($E("VADNPX",AGSSX))=Y,AGSSPC(AGSSX)=Y
 Q
DISP ;EP
 W $$S^AGVDF("IOF")
 W ?15,"SSN VERIFICATION REPORTS",!
 W:'$D(AGSSP) !,"The user can select any combination of the following reports"
 W:'$D(AGSSP) !,"and the type, either Statistics or Complete.",!
 W:'$D(AGSSP) !,"First answer the range of reports and then the type of report",!,"for the range selected",!
 W:$D(AGSSP) !,"You have selected the following reports.",!
 F AGSSI=1:1:5 W !,?5,AGSSI,?10,$P($T(@AGSSI),";;",2) W:$D(AGSSPC(AGSSI)) ?50,$S(AGSSPC(AGSSI)["S":"Statistics",1:"Complete")
 ;
1 ;;`V` Verified by SSA 
2 ;;`A` Added by SSA 
3 ;;`D` Match SSA SSN but DATA differs (*)
4 ;;`N` Match SSA DATA but SSNs differ (*)
5 ;;`P` Potential and/or Pending SSNs  (*)
 ;
 W !!,"SSA SSN Matching Process Data >> IS ",$S($D(^AGSSTEMP(AGSSITE)):"",1:"NOT")," << available. "
 W !,"(*)  data from SSA Matching Process added if available",!
 Q
ASK2 K DIR S DIR(0)="Y",DIR("A")="Are You Satisfied with the above selection ?",DIR("B")="Y" D ^DIR
 I (+$G(DUOUT)+$G(DTOUT)+$G(DROUT)+$G(DIROUT))!(Y="") G END
 I Y=1 G CONT
 K DIR S DIR(0)="S^S:Start Over;R:Re-edit;E:Exit",DIR("A")="Please Select: ",DIR("B")="S" D ^DIR
 G:Y["S" S
 G:Y["R" S1A
 G END
CONT ;EP
 S XBRC="^AGSSR",XBRP="PRINT^AGSSR",XBRX="END^AGSSP",XBNS="AGS"
 D ^XBDBQUE
 Q
END ;EP - kill variables from all print routines
 D ^%ZISC
 I '$D(ZTSK),$D(AGSS("JOBID")) K ^AGSTEMP(AGSS("JOBID")) ;kill of temporary global
END2 ;Consolidated duplicate kills of variables
 K AGSS,AGSSI,AGSSX,AGSSP,AGSSC,AGSSN,AGSSP1,AGSSPC,AGSSPG
 K AGSSPIO,AGSSPHIO,AGSSPION
 K AGSSCSN,AGSSCSX,AGSSDOB,AGSSHDR,AGSSHRN,AGSSCPU
 K AGSI,AGSX,AGSY,AGSRA,AGSRV,AGSRP,AGSRN,AGSRD,ABSRR,AGSRX
 K AGSHRN,AGSDFN,AGSGLO
 K AGSCDOB,AGSCLN,AGSCMN,AGSCFN,AGSCNM,AGSCREC
 K AGSCSSN1,AGSCSSN2,AGSCSX,AGSCVC
 K AGSSASSN
 K AGSSCDOB,AGSSCFN,AGSSCHRN,AGSSCLN,AGSSCMN,AGSSCREC,AGSSCSSN
 K AGSSDT,AGSSVC,AGSSNM,AGSSROU,AGSSFLAG
 K AGSSLINE,AGSSPAT,AGSSREC
 K AG0,AGSUFAC
 K AGSLDOB,AGSLNM,AGSLSX,AGSLSSN,AGSLVC
 K DIR,DFN
 Q
