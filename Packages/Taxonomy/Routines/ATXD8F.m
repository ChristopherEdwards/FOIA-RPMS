ATXD8F ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 13, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;SURVEILL ADV EV SUDDEN DEATH
 ;
 ; This routine loads Taxonomy SURVEILL ADV EV SUDDEN DEATH
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
 ;;21,"674.90 ")
 ;;1
 ;;21,"674.92 ")
 ;;2
 ;;21,"674.94 ")
 ;;3
 ;;21,"798.0 ")
 ;;4
 ;;21,"O90.9 ")
 ;;5
 ;;21,"R99. ")
 ;;6
 ;;9002226,925,.01)
 ;;SURVEILL ADV EV SUDDEN DEATH
 ;;9002226,925,.02)
 ;;@
 ;;9002226,925,.04)
 ;;n
 ;;9002226,925,.06)
 ;;@
 ;;9002226,925,.08)
 ;;0
 ;;9002226,925,.09)
 ;;3131113
 ;;9002226,925,.11)
 ;;@
 ;;9002226,925,.12)
 ;;31
 ;;9002226,925,.13)
 ;;1
 ;;9002226,925,.14)
 ;;@
 ;;9002226,925,.15)
 ;;80
 ;;9002226,925,.16)
 ;;@
 ;;9002226,925,.17)
 ;;@
 ;;9002226,925,3101)
 ;;@
 ;;9002226.02101,"925,674.90 ",.01)
 ;;674.90 
 ;;9002226.02101,"925,674.90 ",.02)
 ;;674.90 
 ;;9002226.02101,"925,674.90 ",.03)
 ;;1
 ;;9002226.02101,"925,674.92 ",.01)
 ;;674.92 
 ;;9002226.02101,"925,674.92 ",.02)
 ;;674.92 
 ;;9002226.02101,"925,674.92 ",.03)
 ;;1
 ;;9002226.02101,"925,674.94 ",.01)
 ;;674.94 
 ;;9002226.02101,"925,674.94 ",.02)
 ;;674.94 
 ;;9002226.02101,"925,674.94 ",.03)
 ;;1
 ;;9002226.02101,"925,798.0 ",.01)
 ;;798.0 
 ;;9002226.02101,"925,798.0 ",.02)
 ;;798.9 
 ;;9002226.02101,"925,798.0 ",.03)
 ;;1
 ;;9002226.02101,"925,O90.9 ",.01)
 ;;O90.9 
 ;;9002226.02101,"925,O90.9 ",.02)
 ;;O90.9 
 ;;9002226.02101,"925,O90.9 ",.03)
 ;;30
 ;;9002226.02101,"925,R99. ",.01)
 ;;R99. 
 ;;9002226.02101,"925,R99. ",.02)
 ;;R99. 
 ;;9002226.02101,"925,R99. ",.03)
 ;;30
 ;;9002226.04101,"925,1",.01)
 ;;BGP
 ;
OTHER ; OTHER ROUTINES
 Q