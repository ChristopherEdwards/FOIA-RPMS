BDGADS ; IHS/ANMC/LJF - A&D SUMMARY PRINT ; 
 ;;5.3;PIMS;**1013**;APR 26, 2002
 ;
 ; Assumes VA variables RD and GL and set
 ;
 I $E(IOST,1,2)="P-" S BDGT=RD D INIT,PRINT Q
 ;
EN ; -- main entry point for BDG A&D SUMMARY
 NEW VALMCNT,BDGT
 D TERM^VALM0,CLEAR^VALM1
 S BDGT=RD                                         ;reset run date
 D EN^VALM("BDG A&D SUMMARY")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S X="ADMISSIONS & DISCHARGES for "_$$GET1^DIQ(4,DUZ(2),.01)
 S VALMHDR(2)=$$SP(79-$L(X)\2)_X
 S X="For "_$$DOW^XLFDT(BDGT)_" "_$$FMTE^XLFDT(BDGT,2)
 S VALMHDR(3)=$$SP(79-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW SRV,PREV,SRVN,TOT
 K ^TMP("BDGADS",$J)
 S VALMCNT=0
 S PREV=$$FMADD^XLFDT(BDGT,-1)                     ;previous date
 ;S TOT=0 F I="O","I","N" S TOT(I)=""       ;initialize totals orig
 S TOT=0 F I="O","I","N","D" S TOT(I)=""       ;initialize totals ihs/cmi/maw 09/13/2011 PATCH 1013
 ;
 D HDG     ;display column headings
 ;
 ; first gathers stats for inpatient services
 ;  loop in alphabetical order
 S SRVN=0 F  S SRVN=$O(^DIC(45.7,"B",SRVN)) Q:SRVN=""  D
 . Q:SRVN["[OBSERVATION"  Q:SRVN="NEWBORN"
 . Q:SRVN="DAY SURGERY"  ;ihs/cmi/maw 09/13/2011 PATCH 1013
 . ;
 . S SRV=0 F  S SRV=$O(^DIC(45.7,"B",SRVN,SRV)) Q:'SRV  D
 .. Q:'$$ACTSRV^BDGPAR(SRV,BDGT)        ;quit if not active on run date
 .. D LINE
 ;
 ; next gather observation services
 S SRVN=0 F  S SRVN=$O(^DIC(45.7,"B",SRVN)) Q:SRVN=""  D
 . Q:SRVN'["[OBSERVATION"  Q:SRVN="NEWBORN"
 . Q:SRVN="DAY SURGERY"  ;ihs/cmi/maw 09/13/2011 PATCH 1013
 . ;
 . S SRV=0 F  S SRV=$O(^DIC(45.7,"B",SRVN,SRV)) Q:'SRV  D
 .. Q:'$$ACTSRV^BDGPAR(SRV,BDGT)        ;quit if not active on run date
 .. D LINE
 ;
 ; next gather day surgery services
 S SRVN=0 F  S SRVN=$O(^DIC(45.7,"B",SRVN)) Q:SRVN=""  D
 . Q:SRVN'="DAY SURGERY"  ;ihs/cmi/maw 09/13/2011 PATCH 1013
 . ;
 . S SRV=0 F  S SRV=$O(^DIC(45.7,"B",SRVN,SRV)) Q:'SRV  D
 .. Q:'$$ACTSRV^BDGPAR(SRV,BDGT)        ;quit if not active on run date
 .. D LINE
 ;
 ; now newborn totals
 D SET("",.VALMCNT)
 S SRVN="NEWBORN",SRV=$O(^DIC(45.7,"B",SRVN,0)) I SRV D
 . Q:'$$ACTSRV^BDGPAR(SRV,BDGT)         ;quit if not active on run date
 . D LINE
 ;
 D TOTALS,SET("",.VALMCNT)
 D PATDATA^BDGADS1
 Q
 ;
TOTALS ; set up total display lines
 NEW LINE,I,X
 D SET($$REPEAT^XLFSTR("=",79),.VALMCNT)
 ;
 I TOT("I")]"" D                   ;if inpatient numbers exist
 . S LINE="Inpatient Totals:",X=0
 . F I=24:8 S X=X+1 Q:X=8  S LINE=$$PAD(LINE,I)_$J($P(TOT("I"),U,X),4)
 . D SET(LINE,.VALMCNT)
 ;
 I TOT("O")]"" D                   ;if observation numbers exist
 . S LINE="Observation Totals:",X=0
 . F I=24:8 S X=X+1 Q:X=8  S LINE=$$PAD(LINE,I)_$J($P(TOT("O"),U,X),4)
 . D SET(LINE,.VALMCNT)
 ;
 I TOT("D")]"" D                   ;if day surgery numbers exist
 . S LINE="Day Surgery Totals:",X=0
 . F I=24:8 S X=X+1 Q:X=8  S LINE=$$PAD(LINE,I)_$J($P(TOT("D"),U,X),4)
 . D SET(LINE,.VALMCNT)
 ;
 S LINE="Total:",X=0
 F I=24:8 S X=X+1 Q:X=8  S LINE=$$PAD(LINE,I)_$J($P(TOT,U,X),4)
 D SET(LINE,.VALMCNT)
 ;
 I TOT("N")]"" D
 . S LINE="Newborn Totals:",X=0
 . F I=24:8 S X=X+1 Q:X=8  S LINE=$$PAD(LINE,I)_$J($P(TOT("N"),U,X),4)
 . D SET(LINE,.VALMCNT)
 ;
 Q
 ;
