BDGADD ; IHS/ANMC/LJF - A&D DETAILED PRINT ;  [ 06/11/2002  2:27 PM ]
 ;;5.3;PIMS;**1013**;APR 26, 2002
 ;
 ; Assumes VA variables RD and GL and set
 ;
 I $E(IOST,1,2)="P-" S BDGT=RD D INIT,PRINT Q
 ;
EN ; -- main entry point for BDG A&D DETAILED
 NEW VALMCNT,BDGT
 D TERM^VALM0,CLEAR^VALM1
 S BDGT=RD                                         ;reset run date
 D EN^VALM("BDG A&D DETAILED")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S X="ADMISSIONS & DISCHARGES for "_$$GET1^DIQ(4,DUZ(2),.01)
 S VALMHDR(2)=$$SP(79-$L(X)\2)_X
 S VALMHDR(3)=$$SP(12)="For "_$$DOW^XLFDT(BDGT)_" "_$$FMTE^XLFDT(BDGT,2)
 Q
 ;
INIT ; -- init variables and list array
 NEW SRV,PREV,SRVN,TOT,TOT1,TOT2
 K ^TMP("BDGADD",$J)
 S VALMCNT=0
 S PREV=$$FMADD^XLFDT(BDGT,-1)                     ;previous date
 S (TOT1,TOT2)=0 F I="O","I","N","D" S TOT(I)=""       ;initialize totals
 ;
 D REMAIN           ;display total patients remaining at end of day
 D HDG              ;display column headings
 D PATDATA^BDGADD1  ;display patients
 ;
 Q
 ;
 ;
SET(DATA,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGADD",$J,NUM,0)=DATA
 Q
 ;
REMAIN ; total up patients remaining at end of day
 ; count by service to pull out newborns and oberservations
 NEW COUNT,I,SV,SNM,SUB,LINE,N
 F I="I","O","N","D" S COUNT(I)=0
 S SV=0 F  S SV=$O(^BDGCTX(SV)) Q:'SV  D
 . S N=$G(^BDGCTX(SV,1,BDGT,0)) I N="" Q
 . S SNM=$$GET1^DIQ(45.7,SV,.01)             ;service name
 . S SUB=$S(SNM="NEWBORN":"N",SNM["OBSERVATION":"O",SNM="DAY SURGERY":"D",1:"I")
 . S COUNT(SUB)=COUNT(SUB)+$P(N,U,2)+$P(N,U,12)
 ;
 S LINE="Inpatients:"_COUNT("I")
 S LINE=$$PAD(LINE,25)_"Observations: "_COUNT("O")
 S LINE=$$PAD(LINE,55)_"Day Surgerys: "_COUNT("D")  ;ihs/cmi/maw 09/14/2011 patch 1013
 S LINE=$$PAD(LINE,85)_"Newborns: "_COUNT("N")
 D SET(LINE,.VALMCNT),SET("",.VALMCNT)
 Q
 ;
HDG ; set up column headings
 NEW LINE
 ;
 ;IHS/ANMC/LJF 6/11/2002 added PCP so column headings must change
 ;changed 25 -> 27, 34 -> 35 (LJF7 6/11/2002)
 S LINE=$$PAD($$PAD(" NAME",27)_" HRCN",35)_"AGE"
 ;changed 63 -> 58 (LJF7 6/11/2002)
 S LINE=$$PAD($$PAD(LINE,40)_"COMMUNITY",58)_"WARD   SERV"
 ;changed 80 -> 72 and added code (LJF7 6/11/2002) 
 S LINE=$$PAD($$PAD(LINE,72)_"PROVIDER",92)_"PRIM CARE PRV"
 ;IHS/ANMC/LJF 6/11/2002 end of mods
 ;
 D SET(LINE,.VALMCNT),SET($$REPEAT^XLFSTR("-",110),.VALMCNT)
 Q
 ;
PRINT ; print report to paper
 NEW BDGX,BDGLN,WARD
 U IO D PHDG
 ;
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGADD",$J,BDGX)) Q:'BDGX  D
 . ;I $Y>(IOSL-4) D PHDG  ;IHS/ANMC/LJF 6/5/2002 form feed at bottom of page (LJF7 6/11/2002)
 . I $Y>(IOSL-4) W @IOF D PHDG  ;IHS/ANMC/LJF 6/5/2002 form feed at bottom of page (LJF7 6/11/2002)
 . W !,^TMP("BDGADD",$J,BDGX,0)
 D ^%ZISC,EXIT
 Q
 ;
PHDG ; heading for paper report
 ;D HDR W @IOF  ;IHS/ANMC/LJF 6/5/2002 no form feed at beginning (LJF7 6/11/2002)
 D HDR  ;IHS/ANMC/LJF 6/5/2002 no form feed at beginning (LJF7 6/11/2002)
 F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGADD",$J) K BDGREP
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
