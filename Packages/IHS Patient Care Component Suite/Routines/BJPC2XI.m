BJPC2XI ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON JUN 23, 2008 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
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
 ;;3.6,92,.01)
 ;;APCL DIABETES REG NEW CASE
 ;;3.6,92,2)
 ;;DM NEW CASE
 ;;3.63,92,1,0)
 ;;^3.61A^20^20^3051220^^^^
 ;;3.63,92,1,1,0)
 ;;     Patient Name: |2|                      SSN: |23|
 ;;3.63,92,1,2,0)
 ;;     Chart No.: |99|   DOB: |18|
 ;;3.63,92,1,3,0)
 ;;     
 ;;3.63,92,1,4,0)
 ;;     This patient was seen on |3| at |15|
 ;;3.63,92,1,5,0)
 ;;     with the following diagnosis:
 ;;3.63,92,1,6,0)
 ;;     
 ;;3.63,92,1,7,0)
 ;;     ICD9 Code: |1|  ICD Description: |8|
 ;;3.63,92,1,8,0)
 ;;     Provider Stated: |4|
 ;;3.63,92,1,9,0)
 ;;     Patient's Community: |16|
 ;;3.63,92,1,10,0)
 ;;     Patient's Service Unit: |17|
 ;;3.63,92,1,11,0)
 ;;     Patient's Tribe: |19|
 ;;3.63,92,1,12,0)
 ;;     Tribal Blood Quantum: |21|
 ;;3.63,92,1,13,0)
 ;;     |22|
 ;;3.63,92,1,14,0)
 ;; 
 ;;3.63,92,1,15,0)
 ;;     Patient's Health Records:   |30|   |31|   |32|   |33|   |34|   |35|
 ;;3.63,92,1,16,0)
 ;;|36|   |37|   |38|   |39|
 ;;3.63,92,1,17,0)
 ;; 
 ;;3.63,92,1,18,0)
 ;; 
 ;;3.63,92,1,19,0)
 ;;This is the first time that this patient has been seen for the diabetes
 ;;3.63,92,1,20,0)
 ;;diagnosis listed above.  Please take appropriate follow up action.
 ;;3.63,92,3,0)
 ;;2^3.63^2^2^3051220^^^^
 ;;3.63,92,3,1,0)
 ;;This bulletin will be sent to diabetes control officer when a patient
 ;;3.63,92,3,2,0)
 ;;is seen for the first time for a dm diagnosis
 ;;21,"250.00 ")
 ;;1
 ;;21,"648.81 ")
 ;;2
 ;;9002226,8,.01)
 ;;APCL DIABETES REG NEW CASE
 ;;9002226,8,.02)
 ;;APCL - FOR NEW DM CASES
 ;;9002226,8,.04)
 ;;n
 ;;9002226,8,.06)
 ;;@
 ;;9002226,8,.08)
 ;;1
 ;;9002226,8,.09)
 ;;2940609
 ;;9002226,8,.11)
 ;;B
 ;;9002226,8,.12)
 ;;31
 ;;9002226,8,.13)
 ;;1
 ;;9002226,8,.14)
 ;;BA
 ;;9002226,8,.15)
 ;;80
 ;;9002226,8,.16)
 ;;1
 ;;9002226,8,.17)
 ;;@
 ;;9002226,8,3101)
 ;;D ^APCLDMNC
 ;;9002226.02101,"8,250.00 ",.01)
 ;;250.00
 ;;9002226.02101,"8,250.00 ",.02)
 ;;250.93
 ;;9002226.02101,"8,648.81 ",.01)
 ;;648.81
 ;;9002226.02101,"8,648.81 ",.02)
 ;;648.84
 ;
OTHER ; OTHER ROUTINES
 Q
