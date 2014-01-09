AUMUPD3 ;IHS/OIT/NKD - SCB UPDATE  05/23/2012 ;
 ;;12.0;TABLE MAINTENANCE;**3**;SEP 27,2011;Build 1
 ;ORIG RTN AUMUPDT
 Q  ;
 ;Called at POST by KIDS for AUM updates
POST ;EP -- MAIN EP
 N DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS),";",3)),EDTC,MJTC,AUMACT,AUMIEN,AUMRTN
 S AUMIEN=0
 F  S AUMIEN=$O(^AUMDATA(AUMIEN)) Q:'AUMIEN  D
 .S L=^AUMDATA(AUMIEN,0)
 .S AUMACT=$P(L,"^",2)
 .S AUMRTN=$P(L,"^",9)
 .S:AUMRTN'="" AUMACT=AUMACT_"^"_AUMRTN
 .I AUMACT="PCLASALL" S AUMPRV($P(L,"^",1),0)=$P(L,"^",3,8),AUMPRV(0)="AUM PRV DATA^^^"_$P(L,"^",1) ;AUM*12.0*1 - IHS/OIT/NKD
 .E  S L=$P(L,"^",3,8) D @AUMACT
 .Q
 I $D(AUMPRV(0)) D PCLASALL^AUMUPD4 ;AUM*12.0*1 - IHS/OIT/NKD - ROUTE TO PROVIDER TABLE UPDATE
 ;IHS/OIT/NKD AUM*12.0*3 ADDED PICKLIST REPORT
 I $D(EDTC) D PKLST^AUMUPD4
 D STUP
 Q
ADDOK ;ADDED MESSAGE
 D RSLT($J("",5)_"Added : "_L)
 Q
ADDFAIL ;FAILED MESSAGE
 D RSLT($J("",5)_$$M(0)_"ADD FAILED => "_L)
 Q
DASH ;PRT DASH LINE
 D RSLT("")
 D RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70)))
 D RSLT("")
 Q
