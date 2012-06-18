AUMUPDT ;IHS/ITSC/DMJ - SCB UPDATE  2/18/2004 [ 10/04/2006  12:33 PM ]
 ;;8.1;AUM - SCB UPDATE;**1,2**;NOV 9, 2007
 ;
POST ;EP -- MAIN EP
 N DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS),";",3))
 S AUMIEN=0
 F  S AUMIEN=$O(^AUMDATA(AUMIEN)) Q:'AUMIEN  D
 .S L=^AUMDATA(AUMIEN,0)
 .S AUMACT=$P(L,"^",2)
 .S AUMRTN=$P(L,"^",9)
 .S:AUMRTN'="" AUMACT=AUMACT_"^"_AUMRTN
 .S L=$P(L,"^",3,8)
 .D @AUMACT
 Q
 ;
ADDOK ;----- "ADDED" MESSAGE
 D RSLT($J("",5)_"Added : "_L)
 Q
 ;
ADDFAIL ;----- "FAILED" MESSAGE
 D RSLT($J("",5)_$$M(0)_"ADD FAILED => "_L)
 Q
 ;
DASH ;----- PRT DASH LINE
 D RSLT("")
 D RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70)))
 D RSLT("")
 Q
 ;
DIE ;----- DIE EDIT
 N @($P($T(SVARS),";",3))
 L +(@(DIE_DA_")")):10
 E  D RSLT($J("",5)_$$M(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE
 L -(@(DIE_DA_")"))
 Q
 ;
IEN(X,%,Y) ;
 ;----- UPDATE AREA, SERVICE UNIT, COUNTY
 S Y=$O(@(X_"""C"",%,0)")) I Y Q +Y
 I Y D  S:Y<0 Y=""
 .N %,@($P($T(SVARS),";",3))
 .S L=Y
 .I X["AREA" D  Q
 ..N X
 ..D RSLT("(Add Missing Area)")
 ..D ADDAREA
 ..D RSLT("(END Add Missing Area)")
 .I X["SU" D  Q
 ..N X
 ..D RSLT("(Add Missing SU)")
 ..D ADDSU
 ..D RSLT("(END Add Missing SU)")
 .I X["CTY" D  Q
 ..N X
 ..D RSLT("(Add Missing County)")
 ..D ADDCNTY
 ..D RSLT("(END Add Missing County)")
 ;
 D:'Y RSLT($J("",5)_$$M(0)_$P(@(X_"0)"),U)_" DOES NOT EXIST => "_%)
 Q +Y
 ;
DIK ;--- KILL ENTRY
 N @($P($T(SVARS),";",3)),DIK
 D ^DIK
 Q
 ;
FILE ;--- FILE NEW ENTRY
 N @($P($T(SVARS),";",3))
 K DD,DO
 S DIC(0)="L"
 D FILE^DICN
 K DIC,DLAYGO
 Q
 ;
M(%) ;--- ERROR MESSAGE
 Q $S(%=0:"ERROR : ",%=1:"NOT ADDED : ",1:"")
 ;
MODOK ;--- IF MOD OK 
 D RSLT($J("",5)_"Changed : "_L)
 Q
 ;
RSLT(%) ;--- ISSUE MESSAGES DURING INSTALL
 N @($P($T(SVARS),";",3))
 D MES^XPDUTL(%)
 Q
 ;
IXDIC(DIC,DIC0,D,X,DLAYGO)   ;
 ;--- CALL TO FILEMAN IX^DIC
 N @($P($T(SVARS),";",3))
 S DIC(0)=DIC0
 K DIC0
 I '$G(DLAYGO) K DLAYGO
 D IX^DIC
 Q Y
 ;
AREANEW ;
 S E="New Area Codes"
 D ADDAREA
 Q
 ;
ADDAREA ;--- NEW AREA
 S A=$P(L,U),N=$P(L,U,2),R=$P(L,U,3),C=$P(L,U,4),L=$$LJ^XLFSTR(A,6)_$$LJ^XLFSTR(N,30)_$$LJ^XLFSTR(R,15)_C
 I $D(^AUTTAREA("B",N)) D RSLT($J("",5)_$$M(1)_"NAME EXISTS => "_N) Q
 I $D(^AUTTAREA("C",A)) D RSLT($J("",5)_$$M(1)_"CODE EXISTS => "_A) Q
 S DLAYGO=9999999.21
 S DIC="^AUTTAREA("
 S X=N
 S DIC("DR")=".02///"_A_";.03///"_R_";.04///"_C
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
CNTYNEW ;---- NEW COUNTY
 D RSLT("NEW COUNTY CODES (SECTION V-B)")
 D RSLT($$RJ^XLFSTR("STATE  CNTY   NAME",28))
 D RSLT($$RJ^XLFSTR("-----  ----   ----",28))
 D ADDCNTY
 Q
 ;
ADDCNTY ;--- NEW COUNTY
 S S=$P(L,U),C=$P(L,U,2),N=$P(L,U,3),A=$P(L,U,4),L=S_"    "_C_"    "_N_$J("",30-$L(N))_A
 I $D(^AUTTCTY("C",S_C)) D RSLT($J("",5)_$$M(1)_"CODE EXISTS => "_S_C) Q
 S P("S")=$$IEN("^DIC(5,",S)
 Q:'P("S")
 S DIC="^AUTTCTY("
 S X=N
 S DIC("DR")=".02////"_P("S")_";.03///"_C_";.06///"_A
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
SUNEW ;--- ADD NEW SU
 D RSLT("NEW/REACTIVATED SERVICE UNIT CODE (SECTION VIII-B")
 D RSLT($J("",13)_$$LJ^XLFSTR("AREA",6)_$$LJ^XLFSTR("S.U.",6)_"NAME")
 D RSLT($J("",13)_$$LJ^XLFSTR("----",6)_$$LJ^XLFSTR("----",6)_"----")
 D ADDSU
 Q
 ;
ADDSU ;
 S A=$P(L,U),S=$P(L,U,2),N=$P(L,U,3),L=$$LJ^XLFSTR(A,6)_$$LJ^XLFSTR(S,6)_N
 I $D(^AUTTSU("C",A_S)) D RSLT($J("",5)_$$M(1)_"ASU EXISTS => "_A_S) Q
 S P=$$IEN("^AUTTAREA(",A)
 Q:'P
 S DLAYGO=9999999.22
 S DIC="^AUTTSU("
 S X=N
 S DIC("DR")=".02////"_P_";.03///"_S
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
SUFR ;--- SU FROM
 S LFR=L
 Q
SUMOD ;--- MOD SU
 D RSLT("SERVICE UNIT CODE CHANGES (SECTION VIII-B)")
 D RSLT($J("",15)_"AA SU NAME")
 D RSLT($J("",15)_"-- -- ----")
 S A=$P(LFR,U),S=$P(LFR,U,2),N=$P(LFR,U,3)
 S P=$O(^AUTTSU("C",A_S,0))
 S LTO=L
 S A=$P(LTO,U),S=$P(LTO,U,2),N=$P(LTO,U,3)
 I 'P S P=$O(^AUTTSU("C",A_S,0)) I 'P D ADDSU Q
 S L=A_" "_S_" "_N
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S DIE="^AUTTSU("
 S DA=P
 S DR=".01///"_N_";.02////"_P("A")_";.03///"_S
 D DIE
 I $D(Y) D RSLT($J("",5)_" : EDIT SERVICE UNIT FAILED => "_L) Q
 D MODOK
 Q
 ;
SUINA ;--- INACTIVATE SERVICE UNIT
 D RSLT("Inactivated Service Unit Codes (SECTION VIII-B)")
 D RSLT($J("",15)_"AA SU NAME")
 D RSLT($J("",15)_"-- -- ----")
 S A=$P(L,"^",1),S=$P(L,"^",2),N=$P(L,"^",3)
 S P=$O(^AUTTSU("C",A_S,0))
 I 'P D  Q
 .D RSLT("SERVICE UNIT CODE NOT FOUND")
 S ^AUTTSU(P,-9)="INACTIVE"
 S L=$TR(L,"^"," ")
 D RSLT("Inactivated => "_L)
 Q
 ;
LOCNEW ;--- ADD NEW LOCATION
 D RSLT("NEW FACILITY CODES (SECTION VIII-C)")
 D RSLT($$RJ^XLFSTR("AA SU FA NAME",26)_$$RJ^XLFSTR("PSEUDO",34))
 D RSLT($$RJ^XLFSTR("-- -- -- ----",26)_$$RJ^XLFSTR("------",34))
 D ADDLOC
 Q
ADDLOC ;
 S A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4),P=$P(L,U,5),UQID=$P(L,U,6)
 S L=A_" "_S_" "_F_" "_N_$J("",32-$L(N))_P
 S %=A_S_F,%=$O(^AUTTLOC("C",%,0))
 I % D RSLT($J("",5)_$$M(1)_"ASUFAC EXISTS => "_A_S_F) D  Q
 .I $P($G(^AUTTLOC(%,0)),U,21) S DIE="^AUTTLOC(",DA=%,DR=".27///@;.28////"_DT D DIE D:$D(Y) RSLT($J("",5)_$$M(0)_"DELETE INACTIVE DATE FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"INACTIVE DATE DELETED => "_L)
 .S %=$O(^AUTTLOC("C",A_S_F,0)),%=$P(^AUTTLOC(%,0),U)
 .I %,$D(^DIC(4,%,0)),N'=$P(^DIC(4,%,0),U) S DIE="^DIC(4,",DA=%,DR=".01///"_N D DIE D:$D(Y) RSLT($J("",5)_$$M(0)_"EDIT INSTITUTION FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"INSTITUTION NAME UPDATED => "_L)
 .S %=$O(^AUTTLOC("C",A_S_F,0))
 .I P'=$P($G(^AUTTLOC(%,1)),U,2) S DIE="^AUTTLOC(",DA=%,DR=".28////"_DT_";.31///"_P D DIE D:$D(Y) RSLT($J("",5)_$$M(0)_"EDIT PSEUDO PREFIX FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"PSEUDO PREFIX UPDATED => "_L)
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S P("S")=$$IEN("^AUTTSU(",A_S)
 Q:'P("S")
 F DINUM=+$P(^DIC(4,0),U,3):1 Q:'$D(^DIC(4,DINUM))&('$D(^AUTTLOC(DINUM)))  I DINUM>99999 D RSLT($J("",5)_$$M(0)_"DINUM FOR LOC/INSTITUTION TOO BIG. NOTIFY ISC.") Q
 Q:DINUM>99999
 S DLAYGO=4,DIC="^DIC(4,",X=N
 D FILE
 K DINUM,DLAYGO
 I Y<0 D RSLT($J("",5)_$$M(0)_"^DIC(4 ADD FAILED => "_L) Q
 NEW AUMAD
 S AUMAD=0
 F  S AUMAD=$O(^DD(4,.01,1,AUMAD)) Q:'AUMAD  I $P(^(AUMAD,0),U,2)="AD",$E(^(1),1)="I" Q
 ; If AD xref on 4 is active, edit LOCATION and Quit.
 I AUMAD D  Q
 .S DA=+Y,DIE="^AUTTLOC(",DR=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.28////"_DT_";.31///"_P_";.32///"_UQID
 .D DIE
 .I '$D(Y) D ADDOK Q
 .D RSLT($J("",5)_$$M(0)_"EDIT LOCATION FAILED => "_L)
 S DINUM=+Y,DLAYGO=9999999.06
 S DIC="^AUTTLOC(",X=DINUM,DIC("DR")=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.28////"_DT_";.31///"_P_";.32///"_UQID
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 KILL DINUM,DLAYGO
 Q
 ;
LOCFR ;LOCATION FROM
 S LFR=L
 Q
LOCMOD ;--- MOD LOCATION
 D RSLT("FACILITY CODE CHANGES (SECTION VIII-C)")
 D RSLT($$RJ^XLFSTR("AA SU FA NAME",28)_$$RJ^XLFSTR("PSEUDO",34))
 D RSLT($$RJ^XLFSTR("-- -- -- ----",28)_$$RJ^XLFSTR("------",34))
 S A=$P(LFR,U),S=$P(LFR,U,2),F=$P(LFR,U,3)
 S P=$O(^AUTTLOC("C",A_S_F,0))
 S LTO=L
 S A=$P(LTO,U),S=$P(LTO,U,2),F=$P(LTO,U,3),N=$P(LTO,U,4)
 I 'P S P=$O(^AUTTLOC("C",A_S_F,0)) I 'P D ADDLOC Q
 S L=A_" "_S_" "_F_" "_N_$J("",32-$L(N))_$P(LTO,U,5)
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S P("S")=$$IEN("^AUTTSU(",A_S)
 Q:'P("S")
 S DIE="^AUTTLOC(",DA=P,DR=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.28////"_DT_";.31///"_$P(LTO,U,5)_";.32////"_$P(LTO,U,6)
 S ZZDIE=DIE,ZZDA=DA,ZZDR=DR
 D DIE
 I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT LOCATION FAILED => "_L) Q
 S DIE="^DIC(4,",DA=$P(^AUTTLOC(P,0),U),DR=".01///"_N
 D DIE
 I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT INSTITUTION FAILED => "_L) Q
 D MODOK
 D DASH,RSLT($$LOCMOD^AUMXPORT(LFR,LTO)_" patients marked for export because of the Location Code changes.")
 Q
 ;
LOCINA ;--- INACTIVATE LOCATION
 D RSLT("Inactivated Location Codes")
 S A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4),P=$P(L,U,5)
 S L=A_" "_S_" "_F_" "_N_" "_P
 S %=A_S_F,%=$O(^AUTTLOC("C",%,0))
 I '% D RSLT($J("",5)_"ASUFAC "_A_S_F_" not found (OK).") Q
 S DIE="^AUTTLOC(",DA=%,DR=".27////"_DT
 D DIE
 I $D(Y) D RSLT($J("",5)_"EDIT INACTIVE DATE FAILED => "_L) I 1
 E  D RSLT($J("",5)_"INACTIVATED => "_L)
 Q
 ;
COMNEW ;--- ADD COMMUNITY
 D RSLT("NEW COMMUNITY CODES (SECTION V-C)")
 D RSLT($$RJ^XLFSTR("ST CT COM NAME",27)_$$RJ^XLFSTR("AA SU",33))
 D RSLT($$RJ^XLFSTR("-- -- --- ----",27)_$$RJ^XLFSTR("-- --",33))
 D ADDCOMM
 Q
ADDCOMM ;
 S S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6),L=S_" "_O_" "_C_" "_N_$J("",32-$L(N))_A_" "_V
 I $D(^AUTTCOM("C",S_O_C)) D RSLT($J("",5)_$$M(1)_"STCTYCOM CODE EXISTS => "_S_O_C) Q
 S P("O")=$$IEN("^AUTTCTY(",S_O)
 Q:'P("O")
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S P("V")=$$IEN("^AUTTSU(",A_V)
 Q:'P("V")
 S DLAYGO=9999999.05,DIC="^AUTTCOM(",X=N,DIC("DR")=".02////"_P("O")_";.05////"_P("V")_";.06////"_P("A")_";.07///"_C
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
COMFR ;community from
 S LFR=L
 Q
COMMOD ;--- MOD COMMUNITY
 D RSLT("COMMUNITY CODE CHANGES (SECTION V-C)")
 D RSLT($J("",15)_"ST CT COM NAME"_$J("",28)_"AA SU")
 D RSLT($J("",15)_"-- -- --- ----"_$J("",28)_"-- --")
 S S=$P(LFR,U),O=$P(LFR,U,2),C=$P(LFR,U,3)
 S DA=$O(^AUTTCOM("C",S_O_C,0))
 S LTO=L
 S S=$P(LTO,U),O=$P(LTO,U,2),C=$P(LTO,U,3),N=$P(LTO,U,4),A=$P(LTO,U,5),V=$P(LTO,U,6)
 I 'DA S DA=$O(^AUTTCOM("C",S_O_C,0))
 I 'DA D ADDCOMM Q
 S L=S_" "_O_" "_C_" "_N_$J("",32-$L(N))_A_" "_V
 S P("O")=$$IEN("^AUTTCTY(",S_O)
 Q:'P("O")
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S P("V")=$$IEN("^AUTTSU(",A_V)
 Q:'P("V")
 S DIE="^AUTTCOM("
 S DR=".01///"_N_";.02////"_P("O")_";.05////"_P("V")_";.06////"_P("A")_";.07///"_C
 D DIE
 I $D(Y) D RSLT($J("",5)_$$M(0)_"CHANGE FAILED => "_L) Q
 D MODOK
 D DASH
 D DASH,RSLT($$COMMMOD^AUMXPORT(LFR,LTO)_" patients marked for export because of the Community Code changes.")
 Q
 ;
CLINNEW ;--- ADD NEW CLINIC
 D RSLT("NEW CLINIC CODES (SECTION XIX)")
 D RSLT($J("",11)_"CODE NAME"_$J("",28)_"ABRV.  PRI.CARE  1A WL RPT")
 D RSLT($J("",11)_"---- ----"_$J("",28)_"-----  --------  ---------")
 D ADDCLIN
 KILL DLAYGO
 Q
 ;
ADDCLIN ;
 S C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),P=$P(L,U,4),R=$P(L,U,5),L=C_" "_N_$J("",(32-$L(N)))_$$LJ^XLFSTR(A,8)_$$LJ^XLFSTR(P,11)_R
 I $D(^DIC(40.7,"C",C)) D RSLT($J("",5)_$$M(1)_"CLINIC CODE EXISTS => "_C),RSLT("") Q
 S DLAYGO=40.7,DIC="^DIC(40.7,",X=N,DIC("DR")="1///"_C_";999999901///"_A_";90000.01///"_R
 I $L(P) S DIC("DR")=DIC("DR")_";999999902///"_P
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
CLINFR ;clinic from
 S LFR=L
 Q
 ;
CLINMOD ;--- MOD CLINIC
 D RSLT("MODIFY CLINIC")
 D RSLT($J("",13)_"CODE NAME"_$J("",28)_"ABRV.  PRI.CARE  1A WL RPT")
 D RSLT($J("",13)_"---- ----"_$J("",28)_"-----  --------  ---------")
 S LTO=L
 S C=$P(LTO,"^",1),N=$P(LTO,"^",2),A=$P(LTO,"^",3),P=$P(LTO,"^",4),R=$P(LTO,"^",5)
 S DA=$O(^DIC(40.7,"C",C,0))
 I 'DA D ADDCLIN Q
 S DIE="^DIC(40.7,"
 S DR=".01///"_N_";999999901///"_A_";999999902///"_P_";90000.01///"_R
 D ^DIE
 S L=C_" "_N_$J("",(32-$L(N)))_$$LJ^XLFSTR(A,8)_$$LJ^XLFSTR(P,11)_R
 D MODOK
 Q
 ;
TRIBEFR ;tribe from
 S LFR=L
 Q
TRIBEMOD ;--- MOD TRIBE
 ;      C=CODE, O=OLD, N=NAME, P=IEN
 D RSLT("MODIFY TRIBE")
 D RSLT($$RJ^XLFSTR("CODE OLD NAME",28))
 D RSLT($$RJ^XLFSTR("---- --- ----",28))
 S C=$P(LFR,U),O=$P(LFR,U,2),N=$P(LFR,U,3)
 S P=$O(^AUTTTRI("C",C,0))
 S LTO=L
 S C=$P(LTO,U),O=$P(LTO,U,2),N=$P(LTO,U,3),G=$P(LTO,U,4)
 I 'P S P=$O(^AUTTTRI("C",C,0))
 I 'P D ADDTRIBE Q
 S L=C_" "_O_" "_N
 S DIE="^AUTTTRI("
 S DA=P
 S DR=".01///"_N_";.02///"_C_";.03///"_G_";.04///"_O
 D DIE
 I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT TRIBE FAILED => "_L) Q
 D MODOK
 Q
TRIBENEW ;--- NEW TRIBE
 D RSLT("NEW TRIBE")
 D ADDTRIBE
 Q
ADDTRIBE ;
 S C=$P(L,U),O=$P(L,U,2),N=$P(L,U,3),G=$P(L,"^",4)
 S L="  "_$$LJ^XLFSTR(C,5)_$$LJ^XLFSTR(O,4)_N
 S %=$O(^AUTTTRI("C",C,0))
 I % D RSLT($J("",5)_$$M(1)_"TRIBE EXISTS => "_N)  Q
 S DLAYGO=9999999.03
 S DIC="^AUTTTRI("
 S X=N
 S DIC("DR")=".02///"_C_";.03///"_G_";.04///"_O
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
PCLASFR ;provider class
 D PCLASFR^AUMUPD2
 Q
 ;
PCLASMOD ;provider class change
 D PCLASMOD^AUMUPD2
 Q
EXAMNEW ;new exam
 D EXAMNEW^AUMUPD2
 Q
ETUPDT ;update education topics
 S AUMN=$P(L,"^",2)
 S AUMIEN2=$O(^AUTTEDT("C",AUMN,0))
 Q:'AUMIEN2
 S ^AUTTEDT(AUMIEN2,0)=L
 Q
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables
 Q
