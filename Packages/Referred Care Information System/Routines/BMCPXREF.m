BMCPXREF ; IHS/PHXAO/TMJ - FIX X-REF FOR PO FISCAL YEAR ;  
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
 S U="^"
 S RIEN=0 ;RCIS REF IEN on RCIS Side
 S BMCCT=0 ;Counter -on Re-Index Referrals
START ;START $O OF REFERRALS
 F  S RIEN=$O(^BMCREF(RIEN)) Q:RIEN'=+RIEN  D
 . ;GET THE RCIS PATIENT DEMOGRAPHICS
 . S BMCR=$P(^BMCREF(RIEN,0),U,1)    ;.01 RCIS Date Referral Initiated
 . S BMCRNUM=$P(^BMCREF(RIEN,0),U,2) ;.02 RCIS Referral Number
 . ;
 . S RCIEN=0 ;PO IEN on RCIS Side (CHS AUTH Multiple)
 . F  S RCIEN=$O(^BMCREF(RIEN,41,RCIEN)) Q:RCIEN'=+RCIEN  D
 . . D FIX ;Re-Index the PO Authorization Fiscal Year
 ;
 ;
 W !!,"(1)  Re-Indexed Total Number of Referrals: ",?30,BMCCT,!
 DO END
 QUIT
 ;
FIX ;RE-INDEX PO AUTH # FISCAL YEAR TRIGGER
 S BMCFY=$P($G(^BMCREF(RIEN,41,RCIEN,11)),U,1)
 Q:BMCFY'=""  ;Quit if FY Value already exists in PO FY
 S DA=RCIEN
 Q:'DA
 ;
 S DA(1)=RIEN
 S DIK="^BMCREF("_DA(1)_",""41"","
 S DIK(1)=".08"
 D EN1^DIK
 S BMCCT=BMCCT+1
 W !,"RE-INDEXED REFERRAL #:   "_RIEN,?50,"PO IEN: "_RCIEN
 ;
 Q
 ;
END ;End of Routine
 W !,"Finished Re-Indexing the PO Authorization Fiscal Year",!
 K RIEN,RCIEN,BMCCT,D,D0,BMCFY
