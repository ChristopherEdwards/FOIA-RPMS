BMEMED ; IHS/PHXAO/TMJ - ACTUAL UPDATES OF RECORDS - 560 FILE PROCESS ; 
 ;;1.0T1;MEDICAID ELIGIBILITY DOWNLOAD;;JUN 25, 2003
 ;BMEGMED Global established by Routine BMEGMED.
 ;This Sets Every Record in AHCCCS File from the BMEGMED(Global
 ;
 ;This Routine $0's through Global ^BMEGMED(
 ;This Routine completes the ACTUAL RPMS DOWNLOAD
 ;by updating the RPMS MEDICAID ELIGIBILITY File, the
 ;RPMS Master Control File and the Monthly No Match File
 ;
 ;
BEGIN ;Establish Date/Time/Count Variables
 ;Establish Run Counters
 ;
 ;S FILE="MED0120001.TXT" ;Hard Set for Testing Only on just this routine
 ;
 S BMEMNEW=0 ;New Adds to Med Eligibility File
 S BMEMUPDT=0 ;Updates to Med Eligibility File
 S BMESSNCT=0 ;SSN Matches Only in No Match File
 S BMEKIDCT=0 ;KID's Care Counter in No Match File
 S BMETOTCT=0 ;Total Records Actually Processed - New or Update
 S BMENOCT=0 ; Variable used to not count News & Updates twice
 S BMEGTOT=0 ;Grand Total all Records regardless of action 
 S BMEBTIME=$$NOW^XLFDT
 ;
INS ;GET ARIZONA MEDICAID INTERNAL NUMBER FROM THE INSURER FILE-PHX AREA
 S DIC="^AUTNINS(",DIC(0)="XZIMO",X="MEDICAID" D ^DIC
 I Y'=-1 S BMEINS=$P(Y,"^",1)
 E  G END2 ;Quit if no Insurer - don't write message
 ;
 D START
 S BMEETIME=$$NOW^XLFDT
 D LOG
 D END
 Q
 ;
START ;BEGIN $O THRU ^BMEGMED( -created by Routine BMEGMED
 ;which reads all records in AHCCCS File 1-420 Position &
 ;sets full record  in ^BMEGMED(Global
 ;S BMEMRATE=""
 ;
 K ^TMP($J),^BMETMED ;Kill off $Job and Previous Month's BMETMED Global
 ;
 S ^BMETMED(0)="BME MEDICAID NO MATCH^90332DI"
A ; -- BEGIN $O THRU BMEGMED(GLOBAL CREATED BY ROUTINE BMEGMED
 S BMEIFN=0 F  S BMEIFN=$O(^BMEGMED(BMEIFN)) Q:'BMEIFN  D
 . S BMEREC=^BMEGMED(BMEIFN),BMEMSSN=$E(BMEREC,27,35),BMEMNUM=$E(BMEREC,18,26),BMEMLNAM=$E(BMEREC,108,130),BMEMDOB=$E(BMEREC,143,150),BMEMSEX=$E(BMEREC,142,142),BMEFNAM=$E(BMEREC,131,140)
 . Q:$E(BMEREC,1,2)="XX"  ;Quit -Last BMEIFN Record is end of File
 . S BMEMLNAM=$P(BMEMLNAM," ",1) ; Strip out spaces on Medicaid Last Name
 . S BMEFNAM=$P(BMEFNAM," ",1) ;Strip out spaces on Medicaid First Name
 . S BMEMFULN=BMEMLNAM_","_BMEFNAM ;Medicaid Full Name
 . S BMEMRATE="" S BMEMKID="" S BMESSNCK="" S BMENOCT=0 S BMEGTOT=BMEGTOT+1
 . D MEDNUM ;Check the Med Elig Number before SSN
 . I BMENUMCK=0 S DFN=$O(^DPT("SSN",+BMEMSSN,0)) I 'DFN N BMEREC,BMEMSSN,BMEMNUM D ^BMEMED0 Q
 .       . D MEDNAME ;Check Medicaid Elig File's Medicaid Name (if exists)
 . S BMESDOB=$P(^DPT(DFN,0),U,3) ;VA PT DOB
 . S BMEMDOB=$$DOB ; AHCCCS DOB
 . S BMESSEX=$P(^DPT(DFN,0),U,2),BMESFULN=$P(^(0),U) ; VA PT SEX
 . S BMESLNAM=$P(BMESFULN,",",1) ; VA PT FULL LAST NAME
 . S BMEMRATE=$E(BMEREC,355,358) ;AHCCCS Rate Code-Ck for Kids Care
 . S BMEMEED=$$EED,BMEMEBD=$$EBD ;AHCCCS PAYMENT TO/FROM DT
 . S BMEMERD=$$ERD,BMECOVTP=$E(BMEREC,106,107) ;Enrollment Dt - CT=Coverage Type)
 . S BMENOCT=0 ;Variable for Not counting New & Updates twice
 . I BMEMRATE>5999&(BMEMRATE<7000) S BMEMKID="Y" S BMEKIDCT=BMEKIDCT+1 N BMEREC,BMEMSSN,BMEMNUM D ^BMEMED0 Q  ;Quit if KIDS CARE-Per J. Hathcoat 1/25/01
 . I BMEMLNAM'=BMESLNAM&(BMENAMCK'=1) S BMESSNCT=BMESSNCT+1 S BMESSNCK="Y" N BMEREC,BMEMSSN,BMEMNUM D ^BMEMED0 Q  ; Quit if no match on Med Name or Last Name
 . I BMEMDOB'=BMESDOB S BMESSNCT=BMESSNCT+1 S BMESSNCK="Y" N BMEREC,BMEMSSN,BMEMNUM D ^BMEMED0 Q  ;Quit on DOB No Match
 . I BMEMSEX'=BMESSEX S BMESSNCT=BMESSNCT+1 S BMESSNCK="Y" N BMEREC,BMEMSSN,BMEMNUM D ^BMEMED0 Q  ;Quit if no match on Sex
 . D NEW,UP0,MED
 . S BMETOTCT=BMETOTCT+1 ;Total Record Count - Regardless of action
 Q
 ;
MED ; -- add eligiblity date(s)/data
 S BMEIEN=$O(^AUPNMCD("B",DFN,0)) Q:'BMEIEN
 Q:$P($G(^AUPNMCD(BMEIEN,11,BMEMEBD,0)),U,2)=BMEMEED  ;Quit if Both Beg/End Match already
 S:'$D(^AUPNMCD(BMEIEN,11,0)) $P(^(0),U,2)="9000004.11D"
 S BMELEBD=$P($G(^AUPNMCD(BMEIEN,11,0)),U,3) ;Last Beg Date entered
 I BMELEBD="" D
 . S $P(^AUPNMCD(BMEIEN,11,0),U,3)=BMEMEBD
 .       . S $P(^AUPNMCD(BMEIEN,11,0),U,4)=$P(^(0),U,4)+1
 . S DR=".01///"_BMEMEBD_";.03////"_BMECOVTP ; Add Beginning DT Only
 . S DIE="^AUPNMCD("_BMEIEN_",11,",DA(1)=BMEIEN,DA=BMEMEBD D ^DIE K DIE,DR,DA,DINUM
 . I BMENOCT=0 S BMEMUPDT=BMEMUPDT+1 D UPDATES^BMEMSTR ;Update Count-Update Master List
 I BMELEBD'="" D
 . S BMELEED=$P($G(^AUPNMCD(BMEIEN,11,BMELEBD,0)),U,2)
 . I BMELEED'="" S $P(^AUPNMCD(BMEIEN,11,0),U,3)=BMEMEBD
 .       . I BMELEED'="" S $P(^AUPNMCD(BMEIEN,11,0),U,4)=$P(^(0),U,4)+1
 . I BMELEED'="" S DR=".01///"_BMEMEBD_";03////"_BMECOVTP ; Add Beg DT Only
 . I BMELEED'="" S DIE="^AUPNMCD("_BMEIEN_",11,",DA(1)=BMEIEN,DA=BMEMEBD D ^DIE K DIE,DR,DA,DINUM I BMENOCT=0 S BMEMUPDT=BMEMUPDT+1 D UPDATES^BMEMSTR Q
 . D STILLACT^BMEMSTR ;Existing Patient fell through-Still Active Only/no Update
 Q
 ;
NEW ; -- create new entry in medicaid eligible
 Q:$O(^AUPNMCD("B",+DFN,0))  ;Quit if already in Medicaid Eligibility File
 D ^XBFMK K DIADD,DINUM
 S X=DFN,DIC="^AUPNMCD(",DIC(0)="L",DLAYGO=9000004
 S DIC("DR")=".02////"_BMEINS_";.03////"_BMEMNUM_";.04////"_3_";2101////"_BMEMFULN
 S DIC("DR")=DIC("DR")_";.07////"_BMESSEX_";.08////"_DT_";.12////"_BMEMRATE
 ;K DD,DO
 D FILE^DICN S BMEIEN=+Y D ^XBFMK K DIADD,DINUM
 S BMEMNEW=BMEMNEW+1 ;Counter for New Adds to Medicaid Eligibility file
 S BMENOCT=1 ;Don't count again on Date Updates UP0
 D NEW^BMEMSTR
 Q
 ;
UP0 ; -- update 0th node - Patient Demographics Only
 S BMEIEN=$O(^AUPNMCD("B",DFN,0)) Q:'BMEIEN
 S:'$P(^AUPNMCD(BMEIEN,0),U,2) $P(^AUPNMCD(BMEIEN,0),U,2)=BMEINS
 S:'$P(^AUPNMCD(BMEIEN,0),U,3) $P(^AUPNMCD(BMEIEN,0),U,3)=BMEMNUM
 S:'$P(^AUPNMCD(BMEIEN,0),U,4) $P(^AUPNMCD(BMEIEN,0),U,4)=3
 S DIE="^AUPNMCD(",DA=BMEIEN,DR="2101////"_BMEMFULN_";.08////"_DT_";.12////"_BMEMRATE
 D ^DIE K DIE,DR,DA
 ;I BMENOCT=0 S BMEMUPDT=BMEMUPDT+1 ;Counter for Updates only to Medicaid Eligibility File
 Q
 ;
END ; -- cleanup       
 S BMEGTOT=BMEGTOT-1
 ;W !!,"End of Download Update!!!",!
 ;W !!
 ;W "Total Records Processed: "_BMEGTOT
 ;W !,"Total Action Records Process: "_BMETOTCT
 ;W !,"Total New Records Added: "_BMEMNEW
 ;W !,"Total Updated Records: "_BMEMUPDT
 ;W !,"Total Records with SSN Match Only: "_BMESSNCT
 ;W !!,"Total KID's Care: "_BMEKIDCT
 ;
 K BMEIFN,DFN,BMEIEN,BMEMEED,BMEMEBD,BMECOVTP,BMEMNUM,BMEMSEX,BMEREC,BMECNT,BMEMFULN,BMEFNAM,BMENAMCK,MEDNAME,BMEMIEN,BMEFNAM,BMEMDOB,BMEMRATE
 K BMEMNEW,BMEMUPDT,BMESSNCT,BMETOTCT,BMENOCT,BMEGTOT,BMEBTIME,BMEMKID,BMEKIDCT,BMEETIME
 Q
 ;
EED() ; -- eligibility end date
 ;N X,Y S X=$E(BMEREC,412,419) D ^%DT Q Y
 N X,Y S BMEYYYY=$E(BMEREC,412,415),BMEMMDD=$E(BMEREC,416,419)
 S BMEMEED=BMEMMDD_BMEYYYY
 S X=BMEMEED D ^%DT Q Y
 ;
EBD() ; -- eligibility beg date
 ;N X,Y S X=$E(BMEREC,404,411) D ^%DT Q Y
 N X,Y S BMEYYYY=$E(BMEREC,347,350),BMEMMDD=$E(BMEREC,351,354)
 S BMEMEBD=BMEMMDD_BMEYYYY
 S X=BMEMEBD D ^%DT Q Y
 ;
EHIS() ; -- eligibilities after date/flag
 N X1,X2,X S X1=DT,X2=-180 D C^%DTC Q X
 ;
HRCN() ;EP; -- IHS health record number
 Q $P($G(^AUPNPAT(+$G(DFN),41,+$G(DUZ(2)),0)),"^",2)
 ;
ERD() ;EP -- Eligibility Enrollment Dt (Same as Beg Date on Roster)
 ;Roster Positions 347-354
 N X,Y S BMEYYYY=$E(BMEREC,347,350),BMEMMDD=$E(BMEREC,351,354)
 S BMEMERD=BMEMMDD_BMEYYYY
 S X=BMEMERD D ^%DT Q Y
 ;N X,Y S X=$E(BMEREC,404,411) D ^%DT Q Y
 ;
DOB() ;EP - Date of AHCCCS Birth Date Conversion
 N X,Y S BMEYYYY=$E(BMEREC,143,146),BMEMMDD=$E(BMEREC,147,150)
 S BMEMDOB=BMEMMDD_BMEYYYY
 S X=BMEMDOB D ^%DT Q Y
 ;
LOG ;Update BME MEDICAL ELIGIBLE DOWNLOAD LOG
 ;W !!,"The Download Process is Now Complete!!"
 ;W !!,"I will now update the Download Log with the final run documentation",!
 ;The .01 Entry is Today's Date at time of run - BMEBTIME Variable
 D ^XBFMK K DIADD,DINUM
 S X=BMEBTIME,DIC="^BMEMLOG(",DIC(0)="L",DLAYGO=90333
 S DIC("DR")=".02////"_BMEETIME_";.03////"_BMEGTOT_";.04///"_BMETOTCT_";.05////"_BMESSNCT_";1///"_BMEKIDCT
 S DIC("DR")=DIC("DR")_";.06////"_BMEMNEW_";.07////"_BMEMUPDT_";.08////"_BMEFILE
 D FILE^DICN S IEN=+Y D ^XBFMK K DIADD,DINUM
 ;
 ;W !!,"Log File Updated",!
 ;
 Q
 ;
END2 ;Abnormal Termination - Medicaid Insurer missing from Insurer File
 ;W !,"The Insurer - ARIZONA MEDICAID -missing from the Insurer File",!
 ;W !,"The Initial Process of creating the BMEGMED Global is complete",!
 ;W "however, the Update Run (BMEMED) cannot be ran - See your Site Manager",!!
 Q
 ;
MEDNAME ;Check Med Elig Medicaid Name-If exists for match
 ;
 S BMENAMCK=0
 S BMEMIEN=$O(^AUPNMCD("B",+DFN,0))
 Q:'BMEMIEN
 S BMEMEDNA=$P($G(^AUPNMCD(BMEMIEN,21)),U,1)
 Q:BMEMEDNA=""
 I BMEMEDNA=BMEMFULN S BMENAMCK=1
 Q
 ;
MEDNUM ;Check Med Elig Number against RPMS
 ;
 S BMENUMCK=0
 S BMEMIEN=$O(^AUPNMCD("AE",BMEMNUM,0))
 Q:'BMEMIEN
 S BMEMEDNU=$P($G(^AUPNMCD(BMEMIEN,0)),U,3)
 Q:BMEMEDNU=""
 I BMEMEDNU=BMEMNUM S BMENUMCK=1 S DFN=$P($G(^AUPNMCD(BMEMIEN,0)),U,1)
 Q
 ;
