ATXD5K2 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 12, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"164,X35.XXXA ",.02)
 ;;X35.XXXA 
 ;;9002226.02101,"164,X35.XXXA ",.03)
 ;;30
 ;;9002226.02101,"164,X35.XXXD ",.01)
 ;;X35.XXXD 
 ;;9002226.02101,"164,X35.XXXD ",.02)
 ;;X35.XXXD 
 ;;9002226.02101,"164,X35.XXXD ",.03)
 ;;30
 ;;9002226.02101,"164,X35.XXXS ",.01)
 ;;X35.XXXS 
 ;;9002226.02101,"164,X35.XXXS ",.02)
 ;;X35.XXXS 
 ;;9002226.02101,"164,X35.XXXS ",.03)
 ;;30
 ;;9002226.02101,"164,X36.0XXA ",.01)
 ;;X36.0XXA 
 ;;9002226.02101,"164,X36.0XXA ",.02)
 ;;X36.0XXA 
 ;;9002226.02101,"164,X36.0XXA ",.03)
 ;;30
 ;;9002226.02101,"164,X36.0XXD ",.01)
 ;;X36.0XXD 
 ;;9002226.02101,"164,X36.0XXD ",.02)
 ;;X36.0XXD 
 ;;9002226.02101,"164,X36.0XXD ",.03)
 ;;30
 ;;9002226.02101,"164,X36.0XXS ",.01)
 ;;X36.0XXS 
 ;;9002226.02101,"164,X36.0XXS ",.02)
 ;;X36.0XXS 
 ;;9002226.02101,"164,X36.0XXS ",.03)
 ;;30
 ;;9002226.02101,"164,X36.1XXA ",.01)
 ;;X36.1XXA 
 ;;9002226.02101,"164,X36.1XXA ",.02)
 ;;X36.1XXA 
 ;;9002226.02101,"164,X36.1XXA ",.03)
 ;;30
 ;;9002226.02101,"164,X36.1XXD ",.01)
 ;;X36.1XXD 
 ;;9002226.02101,"164,X36.1XXD ",.02)
 ;;X36.1XXD 
 ;;9002226.02101,"164,X36.1XXD ",.03)
 ;;30
 ;;9002226.02101,"164,X36.1XXS ",.01)
 ;;X36.1XXS 
 ;;9002226.02101,"164,X36.1XXS ",.02)
 ;;X36.1XXS 
 ;;9002226.02101,"164,X36.1XXS ",.03)
 ;;30
 ;;9002226.02101,"164,X37.0XXA ",.01)
 ;;X37.0XXA 
 ;;9002226.02101,"164,X37.0XXA ",.02)
 ;;X37.0XXA 
 ;;9002226.02101,"164,X37.0XXA ",.03)
 ;;30
 ;;9002226.02101,"164,X37.0XXD ",.01)
 ;;X37.0XXD 
 ;;9002226.02101,"164,X37.0XXD ",.02)
 ;;X37.0XXD 
 ;;9002226.02101,"164,X37.0XXD ",.03)
 ;;30
 ;;9002226.02101,"164,X37.0XXS ",.01)
 ;;X37.0XXS 
 ;;9002226.02101,"164,X37.0XXS ",.02)
 ;;X37.0XXS 
 ;;9002226.02101,"164,X37.0XXS ",.03)
 ;;30
 ;;9002226.02101,"164,X37.1XXA ",.01)
 ;;X37.1XXA 
 ;;9002226.02101,"164,X37.1XXA ",.02)
 ;;X37.1XXA 
 ;;9002226.02101,"164,X37.1XXA ",.03)
 ;;30
 ;;9002226.02101,"164,X37.1XXD ",.01)
 ;;X37.1XXD 
 ;;9002226.02101,"164,X37.1XXD ",.02)
 ;;X37.1XXD 
 ;;9002226.02101,"164,X37.1XXD ",.03)
 ;;30
 ;;9002226.02101,"164,X37.1XXS ",.01)
 ;;X37.1XXS 
 ;;9002226.02101,"164,X37.1XXS ",.02)
 ;;X37.1XXS 
 ;;9002226.02101,"164,X37.1XXS ",.03)
 ;;30
 ;;9002226.02101,"164,X37.2XXA ",.01)
 ;;X37.2XXA 
 ;;9002226.02101,"164,X37.2XXA ",.02)
 ;;X37.2XXA 
 ;;9002226.02101,"164,X37.2XXA ",.03)
 ;;30
 ;;9002226.02101,"164,X37.2XXD ",.01)
 ;;X37.2XXD 
 ;;9002226.02101,"164,X37.2XXD ",.02)
 ;;X37.2XXD 
 ;;9002226.02101,"164,X37.2XXD ",.03)
 ;;30
 ;;9002226.02101,"164,X37.2XXS ",.01)
 ;;X37.2XXS 
 ;;9002226.02101,"164,X37.2XXS ",.02)
 ;;X37.2XXS 
 ;;9002226.02101,"164,X37.2XXS ",.03)
 ;;30
 ;;9002226.02101,"164,X37.3XXA ",.01)
 ;;X37.3XXA 
 ;;9002226.02101,"164,X37.3XXA ",.02)
 ;;X37.3XXA 
 ;;9002226.02101,"164,X37.3XXA ",.03)
 ;;30
 ;;9002226.02101,"164,X37.3XXD ",.01)
 ;;X37.3XXD 
 ;;9002226.02101,"164,X37.3XXD ",.02)
 ;;X37.3XXD 
 ;;9002226.02101,"164,X37.3XXD ",.03)
 ;;30
 ;;9002226.02101,"164,X37.3XXS ",.01)
 ;;X37.3XXS 
 ;;9002226.02101,"164,X37.3XXS ",.02)
 ;;X37.3XXS 
 ;;9002226.02101,"164,X37.3XXS ",.03)
 ;;30
 ;;9002226.02101,"164,X37.41XA ",.01)
 ;;X37.41XA 
 ;;9002226.02101,"164,X37.41XA ",.02)
 ;;X37.41XA 
 ;;9002226.02101,"164,X37.41XA ",.03)
 ;;30
 ;;9002226.02101,"164,X37.41XD ",.01)
 ;;X37.41XD 
 ;;9002226.02101,"164,X37.41XD ",.02)
 ;;X37.41XD 
 ;;9002226.02101,"164,X37.41XD ",.03)
 ;;30
 ;;9002226.02101,"164,X37.41XS ",.01)
 ;;X37.41XS 
 ;;9002226.02101,"164,X37.41XS ",.02)
 ;;X37.41XS 
 ;;9002226.02101,"164,X37.41XS ",.03)
 ;;30
 ;;9002226.02101,"164,X37.42XA ",.01)
 ;;X37.42XA 
 ;;9002226.02101,"164,X37.42XA ",.02)
 ;;X37.42XA 
 ;;9002226.02101,"164,X37.42XA ",.03)
 ;;30
 ;;9002226.02101,"164,X37.42XD ",.01)
 ;;X37.42XD 
 ;;9002226.02101,"164,X37.42XD ",.02)
 ;;X37.42XD 
 ;;9002226.02101,"164,X37.42XD ",.03)
 ;;30
 ;;9002226.02101,"164,X37.42XS ",.01)
 ;;X37.42XS 
 ;;9002226.02101,"164,X37.42XS ",.02)
 ;;X37.42XS 
 ;;9002226.02101,"164,X37.42XS ",.03)
 ;;30
 ;;9002226.02101,"164,X37.43XA ",.01)
 ;;X37.43XA 
 ;;9002226.02101,"164,X37.43XA ",.02)
 ;;X37.43XA 
 ;;9002226.02101,"164,X37.43XA ",.03)
 ;;30
 ;;9002226.02101,"164,X37.43XD ",.01)
 ;;X37.43XD 
 ;;9002226.02101,"164,X37.43XD ",.02)
 ;;X37.43XD 
 ;;9002226.02101,"164,X37.43XD ",.03)
 ;;30
 ;;9002226.02101,"164,X37.43XS ",.01)
 ;;X37.43XS 
 ;;9002226.02101,"164,X37.43XS ",.02)
 ;;X37.43XS 
 ;;9002226.02101,"164,X37.43XS ",.03)
 ;;30
 ;;9002226.02101,"164,X37.8XXA ",.01)
 ;;X37.8XXA 
 ;;9002226.02101,"164,X37.8XXA ",.02)
 ;;X37.8XXA 
 ;;9002226.02101,"164,X37.8XXA ",.03)
 ;;30
 ;;9002226.02101,"164,X37.8XXD ",.01)
 ;;X37.8XXD 
 ;;9002226.02101,"164,X37.8XXD ",.02)
 ;;X37.8XXD 
 ;;9002226.02101,"164,X37.8XXD ",.03)
 ;;30
 ;;9002226.02101,"164,X37.8XXS ",.01)
 ;;X37.8XXS 
 ;;9002226.02101,"164,X37.8XXS ",.02)
 ;;X37.8XXS 
 ;;9002226.02101,"164,X37.8XXS ",.03)
 ;;30
 ;;9002226.02101,"164,X37.9XXA ",.01)
 ;;X37.9XXA 
 ;;9002226.02101,"164,X37.9XXA ",.02)
 ;;X37.9XXA 
 ;;9002226.02101,"164,X37.9XXA ",.03)
 ;;30
 ;;9002226.02101,"164,X37.9XXD ",.01)
 ;;X37.9XXD 
 ;;9002226.02101,"164,X37.9XXD ",.02)
 ;;X37.9XXD 
 ;;9002226.02101,"164,X37.9XXD ",.03)
 ;;30
 ;;9002226.02101,"164,X37.9XXS ",.01)
 ;;X37.9XXS 
 ;;9002226.02101,"164,X37.9XXS ",.02)
 ;;X37.9XXS 
 ;;9002226.02101,"164,X37.9XXS ",.03)
 ;;30
 ;;9002226.02101,"164,X38.XXXA ",.01)
 ;;X38.XXXA 
 ;;9002226.02101,"164,X38.XXXA ",.02)
 ;;X38.XXXA 
 ;;9002226.02101,"164,X38.XXXA ",.03)
 ;;30
 ;;9002226.02101,"164,X38.XXXD ",.01)
 ;;X38.XXXD 
 ;;9002226.02101,"164,X38.XXXD ",.02)
 ;;X38.XXXD 
 ;;9002226.02101,"164,X38.XXXD ",.03)
 ;;30
 ;;9002226.02101,"164,X38.XXXS ",.01)
 ;;X38.XXXS 
 ;;9002226.02101,"164,X38.XXXS ",.02)
 ;;X38.XXXS 
 ;;9002226.02101,"164,X38.XXXS ",.03)
 ;;30
 ;;9002226.02101,"164,X39.01XA ",.01)
 ;;X39.01XA 
 ;;9002226.02101,"164,X39.01XA ",.02)
 ;;X39.01XA 
 ;;9002226.02101,"164,X39.01XA ",.03)
 ;;30
 ;;9002226.02101,"164,X39.01XD ",.01)
 ;;X39.01XD 
 ;;9002226.02101,"164,X39.01XD ",.02)
 ;;X39.01XD 
 ;;9002226.02101,"164,X39.01XD ",.03)
 ;;30
 ;;9002226.02101,"164,X39.01XS ",.01)
 ;;X39.01XS 
 ;;9002226.02101,"164,X39.01XS ",.02)
 ;;X39.01XS 
 ;;9002226.02101,"164,X39.01XS ",.03)
 ;;30
 ;;9002226.02101,"164,X39.08XA ",.01)
 ;;X39.08XA 
 ;;9002226.02101,"164,X39.08XA ",.02)
 ;;X39.08XA 
 ;;9002226.02101,"164,X39.08XA ",.03)
 ;;30
 ;;9002226.02101,"164,X39.08XD ",.01)
 ;;X39.08XD 
 ;;9002226.02101,"164,X39.08XD ",.02)
 ;;X39.08XD 
 ;;9002226.02101,"164,X39.08XD ",.03)
 ;;30
 ;;9002226.02101,"164,X39.08XS ",.01)
 ;;X39.08XS 
 ;;9002226.02101,"164,X39.08XS ",.02)
 ;;X39.08XS 
 ;;9002226.02101,"164,X39.08XS ",.03)
 ;;30
 ;;9002226.02101,"164,X39.8XXA ",.01)
 ;;X39.8XXA 
 ;;9002226.02101,"164,X39.8XXA ",.02)
 ;;X39.8XXA 
 ;;9002226.02101,"164,X39.8XXA ",.03)
 ;;30
 ;;9002226.02101,"164,X39.8XXD ",.01)
 ;;X39.8XXD 
 ;;9002226.02101,"164,X39.8XXD ",.02)
 ;;X39.8XXD 
 ;;9002226.02101,"164,X39.8XXD ",.03)
 ;;30
 ;;9002226.02101,"164,X39.8XXS ",.01)
 ;;X39.8XXS 
 ;;9002226.02101,"164,X39.8XXS ",.02)
 ;;X39.8XXS 
 ;;9002226.02101,"164,X39.8XXS ",.03)
 ;;30
 ;;9002226.04101,"164,1",.01)
 ;;APCL