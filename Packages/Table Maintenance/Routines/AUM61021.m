AUM61021 ; IHS/ADC/GTH - STANDARD TABLE UPDATES, 06DEC95 BANYAN ; [ 12/11/95  3:39 PM ]
 ;;96.1;TABLE MAINTENANCE;**2**;OCT 26,1995
 ;
 Q
 ;
START ;EP
 ;
 NEW A,C,DIC,DIE,DLAYGO,DR,E,L,N,O,P,R,S,T
 ;
 S E(0)="ERROR : ",E(1)="NOT ADDED : "
 D LOCNEW,DASH,LOCMOD,DASH,LOCINACT,DASH,COMMMOD,DASH
 ;
 Q
 ;
 ; -----------------------------------------------------
 ;
ADDOK D RSLT($J("",5)_"Added : "_L) Q
ADDFAIL D RSLT($J("",5)_E(0)_"ADD FAILED => "_L) Q
DASH D RSLT(""),RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70))),RSLT("") Q
DIE NEW A,C,E,L,N,O,P,R,S,T
 LOCK +(@(DIE_DA_")")):10 E  D RSLT($J("",5)_E(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) K DA,DIE,DR Q
IEN(X,%,Y) ;
 S Y=$O(@(X_"""C"",%,0)"))
 I 'Y S Y=$T(@%^AUM9511M) I Y NEW Z S Z=E D  S:Y<0 Y="" S E=Z
 . NEW A,C,L,N,O,P,R,S,V,%
 . S L=Y
 . I X["AREA" NEW X S E=E_" (Add Area) " D ADDAREA Q
 . I X["SU" NEW X S E=E_" (Add SU) " D ADDSU Q
 . I X["CTY" NEW X S E=E_" (Add County) " D ADDCNTY Q
 .Q
 D:'Y RSLT($J("",5)_E(0)_$P(@(X_"0)"),U)_" DOES NOT EXIST => "_%)
 Q +Y
DIK NEW A,C,E,L,N,O,P,R,S,T D ^DIK K DIK Q
FILE NEW A,C,E,L,N,O,P,R,S,T K DD,DO S DIC(0)="L" D FILE^DICN K DIC Q
MODOK D RSLT($J("",5)_"Changed : "_L) Q
RSLT(%) S ^(0)=$G(^TMP("AUM SCB",$J,0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,% Q
ZEROTH(A,B,C,D,E,F,G,H,I,J,K) ; Return 0th node.  A is file #, rest fields.
 I '$G(A) Q -1
 I '$G(B) Q -1
 F %=67:1:75 Q:'$G(@($C(%)))  S A=+$P(^DD(A,B,0),U,2),B=@($C(%))
 I 'A!('B) Q -1
 I '$D(^DD(A,B,0)) Q -1
 Q U_$P(^DD(A,B,0),U,2)
 ;
 ; -----------------------------------------------------
AREANEW ;
 D RSLT("New Area Codes")
 F T=1:1 S L=$T(AREANEW+T^AUM6102A) Q:$P(L,";",3)="END"  D ADDAREA
 Q
 ;
ADDAREA ;
 S L=$P(L,";;",2),A=$P(L,U),N=$P(L,U,2),R=$P(L,U,3),C=$P(L,U,4),L=A_" "_N_" "_R_" "_C
 I $D(^AUTTAREA("B",N)) D RSLT($J("",5)_E(1)_"NAME EXISTS => "_N) Q
 I $D(^AUTTAREA("C",A)) D RSLT($J("",5)_E(1)_"CODE EXISTS => "_A) Q
 S DLAYGO=9999999.21,DIC="^AUTTAREA(",X=N,DIC("DR")=".02///"_A_";.03///"_R_";.04///"_C
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
 ; -----------------------------------------------------
SUNEW ;
 D RSLT("New Service Unit Codes")
 F T=1:1 S L=$T(SUNEW+T^AUM6102A) Q:$P(L,";",3)="END"  D ADDSU
 Q
 ;
ADDSU ;
 S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),N=$P(L,U,3),L=A_" "_S_" "_N
 I $D(^AUTTSU("C",A_S)) D RSLT($J("",5)_E(1)_"ASU EXISTS => "_A_S) Q
 S P=$$IEN("^AUTTAREA(",A)
 Q:'P
 S DLAYGO=9999999.22,DIC="^AUTTSU(",X=N,DIC("DR")=".02////"_P_";.03///"_S
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
 ; -----------------------------------------------------
LOCNEW ;
 D RSLT("New Location Codes")
 F T=1:1 S L=$T(LOCNEW+T^AUM6102A) Q:$P(L,";",3)="END"  D ADDLOC
 Q
 ;
ADDLOC ;
 S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4),P=$P(L,U,5)
 S L=A_" "_S_" "_F_" "_N_" "_P
 S %=A_S_F,%=$O(^AUTTLOC("C",%,0))
 I % D RSLT($J("",5)_E(1)_"ASUFAC EXISTS => "_A_S_F) D  Q
 . I $P($G(^AUTTLOC(%,0)),U,21) S DIE="^AUTTLOC(",DA=%,DR=".27///@" D DIE D:$D(Y) RSLT($J("",5)_E(0)_"DELETE INACTIVE DATE FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"INACTIVE DATE DELETED => "_L)
 . S %=$O(^AUTTLOC("C",A_S_F,0)),%=$P(^AUTTLOC(%,0),U)
 . I %,$D(^DIC(4,%,0)),N'=$P(^DIC(4,%,0),U) S DIE="^DIC(4,",DA=%,DR=".01///"_N D DIE D:$D(Y) RSLT($J("",5)_E(0)_"EDIT INSTITUTION FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"INSTITUTION NAME UPDATED => "_L)
 . S %=$O(^AUTTLOC("C",A_S_F,0))
 . I P'=$P($G(^AUTTLOC(%,1)),U,2) S DIE="^AUTTLOC(",DA=%,DR=".31///"_P D DIE D:$D(Y) RSLT($J("",5)_E(0)_"EDIT PSEUDO PREFIX FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"PSEUDO PREFIX UPDATED => "_L)
 .Q
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S P("S")=$$IEN("^AUTTSU(",A_S)
 Q:'P("S")
 F DINUM=+$P(^DIC(4,0),U,3):1 Q:'$D(^DIC(4,DINUM))&('$D(^AUTTLOC(DINUM)))  I DINUM>99999 D RSLT($J("",5)_E(0)_"DINUM FOR LOC/INSTITUTION TOO BIG. NOTIFY ISC.") Q
 Q:DINUM>99999
 S DLAYGO=4,DIC="^DIC(4,",X=N
 D FILE
 I Y<0 D RSLT($J("",5)_E(0)_"^DIC(4 ADD FAILED => "_L) Q
 S DINUM=+Y,DLAYGO=9999999.06,DIC="^AUTTLOC(",X=DINUM,DIC("DR")=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.31///"_P
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
LOCMOD ;
 D RSLT("Location Code Changes")
 F T=1:2 S L=$T(LOCMOD+T^AUM6102A) Q:$P(L,";",3)="END"  S L("TO")=$T(LOCMOD+T+1^AUM6102A) D
 . S L=$P(L,U,2,99),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3)
 . S P=$O(^AUTTLOC("C",A_S_F,0))
 . S L=$P(L("TO"),U,2,99),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4)
 . I 'P S P=$O(^AUTTLOC("C",A_S_F,0)) I 'P S L=";;"_L D ADDLOC Q
 . S L=A_" "_S_" "_F_" "_N_" "_$P(L("TO"),U,6)
 . S P("A")=$$IEN("^AUTTAREA(",A)
 . Q:'P("A")
 . S P("S")=$$IEN("^AUTTSU(",A_S)
 . Q:'P("S")
 . S DIE="^AUTTLOC(",DA=P,DR=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.31///"_$P(L("TO"),U,6)
 . D DIE
 . I $D(Y) D RSLT($J("",5)_E(0)_"EDIT LOCATION FAILED => "_L) Q
 . S DIE="^DIC(4,",DA=$P(^AUTTLOC(P,0),U),DR=".01///"_N
 . D DIE
 . I $D(Y) D RSLT($J("",5)_E(0)_"EDIT INSTITUTION FAILED => "_L) Q
 . D MODOK
 .Q
 D DASH,RSLT($$LOCMOD^AUMXPORT("AUM6102A")_" patients marked for export because of the Location Code changes.")
 ;
 Q
 ;
LOCINACT ;
 D RSLT("Inactivated Location Codes")
 F T=1:1 S L=$T(LOCINACT+T^AUM6102A) Q:$P(L,";",3)="END"  D
 . S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4),P=$P(L,U,5)
 . S L=A_" "_S_" "_F_" "_N_" "_P
 . S %=A_S_F,%=$O(^AUTTLOC("C",%,0))
 . I '% D RSLT($J("",5)_"ASUFAC "_A_S_F_" not found (OK).") Q
 . S DIE="^AUTTLOC(",DA=%,DR=".27////"_DT
 . D DIE
 . I $D(Y) D RSLT($J("",5)_E(0)_"EDIT INACTIVE DATE FAILED => "_L) I 1
 . E  D RSLT($J("",5)_"INACTIVATED => "_L)
 .Q
 Q
 ;
 ; -----------------------------------------------------
CNTYNEW ;
 D RSLT("New County Codes")
 F T=1:1 S L=$T(CNTYNEW+T^AUM6102A) Q:$P(L,";",3)="END"  D ADDCNTY
 Q
 ;
ADDCNTY ;
 S L=$P(L,";;",2),S=$P(L,U),C=$P(L,U,2),N=$P(L,U,3),L=S_" "_C_" "_N
 I $D(^AUTTCTY("C",S_C)) D RSLT($J("",5)_E(1)_"CODE EXISTS => "_S_C) Q
 S P("S")=$$IEN("^DIC(5,",S)
 Q:'P("S")
 S DIC="^AUTTCTY(",X=N,DIC("DR")=".02////"_P("S")_";.03///"_C
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
CNTYMOD ;
 D RSLT("County Code Changes")
 F T=1:2 S L=$T(CNTYMOD+T^AUM6102A) Q:$P(L,";",3)="END"  S L("TO")=$T(CNTYMOD+T+1^AUM6102A) D
 . S L=$P(L,U,2,99),S=$P(L,U),C=$P(L,U,2)
 . S P=$O(^AUTTCTY("C",S_C,0))
 . S L=$P(L("TO"),U,2,99),S=$P(L,U),C=$P(L,U,2),N=$P(L,U,3)
 . I 'P S P=$O(^AUTTCTY("C",S_C,0)) I 'P S L=";;"_L D ADDCNTY Q
 . S L=S_" "_C_" "_N
 . S P("S")=$$IEN("^DIC(5,",S)
 . Q:'P("S")
 . S DIE="^AUTTCTY(",DA=P,DR=".01///"_N_";.02////"_P("S")_";.03///"_C
 . D DIE
 . I $D(Y) D RSLT($J("",5)_E(0)_"EDIT COUNTY FAILED => "_L) Q
 . D MODOK
 .Q
 Q
 ;
 ; -----------------------------------------------------
COMMNEW ;
 D RSLT("New Community Codes")
 F T=1:1 S L=$T(COMMNEW+T^AUM9511A) Q:$P(L,";",3)="END"  D ADDCOMM
 Q
 ;
ADDCOMM ;
 S L=$P(L,";;",2),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6),L=S_" "_O_" "_C_" "_N_" "_A_" "_V
 I $D(^AUTTCOM("C",S_O_C)) D RSLT($J("",5)_E(1)_"STCTYCOM CODE EXISTS => "_S_O_C) Q
 S P("O")=$$IEN^AUM95111("^AUTTCTY(",S_O)
 Q:'P("O")
 S P("A")=$$IEN^AUM95111("^AUTTAREA(",A)
 Q:'P("A")
 S P("V")=$$IEN^AUM95111("^AUTTSU(",A_V)
 Q:'P("V")
 S DLAYGO=9999999.05,DIC="^AUTTCOM(",X=N,DIC("DR")=".02////"_P("O")_";.05////"_P("V")_";.06////"_P("A")_";.07///"_C
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
COMMMOD ;
 D RSLT("Community Code Changes")
 F T=1:2 S L=$T(COMMMOD+T^AUM6102A) Q:$P(L,";",3)="END"  S L("TO")=$T(COMMMOD+T+1^AUM6102A) D
 . S L=$P(L,U,2,99),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3)
 . S P=$O(^AUTTCOM("C",S_O_C,0))
 . S L=$P(L("TO"),U,2,99),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6)
 . I 'P S P=$O(^AUTTCOM("C",S_O_C,0)) I 'P S L=";;"_L D ADDCOMM Q
 . S L=S_" "_O_" "_C_" "_N_" "_A_" "_V
 . S P("O")=$$IEN^AUM61021("^AUTTCTY(",S_O)
 . Q:'P("O")
 . S P("A")=$$IEN^AUM61021("^AUTTAREA(",A)
 . Q:'P("A")
 . S P("V")=$$IEN^AUM61021("^AUTTSU(",A_V)
 . Q:'P("V")
 . S DIE="^AUTTCOM(",DA=P,DR=".01///"_N_";.02////"_P("O")_";.05////"_P("V")_";.06////"_P("A")_";.07///"_C
 . D DIE
 . I $D(Y) D RSLT($J("",5)_E(0)_"CHANGE FAILED => "_L) Q
 . D MODOK
 .Q
 D DASH,RSLT($$COMMMOD^AUMXPORT("AUM6102A")_" patients marked for export because of the Community Code changes.")
 Q
 ;
 ; -----------------------------------------------------
 ;
