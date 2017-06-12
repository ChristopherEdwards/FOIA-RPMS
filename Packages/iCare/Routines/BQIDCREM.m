BQIDCREM ;GDIT/HS/ALA-Reminders Panel Definition ; 07 Dec 2012  2:18 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**3,4**;Apr 18, 2012;Build 66
 ;
 Q
 ;
EN(DATA,PARMS,MPARMS) ;EP - Find records
 ;
 ;Description
 ;  Executable that finds all patients who have a reminder
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Expected to return FDATA
 ;
 NEW UID,VDATA,DFN,RIEN,PTMFRAME,PVISITS,FUT,OVD,RMDFROM,RMDTHRU
 NEW CAT,TYP,PROV,NOTA,SPEC,QFL,VISIT,VSDTM,RMDRANGE
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIDCREM",UID))
 S FDATA=$NA(^TMP("BQIFND",UID))
 S VDATA=$NA(^TMP("BQIVIS",UID))
 S DCRIT=$NA(^TMP("BQICRIT",UID))
 K @DATA,@DCRIT,@VDATA,@FDATA
 ;
 ;  Set the parameters into variables
 I '$D(PARMS) Q
 ;
 S NM="" F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 S REMCODE=$G(REMCODE,""),OVD=$G(OVD,""),FUT=$G(FUT,"")
 S PROV=$G(PROV,""),RMDFROM=$G(RMDFROM,""),RMDTHRU=$G(RMDTHRU,"")
 I $G(RMDRANGE)'="" D
 . I $G(PPIEN)'="" D RANGE^BQIDCAH1(RMDRANGE,PPIEN,"RMDRANGE")
 . S RFDT=$S($G(RFROM)'="":RFROM,1:$G(RMDFROM))
 . S REDT=$S($G(RTHRU)'="":RTHRU,1:$G(RMDTHRU))
 I $G(RMDFROM)'="" S RFDT=RMDFROM,REDT=$G(RMDTHRU)
 D PROV
 ;
 I $D(MPARMS("REMCODE")) D  Q
 . S REMCODE=""
 . F  S REMCODE=$O(MPARMS("REMCODE",REMCODE)) Q:REMCODE=""  D SRC
 D SRC
 K @FDATA
 Q
 ;
SRC ;EP - Search and find
 I $D(@FDATA) S DFN="" D
 . F  S DFN=$O(@FDATA@(DFN)) Q:DFN=""  D RMF
 Q
 ;
RMF ;EP - Find reminder
 S RIEN=$O(^BQIPAT(DFN,40,"B",REMCODE,""))
 I RIEN="" Q
 S RDATA=$G(^BQIPAT(DFN,40,RIEN,0)) I RDATA="" Q
 I $P(RDATA,U,3)=""!($P(RDATA,U,3)="N/A") Q
 ;
 I FUT'="" D  Q
 . I $P(RDATA,U,3)="DUE NOW" Q
 . ;I $P(RDATA,U,3)="RESOLVED" S @DATA@(DFN)="" Q
 . I $P(RDATA,U,3)="RESOLVED" Q
 . I $P(RDATA,U,4)'="" D
 .. I $G(RFDT)'="" D
 ... I $P(RDATA,U,4)<RFDT!($P(RDATA,U,4)>REDT) Q
 ... S @DATA@(DFN)="",@DCRIT@("REM",DFN,REMCODE)=""
 .. I $G(RFDT)="",$P(RDATA,U,4)>DT S @DATA@(DFN)="",@DCRIT@("REM",DFN,REMCODE)="" Q
 ;
 I OVD'="" D  Q
 . I $P(RDATA,U,3)="RESOLVED" Q
 . I $P(RDATA,U,4)>DT Q
 . S @DATA@(DFN)="",@DCRIT@("REM",DFN,REMCODE)=""
 Q
 ;
PROV ;EP - 
 ; 
 NEW TMFRAME,VISITS,FDT,TDT,IEN,RFROM,RTHRU
 I $G(DT)="" D DT^DICRW
 S VISITS=$G(PVISITS,"")
 I $G(PPIEN)'="",$G(PTMFRAME)'="" D RANGE^BQIDCAH1(PTMFRAME,PPIEN,"PTMFRAME")
 S FDT=$S($G(RFROM)'="":RFROM,1:$G(PFROM))
 S TDT=$S($G(RTHRU)'="":RTHRU,1:$G(PTHRU))
 S TDT=DT
 I $G(PROV)'="" D PV Q
 Q
 ;
 ;  Go through the V PROVIDER File for the designated provider and
 ;  find out if they are a primary or secondary provider AND if the
 ;  visit falls within the time frame
PV ;
 S IEN=""
 F  S IEN=$O(^AUPNVPRV("B",PROV,IEN),-1) Q:IEN=""  D
 . S VISIT=$$GET1^DIQ(9000010.06,IEN_",",.03,"I") I VISIT="" Q
 . S VSDTM=$$GET1^DIQ(9000010,VISIT_",",.01,"I")\1 I VSDTM=0 Q
 . S DFN=$$GET1^DIQ(9000010.06,IEN_",",.02,"I") I DFN="" Q
 . ;
 . I FDT'="" S QFL=0 D  Q:QFL
 .. I VSDTM'<FDT,VSDTM'>TDT Q
 .. S QFL=1
 . ;  Count number of visits for a patient
 . S @VDATA@(DFN)=$G(@VDATA@(DFN))+1
 ;
 S DFN=""
 F  S DFN=$O(@VDATA@(DFN)) Q:DFN=""  D
 . ;  if the number of visits for patient doesn't match the criteria, quit
 . I @VDATA@(DFN)<VISITS Q  ;Changed from '= to <
 . S @FDATA@(DFN)=""
 ;
 K @VDATA
 Q
