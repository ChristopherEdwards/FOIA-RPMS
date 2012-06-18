AUM91112 ; IHS/ASDST/GTH - STANDARD TABLE UPDATES, 2000FEB10 ; [ 02/28/2000  12:03 PM ]
 ;;99.1;TABLE MAINTENANCE;**11**;NOV 6,1998
 ;
 Q
 ;
START ;EP
 ;
 NEW A,C,DIC,DIE,DINUM,DLAYGO,DR,E,L,M,N,O,P,R,S,T
 ;
 S E(0)="ERROR : ",E(1)="NOT ADDED : "
 D TRIBCHK,DASH
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
E(L) Q $P($P($T(@L^AUM9111A),";",3),":",1)
IEN(X,%,Y) ;
 S Y=$O(@(X_"""C"",%,0)"))
 I 'Y S Y=$$VAL^AUM9111M(X,%) I Y NEW Z S Z=E D  S:Y<0 Y="" S E=Z
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
RSLT(%) S ^(0)=$G(^TMP("AUM9111",$J,0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,% Q
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
 ;
TRIBCHK ;
 D RSLT("--> Checking .04 field of TRIBE file")
 D RSLT("    to ensure a non-null value.")
 S (C,P)=0,N=$P($G(^AUTTTRI(0)),U,3)
 D PCT(P,N)
 F  S P=$O(^AUTTTRI(P)) Q:'(P=+P)  D:'$D(ZTQUEUED) PCT(P,N) I '$L($P($G(^(P,0)),"^",4)) D
 . S DA=P,DIE="^AUTTTRI(",DR=".04///N"
 . D DIE
 . I $D(Y) D RSLT(E(0)_E_" : EDIT .04 field of TRIBE FAILED => "_$P(^AUTTTRI(P,0),U)) Q
 . S C=C+1
 .Q
 D RSLT($J("",5)_C_" entries in TRIBE were updated.")
 Q
 ;
 ; -----------------------------------------------------
 ;
PCT(C,N) ;
 I C=0 W !,"--10%--20%--30%--40%--50%--60%--70%--80%--90%-100%",! Q
 F  Q:$X>49  Q:(C/N)<($X*.02)  W "|"
 Q
 ;
