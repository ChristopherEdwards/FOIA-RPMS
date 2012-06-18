BSDWKR6 ;cmi/anch/maw - BSD Turn Around Time Report 2/20/2007 2:41:31 PM
 ;;5.3;PIMS;**1007,1010,1011,1012**;FEB 27, 2007
 ;
 ;
 ;cmi/anch/maw 2/20/2007 PATCH 1007 item 1007.24
 ;cmi/flag/maw 11/19/2009 PATCH 1011 mods for PIMC in formatting
 ;
ASK ; -- ask user questions
 NEW VAUTC,VAUTD,POP,BSDBD,BSDED,BSDSUB,Y
 ;
 S BSDSUB="C"
 ;
 ; get clinic arrays based on subtotal category
 ;S BSDSRT=$$READ^BDGF("S^D:Detailed;S:Summary","Select type of report")
 ;
 D CLINIC^BSDU(2) G EXIT:$D(BSDQ)
 ;I BSDSRT="S" D CLINIC^BSDU(2) G EXIT:$D(BSDQ)
 ;I BSDSRT="D" D ONE
 G EXIT:$D(BSDQ)
 ;
 S BSDBD=$$READ^BDGF("DO^::EX","Select First Date to Search") G EXIT:'BSDBD
 S BSDED=$$READ^BDGF("DO^::EX","Select Last Date to Search") G EXIT:'BSDED
 ;
 S BSDSRT=$$READ^BDGF("S^D:Detailed;S:Summary","Select type of report")
 ;
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q  ;browse in list mgr mode
 D ZIS^BDGF("PQ","START^BSDWKR6","TURN AROUND TIME","BSDDET;BSDSUB;BSDSRT;BSDSEEN;BSDBD;BSDED;VAUTC*;VAUTD*")
 Q
 ;
ONE() ;-- get one clinic
 S VAUTC=0
 S DIC="^SC("
 S DIC(0)="AEMQZ"
 S DIC("A")="Select Clinic: "
 D ^DIC
 I Y<0 S BSDQ=1 Q
 S VAUTC(+Y)=$P(Y,U,2)
 Q
 ;
START ;EP; -- re-entry for printing to paper
 D INIT,PRINT Q
 ;
