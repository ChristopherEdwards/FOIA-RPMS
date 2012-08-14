APCHTXC ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON JAN 22, 2004; [ 09/24/04  2:06 PM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**11,12**;JAN 22, 2004
 ;;APCH ISCHEMIC HEART DISEASE
 ;
 ; This routine loads Taxonomy APCH ISCHEMIC HEART DISEASE
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
 ;;21,"410.0 ")
 ;;1
 ;;21,"414.0 ")
 ;;2
 ;;21,"428.0 ")
 ;;3
 ;;21,"429.2 ")
 ;;4
 ;;9002226,708,.01)
 ;;APCH ISCHEMIC HEART DISEASE
 ;;9002226,708,.02)
 ;;@
 ;;9002226,708,.04)
 ;;@
 ;;9002226,708,.06)
 ;;@
 ;;9002226,708,.08)
 ;;0
 ;;9002226,708,.09)
 ;;3030731
 ;;9002226,708,.11)
 ;;@
 ;;9002226,708,.12)
 ;;31
 ;;9002226,708,.13)
 ;;1
 ;;9002226,708,.14)
 ;;@
 ;;9002226,708,.15)
 ;;80
 ;;9002226,708,.16)
 ;;@
 ;;9002226,708,.17)
 ;;@
 ;;9002226,708,3101)
 ;;@
 ;;9002226.02101,"708,410.0 ",.01)
 ;;410.0 
 ;;9002226.02101,"708,410.0 ",.02)
 ;;412. 
 ;;9002226.02101,"708,414.0 ",.01)
 ;;414.0 
 ;;9002226.02101,"708,414.0 ",.02)
 ;;414.9 
 ;;9002226.02101,"708,428.0 ",.01)
 ;;428.0 
 ;;9002226.02101,"708,428.0 ",.02)
 ;;428.9 
 ;;9002226.02101,"708,429.2 ",.01)
 ;;429.2 
 ;;9002226.02101,"708,429.2 ",.02)
 ;;429.2 
 ;
OTHER ; OTHER ROUTINES
 Q