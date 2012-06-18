BCHBAN ; IHS/TUCSON/LAB - Banner routine for CHR package ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 ;Writes all menu banners.
EP ;EP
V ; GET VERSION
 S BCH("VERSION")="",BCH("VERSION")=$O(^DIC(9.4,"C","BCH",BCH("VERSION"))),BCH("VERSION")=^DIC(9.4,BCH("VERSION"),"VERSION")
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
 ;;**         CHRIS II Export Utility        **
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
 ;;**        Activity Workload Reports       **
 ;;********************************************
 ;;QUIT
TEXTA ;chris ii reports
 ;;********************************************
 ;;**      RPMS CHR/PCC REPORTING SYSTEM     **
 ;;**             CHRIS II REPORTS           **
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
