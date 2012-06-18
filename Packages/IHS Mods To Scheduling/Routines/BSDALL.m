BSDALL ; IHS/ANMC/LJF - IHS APPT LIST - LT CODE ; 
 ;;5.3;PIMS;**1004,1011**;MAY 28, 2004
 ;IHS/OIT/LJF 07/20/2005 PATCH 1004 moved spacing of heading
 ;
 ;
 ;cmi/flag/maw 10/05/2009 PATCH 1011 RQMT73 allow multiple dates for appointment list
 ;
EN ;EP; -- main entry point for appt list list template
 ;cmi/maw 10/5/2009 PATCH 1011 RQMT73 code follows
 I IOST'["C-" D  Q
 . NEW BSDPRT
 . S BSDPRT=1 D INIT
 . F BSDI=1:1:BSDCOPY W:BSDI>1 @IOF D PRINT  ;print # of copies desired
 . D ^%ZISC,EXIT
 .;
 ;I IOST'["C-" D  Q
 ;. N BSDDA
 ;. S BSDDA=0 F  S BSDDA=$O(BSDD(BSDDA)) Q:'BSDDA  D
 ;.. S BSDD=+$G(BSDD(BSDDA))
 ;.. NEW BSDPRT
 ;.. S BSDPRT=1 D INIT
 ;.. F BSDI=1:1:BSDCOPY W:BSDI>1 @IOF D PRINT  ;print # of copies desired
 ;. D ^%ZISC,EXIT
 ;.;
 I IOST["C-" D  Q
 . S BSDD=$S($O(BSDD("")):$G(BSDD($O(BSDD("")))),1:$G(BSDD))
 . NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 . D EN^VALM("BSDAM APPT LIST LONG")
 . D CLEAR^VALM1
 ;cmi/maw PATCH 1011 orig
 ;NEW BSDPRT
 ;I IOST'["C-" D  Q    ;printing to paper
 ;. S BSDPRT=1 D INIT
 ;. F BSDI=1:1:BSDCOPY W:BSDI>1 @IOF D PRINT  ;print # of copies desired
 ;. D ^%ZISC,EXIT
 ;
 ;NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 ;D EN^VALM("BSDAM APPT LIST LONG")
 ;D CLEAR^VALM1
 Q
 ;
HDR ;EP; -- header code
 S VALMHDR(1)=$$REPEAT^XLFSTR(" ",10)_$$CONF^BDGF
 S X=$$PAD(" Time",7)_$$PAD("Patient Name",19)_$$PAD("HRCN",10)
 ;S VALMHDR(2)=X_"DOB (Age)    Lab@     X-Ray@     EKG@"
 S VALMHDR(2)=X_"DOB (Age)        Lab@     X-Ray@     EKG@"   ;IHS/OIT/LJF 7/20/2005 PATCH 1004
 S VALMHDR(3)=$$SP(9)_"Insurance & Appointment Information"
 Q
 ;
INIT ;EP; -- init variables and list array
 K ^TMP("BSDAL",$J) S VALMCNT=0
 D START^BSDAL2
 Q
 ;
PRINT ; -- print list to paper
 NEW BSDN,BSDT,BSDLN,BSDPG,BSDSAV,BDGLNS
 U IO D INIT^BDGF    ;initialize heading variables - BDG namespaced
 S X=3 S:BSDAMB X=4 I (BSDPH)!(BSDPCMM) S X=X+1
 S BSDLNS=X+4     ;# of lines per patient depending on data asked for
 S BSDN=0
 F  S BSDN=$O(^TMP("BSDAL",$J,BSDN)) Q:'BSDN  D
 . S BSDLN=^TMP("BSDAL",$J,BSDN,0)
 . I $E(BSDLN,1,5)="@@@@@" S BSDSAV=$P(BSDLN,"@@@@@",2) D HDG Q
 . I BSDLN="",($Y>(IOSL-BSDLNS)) D HDG
 . I $Y>(IOSL-4) D HDG
 . W !,BSDLN
 Q
 ;
HDG ;Print report header
 S BSDPG=$G(BSDPG)+1 I BSDPG>1 W @IOF
 W !?11,"*****",$$CONF^BDGF,"*****",?70,$J(BDGTIME,9)
 W !?(80-$L(BDGFAC)\2),BDGFAC,?67,BDGDATE
 I '$D(BSDT) S BSDT=$$FMTE^XLFDT(BSDD)
 NEW X S X="Appointment List for "_$S($$CNTD():"Multiple Dates",1:BSDT_" ("_$$DOW^XLFDT(BSDD)_")")
 W !,BDGUSR,?(80-$L(X)\2),X,?71,"Page: ",$J(BSDPG,2)
 W !,$$REPEAT^XLFSTR("=",80)
 W !?2,"Time",?7,"Patient Name",?30,"HRCN",?40,"DOB(Age)"
 W ?53," Lab@",?62,"X-Ray@",?74,"EKG@"
 W !?9,"Insurance & Appointment Information"
 W !,$$REPEAT^XLFSTR("-",80)
 W !!,BSDSAV,!,$$REPEAT^XLFSTR("=",80)
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP; -- exit code
 K ^TMP("BSDAL",$J) K VALMCNT,BSDI
 D PRTKL^BDGF    ;kill print to paper variables
 S VALMNOFF=1  ;suppress form feed before next question
 Q
 ;
EXPND ;EP; -- expand code
 Q
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
CNTD() ;-- count number of days in BSDD array
 N CDA,CCNT
 S CCNT=0
 S CDA=0 F  S CDA=$O(BSDD(CDA)) Q:'CDA  D
 . S CCNT=CCNT+1
 I CCNT>1 Q 1
 Q 0
 ;
