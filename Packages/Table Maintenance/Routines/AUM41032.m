AUM41032 ;IHS/ITSC/DMJ - SCB UPDATE  2/18/2004 [ 04/01/2004  11:14 AM ]
 ;;04.1;TABLE MAINTENANCE;**3**;OCT 13,2003
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
 Q $P($P($T(@L^AUM4103A),";",3),":",1)
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
RSLT(%) ; EP- INCREMENTS/UPDATES ^TMP("AUM4103,$J) called here and AUM4103
 ; global used to generate the email message sent by
 ; post-install routine
 S ^(0)=$G(^TMP("AUM4103",$J,0))+1,^(^(0))=% D MES(%)
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
CLINNEW ;EP --- ADD NEW CLINIC
 D RSLT($$E("CLINNEW"))
 D RSLT($J("",11)_"CODE NAME"_$J("",28)_"ABRV.  PRI.CARE  1A WL RPT")
 D RSLT($J("",11)_"---- ----"_$J("",28)_"-----  --------  ---------")
 F T=1:1 S L=$T(CLINNEW+T^AUM4103A) Q:$P(L,";",3)="END"  D ADDCLIN
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
CLINMOD ;EP
 S E="Clinic Name Changes"
 F T=1:2 S L=$T(CLINMOD+T^AUM4103A) Q:$P(L,";",3)="END"  D
 .S L("TO")=$T(CLINMOD+T+1^AUM4103A)
 .S L=$P(L("TO"),"^",2,99),C=$P(L,"^",1),N=$P(L,"^",2)
 .S DA=$O(^DIC(40.7,"C",C,0))
 .I 'DA S L=";;"_L D ADDCLIN Q
 .S DIE="^DIC(40.7,",DR=".01///"_N D ^DIE
 .I $D(Y) D RSLT(E_" : CHANGE FAILED => "_L) Q
 .D MODOK
 Q
 ;
TRIBEMOD ;EP --- MOD TRIBE
 ;      C=CODE, O=OLD, N=NAME, P=IEN
 N @$P($T(SVARS),";",3)
 D RSLT($$E("TRIBEMOD"))
 D RSLT($$RJ^XLFSTR("CODE OLD NAME",28))
 D RSLT($$RJ^XLFSTR("---- --- ----",28))
 F T=1:2 S L=$T(TRIBEMOD+T^AUM4103A) Q:$P(L,";",3)="END"  S L("TO")=$T(TRIBEMOD+T+1^AUM4103A) D
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
EXAMNEW ;EP --- NEW EXAM
 N @$P($T(SVARS),";",3)
 D RSLT($$E("EXAMNEW"))
 D RSLT($J("",13)_"NAME")
 D RSLT($J("",13)_"----")
 F T=1:1 S L=$T(EXAMNEW+T^AUM4103A) Q:$P(L,";",3)="END"  D ADDEXAM
 Q
ADDEXAM ;  
 S L=$P(L,";;",2),N=$P(L,U),C=$P(L,U,2),L=N
 I $D(^AUTTEXAM("C",C)) D RSLT($J("",5)_$$M(1)_"EXAM CODE EXISTS => "_C_" "_N) Q
 S DLAYGO=9999999.15,DIC="^AUTTEXAM(",X=N
 S DIC("DR")=".02///"_C
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 K DLAYGO
 Q
 ;
EXAMMOD ;EP modify exam file
 S E="Exam Name Changes"
 F T=1:2 S L=$T(EXAMMOD+T^AUM4103A) Q:$P(L,";",3)="END"  D
 .S L("TO")=$T(EXAMMOD+T+1^AUM4103A)
 .S L=$P(L("TO"),"^",2,99),N=$P(L,"^"),C=$P(L,"^",2)
 .S DA=$O(^AUTTEXAM("C",C,0))
 .I 'DA S L=";;"_L D ADDEXAM Q
 .S L=C_" "_N
 .S DIE="^AUTTEXAM(",DR=".01///"_N D DIE
 .I $D(Y) D RSLT(E(0)_E_" : CHANGE FAILED => "_L) Q
 .D MODOK
 Q
EDUCNEW ;EP --- NEW PATIENT ED- P&F
 D RSLT($$E("EDUCNEW"))
 D RSLT($J("",13)_"NAME")
 D RSLT($J("",13)_"----")
 F T=1:1 S L=$T(EDUCNEW+T^AUM4103A) Q:$P(L,";",3)="END"  D ADDEDUC
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
HFNEW ;EP --- NEW HEALTH FACTORS
 D RSLT($$E("HFNEW"))
 D RSLT($J("",13)_"NAME")
 D RSLT($J("",13)_"----")
 F T=1:1 S L=$T(HFNEW+T^AUM4103A) Q:$P(L,";",3)="END"  D ADDHF
 Q
ADDHF ;
 S L=$P(L,";;",2),N=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),S=$P(L,U,4),L=N_" "_O_"  "_C_"  "_S
 I $D(^AUTTHF("B",N)) D RSLT($J("",5)_$$M(1)_"HEALTH FACTOR EXISTS => "_N),RSLT("") Q
 S DLAYGO=9999999.64,DIC="^AUTTHF(",X=N,DIC("DR")=".03///"_O_";.1///"_C_";.14///"_S
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
PCLASNEW ;EP --- NEW PROV CLASS
 S E=$$E("PCLASNEW")
 D RSLT(E)
 D RSLT($J("",11)_"CODE NAME"_$J("",28)_"ABRV.")
 D RSLT($J("",11)_"---- ----"_$J("",28)_"-----")
 F T=1:1 S L=$T(PCLASNEW+T^AUM4103A) Q:$P(L,";",3)="END"  D ADDPCLAS
 Q
