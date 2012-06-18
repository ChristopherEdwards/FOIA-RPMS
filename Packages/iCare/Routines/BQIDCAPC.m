BQIDCAPC ;PRXM/HC/ALA-Scheduled Visits by Clinic Stop ; 21 Nov 2005  6:04 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
APT(DATA,PARMS,MPARMS) ;EP
 ;
 ;Description
 ;  Executable to retrieve patients which have appointments in a hospital location that
 ;  is associated with a clinical stop code.
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Expected to return DATA
 ;Parameters
 ;  CLIN = Clinic Stop Code parameter
 ;  LOC  = Hosp Location internal entry number associated with CLIN
 ;  FDT  = Starting date for the FROM date parameter
 ;  EDT  = Ending date for the THRU date parameter
 ;  DFN  = Patient internal entry number
 ;  APSTAT = Appointment status
 ;
 NEW II,UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIDCAPC",UID))
 K @DATA
 S II=0
 ;
FND ;  Find the patients with appts for one or more clinic stop codes
 NEW CLIN,FROM,THRU,LOC,NM,N,FRDT,ENDT,LABEL,APST,STOP,FDT,EDT,DFN,LABEL
 NEW STR,SLOC,STAT,APSTAT,APTYPE
 S NM=""
 F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 I $G(APTYPE)'="" D
 . NEW MIEN,MAPS
 . S MIEN=$O(^BQI(90506,10,3,8,3,"B",APTYPE,"")) I MIEN="" Q
 . S MAPS=$P(^BQI(90506,10,3,8,3,MIEN,0),U,2)
 . F N=1:1:$L(MAPS,"~") S NM=$P($P(MAPS,"~",N),"=",1),MPARMS(NM,$P($P(MAPS,"~",N),"=",2))=""
 ;
 I $D(MPARMS("APTYPE"))>0 D
 . NEW MPM,MIEN,MAPS
 . S MPM=""
 . F  S MPM=$O(MPARMS("APTYPE",MPM)) Q:MPM=""  D
 .. S MIEN=$O(^BQI(90506,10,3,8,3,"B",MPM,"")) I MIEN="" Q
 .. S MAPS=$P(^BQI(90506,10,3,8,3,MIEN,0),U,2)
 .. F N=1:1:$L(MAPS,"~") S NM=$P($P(MAPS,"~",N),"=",1),MPARMS(NM,$P($P(MAPS,"~",N),"=",2))=""
 ;
 S LABEL="FND1" D
 . I $G(APSTAT)'="",APSTAT'="AC",APSTAT["C" S LABEL="FNDALL" Q
 . I $D(MPARMS("APSTAT")) D  Q
 .. S APST="",STOP=""
 .. F  S APST=$O(MPARMS("APSTAT",APST)) Q:APST=""  D  Q:STOP
 ... I APST'="AC",APST["C" S LABEL="FNDALL",STOP=1 Q
 I LABEL="FNDALL" D FNDALL Q
 I $G(CLIN)]"" D FND1
 I $D(MPARMS("CLIN")) S CLIN="" F  S CLIN=$O(MPARMS("CLIN",CLIN)) Q:CLIN=""  D FND1
 Q
 ;
