ATXD8Q5 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 12, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"911,659.81 ",.01)
 ;;659.81 
 ;;9002226.02101,"911,659.81 ",.02)
 ;;659.81 
 ;;9002226.02101,"911,659.81 ",.03)
 ;;1
 ;;9002226.02101,"911,659.91 ",.01)
 ;;659.91 
 ;;9002226.02101,"911,659.91 ",.02)
 ;;659.91 
 ;;9002226.02101,"911,659.91 ",.03)
 ;;1
 ;;9002226.02101,"911,660.01 ",.01)
 ;;660.01 
 ;;9002226.02101,"911,660.01 ",.02)
 ;;660.01 
 ;;9002226.02101,"911,660.01 ",.03)
 ;;1
 ;;9002226.02101,"911,660.11 ",.01)
 ;;660.11 
 ;;9002226.02101,"911,660.11 ",.02)
 ;;660.11 
 ;;9002226.02101,"911,660.11 ",.03)
 ;;1
 ;;9002226.02101,"911,660.21 ",.01)
 ;;660.21 
 ;;9002226.02101,"911,660.21 ",.02)
 ;;660.21 
 ;;9002226.02101,"911,660.21 ",.03)
 ;;1
 ;;9002226.02101,"911,660.31 ",.01)
 ;;660.31 
 ;;9002226.02101,"911,660.31 ",.02)
 ;;660.31 
 ;;9002226.02101,"911,660.31 ",.03)
 ;;1
 ;;9002226.02101,"911,660.41 ",.01)
 ;;660.41 
 ;;9002226.02101,"911,660.41 ",.02)
 ;;660.41 
 ;;9002226.02101,"911,660.41 ",.03)
 ;;1
 ;;9002226.02101,"911,660.51 ",.01)
 ;;660.51 
 ;;9002226.02101,"911,660.51 ",.02)
 ;;660.51 
 ;;9002226.02101,"911,660.51 ",.03)
 ;;1
 ;;9002226.02101,"911,660.61 ",.01)
 ;;660.61 
 ;;9002226.02101,"911,660.61 ",.02)
 ;;660.61 
 ;;9002226.02101,"911,660.61 ",.03)
 ;;1
 ;;9002226.02101,"911,660.71 ",.01)
 ;;660.71 
 ;;9002226.02101,"911,660.71 ",.02)
 ;;660.71 
 ;;9002226.02101,"911,660.71 ",.03)
 ;;1
 ;;9002226.02101,"911,660.81 ",.01)
 ;;660.81 
 ;;9002226.02101,"911,660.81 ",.02)
 ;;660.81 
 ;;9002226.02101,"911,660.81 ",.03)
 ;;1
 ;;9002226.02101,"911,660.91 ",.01)
 ;;660.91 
 ;;9002226.02101,"911,660.91 ",.02)
 ;;660.91 
 ;;9002226.02101,"911,660.91 ",.03)
 ;;1
 ;;9002226.02101,"911,661.01 ",.01)
 ;;661.01 
 ;;9002226.02101,"911,661.01 ",.02)
 ;;661.01 
 ;;9002226.02101,"911,661.01 ",.03)
 ;;1
 ;;9002226.02101,"911,661.11 ",.01)
 ;;661.11 
 ;;9002226.02101,"911,661.11 ",.02)
 ;;661.11 
 ;;9002226.02101,"911,661.11 ",.03)
 ;;1
 ;;9002226.02101,"911,661.21 ",.01)
 ;;661.21 
 ;;9002226.02101,"911,661.21 ",.02)
 ;;661.21 
 ;;9002226.02101,"911,661.21 ",.03)
 ;;1
 ;;9002226.02101,"911,661.31 ",.01)
 ;;661.31 
 ;;9002226.02101,"911,661.31 ",.02)
 ;;661.31 
 ;;9002226.02101,"911,661.31 ",.03)
 ;;1
 ;;9002226.02101,"911,661.41 ",.01)
 ;;661.41 
 ;;9002226.02101,"911,661.41 ",.02)
 ;;661.41 
 ;;9002226.02101,"911,661.41 ",.03)
 ;;1
 ;;9002226.02101,"911,661.91 ",.01)
 ;;661.91 
 ;;9002226.02101,"911,661.91 ",.02)
 ;;661.91 
 ;;9002226.02101,"911,661.91 ",.03)
 ;;1
 ;;9002226.02101,"911,662.01 ",.01)
 ;;662.01 
 ;;9002226.02101,"911,662.01 ",.02)
 ;;662.01 
 ;;9002226.02101,"911,662.01 ",.03)
 ;;1
 ;;9002226.02101,"911,662.11 ",.01)
 ;;662.11 
 ;;9002226.02101,"911,662.11 ",.02)
 ;;662.11 
 ;;9002226.02101,"911,662.11 ",.03)
 ;;1
 ;;9002226.02101,"911,662.21 ",.01)
 ;;662.21 
 ;;9002226.02101,"911,662.21 ",.02)
 ;;662.21 
 ;;9002226.02101,"911,662.21 ",.03)
 ;;1
 ;;9002226.02101,"911,662.31 ",.01)
 ;;662.31 
 ;;9002226.02101,"911,662.31 ",.02)
 ;;662.31 
 ;;9002226.02101,"911,662.31 ",.03)
 ;;1
 ;;9002226.02101,"911,663.01 ",.01)
 ;;663.01 
 ;;9002226.02101,"911,663.01 ",.02)
 ;;663.01 
 ;;9002226.02101,"911,663.01 ",.03)
 ;;1
 ;;9002226.02101,"911,663.11 ",.01)
 ;;663.11 
 ;;9002226.02101,"911,663.11 ",.02)
 ;;663.11 
 ;;9002226.02101,"911,663.11 ",.03)
 ;;1
 ;;9002226.02101,"911,663.21 ",.01)
 ;;663.21 
 ;;9002226.02101,"911,663.21 ",.02)
 ;;663.21 
 ;;9002226.02101,"911,663.21 ",.03)
 ;;1
 ;;9002226.02101,"911,663.31 ",.01)
 ;;663.31 
 ;;9002226.02101,"911,663.31 ",.02)
 ;;663.31 
 ;;9002226.02101,"911,663.31 ",.03)
 ;;1
 ;;9002226.02101,"911,663.41 ",.01)
 ;;663.41 
 ;;9002226.02101,"911,663.41 ",.02)
 ;;663.41 
 ;;9002226.02101,"911,663.41 ",.03)
 ;;1
 ;;9002226.02101,"911,663.51 ",.01)
 ;;663.51 
 ;;9002226.02101,"911,663.51 ",.02)
 ;;663.51 
 ;;9002226.02101,"911,663.51 ",.03)
 ;;1
 ;;9002226.02101,"911,663.61 ",.01)
 ;;663.61 
 ;;9002226.02101,"911,663.61 ",.02)
 ;;663.61 
 ;;9002226.02101,"911,663.61 ",.03)
 ;;1
 ;;9002226.02101,"911,663.81 ",.01)
 ;;663.81 
 ;;9002226.02101,"911,663.81 ",.02)
 ;;663.81 
 ;;9002226.02101,"911,663.81 ",.03)
 ;;1
 ;;9002226.02101,"911,663.91 ",.01)
 ;;663.91 
 ;;9002226.02101,"911,663.91 ",.02)
 ;;663.91 
 ;;9002226.02101,"911,663.91 ",.03)
 ;;1
 ;;9002226.02101,"911,664.00 ",.01)
 ;;664.00 
 ;;9002226.02101,"911,664.00 ",.02)
 ;;664.94 
 ;;9002226.02101,"911,664.00 ",.03)
 ;;1
 ;;9002226.02101,"911,665.01 ",.01)
 ;;665.01 
 ;;9002226.02101,"911,665.01 ",.02)
 ;;665.01 
 ;;9002226.02101,"911,665.01 ",.03)
 ;;1
 ;;9002226.02101,"911,665.11 ",.01)
 ;;665.11 
 ;;9002226.02101,"911,665.11 ",.02)
 ;;665.11 
 ;;9002226.02101,"911,665.11 ",.03)
 ;;1
 ;;9002226.02101,"911,665.22 ",.01)
 ;;665.22 
 ;;9002226.02101,"911,665.22 ",.02)
 ;;665.22 
 ;;9002226.02101,"911,665.22 ",.03)
 ;;1
 ;;9002226.02101,"911,665.24 ",.01)
 ;;665.24 
 ;;9002226.02101,"911,665.24 ",.02)
 ;;665.24 
 ;;9002226.02101,"911,665.24 ",.03)
 ;;1
 ;;9002226.02101,"911,665.31 ",.01)
 ;;665.31 
 ;;9002226.02101,"911,665.31 ",.02)
 ;;665.31 
 ;;9002226.02101,"911,665.31 ",.03)
 ;;1
 ;;9002226.02101,"911,665.34 ",.01)
 ;;665.34 
 ;;9002226.02101,"911,665.34 ",.02)
 ;;665.34 
 ;;9002226.02101,"911,665.34 ",.03)
 ;;1
 ;;9002226.02101,"911,665.41 ",.01)
 ;;665.41 
 ;;9002226.02101,"911,665.41 ",.02)
 ;;665.41 
 ;;9002226.02101,"911,665.41 ",.03)
 ;;1
 ;;9002226.02101,"911,665.44 ",.01)
 ;;665.44 
 ;;9002226.02101,"911,665.44 ",.02)
 ;;665.44 
 ;;9002226.02101,"911,665.44 ",.03)
 ;;1
 ;;9002226.02101,"911,665.51 ",.01)
 ;;665.51 
 ;;9002226.02101,"911,665.51 ",.02)
 ;;665.51 
 ;;9002226.02101,"911,665.51 ",.03)
 ;;1
 ;;9002226.02101,"911,665.54 ",.01)
 ;;665.54 
 ;;9002226.02101,"911,665.54 ",.02)
 ;;665.54 
 ;;9002226.02101,"911,665.54 ",.03)
 ;;1
 ;;9002226.02101,"911,665.61 ",.01)
 ;;665.61 
 ;;9002226.02101,"911,665.61 ",.02)
 ;;665.61 
 ;;9002226.02101,"911,665.61 ",.03)
 ;;1
 ;;9002226.02101,"911,665.64 ",.01)
 ;;665.64 
 ;;9002226.02101,"911,665.64 ",.02)
 ;;665.64 
 ;;9002226.02101,"911,665.64 ",.03)
 ;;1
 ;;9002226.02101,"911,665.71 ",.01)
 ;;665.71 
 ;;9002226.02101,"911,665.71 ",.02)
 ;;665.71 
 ;;9002226.02101,"911,665.71 ",.03)
 ;;1
 ;;9002226.02101,"911,665.72 ",.01)
 ;;665.72 
 ;;9002226.02101,"911,665.72 ",.02)
 ;;665.72 
 ;;9002226.02101,"911,665.72 ",.03)
 ;;1
 ;;9002226.02101,"911,665.74 ",.01)
 ;;665.74 
 ;;9002226.02101,"911,665.74 ",.02)
 ;;665.74 
 ;;9002226.02101,"911,665.74 ",.03)
 ;;1
 ;;9002226.02101,"911,665.81 ",.01)
 ;;665.81 
 ;;9002226.02101,"911,665.81 ",.02)
 ;;665.81 
 ;;9002226.02101,"911,665.81 ",.03)
 ;;1
 ;;9002226.02101,"911,665.82 ",.01)
 ;;665.82 
 ;;9002226.02101,"911,665.82 ",.02)
 ;;665.82 
 ;;9002226.02101,"911,665.82 ",.03)
 ;;1
 ;;9002226.02101,"911,665.84 ",.01)
 ;;665.84 
 ;;9002226.02101,"911,665.84 ",.02)
 ;;665.84 
 ;;9002226.02101,"911,665.84 ",.03)
 ;;1
 ;;9002226.02101,"911,665.91 ",.01)
 ;;665.91 
 ;;9002226.02101,"911,665.91 ",.02)
 ;;665.91 
 ;;9002226.02101,"911,665.91 ",.03)
 ;;1
 ;;9002226.02101,"911,665.92 ",.01)
 ;;665.92 
 ;;9002226.02101,"911,665.92 ",.02)
 ;;665.92 
 ;;9002226.02101,"911,665.92 ",.03)
 ;;1
 ;;9002226.02101,"911,665.94 ",.01)
 ;;665.94 
 ;;9002226.02101,"911,665.94 ",.02)
 ;;665.94 
 ;;9002226.02101,"911,665.94 ",.03)
 ;;1
 ;;9002226.02101,"911,666.00 ",.01)
 ;;666.00 
 ;;9002226.02101,"911,666.00 ",.02)
 ;;666.34 
 ;;9002226.02101,"911,666.00 ",.03)
 ;;1
 ;;9002226.02101,"911,667.00 ",.01)
 ;;667.00 
 ;;9002226.02101,"911,667.00 ",.02)
 ;;667.14 
 ;;9002226.02101,"911,667.00 ",.03)
 ;;1
 ;;9002226.02101,"911,668.00 ",.01)
 ;;668.00 
 ;;9002226.02101,"911,668.00 ",.02)
 ;;668.02 
 ;;9002226.02101,"911,668.00 ",.03)
 ;;1
 ;;9002226.02101,"911,668.04 ",.01)
 ;;668.04 
 ;;9002226.02101,"911,668.04 ",.02)
 ;;668.12 
 ;;9002226.02101,"911,668.04 ",.03)
 ;;1
 ;;9002226.02101,"911,668.14 ",.01)
 ;;668.14 
 ;;9002226.02101,"911,668.14 ",.02)
 ;;668.22 
 ;;9002226.02101,"911,668.14 ",.03)
 ;;1
 ;;9002226.02101,"911,668.24 ",.01)
 ;;668.24 
 ;;9002226.02101,"911,668.24 ",.02)
 ;;668.82 
 ;;9002226.02101,"911,668.24 ",.03)
 ;;1
 ;;9002226.02101,"911,668.84 ",.01)
 ;;668.84 
 ;;9002226.02101,"911,668.84 ",.02)
 ;;668.92 
 ;;9002226.02101,"911,668.84 ",.03)
 ;;1
 ;;9002226.02101,"911,668.94 ",.01)
 ;;668.94 
 ;;9002226.02101,"911,668.94 ",.02)
 ;;668.94 
 ;;9002226.02101,"911,668.94 ",.03)
 ;;1
 ;;9002226.02101,"911,669.00 ",.01)
 ;;669.00 
 ;;9002226.02101,"911,669.00 ",.02)
 ;;669.02 
 ;;9002226.02101,"911,669.00 ",.03)
 ;;1
 ;;9002226.02101,"911,669.04 ",.01)
 ;;669.04 
 ;;9002226.02101,"911,669.04 ",.02)
 ;;669.12 
 ;;9002226.02101,"911,669.04 ",.03)
 ;;1
 ;;9002226.02101,"911,669.14 ",.01)
 ;;669.14 
 ;;9002226.02101,"911,669.14 ",.02)
 ;;669.22 
 ;;9002226.02101,"911,669.14 ",.03)
 ;;1
 ;;9002226.02101,"911,669.24 ",.01)
 ;;669.24 
 ;;9002226.02101,"911,669.24 ",.02)
 ;;669.42 
 ;;9002226.02101,"911,669.24 ",.03)
 ;;1
 ;;9002226.02101,"911,669.44 ",.01)
 ;;669.44 
 ;;9002226.02101,"911,669.44 ",.02)
 ;;669.82 
 ;;9002226.02101,"911,669.44 ",.03)
 ;;1
 ;;9002226.02101,"911,669.84 ",.01)
 ;;669.84 
 ;;9002226.02101,"911,669.84 ",.02)
 ;;669.92 
 ;;9002226.02101,"911,669.84 ",.03)
 ;;1
 ;;9002226.02101,"911,669.94 ",.01)
 ;;669.94 
 ;;9002226.02101,"911,669.94 ",.02)
 ;;669.94 
 ;;9002226.02101,"911,669.94 ",.03)
 ;;1
 ;;9002226.02101,"911,670.00 ",.01)
 ;;670.00 
 ;;9002226.02101,"911,670.00 ",.02)
 ;;670.04 
 ;;9002226.02101,"911,670.00 ",.03)
 ;;1
 ;;9002226.02101,"911,671.01 ",.01)
 ;;671.01 
 ;;9002226.02101,"911,671.01 ",.02)
 ;;671.01 
 ;;9002226.02101,"911,671.01 ",.03)
 ;;1
 ;;9002226.02101,"911,671.02 ",.01)
 ;;671.02 
 ;;9002226.02101,"911,671.02 ",.02)
 ;;671.02 
 ;;9002226.02101,"911,671.02 ",.03)
 ;;1
 ;;9002226.02101,"911,671.04 ",.01)
 ;;671.04 
 ;;9002226.02101,"911,671.04 ",.02)
 ;;671.04 
 ;;9002226.02101,"911,671.04 ",.03)
 ;;1
 ;;9002226.02101,"911,671.11 ",.01)
 ;;671.11 
 ;;9002226.02101,"911,671.11 ",.02)
 ;;671.11 
 ;;9002226.02101,"911,671.11 ",.03)
 ;;1
 ;;9002226.02101,"911,671.12 ",.01)
 ;;671.12 
 ;;9002226.02101,"911,671.12 ",.02)
 ;;671.12 
 ;;9002226.02101,"911,671.12 ",.03)
 ;;1
 ;;9002226.02101,"911,671.14 ",.01)
 ;;671.14 
 ;;9002226.02101,"911,671.14 ",.02)
 ;;671.14 
 ;;9002226.02101,"911,671.14 ",.03)
 ;;1
 ;;9002226.02101,"911,671.21 ",.01)
 ;;671.21 
 ;;9002226.02101,"911,671.21 ",.02)
 ;;671.21 
 ;;9002226.02101,"911,671.21 ",.03)
 ;;1
 ;;9002226.02101,"911,671.22 ",.01)
 ;;671.22 
 ;;9002226.02101,"911,671.22 ",.02)
 ;;671.22 
 ;;9002226.02101,"911,671.22 ",.03)
 ;;1
 ;;9002226.02101,"911,671.24 ",.01)
 ;;671.24 
 ;;9002226.02101,"911,671.24 ",.02)
 ;;671.24 
 ;;9002226.02101,"911,671.24 ",.03)
 ;;1
 ;;9002226.02101,"911,671.31 ",.01)
 ;;671.31 
 ;;9002226.02101,"911,671.31 ",.02)
 ;;671.31 
 ;;9002226.02101,"911,671.31 ",.03)
 ;;1
 ;;9002226.02101,"911,671.42 ",.01)
 ;;671.42 
 ;;9002226.02101,"911,671.42 ",.02)
 ;;671.42 
 ;;9002226.02101,"911,671.42 ",.03)
 ;;1
 ;;9002226.02101,"911,671.44 ",.01)
 ;;671.44 
 ;;9002226.02101,"911,671.44 ",.02)
 ;;671.44 
 ;;9002226.02101,"911,671.44 ",.03)
 ;;1
 ;;9002226.02101,"911,671.51 ",.01)
 ;;671.51 
 ;;9002226.02101,"911,671.51 ",.02)
 ;;671.51 
 ;;9002226.02101,"911,671.51 ",.03)
 ;;1
 ;;9002226.02101,"911,671.52 ",.01)
 ;;671.52 
 ;;9002226.02101,"911,671.52 ",.02)
 ;;671.52 
 ;;9002226.02101,"911,671.52 ",.03)
 ;;1