DIE ;DIE EDIT
 N @($P($T(SVARS),";",3))
 L +(@(DIE_DA_")")):10
 E  D RSLT($J("",5)_$$M(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE
 L -(@(DIE_DA_")"))
 Q
IEN(X,%,Y) ;
 ;UPDATE AREA, SU, COUNTY
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
DIK ;KILL ENTRY
 N @($P($T(SVARS),";",3)),DIK
 D ^DIK
 Q
FILE ;FILE NEW ENTRY
 N @($P($T(SVARS),";",3))
 K DD,DO
 S DIC(0)="L"
 D FILE^DICN
 K DIC,DLAYGO
 Q
M(%) ;ERR MESSAGE
 Q $S(%=0:"ERROR : ",%=1:"NOT ADDED : ",1:"")
MODOK ;IF MOD OK 
 D RSLT($J("",5)_"Changed : "_L)
 Q
RSLT(%) ;MESSAGES DURING INSTALL
 N @($P($T(SVARS),";",3))
 D MES^XPDUTL(%)
 Q
IXDIC(DIC,DIC0,D,X,DLAYGO)   ;
 ;CALL TO FM IX^DIC
 N @($P($T(SVARS),";",3))
 S DIC(0)=DIC0
 K DIC0
 I '$G(DLAYGO) K DLAYGO
 D IX^DIC
 Q Y
AREANEW ;
 S E="New Area Codes"
 D ADDAREA
 Q
ADDAREA ;NEW AREA
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
CNTYNEW ;NEW COUNTY
 D ADDCNTY
 Q
ADDCNTY ;NEW COUNTY
 ;STATE^COUNTY CODE^NAME^FIPS CODE
 S S=$P(L,U),C=$P(L,U,2),N=$P(L,U,3),A=$P(L,U,4),L=S_"    "_C_"    "_N_$J("",30-$L(N))_A
 I $D(^AUTTCTY("C",S_C)) D  Q
 .S DA=$O(^AUTTCTY("C",S_C,0))
 .I N'=$P(^AUTTCTY(DA,0),U) D RSLT("County Name Change: "_N_"  "_$P(^AUTTCTY(DA,0),U)) S DIE="^AUTTCTY(",DR=".01///"_N D ^DIE
 .; ADDED LINE BACK IN RNB
 .I $D(^AUTTCTY("C",S_C)) D RSLT($J("",5)_$$M(1)_"COUNTY CODE EXISTS => "_S_C) Q
 S P("S")=$$IEN("^DIC(5,",S)
 Q:'P("S")
 S DIC="^AUTTCTY("
 S X=N
 S DIC("DR")=".02////"_P("S")_";.03///"_C_";.06///"_A
 D FILE
 D RSLT("NEW COUNTY (SECTION V-B)")
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
CNTYFR ;EP
 S LFR=L
 Q
CNTYMOD ;EP
 D RSLT("COUNTY CODE CHANGES (SECTION V-C)")
 S S=$P(LFR,U),C=$P(LFR,U,2),N=$P(LFR,U,3),A=$P(LFR,U,4),L1=S_"    "_C_"    "_N_$J("",30-$L(N))_A
 S P=$O(^AUTTCTY("C",S_C,0))
 S LTO=L
 S S=$P(L,U),C=$P(L,U,2),N=$P(L,U,3),A=$P(L,U,4),L2=S_"    "_C_"    "_N_$J("",30-$L(N))_A
 I 'P S P=$O(^AUTTCTY("C",S_C,0)) I 'P D ADDCNTY Q
 S P("S")=$$IEN("^DIC(5,",S)
 Q:'P("S")
 S DIE="^AUTTCTY("
 S DA=P
 S DR=".01///"_N_";.02////"_P("S")_";.03///"_C
 D DIE
 I $D(Y) D RSLT($J("",5)_" : EDIT COUNTY CODE FAILED => "_L1)
 E  D RSLT($J("",5)_" : EDIT COUNTY "_L1_" TO "_L2)
 Q
CNTYDEL ; County Delete
 ; Temporary action to physically remove a county entry
 D CNTYDEL^AUMUPD2
 Q
SUNEW ;--- ADD NEW SU
 ;AREA CODE^SU CODE^SU NAME
 D RSLT("NEW/REACTIVATED SERVICE UNIT CODE (SECTION VIII-B")
 D ADDSU
 Q
ADDSU ;
 S A=$P(L,U),S=$P(L,U,2),N=$P(L,U,3),L=$$LJ^XLFSTR(A,6)_$$LJ^XLFSTR(S,6)_N
 S EINSU=$O(^AUTTSU("C",A_S,"")) I EINSU'="" I $D(^AUTTSU("C",A_S))&($G(^AUTTSU(EINSU,-9))="") D RSLT($J("",5)_$$M(1)_"ASU EXISTS => "_A_S) Q
 I EINSU'="" I $G(^AUTTSU(EINSU,-9))'="" K ^AUTTSU(EINSU,-9)
 S P=$$IEN("^AUTTAREA(",A)
 Q:'P
 S DLAYGO=9999999.22
 S DIC="^AUTTSU("
 S X=N
 S DIC("DR")=".02////"_P_";.03///"_S
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
SUFR ;--- SU FROM
 S LFR=L
 Q
SUMOD ;--- MOD SU
 D RSLT("SERVICE UNIT CHANGES (SECTION VIII-B)")
 S A=$P(LFR,U),S=$P(LFR,U,2),N=$P(LFR,U,3),L1=A_" "_S_" "_N
 S P=$O(^AUTTSU("C",A_S,0))
 S LTO=L
 S A=$P(LTO,U),S=$P(LTO,U,2),N=$P(LTO,U,3)
 I 'P S P=$O(^AUTTSU("C",A_S,0)) I 'P D ADDSU Q
 I $D(^AUTTSU(P,-9)) D RSLT($J("",5)_" : EDIT SERVICE UNIT FAILED ENTY INACTIVE=> "_A_"  "_S_"  "_N) Q
 S L=A_" "_S_" "_N
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S DIE="^AUTTSU("
 S DA=P
 S DR=".01///"_N_";.02////"_P("A")_";.03///"_S
 D DIE
 I $D(Y) D RSLT($J("",5)_"SERVICE UNIT EDIT FAILED => "_L)
 E  D RSLT($J("",5)_"SERVICE UNIT CHANGED => "_L1_" to "_L)
 Q
SUINA ;--- INACTIVATE SU
 ;D RSLT("Inactivated Service Unit Codes (SECTION VIII-B)")
 S A=$P(L,"^",1),S=$P(L,"^",2),N=$P(L,"^",3)
 S P=$O(^AUTTSU("C",A_S,0))
 I 'P D  Q
 .D RSLT("SERVICE UNIT CODE NOT FOUND")
 S ^AUTTSU(P,-9)="INACTIVE"
 S L=$TR(L,"^"," ")
 D RSLT("Service Unit Inactivated => "_L)
 Q
 ;
LOCNEW ;--- ADD NEW LOC
 D RSLT("NEW FACILITY CODES (SECTION VIII-C)")
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
 .I %,P'=$P($G(^AUTTLOC(%,1)),U,2) S DIE="^AUTTLOC(",DA=%,DR=".28////"_DT_";.31///"_P D DIE D:$D(Y) RSLT($J("",5)_$$M(0)_"EDIT PSEUDO PREFIX FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"PSEUDO PREFIX UPDATED => "_L)
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S P("S")=$$IEN("^AUTTSU(",A_S)
 I 'P("S") D RSLT($J("",5)_"FAILED : "_L) Q
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
 .I '$D(Y) D RSLT("Location ") D ADDOK Q
 .D RSLT($J("",5)_$$M(0)_"EDIT LOCATION FAILED => "_L)
 S DINUM=+Y,DLAYGO=9999999.06
 S DIC="^AUTTLOC(",X=DINUM,DIC("DR")=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.28////"_DT_";.31///"_P_";.32///"_UQID
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 KILL DINUM,DLAYGO
 Q
LOCFR ;LOC FR
 S LFR=L
 Q
LOCMOD ;--- MOD LOC
 ;D RSLT("FACILITY CODE CHANGES (SECTION VIII-C)")
 S A=$P(LFR,U),S=$P(LFR,U,2),F=$P(LFR,U,3),N=$P(LFR,U,4),L1=A_" "_S_" "_F_" "_N
 S P=$O(^AUTTLOC("C",A_S_F,0))
 S LTO=L
 S A=$P(LTO,U),S=$P(LTO,U,2),F=$P(LTO,U,3),N=$P(LTO,U,4),L2=A_" "_S_" "_F_" "_N
 I 'P S P=$O(^AUTTLOC("C",A_S_F,0)) I 'P D ADDLOC Q
 S L=A_" "_S_" "_F_" "_N_$J("",32-$L(N))_$P(LTO,U,5)
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S P("S")=$$IEN("^AUTTSU(",A_S)
 I 'P("S") D RSLT($J("",5)_$$M(0)_"EDIT LOCATION FAILED => "_L) Q
 S DIE="^AUTTLOC(",DA=P,DR=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.28////"_DT_";.31///"_$P(LTO,U,5)_";.32////"_$P(LTO,U,6)
 S ZZDIE=DIE,ZZDA=DA,ZZDR=DR
 D DIE
 I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT LOCATION FAILED => "_L) Q
 S DIE="^DIC(4,",DA=$P(^AUTTLOC(P,0),U),DR=".01///"_N
 D DIE
 I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT INSTITUTION FAILED => "_L) Q
 D RSLT(""),RSLT("Location Changed: "_L1_" TO "_L2)
 D RSLT($$LOCMOD^AUMXPORT(LFR,LTO)_" patients marked for export because of the Location Code changes.")
 Q
LOCACT ;---ACTIVATE LOC
 D RSLT("Activate Location Code")
 S LORG=L
 S STAT="@" D LOCST I '% S STAT="",L=LORG D ADDLOC Q
 I $D(Y) D RSLT($J("",5)_"EDIT ACTIVE DATE FAILED => "_L) I 1
 E  D RSLT($J("",5)_"ACTIVATED => "_L)
 Q
LOCINA ;--- INACTIVATE LOC
 D RSLT("Inactivate Location Code")
 S STAT=DT D LOCST I '% Q
 I $D(Y) D RSLT($J("",5)_"EDIT INACTIVE DATE FAILED => "_L) I 1
 E  D RSLT($J("",5)_"INACTIVATED => "_L)
 Q
LOCST ;CHANGE THE STATUS OF THE LOCATION ENTRY
 S A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4),P=$P(L,U,5)
 S L=A_" "_S_" "_F_" "_N_" "_P
 S %=A_S_F,%=$O(^AUTTLOC("C",%,0))
 I '% D RSLT($J("",5)_"ASUFAC "_A_S_F_" not found (OK).") Q
 S DIE="^AUTTLOC(",DA=%,DR=".27////"_STAT
 D DIE
 K STAT Q
COMNEW ;--- ADD COMMUNITY
 ;D RSLT("NEW COMMUNITY CODES (SECTION V-C)")
 D ADDCOMM
 Q
ADDCOMM ;
 S S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6),L=S_" "_O_" "_C_" "_N_$J("",32-$L(N))_A_" "_V
 I $D(^AUTTCOM("C",S_O_C)) D  Q
 .S DA=$O(^AUTTCOM("C",S_O_C,0))
 .I N'=$P(^AUTTCOM(DA,0),U) D RSLT("Community Name Change: "_N_"  "_$P(^AUTTCOM(DA,0),U)) S DIE="^AUTTCOM(",DR=".01///"_N D ^DIE
 .S P("V")=$$IEN("^AUTTSU(",A_V) Q:'P("V")  I P("V")'=$P(^AUTTCOM(DA,0),U,5) D RSLT("Community: "_N_$J("",5)_"SU Change: "_V) S DIE="^AUTTCOM(",DR=".05///"_P("V") D ^DIE
 .S P("A")=$$IEN("^AUTTAREA(",A) Q:'P("A")  I P("A")'=$P(^AUTTCOM(DA,0),U,6) D RSLT("Community: "_N_$J("",5)_" AREA Change: "_A) S DIE="^AUTTCOM(",DR=".06///"_P("A") D ^DIE
 .;D RSLT($J("",5)_$$M(1)_"STCTYCOM CODE EXISTS => "_S_O_C_"  "_N_"  "_$P(^AUTTCOM(DA,0),U))
 S P("O")=$$IEN("^AUTTCTY(",S_O)
 Q:'P("O")
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S P("V")=$$IEN("^AUTTSU(",A_V)
 Q:'P("V")
 S DLAYGO=9999999.05,DIC="^AUTTCOM(",X=N,DIC("DR")=".02////"_P("O")_";.05////"_P("V")_";.06////"_P("A")_";.07///"_C
 D FILE
 D RSLT("NEW COMMUNITY")
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
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
 D DASH,RSLT($$COMMMOD^AUMXPORT(LFR,LTO)_" patients marked for export because of the Community Code changes.")
 Q
