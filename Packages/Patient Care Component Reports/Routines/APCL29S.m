APCL29S ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 21, 2013;
 ;;3.0;IHS PCC REPORTS;**29**;FEB 05, 1997;Build 35
 ;;SURVEILLANCE CPT FLU
 ;
 ; This routine loads Taxonomy SURVEILLANCE CPT FLU
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
 ;;21,"90654 ")
 ;;1
 ;;21,"90672 ")
 ;;2
 ;;21,"90685 ")
 ;;3
 ;;21,"90724 ")
 ;;4
 ;;21,"G0008 ")
 ;;5
 ;;21,"G8108 ")
 ;;6
 ;;9002226,1866,.01)
 ;;SURVEILLANCE CPT FLU
 ;;9002226,1866,.02)
 ;;@
 ;;9002226,1866,.04)
 ;;@
 ;;9002226,1866,.06)
 ;;@
 ;;9002226,1866,.08)
 ;;0
 ;;9002226,1866,.09)
 ;;3130612
 ;;9002226,1866,.11)
 ;;@
 ;;9002226,1866,.12)
 ;;455
 ;;9002226,1866,.13)
 ;;1
 ;;9002226,1866,.14)
 ;;@
 ;;9002226,1866,.15)
 ;;81
 ;;9002226,1866,.16)
 ;;@
 ;;9002226,1866,.17)
 ;;@
 ;;9002226,1866,3101)
 ;;@
 ;;9002226.02101,"1866,90654 ",.01)
 ;;90654 
 ;;9002226.02101,"1866,90654 ",.02)
 ;;90662 
 ;;9002226.02101,"1866,90672 ",.01)
 ;;90672 
 ;;9002226.02101,"1866,90672 ",.02)
 ;;90673 
 ;;9002226.02101,"1866,90685 ",.01)
 ;;90685 
 ;;9002226.02101,"1866,90685 ",.02)
 ;;90686 
 ;;9002226.02101,"1866,90724 ",.01)
 ;;90724 
 ;;9002226.02101,"1866,90724 ",.02)
 ;;90724 
 ;;9002226.02101,"1866,G0008 ",.01)
 ;;G0008 
 ;;9002226.02101,"1866,G0008 ",.02)
 ;;G0008 
 ;;9002226.02101,"1866,G8108 ",.01)
 ;;G8108 
 ;;9002226.02101,"1866,G8108 ",.02)
 ;;G8108 
 ;
OTHER ; OTHER ROUTINES
 Q