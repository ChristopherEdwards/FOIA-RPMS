BGP29S ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PED FASD DXS
 ;
 ; This routine loads Taxonomy BGP PED FASD DXS
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
 ;;21,"760.71 ")
 ;;1
 ;;9002226,1605,.01)
 ;;BGP PED FASD DXS
 ;;9002226,1605,.02)
 ;;@
 ;;9002226,1605,.04)
 ;;@
 ;;9002226,1605,.06)
 ;;@
 ;;9002226,1605,.08)
 ;;0
 ;;9002226,1605,.09)
 ;;3120219
 ;;9002226,1605,.11)
 ;;@
 ;;9002226,1605,.12)
 ;;31
 ;;9002226,1605,.13)
 ;;1
 ;;9002226,1605,.14)
 ;;@
 ;;9002226,1605,.15)
 ;;80
 ;;9002226,1605,.16)
 ;;@
 ;;9002226,1605,.17)
 ;;@
 ;;9002226,1605,3101)
 ;;@
 ;;9002226.02101,"1605,760.71 ",.01)
 ;;760.71 
 ;;9002226.02101,"1605,760.71 ",.02)
 ;;760.71 
 ;
OTHER ; OTHER ROUTINES
 Q
