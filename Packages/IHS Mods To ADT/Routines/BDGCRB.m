BDGCRB ; IHS/ANMC/LJF - CLINICAL RECORD BRIEF ; 
 ;;5.3;PIMS;**1007,1008**;APR 26, 2002
 ;
 ;
 ;cmi/anch/maw 7/25/2007 added set of copies to 1 if in quiet mode or bombs in BDGCRB1
 ;
 ;
FORMS ;EP; entry point for admission forms option
 NEW FORM,CHOICE,DGPMT
 K BDGFRM,BDGHALF,BDGCOP,BDGFIN,DGQUIET,DGPMCA,DFN
 ;
 I $D(^XUSEC("DGZNOCLN",DUZ)) D  Q
 . W !!,"LOCATOR CARD",!!
 . S FORM=1,DGPMT=1 D NOPAT^BDGLOC(1)
 ;
 S CHOICE="1:Locator Card;2:A Sheet;3:A Sheets by Admit Date"
 I $D(^XUSEC("DGZPCC2",DUZ)) S CHOICE=CHOICE_";4:Final A Sheet"
 S FORM=$$READ^BDGF("SO^"_CHOICE,"Select Admission Form to Print")
 S DGPMT=1
 I FORM=1 D NOPAT^BDGLOC(1) Q
 I FORM=2 D NOPAT(0) Q
 I FORM=3 D DATES(0) Q
 I FORM=4 D NOPAT(1)
 Q
 ;
 ;
NOPAT(FINAL) ;EP; entry point where patient is not known
 ; FINAL set to 1 if called by FINAL A SHEET option
 NEW DFN,DGPMCA,BDGHALF
 ;
 ; set patient and admission
 S DFN=+$$READ^BDGF("PO^2:EMQZ","Select Patient") Q:DFN<1
 S DGPMCA=$$ADMIT(DFN) Q:DGPMCA<1
 I '$G(DGPMT) S DGPMT=1
 ;
 I '$G(FINAL) S BDGFIN=0
 ;
 I $G(FINAL) D  Q:'BDGFIN
 . S BDGFIN=$$READ^BDGF("SO^1:A Sheet Only;2:A Sheet with CPT List;3:Medicare/Medicaid A Sheet","Select Report to Print",$$GET1^DIQ(9009020.1,$$DIV^BSDU,.07,"I"),"^D FINHLP^BDGCRB")
 ;
 D PAT(DFN,DGPMCA,BDGFIN,+$G(DGPMT))
 Q
 ;
 ;
PAT(DFN,DGPMCA,BDGFIN,DGPMT,BDGHALF,DGQUIET,BDGCOP,BDGDEV) ;EP; pat & adm are known
 ;
 ; REQUIRED:
 ; DFN = patient ien; DGPMCA = admission ien
 ;
 ; DGPMT = transaction type (1=admission, 2=ward transfer, etc.)
 ;
 ; BDGFIN = 0 if not final a sheet, = 1 for a sheet only,
 ;        = 2 for a sheet & cpt list, = 3 for a sheet & m/m list
 ;
 ; OPTIONAL:
 ; DGQUIET = if set to 1 no user interaction and all other optional
 ;               variables are set
 ; BDGDEV  = print device if sent by calling routine
 ;           otherwise will look for a sheet printer for ward
 ;
 ; REQUIRED IF DGQUIET IS SET:
 ; BDGHALF = 1 to print bottom half of form, = 0 to leave blank
 ;         = 2 assumes printing of coded data
 ; BDGCOP = number of copies to print
 ;
 ;
 I ('DFN)!('DGPMCA)!($G(DGPMT)="") Q
 Q:'$D(^DGPM(DGPMCA,0))     ;quit if admission deleted
 Q:DGPMT'=1                 ;a sheets printed only at admission
 ;
 ; get CRB format from parameter file
 NEW BDGFRM
 S BDGFRM=$$GET1^DIQ(9009020.1,$$DIV^BSDU,.06,"I")
 I 'BDGFRM D  Q
 . Q:$G(DGQUIET)
 . D MSG^BDGF("No Clinical Record Brief format has been defined for this facility",2,1)
 . D PAUSE^BDGF
 ;
 ; if in quiet mode, call ZTLOAD and quit
 I $G(DGQUIET) D  Q
 . I '$G(BDGDEV) S BDGDEV=$$WRDPTR(DFN) Q:'BDGDEV   ;find ward's printer
 . S BDGCOP=1  ;cmi/anch/maw 7/25/2007 set copies to 1 if they are in quiet mode
 . D ZIS^BDGF("F","^BDGCRB1","A SHEET PRINT","DFN;DGPMCA;DGPMDA;BDGFRM;BDGHALF;BDGFIN;BDGCOP",$G(BDGDEV))
 . K BDGCNT,BDGHALF,BDGFIN,BDGCOP,BDGFRM  ;cmi/maw 10/3/2007
 . D ^%ZISC  ;cmi/maw 10/3/2007
 ;
 ; else ask user questions
 D MSG^BDGF("Printing A Sheet for admission. Type ^ to bypass.",2,0)
 I BDGFIN>0 S BDGHALF=2     ;if final a sheet
 E  S BDGHALF=$$READ^BDGF("Y","Print Bottom Half of A Sheet","YES") Q:BDGHALF=U
 S BDGCOP=$$READ^BDGF("N^1:10","Print How Many Copies",1) Q:BDGCOP<1
 ;
 ; then send to print device
 I '$G(BDGDEV) S BDGDEV=$$WRDPTR(DFN) I 'BDGDEV K BDGDEV   ;find ward's printer
 D ZIS^BDGF("PQ","^BDGCRB1","A SHEET PRINT","DFN;DGPMCA;DGPMDA;BDGFRM;BDGHALF;BDGFIN;BDGCOP",$G(BDGDEV))
 K BDGCNT,BDGHALF,BDGFIN,BDGCOP,BDGFRM  ;cmi/maw 10/3/2007
 D ^%ZISC  ;cmi/maw 10/3/2007
 Q
 ;
 ;
