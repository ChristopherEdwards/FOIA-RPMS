BGOWEB ; IHS/BAO/TMD - Browser Util ;27-May-2008 11:02;PLS
 ;;1.1;BGO COMPONENTS;**1,3,5**;Mar 20, 2007
 ;---------------------------------------------
 ; Returns Web Reference Sites
 ;  RET as a list of records in the format:
 ;    Site [1] ^ File IEN [2] ^ URL [3]
GETSITES(RET,DUMMY) ;EP
 N X,Y,CNT,IEN,URL,SITE
 S (X,CNT)=0
 F  S X=$O(^BGOWEBS("AC",X)) Q:'X  D
 .S IEN=0
 .F  S IEN=$O(^BGOWEBS("AC",X,IEN)) Q:'IEN  D
 ..S Y=^BGOWEBS(IEN,0)
 ..Q:$P(Y,U,4)
 ..S SITE=$P(Y,U),URL=$P(Y,U,2)
 ..D ADD(SITE_U_IEN_U_URL)
 Q
 ; Returns Web Links
 ;  INP = User IEN ^ Category IEN
 ;  RET returned as a list of web links
GETREF(RET,INP) ;EP
 D GETLINKS(.RET,INP,"B")
 Q
 ; Returns Web Link categories
 ;  USR = User IEN
 ;  RET returned as a list of categories
GETCATS(RET,USR) ;EP
 D GETLINKS(.RET,+USR,"C")
 Q
 ; Return list of entries from WEB LINKS file
GETLINKS(RET,INP,XRF) ;EP
 N X,Y,CNT,IEN,CAT,USR
 S USR=+INP
 S CAT=$P(INP,U,2)
 S X="",CNT=0
 F  S X=$O(^BGOLINKS(XRF,X)) Q:X=""  D
 .S IEN=$O(^BGOLINKS(XRF,X,0))
 .Q:'IEN
 .S Y=^BGOLINKS(IEN,0)
 .I $P(Y,U,3),$P(Y,U,3)'=USR Q
 .I CAT'="",$P(Y,U,2)'="",$P(Y,U,2)'=CAT Q
 .D ADD(X)
 Q
 ; Returns web ref links
 ;  INP = Type [1] ^ Value [2] ^ Category [3] ^ URL [4]
 ;  Returns list of records in the format
 ;   Name [1]^ URL [2] ^ Link IEN [3] ^ Value [4] ^ Type [5]
GET(RET,INP) ;EP
 N TYP,VAL,XREF,URL,NAM,CNT,X,Y
 S TYP=+INP
 S VAL=$P(INP,U,2)
 S CAT=$P(INP,U,3)
 S URL=$P(INP,U,4)
 S CNT=0
 I TYP D
 .S TYP=$$TYP2GBL(TYP),X=0
 .Q:TYP=""
 .F  S X=$O(^BGOLINKS("AA",TYP,VAL,X)) Q:'X  D G1
 E  I CAT'="" D
 .S X=0
 .F  S X=$O(^BGOLINKS("C",CAT,X)) Q:'X  D G1
 E  I URL'="" D
 .S X=0
 .F  S X=$O(^BGOLINKS("AU",URL,X)) Q:'X  D G1
 Q
G1 N Y,NAM,CAT,URL
 S Y=$G(^BGOLINKS(X,0))
 I $P(Y,U,3),$P(Y,U,3)'=DUZ Q
 S NAM=$P(Y,U)
 Q:NAM=""
 S CAT=$P(Y,U,2)
 S URL=$P($G(^BGOLINKS(X,1)),U)
 Q:URL=""
 D ADD(NAM_U_URL_U_X_U_VAL_U_TYP)
 Q
 ; Delete a web link
 ;  INP = IEN to delete [1] ^ Reference to delete [2] ^ Link Type [3]
DEL(RET,INP) ;EP
 N REF,DA,DIK,Y,CAC,TYP
 S DA=$P(INP,U),REF=+$P(INP,U,2),TYP=+$P(INP,U,3)
 Q:'DA
 I '$$HASKEY^BEHOUSCX("BGOZ CAC"),$P(^BGOLINKS(DA,0),U,3),DUZ='$P(^(0),U,3) S RET=$$ERR^BGOUTL(1107) Q
 I 'REF S DIK="^BGOLINKS("
 E  D
 .S DA(1)=DA
 .S REF=REF_";"_$$TYP2GBL(TYP)
 .S DA=$O(^BGOLINKS(DA,11,"B",REF,0))
 .S DIK="^BGOLINKS(DA(1),11,"
 S:DA RET=$$DELETE^BGOUTL(DIK,.DA)
 Q
 ; Set web reference
 ; INP = Type [1] ^ Value [2] ^ Name [3] ^ URL [4] ^ User IEN [5] ^ Value 2 [6] ^ Category [7]
SET(RET,INP) ;EP
 N TYP,VAL,X,URL,NAM,I,LNKIEN,XREF,SUB,USR,VAL2,CAT,FDA,IEN,GBL
 S TYP=$$TYP2GBL(+INP),RET=""
 I TYP="" S RET=$$ERR^BGOUTL(1108) Q
 S VAL=+$P(INP,U,2)
 I 'VAL S RET=$$ERR^BGOUTL(1109) Q
 S NAM=$P(INP,U,3)
 S URL=$P(INP,U,4)
 S USR=$P(INP,U,5)
 S VAL2=+$P(INP,U,6)
 S CAT=$P(INP,U,7)
 S LNKIEN=$O(^BGOLINKS("AU",URL,0))
 S FDA=$NA(FDA(90362.21,$S(LNKIEN:LNKIEN,1:"+1")_","))
 S @FDA@(.01)=NAM
 S:CAT @FDA@(.02)="`"_CAT
 S:USR @FDA@(.03)="`"_USR
 S @FDA@(.11)=URL
 S RET=$$UPDATE^BGOUTL(.FDA,"E@",.IEN)
 Q:RET
 S:'LNKIEN LNKIEN=IEN(1)
 I 'VAL2 D S1(VAL) Q
 S GBL=$$CREF^DILF(U_TYP)
 S VAL=$P($G(@GBL@(VAL,0)),U)
 Q:VAL=""
 S VAL2=$P($G(@GBL@(VAL2,0)),U)
 Q:VAL2=""
 F  D  S VAL=$O(@GBL@("BA",VAL)) Q:VAL>VAL2!(VAL="")!RET
 .S X=$O(@GBL@("BA",VAL,0))
 .D:X S1(X)
 Q
 ; Add a pointer to web link
S1(VAL) N FDA
 Q:$O(^BGOLINKS("AA",TYP,VAL,LNKIEN,0))
 S FDA=$NA(FDA(90362.2111,"+1,"_LNKIEN_","))
 S @FDA@(.01)=VAL_";"_TYP
 S RET=$$UPDATE^BGOUTL(.FDA)
 S:-RET=305 RET=""  ; No data error is normal
 Q
 ; Convert type index to global reference
TYP2GBL(X) ;
 Q $P("ICPT(^ICPT(^ICD9(^ICD9(^AUTTEDT(^AUTTEXAM(^AUTTIMM(^AUTTSK(",U,X+1)
 ; Add to output array
ADD(X) S CNT=$G(CNT)+1,RET(CNT)=X
 Q
 ; Returns Default Search URL
DEFSURL(RET,DUMMY) ;
 N UIEN
 S UIEN=$$GET^XPAR("ALL","BGO DEFAULT WEB SEARCH SITE")
 S RET=$S(UIEN:$P($G(^BGOWEBS(UIEN,0)),U,2),1:"")
 Q
