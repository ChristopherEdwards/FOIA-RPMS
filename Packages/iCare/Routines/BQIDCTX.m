BQIDCTX ;VNGT/HS/ALA-Taxonomy Search ; 01 Feb 2007  6:29 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
TAX(DATA,PARMS,MPARMS) ;EP
 ;
 ;Description
 ;  Executable to retrieve those patients which have data in RPMS for
 ;  specified taxonomies
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Expected to return DATA
 ;
 NEW UID,II,X,TGLOB,NM,FROM,THRU,VISITS,TAX,DFN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J),II=0
 S DATA=$NA(^TMP("BQIDCTX",UID)),TGLOB=$NA(^TMP("BQIDCTG",UID))
 K @DATA,@TGLOB
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIDCTX D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I '$D(PARMS),'$D(MPARMS) Q
 ;
 S NM=""
 F  S NM=$O(PARMS(NM)) Q:NM=""  D
 . S @NM=$P(PARMS(NM),U,1)
 . F I=2:1:$L(PARMS(NM),U) Q:$P(PARMS(NM),U,I)=""  S @($P(PARMS(NM),U,I))
 ;
 ; If a single taxonomy
 I $G(TAX)'="" D TAX1 M @DATA=@TGLOB G DONE
 ;
 ; If multiple taxonomies
 I $D(MPARMS("TAX")) S TAX="" F  S TAX=$O(MPARMS("TAX",TAX)) Q:TAX=""  D
 . F I=1:1:$L(MPARMS("TAX",TAX),U) Q:$P(MPARMS("TAX",TAX),U,I)=""  S @($P(MPARMS("TAX",TAX),U,I))
 . D TAX1
 . S DFN=""
 . F  S DFN=$O(@TGLOB@(DFN)) Q:DFN=""  I @TGLOB@(DFN)<VISITS K @TGLOB@(DFN)
 . M @DATA=@TGLOB
 ;
DONE ;
 K @TREF,@TGLOB,FROM,THRU,VISITS
 Q
 ;
TAX1 ;
 ; Parameters
 ;   QN   = QMan link IEN
 ;   FREF = Target FileMan File Reference
 ;   FLD  = Target Field Number
 ;   GREF = Global reference
 ;   TREF = Taxonomy reference
 NEW GREF,TREF,QN,TAXNM,FREF,FLD,TN,XRF,IEN,VISIT,VSDTM
 S TAXNM=$P($G(^ATXAX(TAX,0)),U,1)
 S QN=$P($G(^ATXAX(TAX,0)),U,12) I QN="" Q
 S FREF=$P($G(^AMQQ(1,QN,0)),U,3) I FREF="" Q
 S FLD=$P($G(^AMQQ(1,QN,0)),U,4)
 S GREF=$$ROOT^DILFD(FREF,"",1)
 S TREF=$NA(^TMP("BQITAX",UID))
 K @TREF
 ; Build the values to look for from the taxonomy in temporary global
 D BLD^BQITUTL(TAXNM,TREF)
 ;
 S TN="" F  S TN=$O(@TREF@(TN)) Q:TN=""  D FND
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
FND ;
 I FLD=".01" S XRF="B" ; Could be "AF" in the future
 S IEN=""
 F  S IEN=$O(@GREF@(XRF,TN,IEN),-1) Q:IEN=""  D
 . S DFN=$P($G(@GREF@(IEN,0)),U,2) I DFN="" Q
 . ; User may now select Living, Deceased or both as a filter so
 . ; if no filters defined assume living patients otherwise let filter decide
 . ;I $O(^BQICARE(OWNR,1,PLIEN,15,0))="",$P($G(^DPT(DFN,.35)),U,1)'="" Q
 . ; If patient has no active HRNs, quit
 . I '$$HRN^BQIUL1(DFN) Q
 . ; If patient has no visit in last 3 years, quit
 . ;I '$$VTHR^BQIUL1(DFN) Q
 . ;
 . S VISIT=$P($G(@GREF@(IEN,0)),U,3) I VISIT="" Q
 . ; If visit has been deleted, quit
 . I $P(^AUPNVSIT(VISIT,0),U,11)=1 Q
 . S VSDTM=$P($G(^AUPNVSIT(VISIT,0)),U,1)\1 I VSDTM=0 Q
 . I $G(FROM)'="",$G(THRU)'="" S QFL=0 D  Q:QFL
 .. I VSDTM<FROM!(VSDTM>THRU) S QFL=1
 . I $G(VISITS)="" S @TGLOB@(DFN)="" Q
 . I $G(VISITS)'="" Q:$G(@TGLOB@(DFN))'<VISITS  S @TGLOB@(DFN)=$G(@TGLOB@(DFN))+1
 Q
