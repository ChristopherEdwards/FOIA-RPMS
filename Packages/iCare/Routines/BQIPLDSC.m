BQIPLDSC ;PRXM/HC/ALA-Panel Description Utility ; 19 Jan 2006  1:28 PM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
 ;
 Q
 ;
AGE ; Format FPARMS("AGE") or FMPARMS("AGE")
 ; Added the following line to replace the subsequent code for PR_0124
 I $D(FPARMS("AGE")) D  Q
 . N AGE,EXT,OP
 . S AGE=FPARMS("AGE")
 . S EXT=$S($E(AGE)="'":2,1:1),OP=$E(AGE,1,EXT),AGE=$E(AGE,EXT+1,99)
 . S AGE=$S(OP="=":AGE,OP=">":"older than "_AGE,OP="<":"younger than "_AGE,OP="'<":AGE_" or older",1:AGE_" or younger")
 . I AGE["YRS" S AGE=$P(AGE,"YRS")_" years"_$P(AGE,"YRS",2,99)
 . I AGE["MOS" S AGE=$P(AGE,"MOS")_" months"_$P(AGE,"MOS",2,99)
 . I AGE["DYS" S AGE=$P(AGE,"DYS")_" days"_$P(AGE,"DYS",2,99)
 . S FPARMS("AGE")=AGE
 N AGE,AGE1,AGE2,I
 S AGE1=$O(FMPARMS("AGE","")) Q:AGE1=""
 S AGE2=$O(FMPARMS("AGE",AGE1)) Q:AGE2=""
 I $E(AGE1)="'" S AGE="between (inclusive) "_$E(AGE1,3,99)_" and "_$E(AGE2,3,99)
 I $E(AGE1)'="'" S AGE="younger than "_$E(AGE1,2,99)_" or older than "_$E(AGE2,2,99)
 F I=1,2 I AGE["YRS" S AGE=$P(AGE,"YRS")_" years"_$P(AGE,"YRS",2,99)
 F I=1,2 I AGE["MOS" S AGE=$P(AGE,"MOS")_" months"_$P(AGE,"MOS",2,99)
 F I=1,2 I AGE["DYS" S AGE=$P(AGE,"DYS")_" days"_$P(AGE,"DYS",2,99)
 S FPARMS("AGE")=AGE K FMPARMS("AGE")
 Q
 ;
PLIDEN ; Format FPARMS("PLIDEN") or FMPARMS("PLIDEN")
 N PLOWNR
 I $D(FPARMS("PLIDEN")) D
 . S PLOWNR=$P(FPARMS("PLIDEN"),$C(26),1),PLOWNR=$$GET1^DIQ(200,PLOWNR_",",.01,"E")
 . S FPARMS("PLIDEN")=$P(FPARMS("PLIDEN"),$C(26),2)_" "_PLOWNR
 I $D(FMPARMS("PLIDEN")) D
 . N PLIEN,PLARR
 . S PLIEN=""
 . F  S PLIEN=$O(FMPARMS("PLIDEN",PLIEN)) Q:PLIEN=""  D
 .. S PLOWNR=$P(PLIEN,$C(26),1),PLOWNR=$$GET1^DIQ(200,PLOWNR_",",.01,"E")
 .. S PLARR($P(PLIEN,$C(26),2)_" "_PLOWNR)=""
 . K FMPARMS("PLIDEN")
 . M FMPARMS("PLIDEN")=PLARR
 Q
 ;
BEN ; Format FPARMS("BEN") or FMPARMS("BEN")
 Q  ;Disabled
 I $D(FPARMS("BEN")) D
 . S FPARMS("BEN")=$$GET1^DIQ(9999999.25,FPARMS("BEN")_",",.01,"E")
 I $D(FMPARMS("BEN")) D
 . N PLIEN,PLBEN
 . S PLIEN=""
 . F  S PLIEN=$O(FMPARMS("BEN",PLIEN)) Q:PLIEN=""  D
 .. S PLBEN=$$GET1^DIQ(9999999.25,PLIEN_",",.01,"E")
 .. S PLARR(PLBEN)=""
 . K FMPARMS("BEN")
 . M FMPARMS("BEN")=PLARR
 Q
 ;
REG ; Format FPARMS("REG")
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
 ;S PARMS("REG")=REGNMSP_PARMS("REG")
 Q
 ;
STAT(STAT) ;EP - Register Status
 I $G(STAT)="" Q
 I '$D(PARMS("STATUS")) S PARMS("STATUS")="  Status: "
 I PARMS("STATUS")'="  Status: " S PARMS("STATUS")=PARMS("STATUS")_", "
 S PARMS("STATUS")=PARMS("STATUS")_STAT
 Q
 ;
SCH ;EP - Scheduled Appointments
 NEW FDT,EDT,OSTAT,STAT,II
 S RFROM=$G(PARMS("RFROM")),RTHRU=$G(PARMS("RTHRU"))
 S FROM=$G(PARMS("FROM")),THRU=$G(PARMS("THRU"))
 S FDT=$S($G(RFROM)'="":RFROM,1:$G(FROM))
 S EDT=$S($G(RTHRU)'="":RTHRU,1:$G(THRU))
 S PARMS("FROM")=FDT,PARMS("THRU")=EDT
 I NAME="APTYPE" D
 . Q:VALUE=""
 . I '$D(PARMS("APTYPE")),'$D(MPARMS("APTYPE")) S VALUE=" Status "_VALUE
 I NAME="APSTAT" D
 . Q:VALUE=""
 . ; Remove comments if status description should be displayed
 . ; D TAB^BQIUTB(.OSTAT,"APSTAT")
 . ; F II=1:1 S STAT=@OSTAT@(II) Q:STAT=$C(31)  S STAT($P(STAT,U))=$P(STAT,U,2)
 . ; I $D(STAT(VALUE)) S VALUE=$P(STAT(VALUE),$C(30))
 . S VALUE=$$SCHTP(VALUE)
 . I '$D(PARMS("APSTAT")),'$D(MPARMS("APSTAT")) S VALUE=" Status "_VALUE
 . I $D(MPARMS("APSTAT"," Status "_VALUE)) S VALUE=" Status "_VALUE
 Q
 ;
SCHTP(STATUS) ;EP - Convert appointment status code to appointment type
 NEW ST,APTYPE,I,PC,VAL,TPIEN
 S VAL=STATUS
 S APTYPE=$O(^BQI(90506,PPIEN,3,"B","APTYPE","")) I APTYPE="" Q VAL
 S ST="" F  S ST=$O(^BQI(90506,PPIEN,3,APTYPE,3,"AC",ST)) Q:ST=""  D
 . F I=1:1:$L(ST,"~") S PC=$P(ST,"~",I) I PC=("APSTAT="_VAL) D  Q
 .. S TPIEN=$O(^BQI(90506,PPIEN,3,APTYPE,3,"AC",ST,""))
 .. I TPIEN'="" S VAL=$P($G(^BQI(90506,PPIEN,3,APTYPE,3,TPIEN,0)),U) S:VAL="" VAL=STATUS
 Q VAL
 ;
DXCAT ;EP - Diagnosis Category
 ; Only reformat description with designated operand
 I $G(FPARMS("DXOP"))="" Q
 ; If only a single Dx Category was identified operand is meaningless
 I '$D(FMPARMS("DXCAT")) Q
 S FPARMS("DXOP")=$S(FPARMS("DXOP")="&":", AND ",1:", OR ")
 N DX,APM
 S (DX,APM)="",FPARMS("DXCAT")=""
 F  S DX=$O(FMPARMS("DXCAT",DX)) Q:DX=""  D
 . I $D(AFMPARMS("DXCAT",DX)) D
 .. S APM=$$ADDAP^BQIPLDS1("DXCAT",DX)
 .. ;S APM=$P(APM,"(")_"(Status "_$P(APM,"(",2,99)
 . I $O(FMPARMS("DXCAT",DX))="" S FPARMS("DXCAT")=FPARMS("DXCAT")_DX_APM Q
 . S FPARMS("DXCAT")=FPARMS("DXCAT")_DX_APM_FPARMS("DXOP")
 K FMPARMS("DXCAT"),AFMPARMS("DXCAT")
 Q
 ;
NVIS ; Format FPARMS("NUMVIS") or FMPARMS("NUMVIS")
 ;
 I $D(FPARMS("NUMVIS")) D  Q
 . N NUMVIS,EXT,OP
 . I FPARMS("NUMVIS")?1N.N S FPARMS("NUMVIS")="="_FPARMS("NUMVIS") ;***Replace***
 . S NUMVIS=FPARMS("NUMVIS")
 . S EXT=$S($E(NUMVIS)="'":2,1:1),OP=$E(NUMVIS,1,EXT),NUMVIS=$E(NUMVIS,EXT+1,99)
 . S NUMVIS=$S(OP="=":NUMVIS,OP=">":"more than "_NUMVIS,OP="<":"less than "_NUMVIS,OP="'<":NUMVIS_" or more",1:NUMVIS_" or less")
 . S FPARMS("NUMVIS")=NUMVIS
 N NUMVIS,NUMVIS1,NUMVIS2,I
 S NUMVIS1=$O(FMPARMS("NUMVIS","")) Q:NUMVIS1=""
 S NUMVIS2=$O(FMPARMS("NUMVIS",NUMVIS1)) Q:NUMVIS2=""
 I $E(NUMVIS1)="'" S NUMVIS="between (inclusive) "_$E(NUMVIS1,3,99)_" and "_$E(NUMVIS2,3,99)
 I $E(NUMVIS1)'="'",$E(NUMVIS1)'="=" S NUMVIS="less than "_$E(NUMVIS1,2,99)_" or more than "_$E(NUMVIS2,2,99)
 I $G(NUMVIS)'="" S FPARMS("NUMVIS")=NUMVIS K FMPARMS("NUMVIS")
 Q
 ;
EHPL ;EP - Format EHR Personal List
 ; This is defined as a numeric field so PARMS and MPARMS are not created - data all contained in VALUE
 N EHCT,EHPLIEN,EHPL,PLVAL
 F EHCT=1:1:$L(VALUE,$C(29)) S EHPLIEN=$P(VALUE,$C(29),EHCT) Q:EHPLIEN=""  D
 . S EHPL=$$GETNAME^BEHOPTP2(EHPLIEN)
 . S PLVAL=$G(PLVAL)_EHPL_","
 S PLVAL=$$TKO^BQIUL1(PLVAL,",")
 S VALUE=PLVAL
 Q
 ;
PEN(OWNR,PLIEN,DESC) ;EP - Format Panel Generated Description
 ;
 ;Description
 ;  The panel description is based on the values of the parameters
 ;
 NEW DA,IENS,TYPE,SOURCE,PPIEN,ODESC,NDESC,PARMS,MPARMS,N,NAME,OPARMS,PTYP,VALUE
 NEW BQFIL,VAL,VALS,PDESC,FILTER
 ;
 S NDESC="",FILTER=""
 S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 S TYPE=$$GET1^DIQ(90505.01,IENS,.03,"I")
 S SOURCE=$$GET1^DIQ(90505.01,IENS,.11,"I")
 ;
 ;My Patients
 ;
 I TYPE="Y" D  Q
 . NEW FILTER,ICDEF,ICEXE,ICIEN,MPARMS,MPIEN,NAME,NDESC,PARMS,PDESC,SOURCE,VAL,VALS
 . S FILTER=""
 . ;
 . S MPIEN=0 F  S MPIEN=$O(^BQICARE(OWNR,7,MPIEN)) Q:'MPIEN  I $G(^BQICARE(OWNR,7,MPIEN,2))'="" D
 .. ;
 .. ;Pull iCare Definition Executable
 .. S ICDEF=$G(^BQICARE(OWNR,7,MPIEN,0)) Q:ICDEF=""
 .. S ICIEN=$O(^BQI(90506,"B",ICDEF,"")) Q:ICIEN=""
 .. S ICEXE=$G(^BQI(90506,ICIEN,5))
 .. ;
 .. ;Run Executable Statement
 .. I ICEXE]"" X ICEXE
 . ;
 . ;Convert Multiple Values into one Value
 . I $D(MPARMS) D
 .. S NAME=""
 .. F  S NAME=$O(MPARMS(NAME)) Q:NAME=""  D
 ... S VAL="",VALS=""
 ... F  S VAL=$O(MPARMS(NAME,VAL)) Q:VAL=""  S VALS=VALS_VAL_", "
 ... S VALS=$$TKO^BQIUL1(VALS,", ")
 ... S PARMS(NAME)=VALS
 . ;
 . ;Define Description Format
 . S NDESC="My Patients where provider |PROV| specialties are |TYPE|."
 . ;
 . ;Assemble Filter
 . I $O(^BQICARE(OWNR,1,PLIEN,15,0)) D  I $G(BMXSEC)'="" Q
 .. S FILTER=$$FILTER^BQIPLDS1(OWNR,PLIEN)
 .. I $G(BMXSEC)'="" Q
 .. I $G(NDESC)="" D FILDES(FILTER,1) Q
 .. I '$F(NDESC,"|") S DESC(1,0)=NDESC D FILDES(FILTER,2) Q
 . ;
 . ;Assemble Generated Description
 . F  Q:'$F(NDESC,"|")  D PRS
 . S DESC(1,0)=$G(PDESC) D FILDES(FILTER,2)
 . Q
 ;
 ;Manual Patients
 ;
 I TYPE="M" S DESC(1,0)="The patients who were selected manually" Q
 ;
 ;QMAN Template
 ;
 I TYPE="Q" D  Q
 . ;S DESC(1,0)="The patients who were selected by QMAN Template "_$P(^DIBT(SOURCE,0),U,1)
 . S DESC(1,0)="Search Template "_$P($G(^DIBT(SOURCE,0)),U,1)
 . I $O(^BQICARE(OWNR,1,PLIEN,15,0)) D  I $G(BMXSEC)'="" Q
 .. ;S FILTER=$$FILTER(OWNR,PLIEN,2,4)
 .. S FILTER=$$FILTER^BQIPLDS1(OWNR,PLIEN)
 .. I $G(BMXSEC)'="" Q
 .. D FILDES(FILTER,2)
 ;
 I SOURCE="" Q
 ;
 S PPIEN=$$PP^BQIDCDF(SOURCE) I PPIEN=-1 Q
 S NDESC=$$GET1^DIQ(90506,PPIEN,4,"E")
 ;
 K PARMS,MPARMS
 ;
 ; Get parameters from panel definition
 S N=0 F  S N=$O(^BQICARE(OWNR,1,PLIEN,10,N)) Q:'N  D
 . NEW DA,IENS,NAME,DESCEX,VALUE,PPIEN,PTYP
 . S DA(2)=OWNR,DA(1)=PLIEN,DA=N,IENS=$$IENS^DILF(.DA)
 . S NAME=$$GET1^DIQ(90505.02,IENS,.01,"E")
 . S PPIEN=$$PP^BQIDCDF(SOURCE)
 . I PPIEN S DESCEX=$$GET1^DIQ(90506,PPIEN,5,"I")
 . S PTYP=$$PTYP^BQIDCDF(SOURCE,NAME)
 . I PTYP="T" D
 .. S VALUE=$$GET1^DIQ(90505.02,IENS,.03,"E")
 .. S BQFIL=$$FILN^BQIDCDF(SOURCE,NAME) Q:BQFIL=""
 .. S VALUE=$$GET1^DIQ(BQFIL,VALUE,.01,"E")
 . I PTYP'="T" S VALUE=$$GET1^DIQ(90505.02,IENS,.02,"E")
 . ;
 . ;Save unformatted parameter values
 . S OPARMS(NAME)=VALUE
 . ;
 . I PTYP="D" S VALUE=$$UP^XLFSTR($$FMTE^XLFDT(VALUE,1))
 . I PTYP="R" D
 .. S VALUE=$$DATE^BQIUL1(VALUE)
 .. S VALUE=$$UP^XLFSTR($$FMTE^XLFDT(VALUE,1))
 . I VALUE'="" D  Q
 .. I $G(DESCEX)'="" X DESCEX
 .. S PARMS(NAME)=VALUE
 . I VALUE="" D
 .. Q:'$D(^BQICARE(OWNR,1,PLIEN,10,N,1))
 .. NEW MN
 .. S MN=0 F  S MN=$O(^BQICARE(OWNR,1,PLIEN,10,N,1,MN)) Q:'MN  D
 ... NEW DA,IENS,VALUE
 ... S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=N,DA=MN,IENS=$$IENS^DILF(.DA)
 ... I PTYP="T" D
 .... S VALUE=$$GET1^DIQ(90505.21,IENS,.02,"E")
 .... S BQFIL=$$FILN^BQIDCDF(SOURCE,NAME) Q:BQFIL=""
 .... S VALUE=$$GET1^DIQ(BQFIL,VALUE,.01,"E")
 ... I PTYP'="T" S VALUE=$$GET1^DIQ(90505.21,IENS,.01,"E")
 ... I VALUE'="",$G(DESCEX)'="" X DESCEX
 ... I VALUE]"" S MPARMS(NAME,VALUE)=""
 ;
 ;Special Code to Assemble Primary/Secondary Provider Information into "TYPE" node
 I $D(MPARMS("TYPE","PRIM")) D PSVST^BQIPLDS1("PRIM",$G(OPARMS("PVISITS")),$G(OPARMS("PTMFRAME")),.MPARMS)
 I $D(MPARMS("TYPE","PRSC")) D PSVST^BQIPLDS1("PRSC",$G(OPARMS("PSVISITS")),$G(OPARMS("PSTMFRAM")),.MPARMS)
 ;
 I $O(^BQICARE(OWNR,1,PLIEN,15,0)) D  I $G(BMXSEC)'="" Q
 . S FILTER=$$FILTER^BQIPLDS1(OWNR,PLIEN)
 . I $G(BMXSEC)'="" Q
 I $G(NDESC)="" D FILDES(FILTER,1) Q
 I '$F(NDESC,"|") S DESC(1,0)=NDESC D FILDES(FILTER,2) Q
 ;
 I $D(MPARMS) D
 . S NAME=""
 . F  S NAME=$O(MPARMS(NAME)) Q:NAME=""  D
 .. S VAL="",VALS=""
 .. F  S VAL=$O(MPARMS(NAME,VAL)) Q:VAL=""  S VALS=VALS_VAL_", "
 .. S VALS=$$TKO^BQIUL1(VALS,", ")
 .. S PARMS(NAME)=VALS
 ;
 S ODESC=NDESC
 F  Q:'$F(NDESC,"|")  D PRS
 S DESC(1,0)=PDESC D FILDES(FILTER,2)
 Q
 ;
PRS ;  Parse description
 S NDESC=$P(NDESC,"|",1)_$G(PARMS($P(NDESC,"|",2)))_$P(NDESC,"|",3,99)
 S PDESC=NDESC
 Q
 ;
FILDES(FILTER,ENT) ;EP - Load filter description in DESC()
 N PC
 I FILTER'="" D
 . ;S FILTER="Panel filtered by: "_FILTER
 . I '$D(ENT) S ENT=$O(DESC(""),-1)+1
 . F I=1:1:$L(FILTER,"; ") S PC=$P(FILTER,"; ",I) I PC'="" S DESC(ENT,0)=PC_"; ",ENT=ENT+1
 . S ENT=ENT-1
 . I $D(DESC(ENT,0)) S DESC(ENT,0)=$$TKO^BQIUL1(DESC(ENT,0),"; ")
 Q
 ;
MEN(OWNR,PREF) ;EP -- Format my patients preferences generated description
 ;
 ;Description
 ;  The my patients preferences description is based on the values of the parameters
 ;
 NEW DA,IENS,SOURCE,PPIEN,DESC,ODESC,NDESC,PARMS,MPARMS,N,NAME,PTYP,VALUE
 NEW BQFIL,VAL,VALS
 S DESC="",NDESC=""
 S DA(1)=OWNR,DA=PREF,IENS=$$IENS^DILF(.DA)
 S SOURCE=$$GET1^DIQ(90505.07,IENS,.01,"E")
 ;
 S PPIEN=$$PP^BQIDCDF(SOURCE) I PPIEN=-1 Q ""
 S DESC=$$GET1^DIQ(90506,PPIEN,4,"E")
 I DESC="" Q ""
 ;
 ; Get parameters from my patient definition
 S N=0 F  S N=$O(^BQICARE(OWNR,7,PREF,10,N)) Q:'N  D
 . NEW DA,IENS,NAME,VALUE
 . S DA(2)=OWNR,DA(1)=PREF,DA=N,IENS=$$IENS^DILF(.DA)
 . S NAME=$$GET1^DIQ(90505.08,IENS,.01,"E")
 . S PTYP=$$PTYP^BQIDCDF(SOURCE,NAME)
 . I PTYP="T" D
 .. S VALUE=$$GET1^DIQ(90505.08,IENS,.03,"E")
 .. S BQFIL=$$FILN^BQIDCDF(SOURCE,NAME) Q:BQFIL=""
 .. S VALUE=$$GET1^DIQ(BQFIL,VALUE,.01,"E")
 . I PTYP'="T" S VALUE=$$GET1^DIQ(90505.08,IENS,.02,"E")
 . I PTYP="D" S VALUE=$$UP^XLFSTR($$FMTE^XLFDT(VALUE,1))
 . I PTYP="R" D
 .. S VALUE=$$DATE^BQIUL1(VALUE)
 .. S VALUE=$$UP^XLFSTR($$FMTE^XLFDT(VALUE,1))
 . I NAME="SPEC",VALUE'="" D  Q:VALUE=""
 .. N SPECNM
 .. S SPECNM=$$GET1^DIQ(90360.3,VALUE,.01,"I") ;Mnemonic
 .. S VALUE=SPECNM
 . I VALUE'="" S PARMS(NAME)=VALUE Q
 . I VALUE="" D
 .. Q:'$D(^BQICARE(OWNR,7,PREF,10,N,1))
 .. NEW MN
 .. S MN=0 F  S MN=$O(^BQICARE(OWNR,7,PREF,10,N,1,MN)) Q:'MN  D
 ... NEW DA,IENS,VALUE
 ... S DA(3)=OWNR,DA(2)=PREF,DA(1)=N,DA=MN,IENS=$$IENS^DILF(.DA)
 ... I PTYP="T" D
 .... S VALUE=$$GET1^DIQ(90505.81,IENS,.02,"E")
 .... S BQFIL=$$FILN^BQIDCDF(SOURCE,NAME) Q:BQFIL=""
 .... S VALUE=$$GET1^DIQ(BQFIL,VALUE,.01,"E")
 ... I PTYP'="T" S VALUE=$$GET1^DIQ(90505.81,IENS,.01,"E")
 ... I NAME="SPEC",VALUE'="" D  Q:VALUE=""
 .... N SPECNM
 .... S SPECNM=$$GET1^DIQ(90360.3,VALUE,.01,"I") ;Mnemonic
 .... S VALUE=SPECNM
 ... S MPARMS(NAME,VALUE)=""
 ;
 I '$F(DESC,"|") Q ""
 I $D(PARMS)<10 Q ""
 ;
 I $D(MPARMS) D
 . S NAME=""
 . F  S NAME=$O(MPARMS(NAME)) Q:NAME=""  D
 .. S VAL="",VALS=""
 .. F  S VAL=$O(MPARMS(NAME,VAL)) Q:VAL=""  S VALS=VALS_VAL_", "
 .. S VALS=$$TKO^BQIUL1(VALS,", ")
 .. S PARMS(NAME)=VALS
 ;
 S ODESC=DESC,NDESC=DESC
 F  Q:'$F(NDESC,"|")  D PRS
 Q PDESC
