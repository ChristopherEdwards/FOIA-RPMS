BDGCEN1 ; IHS/ANMC/LJF - CENSUS AID-LIST BY WARD & TX ;  [ 08/20/2004  11:40 AM ]
 ;;5.3;PIMS;**1001**;APR 26, 2002
 ;
 NEW BDGWD,BDGED,BDGBD,BDGTX,BDGAGE
 S BDGWD=+$$READ^BDGF("PO^9009016.2:EQMZ","Select Ward") Q:BDGWD<1
 S BDGTX=$$READ^BDGF("S^A:ALL TREATING SPECIALTIES;O:ONE SPECIALTY ONLY","Choose Report Format") Q:BDGTX=U
 I BDGTX="O" D  Q:BDGTX<1  Q:BDGAGE=U
 . S BDGTX=+$$READ^BDGF("PO^45.7:EMQZ","Within Ward, List Which Treating Specialty") Q:BDGTX<1
 . S BDGAGE=$$READ^BDGF("S^A:ADULT;P:PEDIATRIC","Adult or Pediatric Census","","^D AGE^BDGCEN1")
 ;
 S BDGBD=$$READ^BDGF("DO^::EX","Select beginning date") Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^::EX","Select ending date") Q:BDGED<1
 ;
 I $$BROWSE^BDGF="B" D EN Q
 D ZIS^BDGF("QP","EN^BDGCEN1","CENSUS AID2","BDGWD;BDGTX;BDGBD;BDGED;BDGAGE")
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
EN ;EP; -- main entry point for BDG CENSUS AID2
 ;IHS/ITSC/WAR 11/13/03 added New 'BDGION' variable and S BDGION=ION
 ;    to remedy queing problem with printer. See line tag PRINT
 NEW VALMCNT,BDGION
 ;I $E(IOST,1,2)="P-" D INIT,PRINT Q
 ;I $E(IOST,1,2)="P-" S BDGION=IOP D INIT,PRINT Q
 I $E(IOST,1,2)="P-" S BDGION=ION D INIT,PRINT Q  ;IHS/ITSC/LJF 7/8/2004 PATCH #1001
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG CENSUS AID2")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X,Y,Z
 S X=$$FMTE^XLFDT(BDGBD)_" to "_$$FMTE^XLFDT(BDGED)
 S VALMHDR(1)=$$SP(75-$L(X)\2)_X
 S X=$$GET1^DIQ(42,BDGWD,.01)
 S Y=$S(BDGTX="A":"All Treating Specialties",1:$$GET1^DIQ(45.7,BDGTX,.01))
 S Z=$S('$D(BDGAGE):"",BDGAGE="A":"(Adult)",1:"(Pediatric)")
 S X=X_" - "_Y_" "_Z,VALMHDR(2)=$$SP(79-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW X,RTN
 K ^TMP("BDGCEN1",$J),^TMP("BDGCEN10",$J)
 S RTN=$S(BDGTX="A":"^BDGCEN11",1:"^BDGCEN10")
 D GUIR^XBLM(RTN,"^TMP(""BDGCEN10"",$J,")
 S (X,VALMCNT)=0
 F  S X=$O(^TMP("BDGCEN10",$J,X)) Q:'X  D
 . S VALMCNT=VALMCNT+1
 . S ^TMP("BDGCEN1",$J,VALMCNT,0)=^TMP("BDGCEN10",$J,X)
 K ^TMP("BDGCEN10",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGCEN1",$J)
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
 U IO S DGPAGE=0 D HEAD^BDGCEN10
 ;
 S X=0 F  S X=$O(^TMP("BDGCEN1",$J,X)) Q:'X  D
 . I $Y>(IOSL-4) D HEAD^BDGCEN10
 . W !,^TMP("BDGCEN1",$J,X,0)
 ;
 D EXIT,^%ZISC
 Q
