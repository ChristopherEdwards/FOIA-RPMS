BSDAL2 ; IHS/ANMC/LJF - IHS APPT LIST - CONTINUED ;  
 ;;5.3;PIMS;**1004,1005,1007,1011,1012,1013**;DEC 01, 2006
 ;IHS version of SDAL0
 ;IHS/OIT/LJF 07/15/2005 PATCH 1004 used code for printable age, instead of just a number
 ;IHS/OIT/LJF 05/03/2006 PATCH 1005 added parens around inurance coverage for readability
 ;cmi/anch/maw 11/22/2006 PATCH 1007 added code in APPTLN for item 1007.03
 ;cmi/flag/maw 11/6/2009 PATCH 1011 added code in CLINIC to print for multiple days
 ;cmi/flag/maw 6/4/2010 PATCH 1012 added code to expand other info
 ;ihs/cmi/maw 04/05/2011 PATCH 1013 RQMT152 added cell phone
 ;
START ;EP; called by list template INIT^BSDALL
 NEW SC,BSDCN
 S BSDCN=0
 F  S BSDCN=$S(VAUTC:$O(^SC("B",BSDCN)),1:$O(VAUTC(BSDCN))) Q:BSDCN=""  D
 . S SC=0
 . F  S SC=$O(^SC("B",BSDCN,SC)) Q:'SC  D CLINIC
 Q
 ;
CLINIC ; called for each clinic
 NEW BSDACT,BSD,IEN,FIRST,LINE
 ; check if clinic is active and not cancelled for date
 ;cmi/flag/maw 11/6/2009 pims patch 1011
 N BSDDA
 S BSDDA=0 F  S BSDDA=$O(BSDD(BSDDA)) Q:'BSDDA  D
 . S BSDD=+$G(BSDD(BSDDA))
 . I $$CHECK(SC,BSDD),$$ACTIVITY(SC,BSDD) D
 .. S LINE=$S($G(BSDPRT):"@@@@@",1:"")      ;tof marker for paper print
 .. S LINE=LINE_"Appointments for  "_$$GET1^DIQ(44,SC,.01)
 .. S LINE=LINE_" clinic on  "_$$FMTE^XLFDT(BSDD)
 .. D SET(LINE,.VALMCNT)
 .. I '$G(BSDPRT) D SET($$REPEAT^XLFSTR("=",80),.VALMCNT)
 .. ;
 .. ;get each appt time for date and clinic
 .. S BSDACT=0,BSD=BSDD
 .. F  S BSD=$O(^SC(SC,"S",BSD)) Q:'BSD!(BSD\1>BSDD)  D
 ... ;  find each appt at date/time then call APPTLN to print info
 ... S IEN=0,FIRST=1
 ... F  S IEN=$O(^SC(SC,"S",BSD,1,IEN)) Q:'IEN  D
 .... Q:$P($G(^SC(SC,"S",BSD,1,IEN,0)),U,9)="C"     ;cancelled
 .... D APPTLN(SC,BSD,IEN)                          ;print appt data line
 .. ;
 .. I 'BSDACT D
 ... S BSDACT="No appointment activity found for this clinic date!"
 ... D SET("",.VALMCNT),SET($$SP(75-$L(BSDACT)\2)_BSDACT,.VALMCNT)
 .. ;
 .. D SET("",.VALMCNT)         ;blank line before chart requests or next clinic
 .. I BSDCR D CCLK(SC,BSDD)    ;print chart requests at end of list
 ;
 Q
 ;
