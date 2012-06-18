AUM41011 ;TASSC/MFD - SCB UPDATE  10/31/2003 [ 11/20/2003  3:32 PM ]
 ;;04.1;TABLE MAINTENANCE;**1**;OCT 13,2003
 ;
START ;EP -- MAIN EP
 N DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS),";",3))
 D GREET
 D DASH,SUNEW
 D DASH,SUMOD
 D DASH,LOCNEW
 D DASH,LOCMOD
 D DASH,LOCINACT
 D DASH,COMMNEW
 D DASH,COMMMOD
 D DASH,TRIBEMOD
 D DASH,EXAMNEW
 D DASH,CLINNEW
 D DASH,PCLASNEW
 ;D DASH,EDUCNEW
 D DASH,HFNEW
 Q
GREET ;----- GREETING/INTRO TEXT
 D RSLT($J("",5)_$P($T(UPDATE^AUM4101A),";",3))
 F L="GREET","INTROE","INTROI" D
 . F %=1:1 D RSLT($P($T(@L+%^AUM4101),";",3)) Q:$P($T(@L+%+1^AUM4101),";",3)="###"
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
E(L) ;-----
 Q $P($P($T(@L^AUM4101A),";",3),":",1)
 ;
IEN(X,%,Y) ;
 ;----- UPDATE AREA, SERVICE UNIT, COUNTY
 S Y=$O(@(X_"""C"",%,0)")) I Y Q +Y
 I 'Y S Y=$$VAL^AUM4101M(X,%)
 I Y D  S:Y<0 Y=""
 . N %,@($P($T(SVARS),";",3))
 . S L=Y
 . I X["AREA" D  Q
 . . N X
 . . D RSLT("(Add Missing Area)")
 . . D ADDAREA
 . . D RSLT("(END Add Missing Area)")
 . I X["SU" D  Q
 . . N X
 . . D RSLT("(Add Missing SU)")
 . . D ADDSU
 . . D RSLT("(END Add Missing SU)")
 . I X["CTY" D  Q
 . . N X
 . . D RSLT("(Add Missing County)")
 . . D ADDCNTY
 . . D RSLT("(END Add Missing County)")
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
RSLT(%) ; EP- INCREMENTS/UPDATES ^TMP("AUM4101,$J) called here and AUM4101
 ; global used to generate the email message sent by
 ; post-install routine
 S ^(0)=$G(^TMP("AUM4101",$J,0))+1,^(^(0))=% D MES(%)
 Q
 ;
MES(%) ;--- ISSUE MESSAGES DURING INSTALL
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
ADDAREA ;--- NEW AREA
 ; PROGRAMMER NOTE:  This s/r is required for every patch.
 S L=$P(L,";;",2),A=$P(L,U),N=$P(L,U,2),R=$P(L,U,3),C=$P(L,U,4),L=$$LJ^XLFSTR(A,6)_$$LJ^XLFSTR(N,30)_$$LJ^XLFSTR(R,15)_C
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
ADDCNTY ;--- NEW COUNTY
 ; PROGRAMMER NOTE:  This s/r is required for every patch.
 S L=$P(L,";;",2),S=$P(L,U),C=$P(L,U,2),N=$P(L,U,3),A=$P(L,U,4),L=S_"    "_C_"    "_N_$J("",30-$L(N))_A
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
ADDSU ;
 ; PROGRAMMER NOTE:  This s/r is required for every patch.
 S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),N=$P(L,U,3),L=$$LJ^XLFSTR(A,6)_$$LJ^XLFSTR(S,6)_N
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
SUNEW ;--- ADD NEW SU
 D RSLT($$E("SUNEW"))
 D RSLT($J("",13)_$$LJ^XLFSTR("AREA",6)_$$LJ^XLFSTR("S.U.",6)_"NAME")
 D RSLT($J("",13)_$$LJ^XLFSTR("----",6)_$$LJ^XLFSTR("----",6)_"----")
 F T=1:1 S L=$T(SUNEW+T^AUM4101A) Q:$P(L,";",3)="END"  D ADDSU
 Q
 ;
SUMOD ;--- MOD SU
 D RSLT($$E("SUMOD"))
 D RSLT($J("",15)_"AA SU NAME")
 D RSLT($J("",15)_"-- -- ----")
 F T=1:2 S L=$T(SUMOD+T^AUM4101A) Q:$P(L,";",3)="END"  S L("TO")=$T(SUMOD+T+1^AUM4101A) D
 . S L=$P(L,U,2,99),A=$P(L,U),S=$P(L,U,2),N=$P(L,U,3)
 . S P=$O(^AUTTSU("C",A_S,0))
 . S L=$P(L("TO"),U,2,99),A=$P(L,U),S=$P(L,U,2),N=$P(L,U,3)
 . I 'P S P=$O(^AUTTSU("C",A_S,0)) I 'P S L=";;"_L D ADDSU Q
 . S L=A_" "_S_" "_N
 . S P("A")=$$IEN("^AUTTAREA(",A)
 . Q:'P("A")
 . S DIE="^AUTTSU(",DA=P,DR=".01///"_N_";.02////"_P("A")_";.03///"_S
 . D DIE
 . I $D(Y) D RSLT($J("",5)_$$E(0)_" : EDIT SERVICE UNIT FAILED => "_L) Q
 . D MODOK
 Q
 ;
LOCNEW ;--- ADD NEW LOCATION
 D RSLT($$E("LOCNEW"))
 D RSLT($$RJ^XLFSTR("AA SU FA NAME",26)_$$RJ^XLFSTR("PSEUDO",34))
 D RSLT($$RJ^XLFSTR("-- -- -- ----",26)_$$RJ^XLFSTR("------",34))
 F T=1:1 S L=$T(LOCNEW+T^AUM4101A) Q:$P(L,";",3)="END"  D ADDLOC
 Q
ADDLOC ;
 S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4),P=$P(L,U,5)
 S L=A_" "_S_" "_F_" "_N_$J("",32-$L(N))_P
 S %=A_S_F,%=$O(^AUTTLOC("C",%,0))
 I % D RSLT($J("",5)_$$M(1)_"ASUFAC EXISTS => "_A_S_F) D  Q
 . I $P($G(^AUTTLOC(%,0)),U,21) S DIE="^AUTTLOC(",DA=%,DR=".27///@;.28////"_DT D DIE D:$D(Y) RSLT($J("",5)_$$M(0)_"DELETE INACTIVE DATE FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"INACTIVE DATE DELETED => "_L)
 . S %=$O(^AUTTLOC("C",A_S_F,0)),%=$P(^AUTTLOC(%,0),U)
 . I %,$D(^DIC(4,%,0)),N'=$P(^DIC(4,%,0),U) S DIE="^DIC(4,",DA=%,DR=".01///"_N D DIE D:$D(Y) RSLT($J("",5)_$$M(0)_"EDIT INSTITUTION FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"INSTITUTION NAME UPDATED => "_L)
 . S %=$O(^AUTTLOC("C",A_S_F,0))
 . I P'=$P($G(^AUTTLOC(%,1)),U,2) S DIE="^AUTTLOC(",DA=%,DR=".28////"_DT_";.31///"_P D DIE D:$D(Y) RSLT($J("",5)_$$M(0)_"EDIT PSEUDO PREFIX FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"PSEUDO PREFIX UPDATED => "_L)
 .Q
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
 . S DA=+Y,DIE="^AUTTLOC(",DR=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.28////"_DT_";.31///"_P
 . D DIE
 . I '$D(Y) D ADDOK Q
 . D RSLT($J("",5)_$$M(0)_"EDIT LOCATION FAILED => "_L)
 .Q
 S DINUM=+Y,DLAYGO=9999999.06,DIC="^AUTTLOC(",X=DINUM,DIC("DR")=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.28////"_DT_";.31///"_P
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 KILL DINUM,DLAYGO
 Q
 ;
LOCMOD ;--- MOD LOCATION
 D RSLT($$E("LOCMOD"))
 D RSLT($$RJ^XLFSTR("AA SU FA NAME",28)_$$RJ^XLFSTR("PSEUDO",34))
 D RSLT($$RJ^XLFSTR("-- -- -- ----",28)_$$RJ^XLFSTR("------",34))
 F T=1:2 S L=$T(LOCMOD+T^AUM4101A) Q:$P(L,";",3)="END"  S L("TO")=$T(LOCMOD+T+1^AUM4101A) D
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
 . I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT LOCATION FAILED => "_L) Q
 . S DIE="^DIC(4,",DA=$P(^AUTTLOC(P,0),U),DR=".01///"_N
 . D DIE
 . I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT INSTITUTION FAILED => "_L) Q
 . D MODOK
 .Q
 ;
 D DASH
 D RSLT("Checking Location Code changes to determine export status.")
 D RSLT("Patient data is not exported if the only change is to the Location NAME.")
 D RSLT("Location Code changes must be rolled up into the national data repository...")
 D DASH,RSLT($$LOCMOD^AUMXPORT("AUM4101A")_" patients marked for export because of the Location Code changes.")
 Q
 ;
LOCINACT ;--- INACTIVATE LOCATION
 D RSLT("Inactivated Location Codes")
 F T=1:1 S L=$T(LOCINACT+T^AUM4101A) Q:$P(L,";",3)="END"  D
 . S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4),P=$P(L,U,5)
 . S L=A_" "_S_" "_F_" "_N_" "_P
 . S %=A_S_F,%=$O(^AUTTLOC("C",%,0))
 . I '% D RSLT($J("",5)_"ASUFAC "_A_S_F_" not found (OK).") Q
 . S DIE="^AUTTLOC(",DA=%,DR=".27////"_DT
 . D DIE
 . I $D(Y) D RSLT($J("",5)_$$E(0)_"EDIT INACTIVE DATE FAILED => "_L) I 1
 . E  D RSLT($J("",5)_"INACTIVATED => "_L)
 .Q
 Q
 ;
COMMNEW ;--- ADD COMMUNITY
 D RSLT($$E("COMMNEW"))
 D RSLT($$RJ^XLFSTR("ST CT COM NAME",27)_$$RJ^XLFSTR("AA SU",33))
 D RSLT($$RJ^XLFSTR("-- -- --- ----",27)_$$RJ^XLFSTR("-- --",33))
 F T=1:1 S L=$T(COMMNEW+T^AUM4101A) Q:$P(L,";",3)="END"  D ADDCOMM
 Q
ADDCOMM ;
 S L=$P(L,";;",2),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6),L=S_" "_O_" "_C_" "_N_$J("",32-$L(N))_A_" "_V
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
COMMMOD ;--- MOD COMMUNITY
 D RSLT($$E("COMMMOD"))
 D RSLT($J("",15)_"ST CT COM NAME"_$J("",28)_"AA SU")
 D RSLT($J("",15)_"-- -- --- ----"_$J("",28)_"-- --")
 F T=1:2 S L=$T(COMMMOD+T^AUM4101A) Q:$P(L,";",3)="END"  S L("TO")=$T(COMMMOD+T+1^AUM4101A) D
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
 . I $D(Y) D RSLT($J("",5)_$$M(0)_"CHANGE FAILED => "_L) Q
 . D MODOK
 .Q
 D DASH
 D RSLT("Checking Community Code changes to determine export status.")
 D RSLT("Patient data is not exported if the only change is to the Commnuity NAME.")
 D RSLT("Commnity Code changes must be rolled up into the national data repository...")
 D DASH,RSLT($$COMMMOD^AUMXPORT("AUM4101A")_" patients marked for export because of the Community Code changes.")
 Q
 ;
CLINNEW ;--- ADD NEW CLINIC
 D RSLT($$E("CLINNEW"))
 D RSLT($J("",11)_"CODE NAME"_$J("",28)_"ABRV.  PRI.CARE  1A WL RPT")
 D RSLT($J("",11)_"---- ----"_$J("",28)_"-----  --------  ---------")
 F T=1:1 S L=$T(CLINNEW+T^AUM4101A) Q:$P(L,";",3)="END"  D ADDCLIN
 KILL DLAYGO
 Q
 ;
ADDCLIN ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),P=$P(L,U,4),R=$P(L,U,5),L=C_" "_N_$J("",(32-$L(N)))_$$LJ^XLFSTR(A,8)_$$LJ^XLFSTR(P,11)_R
 I $D(^DIC(40.7,"C",C)) D RSLT($J("",5)_$$M(1)_"CLINIC CODE EXISTS => "_C),RSLT("") Q
 S DLAYGO=40.7,DIC="^DIC(40.7,",X=N,DIC("DR")="1///"_C_";999999901///"_A_";90000.01///"_R
 I $L(P) S DIC("DR")=DIC("DR")_";999999902///"_P
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
TRIBEMOD ;--- MOD TRIBE
 ;      C=CODE, O=OLD, N=NAME, P=IEN
 N @$P($T(SVARS),";",3)
 D RSLT($$E("TRIBEMOD"))
 D RSLT($$RJ^XLFSTR("CODE OLD NAME",28))
 D RSLT($$RJ^XLFSTR("---- --- ----",28))
 F T=1:2 S L=$T(TRIBEMOD+T^AUM4101A) Q:$P(L,";",3)="END"  S L("TO")=$T(TRIBEMOD+T+1^AUM4101A) D
 . S L=$P(L,U,2,99),C=$P(L,U),O=$P(L,U,2),N=$P(L,U,3)
 . S P=$O(^AUTTTRI("C",C,0))
 . S L=$P(L("TO"),U,2,99),C=$P(L,U),O=$P(L,U,2),N=$P(L,U,3)
 . I 'P S P=$O(^AUTTTRI("C",C,0))
 . I 'P S L=";;"_L D ADDTRIBE Q
 . S L=C_" "_O_" "_N
 . S DIE="^AUTTTRI("
 . S DA=P
 . S DR=".01///"_N_";.02///"_C_";.04///"_O
 . D DIE
 . I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT TRIBE FAILED => "_L) Q
 . D MODOK
 Q
ADDTRIBE ;
 S L=$P(L,";;",2),C=$P(L,U),O=$P(L,U,2),N=$P(L,U,3)
 S L="  "_$$LJ^XLFSTR(C,5)_$$LJ^XLFSTR(O,4)_N
 S %=$O(^AUTTTRI("C",C,0))
 I % D RSLT($J("",5)_$$M(1)_"TRIBE EXISTS => "_N)  Q
 S DLAYGO=9999999.03
 S DIC="^AUTTTRI("
 S X=N
 S DIC("DR")=".02///"_C_";.04///"_O
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
EXAMNEW ;--- NEW EXAM
 N @$P($T(SVARS),";",3)
 D RSLT($$E("EXAMNEW"))
 D RSLT($J("",13)_"NAME")
 D RSLT($J("",13)_"----")
 F T=1:1 S L=$T(EXAMNEW+T^AUM4101A) Q:$P(L,";",3)="END"  D ADDEXAM
 Q
ADDEXAM ;  
 S L=$P(L,";;",2),N=$P(L,U),C=$P(L,U,2),L=N
 ;I $D(^AUTTEXAM("B",N)) D RSLT($J("",5)_$$M(1)_"EXAM NAME EXISTS => "_N) Q
 I $D(^AUTTEXAM("C",C)) D RSLT($J("",5)_$$M(1)_"EXAM CODE EXISTS => "_C_" "_N) Q
 S DLAYGO=9999999.15,DIC="^AUTTEXAM(",X=N
 S DIC("DR")=".02///"_C
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 K DLAYGO
 Q
 ;
EDUCNEW ;--- NEW PATIENT ED- P&F
 D RSLT($$E("EDUCNEW"))
 D RSLT($J("",13)_"NAME")
 D RSLT($J("",13)_"----")
 F T=1:1 S L=$T(EDUCNEW+T^AUM4101A) Q:$P(L,";",3)="END"  D ADDEDUC
 Q
ADDEDUC ;--- ADD THE NEW PATIENT EDUCATION
 S L=$P(L,";;",2),N=$P(L,U),M=$P(L,U,2),C=$P(L,U,3),L=N
 I $D(^AUTTEDPF("B",N)) D RSLT($J("",5)_$$M(1)_"PT ED NAME EXISTS => "_N) Q
 S DLAYGO=9999999.98,DIC="^AUTTEDPF(",X=N
 S DIC("DR")=".02///"_M_";.03///"_C
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
HFNEW ;--- NEW HEALTH FACTORS
 D RSLT($$E("HFNEW"))
 D RSLT($J("",13)_"NAME")
 D RSLT($J("",13)_"----")
 F T=1:1 S L=$T(HFNEW+T^AUM4101A) Q:$P(L,";",3)="END"  D ADDHF
 Q
ADDHF ;
 S L=$P(L,";;",2),N=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),S=$P(L,U,4),L=N_" "_O_"  "_C_"  "_S
 I $D(^AUTTHF("B",N)) D RSLT($J("",5)_$$M(1)_"HEALTH FACTOR EXISTS => "_N),RSLT("") Q
 S DLAYGO=9999999.64,DIC="^AUTTHF(",X=N,DIC("DR")=".03///"_O_";.1///"_C_";.14///"_S
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
PCLASNEW ;--- NEW PROV CLASS
 S E=$$E("PCLASNEW")
 D RSLT(E)
 D RSLT($J("",11)_"CODE NAME"_$J("",28)_"ABRV.")
 D RSLT($J("",11)_"---- ----"_$J("",28)_"-----")
 F T=1:1 S L=$T(PCLASNEW+T^AUM4101A) Q:$P(L,";",3)="END"  D ADDPCLAS
 Q
ADDPCLAS ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),L=C_" "_N_$J("",(32-$L(N)))_A
 I $D(^DIC(7,"D",C)) D RSLT($J("",5)_$$M(1)_"PROVIDER CODE EXISTS => "_C),RSLT("") Q
 S DLAYGO=7,DIC="^DIC(7,",X=N,DIC("DR")="1///"_A_";9999999.01///"_C
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables
 Q
