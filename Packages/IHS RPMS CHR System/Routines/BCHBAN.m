BCHBAN ; IHS/CMI/LAB - Banner routine for CHR package ; 
 ;;2.0;IHS RPMS CHR SYSTEM;;OCT 23, 2012;Build 27
 ;
 ;Writes all menu banners.
EP ;EP
V ; GET VERSION
 S BCH("VERSION")="",BCH("VERSION")=$O(^DIC(9.4,"C","BCH",BCH("VERSION"))),BCH("VERSION")="2.0"
 I $G(BCHTEXT)="" S BCHTEXT="TEXT",BCHLINE=3 G PRINT
 S BCHTEXT="TEXT"_BCHTEXT
 F BCHJ=1:1 S BCHX=$T(@BCHTEXT+BCHJ),BCHX=$P(BCHX,";;",2) Q:BCHX="QUIT"!(BCHX="")  S BCHLINE=BCHJ
PRINT W:$D(IOF) @IOF
 F BCHJ=1:1:BCHLINE S BCHX=$T(@BCHTEXT+BCHJ),BCHX=$P(BCHX,";;",2) W !?80-$L(BCHX)\2,BCHX K BCHX
 S X=$P(^DIC(4,DUZ(2),0),U)
 W !?80-$L(X)/2,X
 W !?80-(8+$L(BCH("VERSION")))/2,"Version ",BCH("VERSION")
XIT ;
 K DIC,DA,X,Y,%Y,%,BCHJ,BCHX,BCHTEXT,BCHLINE
 Q
HIPAA ;EP
 W !!,"THIS SYSTEM CONTAINS CONFIDENTIAL PATIENT INFORMATION CONVERED BY THE PRIVACY"
 W !,"ACT.  UNAUTHORIZED USE OF THIS DATA IS ILLEGAL.",!!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S XQUIT=1 Q
 I 'Y S XQUIT=1 Q
 Q
TEXT ;chr
 ;;*******************************************
 ;;**     RPMS CHR/PCC REPORTING SYSTEM     **
 ;;*******************************************
 ;;QUIT
TEXTR ;reports menu
 ;;********************************************
 ;;**      RPMS CHR/PCC REPORTING SYSTEM     **
 ;;**                 Reports                **
 ;;********************************************
 ;;QUIT
TEXTX ;export utility
 ;;********************************************
 ;;**      RPMS CHR/PCC REPORTING SYSTEM     **
 ;;**         CHR Export Utility        **
 ;;********************************************
 ;;QUIT
TEXTE ;data entry menu
 ;;*******************************************
 ;;**     RPMS CHR/PCC REPORTING SYSTEM     **
 ;;**             Data Entry Menu           **
 ;;*******************************************
 ;;QUIT
TEXTC ;activity record counts
 ;;********************************************
 ;;**      RPMS CHR/PCC REPORTING SYSTEM     **
 ;;**        Service Workload Reports       **
 ;;********************************************
 ;;QUIT
TEXTA ;chris ii reports
 ;;********************************************
 ;;**      RPMS CHR/PCC REPORTING SYSTEM     **
 ;;**             CHR REPORTS           **
 ;;********************************************
 ;;QUIT
TEXTT ;tables menu
 ;;********************************************
 ;;**      RPMS CHR/PCC REPORTING SYSTEM     **
 ;;**        Print CHR Standard Tables       **
 ;;********************************************
 ;;QUIT
TEXTB ;encounter/record reports
 ;;********************************************
 ;;**      RPMS CHR/PCC REPORTING SYSTEM     **
 ;;**        Encounter/Record Reports        **
 ;;********************************************
 ;;QUIT
TEXTM ;manager utilities
 ;;********************************************
 ;;**      RPMS CHR/PCC REPORTING SYSTEM     **
 ;;**            Manager Utilities           **
 ;;********************************************
 ;;QUIT
TEXTU ;UNDUP reports
 ;;********************************************
 ;;**      RPMS CHR/PCC REPORTING SYSTEM     **
 ;;**   Unduplicated Patient Count Reports   **
 ;;********************************************
 ;;QUIT
