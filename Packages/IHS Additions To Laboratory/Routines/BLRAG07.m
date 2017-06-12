BLRAG07 ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ; 17-Oct-2014 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1031,1034**;NOV 01, 1997;Build 88
 ;
 ;  BLR REF LAB USING LEDI   - UL^BLRAG02      = return the value of the 'REF LAB USING LEDI?' field in the BLR MASTER CONTROL file
 ;  BLR ICD LOOKUP           - ICDLKUP^BLRAG07 = ICD code lookup
 ;  BLR ORDER REASON LKUP    - ORL^BLRAG07     = return order reasons from file 100.03
 ;  BLR PATIENT LOOKUP       - PTLK^BLRAG04    = Patient Lookup
 ;  BLR PRINTERS AVAILABLE   - DEVICE^BLRAG10  = return available printers from the DEVICE file
 ;  BLR USER LOOKUP          - NP^BLRAG06      = return entries from the NEW PERSON table 200 that are 'active'
 ;
 ;  BLR ACCESSION            - ACC^BLRAG05     = lab accession processor
 ;  BLR ACCESSION PRINT      - ABR^BLRAG02     = reprint accession label or manifest
 ;  BLR ALL NON-ACCESSIONED  - ANA^BLRAG01     = return all non-accessioned lab records
 ;  BLR ALL-ACCESSIONED      - ABD^BLRAG02     = return all accessioned records for given date range
 ;  BLR COLLECTION INFO      - BLC^BLRAG06     = check BLR PT CONFIRM parameter and return insurances for patient
 ;  BLR DELETE TEST          - DELTST^BLRAG08  = Cancel tests - Test are no longer deleted, instead the status is changed to Not Performed.
 ;  BLR ORDER/TEST STATUS    - LROS^BLRAG03    = return order/test status for given patient and date range
 ;
 ;  BLR SHIP CONF            - SC^BLRAG09A     = select a shipping configuration
 ;  BLR MANIFEST BUILD       - BM^BLRAG09B     = build a shipping manifest
 ;  BLR MANIFEST CLOSE/SHIP  - CLSHIP^BLRAG09C = Close/ship a shipping manifest
 ;  BLR MANIFEST DISPLAY     - DISP^BLRAG09G   = screen formatted text for manifest display
 ;  BLR MANIFEST START       - SMONLY^BLRAG09C = Start a shipping manifest only, no building
 ;  BLR MANIFEST TEST ADD    - ADDTEST^BLRAG09C= Add tests to an existing manifest\
 ;  BLR MANIFEST TEST REMOVE - REMVTST^BLRAG09C= Remove a test from manifest - actually flags test as "removed".
 ;  BLR MANIFEST TESTS TO ADD- TARPC^BLRAG09B  = return tests that can be added to a manifest
 ;
 ;---------------------------------------------------------------
 ; Lookup ICD's matching input
 ;  BLRINP   = (required) Partial name lookup - free text
 ;  BLRLEX   = (optional) Use Lexicon
 ;                           0=ICD9 lookup (default)
 ;                           1=Lexicon lookup
 ;  BLRVDT   = (optional) Visit date in external format
 ;  BLRGEN   = (optional) patient gender
 ;  BLRECOD  = (optional) allow ECodes flag:
 ;                           0=exclude (default)
 ;                           1=include
 ;                           2=ecodes only
 ;  BLRVCOD  = (optional) allow VCodes flag:
 ;                           0=include
 ;                           1=exclude
 ;                           2=vcodes only
 ;  Returned as a list of records in the format:
 ;    0                  1         2                3
 ;    Descriptive Text ^ ICD IEN ^ Narrative Text ^ ICD Code
 ;
 ; 
