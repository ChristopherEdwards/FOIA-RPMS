BWUPDISP ;IHS/ANMC/MWR - UPLOAD: UNMATCHED REPORTS;15-Feb-2003 22:12;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  CALLED BY OPTION: "BW UPLD DISPLAY UNMATCHED" TO DISPLAY AND
 ;;  TRANSFER UNMATCHED LAB REPORTS.
 ;;
 ;
UNMATCHP ;EP
 ;---> CALLED BY OPTION: "BW UPLD PRINT ALL UNMATCHED".
 ;---> PRINT ALL UNMATCHED LAB RESULTS.
 D SETVARS^BWUTL5
 D TITLE^BWUTL5("PRINT UNMATCHED LAB RESULTS")
 S ZTRTN="UNMATCHQ^BWUPDISP"
 D ZIS^BWUTL2(.BWPOP,1)
 I BWPOP D EXIT Q
 ;
UNMATCHQ ;EP
 ;---> QUEUE PRINT OF UNMATCHED LAB RESULTS STARTS HERE.
 D SETVARS^BWUTL5
 N N S N=0
 F  S N=$O(^BWRUN("B",N)) Q:N=""!(BWPOP)  D
 .S M=0
 .F  S M=$O(^BWRUN("B",N,M)) Q:M=""!(BWPOP)  D
 ..S BWY=M D DISPLAY1
 D ^%ZISC,EXIT
 Q
 ;
EXIT ;EP
 D KILLALL^BWUTL8
 Q
 ;
UNMATCH ;EP
 ;---> CALLED BY OPTION: "BW UPLD DISPLAY UNMATCHED".
 ;---> LOOKUP AND DISPLAY UNMATCHED LAB RESULTS.
 D SETVARS^BWUTL5
 S (BWPOP1,BWPOP)=0,ZTRTN="DISPLAY1^BWUPDISP"
 F  Q:BWPOP1  D
 .D TITLE^BWUTL5("DISPLAY UNMATCHED LAB RESULTS")
 .W !!,"   Select the unmatched lab result you wish to display."
 .N A S A="   Select ACCESSION# or PATIENT: ",BWPOP=0
 .D DIC^BWFMAN(9002086.86,"QEMA",.Y,A)
 .I Y<0 S BWPOP1=1 Q
 .S (BWY,BWYY)=+Y
 .D DEVICE Q:BWPOP
 .D DISPLAY1,^%ZISC
 .D COPY
 D EXIT
 Q
 ;
