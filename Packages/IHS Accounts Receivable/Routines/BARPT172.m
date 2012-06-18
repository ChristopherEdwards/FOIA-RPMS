BARPT172 ; IHS/SD/LSL - Post init for V1.7 Patch 2 ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 Q
 ; *********************************************************************
 ;
EN ; EP - Driver
 D PRVPATCH                 ; Check to see if previous patches installed
 D PATCH2                   ; Post init for V1.7 Patch 2
 D MAIL                     ; Send MailMan message
 Q
 ; *********************************************************************
 ;
PRVPATCH ;
 ; Check previous patch post inits
 N BARP1
 S BARP1=$$INSTALLD^BAREV17("BAR*1.7*1")
 I BARP1 Q                  ; All previous patches installed
 D PATCH1                   ; Perform Patch 1 post inits.
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
 W !!,"Now performing A/R V1.7 Patch 2 post inits..."
 S BARDUZ=DUZ(2)
 D CURBAL
 D PATACC
 D EISS
 S DUZ(2)=BARDUZ
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
MAIL ;
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
 S XMSUB="Accounts Receivable V1.7 Patch 2"
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
 S K=0
 F  D  Q:BARTXT="END"
 . S K=K+1
 . S BARTXT=$P($T(@1+K),";;",2)
 . I BARTXT="END" Q
 . S BARMSG(K,0)=BARTXT
 S XMTEXT="BARMSG("
 S %H=$H
 D YX^%DTC
 Q
 ; *********************************************************************
 ;
MAILMSG ;
 D ^XMD
 K BARMSG
 Q
 ; *********************************************************************
 ;
1 ;;
 ;;Accounts Receivable V1.7 Patch 2 has been installed on your
 ;;computer.  You have received this message because you hold the BARZMENU
 ;;key that allows access to the Accounts Receivable Master Menu.
 ;; 
 ;;Accounts Receivable V1.7 Patch 2 contains:
 ;; 
 ;;1.  Enhancements of two reports allowing EISS capability:
 ;;    1.  Period Summary Report (PSR)
 ;;    2.  Age Summary Report (ASM)
 ;;        When selecting these reports by Allowance Category, all categories,
 ;;        summary report;  a file of the report data will automatically get
 ;;        created on the EISS directory and sent to the ARMS Server where
 ;;        the intranet can find it for WEB display.
 ;; 
 ;;2.  Resolution of four known errors:
 ;;    1.  Period Summary Report
 ;;        Resolved error caused by missing Billing Entities
 ;;    2.  Transaction Report
 ;;        Removed Collection Batch to Account Post transaction type (115) from
 ;;        the payment column of the report.
 ;;    3.  Post Unallocated Cash
 ;;        Resolved error seen when user is editing a line item during the posting
 ;;        process.
 ;;    4.  FM Search and Print or Sort and Print from AR Manager
 ;;        Improve screen allowing access to specific files.
 ;;END
