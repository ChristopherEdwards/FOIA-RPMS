BSDFRL ; IHS/ANMC/LJF - IHS FILE ROOM LIST ;  
 ;;5.3;PIMS;**1007,1008**;DEC 01, 2006
 ;
 ;cmi/anch/maw 11/22/2006 PATCH 1007 added code in GETAPPT,GATHER,SORTS for item 1007.07
 ;cmi/anch/maw 2/5/2007 PATCH 1007 added code in GATHER to look for appt on same day and print if there
 ;
 NEW BSDDT,VAUTD,VAUTC,BSDSRT,BSDCRI   ;IHS/ITSC/LJF 1/9/2004
DATE ; -- select date
 S BSDDT=$$READ^BDGF("D0^::EX","List Appointments for What Date")
 Q:BSDDT<1
 ;
CLINIC ; -- all clinics or selected ones?
 ; if ALL clinics are selected, VAUTC=1
 ;   otherwise the VAUTC array is set and VAUTC=0
 D CLINIC^BSDU(1) I Y<0 D EXIT Q
 ;
SORTS ; -- sort by
 NEW DIR0,DIRA,DIRB
 ;S DIR0="S^C:BY CLINIC CODE;P:BY PRINCIPAL CLINIC;T:BY TERMINAL DIGIT"
 ;S DIR0="S^N:BY CLINIC NAME;C:BY CLINIC CODE;P:BY PRINCIPAL CLINIC;T:BY TERMINAL DIGIT"  ;IHS/ITSC/LJF 1/9/2004  cmi/anch/maw 11/5/2006 maw orig line item 1007.07 patch 1007
 S DIR0="S^N:BY CLINIC NAME;C:BY CLINIC CODE;P:BY PRINCIPAL CLINIC;T:BY TERMINAL DIGIT;A:BY APPOINTMENT TIME;U:BY PATIENT NAME"  ;cmi/anch/maw 11/5/2006 maw new line item 1007.07 patch 1007
 S DIRA="FILE ROOM LIST SORT ORDER"
 S DIRB=$$GET1^DIQ(9009020.2,+$$DIV^BSDU,.17)
 S BSDSRT=$$READ^BDGF(DIR0,DIRA,DIRB,"^D HELP^BSDFRL")
 ;I "CPT"'[BSDSRT D EXIT Q
 ;I "NCPT"'[BSDSRT D EXIT Q   ;IHS/ITSC/LJF 1/9/2004 cmi/anch/maw 11/5/2006 original line item 1007.07 patch 1007
 I "NCPTAU"'[BSDSRT D EXIT Q   ;cmi/anch/maw 11/5/2006 new line item 1007.07 patch 1007
 ;
CHTRQ ; -- ask to include chart requests                   ;IHS/ITSC/LJF 1/9/2004
 S BSDCRI=$$READ^BDGF("Y","Include CHART REQUESTS","NO")  ;IHS/ITSC/LJF 1/9/2004
 ;
DEVICE ; -- select device
 NEW DGVAR,PGM,POP
 ;S DGVAR="VAUTD#^VAUTC#^BSDSRT^BSDDT",PGM="START^BSDFRL"
 S DGVAR="VAUTD#^VAUTC#^BSDSRT^BSDDT^BSDCRI",PGM="START^BSDFRL"   ;IHS/ITSC/LJF 1/9/2004
 D ZIS^DGUTQ I POP D EXIT Q
 I '$D(IO("Q")) D START^BSDFRL
 Q
 ;
 ;
START ;EP; entry to report after calling print device
 ;I $E(IOST,1,2)="C-" D EN Q  ;use listman if using screen TODO
 D GATHER,PRINT Q            ;otherwise print to paper
 ;
EN ;EP; -- entry for list manager interface
 NEW VALMCNT D TERM^VALM0
 D EN^VALM("BSDRM FILE ROOM LIST")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP; -- report heading
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S VALMHDR(2)="FILE ROOM LIST FOR APPOINTMENTS & CHART REQUESTS for "
 S VALMHDR(2)=$$SP(10)_VALMHDR(2)_$$FMTE^XLFDT(BSDDT)
 Q
 ;
