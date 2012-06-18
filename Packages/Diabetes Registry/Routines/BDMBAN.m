BDMBAN ; IHS/CMI/LAB - Banner routine for Management RPTS ; [ 12/28/2008 5:24 PM ]
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
V ; GET VERSION
 S BDM("VERSION")="",BDM("VERSION")=$O(^DIC(9.4,"C","BJPC",BDM("VERSION"))),BDM("VERSION")=^DIC(9.4,BDM("VERSION"),"VERSION")
 I $G(BDMTEXT)="" S BDMTEXT="TEXT",BDMLINE=3 G PRINT
 S BDMTEXT="TEXT"_BDMTEXT
 F BDMJ=1:1 S BDMX=$T(@BDMTEXT+BDMJ),BDMX=$P(BDMX,";;",2) Q:BDMX="QUIT"!(BDMX="")  S BDMLINE=BDMJ
PRINT W:$D(IOF) @IOF
 F BDMJ=1:1:BDMLINE S BDMX=$T(@BDMTEXT+BDMJ),BDMX=$P(BDMX,";;",2) W !?80-$L(BDMX)\2,BDMX K BDMX
 W !?80-(22+$L(BDM("VERSION")))/2,"IHS PCC Suite Version ",BDM("VERSION")
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S BDM("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(BDM("SITE"))\2,BDM("SITE")
XIT ;
 K DIC,DA,X,Y,%Y,%,BDMJ,BDMX,BDMTEXT,BDMLINE,BDM
 Q
TEXT ;
 ;;*********************************
 ;;**   IHS DIABETES MANAGEMENT   **
 ;;*********************************
 ;;QUIT
TEXTD ;EP
 ;;***********************************
 ;;**  Diabetes Management System   **
 ;;**  Diabetes Audit Report Menu   **
 ;;***********************************
 ;;QUIT
