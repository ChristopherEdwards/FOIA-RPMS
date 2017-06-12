ATXDBZ ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAY 13, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;SURVEILLANCE IMMUNOLOGICAL
 ;
 ; This routine loads Taxonomy SURVEILLANCE IMMUNOLOGICAL
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
 ;;21,"995.0 ")
 ;;1
 ;;21,"999.4 ")
 ;;2
 ;;21,"999.42 ")
 ;;3
 ;;21,"999.52 ")
 ;;4
 ;;21,"T78.2XXA ")
 ;;5
 ;;21,"T80.52XA ")
 ;;6
 ;;21,"T80.62XA ")
 ;;7
 ;;9002226,1500,.01)
 ;;SURVEILLANCE IMMUNOLOGICAL
 ;;9002226,1500,.02)
 ;;@
 ;;9002226,1500,.04)
 ;;n
 ;;9002226,1500,.06)
 ;;@
 ;;9002226,1500,.08)
 ;;0
 ;;9002226,1500,.09)
 ;;3130612
 ;;9002226,1500,.11)
 ;;@
 ;;9002226,1500,.12)
 ;;31
 ;;9002226,1500,.13)
 ;;1
 ;;9002226,1500,.14)
 ;;@
 ;;9002226,1500,.15)
 ;;80
 ;;9002226,1500,.16)
 ;;@
 ;;9002226,1500,.17)
 ;;@
 ;;9002226,1500,3101)
 ;;@
 ;;9002226.02101,"1500,995.0 ",.01)
 ;;995.0 
 ;;9002226.02101,"1500,995.0 ",.02)
 ;;995.0 
 ;;9002226.02101,"1500,995.0 ",.03)
 ;;1
 ;;9002226.02101,"1500,999.4 ",.01)
 ;;999.4 
 ;;9002226.02101,"1500,999.4 ",.02)
 ;;999.4 
 ;;9002226.02101,"1500,999.4 ",.03)
 ;;1
 ;;9002226.02101,"1500,999.42 ",.01)
 ;;999.42 
 ;;9002226.02101,"1500,999.42 ",.02)
 ;;999.42 
 ;;9002226.02101,"1500,999.42 ",.03)
 ;;1
 ;;9002226.02101,"1500,999.52 ",.01)
 ;;999.52 
 ;;9002226.02101,"1500,999.52 ",.02)
 ;;999.52 
 ;;9002226.02101,"1500,999.52 ",.03)
 ;;1
 ;;9002226.02101,"1500,T78.2XXA ",.01)
 ;;T78.2XXA 
 ;;9002226.02101,"1500,T78.2XXA ",.02)
 ;;T78.2XXA 
 ;;9002226.02101,"1500,T78.2XXA ",.03)
 ;;30
 ;;9002226.02101,"1500,T80.52XA ",.01)
 ;;T80.52XA 
 ;;9002226.02101,"1500,T80.52XA ",.02)
 ;;T80.52XA 
 ;;9002226.02101,"1500,T80.52XA ",.03)
 ;;30
 ;;9002226.02101,"1500,T80.62XA ",.01)
 ;;T80.62XA 
 ;;9002226.02101,"1500,T80.62XA ",.02)
 ;;T80.62XA 
 ;;9002226.02101,"1500,T80.62XA ",.03)
 ;;30
 ;;9002226.04101,"1500,1",.01)
 ;;BGP
 ;
OTHER ; OTHER ROUTINES
 Q