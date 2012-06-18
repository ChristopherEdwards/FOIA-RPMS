BSDPVW ; IHS/ANMC/LJF - PROVIDER WEEKLY SCHEDULE ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
WEEK ; -- select week by picking any date within that week    
 NEW BSDDT
 S BSDDT=$$READ^BDGF("DO^::EX","Select DATE","TODAY","D DTHELP^BSDPVW")
 Q:BSDDT<1
 ;
 ;
EN ; -- main entry point for BSDAM PROVIDER WEEK
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDAM PROVIDER WEEK")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(10)_"Appointments for "_$$GET1^DIQ(200,BSDPRV,.01)
 S VALMHDR(1)=VALMHDR(1)_" for week of "_$$FMTE^XLFDT(BSDDT)
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDPVD",$J),^TMP("BSDPVD1",$J)
 S VALMCNT=0
 ;
 ; loop thru provider's clinics and then appts for date range
 NEW CLN,CLNM,IEN,DATE,END,NODE
 S CLN=0 F  S CLN=$O(^TMP("BSDPVD2",$J,CLN)) Q:'CLN  D
 . S CLNM=^TMP("BSDPVD2",$J,CLN)
 . ;
 . S DATE=BSDDT-.0001,END=$$FMADD^XLFDT(BSDDT,7)_".24"
 . F  S DATE=$O(^SC(CLN,"S",DATE))  Q:'DATE  Q:(DATE>END)  D
 .. S IEN=0 F  S IEN=$O(^SC(CLN,"S",DATE,1,IEN)) Q:'IEN  D
 ... ;
 ... ; sort by date,clinic; save clinic ien, patient, length, info
 ... S NODE=$G(^SC(CLN,"S",DATE,1,IEN,0)) Q:'NODE
 ... S ^TMP("BSDPVD1",$J,DATE,CLNM,IEN)=$P(NODE,U,1,4)_U_CLN_U_$G(^SC(CLN,"S",DATE,1,IEN,"OB"))
 ;
 I '$D(^TMP("BSDPVD1",$J)) D SET("NO APPTS FOR PROVIDER","",0,.VALMCNT) Q
 ;
 ; put sorted list into display array
 NEW DATE,CLN,IEN,DATA,BSDCNT,LINE,X,I,LASTTM,ENDTM,LASTDT
 S (DATE,LASTDT)=0,BSDCNT=1
 F  S DATE=$O(^TMP("BSDPVD1",$J,DATE)) Q:'DATE  D
 . ;
 . ; mark beginning of new date
 . I (DATE\1)'=LASTDT D
 .. I +$G(LASTDT)'=0 D SET("","",BSDCNT,.VALMCNT)  ;extra line
 .. S X="Appointments for "_$$FMTE^XLFDT(DATE,"D")
 .. D SET($$SP(79-$L(X)\2)_X,"",BSDCNT,.VALMCNT)
 .. S LASTDT=DATE\1
 . ;
 . S CLN=0 F  S CLN=$O(^TMP("BSDPVD1",$J,DATE,CLN)) Q:CLN=""  D
 .. S IEN=0 F  S IEN=$O(^TMP("BSDPVD1",$J,DATE,CLN,IEN)) Q:'IEN  D
 ... S DATA=^TMP("BSDPVD1",$J,DATE,CLN,IEN)
 ... S LINE=$J(BSDCNT,2)_". "_$P($$FMTE^XLFDT(DATE,2),"@",2)  ;appt time
 ... S ENDTM=$P($$FMTE^XLFDT($$FMADD^XLFDT(DATE,0,0,$P(DATA,U,2))),"@",2)
 ... S LINE=LINE_"-"_ENDTM_$TR($P(DATA,U,6),"O","*")  ;end time/overbk
 ... S LINE=$$PAD(LINE,17)_$E(CLN,1,11)             ;end time & clinic
 ... S LINE=$$PAD(LINE,30)_$E($$NAMEPRT^BDGF2(+DATA,0),1,18)  ;patient
 ... S LINE=$$PAD(LINE,50)_$E($P(DATA,U,4),1,29)             ;appt info
 ... ;
 ... ; add extra lines if end time diff hour from last appt
 ... I $D(LASTTM) D
 .... S X=$E($P(DATE,".",2),1,2)-$E(LASTTM,1,2)   ;difference in hours
 .... F I=1:1:X D SET("","",BSDCNT,.VALMCNT)     ;determines # of lines
 ... S LASTTM=ENDTM   ;save end time to compare with next appt
 ... ;
 ... ; now print this appt
 ... D SET(LINE,(+DATA)_U_$P(DATA,U,5)_U_DATE,BSDCNT,.VALMCNT)
 ... S BSDCNT=$G(BSDCNT)+1   ;number on display page
 ;
 K ^TMP("BSDPVD1",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDPVD2",$J),^TMP("BSDPVD",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
DTHELP ;EP; help for date range question
 D MSG^BDGF("Enter the beginning date for the report.",2,0)
 D MSG^BDGF("The display will display appointments for that date",1,0)
 D MSG^BDGF("and the next 6 for a week's worth.",1,1)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
SET(DATA,IENS,COUNT,LINE) ; -- put data into display array
 S LINE=LINE+1                      ;line number
 S ^TMP("BSDPVD",$J,LINE,0)=DATA
 S ^TMP("BSDPVD",$J,"IDX",LINE,COUNT)=IENS
 Q
 ;
