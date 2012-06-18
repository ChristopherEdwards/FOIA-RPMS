BARPT173 ; IHS/SD/LSL - Post init for V1.7 Patch 3 ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 Q
 ; *********************************************************************
 ;
EN ; EP - Driver
 D PRVPATCH                 ; Check to see if previous patches installed
 D PATCH3                   ; Post init for V1.7 Patch 3
 D MAILPAT                  ; Send Patch install MailMan message
 H 5
 D MAILDUP                  ; Send dup bill message to manager
 Q
 ; *********************************************************************
 ;
PRVPATCH ;
 ; Check previous patch post inits
 N BARP1,BARP2
 S BARP2=$$INSTALLD^BAREV17("BAR*1.7*2")
 S BARP1=$$INSTALLD^BAREV17("BAR*1.7*1")
 I BARP2 Q                  ; All previous patches installed
 I BARP1 D PATCH2 Q         ; Only missing patch 2
 D PATCH1,PATCH2                   ; Perform Patch 1 AND 2 post inits.
 Q
 ; ********************************************************************
PATCH1 ;
 ; Patch 1 post init
 ; Delete A/R Period Summary Data File data
 W !!,"You are missing A/R V1.7 Patch 1...performing POST INITS of that patch"
 S DIK="^BARPSR("
 S DA=0
 F  S DA=$O(^BARPSR(DA)) Q:'+DA  D ^DIK
 K DA,DIK
 ;
 ; Delete the A/R Period Summary Data File Data Dictionary
 S DIU="^BARPSR("
 S DIU(0)="DT"
 D EN^DIU2
 K DIU
 W !!,"A/R V1.7 Patch 1 POST INIT complete"
 Q
 ; *********************************************************************
 ;
PATCH2 ;
 ; Patch 2 post init
 W !!,"You are missing A/R V1.7 Patch 2...performing POST INITS of that patch"
 S BARDUZ=DUZ(2)
 D CURBAL
 D PATACC
 D EISS
 S DUZ(2)=BARDUZ
 W !!,"A/R V1.7 Patch 2 POST INIT complete"
 Q
 ; ********************************************************************
 ;
CURBAL ;
 ; Rebuild ABAL and APBAL x-refs on field 15 of file 90050.01
 W !!,"Rebuilding ABAL and APBAL x-refs on Current Balance of A/R Bill File..."
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'+DUZ(2)  D
 . F BARX="ABAL","APBAL" D
 .  . K ^BARBL(DUZ(2),BARX)
 .  . S DIK="^BARBL(DUZ(2),"
 .  . S DIK(1)="15^"_BARX
 . D ENALL^DIK
 W "DONE."
 Q
 ; ********************************************************************
 ;
PATACC ;
 ; Create PAS x-ref on field 101 of file 90050.02
 W !!,"Creating PAS x-ref on Pat Acct Stmt of A/R Account File..."
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARAC(DUZ(2))) Q:'+DUZ(2)  D
 . K ^BARAC(DUZ(2),"PAS")
 . S DIK="^BARAC(DUZ(2),"
 . S DIK(1)="101^PAS"
 . D ENALL^DIK
 W "DONE."
 Q
 ; ********************************************************************
 ;
EISS ;
 ; Populate EISS fields in file 90052.06
 W !!,"Populating EISS System Address, Username, and Password fields"
 W !,"in A/R Site Parameter File..."
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BAR(90052.06,DUZ(2))) Q:'+DUZ(2)  D
 . S DIE="^BAR(90052.06,DUZ(2),"
 . S DA=0
 . F  S DA=$O(^BAR(90052.06,DUZ(2),DA)) Q:'+DA  D
 . . K DR
 . . S DR="201///127.0.0.1"
 . . S DR=DR_";202///bardata"
 . . S DR=DR_";203///1bardat/"
 . . D ^DIE
 K DA,DIE,DR
 W "DONE."
 Q
 ; ********************************************************************
 ;
PATCH3 ;
 ; Post init for V1.7 Patch 3
 W !!,"Now performing A/R V1.7 Patch 3 post inits..."
 D FINDUP
 Q
 ; ********************************************************************
 ;
FINDUP ;
 ; Find possible AR Bill Multiples (duplicates)
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
 ; ********************************************************************
 ;
MAILPAT ;
 ; Send a mail message to all holders of the BARZMENU key that a patch
 ; has been installed on the system.
 ;
 W !!,"Sending MailMan message to users..."
 D MAILSET
 D MAILTXT
 D MAILMSG
 W "   DONE"
 Q
 ; *********************************************************************
 ;
MAILSET ;   
 ; Set Mailman Variables
 K XMY
 S XMSUB="Accounts Receivable V1.7 Patch 3"
 S XMDUZ="Accounts Receivable Software Engineer"
 D MAILIST        ; Get list of recipients
 Q
 ; *********************************************************************
 ;
MAILIST ;
 ; Find users who hold the BARZMENU key
 ;S XMY("STAR,GLEN R")=""
 S J=0
 F  S J=$O(^XUSEC("BARZMENU",J)) Q:'J  D
 . S BARNAME=$P($G(^VA(200,J,0)),U)
 . S XMY(BARNAME)=""
 Q
 ; *********************************************************************
 ;
MAILTXT ;
 ; Determine body of e-mail
 S K=0
 F  D  Q:BARTXT="END"
 . S K=K+1
 . S BARTXT=$P($T(@1+K),";;",2)
 . I BARTXT="END" Q
 . S BARMSG(K)=BARTXT
 Q
 ; *********************************************************************
 ;
MAILMSG ;
 S XMTEXT="BARMSG("
 S %H=$H
 D YX^%DTC
 N DIFROM
 D ^XMD
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
 S XMSUB="Possible AR Bill Duplicates"
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
 . . . S BARIENO="'"_BARIEN
 . . . F I=$L(BARIENO):1:10 S BARIENO=BARIENO_" "
 . . . S BARPIEN=$P($G(^BARBL(BARPAR,BARIEN,1)),U)
 . . . S:BARPIEN]"" BARPAT=$E($$GET1^DIQ(9000001,BARPIEN,.01),1,20)
 . . . S:BARPIEN="" BARPAT=""
 . . . F I=$L(BARPAT):1:25 S BARPAT=BARPAT_" "
 . . . S BARBAMT=$P($G(^BARBL(BARPAR,BARIEN,0)),U,13)
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
1 ;;
 ;;Accounts Receivable V1.7 Patch 3 has been installed on your
 ;;computer.  You have received this message because you hold the BARZMENU
 ;;key that allows access to the Accounts Receivable Master Menu.
 ;; 
 ;;Accounts Receivable V1.7 Patch 3 is inclusive of patches 1 and 2.  It
 ;;also contains a fix stopping duplicate bill creation in AR when the
 ;;bill is printed or reprinted in 3P.
 ;;
 ;;END
 ;
2 ;;
 ;;As a part of the installation of Accounts Receivable V1.7 Patch 3, the system
 ;;looked for possible duplicates on your system.  You have received this
 ;;message because you hold the BARZ MANAGER key that allows access to the
 ;;Accounts Receivable Manager options.  The following is a list of possible
 ;;duplicates that were found.  Please review these bills and write off the
 ;;first occurrence of the bill if you find it is truly a duplicate.
 ;;
 ;;  IEN       Bill                       Patient                  Billed Amount
 ;; 
 ;;END