FND1 ; Check one clinic stop code
 ; If timeframe is selected populate start and end dates
 I $G(RANGE)'="",$G(PPIEN)'="" D RANGE^BQIDCAH(RANGE,PPIEN)
 S LOC=""
 F  S LOC=$O(^SC("ASTOP",CLIN,LOC)) Q:LOC=""  D
 . S FDT=$S($G(RFROM)'="":RFROM,1:$G(FROM))
 . S EDT=$S($G(RTHRU)'="":RTHRU,1:$G(THRU))
 . NEW APCHK
 . F  S FDT=$O(^SC(LOC,"S",FDT)) Q:FDT=""!(FDT\1>EDT)  D
 .. S N=0
 .. F  S N=$O(^SC(LOC,"S",FDT,1,N)) Q:'N  D
 ... NEW DA,IENS
 ... S DA(2)=LOC,DA(1)=FDT,DA=N,IENS=$$IENS^DILF(.DA)
 ... S DFN=$$GET1^DIQ(44.003,IENS,.01,"I") I DFN="" Q
 ... ; User may now select Living, Deceased or both as a filter so
 ... ; if no filters defined assume living patients otherwise let filter decide
 ... ;I $O(^BQICARE(OWNR,1,PLIEN,15,0))="",$P($G(^DPT(DFN,.35)),U,1)'="" Q
 ... I '$$HRN^BQIUL1(DFN) Q
 ... ; If patient has no visit in last 3 years, quit
 ... ;I '$$VTHR^BQIUL1(DFN) Q
 ... I $G(APSTAT)'="" D  Q
 .... I $G(APSTAT)="AC" S APCHK=""
 .... I $G(APSTAT)'="AC" S APCHK=APSTAT
 .... I $P($G(^DPT(DFN,"S",FDT,0)),U,2)'=APCHK Q
 .... S @DATA@(DFN)=""
 ... I $D(MPARMS("APSTAT")) D  Q
 .... S APST=""
 .... F  S APST=$O(MPARMS("APSTAT",APST)) Q:APST=""  D
 ..... I $G(APST)="AC" S APCHK=""
 ..... I $G(APST)'="AC" S APCHK=APST
 ..... I $P($G(^DPT(DFN,"S",FDT,0)),U,2)'=APCHK Q
 ..... S @DATA@(DFN)=""
 ... ;S @DATA@(DFN)=""
 Q
 ;
FNDALL ; Loop through all patients since cancelled status selected
 ; If timeframe is selected populate start and end dates
 I $G(RANGE)'="",$G(PPIEN)'="" D RANGE^BQIDCAH(RANGE,PPIEN)
 S FRDT=$S($G(RFROM)'="":RFROM,1:$G(FROM))
 S ENDT=$S($G(RTHRU)'="":RTHRU,1:$G(THRU))
 I $G(CLIN)]"" D
 .S LOC=""
 .F  S LOC=$O(^SC("ASTOP",CLIN,LOC)) Q:LOC=""  S LOC(LOC)=""
 I $D(MPARMS("CLIN")) D
 . S CLIN=""
 . F  S CLIN=$O(MPARMS("CLIN",CLIN)) Q:CLIN=""  D
 .. S LOC=""
 .. F  S LOC=$O(^SC("ASTOP",CLIN,LOC)) Q:LOC=""  S LOC(LOC)=""
 NEW APCHK
 S DFN=0
 F  S DFN=$O(^DPT(DFN)) Q:'DFN  D
 . ; *disabled* since user may now select Living, Deceased or both as a filter
 . ;I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 . I '$$HRN^BQIUL1(DFN) Q
 . ; If patient has no visit in last 3 years, quit
 . ;I '$$VTHR^BQIUL1(DFN) Q
 . S FDT=FRDT,EDT=ENDT
 . F  S FDT=$O(^DPT(DFN,"S",FDT)) Q:'FDT!(FDT\1>EDT)  D
 .. S STR=$G(^DPT(DFN,"S",FDT,0)) I STR="" Q
 .. S SLOC=$P(STR,U),STAT=$P(STR,U,2) I SLOC="" Q
 .. I '$D(LOC(SLOC)) Q
 .. I $D(APSTAT) D  Q
 ... I APSTAT="AC",STAT'="" Q
 ... I STAT'=APSTAT Q
 ... S @DATA@(DFN)=""
 .. I $D(MPARMS("APSTAT")) D  Q
 ... I STAT'="",'$D(MPARMS("APSTAT",STAT)) Q
 ... I STAT="",'$D(MPARMS("APSTAT","AC")) Q
 ... S @DATA@(DFN)=""
 .. S @DATA@(DFN)=""
 Q
