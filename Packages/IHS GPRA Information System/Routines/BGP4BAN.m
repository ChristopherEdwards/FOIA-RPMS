BGP4BAN ; IHS/CMI/LAB - BANNER FOR GPRA 04 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
BANNER ;EP
V ; GET VERSION
 NEW BGPV,BGPL,BGPJ,BGPX
 S BGPV="3.1"
 I $G(BGPTEXT)="" S BGPTEXT="TEXT",BGPL=4 G PRINT
 S BGPTEXT="TEXT"_BGPTEXT
 F BGPJ=1:1 S BGPX=$T(@BGPTEXT+BGPJ),BGPX=$P(BGPX,";;",2) Q:BGPX="QUIT"!(BGPX="")  S BGPL=BGPJ
PRINT W:$D(IOF) @IOF
 F BGPJ=1:1:BGPL S BGPX=$T(@BGPTEXT+BGPJ),BGPX=$P(BGPX,";;",2) W !,$$CTR(BGPX,80)
 W !,$$CTR("Version "_BGPV)
SITE W !!,$$CTR($$LOC)
 K BGPTEXT
 Q
TEXT ;
 ;;*******************************************************
 ;;**                  IHS/RPMS GPRA+                   **
 ;;**  Clinical Performance Indicator Reporting System  **
 ;;*******************************************************
 ;;QUIT
 ;
TEXT4 ;
 ;;*******************************************************
 ;;**                    GPRA+ FY04                     **
 ;;**  Clinical Performance Indicator Reporting System  **
 ;;*******************************************************
 ;;QUIT
TEXTR ;
 ;;**************************
 ;;**      GPRA+ FY04      **
 ;;**     Reports Menu     **
 ;;**************************
 ;;QUIT
TEXTX ;;
 ;;*****************************
 ;;**        GPRA+ FY04       **
 ;;**    Area Options Menu    **
 ;;*****************************
 ;;QUIT
 ;
TEXTS ;;
 ;;***********************
 ;;**     GPRA+ FY04    **
 ;;**     Setup Menu    **
 ;;***********************
 ;;QUIT
 ;
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
