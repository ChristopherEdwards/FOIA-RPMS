BUD6BAN ; IHS/CMI/LAB - Banner routine for UDS package ;
 ;;6.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2012;Build 25
 ;
 ;Writes all menu banners.
EP ;EP
V ; GET VERSION
 S BUD("VERSION")="",BUD("VERSION")=$O(^DIC(9.4,"C","BUD",BUD("VERSION"))),BUD("VERSION")=^DIC(9.4,BUD("VERSION"),"VERSION")
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
 ;;**                 2006                   **
 ;;********************************************
 ;;QUIT
TEXTR ;
 ;;**************************************
 ;;**  RPMS UNIFORM DATA SYSTEM (UDS)  **
 ;;**           2006 Reports           **
 ;;**************************************
 ;;QUIT
TEXTM ;manager utilities
 ;;**************************************
 ;;**  RPMS UNIFORM DATA SYSTEM (UDS)  **
 ;;**        2006 Manager Utilities    **
 ;;**************************************
 ;;QUIT
TEXTL ;;
 ;;**************************************
 ;;**  RPMS UNIFORM DATA SYSTEM (UDS)  **
 ;;**          2006 User Lists         **
 ;;**************************************
 ;;QUIT
