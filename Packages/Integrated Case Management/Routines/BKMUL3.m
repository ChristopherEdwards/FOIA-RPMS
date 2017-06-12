BKMUL3 ;APTIV/HC/DB-BKM utilities for Code Set Versioning ; 16 Apr 2008  6:00 PM
 ;;2.2;HIV MANAGEMENT SYSTEM;;Apr 01, 2015;Build 40
 ;
ICD9(VAL,IDT,PC) ; EP - Return value of CSV pc of the ICD DIAGNOSIS file (#80)
 ;
 ;Input Parameter Description:
 ;VAL   ICD DIAGNOSIS internal entry number
 ;IDT   ICD DIAGNOSIS date
 ;PC    piece of the string returned by $$ICDDX^ICDCODE that is being
 ;      requested
 N STR
 S IDT=$G(IDT)
 I $$VERSION^XPDUTL("AICD")>3.51 D
 . S SYS=$$CSI^ICDEX(80,VAL)
 . S STR=$$ICDDX^ICDEX(VAL,IDT,SYS,"I")
 I $$VERSION^XPDUTL("AICD")<4.0 D
 . S STR=$S(IDT="":$$ICDDX^ICDCODE(VAL),1:$$ICDDX^ICDCODE(VAL,IDT))
 I $P(STR,U)=-1 Q ""
 Q $P(STR,U,PC)
 ;
ICD0(VAL,IDT,PC) ; EP - Return value of CSV pc of the ICD OPERATION/PROCEDURE file (#80.1)
 ;
 ;Input Parameter Description:
 ;VAL   ICD OPERATION/PROCEDURE internal entry number
 ;IDT   ICD OPERATION/PROCEDURE date
 ;PC    piece of the string returned by $$ICDOP^ICDCODE that is being
 ;      requested
 N STR
 S IDT=$G(IDT)
 I $$VERSION^XPDUTL("AICD")>3.51 D
 . S SYS=$$CSI^ICDEX(80.1,VAL)
 . S STR=$$ICDOP^ICDEX(VAL,IDT,SYS,"I")
 I $$VERSION^XPDUTL("AICD")<4.0 D
 . S STR=$S(IDT="":$$ICDOP^ICDCODE(VAL),1:$$ICDOP^ICDCODE(VAL,IDT))
 I $P(STR,U)=-1 Q ""
 Q $P(STR,U,PC)
 ;
ICPT(VAL,IDT,PC) ; EP - Return value of CSV pc of the CPT file (#81)
 ;
 ;Input Parameter Description:
 ;VAL   CPT internal entry number
 ;IDT   CPT date
 ;PC    piece of the string returned by $$CPT^ICPTCOD that is being
 ;      requested
 N STR
 S IDT=$G(IDT)
 S STR=$S(IDT="":$$CPT^ICPTCOD(VAL),1:$$CPT^ICPTCOD(VAL,IDT))
 I $P(STR,U)=-1 Q ""
 Q $P(STR,U,PC)
 ;
ICDD(FILE,VAL,IDT) ;EP - Return description for ^ICD9 or ^ICD0
 ; FILE is 80 or 80.1
 ; VAL is internal entry number
 ; IDT is the date
 ;
 N EXEC,CODE,OK,ARRAY,DESC,I,QFL
 S IDT=$G(IDT,""),QFL=0
 I $$VERSION^XPDUTL("AICD")<4.0 D   I QFL Q ""
 . S EXEC="S CODE=$$"_FILE_"("_VAL_","_IDT_",2)"
 . X EXEC
 . I CODE="" S QFL=1 Q
 . S OK=$$ICDD^ICDCODE(CODE,"ARRAY",IDT)
 . I OK=-1 S QFL=1
 I $$VERSION^XPDUTL("AICD")>3.51 D  I OK=-1 Q ""
 . S CSYS=$$CSI^ICDEX(FILE,VAL)
 . S OK=$$ICDDESC^ICDXCODE(CSYS,VAL,IDT,.ARRAY)
 ;
 S DESC="" F I=1:1 Q:'$D(ARRAY(I))  Q:ARRAY(I)=" "  S DESC=DESC_ARRAY(I)_" "
 S DESC=$$TKO^BQIUL1(DESC," ")
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
