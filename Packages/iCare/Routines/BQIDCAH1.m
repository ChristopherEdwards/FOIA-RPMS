BQIDCAH1 ;PRXM/HC/ALA-Ad Hoc Search continued ; 01 Aug 2007  11:27 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 Q
 ;
ACHK(IEN) ;EP - Age check
 NEW AGE,PAGE,TYP1,TYP2,OP1,OP2,AVAL1,AVAL2,PTYP,PVAL
 ;S AGE=$$GET1^DIQ(9000001,IEN_",",1102.99,"E")
 S AGE=$$AGE^BQIAGE(IEN)
 I AGE="" Q
 ;S PAGE=$$GET1^DIQ(9000001,IEN_",",1102.98,"E")
 S PAGE=$$AGE^BQIAGE(IEN,,1)
 ;
 S TYP1=$E(CRIT1,$L(CRIT1)-2,$L(CRIT1)),OP1=$E(CRIT1,1,1)
 I TYP1'="YRS",TYP1'="MOS",TYP1'="DYS" S TYP1="YRS"
 S AVAL1=$E(CRIT1,2,$L(CRIT1)-3)
 I $E(OP1,1,1)="'" S OP1=$E(CRIT1,1,2),AVAL1=$E(CRIT1,3,$L(CRIT1)-3)
 ;
 ; If not inclusive or exclusive, then only one criteria
 I $G(CRIT2)="" D
 . ;  If the search is in years, can just use the AGE value
 . I TYP1="YRS" D  Q
 .. S AVAL1=$$STRIP^XLFSTR(CRIT1,TYP1)
 .. I @(AGE_AVAL1) S @TGLOB@(IEN)="" Q
 . ; If the search is not in years, must check the PRINTED AGE value
 . ; for those ages in months and days
 . S PVAL=$P(PAGE," ",1),PTYP=$P(PAGE," ",2)
 . ;S AVAL1=$E(CRIT1,2,$L(CRIT1)-3)
 . ; Check the operand for a 'not' and set operand and criteria value appropriately
 . I $E(OP1,1,1)="'" S AVAL1=$E(CRIT1,3,$L(CRIT1)-3)
 . ; If the criteria qualifier type is not equal to the printed age qualifier type
 . I TYP1'=PTYP D  Q
 .. ; if the operand is less than or less than/equal, depending on the
 .. ; criteria qualifier, certain print age qualifiers should be included or
 .. ; excluded from the check
 .. I OP1="<"!(OP1="'>") D
 ... I TYP1="MOS",PTYP="YRS" Q
 ... I TYP1="DYS",PTYP="YRS"!(PTYP="MOS") Q
 ... S @TGLOB@(IEN)=""
 .. ; if the operand is greater than or greater than/equal, depending on the
 .. ; criteria qualifier, certain print age qualifiers should be included or
 .. ; excluded from the check
 .. I OP1=">"!(OP1="'<") D
 ... I TYP1="MOS",PTYP="DYS" Q
 ... S @TGLOB@(IEN)=""
 . ; if the criteria qualifier and the print age qualifer is the same, then
 . ; simple arithmetic check can be done based on the operand
 . I @(PVAL_OP1_AVAL1) S @TGLOB@(IEN)=""
 ;
 ;  If inclusive or exclusive criteria is used
 I $G(CRIT2)'="" D
 . S TYP2=$E(CRIT2,$L(CRIT2)-2,$L(CRIT2)),OP2=$E(CRIT2,1,1)
 . I TYP2'="YRS",TYP2'="MOS",TYP2'="DYS" S TYP2="YRS"
 . S AVAL2=$E(CRIT2,2,$L(CRIT2)-3)
 . I $E(OP2,1,1)="'" S OP2=$E(CRIT2,1,2),AVAL2=$E(CRIT2,3,$L(CRIT2)-3)
 . ; If both criteria qualifiers are years, then AGE value can be checked
 . I TYP1="YRS",TYP2="YRS" D  Q
 .. S AVAL1=$$STRIP^XLFSTR(CRIT1,TYP1)
 .. S AVAL2=$$STRIP^XLFSTR(CRIT2,TYP2)
 .. ; if operand contains a 'not' value, then it is inclusive and the value
 .. ; must have both criteria as 'true'
 .. I OP1["'",OP2["'" I @(AGE_AVAL1),@(AGE_AVAL2) S @TGLOB@(IEN)="" Q
 .. ; if operand does not contain a 'not' value, then it is exclusive and the
 .. ; value must have one criteria as 'true'
 .. I OP1'["'",OP2'["'" D  Q
 ... I @(AGE_AVAL1) S @TGLOB@(IEN)="" Q
 ... I @(AGE_AVAL2) S @TGLOB@(IEN)="" Q
 . ;
 . ; Can't compare non compatible qualifiers
 . I TYP1="YRS",TYP2'="YRS" Q
 . I TYP1="MOS",TYP2="DYS" Q
 . ;
 . S PVAL=$P(PAGE," ",1),PTYP=$P(PAGE," ",2)
 . I PTYP=TYP1,PTYP=TYP2 D  Q
 .. S AVAL1=$$STRIP^XLFSTR(CRIT1,TYP1)
 .. S AVAL2=$$STRIP^XLFSTR(CRIT2,TYP2)
 .. I OP1["'",OP2["'" I @(PVAL_AVAL1),@(PVAL_AVAL2) S @TGLOB@(IEN)="" Q
 .. I OP1'["'",OP2'["'" D  Q
 ... I @(PVAL_AVAL1) S @TGLOB@(IEN)="" Q
 ... I @(PVAL_AVAL2) S @TGLOB@(IEN)="" Q
 . ; Inclusive check
 . I OP1="'<" D
 .. I TYP1="MOS" D
 ... I PTYP="DYS" Q
 ... I PTYP="MOS",@(PVAL_OP1_AVAL1) D
 .... I TYP2="YRS" S @TGLOB@(IEN)="" Q
 ... I PTYP=TYP2,@(PVAL_OP2_AVAL2) S @TGLOB@(IEN)="" Q
 .. I TYP1="DYS" D
 ... I PTYP="DYS",@(PVAL_OP1_AVAL1) D
 .... I TYP2'="DYS" S @TGLOB@(IEN)="" Q
 ... I PTYP=TYP2,@(PVAL_OP2_AVAL2) S @TGLOB@(IEN)="" Q
 . ; Exclusive check
 . I OP1="<" D
 .. I TYP1="DYS" D
 ... I TYP2="DYS" D
 .... I PTYP="DYS" D
 ..... I @(PVAL_OP1_AVAL1) S @TGLOB@(IEN)="" Q
 ..... I @(PVAL_OP2_AVAL2) S @TGLOB@(IEN)="" Q
 .... I PTYP="MOS"!(PTYP="YRS") S @TGLOB@(IEN)="" Q
 ... I TYP2="MOS" D
 .... I PTYP="DYS",@(PVAL_OP1_AVAL1) S @TGLOB@(IEN)="" Q
 .... I PTYP="MOS",@(PVAL_OP2_AVAL2) S @TGLOB@(IEN)="" Q
 .... I PTYP="YRS" S @TGLOB@(IEN)="" Q
 ... I TYP2="YRS" D
 .... I PTYP="DYS",@(PVAL_OP1_AVAL1) S @TGLOB@(IEN)="" Q
 .... I PTYP="MOS" Q
 .... I PTYP="YRS",@(PVAL_OP2_AVAL2) S @TGLOB@(IEN)="" Q
 .. I TYP1="MOS" D
 ... I TYP2="DYS" Q
 ... I TYP2="MOS" D
 .... I PTYP="DYS" S @TGLOB@(IEN)="" Q
 .... I PTYP="MOS" D
 ..... I @(PVAL_OP1_AVAL1) S @TGLOB@(IEN)="" Q
 ..... I @(PVAL_OP2_AVAL2) S @TGLOB@(IEN)="" Q
 .... I PTYP="YRS" S @TGLOB@(IEN)="" Q
 ... I TYP2="YRS" D
 .... I PTYP="DYS" S @TGLOB@(IEN)="" Q
 .... I PTYP="MOS",@(PVAL_OP1_AVAL1) S @TGLOB@(IEN)="" Q
 .... I PTYP="YRS",@(PVAL_OP2_AVAL2) S @TGLOB@(IEN)="" Q
 .. I TYP1="YRS" D
 ... I TYP2="DYS" Q
 ... I TYP2="MOS" Q
 ... I TYP2="YRS" D
 .... I PTYP="DYS" S @TGLOB@(IEN)="" Q
 .... I PTYP="MOS" S @TGLOB@(IEN)="" Q
 .... I PTYP="YRS" D
 ..... I @(PVAL_OP1_AVAL1) S @TGLOB@(IEN)="" Q
 ..... I @(PVAL_OP2_AVAL2) S @TGLOB@(IEN)="" Q
 Q
 ;
DIAG(FGLOB,TGLOB,DIAG,MPARMS) ;EP - Diagnosis Category search
 NEW DXPT,CT,DFN,STAT,AVL,RCIEN
 I $G(TGLOB)="" Q
 I $G(DIAG)]"" D DXC
 I $D(MPARMS("DXCAT")) D
 . I DXOP="!" D  Q
 .. S DIAG="" F  S DIAG=$O(MPARMS("DXCAT",DIAG)) Q:DIAG=""  D DXC
 . I DXOP="&" D
 .. S DIAG="",CT=0
 .. F  S DIAG=$O(MPARMS("DXCAT",DIAG)) Q:DIAG=""  D
 ... S CT=CT+1,IEN=""
 ... F  S IEN=$O(^BQIREG("B",DIAG,IEN)) Q:IEN=""  D
 .... S DFN=$P(^BQIREG(IEN,0),U,2)
 .... S STAT=$P(^BQIREG(IEN,0),U,3)
 .... ; Check for associated statuses
 .... I '$D(APARMS),'$D(MAPARMS) S DXPT(DFN)=$G(DXPT(DFN))+1 Q
 .... I $G(APARMS("DXCAT",DIAG,"DXSTAT"))'="" D  Q
 ..... I STAT=$G(APARMS("DXCAT",DIAG,"DXSTAT")) S DXPT(DFN)=$G(DXPT(DFN))+1
 .... S AVL=""
 .... F  S AVL=$O(MAPARMS("DXCAT",DIAG,"DXSTAT",AVL)) Q:AVL=""  D
 ..... I STAT=AVL S DXPT(DFN)=$G(DXPT(DFN))+1
 . ;
 . S IEN="" F  S IEN=$O(DXPT(IEN)) Q:IEN=""  I DXPT(IEN)'=CT K DXPT(IEN)
 . I $G(FGLOB)="" S IEN="" F  S IEN=$O(DXPT(IEN)) Q:IEN=""  S @TGLOB@(IEN)=""
 . I $G(FGLOB)'="" S IEN="" F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  I $D(DXPT(IEN))>0 S @TGLOB@(IEN)=""
 K MAPARMS
 Q
 ;
DXC ;
 I $G(FGLOB)'="" D
 . S IEN=""
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 .. I $D(^BQIREG("C",IEN,DIAG)) D
 ... S RCIEN=$O(^BQIREG("C",IEN,DIAG,""))
 ... S STAT=$P(^BQIREG(RCIEN,0),U,3)
 ... ;**Check for associated statuses
 ... I '$D(APARMS("DXCAT",DIAG)),'$D(MAPARMS("DXCAT",DIAG)) S @TGLOB@(IEN)="" Q
 ... ; I '$D(APARMS),'$D(MAPARMS) S @TGLOB@(IEN)="" Q
 ... I $G(APARMS("DXCAT",DIAG,"DXSTAT"))'="" D  Q
 .... I STAT=$G(APARMS("DXCAT",DIAG,"DXSTAT")) S @TGLOB@(IEN)=""
 ... S AVL=""
 ... F  S AVL=$O(MAPARMS("DXCAT",DIAG,"DXSTAT",AVL)) Q:AVL=""  D
 .... I STAT=AVL S @TGLOB@(IEN)=""
 ;
 NEW DFN,IEN
 I $G(FGLOB)="" D
 . S IEN=""
 . F  S IEN=$O(^BQIREG("B",DIAG,IEN)) Q:IEN=""  D
 .. S DFN=$P(^BQIREG(IEN,0),U,2)
 .. S STAT=$P(^BQIREG(IEN,0),U,3)
 .. ;  Check for associated statuses
 .. I '$D(APARMS),'$D(MAPARMS) S @TGLOB@(DFN)="" Q
 .. I $G(APARMS("DXCAT",DIAG,"DXSTAT"))'="" D  Q
 ... I STAT=$G(APARMS("DXCAT",DIAG,"DXSTAT")) S @TGLOB@(DFN)=""
 .. I $D(MAPARMS("DXCAT",DIAG,"DXSTAT",STAT)) S @TGLOB@(DFN)=""
 Q
 ;
 ;
BEN(FGLOB,TGLOB,BEN,MPARMS) ;EP - Beneficiary search
 I $G(TGLOB)="" Q
 I $G(BEN)]"" D BEN1
 I $D(MPARMS("BEN")) S BEN="" F  S BEN=$O(MPARMS("BEN",BEN)) Q:BEN=""  D BEN1
 Q
 ;
BEN1 ;
 I $G(FGLOB)'="" D  Q
 . N IEN,BENPT
 . S IEN=""
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 .. S BENPT=$$GET1^DIQ(9000001,IEN_",",1111,"I")
 .. I BENPT=BEN S @TGLOB@(IEN)=""
 ;
 N DFN
 S DFN=""
 F  S DFN=$O(^AUPNPAT("AD",BEN,DFN)) Q:DFN=""  S @TGLOB@(DFN)=""
 Q
