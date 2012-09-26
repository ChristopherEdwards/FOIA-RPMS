BGP28G ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PED CB DXS
 ;
 ; This routine loads Taxonomy BGP PED CB DXS
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
 ;;21,"650. ")
 ;;1
 ;;9002226,1567,.01)
 ;;BGP PED CB DXS
 ;;9002226,1567,.02)
 ;;@
 ;;9002226,1567,.04)
 ;;@
 ;;9002226,1567,.06)
 ;;@
 ;;9002226,1567,.08)
 ;;0
 ;;9002226,1567,.09)
 ;;3120218
 ;;9002226,1567,.11)
 ;;@
 ;;9002226,1567,.12)
 ;;31
 ;;9002226,1567,.13)
 ;;1
 ;;9002226,1567,.14)
 ;;@
 ;;9002226,1567,.15)
 ;;80
 ;;9002226,1567,.16)
 ;;@
 ;;9002226,1567,.17)
 ;;@
 ;;9002226,1567,3101)
 ;;@
 ;;9002226.02101,"1567,650. ",.01)
 ;;650. 
 ;;9002226.02101,"1567,650. ",.02)
 ;;650. 
 ;
OTHER ; OTHER ROUTINES
 Q
