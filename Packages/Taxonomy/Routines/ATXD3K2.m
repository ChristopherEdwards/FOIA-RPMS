ATXD3K2 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 28, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"501,M84.442A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.443A ",.01)
 ;;M84.443A
 ;;9002226.02101,"501,M84.443A ",.02)
 ;;M84.443A
 ;;9002226.02101,"501,M84.443A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.444A ",.01)
 ;;M84.444A
 ;;9002226.02101,"501,M84.444A ",.02)
 ;;M84.444A
 ;;9002226.02101,"501,M84.444A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.445A ",.01)
 ;;M84.445A
 ;;9002226.02101,"501,M84.445A ",.02)
 ;;M84.445A
 ;;9002226.02101,"501,M84.445A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.446A ",.01)
 ;;M84.446A
 ;;9002226.02101,"501,M84.446A ",.02)
 ;;M84.446A
 ;;9002226.02101,"501,M84.446A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.451A ",.01)
 ;;M84.451A
 ;;9002226.02101,"501,M84.451A ",.02)
 ;;M84.451A
 ;;9002226.02101,"501,M84.451A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.452A ",.01)
 ;;M84.452A
 ;;9002226.02101,"501,M84.452A ",.02)
 ;;M84.452A
 ;;9002226.02101,"501,M84.452A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.453A ",.01)
 ;;M84.453A
 ;;9002226.02101,"501,M84.453A ",.02)
 ;;M84.453A
 ;;9002226.02101,"501,M84.453A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.454A ",.01)
 ;;M84.454A
 ;;9002226.02101,"501,M84.454A ",.02)
 ;;M84.454A
 ;;9002226.02101,"501,M84.454A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.459A ",.01)
 ;;M84.459A
 ;;9002226.02101,"501,M84.459A ",.02)
 ;;M84.459A
 ;;9002226.02101,"501,M84.459A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.461A ",.01)
 ;;M84.461A
 ;;9002226.02101,"501,M84.461A ",.02)
 ;;M84.461A
 ;;9002226.02101,"501,M84.461A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.462A ",.01)
 ;;M84.462A
 ;;9002226.02101,"501,M84.462A ",.02)
 ;;M84.462A
 ;;9002226.02101,"501,M84.462A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.463A ",.01)
 ;;M84.463A
 ;;9002226.02101,"501,M84.463A ",.02)
 ;;M84.463A
 ;;9002226.02101,"501,M84.463A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.464A ",.01)
 ;;M84.464A
 ;;9002226.02101,"501,M84.464A ",.02)
 ;;M84.464A
 ;;9002226.02101,"501,M84.464A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.469A ",.01)
 ;;M84.469A
 ;;9002226.02101,"501,M84.469A ",.02)
 ;;M84.469A
 ;;9002226.02101,"501,M84.469A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.471A ",.01)
 ;;M84.471A
 ;;9002226.02101,"501,M84.471A ",.02)
 ;;M84.471A
 ;;9002226.02101,"501,M84.471A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.472A ",.01)
 ;;M84.472A
 ;;9002226.02101,"501,M84.472A ",.02)
 ;;M84.472A
 ;;9002226.02101,"501,M84.472A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.473A ",.01)
 ;;M84.473A
 ;;9002226.02101,"501,M84.473A ",.02)
 ;;M84.473A
 ;;9002226.02101,"501,M84.473A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.474A ",.01)
 ;;M84.474A
 ;;9002226.02101,"501,M84.474A ",.02)
 ;;M84.474A
 ;;9002226.02101,"501,M84.474A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.475A ",.01)
 ;;M84.475A
 ;;9002226.02101,"501,M84.475A ",.02)
 ;;M84.475A
 ;;9002226.02101,"501,M84.475A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.476A ",.01)
 ;;M84.476A
 ;;9002226.02101,"501,M84.476A ",.02)
 ;;M84.476A
 ;;9002226.02101,"501,M84.476A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.477A ",.01)
 ;;M84.477A
 ;;9002226.02101,"501,M84.477A ",.02)
 ;;M84.477A
 ;;9002226.02101,"501,M84.477A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.478A ",.01)
 ;;M84.478A
 ;;9002226.02101,"501,M84.478A ",.02)
 ;;M84.478A
 ;;9002226.02101,"501,M84.478A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.479A ",.01)
 ;;M84.479A
 ;;9002226.02101,"501,M84.479A ",.02)
 ;;M84.479A
 ;;9002226.02101,"501,M84.479A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.48XA ",.01)
 ;;M84.48XA
 ;;9002226.02101,"501,M84.48XA ",.02)
 ;;M84.48XA
 ;;9002226.02101,"501,M84.48XA ",.03)
 ;;30
 ;;9002226.02101,"501,M84.60XA ",.01)
 ;;M84.60XA
 ;;9002226.02101,"501,M84.60XA ",.02)
 ;;M84.60XA
 ;;9002226.02101,"501,M84.60XA ",.03)
 ;;30
 ;;9002226.02101,"501,M84.611A ",.01)
 ;;M84.611A
 ;;9002226.02101,"501,M84.611A ",.02)
 ;;M84.611A
 ;;9002226.02101,"501,M84.611A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.612A ",.01)
 ;;M84.612A
 ;;9002226.02101,"501,M84.612A ",.02)
 ;;M84.612A
 ;;9002226.02101,"501,M84.612A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.619A ",.01)
 ;;M84.619A
 ;;9002226.02101,"501,M84.619A ",.02)
 ;;M84.619A
 ;;9002226.02101,"501,M84.619A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.621A ",.01)
 ;;M84.621A
 ;;9002226.02101,"501,M84.621A ",.02)
 ;;M84.621A
 ;;9002226.02101,"501,M84.621A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.622A ",.01)
 ;;M84.622A
 ;;9002226.02101,"501,M84.622A ",.02)
 ;;M84.622A
 ;;9002226.02101,"501,M84.622A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.629A ",.01)
 ;;M84.629A
 ;;9002226.02101,"501,M84.629A ",.02)
 ;;M84.629A
 ;;9002226.02101,"501,M84.629A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.631A ",.01)
 ;;M84.631A
 ;;9002226.02101,"501,M84.631A ",.02)
 ;;M84.631A
 ;;9002226.02101,"501,M84.631A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.632A ",.01)
 ;;M84.632A
 ;;9002226.02101,"501,M84.632A ",.02)
 ;;M84.632A
 ;;9002226.02101,"501,M84.632A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.633A ",.01)
 ;;M84.633A
 ;;9002226.02101,"501,M84.633A ",.02)
 ;;M84.633A
 ;;9002226.02101,"501,M84.633A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.634A ",.01)
 ;;M84.634A
 ;;9002226.02101,"501,M84.634A ",.02)
 ;;M84.634A
 ;;9002226.02101,"501,M84.634A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.639A ",.01)
 ;;M84.639A
 ;;9002226.02101,"501,M84.639A ",.02)
 ;;M84.639A
 ;;9002226.02101,"501,M84.639A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.641A ",.01)
 ;;M84.641A
 ;;9002226.02101,"501,M84.641A ",.02)
 ;;M84.641A
 ;;9002226.02101,"501,M84.641A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.642A ",.01)
 ;;M84.642A
 ;;9002226.02101,"501,M84.642A ",.02)
 ;;M84.642A
 ;;9002226.02101,"501,M84.642A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.649A ",.01)
 ;;M84.649A
 ;;9002226.02101,"501,M84.649A ",.02)
 ;;M84.649A
 ;;9002226.02101,"501,M84.649A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.650A ",.01)
 ;;M84.650A
 ;;9002226.02101,"501,M84.650A ",.02)
 ;;M84.650A
 ;;9002226.02101,"501,M84.650A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.651A ",.01)
 ;;M84.651A
 ;;9002226.02101,"501,M84.651A ",.02)
 ;;M84.651A
 ;;9002226.02101,"501,M84.651A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.652A ",.01)
 ;;M84.652A
 ;;9002226.02101,"501,M84.652A ",.02)
 ;;M84.652A
 ;;9002226.02101,"501,M84.652A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.653A ",.01)
 ;;M84.653A
 ;;9002226.02101,"501,M84.653A ",.02)
 ;;M84.653A
 ;;9002226.02101,"501,M84.653A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.659A ",.01)
 ;;M84.659A
 ;;9002226.02101,"501,M84.659A ",.02)
 ;;M84.659A
 ;;9002226.02101,"501,M84.659A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.661A ",.01)
 ;;M84.661A
 ;;9002226.02101,"501,M84.661A ",.02)
 ;;M84.661A
 ;;9002226.02101,"501,M84.661A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.662A ",.01)
 ;;M84.662A
 ;;9002226.02101,"501,M84.662A ",.02)
 ;;M84.662A
 ;;9002226.02101,"501,M84.662A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.663A ",.01)
 ;;M84.663A
 ;;9002226.02101,"501,M84.663A ",.02)
 ;;M84.663A
 ;;9002226.02101,"501,M84.663A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.664A ",.01)
 ;;M84.664A
 ;;9002226.02101,"501,M84.664A ",.02)
 ;;M84.664A
 ;;9002226.02101,"501,M84.664A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.669A ",.01)
 ;;M84.669A
 ;;9002226.02101,"501,M84.669A ",.02)
 ;;M84.669A
 ;;9002226.02101,"501,M84.669A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.671A ",.01)
 ;;M84.671A
 ;;9002226.02101,"501,M84.671A ",.02)
 ;;M84.671A
 ;;9002226.02101,"501,M84.671A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.672A ",.01)
 ;;M84.672A
 ;;9002226.02101,"501,M84.672A ",.02)
 ;;M84.672A
 ;;9002226.02101,"501,M84.672A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.673A ",.01)
 ;;M84.673A
 ;;9002226.02101,"501,M84.673A ",.02)
 ;;M84.673A
 ;;9002226.02101,"501,M84.673A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.674A ",.01)
 ;;M84.674A
 ;;9002226.02101,"501,M84.674A ",.02)
 ;;M84.674A
 ;;9002226.02101,"501,M84.674A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.675A ",.01)
 ;;M84.675A
 ;;9002226.02101,"501,M84.675A ",.02)
 ;;M84.675A
 ;;9002226.02101,"501,M84.675A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.676A ",.01)
 ;;M84.676A
 ;;9002226.02101,"501,M84.676A ",.02)
 ;;M84.676A
 ;;9002226.02101,"501,M84.676A ",.03)
 ;;30
 ;;9002226.02101,"501,M84.68XA ",.01)
 ;;M84.68XA
 ;;9002226.02101,"501,M84.68XA ",.02)
 ;;M84.68XA
 ;;9002226.02101,"501,M84.68XA ",.03)
 ;;30
 ;;9002226.04101,"501,1",.01)
 ;;BGP