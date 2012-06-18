BDGSEC2 ; IHS/ANMC/LJF - SENSITIVE PAT DISPLAY ; [ 01/16/2004  3:41 PM ]
 ;;5.3;PIMS;**1007,1008**;APR 26, 2002
 ;
 ;cmi/anch/maw 9/7/2007 mods for PATCH 1007 in PRINT
 ;
 D PID^VADPT6  ;set ID #
 ;I IOST'["C-" U IO D INIT,PRINT Q  ;cmi/anch/maw 9/7/2007 orig line
 I IOST'["C-" S BDGION=IO D INIT,PRINT Q  ;cmi/anch/maw 9/7/2007 per linda fels PATCH 1007
 ;
EN ; -- main entry point for BDG SECURITY DISPLAY
 NEW VALMCNT D TERM^VALM0
 D EN^VALM("BDG SECURITY DISPLAY")
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Sensitive Patient Access for "_DGRNG1_" to "_DGRNG2
 S VALMHDR(2)=$$PAD("Patient Name: "_DGNAM,40)_"  #"_$G(HRCN)
 S VALMHDR(2)=$$PAD(VALMHDR(2),50)_"Date of Birth : "_$$FMTE^XLFDT(DOB)
 Q
 ;
INIT ; -- init variables and list array
 NEW X
 K ^TMP("BDGSEC",$J),^TMP("BDGSEC2",$J)
 D GUIR^XBLM("START^DGSEC2","^TMP(""BDGSEC"",$J,")
 S X=0 F  S X=$O(^TMP("BDGSEC",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BDGSEC2",$J,X,0)=" "_^TMP("BDGSEC",$J,X)
 S VALMCNT=+$G(VALMCNT)
 K ^TMP("BDGSEC",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSEC2",$J),VALMCNT
 D KILL^AUPNPAT K VA,HRCN,DGDATE,DGTIME,DGUSR,DIC,VAERR
 D Q^DGSEC2
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; -- print report to paper
 S IOP=BDGION D ^%ZIS U IO K BDGION  ;cmi/anch/maw 9/7/2007 per linda fels PATCH 1007
 NEW LINE
 S LINE=0 D HD
 F  S LINE=$O(^TMP("BDGSEC2",$J,LINE)) Q:'LINE  D
 . I $Y>(IOSL-4) D HD
 . W !,$G(^TMP("BDGSEC2",$J,LINE,0))
 D ^%ZISC D EXIT
 Q
 ;
HD ; -- print heading
 W @IOF,!,"Sensitive Patient Access Report for ",DGRNG1," to ",DGRNG2
 S DGPGE=DGPGE+1 W ?70,"Page: ",DGPGE
 K DGLNE S $P(DGLNE,"=",80)="" W !,DGLNE,!,"Run Date    : "
 D H^DGUTL S Y=DGTIME W ?14 D DT^DIQ
 W ?47,"Patient ID Num: ",$G(HRCN)
 W !,"Patient Name: ",$S($D(DGNAM):DGNAM,1:"Unknown")
 W ?47,"Date of Birth : " S Y=$S($D(DOB):DOB,1:"Unknown") D DT^DIQ
 W !,DGLNE K DGLNE S $P(DGLNE,"-",80)=""
 W !!,"USER",?23,"DATE ACCESSED",?46,"OPTION/PROTOCOL USED"
 W ?70,"INPATIENT",!,DGLNE
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