APPTLN(CLN,DATE,IEN) ; -- for each individual appt, print patient data
 NEW NODE,DFN,DATA,X,VA,VADM,BSDZ,SPACE,Z,VAPA,LINE
 S NODE=^SC(CLN,"S",DATE,1,IEN,0),DFN=+NODE
 ;cmi/anch/maw 11/3/2006 added length of appointment item 1007.03 patch 1007
 N BSDLOA
 S BSDLOA=$P(NODE,U,2)
 ;cmi/anch/maw 11/3/2006 end of length of appointment item 1007.03 patch 1007
 I BSDWI=0,$$WALKIN^BSDU2(DFN,DATE) Q                 ;quit if excluding walk-ins
 S DATA=$G(^DPT(DFN,"S",DATE,0)) Q:$P(DATA,U,2)["C"   ;cancelled
 D DEM^VADPT
 ;
 ; -- build display line
 ; line 1: appt time, walkin, checkin, out vs inpt
 I FIRST D                                       ;if first appt at this time, print time
 . ;S FIRST=0,X=DATE D TM^SDROUT0 S LINE=$J(X,8)  ;cmi/anch/maw 11/3/2006 original line item 1007.03 patch 1007
 . S FIRST=0,X=DATE D TM^SDROUT0 S LINE=$J(X,8)_$$SP(1)_$S($G(BSDLOA):"("_BSDLOA_" Min)",1:"")  ;cmi/anch/maw 11/3/2006 modified line item 1007.03 patch 1007
 E  D SET("",.VALMCNT) S LINE=""                 ;else print extra line
 ;
 ;S LINE=$$PAD(LINE,12)  ;cmi/anch/maw 11/3/2006 original line item 1007.03 patch 1007
 S LINE=$$PAD(LINE,20)  ;cmi/anch/maw 11/3/2006 modified line item 1007.03 patch 1007
 I $P(DATA,U,7)=4 S LINE=LINE_"Walk-in "
 E  S X=$P($G(^SC(SC,"S",DATE,1,IEN,"C")),U) I X]"" D
 . D TM^SDROUT0 S LINE=LINE_"Checked in at "_X                  ;checkin time
 ;
 I ($P(DATA,U,2)="N")!($P(DATA,U,2)="NA") S LINE=LINE_"No-Show"
 ;
 S X=$$INPT1^BDGF1(DFN,DATE) S LINE=$$PAD(LINE,40)              ;inpatient?
 I X]"" S LINE=LINE_"Admitted "_X_"  "                          ;admit date
 S LINE=LINE_"("_$S($G(^DPT(DFN,.1))]"":^(.1),1:"Outpatient")_")"
 D SET(LINE,.VALMCNT)
 ;
 ; -- line 2: name, chart #, dob, age, lab/x-ray/ekg times
 I $$DEAD^BDGF2(DFN) D
 . D SET($$SP(12)_"**PATIENT DIED ON "_$$DOD^BDGF2(DFN)_"**",.VALMCNT)
 ;
 S LINE=$$SP(3)_$S($D(^SC(SC,"S",DATE,1,IEN,"OB")):"*",1:"")    ;overbook
 S LINE=$$PAD(LINE,5)_$E(VADM(1),1,20)                          ;pat name
 S LINE=$$PAD($$PAD(LINE,27)_"#"_$$HRCN^BDGF2(DFN,DUZ(2)),36)   ;pat id
 ;S LINE=LINE_$$FMTE^XLFDT(+VADM(3),5)_" ("_VADM(4)_")"         ;dob(age)
 S LINE=LINE_$$FMTE^XLFDT(+VADM(3),5)_" ("_$$AGE(DFN)_")"       ;IHS/OIT/LJF 7/15/2005 PATCH 1004
 ;
 S (BSDZ(3),BSDZ(4),BSDZ(5))="",SPACE=0                         ;lab/xray/ekg
 F X=3,4,5 S BSDZ(X)=$P(DATA,U,X)                               ;test date/times
 ;F Z=3,4,5 S X=BSDZ(Z) D:X]"" TM^SDROUT0 S SPACE=Z#3*8+3 S LINE=$$PAD(LINE,(48+SPACE))_$J(X,8)_"  "
 F Z=3,4,5 S X=BSDZ(Z) D:X]"" TM^SDROUT0 S SPACE=Z#3*8+3 S LINE=$$PAD(LINE,(50+SPACE))_$J(X,8)_"  "  ;IHS/OIT/LJF 7/15/2005 PATCH 1004
 D SET(LINE,.VALMCNT)
 ;
 ; line 3: insurance coverage and other info
 ;S LINE=$$PAD($$SP(9)_$$INSUR^BDGF2(DFN,DATE),18)_$P(NODE,U,4)
 ;S LINE=$$PAD($$SP(9)_"("_$$INSUR^BDGF2(DFN,DATE)_")",18)_$P(NODE,U,4)   ;IHS/OIT/LJF 05/03/2006 PATCH 1005 cmi/maw PATCH 1012 RQMT129 orig line
 S LINE=$$PAD($$SP(9)_"("_$$INSUR^BDGF2(DFN,DATE)_")",18)  ;IHS/OIT/LJF 05/03/2006 PATCH 1005 cmi/maw PATCH 1012 RQMT129 new line
 D SET(LINE,.VALMCNT)
 ;cmi/maw 6/4/2010 PATCH 1012 RQMT 129
 I $L($P(NODE,U,4))>78 D
 . S LINE=$E($P(NODE,U,4),1,78)
 . D SET(LINE,.VALMCNT)
 . S LINE=$E($P(NODE,U,4),79,155)
 . D SET(LINE,.VALMCNT)
 I $L($P(NODE,U,4))<78 D
 . S LINE=$P(NODE,U,4)
 . D SET(LINE,.VALMCNT)
 ;
 ; line 4: appt made by
 I BSDAMB D
 . NEW X,Y,Z
 . S X=$P(NODE,U,6),Y=$P(NODE,U,7) Q:X=""
 . S LINE=$$SP(9)_"Made by "_$$GET1^DIQ(200,X,.01)_"  on "
 . S LINE=LINE_$$FMTE^XLFDT(Y,"2")
 . S Z=$$GET1^DIQ(200,X,.132) I Z]"" S LINE=LINE_" ("_Z_")"  ;usr phone
 . D SET(LINE,.VALMCNT)
 ;
 ; line 5: patient phone & primary care provider info
 I (BSDPH)!(BSDPCMM) S LINE=$$SP(9) D
 . ;cmi/anch/maw 11/3/2006 start of work phone print item 1007.01 patch 1007
 . I BSDPH D
 .. K VAPA
 .. D ADD^VADPT
 .. N BSDWPH,BSDCPH  ;ihs/cmi/maw 04/05/2011 Patch 1013 RQMT152
 .. S BSDWPH=$$GET1^DIQ(2,DFN,.132)
 .. S BSDCPH=$$GET1^DIQ(9000001,DFN,1801)  ;ihs/cmi/maw 04/05/2011 Patch 1013 RQMT152
 .. S LINE=LINE_"Home Phone: "_VAPA(8)
 .. S LINE=LINE_$$SP(3)_"Work Phone: "_$G(BSDWPH)
 .. I $L(LINE>9) D SET(LINE,.VALMCNT)
 .. S LINE=$$SP(8)_"Other Phone: "_$G(BSDCPH)  ;ihs/cmi/maw 04/05/2011 Patch 1013 RQMT152
 .. D SET(LINE,.VALMCNT)
 . ;cmi/anch/maw 11/3/2006 commented out line below to add work phone as well item 1007.01 patch 1007
 . ;I BSDPH K VAPA D ADD^VADPT S LINE=LINE_"Phone: "_VAPA(8)  ;pat phone
 . ;cmi/anch/maw 11/3/2006 end of work phone print item 1007.01 patch 1007
 . I BSDPCMM D
 .. NEW BSDARR S BSDARR="BSDARR" D PCP^BSDU1(DFN,.BSDARR)
 .. ;I $D(BSDARR(1)) S LINE=$$PAD(LINE,60)_"PCP: "_$P(BSDARR(1),"/",1,2)  cmi/anch/maw 11/3/2006 original line item 1007.01 patch 1007
 .. I $D(BSDARR(1)) S LINE=$$SP(9)_"PCP: "_$P(BSDARR(1),"/",1,2)  ;cmi/anch/maw 11/3/2006 modified line item 1007.01 patch 1007
 .. I $L(LINE>9) D SET(LINE,.VALMCNT)  ;cmi/anch/maw 8/14/2007 added .notation as it was wrong PATCH 1007
 ;
 ;cmi/anch/maw 11/3/2006 added current community item 1007.02 patch 1007
 ; line 6: current community
 I $G(BSDCC) D
 . S LINE=$$SP(9)_$S($$GET1^DIQ(9000001,DFN,1118)]"":"Current Community: "_$$GET1^DIQ(9000001,DFN,1118),1:"")
 . D SET(LINE,.VALMCNT)
 ;cmi/anch/maw 11/3/2006 end of item 1007.02 patch 1007
 ;
 S BSDACT=BSDACT+1 D SET("",.VALMCNT)
 Q
 ;
 ;
