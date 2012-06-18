BDGCEN3 ; IHS/ANMC/LJF - CENSUS AID-PATIENT LISTS ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 NEW Y,X,BDGWD,BDGBD,BDGED
 S Y=$$READ^BDGF("Y","Print for ALL Wards","NO") Q:Y=U
 I Y=1 S BDGWD="A"          ;all wards
 E  D  Q:BDGWD<1            ;just one
 . S X="I +$P($G(^BDGWD(+Y,0)),U,3)'=""I"""
 . S BDGWD=+$$READ^BDGF("PO^42:EQMZ","Select Ward","","",X)
 ;
 S BDGBD=$$READ^BDGF("DO^:"_$$NOW^XLFDT_":EPR","Select beginning date and time") Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^"_BDGBD_":"_$$NOW^XLFDT_":EPR","Select ending date and time") Q:BDGED<1
 ;
 I $$BROWSE^BDGF="B" D EN Q
 D ZIS^BDGF("QP","EN^BDGCEN3","CENSUS AID4","BDGWD;BDGBD;BDGED")
 D HOME^%ZIS
 Q
 ;
 ;
EN ;EP; -- main entry point for BDG CENSUS AID4
 NEW VALMCNT,BDGPRT
 I $E(IOST,1,2)="P-" S BDGPRT=1 D INIT,PRINT Q
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG CENSUS AID4")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S X=$$FMTE^XLFDT(BDGBD)_" to "_$$FMTE^XLFDT(BDGED)
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 S X=$S(BDGWD="A":"For All Wards",1:"For "_$$GET1^DIQ(42,BDGWD,.01))
 S VALMHDR(3)=$$SP(79-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 I '$G(BDGPRT) D MSG^BDGF("Compiling list; please wait...",2,0)
 K ^TMP("BDGCEN3",$J),^TMP("BDGCEN31",$J)
 S VALMCNT=0
 D ^BDGCEN30,^BDGCEN31      ;compile data and put into display array
 I BDGWD="A" D ^BDGCEN32    ;summary page
 ;
 I '$D(^TMP("BDGCEN3",$J)) D SET^BDGCEN31("No data found",.VALMCNT)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGCEN3",$J) K BDGWD,BDGED,BDGBD,BDGSUB,BDGNB
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print report to paper
 NEW BDGLN,BDGPG,BDGSUM
 U IO D INIT^BDGF
 ;
 S BDGLN=0 F  S BDGLN=$O(^TMP("BDGCEN3",$J,BDGLN)) Q:'BDGLN  D
 . I ^TMP("BDGCEN3",$J,BDGLN,0)["<< SUMMARY PAGE >>" S BDGSUM=1 D HDG Q
 . I ^TMP("BDGCEN3",$J,BDGLN,0)["***" D HDG
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGCEN3",$J,BDGLN,0)
 ;
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading when printing to paper
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?13,"***",$$CONF^BDGF,"***"
 W !,BDGDATE,?30,"Ward Census Listing",?71,"Page: ",BDGPG
 NEW X S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 W !,BDGTIME,?(80-$L(X)\2),X
 ;
 ; column heading all pages except summary page
 I '$G(BDGSUM) D
 . W !,$$REPEAT^XLFSTR("-",80)
 . W !?3," Time",?22,"Patient Name",?55,"Chart #"
 . W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
