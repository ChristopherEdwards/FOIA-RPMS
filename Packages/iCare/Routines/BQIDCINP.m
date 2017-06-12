BQIDCINP ;GDIT/HS/ALA-Find Inpatient Patients ; 06 Nov 2012  3:43 PM
 ;;2.4;ICARE MANAGEMENT SYSTEM;;Apr 01, 2015;Build 41
 ;
 Q
 ;
EN(DATA,PARMS,MPARMS) ;EP
 ;
 ;Description
 ;  Executable to retrieve inpatients for the specified parameters
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Output
 ;  ^TMP("BQIDCINP",UID,DFN,VISIT IEN)=""
 ;
 NEW UID,AFDT,AEDT,DFDT,DEDT,NXN,IEN,CURINP,ARANGE,DRANGE,RFROM,RTHRU,AFROM,ATHRU
 NEW DFROM,DTHRU,LOC,IEN,DFN,NXN,VIEN,VISIT,ATYP,APROV,WARD,DTYP,FTSPEC,CT,MCT
 NEW DSDTM,ADTM,NRSE,NURSE
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIDCINP",UID))
 S DCRIT=$NA(^TMP("BQICRIT",UID))
 K @DATA,@DCRIT
 ;
 ;  Set the parameters into variables
 I '$D(PARMS) Q
 ;
 S NM="" F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 S CURINP=$G(CURINP,""),ARANGE=$G(ARANGE,""),AFROM=$G(AFROM,""),ATHRU=$G(ATHRU,""),ATYP=$G(ATYP,"")
 S DRANGE=$G(DRANGE,""),DFROM=$G(DFROM,""),DTHRU=$G(DTHRU,""),DTYP=$G(DTYP,""),APROV=$G(APROV,"")
 S WARD=$G(WARD,""),FTSPEC=$G(FTSPEC,"")
 ;
 I $G(ARANGE)'="" D
 . I $G(PPIEN)'="" D RANGE^BQIDCAH1(ARANGE,PPIEN,"ARANGE")
 . S AFDT=$S($G(RFROM)'="":RFROM,1:$G(AFROM))
 . S AEDT=$S($G(RTHRU)'="":RTHRU,1:$G(ATHRU))
 I $G(AFROM)'="" S AFDT=AFROM,AEDT=$G(ATHRU)
 ;
 I $G(DRANGE)'="" D
 . I $G(PPIEN)'="" D RANGE^BQIDCAH1(DRANGE,PPIEN,"DRANGE")
 . S DFDT=$S($G(RFROM)'="":RFROM,1:$G(DFROM))
 . S DEDT=$S($G(RTHRU)'="":RTHRU,1:$G(DTHRU))
 I $G(DFROM)'="" S DFDT=DFROM,DEDT=$G(DTHRU)
 ;
 I $G(CURINP)'="" D
 . S LOC=""
 . F  S LOC=$O(^DGPM("CN",LOC)) Q:LOC=""  D
 .. S IEN=""
 .. F  S IEN=$O(^DGPM("CN",LOC,IEN)) Q:IEN=""  D
 ... I $G(^DGPM(IEN,0))="" Q
 ... S DFN=$P(^DGPM(IEN,0),U,3),$P(@DCRIT@("INP",DFN,IEN),U,1)=1
 ... S ADTM=$P(^DGPM(IEN,0),U,1)\1
 ... I $G(AFDT)'="",ADTM<AFDT!(ADTM>AEDT) S $P(@DCRIT@("INP",DFN,IEN),U,1)=0 Q
 ... D ADM
 ;
 I $G(CURINP)="",$G(AFDT)'="" D
 . S AFDT=AFDT-.0001
 . F  S AFDT=$O(^DGPM("B",AFDT)) Q:AFDT=""!(AFDT\1>AEDT)  D
 .. S IEN=""
 .. F  S IEN=$O(^DGPM("B",AFDT,IEN)) Q:IEN=""  D
 ... I $$GET1^DIQ(405,IEN_",",.02,"E")'="ADMISSION" Q
 ... I $G(^DGPM(IEN,0))="" Q
 ... S DFN=$P(^DGPM(IEN,0),U,3),$P(@DCRIT@("INP",DFN,IEN),U,1)=1
 ... D ADM
 ;
 I $G(DFDT)'="" D
 . I $D(@DCRIT) D
 .. S DFN=""
 .. F  S DFN=$O(@DCRIT@("INP",DFN)) Q:DFN=""  D
 ... S IEN=""
 ... F  S IEN=$O(@DCRIT@("INP",DFN,IEN)) Q:IEN=""  D
 .... S NXN="",QFL=0
 .... F  S NXN=$O(^DGPM("CA",IEN,NXN),-1)  Q:NXN=IEN  D  Q:QFL
 ..... I $$GET1^DIQ(405,NXN_",",.02,"E")'="DISCHARGE" S $P(@DCRIT@("INP",DFN,IEN),U,6)=0 Q
 ..... D:$G(DTYP)="" UPD(7,"") D:$G(DTYP)'="" UPD(7,0)
 ..... I $G(DTYP)'="",$P(^DGPM(IEN,0),U,4)=DTYP D UPD(7,1)
 ..... S DSDTM=$$GET1^DIQ(405,NXN_",",.01,"I")
 ..... I DSDTM\1<DFDT!(DSDTM\1>DEDT) S $P(@DCRIT@("INP",DFN,IEN),U,6)=0 Q
 ..... S $P(@DCRIT@("INP",DFN,IEN),U,6)=1,QFL=1
 ..... ;D CNF
 . I '$D(@DCRIT) D
 .. S DFDT=DFDT-.0001
 .. F  S DFDT=$O(^AUPNVINP("B",DFDT)) Q:DFDT=""!(DFDT\1>DEDT)  D
 ... S VIEN=""
 ... F  S VIEN=$O(^AUPNVINP("B",DFDT,VIEN)) Q:VIEN=""  D
 .... I $G(^AUPNVINP(VIEN,0))="" Q
 .... S VISIT=$P(^AUPNVINP(VIEN,0),U,3),DFN=$P(^(0),U,2)
 .... S IEN=$O(^DGPM("AVISIT",VISIT,"")) I IEN="" Q
 .... S DFN=$P(^DGPM(IEN,0),U,3),$P(@DCRIT@("INP",DFN,IEN),U,6)=1
 .... D ADM,DIS
 ;
 S DFN=""
 F  S DFN=$O(@DCRIT@("INP",DFN)) Q:DFN=""  D
 . S IEN=""
 . F  S IEN=$O(@DCRIT@("INP",DFN,IEN)) Q:IEN=""  D CNF
 ;
 Q
 ;
UPD(PEC,VAL) ;EP
 S $P(@DCRIT@("INP",DFN,IEN),U,PEC)=VAL
 Q
 ;
DIS ; EP - Discharge
 S NXN=""
 F  S NXN=$O(^DGPM("CA",IEN,NXN),-1)  Q:NXN=IEN  D
 . I $$GET1^DIQ(405,NXN_",",.02,"E")'="DISCHARGE" Q
 . S DFN=$P(^DGPM(IEN,0),U,3),$P(@DCRIT@("INP",DFN,IEN),U,6)=1
 . I $G(DTYP)="",'$D(MPARMS("DTYP")) D UPD(7,"")
 . I $G(DTYP)'="" D UPD(7,0) I $P(^DGPM(IEN,0),U,4)=DTYP D UPD(7,1)
 . I $G(DTYP)="",$D(MPARMS("DTYP")) D
 .. S DTYP="" D UPD(7,"")
 .. F  S DTYP=$O(MPARMS("DTYP",DTYP)) Q:DTYP=""  I $P(^DGPM(IEN,0),U,4)=DTYP D UPD(7,1)
 . S VISIT=$P(^DGPM(IEN,0),U,27) I VISIT="" Q
 . I $G(NURSE)="",'$D(MPARMS("NURSE")) D UPD(8,"")
 . S TIEN=""
 . F  S TIEN=$O(^TIU(8925,"V",VISIT,TIEN)) Q:TIEN=""  D
 .. I $$GET1^DIQ(8925,TIEN_",",.01,"E")'["NURSE" Q
 .. S NRSE=$$GET1^DIQ(8925,TIEN_",",1202,"I") I NRSE="" Q
 .. I $G(NURSE)'="" D UPD(8,0) I NURSE=NRSE D UPD(8,1) Q
 .. I $G(NURSE)="",$D(MPARMS("NURSE")) D UPD(8,0) I $D(MPARMS("NURSE",NRSE)) D UPD(8,1)
 Q
 ;
CNF ;EP - confirm
 S CT=0,MCT=0
 F I=1:1:$L(@DCRIT@("INP",DFN,IEN),U) D
 . I $P(@DCRIT@("INP",DFN,IEN),U,I)'="" S CT=CT+1
 . I $P(@DCRIT@("INP",DFN,IEN),U,I)'="",$P(@DCRIT@("INP",DFN,IEN),U,I)=1 S MCT=MCT+1
 I CT=0 K @DCRIT@("INP",DFN,IEN) Q
 I CT'=MCT K @DCRIT@("INP",DFN,IEN) Q
 I CT=MCT S @DATA@(DFN)=""
 Q
 ;
ADM ;EP - Admission
 I $G(ATYP)="",'$D(MPARMS("ATYP")) D UPD(2,"")
 I $G(ATYP)'="" D UPD(2,0) I $P(^DGPM(IEN,0),U,4)=ATYP D UPD(2,1)
 I $G(ATYP)="",$D(MPARMS("ATYP")) D
 . S ATYP="" D UPD(2,0)
 . F  S ATYP=$O(MPARMS("ATYP",ATYP)) Q:ATYP=""  I $P(^DGPM(IEN,0),U,4)=ATYP D UPD(2,1)
 I $G(WARD)="",'$D(MPARMS("WARD")) D UPD(3,"")
 I $G(WARD)'="" D UPD(3,0) I $P(^DGPM(IEN,0),U,6)=WARD D UPD(3,1)
 I $G(WARD)="",$D(MPARMS("WARD")) D
 . S WARD="" D UPD(3,0)
 . F  S WARD=$O(MPARMS("WARD",WARD)) Q:WARD=""  I $P(^DGPM(IEN,0),U,6)=WARD D UPD(3,1)
 S NXN=$O(^DGPM("CA",IEN,IEN)) I NXN="" Q
 I $G(APROV)="",'$D(MPARMS("APROV")) D UPD(4,"")
 I $G(APROV)'="" D UPD(4,0) I $P(^DGPM(NXN,0),U,19)=APROV D UPD(4,1)
 I $G(APROV)="",$D(MPARMS("APROV")) D
 . S APROV="" D UPD(4,0)
 . F  S APROV=$O(MPARMS("APROV",APROV)) Q:APROV=""  I $P(^DGPM(NXN,0),U,19)=APROV D UPD(4,1)
 I $G(FTSPEC)="",'$D(MPARMS("FTSPEC")) D UPD(5,"")
 I $G(FTSPEC)'="" D UPD(5,0) I $P(^DGPM(NXN,0),U,9)=FTSPEC D UPD(5,1)
 I $G(FTSPEC)'="",$D(MPARMS("FTSPEC")) D
 . S FTSPEC="" D UPD(5,0)
 . F  S FTSPEC=$O(MPARMS("FTSPEC",FTSPEC)) Q:FTSPEC=""  I $P(^DGPM(NXN,0),U,9)=FTSPEC D UPD(5,1)
 Q
