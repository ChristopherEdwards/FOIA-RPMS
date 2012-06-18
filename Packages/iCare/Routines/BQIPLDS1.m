BQIPLDS1 ;PRXM/HC/ALA-Panel Description Utility (cont) ; 7 Apr 2008  4:28 PM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
 ;
 Q
 ;
 ;DXCAT ;EP - Diagnosis Category
 ; Only reformat description with designated operand
 ;I $G(FPARMS("DXOP"))="" Q
 ; If only a single Dx Category was identified operand is meaningless
 ;I '$D(FMPARMS("DXCAT")) Q
 ;S FPARMS("DXOP")=$S(FPARMS("DXOP")="&":", AND ",1:", OR ")
 ;N DX,APM
 ;S (DX,APM)="",FPARMS("DXCAT")=""
 ;F  S DX=$O(FMPARMS("DXCAT",DX)) Q:DX=""  D
 ;. I $D(AFMPARMS("DXCAT",DX)) D
 ;.. S APM=$$ADDAP("DXCAT",DX)
 ;. I $O(FMPARMS("DXCAT",DX))="" S FPARMS("DXCAT")=FPARMS("DXCAT")_DX_APM Q
 ;. S FPARMS("DXCAT")=FPARMS("DXCAT")_DX_APM_FPARMS("DXOP")
 ;K FMPARMS("DXCAT"),AFMPARMS("DXCAT")
 ;Q
 ;
