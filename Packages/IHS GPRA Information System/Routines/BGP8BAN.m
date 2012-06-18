BGP8BAN ; IHS/CMI/LAB - BANNER FOR CRS 08 ; 13 Aug 2008  11:31 AM
 ;;8.0;IHS CLINICAL REPORTING;**2,3**;MAR 12, 2008
 ;
 ;
BANNER ;EP
V ; GET VERSION
 NEW BGPV,BGPL,BGPJ,BGPX
 S BGPV="8.0, Patch 3"
 I $G(BGPTEXT)="" S BGPTEXT="TEXT",BGPL=3 G PRINT
 S BGPTEXT="TEXT"_BGPTEXT
 F BGPJ=1:1 S BGPX=$T(@BGPTEXT+BGPJ),BGPX=$P(BGPX,";;",2) Q:BGPX="QUIT"!(BGPX="")  S BGPL=BGPJ
PRINT W:$D(IOF) @IOF
 F BGPJ=1:1:BGPL S BGPX=$T(@BGPTEXT+BGPJ),BGPX=$P(BGPX,";;",2) W !,$$CTR(BGPX,80)
 W !,$$CTR("Version "_BGPV,80)
SITE W !!,$$CTR($$LOC,80)
 K BGPTEXT
 Q
RPTVER() ;EP
 Q "CRS 2008, Version 8.0 Patch 3"
TEXT ;
 ;;****************************************************
 ;;**    IHS/RPMS CLINICAL REPORTING SYSTEM (CRS)    **
 ;;****************************************************
 ;;QUIT
 ;
TEXTN ;
 ;;*********************************
 ;;**      IHS/RPMS CRS 2008      **
 ;;**    National GPRA Reports    **
 ;;*********************************
 ;;QUIT
 ;
TEXTL ;
 ;;******************************************************
 ;;**                IHS/RPMS CRS 2008                 **
 ;;**   Reports for Local Use: IHS Clinical Measures   **
 ;;******************************************************
 ;;QUIT
 ;
TEXTO ;
 ;;*********************************
 ;;**      IHS/RPMS CRS 2008      **
 ;;**    Other National Reports   **
 ;;*********************************
 ;;QUIT
 ;
TEXTC ;
 ;;*********************************
 ;;**      IHS/RPMS CRS 2008      **
 ;;**    CMS Performance Report   **
 ;;*********************************
 ;;QUIT
 ;
TEXT6 ;
 ;;*********************************
 ;;**      IHS/RPMS CRS 2008      **
 ;;**  Clinical Reporting System  **
 ;;*********************************
 ;;QUIT
 ;
TEXTR ;
 ;;**************************
 ;;**   IHS/RPMS CRS 2008  **
 ;;**     Reports Menu     **
 ;;**************************
 ;;QUIT
TEXTX ;;
 ;;***************************
 ;;**   IHS/RPMS CRS 2008   **
 ;;**  Area Office Options  **
 ;;***************************
 ;;QUIT
 ;
TEXTS ;;
 ;;**************************
 ;;**   IHS/RPMS CRS 2008  **
 ;;**       Setup Menu     **
 ;;**************************
 ;;QUIT
 ;
TEXTT ;;
 ;;***************************
 ;;**   IHS/RPMS CRS 2008   **
 ;;**  Taxonomy Setup Menu  **
 ;;***************************
 ;;QUIT
 ;
TEXTZ ;;
 ;;***************************
 ;;**   IHS/RPMS CRS 2008   **
 ;;**  Taxonomy Check Menu  **
 ;;***************************
 ;;QUIT
 ;
TEXTU ;;
 ;;*****************************
 ;;**    IHS/RPMS CRS 2008    **
 ;;**  Taxonomy Reports Menu  **
 ;;*****************************
 ;;QUIT
 ;;
TEXTG ;;
 ;;*********************************
 ;;**      IHS/RPMS CRS 2008      **
 ;;**  Lab Taxonomy Reports Menu  **
 ;;*********************************
 ;;QUIT
TEXTM ;;
 ;;****************************************
 ;;**          IHS/RPMS CRS 2008         **
 ;;**  Medication Taxonomy Reports Menu  **
 ;;****************************************
 ;;QUIT
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
XTMP(N,D) ;EP - set xtmp 0 node
 Q:$G(N)=""
 S ^XTMP(N,0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_$G(D)
 Q