COMINAC ;INACTIVATE COMMUNITY
 D COMINAC^AUMUPD2
 Q
COMACT ; ACTIVATE COMMUNITY
 S S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6),L=S_" "_O_" "_C_" "_N_$J("",32-$L(N))_A_" "_V
 I '$D(^AUTTCOM("C",S_O_C)) S L=^AUMDATA(AUMIEN,0),L=$P(L,"^",3,8) D COMNEW Q
 S DA=$O(^AUTTCOM("C",S_O_C,0))
 S DIE="^AUTTCOM(",DR=".18////@"
 D DIE
 I $D(Y) D RSLT($J("",5)_"EDIT ACTIVATION FAILED => "_L)
 E  D RSLT($J("",5)_"ACTIVATED => "_L)
 Q
CLINNEW ;--- ADD NEW CLINIC
 D RSLT("NEW CLINIC CODES (SECTION XIX)")
 D ADDCLIN
 KILL DLAYGO
 Q
ADDCLIN ;
 ;CLINIC CODE^CLINIC NAME^ABBREVIATION^PRIMARY CARE^WORKLOAD FLG
 S C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),P=$P(L,U,4),R=$P(L,U,5),L=C_" "_N_$J("",(32-$L(N)))_$$LJ^XLFSTR(A,8)_$$LJ^XLFSTR(P,11)_R
 I $D(^DIC(40.7,"C",C)) D RSLT($J("",5)_$$M(1)_"CLINIC CODE EXISTS => "_C),RSLT("") Q
 S DLAYGO=40.7,DIC="^DIC(40.7,",X=N,DIC("DR")="1///"_C_";999999901///"_A_";90000.01///"_R
 I $L(P) S DIC("DR")=DIC("DR")_";999999902///"_P
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
CLINFR ;clinic from
 S LFR=L
 Q
