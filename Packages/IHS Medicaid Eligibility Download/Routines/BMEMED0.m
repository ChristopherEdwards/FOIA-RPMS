BMEMED0 ; IHS/PHXAO/TMJ - STUFF NO MATCH ENTRIES INTO MONTHLY TEMP FILE ; 
 ;;1.0T1;MEDICAID ELIGIBILITY DOWNLOAD;;JUN 25, 2003
 ;
 ;This Routine is called from BMEMED Routine when
 ;a NO MATCH Record is hit.  This Routine populates the
 ;Temporary Monthly No Match File ^BMETMED(Global
 ;This File is utilized to manually compare and automatically update
 ;Patient Registration
 ;
 ;
 ; -- set up variables for stuff in AHCCCS Medicaid File
SET S BMEREC=^BMEGMED(BMEIFN)
 S BMEFNAME=$E(BMEREC,131,140),BMELNAME=$E(BMEREC,108,130)
 S BMEFNAME=$P(BMEFNAME," ",1),BMELNAME=$P(BMELNAME," ",1) ;Strip out spaces in both names
 S BMEMFULN=BMELNAME_","_BMEFNAME
 S BMECITY=$E(BMEREC,286,305),BMESTATE=$E(BMEREC,306,307)
 S BMECITY=$P(BMECITY," ",1) S RES=BMECITY_", "_BMESTATE
 S BMESEX=$E(BMEREC,142,142),BMEMDOB=$E(BMEREC,143,150),BMEMRATE=$E(BMEREC,355,358)
 S BMENUM=$E(BMEREC,18,26),BMECOVTP=$E(BMEREC,106,107),BMERESCE=$E(BMEREC,17,17)
 S BMEMZIP=$E(BMEREC,223,227) ;Get Medicaid File Zip code
 S BMEMCNTY=$E(BMEREC,91,105) S BMEMCTYN=$P(BMEMCNTY," ",1) ;Strip out spaces
 ;
 ;NEED TO GET COUNTY IEN FOR CHECK - THE "B" IS AN IEN ON PTR.
 Q:$L(BMEMCTYN)=0  ;Quit if No Medicaid County Name
 S BMESCNTY=$O(^BMECTY("C",BMEMCTYN,0)) ;Check to see if AHCCCS County Name is in the (COUNTY SCREEN) File
 S BMEMSSN=$E(BMEREC,27,35)
 ;
 I 'BMESCNTY Q  ;Quit if Not in County Table
 ;
DATE ;AHCCCS Dates (Y2K Conversion)
 S BMEMEBD=$$EBD ;AHCCCS Payment From Date/Beg
 S BMEMEED=$$EED ; AHCCCS Payment From/End
 S BMEMDOB=$$DOB ;AHCCCS Date of Birth
 S BMEMERD=$$ERD ; Enrollment Date
 ;Q:"AIAN"'[RACE
 Q:BMEMEBD=-1  ;Quit if no AHCCCS Beg Elig Dt in MED File
 Q:BMEMEED=-1  ;Quit if no AHCCCS End Elig Dt in MED File
 ;
 D NEW
 Q
 ;
NEW ; -- create new entry in local BME MEDICAID ELIGIBLE (NO MATCH) File-Global ^BMETMED(
 ;Do not stuff the Medicaid End Elig Dt (EED Variable)
 ;Only stuff the Mediciad Beg Elig Dt (EEB/ERD Variables)
 D ^XBFMK K DIADD,DINUM
 S X=BMEMEBD,DIC="^BMETMED(",DIC(0)="L",DLAYGO=90332
 ;S DIC("DR")=".02////"_BMEFNAME
 S DIC("DR")=".02////"_BMEMFULN_";.03////"_BMESEX_";.04///"_BMEMDOB_";.05////"_RES
 S DIC("DR")=DIC("DR")_";.06////"_BMENUM_";.08////"_BMECOVTP_";4////"_BMEMRATE
 S DIC("DR")=DIC("DR")_";1////"_BMEMSSN_";2////"_BMERESCE_";.09////"_BMEMEED
 I BMESSNCK="Y" S DIC("DR")=DIC("DR")_";3///"_BMESSNCK
 I BMEMKID="Y" S DIC("DR")=DIC("DR")_";5///"_BMEMKID
 D FILE^DICN D ^XBFMK K DIADD,DINUM
 Q
 ;
EED() ; -- eligibility end date
 ;N X,Y S X=$E(BMEREC,406,411) D ^%DT Q Y
 N X,Y S BMEYYYY=$E(BMEREC,412,415),BMEMMDD=$E(BMEREC,416,419)
 S BMEMEED=BMEMMDD_BMEYYYY
 S X=BMEMEED D ^%DT Q Y
 ;
EBD() ; -- eligibility begin date
 ;N X,Y S X=$E(BMEREC,406,411) D ^%DT Q Y
 N X,Y S BMEYYYY=$E(BMEREC,347,350),BMEMMDD=$E(BMEREC,351,354)
 S BMEMEBD=BMEMMDD_BMEYYYY
 S X=BMEMEBD D ^%DT Q Y
 ;
ERD() ; -- Med Enrollment Dt 
 ;N X,Y S X=$E(BMEREC,406,411) D ^%DT Q Y
 N X,Y S BMEYYYY=$E(BMEREC,347,350),BMEMMDD=$E(BMEREC,351,354)
 S BMEMERD=BMEMMDD_BMEYYYY
 S X=BMEMERD D ^%DT Q Y
 ;
DOB() ;Date of Birth Conversion
 N X,Y S BMEYYYY=$E(BMEMDOB,1,4),BMEMMDD=$E(BMEMDOB,5,8)
 S BMEMDOB=BMEMMDD_BMEYYYY
 S X=BMEMDOB D ^%DT Q Y
 ;
