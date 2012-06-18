ABSPOS6H ; IHS/FCS/DRS - Data Entry & Status Disp ; 
 ;;1.0;PHARMACY POINT OF SALE;**10**;JUN 21, 2001
 ; continuation of ABSPOS6A:
 ;   SETLINE, INFOCT, COMMENTS
 ;-----------------------------------------------------------------
 ;IHS/SD/lwj 3/10/04 patch 10 V1.0
 ;Cherokee reported a problem with the selection process
 ; on the List Manager screen.  The problem was isolated
 ; to the occasion when the patient's IEN was less than the
 ; number of claims to display.  The selection prompt would
 ; limit the user to the patient's IEN.  (i.e. IEN = 5,
 ; select prompt would remain at 5-5 even if there were
 ; 100 claims to select from.)  The problem was traced
 ; to the additional entry:
 ; ^TMP("ABSPOS",$J,"VALM","IDX",LINE,INFO("PATIEN"),RXI)
 ; While the:
 ; ^TMP("ABSPOS",$J,"VALM","IDX",LINE,INFO("PATIENT")
 ; entry is setup and used by list manager, the other entry
 ; appeared to be bogus and may have been used when the
 ; screen was first set up.  No other references were made
 ; to the "RXI" entry in any of the POS programs, so it was
 ; remarked from this routine where it was defined.
 ;-------------------------------------------------------------
 ;
 Q
SETLINE(LINE,PAT,RXI) ;EP - from ABSPOS6I
 ; set up given line# in array for given PAT name; R root
 ; LINE # in array to set
 ; PAT = which patient
 ; RXI: if present, set this up as a prescription line
 ;      if missing, set this up as a patient line
 N %,X,INFO D INFO^ABSPOS6B(PAT,$G(RXI)) ; Set INFO(*) array
 ;
 ; Setting up - common to both patient and prescription lines:
 ;    X is started; whatever branch you go to will build on X
 ;
SETL1 K ^TMP("ABSPOS",$J,"VALM","IDX",LINE) ; indexing for ^VALM2 call
 S X=$$SETFLD^VALM1($J(LINE,2),"","LINE NUMBER")
 ;
 ; Setting up for a prescription line:
 ;
SETL2 I $G(RXI) D
 .I LINE="" D
 . . D IMPOSS^ABSPOSUE("P","TI","LINE null",,"SETL2",$T(+0))
 .I INFO("PATIEN")="" D
 . . D IMPOSS^ABSPOSUE("P","TI","INFO(""PATIEN"") null",,"SETL2",$T(+0))
 .I RXI="" D
 . . D IMPOSS^ABSPOSUE("P","TI","RXI null",,"SETL2",$T(+0))
 .;
 .;IHS/SD/lwj 3/10/04 patch 10 nxt line remrked out
 .;S ^TMP("ABSPOS",$J,"VALM","IDX",LINE,INFO("PATIEN"),RXI)=""
 .;
 .S X=$$SETFLD^VALM1(INFO("DRUG"),X,"PATIENT") ; drug name 
 .N C S C=INFO("RES") ; this will be either status or result
 .;     DO INFO also tacked on the prescription number
 .S X=$$SETFLD^VALM1(C,X,"COMMENTS")
 .I $L(C)>80 S X=$$SETFLD^VALM1($E(C,81,160),X,"COMMENTS 2")
 .I $L(C)>160 S X=$$SETFLD^VALM1($E(C,161,$L(C)),X,"COMMENTS 3")
 ;
 ; Setting up for a patient line:
 ;
SETL3 E  D
 .S ^TMP("ABSPOS",$J,"VALM","IDX",LINE,INFO("PATIEN"))=""
 .I INFO("%")=100 S INFO("%")="done"
 .E  S INFO("%")=" "_$J(INFO("%"),2)_"%"
 .S X=$$SETFLD^VALM1(INFO("%"),X,"PERCENT DONE")
 .S X=$$SETFLD^VALM1(PAT,X,"PATIENT")
 .N C S C=INFO("RES") ;$S(INFO("%")="done":$$COMMENTS,1:INFO("RES"))
 .S X=$$SETFLD^VALM1($E(C,1,80),X,"COMMENTS")
 .I $L(C)>80 S X=$$SETFLD^VALM1($E(C,81,160),X,"COMMENTS 2")
 .I $L(C)>160 S X=$$SETFLD^VALM1($E(C,161,210),X,"COMMENTS 3")
SETL9 D SET^VALM10(LINE,X,LINE)
 I $$VISIBLE^ABSPOS6I(LINE) D WRITE^VALM10(LINE)
 Q
INFOCT(N)          ; how many of these things?
 I INFO("COUNT")=1 Q "" ; only one, so we display no count
 I N=INFO("COUNT") Q "ALL " ; more than one and they're all this way
 Q N_" "
COMMENTS()         ; construct the comments based on what's in the INFO array
 N %,A,M,X,Y S %="",M=255 ; M = max length 
 ; start with results
 I $O(INFO("RES",""))]"" D  ;S %="RESULTS: " D
 .S A="" F  S A=$O(INFO("RES",A)) Q:A=""  D
 ..;S X=$P(A,U),Y=$P(A,U,2,$L(A,U)) ; X = result code, Y = text
 ..S %=%_$$INFOCT(INFO("RES",A)) ; how many of them
 ..;I Y]"" S %=%_Y ; with this status
 ..;E  S %=%_"result code "_X
 ..S %=%_A
 ..S %=%_"; "
 ..I $L(%)>M S %=$E(%,1,$L(M))
 ; tack on statuses
 I INFO("%")'="done" D
 .S %=%_"STATUS: "
 .S A="" F  S A=$O(INFO("STAT",A)) Q:A=""  D
 ..S %=%_$$INFOCT(INFO("STAT",A))_$$STATI^ABSPOSU(A)_"; " ; count,text
 ..I $L(%)>M S %=$E(%,1,$L(M))
 I %?.E1"; " S %=$E(%,1,253)
 Q %
DISPHIST(MSG,HANG) ;EP - DEBUGGING - to record history and pause
 Q:'$P($G(^ABSP(9002313.99,1,"ABSPOS6*")),U)
 S @DISPHIST=@DISPHIST+1
 S @DISPHIST@(@DISPHIST)=MSG
 Q:'$G(HANG)!$G(NODISPLY)
 D MSG^VALM10(MSG)
 HANG HANG
 D MSG^VALM10("")
 Q
