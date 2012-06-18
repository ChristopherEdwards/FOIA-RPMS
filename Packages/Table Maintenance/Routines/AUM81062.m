AUM81062 ; IHS/ASDST/GTH - STANDARD TABLE UPDATES, 5&6OCT1998 MESSAGES ; [ 10/27/1998  11:32 AM ]
 ;;98.1;TABLE MAINTENANCE;**6**;NOV 17,1997
 ;
 Q
 ;
START ;EP
 ;
 NEW A,C,DIC,DIE,DLAYGO,DR,E,L,N,O,P,R,S,T
 S E(0)="ERROR : ",E(1)="NOT ADDED : "
 D DASH,CHAADD,DASH
 Q
 ; ===   utility sub-routines   ====
 ;
ADDOK D RSLT($J("",5)_"Added : "_L) Q
ADDFAIL D RSLT($J("",5)_E(0)_" : ADD FAILED => "_L) Q
DASH D RSLT(""),RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70))),RSLT("") Q
DIE NEW A,C,E,L,N,O,P,R,S,T
 LOCK +(@(DIE_DA_")")):10
 E  D RSLT($J("",5)_E(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE
 LOCK -(@(DIE_DA_")"))
 KILL DA,DIE,DR
 Q
DIK NEW A,C,E,L,N,O,P,R,S,T D ^DIK KILL DIK Q
FILE NEW A,C,E,L,N,O,P,R,S,T KILL DD,DO S DIC(0)="L" D FILE^DICN KILL DIC Q
MODOK D RSLT($J("",5)_"Changed : "_L) Q
RSLT(%) S ^(0)=$G(^TMP("AUM8106",$J,0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,% Q
ZEROTH(A,B,C,D,E,F,G,H,I,J,K) ; Return 0th node.  A is file #, rest fields.
 I '$G(A) Q -1
 I '$G(B) Q -1
 F %=67:1:75 Q:'$G(@($C(%)))  S A=+$P(^DD(A,B,0),U,2),B=@($C(%))
 I 'A!('B) Q -1
 I '$D(^DD(A,B,0)) Q -1
 Q U_$P(^DD(A,B,0),U,2)
 ;
 ; =================================
 ;
CHANEW ;
 D RSLT("New CHA ICD Recode Table")
 F T=1:1 S L=$T(CHANEW+T^AUM8106A) Q:$P(L,";",3)="END"  D ADDCHA
 Q
 ;
ADDCHA ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),L=C_" "_N
 I $D(^AUTTCHA("B",C)) D RSLT($J("",5)_E(1)_" : CHA ICD RECODE EXISTS => "_C) Q
 S DLAYGO=9999999.74,DIC="^AUTTCHA(",X=C,DIC("DR")=".03///"_N
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 I Y>0,'$D(^AUTTCHA(+Y,11)) S %=$$ZEROTH(9999999.74,1101) I '(%=-1) S ^AUTTCHA(+Y,11,0)=%
 Q
 ;
CHAADD ;
 D RSLT("CHA ICD Recode, Add Range")
 F T=1:1 S L=$T(CHAADD+T^AUM8106A) Q:$P(L,";",3)="END"  D
 . S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),O=$P(L,U,3),S=$P(L,U,4)
 . S P=$O(^AUTTCHA("B",C,0))
 . I 'P S L=";;"_L D ADDCHA Q:Y<0
 . S L=C_" "_N_"  "_O_"  "_S
 . I $O(^AUTTCHA(P,11,"B",$E(O,1,30),0)),$O(^AUTTCHA(P,11,"B",$E(O,1,30),0))=$O(^AUTTCHA("AH",S_" ",P,0)) D RSLT($J("",5)_"Range Exists (That's OK)"),RSLT($J("",10)_"=> "_L) Q
 . I '$D(^AUTTCHA(P,11)) S %=$$ZEROTH(9999999.74,1101) I '(%=-1) S ^AUTTCHA(P,11,0)=%
 . S DIC="^AUTTCHA("_P_",11,",X=O,DA(1)=P
 . D FILE
 . I Y<0 D RSLT($J("",5)_E(0)_" : ADD RANGE FAILED => "_L) Q
 . S DIE="^AUTTCHA("_P_",11,",DA(1)=P,DA=+Y,P(1)=DA,DR=".02///"_S
 . D DIE
 . I $D(Y) D RSLT($J("",5)_E(0)_" : ADD RANGE FAILED => "_L) S DA(1)=P,DA=P(1),DIK="^AUTTCHA("_DA(1)_",11," D DIK Q
 . D RSLT($J("",5)_"Added => "_L)
 .Q
 Q
 ;
