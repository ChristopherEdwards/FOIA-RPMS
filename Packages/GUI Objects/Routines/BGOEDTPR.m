BGOEDTPR ; IHS/BAO/TMD - EDUCATION TOPIC PREFERENCES MANAGER ;03-Sep-2008 13:28;PLS
 ;;1.1;BGO COMPONENTS;**1,3,4,5**;Mar 20, 2007
 ; Patch 5 delivers logic to import education pick-lists.
 ; Validates an education topic
VALIDATE(RET,IEN,CODE) ;EP
 I 'IEN,$G(CODE)'="" D
 .N X
 .S IEN=-1
 .F X=0:0 S X=$O(^AUTTEDT("C",CODE,X)) Q:'X  S IEN=X Q:'$P($G(^AUTTEDT(IEN,0)),U,3)
 I 'IEN S RET=$$ERR^BGOUTL(1023)
 E  I '$D(^AUTTEDT(IEN,0)) S RET=$$ERR^BGOUTL(1024)
 E  I $P(^AUTTEDT(IEN,0),U,3) S RET=$$ERR^BGOUTL(1025)
 E  S RET=""
 Q
 ; Return long name for an education topic
GETLNAME(RET,IEN) ;EP
 I 'IEN S RET=$$ERR^BGOUTL(1023)
 E  S RET=$P($G(^AUTTEDT(+IEN,0)),U)
 Q
 ; Return categories matching specified criteria
 ;  INP = Category IEN [1] ^ Hospital Location IEN [2] ^ Provider IEN [3] ^ Manager IEN [4] ^ Show All [5]
GETCATS(RET,INP) ;EP
 D GETCATS^BGOPFUTL(.RET,INP,90362.36)
 Q
 ; Returns list of education topics for specified category
 ;  INP = Category IEN [1] ^ Group [2] ^ Visit IEN [3] ^ Display Freq Order [4]
 ;  Returns a list of records in the format:
 ;   Topic IEN [1] ^ Topic Text [2] ^ Freq [3] ^ VPED IEN [4] ^ Rank [5] ^ Item IEN [6] ^ Mnemonic [7]
GETITEMS(RET,INP) ;EP
 N DX,J,TXT,FREQ,VIEN,GRP,CAT,CNT,VPX,FREQ,RANK,IEN
 S RET=$$TMPGBL^BGOUTL
 S CAT=+INP
 I 'CAT S @RET@(1)=$$ERR^BGOUTL(1018) Q
 I '$D(^BGOEDTPR(CAT,0)) S @RET@(1)=$$ERR^BGOUTL(1019) Q
 S GRP=$P(INP,U,2)
 S VIEN=$P(INP,U,3)
 S FREQ=$P(INP,U,4)
 S:$P(^BGOEDTPR(CAT,0),U,6) GRP=""
 I VIEN D
 .S VPX=0
 .F  S VPX=$O(^AUPNVPED("AD",VIEN,VPX)) Q:'VPX  D
 .S:$D(^AUPNVPED(VPX,0)) VPX(+^(0))=VPX
 S (CNT,RANK)=0
 I FREQ D
 .S J=""
 .F  S J=$O(^BGOEDTPR(CAT,1,"AC",J),-1) Q:J=""  D
 ..S IEN=0
 ..F  S IEN=$O(^BGOEDTPR(CAT,1,"AC",J,IEN)) Q:'IEN  D GE1
 E  D
 .S IEN=0
 .F  S IEN=$O(^BGOEDTPR(CAT,1,IEN)) Q:'IEN  D GE1
 Q
GE1 N N0,EDT,TXT,CATP,FREQVAL,MNEM
 S N0=$G(^BGOEDTPR(CAT,1,IEN,0))
 S EDT=+N0
 Q:'EDT
 Q:'$D(^AUTTEDT(EDT,0))
 S TXT=$P(^AUTTEDT(EDT,0),U),MNEM=$P(^(0),U,2),CATP=$P(^(0),U,6)
 I $P(TXT,"-",2)'="",CATP'="" D
 .S CATP=$O(^AUTTEDMT("B",CATP,0))
 .Q:'CATP
 .S TXT=$P($G(^AUTTEDMT(CATP,0)),U)_"-"_$P(TXT,"-",2)
 S:$P(N0,U,2)'="" TXT=$P(N0,U,2)
 I FREQ D
 .S RANK=RANK+1
 .S RANK=$S(RANK<10:"00",RANK<100:"0",1:"")_RANK
 S FREQVAL=$P(N0,U,3)
 S CNT=CNT+1
 S @RET@(CNT)=EDT_U_TXT_U_FREQVAL_U_$G(VPX(EDT))_U_RANK_U_IEN_U_MNEM
 Q
 ; Return list of managers associated with a specified category
GETMGRS(RET,CAT) ;EP
 D GETMGRS^BGOPFUTL(.RET,CAT,90362.36)
 Q
 ; Set category fields
 ;  INP = Name [1] ^ Hosp Loc [2] ^ Clinic [3] ^ Provider [4] ^ User [5] ^ Category IEN [6] ^ Delete [7] ^ Discipline [8]
SETCAT(RET,INP) ;EP
 D SETCAT^BGOPFUTL(.RET,INP,90362.36)
 Q
 ; Set field values for an education topic preference entry
 ;  INP = Category IEN [1] ^ Education Topic IEN [2] ^ Display Text [3] ^ Delete [4] ^ Mnemonic [5] ^ Frequency [6] ^
 ;        Allow Dups [7] ^ Item IEN [8]
SETITEM(RET,INP) ;EP
 ;Patch 5 start
 N NAME,ACTIVE,IEN,ACTIVE,DONE,NCAT,NMN,NAME1
 S DONE=0,NCAT=""
 S NAME=$P(INP,U,3)
 I NAME'="" D
 .S NAME1=$P(NAME,"-",1)
 .S NCAT=$O(^AUTTEDMT("B",NAME1,NCAT)) Q:NCAT=""  D
 ..S NMN=$P($G(^AUTTEDMT(NCAT,0)),U,2)
 ..I NAME1'=NMN S NAME=NMN_"-"_$P(NAME,"-",2)
 .I NAME'="" D
 ..S IEN="" F  S IEN=$O(^AUTTEDT("B",NAME,IEN))  Q:IEN=""!(DONE=1)  D
 ...S ACTIVE=$P($G(^AUTTEDT(IEN,0)),U,3)
 ...I ACTIVE="" S DONE=1 S $P(INP,U,2)=IEN
 ;Patch 5 end
 D SETITEM^BGOPFUTL(.RET,INP,90362.36)
 Q
 ; Add or remove a manager from a category
 ;  INP = Category IEN [1] ^ Manager IEN [2] ^ Add [3]
SETMGR(RET,INP) ;EP
 D SETMGR^BGOPFUTL(.RET,INP,90362.362)
 Q
 ; Set display name for a preference
 ;  INP = Category IEN [1] ^ Item IEN [2] ^ Display Name [3]
SETNAME(RET,INP) ;EP
 D SETNAME^BGOPFUTL(.RET,INP,90362.361)
 Q
 ; Set frequency for an education topic
 ;  INP = Category IEN [1] ^ Item Value [2] ^ Increment [3] ^ Frequency [4]
SETFREQ(RET,INP) ;EP
 D SETFREQ^BGOPFUTL(.RET,INP,90362.361)
 Q
