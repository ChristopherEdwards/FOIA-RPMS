BGOUTL ; IHS/BAO/TMD - Utilities ;29-Jun-2009 08:06;PLS
 ;;1.1;BGO COMPONENTS;**1,3,4,5,6**;Mar 20, 2007
 ; Compute patient's age
 ;  DFN = Patient IEN
 ;  DAT = Reference date (defaults to today)
PTAGE(DFN,DAT) ;EP
 N DOB
 S DOB=+$P($G(^DPT(+DFN,0)),U,3)
 S:'$G(DAT) DAT=DT
 Q $S(DAT:$$FMDIFF^XLFDT(DT,DOB)/365.25\1,1:"")
 ; Convert a string to mixed case
MCASE(X) ;EP
 N Y
 S X=$$LOW^XLFSTR(X),Y=1
 F  D  S Y=$F(X," ",Y) Q:'Y
 .S $E(X,Y)=$$UP^XLFSTR($E(X,Y))
 Q X
 ; Check if user has specified security key
APSEC(RET,KEY) ;EP
 S RET=$D(^XUSEC(KEY,DUZ))
 Q
 ; Check security keys and parameters
 ;   INP = <key 1>|<key 2>|...|<key n>^<param 1>|<param 2>|...|<param n>^User IEN (optional)
 ;   Returned as:
 ;     <key 1>|<key 2>|...|<key n>^<param 1>|<param 2>|...|<param n>
 ;   where <key n> is boolean value for presence of key
 ;   and <param n> is of the format <user setting>~<user class name>
 ;   where <user setting> is the user setting for the parameter and
 ;   <user class name> is the user class that has a true value for
 ;   the parameter.
CHKSEC(RET,INP) ;EP
 N KEYS,PARAMS,C,X,LP,PARM,USR,CLS,UC,USER
 S RET=""
 S KEYS=$P(INP,U)
 S PARAMS=$P(INP,U,2)
 S USER=$P(INP,U,3)
 I USER,USER'=DUZ S RET=$$ERR(1053) Q
 F C=1:1 S X=$P(KEYS,"|",C) Q:X=""  S $P(KEYS,"|",C)=$$HASKEY^BEHOUSCX(X)
 F C=1:1 S PARM=$P(PARAMS,"|",C) Q:PARM=""  D
 .S USR=$$GET^XPAR("USR.`"_DUZ,PARM)
 .S CLS=""
 .S LP=0
 .F  S LP=$O(^USR(8930.3,"B",DUZ,LP)) Q:'LP  D  Q:CLS'=""
 ..S UC=$P($G(^USR(8930.3,LP,0)),U,2)
 ..Q:'UC
 ..S:$$GET^XPAR("CLS.`"_UC,PARM) CLS=$P($G(^USR(8930,UC,0)),U)
 .S $P(PARAMS,"|",C)=+USR_"~"_CLS
 S RET=KEYS_U_PARAMS
 Q
 ; Return a parameter value
CKPARM(RET,PARM) ;EP
 S RET=$$GET^XPAR("ALL",PARM)
 Q
 ; Return clinic stop associated with a location
 ;  IEN = IEN in HOSPITAL LOCATION file
 ;  RET = Returned as Name^Code
GETCLN(RET,IEN) ;EP
 S RET=$P($G(^SC(+IEN,0)),U,7)
 S:$D(^DIC(40.7,+RET,0)) RET=RET_U_$P(^(0),U,1,2)
 Q
 ;
 ; RPC to retrieve visit detail report
GETRPT(RET,VIEN) ;EP
 D GETRPT^BEHOENPS(.RET,VIEN)
 Q
 ; Return a BGO parameter value
 ;  PID = Parameter identifier
 ;  RET = Parameter value
GETPARM(RET,PID) ;EP
 I $G(PID)="" S RET=$$ERR(1054)
 E  S RET=$$GET^XPAR("ALL","BGO PARAMETER",PID)
 Q
 ; Set a BGO parameter value
 ;  INP = Parameter ID ^ Parameter Value ^ Entity (optional)
