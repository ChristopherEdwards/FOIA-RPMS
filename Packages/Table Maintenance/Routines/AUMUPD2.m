AUMUPD2 ;IHS/OIT/NKD - SCB UPDATE  11/29/2011 ;
 ;;12.0;TABLE MAINTENANCE;**1**;SEP 27,2011;Build 1
 ;AUM*9.1*4 8/18/2009 OIT.IHS.FCJ ADDED RESNEW, RESFR AND RESMOD MODULES
 ;and Line description for Provider class
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
EXAMNEW ;EP --- NEW EXAM
 D RSLT("NEW EXAM")
 D RSLT($J("",13)_"NAME")
 D RSLT($J("",13)_"----")
 D ADDEXAM
 Q
ADDEXAM ;  
 S N=$P(L,U),C=$P(L,U,2),L=N
 I $D(^AUTTEXAM("C",C)) D RSLT($J("",5)_$$M(1)_"EXAM CODE EXISTS => "_C_" "_N) Q
 S DLAYGO=9999999.15,DIC="^AUTTEXAM(",X=N
 S DIC("DR")=".02///"_C
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 K DLAYGO
 Q
 ;
EXAMFR ;EP - exam from
 S LFR=L
 Q
EXAMMOD ;EP - modify exam file
 S E="Exam Name Changes"
 S N=$P(LFR,"^",1),C=$P(LFR,"^",2)
 S DA=$O(^AUTTEXAM("C",C,0))
 S LTO=L
 S N=$P(LTO,"^"),C=$P(LTO,"^",2)
 S:'DA DA=$O(^AUTTEXAM("C",C,0))
 I 'DA D ADDEXAM Q
 S L=C_" "_N
 S DIE="^AUTTEXAM(",DR=".01///"_N D DIE
 I $D(Y) D RSLT(E_" : CHANGE FAILED => "_L) Q
 D MODOK
 Q
EXAMINA ;EP - inactivate exam
 D RSLT("Inactivated Exam Codes")
 S N=$P(L,U)
 S C=$P(L,"^",2)
 S DA=$O(^AUTTEXAM("C",C,0)) Q:'DA
 S DIE="^AUTTEXAM("
 S DR=".04///1"
 D ^DIE
 I $D(Y) D RSLT("CHANGE FAILED => "_L) Q
 D RSLT("Code Inactivated: "_N_"  "_C)
 Q
EDUCNEW ;EP --- NEW PATIENT ED- P&F
 D RSLT("EDUCATION - PATIENT AND FAMILY")
 D RSLT($J("",13)_"NAME")
 D RSLT($J("",13)_"----")
 D ADDEDUC
 Q
ADDEDUC ;--- ADD THE NEW PATIENT EDUCATION
 S N=$P(L,U),M=$P(L,U,2),C=$P(L,U,3),L=N
 I $D(^AUTTEDPF("B",N)) D RSLT($J("",5)_$$M(1)_"PT ED NAME EXISTS => "_N) Q
 S DLAYGO=9999999.98,DIC="^AUTTEDPF(",X=N
 S DIC("DR")=".02///"_M_";.03///"_C
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
HFNEW ;EP --- NEW HEALTH FACTORS
 D RSLT("NEW HEALTH FACTORS")
 ;D RSLT($J("",13)_"NAME")
 ;D RSLT($J("",13)_"----")
 D ADDHF
 Q
ADDHF ;
 S N=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),S=$P(L,U,4),D=$P(L,U,5)
 S L=N_" "_O_"  "_C_"  "_S_"  "_D
 I $D(^AUTTHF("B",N)) D RSLT($J("",5)_$$M(1)_"HEALTH FACTOR EXISTS => "_N),RSLT("") Q
 S DLAYGO=9999999.64,DIC="^AUTTHF(",X=N
 S DIC("DR")=".02///"_D_";.03///"_O_";.1///"_C_";.14///"_S
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
HFFR ;EP --- HEALTH FACTOR FROM
 S LFR=L
 Q
