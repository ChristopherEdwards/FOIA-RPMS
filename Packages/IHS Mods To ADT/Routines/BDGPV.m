BDGPV ; IHS/ANMC/LJF - PROVIDER INQUIRY ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 NEW BDGPV,BDGPVN,DEF,SCR,BDGSRT
 S DEF=$S($D(^XUSEC("PROVIDER",DUZ)):$$GET1^DIQ(200,DUZ,.01),1:"")
 S SCR="I $D(^XUSEC(""PROVIDER"",+Y))"         ;screen for provider key
 S BDGPV=$$READ^BDGF("PO^200:EMQZ","Select PROVIDER NAME",DEF,"",SCR)
 Q:BDGPV<1  S BDGPVN=$P(BDGPV,U,2),BDGPV=+BDGPV
 ;
 S BDGSRT=$$READ^BDGF("SAO^W:WARD;S:SERVICE","Inpatients sorted by Ward or Service: ","WARD") Q:BDGSRT=U
 I $$BROWSE^BDGF="B" D EN Q
 D ZIS^BDGF("PQ","START^BDGPV","PROVIDER'S INPATIENTS","BDGPV;BDGPVN;BDGSRT")
 Q
 ;
START ;EP; entry when printing to paper
 S BDGPRT=1 D INIT,PRINT Q
 ;
EN ;EP; -- main entry point for BDG PROVIDER INQUIRY
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG PROVIDER INQUIRY")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(10)_"** "_$$CONF^BDGF_" **"
 S VALMHDR(2)=$$SP(75-$L(BDGPVN)\2)_BDGPVN      ;provider name
 S VALMSG=$$SP(7)_"Attending/Admitting/Primary Care"
 Q
 ;
INIT ; -- init variables and list array
 I '$G(BDGPRT) D MSG^BDGF("Please wait while I compile the list...",1,0)
 NEW BDGCNT
 K ^TMP("BDGPV",$J),^TMP("BDGPV1",$J)
 S VALMCNT=0    ;line count
 S BDGCNT=1     ;patient count for choosing patient entry
 D INPT,SCHADM,DAYSUR,SCHDS,APPTS,SCHVST
 I '$D(^TMP("BDGPV",$J)) S ^TMP("BDGPV",$J,1,0)="NO PATIENTS FOUND",VALMCNT=1
 K ^TMP("BDGPV1",$J)
 Q
 ;