CLINMOD ;--- MOD CLINIC
 D RSLT("MODIFY CLINIC")
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
TRIBEFR ;tribe from
 D TRIBEFR^AUMUPD2
 Q
TRIBEMOD ;--- MOD TRIBE
 D TRIBEMOD^AUMUPD2
 Q
TRIBENEW ;--- NEW TRIBE
 D TRIBENEW^AUMUPD2
 Q
PCLASNEW ;NEW PROVIDER CLASS (SERVICES)
 D PCLASNEW^AUMUPD2
 Q
PCLASFR ;provider class (services)
 D PCLASFR^AUMUPD2
 Q
PCLASMOD ;provider class change
 D PCLASMOD^AUMUPD2
 Q
EXAMNEW ;new exam
 D EXAMNEW^AUMUPD2
 Q
 ;IHS/OIT/NKD AUM*12.0*3 Added measurement type update
MEASMOD ;update measurement type
 D MEASMOD^AUMUPD2
 Q
EDTMOD ;update education topics
 D EDTMOD^AUMUPD4
 Q
MJTMOD ;update major education topics
 D MJTMOD^AUMUPD4
 Q
INSMOD ;new insurer type
 D INSMOD^AUMUPD2
 Q
RESNEW ;RESERVATION CODE
 ;CODE^NAME^AREA^STATE
 D RESNEW^AUMUPD2
 Q
