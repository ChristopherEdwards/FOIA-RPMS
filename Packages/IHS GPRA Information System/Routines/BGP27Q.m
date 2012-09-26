BGP27Q ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PED ADHD DXS
 ;
 ; This routine loads Taxonomy BGP PED ADHD DXS
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
 ;;21,"314.01 ")
 ;;1
 ;;9002226,1551,.01)
 ;;BGP PED ADHD DXS
 ;;9002226,1551,.02)
 ;;@
 ;;9002226,1551,.04)
 ;;@
 ;;9002226,1551,.06)
 ;;@
 ;;9002226,1551,.08)
 ;;0
 ;;9002226,1551,.09)
 ;;3120217
 ;;9002226,1551,.11)
 ;;@
 ;;9002226,1551,.12)
 ;;31
 ;;9002226,1551,.13)
 ;;1
 ;;9002226,1551,.14)
 ;;@
 ;;9002226,1551,.15)
 ;;80
 ;;9002226,1551,.16)
 ;;@
 ;;9002226,1551,.17)
 ;;@
 ;;9002226,1551,3101)
 ;;@
 ;;9002226.02101,"1551,314.01 ",.01)
 ;;314.01 
 ;;9002226.02101,"1551,314.01 ",.02)
 ;;314.01 
 ;
OTHER ; OTHER ROUTINES
 Q
