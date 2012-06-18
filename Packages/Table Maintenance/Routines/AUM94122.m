AUM94122 ; DSD/GTH - STANDARD TABLE UPDATES (2), 05DEC94 BANYAN ; [ 12/06/94  11:41 AM ]
 ;;95.1;TABLE MAINTENANCE;**1**;NOV 1, 1994
 ;
 Q
 ;
START ;EP
 ;
 NEW A,C,DIC,DIE,DLAYGO,DR,E,L,N,O,P,R,S,T
 S E(0)="ERROR : ",E(1)="NOT ADDED : "
 D COMMNEW,COMMDEL
 Q
 ; ===   utility sub-routines   ====
 ;
ADDOK D RSLT(E_", Added : "_L) Q
ADDFAIL D RSLT(E(0)_E_" : ADD FAILED => "_L) Q
DIE NEW A,C,E,L,N,O,P,R,S,T
 LOCK +(@(DIE_DA_")")):10 E  D RSLT(E(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) K DA,DIE,DR Q
FILE NEW A,C,E,L,N,O,P,R,S,T K DD,DO S DIC(0)="L" D FILE^DICN K DIC Q
MODOK D RSLT(E_", Changed : "_L) Q
RSLT(%) S ^(0)=$G(^TMP($J,"RSLT",0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,% Q
 ;
 ; =================================
 ;
COMMNEW ;
 S E="New Community Codes"
 F T=1:1 S L=$T(COMMNEW+T^AUM9412A) Q:$P(L,";",3)="END"  D ADDCOMM
 Q
 ;
ADDCOMM ;
 S L=$P(L,";;",2),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6),L=S_" "_O_" "_C_" "_N_" "_A_" "_V
 I $D(^AUTTCOM("C",S_O_C)) D RSLT(E(1)_E_" : STCTYCOM CODE EXISTS => "_S_O_C) Q
 S P("O")=$$IEN^AUM94121("^AUTTCTY(",S_O) Q:'P("O")
 S P("A")=$$IEN^AUM94121("^AUTTAREA(",A) Q:'P("A")
 S P("V")=$$IEN^AUM94121("^AUTTSU(",A_V) Q:'P("V")
 S DLAYGO=9999999.05,DIC="^AUTTCOM(",X=N,DIC("DR")=".02////"_P("O")_";.05////"_P("V")_";.06////"_P("A")_";.07///"_C D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
COMMMOD ;
 S E="Community Code Changes"
 F T=1:2 S L=$T(COMMMOD+T^AUM9412A) Q:$P(L,";",3)="END"  S L("TO")=$T(COMMMOD+T+1^AUM9412A) D
 .S L=$P(L,U,2,99),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3)
 .S P=$O(^AUTTCOM("C",S_O_C,0))
 .S L=$P(L("TO"),U,2,99),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6)
 .I 'P S P=$O(^AUTTCOM("C",S_O_C,0)) I 'P S L=";;"_L D ADDCOMM Q
 .S L=S_" "_O_" "_C_" "_N_" "_A_" "_V
 .S P("O")=$$IEN^AUM94121("^AUTTCTY(",S_O) Q:'P("O")
 .S P("A")=$$IEN^AUM94121("^AUTTAREA(",A) Q:'P("A")
 .S P("V")=$$IEN^AUM94121("^AUTTSU(",A_V) Q:'P("V")
 .S DIE="^AUTTCOM(",DA=P,DR=".01///"_N_";.02////"_P("O")_";.05////"_P("V")_";.06////"_P("A")_";.07///"_C D DIE
 .I $D(Y) D RSLT(E(0)_E_" : CHANGE FAILED => "_L) Q
 .D MODOK
 .Q
 Q
 ;
COMMDEL ;
 S E="Community Inactivation"
 F T=1:1 S L=$T(COMMDEL+T^AUM9412A) Q:$P(L,";",3)="END"  D
 .S L=$P(L,";;",2),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6),L=S_" "_O_" "_C_" "_N_" "_A_" "_V
 .S P=$O(^AUTTCOM("C",S_O_C,0))
 .I 'P D RSLT(E_" : COMMUNITY NOT FOUND (That's OK) => "_L) Q
 .S DIE="^AUTTCOM(",DA=P,DR=".14///<INACTIVE>" D DIE
 .I $D(Y) D RSLT(E(0)_E_" : EDIT FAILED => "_L) Q
 .D RSLT(E_" : SHORT NAME MARKED '<INACTIVE>' => "_L) Q
 .Q
 Q
 ;
TRIBNEW ;
 S E="New Tribe Codes"
 F T=1:1 S L=$T(TRIBNEW+T^AUM9412A) Q:$P(L,";",3)="END"  D ADDTRIB
 Q
 ;
ADDTRIB ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),L=C_" "_N
 I $D(^AUTTTRI("C",C)) D RSLT(E(1)_E_" : TRIBE CODE EXISTS => "_C) Q
 S DLAYGO=9999999.03,DIC="^AUTTTRI(",X=N,DIC("DR")=".02///"_C D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
RESNEW ;
 S E="New Reservation Codes"
 F T=1:1 S L=$T(RESNEW+T^AUM9412A) Q:$P(L,";",3)="END"  D ADDRES
 Q
 ;
ADDRES ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),S=$P(L,U,4),L=C_" "_N_" "_A_" "_S
 I $D(^AUTTRES("C",C)) D RSLT(E(1)_E_" : RESERVATION CODE EXISTS => "_C) Q
 S P("A")=$$IEN^AUM94121("^AUTTAREA(",A) Q:'P("A")
 S P("S")=$$IEN^AUM94121("^DIC(5,",S) Q:'P("S")
 S DLAYGO=9999999.47,DIC="^AUTTRES(",X=N,DIC("DR")=".02///"_C_";.03////"_P("S")_";.04////"_P("A") D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
PCLASNEW ;
 S E="New Provider Class Codes"
 F T=1:1 S L=$T(PCLASNEW+T^AUM9412B) Q:$P(L,";",3)="END"  D ADDPCLAS
 Q
 ;
ADDPCLAS ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),L=C_" "_N_"  "_A
 I $D(^DIC(7,"D",C)) D RSLT(E(1)_E_" : PROVIDER CLASS CODE EXISTS => "_C) Q
 S DLAYGO=7,DIC="^DIC(7,",X=N,DIC("DR")="1///"_A_";9999999.01///"_C D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