HFMOD ;EP --- MODIFY HEALTH FACTOR
 S E="Health Factor Changes"
 S LTO=L
 S N=$P(LFR,"^",1)
 S DA=$O(^AUTTHF("B",N,0))
 S N=$P(LTO,"^",1),O=$P(LTO,"^",2),C=$P(LTO,"^",3),S=$P(LTO,"^",4),D=$P(LTO,"^",5),M=$P(LTO,"^",6)
 I 'DA S DA=$O(^AUTTHF("B",N,0))
 I 'DA D ADDHF Q
 S $P(^AUTTHF(DA,0),"^",13)=""
 S $P(^AUTTHF(DA,0),"^",15)=""
 S DIE="^AUTTHF("
 S DR=".01///"_N_";.03///"_O_";.1///"_C_";.14///"_S_";.02///"_D_";8801///"_M
 D DIE
 I $D(Y) D RSLT(E_" : CHANGE FAILED => "_L) Q
 D MODOK
 Q
HFINA ;EP --- INACTIVATE HEALTH FACTOR
 D RSLT("Inactivated Health Factors")
 S N=$P(L,U)
 S D=$P(L,U,2)
 S L=N_"  "_D
 S DA=$O(^AUTTHF("B",N,0)) Q:'DA
 S DIE="^AUTTHF("
 S DR=".13///1;.15///"_D
 D ^DIE
 I $D(Y) D RSLT($J("",5)_"EDIT FAILED => "_L)
 E  D RSLT($J("",5)_"INACTIVATED => "_L)
 Q
 ;
PCLASNEW ;EP --- NEW PROV CLASS
 ;CODE^NAME^ABRV^PCP^WL   ;AUM9.1*4 IHS/OIT/FCJ NEW LINE
 S E="NEW SERVICES RENDERED BY (PROVIDER CODES)"
 D RSLT(E)
 ;D RSLT($J("",11)_"CODE NAME"_$J("",28)_"ABRV.")
 ;D RSLT($J("",11)_"---- ----"_$J("",28)_"-----")
 D ADDPCLAS
 Q
ADDPCLAS ;
 S C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),P=$P(L,U,4),R=$P(L,U,5)
 S L=C_" "_N_$J("",(32-$L(N)))_A
 I $D(^DIC(7,"D",C)) D RSLT($J("",5)_$$M(1)_"PROVIDER CODE EXISTS => "_C),RSLT("") Q
 S DLAYGO=7,DIC="^DIC(7,",X=N,DIC("DR")="1///"_A_";9999999.01///"_C_";9999999.03///"_P_";9999999.05///"_R
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
PCLASFR ;EP - provider class from
 S LFR=L
 Q
PCLASMOD ;EP
 D RSLT("SERVICES RENDERED BY (PROVIDER) CODE CHANGES (SECTION XV)")
 S C=$P(LFR,"^",1),N=$P(LFR,"^",2),A=$P(LFR,"^",3)
 S LTO=L
 S C=$P(LTO,"^",1),N=$P(LTO,"^",2),A=$P(LTO,"^",3),I=$P(LTO,"^",4),II=$P(LTO,"^",5)
 S P=$O(^DIC(7,"D",C,0))
 I 'P D ADDPCLAS Q
 S L=C_" "_N_" "_A
 S DIE="^DIC(7,",DA=P,DR=".01///"_N_";1///"_A_";9999999.01///"_C_";9999999.03///"_I_";9999999.05///"_II
 D ^DIE
 I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT PROVIDER CODE FAILED => "_L) Q
 D MODOK
 Q
 ;
MEASNEW ;EP --- NEW MEASUREMENT TYPE
 S E="New Measurement Type"
 D RSLT(E)
 D ADDMEAS
 Q
ADDMEAS ;
 S N=$P(L,"^"),S=$P(L,"^",2),C=$P(L,"^",3),L=N_" "_S_"  "_C
 I $D(^AUTTMSR("C",C)) D RSLT(E_" : MEASUREMENT TYPE CODE EXISTS => "_C) Q
 S DLAYGO=9999999.07,DIC="^AUTTMSR(",X=N,DIC("DR")=".02///"_S_";.03///"_C D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
