CIAUDDR ;MSC/IND/DKM - FileMan RPC Extensions ;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; RPC: Retrieve DD information about a file.
 ; FNUM = File # or name
 ; FLDS = Semi-colon delimited field list (optional)
 ; IENS = IENS (for subfile entries)
 ; FLGS = Control flags:
 ;   D = Fix duplicate field names
 ;   M = Retrieve multiples
 ; Return data:
 ;  DATA(0)   = -1^Error text or
 ;            = File #^File name^Rec count^Field count^Readonly^Parent File
 ;  DATA(n)   = Field #^Field name^Datatype^Size^Required^Readonly^Help lines^Xref^Calculated
 ;  DATA(n,0) = Supplemental data (set mappings)
 ;  DATA(n,1) = Prompt Text
 ;  DATA(n,2) = Help Text
GETDD(DATA,FNUM,FLDS,IENS,FLGS) ;
 N X,Y,Z,CNT,N0,FLD,PF,MULT,DUPS
 S DATA=$NA(^TMP("CIAUDDR",$J))
 K @DATA
 S FNUM=$G(FNUM),FLDS=$G(FLDS),FLGS=$G(FLGS),MULT=FLGS["M",DUPS=FLGS["D"
 I $L(FNUM),FNUM'=+FNUM D
 .S FNUM=$O(^DIC("B",FNUM,0))
 .I FNUM,$O(^(FNUM)) S FNUM=""
 S X=$$ROOT^DILFD(FNUM,$G(IENS),1),PF=$G(^DD(+FNUM,0,"UP"))
 S:$L(X) X=$G(@X@(0))
 S:PF $P(X,U)=$P($G(^DD(+FNUM,0)),U)
 I '$L(X) D SETERR("Table not found") Q
 S N0=FNUM_U_$P(X,U)_U_$P(X,U,4),CNT=0
 F X=1:1:$L(FLDS,";") D  Q:'X
 .S FLD=$P(FLDS,";",X)
 .Q:'$L(FLD)
 .S:FLD="*" FLD="0-9999999999999999"
 .I $TR(FLD,".")?1.N1"-"1.N D
 ..S Z=+$P(FLD,"-"),Y=+$P(FLD,"-",2)
 ..S:Z<0 Z=0
 ..I Z=0 S:'$$GETFL(0,0) X=0
 ..I Z>0,$D(^DD(FNUM,Z,0)) S:'$$GETFL(Z,MULT) X=0
 ..F  Q:'X  S Z=$O(^DD(FNUM,Z)) Q:'Z  Q:Z>Y  S:'$$GETFL(Z,MULT) X=0
 .E  I '$$GETFL(FLD,1) S X=0
 S:X @DATA@(0)=N0_U_CNT_U_($P($G(^DD(FNUM,0,"DI")),U,2)["Y")_U_PF
 Q
 ; Setup type info for field
 ;  FLDX = Field # or name
 ;  MULT = Allow multiples
 ; Note: Datatype (TP) maps to TFMFieldType enum:
 ;   0 = unknown, 1 = free text, 2 = numeric, 3 = boolean,
 ;   4 = date/time, 5 = wp, 6 = pointer, 7 = set, 8 = subfile
GETFL(FLDX,MULT) ;
 N X,Z,LN,TP,HC,DD,FLD,MLT,NAM
 S FLD=$$FLDNUM(FNUM,FLDX),MLT=0
 S DD=$S('$L(FLD):"",FLD:$G(^DD(FNUM,FLD,0)),1:"#^RICJ8,5"),X=$P(DD,U,2)
 I '$L(DD) D SETERR("Field not found: "_FLDX) Q 0
 I X,$P($G(^DD(X,.01,0)),U,2)'["W" S MLT=1
 I 'MULT,MLT Q 1
 S (LN,TP,HC,Z)=0,DX="",NAM=$P(DD,U),CNT=CNT+1
 I DUPS,$O(^(+$O(^DD(FNUM,"B",NAM,0)))) S NAM=NAM_"("_FLD_")"
 I MLT S TP=8,DX=+X
 E  I X["B" S TP=3
 E  I X["D" S TP=4,DX=$P($P($P(DD,U,5),"%DT=",2),"""",2)
 E  I X["F"!(X["K") S TP=1,LN=+$P($P(DD,U,5),"$L(X)>",2) S:'LN LN=30
 E  I X["J" S TP=2,DX=$P(X,"J",2) S:DX'["," LN=DX,DX="",TP=1
 E  I X["P"!(X["p") S TP=6,DX=+$P($TR(X,"p","P"),"P",2),LN=$$GETLN(DX)
 E  I X["S" S TP=7,DX=$P(DD,U,3)
 E  I X=+X S TP=5
 I 'FLD S HC=1,@DATA@(CNT,2,HC)="Internal record number."
 E  F  S Z=$O(^DD(FNUM,FLD,21,Z)) Q:'Z  S HC=HC+1,@DATA@(CNT,2,HC)=^(Z,0)
 S @DATA@(CNT)=FLD_U_NAM_U_TP_U_LN_U_(X["R")_U_(X["I")_U_HC_U_$$XREF(FNUM,FLD)_U_(X["C")
 S @DATA@(CNT,0)=DX,@DATA@(CNT,1)=$G(^DD(FNUM,FLD,3))
 Q 1
 ; Get length of .01 for file
GETLN(FNUM) ;
 N DD,X
 S DD=$G(^DD(FNUM,.01,0)),X=$P(DD,U,2)
 S X=+$S(X["P":$$GETLN(+$E(X,2,99)),X["F":$P($P(DD,U,5),"$L(X)>",2),1:0)
 Q $S(X:X,1:30)
SETERR(ERR) ;
 K @DATA
 S @DATA@(0)="-1^"_ERR
 Q
 ; RPC: CIAUDDR MOVETO
 ; Move to specified record (returns IEN only)
 ; FNUM: File #
 ; IEN : Current IEN
 ; DIR : 0 = current; 1 = next; 2 = prior
 ; IENS: Subfile IENS
 ; SCRN: Screens (optional)
 ; INDX: Index (optional)
 ; Returns IEN or <error code>^<error text>
MOVETO(DATA,FNUM,IEN,DIR,IENS,SCRN,INDX) ;
 N GBL,IDX,IDF,OK
 S GBL=$$ROOT^DILFD(FNUM,$G(IENS),1),DIR=+$G(DIR),INDX=$G(INDX)
 S DIR=$S(DIR=1:1,DIR=2:-1,1:0)
 S:$L($G(SCRN)) SCRN(-1)=SCRN
 I '$L(GBL) S DATA="-4^Table not found" Q
 I $L(INDX) D  Q:$G(DATA)
 .I '$O(^DD(FNUM,0,"IX",INDX,"")) S DATA="-5^Index "_INDX_" not found" Q
 .S IDF=$$XREFFLD(FNUM,INDX)
 .I 'IDF S DATA="-6^Index "_INDX_" is not a standard index" Q
 .S IDX=$S(IEN=-1:"",IEN=-2:$C(255),1:$E($$FLDVAL(FNUM,IDF,IEN,GBL),1,30))
 E  S IEN=$S(IEN=-1:0,IEN=-2:$O(@GBL@($C(1)),-1)+1,1:+IEN)
 F  D  Q:OK!'IEN
 .S IEN=+$$NXTIEN
 .;S OK=IEN&(IEN\1=IEN)&$D(@GBL@(IEN,0)),SCRN=""
 .S OK=IEN&$D(@GBL@(IEN,0)),SCRN=""
 .F  Q:'OK  S SCRN=$O(SCRN(SCRN)) Q:'$L(SCRN)  D
 ..N Y
 ..S Y=IEN
 ..I $D(@GBL@(Y,0))
 ..X SCRN(SCRN)
 ..S OK=$T
 .I 'OK,'DIR S IEN=0
 S DATA=$S(OK:IEN,'DIR:"-3^Record not found",DIR=1:"-2^End of file",1:"-1^Beginning of file")
 Q
 ; Return next IEN
NXTIEN() Q:'DIR IEN
 Q:'$L(INDX) $O(@GBL@(IEN),DIR)
 N OK
 F  D  Q:OK!'$L(IDX)
 .S:IEN'>0 IDX=$O(@GBL@(INDX,IDX),DIR),IEN=""
 .S IEN=$S($L(IDX):$O(@GBL@(INDX,IDX,IEN),DIR),1:0)
 .;S OK=$S('IEN:0,1:$E($$FLDVAL(FNUM,IDF,IEN,GBL),1,30)=IDX)
 .S OK=$S('IEN:0,1:$D(@GBL@(IEN,0)))
 Q IEN
 ; Return field value (internal)
 ;  FIL  = File or subfile #
 ;  FLD  = Field #
 ;  IEN  = Record #
 ;  ROOT = Global root of file or subfile, or IENS of subfile
FLDVAL(FIL,FLD,IEN,ROOT) ;
 I FLD=0!(FLD="#") Q IEN
 N PC,ND,DD
 S:FLD'=+FLD FLD=+$O(^DD(FIL,"B",FLD,0))
 S DD=$G(^DD(FIL,FLD,0))
 Q:$P(DD,U,2)["C" $$GET1^DIQ(FIL,IEN_","_$P(ROOT,",",2,999),FLD,"I")
 S ND=$P(DD,U,4),PC=$P(ND,";",2),ND=$P(ND,";")
 S:$E(ROOT)'=U ROOT=$$ROOT^DILFD(FIL,ROOT,1)
 Q $S('$L(ND):"",1:$P($G(@ROOT@(IEN,ND)),U,PC))
 ; RPC: Lock/unlock a record
 ;   FNUM = File #
 ;   IENS = Record # (IENS format)
 ;   WAIT = If >=0, seconds to wait for lock.
 ;          If missing or null, perform unlock operation.
 ;   DATA = Returns 0 if successful, -n^Error Text if not.
LOCK(DATA,FNUM,IENS,WAIT) ;
 N X,IEN,OK,$ET
 S @$$TRAP^CIAUOS("LOCKERR^CIAUDDR")
 S $ET="",X=$$ROOT^DILFD(FNUM,IENS,1),DATA=0,IEN=+IENS
 I '$L(X) S DATA="-1^Table not found"  Q
 K:$G(WAIT)="" WAIT
 D LOCK^CIANBRPC(.OK,$NA(@X@(IEN)),.WAIT)
 S:'OK DATA="-2^Record locked by another process"
 Q
LOCKERR S DATA="-3^Unexpected error"
 Q
 ; RPC: Convert pointer internal<->external
CVTPTR(DATA,FNUM,VAL,EXT) ;
 I EXT S DATA=$$GET1^DIQ(FNUM,VAL,.01)
 E  D
 .N ROOT
 .S ROOT=$$ROOT^DILFD(FNUM,,1)
 .I '$L(ROOT) S DATA=""
 .E  I VAL?1"`"1.N D
 ..S VAL=+$E(VAL,2,999),DATA=$S('VAL:"",$D(@ROOT@(VAL,0))#2:VAL,1:"")
 .E  D
 ..N LP
 ..F LP=0:1:3 S DATA=$$CP(LP) Q:DATA
 Q
 ; Lookup value in "B" xref
CP(XFM) N RTN,LKP
 S LKP=$S(XFM#2:$E(VAL,1,30),1:VAL),LKP=$S(XFM\2:$$UP^XLFSTR(LKP),1:LKP),RTN=0
 F  S RTN=$O(@ROOT@("B",LKP,RTN)) Q:'RTN  Q:$P($G(@ROOT@(RTN,0)),U)=VAL
 Q RTN
 ; RPC: Find an entry using specified fields and values
 ;   FNUM = File number to search
 ;   IENS = IENS for subfile
 ;   FLGS = Search flags.  Combination of:
 ;       P = partial match
 ;       I = case insensitive
 ;   FLDS = Field #'s or names to search.  Can be ;-delimited or list.
 ;   VALS = Values to search.  Can be single value or list.
 ;   MAX  = Maximum entries to return (default=all)
 ;   Returns list of one or all IENs matching criteria or
 ;     -n^error text if error.
FIND(DATA,FNUM,IENS,FLGS,FLDS,VALS,MAX) ;
 N ROOT,QUIT,XRF,XKY,CNT,X
 S IENS=$G(IENS)
 I $L(IENS),$E(IENS)'="," S IENS=","_IENS
 S ROOT=$$ROOT^DILFD(FNUM,IENS,1),QUIT=0,FLGS=$G(FLGS),MAX=+$G(MAX),CNT=0
 S:$D(VALS)=1 VALS(1)=VALS
 I $D(FLDS)=1 F X=1:1:$L(FLDS,";") S FLDS(X)=$P(FLDS,";",X)
 F FLDS=0:0 S FLDS=$O(FLDS(FLDS)) Q:'FLDS  D  Q:QUIT
 .I '$D(VALS(FLDS)) S QUIT="-1^Not enough lookup values." Q
 .S X=$$FLDNUM(FNUM,FLDS(FLDS))
 .I '$L(X) S QUIT="-2^Unknown field "_FLDS(FLDS)_"." Q
 .S FLDS(FLDS)=X
 .I '$D(XRF) D
 ..S X=$$XREF(FNUM,X)
 ..S:$L(X) XRF=X,XKY=$S(FLGS["I":$$UP^XLFSTR(VALS(FLDS)),1:VALS(FLDS))
 I 'QUIT,'$D(XRF) S QUIT="-3^At least one field must be a key field."
 D:'QUIT FINDX
 I QUIT<0 K @DATA S @DATA@(0)=QUIT
 Q
FINDX G FINDN:XRF="#",FINDP:FLGS["P",FINDE
 ; Find by IEN
FINDN D FINDF(XKY)
 Q
 ; Find exact match
FINDE N XKT,IEN
 S IEN=0,XKT=$E(XKY,1,30)
 F  S IEN=$O(@ROOT@(XRF,XKT,IEN)) Q:'IEN  D  Q:QUIT
 .D FINDF(IEN)
 Q
 ; Partial match
FINDP N XKT,VAL,IEN,LEN
 S XKT=$E(XKY,1,30),VAL=XKT,LEN=$L(XKT)
 F  D  S VAL=$O(@ROOT@(XRF,VAL)) Q:$E(VAL,1,LEN)'=XKT!QUIT
 .S IEN=0
 .F  S IEN=$O(@ROOT@(XRF,VAL,IEN)) Q:'IEN  D  Q:QUIT
 ..D FINDF(IEN)
 Q
 ; Check fields for match.  Add to output if all match
FINDF(IEN) ;
 N FND
 S FLDS=0,FND=1
 F  S FLDS=$O(FLDS(FLDS)) Q:'FLDS  D  Q:'FND
 .S FND=$$FINDM(FLDS(FLDS),VALS(FLDS),IEN)
 I FND D
 .S CNT=CNT+1,@DATA@(CNT)=IEN
 .I MAX,CNT'<MAX S QUIT=1
 Q
 ; Check for match
FINDM(FLD,VAL,IEN) ;
 N VALX
 S VALX=$$FLDVAL(FNUM,FLD,IEN,ROOT)
 S:FLGS["I" VAL=$$UP^XLFSTR(VAL),VALX=$$UP^XLFSTR(VALX)
 Q $S(FLGS["P":$E(VALX,1,$L(VAL))=VAL,1:VAL=VALX)
 ; Return field number from name
FLDNUM(FNUM,FLD) ;EP
 Q $S(FLD=+FLD:FLD,FLD="#":0,1:$O(^DD(FNUM,"B",FLD,0)))
 ; Returns the standard xref for the specified field.
XREF(FNUM,FLD,LAST) ;EP
 N XREF
 S LAST=+$G(LAST),XREF="",FLD=$$FLDNUM(FNUM,FLD)
 Q:'$L(FLD) ""
 Q:'FLD "#"
 F  S LAST=$O(^DD(FNUM,FLD,1,LAST)) Q:'LAST  I $D(^(LAST,0)),$P(^(0),U,3)="" S XREF=$P(^(0),U,2) Q
 Q XREF
 ; Returns field # if xref is a standard type, or 0 if not.
XREFFLD(FNUM,XREF) ;EP
 N FLD,LAST,X
 S FLD=$O(^DD(FNUM,0,"IX",XREF,FNUM,0))
 Q:'FLD 0
 F  S X=$$XREF(FNUM,FLD,.LAST) Q:'$L(X)!(X=XREF)
 Q $S($L(X):FLD,1:0)