LINE ; build display line
 NEW DATA,REMA,REMP,LINE,TYPE,CNT,I
 S DATA=$G(^BDGCTX(SRV,1,BDGT,0))            ;data for run date
 S REMA=$P($G(^BDGCTX(SRV,1,PREV,0)),U,2)    ;prev day adults
 S REMP=$P($G(^BDGCTX(SRV,1,PREV,0)),U,12)   ;prev day peds
 ;S TYPE=$S(SRVN["OBSERVATION":"O",SRVN="NEWBORN":"N",1:"I")  orig
 S TYPE=$S(SRVN["OBSERVATION":"O",SRVN="NEWBORN":"N",SRVN="DAY SURGERY":"D",1:"I")  ;ihs/cmi/maw 09/13/2011 PATCH 1013
 ;
 ; count up adult & peds numbers
 S CNT(1)=REMA+REMP                            ;prev remaining
 S CNT(2)=$P(DATA,U,3)+$P(DATA,U,13)           ;admits
 S CNT(3)=$P(DATA,U,5)+$P(DATA,U,15)           ;trans in
 S CNT(4)=$P(DATA,U,6)+$P(DATA,U,16)           ;trans out
 S CNT(5)=$P(DATA,U,7)+$P(DATA,U,17)           ;death
 S CNT(6)=$P(DATA,U,4)+$P(DATA,U,14)           ;discharges
 S CNT(7)=$P(DATA,U,2)+$P(DATA,U,12)           ;remaining
 ;
 ; build columns across page
 S LINE=$E(SRVN,1,23),X=0
 F I=24:8 S X=X+1 Q:X=8  S LINE=$$PAD(LINE,I)_$J(CNT(X),4)
 D SET(LINE,.VALMCNT)
 ;
 ; increment totals
 F I=1:1:7 S $P(TOT(TYPE),U,I)=$P(TOT(TYPE),U,I)+CNT(I)
 I TYPE'="N" F I=1:1:7 S $P(TOT,U,I)=$P($G(TOT),U,I)+CNT(I)
 Q
 ;
SET(DATA,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGADS",$J,NUM,0)=DATA
 Q
 ;
HDG ; set up column headings
 NEW LINE
 S LINE=$$PAD("SERVICE",21)_"REMAINING   ADMIT     TRANSFERS    DEATHS  DISCH  REMAINING"
 D SET(LINE,.VALMCNT)
 S LINE=$$PAD($$SP(21)_"(Prev Day)",42)_"IN     OUT"
 D SET(LINE,.VALMCNT)
 Q
 ;
PRINT ; print report to paper
 NEW BDGX,BDGPG
 U IO D INIT^BDGF,PHDG
 ;
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGADS",$J,BDGX)) Q:'BDGX  D
 . I $Y>(IOSL-4) D PHDG
 . W !,^TMP("BDGADS",$J,BDGX,0)
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
PHDG ; heading for paper report
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?11,"***",$$CONF^BDGF,"***"
 S X="ADMISSIONS & DISCHARGES for "_$$GET1^DIQ(4,DUZ(2),.01)
 W !,BDGDATE,?(80-$L(X)\2),X,?70,"Page: ",BDGPG
 S X="For "_$$DOW^XLFDT(BDGT)_" "_$$FMTE^XLFDT(BDGT,2)
 W !,BDGTIME,?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGADS",$J) K BDGREP
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
