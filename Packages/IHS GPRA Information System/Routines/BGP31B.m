BGP31B ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 02, 2012;
 ;;13.0;IHS CLINICAL REPORTING;;NOV 20, 2012;Build 81
 ;;BGP TOPICAL FLUORIDE DXS
 ;
 ; This routine loads Taxonomy BGP TOPICAL FLUORIDE DXS
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
 ;;21,"V07.31 ")
 ;;1
 ;;9002226,1735,.01)
 ;;BGP TOPICAL FLUORIDE DXS
 ;;9002226,1735,.02)
 ;;@
 ;;9002226,1735,.04)
 ;;@
 ;;9002226,1735,.06)
 ;;@
 ;;9002226,1735,.08)
 ;;@
 ;;9002226,1735,.09)
 ;;3120802
 ;;9002226,1735,.11)
 ;;@
 ;;9002226,1735,.12)
 ;;31
 ;;9002226,1735,.13)
 ;;1
 ;;9002226,1735,.14)
 ;;@
 ;;9002226,1735,.15)
 ;;80
 ;;9002226,1735,.16)
 ;;@
 ;;9002226,1735,.17)
 ;;@
 ;;9002226,1735,3101)
 ;;@
 ;;9002226.02101,"1735,V07.31 ",.01)
 ;;V07.31 
 ;;9002226.02101,"1735,V07.31 ",.02)
 ;;V07.31 
 ;
OTHER ; OTHER ROUTINES
 Q