INPT ; find all inpatients for this provider
 NEW BDGCA,DFN,SRT,X,BDGX,LINE,CAT,SRT,NAME
 ;  loop thru ACA xref in ^DPT for current admissions
 S BDGCA=0 F  S BDGCA=$O(^DPT("ACA",BDGCA)) Q:'BDGCA  D
 . S DFN=0 F  S DFN=$O(^DPT("ACA",BDGCA,DFN)) Q:'DFN  D
 .. ;
 .. ; set admissions into array sorted by category and ward/srv sort
 .. S SRT=$S(BDGSRT="W":$G(^DPT(DFN,.1)),1:$$GET1^DIQ(2,DFN,.103))
 .. I SRT="" S SRT="??"
 .. ;
 .. ; category 1: prov is prim inpt prov or attending
 .. I $G(^DPT(DFN,.1041))=BDGPV D  Q
 ... S ^TMP("BDGPV1",$J,1,SRT,$$GET1^DIQ(2,DFN,.01),DFN)=BDGCA
 .. ;
 .. ; category 2: prov is admitting only
 .. I $$ADMPRV^BDGF1(BDGCA,DFN,"ADM")=BDGPVN D  Q
 ... S ^TMP("BDGPV1",$J,2,SRT,$$GET1^DIQ(2,DFN,.01),DFN)=BDGCA
 .. ;
 .. ; category 3: prov is PCP only
 .. K BDGX S BDGX="BDGX" D PCP^BSDU1(DFN,.BDGX)
 .. I $P(BDGX(1),"/",3)=BDGPV  D
 ... S ^TMP("BDGPV1",$J,3,SRT,$$GET1^DIQ(2,DFN,.01),DFN)=BDGCA
 ;
 ; now take sorted list and put into display array
 S CAT=0 F  S CAT=$O(^TMP("BDGPV1",$J,CAT)) Q:'CAT  D
 . ;
 . ; put category subtitle into display array
 . S LINE=$S(CAT=1:"Attending Provider:",CAT=2:"Admitting Provider:",1:"Primary Care Provider")
 . D SET($G(IORVON)_LINE_$G(IORVOFF),.VALMCNT,BDGCNT,"")
 . ;
 . S SRT=0 F  S SRT=$O(^TMP("BDGPV1",$J,CAT,SRT)) Q:SRT=""  D
 .. ;
 .. ; put sort item subtitle into display array
 .. S LINE="For "_SRT_$S(BDGSRT="W":" Ward",1:" Service")
 .. D SET($$SP(3)_$G(IOUON)_LINE_$G(IOUOFF),.VALMCNT,BDGCNT,"")
 .. ;
 .. S NAME=0 F  S NAME=$O(^TMP("BDGPV1",$J,CAT,SRT,NAME)) D:NAME="" SET("",.VALMCNT,BDGCNT,"") Q:NAME=""  D
 ... S DFN=0 F  S DFN=$O(^TMP("BDGPV1",$J,CAT,SRT,NAME,DFN)) Q:'DFN  D
 .... S BDGCA=^TMP("BDGPV1",$J,CAT,SRT,NAME,DFN)   ;corresp adm ien
 .... ;
 .... ; build lines and put into display array
 .... S LINE=$J(BDGCNT,2)_") "_$E(NAME,1,18)
 .... S LINE=$$PAD(LINE,24)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)
 .... S LINE=$$PAD(LINE,33)_$S(BDGSRT="W":$$SRV,1:$$WRD)      ;wrd/srv
 .... S LINE=$$PAD(LINE,41)_$G(^DPT(DFN,.101))                ;room-bed 
 .... S LINE=$$PAD(LINE,50)_$P($$GET1^DIQ(405,BDGCA,.01),"@")  ;admit dt
 .... S LINE=$$PAD(LINE,64)_$$GET1^DIQ(405,BDGCA,.1)          ;dx
 .... D SET(LINE,.VALMCNT,BDGCNT,"IP"_U_DFN_U_BDGCA)
 .... ;
 .... S LINE=$$PAD($$SP(5)_$$CWAD^BDGF2(DFN),17)              ;cwad
 .... S LINE=LINE_$E($$GET1^DIQ(2,DFN,.1041),1,15)_"/"        ;attend
 .... S LINE=LINE_$E($$ADMPRV^BDGF1(BDGCA,DFN,"ADM"),1,15)_"/"   ;admtg
 .... K BDGX S BDGX="BDGX" D PCP^BSDU1(DFN,.BDGX)
 .... S LINE=LINE_$E($P($G(BDGX(1)),"/"),1,15)              ;pcp
 .... D SET(LINE,.VALMCNT,BDGCNT,"IP"_U_DFN_U_BDGCA)
 .... ;
 .... ; increment patient selection number
 .... S BDGCNT=BDGCNT+1
 Q
 ;
SCHADM ; find scheduled admissions for next week for provider
 ;D SCHED^BDGPV1("IP")
 Q
 ;
