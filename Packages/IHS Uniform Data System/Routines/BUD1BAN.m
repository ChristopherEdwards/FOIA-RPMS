BUD1BAN ; IHS/CMI/LAB - Banner routine for UDS package ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;Writes all menu banners.
EP ;EP
V ; GET VERSION
 S BUD("VERSION")="",BUD("VERSION")=$O(^DIC(9.4,"C","BUD",BUD("VERSION"))),BUD("VERSION")=^DIC(9.4,BUD("VERSION"),"VERSION")
 S BUD("VERSION")="6.0"
 I $G(BUDTEXT)="" S BUDTEXT="TEXT",BUDLINE=4 G PRINT
 S BUDTEXT="TEXT"_BUDTEXT
 F BUDJ=1:1 S BUDX=$T(@BUDTEXT+BUDJ),BUDX=$P(BUDX,";;",2) Q:BUDX="QUIT"!(BUDX="")  S BUDLINE=BUDJ
PRINT W:$D(IOF) @IOF
 F BUDJ=1:1:BUDLINE S BUDX=$T(@BUDTEXT+BUDJ),BUDX=$P(BUDX,";;",2) W !?80-$L(BUDX)\2,BUDX K BUDX
 S X=$P(^DIC(4,DUZ(2),0),U)
 W !?80-$L(X)/2,X
 W !?80-(8+$L(BUD("VERSION")))/2,"Version ",BUD("VERSION")
XIT ;
 K DIC,DA,X,Y,%Y,%,BUDJ,BUDX,BUDTEXT,BUDLINE
 Q
TEXT ;uds
 ;;********************************************
 ;;**     RPMS UNIFORM DATA SYSTEM (UDS)     **
 ;;**                 2011                   **
 ;;********************************************
 ;;QUIT
TEXTR ;
 ;;**************************************
 ;;**  RPMS UNIFORM DATA SYSTEM (UDS)  **
 ;;**           2011 Reports           **
 ;;**************************************
 ;;QUIT
TEXTM ;manager utilities
 ;;**************************************
 ;;**  RPMS UNIFORM DATA SYSTEM (UDS)  **
 ;;**      2011 Manager Utilities      **
 ;;**************************************
 ;;QUIT
TEXTL ;;
 ;;**************************************
 ;;**  RPMS UNIFORM DATA SYSTEM (UDS)  **
 ;;** 2011 Patient and Provider Lists  **
 ;;**************************************
 ;;QUIT
TEXTA ;;
 ;;*******************************************************
 ;;**           RPMS UNIFORM DATA SYSTEM (UDS)          **
 ;;**          2011 Patient and Provider List           **
 ;;**  Lists for Tables Zip Code, 3A&3B, 4, 5, and 6A   **
 ;;*******************************************************
 ;;QUIT
TEXTB ;;
 ;;**************************************
 ;;**  RPMS UNIFORM DATA SYSTEM (UDS)  **
 ;;** 2011 Patient and Provider Lists  **
 ;;**       Lists for Table 6B         **
 ;;**************************************
 ;;QUIT
TEXTC ;;
 ;;**************************************
 ;;**  RPMS UNIFORM DATA SYSTEM (UDS)  **
 ;;** 2011 Patient and Provider Lists  **
 ;;**        Lists for Table 7         **
 ;;**************************************
 ;;QUIT
TEXTD ;;
 ;;**************************************
 ;;**  RPMS UNIFORM DATA SYSTEM (UDS)  **
 ;;** 2011 Patient and Provider Lists  **
 ;;**     Pregnant Patient Lists       **
 ;;**************************************
 ;;QUIT
TEXTE ;;
 ;;**************************************
 ;;**  RPMS UNIFORM DATA SYSTEM (UDS)  **
 ;;** 2011 Patient and Provider Lists  **
 ;;**   Hypertension Patient Lists     **
 ;;**************************************
 ;;QUIT
TEXTF ;;
 ;;**************************************
 ;;**  RPMS UNIFORM DATA SYSTEM (UDS)  **
 ;;** 2011 Patient and Provider Lists  **
 ;;**      Diabetes Patient Lists      **
 ;;**************************************
 ;;QUIT
