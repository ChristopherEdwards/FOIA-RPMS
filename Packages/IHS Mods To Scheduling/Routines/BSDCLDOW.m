BSDCLDOW ; IHS/ANMC/LJF - CLINIC LIST-DAY OF WEEK ;  [ 12/18/2003  2:22 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
START ;EP; entry from SDCLDOW
 I $E(IOST,1,2)="C-" D EN Q   ;browse
 ;IHS/ITSC/WAR 11/13/03 added New 'BDGION' variable and S BDGION=ION
 ;    to remedy queing problem with printer. See line tag PRINT
 N BDGION S BDGION=ION
 D INIT,PRINT Q              ;print on paper
 ;
EN ; -- main entry point for BSDRM DAY OF WEEK
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM DAY OF WEEK")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDCLDOW",$J),^TMP("BSDCLDOW1",$J)
 D GUIR^XBLM("START^SDCLDOW","^TMP(""BSDCLDOW1"",$J,")
 NEW X S X=0 F  S X=$O(^TMP("BSDCLDOW1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDCLDOW",$J,X,0)=^TMP("BSDCLDOW1",$J,X)
 K ^TMP("BSDCLDOW1",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDCLDOW",$J)
 D SDCLDOW^SDKILL K VAUTC,VAUTD
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; -- print display array on paper
 ;IHS/ITSC/WAR 11/13/03 added next line - queing was not working
 S IOP=BDGION D ^%ZIS
 U IO W @IOF
 NEW X S X=0 F  S X=$O(^TMP("BSDCLDOW",$J,X)) Q:'X  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BSDCLDOW",$J,X,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; -- reprint first 10 lines of display as heading
 W @IOF
 NEW Y F Y=1:1:10 W !,^TMP("BSDCLDOW",$J,Y,0)
 Q
