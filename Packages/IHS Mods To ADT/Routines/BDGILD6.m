BDGILD6 ; IHS/ANMC/LJF - FACILITY TRANSFERS ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BDG ILD FACILITY TRANSFERS
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG ILD FACILITY TRANSFERS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S X="Transfers to/from "_$$GET1^DIQ(4,DUZ(2),.01)
 S VALMHDR(2)=$$SP(79-$L(X)\2)_X
 S X=$$FMTE^XLFDT(BDGBD)_" to "_$$FMTE^XLFDT(BDGED)
 S VALMHDR(3)=$$SP(79-$L(X)\2)_X
 ;
 I BDGTYP=1 S VALMCAP=$$PAD($$PAD($$PAD($$PAD($$PAD(" Admt/Dsch Date",17)_"Patient Name",41)_"HRCN",52)_"Serv",60)_"Facility",80)
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BDGILD6",$J)
 S VALMCNT=0
 D ^BDGILD61
 ;
 I '$D(^TMP("BDGILD6",$J)) D
 . S VALMCNT=1,^TMP("BDGILD6",$J,1,0)="No data found"
 ;
 Q
 ;
PRINT ; print report to paper
 NEW LINE,BDGPG
 U IO D INIT^BDGF,HDG
 ;
 S LINE=0 F  S LINE=$O(^TMP("BDGILD6",$J,LINE)) Q:'LINE  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGILD6",$J,LINE,0)
 ;
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading for paper report
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?13,"***",$$CONF^BDGF,"***"
 S X="Inter-Facility Transfers to/from "_$$GET1^DIQ(4,DUZ(2),.01)
 W !,BDGDATE,?(80-$L(X)\2),X,?71,"Page: ",BDGPG
 S X=$$FMTE^XLFDT(BDGBD)_" to "_$$FMTE^XLFDT(BDGED)
 W !,BDGTIME,?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("-",80)
 I BDGTYP=1 S X=$$PAD($$PAD($$PAD($$PAD($$PAD(" Admt/Dsch Date",17)_"Patient Name",41)_"HRCN",52)_"Serv",60)_"Facility",80)
 E  S X=$$PAD($$PAD($$PAD("Facility",27)_"Service",55)_"Tran In",70)_"Tran Out"
 W !,X,!,$$REPEAT^XLFSTR("=",80)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGILD6",$J)
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