RESNEW ; NEW RESERVATION
 ;CODE^NAME^AREA^STATE
 I $G(AUMFLG)=1 S L=LTO
 D RSLT("NEW RESERVATION CODE")
 S N=$P(L,U,2),C=$P(L,U),A=$P(L,U,3),S=$P(L,U,4)
 S L=N_"  "_C_"  "_A_"  "_S
 I $D(^AUTTRES("B",N))!$D(^AUTTRES("C",C)) D RSLT($J("",5)_$$M(1)_"RESERVATION ENTRY EXISTS => "_N_" "_C) Q
 S DLAYGO=9999999.47,DIC="^AUTTRES(",X=N
 S DIC("DR")=".02///"_C_";.03///"_S_";.04///"_A
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 K AUMFLG Q
 ;
RESFR ;EP --- EDIT RESERVATION ENTRY
 S AUMFLG=0
 D RSLT("RESERVATION CODE CHANGES")
 S LFR=L
 Q
RESMOD ;EP --- CONT EDIT RESERVATION ENTRY
 S LTO=L
 S N=$P(LFR,U,2),C=$P(LFR,U)
 S L=N_" "_C_"  "_$P(LFR,U,3)_"  "_$P(LFR,U,4)
 S DA=$O(^AUTTRES("B",N,0)) I 'DA S DA=$O(^AUTTRES("C",C,0))
 S N=$P(LTO,U,2),C=$P(LTO,U),A=$P(LTO,U,3),S=$P(LTO,U,4)
RESMOD2 ;
 I 'DA S DA=$O(^AUTTRES("C",C,0)) I 'DA S DA=$O(^AUTTRES("B",N,0))
 I 'DA S AUMFLG=1 D RESNEW Q
 S DIE="^AUTTRES("
 S DR=".01///"_N_";.02///"_C_";.03///"_S_";.04///"_A
 D DIE
 I $D(Y) D RSLT($J("",5)_"RESERVATION CHANGE FAILED => "_L)
 E  D RSLT($J("",5)_"RESERVATION CHANGE => "_N_" "_C_" "_S_" "_A)
 Q
 ;
COMINAC ;INACTIVATE COMMUNITY
 S S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6),L=S_" "_O_" "_C_" "_N_$J("",32-$L(N))_A_" "_V
 I '$D(^AUTTCOM("C",S_O_C)) D RSLT($J("",5)_"INACTIVATE COMMUNITY FAILED: STCTYCOM CODE DOES NOT EXIST => "_S_O_C) Q
 S DA=$O(^AUTTCOM("C",S_O_C,0))
 S DIE="^AUTTCOM(",DR=".18////"_DT
 D DIE
 I $D(Y) D RSLT($J("",5)_"EDIT INACTIVE DATE FAILED => "_L)
 E  D RSLT($J("",5)_"INACTIVATED => "_L)
 Q
CNTYDEL ; County Delete
 ; Temporary action to physically remove a county entry
 D RSLT("COUNTY CODE DELETE (SECTION V-C)")
 S LTO=L
 S S=$P(L,U),C=$P(L,U,2),N=$P(L,U,3),A=$P(L,U,4),L2=S_"    "_C_"    "_N_$J("",30-$L(N))_A
 S P=$O(^AUTTCTY("C",S_C,0))
 I 'P D RSLT($J("",5)_"NOT DELETED : COUNTY CODE DOES NOT EXIST => "_L2) Q
 S DIK="^AUTTCTY("
 S DA=P
 D ^DIK
 I '$D(Y) D RSLT($J("",5)_" : DELETE COUNTY CODE FAILED => "_L2)
 E  D RSLT($J("",5)_" : COUNTY CODE DELETED: "_L2)
 Q
TRIBEFR ;EP --- tribe from
 S LFR=L
 Q
TRIBEMOD ;EP --- MOD TRIBE
 ;      C=CODE, N=NAME, LN=LONG NAME, P=IEN
 D RSLT("MODIFY TRIBE")
 S C=$P(LFR,U),N=$P(LFR,U,2),LN=$P(LFR,U,3),L1=C_" "_N
 S P=$O(^AUTTTRI("C",C,0))
 S LTO=L
 S C=$P(LTO,U),N=$P(LTO,U,2),LN=$P(LTO,U,3)
 I 'P S P=$O(^AUTTTRI("C",C,0))
 I 'P D ADDTRIBE Q
 S L=C_" "_N
 S DIE="^AUTTTRI("
 S DA=P
 S DR=".01///"_N_";.02///"_C_";.03///"_LN
 D DIE
 I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT TRIBE FAILED => "_L) Q
 D RSLT("Changed: "_L1_" TO "_L)
 Q
