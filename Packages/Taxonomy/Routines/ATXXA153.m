ATXXA153 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"873,T47.2X2A ",.02)
 ;;T47.2X2A
 ;;9002226.02101,"873,T47.2X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.2X3A ",.01)
 ;;T47.2X3A
 ;;9002226.02101,"873,T47.2X3A ",.02)
 ;;T47.2X3A
 ;;9002226.02101,"873,T47.2X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.2X4A ",.01)
 ;;T47.2X4A
 ;;9002226.02101,"873,T47.2X4A ",.02)
 ;;T47.2X4A
 ;;9002226.02101,"873,T47.2X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.3X1A ",.01)
 ;;T47.3X1A
 ;;9002226.02101,"873,T47.3X1A ",.02)
 ;;T47.3X1A
 ;;9002226.02101,"873,T47.3X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.3X2A ",.01)
 ;;T47.3X2A
 ;;9002226.02101,"873,T47.3X2A ",.02)
 ;;T47.3X2A
 ;;9002226.02101,"873,T47.3X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.3X3A ",.01)
 ;;T47.3X3A
 ;;9002226.02101,"873,T47.3X3A ",.02)
 ;;T47.3X3A
 ;;9002226.02101,"873,T47.3X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.3X4A ",.01)
 ;;T47.3X4A
 ;;9002226.02101,"873,T47.3X4A ",.02)
 ;;T47.3X4A
 ;;9002226.02101,"873,T47.3X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.4X1A ",.01)
 ;;T47.4X1A
 ;;9002226.02101,"873,T47.4X1A ",.02)
 ;;T47.4X1A
 ;;9002226.02101,"873,T47.4X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.4X2A ",.01)
 ;;T47.4X2A
 ;;9002226.02101,"873,T47.4X2A ",.02)
 ;;T47.4X2A
 ;;9002226.02101,"873,T47.4X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.4X3A ",.01)
 ;;T47.4X3A
 ;;9002226.02101,"873,T47.4X3A ",.02)
 ;;T47.4X3A
 ;;9002226.02101,"873,T47.4X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.4X4A ",.01)
 ;;T47.4X4A
 ;;9002226.02101,"873,T47.4X4A ",.02)
 ;;T47.4X4A
 ;;9002226.02101,"873,T47.4X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.5X1A ",.01)
 ;;T47.5X1A
 ;;9002226.02101,"873,T47.5X1A ",.02)
 ;;T47.5X1A
 ;;9002226.02101,"873,T47.5X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.5X2A ",.01)
 ;;T47.5X2A
 ;;9002226.02101,"873,T47.5X2A ",.02)
 ;;T47.5X2A
 ;;9002226.02101,"873,T47.5X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.5X3A ",.01)
 ;;T47.5X3A
 ;;9002226.02101,"873,T47.5X3A ",.02)
 ;;T47.5X3A
 ;;9002226.02101,"873,T47.5X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.5X4A ",.01)
 ;;T47.5X4A
 ;;9002226.02101,"873,T47.5X4A ",.02)
 ;;T47.5X4A
 ;;9002226.02101,"873,T47.5X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.6X1A ",.01)
 ;;T47.6X1A
 ;;9002226.02101,"873,T47.6X1A ",.02)
 ;;T47.6X1A
 ;;9002226.02101,"873,T47.6X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.6X2A ",.01)
 ;;T47.6X2A
 ;;9002226.02101,"873,T47.6X2A ",.02)
 ;;T47.6X2A
 ;;9002226.02101,"873,T47.6X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.6X3A ",.01)
 ;;T47.6X3A
 ;;9002226.02101,"873,T47.6X3A ",.02)
 ;;T47.6X3A
 ;;9002226.02101,"873,T47.6X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.6X4A ",.01)
 ;;T47.6X4A
 ;;9002226.02101,"873,T47.6X4A ",.02)
 ;;T47.6X4A
 ;;9002226.02101,"873,T47.6X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.7X1A ",.01)
 ;;T47.7X1A
 ;;9002226.02101,"873,T47.7X1A ",.02)
 ;;T47.7X1A
 ;;9002226.02101,"873,T47.7X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.7X2A ",.01)
 ;;T47.7X2A
 ;;9002226.02101,"873,T47.7X2A ",.02)
 ;;T47.7X2A
 ;;9002226.02101,"873,T47.7X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.7X3A ",.01)
 ;;T47.7X3A
 ;;9002226.02101,"873,T47.7X3A ",.02)
 ;;T47.7X3A
 ;;9002226.02101,"873,T47.7X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.7X4A ",.01)
 ;;T47.7X4A
 ;;9002226.02101,"873,T47.7X4A ",.02)
 ;;T47.7X4A
 ;;9002226.02101,"873,T47.7X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.8X1A ",.01)
 ;;T47.8X1A
 ;;9002226.02101,"873,T47.8X1A ",.02)
 ;;T47.8X1A
 ;;9002226.02101,"873,T47.8X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.8X2A ",.01)
 ;;T47.8X2A
 ;;9002226.02101,"873,T47.8X2A ",.02)
 ;;T47.8X2A
 ;;9002226.02101,"873,T47.8X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.8X3A ",.01)
 ;;T47.8X3A
 ;;9002226.02101,"873,T47.8X3A ",.02)
 ;;T47.8X3A
 ;;9002226.02101,"873,T47.8X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.8X4A ",.01)
 ;;T47.8X4A
 ;;9002226.02101,"873,T47.8X4A ",.02)
 ;;T47.8X4A
 ;;9002226.02101,"873,T47.8X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T47.91XA ",.01)
 ;;T47.91XA
 ;;9002226.02101,"873,T47.91XA ",.02)
 ;;T47.91XA
 ;;9002226.02101,"873,T47.91XA ",.03)
 ;;30
 ;;9002226.02101,"873,T47.92XA ",.01)
 ;;T47.92XA
 ;;9002226.02101,"873,T47.92XA ",.02)
 ;;T47.92XA
 ;;9002226.02101,"873,T47.92XA ",.03)
 ;;30
 ;;9002226.02101,"873,T47.93XA ",.01)
 ;;T47.93XA
 ;;9002226.02101,"873,T47.93XA ",.02)
 ;;T47.93XA
 ;;9002226.02101,"873,T47.93XA ",.03)
 ;;30
 ;;9002226.02101,"873,T47.94XA ",.01)
 ;;T47.94XA
 ;;9002226.02101,"873,T47.94XA ",.02)
 ;;T47.94XA
 ;;9002226.02101,"873,T47.94XA ",.03)
 ;;30
 ;;9002226.02101,"873,T48.0X1A ",.01)
 ;;T48.0X1A
 ;;9002226.02101,"873,T48.0X1A ",.02)
 ;;T48.0X1A
 ;;9002226.02101,"873,T48.0X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.0X2A ",.01)
 ;;T48.0X2A
 ;;9002226.02101,"873,T48.0X2A ",.02)
 ;;T48.0X2A
 ;;9002226.02101,"873,T48.0X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.0X3A ",.01)
 ;;T48.0X3A
 ;;9002226.02101,"873,T48.0X3A ",.02)
 ;;T48.0X3A
 ;;9002226.02101,"873,T48.0X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.0X4A ",.01)
 ;;T48.0X4A
 ;;9002226.02101,"873,T48.0X4A ",.02)
 ;;T48.0X4A
 ;;9002226.02101,"873,T48.0X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.1X1A ",.01)
 ;;T48.1X1A
 ;;9002226.02101,"873,T48.1X1A ",.02)
 ;;T48.1X1A
 ;;9002226.02101,"873,T48.1X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.1X2A ",.01)
 ;;T48.1X2A
 ;;9002226.02101,"873,T48.1X2A ",.02)
 ;;T48.1X2A
 ;;9002226.02101,"873,T48.1X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.1X3A ",.01)
 ;;T48.1X3A
 ;;9002226.02101,"873,T48.1X3A ",.02)
 ;;T48.1X3A
 ;;9002226.02101,"873,T48.1X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.1X4A ",.01)
 ;;T48.1X4A
 ;;9002226.02101,"873,T48.1X4A ",.02)
 ;;T48.1X4A
 ;;9002226.02101,"873,T48.1X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.201A ",.01)
 ;;T48.201A
 ;;9002226.02101,"873,T48.201A ",.02)
 ;;T48.201A
 ;;9002226.02101,"873,T48.201A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.202A ",.01)
 ;;T48.202A
 ;;9002226.02101,"873,T48.202A ",.02)
 ;;T48.202A
 ;;9002226.02101,"873,T48.202A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.203A ",.01)
 ;;T48.203A
 ;;9002226.02101,"873,T48.203A ",.02)
 ;;T48.203A
 ;;9002226.02101,"873,T48.203A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.204A ",.01)
 ;;T48.204A
 ;;9002226.02101,"873,T48.204A ",.02)
 ;;T48.204A
 ;;9002226.02101,"873,T48.204A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.291A ",.01)
 ;;T48.291A
 ;;9002226.02101,"873,T48.291A ",.02)
 ;;T48.291A
 ;;9002226.02101,"873,T48.291A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.292A ",.01)
 ;;T48.292A
 ;;9002226.02101,"873,T48.292A ",.02)
 ;;T48.292A
 ;;9002226.02101,"873,T48.292A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.293A ",.01)
 ;;T48.293A
 ;;9002226.02101,"873,T48.293A ",.02)
 ;;T48.293A
 ;;9002226.02101,"873,T48.293A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.294A ",.01)
 ;;T48.294A
 ;;9002226.02101,"873,T48.294A ",.02)
 ;;T48.294A
 ;;9002226.02101,"873,T48.294A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.3X1A ",.01)
 ;;T48.3X1A
 ;;9002226.02101,"873,T48.3X1A ",.02)
 ;;T48.3X1A
 ;;9002226.02101,"873,T48.3X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.3X2A ",.01)
 ;;T48.3X2A
 ;;9002226.02101,"873,T48.3X2A ",.02)
 ;;T48.3X2A
 ;;9002226.02101,"873,T48.3X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.3X3A ",.01)
 ;;T48.3X3A
 ;;9002226.02101,"873,T48.3X3A ",.02)
 ;;T48.3X3A
 ;;9002226.02101,"873,T48.3X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.3X4A ",.01)
 ;;T48.3X4A
 ;;9002226.02101,"873,T48.3X4A ",.02)
 ;;T48.3X4A
 ;;9002226.02101,"873,T48.3X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.4X1A ",.01)
 ;;T48.4X1A
 ;;9002226.02101,"873,T48.4X1A ",.02)
 ;;T48.4X1A
 ;;9002226.02101,"873,T48.4X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.4X2A ",.01)
 ;;T48.4X2A
 ;;9002226.02101,"873,T48.4X2A ",.02)
 ;;T48.4X2A
 ;;9002226.02101,"873,T48.4X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.4X3A ",.01)
 ;;T48.4X3A
 ;;9002226.02101,"873,T48.4X3A ",.02)
 ;;T48.4X3A
 ;;9002226.02101,"873,T48.4X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.4X4A ",.01)
 ;;T48.4X4A
 ;;9002226.02101,"873,T48.4X4A ",.02)
 ;;T48.4X4A
 ;;9002226.02101,"873,T48.4X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.5X1A ",.01)
 ;;T48.5X1A
 ;;9002226.02101,"873,T48.5X1A ",.02)
 ;;T48.5X1A
 ;;9002226.02101,"873,T48.5X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.5X2A ",.01)
 ;;T48.5X2A
 ;;9002226.02101,"873,T48.5X2A ",.02)
 ;;T48.5X2A
 ;;9002226.02101,"873,T48.5X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.5X3A ",.01)
 ;;T48.5X3A
 ;;9002226.02101,"873,T48.5X3A ",.02)
 ;;T48.5X3A
 ;;9002226.02101,"873,T48.5X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.5X4A ",.01)
 ;;T48.5X4A
 ;;9002226.02101,"873,T48.5X4A ",.02)
 ;;T48.5X4A
 ;;9002226.02101,"873,T48.5X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.6X1A ",.01)
 ;;T48.6X1A
 ;;9002226.02101,"873,T48.6X1A ",.02)
 ;;T48.6X1A
 ;;9002226.02101,"873,T48.6X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.6X2A ",.01)
 ;;T48.6X2A
 ;;9002226.02101,"873,T48.6X2A ",.02)
 ;;T48.6X2A
 ;;9002226.02101,"873,T48.6X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.6X3A ",.01)
 ;;T48.6X3A
 ;;9002226.02101,"873,T48.6X3A ",.02)
 ;;T48.6X3A
 ;;9002226.02101,"873,T48.6X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.6X4A ",.01)
 ;;T48.6X4A
 ;;9002226.02101,"873,T48.6X4A ",.02)
 ;;T48.6X4A
 ;;9002226.02101,"873,T48.6X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.901A ",.01)
 ;;T48.901A
 ;;9002226.02101,"873,T48.901A ",.02)
 ;;T48.901A
 ;;9002226.02101,"873,T48.901A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.902A ",.01)
 ;;T48.902A
 ;;9002226.02101,"873,T48.902A ",.02)
 ;;T48.902A
 ;;9002226.02101,"873,T48.902A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.903A ",.01)
 ;;T48.903A
 ;;9002226.02101,"873,T48.903A ",.02)
 ;;T48.903A
 ;;9002226.02101,"873,T48.903A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.904A ",.01)
 ;;T48.904A
 ;;9002226.02101,"873,T48.904A ",.02)
 ;;T48.904A
 ;;9002226.02101,"873,T48.904A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.991A ",.01)
 ;;T48.991A
 ;;9002226.02101,"873,T48.991A ",.02)
 ;;T48.991A
 ;;9002226.02101,"873,T48.991A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.992A ",.01)
 ;;T48.992A
 ;;9002226.02101,"873,T48.992A ",.02)
 ;;T48.992A
 ;;9002226.02101,"873,T48.992A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.993A ",.01)
 ;;T48.993A
 ;;9002226.02101,"873,T48.993A ",.02)
 ;;T48.993A
 ;;9002226.02101,"873,T48.993A ",.03)
 ;;30
 ;;9002226.02101,"873,T48.994A ",.01)
 ;;T48.994A
 ;;9002226.02101,"873,T48.994A ",.02)
 ;;T48.994A
 ;;9002226.02101,"873,T48.994A ",.03)
 ;;30
 ;;9002226.02101,"873,T49.0X1A ",.01)
 ;;T49.0X1A
 ;;9002226.02101,"873,T49.0X1A ",.02)
 ;;T49.0X1A
 ;;9002226.02101,"873,T49.0X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T49.0X2A ",.01)
 ;;T49.0X2A
 ;;9002226.02101,"873,T49.0X2A ",.02)
 ;;T49.0X2A
 ;;9002226.02101,"873,T49.0X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T49.0X3A ",.01)
 ;;T49.0X3A
 ;;9002226.02101,"873,T49.0X3A ",.02)
 ;;T49.0X3A
 ;;9002226.02101,"873,T49.0X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T49.0X4A ",.01)
 ;;T49.0X4A
 ;;9002226.02101,"873,T49.0X4A ",.02)
 ;;T49.0X4A
 ;;9002226.02101,"873,T49.0X4A ",.03)
 ;;30
 ;;9002226.02101,"873,T49.1X1A ",.01)
 ;;T49.1X1A
 ;;9002226.02101,"873,T49.1X1A ",.02)
 ;;T49.1X1A
 ;;9002226.02101,"873,T49.1X1A ",.03)
 ;;30
 ;;9002226.02101,"873,T49.1X2A ",.01)
 ;;T49.1X2A
 ;;9002226.02101,"873,T49.1X2A ",.02)
 ;;T49.1X2A
 ;;9002226.02101,"873,T49.1X2A ",.03)
 ;;30
 ;;9002226.02101,"873,T49.1X3A ",.01)
 ;;T49.1X3A
 ;;9002226.02101,"873,T49.1X3A ",.02)
 ;;T49.1X3A
 ;;9002226.02101,"873,T49.1X3A ",.03)
 ;;30
 ;;9002226.02101,"873,T49.1X4A ",.01)
 ;;T49.1X4A
 ;;9002226.02101,"873,T49.1X4A ",.02)
 ;;T49.1X4A