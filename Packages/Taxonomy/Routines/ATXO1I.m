ATXO1I ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 12, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;BGP BILAT FOOT AMP PROCEDURES
 ;
 ; This routine loads Taxonomy BGP BILAT FOOT AMP PROCEDURES
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
 ;;21,"0Y640ZZ ")
 ;;1
 ;;9002226,1000,.01)
 ;;BGP BILAT FOOT AMP PROCEDURES
 ;;9002226,1000,.02)
 ;;@
 ;;9002226,1000,.04)
 ;;n
 ;;9002226,1000,.06)
 ;;@
 ;;9002226,1000,.08)
 ;;@
 ;;9002226,1000,.09)
 ;;@
 ;;9002226,1000,.11)
 ;;@
 ;;9002226,1000,.12)
 ;;255
 ;;9002226,1000,.13)
 ;;1
 ;;9002226,1000,.14)
 ;;@
 ;;9002226,1000,.15)
 ;;80.1
 ;;9002226,1000,.16)
 ;;@
 ;;9002226,1000,.17)
 ;;@
 ;;9002226,1000,3101)
 ;;@
 ;;9002226.02101,"1000,0Y640ZZ ",.01)
 ;;0Y640ZZ 
 ;;9002226.02101,"1000,0Y640ZZ ",.02)
 ;;0Y640ZZ 
 ;;9002226.02101,"1000,0Y640ZZ ",.03)
 ;;31
 ;
OTHER ; OTHER ROUTINES
 Q