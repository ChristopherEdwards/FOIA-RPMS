ATXD5G11 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 12, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"160,T59.3X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T59.4X3A ",.01)
 ;;T59.4X3A 
 ;;9002226.02101,"160,T59.4X3A ",.02)
 ;;T59.4X3A 
 ;;9002226.02101,"160,T59.4X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T59.4X3D ",.01)
 ;;T59.4X3D 
 ;;9002226.02101,"160,T59.4X3D ",.02)
 ;;T59.4X3D 
 ;;9002226.02101,"160,T59.4X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T59.4X3S ",.01)
 ;;T59.4X3S 
 ;;9002226.02101,"160,T59.4X3S ",.02)
 ;;T59.4X3S 
 ;;9002226.02101,"160,T59.4X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T59.5X3A ",.01)
 ;;T59.5X3A 
 ;;9002226.02101,"160,T59.5X3A ",.02)
 ;;T59.5X3A 
 ;;9002226.02101,"160,T59.5X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T59.5X3D ",.01)
 ;;T59.5X3D 
 ;;9002226.02101,"160,T59.5X3D ",.02)
 ;;T59.5X3D 
 ;;9002226.02101,"160,T59.5X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T59.5X3S ",.01)
 ;;T59.5X3S 
 ;;9002226.02101,"160,T59.5X3S ",.02)
 ;;T59.5X3S 
 ;;9002226.02101,"160,T59.5X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T59.6X3A ",.01)
 ;;T59.6X3A 
 ;;9002226.02101,"160,T59.6X3A ",.02)
 ;;T59.6X3A 
 ;;9002226.02101,"160,T59.6X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T59.6X3D ",.01)
 ;;T59.6X3D 
 ;;9002226.02101,"160,T59.6X3D ",.02)
 ;;T59.6X3D 
 ;;9002226.02101,"160,T59.6X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T59.6X3S ",.01)
 ;;T59.6X3S 
 ;;9002226.02101,"160,T59.6X3S ",.02)
 ;;T59.6X3S 
 ;;9002226.02101,"160,T59.6X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T59.7X3A ",.01)
 ;;T59.7X3A 
 ;;9002226.02101,"160,T59.7X3A ",.02)
 ;;T59.7X3A 
 ;;9002226.02101,"160,T59.7X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T59.7X3D ",.01)
 ;;T59.7X3D 
 ;;9002226.02101,"160,T59.7X3D ",.02)
 ;;T59.7X3D 
 ;;9002226.02101,"160,T59.7X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T59.7X3S ",.01)
 ;;T59.7X3S 
 ;;9002226.02101,"160,T59.7X3S ",.02)
 ;;T59.7X3S 
 ;;9002226.02101,"160,T59.7X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T59.813A ",.01)
 ;;T59.813A 
 ;;9002226.02101,"160,T59.813A ",.02)
 ;;T59.813A 
 ;;9002226.02101,"160,T59.813A ",.03)
 ;;30
 ;;9002226.02101,"160,T59.813D ",.01)
 ;;T59.813D 
 ;;9002226.02101,"160,T59.813D ",.02)
 ;;T59.813D 
 ;;9002226.02101,"160,T59.813D ",.03)
 ;;30
 ;;9002226.02101,"160,T59.813S ",.01)
 ;;T59.813S 
 ;;9002226.02101,"160,T59.813S ",.02)
 ;;T59.813S 
 ;;9002226.02101,"160,T59.813S ",.03)
 ;;30
 ;;9002226.02101,"160,T59.893A ",.01)
 ;;T59.893A 
 ;;9002226.02101,"160,T59.893A ",.02)
 ;;T59.893A 
 ;;9002226.02101,"160,T59.893A ",.03)
 ;;30
 ;;9002226.02101,"160,T59.893D ",.01)
 ;;T59.893D 
 ;;9002226.02101,"160,T59.893D ",.02)
 ;;T59.893D 
 ;;9002226.02101,"160,T59.893D ",.03)
 ;;30
 ;;9002226.02101,"160,T59.893S ",.01)
 ;;T59.893S 
 ;;9002226.02101,"160,T59.893S ",.02)
 ;;T59.893S 
 ;;9002226.02101,"160,T59.893S ",.03)
 ;;30
 ;;9002226.02101,"160,T59.93XA ",.01)
 ;;T59.93XA 
 ;;9002226.02101,"160,T59.93XA ",.02)
 ;;T59.93XA 
 ;;9002226.02101,"160,T59.93XA ",.03)
 ;;30
 ;;9002226.02101,"160,T59.93XD ",.01)
 ;;T59.93XD 
 ;;9002226.02101,"160,T59.93XD ",.02)
 ;;T59.93XD 
 ;;9002226.02101,"160,T59.93XD ",.03)
 ;;30
 ;;9002226.02101,"160,T59.93XS ",.01)
 ;;T59.93XS 
 ;;9002226.02101,"160,T59.93XS ",.02)
 ;;T59.93XS 
 ;;9002226.02101,"160,T59.93XS ",.03)
 ;;30
 ;;9002226.02101,"160,T60.0X3A ",.01)
 ;;T60.0X3A 
 ;;9002226.02101,"160,T60.0X3A ",.02)
 ;;T60.0X3A 
 ;;9002226.02101,"160,T60.0X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T60.0X3D ",.01)
 ;;T60.0X3D 
 ;;9002226.02101,"160,T60.0X3D ",.02)
 ;;T60.0X3D 
 ;;9002226.02101,"160,T60.0X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T60.0X3S ",.01)
 ;;T60.0X3S 
 ;;9002226.02101,"160,T60.0X3S ",.02)
 ;;T60.0X3S 
 ;;9002226.02101,"160,T60.0X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T60.1X3A ",.01)
 ;;T60.1X3A 
 ;;9002226.02101,"160,T60.1X3A ",.02)
 ;;T60.1X3A 
 ;;9002226.02101,"160,T60.1X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T60.1X3D ",.01)
 ;;T60.1X3D 
 ;;9002226.02101,"160,T60.1X3D ",.02)
 ;;T60.1X3D 
 ;;9002226.02101,"160,T60.1X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T60.1X3S ",.01)
 ;;T60.1X3S 
 ;;9002226.02101,"160,T60.1X3S ",.02)
 ;;T60.1X3S 
 ;;9002226.02101,"160,T60.1X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T60.2X3A ",.01)
 ;;T60.2X3A 
 ;;9002226.02101,"160,T60.2X3A ",.02)
 ;;T60.2X3A 
 ;;9002226.02101,"160,T60.2X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T60.2X3D ",.01)
 ;;T60.2X3D 
 ;;9002226.02101,"160,T60.2X3D ",.02)
 ;;T60.2X3D 
 ;;9002226.02101,"160,T60.2X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T60.2X3S ",.01)
 ;;T60.2X3S 
 ;;9002226.02101,"160,T60.2X3S ",.02)
 ;;T60.2X3S 
 ;;9002226.02101,"160,T60.2X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T60.3X3A ",.01)
 ;;T60.3X3A 
 ;;9002226.02101,"160,T60.3X3A ",.02)
 ;;T60.3X3A 
 ;;9002226.02101,"160,T60.3X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T60.3X3D ",.01)
 ;;T60.3X3D 
 ;;9002226.02101,"160,T60.3X3D ",.02)
 ;;T60.3X3D 
 ;;9002226.02101,"160,T60.3X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T60.3X3S ",.01)
 ;;T60.3X3S 
 ;;9002226.02101,"160,T60.3X3S ",.02)
 ;;T60.3X3S 
 ;;9002226.02101,"160,T60.3X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T60.4X3A ",.01)
 ;;T60.4X3A 
 ;;9002226.02101,"160,T60.4X3A ",.02)
 ;;T60.4X3A 
 ;;9002226.02101,"160,T60.4X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T60.4X3D ",.01)
 ;;T60.4X3D 
 ;;9002226.02101,"160,T60.4X3D ",.02)
 ;;T60.4X3D 
 ;;9002226.02101,"160,T60.4X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T60.4X3S ",.01)
 ;;T60.4X3S 
 ;;9002226.02101,"160,T60.4X3S ",.02)
 ;;T60.4X3S 
 ;;9002226.02101,"160,T60.4X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T60.8X3A ",.01)
 ;;T60.8X3A 
 ;;9002226.02101,"160,T60.8X3A ",.02)
 ;;T60.8X3A 
 ;;9002226.02101,"160,T60.8X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T60.8X3D ",.01)
 ;;T60.8X3D 
 ;;9002226.02101,"160,T60.8X3D ",.02)
 ;;T60.8X3D 
 ;;9002226.02101,"160,T60.8X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T60.8X3S ",.01)
 ;;T60.8X3S 
 ;;9002226.02101,"160,T60.8X3S ",.02)
 ;;T60.8X3S 
 ;;9002226.02101,"160,T60.8X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T60.93XA ",.01)
 ;;T60.93XA 
 ;;9002226.02101,"160,T60.93XA ",.02)
 ;;T60.93XA 
 ;;9002226.02101,"160,T60.93XA ",.03)
 ;;30
 ;;9002226.02101,"160,T60.93XD ",.01)
 ;;T60.93XD 
 ;;9002226.02101,"160,T60.93XD ",.02)
 ;;T60.93XD 
 ;;9002226.02101,"160,T60.93XD ",.03)
 ;;30
 ;;9002226.02101,"160,T60.93XS ",.01)
 ;;T60.93XS 
 ;;9002226.02101,"160,T60.93XS ",.02)
 ;;T60.93XS 
 ;;9002226.02101,"160,T60.93XS ",.03)
 ;;30
 ;;9002226.02101,"160,T61.03XA ",.01)
 ;;T61.03XA 
 ;;9002226.02101,"160,T61.03XA ",.02)
 ;;T61.03XA 
 ;;9002226.02101,"160,T61.03XA ",.03)
 ;;30
 ;;9002226.02101,"160,T61.03XD ",.01)
 ;;T61.03XD 
 ;;9002226.02101,"160,T61.03XD ",.02)
 ;;T61.03XD 
 ;;9002226.02101,"160,T61.03XD ",.03)
 ;;30
 ;;9002226.02101,"160,T61.03XS ",.01)
 ;;T61.03XS 
 ;;9002226.02101,"160,T61.03XS ",.02)
 ;;T61.03XS 
 ;;9002226.02101,"160,T61.03XS ",.03)
 ;;30
 ;;9002226.02101,"160,T61.13XA ",.01)
 ;;T61.13XA 
 ;;9002226.02101,"160,T61.13XA ",.02)
 ;;T61.13XA 
 ;;9002226.02101,"160,T61.13XA ",.03)
 ;;30
 ;;9002226.02101,"160,T61.13XD ",.01)
 ;;T61.13XD 
 ;;9002226.02101,"160,T61.13XD ",.02)
 ;;T61.13XD 
 ;;9002226.02101,"160,T61.13XD ",.03)
 ;;30
 ;;9002226.02101,"160,T61.13XS ",.01)
 ;;T61.13XS 
 ;;9002226.02101,"160,T61.13XS ",.02)
 ;;T61.13XS 
 ;;9002226.02101,"160,T61.13XS ",.03)
 ;;30
 ;;9002226.02101,"160,T61.773A ",.01)
 ;;T61.773A 
 ;;9002226.02101,"160,T61.773A ",.02)
 ;;T61.773A 
 ;;9002226.02101,"160,T61.773A ",.03)
 ;;30
 ;;9002226.02101,"160,T61.773D ",.01)
 ;;T61.773D 
 ;;9002226.02101,"160,T61.773D ",.02)
 ;;T61.773D 
 ;;9002226.02101,"160,T61.773D ",.03)
 ;;30
 ;;9002226.02101,"160,T61.773S ",.01)
 ;;T61.773S 
 ;;9002226.02101,"160,T61.773S ",.02)
 ;;T61.773S 
 ;;9002226.02101,"160,T61.773S ",.03)
 ;;30
 ;;9002226.02101,"160,T61.783A ",.01)
 ;;T61.783A 
 ;;9002226.02101,"160,T61.783A ",.02)
 ;;T61.783A 
 ;;9002226.02101,"160,T61.783A ",.03)
 ;;30
 ;;9002226.02101,"160,T61.783D ",.01)
 ;;T61.783D 
 ;;9002226.02101,"160,T61.783D ",.02)
 ;;T61.783D 
 ;;9002226.02101,"160,T61.783D ",.03)
 ;;30
 ;;9002226.02101,"160,T61.783S ",.01)
 ;;T61.783S 
 ;;9002226.02101,"160,T61.783S ",.02)
 ;;T61.783S 
 ;;9002226.02101,"160,T61.783S ",.03)
 ;;30
 ;;9002226.02101,"160,T61.8X3A ",.01)
 ;;T61.8X3A 
 ;;9002226.02101,"160,T61.8X3A ",.02)
 ;;T61.8X3A 
 ;;9002226.02101,"160,T61.8X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T61.8X3D ",.01)
 ;;T61.8X3D 
 ;;9002226.02101,"160,T61.8X3D ",.02)
 ;;T61.8X3D 
 ;;9002226.02101,"160,T61.8X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T61.8X3S ",.01)
 ;;T61.8X3S 
 ;;9002226.02101,"160,T61.8X3S ",.02)
 ;;T61.8X3S 
 ;;9002226.02101,"160,T61.8X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T61.93XA ",.01)
 ;;T61.93XA 
 ;;9002226.02101,"160,T61.93XA ",.02)
 ;;T61.93XA 
 ;;9002226.02101,"160,T61.93XA ",.03)
 ;;30
 ;;9002226.02101,"160,T61.93XD ",.01)
 ;;T61.93XD 
 ;;9002226.02101,"160,T61.93XD ",.02)
 ;;T61.93XD 
 ;;9002226.02101,"160,T61.93XD ",.03)
 ;;30
 ;;9002226.02101,"160,T61.93XS ",.01)
 ;;T61.93XS 
 ;;9002226.02101,"160,T61.93XS ",.02)
 ;;T61.93XS 
 ;;9002226.02101,"160,T61.93XS ",.03)
 ;;30
 ;;9002226.02101,"160,T62.0X3A ",.01)
 ;;T62.0X3A 
 ;;9002226.02101,"160,T62.0X3A ",.02)
 ;;T62.0X3A 
 ;;9002226.02101,"160,T62.0X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T62.0X3D ",.01)
 ;;T62.0X3D 
 ;;9002226.02101,"160,T62.0X3D ",.02)
 ;;T62.0X3D 
 ;;9002226.02101,"160,T62.0X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T62.0X3S ",.01)
 ;;T62.0X3S 
 ;;9002226.02101,"160,T62.0X3S ",.02)
 ;;T62.0X3S 
 ;;9002226.02101,"160,T62.0X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T62.1X3A ",.01)
 ;;T62.1X3A 
 ;;9002226.02101,"160,T62.1X3A ",.02)
 ;;T62.1X3A 
 ;;9002226.02101,"160,T62.1X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T62.1X3D ",.01)
 ;;T62.1X3D 
 ;;9002226.02101,"160,T62.1X3D ",.02)
 ;;T62.1X3D 
 ;;9002226.02101,"160,T62.1X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T62.1X3S ",.01)
 ;;T62.1X3S 
 ;;9002226.02101,"160,T62.1X3S ",.02)
 ;;T62.1X3S 
 ;;9002226.02101,"160,T62.1X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T62.2X3A ",.01)
 ;;T62.2X3A 
 ;;9002226.02101,"160,T62.2X3A ",.02)
 ;;T62.2X3A 
 ;;9002226.02101,"160,T62.2X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T62.2X3D ",.01)
 ;;T62.2X3D 
 ;;9002226.02101,"160,T62.2X3D ",.02)
 ;;T62.2X3D 
 ;;9002226.02101,"160,T62.2X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T62.2X3S ",.01)
 ;;T62.2X3S 
 ;;9002226.02101,"160,T62.2X3S ",.02)
 ;;T62.2X3S 
 ;;9002226.02101,"160,T62.2X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T62.8X3A ",.01)
 ;;T62.8X3A 
 ;;9002226.02101,"160,T62.8X3A ",.02)
 ;;T62.8X3A 
 ;;9002226.02101,"160,T62.8X3A ",.03)
 ;;30
 ;;9002226.02101,"160,T62.8X3D ",.01)
 ;;T62.8X3D 
 ;;9002226.02101,"160,T62.8X3D ",.02)
 ;;T62.8X3D 
 ;;9002226.02101,"160,T62.8X3D ",.03)
 ;;30
 ;;9002226.02101,"160,T62.8X3S ",.01)
 ;;T62.8X3S 
 ;;9002226.02101,"160,T62.8X3S ",.02)
 ;;T62.8X3S 
 ;;9002226.02101,"160,T62.8X3S ",.03)
 ;;30
 ;;9002226.02101,"160,T62.93XA ",.01)
 ;;T62.93XA 
 ;;9002226.02101,"160,T62.93XA ",.02)
 ;;T62.93XA 
 ;;9002226.02101,"160,T62.93XA ",.03)
 ;;30
 ;;9002226.02101,"160,T62.93XD ",.01)
 ;;T62.93XD 
 ;;9002226.02101,"160,T62.93XD ",.02)
 ;;T62.93XD 
 ;;9002226.02101,"160,T62.93XD ",.03)
 ;;30
 ;;9002226.02101,"160,T62.93XS ",.01)
 ;;T62.93XS 
 ;;9002226.02101,"160,T62.93XS ",.02)
 ;;T62.93XS 
 ;;9002226.02101,"160,T62.93XS ",.03)
 ;;30
 ;;9002226.02101,"160,T63.003A ",.01)
 ;;T63.003A 
 ;;9002226.02101,"160,T63.003A ",.02)
 ;;T63.003A 
 ;;9002226.02101,"160,T63.003A ",.03)
 ;;30
 ;;9002226.02101,"160,T63.003D ",.01)
 ;;T63.003D 
 ;;9002226.02101,"160,T63.003D ",.02)
 ;;T63.003D 
 ;;9002226.02101,"160,T63.003D ",.03)
 ;;30
 ;;9002226.02101,"160,T63.003S ",.01)
 ;;T63.003S 
 ;;9002226.02101,"160,T63.003S ",.02)
 ;;T63.003S 
 ;;9002226.02101,"160,T63.003S ",.03)
 ;;30
 ;;9002226.02101,"160,T63.013A ",.01)
 ;;T63.013A 
 ;;9002226.02101,"160,T63.013A ",.02)
 ;;T63.013A 
 ;;9002226.02101,"160,T63.013A ",.03)
 ;;30
 ;;9002226.02101,"160,T63.013D ",.01)
 ;;T63.013D 
 ;;9002226.02101,"160,T63.013D ",.02)
 ;;T63.013D 
 ;;9002226.02101,"160,T63.013D ",.03)
 ;;30
 ;;9002226.02101,"160,T63.013S ",.01)
 ;;T63.013S 
 ;;9002226.02101,"160,T63.013S ",.02)
 ;;T63.013S 
 ;;9002226.02101,"160,T63.013S ",.03)
 ;;30
 ;;9002226.02101,"160,T63.023A ",.01)
 ;;T63.023A 
 ;;9002226.02101,"160,T63.023A ",.02)
 ;;T63.023A 
 ;;9002226.02101,"160,T63.023A ",.03)
 ;;30
 ;;9002226.02101,"160,T63.023D ",.01)
 ;;T63.023D 
 ;;9002226.02101,"160,T63.023D ",.02)
 ;;T63.023D 
 ;;9002226.02101,"160,T63.023D ",.03)
 ;;30
 ;;9002226.02101,"160,T63.023S ",.01)
 ;;T63.023S 
 ;;9002226.02101,"160,T63.023S ",.02)
 ;;T63.023S 
 ;;9002226.02101,"160,T63.023S ",.03)
 ;;30
 ;;9002226.02101,"160,T63.033A ",.01)
 ;;T63.033A 
 ;;9002226.02101,"160,T63.033A ",.02)
 ;;T63.033A 
 ;;9002226.02101,"160,T63.033A ",.03)
 ;;30
 ;;9002226.02101,"160,T63.033D ",.01)
 ;;T63.033D 
 ;;9002226.02101,"160,T63.033D ",.02)
 ;;T63.033D 
 ;;9002226.02101,"160,T63.033D ",.03)
 ;;30
 ;;9002226.02101,"160,T63.033S ",.01)
 ;;T63.033S 
 ;;9002226.02101,"160,T63.033S ",.02)
 ;;T63.033S 
 ;;9002226.02101,"160,T63.033S ",.03)
 ;;30
 ;;9002226.02101,"160,T63.043A ",.01)
 ;;T63.043A 
 ;;9002226.02101,"160,T63.043A ",.02)
 ;;T63.043A 
 ;;9002226.02101,"160,T63.043A ",.03)
 ;;30
 ;;9002226.02101,"160,T63.043D ",.01)
 ;;T63.043D 
 ;;9002226.02101,"160,T63.043D ",.02)
 ;;T63.043D 
 ;;9002226.02101,"160,T63.043D ",.03)
 ;;30
 ;;9002226.02101,"160,T63.043S ",.01)
 ;;T63.043S 