FILTER(OWNR,PLIEN) ;EP - Include filter description
 ;
 ; Retrieve all filters for this panel and return as a string in filter order
 ; as defined in the ICARE DEFINITIONS file (90506.03,.1)
 ;
 N DA,FIENS,FSOURCE,FIEN,FN,FPARMS,FMPARMS,FILTER
 N AFILTER,AP,AFPARMS,AFMPARMS,MAP
 S DA(1)=OWNR,DA=PLIEN,FIENS=$$IENS^DILF(.DA)
 S FSOURCE=$$GET1^DIQ(90505.01,FIENS,.14,"E")
 ; if there is no filter source, the filter may have been turned off
 I FSOURCE="" Q ""
 S FIEN=$$PP^BQIDCDF(FSOURCE) ; Filter ien
 I FIEN=-1 S BMXSEC="Filter SOURCE was not found" Q ""
 ; Get filters from panel definition
 S FN=0 F  S FN=$O(^BQICARE(OWNR,1,PLIEN,15,FN)) Q:'FN  D
 . NEW DA,IENS,FNAME,VALUE,BQFIL
 . S DA(2)=OWNR,DA(1)=PLIEN,DA=FN,IENS=$$IENS^DILF(.DA)
 . S FNAME=$$GET1^DIQ(90505.115,IENS,.01,"E") Q:FNAME=""  S FILTER(FNAME)=""
 . S PTYP=$$PTYP^BQIDCDF(FSOURCE,FNAME)
 . S VALUE=$$GVAL(PTYP,90505.115,IENS,FSOURCE,FNAME)
 . I VALUE'="" D  Q
 .. S FPARMS(FNAME)=VALUE
 .. ; Retrieve associated parameters
 .. ; Single associated parameter
 .. S AP=0
 .. F  S AP=$O(^BQICARE(OWNR,1,PLIEN,15,FN,2,AP)) Q:'AP  D
 ... NEW DA,IENS,APNAME,AVALUE,APTYP
 ... S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=FN,DA=AP,IENS=$$IENS^DILF(.DA)
 ... S APNAME=$$GET1^DIQ(90505.1152,IENS,.01,"E") Q:APNAME=""  S AFILTER(FNAME,APNAME)=""
 ... S APTYP=$$PTYP^BQIDCDF(FSOURCE,APNAME)
 ... S AVALUE=$$GVAL(APTYP,90505.1152,IENS,FSOURCE,APNAME)
 ... I $T(@(APNAME))'="" D @APNAME
 ... I AVALUE'="" S AFPARMS(FNAME,VALUE,APNAME)=AVALUE
 ... I AVALUE="" D
 .... Q:'$D(^BQICARE(OWNR,1,PLIEN,15,FN,2,AP,1))
 .... ; Multiple associated parameter
 .... S MAP=0
 .... F  S MAP=$O(^BQICARE(OWNR,1,PLIEN,15,FN,2,AP,1,MAP)) Q:'MAP  D
 ..... NEW DA,IENS
 ..... S DA(4)=OWNR,DA(3)=PLIEN,DA(2)=FN,DA(1)=AP,DA=MAP,IENS=$$IENS^DILF(.DA)
 ..... S AVALUE=$$GET1^DIQ(90505.11521,IENS,.01,"E")
 ..... I $T(@(APNAME))'="" D @APNAME
 ..... I AVALUE'="" S AFPARMS(FNAME,VALUE,APNAME,AVALUE)=""
 . I VALUE="" D
 .. Q:'$D(^BQICARE(OWNR,1,PLIEN,15,FN,1))
 .. NEW MN
 .. S MN=0 F  S MN=$O(^BQICARE(OWNR,1,PLIEN,15,FN,1,MN)) Q:'MN  D
 ... NEW DA,IENS,VALUE,BQFIL
 ... S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=FN,DA=MN,IENS=$$IENS^DILF(.DA)
 ... S VALUE=$$GMVAL(PTYP,90505.1151,IENS,FSOURCE,FNAME)
 ... I VALUE'="" S FMPARMS(FNAME,VALUE)=""
 ... ; Retrieve associated parameters
 ... ; Single associated parameter
 ... S AP=0
 ... F  S AP=$O(^BQICARE(OWNR,1,PLIEN,15,FN,1,MN,2,AP)) Q:'AP  D
 .... NEW DA,IENS,APNAME,AVALUE,APTYP
 .... S DA(4)=OWNR,DA(3)=PLIEN,DA(2)=FN,DA(1)=MN,DA=AP,IENS=$$IENS^DILF(.DA)
 .... S APNAME=$$GET1^DIQ(90505.11512,IENS,.01,"E") Q:APNAME=""  S AFILTER(FNAME,APNAME)=""
 .... S APTYP=$$PTYP^BQIDCDF(FSOURCE,APNAME)
 .... S AVALUE=$$GVAL(APTYP,90505.11512,IENS,FSOURCE,APNAME)
 .... I $T(@(APNAME))'="" D @APNAME
 .... I AVALUE'="" S AFMPARMS(FNAME,VALUE,APNAME,AVALUE)=""
 .... I AVALUE="" D
 ..... Q:'$D(^BQICARE(OWNR,1,PLIEN,15,FN,1,MN,2,AP,1))
 ..... ; Multiple associated parameter
 ..... S MAP=0
 ..... F  S MAP=$O(^BQICARE(OWNR,1,PLIEN,15,FN,1,MN,2,AP,1,MAP)) Q:'MAP  D
 ...... NEW DA,IENS
 ...... S DA(5)=OWNR,DA(4)=PLIEN,DA(3)=FN,DA(2)=MN,DA(1)=AP,DA=MAP,IENS=$$IENS^DILF(.DA)
 ...... S AVALUE=$$GET1^DIQ(90505.115121,IENS,.01,"E")
 ...... I $T(@(APNAME))'="" D @APNAME
 ...... I AVALUE'="" S AFMPARMS(FNAME,VALUE,APNAME,AVALUE)=""
 ; Load description and executable code
 N X,DIC,Y,FX,FDES,FORD,FDESC,DA,IENS
 S FNAME="",FDESC=""
 F  S FNAME=$O(FILTER(FNAME)) Q:FNAME=""  D
 . S X=FNAME,DIC(0)="NZ",DIC="^BQI(90506,"_FIEN_",3," D ^DIC
 . Q:Y<0  S DA=$P(Y,"^"),DA(1)=FIEN,IENS=$$IENS^DILF(.DA)
 . S FX=$$GET1^DIQ(90506.03,IENS,2,"I")
 . I FX'="" X FX
 . S FDES=$$GET1^DIQ(90506.03,IENS,4,"I")
 . S FORD=$$GET1^DIQ(90506.03,IENS,.1,"I")
 . Q:FORD=""
 . I FDES'="" S FDES(FORD)=FDES
 S FORD="" F  S FORD=$O(FDES(FORD)) Q:FORD=""  S FDESC=FDESC_FDES(FORD)_"; "
 ;S FDESC=$E(FDESC,1,$L(FDESC)-2) ; Remove trailing "; "
 S FDESC=$$TKO^BQIUL1(FDESC,"; ")
 I $D(AFPARMS) D
 . N CAT,AVAL,TP,VALS,FDSC
 . S CAT=""
 . F  S CAT=$O(FPARMS(CAT)) Q:CAT=""  I FPARMS(CAT)'="",$D(AFPARMS(CAT,FPARMS(CAT))) D
 .. S TP=""
 .. F  S TP=$O(AFPARMS(CAT,FPARMS(CAT),TP)) Q:TP=""  D
 ... S AVAL="",VALS=$$GDSC(TP,FIEN)
 ... F  S AVAL=$O(AFPARMS(CAT,FPARMS(CAT),TP,AVAL)) Q:AVAL=""  D
 .... S VALS=VALS_AVAL_", "
 ... S VALS=$$TKO^BQIUL1(VALS,", ")
 .. I VALS'="" S FPARMS(CAT)=FPARMS(CAT)_" ("_VALS_")"
 I $D(FMPARMS) D
 . S FNAME=""
 . F  S FNAME=$O(FMPARMS(FNAME)) Q:FNAME=""  D
 .. S VAL="",VALS=""
 .. F  S VAL=$O(FMPARMS(FNAME,VAL)) Q:VAL=""  D
 ... S VALS=VALS_VAL_$$ADDAP(FNAME,VAL)_", "
 .. S VALS=$$TKO^BQIUL1(VALS,", ")
 .. S FPARMS(FNAME)=VALS
 I FDESC["|" D
 . F  S FDESC=$P(FDESC,"|",1)_$G(FPARMS($P(FDESC,"|",2)))_$P(FDESC,"|",3,99) Q:FDESC'["|"
 I FDESC'="" S FDESC=$$TKO^BQIUL1(FDESC,", ")
 Q FDESC
 ;
GVAL(PTYP,FILN,IENS,SRC,NM) ; EP - Get value of parameter/filter
 N VALUE,BQFIL
 I PTYP="T" D
 . S VALUE=$$GET1^DIQ(FILN,IENS,.03,"E")
 . S BQFIL=$$FILN^BQIDCDF(SRC,NM) Q:BQFIL=""
 . S VALUE=$$GET1^DIQ(BQFIL,VALUE,.01,"E")
 I PTYP'="T" S VALUE=$$GET1^DIQ(FILN,IENS,.02,"E")
 I PTYP="D" S VALUE=$$UP^XLFSTR($$FMTE^XLFDT(VALUE,1))
 I PTYP="R" D
 . S VALUE=$$DATE^BQIUL1(VALUE)
 . S VALUE=$$UP^XLFSTR($$FMTE^XLFDT(VALUE,1))
 Q VALUE
 ;
GMVAL(PTYP,FILN,IENS,SRC,NM) ; EP - Get value for multiples
 N VALUE,BQFIL
 I PTYP="T" D
 . S VALUE=$$GET1^DIQ(FILN,IENS,.02,"E")
 . S BQFIL=$$FILN^BQIDCDF(SRC,NM) Q:BQFIL=""
 . S VALUE=$$GET1^DIQ(BQFIL,VALUE,.01,"E")
 I PTYP'="T" S VALUE=$$GET1^DIQ(FILN,IENS,.01,"E")
 Q VALUE
 ;
GDSC(CAT,FIEN) ; EP - Get filter description
 N X,DIC,Y,DA,IENS
 S X=CAT,DIC(0)="NZ",DIC="^BQI(90506,"_FIEN_",3," D ^DIC
 I Y<0 Q ""
 S DA=$P(Y,"^"),DA(1)=FIEN,IENS=$$IENS^DILF(.DA)
 S FDSC=$$GET1^DIQ(90506.03,IENS,.09,"I")
 I FDSC'="" S FDSC=FDSC_" "
 Q FDSC
 ;
ADDAP(FNM,VALUE) ; EP - Return associated parameters text for multiple filter
 N TP,AVAL,VALS
 S (TP,VALS)=""
 F  S TP=$O(AFMPARMS(FNM,VALUE,TP)) Q:TP=""  D
 . S VALS=VALS_" ("_$$GDSC(TP,FIEN),AVAL="" D
 .. F  S AVAL=$O(AFMPARMS(FNM,VALUE,TP,AVAL)) Q:AVAL=""  D
 ... S VALS=VALS_AVAL_", "
 .. S VALS=$$TKO^BQIUL1(VALS,", ")_")"
 Q VALS
 ;
DXSTAT ; EP - Translate code to description for dx tag statuses
 S AVALUE=$S(AVALUE="A":"Accepted",AVALUE="P":"Proposed",AVALUE="N":"Not Accepted",AVALUE="V":"No Longer Valid",AVALUE="S":"Superseded",1:"")
 Q
 ;
MYPT(OWNR,MPIEN,ICDEF,PARMS,MPARMS) ;EP - Set up My Patients - System Generated Description
 ;
 ;Description: This tag gets called by DESCRIPTION EXECUTABLE code in 90506. The process is
 ;             started from PEN^BQIPLDSC. It sets up the single field PARMS array and the
 ;             multiple field MPARMS array with information found in the file 90505, node 7.
 ;
 ;Parameters:
 ;   OWNR = Owner
 ;  MPIEN = File 90505, Node 7 IEN
 ;  ICDEF = ICARE DEFINITIONS Name
 ;  PARMS = Array of Fields and Values (Updated By This Tag)
 ; MPARMS = Array of Multiple Fields and Values (Updated By This Tag)
 ;
 NEW DA,IENS,N,SOURCE
 S SOURCE="PATIENTS ASSIGNED TO" ;Use the field defs from PATIENTS ASSIGNED TO since they are the same
 S N=0 F  S N=$O(^BQICARE(OWNR,7,MPIEN,10,N)) Q:'N  D
 . NEW DA,IENS,NAME,DESCEX,VALUE,PPIEN,PTYP,BQFIL
 . S DA(2)=OWNR,DA(1)=MPIEN,DA=N,IENS=$$IENS^DILF(.DA)
 . S NAME=$$GET1^DIQ(90505.08,IENS,.01,"E")
 . ;
 . S PPIEN=$$PP^BQIDCDF(SOURCE)
 . I PPIEN S DESCEX=$$GET1^DIQ(90506,PPIEN,5,"I")
 . S PTYP=$$PTYP^BQIDCDF(SOURCE,NAME)
 . I PTYP="T" D
 .. S VALUE=$$GET1^DIQ(90505.08,IENS,.03,"E")
 .. S BQFIL=$$FILN^BQIDCDF(SOURCE,NAME) Q:BQFIL=""
 .. S VALUE=$$GET1^DIQ(BQFIL,VALUE,.01,"E")
 . I PTYP'="T" S VALUE=$$GET1^DIQ(90505.08,IENS,.02,"E")
 . ;
 . ;Save Provider
 . I NAME="PROV" D  Q
 .. I '$D(PARMS("PROV")) S PARMS("PROV")=VALUE
 . ;
 . ;Save Single-Stored Specialty
 . I NAME="SPEC",VALUE'="",$G(DESCEX)'="" X DESCEX
 . ;
 . ;Handle Multiple Fields
 . I VALUE="",$D(^BQICARE(OWNR,7,MPIEN,10,N,1)) D  Q
 .. ;
 .. NEW MN
 .. S MN=0 F  S MN=$O(^BQICARE(OWNR,7,MPIEN,10,N,1,MN)) Q:'MN  D
 ... NEW DA,IENS,VALUE
 ... S DA(3)=OWNR,DA(2)=MPIEN,DA(1)=N,DA=MN,IENS=$$IENS^DILF(.DA)
 ... I PTYP="T" D
 .... S VALUE=$$GET1^DIQ(90505.81,IENS,.02,"E")
 .... S BQFIL=$$FILN^BQIDCDF(SOURCE,NAME) Q:BQFIL=""
 .... S VALUE=$$GET1^DIQ(BQFIL,VALUE,.01,"E")
 ... I PTYP'="T" S VALUE=$$GET1^DIQ(90505.81,IENS,.01,"E")
 ... I VALUE'="",$G(DESCEX)'="" X DESCEX
 ... S MPARMS(NAME,VALUE)=""
 . ;
 . ;Save Single fields
 . S PARMS(NAME)=VALUE
 ;
 I $D(PARMS("VISITS")),$D(PARMS("TMFRAME")) D
 . I ICDEF="MY PATIENTS-PRIMARY" D PSVST("PRIM",$G(PARMS("VISITS")),$G(PARMS("TMFRAME")),.MPARMS)
 . I ICDEF="MY PATIENTS-PRIMARY/SECONDARY" D PSVST("PRSC",$G(PARMS("VISITS")),$G(PARMS("TMFRAME")),.MPARMS)
 . K PARMS("VISITS"),PARMS("TMFRAME")
 Q
 ;
SPEC ;EP - Format Specialty provider
 I NAME'="SPEC" Q
 I VALUE="" Q
 N SPECNM
 S SPECNM=$$GET1^DIQ(90360.3,VALUE,.01,"I")
 I SPECNM="" Q
 ;
 ;Save each Specialty name in the "TYPE" node so it gets included in the
 ;generated description. The "SPEC" entry also needs removed so it doesn't show
 ;up as well.
 K:$D(MPARMS("TYPE","SPEC")) MPARMS("TYPE","SPEC")
 S MPARMS("TYPE",SPECNM)=""
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
 ;Remove Existing Entry
 K BQIMPRM("TYPE",BQITYPE)
 ;
 ;Assemble Visit Check Description
 S STR=$S(BQITYPE="PRIM":"PRIMARY VISIT PROVIDER",1:"Primary/Secondary Visit provider")
 S STR=STR_" "_BQIVST_$S(BQIVST>1:" visits",1:" visit")
 S STR=STR_" in "_$S(BQITIME="T-24M":"2 YRS",BQITIME="T-12M":"1 YR",1:$P(BQITIME,"T-",2))
 ;
 ;Save New Entry With Visit Check Description
 S BQIMPRM("TYPE",STR)=""
 Q
