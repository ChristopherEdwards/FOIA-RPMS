ATXD4E ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 11, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;BGP ASA ALLERGY 995.0-995.3
 ;
 ; This routine loads Taxonomy BGP ASA ALLERGY 995.0-995.3
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
 ;;21,"995.0 ")
 ;;1
 ;;9002226,335,.01)
 ;;BGP ASA ALLERGY 995.0-995.3
 ;;9002226,335,.02)
 ;;@
 ;;9002226,335,.04)
 ;;n
 ;;9002226,335,.06)
 ;;@
 ;;9002226,335,.08)
 ;;0
 ;;9002226,335,.09)
 ;;3041020
 ;;9002226,335,.11)
 ;;@
 ;;9002226,335,.12)
 ;;31
 ;;9002226,335,.13)
 ;;1
 ;;9002226,335,.14)
 ;;@
 ;;9002226,335,.15)
 ;;80
 ;;9002226,335,.16)
 ;;@
 ;;9002226,335,.17)
 ;;@
 ;;9002226,335,3101)
 ;;@
 ;;9002226.02101,"335,995.0 ",.01)
 ;;995.0 
 ;;9002226.02101,"335,995.0 ",.02)
 ;;995.3 
 ;;9002226.02101,"335,995.0 ",.03)
 ;;1
 ;;9002226.04101,"335,1",.01)
 ;;BGP
 ;
OTHER ; OTHER ROUTINES
 Q