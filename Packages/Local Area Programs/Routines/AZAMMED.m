AZAMMED ; IHS/PHXAO/TMJ - ACTUAL UPDATES OF AHCCCS MEDICAID RECORDS [ 06/17/03  9:16 AM ]
 ;AZAGMED Global established by Routine AZAGMED.
 ;This Sets Every Record in AHCCCS File to AZAGMED(Global
 ;
 ;This Routine $0's through Global ^AZAGMED(
 ;This Routine completes the ACTUAL RPMS DOWNLOAD
 ;by updated the RPMS MEDICAID ELIGIBILITY File, the
 ;RPMS Master Control File and the Monthly No Match File
 ;
 ;
VARIABLE ;Establish Date/Time/Count Variables
 ;Establish Run Counters
 ;
 ;S FILE="MED0120001.TXT" ;Hard Set for Testing Only on just this routine
 ;
 S AZAMNEW=0 ;New Adds to Med Eligibility File
 S AZAMUPDT=0 ;Updates to Med Eligibility File
 S SSNCT=0 ;SSN Matches Only in No Match File
 S KIDCT=0 ;KID's Care Counter in No Match File
 S TOTALCT=0 ;Total Records Actually Processed - New or Update
 S NOCOUNT=0 ; Variable used to not count News & Updates twice
 S GRANDTOT=0 ;Grand Total all Records regardless of action 
 S BEGTIME=$$NOW^XLFDT
 ;
INS ;GET ARIZONA MEDICAID INTERNAL NUMBER FROM THE INSURER FILE-PHX AREA
 S DIC="^AUTNINS(",DIC(0)="XZIMO",X="MEDICAID" D ^DIC
 I Y'=-1 S INS=$P(Y,"^",1)
 E  G END2 ;Quit if no Insurer - don't write message
 ;
 D START
 S ENDTIME=$$NOW^XLFDT
 D LOG
 D END
 Q
 ;
START ;BEGIN $O THRU ^AZAGMED( -created by Routine AZAGMED
 ;which reads all records in AHCCCS File 1-420 Position &
 ;sets full record  in ^AZAGMED(Global
 ;S MRATE=""
 ;
 I '$D(ZTQUEUED) U IO(0)  ;IHS/ANMC/FBD-2/17/98-ADDED LINE-TRYING TO AVOID <MODER> ERRORS
 K ^TMP($J),^AZAMED ;Kill off $Job and Previous Month's AZAMED Global
 ;
 S ^AZAMED(0)="AZA MEDICAID ELIGIBLE (NO SSN)^1180001DI"
A ; -- BEGIN $O THRU AZAGMED(GLOBAL CREATED BY AZAGMED
 S IFN=0 F  S IFN=$O(^AZAGMED(IFN)) Q:'IFN  D
 . S N=^AZAGMED(IFN),MSSN=$E(N,27,35),MNUM=$E(N,18,26),MLNAME=$E(N,108,130),MDOB=$E(N,143,150),MSEX=$E(N,142,142),MFNAME=$E(N,131,140)
 . Q:$E(N,1,2)="XX"  ;Quit -Last IFN Record is end of File
 . S MLNAME=$P(MLNAME," ",1) ; Strip out spaces on Medicaid Last Name
 . S MFNAME=$P(MFNAME," ",1) ;Strip out spaces on Medicaid First Name
 . S MFULNAME=MLNAME_","_MFNAME ;Medicaid Full Name
 . S MRATE="" S MKID="" S SSNMATCH="" S NOCOUNT=0 S GRANDTOT=GRANDTOT+1
 . D MEDNUM ;Check the Med Elig Number before SSN
 . I MNUMMAT=0 S DFN=$O(^DPT("SSN",+MSSN,0)) I 'DFN N N,MSSN,MNUM D ^AZAMED0 Q  
 . D MEDNAME ;Check Medicaid Elig File's Medicaid Name (if exists)
 . S SDOB=$P(^DPT(DFN,0),U,3) ;VA PT DOB
 . S MDOB=$$DOB ; AHCCCS DOB
 . S SSEX=$P(^DPT(DFN,0),U,2),FULLNAME=$P(^(0),U) ; VA PT SEX
 . S SLNAME=$P(FULLNAME,",",1) ; VA PT FULL LAST NAME
 . S MRATE=$E(N,355,358) ;AHCCCS Rate Code-Ck for Kids Care
 . S EED=$$EED,EBD=$$EBD ;AHCCCS PAYMENT TO/FROM DT
 . ;Q:EED<$$EHIS
 . S ERD=$$ERD,CT=$E(N,106,107) ;Enrollment Dt - CT=Coverage Type)
 . S NOCOUNT=0 ;Variable for Not counting New & Updates twice
 . I MRATE>5999&(MRATE<7000) S MKID="Y" S KIDCT=KIDCT+1 N N,MSSN,MNUM D ^AZAMED0 Q  ;Quit if KIDS CARE-Per J. Hathcoat 1/25/01
 . I MLNAME'=SLNAME&(MNAMEMAT'=1) S SSNCT=SSNCT+1 S SSNMATCH="Y" N N,MSSN,MNUM D ^AZAMED0 Q  ; Quit if no match on Med Name or Last Name
 . I MDOB'=SDOB S SSNCT=SSNCT+1 S SSNMATCH="Y" N N,MSSN,MNUM D ^AZAMED0 Q  ; Quit on DOB No Match
 . I MSEX'=SSEX S SSNCT=SSNCT+1 S SSNMATCH="Y" N N,MSSN,MNUM D ^AZAMED0 Q  ;     Quit if no match on Sex
 . D NEW,UP0,MED
 . S TOTALCT=TOTALCT+1 ;Total Record Count - Regardless of action
 Q
 ;
MED ; -- add eligiblity date(s)/data
 S IEN=$O(^AUPNMCD("B",DFN,0)) Q:'IEN
 Q:$P($G(^AUPNMCD(IEN,11,EBD,0)),U,2)=EED  ;Quit if Both Beg/End Match already
 S:'$D(^AUPNMCD(IEN,11,0)) $P(^(0),U,2)="9000004.11D"
 S LSTEBD=$P($G(^AUPNMCD(IEN,11,0)),U,3) ;Last Beg Date entered
 I LSTEBD="" D
 . S $P(^AUPNMCD(IEN,11,0),U,3)=EBD 
 . S $P(^AUPNMCD(IEN,11,0),U,4)=$P(^(0),U,4)+1
 . S DR=".01///"_EBD_"" ;.03////"_CT ; Add Beginning DT Only
 . S DIE="^AUPNMCD("_IEN_",11,",DA(1)=IEN,DA=EBD D ^DIE K DIE,DR,DA,DINUM
 . I NOCOUNT=0 S AZAMUPDT=AZAMUPDT+1 D UPDATES^AZAMSTR ;Update Count-Update Master List
 I LSTEBD'="" D
 . S SENDDT=$P($G(^AUPNMCD(IEN,11,LSTEBD,0)),U,2)
 . I SENDDT'="" S $P(^AUPNMCD(IEN,11,0),U,3)=EBD 
 . I SENDDT'="" S $P(^AUPNMCD(IEN,11,0),U,4)=$P(^(0),U,4)+1
 . I SENDDT'="" S DR=".01///"_EBD_";03////"_CT ; Add Beg DT Only
 . I SENDDT'="" S DIE="^AUPNMCD("_IEN_",11,",DA(1)=IEN,DA=EBD D ^DIE K DIE,DR,DA,DINUM I NOCOUNT=0 S AZAMUPDT=AZAMUPDT+1 D UPDATES^AZAMSTR Q
 . D STILLACT^AZAMSTR ;Existing Patient fell through-Still Active Only/no Update
 Q
 ;
NEW ; -- create new entry in medicaid eligible
 Q:$O(^AUPNMCD("B",+DFN,0))  ;Quit if already in Medicaid Eligibility File
 D ^XBFMK K DIADD,DINUM
 S X=DFN,DIC="^AUPNMCD(",DIC(0)="L",DLAYGO=9000004
 S DIC("DR")=".02////"_INS_";.03////"_MNUM_";.04////3;2101////"_MFULNAME
 S DIC("DR")=DIC("DR")_";.07////"_SSEX_";.08////"_DT_";.12////"_MRATE
 ;K DD,DO
 D FILE^DICN S IEN=+Y D ^XBFMK K DIADD,DINUM
 S AZAMNEW=AZAMNEW+1 ;Counter for New Adds to Medicaid Eligibility file
 S NOCOUNT=1 ;Don't count again on Date Updates UP0
 D NEW^AZAMSTR
 Q
 ;
UP0 ; -- update 0th node - Patient Demographics Only
 S IEN=$O(^AUPNMCD("B",DFN,0)) Q:'IEN
 S:'$P(^AUPNMCD(IEN,0),U,2) $P(^AUPNMCD(IEN,0),U,2)=INS
 S:'$P(^AUPNMCD(IEN,0),U,3) $P(^AUPNMCD(IEN,0),U,3)=MNUM
 S:'$P(^AUPNMCD(IEN,0),U,4) $P(^AUPNMCD(IEN,0),U,4)=3
 S DIE="^AUPNMCD(",DA=IEN,DR="2101////"_MFULNAME_";.08////"_DT_";.12////"_MRATE
 D ^DIE K DIE,DR,DA
 ;I NOCOUNT=0 S AZAMUPDT=AZAMUPDT+1 ;Counter for Updates only to Medicaid Eligibility File
 Q
 ;
END ; -- cleanup       
 S GRANDTOT=GRANDTOT-1
 ;W !!,"End of Download Update!!!",!
 ;W !!
 ;W "Total Records Processed: "_GRANDTOT
 ;W !,"Total Action Records Process: "_TOTALCT
 ;W !,"Total New Records Added: "_AZAMNEW
 ;W !,"Total Updated Records: "_AZAMUPDT
 ;W !,"Total Records with SSN Match Only: "_SSNCT
 ;W !!,"Total KID's Care: "_KIDCT
 ;
 K IFN,DFN,IEN,EED,EBD,CT,MNUM,MSEX,N,NAME,CNT,MFULNAME,MFNAME,MNAMEMAT,MEDNAME,MIEN,MFNAME,MDOB,MRATE
 K AZAMNEW,AZAMUPDT,SSNCT,TOTALCT,NOCOUNT,GRANDTOT,BEGTIME,MKID,KIDCT,ENDTIME
 Q
 ;
EED() ; -- eligibility end date
 ;N X,Y S X=$E(N,412,419) D ^%DT Q Y
 N X,Y S YYYY=$E(N,412,415),MMDD=$E(N,416,419)
 S EED=MMDD_YYYY
 S X=EED D ^%DT Q Y
 ;
EBD() ; -- eligibility beg date
 ;N X,Y S X=$E(N,404,411) D ^%DT Q Y
 N X,Y S YYYY=$E(N,347,350),MMDD=$E(N,351,354)
 S EBD=MMDD_YYYY
 S X=EBD D ^%DT Q Y
 ;
EHIS() ; -- eligibilities after date/flag
 N X1,X2,X S X1=DT,X2=-180 D C^%DTC Q X
 ;
HRCN() ;EP; -- IHS health record number
 Q $P($G(^AUPNPAT(+$G(DFN),41,+$G(DUZ(2)),0)),"^",2)
 ;
ERD() ;EP -- Eligibility Enrollment Dt (Same as Beg Date on Roster)
 ;Roster Positions 347-354
 N X,Y S YYYY=$E(N,347,350),MMDD=$E(N,351,354)
 S ERD=MMDD_YYYY
 S X=ERD D ^%DT Q Y
 ;N X,Y S X=$E(N,404,411) D ^%DT Q Y
 ;
DOB() ;EP - Date of AHCCCS Birth Date Conversion
 N X,Y S YYYY=$E(N,143,146),MMDD=$E(N,147,150)
 S MDOB=MMDD_YYYY
 S X=MDOB D ^%DT Q Y
 ;
LOG ;Update AZA MEDICAL ELIGIBLE DOWNLOAD LOG
 ;W !!,"The Download Process is Now Complete!!"
 ;W !!,"I will now update the Download Log with the final run documentation",!
 ;S BEGTIME=$$NOW^XLFDT,ENDTIME=$$NOW^XLFDT,GRANDTOT=100,TOTALCT=50,SSNCT=5,AZAMNEW=10,AZAMUPDT=8
 ;The .01 Entry is Today's Date at time of run - BEGTIME Variable
 D ^XBFMK K DIADD,DINUM
 S X=BEGTIME,DIC="^AZAMEDLG(",DIC(0)="L",DLAYGO=1180006
 S DIC("DR")=".02////"_ENDTIME_";.03////"_GRANDTOT_";.04///"_TOTALCT_";.05////"_SSNCT_";1///"_KIDCT
 S DIC("DR")=DIC("DR")_";.06////"_AZAMNEW_";.07////"_AZAMUPDT_";.08////"_FILE
 ;ADD THE FILE NAME PROCESSED FIELD .08 HERE
 ;S DIC("DR")=DIC("DR")_";1////"_SSN_";2////"_RESCE
 D FILE^DICN S IEN=+Y D ^XBFMK K DIADD,DINUM
 ;
 ;W !!,"Log File Updated",!
 ;
 Q
 ;
END2 ;Abnormal Termination - Medicaid Insurer missing from Insurer File
 ;W !,"The Insurer - ARIZONA MEDICAID - is missing from the Insurer File",!
 ;W !,"The Initial Process of creating the AZAGMED Global is complete",!
 ;W "however, the Update Run (AZAMED) cannot be ran - See your Site Manager",!!
 Q
 ;
MEDNAME ;Check Med Elig Medicaid Name-If exists for match
 ;
 S MNAMEMAT=0
 S MIEN=$O(^AUPNMCD("B",+DFN,0))
 Q:'MIEN
 S MEDNAME=$P($G(^AUPNMCD(MIEN,21)),U,1)
 Q:MEDNAME=""
 I MEDNAME=MFULNAME S MNAMEMAT=1
 Q
 ;
MEDNUM ;Check Med Elig Number against RPMS
 ;
 S MNUMMAT=0
 S MIEN=$O(^AUPNMCD("AE",MNUM,0))
 Q:'MIEN
 S MEDNUM=$P($G(^AUPNMCD(MIEN,0)),U,3)
 Q:MEDNUM=""
 I MEDNUM=MNUM S MNUMMAT=1 S DFN=$P($G(^AUPNMCD(MIEN,0)),U,1)
 Q
 ;
