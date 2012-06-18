BARPT175 ; IHS/SD/LSL - Post init for V1.7 Patch 5 ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 Q
 ; *********************************************************************
 ;
EN ; EP - Driver
 D PRVPATCH                 ; Check to see if previous patches installed
 ; Post init for V1.7 Patch 5
 I '($$INSTALLD^BAREV17("BAR*1.7*5")) D PATCH5
 Q
 ; *********************************************************************
 ;
PRVPATCH ;
 ; Check previous patch post inits
 N BARP1,BARP2,BARP3
 S BARP5=$$INSTALLD^BAREV17("BAR*1.7*5")
 S BARP4=$$INSTALLD^BAREV17("BAR*1.7*4")
 S BARP3=$$INSTALLD^BAREV17("BAR*1.7*3")
 S BARP2=$$INSTALLD^BAREV17("BAR*1.7*2")
 S BARP1=$$INSTALLD^BAREV17("BAR*1.7*1")
 I BARP5 Q                     ; This patch already installed
 I 'BARP4 D EN^BARPT174 Q      ; Patch 4 (or 3,2,1) not installed
 I 'BARP3 D EN^BARPT173 Q      ; Patch 3 ( or 2,1) not installed
 I 'BARP2 D EN^BARPT172 Q      ; Patch 2 (or 1) not installed
 I 'BARP1 D EN^BARPT171 Q      ; Patch 1 not installed
 Q
 ; ********************************************************************
PATCH5 ;
 ; Patch 5 post init
 D PRCRTN                      ; Change processing rtn for Remark Code
 D NCPDPTBL                    ; Add NCPDP Rej/Pay Codes to table
 D TRNSPT                      ; Update Transport with posting element
 D TRNLQ                       ; Modify LQ02 of HIPAA transport
 D VPTRN                       ; Add entry to Variable Processing Mult
 D VPNCPDP                     ; Add entry to Variable Processing Mult
 D TRNTYP                      ; Create Rem Cd, NCPDP Transaction Types
 D MAIL                        ; Send Patch 5 MailMan message to users
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
PRCRTN ;
 ; In the A/R EDI TABLES File, change the processing routine for
 ; Remittance Remark Code entry (IEN 34)
 W !!,"Updating Remittance Remark Code A/R EDI TABLES entry... "
 K DIE,DA,DR
 S DIE="^BARETBL("
 S DA=34
 S DR=".03///D HRMKCD|BAREDP02"
 D ^DIE
 K DIE,DA,DR
 W ?73,"DONE"
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
NCPDPTBL ;
 ; In the A/R EDI TABLES File, add entry for NCPDP Reject/Payment
 ; Codes (IEN 41)
 W !!,"Creating NCPDP Reject/Payment Codes A/R EDI TABLES entry... "
 K DIC,DIE,DA,DR,DINUM,X
 S DIC="^BARETBL("
 S DIC(0)="ZXEL"
 S DLAYGO=90056
 S DINUM=41
 S X="NCPDP Reject/Payment Codes"
 S DIC("DR")=".03///D LQCD|BAREDP02"
 K DD,DO
 D FILE^DICN
 K DIE,DA,DR
 W ?73,"DONE"
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
TRNSPT ;
 ; Update Remark Code elements of HIPAA transport with VRMKCD posting
 ; element
 W !!,"Updating HIPAA transport with Remark Code posting element..."
 ; First, look up HIPAA 835 v4010 Transport
 K DIC,DA,DR,X,Y
 S DIC="^BAREDI(""1T"","
 S DIC(0)="ZX"
 S X="HIPAA 835 v4010"
 K DD,DO
 D ^DIC
 I Y<1 D  Q
 . W !!,$$EN^BARVDF("RVN")
 . W "An exact match for the HIPAA 835 v4010 transport in the A/R EDI TRANSPORT File"
 . W !,"WAS NOT FOUND!  Remark code variables have not been added to the transport."
 . W !,"When the patch install has completed, resolve the above situation"
 . W !,"AND run TRNSPT^BARPT175 to populate Remark Code variables in Transport"
 . W $$EN^BARVDF("RVF")
 S BARTP=+Y                    ; IEN to A/R EDI TRANSPORT file
 ; Now find MIA and MOA Segments
 F I="3-033-MIA","3-035-MOA" D TRNSEG
 W ?73,"DONE"
 Q
 ; ********************************************************************
 ;
TRNSEG ;
 ; Find MIA and MOA segments of HIPAA transport
 K DIC,DA,DR,X,Y
 S DA(1)=BARTP
 S DIC="^BAREDI(""1T"","_DA(1)_",10,"
 S DIC(0)="ZX"
 S X=I
 K DD,DO
 D ^DIC
 I Y<1 Q
 S BARSEG=+Y                 ; Segment IEN
 I I="3-033-MIA" F J="MIA05","MIA20","MIA21","MIA22","MIA23" D TRNELM
 I I="3-035-MOA" F J="MOA03","MOA04","MOA05","MOA06","MOA07" D TRNELM
 Q
 ; ********************************************************************
 ;
