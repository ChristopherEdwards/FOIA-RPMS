BGP2YN ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PED SPIDER DXS
 ;
 ; This routine loads Taxonomy BGP PED SPIDER DXS
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
 ;;21,"989.5 ")
 ;;1
 ;;9002226,1703,.01)
 ;;BGP PED SPIDER DXS
 ;;9002226,1703,.02)
 ;;@
 ;;9002226,1703,.04)
 ;;@
 ;;9002226,1703,.06)
 ;;@
 ;;9002226,1703,.08)
 ;;0
 ;;9002226,1703,.09)
 ;;3120219
 ;;9002226,1703,.11)
 ;;@
 ;;9002226,1703,.12)
 ;;31
 ;;9002226,1703,.13)
 ;;1
 ;;9002226,1703,.14)
 ;;@
 ;;9002226,1703,.15)
 ;;80
 ;;9002226,1703,.16)
 ;;@
 ;;9002226,1703,.17)
 ;;@
 ;;9002226,1703,3101)
 ;;@
 ;;9002226.02101,"1703,989.5 ",.01)
 ;;989.5 
 ;;9002226.02101,"1703,989.5 ",.02)
 ;;989.5 
 ;
OTHER ; OTHER ROUTINES
 Q
