XBUTL ;IHS/ITSC/CLS - XB MISCELLANEOUS UTILITIES [ 10/06/2005  9:59 AM ]
 ;;3.0;IHS/VA UTILITIES;**11**;July 20, 2005
 ;
LINK(P,C) ;link protocols child to parent
 ;Input: P-Parent protocol
 ;       C-Child protocol
 N IENARY,PIEN,AIEN,FDA,ERR
 Q:'$L(P)!('$L(C))
 S IENARY(1)=$$FIND1^DIC(101,"","",P)
 S AIEN=$$FIND1^DIC(101,"","",C)
 Q:'IENARY(1)!'AIEN
 S FDA(101.01,"?+2,"_IENARY(1)_",",.01)=AIEN
 D UPDATE^DIE("S","FDA","IENARY","ERR")
 ;I $G(ERR("DIERR",1)) W ! ZW ERR  ;IHS/CIA/PLS for debugging use
 Q
LUHN(X) ;calulate check digit, Luhn formula for NPI
 ;x=10 digit number
 I '+X S X=0 Q X
 I $E(X,1,5)=80840 D
 .S X=$E(X,6,15)
 S XBSTRING=""
 I X'?10N S X=0 Q X
 S XBCD=$E(X,10)
 F I=1:1:9 D
 .I (I#2) D
 ..S XBSTRING=XBSTRING_($E(X,I)*2)
 .I '(I#2) D
 ..S XBSTRING=XBSTRING_$E(X,I)
 S XBTOT=0
 F I=1:1:$L(XBSTRING) D
 .S XBTOT=XBTOT+$E(XBSTRING,I)
 S XBTOT=XBTOT+24
 S XBTOT=1000-XBTOT
 S X=$E(XBTOT,$L(XBTOT))
 I X'=XBCD S X=0 Q X
 S X=1 Q X
