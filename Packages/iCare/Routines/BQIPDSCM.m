BQIPDSCM ;VNGT/HS/BEE-Panel Description Utility ; 7 Apr 2008  4:28 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 Q
 ;
DESC(OWNR,PLIEN,DESC) ;EP - Format Panel Generated Description
 ;
 ; Input:
 ;   OWNR - The panel owner
 ;  PLIEN - The panel IEN
 ;  
 ; Output:
 ;   DESC - Array containing the generated panel description 
 ;
 NEW DA,IENS,TYPE,SOURCE,MPARMS,PARMS,FILTER,FSOURCE,FPARMS,TDESC,IPC,PCAT
 ;
 S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 S TYPE=$$GET1^DIQ(90505.01,IENS,.03,"I")
 S SOURCE=$$GET1^DIQ(90505.01,IENS,.11,"I")
 S FSOURCE=$$GET1^DIQ(90505.01,IENS,.14,"E")
 ;
 ;Set Up Parameter Section
 ;
 ;Manual Patients
 I TYPE="M" S DESC(1,0)="The patients who were selected manually"
 ;
 ;QMAN Template
 I TYPE="Q" S DESC(1,0)="Search Template "_$P($G(^DIBT(SOURCE,0)),U,1)
 ;
 ;My Panel - User preferences Definition
 I TYPE="Y" D
 . NEW MPIEN,PFLD,SOURCE,TDESC,PMAP
 . S MPIEN=0 F  S MPIEN=$O(^BQICARE(OWNR,7,MPIEN)) Q:'MPIEN  D
 .. S SOURCE=$G(^BQICARE(OWNR,7,MPIEN,0))
 .. S PFLD=0 F  S PFLD=$O(^BQICARE(OWNR,7,MPIEN,10,PFLD)) Q:'PFLD  D
 ... ;
 ... NEW DA,IENS,PNAM,PTYP,VALUE,FILE,PEXE,MUL,OPNAM
 ... S DA(2)=OWNR,DA(1)=MPIEN,DA=PFLD,IENS=$$IENS^DILF(.DA)
 ... ;
 ... ;Pull parameter information
 ... S (OPNAM,PNAM)=$$GET1^DIQ(90505.08,IENS,".01","E") Q:PNAM=""
 ... S PTYP=$$PTYP^BQIDCDF(SOURCE,PNAM)
 ... I PTYP="T" D
 .... S VALUE=$$GET1^DIQ(90505.08,IENS,.03,"E")
 .... S FILE=$$FILN^BQIDCDF(SOURCE,PNAM) Q:FILE=""
 .... S VALUE=$$GET1^DIQ(FILE,VALUE,.01,"E")
 ... I PTYP'="T" S VALUE=$$GET1^DIQ(90505.08,IENS,.02,"E")
 ... S PMAP=$$PMAP^BQIDCDF(SOURCE,PNAM) I PMAP]"" D MAP(SOURCE,PMAP,.VALUE,.PNAM)
 ... S PEXE=$$PEXE^BQIDCDF(SOURCE,PNAM) I VALUE]"",PEXE]"" X PEXE
 ... ;
 ... ;Single value save
 ... I VALUE]"" S PARMS(PNAM,$$TRUNC(VALUE))="" Q
 ... ;
 ... ;Multiple value save
 ... S MUL=0 F  S MUL=$O(^BQICARE(OWNR,7,MPIEN,10,PFLD,1,MUL)) Q:'MUL  D
 .... NEW DA,IENS,VALUE
 .... S DA(3)=OWNR,DA(2)=MPIEN,DA(1)=PFLD,DA=MUL,IENS=$$IENS^DILF(.DA)
 .... S PNAM=OPNAM
 .... I PTYP="T" D
 ..... S VALUE=$$GET1^DIQ(90505.81,IENS,.01,"E")
 ..... S FILE=$$FILN^BQIDCDF(SOURCE,PNAM) Q:FILE=""
 ..... S VALUE=$$GET1^DIQ(FILE,VALUE,.01,"E")
 .... I PTYP'="T" S VALUE=$$GET1^DIQ(90505.81,IENS,.01,"E")
 .... I VALUE]"",PMAP]"" D MAP(SOURCE,PMAP,.VALUE,.PNAM)
 .... I VALUE]"",PEXE]"" X PEXE
 .... I VALUE]"" S PARMS(PNAM,$$TRUNC(VALUE))=""
 . ;
 . ;Assemble parameter description
 . D PDESC(TYPE,"MY PATIENTS-DESCRIPTION",.TDESC,.PARMS)
 . S DESC(1,0)=$G(TDESC)
 . Q
 ;
 ;Other Panel Types
 I ".M.Q.Y."'[TYPE D
 . ;
 . I SOURCE="" Q
 . ;
 . NEW PPIEN,PMIEN
 . S PPIEN=$$PP^BQIDCDF(SOURCE) I PPIEN=-1 Q
 . ;
 . ; Get parameters from panel definition
 . S PMIEN=0 F  S PMIEN=$O(^BQICARE(OWNR,1,PLIEN,10,PMIEN)) Q:'PMIEN  D
 .. ;
 .. NEW DA,PNAM,PTYP,VALUE,FILE,MUL,PEXE,OPNAM,PMAP
 .. S DA(2)=OWNR,DA(1)=PLIEN,DA=PMIEN,IENS=$$IENS^DILF(.DA)
 .. S (OPNAM,PNAM)=$$GET1^DIQ(90505.02,IENS,.01,"E")
 .. S PTYP=$$PTYP^BQIDCDF(SOURCE,PNAM)
 .. I PTYP="T" D
 ... S VALUE=$$GET1^DIQ(90505.02,IENS,.03,"E")
 ... S FILE=$$FILN^BQIDCDF(SOURCE,PNAM) Q:FILE=""
 ... S VALUE=$$GET1^DIQ(FILE,VALUE,.01,"E")
 .. I PTYP'="T" S VALUE=$$GET1^DIQ(90505.02,IENS,.02,"E")
 .. I PTYP="D" S VALUE=$$UP^XLFSTR($$FMTE^XLFDT(VALUE,1))
 .. I PTYP="R" D
 ... S VALUE=$$DATE^BQIUL1(VALUE)
 ... S VALUE=$$UP^XLFSTR($$FMTE^XLFDT(VALUE,1))
 .. S PMAP=$$PMAP^BQIDCDF(SOURCE,PNAM) I VALUE]"",PMAP]"" D MAP(SOURCE,PMAP,.VALUE,.PNAM)
 .. S PEXE=$$PEXE^BQIDCDF(SOURCE,PNAM) I VALUE]"",PEXE]"" X PEXE
 .. ;
 .. ;Single value save
 .. I VALUE]"" S PARMS(PNAM,$$TRUNC(VALUE))="" Q
 .. ;
 .. ;Multiple value save
 .. S MUL=0 F  S MUL=$O(^BQICARE(OWNR,1,PLIEN,10,PMIEN,1,MUL)) Q:'MUL  D
 ... NEW DA,IENS,VALUE
 ... S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=PMIEN,DA=MUL,IENS=$$IENS^DILF(.DA)
 ... S PNAM=OPNAM
 ... I PTYP="T" D
 .... S VALUE=$$GET1^DIQ(90505.21,IENS,.01,"E")
 .... S FILE=$$FILN^BQIDCDF(SOURCE,PNAM) Q:FILE=""
 .... S VALUE=$$GET1^DIQ(FILE,VALUE,.01,"E")
 ... I PTYP'="T" S VALUE=$$GET1^DIQ(90505.21,IENS,.01,"E")
 ... I PTYP="D" S VALUE=$$UP^XLFSTR($$FMTE^XLFDT(VALUE,1))
 ... I PTYP="R" D
 .... S VALUE=$$DATE^BQIUL1(VALUE)
 .... S VALUE=$$UP^XLFSTR($$FMTE^XLFDT(VALUE,1))
 ... I VALUE]"",PMAP]"" D MAP(SOURCE,PMAP,.VALUE,.PNAM)
 ... I VALUE]"",PEXE]"" X PEXE
 ... I VALUE]"" S PARMS(PNAM,$$TRUNC(VALUE))=""
 .. Q
 . ;Assemble parameter description
 . D PDESC(TYPE,SOURCE,.TDESC,.PARMS)
 . S DESC(1,0)=$G(TDESC)
 ;
 ;Retrieve filter information
 D FILTER^BQIPDSCF(OWNR,PLIEN,.FPARMS)
 ;
 ;Assemble filter description
 I $D(FPARMS) D FDESC(.DESC,.FPARMS)
 ;
 ;Pull category and IPC Flag
 D CATIPC(OWNR,PLIEN,.DESC)
 ;
 Q
 ;