ICDLKUP(BLRY,BLRINP,BLRLEX,BLRVDT,BLRGEN,BLRECOD,BLRVCOD) ;EP - ICD lookup
 ;  rpc: BLR ICD LOOKUP
 ;INPUT:
 ;  BLRINP = (required) Partial name lookup - free text; must be at least 3 characters
 ;  BLRLEX = (optional) Use Lexicon
 ;    0=ICD9 lookup (default)
 ;    1=Lexicon lookup
 ;  BLRVDT = (optional) Visit date in external format
 ;  BLRGEN = (optional) patient gender
 ;  BLRECOD = (optional) allow ECodes flag:
 ;    0=exclude (default)
 ;    1=include
 ;    2=ecodes only
 ;  BLRVCOD = (optional) allow VCodes flag:
 ;    0=include
 ;    1=exclude
 ;    2=vcodes only
 ;RETURN:
 ; Returned as a list of records in the format:
 ;  0                  1         2                3
 ;  Descriptive Text ^ ICD IEN ^ Narrative Text ^ ICD Code
 ;
 N DIC,X,Y,I,ICD,LEX,RES
 N AICDRET,XTLKSAY,REC,DESC,CODE,NARR
 N BLRI
 N CODESYS
 NEW ICDCODSY ; IHS/MSC/MKK - LR*5.2*1034
 ;
 S BLRLEX=$G(BLRLEX)
 ; S BLRVDT=$G(BLRVDT)
 S BLRVDT=$G(BLRVDT,$$DT^XLFDT)   ; IHS/MSC/MKK - LR*5.2*1034
 ;
 D ICDCODSY(BLRVDT,.ICDCODSY)     ; IHS/MSC/MKK - LR*5.2*1034
 ;
 S BLRGEN=$G(BLRGEN)
 S BLRECOD=$G(BLRECOD)
 S BLRVCOD=$G(BLRVCOD)
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY=$$TMPGLB^BLRAGUT()
 S @BLRY@(0)="ERROR_ID"
 ;
 I $L($G(BLRINP))<3 D ERR^BLRAGUT("BLRAG07: User name lookup requires at least 3 characters.") Q
 S:BLRVDT'="" BLRVDT=$$CVTDATE^BLRAGUT(BLRVDT)  ;convert date to FM format
 ;
 I BLRLEX D
 .N HITS
 .D LEXLKUP^BLRAGUT(.HITS,BLRINP_"^ICD")
 .S HITS=0
 .F  S HITS=$O(HITS(HITS)) Q:'HITS  D
 ..S BLRLEX=+HITS(HITS)
 ..S X=$$ICDONE^LEXU(BLRLEX)
 ..Q:X=""
 ..S ICD=$O(^ICD9("BA",X,0))
 ..S:'ICD ICD=$O(^ICD9("BA",X_" ",0))
 ..D:ICD CHKHITS
 E  I $G(DUZ("AG"))="I"  D
 .S DIC="^ICD9(",DIC(0)="TM",X=BLRINP,XTLKSAY=0
 .; K ^UTILITY("AICDHITS",$J),^TMP("XTLKHITS",$J)
 . K ^TMP("ICD9",$J),^TMP("XTLKHITS",$J)    ; IHS/MSC/MKK - LR*5.2*1034
 .D ^DIC
 .; I Y'=-1 D
 .I +Y'=-1 D  ; IHS/MSC/MKK - LR*5.2*1034
 ..S ICD=+Y
 ..D CHKHITS
 .E  I $G(^DD(80,0,"DIC"))="XTLKDICL" D
 ..D XTLKUP
 .E  D AICDLKUP
 .I 'BLRI,$L(BLRINP)>2 D
 ..N LK,LN
 ..S LK=BLRINP,LN=$L(BLRINP)
 ..F  D  S LK=$O(^ICD9("BA",LK)) Q:$E(LK,1,LN)'=BLRINP
 ...S ICD=0
 ...F  S ICD=$O(^ICD9("BA",LK,ICD)) Q:'ICD  D CHKHITS
 .K ^UTILITY("AICDHITS",$J),^TMP("XTLKHITS",$J)
 E  D
 .; D FIND^DIC(80,,".01;10","M",BLRINP,,,,,"RES")
 .D FINDER(BLRINP,.RES)      ; IHS/MSC/MKK - LR*5.2*1034
 .I '$O(RES("DILIST",0)) Q
 .M ^TMP("XTLKHITS",$J)=RES("DILIST",2)
 .D XTLKUP
 .K ^TMP("XTLKHITS",$J)
 K @BLRY@(0)
 ;            0           1       2         3
 ; S @BLRY@(0)="DESCRIPTION^ICD_IEN^NARRATIVE^ICD_CODE"
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 ;            0           1       2         3        4
 S @BLRY@(0)="DESCRIPTION^ICD_IEN^NARRATIVE^ICD_CODE^CODING_SYSTEM"
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 Q
 ;