TRIBENEW ;EP --- NEW TRIBE
 D RSLT("NEW TRIBE")
 D ADDTRIBE
 Q
ADDTRIBE ;
 S C=$P(L,U),N=$P(L,U,2)
 S L="  "_$$LJ^XLFSTR(C,5)_$$LJ^XLFSTR(N,4)
 S %=$O(^AUTTTRI("C",C,0))
 I % D RSLT($J("",5)_$$M(1)_"TRIBE EXISTS => "_N)  Q
 S DLAYGO=9999999.03
 S DIC="^AUTTTRI("
 S X=N
 S DIC("DR")=".02///"_C
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
ADDINST ;EP --- Add institute
 ;
 D RSLT("ADD INSTITUTION AND STATION NUMBER")
 S INSNAM=$P(L,"^",1),STNUM=$P(L,"^",3)
 F %=+$P(^DIC(4,0),U,3):1 Q:'$D(^DIC(4,%))
 I %>99999 D RSLT($J("",5)_$$M(0)_"DINUM FOR INSTITUTION TOO BIG. NOTIFY ISC.") Q
 ;I %,$D(^DIC(4,%,0))
 S DLAYGO=4,DIC="^DIC(4,",DINUM=%,X=INSNAM
 ;S DIE="^DIC(4,",DA=%,DR=".01///"_INSNAM_";
 ;S DR="99///"_STNUM
 D FILE I Y<0 D RSLT($J("",5)_$$M(0)_"EDIT INSTITUTION FAILED => "_L) Q
 I $D(Y) D RSLT($J("",5)_"INSTITUTION NAME UPDATED => "_INSNAM)
 K DINUM,DLAYGO
 S DIE="^DIC(4,",DA=%,DR="99////"_STNUM D DIE
 Q
ADDSTNM ;EP --- Add station number
 ;
 D RSLT("ADD STATION NUMBER TO INSTITUTION")
 S INSNAM=$P(L,"^",1),ASUFAC=$P(L,"^",2),STNUM=$P(L,"^",3)
 S XLOCEIN=$O(^AUTTLOC("C",ASUFAC,""))
 I $L(XLOCEIN)<1 D RSLT($J("",5)_"STATION NUMBER ADD FAILED => "_L) Q
 S XLOCDAT=$G(^AUTTLOC(XLOCEIN,0))
 S XINSTEIN=$P(XLOCDAT,"^",1),XINSTDAT=$G(^DIC(4,XINSTEIN,0))
 S XINSTNM=$P(XINSTDAT,"^",1)
 S DA=XINSTEIN
 S DR="99////"_STNUM
 S DIE="^DIC(4,"
 ;S AUMDA=DA
 D DIE
 I $D(Y) D RSLT($J("",5)_"STATION NUMBER ADD FAILED => "_L)
 E  D RSLT($J("",5)_"STATION NUMBER ADD => "_INSNAM_" "_ASUFAC_" "_STNUM)
 Q
DELSTNM ;EP --- Remove station number
 ;
 D RSLT("REMOVE STATION NUMBER FROM INSTITUTION")
 S INSNAM=$P(L,"^",1),ASUFAC=$P(L,"^",2),STNUM=$P(L,"^",3)
 S XLOCEIN=$O(^AUTTLOC("C",ASUFAC,""))
 I $L(XLOCEIN)<1 D RSLT($J("",5)_"STATION NUMBER DELETE FAILED => "_L) Q
 S XLOCDAT=$G(^AUTTLOC(XLOCEIN,0))
 S XINSTEIN=$P(XLOCDAT,"^",1),XINSTDAT=$G(^DIC(4,XINSTEIN,0))
 S XINSTNM=$P(XINSTDAT,"^",1)
 S DA=XINSTEIN
 S DR="99////@"
 S DIE="^DIC(4,"
 ;S AUMDA=DA
 D DIE
 I $D(Y) D RSLT($J("",5)_"STATION NUMBER DELETE FAILED => "_L)
 E  D RSLT($J("",5)_"STATION NUMBER DELETE => "_INSNAM_" "_ASUFAC_" "_STNUM)
 Q
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables
 Q
