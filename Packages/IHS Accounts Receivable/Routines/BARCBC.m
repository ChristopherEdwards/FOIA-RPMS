BARCBC ; IHS/SD/LSL - CALCULATE COLLECTION BATCH FIELDS ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3**;OCT 26, 2005
 ;
 ; ITSC/SD/LSL - 05/16/02 - V1.6 Patch 2 - NOIS CXX-0501-110068
 ;      Modified to accomodate new field (23) in A/R Collection Batch
 ;
 ; ITSC/SD/LSL - 01/02/03 - V1.7 - BXX-0103-150002
 ;      Modified L2 to not include cancelled items in batch total
 ;
 ; IHS/SD/LSL - 02/25/04 - V1.7 Patch 5 - IM12590
 ;      Modified L2 to not include rolled up items in batch total
 ;
 ; *********************************************************************
 ;
B15(X) ;EP - batch total field #15
 D L2
 Q BARTOT(3)
 ; *********************************************************************
 ;
BTAL(X) ;batch total for all transaction types
 ;x=batch
 S BARTOT1=0
 N I
 S I=0
 F  S I=$O(^BARTR(DUZ(2),"ACB",X,I)) Q:'I  D
 .N J
 .S J=0
 .F  S J=$O(^BARTR(DUZ(2),"ACB",X,I,J)) Q:'J  D
 ..S BARTOT1=BARTOT1+$$BTT(X,J)
 Q BARTOT1
 ; *********************************************************************
 ;
BTT(X,Z) ;EP - batch total for given transaction type
 ;x=batch
 ;z=transaction type internal or external value
 S BARTT1=Z
 S:'BARTT1 BARTT1=$O(^BARTBL("B",BARTT1,0))
 I 'BARTT1 K BARTT1 Q 0
 S BARTOT2=0
 N I
 S I=0
 F  S I=$O(^BARTR(DUZ(2),"ACB",X,I)) Q:'I  D
 .S BARTOT2=BARTOT2+$$ITT(X,I,BARTT1)
 K BARTT1
 Q BARTOT2
 ; *********************************************************************
 ;IHS/SD/TPF BAR*1.8*3 UFMS SCR2
BTTREIM(COLIEN) ;EP - RETURN BATCH TOTAL FOR ALL REIMBURSEMENT TYPES
 N BARTOTAL,BARTRANT
 S BARTABT=23  ;THIS SHOULD EQUAL THE A/R TABLE TYPE ENTRY FOR 'UNBILLED REIMBURSEMENTS'
 S BARTOTAL=0
 S BARTRANT=""
 F  S BARTRANT=$O(^BARTBL("D",BARTABT,BARTRANT)) Q:'BARTRANT  D
 .S BARTOTAL=BARTOTAL+$$BTT(COLIEN,BARTRANT)
 Q BARTOTAL
 ;
ITTREIM(COLIEN,ITEMIEN) ;EP - RETURN ITEM TOTAL FOR ALL REIMBURSEMENT TYPES
 N BARTOTAL,BARTRANT
 S BARTABT=23  ;THIS SHOULD EQUAL THE A/R TABLE TYPE ENTRY FOR 'UNBILLED REIMBURSEMENTS'
 S BARTOTAL=0
 S BARTRANT=""
 F  S BARTRANT=$O(^BARTBL("D",BARTABT,BARTRANT)) Q:'BARTRANT  D
 .S BARTOTAL=BARTOTAL+$$ITT(COLIEN,ITEMIEN,BARTRANT)
 Q BARTOTAL
 ;
ITT(X,Y,Z) ;EP - item total for given transaction type
 ;x=batch
 ;y=item
 ;z=transaction type
 S BARTT=Z
 S:'BARTT BARTT=$O(^BARTBL("B",BARTT,0))
 I 'BARTT K BARTT Q 0
 D IL1
 K BARTT
 Q BARTOT
 ; *********************************************************************
 ;
STT(X,Y,Z,V)       ;EP - sub EOB total for given transaction type
 ;x=batch
 ;y=item
 ;z=transaction type
 ;v=visit location
 S BARTT=Z
 S:'BARTT BARTT=$O(^BARTBL("B",BARTT,0))
 I 'BARTT K BARTT Q 0
 S BARVL=V
 I 'BARVL K BARTT,BARVL Q 0
 D IL1
 K BARVL,BARTT
 Q BARTOT
 ; *********************************************************************
 ;
IL1 ;for given item, loop thru transactions
 S BARTOT=0
 N J
 S J=0
 F  S J=$O(^BARTR(DUZ(2),"ACB",X,Y,BARTT,J)) Q:'J  D
 .I $G(BARVL),$P(^BARTR(DUZ(2),J,0),"^",11)'=BARVL Q
 . ;IF CALLED FROM FIELD 23, TRAN TYPE = UN-ALLOCATED AND GL STATUS=RESOLVED
 . I +$G(BAR23),BARTT=100,$P($G(^BARTR(DUZ(2),J,1)),U,5)="R" Q
 .S BARTOT=BARTOT+$P(^BARTR(DUZ(2),J,0),"^",2)
 .S BARTOT=BARTOT-$P(^BARTR(DUZ(2),J,0),"^",3)
 Q
 ; *********************************************************************
 ;
ITAL(X,Y) ;item total all transaction types
 ;x=batch
 ;y=item
 S BARTOT3=0
 N I
 S I=0
 F  S I=$O(^BARTR(DUZ(2),"ACB",X,Y,I)) Q:'I  D
 .S BARTOT3=BARTOT3+$$ITT(X,Y,I)
 Q BARTOT3
 ; *********************************************************************
 ;
L2 ;loop thru items in a batch
 N I
 F I=1:1:3 S BARTOT(I)=0
 S I=0
 F  S I=$O(^BARCOL(DUZ(2),D0,1,I)) Q:'I  D
 .Q:$P($G(^BARCOL(DUZ(2),D0,1,I,0)),U,17)="C"
 . Q:$P($G(^BARCOL(DUZ(2),D0,1,I,0)),U,17)="R"    ; Quit if rolled up
 .S BAR1=$G(^BARCOL(DUZ(2),D0,1,I,1))
 .S BARTOT(1)=BARTOT(1)+$P(BAR1,"^",1)
 .S BARTOT(2)=BARTOT(2)+$P(BAR1,"^",2)
 S BARTOT(3)=BARTOT(1)-BARTOT(2)
 Q
 ; *********************************************************************
 ;
SET(X,Y)         ;EP - sub eob total, field #202
 ;x=batch
 ;y=item
 S BARST=0
 N I
 S I=0
 F  S I=$O(^BARCOL(DUZ(2),X,1,Y,6,I)) Q:'I  D
 .S BARST=BARST+$P(^BARCOL(DUZ(2),X,1,Y,6,I,0),"^",2)
 Q BARST
