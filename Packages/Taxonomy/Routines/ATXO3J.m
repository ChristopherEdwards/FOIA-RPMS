ATXO3J ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 12, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;BTPW COLP IMP NO BX PROC
 ;
 ; This routine loads Taxonomy BTPW COLP IMP NO BX PROC
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
 ;;21,"0UJH8ZZ ")
 ;;2
 ;;21,"70.21 ")
 ;;1
 ;;9002226,1393,.01)
 ;;BTPW COLP IMP NO BX PROC
 ;;9002226,1393,.02)
 ;;@
 ;;9002226,1393,.04)
 ;;n
 ;;9002226,1393,.06)
 ;;@
 ;;9002226,1393,.08)
 ;;@
 ;;9002226,1393,.09)
 ;;3131112
 ;;9002226,1393,.11)
 ;;@
 ;;9002226,1393,.12)
 ;;255
 ;;9002226,1393,.13)
 ;;1
 ;;9002226,1393,.14)
 ;;@
 ;;9002226,1393,.15)
 ;;80.1
 ;;9002226,1393,.16)
 ;;@
 ;;9002226,1393,.17)
 ;;@
 ;;9002226,1393,3101)
 ;;@
 ;;9002226.02101,"1393,0UJH8ZZ ",.01)
 ;;0UJH8ZZ 
 ;;9002226.02101,"1393,0UJH8ZZ ",.02)
 ;;0UJH8ZZ 
 ;;9002226.02101,"1393,0UJH8ZZ ",.03)
 ;;31
 ;;9002226.02101,"1393,70.21 ",.01)
 ;;70.21 
 ;;9002226.02101,"1393,70.21 ",.02)
 ;;70.21 
 ;;9002226.02101,"1393,70.21 ",.03)
 ;;2
 ;
OTHER ; OTHER ROUTINES
 Q