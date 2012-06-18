BQIFLGET ;PRXM/HC/ALA-Get flags ; 14 Dec 2005  11:22 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
RET(DATA,DTYP,OWNR,PLIEN,DFN) ; EP -- BQI GET FLAGS
 ;
 ;Description
 ;
 ;Input
 ;  DTYP  = Display Type; 'A'=All flags, 'S'=Shown flags,
 ;                       'H'=Hidden flags
 ;  OWNR  = User identifier if DUZ is a shared person
 ;  PLIEN = Panel IEN
 ;  DFN   = Patient identifier
 ;
 NEW UID,II,DOB,SENS,PTSEX,PTAGE,HRN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIFLGET",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIFLGET D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010FLAG_DEF_IEN^I00010FLAG_IEN^I00010DFN^T00030PATIENT_NAME^T00030HRN^T00050DPCP^T00030FLAG_TYPE^D00015FLAG_DATE^T00010FLAG_ACTION^T00001FLAG_STATUS^T00250FLAG_DESC^D00030DOB^T00001SENS_FLAG^T00001SEX^T00007AGE"_$C(30)
 S DFN=$G(DFN,"")
 S OWNR=$G(OWNR,"")
 ;
 I $G(DFN)'="" D PAT G DONE
 I $G(OWNR)'="" D PNL G DONE
 D ALL
 ;
DONE ; Finish the RPC call
 S II=II+1,@DATA@(II)=$C(31)
 K PARMS,MPARMS,ADTM,ADATM,ADESC,ADIEN,ALIEN,X,Y,TMFRAME,NM
 K STAT,DA,IENS,AACT,FDT,TDT,SOURCE,VALUE,NAME,PIEN,PMIEN,PTYP
 K HRN,AIEN,FSTAT,FDTM,RIEN,%DT,PNAME,VIEN,PARMS,MPARMS,ORPHY
 K RANGE,RSLT,TEST,AFLG,BQIPREF,PLIEN
 Q
 ;
