BGPMUDSL ; IHS/MSC/MMT - DISPLAY Measure LISTS ;02-Mar-2011 14:00;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;;
RT ;EP
 ;
 ;for each measure list, choose report type
 W !!,"Select List Type.",!
 W:'$G(BGP0NPLT) "NOTE:  If you select All Patients, your list may be",!,"hundreds of pages and take hours to print.",!
 S DIR(0)="S^D:Pts. Not in numerator;N:Pts in numerator;A:All Patients",DIR("A")="Choose report type for the Lists: " KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BGPQUIT="" K BGPLIST Q
 S BGPLIST=Y
 Q
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ1 ;EP
 K BGPMUGL,BGPTIND,BGPHIGH,BGPANS,BGPC,BGPGANS,BGPGC,BGPGI,BGPI,BGPX
 Q
 ;; ;
EN ;EP -- main entry point for  LIST DISPLAY
 D EN^VALM("BGPMU 11 LIST SELECTION")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="IHS Meaningful Use Clinical Quality Measure Lists of Patients"
 S VALMHDR(2)="* indicates the list has been selected"
 Q
 ;
INIT ; -- init variables and list array
 K BGPMUGL,BGPNOLI S BGPHIGH=""
 N X,C,I,O
 S (X,C,I,O)=0 F  S O=$O(^BGPMUIND(BGPMUYF,"ADO",O)) Q:O'=+O  S X=$O(^BGPMUIND(BGPMUYF,"ADO",O,0)) I $D(BGPIND(X)) D
 .S C=C+1 S BGPMUGL(C,0)=C_")",$E(BGPMUGL(C,0),5)=$P(^BGPMUIND(BGPMUYF,X,0),U,5),BGPMUGL("IDX",C,C)=X I $D(BGPLIST(X)) S BGPMUGL(C,0)="*"_BGPMUGL(C,0)
 ;.I $P(^BGPMUIND(BGPMUYF,X,0),U,5)="" S C=C+1 D
 ;..S BGPMUGL(C,0)=$P(^BGPMUIND(BGPMUYF,X,0),U,4)_" NO patient list available for measure:  ",BGPMUGL("IDX",C,C)=X,BGPNOLI(X)="" I $D(BGPLIST(X)) S BGPMUGL(C,0)="*"_BGPMUGL(C,0)
 S (VALMCNT,BGPHIGH)=C
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 W ! S DIR(0)="LO^1:"_BGPHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPGANS=Y,BGPGC="" F BGPGI=1:1 S BGPGC=$P(BGPGANS,",",BGPGI) Q:BGPGC=""  S BGPI=$O(BGPMUGL("IDX",BGPGC,0)) S BGPIND=BGPMUGL("IDX",BGPGC,BGPI) I $D(BGPIND(BGPIND)),'$D(BGPNOLI(BGPIND)) S BGPLIST(BGPIND)=""
ADDX ;
 D BACK
 Q
ADDALL ;
 F X=1:1:BGPHIGH S I=$G(BGPMUGL("IDX",X,X)) I $D(BGPIND(I)),'$D(BGPNOLI(I)) S BGPLIST(I)=""
 D BACK
 Q
 ;
REM ;
 W ! S DIR(0)="LO^1:"_BGPHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPGANS=Y,BGPGC="" F BGPGI=1:1 S BGPGC=$P(BGPGANS,",",BGPGI) Q:BGPGC=""  S I=$G(BGPMUGL("IDX",BGPGC,BGPGC)) K BGPLIST(I)
REMX ;
 D BACK
 Q
 ;
