AUM94121 ; DSD/GTH - STANDARD TABLE UPDATES (1), 05DEC94 BANYAN ; [ 12/06/94  10:42 AM ]
 ;;95.1;TABLE MAINTENANCE;**1**;NOV 1, 1994
 Q
 ;
START ;EP
 NEW A,C,DIC,DIE,DLAYGO,DR,E,L,N,O,P,R,S,T
 S E(0)="ERROR : ",E(1)="NOT ADDED : "
 D SUNEW,LOCNEW,LOCMOD
 Q
 ;
ADDOK D RSLT(E_", Added : "_L) Q
ADDFAIL D RSLT(E(0)_E_" : ADD FAILED => "_L) Q
DIE NEW A,C,E,L,N,O,P,R,S,T
 LOCK +(@(DIE_DA_")")):10 E  D RSLT(E(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) K DA,DIE,DR Q
IEN(X,%,Y) ;EP
 S Y=$O(@(X_"""C"",%,0)"))
 I 'Y S Y=$T(@%^AUM9412M) I Y NEW Z S Z=E D  S:Y<0 Y="" S E=Z
 . NEW A,C,L,N,O,P,R,S,V,%
 . S L=Y
 . I X["AREA" NEW X S E=E_" (Add Area) " D ADDAREA Q
 . I X["SU" NEW X S E=E_" (Add SU) " D ADDSU Q
 . I X["CTY" NEW X S E=E_" (Add County) " D ADDCNTY Q
 .Q
 D:'Y RSLT(E(0)_E_" : "_$P(@(X_"0)"),U)_" DOES NOT EXIST => "_%)
 Q +Y
FILE NEW A,C,E,L,N,O,P,R,S,T K DD,DO S DIC(0)="L" D FILE^DICN K DIC Q
MODOK D RSLT(E_", Changed : "_L) Q
RSLT(%) S ^(0)=$G(^TMP($J,"RSLT",0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,% Q
 ;
AREANEW ;
 S E="New Area Codes"
 F T=1:1 S L=$T(AREANEW+T^AUM9412A) Q:$P(L,";",3)="END"  D ADDAREA
 Q
 ;
ADDAREA ;
 S L=$P(L,";;",2),A=$P(L,U),N=$P(L,U,2),R=$P(L,U,3),C=$P(L,U,4),L=A_"  "_N_"  "_R_"  "_C
 I $D(^AUTTAREA("B",N)) D RSLT(E(1)_E_" : NAME EXISTS => "_N) Q
 I $D(^AUTTAREA("C",A)) D RSLT(E(1)_E_" : CODE EXISTS => "_A) Q
 S DLAYGO=9999999.21,DIC="^AUTTAREA(",X=N,DIC("DR")=".02///"_A_";.03///"_R_";.04///"_C D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
SUNEW ;
 S E="New Service Unit Codes"
 F T=1:1 S L=$T(SUNEW+T^AUM9412A) Q:$P(L,";",3)="END"  D ADDSU
 Q
 ;
ADDSU ;
 S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),N=$P(L,U,3),L=A_"  "_S_"  "_N
 I $D(^AUTTSU("C",A_S)) D RSLT(E(1)_E_" : ASU EXISTS => "_A_S) Q
 S P=$$IEN("^AUTTAREA(",A) Q:'P
 S DLAYGO=9999999.22,DIC="^AUTTSU(",X=N,DIC("DR")=".02////"_P_";.03///"_S D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
LOCNEW ;
 S E="New Location Codes"
 F T=1:1 S L=$T(LOCNEW+T^AUM9412A) Q:$P(L,";",3)="END"  D ADDLOC
 Q
 ;
ADDLOC ;
 S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4),P=$P(L,U,5)
 S L=A_"  "_S_"  "_F_"  "_N_"  "_P
 S %=A_S_F,%=$O(^AUTTLOC("C",%,0))
 I % D RSLT(E(1)_E_" : ASUFAC EXISTS => "_A_S_F) D  Q
 .I $P($G(^AUTTLOC(%,0)),U,21) S DIE="^AUTTLOC(",DA=%,DR=".27///@" D DIE D:$D(Y) RSLT(E(1)_E_" : DELETE INACTIVE DATE FAILED => "_L) D:'$D(Y) RSLT(E_" : INACTIVE DATE DELETED => "_L)
 .S %=$O(^AUTTLOC("C",A_S_F,0)),%=$P(^AUTTLOC(%,0),U)
 .I %,$D(^DIC(4,%,0)),N'=$P(^DIC(4,%,0),U) S DIE="^DIC(4,",DA=%,DR=".01///"_N D DIE D:$D(Y) RSLT(E(0)_E_" : EDIT INSTITUTION FAILED => "_L) D:'$D(Y) RSLT(E_" : INSTITUTION NAME UPDATED => "_L)
 .S %=$O(^AUTTLOC("C",A_S_F,0))
 .I P'=$P($G(^AUTTLOC(%,1)),U,2) S DIE="^AUTTLOC(",DA=%,DR=".31///"_P D DIE D:$D(Y) RSLT(E(0)_E_" : EDIT PSEUDO PREFIX FAILED => "_L) D:'$D(Y) RSLT(E_" : PSEUDO PREFIX UPDATED => "_L)
 .Q
 S P("A")=$$IEN("^AUTTAREA(",A) Q:'P("A")
 S P("S")=$$IEN("^AUTTSU(",A_S) Q:'P("S")
 F DINUM=+$P(^DIC(4,0),U,3):1 Q:'$D(^DIC(4,DINUM))&('$D(^AUTTLOC(DINUM)))  I DINUM>99999 D RSLT(E(0)_"DINUM FOR LOC/INSTITUTION TOO BIG. NOTIFY ISC.") Q
 Q:DINUM>99999
 S DLAYGO=4,DIC="^DIC(4,",X=N D FILE
 I Y<0 D RSLT(E(0)_E_" : ^DIC(4 ADD FAILED => "_L) Q
 S DINUM=+Y,DLAYGO=9999999.06,DIC="^AUTTLOC(",X=DINUM,DIC("DR")=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.31///"_P D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
LOCMOD ;
 S E="Location Code Changes"
 F T=1:2 S L=$T(LOCMOD+T^AUM9412A) Q:$P(L,";",3)="END"  S L("TO")=$T(LOCMOD+T+1^AUM9412A) D
 .S L=$P(L,U,2,99),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3)
 .S P=$O(^AUTTLOC("C",A_S_F,0))
 .S L=$P(L("TO"),U,2,99),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4)
 .I 'P S P=$O(^AUTTLOC("C",A_S_F,0)) I 'P S L=";;"_L D ADDLOC Q
 .S L=A_"  "_S_"  "_F_"  "_N_"  "_$P(L("TO"),U,6)
 .S P("A")=$$IEN("^AUTTAREA(",A) Q:'P("A")
 .S P("S")=$$IEN("^AUTTSU(",A_S) Q:'P("S")
 .S DIE="^AUTTLOC(",DA=P,DR=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.31///"_$P(L("TO"),U,6) D DIE
 .I $D(Y) D RSLT(E(0)_E_" : EDIT LOCATION FAILED => "_L) Q
 .S DIE="^DIC(4,",DA=$P(^AUTTLOC(P,0),U),DR=".01///"_N D DIE
 .I $D(Y) D RSLT(E(0)_E_" : EDIT INSTITUTION FAILED => "_L) Q
 .D MODOK
 .Q
 Q
 ;
CNTYNEW ;
 S E="New County Codes"
 F T=1:1 S L=$T(CNTYNEW+T^AUM9412A) Q:$P(L,";",3)="END"  D ADDCNTY
 Q
 ;
ADDCNTY ;
 S L=$P(L,";;",2),S=$P(L,U),C=$P(L,U,2),N=$P(L,U,3),L=S_"  "_C_"  "_N
 I $D(^AUTTCTY("C",S_C)) D RSLT(E(1)_E_" : CODE EXISTS => "_S_C) Q
 S P("S")=$$IEN("^DIC(5,",S) Q:'P("S")
 S DIC="^AUTTCTY(",X=N,DIC("DR")=".02////"_P("S")_";.03///"_C D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
CNTYMOD ;
 S E="County Code Changes"
 F T=1:2 S L=$T(CNTYMOD+T^AUM9412A) Q:$P(L,";",3)="END"  S L("TO")=$T(CNTYMOD+T+1^AUM9412A) D
 .S L=$P(L,U,2,99),S=$P(L,U),C=$P(L,U,2)
 .S P=$O(^AUTTCTY("C",S_C,0))
 .S L=$P(L("TO"),U,2,99),S=$P(L,U),C=$P(L,U,2),N=$P(L,U,3)
 .I 'P S P=$O(^AUTTCTY("C",S_C,0)) I 'P S L=";;"_L D ADDCNTY Q
 .S L=S_"  "_C_"  "_N
 .S P("S")=$$IEN("^DIC(5,",S) Q:'P("S")
 .S DIE="^AUTTCTY(",DA=P,DR=".01///"_N_";.02////"_P("S")_";.03///"_C D DIE
 .I $D(Y) D RSLT(E(0)_E_" : EDIT COUNTY FAILED => "_L) Q
 .D MODOK
 .Q
 Q
