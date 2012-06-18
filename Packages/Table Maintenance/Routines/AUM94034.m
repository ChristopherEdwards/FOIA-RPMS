AUM94034 ; DSD/GTH - STANDARD TABLE UPDATES (4), 31MAR94 BANYAN ; [ 04/08/94  1:06 PM ]
 ;;94.1;TABLE MAINTENANCE;**3**;DECEMBER 15, 1993
 ;
 Q
 ;
START ;EP
 ;
 NEW A,C,DIC,DIE,DLAYGO,DR,E,L,N,O,P,R,S,T
 S E(0)="ERROR : ",E(1)="NOT ADDED : "
 D CHAADD,RCDNEW,RCDADD,RCDDEL,ICD0ACT,ICD0INAC
 Q
 ; ===   utility sub-routines   ====
 ;
ADDOK D RSLT(E_", Added : "_L) Q
ADDFAIL D RSLT(E(0)_E_" : ADD FAILED => "_L) Q
DIE NEW A,C,E,L,N,O,P,R,S,T
 LOCK +(@(DIE_DA_")")):10 E  D RSLT(E(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) K DA,DIE,DR Q
DIK NEW A,C,E,L,N,O,P,R,S,T D ^DIK K DIK Q
FILE NEW A,C,E,L,N,O,P,R,S,T K DD,DO S DIC(0)="L" D FILE^DICN K DIC Q
MODOK D RSLT(E_", Changed : "_L) Q
RSLT(%) S ^(0)=$G(^TMP($J,"RSLT",0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,% Q
 ;
 ; =================================
 ;
CHANEW ;
 S E="New CHA ICD Recode Table"
 F T=1:1 S L=$T(CHANEW+T^AUM9403D) Q:$P(L,";",3)="END"  I $P(L,U,$L(L,U))="Y" D ADDCHA
 Q
 ;
ADDCHA ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),L=C_" "_N
 I $D(^AUTTCHA("B",C)) D RSLT(E(1)_E_" : CHA ICD RECODE EXISTS => "_C) Q
 S DLAYGO=9999999.74,DIC="^AUTTCHA(",X=C,DIC("DR")=".03///"_N D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 I Y>0,'$D(^AUTTCHA(+Y,11)) S ^(11,0)="^9999999.7411^^"
 Q
 ;
CHAADD ;
 S E="CHA ICD Recode, add range"
 F T=1:1 S L=$T(CHAADD+T^AUM9403D) Q:$P(L,";",3)="END"  I $P(L,U,$L(L,U))="Y" D
 .S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),O=$P(L,U,3),S=$P(L,U,4)
 .S P=$O(^AUTTCHA("B",C,0))
 .I 'P S L=";;"_L D ADDCHA Q:Y<0
 .S L=C_" "_N_"  "_O_"  "_S
 .I $O(^AUTTCHA(P,11,"B",$E(O,1,30),0)),$O(^AUTTCHA(P,11,"B",$E(O,1,30),0))=$O(^AUTTCHA("AH",S_" ",P,0)) D RSLT(E_" : RANGE EXISTS => "_L) Q
 .S DIC="^AUTTCHA("_P_",11,",X=O,DA(1)=P D FILE
 .I Y<0 D RSLT(E(0)_E_" : ADD RANGE FAILED => "_L) Q
 .S DIE="^AUTTCHA("_P_",11,",DA(1)=P,DA=+Y,P(1)=DA,DR=".02///"_S D DIE
 .I $D(Y) D RSLT(E(0)_E_" : ADD RANGE FAILED => "_L) S DA(1)=P,DA=P(1),DIK="^AUTTCHA("_DA(1)_",11," D DIK Q
 .D RSLT(E_" : Added => "_L)
 .Q
 Q
 ;
RCDNEW ;
 S E="New Recode ICD/APC"
 F T=1:1 S L=$T(RCDNEW+T^AUM9403D) Q:$P(L,";",3)="END"  I $P(L,U,$L(L,U))="Y" D ADDRCD
 Q
 ;
ADDRCD ;
 S L=$P(L,";;",2),C=$P(L,U),R=$P(L,U,2),N=$P(L,U,3),L=C_" "_R_"  "_N
 I $D(^AUTTRCD("B",C)) D RSLT(E(1)_E_" : RECODE ICD/APC EXISTS => "_C) Q
 S DLAYGO=9999999.08,DIC="^AUTTRCD(",X=C,DIC("DR")=".02///"_R_";.03///"_N D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 I Y>0,'$D(^AUTTRCD(+Y,11)) S ^(11,0)="^9999999.81101^^"
 Q
 ;
RCDADD ;
 S E="Recode ICD/APC, add range"
 F T=1:1 S L=$T(RCDADD+T^AUM9403D) Q:$P(L,";",3)="END"  I $P(L,U,$L(L,U))="Y" D
 .S L=$P(L,";;",2),C=$P(L,U),R=$P(L,U,2),N=$P(L,U,3),O=$P(L,U,4),S=$P(L,U,5)
 .S P=$O(^AUTTRCD("B",C,0))
 .I 'P S L=";;"_L D ADDRCD Q:Y<0
 .S L=C_" "_R_"  "_N_"  "_O_"  "_S
 .I $O(^AUTTRCD(P,11,"B",$E(O,1,30),0)),$O(^AUTTRCD(P,11,"B",$E(O,1,30),0))=$O(^AUTTRCD("AH",S_" ",P,0)) D RSLT(E_" : RANGE EXISTS => "_L) Q
 .I '$D(^AUTTRCD(P,11)) S ^(11,0)="^9999999.81101^^"
 .S DIC="^AUTTRCD("_P_",11,",X=O,DA(1)=P D FILE
 .I Y<0 D RSLT(E(0)_E_" : ADD RANGE FAILED => "_L) Q
 .S DIE="^AUTTRCD("_P_",11,",DA(1)=P,DA=+Y,P(1)=DA,DR=".02///"_S D DIE
 .I $D(Y) D RSLT(E(0)_E_" : ADD RANGE FAILED => "_L) S DA(1)=P,DA=P(1),DIK="^AUTTRCD("_DA(1)_",11," D DIK Q
 .D RSLT(E_" : Added => "_L)
 .Q
 Q
 ;
RCDDEL ;
 S E="Recode ICD/APC, delete range"
 F T=1:1 S L=$T(RCDDEL+T^AUM9403D) Q:$P(L,";",3)="END"  I $P(L,U,$L(L,U))="Y" D
 .S L=$P(L,";;",2),C=$P(L,U),R=$P(L,U,2),N=$P(L,U,3),O=$P(L,U,4),S=$P(L,U,5),L=C_" "_R_"  "_N_"  "_O_"  "_S
 .S P=$O(^AUTTRCD("B",C,0))
 .I 'P D RSLT(E_" : Code does not exist => "_L) Q
 .I '$O(^AUTTRCD(P,11,"B",$E(O,1,30),0)) D RSLT(E_" : Range does not exist => "_L) Q
 .I $O(^AUTTRCD(P,11,"B",$E(O,1,30),0))'=$O(^AUTTRCD("AH",S_" ",P,0)) D RSLT(E_" : Range does not exist => "_L) Q
 .S DA(1)=P,DA=$O(^AUTTRCD(P,11,"B",$E(O,1,30),0)),DIK="^AUTTRCD("_DA(1)_",11," D DIK
 .D RSLT(E_" : Deleted => "_L)
 .Q
 Q
 ;
ICD0ACT ;
 S E="ICD0, Activate"
 F T=1:1 S L=$T(ICD0ACT+T^AUM9403D) Q:$P(L,";",3)="END"  I $P(L,U,$L(L,U))="Y" D
 .S L=$P(L,";;",2),C=$P(L,U),L=C
 .S P=$O(^ICD0("B",C,0))
 .I 'P S P=$O(^ICD0("AB",C,0))
 .I 'P S P=$O(^ICD0("BA",C_" ",0))
 .I 'P,+C[$P(C,".",1) S P=$O(^ICD0("BA",+C,0))
 .I 'P D RSLT(E_" : Code does not exist => "_L) Q
 .S DIE="^ICD0(",DA=P,DR="100///@;102///@" D DIE
 .I $D(Y) D RSLT(E(0)_E_" : EDIT ICD0 FAILED => "_L) Q
 .D RSLT(E_" : Activated => "_L)
 .Q
 Q
 ;
ICD0INAC ;
 S E="ICD0, IN-Activate"
 F T=1:1 S L=$T(ICD0INAC+T^AUM9403D) Q:$P(L,";",3)="END"  I $P(L,U,$L(L,U))="Y" D
 .S L=$P(L,";;",2),C=$P(L,U),O=$P(L,U,2),L=C_"  "_O
 .S P=$O(^ICD0("B",C,0))
 .I 'P S P=$O(^ICD0("AB",C,0))
 .I 'P S P=$O(^ICD0("BA",C_" ",0))
 .I 'P,+C[$P(C,".",1) S P=$O(^ICD0("BA",+C,0))
 .I 'P D RSLT(E_" : Code does not exist => "_L) Q
 .S DIE="^ICD0(",DA=P,DR="100///1;102///"_O D DIE
 .I $D(Y) D RSLT(E(0)_E_" : EDIT ICD0 FAILED => "_L) Q
 .D RSLT(E_" : IN-Activated => "_L)
 .Q
 Q
 ;