CCLK(CLN,DATE) ; -- list chart requests for this clinic and date
 NEW BSDC,DFN,IEN,BSDN
 I $O(^SC(CLN,"C",DATE,1,0)) D
 . D SET("CHART REQUESTS for "_$$FMTE^XLFDT(DATE)_":",.VALMCNT)
 ;
 S IEN=0 F  S IEN=$O(^SC(CLN,"C",DATE,1,IEN)) Q:'IEN  D
 . S DFN=$G(^SC(CLN,"C",DATE,1,IEN,0)) Q:'DFN
 . S BSDN=$G(^SC(CLN,"C",DATE,1,IEN,9999999))
 . S LINE=$E($$GET1^DIQ(2,DFN,.01),1,20)
 . S LINE=$$PAD(LINE,23)_"#"_$$HRCN^BDGF2(DFN,DUZ(2))
 . S LINE=$$PAD(LINE,35)_$E($P(BSDN,U,3),1,33)
 . D SET(LINE,.VALMCNT)
 . I BSDAMB D
 .. S LINE=$$SP(11)_"Made by "_$$GET1^DIQ(200,+$P(BSDN,U,2),.01)
 .. S LINE=LINE_" on "_$$FMTE^XLFDT(+BSDN,"D")
 .. S X=$$GET1^DIQ(200,+$P(BSDN,U,2),.132)
 .. I X]"" S LINE=LINE_" ("_X_")"     ;user phone
 .. D SET(LINE,.VALMCNT)
 Q
 ;
 ;
