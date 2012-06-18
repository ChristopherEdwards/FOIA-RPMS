BARLN0 ; IHS/SD/LSL - LISTMAN DRIVER FOR LINK 02-FEB-1996 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;; ;
EN ; EP -- main entry point for BAR LINK
 D EN^VALM("BAR LINK")
 Q
 ; *********************************************************************
 ;
HDR ; -- header code
 Q
 ; *********************************************************************
 ;
INIT ; -- init variables and list array
 D VIEW^BARLN0(XBROU)
 S VALMCNT=$O(^TMP("BAR LINK",$J,XBNODE,""),-1)
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
 Q
 ; *********************************************************************
 ;
EXPND ; -- expand code
 Q
 ; *********************************************************************
 ;
LMFUN ;
VIEW(XBROU)         ;EP
 ; ** USING XBROU print to a host file for viewing
 I '$D(XBHDR) S XBHDR=""
 U IO(0)
 D WAIT^DICD
 S Y=$$PWD^%ZISH(.XBDIR)
 S XBDIR=XBDIR(1)
 S XBFN="XB"_$J
 S X=$$OPEN^%ZISH(XBDIR,XBFN,"W")
 S IOST="P-DEC",IOST(0)=$O(^%ZIS(2,"B","P-DEC",0))
 S IOSL=6000
 S IOF="#"
 U IO
 D @XBROU
 D ^%ZISC
 D HOME^%ZIS
 I '$D(XBHDR) S XBHDR=""
 N Y,X,I
 S XBNODE=$G(XQORS)+1
 S Y=$$OPEN^%ZISH(XBDIR,XBFN,"R")
 I Y W !,"NO OPEN" H 1 Q
 K ^TMP("BAR LINK",$J,XBNODE)
 F I=1:1 U IO R X:DTIME S X=$$STRIP(X) S ^TMP("BAR LINK",$J,XBNODE,I,0)=X Q:$$STATUS^%ZISH=-1
 D ^%ZISC
 S X=$$DEL^%ZISH(XBDIR,XBFN)
 K XBDIR,XBFN,XBHDR
 K XBDIR,XBFN
 Q
 ; *********************************************************************
 ;
EFILE Q
 ; *********************************************************************
 ;
STRIP(Z) ;
 ; REMOVE CONTROLL CHARACTERS
 N I F I=1:1:$L(Z) I (32>$A($E(Z,I))) S Z=$E(Z,1,I-1)_" "_$E(Z,I+1,999)
 Q Z
 ; *********************************************************************
 ;
KILL ;
 K ^TMP("BAR LINK",$J,XBNODE)
 Q
