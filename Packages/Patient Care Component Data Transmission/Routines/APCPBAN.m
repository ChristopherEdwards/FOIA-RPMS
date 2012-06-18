APCPBAN ; IHS/TUCSON/LAB - BANNER FOR PCC DATA TRANSMISSION AUGUST 14, 1992 ; [ 04/03/98  08:39 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;;APR 03, 1998
V ; GET VERSION
 S APCP("VERSION")="",APCP("VERSION")=$O(^DIC(9.4,"C","APCP",APCP("VERSION"))),APCP("VERSION")=^DIC(9.4,APCP("VERSION"),"VERSION")
 I $G(APCPTEXT)="" S APCPTEXT="TEXT",APCPLINE=3 G PRINT
 S APCPTEXT="TEXT"_APCPTEXT
 F APCPJ=1:1 S APCPX=$T(@APCPTEXT+APCPJ),APCPX=$P(APCPX,";;",2) Q:APCPX="QUIT"!(APCPX="")  S APCPLINE=APCPJ
PRINT W:$D(IOF) @IOF
 F APCPJ=1:1:APCPLINE S APCPX=$T(@APCPTEXT+APCPJ),APCPX=$P(APCPX,";;",2) W !?80-$L(APCPX)\2,APCPX K APCPX
 W !?80-(8+$L(APCP("VERSION")))/2,"Version ",APCP("VERSION")
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S APCP("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(APCP("SITE"))\2,APCP("SITE")
XIT ;
 K DIC,DA,X,Y,%Y,%,APCPJ,APCPX,APCPTEXT,APCPLINE
 Q
TEXT ;
 ;;****************************************
 ;;**       PCC Data Transmission        **
 ;;****************************************
 Q
TEXTR ;
 ;;**************************************
 ;;**   PCC Data Transmission Module   **
 ;;**          REPORTS MODULE          **
 ;;**************************************
 Q