CHECK(CLN,APDT) ;check if clinic for this division and not cancelled or inactive
 I $$GET1^DIQ(44,CLN,2,"I")'="C" Q 0                   ;not a clinic
 I 'VAUTD,'$D(VAUTD(+$$GET1^DIQ(44,CLN,3.5,"I"))) Q 0  ;wrong division
 I '$$ACTV^BSDU(CLN,APDT) Q 0                          ;not active
 I $G(^SC(CLN,"ST",APDT,1))["**CANCELLED" Q 0          ;cancelled
 Q 1
 ;
 ;
ACTIVITY(CLN,APDT) ;Determine if clinic has activity to print for appt date
 I BSDCR,$O(^SC(CLN,"C",APDT,0)) Q 1  ;chart request list
 NEW DATE,FOUND,N
 S FOUND=0,DATE=APDT
 F  S DATE=$O(^SC(CLN,"S",DATE)) Q:'DATE  Q:(DATE\1>APDT)  Q:FOUND  D
 .S N=0 F  S N=$O(^SC(CLN,"S",DATE,1,N)) Q:'N!FOUND  D
 .. I $P(^SC(CLN,"S",DATE,1,N,0),U,9)'["C" S FOUND=1
 Q FOUND
 ;
SET(DATA,NUM) ; put display line into display array
 S NUM=NUM+1
 S ^TMP("BSDAL",$J,NUM,0)=DATA
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
AGE(P) ; returns shortened printable age  ;IHS/OIT/LJF 7/15/2005 PATCH 1004
 Q $E($$STRIP^XLFSTR($$AGE^AUPNPAT(DFN,DATE,"R")," "),1,3)
