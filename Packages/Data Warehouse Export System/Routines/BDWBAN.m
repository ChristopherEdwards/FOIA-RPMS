BDWBAN ; IHS/CMI/LAB - BANNER FOR DATA WAREHOUSE ;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
V ; GET VERSION
 S BDW("VERSION")="1.0"
 I $G(BDWTEXT)="" S BDWTEXT="TEXT",BDWLINE=3 G PRINT
 S BDWTEXT="TEXT"_BDWTEXT
 F BDWJ=1:1 S BDWX=$T(@BDWTEXT+BDWJ),BDWX=$P(BDWX,";;",2) Q:BDWX="QUIT"!(BDWX="")  S BDWLINE=BDWJ
PRINT W:$D(IOF) @IOF
 F BDWJ=1:1:BDWLINE S BDWX=$T(@BDWTEXT+BDWJ),BDWX=$P(BDWX,";;",2) W !?80-$L(BDWX)\2,BDWX K BDWX
 W !?80-(8+$L(BDW("VERSION")))/2,"Version ",BDW("VERSION")
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S BDW("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(BDW("SITE"))\2,BDW("SITE")
XIT ;
 K DIC,DA,X,Y,%Y,%,BDWJ,BDWX,BDWTEXT,BDWLINE
 Q
TEXT ;
 ;;********************************************
 ;;**           Data Warehouse Export        **
 ;;********************************************
 Q
TEXTB ;
 ;;******************************************
 ;;**       Data Warehouse Export Module   **
 ;;**           BACKLOAD DATA MENU         **
 ;;******************************************
 Q
TEXTR ;
 ;;******************************************
 ;;**       Data Warehouse Export Module   **
 ;;**            REPORTS MODULE            **
 ;;******************************************
 Q
