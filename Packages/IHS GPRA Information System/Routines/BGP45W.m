BGP45W ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON SEP 30, 2013;
 ;;14.0;IHS CLINICAL REPORTING;;NOV 14, 2013;Build 101
 ;;BGP RA LEFLUNOMIDE VAPI
 ;
 ; This routine loads Taxonomy BGP RA LEFLUNOMIDE VAPI
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
 ;;21,"L0213 ")
 ;;1
 ;;21,"L0214 ")
 ;;2
 ;;9002226,1838,.01)
 ;;BGP RA LEFLUNOMIDE VAPI
 ;;9002226,1838,.02)
 ;;@
 ;;9002226,1838,.04)
 ;;@
 ;;9002226,1838,.06)
 ;;@
 ;;9002226,1838,.08)
 ;;@
 ;;9002226,1838,.09)
 ;;3130926
 ;;9002226,1838,.11)
 ;;@
 ;;9002226,1838,.12)
 ;;@
 ;;9002226,1838,.13)
 ;;1
 ;;9002226,1838,.14)
 ;;@
 ;;9002226,1838,.15)
 ;;50.68
 ;;9002226,1838,.16)
 ;;@
 ;;9002226,1838,.17)
 ;;@
 ;;9002226,1838,3101)
 ;;@
 ;;9002226.02101,"1838,L0213 ",.01)
 ;;L0213
 ;;9002226.02101,"1838,L0213 ",.02)
 ;;L0213
 ;;9002226.02101,"1838,L0214 ",.01)
 ;;L0214
 ;;9002226.02101,"1838,L0214 ",.02)
 ;;L0214
 ;
OTHER ; OTHER ROUTINES
 Q