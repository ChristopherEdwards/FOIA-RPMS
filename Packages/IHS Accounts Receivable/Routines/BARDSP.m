BARDSP ; IHS/SD/LSL - VALM INTERFACE FOR A/R ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;; ;
EN ;EP - main entry point for BAR DISPLAY
 D EN^VALM("BAR DISPLAY")
 Q
 ; *********************************************************************
 ;
HDR ; -- header code
 Q
 ; *********************************************************************
 ;
INIT ; -- init variables and list array
 S VALMCNT=$O(^TMP("BAR",$J,BARNODE,""),-1)
 Q
 ; *********************************************************************
 ;
HELP ; -- help code
 S X="?"
 D DISP^XQORM1
 W !!
 Q
 ; *********************************************************************
 ;
EXIT ; -- exit code
 K ^TMP("BAR",$J,BARNODE)
 I '$G(XQORS) D CLEAR^VALM1
 Q
 ; *********************************************************************
 ;
EXPND ; -- expand code
 Q
 ; *********************************************************************
 ;
FILE(BARDIR,BARFN) ; EP
 ; Pull up a file into the TMP global for display
 N Y,X,I,BARNODE
 S BARNODE=$G(XQORS)+1
 S Y=$$OPEN^%ZISH(BARDIR,BARFN,"R")
 I Y W !,"NO OPEN" H 1 G FILE
 K ^TMP("BAR",$J)
 F I=1:1 U IO R X:1 Q:$$STATUS^%ZISH=-1  S ^TMP("BAR",$J,BARNODE,I,0)=X
 D ^%ZISC
 D EN^BARDSP
 K ^TMP("BAR",$J,BARNODE)
EFILE ;
 Q
 ; *********************************************************************
 ;
SFILE ; EP - SELECT FILE
OPEN ;
 D DT^DICRW
 D ^XBCLS
 W !!,"Select a Directory and File",!!
 K DIR
 S DIR(0)="F^1:30"
 S DIR("A")="Directory "
 S DIR("B")="/usr/mumps/"
 D ^DIR
 K DIR
 Q:Y["^"
 S BARXDIR=Y
 ;
FNAME ;
 K DIR
FNAME1 ;
 S DIR(0)="F^1:15"
 S DIR("A")="File Name "
 D ^DIR
 K DIR
 G:Y["^" OPEN
 I Y?.N,$D(BARXFL(Y)) S DIR("B")=BARXFL(Y) G FNAME1
 I Y["*" D
 .K BARXFL  D  G FNAME
 .. S X=$$LIST^%ZISH(BARXDIR,Y,.BARXFL)
 .. F BARXI=1:1 Q:'$D(BARXFL(BARXI))  W !,?5,BARXI,?10,BARXFL(BARXI)
 S BARXFN=Y
 S X=$$OPEN^%ZISH(BARXDIR,BARXFN,"R")
 ;
ES ;
 I X W !,"error on open of file ",BARXDIR,BARXFN,! D EOP^BARUTL(0) Q:Y=1  G FNAME
 D ^%ZISC
 D FILE^BARDSP(BARXDIR,BARXFN)
 ;
ESFILE ;
 Q
 ; *********************************************************************
 ;
FACE(DFN)          ;EP - display face sheet
 Q:'$G(DFN)
 N BARFN
 S BARFN="BAR"_$J
 ;
O ;
 S Y=$$OPEN^%ZISH("",BARFN,"W")
 I Y W !,"NO OPEN"
 U IO
 D START^AGFACE
 D ^%ZISC
 D FILE^BARDSP("",BARFN)
 S Y=$$DEL^%ZISH("",BARFN)
 Q
 ; *********************************************************************
 ;
FMCRIB ; EP
 ; call up the FM CRIB text from the A/R LETTERS & TEXT file
 D ARRAY^XBLM("^BAR(90052.03,1,1,")
 Q
