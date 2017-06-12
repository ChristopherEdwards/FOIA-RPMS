BQIPDSCF ;VNGT/HS/BEE-Panel Description Utility ; 7 Apr 2008  4:28 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
FILTER(OWNR,PLIEN,FPARMS) ;EP - Include filter description
 ;
 ; Retrieve all filters for this panel and return as a string in filter order
 ; as defined in the ICARE DEFINITIONS file (90506.03,.1)
 ;
 N DA,FIEN,FIENS,FSOURCE,FN,MN
 ;
 S DA(1)=OWNR,DA=PLIEN,FIENS=$$IENS^DILF(.DA)
 S FSOURCE=$$GET1^DIQ(90505.01,FIENS,.14,"E")
 ;
 ;Quit if filter turned off
 I FSOURCE="" Q ""
 ;
 S FIEN=$$PP^BQIDCDF(FSOURCE) ; Filter ien
 I FIEN=-1 S BMXSEC="Filter SOURCE was not found" Q ""
 ;
 ;Get each filter from panel definition
 S FN=0 F  S FN=$O(^BQICARE(OWNR,1,PLIEN,15,FN)) Q:'FN  D
 . NEW DA,IENS,FNAME,VALUE,PEXE,PTYP,PORD,VALUE,ASTR,PMAP,OFNAME
 . S DA(2)=OWNR,DA(1)=PLIEN,DA=FN,IENS=$$IENS^DILF(.DA)
 . S (OFNAME,FNAME)=$$GET1^DIQ(90505.115,IENS,.01,"E") Q:FNAME=""
 . S PTYP=$$PTYP^BQIDCDF(FSOURCE,FNAME) Q:PTYP=""
 . S PORD=$$PORD^BQIDCDF(FSOURCE,FNAME) Q:PORD=""
 . S VALUE=$$GVAL(PTYP,90505.115,IENS,FSOURCE,FNAME)
 . ;
 . ;Pull associate parameters
 . S ASTR=$$ASPARM(FN)
 . ;
 . ;Call any defined executable
 . S PMAP=$$PMAP^BQIDCDF(FSOURCE,FNAME) I VALUE]"",PMAP]"" D MAP^BQIPDSCM(FSOURCE,PMAP,.VALUE,.FNAME)
 . S PEXE=$$PEXE^BQIDCDF(FSOURCE,FNAME) I VALUE]"",PEXE]"" X PEXE
 . ;
 . ;Save single value
 . I VALUE]"" D  Q
 .. I $G(ASTR)="",FNAME="LAB",$G(VALUE)'="",VALUE["^" S VALUE=$P(VALUE,"^",1)
 .. I $G(ASTR)'="" D
 ... NEW RES
 ... I ASTR["NUMLAB" D
 .... S RES=$P(VALUE,U,2),VALUE=$P(VALUE,U,1)
 .... S VALUE=VALUE_" is"_$$LBRS^BQIPDSC1(ASTR)
 ... I ASTR["SETLAB" D
 .... S RES=$P(VALUE,U,2),VALUE=$P(VALUE,U,1),ASTR=$P(ASTR,"SETLAB",2)
 .... NEW LVAL,NVAL
 .... S VALUE=VALUE_" is "
 .... S ASTR=$TR(ASTR,$C(28),""),NVAL=$L(ASTR,$C(29))
 .... F I=1:1:NVAL S LVAL=$P(ASTR,$C(29),I) I LVAL'="" S VALUE=VALUE_$$SCD^BQIUL2(RES,LVAL)_$S(NVAL>1:" or ",1:"")
 ... S VALUE=$$TKO^BQIUL1(VALUE," or ")
 .. S FPARMS(PORD,FNAME,$$TRUNC^BQIPDSCM(VALUE))=""
 . ;
 . ;Save multiple values
 . S MN=0 F  S MN=$O(^BQICARE(OWNR,1,PLIEN,15,FN,1,MN)) Q:'MN  D
 .. NEW DA,IENS,VALUE
 .. S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=FN,DA=MN,IENS=$$IENS^DILF(.DA)
 .. S FNAME=OFNAME
 .. S VALUE=$$GMVAL(PTYP,90505.1151,IENS,FSOURCE,FNAME)
 .. ;
 .. ;Pull associate parameters
 .. S ASTR=$$ASMPARM(MN)
 .. ;
 .. ;Call any defined executable
 .. I VALUE]"",PMAP]"" D MAP^BQIPDSCM(FSOURCE,PMAP,.VALUE,.FNAME)
 .. I VALUE]"",PEXE]"" X PEXE
 .. ;
 .. ;Save multiple value
 .. I VALUE]"" D
 ... I $G(ASTR)="",FNAME="LAB",$G(VALUE)'="",VALUE["^" S VALUE=$P(VALUE,"^",1)
 ... I $G(ASTR)'="" D
 .... NEW RES
 .... I ASTR["NUMLAB" D
 ..... S RES=$P(VALUE,U,2),VALUE=$P(VALUE,U,1)
 ..... S VALUE=VALUE_" is"_$$LBRS^BQIPDSC1(ASTR)
 .... I ASTR["SETLAB" D
 ..... S RES=$P(VALUE,U,2),VALUE=$P(VALUE,U,1),ASTR=$P(ASTR,"SETLAB",2)
 ..... S VALUE=VALUE_" is "
 ..... NEW LVAL,NVAL
 ..... S ASTR=$TR(ASTR,$C(28),""),NVAL=$L(ASTR,$C(29))
 ..... F I=1:1:NVAL S LVAL=$P(ASTR,$C(29),I) I LVAL'="" S VALUE=VALUE_$$SCD^BQIUL2(RES,LVAL)_$S(NVAL>1:" or ",1:"")
 .... S VALUE=$$TKO^BQIUL1(VALUE," or ")
 ... S FPARMS(PORD,FNAME,$$TRUNC^BQIPDSCM(VALUE))=""
 Q
 ;
GVAL(PTYP,FILN,IENS,SRC,NM) ; EP - Get value of parameter/filter
 N VALUE,BQFIL,PEXE,LABR
 ;
 ;Table
 I PTYP="T" D
 . S VALUE=$$GET1^DIQ(FILN,IENS,.03,"E")
 . I VALUE[";" D  Q
 .. NEW PGL
 .. S PGL="^"_$P(VALUE,";",2),PGL=$$TKO^BQIUL1(PGL,"(")
 .. S VALUE=$P(@PGL@($P(VALUE,";",1),0),U,1)
 . S BQFIL=$$FILN^BQIDCDF(SRC,NM) Q:BQFIL=""
 . I NM="LAB",VALUE'="" S LABR=$$LSET^BQIDCAH3(VALUE)
 . S VALUE=$$GET1^DIQ(BQFIL,VALUE_",",.01,"E")
 ;
 ;Non-table
 I PTYP'="T" S VALUE=$$GET1^DIQ(FILN,IENS,.02,"E")
 I PTYP="D" S VALUE=$$UP^XLFSTR($$FMTE^XLFDT(VALUE,1))
 I PTYP="R" D
 . ;No longer needs converted
 . ;S VALUE=$$DATE^BQIUL1(VALUE)
 . ;S VALUE=$$UP^XLFSTR($$FMTE^XLFDT(VALUE,1))
 ;
 Q VALUE_$S($G(LABR)'="":"^"_LABR,1:"")
 ;
ASPARM(FN) ;EP - Retrieve associated parameters from single value field
 NEW AP,APRM,ASTR
 ;First look for single value parameter
 S AP=0
 F  S AP=$O(^BQICARE(OWNR,1,PLIEN,15,FN,2,AP)) Q:'AP  D
 . NEW DA,IENS,APNAME,AVALUE,APTYP
 . S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=FN,DA=AP,IENS=$$IENS^DILF(.DA)
 . S APNAME=$$GET1^DIQ(90505.1152,IENS,.01,"E") Q:APNAME=""
 . S APTYP=$$PTYP^BQIDCDF(FSOURCE,APNAME)
 . S AVALUE=$$GVAL(APTYP,90505.1152,IENS,FSOURCE,APNAME)
 . I AVALUE'="" S APRM(APNAME)=AVALUE
 . ;
 . ;Now try looking for multi value parameter
 . I AVALUE="" D
 .. NEW MAP
 .. S MAP=0
 .. F  S MAP=$O(^BQICARE(OWNR,1,PLIEN,15,FN,2,AP,1,MAP)) Q:'MAP  D
 ... NEW DA,IENS,AVAL
 ... S DA(4)=OWNR,DA(3)=PLIEN,DA(2)=FN,DA(1)=AP,DA=MAP,IENS=$$IENS^DILF(.DA)
 ... S AVAL=$$GET1^DIQ(90505.11521,IENS,.01,"E")
 ... S AVAL=$$GMVAL(APTYP,90505.11521,IENS,FSOURCE,APNAME)
 ... I AVAL'="" S AVALUE=AVALUE_$S(AVALUE="":"",1:$C(29))_AVAL
 .. S:AVALUE]"" APRM(APNAME)=AVALUE
 S ASTR=""
 S APRM="" F  S APRM=$O(APRM(APRM)) Q:APRM=""  D
 . ;
 . ;Form associate string
 . S ASTR=ASTR_$S(ASTR="":"",1:$C(26))_APRM_$C(28)_APRM(APRM)
 Q ASTR
 ;
ASMPARM(MN) ;EP - Retrieve associated parameters from multiple value field
 NEW AP,APRM,ASTR
 ;First look for single value parameter
 S AP=0
 F  S AP=$O(^BQICARE(OWNR,1,PLIEN,15,FN,1,MN,2,AP)) Q:'AP  D
 . NEW DA,IENS,APNAME,AVALUE,APTYP
 . S DA(4)=OWNR,DA(3)=PLIEN,DA(2)=FN,DA(1)=MN,DA=AP,IENS=$$IENS^DILF(.DA)
 . S APNAME=$$GET1^DIQ(90505.11512,IENS,.01,"E") Q:APNAME=""
 . S APTYP=$$PTYP^BQIDCDF(FSOURCE,APNAME)
 . S AVALUE=$$GVAL(APTYP,90505.11512,IENS,FSOURCE,APNAME)
 . I AVALUE'="" S APRM(APNAME)=AVALUE
 . ;Now try looking for multi value parameter
 . I AVALUE="" D
 .. NEW MAP
 .. S MAP=0
 .. F  S MAP=$O(^BQICARE(OWNR,1,PLIEN,15,FN,1,MN,2,AP,1,MAP)) Q:'MAP  D
 ... NEW DA,IENS,AVAL
 ... S DA(5)=OWNR,DA(4)=PLIEN,DA(3)=FN,DA(2)=MN,DA(1)=AP,DA=MAP,IENS=$$IENS^DILF(.DA)
 ... S AVAL=$$GET1^DIQ(90505.115121,IENS,.01,"E")
 ... S AVAL=$$GMVAL(APTYP,90505.115121,IENS,FSOURCE,APNAME)
 ... I AVAL'="" S AVALUE=AVALUE_$S(AVALUE="":"",1:$C(29))_AVAL
 .. S:AVALUE]"" APRM(APNAME)=AVALUE
 S ASTR=""
 S APRM="" F  S APRM=$O(APRM(APRM)) Q:APRM=""  D
 . ;Form associate string
 . S ASTR=ASTR_$S(ASTR="":"",1:$C(26))_APRM_$C(28)_APRM(APRM)
 Q ASTR
 ;
GMVAL(PTYP,FILN,IENS,SRC,NM) ; EP - Get value for multiples
 N VALUE,BQFIL,LABR
 I PTYP="T" D
 . S VALUE=$$GET1^DIQ(FILN,IENS,.02,"E")
 . S BQFIL=$$FILN^BQIDCDF(SRC,NM) Q:BQFIL=""
 . I NM="LAB",VALUE'="" S LABR=$$LSET^BQIDCAH3(VALUE)
 . S VALUE=$$GET1^DIQ(BQFIL,VALUE,.01,"E")
 I PTYP'="T" S VALUE=$$GET1^DIQ(FILN,IENS,.01,"E")
 Q VALUE_$S($G(LABR)'="":"^"_LABR,1:"")
 ;
NVIS(PORD,VALUE,ASTR) ;EP - Assemble number of visits
 NEW I,CLIN,PROV,STR,N1,N2,FND,V,VAL
 S ASTR=$G(ASTR,"")
 S (CLIN,PROV)=""
 F I=1:1:$L($G(ASTR),$C(26)) D
 . NEW FINFO,FNAME,FVAL,NVAL,PC
 . S FINFO=$P(ASTR,$C(26),I)
 . S FNAME=$P(FINFO,$C(28)) Q:FNAME=""
 . S FVAL=$P(FINFO,$C(28),2) Q:FVAL=""
 . S NVAL=""
 . F PC=1:1:$L(FVAL,$C(29)) D
 .. S VAL=$P(FVAL,$C(29),PC) S:VAL]"" NVAL=NVAL_$S(NVAL]"":", ",1:"")_VAL
 . I FNAME]"",NVAL]"" S @FNAME=NVAL
 ;
 ;Get visit number(s)
 S (N1,FND)="" F I=1:1:$L(VALUE) Q:(FND=1&($E(VALUE,I)'?1N))  I $E(VALUE,I)?1N S N1=N1_$E(VALUE,I),FND=1
 Q:N1=""
 S (N2,FND)="" I I<$L(VALUE) F I=I:1:$L(VALUE) Q:(FND=1&($E(VALUE,I)'?1N))  I $E(VALUE,I)?1N S N2=N2_$E(VALUE,I),FND=1
 ;
 S STR="# of Visits"
 I CLIN]"" S STR=STR_" in clinic "_CLIN
 I PROV]"" S STR=STR_" for provider "_PROV
 ;
 S V=VALUE
 I V["~",V["'" S STR=STR_" in range (inclusive) "_N1_" thru "_N2
 E  I V["~" S STR=STR_" out of range (exclusive) less than "_N1_" or greater than "_N2
 E  I V["'<" S STR=STR_" greater than or equal to "_N1
 E  I V["'>" S STR=STR_" less than or equal to "_N1
 E  I V["<" S STR=STR_" less than "_N1
 E  I V[">" S STR=STR_" greater than "_N1
 E  S STR=STR_" equal to "_N1
 S VALUE=STR
 Q
 ;
DLM(FPARMS,FLD) ;EP - Determine delimiter between multiple entries
 NEW PORD,FND,FNAME,FENT
 S (FND,PORD)="" F  S PORD=$O(FPARMS(PORD)) Q:'PORD  S FNAME="" F  S FNAME=$O(FPARMS(PORD,FNAME)) Q:FNAME=""  I FNAME=FLD D  Q
 . S FENT="" F  S FENT=$O(FPARMS(PORD,FNAME,FENT)) Q:FENT=""  D
 .. S FPARMS(PORD,FNAME,FENT)=$S($G(VALUE)="&":" AND ",1:" OR ")
 Q
 ;
AGE ; Format FPARMS("AGE") or FMPARMS("AGE")
 NEW AGE,EXT,OP,AGE1,AGE2
 I '$D(FPARMS(PORD,"AGE")) D  Q
 . S AGE=$G(VALUE)
 . S EXT=$S($E(AGE)="'":2,1:1),OP=$E(AGE,1,EXT),AGE=$E(AGE,EXT+1,99)
 . S AGE=$S(OP="=":AGE,OP=">":"older than "_AGE,OP="<":"younger than "_AGE,OP="'<":AGE_" or older",1:AGE_" or younger")
 . I AGE["YRS" S AGE=$P(AGE,"YRS")_" years"_$P(AGE,"YRS",2,99)
 . I AGE["MOS" S AGE=$P(AGE,"MOS")_" months"_$P(AGE,"MOS",2,99)
 . I AGE["DYS" S AGE=$P(AGE,"DYS")_" days"_$P(AGE,"DYS",2,99)
 . S VALUE=AGE
 ;
 ;Two Age values - must be exclusive or inclusive
 S AGE2=$G(VALUE)
 S EXT=$S($E(AGE2)="'":2,1:1),OP=$E(AGE2,1,EXT),AGE2=$E(AGE2,EXT+1,99)
 I AGE2["YRS" S AGE2=$P(AGE2,"YRS")_" years"_$P(AGE2,"YRS",2,99)
 I AGE2["MOS" S AGE2=$P(AGE2,"MOS")_" months"_$P(AGE2,"MOS",2,99)
 I AGE2["DYS" S AGE2=$P(AGE2,"DYS")_" days"_$P(AGE2,"DYS",2,99)
 ;
 ;Inclusive
 S AGE1=$O(FPARMS(PORD,"AGE","")) Q:AGE1=""
 I AGE1["or older"!(AGE1["or younger") D  Q
 . K FPARMS(PORD,"AGE",AGE1)
 . I AGE1["or older" S AGE1=$P(AGE1," or older")
 . E  S AGE1=$P(AGE1," or younger")
 . S VALUE="between (inclusive) "_AGE1_" and "_AGE2
 ;
 ;Exclusive
 K FPARMS(PORD,"AGE",AGE1)
 I AGE1["younger than" S AGE1=$P(AGE1,"younger than ",2)
 E  S AGE1=$P(AGE1,"older than ",2)
 S VALUE="younger than "_AGE1_" or older than "_AGE2
 Q
 ;
DXCAT ;EP - Diagnosis Category
 NEW I,STR,DXSTAT
 S ASTR=$G(ASTR,"")
 F I=1:1:$L(ASTR,$C(26)) D
 . NEW AINFO,ANAME,AVAL,NVAL,VAL,PC
 . S AINFO=$P(ASTR,$C(26),I)
 . S ANAME=$P(AINFO,$C(28)) Q:ANAME=""
 . S AVAL=$P(AINFO,$C(28),2) Q:AVAL=""
 . S NVAL=""
 . F PC=1:1:$L(AVAL,$C(29)) D
 .. S VAL=$P(AVAL,$C(29),PC) Q:VAL=""
 .. S VAL=$S(VAL="A":"Accepted",VAL="P":"Proposed",VAL="N":"Not Accepted",VAL="V":"No Longer Valid",VAL="S":"Superseded",1:"")
 .. S:VAL]"" NVAL=NVAL_$S(NVAL]"":", ",1:"")_VAL
 . I ANAME]"",NVAL]"" S @ANAME=NVAL
 ;
 S STR="Diagnostic Tag "_VALUE
 S:$G(DXSTAT)]"" STR=STR_" (Diagnostic Tag Status "_DXSTAT_")"
 S VALUE=STR
 Q
 ;
DEC ;EP - Format Patient status
 ;Save everything under deceased
 S PORD=$$PORD^BQIDCDF(FSOURCE,"DEC") Q:PORD=""
 ;Deceased
 I FNAME="DEC" D
 . NEW PORD,DECDT,DECFDT,DECTDT
 . S VALUE=$S($G(VALUE)="Y":"Deceased",1:"")
 . Q:VALUE=""
 . ;Tack on Deceased information
 . ;Deceased from date
 . S DECFDT=$$GETVAL(OWNR,PLIEN,"DECFDT")
 . I DECFDT]"" S VALUE=VALUE_" (Range from date "_$$FMTE^BQIUL1(DECFDT)
 . ;Deceased thru date
 . S DECTDT=$$GETVAL(OWNR,PLIEN,"DECTDT")
 . I DECTDT]"" S VALUE=VALUE_$S(VALUE["Range":" thru date ",1:" (Range thru date ")_$$FMTE^BQIUL1(DECTDT)
 . I VALUE["(" S VALUE=VALUE_")"
 ;
 ;Living
 I FNAME="LIV" S VALUE=$S($G(VALUE)="Y":"Living",1:"") S:VALUE]"" FNAME="DEC"
 ;
 ;Inactive
 I FNAME="INAC" S VALUE=$S($G(VALUE)="Y":"Inactive",1:"") S:VALUE]"" FNAME="DEC"
 ;
 ;DEMO
 I FNAME="DEMO" S VALUE=$S($G(VALUE)="E":"Exclude",$G(VALUE)="O":"Only",1:"Include")_" DEMO " S:VALUE]"" FNAME="DEC"
 Q
 ;
PLIDEN ; Format FPARMS("PLIDEN") or FMPARMS("PLIDEN")
 Q:$G(VALUE)=""
 ;
 NEW PLOWNR,PLNAME
 S PLOWNR=$P(VALUE,$C(26)) S:PLOWNR]"" PLOWNR=$$GET1^DIQ(200,PLOWNR_",",.01,"E")
 S:PLOWNR]"" PLOWNR="(Owner: "_PLOWNR_")"
 S PLNAME=$P(VALUE,$C(26),2)
 ;
 S VALUE=PLNAME_$S(PLNAME]"":" ",1:"")_PLOWNR
 Q
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
LABTX(VALUE) ;EP - Assemble LABTX value
 NEW X,DIC,Y,IEN,VAL,LABTST,LTST
 I VALUE="" Q
 S X=VALUE,DIC="^ATXLAB(" D ^DIC
 S VALUE="Lab Taxonomy "_VALUE
 I Y="-1" Q
 S IEN=+Y_",",VAL=""
 D GETS^DIQ(9002228,IEN,"2101*","E","LABTST")
 S LTST="" F  S LTST=$O(LABTST(9002228.02101,LTST)) Q:LTST=""  D
 . S VAL=VAL_$S(VAL="":" (Lab Tests ",1:", ")_$G(LABTST(9002228.02101,LTST,".01","E"))
 S:VAL["(" VAL=VAL_")"
 S VALUE=VALUE_VAL
 Q
 ;
MEDTX(VALUE) ;EP - Assemble MEDTX value
 NEW X,DIC,Y,IEN,VAL,MED,MTST,MD,FILE
 I VALUE="" Q
 S X=VALUE,DIC="^ATXAX(" D ^DIC
 S VALUE="Medication Taxonomy "_VALUE
 I Y="-1" Q
 S IEN=+Y_",",VAL=""
 D GETS^DIQ(9002226,IEN,".15;2101*","IE","MED")
 S FILE=$G(MED(9002226,IEN,.15,"I")) Q:FILE=""
 S MTST="" F  S MTST=$O(MED(9002226.02101,MTST)) Q:MTST=""  D
 . S MD=$G(MED(9002226.02101,MTST,".01","E")) Q:MD=""
 . S MD=$$GET1^DIQ(FILE,MD_",",.01,"E")
 . S VAL=VAL_$S(VAL="":" (Medications ",1:", ")_MD
 S:VAL["(" VAL=VAL_")"
 S VALUE=VALUE_VAL
 Q
 ;
PRBTX(VALUE) ;EP - Assemble PROBTX value
 NEW X,DIC,Y,IEN,VAL,PROB,PTST,PB,FILE
 I VALUE="" Q
 S X=VALUE,DIC="^ATXAX(" D ^DIC
 S VALUE="Problem Taxonomy "_VALUE
 I Y="-1" Q
 S IEN=+Y_",",VAL=" ("
 D GETS^DIQ(9002226,IEN,".15;2101*","IE","PROB")
 S FILE=$G(PROB(9002226,IEN,.15,"I")) Q:FILE=""
 S PTST="" F  S PTST=$O(PROB(9002226.02101,PTST)) Q:PTST=""  D
 . S PB=$G(PROB(9002226.02101,PTST,".01","E")) Q:PB=""
 . S VAL=VAL_$$TKO^BQIUL1(PB," ")_", "
 S VAL=$$TKO^BQIUL1(VAL,", ")
 S:VAL["(" VAL=VAL_")"
 S VALUE=VALUE_VAL
 Q
 ;
GETVAL(OWNR,PLIEN,FLD) ;EP - Retrieve Single field value
 N DECIEN,DA,IEN,IENS
 S IEN=$O(^BQICARE(OWNR,1,PLIEN,15,"B",FLD,"")) Q:IEN="" ""
 S DA(2)=OWNR,DA(1)=PLIEN,DA=IEN,IENS=$$IENS^DILF(.DA)
 Q $$GET1^DIQ(90505.115,IENS,.02,"I")
 ;
ICD(ICDIEN) ;EP - Return ICD Information
 NEW ICD
 S ICD=""
 ;Pull appropriate ICD-9/ICD-10 code
 ;ICD-9
 I $$VERSION^XPDUTL("AICD")<4.0 D
 . NEW STR
 . I '$L($T(ICDDX^ICDCODE)) D  Q
 .. S ICD=$$GET1^DIQ(80,ICDIEN_",",.03,"I")_U_$$GET1^DIQ(80,ICDIEN_",",.01,"I")
 . S STR=$$ICDDX^ICDCODE(ICDIEN) I $P(STR,U)="-1" Q
 . S ICD=$P(STR,U,4)_U_$P(STR,U,2)
 ;
 ;ICD-9 or ICD-10
 I $$VERSION^XPDUTL("AICD")>3.51 D
 . ;First try to locate ICD-10
 . I $$IMP^ICDEXA(30)'>DT D  Q:ICD]""
 .. NEW STR
 .. S STR=$$ICDDATA^ICDXCODE(30,ICDIEN,DT,"E") I $P(STR,U)="-1" Q
 .. S ICD=$P(STR,U,4)_U_$P(STR,U,2)
 . ;If not an ICD-10 code try ICD-9 (could be before date or a historical entry)
 . I $G(ICD)="" D
 .. NEW STR
 .. S STR=$$ICDDATA^ICDXCODE(1,ICDIEN,DT,"E") I $P(STR,U)="-1" Q
 .. S ICD=$P(STR,U,4)_U_$P(STR,U,2)
 Q $S(ICD]"":($P(ICD,U)_" ("_$P(ICD,U,2)_")"),1:"")
 ;
PRST(VALUE) ;EP - Problem statuses
 NEW FILE,FLD
 S FILE=9000011,FLD=.12
 S VALUE=$$STC^BQIUL2(FILE,FLD,VALUE)
 Q
