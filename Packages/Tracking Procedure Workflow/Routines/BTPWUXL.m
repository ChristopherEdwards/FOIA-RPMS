BTPWUXL ;VNGT/HS/ALA-CREATED BY ^ATXSTX ON JAN 14, 2010;
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;;BGP HYSTERECTOMY PROCEDURES
 ;
 ; This routine loads Taxonomy BGP HYSTERECTOMY PROCEDURES
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
 ;;21,"68.4 ")
 ;;1
 ;;9002226,727,.01)
 ;;BGP HYSTERECTOMY PROCEDURES
 ;;9002226,727,.02)
 ;;HYSTERECTOMY PROCEDURES
 ;;9002226,727,.04)
 ;;n
 ;;9002226,727,.06)
 ;;@
 ;;9002226,727,.08)
 ;;0
 ;;9002226,727,.09)
 ;;3050208
 ;;9002226,727,.11)
 ;;@
 ;;9002226,727,.12)
 ;;255
 ;;9002226,727,.13)
 ;;1
 ;;9002226,727,.14)
 ;;@
 ;;9002226,727,.15)
 ;;80.1
 ;;9002226,727,.16)
 ;;@
 ;;9002226,727,.17)
 ;;@
 ;;9002226,727,3101)
 ;;@
 ;;9002226.02101,"727,68.4 ",.01)
 ;;68.4 
 ;;9002226.02101,"727,68.4 ",.02)
 ;;68.8
 ;
OTHER ; OTHER ROUTINES
 Q