BMEMED0 ; IHS/PHXAO/TMJ - STUFF MEDICAID SCRATCH INTO FILEMAN FILE ; [ 06/11/03  3:27 PM ]
 ;1.0;AZA MEDICAID ELIGIBILITY FILES;MARCH 14, 1994
 ;
 ;This Routine is called from AZAMED Routine when
 ;a NO MATCH Record is hit.  This Routine populates the
 ;Temporary Monthly No Match File ^AZAMED(Global
 ;This File is utilized to manually compare and update
 ;Patient Registration
 ;
 ; -- new necessary variables
 ;N NAME,SEX,DOB,RES,NUM,RACE,CT,RESCE,EBD,EED,SSN,IEN
 ;
 ; -- set up variables for stuff in AHCCCS Medicaid File
SET S N=^AZAGMED(IFN)
 S FNAME=$E(N,131,140),LNAME=$E(N,108,130)
 S FNAME=$P(FNAME," ",1),LNAME=$P(LNAME," ",1) ;Strip out spaces in both names
 S MFULNAME=LNAME_","_FNAME
 S CITY=$E(N,286,305),STATE=$E(N,306,307)
 S CITY=$P(CITY," ",1) S RES=CITY_", "_STATE
 S SEX=$E(N,142,142),DOB=$E(N,143,150),MRATE=$E(N,355,358)
 S NUM=$E(N,18,26),CT=$E(N,106,107),RESCE=$E(N,17,17)
 S MZIP=$E(N,223,227) ;Get Medicaid File Zip code
 S MCOUNTY=$E(N,91,105) S MCTYNAME=$P(MCOUNTY," ",1) ;Strip out spaces
 ;
 ;NEED TO GET COUNTY IEN FOR CHECK - THE "B" IS AN IEN ON PTR.
 ;WENT HOME FOR THE WEEKEND - I'M TIRED.
 Q:$L(MCTYNAME)=0  ;Quit if No Medicaid County Name
 S SCOUNTY=$O(^AZAMEDZP(1180004,"C",MCTYNAME,0)) ;Check to see if AHCCCS County Name is in the (COUNTY SCREEN) File
 S SSN=$E(N,27,35)
 ;
 I 'SCOUNTY Q  ;Quit if Not in County Table
 ;
DATE ;AHCCCS Dates (Y2K Conversion)
 S EBD=$$EBD ;AHCCCS Payment From Date/Beg
 S EED=$$EED ; AHCCCS Payment From/End
 S DOB=$$DOB ;AHCCCS Date of Birth
 S ERD=$$ERD ; Enrollment Date
 ;Q:"AIAN"'[RACE
 Q:EBD=-1  ;Quit if no AHCCCS Beg Elig Dt in MED File
 Q:EED=-1  ;Quit if no AHCCCS End Elig Dt in MED File
 ;
 D NEW
 Q
 ;
NEW ; -- create new entry in local AZA MEDICAID ELIGIBLE (NO SSN) File-Global ^AZAMED(
 ;Do not stuff the Medicaid End Elig Dt (EED Variable)
 ;Only stuff the Mediciad Beg Elig Dt (EEB/ERD Variables)
 D ^XBFMK K DIADD,DINUM
 S X=EBD,DIC="^AZAMED(",DIC(0)="L",DLAYGO=1180004
 ;S DIC("DR")=".02////"_FNAME
 S DIC("DR")=".02////"_MFULNAME_";.03////"_SEX_";.04///"_DOB_";.05////"_RES
 S DIC("DR")=DIC("DR")_";.06////"_NUM_";.08////"_CT_";4////"_MRATE
 S DIC("DR")=DIC("DR")_";1////"_SSN_";2////"_RESCE_";.09////"_EED
 ;I DUZ=5703 W !!  ZW  W !!  ;DEBUG
 I SSNMATCH="Y" S DIC("DR")=DIC("DR")_";3///"_SSNMATCH
 I MKID="Y" S DIC("DR")=DIC("DR")_";5///"_MKID
 D FILE^DICN D ^XBFMK K DIADD,DINUM
 Q
 ;
EED() ; -- eligibility end date
 ;N X,Y S X=$E(N,406,411) D ^%DT Q Y
 N X,Y S YYYY=$E(N,412,415),MMDD=$E(N,416,419)
 S EED=MMDD_YYYY
 S X=EED D ^%DT Q Y
 ;
EBD() ; -- eligibility begin date
 ;N X,Y S X=$E(N,406,411) D ^%DT Q Y
 N X,Y S YYYY=$E(N,347,350),MMDD=$E(N,351,354)
 S EBD=MMDD_YYYY
 S X=EBD D ^%DT Q Y
 ;
ERD() ; -- Med Enrollment Dt 
 ;N X,Y S X=$E(N,406,411) D ^%DT Q Y
 N X,Y S YYYY=$E(N,347,350),MMDD=$E(N,351,354)
 S ERD=MMDD_YYYY
 S X=ERD D ^%DT Q Y
 ;
DOB() ;Date of Birth Conversion
 N X,Y S YYYY=$E(DOB,1,4),MMDD=$E(DOB,5,8)
 S DOB=MMDD_YYYY
 S X=DOB D ^%DT Q Y
 ;
