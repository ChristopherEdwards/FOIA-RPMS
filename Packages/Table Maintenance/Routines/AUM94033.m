AUM94033 ; DSD/GTH - STANDARD TABLE UPDATES (3), 31MAR94 BANYAN ; [ 04/07/94  5:39 PM ]
 ;;94.1;TABLE MAINTENANCE;**3**;DECEMBER 15, 1993
 ;
 Q
 ;
START ;EP
 ;
 NEW A,C,DIC,DIE,DLAYGO,DR,E,L,N,O,P,R,S,T
 S E(0)="ERROR : ",E(1)="NOT ADDED : "
 D EDTNEW,EDTMOD,TRETNEW,MEASNEW
 Q
 ; ===   utility sub-routines   ====
 ;
ADDOK D RSLT(E_", Added : "_L) Q
ADDFAIL D RSLT(E(0)_E_" : ADD FAILED => "_L) Q
DIE NEW A,C,E,L,N,O,P,R,S,T
 LOCK +(@(DIE_DA_")")):10 E  D RSLT(E(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) K DA,DIE,DR Q
DIK NEW A,C,E,L,N,O,P,R,S,T D ^DIK K DIK Q
FILE NEW A,C,E,L,N,O,P,R,S,T K DD,DO S DIC(0)="L" D FILE^DICN K DIC Q
MODOK D RSLT(E_", Changed : "_L) Q
RSLT(%) S ^(0)=$G(^TMP($J,"RSLT",0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,% Q
 ;
 ; =================================
 ;
EDTDD ;;K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>6!($L(X)<1)!'(X?1.4UN1"-"1.4UN) X
EDTNEW ;
 S $P(^DD(9999999.09,1,0),U,5,99)=$P($T(EDTDD),";;",2)
 D RSLT("EDUCATION TOPIC, field 1, Input Transform modified.")
 S E="New Education Topics"
 F T=1:1 S L=$T(EDTNEW+T^AUM9403B) Q:$P(L,";",3)="END"  I $P(L,U,$L(L,U))="Y" D ADDEDT
 Q
 ;
ADDEDT ;
 S L=$P(L,";;",2),N=$P(L,U),O=$P(L,U,2),L=N_" "_O
 I $D(^AUTTEDT("B",N)) D RSLT(E(1)_E_" : EDUCATION TOPIC EXISTS => "_N) Q
 S DLAYGO=9999999.09,DIC="^AUTTEDT(",X=N,DIC("DR")="1///"_O D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
EDTMOD ;
 S E="Education Topics Changes"
 F T=1:2 S L=$T(EDTMOD+T^AUM9403B) Q:$P(L,";",3)="END"  S L("TO")=$T(EDTMOD+T+1^AUM9403B) I $P(L("TO"),U,$L(L("TO"),U))="Y" D
 .S L=$P(L,U,2,99),N=$P(L,U),O=$P(L,U,2)
 .S P=$O(^AUTTEDT("B",N,0))
 .S L=$P(L("TO"),U,2,99),N=$P(L,U),O=$P(L,U,2)
 .I 'P S P=$O(^AUTTEDT("B",N,0)) I 'P S L=";;"_L D ADDEDT Q
 .S L=N_" "_O
 .S DIE="^AUTTEDT(",DA=P,DR=".01///"_N_";1///"_O D DIE
 .I $D(Y) D RSLT(E(0)_E_" : CHANGE FAILED => "_L) Q
 .D MODOK
 .Q
 Q
 ;
TRTDD ;;K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>6!($L(X)<6)!'(X?6NU) X I $D(X),$D(^AUTTTRT("C",X)),'$D(^AUTTTRT("C",X,DA)) K X W:'$D(ZTQUEUED) "    Already used! "
TRETNEW ;
 S $P(^DD(9999999.17,.02,0),U,5,99)=$P($T(TRTDD),";;",2)
 D RSLT("TREATMENT, field .02, Input Transform modified.")
 S E="New Treatments"
 F T=1:1 S L=$T(TRETNEW+T^AUM9403C) Q:$P(L,";",3)="END"  I $P(L,U,$L(L,U))="Y" D ADDTRET
 Q
 ;
ADDTRET ;
 S L=$P(L,";;",2),N=$P(L,U),C=$P(L,U,2),S=$P(L,U,3),O=$P(L,U,4),L=N_" "_C_"  "_S_"  "_O
 I $D(^AUTTTRT("B",N)) D RSLT(E(1)_E_" : TREATMENT EXISTS => "_N) Q
 S DLAYGO=9999999.17,DIC="^AUTTTRT(",X=N,DIC("DR")=".02///"_C_";.03///"_S_";8801///"_O D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
MEASNEW ;
 S E="New Measurement Type"
 F T=1:1 S L=$T(MEASNEW+T^AUM9403C) Q:$P(L,";",3)="END"  I $P(L,U,$L(L,U))="Y" D ADDMEAS
 Q
 ;
ADDMEAS ;
 S L=$P(L,";;",2),N=$P(L,U),S=$P(L,U,2),C=$P(L,U,3),L=N_" "_S_"  "_C_"  "_O
 I $D(^AUTTMSR("C",C)) D RSLT(E(1)_E_" : MEASUREMENT TYPE CODE EXISTS => "_C) Q
 S DLAYGO=9999999.07,DIC="^AUTTMSR(",X=N,DIC("DR")=".02///"_S_";.03///"_C D FILE
 D ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
