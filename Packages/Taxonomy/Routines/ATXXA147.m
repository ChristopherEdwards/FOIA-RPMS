ATXXA147 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"873,T36.6X4A ",.02)
 ;;T36.6X4A
 ;;9002226.02101,"873,T36.6X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T36.7X1A ",.01)
 ;;T36.7X1A
 ;;9002226.02101,"873,T36.7X1A ",.02)
 ;;T36.7X1A
 ;;9002226.02101,"873,T36.7X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T36.7X2A ",.01)
 ;;T36.7X2A
 ;;9002226.02101,"873,T36.7X2A ",.02)
 ;;T36.7X2A
 ;;9002226.02101,"873,T36.7X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T36.7X3A ",.01)
 ;;T36.7X3A
 ;;9002226.02101,"873,T36.7X3A ",.02)
 ;;T36.7X3A
 ;;9002226.02101,"873,T36.7X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T36.7X4A ",.01)
 ;;T36.7X4A
 ;;9002226.02101,"873,T36.7X4A ",.02)
 ;;T36.7X4A
 ;;9002226.02101,"873,T36.7X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T36.8X1A ",.01)
 ;;T36.8X1A
 ;;9002226.02101,"873,T36.8X1A ",.02)
 ;;T36.8X1A
 ;;9002226.02101,"873,T36.8X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T36.8X2A ",.01)
 ;;T36.8X2A
 ;;9002226.02101,"873,T36.8X2A ",.02)
 ;;T36.8X2A
 ;;9002226.02101,"873,T36.8X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T36.8X3A ",.01)
 ;;T36.8X3A
 ;;9002226.02101,"873,T36.8X3A ",.02)
 ;;T36.8X3A
 ;;9002226.02101,"873,T36.8X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T36.8X4A ",.01)
 ;;T36.8X4A
 ;;9002226.02101,"873,T36.8X4A ",.02)
 ;;T36.8X4A
 ;;9002226.02101,"873,T36.8X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T36.91XA ",.01)
 ;;T36.91XA
 ;;9002226.02101,"873,T36.91XA ",.02)
 ;;T36.91XA
 ;;9002226.02101,"873,T36.91XA ",.03)
 ;;30
 ;;9002226.02101,"873,T36.92XA ",.01)
 ;;T36.92XA
 ;;9002226.02101,"873,T36.92XA ",.02)
 ;;T36.92XA
 ;;9002226.02101,"873,T36.92XA ",.03)
 ;;30
 ;;9002226.02101,"873,T36.93XA ",.01)
 ;;T36.93XA
 ;;9002226.02101,"873,T36.93XA ",.02)
 ;;T36.93XA
 ;;9002226.02101,"873,T36.93XA ",.03)
 ;;30
 ;;9002226.02101,"873,T36.94XA ",.01)
 ;;T36.94XA
 ;;9002226.02101,"873,T36.94XA ",.02)
 ;;T36.94XA
 ;;9002226.02101,"873,T36.94XA ",.03)
 ;;30
 ;;9002226.02101,"873,T37.0X1A ",.01)
 ;;T37.0X1A
 ;;9002226.02101,"873,T37.0X1A ",.02)
 ;;T37.0X1A
 ;;9002226.02101,"873,T37.0X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.0X2A ",.01)
 ;;T37.0X2A
 ;;9002226.02101,"873,T37.0X2A ",.02)
 ;;T37.0X2A
 ;;9002226.02101,"873,T37.0X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.0X3A ",.01)
 ;;T37.0X3A
 ;;9002226.02101,"873,T37.0X3A ",.02)
 ;;T37.0X3A
 ;;9002226.02101,"873,T37.0X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.0X4A ",.01)
 ;;T37.0X4A
 ;;9002226.02101,"873,T37.0X4A ",.02)
 ;;T37.0X4A
 ;;9002226.02101,"873,T37.0X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.1X1A ",.01)
 ;;T37.1X1A
 ;;9002226.02101,"873,T37.1X1A ",.02)
 ;;T37.1X1A
 ;;9002226.02101,"873,T37.1X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.1X2A ",.01)
 ;;T37.1X2A
 ;;9002226.02101,"873,T37.1X2A ",.02)
 ;;T37.1X2A
 ;;9002226.02101,"873,T37.1X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.1X3A ",.01)
 ;;T37.1X3A
 ;;9002226.02101,"873,T37.1X3A ",.02)
 ;;T37.1X3A
 ;;9002226.02101,"873,T37.1X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.1X4A ",.01)
 ;;T37.1X4A
 ;;9002226.02101,"873,T37.1X4A ",.02)
 ;;T37.1X4A
 ;;9002226.02101,"873,T37.1X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.2X1A ",.01)
 ;;T37.2X1A
 ;;9002226.02101,"873,T37.2X1A ",.02)
 ;;T37.2X1A
 ;;9002226.02101,"873,T37.2X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.2X2A ",.01)
 ;;T37.2X2A
 ;;9002226.02101,"873,T37.2X2A ",.02)
 ;;T37.2X2A
 ;;9002226.02101,"873,T37.2X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.2X3A ",.01)
 ;;T37.2X3A
 ;;9002226.02101,"873,T37.2X3A ",.02)
 ;;T37.2X3A
 ;;9002226.02101,"873,T37.2X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.2X4A ",.01)
 ;;T37.2X4A
 ;;9002226.02101,"873,T37.2X4A ",.02)
 ;;T37.2X4A
 ;;9002226.02101,"873,T37.2X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.3X1A ",.01)
 ;;T37.3X1A
 ;;9002226.02101,"873,T37.3X1A ",.02)
 ;;T37.3X1A
 ;;9002226.02101,"873,T37.3X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.3X2A ",.01)
 ;;T37.3X2A
 ;;9002226.02101,"873,T37.3X2A ",.02)
 ;;T37.3X2A
 ;;9002226.02101,"873,T37.3X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.3X3A ",.01)
 ;;T37.3X3A
 ;;9002226.02101,"873,T37.3X3A ",.02)
 ;;T37.3X3A
 ;;9002226.02101,"873,T37.3X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.3X4A ",.01)
 ;;T37.3X4A
 ;;9002226.02101,"873,T37.3X4A ",.02)
 ;;T37.3X4A
 ;;9002226.02101,"873,T37.3X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.4X1A ",.01)
 ;;T37.4X1A
 ;;9002226.02101,"873,T37.4X1A ",.02)
 ;;T37.4X1A
 ;;9002226.02101,"873,T37.4X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.4X2A ",.01)
 ;;T37.4X2A
 ;;9002226.02101,"873,T37.4X2A ",.02)
 ;;T37.4X2A
 ;;9002226.02101,"873,T37.4X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.4X3A ",.01)
 ;;T37.4X3A
 ;;9002226.02101,"873,T37.4X3A ",.02)
 ;;T37.4X3A
 ;;9002226.02101,"873,T37.4X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.4X4A ",.01)
 ;;T37.4X4A
 ;;9002226.02101,"873,T37.4X4A ",.02)
 ;;T37.4X4A
 ;;9002226.02101,"873,T37.4X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.5X1A ",.01)
 ;;T37.5X1A
 ;;9002226.02101,"873,T37.5X1A ",.02)
 ;;T37.5X1A
 ;;9002226.02101,"873,T37.5X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.5X2A ",.01)
 ;;T37.5X2A
 ;;9002226.02101,"873,T37.5X2A ",.02)
 ;;T37.5X2A
 ;;9002226.02101,"873,T37.5X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.5X3A ",.01)
 ;;T37.5X3A
 ;;9002226.02101,"873,T37.5X3A ",.02)
 ;;T37.5X3A
 ;;9002226.02101,"873,T37.5X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.5X4A ",.01)
 ;;T37.5X4A
 ;;9002226.02101,"873,T37.5X4A ",.02)
 ;;T37.5X4A
 ;;9002226.02101,"873,T37.5X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.8X1A ",.01)
 ;;T37.8X1A
 ;;9002226.02101,"873,T37.8X1A ",.02)
 ;;T37.8X1A
 ;;9002226.02101,"873,T37.8X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.8X2A ",.01)
 ;;T37.8X2A
 ;;9002226.02101,"873,T37.8X2A ",.02)
 ;;T37.8X2A
 ;;9002226.02101,"873,T37.8X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.8X3A ",.01)
 ;;T37.8X3A
 ;;9002226.02101,"873,T37.8X3A ",.02)
 ;;T37.8X3A
 ;;9002226.02101,"873,T37.8X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.8X4A ",.01)
 ;;T37.8X4A
 ;;9002226.02101,"873,T37.8X4A ",.02)
 ;;T37.8X4A
 ;;9002226.02101,"873,T37.8X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T37.91XA ",.01)
 ;;T37.91XA
 ;;9002226.02101,"873,T37.91XA ",.02)
 ;;T37.91XA
 ;;9002226.02101,"873,T37.91XA ",.03)
 ;;30
 ;;9002226.02101,"873,T37.92XA ",.01)
 ;;T37.92XA
 ;;9002226.02101,"873,T37.92XA ",.02)
 ;;T37.92XA
 ;;9002226.02101,"873,T37.92XA ",.03)
 ;;30
 ;;9002226.02101,"873,T37.93XA ",.01)
 ;;T37.93XA
 ;;9002226.02101,"873,T37.93XA ",.02)
 ;;T37.93XA
 ;;9002226.02101,"873,T37.93XA ",.03)
 ;;30
 ;;9002226.02101,"873,T37.94XA ",.01)
 ;;T37.94XA
 ;;9002226.02101,"873,T37.94XA ",.02)
 ;;T37.94XA
 ;;9002226.02101,"873,T37.94XA ",.03)
 ;;30
 ;;9002226.02101,"873,T38.0X1A ",.01)
 ;;T38.0X1A
 ;;9002226.02101,"873,T38.0X1A ",.02)
 ;;T38.0X1A
 ;;9002226.02101,"873,T38.0X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.0X2A ",.01)
 ;;T38.0X2A
 ;;9002226.02101,"873,T38.0X2A ",.02)
 ;;T38.0X2A
 ;;9002226.02101,"873,T38.0X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.0X3A ",.01)
 ;;T38.0X3A
 ;;9002226.02101,"873,T38.0X3A ",.02)
 ;;T38.0X3A
 ;;9002226.02101,"873,T38.0X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.0X4A ",.01)
 ;;T38.0X4A
 ;;9002226.02101,"873,T38.0X4A ",.02)
 ;;T38.0X4A
 ;;9002226.02101,"873,T38.0X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.1X1A ",.01)
 ;;T38.1X1A
 ;;9002226.02101,"873,T38.1X1A ",.02)
 ;;T38.1X1A
 ;;9002226.02101,"873,T38.1X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.1X2A ",.01)
 ;;T38.1X2A
 ;;9002226.02101,"873,T38.1X2A ",.02)
 ;;T38.1X2A
 ;;9002226.02101,"873,T38.1X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.1X3A ",.01)
 ;;T38.1X3A
 ;;9002226.02101,"873,T38.1X3A ",.02)
 ;;T38.1X3A
 ;;9002226.02101,"873,T38.1X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.1X4A ",.01)
 ;;T38.1X4A
 ;;9002226.02101,"873,T38.1X4A ",.02)
 ;;T38.1X4A
 ;;9002226.02101,"873,T38.1X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.2X1A ",.01)
 ;;T38.2X1A
 ;;9002226.02101,"873,T38.2X1A ",.02)
 ;;T38.2X1A
 ;;9002226.02101,"873,T38.2X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.2X2A ",.01)
 ;;T38.2X2A
 ;;9002226.02101,"873,T38.2X2A ",.02)
 ;;T38.2X2A
 ;;9002226.02101,"873,T38.2X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.2X3A ",.01)
 ;;T38.2X3A
 ;;9002226.02101,"873,T38.2X3A ",.02)
 ;;T38.2X3A
 ;;9002226.02101,"873,T38.2X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.2X4A ",.01)
 ;;T38.2X4A
 ;;9002226.02101,"873,T38.2X4A ",.02)
 ;;T38.2X4A
 ;;9002226.02101,"873,T38.2X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.3X1A ",.01)
 ;;T38.3X1A
 ;;9002226.02101,"873,T38.3X1A ",.02)
 ;;T38.3X1A
 ;;9002226.02101,"873,T38.3X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.3X2A ",.01)
 ;;T38.3X2A
 ;;9002226.02101,"873,T38.3X2A ",.02)
 ;;T38.3X2A
 ;;9002226.02101,"873,T38.3X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.3X3A ",.01)
 ;;T38.3X3A
 ;;9002226.02101,"873,T38.3X3A ",.02)
 ;;T38.3X3A
 ;;9002226.02101,"873,T38.3X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.3X4A ",.01)
 ;;T38.3X4A
 ;;9002226.02101,"873,T38.3X4A ",.02)
 ;;T38.3X4A
 ;;9002226.02101,"873,T38.3X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.4X1A ",.01)
 ;;T38.4X1A
 ;;9002226.02101,"873,T38.4X1A ",.02)
 ;;T38.4X1A
 ;;9002226.02101,"873,T38.4X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.4X2A ",.01)
 ;;T38.4X2A
 ;;9002226.02101,"873,T38.4X2A ",.02)
 ;;T38.4X2A
 ;;9002226.02101,"873,T38.4X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.4X3A ",.01)
 ;;T38.4X3A
 ;;9002226.02101,"873,T38.4X3A ",.02)
 ;;T38.4X3A
 ;;9002226.02101,"873,T38.4X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.4X4A ",.01)
 ;;T38.4X4A
 ;;9002226.02101,"873,T38.4X4A ",.02)
 ;;T38.4X4A
 ;;9002226.02101,"873,T38.4X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.5X1A ",.01)
 ;;T38.5X1A
 ;;9002226.02101,"873,T38.5X1A ",.02)
 ;;T38.5X1A
 ;;9002226.02101,"873,T38.5X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.5X2A ",.01)
 ;;T38.5X2A
 ;;9002226.02101,"873,T38.5X2A ",.02)
 ;;T38.5X2A
 ;;9002226.02101,"873,T38.5X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.5X3A ",.01)
 ;;T38.5X3A
 ;;9002226.02101,"873,T38.5X3A ",.02)
 ;;T38.5X3A
 ;;9002226.02101,"873,T38.5X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.5X4A ",.01)
 ;;T38.5X4A
 ;;9002226.02101,"873,T38.5X4A ",.02)
 ;;T38.5X4A
 ;;9002226.02101,"873,T38.5X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.6X1A ",.01)
 ;;T38.6X1A
 ;;9002226.02101,"873,T38.6X1A ",.02)
 ;;T38.6X1A
 ;;9002226.02101,"873,T38.6X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.6X2A ",.01)
 ;;T38.6X2A
 ;;9002226.02101,"873,T38.6X2A ",.02)
 ;;T38.6X2A
 ;;9002226.02101,"873,T38.6X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.6X3A ",.01)
 ;;T38.6X3A
 ;;9002226.02101,"873,T38.6X3A ",.02)
 ;;T38.6X3A
 ;;9002226.02101,"873,T38.6X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.6X4A ",.01)
 ;;T38.6X4A
 ;;9002226.02101,"873,T38.6X4A ",.02)
 ;;T38.6X4A
 ;;9002226.02101,"873,T38.6X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.7X1A ",.01)
 ;;T38.7X1A
 ;;9002226.02101,"873,T38.7X1A ",.02)
 ;;T38.7X1A
 ;;9002226.02101,"873,T38.7X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.7X2A ",.01)
 ;;T38.7X2A
 ;;9002226.02101,"873,T38.7X2A ",.02)
 ;;T38.7X2A
 ;;9002226.02101,"873,T38.7X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.7X3A ",.01)
 ;;T38.7X3A
 ;;9002226.02101,"873,T38.7X3A ",.02)
 ;;T38.7X3A
 ;;9002226.02101,"873,T38.7X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.7X4A ",.01)
 ;;T38.7X4A
 ;;9002226.02101,"873,T38.7X4A ",.02)
 ;;T38.7X4A
 ;;9002226.02101,"873,T38.7X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.801A ",.01)
 ;;T38.801A
 ;;9002226.02101,"873,T38.801A ",.02)
 ;;T38.801A
 ;;9002226.02101,"873,T38.801A ",.03)
 ;;30
 ;;9002226.02101,"873,T38.802A ",.01)
 ;;T38.802A
 ;;9002226.02101,"873,T38.802A ",.02)
 ;;T38.802A