ATXD3E ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 17, 2015;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;BGP MISCARRIAGE/ABORTION DXS
 ;
 ; This routine loads Taxonomy BGP MISCARRIAGE/ABORTION DXS
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
 ;;21,"630. ")
 ;;1
 ;;21,"O00.0 ")
 ;;2
 ;;21,"O00.1 ")
 ;;3
 ;;21,"O00.2 ")
 ;;4
 ;;21,"O00.8 ")
 ;;5
 ;;21,"O00.9 ")
 ;;6
 ;;21,"O01.0 ")
 ;;7
 ;;21,"O01.1 ")
 ;;8
 ;;21,"O01.9 ")
 ;;9
 ;;21,"O02.0 ")
 ;;10
 ;;21,"O02.1 ")
 ;;11
 ;;21,"O02.81 ")
 ;;12
 ;;21,"O02.89 ")
 ;;13
 ;;21,"O02.9 ")
 ;;14
 ;;21,"O03.0 ")
 ;;15
 ;;21,"O03.1 ")
 ;;16
 ;;21,"O03.30 ")
 ;;17
 ;;21,"O03.31 ")
 ;;18
 ;;21,"O03.32 ")
 ;;19
 ;;21,"O03.33 ")
 ;;20
 ;;21,"O03.34 ")
 ;;21
 ;;21,"O03.35 ")
 ;;22
 ;;21,"O03.36 ")
 ;;23
 ;;21,"O03.37 ")
 ;;24
 ;;21,"O03.38 ")
 ;;25
 ;;21,"O03.39 ")
 ;;26
 ;;21,"O03.4 ")
 ;;27
 ;;21,"O03.5 ")
 ;;28
 ;;21,"O03.6 ")
 ;;29
 ;;21,"O03.7 ")
 ;;30
 ;;21,"O03.80 ")
 ;;31
 ;;21,"O03.81 ")
 ;;32
 ;;21,"O03.82 ")
 ;;33
 ;;21,"O03.83 ")
 ;;34
 ;;21,"O03.84 ")
 ;;35
 ;;21,"O03.85 ")
 ;;36
 ;;21,"O03.86 ")
 ;;37
 ;;21,"O04.5 ")
 ;;38
 ;;21,"O04.6 ")
 ;;39
 ;;21,"O04.7 ")
 ;;40
 ;;21,"O04.80 ")
 ;;41
 ;;21,"O30.2 ")
 ;;42
 ;;21,"Z33.2 ")
 ;;43
 ;;9002226,306,.01)
 ;;BGP MISCARRIAGE/ABORTION DXS
 ;;9002226,306,.02)
 ;;@
 ;;9002226,306,.04)
 ;;n
 ;;9002226,306,.06)
 ;;@
 ;;9002226,306,.08)
 ;;0
 ;;9002226,306,.09)
 ;;3140812
 ;;9002226,306,.11)
 ;;@
 ;;9002226,306,.12)
 ;;31
 ;;9002226,306,.13)
 ;;1
 ;;9002226,306,.14)
 ;;@
 ;;9002226,306,.15)
 ;;80
 ;;9002226,306,.16)
 ;;@
 ;;9002226,306,.17)
 ;;@
 ;;9002226,306,3101)
 ;;@
 ;;9002226.02101,"306,630. ",.01)
 ;;630. 
 ;;9002226.02101,"306,630. ",.02)
 ;;637.92 
 ;;9002226.02101,"306,630. ",.03)
 ;;1
 ;;9002226.02101,"306,O00.0 ",.01)
 ;;O00.0 
 ;;9002226.02101,"306,O00.0 ",.02)
 ;;O03.9 
 ;;9002226.02101,"306,O00.0 ",.03)
 ;;30
 ;;9002226.02101,"306,O00.1 ",.01)
 ;;O00.1 
 ;;9002226.02101,"306,O00.1 ",.02)
 ;;O00.1 
 ;;9002226.02101,"306,O00.1 ",.03)
 ;;30
 ;;9002226.02101,"306,O00.2 ",.01)
 ;;O00.2 
 ;;9002226.02101,"306,O00.2 ",.02)
 ;;O00.2 
 ;;9002226.02101,"306,O00.2 ",.03)
 ;;30
 ;;9002226.02101,"306,O00.8 ",.01)
 ;;O00.8 
 ;;9002226.02101,"306,O00.8 ",.02)
 ;;O00.8 
 ;;9002226.02101,"306,O00.8 ",.03)
 ;;30
 ;;9002226.02101,"306,O00.9 ",.01)
 ;;O00.9 
 ;;9002226.02101,"306,O00.9 ",.02)
 ;;O00.9 
 ;;9002226.02101,"306,O00.9 ",.03)
 ;;30
 ;;9002226.02101,"306,O01.0 ",.01)
 ;;O01.0 
 ;;9002226.02101,"306,O01.0 ",.02)
 ;;O01.0 
 ;;9002226.02101,"306,O01.0 ",.03)
 ;;30
 ;;9002226.02101,"306,O01.1 ",.01)
 ;;O01.1 
 ;;9002226.02101,"306,O01.1 ",.02)
 ;;O01.1 
 ;;9002226.02101,"306,O01.1 ",.03)
 ;;30
 ;;9002226.02101,"306,O01.9 ",.01)
 ;;O01.9 
 ;;9002226.02101,"306,O01.9 ",.02)
 ;;O01.9 
 ;;9002226.02101,"306,O01.9 ",.03)
 ;;30
 ;;9002226.02101,"306,O02.0 ",.01)
 ;;O02.0 
 ;;9002226.02101,"306,O02.0 ",.02)
 ;;O02.0 
 ;;9002226.02101,"306,O02.0 ",.03)
 ;;30
 ;;9002226.02101,"306,O02.1 ",.01)
 ;;O02.1 
 ;;9002226.02101,"306,O02.1 ",.02)
 ;;O02.1 
 ;;9002226.02101,"306,O02.1 ",.03)
 ;;30
 ;;9002226.02101,"306,O02.81 ",.01)
 ;;O02.81 
 ;;9002226.02101,"306,O02.81 ",.02)
 ;;O02.81 
 ;;9002226.02101,"306,O02.81 ",.03)
 ;;30
 ;;9002226.02101,"306,O02.89 ",.01)
 ;;O02.89 
 ;;9002226.02101,"306,O02.89 ",.02)
 ;;O02.89 
 ;;9002226.02101,"306,O02.89 ",.03)
 ;;30
 ;;9002226.02101,"306,O02.9 ",.01)
 ;;O02.9 
 ;;9002226.02101,"306,O02.9 ",.02)
 ;;O02.9 
 ;;9002226.02101,"306,O02.9 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.0 ",.01)
 ;;O03.0 
 ;;9002226.02101,"306,O03.0 ",.02)
 ;;O03.0 
 ;;9002226.02101,"306,O03.0 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.1 ",.01)
 ;;O03.1 
 ;;9002226.02101,"306,O03.1 ",.02)
 ;;O03.1 
 ;;9002226.02101,"306,O03.1 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.30 ",.01)
 ;;O03.30 
 ;;9002226.02101,"306,O03.30 ",.02)
 ;;O03.30 
 ;;9002226.02101,"306,O03.30 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.31 ",.01)
 ;;O03.31 
 ;;9002226.02101,"306,O03.31 ",.02)
 ;;O03.31 
 ;;9002226.02101,"306,O03.31 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.32 ",.01)
 ;;O03.32 
 ;;9002226.02101,"306,O03.32 ",.02)
 ;;O03.32 
 ;;9002226.02101,"306,O03.32 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.33 ",.01)
 ;;O03.33 
 ;;9002226.02101,"306,O03.33 ",.02)
 ;;O03.33 
 ;;9002226.02101,"306,O03.33 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.34 ",.01)
 ;;O03.34 
 ;;9002226.02101,"306,O03.34 ",.02)
 ;;O03.34 
 ;;9002226.02101,"306,O03.34 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.35 ",.01)
 ;;O03.35 
 ;;9002226.02101,"306,O03.35 ",.02)
 ;;O03.35 
 ;;9002226.02101,"306,O03.35 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.36 ",.01)
 ;;O03.36 
 ;;9002226.02101,"306,O03.36 ",.02)
 ;;O03.26 
 ;;9002226.02101,"306,O03.36 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.37 ",.01)
 ;;O03.37 
 ;;9002226.02101,"306,O03.37 ",.02)
 ;;O03.37 
 ;;9002226.02101,"306,O03.37 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.38 ",.01)
 ;;O03.38 
 ;;9002226.02101,"306,O03.38 ",.02)
 ;;O03.38 
 ;;9002226.02101,"306,O03.38 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.39 ",.01)
 ;;O03.39 
 ;;9002226.02101,"306,O03.39 ",.02)
 ;;O03.39 
 ;;9002226.02101,"306,O03.39 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.4 ",.01)
 ;;O03.4 
 ;;9002226.02101,"306,O03.4 ",.02)
 ;;O03.4 
 ;;9002226.02101,"306,O03.4 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.5 ",.01)
 ;;O03.5 
 ;;9002226.02101,"306,O03.5 ",.02)
 ;;O03.5 
 ;;9002226.02101,"306,O03.5 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.6 ",.01)
 ;;O03.6 
 ;;9002226.02101,"306,O03.6 ",.02)
 ;;O03.6 
 ;;9002226.02101,"306,O03.6 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.7 ",.01)
 ;;O03.7 
 ;;9002226.02101,"306,O03.7 ",.02)
 ;;O03.7 
 ;;9002226.02101,"306,O03.7 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.80 ",.01)
 ;;O03.80 
 ;;9002226.02101,"306,O03.80 ",.02)
 ;;O03.80 
 ;;9002226.02101,"306,O03.80 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.81 ",.01)
 ;;O03.81 
 ;;9002226.02101,"306,O03.81 ",.02)
 ;;O03.81 
 ;;9002226.02101,"306,O03.81 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.82 ",.01)
 ;;O03.82 
 ;;9002226.02101,"306,O03.82 ",.02)
 ;;O03.82 
 ;;9002226.02101,"306,O03.82 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.83 ",.01)
 ;;O03.83 
 ;;9002226.02101,"306,O03.83 ",.02)
 ;;O03.83 
 ;;9002226.02101,"306,O03.83 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.84 ",.01)
 ;;O03.84 
 ;;9002226.02101,"306,O03.84 ",.02)
 ;;O03.84 
 ;;9002226.02101,"306,O03.84 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.85 ",.01)
 ;;O03.85 
 ;;9002226.02101,"306,O03.85 ",.02)
 ;;O03.85 
 ;;9002226.02101,"306,O03.85 ",.03)
 ;;30
 ;;9002226.02101,"306,O03.86 ",.01)
 ;;O03.86 
 ;;9002226.02101,"306,O03.86 ",.02)
 ;;O03.89 
 ;;9002226.02101,"306,O03.86 ",.03)
 ;;30
 ;;9002226.02101,"306,O04.5 ",.01)
 ;;O04.5 
 ;;9002226.02101,"306,O04.5 ",.02)
 ;;O04.5 
 ;;9002226.02101,"306,O04.5 ",.03)
 ;;30
 ;;9002226.02101,"306,O04.6 ",.01)
 ;;O04.6 
 ;;9002226.02101,"306,O04.6 ",.02)
 ;;O04.6 
 ;;9002226.02101,"306,O04.6 ",.03)
 ;;30
 ;;9002226.02101,"306,O04.7 ",.01)
 ;;O04.7 
 ;;9002226.02101,"306,O04.7 ",.02)
 ;;O04.7 
 ;;9002226.02101,"306,O04.7 ",.03)
 ;;30
 ;;9002226.02101,"306,O04.80 ",.01)
 ;;O04.80 
 ;;9002226.02101,"306,O04.80 ",.02)
 ;;O04.89 
 ;;9002226.02101,"306,O04.80 ",.03)
 ;;30
 ;;9002226.02101,"306,O30.2 ",.01)
 ;;O30.2 
 ;;9002226.02101,"306,O30.2 ",.02)
 ;;O30.2 
 ;;9002226.02101,"306,O30.2 ",.03)
 ;;30
 ;;9002226.02101,"306,Z33.2 ",.01)
 ;;Z33.2 
 ;;9002226.02101,"306,Z33.2 ",.02)
 ;;Z33.2 
 ;;9002226.02101,"306,Z33.2 ",.03)
 ;;30
 ;;9002226.04101,"306,1",.01)
 ;;BGP
 ;
OTHER ; OTHER ROUTINES
 Q