TRUNC(VAL) ;EP - Truncate value to 255
 ;
 Q:$L(VAL)<256 VAL
 Q $E(VAL,1,252)_"..."
 ;
CNT(PARM) ;EP - Return number of entries for specific parameter
 ;
 I PARM="" Q 0
 I $G(PARMS(PARM))="" Q 0
 Q $L(PARMS(PARM),",")
 ;
FCNT(FPRM) ;EP - Return if filter is defined for panel
 ;
 N PORD
 I FPRM="" Q 0
 ;S PORD=$$PORD^BQIDCDF(FSOURCE,FPRM) Q:PORD="" 0
 I $D(FPARMS("VAL",FPRM)) Q $L(FPARMS("VAL",FPRM),", ")
 Q 0
 ;
CATIPC(OWNR,PLIEN,DESC) ;EP - Add in category and IPC status
 ;
 NEW PCAT,PIPC,DA,IENS,DII
 ;
 S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 S PCAT=$$PCAT^BQIPLDF(OWNR,PLIEN) ;$$GET1^DIQ(90505.01,IENS,2.2,"I")
 S PIPC=$$GET1^DIQ(90505.01,IENS,2.1,"I")
 ;
 S DA(1)=DUZ,DA=PCAT,IENS=$$IENS^DILF(.DA)
 S:PCAT]"" PCAT=$$GET1^DIQ(90505.017,IENS,.01,"I")
 S:PCAT="" PCAT="N/A"
 S PIPC=$S(PIPC="1":"Yes",1:"No")
 S DII=$O(DESC(""),"-1") S DII=$G(DII)+1
 S DESC(DII,0)="Panel Category: "_PCAT_"    IPC Panel: "_PIPC_"; "
 ;
 Q
 ;
