BEHWEB ; IHS/BAO/TMD - Infor Button Util ;23-Mar-2011 18:34;PLS
 ;;1.1;BEH COMPONENTS;**054001**;Mar 20, 2007;Build 2
 ;---------------------------------------------
 ; Returns Web Reference Sites
 ;  RET as a list of records in the format:
 ;    Site [1] ^ File IEN [2] ^ URL [3]
GETSITES(RET,DUMMY) ;EP
 N X,Y,CNT,IEN,URL,SITE
 S (X,CNT)=0
 F  S X=$O(^BEHOIFB(90461.71,"AC",X)) Q:'X  D
 .S IEN=0
 .F  S IEN=$O(^BEHOIFB(90461.71,"AC",X,IEN)) Q:'IEN  D
 ..S Y=^BEHOIFB(90461.71,IEN,0)
 ..Q:$P(Y,U,4)
 ..S SITE=$P(Y,U),URL=$P(Y,U,2)
 ..D ADD(SITE_U_IEN_U_URL)
 Q
 ; Add to output array
ADD(X) S CNT=$G(CNT)+1,RET(CNT)=X
 Q
 ; Returns Default Search URL
DEFSURL(RET,DUMMY) ;
 N UIEN
 S UIEN=$$GET^XPAR("ALL","BEH DEFAULT WEB SEARCH SITE")
 S RET=$S(UIEN:$P($G(^BEHOIFB(90461.71,UIEN,0)),U,2),1:"")
 Q
