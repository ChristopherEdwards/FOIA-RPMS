BARDUPBL ; IHS/SD/RLT - Duplicate Bill report modified from BARPT173;  [ 05/25/05 ]
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1**;MAR 27,2007
 Q
 ; *********************************************************************
 ;
EN ; EP - Driver
 D FINDUP                   ; Look for duplicate bills
 D MAILDUP                  ; Send dup bill message to manager
 Q
 ; ********************************************************************
 ;
FINDUP ;
 ; Find possible AR Bill Multiples (duplicates)
 W !!,"Looking for possible duplicate bills..."
 K ^BARTMP("DUP")
 S BARDUZ=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'+DUZ(2)  D
 . S BARBL=""
 . F  S BARBL=$O(^BARBL(DUZ(2),"B",BARBL)) Q:BARBL=""  D
 . . S (BARIEN,BARCNT)=0
 . . F  S BARIEN=$O(^BARBL(DUZ(2),"B",BARBL,BARIEN)) Q:'+BARIEN  D
 . . . S BARCNT=BARCNT+1
 . . I BARCNT>1 S ^BARTMP("DUP",DUZ(2),BARBL)=BARCNT
 S DUZ(2)=BARDUZ
 Q
 ; *********************************************************************
 ;
MAILDUP ;
 ; Send a mail message to all holders of the BARZMGR key listing
 ; possible duplicates on their system
 ;
 W !!,"Sending MailMan message to AR Managers..."
 D MAILSETM
 D MAILTXTM
 D MAILMSGM
 W "   DONE"
 Q
 ; *********************************************************************
 ;
MAILSETM ;   
 ; Set Mailman Variables
 K XMY
 S XMSUB="Possible Duplicate A/R Bills"
 S XMDUZ="Accounts Receivable Software Engineer"
 D MAILISTM        ; Get list of recipients
 Q
 ; *********************************************************************
 ;
MAILISTM ;
 ; Find users who hold the BARZ MANAGER key
 ;S XMY("STAR,GLEN R")=""
 S J=0
 F  S J=$O(^XUSEC("BARZ MANAGER",J)) Q:'+J  D
 . S BARNAME=$P($G(^VA(200,J,0)),U)
 . S XMY(BARNAME)=""
 Q
 ; *********************************************************************
 ;
MAILTXTM ;
 ; Determine body of e-mail
 K ^BARTMP("173MSG")
 S K=0
 F  D  Q:BARTXT="END"
 . S K=K+1
 . S BARTXT=$P($T(@2+K),";;",2)
 . I BARTXT="END" Q
 . S ^BARTMP("173MSG",K)=BARTXT
 ;
 ; Now get the duplicated bills
 ;
 I '$D(^BARTMP("DUP")) D  Q
 . S ^BARTMP("173MSG",K+1)="*****   NO DUPLICATE BILLS FOUND  ****"
 ;
 S $P(BARDASH,"-",51)=""
 S $P(BAREQUAL,"=",51)=""
 S BARCNT=0
 S BARTOT=0
 S BARPAR=0
 F  S BARPAR=$O(^BARTMP("DUP",BARPAR)) Q:'+BARPAR  D
 . S (BARFCNT,BARFBT)=0
 . S K=K+1
 . S ^BARTMP("173MSG",K)="Parent Facility:  "_$$GET1^DIQ(4,BARPAR,.01)
 . S K=K+1
 . S ^BARTMP("173MSG",K)=" "
 . S BARBL=""
 . F  S BARBL=$O(^BARTMP("DUP",BARPAR,BARBL)) Q:BARBL=""  D
 . . S BARFCNT=BARFCNT+1
 . . S BARCNT=BARCNT+1
 . . S BARBIL=$E(BARBL,1,20)
 . . F I=$L(BARBIL):1:25 S BARBIL=BARBIL_" "
 . . S BARIEN=0
 . . F  S BARIEN=$O(^BARBL(BARPAR,"B",BARBL,BARIEN)) Q:'+BARIEN  D
 . . . Q:'$D(^BARBL(BARPAR,BARIEN))
 . . . S BARIENO="'"_BARIEN
 . . . F I=$L(BARIENO):1:10 S BARIENO=BARIENO_" "
 . . . S BARPIEN=$P($G(^BARBL(BARPAR,BARIEN,1)),U)
 . . . S:BARPIEN]"" BARPAT=$E($$GET1^DIQ(9000001,BARPIEN,.01),1,20)
 . . . S:BARPIEN="" BARPAT=""
 . . . F I=$L(BARPAT):1:25 S BARPAT=BARPAT_" "
 . . . ;S BARBAMT=$P($G(^BARBL(BARPAR,BARIEN,0)),U,13)   ;don't use bill amt
 . . . S BARBAMT=$P($G(^BARBL(BARPAR,BARIEN,0)),U,15)    ;use current amt
 . . . S BARBAMTO=$J($FN(BARBAMT,",",2),15)
 . . . S K=K+1
 . . . S ^BARTMP("173MSG",K)=BARIENO_BARBIL_BARPAT_BARBAMTO
 . . S BARFBT=BARBAMT+BARFBT                     ; Facility bill total
 . . S BARTOT=BARBAMT+BARTOT
 . S K=K+1
 . S ^BARTMP("173MSG",K)=$J(BARDASH,79)
 . S K=K+1
 . S ^BARTMP("173MSG",K)=$J("Unique bill count: ",58)_$J(BARFCNT,4)_$J($FN(BARFBT,",",2),16)
 . S K=K+1
 . S ^BARTMP("173MSG",K)=" "
 S ^BARTMP("173MSG",K)=$J(BAREQUAL,79)
 S K=K+1
 S ^BARTMP("173MSG",K)=$J("Total unique bill count: ",58)_$J(BARCNT,4)_$J($FN(BARTOT,",",2),16)
 Q
 ; *********************************************************************
 ;
MAILMSGM ;
 S XMTEXT="^BARTMP(""173MSG"","
 S %H=$H
 D YX^%DTC
 N DIFROM
 D ^XMD
 Q
 ; *********************************************************************
 ;
2 ;;
 ;;The following is a list of possible duplicate A/R Bills found on your
 ;;system.
 ;;
 ;;  IEN       Bill                       Patient                 Current Amount
 ;; 
 ;;END
