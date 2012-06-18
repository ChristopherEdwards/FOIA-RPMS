APCHSBAN ; IHS/CMI/LAB - Banner routine for Health Summary ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
V ; GET VERSION
 S APCH("VERSION")="",APCH("VERSION")=$O(^DIC(9.4,"C","BJPC",APCH("VERSION"))),APCH("VERSION")=^DIC(9.4,APCH("VERSION"),"VERSION")
 S APCHTEXT="TEXT"_APCHTEXT
 F APCHJ=1:1 S APCHX=$T(@APCHTEXT+APCHJ),APCHX=$P(APCHX,";;",2) Q:APCHX="QUIT"!(APCHX="")  S APCHLINE=APCHJ
PRINT W:$D(IOF) @IOF
 F APCHJ=1:1:APCHLINE S APCHX=$T(@APCHTEXT+APCHJ),APCHX=$P(APCHX,";;",2) W !?80-$L(APCHX)\2,APCHX K APCHX
 W !?80-(22+$L(APCH("VERSION")))/2,"IHS PCC Suite Version ",APCH("VERSION")
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S APCH("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(APCH("SITE"))\2,APCH("SITE")
XIT ;
 K DIC,DA,X,Y,%Y,%,APCHJ,APCHX,APCHTEXT,APCHLINE,APCH
 Q
TEXTH ;main menu
 ;;************************************
 ;;**        IHS Health Summary      **
 ;;************************************
 ;;QUIT
TEXTB ;build health summary menu
 ;;************************************
 ;;**        IHS Health Summary      **
 ;;**    Build Health Summary Menu   **
 ;;************************************
 ;;QUIT
TEXTM ;health summary maintenance menu
 ;;*************************************
 ;;**        IHS Health Summary       **
 ;;** Health Summary Maintenance Menu **
 ;;*************************************
 ;;QUIT
TEXTR ;health summary hmr menu
 ;;**************************************
 ;;**         IHS Health Summary       **
 ;;** Health Maintenance Reminder Menu **
 ;;**************************************
 ;;QUIT
TEXTP ;patient health summary menu
 ;;**************************************
 ;;**        IHS Health Summary        **
 ;;**   Patient Health Handouts Menu   **
 ;;**************************************
 ;;QUIT
