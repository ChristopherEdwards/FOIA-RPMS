BARPT18 ; IHS/SD/LSL - Post init for V1.8 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 Q
 ; ********************************************************************
 ;
EN ; EP - Driver
 D PRVPATCH                 ; Check to see if previous patches installed
 D POST18                   ; Post init for V1.8
 D MAIL                     ; Send MailMan message
 Q
 ; ********************************************************************
 ;
PRVPATCH ;
 ; Check previous patch post inits
 N BARP1,BARP2,BARP3,BARP4,BARP5
 S BARP5=$$INSTALLD("BAR*1.7*5")
 S BARP4=$$INSTALLD("BAR*1.7*4")
 S BARP3=$$INSTALLD("BAR*1.7*3")
 S BARP2=$$INSTALLD("BAR*1.7*2")
 S BARP1=$$INSTALLD("BAR*1.7*1")
 I BARP5 Q                     ; all previous patches installed
 I 'BARP5 D EN^BARPT175 Q      ; patch 5 (or 4,3,2,1) not installed
 I 'BARP4 D EN^BARPT174 Q      ; Patch 4 (or 3,2,1) not installed
 I 'BARP3 D EN^BARPT173 Q      ; Patch 3 ( or 2,1) not installed
 I 'BARP2 D EN^BARPT172 Q      ; Patch 2 (or 1) not installed
 I 'BARP1 D EN^BARPT171 Q      ; Patch 1 not installed
 Q
 ; ********************************************************************
 ;
INSTALLD(BAR) ;
 ; Determine if version and patch of said application has been installed
 ; where BAR is the name of the INSTALL  (BAR*1.7*1)
 ; 1st look up package
 N DIC,X,Y
 S X=$P(BAR,"*")
 S DIC="^DIC(9.4,"
 S DIC(0)="FM"
 S D="C"
 D IX^DIC
 I Y<1 Q 0
 ; 2nd look up version
 S DIC=DIC_+Y_",22,"
 S X=$P(BAR,"*",2)
 D ^DIC
 I Y<1 Q 0
 ; 3rd look up patch
 S DIC=DIC_+Y_",""PAH"","
 S X=$P(BAR,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ; ********************************************************************
 ;
POST18 ;
 ; Perform 1.8 post inits
 D START^BAR18DSP              ; Convert Debt Collection files
 D ZISH                        ; Create entries in ZISH SEND PARAMETERS
 Q
 ; ********************************************************************
 ;
ZISH ;
 ; Create entries in ZISH SEND PARAMETERS for EISS and Debt Collection
 W !,"Creating entries in ZISH SEND PARAMETERS FILE for EISS..."
 S BARD=";;"
 S BARCNT=0
 F  D ZISH2 Q:BARVALUE="END"
 Q
 ; ********************************************************************
 ;
ZISH2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@1+BARCNT),BARD,2,8)
 Q:BARVALUE="END"
 K DIC,X,Y,DA,DR,DIE
 S DIC="^%ZIB(9888888.93,"
 S DIC(0)="ZL"
 S DLAYGO=9888888
 S X=$P(BARVALUE,BARD,1)
 K DD,DO
 D ^DIC
 I '+Y Q
 I $P(Y,U,3)'=1 Q
 S DIE=DIC
 S DA=+Y
 S DR=".02///^S X=$P(BARVALUE,BARD,2)"            ; Target system id
 S:$P(BARVALUE,BARD,3)]"" DR=DR_";.03///^S X=$P(BARVALUE,BARD,3)"        ; Username
 S:$P(BARVALUE,BARD,4)]"" DR=DR_";.04///^S X=$P(BARVALUE,BARD,4)"        ; Password
 S DR=DR_";.06///^S X=$P(BARVALUE,BARD,5)"        ; Arguments
 S DR=DR_";.07///^S X=$P(BARVALUE,BARD,6)"        ; Forground/Background
 S DR=DR_";.08///^S X=$P(BARVALUE,BARD,7)"        ; Send command
 D ^DIE
 Q
 ; ********************************************************************
 ;
1 ;
 ;;BAR EISS PSR F;;127.0.0.1;;bardata;;1bardat/;;-i;;F;;sendto
 ;;BAR EISS PSR B;;127.0.0.1;;bardata;;1bardat/;;-i;;B;;sendto
 ;;BAR EISS ASM F;;127.0.0.1;;bardata;;1bardat/;;-i;;F;;sendto
 ;;BAR EISS ASM B;;127.0.0.1;;bardata;;1bardat/;;-i;;B;;sendto
 ;;BAR DCM F;;asdstgw.hqw.DOMAIN.NAME;;;;;;-i;;F;;sendto
 ;;BAR DCM B;;asdstgw.hqw.DOMAIN.NAME;;;;;;-i;;B;;sendto
 ;;END
 ; ********************************************************************
 ;
