APCLTXB ; IHS/OHPRD/TMJ -CREATED BY ^ATXSTX ON JAN 09, 1997 ;
 ;;3.0;IHS PCC REPORTS;;FEB 05, 1997
 ;;APCL DIABETES REG NEW CASE
 ;
 ; This routine loads Taxonomy APCL DIABETES REG NEW CASE
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 D OTHER
 I $O(^TMP("ATX",$J,3.6,0)) D BULL^ATXSTX2
 I $O(^TMP("ATX",$J,9002226,0)) D TAX^ATXSTX2
 D KILL^ATXSTX2
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;3.6,119,.01)
 ;;APCL DIABETES REG NEW CASE
 ;;3.6,119,2)
 ;;DM NEW CASE
 ;;3.63,119,1,0)
 ;;^^11^11^2960820^^^
 ;;3.63,119,1,1,0)
 ;;The following patient
 ;;3.63,119,1,2,0)
 ;;     Patient Name: |2|   Chart No.: |99|
 ;;3.63,119,1,3,0)
 ;;was seen on |3| at |15|
 ;;3.63,119,1,4,0)
 ;;with the following diagnosis:
 ;;3.63,119,1,5,0)
 ;;     ICD9 Code: |1|  ICD Description: |8|
 ;;3.63,119,1,6,0)
 ;;     Provider Stated: |4|
 ;;3.63,119,1,7,0)
 ;; 
 ;;3.63,119,1,8,0)
 ;;This is the first time that this patient has been seen for the
 ;;3.63,119,1,9,0)
 ;;diabetes diagnosis listed above.  This patient/visit may require
 ;;3.63,119,1,10,0)
 ;;your follow-up.  Please review the patient's medical record at your
 ;;3.63,119,1,11,0)
 ;;earliest convenience for further information.
 ;;3.63,119,3,0)
 ;;2^^2^2^2960820^^
 ;;3.63,119,3,1,0)
 ;;This bulletin will be sent to diabetes control officer when a patient
 ;;3.63,119,3,2,0)
 ;;is seen for the first time for a dm diagnosis
 ;;21,"250.00 ")
 ;;1
 ;;21,"648.81 ")
 ;;2
 ;;9002226,92,.01)
 ;;APCL DIABETES REG NEW CASE
 ;;9002226,92,.02)
 ;;APCL - FOR NEW DM CASES
 ;;9002226,92,.04)
 ;;@
 ;;9002226,92,.06)
 ;;@
 ;;9002226,92,.08)
 ;;1
 ;;9002226,92,.09)
 ;;2940609
 ;;9002226,92,.11)
 ;;B
 ;;9002226,92,.12)
 ;;31
 ;;9002226,92,.13)
 ;;1
 ;;9002226,92,.14)
 ;;BA
 ;;9002226,92,.15)
 ;;80
 ;;9002226,92,.16)
 ;;1
 ;;9002226,92,.17)
 ;;@
 ;;9002226,92,3101)
 ;;D ^APCLDMNC
 ;;9002226.02101,"92,250.00 ",.01)
 ;;250.00
 ;;9002226.02101,"92,250.00 ",.02)
 ;;250.93
 ;;9002226.02101,"92,648.81 ",.01)
 ;;648.81
 ;;9002226.02101,"92,648.81 ",.02)
 ;;648.84
 ;
OTHER ; OTHER ROUTINES
 Q
