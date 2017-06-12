ATXDAS ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;BQI ST LOUIS ENCEPH DXS
 ;
 ; This routine loads Taxonomy BQI ST LOUIS ENCEPH DXS
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
 ;;21,"062.3 ")
 ;;1
 ;;21,"A83.3 ")
 ;;2
 ;;9002226,1871,.01)
 ;;BQI ST LOUIS ENCEPH DXS
 ;;9002226,1871,.02)
 ;;St Louis Encephalitis Virus
 ;;9002226,1871,.04)
 ;;n
 ;;9002226,1871,.06)
 ;;@
 ;;9002226,1871,.08)
 ;;0
 ;;9002226,1871,.09)
 ;;3140312
 ;;9002226,1871,.11)
 ;;@
 ;;9002226,1871,.12)
 ;;31
 ;;9002226,1871,.13)
 ;;1
 ;;9002226,1871,.14)
 ;;@
 ;;9002226,1871,.15)
 ;;80
 ;;9002226,1871,.16)
 ;;@
 ;;9002226,1871,.17)
 ;;@
 ;;9002226,1871,3101)
 ;;@
 ;;9002226.01101,"1871,1",.01)
 ;;CDC Nationally Notificable Disease
 ;;9002226.01101,"1871,2",.01)
 ;;St Louis Encephalitis Virus Disease
 ;;9002226.02101,"1871,062.3 ",.01)
 ;;062.3
 ;;9002226.02101,"1871,062.3 ",.02)
 ;;062.3
 ;;9002226.02101,"1871,062.3 ",.03)
 ;;1
 ;;9002226.02101,"1871,A83.3 ",.01)
 ;;A83.3 
 ;;9002226.02101,"1871,A83.3 ",.02)
 ;;A83.3 
 ;;9002226.02101,"1871,A83.3 ",.03)
 ;;30
 ;;9002226.04101,"1871,1",.01)
 ;;BQI
 ;;9002226.05101,"1871,1",.01)
 ;;ENCEPHALITIS
 ;
OTHER ; OTHER ROUTINES
 Q