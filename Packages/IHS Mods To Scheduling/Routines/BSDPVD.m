BSDPVD ; IHS/ANMC/LJF - PROVIDER'S DAILY SCHEDULE ; 
 ;;5.3;PIMS;**1005**;MAY 28, 2004
 ;IHS/OIT/LJF 03/09/2006 PATCH 1005 screen out cancelled appointments
 ;
 NEW BSDVW,BSDPRV,BSDDT
PROV ; -- select provider to display    
 S BSDPRV=+$$READ^BDGF("PO^200:EMQZ","Select PROVIDER","","","I $$SCREEN^DGPMDD(+Y)")
 Q:BSDPRV<1
 D CLINICS      ;find all clinics linked to provider
 Q:'$D(^TMP("BSDPVD2",$J))
 ;
DAYWEEK ; -- select view by day or week
 S BSDVW=$$READ^BDGF("SO^D:DAILY;W:WEEKLY","Select DISPLAY TIMEFRAME")
 I "DW"'[BSDVW Q
 I BSDVW="W" D ^BSDPVW Q  ;weekly display
 ;
DATE ; -- select day to view 
 S BSDDT=$$READ^BDGF("DO^::EX","Select DATE","TODAY") I BSDDT<1 D PROV Q
 ;
 ;
EN ;EP; -- main entry point for BSDAM PROVIDER DAY
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDAM PROVIDER DAY")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S VALMHDR(2)=$$SP(15)_"Appointments for "_$$GET1^DIQ(200,BSDPRV,.01)
 S VALMHDR(2)=VALMHDR(2)_" for "_$$FMTE^XLFDT(BSDDT,"D")
 Q
 ;
INIT ; -- init variables and list array
 S BSDLN=0
 K ^TMP("BSDPVD",$J),^TMP("BSDPVD1",$J)
 ;
 ; loop thru provider's clinics and then appts for date
 NEW CLN,CLNM,IEN,DATE,END,NODE
 S CLN=0 F  S CLN=$O(^TMP("BSDPVD2",$J,CLN)) Q:'CLN  D
 . S CLNM=^TMP("BSDPVD2",$J,CLN)
 . ;
 . S DATE=BSDDT-.0001,END=BSDDT_".2400"
 . F  S DATE=$O(^SC(CLN,"S",DATE))  Q:'DATE  Q:(DATE>END)  D
 .. S IEN=0 F  S IEN=$O(^SC(CLN,"S",DATE,1,IEN)) Q:'IEN  D
 ... ;
 ... ; sort by date,clinic; save clinic ien, patient, length, info
 ... S NODE=$G(^SC(CLN,"S",DATE,1,IEN,0)) Q:'NODE
 ... Q:$P(NODE,U,9)="C"                 ;skip if appt cancelled;IHS/OIT/LJF 03/09/2006 PATCH 1005
 ... S ^TMP("BSDPVD1",$J,DATE,CLNM,IEN)=$P(NODE,U,1,4)_U_CLN_U_$G(^SC(CLN,"S",DATE,1,IEN,"OB"))
 ;
 I '$D(^TMP("BSDPVD1",$J)) D SET("NO APPTS FOR PROVIDER","",0,.BSDLN) S VALMCNT=1 Q
 ;
 ; put sorted list into display array
 NEW DATE,CLN,IEN,DATA,BSDCNT,LINE,X,I,LAST,ENDTM
 S DATE=0 F  S DATE=$O(^TMP("BSDPVD1",$J,DATE)) Q:'DATE  D
 . S CLN=0 F  S CLN=$O(^TMP("BSDPVD1",$J,DATE,CLN)) Q:CLN=""  D
 .. S IEN=0 F  S IEN=$O(^TMP("BSDPVD1",$J,DATE,CLN,IEN)) Q:'IEN  D
 ... S DATA=^TMP("BSDPVD1",$J,DATE,CLN,IEN)
 ... S BSDCNT=$G(BSDCNT)+1                                      ;number on display page
 ... S LINE=$J(BSDCNT,2)_". "_$P($$FMTE^XLFDT(DATE,2),"@",2)    ;appt time
 ... S ENDTM=$P($$FMTE^XLFDT($$FMADD^XLFDT(DATE,0,0,$P(DATA,U,2))),"@",2)
 ... S LINE=LINE_"-"_ENDTM_$TR($P(DATA,U,6),"O","*")            ;end time/overbk
 ... S LINE=$$PAD(LINE,17)_$E(CLN,1,11)                         ;end time & clinic
 ... S LINE=$$PAD(LINE,30)_$E($$NAMEPRT^BDGF2(+DATA,0),1,18)    ;patient
 ... S LINE=$$PAD(LINE,50)_$E($P(DATA,U,4),1,29)                ;appt info
 ... ;
 ... ; add extra lines if end time diff hour from last appt
 ... I $D(LAST) D
 .... S X=$E($P(DATE,".",2),1,2)-$E(LAST,1,2)   ;difference in hours
 .... F I=1:1:X D SET("","",.BSDCNT,.BSDLN)     ;determines # of lines
 ... S LAST=ENDTM   ;save end time to compare with next appt
 ... ;
 ... ; now print this appt
 ... D SET(LINE,(+DATA)_U_$P(DATA,U,5)_U_DATE,.BSDCNT,.BSDLN)
 ;
 S VALMCNT=BSDLN
 K ^TMP("BSDPVD1",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDPVD",$J),^TMP("BSDPVD2",$J),VALMCNT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
SET(DATA,IENS,COUNT,LINE) ; -- put data into display array
 S LINE=LINE+1                      ;line number
 S ^TMP("BSDPVD",$J,LINE,0)=DATA
 S ^TMP("BSDPVD",$J,"IDX",LINE,COUNT)=IENS
 Q
 ;
CLINICS ;EP; -- sets ^tmp for provider's clinics
 ; called by ^BDGPV to display provider's appts
 ; If BSDQUIET is set & >0 no messages display on screen
 ;
 NEW CLN,IEN,NAME
 K ^TMP("BSDPVD2",$J)
 S CLN=0 F  S CLN=$O(^SC("AIHSDPR",BSDPRV,CLN)) Q:'CLN  D
 . S IEN=0 F  S IEN=$O(^SC("AIHSDPR",BSDPRV,CLN,IEN)) Q:'IEN  D
 .. I ^SC("AIHSDPR",BSDPRV,CLN,IEN)'=1 Q   ;not default provider
 .. S NAME=$$GET1^DIQ(44,CLN,.01)
 .. S ^TMP("BSDPVD2",$J,CLN)=NAME
 .. Q:$G(BSDQUIET)   ;no writing to screen
 .. I '$D(^TMP("BSDPVD2",$J)) D MSG^BDGF($$SP(15)_"Provider's Clinics:",2,0)
 .. D MSG^BDGF($$SP(18)_NAME,1,0)
 Q:$G(BSDQUIET)
 I '$D(^TMP("BSDPVD2",$J)) D MSG^BDGF("NO clinics found for provider!",2,1)
 E  D MSG^BDGF("",1,0)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
