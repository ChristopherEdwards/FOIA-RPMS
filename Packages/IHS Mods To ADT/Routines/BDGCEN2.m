BDGCEN2 ; IHS/ANMC/LJF - CENSUS AID-LIST BY SERVICE ;  [ 12/18/2003  1:40 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
 NEW BDGED,BDGBD,BDGTX,BDGAGE
 S BDGTX=+$$READ^BDGF("PO^45.7:EMQZ","Select Treating Specialty") Q:BDGTX<1
 ;
 S BDGAGE=$$READ^BDGF("S^A:ADULT;P:PEDIATRIC","Adult or Pediatric Census","","^D AGE^BDGCEN2") Q:BDGAGE=""  Q:BDGAGE=U
 ;
 S BDGBD=$$READ^BDGF("DO^::EX","Select beginning date") Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^::EX","Select ending date") Q:BDGED<1
 ;
 I $$BROWSE^BDGF="B" D EN Q
 D ZIS^BDGF("QP","EN^BDGCEN2","CENSUS AID3","BDGTX;BDGBD;BDGED;BDGAGE")
 D HOME^%ZIS
 Q
 ;
 ;
AGE ;EP; help for Adult vs. Peds question
 D MSG^BDGF("This report displays either adult census figures",2,0)
 D MSG^BDGF("or pediatric ones.  Please choose one; A or P.",1,1)
 Q
 ;
 ;
EN ;EP; -- main entry point for BDG CENSUS AID3
 ;IHS/ITSC/WAR 11/13/03 added New 'BDGION' variable and S BDGION=ION
 ;    to remedy queing problem with printer. See line tag PRINT
 NEW VALMCNT,BDGION
 ;I $E(IOST,1,2)="P-" D INIT,PRINT Q
 I $E(IOST,1,2)="P-" S BDGION=ION D INIT,PRINT Q
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG CENSUS AID3")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S X=$$FMTE^XLFDT(BDGBD)_" to "_$$FMTE^XLFDT(BDGED)
 S VALMHDR(1)=$$SP(75-$L(X)\2)_X
 S X=$$GET1^DIQ(45.7,BDGTX,.01)_" ("_$S(BDGAGE="A":"Adult",1:"Pediatric")_")"
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW X
 K ^TMP("BDGCEN2",$J),^TMP("BDGCEN20",$J)
 D GUIR^XBLM("^BDGCEN20","^TMP(""BDGCEN20"",$J,")
 S (X,VALMCNT)=0
 F  S X=$O(^TMP("BDGCEN20",$J,X)) Q:'X  D
 . ;IHS/ITSC/WAR 11/13/03 problem with ^TMP("BDGCEN20" added 'IF'
 . ;      statement and second DO dot
 . I +$G(^TMP("BDGCEN20",$J,X))'=0 D
 .. S VALMCNT=VALMCNT+1
 .. S ^TMP("BDGCEN2",$J,VALMCNT,0)=^TMP("BDGCEN20",$J,X)
 K ^TMP("BDGCEN20",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGCEN2",$J)
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
 U IO S DGPAGE=0 D HEAD^BDGCEN20
 ;
 S X=0 F  S X=$O(^TMP("BDGCEN2",$J,X)) Q:'X  D
 . I $Y>(IOSL-4) D HEAD^BDGCEN20
 . W !,^TMP("BDGCEN2",$J,X,0)
 ;
 D EXIT,^%ZISC
 Q