TRNELM ;
 ; Find Remark Code elements of MIA and MOA segments and
 ; edit posting element field (.08)
 K DIC,DA,DR,X,Y
 S DA(2)=BARTP
 S DA(1)=BARSEG
 S DIC="^BAREDI(""1T"","_DA(2)_",10,"_DA(1)_",10,"
 S DIC(0)="ZX"
 S X=J
 K DD,DO
 D ^DIC
 I Y<1 Q
 S BARELM=+Y
 S DIE=DIC
 S DA=+Y
 S DR=".08///VRMKCD"
 D ^DIE
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
TRNLQ ;
 ; Update LQ02 element of HIPAA transport for processing
 ; 
 W !!,"Updating HIPAA transport with LQ Remark Code/NCPDP Reject/Payment"
 W !,"data fields necessary for ERA processing..."
 ; First, look up HIPAA 835 v4010 Transport
 K DIC,DA,DR,X,Y
 S DIC="^BAREDI(""1T"","
 S DIC(0)="ZX"
 S X="HIPAA 835 v4010"
 K DD,DO
 D ^DIC
 I Y<1 D  Q
 . W !!,$$EN^BARVDF("RVN")
 . W "An exact match for the HIPAA 835 v4010 transport in the A/R EDI TRANSPORT File"
 . W !,"WAS NOT FOUND!  Remark code variables have not been added to the transport."
 . W !,"When the patch install has completed, resolve the above situation"
 . W !,"AND run TRNLQ^BARPT175 to populate LQ Segment variables in Transport"
 . W $$EN^BARVDF("RVF")
 S BARTP=+Y                    ; IEN to A/R EDI TRANSPORT file
 ; 
 ; Now find LQ Segment
 K DIC,DA,DR,X,Y
 S DA(1)=BARTP
 S DIC="^BAREDI(""1T"","_DA(1)_",10,"
 S DIC(0)="ZX"
 S X="3-130-LQ"
 K DD,DO
 D ^DIC
 I Y<1 Q
 S BARSEG=+Y                 ; Segment IEN
 ;
 ; Now find LQ02 element and edit
 K DIC,DA,DR,X,Y
 S DA(2)=BARTP
 S DA(1)=BARSEG
 S DIC="^BAREDI(""1T"","_DA(2)_",10,"_DA(1)_",10,"
 S DIC(0)="ZX"
 S X="LQ02"
 K DD,DO
 D ^DIC
 I Y<1 Q
 S BARELM=+Y
 S DIE=DIC
 S DA=+Y
 S DR=".04///ID"
 S DR=DR_";.08///VLQCD"
 S DR=DR_";.09////41"
 D ^DIE
 W ?73,"DONE"
 Q
 ; ********************************************************************
 ;
VPTRN ;
 ; Create VRMKCD in Variable Processing Multiple for HIPAA 835 v4010
 ; Transport (node 70).  The routine populated here for VRMKCD is what
 ; is used to populate the REMARK CODE multiple in the CLAIM multiple
 ; in the A/R EDI IMPORT file.
 W !!,"Updating Variable Processing mult for Remark Code of HIPAA transport... "
 K DIC,DA,DR,X,Y
 Q:'+$G(BARTP)
 Q:$D(^BAREDI("1T",BARTP,70,"VRMKCD"))
 S DA(1)=BARTP
 S DIC="^BAREDI(""1T"","_DA(1)_",70,"
 S DIC(0)="ZXLE"
 S DLAYGO=90056
 S DIC("P")=$P($G(^DD(90056.01,70,0)),U,2)
 S DIC("DR")=".02///RMKCD|BAREDPA1"
 S X="VRMKCD"
 K DD,DO
 D ^DIC
 W ?73,"DONE"
 Q
 ; ********************************************************************
 ;
VPNCPDP ;
 ; Create VLQCD in Variable Processing Multiple for HIPAA 835 v4010
 ; Transport (node 70).  The routine populated here for VLQCD is what
 ; is used to populate the REMARK CODE multiple OR NCPDP REJ/PAY
 ; multiple in the CLAIM multiple of the A/R EDI IMPORT file dependent on
 ; the value of LQ01.
 W !!,"Updating Variable Processing mult for NCPDP Reject/Payment Code"
 W !,"of HIPAA transport... "
 K DIC,DA,DR,X,Y
 Q:'+$G(BARTP)
 Q:$D(^BAREDI("1T",BARTP,70,"VLQCD"))
 S DA(1)=BARTP
 S DIC="^BAREDI(""1T"","_DA(1)_",70,"
 S DIC(0)="ZXLE"
 S DLAYGO=90056
 S DIC("P")=$P($G(^DD(90056.01,70,0)),U,2)
 S DIC("DR")=".02///LQ|BAREDPA1"
 S X="VLQCD"
 K DD,DO
 D ^DIC
 W ?73,"DONE"
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
TRNTYP ;
 ; Create New transaction type called Remark Code
 W !!,"Creating REMARK CODE and NCPDP REJ/PAY Transaction Types... "
 ; REMARK CODE
 K DIC,DA,DR,X,Y
 S DIC="^BARTBL("
 S DIC(0)="LZX"
 S DINUM=505
 S X="REMARK CODE"
 S DLAYGO=90052
 S DIC("DR")="2////7"          ; Transaction type
 S DIC("DR")=DIC("DR")_";6///RMKCD"    ; Synonym
 K DD,DO
 D ^DIC
 ; NCPDP REJ/PAY
 K DIC,DA,DR,X,Y
 S DIC="^BARTBL("
 S DIC(0)="LZX"
 S DINUM=506
 S X="NCPDP REJ/PAY"
 S DLAYGO=90052
 S DIC("DR")="2////7"          ; Transaction type
 S DIC("DR")=DIC("DR")_";6///NCPDP"    ; Synonym
 K DD,DO
 D ^DIC
 W ?73,"DONE"
 Q
 ; ********************************************************************
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
 S XMSUB="Accounts Receivable V1.7 Patch 5"
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
 . Q:BARNAME=""
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
 K BARMSG
 Q
 ; *********************************************************************
 ;