MAIL ;
 ; Send a mail message to all holders of the BARZMENU key that v1.8
 ; has been installed on the system.
 ;
 W !!,"Sending MailMan message to users..."
 D MAILSET
 D MAILTXT
 D MAILMSG
 W "   DONE"
 Q
 ; ********************************************************************
 ;
MAILSET ;   
 ; Set Mailman Variables
 K XMY
 S XMSUB="Accounts Receivable V1.8 (Beta T2)"
 S XMDUZ="Accounts Receivable Software Engineer"
 D MAILIST        ; Get list of recipients
 Q
 ; ********************************************************************
 ;
MAILIST ;
 ; Find users who hold the BARZMENU key
 ;S XMY("DOE,JOHN")=""
 S J=0
 F  S J=$O(^XUSEC("BARZMENU",J)) Q:'J  D
 . S BARNAME=$P($G(^VA(200,J,0)),U)
 . S XMY(BARNAME)=""
 Q
 ; ********************************************************************
 ;
MAILTXT ; 
 S K=0
 F  D  Q:BARTXT="END"
 . S K=K+1
 . S BARTXT=$P($T(@2+K),";;",2)
 . I BARTXT="END" Q
 . S BARMSG(K,0)=BARTXT
 S XMTEXT="BARMSG("
 S %H=$H
 D YX^%DTC
 Q
 ; ********************************************************************
 ;
MAILMSG ;
 D ^XMD
 K BARMSG
 Q
 ; ********************************************************************
 ;
2 ;;
 ;;Accounts Receivable V1.8 has been installed on your computer.
 ;;You have received this message because you hold the BARZMENU menu option
 ;;key that allows access to the Accounts Receivable Master Menu.
 ;; 
 ;;Accounts Receivable 1.8 contains:
 ;;1.  All previous version and patch functionality.
 ;;2.  Enhancement of two existing reports:
 ;;     1.  Aged Open Items Report (AOI)
 ;;         Report may now be executed for payers or patients 
 ;;     2.  Small Balance List (SBL)
 ;;         This report is no longer dependent on the Bill File Error Scan (BES)
 ;;3.  New Reports
 ;;     1.  Cancelled Bills Report (CXL)
 ;;         Found under Manager Reports, this report shows bills in AR that were
 ;;         cancelled in 3P.
 ;;     2.  Inpatient Primary Diagnosis Report (IPDR)
 ;;         Found under Financial Reports, this report displays AR data (bill
 ;;         count, covered days, amount billed, amount paid, copay/deductibe,
 ;;         other adjustments) by Primary Diagnosis Code.
 ;;     3.  Large Balance List (LBL)
 ;;         Found under Account Management Reports, this report displays bills
 ;;         with an open balance greater than the specified dollar amount.
 ;;     4. Payment Summary Report by Collection Batch (PRP)
 ;;         Found under Financial Reports, this report displays a payment
 ;;         summary for AR bills found in Collection Batches spanning a specified
 ;;         date range
 ;;4.  New posting option called Auto Post Beneficies (BEN)
 ;;         After selecting AR Account (must be a beneficiary account), this
 ;;         option will automatically post all bills tied to the specified
 ;;         account to the Adjustment Category named WRITE OFF (3); Type named
 ;;         INDIAN BENEFICIARY (136).
 ;;5.  EISS enhancements
 ;;     1.  Once an EISS file is successfully sent to the central location, it is
 ;;         deleted from the site's local directory.
 ;;     2.  New Manager option called Manually Resend EISS File (EISS)
 ;;         Allows user to resend any EISS file that may not have reached it's
 ;;         destination.
 ;;6. New Debt Collection Module (DCM)
 ;;     1.  Debt Collection Process (DCP)
 ;;         Manually create files to send to Debt Collection Agency by specifying
 ;;         certain parameters
 ;;     2.  Debt Collection Site Parameters (SPM)
 ;;         Site parameters that need defined prior to Debt Collection Process,
 ;;         such as minimum balance allowed on bill before sending to a
 ;;         collection agency.
 ;;     3.  Restricted Payers Maintenance (RPM)
 ;;         Specify payers of which to send to collections
 ;;     4.  View Debt Collection Parameters (DCI)
 ;;     5.  Debt Collection Reports (REP)
 ;;         1.  Debt Collection Log Report (LOG)
 ;;             List of bills sent in specified transmission
 ;;         2.  Debt Collection Payment Report (DCPR)
 ;;             Same as Log Report only contains payment information as well
 ;;         3.  Bill Inquiry (BIR)
 ;;             List all transmissions for specified bill
 ;;     6.  Debt Collection Auto Process (taskable option)
 ;;          If tasked via TaskMan, creates and sends files to debt collection
 ;;          on a pre-specified recurring basis following parameters defined in
 ;;          Debt Collection Site Parameters.
 ;;7.  Resolution of ERA check finding error.
 ;;    If currently experiencing this issue the A/R EDI CHECKS file
 ;;    needs to be cleaned.  For assistance please contact the Help
 ;;    Desk.
 ;;END
