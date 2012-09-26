BGP2BAN ; IHS/CMI/LAB - BANNER FOR CRS 11 13 Aug 2010 11:31 AM ; 21 Feb 2012  7:39 AM
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
 ;
BANNER ;EP
V ; GET VERSION
 NEW BGPV,BGPL,BGPJ,BGPX
 S BGPV="12.1"
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
 Q "CRS 2012, Version 12.1"
TEXT ;
 ;;****************************************************
 ;;**    IHS/RPMS CLINICAL REPORTING SYSTEM (CRS)    **
 ;;****************************************************
 ;;QUIT
 ;
TEXTN ;
 ;;*********************************
 ;;**      IHS/RPMS CRS 2012      **
 ;;**    National GPRA Reports    **
 ;;*********************************
 ;;QUIT
 ;
TEXTL ;
 ;;******************************************************
 ;;**                IHS/RPMS CRS 2012                 **
 ;;**   Reports for Local Use: IHS Clinical Measures   **
 ;;******************************************************
 ;;QUIT
 ;
TEXTO ;
 ;;*********************************
 ;;**      IHS/RPMS CRS 2012      **
 ;;**    Other National Reports   **
 ;;*********************************
 ;;QUIT
 ;
TEXTC ;
 ;;*********************************
 ;;**      IHS/RPMS CRS 2012      **
 ;;**    CMS Performance Report   **
 ;;*********************************
 ;;QUIT
 ;
TEXT6 ;
 ;;*********************************
 ;;**      IHS/RPMS CRS 2012      **
 ;;**  Clinical Reporting System  **
 ;;*********************************
 ;;QUIT
 ;
TEXTA ;;
 ;;***************************
 ;;**   IHS/RPMS CRS 2012   **
 ;;**   Report Automation   **
 ;;***************************
 ;;QUIT
 ;
TEXTR ;
 ;;**************************
 ;;**   IHS/RPMS CRS 2012  **
 ;;**     Reports Menu     **
 ;;**************************
 ;;QUIT
TEXTX ;;
 ;;***************************
 ;;**   IHS/RPMS CRS 2012   **
 ;;**  Area Office Options  **
 ;;***************************
 ;;QUIT
 ;
TEXTS ;;
 ;;**************************
 ;;**   IHS/RPMS CRS 2012  **
 ;;**       Setup Menu     **
 ;;**************************
 ;;QUIT
 ;
TEXTT ;;
 ;;***************************
 ;;**   IHS/RPMS CRS 2012   **
 ;;**  Taxonomy Setup Menu  **
 ;;***************************
 ;;QUIT
 ;
TEXTZ ;;
 ;;***************************
 ;;**   IHS/RPMS CRS 2012   **
 ;;**  Taxonomy Check Menu  **
 ;;***************************
 ;;QUIT
 ;
TEXTU ;;
 ;;*****************************
 ;;**    IHS/RPMS CRS 2012    **
 ;;**  Taxonomy Reports Menu  **
 ;;*****************************
 ;;QUIT
 ;;
TEXTG ;;
 ;;*********************************
 ;;**      IHS/RPMS CRS 2012      **
 ;;**  Lab Taxonomy Reports Menu  **
 ;;*********************************
 ;;QUIT
 ;;
TEXTP ;;
 ;;**************************************
 ;;**        IHS/RPMS CRS 2012         **
 ;;**  Patient Education Reports Menu  **
 ;;**************************************
 ;;QUIT
TEXTM ;;
 ;;****************************************
 ;;**          IHS/RPMS CRS 2012         **
 ;;**  Medication Taxonomy Reports Menu  **
 ;;****************************************
 ;;QUIT
TEXTMU ;
 ;;***********************************
 ;;**       IHS/RPMS CRS 2012       **
 ;;**  Meaningful Use Reports Menu  **
 ;;***********************************
 ;;QUIT
 ;;
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
