APCL29K ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON JUN 12, 2013;
 ;;3.0;IHS PCC REPORTS;**29**;FEB 05, 1997;Build 35
 ;;SURVEILLANCE ENCEPHALOPATHY
 ;
 ; This routine loads Taxonomy SURVEILLANCE ENCEPHALOPATHY
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
 ;;21,"348.3 ")
 ;;1
 ;;9002226,1617,.01)
 ;;SURVEILLANCE ENCEPHALOPATHY
 ;;9002226,1617,.02)
 ;;@
 ;;9002226,1617,.04)
 ;;n
 ;;9002226,1617,.06)
 ;;@
 ;;9002226,1617,.08)
 ;;0
 ;;9002226,1617,.09)
 ;;3110728
 ;;9002226,1617,.11)
 ;;@
 ;;9002226,1617,.12)
 ;;31
 ;;9002226,1617,.13)
 ;;1
 ;;9002226,1617,.14)
 ;;@
 ;;9002226,1617,.15)
 ;;80
 ;;9002226,1617,.16)
 ;;@
 ;;9002226,1617,.17)
 ;;@
 ;;9002226,1617,3101)
 ;;@
 ;;9002226.02101,"1617,348.3 ",.01)
 ;;348.3 
 ;;9002226.02101,"1617,348.3 ",.02)
 ;;348.39 
 ;
OTHER ; OTHER ROUTINES
 Q