DAYSUR ; find all day surgery patients for this provider
 I $T(PRVSUR^BSRPEP)]"" D  Q
 . NEW BDGRR,X,DATE,IEN,BDGI
 . K ^TMP("BDGPV1",$J)
 . S BDGRR="^TMP(""BDGPV1"",$J)"
 . D PRVSUR^BSRPEP(BDGPV,DT,.BDGRR)    ;get list from surgery
 . I '$D(^TMP("BDGPV1",$J)) Q
 . ;
 . D SET("Today's Surgeries:",.VALMCNT,BDGCNT,"")
 . ;
 . I $D(^TMP("BDGPV1",$J)) D
 .. S DATE=0 F  S DATE=$O(^TMP("BDGPV1",$J,DATE)) Q:'DATE  D
 ... S IEN=0 F  S IEN=$O(^TMP("BDGPV1",$J,DATE,IEN)) Q:'IEN  D
 .... F BDGI=1:1 Q:'$D(^TMP("BDGPV1",$J,DATE,IEN,BDGI))  D
 ..... S X=$S(BDGI=1:$J(BDGCNT,2)_") ",1:$$SP(4))
 ..... S X=X_^TMP("BDGPV1",$J,DATE,IEN,BDGI)
 ..... D SET(X,.VALMCNT,BDGCNT,"SR"_U_IEN)
 .... S BDGCNT=BDGCNT+1
 . K ^TMP("BDGPV1",$J)
 ;
 ;
 ; look for day surgeries scheduled for today
 NEW BDGDT,BDGEND,DFN,IENS,LINE,BDGFRST
 S BDGDT=DT-.0001,BDGEND=DT+.24,BDGFRST=1
 F  S BDGDT=$O(^ADGDS("AA",BDGDT)) Q:'BDGDT  Q:BDGDT>BDGEND  D
 . S DFN=0 F  S DFN=$O(^ADGDS("AA",BDGDT,DFN)) Q:'DFN  D
 .. S BDGDS=0 F  S BDGDS=$O(^ADGDS("AA",BDGDT,DFN,BDGDS)) Q:'BDGDS  D
 ... ;
 ... ; if first on list, display subheading
 ... I BDGFRST D SET($G(IORVON)_"Today's Day Surgeries:"_$G(IORVOFF),.VALMCNT,BDGCNT,"") S BDGFRST=0
 ... ;
 ... ; put today's surgeries into display array
 ... S IENS=DFN_","_BDGDS
 ... S LINE=$J(BDGCNT,2)_") "_$P($$GET1^DIQ(9009012.01,IENS,.01),".",2)
 ... S LINE=$$PAD(LINE,12)_$E($$GET1^DIQ(2,DFN,.01),1,18)   ;pat name
 ... S LINE=$$PAD(LINE,32)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)   ;chart #
 ... S LINE=$$PAD(LINE,40)_$$GET1^DIQ(9009012.01,IENS,1)    ;procedure
 ... D SET(LINE,.VALMCNT,BDGCNT,"DS"_U_DFN_U_BDGDS)
 ... ;
 ... ; build status line with released date/time or other status
 ... S STATUS="",X=$$GET1^DIQ(9009012.01,IENS,7) I X]"" D
 .... S STATUS="Released at "_X
 .... I $$GET1^DIQ(9009012.01,IENS,11)="YES" S STATUS=STATUS_" (Admitted)" Q
 .... I $$GET1^DIQ(9009012.01,IENS,15)="YES" S STATUS=STATUS_" (Unescorted)"
 ... ;
 ... I STATUS="" D
 .... I $$GET1^DIQ(9009012.01,IENS,12)="YES" S STATUS="**CANCELLED**" Q
 .... I $$GET1^DIQ(9009012.01,IENS,13)="YES" S STATUS="**NO-SHOW**" Q
 ... ;
 ... D SET($$SP(10)_STATUS,.VALMCNT,BDGCNT,"DS"_U_DFN_U_BDGDS)
 ... ;
 ... ; increment counter
 ... S BDGCNT=BDGCNT+1
 Q
 ;
SCHDS ; find scheduled day surgeries
 ;D SCHED^BDGPV1("DS")
 Q
 ;