SETPARM(RET,INP) ;EP
 N PID,VAL,ENT,ERR
 S PID=$P(INP,U)
 I PID="" S RET=$$ERR(1054) Q
 S VAL=$P(INP,U,2)
 I VAL="" S RET=$$ERR(1055) Q
 S ENT=$P(INP,U,3)
 S:'$L(ENT) ENT="USR"
 D PUT^XPAR(ENT,"BGO PARAMETER",PID,VAL,.RET)
 S:RET RET="-"_RET
 Q
 ; Lock/unlock a file entry
 ;  INP = File # ^ IEN ^ Unlock Flag
LOCK(RET,INP) ;EP
 N GBL,FNUM,IEN,FLG
 S FNUM=+INP
 S IEN=+$P(INP,U,2)
 S FLG=+$P(INP,U,3)
 S GBL=$$ROOT^DILFD(FNUM,,1)
 I GBL="" S RET=$$ERR(1056) Q
 I IEN'>0 S RET=$$ERR(1057) Q
 S GBL=$NA(@GBL@(IEN))
 D LOCK^CIANBRPC(.RET,GBL):FLG,LOCK^CIANBRPC(.RET,GBL,0):'FLG
 I 'RET,'FLG S RET=$$ERR(1058)
 Q
 ; Fileman Lookup utility
 ;  INP = GBL [1] ^ Lookup Value [2] ^ FROM [3] ^ DIR [4] ^ MAX [5] ^ XREF [6] ^ SCRN [7] ^ ALL [8] ^ FLDS [9]
 ;   GBL  = File global root (open or closed, without leading ^) or file #
 ;   FROM = Text from which to start search
 ;   DIR  = Search direction (defaults to 1)
 ;   MAX  = Maximum # to return (defaults to 44)
 ;   XREF = Cross ref to use (defaults to "B")
 ;   SCRN = Screening logic (e.g. => .04="TEST";.07=83)
 ;   ALL  = Return all records, maximum of 9999
 ;   FLDS = Fields to return
