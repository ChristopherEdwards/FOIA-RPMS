AUM95032 ; DSD/GTH - STANDARD TABLE UPDATES (2), 03MAR95 BANYAN ; [ 03/07/95  3:00 PM ]
 ;;95.1;TABLE MAINTENANCE;**4**;NOV 1, 1994
 ;
 Q
 ;
START ;EP
 ;
 NEW A,C,DIC,DIE,DLAYGO,DR,E,L,N,O,P,R,S,T
 S E(0)="ERROR : ",E(1)="NOT ADDED : "
 D COMMMOD
 D RSLT($$COMMMOD^AUMXPORT("AUM9503A")_" patients marked for export because of the Community Code changes.")
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
 F T=1:1 S L=$T(COMMNEW+T^AUM9503A) Q:$P(L,";",3)="END"  D ADDCOMM
 Q
 ;
ADDCOMM ;
 S L=$P(L,";;",2),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6),L=S_" "_O_" "_C_" "_N_" "_A_" "_V
 I $D(^AUTTCOM("C",S_O_C)) D RSLT(E(1)_E_" : STCTYCOM CODE EXISTS => "_S_O_C) Q
 S P("O")=$$IEN^AUM95031("^AUTTCTY(",S_O) Q:'P("O")
 S P("A")=$$IEN^AUM95031("^AUTTAREA(",A) Q:'P("A")
 S P("V")=$$IEN^AUM95031("^AUTTSU(",A_V) Q:'P("V")
 S DLAYGO=9999999.05,DIC="^AUTTCOM(",X=N,DIC("DR")=".02////"_P("O")_";.05////"_P("V")_";.06////"_P("A")_";.07///"_C D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
COMMMOD ;
 S E="Community Code Changes"
 F T=1:2 S L=$T(COMMMOD+T^AUM9503A) Q:$P(L,";",3)="END"  S L("TO")=$T(COMMMOD+T+1^AUM9503A) D
 .S L=$P(L,U,2,99),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3)
 .S P=$O(^AUTTCOM("C",S_O_C,0))
 .S L=$P(L("TO"),U,2,99),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6)
 .I 'P S P=$O(^AUTTCOM("C",S_O_C,0)) I 'P S L=";;"_L D ADDCOMM Q
 .S L=S_" "_O_" "_C_" "_N_" "_A_" "_V
 .S P("O")=$$IEN^AUM95031("^AUTTCTY(",S_O) Q:'P("O")
 .S P("A")=$$IEN^AUM95031("^AUTTAREA(",A) Q:'P("A")
 .S P("V")=$$IEN^AUM95031("^AUTTSU(",A_V) Q:'P("V")
 .S DIE="^AUTTCOM(",DA=P,DR=".01///"_N_";.02////"_P("O")_";.05////"_P("V")_";.06////"_P("A")_";.07///"_C D DIE
 .I $D(Y) D RSLT(E(0)_E_" : CHANGE FAILED => "_L) Q
 .D MODOK
 .Q
 Q
 ;
COMMDEL ;
 S E="Community Inactivation"
 F T=1:1 S L=$T(COMMDEL+T^AUM9503A) Q:$P(L,";",3)="END"  D
 .S L=$P(L,";;",2),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6),L=S_" "_O_" "_C_" "_N_" "_A_" "_V
 .S P=$O(^AUTTCOM("C",S_O_C,0))
 .I 'P D RSLT(E_" : COMMUNITY NOT FOUND (That's OK) => "_L) Q
 .S DIE="^AUTTCOM(",DA=P,DR=".14///<INACTIVE>" D DIE
 .I $D(Y) D RSLT(E(0)_E_" : EDIT FAILED => "_L) Q
 .D RSLT(E_" : SHORT NAME MARKED '<INACTIVE>' => "_L) Q
 .Q
 Q
 ;
