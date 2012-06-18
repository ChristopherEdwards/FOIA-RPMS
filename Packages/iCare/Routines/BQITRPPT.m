BQITRPPT ;PRXM/HC/ALA-Treatment Prompt ; 24 Apr 2007  11:47 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
FND(BQTRMT,BQGLOB,BQDFN,BQRM) ;EP
 ;
 ;  Input Parameters
 ;    BQTRMT - Treatment Prompt
 ;    BQGLOB - Reference to store data
 ;    BQDFN  - Patient IEN
 ;    BQRM   - Remarks array
 ;  Output Parameter
 ;    MEET - If zero, didn't meet the criteria
 ;           If one, did meet the criteria
 ;
 NEW BQREF,CEXE,MEET,N,TAX,NIT,TMFRAME,FREF,ABS,CONT,GREF,TREF,IEN,TIEN,EXEC
 NEW CEXEC,BQIAND,BQIOR
 ;S BQREF="BQIRY" K @BQREF
 ;D BLD(BQTRMT,BQREF,.CEXEC)
 ;
 ; Find if there is a special executable for the treatment prompt
 S EXEC=$G(^BQI(90508.5,BQTRMT,2))
 I $G(EXEC)'="" X EXEC
 ; EXEC should always return RESULT
 ;
 ; update remarks if patient passed all the checks
 I $P(RESULT,U,1)=1 D
 . K PARMS
 . ; Set the parameter values returned from API
 . F BN=3:1:$L(RESULT,U) S PARMS(BN-2)=$P(RESULT,U,BN)
 . S BN=0
 . F  S BN=$O(BQRM(BN)) Q:BN=""  D
 .. I BQRM(BN)'["|" Q
 .. ; Apply parameters into remarks
 .. S NDESC=BQRM(BN)
 .. F  Q:'$F(NDESC,"|")  D PRS
 .. S BQRM(BN)=PDESC
 Q RESULT
 ;
 S MEET=1
 ;
 ;  If taxonomy checks are used to determine whether patient meets criteria or not
 I $D(@BQREF) D
 . S N=0 F  S N=$O(@BQREF@(N)) Q:'N  D
 .. S TAX=$P(@BQREF@(N),U,1),NIT=$P(@BQREF@(N),U,2)
 .. S TMFRAME=$P(@BQREF@(N),U,3),FREF=$P(@BQREF@(N),U,4)
 .. I TMFRAME'="" S EDATE=$$DATE^BQIUL1(TMFRAME),BDATE=DT
 .. I TMFRAME="" S EDATE=$$DATE^BQIUL1("T-12M"),BDATE=DT
 .. S ABS=$P(@BQREF@(N),U,5),CONT=+$P(@BQREF@(N),U,6)
 .. ;
 .. ;  Check for a contraindication executable
 .. S CEXE=$G(CEXEC(N))
 .. I $G(CEXE)'="" D  Q
 ... S DFN=BQDFN
 ... ;I $G(DFN)="" S DFN=BQDFN
 ... X CEXE
 ... ;
 ... ; If absence/presence is defined
 ... I ABS'="" D
 .... I 'X,'ABS S MEET=1 Q
 .... I 'X,ABS S MEET=0 Q
 .... I X,'ABS S MEET=0 Q
 .... I X,ABS S MEET=1
 ... ; If absence/presence is not defined
 ... I ABS="" D
 .... I X S MEET=1 Q
 .... I 'X S MEET=0
 ... ;I MEET,X,CONT S MEET=0
 ... ;I MEET,X,'CONT S MEET=1
 ... ;I MEET,'X,'CONT S MEET=0
 ... ; If met criteria but also met contraindication
 ... I MEET,CONT S MEET=0
 ... I MEET,'CONT S MEET=1
 ... I 'MEET,CONT S MEET=1
 ... I 'MEET,'CONT S MEET=0
 ... ;
 ... Q:'MEET
 ... ; update remarks if patient passed all the checks
 ... K PARMS
 ... F BN=2:1:$L(X,U) S PARMS(BN-1)=$P(X,U,BN)
 ... S BN=0
 ... F  S BN=$O(BQRM(BN)) Q:BN=""  D
 .... I BQRM(BN)'["|" Q
 .... S NDESC=BQRM(BN)
 .... F  Q:'$F(NDESC,"|")  D PRS
 .... ;I PDESC["~"
 .... S BQRM(BN)=PDESC
 .. ;
 .. S GREF=$$ROOT^DILFD(FREF,"",1),TREF=$NA(^TMP("BQITAX",UID))
 .. ;  Build the taxonomy reference
 .. K @TREF
 .. Q:TAX=""
 .. D BLD^BQITUTL(TAX,TREF)
 .. S IEN="",QFL=0
 .. F  S IEN=$O(@GREF@("AC",BQDFN,IEN),-1) Q:IEN=""  D  Q:QFL
 ... S TIEN=$$GET1^DIQ(FREF,IEN_",",.01,"I") I TIEN="" Q
 ... I '$D(@TREF@(TIEN)) Q
 ... S VISIT=$$GET1^DIQ(FREF,IEN_",",.03,"I") I VISIT="" Q
 ... I $$GET1^DIQ(9000010,VISIT_",",.11,"I")=1 Q
 ... S VSDTM=$$GET1^DIQ(9000010,VISIT_",",.01,"I")\1 I VSDTM=0 Q
 ... I $G(TMFRAME)'="",VSDTM<EDATE Q
 ... ; If absence of data, then it did not meet the criteria
 ... I ABS=0 S MEET=0,QFL=1 Q
 ... S MEET=1_U_VSDTM_U_U_VISIT_U_IEN,QFL=1
 .. I $G(BQIAND)'="" D
 ... I BQIAND,MEET Q
 ... I 'BQIAND,MEET S MEET=0
 ;
 I $G(EXEC)'="" X EXEC
 ;
XIT Q MEET
 ;
BLD(TRMT,REF,CEXEC) ;EP
 K CEXEC
 NEW BN,IEN,DATA
 S BN=0
 F  S BN=$O(^BQI(90508.5,TRMT,5,"B",BN)) Q:'BN  D
 . S IEN=0
 . F  S IEN=$O(^BQI(90508.5,TRMT,5,"B",BN,IEN)) Q:'IEN  D
 .. S DATA=^BQI(90508.5,TRMT,5,IEN,0)
 .. ; Exclude the SEARCH ORDER field and only take pieces 2-7
 .. S @REF@(BN)=$P(DATA,U,2,7)
 .. S CEXEC(BN)=$G(^BQI(90508.5,TRMT,5,IEN,1))
 Q
 ;
PRS ;  Parse description
 S NDESC=$P(NDESC,"|",1)_$G(PARMS($P(NDESC,"|",2)))_$P(NDESC,"|",3,99)
 S PDESC=NDESC
 Q
