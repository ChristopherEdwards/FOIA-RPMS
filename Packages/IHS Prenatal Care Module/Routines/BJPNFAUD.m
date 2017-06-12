BJPNFAUD ;GDIT/HS/BEE-Prenatal Care Module - Retrieve Audit History ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;;Feb 24, 2015;Build 63
 ;
 Q
 ;
ACOMP(RET,PIPIEN,PRBIEN) ;Retrieve audit history for a PIP entry
 ;
 ;Input validation
 I $G(PIPIEN)="" Q
 I $G(PRBIEN)="" Q
 ;
 NEW FILE,AIEN,SBPIP,PIEN,SBPRB,FNUM,IEN2,XOLD,DFN
 ;
 ;Get the DFN
 S DFN=$$GET1^DIQ(9000011,PRBIEN_",",.02,"I")
 ;
 ;Loop through PIP file audits first
 S FILE=90680.01
 S AIEN="" F  S AIEN=$O(^DIA(FILE,"B",PIPIEN,AIEN)) Q:AIEN=""  D
 . NEW ADT,ND,AUSR,XFLD,XOLD,XNEW,FLD,DFILE
 . ;
 . ;Pull the top node
 . S ND=$G(^DIA(FILE,AIEN,0))
 . ;
 . ;Get the date/time of change
 . S ADT=$P(ND,U,2) S:ADT="" ADT=" "
 . S ADT=$$TMIN(ADT)
 . ;
 . ;Get change user
 . S AUSR=$P(ND,U,4) S:AUSR="" AUSR=" "
 . ;
 . ;Get field changed
 . S FLD=$P(ND,U,3) Q:FLD=""
 . ;
 . ;Get the field name
 . S DFILE=FILE
 . I FLD["," D
 .. NEW SFLD,SFILE,SBFLD
 .. S SFLD=$P(FLD,",") Q:SFLD=""
 .. S SBFLD=$P(FLD,",",2) Q:SBFLD=""
 .. S SFILE=+$P($G(^DD(FILE,SFLD,0)),U,2) Q:SFLD=""
 .. S FLD=SBFLD
 .. S DFILE=SFILE
 . S XFLD=$P($G(^DD(DFILE,FLD,0)),U) Q:XFLD=""
 . ;
 . ;Get old value
 . S XOLD=$P($G(^DIA(FILE,AIEN,2)),U)
 . ;
 . ;Get new value
 . S XNEW=$P($G(^DIA(FILE,AIEN,3)),U)
 . ;
 . ;Set up sortable entry
 . S @RET@(ADT,AUSR,XFLD)=XOLD_U_XNEW_U_$P(ND,U)
 ;
 ;Now loop through PIP file subentries
 S FILE=90680.01,SBPIP=PIPIEN_","
 S PIEN=SBPIP F  S PIEN=$O(^DIA(FILE,"B",PIEN)) Q:PIEN=""  Q:PIEN'[SBPIP  D
 . S AIEN="" F  S AIEN=$O(^DIA(FILE,"B",PIEN,AIEN)) Q:AIEN=""  D
 .. NEW ADT,ND,AUSR,XFLD,XOLD,XNEW
 .. ;
 .. ;Pull the top node
 .. S ND=$G(^DIA(FILE,AIEN,0))
 .. ;
 .. ;Get the date/time of change
 .. S ADT=$P(ND,U,2) S:ADT="" ADT=" "
 .. S ADT=$$TMIN(ADT)
 .. ;
 .. ;Get change user
 .. S AUSR=$P(ND,U,4) S:AUSR="" AUSR=" "
 .. ;
 .. ;Get field changed
 .. S FLD=$P(ND,U,3) Q:FLD=""
 .. ;
 .. ;Get the field name
 .. S DFILE=FILE
 .. I FLD["," D
 ... NEW SFLD,SFILE,SBFLD
 ... S SFLD=$P(FLD,",") Q:SFLD=""
 ... S SBFLD=$P(FLD,",",2) Q:SBFLD=""
 ... S SFILE=+$P($G(^DD(FILE,SFLD,0)),U,2) Q:SFLD=""
 ... S FLD=SBFLD
 ... S DFILE=SFILE
 .. S XFLD=$P($G(^DD(DFILE,FLD,0)),U) Q:XFLD=""
 .. S:XFLD="PIP" XFLD="PIPF"
 .. ;
 .. ;Get old value
 .. S XOLD=$P($G(^DIA(FILE,AIEN,2)),U)
 .. ;
 .. ;Get new value
 .. S XNEW=$P($G(^DIA(FILE,AIEN,3)),U)
 .. ;
 .. ;Set up sortable entry
 .. S @RET@(ADT,AUSR,XFLD)=XOLD_U_XNEW_U_$P(ND,U)
 ;
 ;Now loop through the PROBLEM file
 S FILE=9000011
 S AIEN="" F  S AIEN=$O(^DIA(FILE,"B",PRBIEN,AIEN)) Q:AIEN=""  D
 . NEW ADT,ND,AUSR,XFLD,XOLD,XNEW
 . ;
 . ;Pull the top node
 . S ND=$G(^DIA(FILE,AIEN,0))
 . ;
 . ;Get the date/time of change
 . S ADT=$P(ND,U,2) S:ADT="" ADT=" "
 . S ADT=$$TMIN(ADT)
 . ;
 . ;Get change user
 . S AUSR=$P(ND,U,4) S:AUSR="" AUSR=" "
 . ;
 . ;Get field changed
 . S FLD=$P(ND,U,3) Q:FLD=""
 . ;
 . ;Get the field name
 . S DFILE=FILE
 . I FLD["," D
 .. NEW SFLD,SFILE,SBFLD
 .. S SFLD=$P(FLD,",") Q:SFLD=""
 .. S SBFLD=$P(FLD,",",2) Q:SBFLD=""
 .. S SFILE=+$P($G(^DD(FILE,SFLD,0)),U,2) Q:SFLD=""
 .. S FLD=SBFLD
 .. S DFILE=SFILE
 . S XFLD=$P($G(^DD(DFILE,FLD,0)),U) Q:XFLD=""
 . ;
 . ;Get old value
 . S XOLD=$P($G(^DIA(FILE,AIEN,2)),U)
 . ;
 . ;Get new value
 . S XNEW=$P($G(^DIA(FILE,AIEN,3)),U)
 . ;
 . ;Set up sortable entry
 . S @RET@(ADT,AUSR,XFLD)=XOLD_U_XNEW_U_$P(ND,U)
 ;
 ;Now loop through PROBLEM file subentries
 S FILE=9000011,SBPRB=PRBIEN_","
 S PIEN=SBPRB F  S PIEN=$O(^DIA(FILE,"B",PIEN)) Q:PIEN=""  D  Q:PIEN'[SBPRB
 . S AIEN="" F  S AIEN=$O(^DIA(FILE,"B",PIEN,AIEN)) Q:AIEN=""  D
 .. NEW ADT,ND,AUSR,XFLD,XOLD,XNEW
 .. ;
 .. ;Pull the top node
 .. S ND=$G(^DIA(FILE,AIEN,0))
 .. ;
 .. ;Get the date/time of change
 .. S ADT=$P(ND,U,2) S:ADT="" ADT=" "
 .. S ADT=$$TMIN(ADT)
 .. ;
 .. ;Get change user
 .. S AUSR=$P(ND,U,4) S:AUSR="" AUSR=" "
 .. ;
 .. ;Get field changed
 .. S FLD=$P(ND,U,3) Q:FLD=""
 .. ;
 .. ;Get the field name
 .. S DFILE=FILE
 .. I FLD["," D
 ... NEW SFLD,SFILE,SBFLD
 ... S SFLD=$P(FLD,",") Q:SFLD=""
 ... S SBFLD=$P(FLD,",",2) Q:SBFLD=""
 ... S SFILE=+$P($G(^DD(FILE,SFLD,0)),U,2) Q:SFLD=""
 ... S FLD=SBFLD
 ... S DFILE=SFILE
 .. S XFLD=$P($G(^DD(DFILE,FLD,0)),U) Q:XFLD=""
 .. ;
 .. ;Get old value
 .. S XOLD=$P($G(^DIA(FILE,AIEN,2)),U)
 .. ;
 .. ;Get new value
 .. S XNEW=$P($G(^DIA(FILE,AIEN,3)),U)
 .. ;
 .. ;Set up sortable entry
 .. S @RET@(ADT,AUSR,XFLD)=XOLD_U_XNEW_U_$P(ND,U)
 ;
 ;Add in qualifiers - EDITS/DELETES are also getting pulled from DIA
 ;Since the DIA field is EDIT/DELETE only, attempt to grab an add
 S FNUM=9000011.13,XOLD=""
 S IEN2=0 F  S IEN2=$O(^AUPNPROB(PRBIEN,13,IEN2)) Q:'+IEN2  D
 . NEW AIEN,Q,BY,WHEN,XNEW
 . S AIEN=IEN2_","_PRBIEN_","
 . S XNEW=$$GET1^DIQ(FNUM,AIEN,.01)
 . Q:XNEW=246112005  ;Skip the attribute entry
 . S BY=$$GET1^DIQ(FNUM,AIEN,.02,"I") S:BY="" BY=" "
 . S WHEN=$$TMIN($$GET1^DIQ(FNUM,AIEN,.03,"I")) S:WHEN="" WHEN=" "
 . S @RET@(WHEN,BY,"SEVERITY")=XOLD_U_XNEW_U_PRBIEN_","_IEN2
 . S XOLD=XNEW
 ;
 ;Get the Care Plans
 D
 . NEW CDATA
 . D GET^BGOCPLAN(.CDATA,PRBIEN,DFN,"C","C","")
 . D PLAN
 ;
 ;Get the Goals
 D
 . NEW CDATA
 . D GET^BGOCPLAN(.CDATA,PRBIEN,DFN,"G","C","")
 . D PLAN
 ;
 ;Get the Visit Instructions
 D
 . NEW VDATA,VIEN
 . D GET^BGOVVI(.VDATA,DFN,PRBIEN,99999,"",.VIEN)
 . Q:'$D(^TMP("BGOVIN",$J))
 . D VISIT
 ;
 ;Get the V Treatment Regimen
 D
 . NEW TDATA,VIEN
 . D GET^BGOVTR(.TDATA,DFN,PRBIEN,99999,"",.VIEN)
 . Q:'$D(^TMP("BGOVIN",$J))
 . D TREAT
 ;
 ;Get the Patient Education
 D
 . NEW EDATA,VIEN
 . D GETEDU^BGOVTR(.EDATA,DFN,PRBIEN,99999,.VIEN)
 . Q:'$D(^TMP("BGOVIN",$J))
 . D EDU
 ;
TMIN(TIME) ;Drop any seconds off the time
 Q +($P(TIME,".")_"."_$E($P(TIME,".",2),1,4))
 ;
PLAN ;GET ALL CARE PLANNING DATA
 NEW CT2
 S CT2=0
 F  S CT2=$O(^TMP("BGOPLAN",$J,CT2)) Q:'+CT2  D
 . NEW STR,TYPE,IEN,STS
 . ;
 . S STR=$G(^TMP("BGOPLAN",$J,CT2))
 . Q:$P(STR,U,1)="~t"
 . ;
 . ;Get the IEN
 . S TYPE=$P(STR,U)
 . S IEN=$P(STR,U,2) Q:IEN=""
 . ;
 . ;Now loop through the history
 . S STS=0 F  S STS=$O(^AUPNCPL(IEN,11,STS)) Q:'STS  D
 .. NEW DA,IENS,ADT,USR,XSTS
 .. S DA(1)=IEN,DA=STS,IENS=$$IENS^DILF(.DA)
 .. S ADT=$$GET1^DIQ(9000092.11,IENS,.03,"I") S:ADT="" ADT=" "
 .. S ADT=$$TMIN(ADT)
 .. S USR=$$GET1^DIQ(9000092.11,IENS,.02,"I") S:USR="" USR=" "
 .. S XSTS=$$GET1^DIQ(9000092.11,IENS,.01,"E")
 .. S @RET@(ADT,USR,$S(TYPE="G":"GOAL.",1:"CARE.")_IEN)=XSTS
 . Q
 Q
 ;
VISIT ;GET ALL VISIT INSTRUCTION DATA
 NEW CT2
 S CT2=0
 F  S CT2=$O(^TMP("BGOVIN",$J,CT2)) Q:'+CT2  D
 . NEW STR,IEN
 . ;
 . S STR=$G(^TMP("BGOVIN",$J,CT2))
 . Q:$P(STR,U,1)="~t"
 . ;
 . ;Get the IEN
 . S IEN=$P(STR,U,2) Q:IEN=""
 . ;
 . ;Get entered date/time
 . S ADT=$$TMIN($$GET1^DIQ(9000010.58,IEN_",",1216,"I")) S:ADT="" ADT=" "
 . ;
 . ;Get entered by
 . S USR=$$GET1^DIQ(9000010.58,IEN_",",1217,"I") S:USR="" USR=" "
 . ;
 . ;Set up entry
 . S @RET@(ADT,USR,"VINS."_IEN)=""
 . Q
 Q
 ;
TREAT ;GET ALL TREATMENT REGIMEN DATA
 NEW CT2
 S CT2=0
 F  S CT2=$O(^TMP("BGOVIN",$J,CT2)) Q:'+CT2  D
 . NEW STR,IEN
 . ;
 . S STR=$G(^TMP("BGOVIN",$J,CT2))
 . ;
 . ;Get the IEN
 . S IEN=$P(STR,U,2) Q:IEN=""
 . ;
 . ;Get entered date/time
 . S ADT=$$TMIN($$GET1^DIQ(9000010.61,IEN_",",1216,"I")) S:ADT="" ADT=" "
 . ;
 . ;Get entered by
 . S USR=$$GET1^DIQ(9000010.61,IEN_",",1217,"I") S:USR="" USR=" "
 . ;
 . ;Set up entry
 . S @RET@(ADT,USR,"VTR."_IEN)=""
 . Q
 Q
 ;
EDU ;GET ALL EDUCATION DATA
 NEW CT2
 S CT2=0
 F  S CT2=$O(^TMP("BGOVIN",$J,CT2)) Q:'+CT2  D
 . NEW STR,IEN
 . ;
 . S STR=$G(^TMP("BGOVIN",$J,CT2))
 . ;
 . ;Get the IEN
 . S IEN=$P(STR,U,6) Q:IEN=""
 . ;
 . ;Get entered date/time
 . S ADT=$$TMIN($$GET1^DIQ(9000010.16,IEN_",",1216,"I")) S:ADT="" ADT=" "
 . ;
 . ;Get entered by
 . S USR=$$GET1^DIQ(9000010.16,IEN_",",1217,"I") S:USR="" USR=" "
 . ;
 . ;Set up entry
 . S @RET@(ADT,USR,"VEDU."_IEN)=""
 . Q
 Q
