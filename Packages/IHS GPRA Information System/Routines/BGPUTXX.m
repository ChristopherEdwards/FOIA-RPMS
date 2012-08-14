BGPUTXX ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON APR 21, 2005 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;;;BGPU;;APR 21, 2005
 ;;BGP EMPHYSEMA DXS
 ;
 ; This routine loads Taxonomy BGP EMPHYSEMA DXS
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
 ;;21,"492.0 ")
 ;;1
 ;;21,"506.4 ")
 ;;2
 ;;21,"518.1 ")
 ;;3
 ;;9002226,395,.01)
 ;;BGP EMPHYSEMA DXS
 ;;9002226,395,.02)
 ;;@
 ;;9002226,395,.04)
 ;;@
 ;;9002226,395,.06)
 ;;@
 ;;9002226,395,.08)
 ;;0
 ;;9002226,395,.09)
 ;;3050320
 ;;9002226,395,.11)
 ;;@
 ;;9002226,395,.12)
 ;;31
 ;;9002226,395,.13)
 ;;1
 ;;9002226,395,.14)
 ;;@
 ;;9002226,395,.15)
 ;;80
 ;;9002226,395,.16)
 ;;@
 ;;9002226,395,.17)
 ;;@
 ;;9002226,395,3101)
 ;;@
 ;;9002226.02101,"395,492.0 ",.01)
 ;;492.0 
 ;;9002226.02101,"395,492.0 ",.02)
 ;;492.8 
 ;;9002226.02101,"395,506.4 ",.01)
 ;;506.4 
 ;;9002226.02101,"395,506.4 ",.02)
 ;;506.4 
 ;;9002226.02101,"395,518.1 ",.01)
 ;;518.1 
 ;;9002226.02101,"395,518.1 ",.02)
 ;;518.2 
 ;
OTHER ; OTHER ROUTINES
 Q