AUM61022 ; IHS/ADC/GTH - STANDARD TABLE UPDATES (2), FIELD REQUESTS ; [ 12/11/95  3:59 PM ]
 ;;96.1;TABLE MAINTENANCE;**2**;OCT 26,1995
 ;
 Q
 ;
START ;EP
 ;
 NEW A,C,DIC,DIE,DLAYGO,DR,E,L,N,O,P,R,S,T
 S E(0)="ERROR : ",E(1)="NOT ADDED : "
 D HFADD,DASH,EDTADD,DASH
 Q
 ;
 ; ===   utility sub-routines   ====
 ;
ADDOK D RSLT($J("",5)_"Added : "_L) Q
ADDFAIL D RSLT($J("",5)_E(0)_"ADD FAILED => "_L) Q
DASH D RSLT(""),RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70))),RSLT("") Q
DIE NEW A,C,E,L,N,O,P,R,S,T
 LOCK +(@(DIE_DA_")")):10 E  D RSLT($J("",5)_E(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) K DA,DIE,DR Q
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
 ;
 ; =================================
 ;
HFADD ;
 D RSLT("New Health Factor Entries")
 F T=1:1 S L=$T(HFADD+T^AUM6102B) Q:$P(L,";",3)="END"  D ADDHF
 Q
 ;
ADDHF ;
 S L=$P(L,";;",2),N=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),R=$P(L,U,4),S=$P(L,U,5),L=N_" "_O_"  "_C_"  "_R_"  "_S
 I $D(^AUTTHF("B",N)) D RSLT($J("",5)_E(1)_"HEALTH FACTOR EXISTS => "_N) Q
 S DLAYGO=9999999.64,DIC="^AUTTHF(",X=N,DIC("DR")=".02///"_O_";.03///"_C_";.08///"_R_";.1///"_S
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
 ; =================================
 ;
EDTADD ;
 D RSLT("New Education Topics")
 F T=1:1 S L=$T(EDTADD+T^AUM6102B) Q:$P(L,";",3)="END"  D ADDEDT
 Q
 ;
ADDEDT ;
 S L=$P(L,";;",2),N=$P(L,U),O=$P(L,U,2),L=N_" "_O
 I $D(^AUTTEDT("B",N)) D RSLT($J("",5)_E(1)_"EDUCATION TOPIC EXISTS => "_N) Q
 S DLAYGO=9999999.09,DIC="^AUTTEDT(",X=N,DIC("DR")="1///"_O
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