MAP(SOURCE,PMAP,VALUE,PNAM) ;EP - Map one value to another
 ;
 NEW PDEF,FIEN,MAP,I,PC,FND
 ;
 S PDEF=$$PP^BQIDCDF(SOURCE) Q:PDEF=""
 ;
 S FIEN=$O(^BQI(90506,PDEF,3,"B",PMAP,"")) Q:FIEN=""
 ;
 S FND=""
 S MAP="" F  S MAP=$O(^BQI(90506,PDEF,3,FIEN,3,"AC",MAP)) Q:MAP=""  D  Q:FND
 . F I=1:1:$L(MAP,"~") S PC=$P(MAP,"~",I) I PC]"" D  Q:FND
 .. NEW VAR,VAL,CIEN,DA,IEN
 .. S VAR=$P(PC,"=") Q:VAR=""
 .. S VAL=$P(PC,"=",2) Q:VAL=""
 .. Q:VAR'=PNAM
 .. Q:VAL'=VALUE
 .. S CIEN=$O(^BQI(90506,PDEF,3,FIEN,3,"AC",MAP,"")) Q:CIEN=""
 .. S DA(2)=PDEF,DA(1)=FIEN,DA=CIEN,IEN=$$IENS^DILF(.DA)
 .. S VALUE=$$GET1^DIQ(90506.33,IEN,.01,"E"),PNAM=PMAP,FND=1
 ;
 Q
 ;
PVST(TYPE) ;EP - Assemble primary secondary visit description section
 ;
 I TYPE="PRIM",$D(PARMS("PVISITS")) D PSVST("PRIM",PARMS("PVISITS"),$G(PARMS("PTMFRAME")),.PARMS)
 I TYPE="PRSC",$D(PARMS("PSVISITS")) D PSVST("PRSC",PARMS("PSVISITS"),$G(PARMS("PSTMFRAM")),.PARMS)
 Q
 ;
PSVST(BQITYPE,BQIVST,BQITIME,BQIMPRM) ;EP - Assemble Primary/Secondary Provider Visit Checks
 ;
 ;Description: This tag receives primary or secondary visit check information and moves it into
 ;             the multiple field "TYPE" node so it will be included with the other specialties.
 ;
 ;Parameters:
 ;BQITYPE = "PRIM" - Primary or "PRSC" - Primary/Secondary
 ;BQIVST = # of visits parameter
 ;BQITIME = Date Range
 ;BQIMPRM = Passed in MPARMS array. Gets updated with visit check description
 ;
 ;
 N STR
 I BQITYPE=""!(BQIVST="")!(BQITIME="") Q
 ;
 ;Assemble Visit Check Description
 S STR=BQIVST
 S STR=STR_" "_$S(BQITYPE="PRIM":"PRIMARY VISIT PROVIDER",1:"PRIMARY/SECONDARY VISIT PROVIDER")
 S STR=STR_" "_$S(BQIVST>1:"visits",1:"visit")
 S STR=STR_" in "_$S(BQITIME="T-24M":"2 years",BQITIME="T-12M":"1 year",1:$P(BQITIME,"T-",2))
 ;
 ;Save New Entry With Visit Check Description
 S BQIMPRM(BQITYPE)=STR
 Q
 ;
