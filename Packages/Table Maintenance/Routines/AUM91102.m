AUM91102 ; IHS/ASDST/GTH - STANDARD TABLE UPDATES, 1999DEC01 ; [ 12/09/1999  10:15 AM ]
 ;;99.1;TABLE MAINTENANCE;**10**;NOV 6,1998
 ;
 Q
 ;
START ;EP
 ;
 NEW A,C,DIC,DIE,DINUM,DLAYGO,DR,E,L,M,N,O,P,R,S,T
 ;
 S E(0)="ERROR : ",E(1)="NOT ADDED : "
 D TRIBNEW,DASH,HFADD,DASH,DXPRMOD,DASH
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
E(L) Q $P($P($T(@L^AUM9110A),";",3),":",1)
IEN(X,%,Y) ;
 S Y=$O(@(X_"""C"",%,0)"))
 I 'Y S Y=$$VAL^AUM9110M(X,%) I Y NEW Z S Z=E D  S:Y<0 Y="" S E=Z
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
RSLT(%) S ^(0)=$G(^TMP("AUM9110",$J,0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,% Q
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
HFADD ;
 D RSLT($$E("HFADD"))
 F T=1:1 S L=$T(HFADD+T^AUM9110A) Q:$P(L,";",3)="END"  D ADDHF
 KILL DLAYGO
 Q
 ;
ADDHF ;
 S L=$P(L,";;",2),N=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),R=$P(L,U,4),S=$P(L,U,5),L=N_" "_O_"  "_C_"  "_R_"  "_S
 I $D(^AUTTHF("B",N)) D RSLT($J("",5)_E(1)_"HEALTH FACTOR EXISTS => "_N) Q
 S DLAYGO=9999999.64,DIC="^AUTTHF(",X=N,DIC("DR")=".02///"_O_";.03///"_C_";.08///"_R_";.1///"_S
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
 ; -----------------------------------------------------
 ;
TRIBNEW ;
 S E=$$E("TRIBNEW")
 D RSLT(E)
 D RSLT($J("",13)_"CCC NAME")
 D RSLT($J("",13)_"--- ----")
 F T=1:1 S L=$T(TRIBNEW+T^AUM9110A) Q:$P(L,";",3)="END"  D ADDTRIB
 Q
 ;
ADDTRIB ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),L=C_" "_N
 I $D(^AUTTTRI("C",C)) D RSLT($J("",5)_E(1)_"TRIBE CODE EXISTS => "_C) Q
 S DLAYGO=9999999.03,DIC="^AUTTTRI(",X=N,DIC("DR")=".02///"_C
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
 ; -----------------------------------------------------
 ;
ADDDXPR ;
 S L=$P(L,";;",2),R=$P(L,U),M=$P(L,U,2),N=$P(L,U,3),S=$P(L,U,4),C=$P(L,U,5),O=$P(L,U,6),L=R_"..."_M_"..."
 I $D(^AUTTDXPR("B",R)) D RSLT($J("",5)_E(1)_"DIAGNOSTIC PROCEDURE RESULT EXISTS => "_R) Q
 S DLAYGO=9999999.68,DIC="^AUTTDXPR(",X=R,DIC("DR")=".02///"_M_";.07///"_S_";3///"_O
 ;
 ; The Input Transform for the .01 field requires a variable from the
 ; Medicine Package be SET.  I'll fix the dd next year.
 ; gth 12/08/99
 S (DINUM,MCQSDXPR)=691.500002
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 KILL MCQSDXPR,DINUM
 Q:Y<0
 ;
 ; Field .03 must be direct SET since value contains ";" and
 ; disrupts the parsing of DR by FileMan.  gth 12/08/99
 S $P(^AUTTDXPR(+Y,0),U,3)=N
 ;
 ; edit WP field DESCRIPTION.
 S DIE="^AUTTDXPR(",DA=+Y,DR="2///"_C,DR(1,9999999.68)="2;",DR(2,9999999.682)=".01"
 D DIE
 I $D(Y) D RSLT($J("",5)_E(0)_"EDIT DIAGNOSTIC PROCEDURE RESULT DESCRIPTION FAILED => "_L) Q
 D DISDXPR
 KILL DLAYGO
 Q
 ;
DXPRMOD ;
 S E=$$E("DXPRMOD")
 D RSLT(E)
 F T=1:2 S L=$T(DXPRMOD+T^AUM9110A) Q:$P(L,";",3)="END"  S L("TO")=$T(DXPRMOD+T+1^AUM9110A) D
 . S L=$P(L,U,2,99),R=$P(L,U)
 . S P=$O(^AUTTDXPR("B",R,0))
 . S L=$P(L("TO"),U,2,99),R=$P(L,U),M=$P(L,U,2),N=$P(L,U,3),S=$P(L,U,4),C=$P(L,U,5),O=$P(L,U,6)
 . I 'P S L=";;"_L D ADDDXPR Q
 . S L=R_"..."_M_"..."
 . S DIE="^AUTTDXPR(",DA=P,DR=".02///"_M_";.07///"_S_";3///"_O
 . D DIE
 . I $D(Y) D RSLT($J("",5)_E(0)_"EDIT DIAGNOSTIC PROCEDURE RESULT FAILED => "_L) Q
 . ; Field .03 must be direct SET since value contains ";" and
 . ; disrupts the parsing of DR by FileMan.  gth 12/08/99
 . S $P(^AUTTDXPR(P,0),U,3)=N
 . ; edit WP field DESCRIPTION.
 . S DIE="^AUTTDXPR(",DA=P,DR="2///"_C,DR(1,9999999.68)="2;",DR(2,9999999.682)=".01"
 . D DIE
 . I $D(Y) D RSLT($J("",5)_E(0)_"EDIT DIAGNOSTIC PROCEDURE RESULT DESCRIPTION FAILED => "_L) Q
 . D MODOK,DISDXPR
 .Q
 Q
 ;
DISDXPR ;
 D RSLT("         RESULT: "_R),RSLT("      DATA TYPE: "_M),RSLT("         PARAMS: "_N),RSLT("AQ INDEX ACTIVE: "_S),RSLT("    DESCRIPTION: "_C),RSLT("   HELP MESSAGE: "_O)
 Q
 ;
 ; -----------------------------------------------------
 ;
