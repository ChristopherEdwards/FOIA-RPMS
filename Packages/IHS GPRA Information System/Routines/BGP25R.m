BGP25R ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP SUICIDAL IDEATION DXS
 ;
 ; This routine loads Taxonomy BGP SUICIDAL IDEATION DXS
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
 ;;21,"V62.84 ")
 ;;1
 ;;9002226,1505,.01)
 ;;BGP SUICIDAL IDEATION DXS
 ;;9002226,1505,.02)
 ;;@
 ;;9002226,1505,.04)
 ;;@
 ;;9002226,1505,.06)
 ;;@
 ;;9002226,1505,.08)
 ;;0
 ;;9002226,1505,.09)
 ;;3120216
 ;;9002226,1505,.11)
 ;;@
 ;;9002226,1505,.12)
 ;;31
 ;;9002226,1505,.13)
 ;;1
 ;;9002226,1505,.14)
 ;;@
 ;;9002226,1505,.15)
 ;;80
 ;;9002226,1505,.16)
 ;;@
 ;;9002226,1505,.17)
 ;;@
 ;;9002226,1505,3101)
 ;;@
 ;;9002226.02101,"1505,V62.84 ",.01)
 ;;V62.84 
 ;;9002226.02101,"1505,V62.84 ",.02)
 ;;V62.84 
 ;
OTHER ; OTHER ROUTINES
 Q
