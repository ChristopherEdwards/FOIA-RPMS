BJPC2XR ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON JUN 23, 2008 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;;APCL INJ FIRE
 ;
 ; This routine loads Taxonomy APCL INJ FIRE
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
 ;;21,"E890.0 ")
 ;;1
 ;;21,"E929.4 ")
 ;;2
 ;;21,"E988.1 ")
 ;;3
 ;;9002226,213,.01)
 ;;APCL INJ FIRE
 ;;9002226,213,.02)
 ;;APCL FIRE ECODES
 ;;9002226,213,.04)
 ;;n
 ;;9002226,213,.06)
 ;;@
 ;;9002226,213,.08)
 ;;1
 ;;9002226,213,.09)
 ;;2961021.135441
 ;;9002226,213,.11)
 ;;@
 ;;9002226,213,.12)
 ;;157
 ;;9002226,213,.13)
 ;;1
 ;;9002226,213,.14)
 ;;BA
 ;;9002226,213,.15)
 ;;80
 ;;9002226,213,.16)
 ;;1
 ;;9002226,213,.17)
 ;;@
 ;;9002226,213,3101)
 ;;@
 ;;9002226.02101,"213,E890.0 ",.01)
 ;;E890.0
 ;;9002226.02101,"213,E890.0 ",.02)
 ;;E899.
 ;;9002226.02101,"213,E929.4 ",.01)
 ;;E929.4
 ;;9002226.02101,"213,E929.4 ",.02)
 ;;E929.4
 ;;9002226.02101,"213,E988.1 ",.01)
 ;;E988.1
 ;;9002226.02101,"213,E988.1 ",.02)
 ;;E988.2
 ;
OTHER ; OTHER ROUTINES
 Q