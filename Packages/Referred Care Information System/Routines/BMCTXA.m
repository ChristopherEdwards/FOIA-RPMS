BMCTXA ; IHS/PHXAO/TMJ -CREATED BY ^ATXSTX ON APR 12, 1996 ; 
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;;BMC 3RD PARTY LIABILITY ALERT
 ;
 ; This routine loads Taxonomy BMC 3RD PARTY LIABILITY ALERT
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
 ;;3.6,148,.01)
 ;;BMC RCIS ALERT 3RD PARTY
 ;;3.6,148,2)
 ;;POSSIBLE 3RD PARTY LIABILITY
 ;;3.63,148,1,0)
 ;;^^6^6^2951228^^^^
 ;;3.63,148,1,1,0)
 ;;Patient Name: |1|    Date Referral Initiated:  |2|
 ;;3.63,148,1,2,0)
 ;;Referral #:  |3|  
 ;;3.63,148,1,3,0)
 ;;Requesting Provider:  |4|
 ;;3.63,148,1,4,0)
 ;; 
 ;;3.63,148,1,5,0)
 ;;This referral is for a diagnostic category that may involve third party
 ;;3.63,148,1,6,0)
 ;;liability.
 ;;3.63,148,3,0)
 ;;^^4^4^2951228^^^^
 ;;3.63,148,3,1,0)
 ;;This bulletin is sent to the CHS supervisor if the referral is a type
 ;;3.63,148,3,2,0)
 ;;CHS.  It is sent to the business office if it is a type IHS.  In either
 ;;3.63,148,3,3,0)
 ;;case it is sent to the RCIS Case Manager.  If it is type OTHER no
 ;;3.63,148,3,4,0)
 ;;bulletin is sent.
 ;;3.64,"148,1",.01)
 ;;1
 ;;3.64,"148,1",1,0)
 ;;^^1^1^2951109^
 ;;3.64,"148,1",1,1,0)
 ;;Name of patient being referred.
 ;;3.64,"148,2",.01)
 ;;2
 ;;3.64,"148,2",1,0)
 ;;^^1^1^2951109^
 ;;3.64,"148,2",1,1,0)
 ;;Date referral initiated.
 ;;3.64,"148,3",.01)
 ;;3
 ;;3.64,"148,3",1,0)
 ;;^^1^1^2951109^
 ;;3.64,"148,3",1,1,0)
 ;;Ten character referral number.
 ;;3.64,"148,4",.01)
 ;;4
 ;;3.64,"148,4",1,0)
 ;;^^1^1^2951228^^^
 ;;3.64,"148,4",1,1,0)
 ;;Name of provider requesting referral.
 ;;21,"800.00 ")
 ;;1
 ;;9002226,116,.01)
 ;;BMC 3RD PARTY LIABILITY ALERT
 ;;9002226,116,.02)
 ;;POSSIBLE THIRD PARTY LIABILITY
 ;;9002226,116,.04)
 ;;n
 ;;9002226,116,.08)
 ;;0
 ;;9002226,116,.09)
 ;;2951201
 ;;9002226,116,.12)
 ;;31
 ;;9002226,116,.13)
 ;;1
 ;;9002226,116,.14)
 ;;BA
 ;;9002226,116,.15)
 ;;80
 ;;9002226,116,.16)
 ;;1
 ;;9002226.02101,"116,800.00 ",.01)
 ;;800.00
 ;;9002226.02101,"116,800.00 ",.02)
 ;;994.9
 ;
OTHER ; OTHER ROUTINES
 Q