APPTS ; find all appts for provider for today
 NEW BSDPRV,BSDQUIET,BSDDT
 S BSDPRV=BDGPV,BSDDT=DT,BSDQUIET=1
 D CLINICS^BSDPVD  ;sets ^TMP("BSDPV2",$J) array
 ;
 ; next lines of code were copied from BSDPVD and modified to fit this
 ;   display array with the proper selelction numbers
 K ^TMP("BDGPV1",$J)
 ;
 ; loop thru provider's clinics and then appts for date
 NEW CLN,CLNM,IEN,DATE,END,NODE
 S CLN=0 F  S CLN=$O(^TMP("BSDPVD2",$J,CLN)) Q:'CLN  D
 . S CLNM=$$GET1^DIQ(44,CLN,1)        ;clinic abbrievation
 . ;
 . S DATE=BSDDT-.0001,END=BSDDT_".2400"
 . F  S DATE=$O(^SC(CLN,"S",DATE))  Q:'DATE  Q:(DATE>END)  D
 .. S IEN=0 F  S IEN=$O(^SC(CLN,"S",DATE,1,IEN)) Q:'IEN  D
 ... ;
 ... ; sort by date,clinic; save clinic ien, patient, length, info
 ... S NODE=$G(^SC(CLN,"S",DATE,1,IEN,0)) Q:'NODE
 ... S ^TMP("BDGPV1",$J,DATE,CLNM,IEN)=$P(NODE,U,1,4)_U_CLN_U_$G(^SC(CLN,"S",DATE,1,IEN,"OB"))
 ;
 I '$D(^TMP("BDGPV1",$J)) Q
 D SET($G(IORVON)_"Today's Appointments:"_$G(IORVOFF),.VALMCNT,BDGCNT,"")
 D SET($$SP(4)_$G(IOUON)_"Appt Time    Clinic   Patient"_$G(IOUOFF),.VALMCNT,BDGCNT,"")
 ;
 ; put sorted list into display array
 NEW DATE,CLN,IEN,DATA,LINE,X,I,LAST,ENDTM
 S DATE=0 F  S DATE=$O(^TMP("BDGPV1",$J,DATE)) Q:'DATE  D
 . S CLN=0 F  S CLN=$O(^TMP("BDGPV1",$J,DATE,CLN)) Q:CLN=""  D
 .. S IEN=0 F  S IEN=$O(^TMP("BDGPV1",$J,DATE,CLN,IEN)) Q:'IEN  D
 ... S DATA=^TMP("BDGPV1",$J,DATE,CLN,IEN)
 ... S LINE=$J(BDGCNT,2)_") "_$P($$FMTE^XLFDT(DATE,2),"@",2)  ;appt time
 ... S ENDTM=$P($$FMTE^XLFDT($$FMADD^XLFDT(DATE,0,0,$P(DATA,U,2))),"@",2)
 ... S LINE=LINE_"-"_ENDTM_$TR($P(DATA,U,6),"O","*")  ;end time/overbk
 ... S LINE=$$PAD(LINE,17)_CLN                        ;end time & clinic
 ... S LINE=$$PAD(LINE,26)_$E($$GET1^DIQ(2,+DATA,.01),1,18)  ;patient
 ... S LINE=$$PAD(LINE,45)_$J("#"_$$HRCN^BDGF2(+DATA,DUZ(2)),6)  ;chart #
 ... S LINE=$$PAD(LINE,54)_$$CWAD^BDGF2(+DATA)               ;cwad
 ... ;
 ... ; add extra lines if end time diff hour from last appt
 ... I $D(LAST) D
 .... S X=$E($P(DATE,".",2),1,2)-$E(LAST,1,2)   ;difference in hours
 .... F I=1:1:X D SET("",.VALMCNT,BDGCNT,"")    ;determines # of lines
 ... S LAST=ENDTM   ;save end time to compare with next appt
 ... ;
 ... ; now print this appt
 ... D SET(LINE,.VALMCNT,BDGCNT,"OP"_U_(+DATA)_U_$P(DATA,U,5)_U_DATE)
 ... ; and other info comments
 ... D SET($$SP(17)_$E($P(DATA,U,4),1,50),.VALMCNT,BDGCNT,"")
 ... ;
 ... ; increment counter
 ... S BDGCNT=BDGCNT+1   ;number on display page
 ;
 K ^TMP("BDGPV1",$J)
 Q
 ;
 Q
 ;
SCHVST ; find scheduled outpat visits and those for quarters
 ;D SCHED^BDGPV1("OUT")
 Q
 ;
PRINT ; print report to paper
 U IO D HDG
 NEW LINE
 S LINE=0 F  S LINE=$O(^TMP("BDGPV",$J,LINE)) Q:'LINE  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGPV",$J,LINE,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 D HDR W @IOF,?30,"Provider's Current Inpatients"
 NEW I F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("-",80)
 W !?5,"Patient Name",?23,"Chart #",?33,"Wrd/Srv",?42,"Room-Bed"
 W ?51,"Admit Date",?65,"Admitting Dx"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGPV",$J) K BDGPRT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
SET(LINE,LNUM,PNUM,IEN) ; puts display line into array
 S LNUM=LNUM+1
 S ^TMP("BDGPV",$J,LNUM,0)=LINE
 S ^TMP("BDGPV",$J,"IDX",LNUM,PNUM)=IEN
 Q
 ;
SRV() ; return current service abbreviation for patient   
 Q $$GET1^DIQ(45.7,+$G(^DPT(DFN,.103)),99)
 ;
WRD() ; return current ward abbreviation for patient
 NEW X
 S X=$G(^DPT(DFN,.1)) I X="" Q "??"
 S X=$$GET1^DIQ(9009016.5,+$O(^DIC(42,"B",X,0)),.02)
 Q $S(X="":"??",1:X)
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
