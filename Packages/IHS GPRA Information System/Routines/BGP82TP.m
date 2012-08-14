BGP82TP ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON JUN 09, 2008;
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;;BGP SMOKELESS TOBACCO CPTS
 ;
 ; This routine loads Taxonomy BGP SMOKELESS TOBACCO CPTS
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
 ;;21,"1035F ")
 ;;1
 ;;9002226,795,.01)
 ;;BGP SMOKELESS TOBACCO CPTS
 ;;9002226,795,.02)
 ;;@
 ;;9002226,795,.04)
 ;;@
 ;;9002226,795,.06)
 ;;@
 ;;9002226,795,.08)
 ;;@
 ;;9002226,795,.09)
 ;;3080529
 ;;9002226,795,.11)
 ;;@
 ;;9002226,795,.12)
 ;;455
 ;;9002226,795,.13)
 ;;1
 ;;9002226,795,.14)
 ;;@
 ;;9002226,795,.15)
 ;;81
 ;;9002226,795,.16)
 ;;@
 ;;9002226,795,.17)
 ;;@
 ;;9002226,795,3101)
 ;;@
 ;;9002226.02101,"795,1035F ",.01)
 ;;1035F 
 ;;9002226.02101,"795,1035F ",.02)
 ;;1035F 
 ;
OTHER ; OTHER ROUTINES
 Q