AUM91011 ; IHS/ASDST/GTH - STANDARD TABLE UPDATES, ICD 99.1 SUPPORT ; [ 11/03/1998  5:26 PM ]
 ;;99.1;TABLE MAINTENANCE;**1**;NOV 6,1998
 ;
 Q
 ;
START ;EP
 ;
 NEW A,C,DIC,DIE,DLAYGO,DR,E,L,N,O,P,R,S,T
 S E(0)="ERROR : ",E(1)="NOT ADDED : "
 D DASH,RCDADD,DASH
 Q
 ; ===   utility sub-routines   ====
 ;
ADDOK D RSLT($J("",5)_"Added : "_L) Q
ADDFAIL D RSLT($J("",5)_E(0)_"ADD FAILED => "_L) Q
DASH D RSLT(""),RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70))),RSLT("") Q
DIE NEW A,C,E,L,M,N,O,P,R,S,T
 LOCK +(@(DIE_DA_")")):10 E  D RSLT($J("",5)_E(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) KILL DA,DIE,DR Q
E(L) Q $P($P($T(@L^AUM9101A),";",3),":",1)
DIK NEW A,C,E,L,M,N,O,P,R,S,T D ^DIK KILL DIK Q
FILE NEW A,C,E,L,M,N,O,P,R,S,T K DD,DO S DIC(0)="L" D FILE^DICN KILL DIC Q
RSLT(%) S ^(0)=$G(^TMP("AUM9101",$J,0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,% Q
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
ADDRCD ;
 S L=$P(L,";;",2),C=$P(L,U),R=$P(L,U,2),N=$P(L,U,3),L=C_" "_R_"  "_N
 I $D(^AUTTRCD("B",C)) D RSLT($J("",5)_E(1)_" : RECODE ICD/APC EXISTS => "_C) Q
 S DLAYGO=9999999.08,DIC="^AUTTRCD(",X=C,DIC("DR")=".02///"_R_";.03///"_N
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 I Y>0,'$D(^AUTTRCD(+Y,11)) S %=$$ZEROTH(9999999.08,1101) I '(%=-1) S ^AUTTRCD(+Y,11,0)=%
 Q
 ;
RCDADD ;
 D RSLT($$E("RCDADD"))
 D RSLT($J("",14)_"CODE ICD CODE NARRATIVE"_$J("",16)_"  LO ICD9  HI ICD9")
 D RSLT($J("",14)_"---- -------- ---------"_$J("",16)_"  -------  -------")
 F T=1:1 S L=$T(RCDADD+T^AUM9101A) Q:$P(L,";",3)="END"  D
 . S L=$P(L,";;",2),C=$P(L,U),R=$P(L,U,2),N=$P(L,U,3),O=$P(L,U,4),S=$P(L,U,5)
 . S P=$O(^AUTTRCD("B",C,0))
 . I 'P S L=";;"_L D ADDRCD Q:Y<0
 . S L=C_"  "_R_$J("",7-$L(R))_"  "_N_$J("",25-$L(N))_"  "_O_$J("",7-$L(O))_"  "_S
 . I $O(^AUTTRCD(P,11,"B",$E(O,1,30),0)),$O(^AUTTRCD(P,11,"B",$E(O,1,30),0))=$O(^AUTTRCD("AH",S_" ",P,0)) D RSLT($J("",5)_"Range Exists (That's OK)"),RSLT($J("",11)_"=> "_L) Q
 . I '$D(^AUTTRCD(P,11)) S ^(11,0)="^9999999.81101^^"
 . S DIC="^AUTTRCD("_P_",11,",X=O,DA(1)=P
 . D FILE
 . I Y<0 D RSLT($J("",5)_E(0)_" : ADD RANGE FAILED => "_L) Q
 . S DIE="^AUTTRCD("_P_",11,",DA(1)=P,DA=+Y,P(1)=DA,DR=".02///"_S
 . D DIE
 . I $D(Y) D RSLT($J("",5)_E(0)_" : ADD RANGE FAILED => "_L) S DA(1)=P,DA=P(1),DIK="^AUTTRCD("_DA(1)_",11," D DIK Q
 . D RSLT($J("",5)_"Added => "_L)
 .Q
 Q
 ;
