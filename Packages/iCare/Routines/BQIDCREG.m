BQIDCREG ;PRXM/HC/ALA-RPMS Register Patients ; 04 Nov 2005  11:04 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
MYP(DATA,PARMS,MPARMS) ;EP
 ;
 ;Description
 ;  Executable to retrieve those patients who are on a specified register
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Expected to return DATA
 ;
 NEW UID,NM,REGIEN,RDATA,FILE,FIELD,XREF,GLBREF,DFN,GLBNOD,RIEN,QFL,SUBREG
 NEW II,X
 NEW STAT,PSTAT,STFILE,STFLD,STEX,IENS
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J),II=0
 S DATA=$NA(^TMP("BQIDCREG",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIDCREG D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S NM=""
 F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 ;
FND ;  Determine where to find the patient cross-reference for the
 ;  specified registry PARMS("REG")
 ;Parameters
 ;  REGIEN = Registry internal entry number
 ;  FILE   = File number where registry resides
 ;  FIELD  = Field number where patient is defined in the registry
 ;  XREF   = The cross-reference of the patient in the registry file
 ;  GLBREF = The global reference of the patient cross-reference
 ;  GLBNOD = Closed root of the global
 ;
 S REGIEN=$G(PARMS("REG")) I REGIEN="" Q
 S RDATA=^BQI(90507,REGIEN,0)
 S FILE=$P(RDATA,"^",7),FIELD=$P(RDATA,"^",5),XREF=$P(RDATA,"^",6)
 S STFILE=$P(RDATA,"^",15),STFLD=$P(RDATA,"^",14),STEX=$G(^BQI(90507,REGIEN,1))
 I $G(SUBREG)="" S SUBREG=$P(RDATA,U,9)
 S GLBREF=$$ROOT^DILFD(FILE,"")_XREF_")"
 S GLBNOD=$$ROOT^DILFD(FILE,"",1)
 I GLBNOD="" Q
 ;
 I '$D(@GLBNOD@(0)) Q
 ;
 S DFN=""
 F  S DFN=$O(@GLBREF@(DFN)) Q:DFN=""  D
 . ; If patient is deceased, quit
 . ; User may now select Living, Deceased or both as a filter so
 . ; if no filters defined assume living patients otherwise let filter decide
 . ;I $O(^BQICARE(OWNR,1,PLIEN,15,0))="",$P($G(^DPT(DFN,.35)),U,1)'="" Q
 . ; If patient has no active HRNs, quit
 . I '$$HRN^BQIUL1(DFN) Q
 . ; If patient has no visit in last 3 years, quit
 . ;I '$$VTHR^BQIUL1(DFN) Q
 . ;
 . I $G(SUBREG)'="" S QFL=0 D  Q:'QFL
 .. Q:FILE'=9002241
 .. S RIEN=""
 .. F  S RIEN=$O(@GLBREF@(DFN,RIEN)) Q:RIEN=""  D
 ... I $P($G(@GLBNOD@(RIEN,0)),U,5)=SUBREG S QFL=1,IENS=RIEN
 . ; Check register status
 . I $D(PARMS("STAT"))!$D(MPARMS("STAT")) S QFL=0 D  Q:'QFL
 .. ;S IENS=$O(@GLBREF@(DFN,""))
 .. I $G(SUBREG)="" S IENS=$O(@GLBREF@(DFN,""))
 .. I STEX'="" X STEX Q:'$D(IENS)
 .. S PSTAT=$$GET1^DIQ(STFILE,IENS,STFLD,"I")
 .. I $D(PARMS("STAT")),PSTAT=PARMS("STAT") S QFL=1 Q
 .. S STAT=""
 .. F  S STAT=$O(MPARMS("STAT",STAT)) Q:STAT=""  I PSTAT=STAT S QFL=1 Q
 . S @DATA@(DFN)=""
 Q
 ;
HMS ; Set IENS for HMS Registry
 N DA
 S DA(1)=$O(^BKM(90451,"B",DFN,"")) Q:'DA(1)
 S DA=$O(^BKM(90451,DA(1),1,0)) Q:'DA
 S IENS=$$IENS^DILF(.DA)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
