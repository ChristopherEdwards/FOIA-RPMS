BME8340 ; IHS/PHXAO/TMJ - STUFF NO MATCH ENTRIES INTO MONTHLY TEMP FILE ; 
 ;;1.0T1;MEDICAID ELIGIBILITY DOWNLOAD;;JUN 25, 2003
 ;
 ;This Routine is called from BME834 Routine when
 ;a NO MATCH Record is hit.  This Routine populates the
 ;Temporary Monthly No Match File ^BMETMED(Global
 ;This File is utilized to manually compare and automatically update
 ;Patient Registration
 ;
 ;
 ; -- set up variables for stuff in AHCCCS Medicaid File
SET S BMEREC=^BMEHOLD(BMEIFN,0)
 S BMEFNAME=$P($G(BMEREC),U,7),BMELNAME=$P($G(BMEREC),U,8)
 S BMEFNAME=$P(BMEFNAME," ",1),BMELNAME=$P(BMELNAME," ",1) ;Strip out spaces in both names
 S BMEMFULN=BMELNAME_","_BMEFNAME
 S BMECITY=$P($G(^BMEHOLD(BMEIFN,11)),U,6),BMESTATE=$P($G(^BMEHOLD(BMEIFN,11)),U,7)
 S BMECITY=$P(BMECITY," ",1) S RES=BMECITY_", "_BMESTATE
 S BMESEX=$P($G(BMEREC),U,6),BMEMDOB=$P($G(BMEREC),U,5),BMEMRATE=$P($G(BMEREC),U,7)
 S BMENUM=$P($G(BMEREC),U,3),BMECOVTP=$P($G(^BMEHOLD(BMEIFN,11)),U,3)
 S BMEMZIP=$P($G(^BMEHOLD(BMEIFN,11)),U,8) ;Get Medicaid File Zip code
 S BMEMCNTY=$P($G(BMEREC),U,14) ;834 Transaction passes 2 digit Code - not text
 ;
 ;NEED TO GET COUNTY IEN FOR CHECK - THE "B" IS AN IEN ON PTR.
 Q:BMEMCNTY=""  ;Quit if No Medicaid County Number
 S BMESCNTY=$O(^BMECTY("D",BMEMCNTY,0)) ;Check to see if AHCCCS County Code is in the (COUNTY SCREEN) File
 S BMEMSSN=$P($G(BMEREC),U,2)
 ;
 I 'BMESCNTY Q  ;Quit if Not in County Table
 ;
DATE ;AHCCCS Dates (Y2K Conversion)
 S BMEMEBD=$$EBD ;AHCCCS Payment From Date/Beg
 ;S BMEMEED=$$EED ; AHCCCS Payment From/End - No Ending Date Available in 834 Transaction
 S BMEMDOB=$$DOB ;AHCCCS Date of Birth
 S BMEMERD=$$ERD ; Enrollment Date
 ;Q:"AIAN"'[RACE
 Q:BMEMEBD=-1  ;Quit if no AHCCCS Beg Elig Dt in MED File
 ;Q:BMEMEED=-1  ;Quit if no AHCCCS End Elig Dt in MED File
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
 S DIC("DR")=DIC("DR")_";1////"_BMEMSSN
 I BMESSNCK="Y" S DIC("DR")=DIC("DR")_";3///"_BMESSNCK
 I BMEMKID="Y" S DIC("DR")=DIC("DR")_";5///"_BMEMKID
 D FILE^DICN D ^XBFMK K DIADD,DINUM
 Q
 ;
EED() ; -- eligibility end date -No Ending Date in 834 Transaction
 ;N X,Y S X=$E(BMEREC,406,411) D ^%DT Q Y
 ;N X,Y S BMEYYYY=$E(BMEREC,412,415),BMEMMDD=$E(BMEREC,416,419)
 ;S BMEMEED=BMEMMDD_BMEYYYY
 ;S X=BMEMEED D ^%DT Q Y
 ;
EBD() ; -- eligibility begin date
 S BMEMEBD=$P($G(BMEREC),U,4) ;Enrollment Date
 N X,Y S BMEYYYY=$E(BMEMEBD,1,4),BMEMMDD=$E(BMEMEBD,5,8)
 S BMEMEBD=BMEMMDD_BMEYYYY
 S X=BMEMEBD D ^%DT Q Y
 ;
ERD() ; -- Med Enrollment Dt 
 S BMEMERD=$P($G(BMEREC),U,4) ;Enrollment Dt/Beg Dt
 N X,Y S BMEYYYY=$E(BMEMERD,1,4),BMEMMDD=$E(BMEMERD,5,8)
 S BMEMERD=BMEMMDD_BMEYYYY
 S X=BMEMERD D ^%DT Q Y
 ;
DOB() ;Date of Birth Conversion
 N X,Y S BMEYYYY=$E(BMEMDOB,1,4),BMEMMDD=$E(BMEMDOB,5,8)
 S BMEMDOB=BMEMMDD_BMEYYYY
 S X=BMEMDOB D ^%DT Q Y
 ;
