BSDCRL ; IHS/ANMC/LJF - CHART REQUESTS LIST ;  [ 08/20/2004  11:52 AM ]
 ;;5.3;PIMS;**1001**;APR 26, 2002
 ;
 NEW BSDDT,VAUTD,VAUTC,BSDSRT
DATES ; -- select date
 S BSDDT=$$READ^BDGF("DO^::EX","Select Date") Q:BSDDT<1
 ;
CLINIC ; -- all clinics or selected ones?
 ; if ALL clinics are selected, VAUTC=1
 ;   otherwise the VAUTC array is set and VAUTC=0
 D CLINIC^BSDU(1) I Y<0 D EXIT Q
 ;
SORTS ; -- sort by
 NEW DIR0,DIRA,DIRB
 S DIR0="S^D:BY DATE/TIME REQUESTED;C:BY CLINIC CODE;P:BY PRINCIPAL CLINIC;T:BY TERMINAL DIGIT"
 S DIRA="CHARTS REQUESTED BY DATE SORT ORDER"
 S BSDSRT=$$READ^BDGF(DIR0,DIRA,"D","^D HELP^BSDCRL")
 I "CPTD"'[BSDSRT D EXIT Q
 ;
DEVICE ; -- select device
 NEW DGVAR,PGM,POP
 D MSG^BDGF("Use wide paper or condensed print if printing to paper",2,1)
 S DGVAR="VAUTD#^VAUTC#^BSDSRT^BSDDT",PGM="START^BSDCRL"
 D ZIS^DGUTQ I POP D EXIT Q
 I '$D(IO("Q")) D START^BSDCRL
 Q
 ;
 ;
START ;EP; entry to report after calling print device
 I $E(IOST,1,2)="C-" D EN Q  ;use listman if using screen
 D GATHER,PRINT Q            ;otherwise print to paper
 ;
EN ;EP; -- entry for list manager interface
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM CHART REQUEST LIST")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP; -- report heading
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S VALMHDR(2)=$$SP(25)_"CHART REQUESTS for "_$$FMTE^XLFDT(BSDDT)
 Q
 ;
GATHER ;EP; -- gathers data and sets into display array
 NEW BSDCNT,BSDNP
 ; build sorted array
 K ^TMP("BSDCRL",$J),^TMP("BSDCRL1",$J)
 S (BSDCNT,BSDNP)=0   ;count and # not printed
 S X=$S(VAUTC=1:"ALL",1:"SOME") D @X
 ;
 ; reset sorted array into display array
 NEW A,B,C,D S BSDLN=0
 S A=0 F  S A=$O(^TMP("BSDCRL1",$J,A)) Q:A=""  D
 . ; add sort subheading
 . I BSDSRT'="T",BSDSRT'="D" D
 .. D SET("",.BSDLN),SET($$SP(23)_"**"_A_"**",.BSDLN)
 . ;
 . S B=0 F  S B=$O(^TMP("BSDCRL1",$J,A,B)) Q:B=""  D
 .. S C=0 F  S C=$O(^TMP("BSDCRL1",$J,A,B,C)) Q:C=""  D
 ... S D=0 F  S D=$O(^TMP("BSDCRL1",$J,A,B,C,D)) Q:D=""  D
 .... D SET(^TMP("BSDCRL1",$J,A,B,C,D),.BSDLN)
 ;
 I BSDCNT>0 D SET("Total Chart Requests: "_BSDCNT_"; Total Not Printed: "_BSDNP,.BSDLN)
 ;
 S VALMCNT=BSDLN
 I 'VALMCNT S VALMCNT=1,^TMP("BSDCRL",$J,1,0)=$$SP(10)_"** NO CHART REQUESTS FOUND FOR DATE **"
 K ^TMP("BSDCRL1",$J)
 Q
 ;
ALL ; -- loop thru all clinics
 NEW BSDCLN
 S BSDCLN=0 F  S BSDCLN=$O(^SC(BSDCLN)) Q:'BSDCLN  D
 . I $$GET1^DIQ(44,BSDCLN,2,"I")'="C" Q   ;not a clinic
 . Q:'$$ACTV^BSDU(BSDCLN,BSDDT)                 ;quit if inactive
 . I VAUTD=0 Q:'$D(VAUTD(+$$DIVC^BSDU(BSDCLN)))  ;quit if not select div
 . D GETCR          ;get all chart requests
 Q
 ;
SOME ; -- loop thru selected clinics
 NEW BSDCL,BSDCLN
 S BSDCL=0 F  S BSDCL=$O(VAUTC(BSDCL)) Q:BSDCL=""  D
 . S BSDCLN=VAUTC(BSDCL)          ;clinic ien
 . I $$GET1^DIQ(44,BSDCLN,2,"I")'="C" Q   ;not a clinic
 . Q:'$$ACTV^BSDU(BSDCLN,BSDDT)   ;quit if inactive
 . D GETCR     ;get all chart requests
 Q
 ;