DICLKUP(RET,INP) ;EP
 N GBL,LKP,FROM,DIR,MAX,XREF,XREFS,SCRN,ALL,FLDS,FNUM,CNT
 S RET=$$TMPGBL
 S GBL=$P(INP,U)
 I GBL=9999999.88,$$CSVACT^BGOUTL2 S GBL=81.3
 I GBL=+GBL S GBL=$$ROOT^DILFD(GBL,,1)
 E  S GBL=$$CREF^DILF(U_GBL)
 S FNUM=$P($G(@GBL@(0)),U,2),FNUM(0)=FNUM["P",FNUM=+FNUM
 Q:'FNUM
 S LKP=$P(INP,U,2)
 S FROM=$P(INP,U,3)
 S DIR=$P(INP,U,4)
 S MAX=$P(INP,U,5)
 S XREF=$P(INP,U,6)
 S SCRN=$TR($P(INP,U,7),"~",U)
 S ALL=$P(INP,U,8)
 S FLDS=$P(INP,U,9)
 S:FLDS="" FLDS=".01"
 I LKP'="",FROM="" S FROM=LKP
 S CNT=0,MAX=$S(ALL:9999,MAX>0:+MAX,1:100),DIR=$S(DIR'=-1:1,1:-1)
 I XREF'="" D  Q
 .S XREFS=XREF
 .F  S XREF=$P(XREFS,"~"),XREFS=$P(XREFS,"~",2,999) D DL1 Q:(XREFS="")!CNT
 S XREF="B"
 I LKP="" D DL1 Q
 F  D DL1 S XREF=$O(@GBL@(XREF)) Q:($E(XREF)'="B")!CNT
 Q
 ; Check specified xref
DL1 N NEXT,IEN
 S NEXT=FROM
 I LKP'="",XREF="B" D  Q:IEN
 .S IEN=$O(@GBL@(XREF,LKP,0))
 .I IEN,$$XSCRN(IEN,SCRN) D DL2
 F  Q:CNT'<MAX  D:$L(NEXT)  Q:'$D(NEXT)  S NEXT=$O(@GBL@(XREF,NEXT),DIR) Q:'$L(NEXT)
 .I LKP'="",$E(NEXT,1,$L(LKP))'=LKP K NEXT Q
 .S IEN=0
 .F  S IEN=$O(@GBL@(XREF,NEXT,IEN)) Q:'IEN  D
 ..N S,X,Y,I,J,FLD,OPR,VAL,N,P
 ..I SCRN'="" D  Q:'X
 ...I $E(SCRN,1,2)="I " S Y=IEN X SCRN S X=$T Q
 ...F I=1:1 S S=$P(SCRN,"&",I) Q:S=""  D  Q:'X
 ....S FLD=+S,X=0
 ....Q:'FLD
 ....S OPR=""
 ....F J=1:1:3 Q:"=<>'[]"'[$E(S,$L(FLD)+J)  S OPR=OPR_$E(S,$L(FLD)+J)
 ....Q:OPR=""
 ....S VAL=$P(S,OPR,2,999)
 ....S N=$P($G(^DD(FNUM,FLD,0)),U,4),P=$P(N,";",2),N=$P(N,";")
 ....Q:N=""!(P="")
 ....X "S X=$P($G(@GBL@(IEN,N)),U,P)"_OPR_"VAL"
 ..D DL2
 Q
 ; Add to output list
DL2 N VAL,TGT,FLD,IENS,I,X
 S IENS=IEN_","
 D GETS^DIQ(FNUM,IENS,FLDS,"I","TGT")
 S VAL=IEN_U_NEXT
 F I=1:1 S FLD=$P(FLDS,";",I) Q:'$L(FLD)  D
 .S X=$G(TGT(FNUM,IENS,FLD,"I"))
 .I FNUM(0),FLD=.01 S X=$$EXTERNAL^DILFD(FNUM,FLD,,X)
 .S VAL=VAL_U_X
 S CNT=CNT+1,@RET@(CNT)=VAL
 Q
 ; Fileman Lookup utility (uses FIND^DIC)
 ;  INP = GBL [1] ^ Lookup Value [2] ^ FROM [3] ^ DIR [4] ^ MAX [5] ^ XREF [6] ^ SCRN [7] ^ ALL [8] ^ FLDS [9]
 ;   GBL  = File global root (open or closed, without leading ^) or file #
 ;   FROM = Text from which to start search
 ;   DIR  = Search direction (not supported)
 ;   MAX  = Maximum # to return (defaults to 44)
 ;   XREF = Cross ref to use (defaults to "B")
 ;   SCRN = Screening logic (e.g. => .04="TEST";.07=83)
 ;   ALL  = Return all records, maximum of 9999
 ;   FLDS = Fields to return
DICLKUP2(RET,INP) ;EP
 N GBL,LKP,FROM,DIR,MAX,XREF,XREFS,SCRN,ALL,FLDS,FNUM,LP,X
 S RET=$$TMPGBL
 S GBL=$P(INP,U)
 I GBL=+GBL S GBL=$$ROOT^DILFD(GBL,,1)
 E  S GBL=$$CREF^DILF(U_GBL)
 S FNUM=$P($G(@GBL@(0)),U,2),FNUM(0)=FNUM["P",FNUM=+FNUM
 Q:'FNUM
 S LKP=$P(INP,U,2)
 S FROM=$P(INP,U,3)
 S DIR=$P(INP,U,4)                                                     ; ignored
 S MAX=$P(INP,U,5)
 S XREF=$TR($P(INP,U,6),"~",U)
 S SCRN=$TR($P(INP,U,7),"~",U)
 S ALL=$P(INP,U,8)
 S FLDS=$P(INP,U,9)
 S:FLDS="" FLDS=".01"
 F LP=1:1:$L(FLDS,";") D
 .S X=$P(FLDS,";",LP)
 .S $P(FLDS,";",LP)=X_$S(X=.01&FNUM(0):"E",1:"I")
 I LKP'="",FROM="" S FROM=LKP
 S MAX=$S(ALL:9999,MAX>0:+MAX,1:100),DIR=$S(DIR'=-1:1,1:-1)
 D FIND^DIC(FNUM,,"@;IX;"_FLDS,"BP",LKP,MAX,XREF,SCRN,,RET)
 K @RET@("DILIST",0)
 Q
 ; Returns true if active hospital location
 ;  LOC = IEN of hospital location
 ;  DAT = optional date to check (defaults to today)
ACTHLOC(LOC,DAT) ;
 Q $$ACTLOC^BEHOENCX(LOC,.DAT)
 ; Returns true if user is a provider and is active
ACTPRV(IEN,DAT) ;
 Q $$ACTIVE^BEHOUSCX(IEN,.DAT)&$$HASKEY^BEHOUSCX("PROVIDER")
 ; Returns true if routine exists
 ;  X = Routine or routine^tag
 ; .Y error message returned if not found
TEST(X,Y) ;EP
 S:X[U X=$P(X,U,2)
 Q:'$L(X)!(X'?.1"%"1.AN) 0
 X ^%ZOSF("TEST")
 Q:$T 1
 S Y=$$ERR(1059,X)
 Q 0
 ; Get CPT modifiers for a CPT code
CPTMODS(RET,INP) ;EP
 Q:'$$TEST("CPTMODS^ORWPCE",.RET)
 D CPTMODS^ORWPCE(.RET,INP)
 Q
 ; Perform lookup in lexicon
 ;  INP = Term ^ Type (ICD/CHP)
LEXLKUP(RET,INP) ;EP
 N TERM,TYPE
 Q:'$$TEST("LEX^ORWPCE",.RET)
 S TERM=$P(INP,U)
 Q:TERM=""
 S TYPE=$P(INP,U,2)
 Q:TYPE=""
 D LEX^ORWPCE(.RET,TERM,TYPE)
 Q
 ; Lexicon ICD lookup
 ;  TERM = Term to lookup
ICDLEX(RET,TERM) ;EP
 S $P(TERM,U,2)="ICD"
 D LEXLKUP(.RET,TERM)
 Q
 ; Return IEN of ICD code
ICDIEN(RET,ICD) ;EP
 S RET=$S($L(ICD):$O(^ICD9("AB",ICD,"")),1:"")
 Q
 ; Get ICD IEN from lexicon IEN
ICDLEXCD(RET,LEX) ;EP
 Q:'$$TEST("LEXCODE^ORWPCE",.RET)
 D LEXCODE^ORWPCE(.RET,LEX,"ICD"),ICDIEN(.RET,RET)
 Q
 ; Get CPT IEN from lexicon IEN
CPTLEXCD(RET,LEX) ;EP
 Q:'$$TEST("LEXCODE^ORWPCE",.RET)
 D LEXCODE^ORWPCE(.RET,LEX,"CHP")
 S:$L(RET) RET=$O(^ICPT("B",RET,""))
 Q
 ; Returns the clinic stop associated with a visit
 ;  VIEN = Visit IEN
VCLN(RET,VIEN) ;EP
 I '$G(VIEN) S RET=$$ERR(1002)
 E  I '$D(^AUPNVSIT(VIEN,0)) S RET=$$ERR(1003)
 E  S RET=$P(^AUPNVSIT(VIEN,0),U,8),RET=$P($G(^DIC(40.7,+RET,0)),U,2)
 Q
 ; Returns 1 if a visit exists for current day
 ;  DFN = Patient IEN
FIRVIS(RET,DFN) ;EP
 I '$G(DFN) S RET=$$ERR(1050)
 E  I '$D(^DPT(DFN,0)) S RET=$$ERR(1001)
 E  I $O(^AUPNVSIT("AA",DFN,9999999-DT+.2359)) S RET=0
 E  S RET=1
 Q
 ; Delete a V file entry
 ;  INP = V File # ^ V File IEN
VFDEL(RET,INP) ;EP
 D VFDEL^BGOUTL2(.RET,+INP,+$P(INP,U,2))
 Q
 ; Fetch a record from a file
GETREC(FNUM,IEN,FLDS) ;EP
 N RET,FLD,IENS,VAL,I,X,Y
 S IENS=IEN_",",RET=IEN
 D GETS^DIQ(FNUM,IENS,FLDS,"IE","VAL")
 F I=1:1:$L(FLDS,";") D
 .S FLD=$P(FLDS,";",I)
 .S X=$G(VAL(FNUM,IENS,FLD,"E")),Y=$G(VAL(FNUM,IENS,FLD,"I"))
 .S:X'=Y X=X_"|"_Y
 .S $P(RET,U,I+1)=X
 Q RET
 ; Add/edit a file entry
UPDATE(FDA,FLG,IEN) ;EP
 N ERR,DFN,X
 I $G(FLG)["@" S FLG=$TR(FLG,"@")
 E  D
 .S X="FDA"
 .F  S X=$Q(@X) Q:'$L(X)  K:'$L(@X) @X
 Q:$D(FDA)'>1 ""
 D UPDATE^DIE(.FLG,"FDA","IEN","ERR")
 K FDA
 Q $S($G(ERR("DIERR",1)):-ERR("DIERR",1)_U_ERR("DIERR",1,"TEXT",1),1:"")
 ; Delete an entry from a file
DELETE(DIK,DA) ;EP
 N CREF,X,Y
 S:DIK=+DIK DIK=$$ROOT^DILFD(DIK)
 S CREF=$$CREF^DILF(DIK)
 D ^DIK
 Q $S($D(@CREF@(DA)):$$ERR(1060,$P($G(@CREF@(0),"UNKNOWN"),U)),1:"")
 ; Check and validate visit
CHKVISIT(VIEN,DFN,CAT) ;EP
 N RET,X0
 S RET=$$ISLOCKED^BEHOENCX(VIEN)
 Q:RET $S(RET<0:$$ERR(1003),1:$$ERR(1061))
 S X0=$G(^AUPNVSIT(VIEN,0))
 I $G(DFN),$P(X0,U,5)'=DFN S RET=$$ERR(1062)
 E  I $P(X0,U,11) S RET=$$ERR(1063)
 E  I $L($G(CAT)),CAT'[$P(X0,U,7) S RET=$$ERR(1064,$$EXTERNAL^DILFD(9000010,.07,,$P(X0,U,7)))
 Q RET
 ; Get primary provider for a visit
 ;  VIEN = Visit IEN
 ;  Returns Provider IEN ^ Provider Name ^ V Provider IEN
PRIPRV(VIEN) ;EP
 N X,RET
 Q:'VIEN $$ERR(1002)
 S X=0,RET=$$ERR(1065)
 F  S X=$O(^AUPNVPRV("AD",VIEN,X)) Q:'X  D  Q:RET>0
 .S Y=$G(^AUPNVPRV(X,0))
 .S:$P(Y,U,4)="P" RET=$P(Y,U)_U_$P($G(^VA(200,+Y,0)),U)_U_X
 Q RET
 ; Create an historical visit
MAKEHIST(DFN,EVNTDT,LOC,VIEN) ;EP
 S EVNTDT=$$CVTDATE(EVNTDT)
 S:EVNTDT#100\1=0 EVNTDT=EVNTDT+1
 Q:EVNTDT\1>DT $$ERR(1066)
 I $G(VIEN) D  Q:VIEN VIEN
 .N X,V,L
 .S X=$G(^AUPNVSIT(VIEN,0)),L=$G(^(21)),V=VIEN,VIEN=0
 .Q:DFN'=$P(X,U,5)
 .Q:$P(X,U,7)'="E"
 .I X\1'=EVNTDT,+X'=EVNTDT Q
 .I LOC=+LOC Q:$P(X,U,6)'=LOC
 .E  I $L(LOC),$P(L,U)'=LOC,$$GET1^DIQ(4,$P(X,U,6),.01)'=LOC Q
 .S VIEN=V
 Q $$FNDVIS^BEHOENCX(DFN,EVNTDT,"E","",-1,,LOC)
 ; Convert date to internal format
CVTDATE(X) ;EP
 Q:"@"[X X
 S:X?1.E1" "1.2N1":"2N.E X=$P(X," ")_"@"_$P(X," ",2,99)
 D DT^DILF("PT",X,.X)
 Q $S(X>0:X,1:"")
 ; Convert date to MM/DD/YYYY format
 ; If TM is nonzero, include time portion
FMTDATE(X,TM) ;EP
 Q:'X ""
 N M,D,V
 S M=$E(X,4,5),D=$E(X,6,7),V=$E(X,1,3)+1700
 S:M&D V=D_"/"_V
 S:M V=M_"/"_V
 I $G(TM) D
 .S X=X#1
 .Q:'X
 .S X=$TR($J(X*10000\1,4),0)
 .S V=V_" "_$E(X,1,2)_":"_$E(X,3,4)
 Q V
 ; Convert a string to WP format
TOWP(X) ;EP
 N I,L,L2,Y,Z
 S Y=@X
 K @X
 S:Y="@" Y=""
 F I=1:1 Q:'$L(Y)  D
 .S L=$F(Y,$C(13))
 .I 'L!(L>242) D
 ..S L=$S($L(Y)'>240:999,1:0)
 ..F  S L2=$F(Y," ",L) Q:'L2!(L2>242)  S L=L2
 .I 'L S Z=$E(Y,1,240),Y=$E(Y,241,99999)
 .E  S Z=$E(Y,1,L-2),Y=$E(Y,L,99999)
 .S @X@(I,0)=$TR(Z,$C(13,10))
 Q $S($D(@X):X,1:"")
 ; Convert a value to internal format
TOINTRNL(FNUM,FLD,VAL) ;EP
 N RET
 D CHK^DIE(FNUM,FLD,,VAL,.RET)
 Q $S(U[$G(RET):"",1:RET)
 ; Return an error code/error dialog
ERR(CODE,PARAMS) ;EP
 Q -CODE_U_$$EZBLD^DIALOG(CODE+903620000,.PARAMS)
 ; Return a temporary global reference
TMPGBL(X) ;EP
 K ^TMP("BGO"_$G(X),$J) Q $NA(^($J))
 ; Returns status of screen application
 ;  0=failed  1=passed
XSCRN(IEN,SCRN) ;EP
 N S,X,Y,I,J,FLD,OPR,VAL,N,P
 S X=1  ; Default to passed
 I SCRN'="" D
 .I $E(SCRN,1,2)="I " D
 ..S Y=IEN X SCRN S X=$T
 .E  D
 ..F I=1:1 S S=$P(SCRN,"&",I) Q:S=""  D  Q:'X
 ...S FLD=+S,X=0
 ...Q:'FLD
 ...S OPR=""
 ...F J=1:1:3 Q:"=<>'[]"'[$E(S,$L(FLD)+J)  S OPR=OPR_$E(S,$L(FLD)+J)
 ...Q:OPR=""
 ...S VAL=$P(S,OPR,2,999)
 ...S N=$P($G(^DD(FNUM,FLD,0)),U,4),P=$P(N,";",2),N=$P(N,";")
 ...Q:N=""!(P="")
 ...X "S X=$P($G(@GBL@(IEN,N)),U,P)"_OPR_"VAL"
 Q X