PT ;EP
 S (BGPROT,BGPDELT,BGPDELF)=""
 W !!,"Please choose an output type.  For an explanation of the delimited",!,"file please see the user manual.",!
 ;S DIR(0)="S^P:Print Report on Printer or Screen;D:Create Delimited output file (for use in Excel);B:Both a Printed Report and Delimited File;X:Create an XML output file",DIR("A")="Select an Output Option",DIR("B")="P" KILL DA D ^DIR KILL DIR
 S DIR(0)="S^P:Print Report on Printer or Screen;D:Create Delimited output file (for use in Excel);X:Create an XML output file",DIR("A")="Select an Output Option",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S BGPROT=Y
 Q:BGPROT="P"
 S BGPDELF="",BGPDELT=""
 W !!,"You have selected to create a "_$S(BGPROT="X":"XML",1:"delimited")_" output file.  You can have this"
 W !,"output file created as a text file in the pub directory, "
 W !,"OR you can have the "_$S(BGPROT="X":"XML",1:"delimited")_" output display on your screen so that"
 W !,"you can do a file capture.  Keep in mind that if you choose to do a"
 W !,"screen capture you CANNOT Queue your report to run in the background!!",!!
 S DIR(0)="S^S:SCREEN - "_$S(BGPROT="X":"XML",1:"delimited")_" output will display on screen for capture;F:FILE - "_$S(BGPROT="X":"XML",1:"delimited")_" output will be written to a file in pub"
 S DIR("A")="Select output type",DIR("B")="S" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PT
 S BGPDELT=Y
 Q:BGPDELT="S"
 I BGPROT'="X" D
 .S DIR(0)="F^1:40",DIR("A")="Enter a filename for the delimited output (no more than 40 characters)" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) G PT
 .S BGPDELF=Y
 I BGPROT="X" S BGPNOW=$$NOW^XLFDT,BGPDELF="XML."_$$INITIALS^BGPMUUT2(BGPPROV)_"."_$E(BGPNOW,2,12)_".xml"
 W !!,"When the report is finished your "_$S(BGPROT="X":"XML",1:"delimited")_" output will be found in the",!,$P($G(^AUTTSITE(1,1)),U,2)," directory.  The filename will be ",BGPDELF,$S(BGPROT="X":"",1:".txt"),!
 Q
 ;
PH ;EP prompt for output creation type (hospital measures)
 S (BGPROT,BGPDELT,BGPDELF)=""
 W !!,"Please choose an output type.  For an explanation of the delimited",!,"file please see the user manual.",!
 ;S DIR(0)="S^P:Print Report on Printer or Screen;D:Create Delimited output file (for use in Excel);B:Both a Printed Report and Delimited File;X:Create an XML output file",DIR("A")="Select an Output Option",DIR("B")="P" KILL DA D ^DIR KILL DIR
 S DIR(0)="S^P:Print Report on Printer or Screen;D:Create Delimited output file (for use in Excel);X:Create an XML output file",DIR("A")="Select an Output Option",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S BGPROT=Y
 Q:BGPROT="P"
 S BGPDELF="",BGPDELT=""
 W !!,"You have selected to create a "_$S(BGPROT="X":"XML",1:"delimited")_" output file.  You can have this"
 W !,"output file created as a text file in the pub directory, "
 W !,"OR you can have the "_$S(BGPROT="X":"XML",1:"delimited")_" output display on your screen so that"
 W !,"you can do a file capture.  Keep in mind that if you choose to do a"
 W !,"screen capture you CANNOT Queue your report to run in the background!!",!!
 S DIR(0)="S^S:SCREEN - "_$S(BGPROT="X":"XML",1:"delimited")_" output will display on screen for capture;F:FILE - "_$S(BGPROT="X":"XML",1:"delimited")_" output will be written to a file in pub"
 S DIR("A")="Select output type",DIR("B")="S" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PT
 S BGPDELT=Y
 Q:BGPDELT="S"
 I BGPROT'="X" D
 .S DIR(0)="F^1:40",DIR("A")="Enter a filename for the delimited output (no more than 40 characters)" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) G PT
 .S BGPDELF=Y
 I BGPROT="X" S BGPNOW=$$NOW^XLFDT,BGPDELF="XML.HOSPITAL."_$E(BGPNOW,2,12)_".xml"
 W !!,"When the report is finished your "_$S(BGPROT="X":"XML",1:"delimited")_" output will be found in the",!,$P($G(^AUTTSITE(1,1)),U,2)," directory.  The filename will be ",BGPDELF,$S(BGPROT="X":"",1:".txt"),!
 Q
