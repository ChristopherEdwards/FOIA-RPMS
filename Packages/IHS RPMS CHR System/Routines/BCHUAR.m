BCHUAR ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 16-AUG-1994 12 Apr 2006 10:24 AM ; 
 ;;2.0;IHS RPMS CHR SYSTEM;;OCT 23, 2012;Build 27
 ;; ;
START ; Write Header
 D EN^BCHUEKL ; -- kill all vars before starting
 D EN^XBVK("BCH") ;IHS/CMI/TMJ PATCH #16 Variable Kill
START1 W:$D(IOF) @IOF
 F J=1:1:5 S X=$P($T(TEXT+J),";;",2) W !?80-$L(X)\2,X
 K X,J
 W !!
 D ^BCHUIN ;Initialize vars, etc.
 ;loop through until user wants to quit
 S BCHPROV="" D GETPROV I BCHPROV  S BCHPROG="" D GETPROG I BCHPROG]""  S BCHDATE="" D GETDATE I BCHDATE  D EN,FULL^VALM1,EXIT
 D EOJ
 Q
 ;
RNS ;EP
 D EN^BCHUEKL
 D EN^XBVK("BCH")
 S BCHRNS=1
 G START1
UP1 ;
 D EN^BCHUEKL
 D EN^XBVK("BCH")
 S BCHF2=1
 G START1
ABB ;EP
 D EN^XBVK("BCH")
 D EN^BCHUEKL
 S BCHUABFO=1
 G START1
EOJ ;EOJ CLEANUP
 D ^BCHUEKL
 K BCHRNS
 Q
GETDATE ;EP  GET DATE OF ENCOUNTER
 G TEST
 S BCHDATE="",DIR(0)="DO^:"_DT_":EPT",DIR("A")="Enter DATE OF SERVICE" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S %DT="ET" D ^%DT G:Y<0 GETDATE
 I Y>DT W "  <Future dates not allowed>",$C(7),$C(7) K X G GETDATE
 S BCHDATE=Y
 D DD^%DT
 ;
TEST ;EP
 S BCHDATE="",DIR(0)="90002,.01O",DIR("A")="Enter DATE OF SERVICE" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S %DT="ET" D ^%DT G:Y<0 GETDATE
 I Y>DT W "  <Future dates not allowed>",$C(7),$C(7) K X G GETDATE
 S BCHDATE=Y
 D DD^%DT
 Q
GETPROV ;EP - GET PROVIDER
 S BCHPROV="",DIR(0)="90002,.03O",DIR("A")="Enter Provider (CHR)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=""
 S BCHPROV=+Y
 Q
 ;
GETPROG ;
 S BCHPROG=""
 K DIR,X,Y,DA S DIR(0)="90002,.02O",DIR("A")="Enter CHR PROGRAM" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S BCHPROG=Y,BCHPROG(0)=$P(Y(0),U)
 Q
EN ; EP -- main entry point for BCH UPDATE ACTIVITY RECORDS
 D TERM^VALM0
 S VALMCC=1
 D EN^VALM("BCH UPDATE ACTIVITY RECORDS")
 D CLEAR^VALM1
 Q
 ;
HDR ; EP -- header code
 S VALMHDR(1)=BCHDASH
 S VALMHDR(2)="Date of Encounter:  "_$$FTIME^VALM1(BCHDATE)_"      Program:  "_BCHPROG(0)
 S VALMHDR(3)="Provider (CHR): "_$P(^VA(200,BCHPROV,0),U)
 S VALMHDR(4)=BCHDASH
 I $E($G(BCHVRECS(1,0)))="N" S BCHRCNT=0,VALMHDR(5)=BCHVRECS(1,0) K BCHVRECS
 E  S VALMHDR(5)="  #  PATIENT NAME      HRN/CHR ID        ASSESSMENT                LOC  TRAVEL"
 Q
 ;
INIT ; -- init variables and list array
 D GATHER^BCHUARL ;gather up all records for display
 S VALMCNT=BCHRCNT
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K BCHRCNT,BCHVRECS
 K VALMCC,VALMHDR,VALMBCK,VALMCNT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
TEXT ;
 ;;CHR Data Entry Module
 ;;
 ;;************************
 ;;* Update CHR Records *
 ;;************************
 ;;
 Q
