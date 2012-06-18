BSDRFC ; IHS/ANMC/LJF - RADIOLOGY PULL LIST ;  [ 11/02/2004  11:45 AM ]
 ;;5.3;PIMS;**1001**;APR 26, 2002
 ;
ASK ; -- ask user for division/clinic selections
 D CLINIC^BSDU(1) Q:$D(BSDU)
 S BSDT=$$READ^BDGF("DO^::EX","Print For Which Date") Q:BSDT<1
 ;IHS/ITSC/WAR 8/3/04 PATCH #1001 Added .VALMHDR variable for printing
 ;D ZIS^BDGF("QP","BEG^BSDRFC","RAD PULL LIST","VAUTC;VAUTD;BSDT;.HALMHDR")
 D ZIS^BDGF("QP","BEG^BSDRFC","RAD PULL LIST","VAUTC;VAUTD;BSDT;VALMHDR")  ;IHS/ITSC/LJF 10/25/2004
 Q
 ;
BEG ;EP; entry point when queuing
 I $E(IOST,1,2)="C-" D EN Q
 D INIT,PRINT Q
 ;
EN ; -- main entry point for BSDRM RAD PULL LIST
 NEW VALMCNT D TERM^VALM0
 D EN^VALM("BSDRM RAD PULL LIST")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 NEW X S X="The following patients have appointments on "
 S VALMHDR(2)=$$SP(10)_X_$$FMTE^XLFDT(BSDT)
 S VALMHDR(3)=$$SP(15)_"and need their previous radiology films pulled"
 ;IHS/ITSC/WAR 8/3/04 PATCH #1001 Added next 2 lineS - missing on printout
 S VALMHDR(4)="                                              "
 S VALMHDR(5)="Chart #  Patient Name            Clinic                    Appt Time"
 Q
 ;
INIT ; -- init variables and list array
 NEW CLINIC,DATE,END,DFN,HRCN,TERM
 S BSDLN=0 K ^TMP("BSDRFC",$J),^TMP("BSDRFC1",$J)
 ;
 ; loop thru ARAD xref to find charts to pull
 S CLINIC=0 F  S CLINIC=$O(^SC("ARAD",CLINIC)) Q:'CLINIC  D
 . I 'VAUTD,'$D(VAUTD(+$$DIVC^BSDU(CLINIC))) Q  ;not in division selectd
 . I 'VAUTC,'$D(VAUTC($$GET1^DIQ(44,CLINIC,.01))) Q  ;clnc not selctd
 . ;
 . ; loop thru selected date and set into order
 . S DATE=BSDT-.0001,END=BSDT_".2400"
 . F  S DATE=$O(^SC("ARAD",CLINIC,DATE)) Q:'DATE  Q:(DATE>END)  D
 .. S DFN=0 F  S DFN=$O(^SC("ARAD",CLINIC,DATE,DFN)) Q:'DFN  D
 ... Q:$P(^SC("ARAD",CLINIC,DATE,DFN),U)="N"     ;don't pull
 ... S HRCN=$$HRCN^BDGF2(DFN,$$FAC^BSDU(CLINIC))  ;chart #
 ... I $$GET1^DIQ(9009020.2,+$$DIVC^BSDU(CLINIC),.18)'="NO" D
 .... S TERM=$$HRCNT^BDGF2(HRCN)          ;convert to terminal digit
 ... E  S TERM=$$HRCND^BDGF2(HRCN)        ;add dashes to sort properly
 ... S ^TMP("BSDRFC1",$J,TERM,DFN,DATE)=CLINIC_U_HRCN
 ;
 ; if none found, say so
 I '$D(^TMP("BSDRFC1",$J)) D  Q
 . D SET($$SP(20)_"** NO CHARTS TO PULL FOR DATE **",.BSDLN) S VALMCNT=1
 ;
 ; loop thru sorted list & create display array
 NEW A,B,C,LINE,NODE
 S A=0 F  S A=$O(^TMP("BSDRFC1",$J,A)) Q:A=""  D
 . S B=0 F  S B=$O(^TMP("BSDRFC1",$J,A,B)) Q:'B  D
 .. S C=0 F  S C=$O(^TMP("BSDRFC1",$J,A,B,C)) Q:'C  D
 ... S NODE=^TMP("BSDRFC1",$J,A,B,C)
 ... ;
 ... ; set up line: chart # - name - clinic - appt time
 ... S LINE=$J($P(NODE,U,2),7)_"   "_$E($$GET1^DIQ(2,B,.01),1,18)
 ... S LINE=$$PAD(LINE,34)_$$GET1^DIQ(44,+NODE,.01)
 ... S LINE=$$PAD(LINE,60)_$$FMTE^XLFDT(C,5)
 ... D SET(LINE,.BSDLN)   ;add to display array
 ... I $$DEAD^BDGF2(B) D
 .... S LINE=$$SP(10)_$G(IORVON)_"** Patient Died on "_$$DOD^BDGF2(B)_" **"_$G(IORVOFF)
 .... D SET(LINE,.BSDLN),SET("",.BSDLN)
 ;
 S VALMCNT=BSDLN K ^TMP("BSDRFC1",$J)
 Q
 ;
SET(DATA,NUM) ; -- stuff line into array
 S NUM=NUM+1
 S ^TMP("BSDRFC",$J,NUM,0)=DATA
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K BSDLN,BSDT,VAUTC,VAUTD,POP K ^TMP("BSDRFC",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; -- print report to paper
 NEW BSDN
 U IO D HDG S BSDN=0
 F  S BSDN=$O(^TMP("BSDRFC",$J,BSDN)) Q:'BSDN  D
 . ;I $Y>(IOST-4) D HDG
 . I $Y>(IOSL-4) D HDG   ;IHS/ITSC/LJF 4/29/2004 PATCH #1001
 . W !,^TMP("BSDRFC",$J,BSDN,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; -- print heading on paper
 NEW VALMHDR D HDR
 W @IOF W !!?20,"RADIOLOGY PULL LIST"
 ;IHS/ITSC/WAR 3/1/04 added the missing subscript
 ;F I=1:1 Q:'$D(VALMHDR)  W VALMHDR(I)
 ;F I=1:1 Q:'$D(VALMHDR(I))  W VALMHDR(I)
 F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)   ;IHS/ITSC/LJF 4/29/2004 PATCH #1001
 W !,$$REPEAT^XLFSTR("=",80),!
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