ADDPCLAS ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),F=$P(L,"^",4),W=$P(L,"^",5)
 S L=C_" "_N_$J("",(32-$L(N)))_A
 I $D(^DIC(7,"D",C)) D RSLT($J("",5)_$$M(1)_"PROVIDER CODE EXISTS => "_C),RSLT("") Q
 S DLAYGO=7,DIC="^DIC(7,",X=N
 S DIC("DR")="1///"_A_";9999999.01///"_C_";9999999.03///"_F_";9999999.05///"_W
 D FILE
 D @$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
PCLASMOD ;EP
 D RSLT($$E("PCLASMOD"))
 F T=1:2 S L=$T(PCLASMOD+T^AUM4103A) Q:$P(L,";",3)="END"  S L("TO")=$T(PCLASMOD+T+1^AUM4103A) D
 .S L=$P(L,"^",2,99),C=$P(L,"^",1),N=$P(L,"^",2),A=$P(L,"^",3),F=$P(L,"^",4),W=$P(L,"^",5)
 .S P=$O(^DIC(7,"D",C,0))
 .I 'P  S L=L("TO") D ADDPCLAS Q
 .S L=$P(L("TO"),"^",2,99),C=$P(L,"^",1),N=$P(L,"^",2),A=$P(L,"^",3),F=$P(L,"^",4),W=$P(L,"^",5)
 .S L=C_" "_N_" "_A
 .S DIE="^DIC(7,",DA=P
 .S DR=".01///"_N_";1///"_A_";9999999.01///"_C_";9999999.03///"_F_";9999999.05///"_W
 .D ^DIE
 .I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT PROVIDER CODE FAILED => "_L) Q
 .D MODOK
 Q
 ;
MEASNEW ;EP
 S E="New Measurement Type"
 F T=1:1 S L=$T(MEASNEW+T^AUM4103A) Q:$P(L,";",3)="END"  D
 .D ADDMEAS
 Q
ADDMEAS ;
 S L=$P(L,";;",2),N=$P(L,"^"),S=$P(L,"^",2),C=$P(L,"^",3),L=N_" "_S_"  "_C
 I $D(^AUTTMSR("C",C)) D RSLT(E_" : MEASUREMENT TYPE CODE EXISTS => "_C) Q
 S DLAYGO=9999999.07,DIC="^AUTTMSR(",X=N,DIC("DR")=".02///"_S_";.03///"_C D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V,W;Single-character work variables
 Q
