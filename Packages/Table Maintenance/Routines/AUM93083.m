AUM93083 ; DSD/GTH - STANDARD TABLE UPDATES (3), EXAM & HEALTH FACTORS ; [ 09/23/93  11:59 AM ]
 ;;93.1;TABLE MAINTENANCE;**6**;MARCH 23, 1993
 ;
 Q
 ;
START ;EP
 ;
 NEW A,C,DIC,DIE,DLAYGO,DR,E,L,N,O,P,R,S,T
 S E(0)="ERROR : ",E(1)="NOT ADDED : "
 D EXAMNEW,EXAMMOD,HFNEW
 Q
 ; ===   utility sub-routines   ====
 ;
ADDOK D RSLT(E_", Added : "_L) Q
ADDFAIL D RSLT(E(0)_E_" : ADD FAILED => "_L) Q
DIE NEW A,C,E,L,N,O,P,R,S,T
 LOCK +(@(DIE_DA_")")):10 E  D RSLT(E(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) K DA,DIE,DR Q
FILE NEW A,C,E,L,N,O,P,R,S,T K DD,DO S DIC(0)="L" D FILE^DICN K DIC Q
MODOK D RSLT(E_", Changed : "_L) Q
RSLT(%) S ^(0)=$G(^TMP($J,"RSLT",0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,% Q
 ;
 ; =================================
 ;
EXAMNEW ;
 S E="New Exam Codes"
 F T=1:1 S L=$T(EXAMNEW+T^AUM9308B) Q:$P(L,";",3)="END"  I $P(L,U,$L(L,U))="Y" D ADDEXAM
 Q
 ;
ADDEXAM ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),L=C_" "_N
 I $D(^AUTTEXAM("C",C)) D RSLT(E(1)_E_" : EXAM CODE EXISTS => "_C) Q
 S DLAYGO=9999999.15,DIC="^AUTTEXAM(",X=N,DIC("DR")=".02///"_C D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
EXAMMOD ;
 S E="Exam Name Changes"
 F T=1:2 S L=$T(EXAMMOD+T^AUM9308B) Q:$P(L,";",3)="END"  S L("TO")=$T(EXAMMOD+T+1^AUM9308B) I $P(L("TO"),U,$L(L("TO"),U))="Y" D
 .S L=$P(L,U,2,99),C=$P(L,U),N=$P(L,U,2)
 .S DA=$O(^AUTTEXAM("C",C,0))
 .S L=$P(L("TO"),U,2,99),C=$P(L,U),N=$P(L,U,2)
 .I 'DA S L=";;"_L D ADDEXAM Q
 .S L=C_" "_N
 .S DIE="^AUTTEXAM(",DR=".01///"_N D DIE
 .I $D(Y) D RSLT(E(0)_E_" : CHANGE FAILED => "_L) Q
 .D MODOK
 .Q
 Q
 ;
HFNEW ;
 S E="New Health Factor Entries"
 F T=1:1 S L=$T(HFNEW+T^AUM9308B) Q:$P(L,";",3)="END"  I $P(L,U,$L(L,U))="Y" D ADDHF
 Q
 ;
ADDHF ;
 S L=$P(L,";;",2),N=$P(L,U),C=$P(L,U,2),S=$P(L,U,3),L=N_" "_C_"  "_S
 I $D(^AUTTHF("B",N)) D RSLT(E(1)_E_" : HEALTH FACTOR EXISTS => "_N) Q
 S DLAYGO=9999999.64,DIC="^AUTTHF(",X=N,DIC("DR")=".03///"_C_";.1///"_S D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
