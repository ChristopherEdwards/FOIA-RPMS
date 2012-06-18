BARPT171 ; IHS/SD/LSL - Post init for V1.7 ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 Q
 ; *********************************************************************
 ;
EN ; EP - Driver
 D PATCH1                   ; Post init for V1.7 Patch 1
 D MAIL                     ; Send MailMan message
 Q
 ; *********************************************************************
PATCH1 ;
 ; Delete A/R Period Summary Data File data
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
 Q
 ; *********************************************************************
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
 S XMSUB="Accounts Receivable V1.7 Patch 1"
 S XMDUZ="Accounts Receivable Software Engineer"
 D MAILIST        ; Get list of recipients
 Q
 ; *********************************************************************
 ;
MAILIST ;
 ; Find users who hold the BARZMENU key
 ;S XMY("LEHMAN,LINDA")=""
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
 ;;Accounts Receivable V1.7 Patch 1 has been installed on your
 ;;computer.  You have received this message because you hold the BARZMENU
 ;;key that allows access to the Accounts Receivable Master Menu.
 ;; 
 ;;Accounts Receivable V1.7 Patch 1 contains:
 ;;1.  Enhancements of two reports:
 ;;    1.  Period Summary Report (PSR)
 ;;        This report has been totally rewritten to not use a holding file.
 ;;        Instead, it uses the Transaction file itself.  The user may run the
 ;;        report for any date range desired.  More detail has also been added
 ;;        to the report allowing better tools for reconciliation.  Also, the report
 ;;        may be run using the same parameters (mostly) as the Age Summary Report.
 ;;    2.  Age Summary Report (ASM)
 ;;        This report has been expanded to allow sorting by Discharge Service.
 ;;        Also, bill level detail has been added allowing better tools for
 ;;        reconciliation.
 ;;2.  Resolution of four known errors:
 ;;    1.  Batch Statistical Report
 ;;        Modified to allow 16 characters (instead of 4) in the batch name on
 ;;        the report header.
 ;;    2.  ERA - load new import
 ;;        Allow AHCCCS ERA File to upload into RPMS even if a bill number is not
 ;;        included on the ERA.
 ;;    3.  Upload 3P Bill by Date
 ;;        Modified to not display status of a previous run if the run occurred before
 ;;        AR V1.7 was installed.
 ;;    4.  Post Unallocated
 ;;        Resolved an UNDEF error when posting unallocated
 ;;    5.  Transaction Report
 ;;        Resolved an UNDEF error when the Transaction Report is run
 ;;END
