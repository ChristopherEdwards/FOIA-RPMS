BKMQUTL ;PRXM/HC/BWF - BKM Report Utilities; [ 1/19/2005  7:16 PM ] ; 13 Jun 2005  3:41 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ; Designed to write to a temporary file for iCare
 ;
CTR(TEXT) ; EP - Center data.
 ;
 ; Input - TEXT   - Text (required)
 ;         LENGTH - Line length (default is 80)
 ; This utility will center the data before filing it to the RPC temporary global.
 ;
 N CENTER,CLINE,LEN,START
 S LEN=$L(TEXT)
 S CENTER=LEN/2,CLINE=LNLEN/2
 S START=CLINE-CENTER\1
 S TEXT=$$LINE("",TEXT,START)
 D UPD(TEXT)
 Q
  ;
LINE(TEXT,STR,POS) ; Set text to match printed report formatting
 I $L(TEXT)>POS Q TEXT_STR
 S $E(TEXT,POS)=STR
 Q TEXT
 ;
UPD(LINE,NUM,SUPP) ;EP
 ; Update global with line of text
 ; NUM - Number of blank lines that follow text
 ; SUPP - Suppress line feed carriage return
 S NUM=$G(NUM),SUPP=$G(SUPP)
 S BQII=BQII+1,@DATA@(BQII)=LINE_$S(SUPP:"",1:$C(13)_$C(10))
 I NUM D
 . N II
 . F II=1:1:NUM S BQII=BQII+1,@DATA@(BQII)=$C(13)_$C(10)
 Q
 ;
COLHDR ;
 S @DATA@(BQII)="T00120REPORT_TEXT"_$C(30)
 Q
HMSDEN(HMSIEN,DFN) ; EP -- Is patient in HMS denominator?
 ;
 ; Input:
 ;     HMSIEN - internal entry number of HMS tag in file #90506.2
 ;     DFN - the patient's DFN
 ;
 ; Output:
 ;     0 - patient is not in the denominator
 ;     1 - patient is in the denominator
 ;
 ; Denominator:
 ;     Patients with Proposed or Accepted tag status
 ;     with an HMS register status of active or blank (not in register)
 ;
 ; Check Tag status
 N TAGIEN,TAGSTAT,STAT,REG,REGIEN,IENS
 S TAGIEN=$O(^BQIREG("C",DFN,HMSIEN,""))
 I TAGIEN="" Q 0 ; No HMS tag
 S TAGSTAT=$$GET1^DIQ(90509,TAGIEN_",",.03,"I")
 I TAGSTAT'="A",TAGSTAT'="P" Q 0
 ;
 ; Check HMS Register status
 S IENS=$$HMSIENS(DFN),STAT=""
 I IENS'="" S STAT=$$GET1^DIQ(90451.01,IENS,.5,"I")
 I "A"'[STAT Q 0 ; Only 'A'ctive or blank
 Q 1
 ;
HMSIENS(DFN) ; Retrieve HMS Register IENS for specified patient
 S REG="HIV Management System",REGIEN=$O(^BQI(90507,"B",REG,""))
 S EXEC=$$GET1^DIQ(90507,REGIEN_",",3,"I")
 X EXEC ; Sets IENS for patient's HMS data
 Q IENS
 ;
ACT(DFN,DXCAT,STAT) ;EP - Check for Dx tag status for a patient
 ; DFN - Patient ien
 ; DXCAT - ien of diagnostic category
 ; STAT - desired status; if blank either A or P
 ;
 NEW ACT,RIEN,CSTAT
 S RIEN="",ACT=0,CSTAT=""
 F  S RIEN=$O(^BQIREG("C",DFN,DXCAT,RIEN)) Q:RIEN=""  D
 . S CSTAT=$P(^BQIREG(RIEN,0),U,3)
 . I $G(STAT)="B",CSTAT="A"!(CSTAT="P") S ACT=1
 . I $G(STAT)'="B",STAT=CSTAT S ACT=1
 Q ACT_U_CSTAT