1 ;;
 ;;Accounts Receivable V1.7 Patch 5 has been installed on your
 ;;computer.  You have received this message because you hold the BARZMENU
 ;;key that allows access to the Accounts Receivable Master Menu.
 ;; 
 ;;Accounts Receivable V1.7 Patch 5 is inclusive of patches 1 thru 4.  It
 ;;also contains the following:
 ;;
 ;;1.  Incorporation of HIPAA compliant Remittance Advice Remark Codes to
 ;;    RPMS Accounts Receivable.  This includes the following changes:
 ;;
 ;;    a.  Creation and population of new A/R EDI REMARK CODES File.
 ;;        This file reflects Remark Codes as of February 2004 Code List
 ;;        Updates as published by wpc-edi.com.
 ;;    b.  Creation of new Transaction Type called "REMARK CODE"
 ;;    c.  Recognize Remittance Advice Remark Codes in 835 remittance
 ;;        files.
 ;;    d.  Post Remark Codes during ERA Post Claims process.
 ;;    e.  New Posting option called Post Remark Codes allowing user to
 ;;        manually post remark codes if desired.
 ;;    f.  New Posting option called Remittance Advice Remark Code Inquiry
 ;;        allowing user to inquire individual remark codes.
 ;;    g.  Display REMARK CODE transactions on Bill Posted Summary.
 ;;
 ;;2.  Incorporation of HIPAA compliant NCPDP Reject/Payment Codes to
 ;;    RPMS Accounts Receivable.  This includes the following changes:
 ;;
 ;;    a.  Creation of new Transaction Type called "NCPDP REJ/PAY"
 ;;    b.  Recognize NCPDP Reject/Payment Codes in 835 remittance
 ;;        files.
 ;;    c.  Post NCPDP Reject/Payment Codes during ERA Post Claims process.
 ;;    d.  New Posting option called Post NCPDP Reject/Payment Codes
 ;;        allowing user to manually post NCPDP Reject/Payment Codes if
 ;;        desired.
 ;;    e.  Display NCPDP REJ/PAY transactions on Bill Posted Summary.
 ;;    f.  The NCPDP Reject/Payment Code table is distributed with the
 ;;        Pharmacy POS software.  If it is not installed on you system,
 ;;        you will not be able to post NCPDP Reject/Payment codes
 ;;        manually and NCPDP reject codes on the ERA will come up
 ;;        "NOT MATCHED"
 ;;
 ;;3.  Allow ERA posting process to obtain Date of Service from the line
 ;;    item level if Date of Service not available at the claim level.
 ;;
 ;;4.  New Posting Menu option called Standard Adjustment Reason Code
 ;;       Inquiry.
 ;;
 ;;5.  Reworded all references of "check" to "chk/EFT #" in regards to
 ;;    ERA Posting and Collection Batch Items.
 ;;
 ;;6.  Modified ERA Posting option Review Postable Claims allowing
 ;;    check/EFT # to be reviewed more than once.
 ;;
 ;;7.  Seven Support Center calls that have been resolved:
 ;;
 ;;    a.  Resolved undefined error when loading an ERA file and the 
 ;;        user must pick the correct bill if more than one bill in
 ;;        RPMS matches the bill on the ERA (835).
 ;;    b.  Resolved undefined error when loading an ERA file that is
 ;;        all one line and has a carriage return/line feed at the end.
 ;;    c.  Modified Post ERA Claims option to stop display of negative
 ;;        balance on bill if posting bill's single transaction brings
 ;;        the bill's balance to zero in A/R.
 ;;    d.  Modified Collection Batch totals to not include items with a
 ;;        status of "rolled up".
 ;;    e.  Modified Load New Import option for AHCCCS Transport
 ;;        (proprietary format) to allow mapping of AHCCCS denial codes
 ;;        to RPMS categories and reasons.
 ;;    f.  Modified Flag Patients Accounts for Statements to allow marking
 ;;        of patient registered at satellite when user is logged into
 ;;        parent.
 ;;    g.  Resolved undefined error when Posting Refunds.
 ;;END
