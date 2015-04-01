APCMBAN ; IHS/CMI/LAB - Banner routine for Management RPTS ;
 ;;1.0;IHS MU PERFORMANCE REPORTS;**2,4,5**;MAR 26, 2012;Build 5
V ; GET VERSION
 S APCM("VERSION")="1.0 (Patch 5)"  ;,APCM("VERSION")=$O(^DIC(9.4,"C","BJPC",APCM("VERSION"))),APCM("VERSION")=^DIC(9.4,APCM("VERSION"),"VERSION")
 I $G(APCMTEXT)="" S APCMTEXT="TEXT",APCMLINE=3 G PRINT
 S APCMTEXT="TEXT"_APCMTEXT
 F APCMJ=1:1 S APCMX=$T(@APCMTEXT+APCMJ),APCMX=$P(APCMX,";;",2) Q:APCMX="QUIT"!(APCMX="")  S APCMLINE=APCMJ
PRINT W:$D(IOF) @IOF
 F APCMJ=1:1:APCMLINE S APCMX=$T(@APCMTEXT+APCMJ),APCMX=$P(APCMX,";;",2) W !?80-$L(APCMX)\2,APCMX K APCMX
 W !,$$CTR("IHS Performance Measure Reports Version "_APCM("VERSION"))
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S APCM("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(APCM("SITE"))\2,APCM("SITE")
XIT ;
 K DIC,DA,X,Y,%Y,%,APCMJ,APCMX,APCMTEXT,APCMLINE,APCM
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
TEXT ;
 ;;*********************************
 ;;**   PCC Management Reports    **
 ;;*********************************
 ;;QUIT
TEXTB ;EP
 ;;********************************************
 ;;**         PCC Management Reports         **
 ;;**   Meaningful Use Performance Reports   **
 ;;**    2013 Stage 1 Performance Reports    **
 ;;********************************************
 ;;QUIT
TEXTA ;
 ;;********************************************
 ;;**         PCC Management Reports         **
 ;;**   Meaningful Use Performance Reports   **
 ;;**    2011 Stage 1 Performance Reports    **
 ;;********************************************
 ;;QUIT
TEXTC ;EP
 ;;********************************************
 ;;**         PCC Management Reports         **
 ;;**   Meaningful Use Performance Reports   **
 ;;** 2014/2015 Stage 1 Performance Reports  **
 ;;********************************************
 ;;QUIT
TEXTD ;EP
 ;;********************************************
 ;;**         PCC Management Reports         **
 ;;**   Meaningful Use Performance Reports   **
 ;;** 2014/2015 Stage 2 Performance Reports  **
 ;;********************************************
 ;;QUIT