COPY ;EP
 S BWPOP=0
 D TITLE^BWUTL5("DISPLAY UNMATCHED LAB RESULTS")
 W !!,"Do you wish to store this report under a Patient's Procedure?"
 S DIR(0)="Y",DIR("B")="NO" D HELP1
 D ^DIR K DIR W !
 Q:$D(DIRUT)!('Y)
 W !!,"Select the Patient's Procedure that will receive this report.",!
 D LKUPPCD^BWPROC(.Y)
 Q:Y<0!($D(DIROUT))
 ;---> SET BWY=IEN OF PROCEDURE IN PROCEDURE FILE 9002086.1.
 S BWY=+Y
 D TOP^BWPRPCD(BWY) S BWPOP=0
 S BWACC=$P(^BWPCD(BWY,0),U)
 D TITLE^BWUTL5("DISPLAY UNMATCHED LAB RESULTS")
 W !!,"   Do you wish to store this Unmatched Lab Report under the "
 W "Procedure",!,"   just displayed (",BWACC,")?"
 W !!?3,"(NOTE: Any data in the Results Text of this Procedure will be"
 W !?10,"deleted and then replaced with the Unmatched Lab Report.)",!
 S DIR(0)="Y",DIR("B")="NO" D HELP2
 D ^DIR K DIR W !
 Q:$D(DIRUT)!('Y)
 ;
 ;---> PUT UNMATCHED LAB REPORT TEXT INTO LOCAL BW1(N) ARRAY.
 S N=0 F  S N=$O(^BWRUN(BWYY,1,N)) Q:'N  D
 .S BW1(N)=^BWRUN(BWYY,1,N,0)
 ;
 ;---> TRANSFER REPORT TEXT FROM LOCAL ARRAY INTO SELECTED PROCEDURE.
 ;---> FIRST PARAMETER="DONE" TELLS BWUPTRAN FORMAT INTO BW1 ARRAY
 ;---> IS ALREADY DONE (I.E., DON'T CALL FORMAT^BWUPRNI1).
 D TRANSFER^BWUPTRAN("DONE",BWY)
 ;
 I BWPOP D  Q
 .W !!,"The Procedure, ",BWACC,", is being edited by another user."
 .W !,"The procedure was not moved out of the Unmatched Reports file."
 .D DIRZ^BWUTL3
 W !!,"   The Unmatched Lab Report has now been stored under the"
 W " Procedure ",BWACC,"."
 S DIK="^BWRUN(",DA=BWYY D ^DIK
 W !,"   The Unmatched Lab Report has been deleted."
 W !,"   The Procedure ",BWACC," now contains the following data:"
 D TOP^BWPRPCD(BWY)
 Q
 ;
DELETE ;EP
 ;---> CALLED BY OPTION: "BW UPLD DELETE UNMATCHED", DELETES UNMATCHED
 ;---> LAB RESULTS.
 ;---> CALLED BY OPTION: "BW UPLD DISPLAY UNMATCHED".
 ;---> LOOKUP AND DISPLAY UNMATCHED LAB RESULTS.
 D SETVARS^BWUTL5 S BWPOP1=0
 F  Q:BWPOP1  D
 .D TITLE^BWUTL5("DELETE UNMATCHED LAB RESULTS")
 .W !!,"   Select the unmatched lab result you wish to delete."
 .N A S A="   Select ACCESSION# or PATIENT: ",BWPOP=0
 .D DIC^BWFMAN(9002086.86,"QEMA",.Y,A)
 .I Y<0 S BWPOP1=1 Q
 .S BWY=+Y
 .W !!,"   Do you wish to display this unmatched result first?"
 .S DIR("?")="   Enter YES to display the unmatched result before "
 .S DIR("?")=DIR("?")_"deciding to delete it."
 .S DIR(0)="Y",DIR("A")="   Enter Yes or No",DIR("B")="NO"
 .D ^DIR W !
 .I $D(DIRUT) S BWPOP=1 Q
 .I Y D DEVICE Q:BWPOP  D DISPLAY1,^%ZISC
 .W !!,"   Do you wish to delete this unmatched result now?"
 .S DIR("?")="   Enter YES to delete this unmatched result."
 .S DIR(0)="Y",DIR("A")="   Enter Yes or No",DIR("B")="NO"
 .D ^DIR W !
 .I $D(DIRUT) S BWPOP=1 Q
 .I Y S DIK="^BWRUN(",DA=BWY D ^DIK  W "   ...DELETED." D DIRZ^BWUTL3
 D EXIT
 Q
 ;
DISPLAY1 ;EP
 ;---> DISPLAY AN UNMATCHED LAB REPORT.
 ;---> REQUIRED VARIABLE: BWY=IEN "BW UPLD UNMATCHED LAB REPORTS" FILE.
 ;---> BWCRT=1 IF OUTPUT IS TO SCREEN.
 ;
 N BWTITLE,DIR,N,X
 D SETVARS^BWUTL5
 U IO
 S BWCRT=$S($E(IOST)="C":1,1:0)
 S BWPRMT1="   Press RETURN to continue or '^'to exit, or"
 S BWCONFF="*********************** CONFIDENTIAL PATIENT INFORMATION "
 S BWCONFF=BWCONFF_"***********************"
 S BWTITLE="-  UNMATCHED LAB REPORT:  -" D CENTERT^BWUTL5(.BWTITLE)
 W:BWCRT @IOF
 W !,BWCONFF,!!,BWTITLE,!
 ;
 W !,"ACCESSION#: ",$P(^BWRUN(BWY,0),U)
 W ?41,"PATIENT: ",$P(^BWRUN(BWY,0),U,3)
 S X=$P(^BWRUN(BWY,0),U,2)
 W !,"REASON    : ",$P($P(^DD(9002086.86,.02,0),X_":",2),";"),! K X
 ;
 W !!?15," -----  TEXT OF LAB RESULT  -----",!
 S N=0
 F  S N=$O(^BWRUN(BWY,1,N)) Q:'N!(BWPOP)  D
 .I $Y+6>IOSL D DIRZ^BWUTL3 Q:BWPOP  W @IOF
 .W !,^BWRUN(BWY,1,N,0)
 D:BWCRT&('BWPOP) DIRZ^BWUTL3 W @IOF
 Q
 ;
DEVICE ;EP
 ;---> GET DEVICE AND POSSIBLY QUEUE TO TASKMAN.
 S ZTRTN="DISPLAY1^BWUPDISP"
 F BWSV="CRT","Y" D
 .I $D(@("BW"_BWSV)) S ZTSAVE("BW"_BWSV)=""
 D ZIS^BWUTL2(.BWPOP,1)
 Q
 ;
HELP1 ;EP
 ;;Answer "YES" to look up and review a Patient's Procedure.
 ;;You will then be given an opportunity to copy this Unmatched Report
 ;;into that Procedure.
 S BWTAB=5,BWLINL="HELP1" D HELPTX
 Q
 ;
HELP2 ;EP
 ;;Answer "YES" to if you wish to store this Unmatched Lab Report under
 ;;the Results Text of the Procedure that was just displayed.
 ;;
 ;;Note: In order to avoid confusion, it may help to begin over again
 ;;and to PRINT both the Unmatched Lab Report and the Procedure; this is
 ;;done by selecting a printer instead of HOME at the "DEVICE:" prompt.
 S BWTAB=5,BWLINL="HELP2" D HELPTX
 Q
 ;
HELPTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
 ;
DISPTAB ;EP
 ;---> CALLED BY OPTION: "BW UPLD LAB DISPLAY ABBREV".
 ;---> OPTION REMOVED FROM "BW MENU-LAB UPLD TABLS/RESULTS", BUT COULD
 ;---> BE RECREATED IF NEEDED.
 D SETVARS^BWUTL5 N DIC,Y
 F  Q:BWPOP  D
 .D TITLE^BWUTL5("DISPLAY LAB RESULTS TABLE ENTRIES")
 .W "Select the Abbreviation of the Results Text you wish to display."
 .D DIC^BWFMAN(9002086.85,"QEMA",.Y,"   Select ABBREVIATION: ")
 .I Y<0 S BWPOP=1 Q
 .S BWY=+Y
 .W !!!?3,$P(^BWTFNI(BWY,0),U)
 .S N=0
 .F  S N=$O(^BWTFNI(BWY,1,N)) Q:'N  D
 ..W ?15,^BWTFNI(BWY,1,N,0),!
 .D DIRZ^BWUTL3
 D EXIT
 Q