AICDLKUP S I=0
 ; F  S I=$O(^UTILITY("AICDHITS",$J,I)) Q:'I  D
 ; .S ICD=$G(^UTILITY("AICDHITS",$J,I))
 ; .D CHKHITS
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 ; AICD*4.0 Stores "Hits" in ^TMP("ICD9",$J not in ^UTILITY("AICDHITS",$J
 F  S I=$O(^TMP("ICD9",$J,"SEL",I))  Q:I<1  D
 . S ICD=+$G(^TMP("ICD9",$J,"SEL",I))
 . D CHKHITS
 ; ----- END IHS/MSC/MKK - LR*5.2*1034
 ;
 Q
 ;
XTLKUP S I=0
 F  S I=$O(^TMP("XTLKHITS",$J,I)) Q:'I  D
 .S ICD=$G(^TMP("XTLKHITS",$J,I))
 .D CHKHITS
 Q
 ;
CHKHITS Q:$D(@BLRY@(0,ICD))  S @BLRY@(0,ICD)=""
 S REC=$G(^ICD9(ICD,0))
 D ENTRYAUD^BLRUTIL("CHKHITS^BLRAG07 0.0")
 ; Q:$P(REC,U,9)
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 ;       AICD 4.0 modified File 80.  There is no longer an INACTIVE FLAG.
 ;       STATUS is now a multiple.  Note that STATUS=1 is ACTIVE; STATUS=0 is INACTIVE.
 Q:'$P($G(^ICD9(ICD,66,+$O(^ICD9(ICD,66,"A"),-1),0)),"^",2)     ; Most Current Status
 ; ----- END IHS/MSC/MKK - LR*5.2*1034
 ;
 I 'BLRECOD,$E(REC)="E" Q
 I BLRECOD=2,$E(REC)'="E" Q
 I BLRVCOD=1,$E(REC)="V" Q
 I BLRVCOD=2,$E(REC)'="V" Q
 ;
 D ENTRYAUD^BLRUTIL("CHKHITS^BLRAG07 3.0")
 ;
 ; I BLRVDT,$P(REC,U,11),$$FMDIFF^XLFDT(BLRVDT,$P(REC,U,11))>-1 Q
 Q:$$INACTDT(ICD,BLRVDT)     ; IHS/MSC/MKK - LR*5.2*1034
 ;
 I $L(BLRGEN),$P(REC,U,10)'="",BLRGEN'=$P(REC,U,10) Q
 ;
 ; S NARR=$G(^ICD9(ICD,1)),CODE=$P(REC,U),DESC=$P(REC,U,3)
 ; 
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 NEW CODE,NARR,DESC,CODESYS,ICD10ID,IMPLDATE
 S CODE=$P(REC,U)
 S NARR=$$DESCICD(ICD,$G(BLRVDT))
 S DESC=$$DIAGICD(ICD,$G(BLRVDT))
 S CODESYS=+$$GET1^DIQ(80,ICD,"CODING SYSTEM","I")
 Q:$D(ICDCODSY(CODESYS))<1
 ; ----- END IHS/MSC/MKK - LR*5.2*1034
 ; 
 S BLRI=BLRI+1
 ; S @BLRY@(BLRI)=DESC_U_ICD_U_NARR_U_CODE
 S @BLRY@(BLRI)=DESC_U_ICD_U_NARR_U_CODE_U_CODESYS    ; IHS/MSC/MKK - LR*5.2*1034
 Q
 ;
ORL(BLRY,BLRINP)  ;return order reasons from file 100.03
 ; rpc: BLR ORDER REASON LKUP
 ;  BLRINP   = (optional) Partial name lookup - free text
 ;  Returned as a list of records in the format:
 ;    0     1
 ;    IEN ^ NAME
 ;   If the DEFAULT DC REASON from the LABORATORY SITE file 69.9 is
 ;      defined, it will be the 1st entry in the return.
 N BLRDEF,BLRI,BLRIEN,BLRJ
 S BLRINP=$G(BLRINP)
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY=$$TMPGLB^BLRAGUT()
 ;            0   1
 S @BLRY@(0)="IEN^NAME"
 S BLRDEF=$P($G(^LAB(69.9,1,"OR")),"^",2)
 I BLRDEF'="" S BLRI=BLRI+1 S @BLRY@(BLRI)=BLRDEF_U_$P($G(^ORD(100.03,BLRDEF,0)),U,1)  ;set default DC reason as first entry
 S BLRJ=$S(BLRINP'="":$$PREP^BLRAGUT(BLRINP),1:"") F  S BLRJ=$O(^ORD(100.03,"B",BLRJ)) Q:BLRJ=""  Q:BLRINP'[$E(BLRJ,1,$L(BLRINP))  D
 .S BLRIEN=$O(^ORD(100.03,"B",BLRJ,0))
 .S BLRI=BLRI+1 S @BLRY@(BLRI)=BLRIEN_U_BLRJ
 Q
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 ;       AICD 4.0 modified ICD9 global.  Need new functions to retrieve data.
 ;
FINDER(BLRINP,RES) ; EP - Mimic FIND^DIC call
 NEW ICD,ICDSTR
 ;
 K RES
 ;
 S ICDSTR=$$ICDDX^ICDEX(BLRINP)
 Q:+ICDSTR<1
 ;
 S RES("DILIST",0)="1^*^0^"
 S RES("DILIST",0,"MAP")=".01^10"
 S RES("DILIST",1,1)=$P(ICDSTR,"^",2)
 S RES("DILIST",2,1)=+ICDSTR
 S RES("DILIST","ID",1,.01)=$P(ICDSTR,"^",2)
 S ICD=+ICDSTR
 S RES("DILIST","ID",1,10)=$$DESCICD(ICD)
 Q
 ;
DESCICD(ICD,BLRVDT) ; EP - DESCRIPTION is now a multiple
 NEW DESCDATE,DESCNUM,DESCRIP
 ;
 S DESCRIP=$G(^ICD9(ICD,68,+$O(^ICD9(ICD,68,"A"),-1),1)) ; Most Current Description
 ;
 I +$G(BLRVDT) D   ; If there is date, retrieve description current as of that date
 . S BLRVDT=$$FMADD^XLFDT(BLRVDT,-1)   ; "Back up" 1 day to account for $ORDER function
 . S DESCDATE=$O(^ICD9(ICD,68,"B",BLRVDT))
 . Q:DESCDATE<1
 . ;
 . S DESCNUM=$O(^ICD9(ICD,68,"B",DESCDATE,0))
 . Q:DESCNUM<1
 . ;
 . S DESCRIP=$G(^ICD9(ICD,68,DESCNUM,1))
 ;
 Q DESCRIP
 ;
DIAGICD(ICD,BLRVDT) ; EP - DIAGNOSIS is now a multiple
 NEW DIAGDATE,DIAGNUM,DIAGDESC
 ;
 S DIAGDESC=$P($G(^ICD9(ICD,67,+$O(^ICD9(ICD,67,"A"),-1),0)),"^",2)  ; Most Current Diagnosis
 ;
 I +$G(BLRVDT) D   ; If there is date, retrieve diagnosis current as of that date
 . S BLRVDT=$$FMADD^XLFDT(BLRVDT,-1)   ; "Back up" 1 day to account for $ORDER function
 . S DIAGDATE=$O(^ICD9(ICD,67,"B",BLRVDT))
 . Q:DIAGDATE<1
 . ;
 . S DIAGNUM=$O(^ICD9(ICD,67,"B",DIAGDATE,0))
 . Q:DIAGNUM<1
 . ;
 . S DIAGDESC=$P($G(^ICD9(ICD,67,DIAGNUM,0)),"^",2)
 ;
 Q DIAGDESC
 ;
INACTDT(ICD,BLRVDT) ; EP - STATUS EFFECTIVE DATE is part of the STATUS Multiple.
 Q:$G(BLRVDT)<1 0       ; If no date, then cannot check STATUS EFFECTIVE DATE ==> Not Inactive
 ;
 NEW STATUS,STSDATE,STSNUM
 ;
 S BLRVDT=$$FMADD^XLFDT(BLRVDT,-1)   ; "Back up" 1 day to account for $ORDER function
 S STSDATE=$O(^ICD9(ICD,66,"B",BLRVDT))
 Q:STSDATE<1 0          ; If no STATUS EFFECTIVE DATE ==> Not Inactive
 ;
 Q:STSDATE>BLRVDT 0     ; If STATUS EFFECTIVE DATE > BLRVDT, then cannot check STATUS ==> Not Inactive
 ;
 S STSNUM=$O(^ICD9(ICD,66,"B",STSDATE,0))
 Q:STSNUM<1 0           ; If no STATUS ==> Not Inactive
 ;
 S STATUS=+$G(^ICD9(ICD,66,STSNUM,0))
 Q $S(STATUS=1:0,1:1)   ; STATUS = 1 ==> ACTIVE; STATUS = 0 ==> INACTIVE
 ;
 ; The following routine sets the ICDCODSY array based upon the values
 ; in the ICD CODING SYSTEMS file, using the BLRVDT.
ICDCODSY(BLRVDT,ICDCODSY) ; EP - Set the ICDCODSY array
 NEW CODESYS,CODESYSA,IEN,IMPLDATE,TMP
 ;
 K ICDCODSY
 ;
 ; Sort by implementation date
 S IEN=.9999999
 F  S IEN=$O(^ICDS(IEN))  Q:IEN<1  D
 . S IMPLDATE=$$GET1^DIQ(80.4,IEN,"IMPLEMENTATION DATE","I")
 . S CODESYSA=$$GET1^DIQ(80.4,IEN,"CODING SYSTEM ABBREVIATION")
 . S CODESYS=$O(^ICDS("C",CODESYSA,0))
 . S TMP(IMPLDATE,IEN)=CODESYS
 ;
 ; Find the implementation date less than or equal to BLRVDT
 S IMPLDATE="A"
 F  S IMPLDATE=$O(TMP(IMPLDATE),-1)  Q:IMPLDATE<1!($D(ICDCODSY))  D
 . I IMPLDATE'>BLRVDT D
 .. S IEN=0
 .. F  S IEN=$O(TMP(IMPLDATE,IEN))  Q:IEN<1  S ICDCODSY(+$G(TMP(IMPLDATE,IEN)))=""
 Q
 ;
 ; TESTIT
TESTIT ; EP - Interactively test ICDLKUP call
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 K ^TMP("BLRAG")
 ;
 S HEADER(1)="Interactively Test ICDLKUP^BLRAG07"
 ;
 D HEADERDT^BLRGMENU
 ;
 D ^XBFMK
 S DIR(0)="DO"
 S DIR("A")="BLRVDT (Date passed to $$ICDDX^ICDEX)"
 S DIR("B")=$$DT^XLFDT
 D ^DIR
 Q:+$G(DIRUT) $$BADSTUFN("No/Quit/Invalid Entry.")
 ;
 S:+Y BLRVDT=+Y	
 S BLRVDT=$G(BLRVDT,$$DT^XLFDT)
 ;
 S HEADER(2)="Search Date:"_$$FMTE^XLFDT(BLRVDT,"5DZ")
 ;
 S BLRLEX=$G(BLRLEX)
 S BLRGEN=$G(BLRGEN)
 S BLRECOD=$G(BLRECOD)
 S BLRVCOD=$G(BLRVCOD)
 ;
 D HEADERDT^BLRGMENU
 ;
 D ^XBFMK
 S DIR(0)="FO"
 S DIR("A")="Enter ICD Lookup String"
 D ^DIR
 Q:+$G(DIRUT) $$BADSTUFN("No/Quit/Invalid Entry.")
 ;
 S BLRINP=$G(X)
 D ICDLKUP(.BLRY,BLRINP,,BLRVDT)
 ;
 S HEADER(3)=$$CJ^XLFSTR("Lookup String:"_BLRINP,IOM)
 S HEADER(4)=$$CJ^XLFSTR("Data Stored at "_BLRY,IOM)
 S HEADER(5)=" "
 S $E(HEADER(6),19)="CODE"
 S HEADER(7)="BLRI"
 S $E(HEADER(7),9)="ICD"
 S $E(HEADER(7),19)="SYS"
 S $E(HEADER(7),25)="Description"
 S (CNT,PG)=0
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S QFLG="NO"
 ;
 S BLRI=0
 F  S BLRI=$O(@BLRY@(BLRI))  Q:BLRI<1!(QFLG="Q")  D
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,"NO")  Q:QFLG="Q"
 . S STR=$G(@BLRY@(BLRI))
 . W $J(BLRI,4),?8,$P(STR,"^",4),?19,$P(STR,"^",5)
 . D LINEWRAP^BLRGMENU(24,$P(STR,"^"),56)
 . W !
 . S LINES=LINES+1
 . S CNT=CNT+1
 ;
 D PRESSKEY^BLRGMENU(9)
 ;
 Q
 ;
BADSTUFN(MSG) ; EP - Display Message and Quit with ""
 W !!,?4,MSG,"  Routine Ends."
 D PRESSKEY^BLRGMENU(9)
 Q ""
 ;
 ; ----- END IHS/MSC/MKK - LR*5.2*1034
