ATXD5T7 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 12, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"173,T45.7X2A ",.02)
 ;;T45.7X2A 
 ;;9002226.02101,"173,T45.7X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T45.7X2D ",.01)
 ;;T45.7X2D 
 ;;9002226.02101,"173,T45.7X2D ",.02)
 ;;T45.7X2D 
 ;;9002226.02101,"173,T45.7X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T45.7X2S ",.01)
 ;;T45.7X2S 
 ;;9002226.02101,"173,T45.7X2S ",.02)
 ;;T45.7X2S 
 ;;9002226.02101,"173,T45.7X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T45.8X2A ",.01)
 ;;T45.8X2A 
 ;;9002226.02101,"173,T45.8X2A ",.02)
 ;;T45.8X2A 
 ;;9002226.02101,"173,T45.8X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T45.8X2D ",.01)
 ;;T45.8X2D 
 ;;9002226.02101,"173,T45.8X2D ",.02)
 ;;T45.8X2D 
 ;;9002226.02101,"173,T45.8X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T45.8X2S ",.01)
 ;;T45.8X2S 
 ;;9002226.02101,"173,T45.8X2S ",.02)
 ;;T45.8X2S 
 ;;9002226.02101,"173,T45.8X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T45.92XA ",.01)
 ;;T45.92XA 
 ;;9002226.02101,"173,T45.92XA ",.02)
 ;;T45.92XA 
 ;;9002226.02101,"173,T45.92XA ",.03)
 ;;30
 ;;9002226.02101,"173,T45.92XD ",.01)
 ;;T45.92XD 
 ;;9002226.02101,"173,T45.92XD ",.02)
 ;;T45.92XD 
 ;;9002226.02101,"173,T45.92XD ",.03)
 ;;30
 ;;9002226.02101,"173,T45.92XS ",.01)
 ;;T45.92XS 
 ;;9002226.02101,"173,T45.92XS ",.02)
 ;;T45.92XS 
 ;;9002226.02101,"173,T45.92XS ",.03)
 ;;30
 ;;9002226.02101,"173,T46.0X2A ",.01)
 ;;T46.0X2A 
 ;;9002226.02101,"173,T46.0X2A ",.02)
 ;;T46.0X2A 
 ;;9002226.02101,"173,T46.0X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T46.0X2D ",.01)
 ;;T46.0X2D 
 ;;9002226.02101,"173,T46.0X2D ",.02)
 ;;T46.0X2D 
 ;;9002226.02101,"173,T46.0X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T46.0X2S ",.01)
 ;;T46.0X2S 
 ;;9002226.02101,"173,T46.0X2S ",.02)
 ;;T46.0X2S 
 ;;9002226.02101,"173,T46.0X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T46.1X2A ",.01)
 ;;T46.1X2A 
 ;;9002226.02101,"173,T46.1X2A ",.02)
 ;;T46.1X2A 
 ;;9002226.02101,"173,T46.1X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T46.1X2D ",.01)
 ;;T46.1X2D 
 ;;9002226.02101,"173,T46.1X2D ",.02)
 ;;T46.1X2D 
 ;;9002226.02101,"173,T46.1X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T46.1X2S ",.01)
 ;;T46.1X2S 
 ;;9002226.02101,"173,T46.1X2S ",.02)
 ;;T46.1X2S 
 ;;9002226.02101,"173,T46.1X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T46.2X2A ",.01)
 ;;T46.2X2A 
 ;;9002226.02101,"173,T46.2X2A ",.02)
 ;;T46.2X2A 
 ;;9002226.02101,"173,T46.2X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T46.2X2D ",.01)
 ;;T46.2X2D 
 ;;9002226.02101,"173,T46.2X2D ",.02)
 ;;T46.2X2D 
 ;;9002226.02101,"173,T46.2X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T46.2X2S ",.01)
 ;;T46.2X2S 
 ;;9002226.02101,"173,T46.2X2S ",.02)
 ;;T46.2X2S 
 ;;9002226.02101,"173,T46.2X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T46.3X2A ",.01)
 ;;T46.3X2A 
 ;;9002226.02101,"173,T46.3X2A ",.02)
 ;;T46.3X2A 
 ;;9002226.02101,"173,T46.3X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T46.3X2D ",.01)
 ;;T46.3X2D 
 ;;9002226.02101,"173,T46.3X2D ",.02)
 ;;T46.3X2D 
 ;;9002226.02101,"173,T46.3X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T46.3X2S ",.01)
 ;;T46.3X2S 
 ;;9002226.02101,"173,T46.3X2S ",.02)
 ;;T46.3X2S 
 ;;9002226.02101,"173,T46.3X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T46.4X2A ",.01)
 ;;T46.4X2A 
 ;;9002226.02101,"173,T46.4X2A ",.02)
 ;;T46.4X2A 
 ;;9002226.02101,"173,T46.4X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T46.4X2D ",.01)
 ;;T46.4X2D 
 ;;9002226.02101,"173,T46.4X2D ",.02)
 ;;T46.4X2D 
 ;;9002226.02101,"173,T46.4X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T46.4X2S ",.01)
 ;;T46.4X2S 
 ;;9002226.02101,"173,T46.4X2S ",.02)
 ;;T46.4X2S 
 ;;9002226.02101,"173,T46.4X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T46.5X2A ",.01)
 ;;T46.5X2A 
 ;;9002226.02101,"173,T46.5X2A ",.02)
 ;;T46.5X2A 
 ;;9002226.02101,"173,T46.5X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T46.5X2D ",.01)
 ;;T46.5X2D 
 ;;9002226.02101,"173,T46.5X2D ",.02)
 ;;T46.5X2D 
 ;;9002226.02101,"173,T46.5X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T46.5X2S ",.01)
 ;;T46.5X2S 
 ;;9002226.02101,"173,T46.5X2S ",.02)
 ;;T46.5X2S 
 ;;9002226.02101,"173,T46.5X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T46.6X2A ",.01)
 ;;T46.6X2A 
 ;;9002226.02101,"173,T46.6X2A ",.02)
 ;;T46.6X2A 
 ;;9002226.02101,"173,T46.6X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T46.6X2D ",.01)
 ;;T46.6X2D 
 ;;9002226.02101,"173,T46.6X2D ",.02)
 ;;T46.6X2D 
 ;;9002226.02101,"173,T46.6X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T46.6X2S ",.01)
 ;;T46.6X2S 
 ;;9002226.02101,"173,T46.6X2S ",.02)
 ;;T46.6X2S 
 ;;9002226.02101,"173,T46.6X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T46.7X2A ",.01)
 ;;T46.7X2A 
 ;;9002226.02101,"173,T46.7X2A ",.02)
 ;;T46.7X2A 
 ;;9002226.02101,"173,T46.7X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T46.7X2D ",.01)
 ;;T46.7X2D 
 ;;9002226.02101,"173,T46.7X2D ",.02)
 ;;T46.7X2D 
 ;;9002226.02101,"173,T46.7X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T46.7X2S ",.01)
 ;;T46.7X2S 
 ;;9002226.02101,"173,T46.7X2S ",.02)
 ;;T46.7X2S 
 ;;9002226.02101,"173,T46.7X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T46.8X2A ",.01)
 ;;T46.8X2A 
 ;;9002226.02101,"173,T46.8X2A ",.02)
 ;;T46.8X2A 
 ;;9002226.02101,"173,T46.8X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T46.8X2D ",.01)
 ;;T46.8X2D 
 ;;9002226.02101,"173,T46.8X2D ",.02)
 ;;T46.8X2D 
 ;;9002226.02101,"173,T46.8X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T46.8X2S ",.01)
 ;;T46.8X2S 
 ;;9002226.02101,"173,T46.8X2S ",.02)
 ;;T46.8X2S 
 ;;9002226.02101,"173,T46.8X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T46.902A ",.01)
 ;;T46.902A 
 ;;9002226.02101,"173,T46.902A ",.02)
 ;;T46.902A 
 ;;9002226.02101,"173,T46.902A ",.03)
 ;;30
 ;;9002226.02101,"173,T46.902D ",.01)
 ;;T46.902D 
 ;;9002226.02101,"173,T46.902D ",.02)
 ;;T46.902D 
 ;;9002226.02101,"173,T46.902D ",.03)
 ;;30
 ;;9002226.02101,"173,T46.902S ",.01)
 ;;T46.902S 
 ;;9002226.02101,"173,T46.902S ",.02)
 ;;T46.902S 
 ;;9002226.02101,"173,T46.902S ",.03)
 ;;30
 ;;9002226.02101,"173,T46.992A ",.01)
 ;;T46.992A 
 ;;9002226.02101,"173,T46.992A ",.02)
 ;;T46.992A 
 ;;9002226.02101,"173,T46.992A ",.03)
 ;;30
 ;;9002226.02101,"173,T46.992D ",.01)
 ;;T46.992D 
 ;;9002226.02101,"173,T46.992D ",.02)
 ;;T46.992D 
 ;;9002226.02101,"173,T46.992D ",.03)
 ;;30
 ;;9002226.02101,"173,T46.992S ",.01)
 ;;T46.992S 
 ;;9002226.02101,"173,T46.992S ",.02)
 ;;T46.992S 
 ;;9002226.02101,"173,T46.992S ",.03)
 ;;30
 ;;9002226.02101,"173,T47.0X2A ",.01)
 ;;T47.0X2A 
 ;;9002226.02101,"173,T47.0X2A ",.02)
 ;;T47.0X2A 
 ;;9002226.02101,"173,T47.0X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T47.0X2D ",.01)
 ;;T47.0X2D 
 ;;9002226.02101,"173,T47.0X2D ",.02)
 ;;T47.0X2D 
 ;;9002226.02101,"173,T47.0X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T47.0X2S ",.01)
 ;;T47.0X2S 
 ;;9002226.02101,"173,T47.0X2S ",.02)
 ;;T47.0X2S 
 ;;9002226.02101,"173,T47.0X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T47.1X2A ",.01)
 ;;T47.1X2A 
 ;;9002226.02101,"173,T47.1X2A ",.02)
 ;;T47.1X2A 
 ;;9002226.02101,"173,T47.1X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T47.1X2D ",.01)
 ;;T47.1X2D 
 ;;9002226.02101,"173,T47.1X2D ",.02)
 ;;T47.1X2D 
 ;;9002226.02101,"173,T47.1X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T47.1X2S ",.01)
 ;;T47.1X2S 
 ;;9002226.02101,"173,T47.1X2S ",.02)
 ;;T47.1X2S 
 ;;9002226.02101,"173,T47.1X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T47.2X2A ",.01)
 ;;T47.2X2A 
 ;;9002226.02101,"173,T47.2X2A ",.02)
 ;;T47.2X2A 
 ;;9002226.02101,"173,T47.2X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T47.2X2D ",.01)
 ;;T47.2X2D 
 ;;9002226.02101,"173,T47.2X2D ",.02)
 ;;T47.2X2D 
 ;;9002226.02101,"173,T47.2X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T47.2X2S ",.01)
 ;;T47.2X2S 
 ;;9002226.02101,"173,T47.2X2S ",.02)
 ;;T47.2X2S 
 ;;9002226.02101,"173,T47.2X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T47.3X2A ",.01)
 ;;T47.3X2A 
 ;;9002226.02101,"173,T47.3X2A ",.02)
 ;;T47.3X2A 
 ;;9002226.02101,"173,T47.3X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T47.3X2D ",.01)
 ;;T47.3X2D 
 ;;9002226.02101,"173,T47.3X2D ",.02)
 ;;T47.3X2D 
 ;;9002226.02101,"173,T47.3X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T47.3X2S ",.01)
 ;;T47.3X2S 
 ;;9002226.02101,"173,T47.3X2S ",.02)
 ;;T47.3X2S 
 ;;9002226.02101,"173,T47.3X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T47.4X2A ",.01)
 ;;T47.4X2A 
 ;;9002226.02101,"173,T47.4X2A ",.02)
 ;;T47.4X2A 
 ;;9002226.02101,"173,T47.4X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T47.4X2D ",.01)
 ;;T47.4X2D 
 ;;9002226.02101,"173,T47.4X2D ",.02)
 ;;T47.4X2D 
 ;;9002226.02101,"173,T47.4X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T47.4X2S ",.01)
 ;;T47.4X2S 
 ;;9002226.02101,"173,T47.4X2S ",.02)
 ;;T47.4X2S 
 ;;9002226.02101,"173,T47.4X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T47.5X2A ",.01)
 ;;T47.5X2A 
 ;;9002226.02101,"173,T47.5X2A ",.02)
 ;;T47.5X2A 
 ;;9002226.02101,"173,T47.5X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T47.5X2D ",.01)
 ;;T47.5X2D 
 ;;9002226.02101,"173,T47.5X2D ",.02)
 ;;T47.5X2D 
 ;;9002226.02101,"173,T47.5X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T47.5X2S ",.01)
 ;;T47.5X2S 
 ;;9002226.02101,"173,T47.5X2S ",.02)
 ;;T47.5X2S 
 ;;9002226.02101,"173,T47.5X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T47.6X2A ",.01)
 ;;T47.6X2A 
 ;;9002226.02101,"173,T47.6X2A ",.02)
 ;;T47.6X2A 
 ;;9002226.02101,"173,T47.6X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T47.6X2D ",.01)
 ;;T47.6X2D 
 ;;9002226.02101,"173,T47.6X2D ",.02)
 ;;T47.6X2D 
 ;;9002226.02101,"173,T47.6X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T47.6X2S ",.01)
 ;;T47.6X2S 
 ;;9002226.02101,"173,T47.6X2S ",.02)
 ;;T47.6X2S 
 ;;9002226.02101,"173,T47.6X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T47.7X2A ",.01)
 ;;T47.7X2A 
 ;;9002226.02101,"173,T47.7X2A ",.02)
 ;;T47.7X2A 
 ;;9002226.02101,"173,T47.7X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T47.7X2D ",.01)
 ;;T47.7X2D 
 ;;9002226.02101,"173,T47.7X2D ",.02)
 ;;T47.7X2D 
 ;;9002226.02101,"173,T47.7X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T47.7X2S ",.01)
 ;;T47.7X2S 
 ;;9002226.02101,"173,T47.7X2S ",.02)
 ;;T47.7X2S 
 ;;9002226.02101,"173,T47.7X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T47.8X2A ",.01)
 ;;T47.8X2A 
 ;;9002226.02101,"173,T47.8X2A ",.02)
 ;;T47.8X2A 
 ;;9002226.02101,"173,T47.8X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T47.8X2D ",.01)
 ;;T47.8X2D 
 ;;9002226.02101,"173,T47.8X2D ",.02)
 ;;T47.8X2D 
 ;;9002226.02101,"173,T47.8X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T47.8X2S ",.01)
 ;;T47.8X2S 
 ;;9002226.02101,"173,T47.8X2S ",.02)
 ;;T47.8X2S 
 ;;9002226.02101,"173,T47.8X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T47.92XA ",.01)
 ;;T47.92XA 
 ;;9002226.02101,"173,T47.92XA ",.02)
 ;;T47.92XA 
 ;;9002226.02101,"173,T47.92XA ",.03)
 ;;30
 ;;9002226.02101,"173,T47.92XD ",.01)
 ;;T47.92XD 
 ;;9002226.02101,"173,T47.92XD ",.02)
 ;;T47.92XD 
 ;;9002226.02101,"173,T47.92XD ",.03)
 ;;30
 ;;9002226.02101,"173,T47.92XS ",.01)
 ;;T47.92XS 
 ;;9002226.02101,"173,T47.92XS ",.02)
 ;;T47.92XS 
 ;;9002226.02101,"173,T47.92XS ",.03)
 ;;30
 ;;9002226.02101,"173,T48.0X2A ",.01)
 ;;T48.0X2A 
 ;;9002226.02101,"173,T48.0X2A ",.02)
 ;;T48.0X2A 
 ;;9002226.02101,"173,T48.0X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T48.0X2D ",.01)
 ;;T48.0X2D 
 ;;9002226.02101,"173,T48.0X2D ",.02)
 ;;T48.0X2D 
 ;;9002226.02101,"173,T48.0X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T48.0X2S ",.01)
 ;;T48.0X2S 
 ;;9002226.02101,"173,T48.0X2S ",.02)
 ;;T48.0X2S 
 ;;9002226.02101,"173,T48.0X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T48.1X2A ",.01)
 ;;T48.1X2A 
 ;;9002226.02101,"173,T48.1X2A ",.02)
 ;;T48.1X2A 
 ;;9002226.02101,"173,T48.1X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T48.1X2D ",.01)
 ;;T48.1X2D 
 ;;9002226.02101,"173,T48.1X2D ",.02)
 ;;T48.1X2D 
 ;;9002226.02101,"173,T48.1X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T48.1X2S ",.01)
 ;;T48.1X2S 
 ;;9002226.02101,"173,T48.1X2S ",.02)
 ;;T48.1X2S 
 ;;9002226.02101,"173,T48.1X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T48.202A ",.01)
 ;;T48.202A 
 ;;9002226.02101,"173,T48.202A ",.02)
 ;;T48.202A 
 ;;9002226.02101,"173,T48.202A ",.03)
 ;;30
 ;;9002226.02101,"173,T48.202D ",.01)
 ;;T48.202D 
 ;;9002226.02101,"173,T48.202D ",.02)
 ;;T48.202D 
 ;;9002226.02101,"173,T48.202D ",.03)
 ;;30
 ;;9002226.02101,"173,T48.202S ",.01)
 ;;T48.202S 
 ;;9002226.02101,"173,T48.202S ",.02)
 ;;T48.202S 
 ;;9002226.02101,"173,T48.202S ",.03)
 ;;30
 ;;9002226.02101,"173,T48.292A ",.01)
 ;;T48.292A 
 ;;9002226.02101,"173,T48.292A ",.02)
 ;;T48.292A 
 ;;9002226.02101,"173,T48.292A ",.03)
 ;;30
 ;;9002226.02101,"173,T48.292D ",.01)
 ;;T48.292D 
 ;;9002226.02101,"173,T48.292D ",.02)
 ;;T48.292D 
 ;;9002226.02101,"173,T48.292D ",.03)
 ;;30
 ;;9002226.02101,"173,T48.292S ",.01)
 ;;T48.292S 
 ;;9002226.02101,"173,T48.292S ",.02)
 ;;T48.292S 
 ;;9002226.02101,"173,T48.292S ",.03)
 ;;30
 ;;9002226.02101,"173,T48.3X2A ",.01)
 ;;T48.3X2A 
 ;;9002226.02101,"173,T48.3X2A ",.02)
 ;;T48.3X2A 
 ;;9002226.02101,"173,T48.3X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T48.3X2D ",.01)
 ;;T48.3X2D 
 ;;9002226.02101,"173,T48.3X2D ",.02)
 ;;T48.3X2D 
 ;;9002226.02101,"173,T48.3X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T48.3X2S ",.01)
 ;;T48.3X2S 
 ;;9002226.02101,"173,T48.3X2S ",.02)
 ;;T48.3X2S 
 ;;9002226.02101,"173,T48.3X2S ",.03)
 ;;30
 ;;9002226.02101,"173,T48.4X2A ",.01)
 ;;T48.4X2A 
 ;;9002226.02101,"173,T48.4X2A ",.02)
 ;;T48.4X2A 
 ;;9002226.02101,"173,T48.4X2A ",.03)
 ;;30
 ;;9002226.02101,"173,T48.4X2D ",.01)
 ;;T48.4X2D 
 ;;9002226.02101,"173,T48.4X2D ",.02)
 ;;T48.4X2D 
 ;;9002226.02101,"173,T48.4X2D ",.03)
 ;;30
 ;;9002226.02101,"173,T48.4X2S ",.01)
 ;;T48.4X2S 
 ;;9002226.02101,"173,T48.4X2S ",.02)
 ;;T48.4X2S 
 ;;9002226.02101,"173,T48.4X2S ",.03)
 ;;30