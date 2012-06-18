BDGCEN ; IHS/ANMC/LJF - CENSUS AID-LIST BY WARD ONLY ;  [ 08/20/2004  11:40 AM ]
 ;;5.3;PIMS;**1001**;APR 26, 2002
 ;
 NEW BDGWD,BDGED,BDGBD
 S BEGIN=$$GET1^DIQ(43,1,10,"I")   ;earliest G&L date
 S BEGIN=$$FMADD^XLFDT(BEGIN,-1)   ;initialize date
 S BDGWD=+$$READ^BDGF("PO^9009016.2:EQMZ","Select Ward") Q:BDGWD<1
 S BDGBD=$$READ^BDGF("DO^"_BEGIN_":"_DT_":EX","Select beginning date")
 Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^"_BEGIN_":"_DT_":EX","Select ending date")
 Q:BDGED<1
 ;
 I $$BROWSE^BDGF="B" D EN Q
 D ZIS^BDGF("QP","EN^BDGCEN","CENSUS AID1","BDGWD;BDGBD;BDGED")
 D HOME^%ZIS
 Q
 ;
EN ;EP; -- main entry point for BDG CENSUS AID1
 ;IHS/ITSC/WAR 11/13/03 added New 'BDGION' variable and S BDGION=ION
 ;    to remedy queing problem with printer. See line tag PRINT
 NEW VALMCNT,BDGION
 ;I $E(IOST,1,2)="P-" D INIT,PRINT Q
 ;I $E(IOST,1,2)="P-" S BDGION=IOP D INIT,PRINT Q
 I $E(IOST,1,2)="P-" S BDGION=ION D INIT,PRINT Q  ;IHS/ITSC/LJF 7/8/2004 PATCH #1001
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG CENSUS AID1")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S X=$$FMTE^XLFDT(BDGBD)_" to "_$$FMTE^XLFDT(BDGED)
 S VALMHDR(1)=$$SP(75-$L(X)\2)_X
 S X=$$GET1^DIQ(42,BDGWD,.01)          ;ward name
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW X
 K ^TMP("BDGCEN",$J),^TMP("BDGCEN0",$J)
 D GUIR^XBLM("^BDGCEN0","^TMP(""BDGCEN0"",$J,")
 S (X,VALMCNT)=0
 F  S X=$O(^TMP("BDGCEN0",$J,X)) Q:'X  D
 . S VALMCNT=VALMCNT+1
 . S ^TMP("BDGCEN",$J,VALMCNT,0)=^TMP("BDGCEN0",$J,X)
 K ^TMP("BDGCEN0",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGCEN",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
PRINT ; print report to paper
 NEW X,DGPAGE
 ;IHS/ITSC/WAR 11/13/03 added next line - queing was not working
 S IOP=BDGION D ^%ZIS
 U IO S DGPAGE=0 D HEAD^BDGCEN0
 ;
 S X=0 F  S X=$O(^TMP("BDGCEN",$J,X)) Q:'X  D
 . I $Y>(IOSL-4) D HEAD^BDGCEN0
 . W !,^TMP("BDGCEN",$J,X,0)
 ;
 D EXIT,^%ZISC
 Q
