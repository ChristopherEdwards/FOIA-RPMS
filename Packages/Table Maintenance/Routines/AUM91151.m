AUM91151 ; IHS/RPMSDBA/GTH - STANDARD TABLE UPDATES, 2000JUL21 ; [ 07/27/2000  10:47 AM ]
 ;;99.1;TABLE MAINTENANCE;**15**;NOV 6,1998
 ;
 Q
 ;
START ;EP
 ;
 NEW A,C,DIC,DIE,DINUM,DLAYGO,DR,E,L,M,N,O,P,R,S,T
 ;
 S E(0)="ERROR : ",E(1)="NOT ADDED : "
 D RSLT($J("",5)_$P($T(UPDATE^AUM9115A),";",3))
 F %=1:1 D RSLT($P($T(GREET+%^AUM9115),";",3)) Q:$P($T(GREET+%+1^AUM9115),";",3)="###"
 F %=1:1 D RSLT($P($T(INTRO+%^AUM9115),";",3)) Q:$P($T(INTRO+%+1^AUM9115),";",3)="###"
 D DASH,LOCNEW,DASH,LOCMOD,DASH,COMMNEW,DASH,COMMMOD,DASH,TRIBNEW,DASH,TRIBMOD,DASH,DOMNEW,DASH
 Q
 ;
 ; -----------------------------------------------------
 ;