GETCR ; -- for clinic, get appts & chart requests for date
 NEW BSDT,BSDEND,BSDN,PAT,HRCN,TERM,SORT,LINE,X,NODE
 S BSDT=BSDDT-.0001,BSDEND=BSDDT_".2400"
 F  S BSDT=$O(^SC(BSDCLN,"C",BSDT)) Q:'BSDT  Q:(BSDT>BSDEND)  D
 . S BSDN=0
 . F  S BSDN=$O(^SC(BSDCLN,"C",BSDT,1,BSDN)) Q:'BSDN  D
 .. S PAT=$G(^SC(BSDCLN,"C",BSDT,1,BSDN,0)) Q:'PAT
 .. ;
 .. ; set sort values
 .. I BSDSRT="D" S SORT=+$G(^SC(BSDCLN,"C",BSDT,1,BSDN,9999999))  ;date
 .. I BSDSRT="C" S SORT=$$CLNCODE^BSDU(BSDCLN)   ;clinic code
 .. I BSDSRT="P" S SORT=$$PRIN^BSDU(BSDCLN)      ;principal clinic
 .. S HRCN=$$HRCN^BDGF2(PAT,$$FAC^BSDU(BSDCLN))  ;chart #
 .. S TERM=$$HRCNT^BDGF2(HRCN)                   ;terminal digit format
 .. I $$GET1^DIQ(9009020.2,+$$DIVC^BSDU(BSDCLN),.18)="NO" D
 ... S TERM=$$HRCND^BDGF2(HRCN)  ;no terminal digit per site param
 .. I BSDSRT="T" S SORT=TERM                     ;terminal digit sort
 .. ;
 .. ; set display line
 .. S NODE=$G(^SC(BSDCLN,"C",BSDT,1,BSDN,9999999))
 .. S LINE=$J(HRCN,6)_"  "_$E($$GET1^DIQ(2,PAT,.01),1,18)    ;pat
 .. S LINE=$$PAD(LINE,28)_$$GET1^DIQ(44,BSDCLN,1)         ;cln abbrev
 .. S LINE=$$PAD(LINE,37)_$E($$FMTE^XLFDT(+NODE),1,18)    ;requested on
 .. S LINE=$$PAD(LINE,57)_$$GET1^DIQ(200,+$P(NODE,U,2),1)  ;requested by
 .. S LINE=$$PAD(LINE,62)_$E($$FMTE^XLFDT($P(NODE,U,4)),1,18)  ;printed
 .. S LINE=$$PAD(LINE,82)_$P(NODE,U,3)                    ;deliver to
 .. ;
 .. S BSDCNT=BSDCNT+1 S:$P(NODE,U,4)="" BSDNP=BSDNP+1   ;counts
 .. S ^TMP("BSDCRL1",$J,SORT,TERM,+PAT,BSDT)=LINE
 ;
 Q
 ;
PRINT ; -- print to paper
 ;IHS/ITSC/WAR 7/30/04 PATCH #1001
 ;U IO D HDR NEW X
 U IO D HEADING NEW BDGLN
 ;S X=0 F  S X=$O(^TMP("BSDAPL",$J,X)) Q:'X  D
 S BDGLN=0 F  S BDGLN=$O(^TMP("BSDCRL",$J,BDGLN)) Q:'BDGLN  D
 . I $Y>(IOSL-4) D HEADING
 . ;W !,^TMP("BSDAPL",$J,X,0)
 . W !,^TMP("BSDCRL",$J,BDGLN,0)
 ;PATCH #1001 END OF CHANGES
 D ^%ZISC,EXIT
 Q
 ;
HEADING ; -- heading for paper report
 D HDR W @IOF,!,VALMHDR(1),!,VALMHDR(2)
 W !,?55,"Printed on ",$$FMTE^XLFDT(DT),!,$$REPEAT^XLFSTR("=",79),!
 Q
 ;
 ;
EXIT ;
 K ^TMP("BSDCRL",$J) K BSDLN
 Q
 ;
HELP1 ;
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
 ;
SET(DATA,LINE) ; -- puts data into display array
 S LINE=LINE+1
 S ^TMP("BSDCRL",$J,LINE,0)=DATA
 Q
 ;
HELP ;EP; -- help for SORTS question
 D MSG^BDGF("Enter D to print by date/time teh chart qas requested.",2,1)
 D MSG^BDGF("Enter C to print by Clinic Code then terminal digit.",2,1)
 D MSG^BDGF("Enter P to print by Principal Clinic then terminal digit.")
 D MSG^BDGF("Enter T to print by Terminal Digit order only",2,1)
 D MSG^BDGF("If your file room does NOT sort by terminal digit",1,0)
 D MSG^BDGF("  AND you set the site parameter that way,",1,0)
 D MSG^BDGF("    then the report will use chart # order.",1,1)
 Q
 ;
DOB(PAT) ; -- return date of birth in numerical format with leading zeros
 NEW X S X=$$GET1^DIQ(2,PAT,.03,"I")
 Q $S('X:"??",1:$E(X,4,5)_"/"_$E(X,6,7)_"/"_(1700+$E(X,1,3)))
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