EN ; -- main entry point for BSDRM WORK STATS
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM TAT REPORT")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(31)_"Turn Around Time"
 S VALMHDR(2)=$$SP(20)_"For dates: "_$$RANGE^BDGF(BSDBD,BSDED)
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0 K ^TMP("BSDWKR6",$J),^TMP("BSD",$J)
 NEW BSDAR S BSDAR=$S(VAUTC:"^SC",1:"VAUTC")
 ;
 ; -- loop by clinic
 NEW CLN,NAME,SUB,APPT,APPN,PAT,STATUS,TYPE,SUB2,END,CHK,BSDCHKI,BSDCHKO,BSDCNT
 S CLN=0 F  S CLN=$O(@BSDAR@(CLN)) Q:'CLN  D
 . Q:'$$GET1^DIQ(44,CLN,3.5,"I")  ;No Div entered for this clinic
 . I $D(VAUTD) Q:(VAUTD'=1&('$D(VAUTD($$GET1^DIQ(44,CLN,3.5,"I")))))  ;this Div notd
 . Q:$D(^SC("AIHSPC",CLN))               ;quit if principal clinic
 . ;S NAME=$$GET1^DIQ(44,CLN,.01)         ;set clinic's name
 . ;D SET(NAME,.VALMCNT)                  ;setup the line with clinic name
 . ;
 . ; -- then by appt date (within range)
 . S APPT=BSDBD,END=BSDED+.2400
 . F  S APPT=$O(^SC(CLN,"S",APPT)) Q:'APPT!(APPT>END)  D
 .. ;
 .. ; -- then find appts to count
 .. S APPN=0,BSDCNT=0
 .. N APPDT
 .. S APPDT=0
 .. F  S APPN=$O(^SC(CLN,"S",APPT,1,APPN)) Q:'APPN  D
 ... S PAT=+^SC(CLN,"S",APPT,1,APPN,0)             ;patient ien
 ... S STATUS=$$VAL^XBDIQ1(2.98,PAT_","_APPT,100)  ;current status
 ... Q:STATUS["CANCEL"  Q:STATUS="FUTURE"
 ... Q:STATUS="NON-COUNT"  Q:STATUS="DELETED"
 ... S CHK=$G(^SC(CLN,"S",APPT,1,APPN,"C"))        ;checkin node
 ... S BSDCHKI=$$LPAD($P(CHK,U),12)
 ... Q:'$G(BSDCHKI)
 ... S BSDCHKO=$$LPAD($P(CHK,U,3),12)
 ... N APPNA,APPTA
 ... S APPNA=$$LPAD($P(APPT,".",2),4)
 ... S APPTA=$P(APPT,".")
 ... S ^TMP("BSD",$J,CLN,APPTA,"IN")=$G(^TMP("BSD",$J,CLN,APPTA,"IN"))+1
 ... S ^TMP("BSD","D",$J,CLN,APPT,PAT)=BSDCHKI_U_BSDCHKO_U_$$GETTAT(BSDCHKI,BSDCHKO)
 ... I BSDCHKO D
 .... S ^TMP("BSD",$J,CLN,APPTA,"OUT")=$G(^TMP("BSD",$J,CLN,APPTA,"OUT"))+1
 .... S ^TMP("BSD",$J,CLN,APPTA,"TAT")=$G(^TMP("BSD",$J,CLN,APPTA,"TAT"))+$$GETTAT(BSDCHKI,BSDCHKO)
 N BSDDA
 S BSDDA=0 F  S BSDDA=$O(^TMP("BSD",$J,BSDDA)) Q:'BSDDA  D
 . S NAME=$$GET1^DIQ(44,BSDDA,.01)         ;set clinic's name
 . D SET(NAME,.VALMCNT)                  ;setup the line with clinic name
 . N BSDIEN S BSDIEN=0 F  S BSDIEN=$O(^TMP("BSD",$J,BSDDA,BSDIEN)) Q:'BSDIEN  D
 .. N BSDCNTI,BSDCNTO,BSDTAT
 .. S BSDCNTI=$G(^TMP("BSD",$J,BSDDA,BSDIEN,"IN"))
 .. S BSDCNTO=$G(^TMP("BSD",$J,BSDDA,BSDIEN,"OUT"))
 .. S BSDTAT=$S($G(^TMP("BSD",$J,BSDDA,BSDIEN,"OUT")):$G(^TMP("BSD",$J,BSDDA,BSDIEN,"TAT"))/$G(^TMP("BSD",$J,BSDDA,BSDIEN,"OUT")),1:"")
 .. S LINE=$$PAD($$FMTE^XLFDT(BSDIEN),20)
 .. S LINE=LINE_$$PAD(BSDCNTI,20)
 .. S LINE=LINE_$$PAD(BSDCNTO,18)
 .. S LINE=LINE_$$PAD($$FMTT(BSDTAT),15)
 .. D SET(LINE,.VALMCNT)
 .. I BSDSRT="D" D
 ...S LINE=$$HDRD
 ...D SET(LINE,.VALMCNT)
 ...S LINE=$$REPEAT^XLFSTR("-",100)
 ...D SET(LINE,.VALMCNT)
 ...D DET(BSDDA,BSDIEN)
 ...D SET("",.VALMCNT)
 I BSDSRT="S" K ^TMP("BSD",$J) Q
 Q
 ;cmi/maw lines below no longer used
 D SET("",.VALMCNT)
 S LINE=$$HDRD
 D SET(LINE,.VALMCNT)
 S LINE=$$REPEAT^XLFSTR("-",100)
 D SET(LINE,.VALMCNT)
 N BSDDDA
 S BSDDDA=0 F  S BSDDDA=$O(^TMP("BSD","D",$J,BSDDDA)) Q:'BSDDDA  D
 . N BSDDIEN S BSDDIEN=0 F  S BSDDIEN=$O(^TMP("BSD","D",$J,BSDDDA,BSDDIEN)) Q:'BSDDIEN  D
 .. N BSDDOEN S BSDDOEN=0 F  S BSDDOEN=$O(^TMP("BSD","D",$J,BSDDDA,BSDDIEN,BSDDOEN)) Q:BSDDOEN=""  D
 ... N BSDDATA,BSDCI,BSDCO,BSDT
 ... S BSDDATA=$G(^TMP("BSD","D",$J,BSDDDA,BSDDIEN,BSDDOEN))
 ... S BSDCI=$P(BSDDATA,U)
 ... S BSDCO=$P(BSDDATA,U,2)
 ... S BSDT=$P(BSDDATA,U,3)
 ... S LINE=$$PAD($E($P($G(^DPT(BSDDOEN,0)),U),1,18),20)
 ... S LINE=LINE_$$PAD($$HRN^AUPNPAT(BSDDOEN,DUZ(2)),8)
 ... S LINE=LINE_$$PAD($$FMTE^XLFDT(BSDDIEN),20)
 ... S LINE=LINE_$$PAD($$FMTE^XLFDT(BSDCI),20)
 ... S LINE=LINE_$$PAD($$FMTE^XLFDT(BSDCO),20)
 ... S LINE=LINE_$$PAD($$FMTT(BSDT),11)  ;cmi/maw 11/19/2009 
 ... D SET(LINE,.VALMCNT)
 K ^TMP("BSD",$J)
 Q
 ;
DET(BSDDDA,BSDDDIEN) ;-- print out the details
 N BSDEND
 S BSDEND=BSDDDIEN+.9999
 F  S BSDDDIEN=$O(^TMP("BSD","D",$J,BSDDDA,BSDDDIEN)) Q:BSDDDIEN>BSDEND!('$G(BSDDDIEN))  D
 .N BSDDOEN S BSDDOEN=0 F  S BSDDOEN=$O(^TMP("BSD","D",$J,BSDDDA,BSDDDIEN,BSDDOEN)) Q:BSDDOEN=""  D
 .. N BSDDATA,BSDCI,BSDCO,BSDT
 .. S BSDDATA=$G(^TMP("BSD","D",$J,BSDDDA,BSDDDIEN,BSDDOEN))
 .. S BSDCI=$P(BSDDATA,U)
 .. S BSDCO=$P(BSDDATA,U,2)
 .. S BSDT=$P(BSDDATA,U,3)
 .. S LINE=$$PAD($E($P($G(^DPT(BSDDOEN,0)),U),1,18),20)
 .. S LINE=LINE_$$PAD($$HRN^AUPNPAT(BSDDOEN,DUZ(2)),8)
 .. S LINE=LINE_$$PAD($$FMTE^XLFDT(BSDDDIEN),20)
 .. S LINE=LINE_$$PAD($$FMTE^XLFDT(BSDCI),20)
 .. S LINE=LINE_$$PAD($$FMTE^XLFDT(BSDCO),20)
 .. S LINE=LINE_$$PAD($$FMTT(BSDT),11)  ;cmi/maw 11/19/2009 
 .. D SET(LINE,.VALMCNT)
 Q
 ;
FMTT(T) ;-- reformat TAT
 N LT,LTI,M
 S LT=$L(T)
 ;S M=" min"  cmi/maw 11/19/2009 PATCH 1011
 S M=" H:min"  ;cmi/maw 11/19/2009 PATCH 1011
 S T=(T)\60_":"_$S($L((T)#60)<2:"0"_((T)#60),1:((T)#60))  ;cmi/maw 11/19/2009 PATCH 1011
 S T=$E(T,1,4)  ;cmi/maw 6/9/2010 PATCH 1012
 I $L(T)=0 Q ""
 I $L(T)=1 Q T_"    "_M
 I $L(T)=2 Q T_"   "_M
 I $L(T)=3 Q T_"  "_M
 I $L(T)=4 Q T_" "_M
 Q T_M
 ;
LPAD(A,L) ;-- pad the length to 4 digits
 I A="" Q ""
 I $L(A)=12 Q A
 I $L(A)=11 Q A_"0"
 I $L(A)=10 Q A_"00"
 I $L(A)=4 Q A
 I $L(A)=3 Q A_"0"
 I $L(A)=2 Q A_"00"
 Q A_"000"
 ;
GETTAT(I,O) ;-- calculate turnaround time
 I '$G(O) Q ""
 N IT,OT,ITH,ITM,OTH,OTM,ET,BT,TS,H,M,S
 S IT=$P(I,".",2)
 S OT=$P(O,".",2)
 S X=I
 D H^%DTC
 S ITH=%H
 S ITM=%T
 S X=O
 D H^%DTC
 S OTH=%H
 S OTM=%T
 S ET=OTH_","_OTM
 S BT=ITH_","_ITM
 ;I $D(ET) S TS=(86400*($P(ET,",")-$P(BT,",")))+($P(ET,",",2)-$P(BT,",",2)),H=$P(TS/3600,".") S:H="" H=0 D
 ;.S TS=TS-(H*3600),M=$P(TS/60,".") S:M="" M=0 S TS=TS-(M*60),S=TS
 I $D(ET) S TS=(86400*($P(ET,",")-$P(BT,",")))+($P(ET,",",2)-$P(BT,",",2)),H=$P(TS/3600,".") S:H="" H=0 D
 .;S TS=TS-(H*3600),M=$P(TS/60,".") S:M="" M=0 S TS=TS-(M*60),S=TS
 .S M=$P((TS/60),".") S:M="" M=0  ;cmi/maw 7/22/2010 patch 1012
 Q $G(M)  ;cmi/maw 11/19/2009 PATCH 1011
 ;Q +$G(H)_"."_+$G(M)_"."_+$G(S)
 ;Q OT-IT  ;cmi/maw TODO fix this calculation
 ;
SET(LINE,NUM) ; -- sets display line into array
 S NUM=NUM+1
 S ^TMP("BSDWKR6",$J,NUM,0)=LINE
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
HELP1 ;EP; help for subtotal question
 D MSG^BDGF("This report will display Turnaround Time for;",1,0)
 D MSG^BDGF("clinic(s).  Turnaround time is the difference",1,0)
 D MSG^BDGF("between Checkin Time and Checkout Time.  If there;",1,0)
 D MSG^BDGF("is not a checkout time, turnaround time is blank;",1,0)
 D MSG^BDGF("  Choose D to display a Detailed Report.",1,0)
 D MSG^BDGF("  Choose S to display a Summary Report.",1,0)
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDWKR6",$J),BSDQ,PAGE
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print report to paper
 S PAGE=1
 U IO D HDG
 NEW BSDX S BSDX=0 F  S BSDX=$O(^TMP("BSDWKR6",$J,BSDX)) Q:'BSDX  D
 . I $Y>(IOSL-4) D
 ..S PAGE=PAGE+1
 ..S Y=$$READ^BDGF("E","Press Return to Continue")
 ..D HDG
 . W !,^TMP("BSDWKR6",$J,BSDX,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 D HDR W @IOF  ;,?31,"Turnaround Time"
 F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I) I I=1 W ?70,$S($G(PAGE):"Page: "_$G(PAGE),1:"")
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Appt Date",?20,"Checked In",?40,"Checked Out",?58,"Avg TAT"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
HDGD ;-- do the header for the detailed report
 W !,$$REPEAT^XLFSTR("-",100)
 W !,"Patient Name",?20,"Chart",?28,"Appointment",?42,"Checkin",?59,"Checkout",?78,"TAT"
 W !,$$REPEAT^XLFSTR("=",100)
 Q
 ;
HDRD() ;-- do the header
 N LN
 S LN=$$PAD("Patient Name",20)
 S LN=LN_$$PAD("Chart",8)
 S LN=LN_$$PAD("Appointment",20)
 S LN=LN_$$PAD("Check In",20)
 S LN=LN_$$PAD("Check Out",20)
 S LN=LN_$$PAD("TAT",10)
 Q LN
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