ALL ;  For all patients defined in the patient lists for the user.
 ;
 ;Parameters
 ;  DFN   = Patient internal entry number
 ;  ADIEN = Flag definition internal entry number
 ;  ADESC = Flag definition description
 ;  TMFRAME = Relative date defined by user
 ;  ALIEN   = Flag record internal entry number
 ;  ADTM,FDT  = Time Frame starting date
 ;  ADATM   = Flag date
 ;  STAT  = Status of the flag for this user
 ;  AACT  = Flag Action (S=Show, H=Hide)
 ;  DOB   = Patient's Date of Birth
 ;  SENS  = Sensitive Patient Flag
 ;  PTSEX = Patient's gender
 ;  PTAGE = Patient's current age
 ;
 D RET^BQIFLAG(DUZ,.BQIPREF)
 S ADIEN=0
 F  S ADIEN=$O(BQIPREF(ADIEN)) Q:'ADIEN  D
 . ; If the flag entry is inactive, quit
 . I $P(^BQI(90506,ADIEN,0),U,2)=1 Q
 . S ADESC=$P(^BQI(90506,ADIEN,0),U,1)
 . S FDT=$P(BQIPREF(ADIEN),U,1),TDT=$P(BQIPREF(ADIEN),U,2)
 . S FDTM=FDT
 . F  S FDTM=$O(^BQIPAT("AE",ADIEN,FDTM)) Q:FDTM=""!(FDTM\1>TDT)  D
 .. S DFN=""
 .. F  S DFN=$O(^BQIPAT("AE",ADIEN,FDTM,DFN)) Q:DFN=""  D
 ... I $D(^BQICARE(DUZ,1,"AB",DFN)) D  Q:'AFLG
 .... ;
 .... ; Check if patient is active on any panel (AFLG=1)
 .... ;
 .... S PLIEN="",AFLG=0
 .... F  S PLIEN=$O(^BQICARE(DUZ,1,"AB",DFN,PLIEN)) Q:PLIEN=""  D  Q:AFLG
 ..... I $G(^BQICARE(DUZ,1,PLIEN,40,DFN,0))="" K ^BQICARE(DUZ,1,"AB",DFN,PLIEN) Q
 ..... I $P(^BQICARE(DUZ,1,PLIEN,40,DFN,0),U,2)'="R" S AFLG=1
 ... ;
 ... ;  If patient isn't on one of user's panels but is on a shared panel
 ... I '$D(^BQICARE(DUZ,1,"AB",DFN)),'$$SHR(DUZ,DFN) Q
 ... S ALIEN=0
 ... F  S ALIEN=$O(^BQIPAT("AE",ADIEN,FDTM,DFN,ALIEN)) Q:ALIEN=""  D
 .... S PNAME=$$GET1^DIQ(9000001,DFN_",",.01,"E")
 .... NEW FDESC
 .... Q:'$D(^BQIPAT(DFN,10,ADIEN,5,ALIEN,1,DUZ))
 .... S STAT=+$P(^BQIPAT(DFN,10,ADIEN,5,ALIEN,1,DUZ,0),U,2)
 .... ;  if the status is '1' Don't Show and the display type is 'S' don't select
 .... I STAT=1,DTYP="S" Q
 .... I 'STAT,DTYP="H" Q
 .... ;  If the status is 1, set action to "reactivate" and flag status to "hide"
 .... ;  If the status is not 1, set action to "deactivate" and flag status to "show"
 .... S AACT=$S(STAT=1:"S",1:"H"),FSTAT=$S(STAT=1:"H",1:"S")
 .... ;  Get the record ien associated with the flag
 .... S RIEN=$P(^BQIPAT(DFN,10,ADIEN,5,ALIEN,0),U,1)
 .... S ADATM=$P(^BQIPAT(DFN,10,ADIEN,5,ALIEN,0),U,2)
 .... S VIEN=$P(^BQIPAT(DFN,10,ADIEN,5,ALIEN,0),U,4)
 .... S ADATM=$$FMTE^BQIUL1(ADATM\1)
 .... I ADESC["LAB" D
 ..... I $E(ADESC,1,3)="LAB" D  Q
 ...... D LAB^BQIRLB(RIEN)
 ...... S FDESC=TEST_" "_RSLT_" "_RANGE_" "_ORPHY
 ..... I $E(ADESC,1,3)="ABN" D  Q
 ...... S FDESC=$P($P($G(^XTV(8992.1,RIEN,1)),U,1),":",2,99)
 .... I ADESC'["LAB" D
 ..... I VIEN="" Q
 ..... NEW NARR
 ..... S FDESC="Provider: "_$$PRV^BQIUL1(VIEN)
 ..... S NARR=$$VVNAR^BQIUL1(VIEN)
 ..... I NARR="" S NARR=$$VPNAR^BQIUL1(VIEN)
 ..... S FDESC=FDESC_$C(13)_$C(10)_"POVs: "_NARR
 .... S DOB=$$FMTE^BQIUL1($$GET1^DIQ(2,DFN_",",.03,"I"))
 .... S PTSEX=$$GET1^DIQ(2,DFN_",",.02,"I")
 .... S PTAGE=$$AGE^BQIAGE(DFN,,1)
 .... S SENS=$$SENS^BQIULPT(DFN)
 .... S HRN=$$HRNL^BQIULPT(DFN),HRN=$TR(HRN,";",$C(10))
 .... S II=II+1
 .... S @DATA@(II)=ADIEN_"^"_ALIEN_"^"_DFN_"^"_PNAME_"^"_HRN_"^"_$P($$DPCP^BQIULPT(DFN),"^",2)_"^"_ADESC_"^"_ADATM_"^"_AACT_"^"_FSTAT_"^"_$G(FDESC)_"^"_DOB_"^"_SENS_"^"_PTSEX_"^"_PTAGE_$C(30)
 Q
 ;
PAT ;  Get flags for one patient
 ;
 ;Parameters
 ;  PNAME = Patient's name
 ;
 S PNAME=$$GET1^DIQ(9000001,DFN_",",.01,"E")
 D RET^BQIFLAG(DUZ,.BQIPREF)
 I '$$FPAT^BQIFLAG(DFN,DUZ,.BQIPREF,DTYP) Q
 S ADIEN=0
 F  S ADIEN=$O(BQIPREF(ADIEN)) Q:'ADIEN  D
 . ; If the flag entry is inactive, quit
 . I $P(^BQI(90506,ADIEN,0),"^",2)=1 Q
 . S ADESC=$P(^BQI(90506,ADIEN,0),U,1)
 . S FDT=$P(BQIPREF(ADIEN),U,1),TDT=$P(BQIPREF(ADIEN),U,2)
 . S FDTM=FDT
 . F  S FDTM=$O(^BQIPAT("AF",DFN,ADIEN,FDTM)) Q:FDTM=""!(FDTM\1>TDT)  D
 .. S ALIEN=0
 .. F  S ALIEN=$O(^BQIPAT("AF",DFN,ADIEN,FDTM,ALIEN)) Q:'ALIEN  D
 ... NEW FDESC
 ... Q:'$D(^BQIPAT(DFN,10,ADIEN,5,ALIEN,1,DUZ))
 ... S STAT=+$P(^BQIPAT(DFN,10,ADIEN,5,ALIEN,1,DUZ,0),U,2)
 ... ;  if the status is '1' Don't Show and the display type is 'S' don't select
 ... I STAT=1,DTYP="S" Q
 ... I 'STAT,DTYP="H" Q
 ... ;  If the status is 1, set action to "reactivate" and flag status to "hide"
 ... ;  If the status is not 1, set action to "deactivate" and flag status to "show"
 ... S AACT=$S(STAT=1:"S",1:"H"),FSTAT=$S(STAT=1:"H",1:"S")
 ... ;  Get the record ien associated with the flag
 ... S RIEN=$P(^BQIPAT(DFN,10,ADIEN,5,ALIEN,0),U,1)
 ... S ADATM=$P(^BQIPAT(DFN,10,ADIEN,5,ALIEN,0),U,2)
 ... S VIEN=$P(^BQIPAT(DFN,10,ADIEN,5,ALIEN,0),U,4)
 ... S ADATM=$$FMTE^BQIUL1(ADATM\1)
 ... I ADESC["LAB" D
 .... I $E(ADESC,1,3)="LAB" D  Q
 ..... D LAB^BQIRLB(RIEN)
 ..... S FDESC=TEST_" "_RSLT_" "_RANGE_" "_ORPHY
 .... I $E(ADESC,1,3)="ABN" D  Q
 ..... S FDESC=$P($P($G(^XTV(8992.1,RIEN,1)),U,1),":",2,99)
 ... I ADESC'["LAB" D
 .... I VIEN="" Q
 .... NEW NARR
 .... S FDESC="Provider: "_$$PRV^BQIUL1(VIEN)
 .... S NARR=$$VVNAR^BQIUL1(VIEN)
 .... I NARR="" S NARR=$$VPNAR^BQIUL1(VIEN)
 .... S FDESC=FDESC_$C(13)_$C(10)_"POVs: "_NARR
 ... S DOB=$$FMTE^BQIUL1($$GET1^DIQ(2,DFN_",",.03,"I"))
 ... S PTSEX=$$GET1^DIQ(2,DFN_",",.02,"I")
 ... S PTAGE=$$AGE^BQIAGE(DFN,,1)
 ... S SENS=$$SENS^BQIULPT(DFN)
 ... S HRN=$$HRNL^BQIULPT(DFN),HRN=$TR(HRN,";",$C(10))
 ... S II=II+1
 ... S @DATA@(II)=ADIEN_"^"_ALIEN_"^"_DFN_"^"_PNAME_"^"_HRN_"^"_$P($$DPCP^BQIULPT(DFN),"^",2)_"^"_ADESC_"^"_ADATM_"^"_AACT_"^"_FSTAT_"^"_$G(FDESC)_"^"_DOB_"^"_SENS_"^"_PTSEX_"^"_PTAGE_$C(30)
 Q
 ;
PNL ;  Get all flags for patients in a panel
 S DFN=0
 F  S DFN=$O(^BQICARE(OWNR,1,PLIEN,40,DFN)) Q:'DFN  D
 . I $P(^BQICARE(OWNR,1,PLIEN,40,DFN,0),U,2)="R" Q
 . Q:$O(^BQIPAT(DFN,10,0))=""
 . S PNAME=$$GET1^DIQ(9000001,DFN_",",.01,"E")
 . D RET^BQIFLAG(OWNR,.BQIPREF)
 . Q:'$$FPAT^BQIFLAG(DFN,OWNR,.BQIPREF,DTYP)
 . S ADIEN=0
 . F  S ADIEN=$O(BQIPREF(ADIEN)) Q:'ADIEN  D
 .. ; If the flag entry is inactive, quit
 .. I $P(^BQI(90506,ADIEN,0),"^",2)=1 Q
 .. S ADESC=$P(^BQI(90506,ADIEN,0),U,1)
 .. S FDT=$P(BQIPREF(ADIEN),U,1),TDT=$P(BQIPREF(ADIEN),U,2)
 .. S FDTM=FDT
 .. F  S FDTM=$O(^BQIPAT("AF",DFN,ADIEN,FDTM)) Q:FDTM=""!(FDTM\1>TDT)  D
 ... S ALIEN=0
 ... F  S ALIEN=$O(^BQIPAT("AF",DFN,ADIEN,FDTM,ALIEN)) Q:'ALIEN  D
 .... Q:'$D(^BQIPAT(DFN,10,ADIEN,5,ALIEN,1,DUZ))
 .... S STAT=+$P(^BQIPAT(DFN,10,ADIEN,5,ALIEN,1,DUZ,0),U,2)
 .... ;  if the status is '1' Don't Show and the display type is 'S' don't select
 .... I STAT=1,DTYP="S" Q
 .... I 'STAT,DTYP="H" Q
 .... ;  If the status is 1, set action to "reactivate" and flag status to "hide"
 .... ;  If the status is not 1, set action to "deactivate" and flag status to "show"
 .... S AACT=$S(STAT=1:"S",1:"H"),FSTAT=$S(STAT=1:"H",1:"S")
 .... ;  Get the record ien associated with the flag
 .... S RIEN=$P(^BQIPAT(DFN,10,ADIEN,5,ALIEN,0),U,1)
 .... S ADATM=$P(^BQIPAT(DFN,10,ADIEN,5,ALIEN,0),U,2)
 .... S VIEN=$P(^BQIPAT(DFN,10,ADIEN,5,ALIEN,0),U,4)
 .... S ADATM=$$FMTE^BQIUL1(ADATM\1)
 .... I ADESC["LAB" D
 ..... I $E(ADESC,1,3)="LAB" D  Q
 ...... D LAB^BQIRLB(RIEN)
 ...... S FDESC=TEST_" "_RSLT_" "_RANGE_" "_ORPHY
 ..... I $E(ADESC,1,3)="ABN" D  Q
 ...... S FDESC=$P($P($G(^XTV(8992.1,RIEN,1)),U,1),":",2,99)
 .... I ADESC'["LAB" D
 ..... I VIEN="" Q
 ..... NEW NARR
 ..... S FDESC="Provider: "_$$PRV^BQIUL1(VIEN)
 ..... S NARR=$$VVNAR^BQIUL1(VIEN)
 ..... I NARR="" S NARR=$$VPNAR^BQIUL1(VIEN)
 ..... S FDESC=FDESC_$C(13)_$C(10)_"POVs: "_NARR
 .... S DOB=$$FMTE^BQIUL1($$GET1^DIQ(2,DFN_",",.03,"I"))
 .... S PTSEX=$$GET1^DIQ(2,DFN_",",.02,"I")
 .... S PTAGE=$$AGE^BQIAGE(DFN,,1)
 .... S SENS=$$SENS^BQIULPT(DFN)
 .... S HRN=$$HRNL^BQIULPT(DFN),HRN=$TR(HRN,";",$C(10))
 .... S II=II+1
 .... S @DATA@(II)=ADIEN_"^"_ALIEN_"^"_DFN_"^"_PNAME_"^"_HRN_"^"_$P($$DPCP^BQIULPT(DFN),"^",2)_"^"_ADESC_"^"_ADATM_"^"_AACT_"^"_FSTAT_"^"_$G(FDESC)_"^"_DOB_"^"_SENS_"^"_PTSEX_"^"_PTAGE_$C(30)
 Q
 ;
SHR(SHRU,SDFN) ;EP - Is patient in a shared panel?
 N USR,SFLG,SPLIEN,SHAXCS,SHSTDT,SHENDT
 S USR="",SFLG=0
 F  S USR=$O(^BQICARE("C",SHRU,USR)) Q:USR=""  D  Q:SFLG
 . S SPLIEN=""
 . F  S SPLIEN=$O(^BQICARE("C",SHRU,USR,SPLIEN)) Q:SPLIEN=""  D  Q:SFLG
 .. I '$D(^BQICARE(USR,1,SPLIEN,40,"B",SDFN)) Q
 .. I $P(^BQICARE(USR,1,SPLIEN,40,SDFN,0),U,2)="R" Q
 .. S SHAXCS=$P(^BQICARE(USR,1,SPLIEN,30,SHRU,0),U,2)
 .. S SHSTDT=$P(^BQICARE(USR,1,SPLIEN,30,SHRU,0),U,3)
 .. S SHENDT=$P(^BQICARE(USR,1,SPLIEN,30,SHRU,0),U,4)
 .. I SHSTDT'>DT,((SHENDT'<DT)!(SHENDT="")),SHAXCS'="I" S SFLG=1
 Q SFLG
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