ADDOK D RSLT($J("",5)_"Added : "_L) Q
ADDFAIL D RSLT($J("",5)_E(0)_"ADD FAILED => "_L) Q
DASH D RSLT(""),RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70))),RSLT("") Q
DIE NEW A,C,E,L,M,N,O,P,R,S,T
 LOCK +(@(DIE_DA_")")):10 E  D RSLT($J("",5)_E(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) KILL DA,DIE,DR Q
E(L) Q $P($P($T(@L^AUM9115A),";",3),":",1)
IEN(X,%,Y) ;
 S Y=$O(@(X_"""C"",%,0)"))
 I 'Y S Y=$$VAL^AUM9115M(X,%) I Y NEW Z S Z=E D  S:Y<0 Y="" S E=Z
 . NEW A,C,L,M,N,O,P,R,S,V,%
 . S L=Y
 . I X["AREA" NEW X D RSLT("(Add Missing Area)") D ADDAREA D RSLT("(END Add Missing Area)") Q
 . I X["SU" NEW X D RSLT("(Add Missing SU)") D ADDSU D RSLT("(END Add Missing SU)") Q
 . I X["CTY" NEW X D RSLT("(Add Missing County)") D ADDCNTY D RSLT("(END Add Missing County)") Q
 .Q
 D:'Y RSLT($J("",5)_E(0)_$P(@(X_"0)"),U)_" DOES NOT EXIST => "_%)
 Q +Y
DIK NEW A,C,E,L,M,N,O,P,R,S,T D ^DIK KILL DIK Q
FILE NEW A,C,E,L,M,N,O,P,R,S,T K DD,DO S DIC(0)="L" D FILE^DICN KILL DIC Q
MODOK D RSLT($J("",5)_"Changed : "_L) Q
RSLT(%) S ^(0)=$G(^TMP("AUM9115",$J,0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,% Q
ZEROTH(A,B,C,D,E,F,G,H,I,J,K) ; Return 0th node.  A is file #, rest fields.
 I '$G(A) Q -1
 I '$G(B) Q -1
 F %=67:1:75 Q:'$G(@($C(%)))  S A=+$P(^DD(A,B,0),U,2),B=@($C(%))
 I 'A!('B) Q -1
 I '$D(^DD(A,B,0)) Q -1
 Q U_$P(^DD(A,B,0),U,2)
 ;
 ; -----------------------------------------------------
 ;
ADDAREA ; PROGRAMMER NOTE:  This s/r is required for every patch.
 S L=$P(L,";;",2),A=$P(L,U),N=$P(L,U,2),R=$P(L,U,3),C=$P(L,U,4),L=A_" "_N_" "_R_" "_C
 I $D(^AUTTAREA("B",N)) D RSLT($J("",5)_E(1)_"NAME EXISTS => "_N) Q
 I $D(^AUTTAREA("C",A)) D RSLT($J("",5)_E(1)_"CODE EXISTS => "_A) Q
 S DLAYGO=9999999.21,DIC="^AUTTAREA(",X=N,DIC("DR")=".02///"_A_";.03///"_R_";.04///"_C
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 KILL DLAYGO
 Q
 ;
 ; -----------------------------------------------------
 ;
ADDCNTY ; PROGRAMMER NOTE:  This s/r is required for every patch.
 S L=$P(L,";;",2),S=$P(L,U),C=$P(L,U,2),N=$P(L,U,3),L=S_" "_C_" "_N
 I $D(^AUTTCTY("C",S_C)) D RSLT($J("",5)_E(1)_"CODE EXISTS => "_S_C) Q
 S P("S")=$$IEN("^DIC(5,",S)
 Q:'P("S")
 S DIC="^AUTTCTY(",X=N,DIC("DR")=".02////"_P("S")_";.03///"_C
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
 ; -----------------------------------------------------
 ;
ADDSU ; PROGRAMMER NOTE:  This s/r is required for every patch.
 S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),N=$P(L,U,3),L=A_" "_S_" "_N
 I $D(^AUTTSU("C",A_S)) D RSLT($J("",5)_E(1)_"ASU EXISTS => "_A_S) Q
 S P=$$IEN("^AUTTAREA(",A)
 Q:'P
 S DLAYGO=9999999.22,DIC="^AUTTSU(",X=N,DIC("DR")=".02////"_P_";.03///"_S
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 KILL DLAYGO
 Q
 ;
 ; -----------------------------------------------------
LOCNEW ;
 D RSLT($$E("LOCNEW"))
 D RSLT($J("",13)_"AA SU FA NAME"_$J("",28)_"PSEUDO")
 D RSLT($J("",13)_"-- -- -- ----"_$J("",28)_"------")
 F T=1:1 S L=$T(LOCNEW+T^AUM9115A) Q:$P(L,";",3)="END"  D ADDLOC
 Q
 ;
ADDLOC ;
 S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4),P=$P(L,U,5)
 S L=A_" "_S_" "_F_" "_N_$J("",32-$L(N))_P
 S %=A_S_F,%=$O(^AUTTLOC("C",%,0))
 I % D RSLT($J("",5)_E(1)_"ASUFAC EXISTS => "_A_S_F) D  Q
 . I $P($G(^AUTTLOC(%,0)),U,21) S DIE="^AUTTLOC(",DA=%,DR=".27///@;.28////"_DT D DIE D:$D(Y) RSLT($J("",5)_E(0)_"DELETE INACTIVE DATE FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"INACTIVE DATE DELETED => "_L)
 . S %=$O(^AUTTLOC("C",A_S_F,0)),%=$P(^AUTTLOC(%,0),U)
 . I %,$D(^DIC(4,%,0)),N'=$P(^DIC(4,%,0),U) S DIE="^DIC(4,",DA=%,DR=".01///"_N D DIE D:$D(Y) RSLT($J("",5)_E(0)_"EDIT INSTITUTION FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"INSTITUTION NAME UPDATED => "_L)
 . S %=$O(^AUTTLOC("C",A_S_F,0))
 . I P'=$P($G(^AUTTLOC(%,1)),U,2) S DIE="^AUTTLOC(",DA=%,DR=".28////"_DT_";.31///"_P D DIE D:$D(Y) RSLT($J("",5)_E(0)_"EDIT PSEUDO PREFIX FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"PSEUDO PREFIX UPDATED => "_L)
 .Q
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S P("S")=$$IEN("^AUTTSU(",A_S)
 Q:'P("S")
 F DINUM=+$P(^DIC(4,0),U,3):1 Q:'$D(^DIC(4,DINUM))&('$D(^AUTTLOC(DINUM)))  I DINUM>99999 D RSLT($J("",5)_E(0)_"DINUM FOR LOC/INSTITUTION TOO BIG. NOTIFY ISC.") Q
 Q:DINUM>99999
 S DLAYGO=4,DIC="^DIC(4,",X=N
 D FILE
 KILL DINUM,DLAYGO
 I Y<0 D RSLT($J("",5)_E(0)_"^DIC(4 ADD FAILED => "_L) Q
 S DINUM=+Y,DLAYGO=9999999.06,DIC="^AUTTLOC(",X=DINUM,DIC("DR")=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.28////"_DT_";.31///"_P
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 KILL DINUM,DLAYGO
 Q
 ;
 ; -----------------------------------------------------
 ;
LOCMOD ;
 D RSLT($$E("LOCMOD"))
 D RSLT($J("",15)_"AA SU FA NAME"_$J("",28)_"PSEUDO")
 D RSLT($J("",15)_"-- -- -- ----"_$J("",28)_"------")
 F T=1:2 S L=$T(LOCMOD+T^AUM9115A) Q:$P(L,";",3)="END"  S L("TO")=$T(LOCMOD+T+1^AUM9115A) D
 . S L=$P(L,U,2,99),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3)
 . S P=$O(^AUTTLOC("C",A_S_F,0))
 . S L=$P(L("TO"),U,2,99),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4)
 . I 'P S P=$O(^AUTTLOC("C",A_S_F,0)) I 'P S L=";;"_L D ADDLOC Q
 . S L=A_" "_S_" "_F_" "_N_$J("",32-$L(N))_$P(L("TO"),U,6)
 . S P("A")=$$IEN("^AUTTAREA(",A)
 . Q:'P("A")
 . S P("S")=$$IEN("^AUTTSU(",A_S)
 . Q:'P("S")
 . S DIE="^AUTTLOC(",DA=P,DR=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.28////"_DT_";.31///"_$P(L("TO"),U,6)
 . D DIE
 . I $D(Y) D RSLT($J("",5)_E(0)_"EDIT LOCATION FAILED => "_L) Q
 . S DIE="^DIC(4,",DA=$P(^AUTTLOC(P,0),U),DR=".01///"_N
 . D DIE
 . I $D(Y) D RSLT($J("",5)_E(0)_"EDIT INSTITUTION FAILED => "_L) Q
 . D MODOK
 .Q
 ;
 D DASH
 D RSLT("Checking Location Code changes to determine export status.")
 D RSLT("Patient data is not exported if the only change is to the Location NAME.")
 D RSLT("Location Code changes must be rolled up into the national data repository...")
 D DASH,RSLT($$LOCMOD^AUMXPORT("AUM9115A")_" patients marked for export because of the Location Code changes.")
 Q
 ;
 ; -----------------------------------------------------
 ;
COMMNEW ;
 D RSLT($$E("COMMNEW"))
 D RSLT($J("",13)_"ST CT COM NAME"_$J("",28)_"AA SU")
 D RSLT($J("",13)_"-- -- --- ----"_$J("",28)_"-- --")
 F T=1:1 S L=$T(COMMNEW+T^AUM9115A) Q:$P(L,";",3)="END"  D ADDCOMM
 Q
 ;
ADDCOMM ;
 S L=$P(L,";;",2),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6),L=S_" "_O_" "_C_" "_N_$J("",32-$L(N))_A_" "_V
 I $D(^AUTTCOM("C",S_O_C)) D RSLT($J("",5)_E(1)_"STCTYCOM CODE EXISTS => "_S_O_C) Q
 S P("O")=$$IEN("^AUTTCTY(",S_O)
 Q:'P("O")
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S P("V")=$$IEN("^AUTTSU(",A_V)
 Q:'P("V")
 S DLAYGO=9999999.05,DIC="^AUTTCOM(",X=N,DIC("DR")=".02////"_P("O")_";.05////"_P("V")_";.06////"_P("A")_";.07///"_C
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 KILL DLAYGO
 Q
 ;
 ; -----------------------------------------------------
 ;
COMMMOD ;
 D RSLT($$E("COMMMOD"))
 D RSLT($J("",15)_"ST CT COM NAME"_$J("",28)_"AA SU")
 D RSLT($J("",15)_"-- -- --- ----"_$J("",28)_"-- --")
 F T=1:2 S L=$T(COMMMOD+T^AUM9115A) Q:$P(L,";",3)="END"  S L("TO")=$T(COMMMOD+T+1^AUM9115A) D
 . S L=$P(L,U,2,99),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3)
 . S P=$O(^AUTTCOM("C",S_O_C,0))
 . S L=$P(L("TO"),U,2,99),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6)
 . I 'P S P=$O(^AUTTCOM("C",S_O_C,0)) I 'P S L=";;"_L D ADDCOMM Q
 . S L=S_" "_O_" "_C_" "_N_$J("",32-$L(N))_A_" "_V
 . S P("O")=$$IEN("^AUTTCTY(",S_O)
 . Q:'P("O")
 . S P("A")=$$IEN("^AUTTAREA(",A)
 . Q:'P("A")
 . S P("V")=$$IEN("^AUTTSU(",A_V)
 . Q:'P("V")
 . S DIE="^AUTTCOM(",DA=P,DR=".01///"_N_";.02////"_P("O")_";.05////"_P("V")_";.06////"_P("A")_";.07///"_C
 . D DIE
 . I $D(Y) D RSLT($J("",5)_E(0)_"CHANGE FAILED => "_L) Q
 . D MODOK
 .Q
 ;
 D DASH
 D RSLT("Checking Community Code changes to determine export status.")
 D RSLT("Patient data is not exported if the only change is to the Commnuity NAME.")
 D RSLT("Commnity Code changes must be rolled up into the national data repository...")
 D DASH,RSLT($$COMMMOD^AUMXPORT("AUM9115A")_" patients marked for export because of the Community Code changes.")
 Q
 ;
 ; -----------------------------------------------------
 ;
TRIBNEW ;
 D RSLT($$E("TRIBNEW"))
 D RSLT($J("",13)_"CCC NAME")
 D RSLT($J("",13)_"--- ----")
 F T=1:1 S L=$T(TRIBNEW+T^AUM9115A) Q:$P(L,";",3)="END"  D ADDTRIB
 Q
 ;
ADDTRIB ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),L=C_" "_A
 I $D(^AUTTTRI("C",C)) D RSLT($J("",5)_E(1)_"TRIBE CODE EXISTS => "_C) Q
 S DLAYGO=9999999.03,DIC="^AUTTTRI(",X=N,DIC("DR")=".02///"_C_";.03///"_A_";.04///N"
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 KILL DLAYGO
 Q
 ;
 ; -----------------------------------------------------
 ;
TRIBMOD ;
 D RSLT($$E("TRIBMOD"))
 D RSLT($J("",14)_"CODE  NAME"_$J("",29)_"INACTIVE")
 D RSLT($J("",14)_"----  ----"_$J("",29)_"--------")
 F T=1:2 S L=$T(TRIBMOD+T^AUM9115A) Q:$P(L,";",3)="END"  S L("TO")=$T(TRIBMOD+T+1^AUM9115A) D
 . S L=$P(L,U,2,99),C=$P(L,U)
 . S P=$O(^AUTTTRI("C",C,0))
 . S L=$P(L("TO"),U,2,99),C=$P(L,U),N=$P(L,U,2),S=$P(L,U,3)
 . I 'P S L=";;"_L D ADDTRIB Q
 . S L=C_"  "_N_$J("",40-$L(N))_S
 . S DIE="^AUTTTRI(",DA=P,DR=".01///"_N_";.04///"_S
 . D DIE
 . I $D(Y) D RSLT(E(0)_E_" : EDIT TRIBE FAILED => "_L) Q
 . D MODOK
 .Q
 Q
 ;
 ; -----------------------------------------------------
 ;
DOMNEW ;
 D RSLT($$E("DOMNEW"))
 D RSLT($J("",13)_"NAME")
 D RSLT($J("",13)_"----")
 F T=1:1 S L=$T(DOMNEW+T^AUM9115A) Q:$P(L,";",3)="END"  D ADDDOM
 Q
 ;
ADDDOM ;
 S L=$P(L,";;",2),N=$P(L,U),L=N
 I $D(^DIC(4.2,"B",N)) D RSLT($J("",5)_E(1)_"DOMAIN NAME EXISTS => "_N) Q
 S DLAYGO=4.2,DIC="^DIC(4.2,",X=N
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 KILL DLAYGO
 Q
 ;
 ; -----------------------------------------------------
 ;