RESFR ;RESERVATION CHANGES
 D RESFR^AUMUPD2
 Q
RESMOD ;RESERVATION CHANGE TO
 D RESMOD^AUMUPD2
 Q
ADDINST ; Add institution
 D ADDINST^AUMUPD2
 Q
ADDSTNM ; Add station no
 D ADDSTNM^AUMUPD2
 Q
DELSTNM ; Delete station no
 D DELSTNM^AUMUPD2
 Q
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables
 Q
STUP ;UPDATE THE STATE CHANGES
 Q
 S (DIE,DIC)="^DIC(5,"
 F L="NEWFOUNDLAND;NL;83","QUEBEC;QC;92","CANADA;CA;96","UNKNOWN;;99","PUERTO RICO;PR;72" D
 .S DA=$S($D(^DIC(5,"B",$P(L,";"))):$O(^DIC(5,"B",$P(L,";"),0)),$D(^DIC(5,"C",$P(L,";",3))):$O(^DIC(5,"C",$P(L,";",3),0)),1:"")
 .I DA="" D  Q
 ..S X=$P(L,";")
 ..S DIC("DR")="2///"_$P(L,";",3)_";1///"_$P(L,";",2)
 ..D FILE
 ..I $D(Y) D RSLT($J("",5)_$$M(0)_"STATE ADD FAILED => "_$P(L,";")) Q
 ..D RSLT("STATE ADDED: "_$P(L,";"))
 .S DR="1///"_$P(L,";",2)
 .D ^DIE
 .I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT STATE FAILED => "_$P(L,";")) Q
 .D RSLT("Changed STATE ABBR: "_$P(L,";")_"  "_$P(L,";",2))
 Q
