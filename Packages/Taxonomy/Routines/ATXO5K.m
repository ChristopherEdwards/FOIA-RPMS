ATXO5K ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 13, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;APCH RECTAL EXAM PROCS
 ;
 ; This routine loads Taxonomy APCH RECTAL EXAM PROCS
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
 ;;21,"0DJDXZZ ")
 ;;2
 ;;21,"89.34 ")
 ;;1
 ;;9002226,1746,.01)
 ;;APCH RECTAL EXAM PROCS
 ;;9002226,1746,.02)
 ;;@
 ;;9002226,1746,.04)
 ;;@
 ;;9002226,1746,.06)
 ;;@
 ;;9002226,1746,.08)
 ;;@
 ;;9002226,1746,.09)
 ;;3131113
 ;;9002226,1746,.11)
 ;;@
 ;;9002226,1746,.12)
 ;;255
 ;;9002226,1746,.13)
 ;;1
 ;;9002226,1746,.14)
 ;;@
 ;;9002226,1746,.15)
 ;;80.1
 ;;9002226,1746,.16)
 ;;@
 ;;9002226,1746,.17)
 ;;@
 ;;9002226,1746,3101)
 ;;@
 ;;9002226.02101,"1746,0DJDXZZ ",.01)
 ;;0DJDXZZ 
 ;;9002226.02101,"1746,0DJDXZZ ",.02)
 ;;0DJDXZZ 
 ;;9002226.02101,"1746,0DJDXZZ ",.03)
 ;;31
 ;;9002226.02101,"1746,89.34 ",.01)
 ;;89.34 
 ;;9002226.02101,"1746,89.34 ",.02)
 ;;89.34 
 ;;9002226.02101,"1746,89.34 ",.03)
 ;;2
 ;
OTHER ; OTHER ROUTINES
 Q