EHPL ;EP - Format EHR Personal List
 NEW EHPLIEN,EHVAL,PC
 S EHVAL=""
 F PC=1:1:$L(PARMS("EHRPLIEN"),", ") S EHPLIEN=$P(PARMS("EHRPLIEN"),", ",PC)  D
 . NEW EHPL
 . S EHPL=$$GETNAME^BEHOPTP2(EHPLIEN)
 . S EHVAL=$G(EHVAL)_EHPL_","
 S EHVAL=$$TKO^BQIUL1(EHVAL,",")
 S:EHVAL]"" PARMS("EHRPLIEN")=EHVAL
 Q
 ;
REG ;EP - Format RPMS Register Panel Information
 N REGIEN,REGNMSP
 I '$D(PARMS("REG")) Q
 S REGIEN=$O(^BQI(90507,"B",PARMS("REG"),""))
 I REGIEN="" Q
 S REGNMSP=$$GET1^DIQ(90507,REGIEN_",",.13,"E")
 I REGNMSP'="" S PARMS("NMSP")=REGNMSP
 I $G(PARMS("SUBREG"))'="" D
 . N SBIEN,SBREG
 . S SBIEN=0 F  S SBIEN=$O(^BQI(90507,SBIEN)) Q:'SBIEN  D
 .. S SBREG=$P($G(^BQI(90507,SBIEN,0)),U,9)
 .. I SBREG=PARMS("SUBREG") D
 ... S REGNMSP=$$GET1^DIQ(90507,SBIEN_",",.13,"E")
 ... I REGNMSP'="" S PARMS("NMSP")=REGNMSP
 Q
 ;
PRS(TDESC) ;EP - Parse description
 S TDESC=$P(TDESC,"|",1)_$G(PARMS($P(TDESC,"|",2)))_$P(TDESC,"|",3,99)
 Q
 ;
MPRS(TDESC) ;EP - Parse filter description
 S TDESC=$P(TDESC,"|",1)_$G(FPARMS("VAL",$P(TDESC,"|",2)))_$P(TDESC,"|",3,99)
 Q
 ;
PDESC(TYPE,SOURCE,TDESC,PARMS) ;EP - Assemble parameter description
 N PPIEN,DSCEXE,DSC,PORD,PFIEN,PSORD
 ;
 ;Convert multiple values into single value
 D MPARMS(.PARMS,"")
 ;
 ;Pull first part of description
 S PPIEN=$$PP^BQIDCDF(SOURCE) I PPIEN=-1 Q
 S DSC=""
 S DSCEXE=$$GET1^DIQ(90506,PPIEN,6) I DSCEXE]"" X DSCEXE
 S TDESC=DSC
 ;
 ;Loop through parameters for source and assemble description
 S PORD="" F  S PORD=$O(^BQI(90506,PPIEN,3,"C",PORD)) Q:PORD=""  D
 . S PFIEN=$O(^BQI(90506,PPIEN,3,"C",PORD,"")) Q:PFIEN=""
 . ;
 . ;Get description framework for parameter
 . S DSC=""
 . S PSORD="" F  S PSORD=$O(^BQI(90506,PPIEN,3,PFIEN,5,"B",PSORD)) Q:PSORD=""  D  I DSC]"" Q
 .. NEW PSIEN,PREXE
 .. S PSIEN=$O(^BQI(90506,PPIEN,3,PFIEN,5,"B",PSORD,"")) Q:PSIEN=""
 .. S PREXE=$G(^BQI(90506,PPIEN,3,PFIEN,5,PSIEN,1))
 .. I PREXE]"" X PREXE
 . S:DSC]"" TDESC=$G(TDESC)_DSC
 ;
 ;Populate values
 F  Q:'$F(TDESC,"|")  D PRS(.TDESC)
 ;
 Q
 ;
