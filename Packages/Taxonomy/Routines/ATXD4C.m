ATXD4C ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 28, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;BGP URI DXS
 ;
 ; This routine loads Taxonomy BGP URI DXS
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
 ;;21,"460. ")
 ;;1
 ;;21,"465.0 ")
 ;;2
 ;;21,"J00. ")
 ;;3
 ;;9002226,533,.01)
 ;;BGP URI DXS
 ;;9002226,533,.02)
 ;;@
 ;;9002226,533,.04)
 ;;n
 ;;9002226,533,.06)
 ;;@
 ;;9002226,533,.08)
 ;;0
 ;;9002226,533,.09)
 ;;3121002
 ;;9002226,533,.11)
 ;;@
 ;;9002226,533,.12)
 ;;31
 ;;9002226,533,.13)
 ;;1
 ;;9002226,533,.14)
 ;;@
 ;;9002226,533,.15)
 ;;80
 ;;9002226,533,.16)
 ;;@
 ;;9002226,533,.17)
 ;;@
 ;;9002226,533,3101)
 ;;@
 ;;9002226.02101,"533,460. ",.01)
 ;;460. 
 ;;9002226.02101,"533,460. ",.02)
 ;;460. 
 ;;9002226.02101,"533,460. ",.03)
 ;;1
 ;;9002226.02101,"533,465.0 ",.01)
 ;;465.0 
 ;;9002226.02101,"533,465.0 ",.02)
 ;;465.9 
 ;;9002226.02101,"533,465.0 ",.03)
 ;;1
 ;;9002226.02101,"533,J00. ",.01)
 ;;J00. 
 ;;9002226.02101,"533,J00. ",.02)
 ;;J00. 
 ;;9002226.02101,"533,J00. ",.03)
 ;;30
 ;;9002226.04101,"533,1",.01)
 ;;BGP
 ;
OTHER ; OTHER ROUTINES
 Q