GATHER ;EP; -- gathers data and sets into display array
 ; build sorted array
 K ^TMP("BSDFRL",$J),^TMP("BSDFRL1",$J)
 S X=$S(VAUTC=1:"ALL",1:"SOME") D @X
 ;
 ; reset sorted array into display array
 NEW A,B,C,D S BSDLN=0
 S A=0 F  S A=$O(^TMP("BSDFRL1",$J,A)) Q:A=""  D
 . ; add sort subheading
 . I BSDSRT'="T" D
 .. ;cmi/anch/maw 11/5/2006 added the next 2 lines for appointment time item 1007.07 patch 1007
 .. I BSDSRT="A" D  Q
 ... D SET("",.BSDLN),SET($$SP(3)_"**"_$$TM($P(A,".",2))_"**",.BSDLN)
 .. ;cmi/anch/maw 11/5/2006 end of mods item 1007.07 patch 1007
 .. D SET("",.BSDLN),SET($$SP(3)_"**"_A_"**",.BSDLN)
 . ;
 . S B=0 F  S B=$O(^TMP("BSDFRL1",$J,A,B)) Q:B=""  D
 .. S C=0 F  S C=$O(^TMP("BSDFRL1",$J,A,B,C)) Q:C=""  D
 ... S D=0 F  S D=$O(^TMP("BSDFRL1",$J,A,B,C,D)) Q:D=""  D
 .... D SET(^TMP("BSDFRL1",$J,A,B,C,D),.BSDLN)
 .... I "ANC"[BSDSRT D CHKOC(A,C,D)  ;cmi/anch/maw 2/5/2007 added to check to see if patient is in another clinic PATCH 1007 item 1007.10
 ;
 S VALMCNT=BSDLN
 K ^TMP("BSDFRL1",$J)
 Q
 ;
CHKOC(CLN,PAT,DATE) ;-- check to see if the patient has another appointment on today
 ;cmi/anch/maw 2/5/2007 added to check for other appointments same day PATCH 1007 item 1007.10
 S DATE=$P(DATE,".")
 N J,K,L,M
 S J=0 F  S J=$O(^TMP("BSDFRL1",$J,J)) Q:J=""  D
 . I J=CLN Q
 . ; add sort subheading
 . S K=0 F  S K=$O(^TMP("BSDFRL1",$J,J,K)) Q:K=""  D
 .. S L=0 F  S L=$O(^TMP("BSDFRL1",$J,J,K,L)) Q:L=""  D
 ... I L'=PAT Q
 ... S M=0 F  S M=$O(^TMP("BSDFRL1",$J,J,K,L,M)) Q:M=""  D
 .... I $P(M,".")'=DATE Q
 .... N SIX
 .... S SIX=$E(^TMP("BSDFRL1",$J,J,K,L,M),1,7)
 .... S $E(^TMP("BSDFRL1",$J,J,K,L,M),1,7)="*OTHER*"
 .... D SET(^TMP("BSDFRL1",$J,J,K,L,M),.BSDLN)
 .... S $E(^TMP("BSDFRL1",$J,J,K,L,M),1,7)=SIX
 Q
 ;
ALL ; -- loop thru all clinics
 NEW BSDCLN,BSDSUB
 S BSDCLN=0 F  S BSDCLN=$O(^SC(BSDCLN)) Q:'BSDCLN  D
 . Q:'$$OKAY(BSDCLN)              ;quit if not okay for file room list
 . Q:'$$ACTV^BSDU(BSDCLN,BSDDT)                 ;quit if inactive
 . I VAUTD=0 Q:'$D(VAUTD(+$$DIVC^BSDU(BSDCLN)))  ;quit if not select div
 . F BSDSUB="S","C" D GETAPPT          ;get all appt & chart requests
 Q
 ;
SOME ; -- loop thru selected clinics
 NEW BSDCL,BSDCLN,BSDSUB
 S BSDCL=0 F  S BSDCL=$O(VAUTC(BSDCL)) Q:BSDCL=""  D
 . S BSDCLN=VAUTC(BSDCL)          ;clinic ien
 . Q:'$$OKAY(BSDCLN)              ;quit if not okay for file room list
 . Q:'$$ACTV^BSDU(BSDCLN,BSDDT)   ;quit if inactive
 . F BSDSUB="S","C" D GETAPPT     ;get all appt & chart requests
 Q
 ;
GETAPPT ; -- for clinic, get appts & chart requests for date
 I BSDSUB="C",BSDCRI=0 Q   ;don't include chart requests;IHS/ITSC/LJF 1/9/2004
 NEW BSDT,BSDEND,BSDN,NODE,HRCN,TERM,SORT,LINE,X,BSDDFN
 S BSDT=BSDDT-.0001,BSDEND=BSDDT_".2400"
 F  S BSDT=$O(^SC(BSDCLN,BSDSUB,BSDT)) Q:'BSDT  Q:(BSDT>BSDEND)  D
 . S BSDN=0
 . F  S BSDN=$O(^SC(BSDCLN,BSDSUB,BSDT,1,BSDN)) Q:'BSDN  D
 .. S NODE=$G(^SC(BSDCLN,BSDSUB,BSDT,1,BSDN,0)) Q:'NODE
 .. ;
 .. ; set sort values
 .. S BSDDFN=$P(NODE,U)                            ;cmi/anch/maw 11/7/2006 patient dfn item 1007.09 patch 1007
 .. I BSDSRT="N" S SORT=$$GET1^DIQ(44,BSDCLN,.01)  ;clinic name
 .. I BSDSRT="C" S SORT=$$CLNCODE^BSDU(BSDCLN)     ;clinic code
 .. I BSDSRT="P" S SORT=$$PRIN^BSDU(BSDCLN)        ;principal clinic
 .. I BSDSRT="U" S SORT=$$GET1^DIQ(2,BSDDFN,.01)  ;patient name cmi/anch/maw 11/5/2006 item 1007.07 patch 1007
 .. I BSDSRT="A" S SORT=BSDT                       ;appointment time cmi/anch/maw 11/5/206 item 1007.07 patch 1007
 .. S HRCN=$$HRCN^BDGF2(+NODE,$$FAC^BSDU(BSDCLN))  ;chart #
 .. S TERM=$$HRCNT^BDGF2(HRCN)                     ;terminal digit format
 .. I $$GET1^DIQ(9009020.2,+$$DIVC^BSDU(BSDCLN),.18)="NO" D
 ... S TERM=$$HRCND^BDGF2(HRCN)                    ;no terminal digit per site param
 .. I BSDSRT="T" S SORT=TERM                       ;terminal digit sort
 .. ;
 .. ; set display line
 .. S LINE=$J(HRCN,7)_"  "_$E($$GET1^DIQ(2,+NODE,.01),1,20)      ;pat
 .. ;S LINE=$$PAD(LINE,33)_"DOB: "_$$DOB(+NODE)                  ;dob  cmi/anch/maw 11/5/2006 removed dob item 1007.09 patch 1007
 .. S LINE=$$PAD(LINE,33)_$$GET1^DIQ(44,BSDCLN,.01)              ;cln name cmi/anch/maw 11/5/2006 new line item 1007.09 patch 1007
 .. ;S LINE=LINE_"  "_$E($$GET1^DIQ(44,BSDCLN,.01),1,15)         ;cln name cmi/anch/maw 11/5/2006 orig line item 1007.09 patch 1007
 .. I BSDSUB="S" D                                               ;appt time
 ... ;I $P(NODE,U,9)="C" S LINE=$$PAD(LINE,65)_"**CANCELLED**"
 ... I $P(NODE,U,9)="C" S LINE=$$PAD(LINE,58)_"*CANCELLED*"      ;IHS/ITSC/LJF 1/8/2004
 ... ;E  S LINE=$$PAD(LINE,68)_"at "_$P($$FMTE^XLFDT(BSDT),"@",2)  ;cmi/anch/maw 11/5/2006 orig line item 1007.09 patch 1007
 ... E  S LINE=$$PAD(LINE,58)_$P($$FMTE^XLFDT(BSDT),"@",2)  ;cmi/anch/maw 11/5/2006 new line item 1007.09 patch 1007
 ... S LINE=$$PAD(LINE,68)_$$INSUR^BDGF2(BSDDFN,$P(BSDT,"."))  ;cmi/anch/maw 11/7/2006 new line added for insurance item 1007.09 patch 1007
 .. ;I BSDSUB="C" S LINE=$$PAD(LINE,58)_"Cht Req"                 ;chart req cmi/anch/maw 11/7/2006 orig line
 .. I BSDSUB="C" D  ;chart req
 ... S LINE=$$PAD(LINE,58)_"Cht Req"                 ;chart req cmi/anch/maw 11/7/2006 new line for item 1007.09 patch 1007
 ... S LINE=$$PAD(LINE,68)_$$INSUR^BDGF2(BSDDFN,$P(BSDT,"."))  ;cmi/anch/maw 11/7/2006 new line added for insurance item 1007.09 patch 1007
 .. ;
 .. S ^TMP("BSDFRL1",$J,SORT,TERM,+NODE,BSDT)=LINE
 .. ;
 .. I $$DEAD^BDGF2(+NODE) S ^TMP("BSDFRL1",$J,SORT,TERM,+NODE,BSDT+.00001)=$$SP(10)_$G(IORVON)_"** Patient Died on "_$$DOD^BDGF2(+NODE)_" **"_$G(IORVOFF)
 ;
 Q
 ;
PRINT ; -- print to paper
 ;IHS/ITSC/WAR 7/30/04 PATCH #1001
 ;U IO D HDR NEW X
 U IO NEW BSDLN
 I BSDSRT="T" D HEADING
 I BSDSRT="U" D HEADING  ;cmi/anch/maw 10/29/2007 patch 1008
 ;S X=0 F  S X=$O(^TMP("BSDFRL",$J,X)) Q:'X  D
 S BSDLN=0 F  S BSDLN=$O(^TMP("BSDFRL",$J,BSDLN)) Q:'BSDLN  D
 . ;I ^TMP("BSDFRL",$J,X,0)["**" D HEADING  ;IHS/ITSC/LJF 1/2/2004
 . ;I ^TMP("BSDFRL",$J,BSDLN,0)["**" D HEADING  cmi/anch/maw 10/29/2007 orig line
 . I ^TMP("BSDFRL",$J,BSDLN,0)["**",BSDSRT'="U" D HEADING  ;cmi/anch/maw 10/29/2007 patch 1008
 . I $Y>(IOSL-4) D HEADING
 . ;W !,^TMP("BSDFRL",$J,X,0)
 . W !,^TMP("BSDFRL",$J,BSDLN,0)
 ;PATCH #1001 END OF CHANGES
 D ^%ZISC,EXIT
 Q
 ;
HEADING ; -- heading for paper report
 NEW X  ;IHS/ITSC/LJF 12/11/2003
 D HDR W @IOF,!,VALMHDR(1),!,VALMHDR(2)
 ;IHS/ITSC/WAR 8/26/04 PATCH #1001 added in Col. headings
 ;W !,?55,"Printed on ",$$FMTE^XLFDT(DT),!,$$REPEAT^XLFSTR("=",79),!
 ;W !,?3,"HRCN",?9,"Patient Name",?33,"Date of Birth",?50,"Clinic",?68,"Appt Time",!,$$REPEAT^XLFSTR("=",79),!  ;cmi/anch/maw 11/5/2006 orig line item 1007.09 patch 1007
 W !,?3,"HRCN",?9,"Patient Name",?33,"Clinic",?58,"Appt Time",?68,"Insurance",!,$$REPEAT^XLFSTR("=",79),!  ;cmi/anch/maw 11/5/2006 new line item 1007.09 patch 1007
 Q
 ;
EXIT ;
 K ^TMP("BSDFRL",$J) K BSDLN
 Q
 ;
HELP1 ;
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
OKAY(CLN) ; -- returns 1 if okay to use in file room list
 I $$GET1^DIQ(44,CLN,2,"I")'="C" Q 0   ;not a clinic
 NEW X,Y
 S X=$$GET1^DIQ(44,CLN,2502)        ;non-count clinic value
 S Y=$$GET1^DIQ(44,CLN,2502.5)      ;include on file room list value
 ;IHS/ITSC/WAR 5/27/2004 P #1001 added next line
 I X="NO"&(Y="NO") Q 0
 I X'="YES" Q 1                     ;counted clinic
 I Y="YES" Q 1                      ;okay to include
 Q 0                                ;else don't include
 ;
SET(DATA,LINE) ; -- puts data into display array
 S LINE=LINE+1
 S ^TMP("BSDFRL",$J,LINE,0)=DATA
 Q
 ;
HELP ;EP; -- help for SORTS question
 D MSG^BDGF("Enter N to print by Clinic Name then terminal digit",2,0)  ;IHS/ITSC/LJF 1/9/2004
 D MSG^BDGF("Enter C to print by Clinic Code then terminal digit",2,1)
 D MSG^BDGF("Enter P to print by Principal Clinic then terminal digit")
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
 ;
TM(T) ; -- cmi/anch/maw 11/5/26 item 1007.07 patch 1007 return trailing zeroes on time
 N I,J,Z
 S Z=(4-$L(T)) F I=1:1:Z S T=T_"0"
 S T=$E(T,1,2)_":"_$E(T,3,4)
 Q T
 ;