FDESC(PARMS,FPARMS) ;EP - Assemble filter description
 NEW PPIEN,DSC,DSCEXE,TDESC,PORD,FPC,VAL,DII,PSORD,PFIEN,FNAME
 ;
 ;Convert multiple values into single value
 D FPARMS(.FPARMS)
 ;
 ;Pull first part of description
 S PPIEN=$$PP^BQIDCDF(FSOURCE) I PPIEN=-1 Q
 S DSC=""
 S DSCEXE=$$GET1^DIQ(90506,PPIEN,6) I DSCEXE]"" X DSCEXE
 S TDESC=DSC
 ;
 ;Loop through parameters for source and assemble description
 S PORD="" F  S PORD=$O(FPARMS(PORD)) Q:'PORD  D
 . S FNAME="" F  S FNAME=$O(FPARMS(PORD,FNAME)) Q:FNAME=""  D
 .. ;
 .. S PFIEN=$O(^BQI(90506,PPIEN,3,"B",FNAME,"")) Q:PFIEN=""
 .. ;
 .. ;Get description framework for parameter
 .. S DSC=""
 .. S FPARMS("VAL",FNAME)=$G(FPARMS(PORD,FNAME))
 .. K FPARMS(PORD,FNAME)
 .. ;
 .. S PSORD="" F  S PSORD=$O(^BQI(90506,PPIEN,3,PFIEN,5,"B",PSORD)) Q:PSORD=""  D  I DSC]"" Q
 ... NEW PSIEN,PREXE
 ... S PSIEN=$O(^BQI(90506,PPIEN,3,PFIEN,5,"B",PSORD,"")) Q:PSIEN=""
 ... S PREXE=$G(^BQI(90506,PPIEN,3,PFIEN,5,PSIEN,1))
 ... I PREXE]"" X PREXE
 .. S:DSC]"" TDESC=$G(TDESC)_DSC_"; "
 S TDESC=$$TKO^BQIUL1(TDESC,"; ")
 ;
 ;Populate values
 NEW FPC,DII
 F  Q:'$F(TDESC,"|")  D MPRS(.TDESC)
 F FPC=1:1:$L(TDESC,"; ") D
 . NEW VAL
 . S VAL=$P(TDESC,"; ",FPC) Q:FPC=""
 . S DII=$O(DESC(""),"-1") S DII=$G(DII)+1
 . S DESC(DII,0)=VAL_"; "
 ;
 Q
 ;
MPARMS(PARMS,DEL) ;EP - Convert multiple values into single value
 ;
 ; Input:
 ;    PARMS - Array of current fields with their values
 ;    DEL   - Delimiter to put between entries
 ; 
 ; Output:
 ;    PARMS - Updated array which includes multiple values
 ;            combined into single entries
 ;    
 NEW NAME
 S DEL=$G(DEL,"") S:DEL="" DEL=", "
 S NAME="" F  S NAME=$O(PARMS(NAME)) Q:NAME=""  D
 . NEW VAL,VALS
 . S VAL="",VALS=""
 . F  S VAL=$O(PARMS(NAME,VAL)) Q:VAL=""  S VALS=VALS_VAL_$S($G(PARMS(NAME,VAL))]"":PARMS(NAME,VAL),1:DEL) K PARMS(NAME,VAL)
 . S VALS=$$TKO^BQIUL1(VALS,DEL)
 . S PARMS(NAME)=VALS
 ;
 Q
 ;
FPARMS(FPARMS) ;EP - Convert multiple filter values into single value
 ;
 ; Input:
 ;    FPARMS - Array of current fields with their values
 ; 
 ; Output:
 ;    FPARMS - Updated array which includes multiple values
 ;            combined into single entries
 ;
 NEW NAME,PORD
 S PORD="" F  S PORD=$O(FPARMS(PORD)) Q:PORD=""  D
 . S NAME="" F  S NAME=$O(FPARMS(PORD,NAME)) Q:NAME=""  D
 .. NEW VAL,VALS,DLM
 .. S VAL="",VALS=""
 .. F  S VAL=$O(FPARMS(PORD,NAME,VAL)) Q:VAL=""  S VALS=VALS_VAL_$S($G(FPARMS(PORD,NAME,VAL))]"":FPARMS(PORD,NAME,VAL),1:", ") K FPARMS(PORD,NAME,VAL)
 .. F DLM=", "," AND "," OR " S VALS=$$TKO^BQIUL1(VALS,DLM)
 .. S FPARMS(PORD,NAME)=VALS
 ;
 Q
