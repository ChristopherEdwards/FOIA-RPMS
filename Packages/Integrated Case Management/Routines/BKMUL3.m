BKMUL3 ;APTIV/HC/DB-BKM utilities for Code Set Versioning ; 16 Apr 2008  6:00 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
ICD9(VAL,IDT,PC) ; EP - Return value of CSV pc of the ICD DIAGNOSIS file (#80)
 ;
 N STR
 S IDT=$G(IDT)
 S STR=$S(IDT="":$$ICDDX^ICDCODE(VAL),1:$$ICDDX^ICDCODE(VAL,IDT))
 I $P(STR,U)=-1 Q ""
 Q $P(STR,U,PC)
 ;
ICD0(VAL,IDT,PC) ; EP - Return value of CSV pc of the ICD OPERATION/PROCEDURE file (#80.1)
 ;
 N STR
 S IDT=$G(IDT)
 S STR=$S(IDT="":$$ICDOP^ICDCODE(VAL),1:$$ICDOP^ICDCODE(VAL,IDT))
 I $P(STR,U)=-1 Q ""
 Q $P(STR,U,PC)
 ;
ICPT(VAL,IDT,PC) ; EP - Return value of CSV pc of the CPT file (#81)
 ;
 N STR
 S IDT=$G(IDT)
 S STR=$S(IDT="":$$CPT^ICPTCOD(VAL),1:$$CPT^ICPTCOD(VAL,IDT))
 I $P(STR,U)=-1 Q ""
 Q $P(STR,U,PC)
 ;
ICDD(FILE,VAL,IDT) ;EP - Return description for ^ICD9 or ^ICD0
 ; FILE is ICD9 or ICD0
 ; VAL is internal entry number
 ;
 N EXEC,CODE,OK,ARRAY,DESC,I
 S IDT=$G(IDT)
 S EXEC="S CODE=$$"_FILE_"("_VAL_","_IDT_",2)"
 X EXEC
 I CODE="" Q ""
 S OK=$$ICDD^ICDCODE(CODE,"ARRAY",IDT)
 I OK=-1 Q ""
 S DESC="" F I=1:1 Q:'$D(ARRAY(I))  Q:ARRAY(I)=" "  S DESC=DESC_ARRAY(I)_" "
 S DESC=$$TKO(DESC," ")
 Q DESC
  ;
TKO(STR,VAL) ;EP - Take off ending character
 ;
 ;Description
 ;  This will take off the ending character at the end of
 ;  a string
 ;Input
 ;  STR - String of data
 ;  VAL - Delimiter character
 ;Output
 ;  same STR without the ending character
 ;
 I $G(STR)="" Q ""
 I $G(VAL)="" Q ""
 ;
 I $E(STR,$L(STR))=VAL S STR=$E(STR,1,$L(STR)-1)
 ;
 Q STR
