BDPBAN ; IHS/CMI/TMJ - Banner for BDP ; 
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
EP ;
V ; GET VERSION
 S BDP("VERSION")="",BDP("VERSION")=$O(^DIC(9.4,"C","BJPC",BDP("VERSION"))),BDP("VERSION")=^DIC(9.4,BDP("VERSION"),"VERSION")
 I $G(BDPTEXT)="" S BDPTEXT="TEXT",BDPLINE=3 G PRINT
 S BDPTEXT="TEXT"_BDPTEXT
 F BDPJ=1:1 S BDPX=$T(@BDPTEXT+BDPJ),BDPX=$P(BDPX,";;",2) Q:BDPX="QUIT"!(BDPX="")  S BDPLINE=BDPJ
PRINT W:$D(IOF) @IOF
 F BDPJ=1:1:BDPLINE S BDPX=$T(@BDPTEXT+BDPJ),BDPX=$P(BDPX,";;",2) W !?80-$L(BDPX)\2,BDPX K BDPX
 W !?80-(22+$L(BDP("VERSION")))/2,"IHS PCC Suite Version ",BDP("VERSION")
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S BDP("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(BDP("SITE"))\2,BDP("SITE")
XIT ;
 K DIC,DA,X,Y,%Y,%,BDPJ,BDPX,BDPTEXT,BDPLINE
 Q
 ;
TEXT ;Designated Prov Mgr System Banner
 ;;**********************************************
 ;;** Designated Provider Management System    **
 ;;**********************************************
 ;;QUIT
TEXTR ;reports menu
 ;;**********************************************
 ;;** Designated Provider Management System    **
 ;;**                  Reports              **
 ;;**********************************************
 ;;QUIT
TEXTE ;data entry menu
 ;;**********************************************
 ;;** Designated Provider Management System    **
 ;;**             Data Entry Menu           **
 ;;**********************************************
 ;;QUIT
TEXTM ;manager utilities
 ;;**********************************************
 ;;** Designated Provider Management System    **
 ;;**            Manager Utilities          **
 ;;**********************************************
 ;;QUIT