ADMIT(DFN) ; ask user to select an admission for patient
 I '$D(^DGPM("APCA",DFN)) W !!?5,"No admissions on file." Q 0
 ;
 ; loop by inverse date to display admissions with most recent first
 NEW IEN,IVDT,COUNT,ADM,Y
 W !!,"Admission(s)" S COUNT=0
 S IVDT=0 F  S IVDT=$O(^DGPM("ATID1",DFN,IVDT)) Q:'IVDT  D
 . S IEN=0 F  S IEN=$O(^DGPM("ATID1",DFN,IVDT,IEN)) Q:'IEN  D
 .. S COUNT=COUNT+1,ADM(COUNT)=IEN             ;save ien by count
 .. W !?5,COUNT,".  ",$$GET1^DIQ(405,IEN,.01)  ;display date by count
 .. S X=$$ADMSRV^BDGF1(IEN,DFN)
 .. W ?35,$S(X["OBSERVATION":"Observation",1:"Hospitalization")
 ;
 I COUNT=1 Q ADM(1)     ;only one, no need to choose
 S Y=$$READ^BDGF("NO^1:"_COUNT,"Select One",1)
 Q +$G(ADM(+Y))
 ;
FINHLP ;EP; help for final sheet sheet format question  
 D MSG^BDGF("Answer 1 to print ONLY the final A Sheet.",2,0)
 D MSG^BDGF("Answer 2 to print the A Sheet and a listing of all CPT codes for admission.",2,0)
 D MSG^BDGF("Answer 3 to print the A Sheet and an abbreviated CPT listing.",2,0)
 Q
 ;
 ;
DATES(BDGFIN) ;Entry Point for printing a sheets by admit date
 NEW BDGDT,BDGHALF,BDGCOP,BDGFRM
 ;
 ; get facility's a sheet format
 S BDGFRM=$$GET1^DIQ(9009020.1,$$DIV^BSDU,.06,"I")
 I 'BDGFRM D  Q
 . Q:$G(DGQUIET)
 . D MSG^BDGF("No Clinical Record Brief format has been defined for this facility",2,1)
 . D PAUSE^BDGF
 ;
 S BDGDT=$$READ^BDGF("DO^::EX","Select Admission Date") Q:BDGDT<1
 S BDGHALF=$$READ^BDGF("Y","Print Bottom Half of A Sheet","YES")
 Q:BDGHALF=U
 S BDGCOP=$$READ^BDGF("N^1:10","Print How Many Copies",1) Q:BDGCOP<1
 ;
 D ZIS^BDGF("PQ","DATEP^BDGCRB","A SHEETS BY DATE","BDGDT;BDGFIN;BDGHALF;BDGCOP;BDGFRM")
 Q
 ;
 ;
DATEP ;EP; entry point for queuing to print a sheets by date
 ; Assumes BDGDT, BDGHALF, BDGCOP, BDGFRM  are set
 NEW BDGADT
 S BDGADT=BDGDT-.0001,BDGDT=BDGDT+.24
 F  S BDGADT=$O(^DGPM("AMV1",BDGADT)) Q:'BDGADT  Q:(BDGADT>BDGDT)  D
 . S BDGPAT=0
 . F  S BDGPAT=$O(^DGPM("AMV1",BDGADT,BDGPAT)) Q:'BDGPAT  D
 .. S BDGDA=0
 .. F  S BDGDA=$O(^DGPM("AMV1",BDGADT,BDGPAT,BDGDA)) Q:'BDGDA  D
 ... ;
 ... ; set variables and call ^BDCRB1
 ... S DFN=BDGPAT,DGPMCA=BDGDA,BDGFIN=0
 ... W @IOF
 ... D ^BDGCRB1
 ;
 ; clean up after all have printed
 D ^%ZISC
 K BDGDT,BDGADT,BDGPAT,BDGDA,DFN,DGPMCA,BDGHALF,BDGFRM,BDGCOP
 Q
 ;
WRDPTR(PAT) ; return printer device attached to patient's current ward
 NEW WARD
 S WARD=$$GET1^DIQ(2,PAT,.1) I WARD="" Q 0
 S WARD=$O(^DIC(42,"B",WARD,0)) I 'WARD Q 0
 Q $$GET1^DIQ(9009016.5,WARD,.04)
