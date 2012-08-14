BGPUXR ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON JUL 05, 2004 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;;BGP VARICELLA CONTRA
 ;
 ; This routine loads Taxonomy BGP VARICELLA CONTRA
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
 ;;21,"042. ")
 ;;1
 ;;21,"200.00 ")
 ;;2
 ;;21,"203.0 ")
 ;;3
 ;;21,"203.00 ")
 ;;4
 ;;21,"203.01 ")
 ;;5
 ;;21,"203.8 ")
 ;;6
 ;;21,"204.0 ")
 ;;7
 ;;21,"279.00 ")
 ;;8
 ;;21,"V08. ")
 ;;9
 ;;9002226,833,.01)
 ;;BGP VARICELLA CONTRA
 ;;9002226,833,.02)
 ;;@
 ;;9002226,833,.04)
 ;;n
 ;;9002226,833,.06)
 ;;@
 ;;9002226,833,.08)
 ;;0
 ;;9002226,833,.09)
 ;;3040527
 ;;9002226,833,.11)
 ;;@
 ;;9002226,833,.12)
 ;;31
 ;;9002226,833,.13)
 ;;1
 ;;9002226,833,.14)
 ;;@
 ;;9002226,833,.15)
 ;;80
 ;;9002226,833,.16)
 ;;@
 ;;9002226,833,.17)
 ;;@
 ;;9002226,833,3101)
 ;;@
 ;;9002226.02101,"833,042. ",.01)
 ;;042. 
 ;;9002226.02101,"833,042. ",.02)
 ;;042.9 
 ;;9002226.02101,"833,200.00 ",.01)
 ;;200.00 
 ;;9002226.02101,"833,200.00 ",.02)
 ;;202.98 
 ;;9002226.02101,"833,203.0 ",.01)
 ;;203.0 
 ;;9002226.02101,"833,203.0 ",.02)
 ;;203.0 
 ;;9002226.02101,"833,203.00 ",.01)
 ;;203.00 
 ;;9002226.02101,"833,203.00 ",.02)
 ;;203.00 
 ;;9002226.02101,"833,203.01 ",.01)
 ;;203.01 
 ;;9002226.02101,"833,203.01 ",.02)
 ;;203.01 
 ;;9002226.02101,"833,203.8 ",.01)
 ;;203.8 
 ;;9002226.02101,"833,203.8 ",.02)
 ;;203.81 
 ;;9002226.02101,"833,204.0 ",.01)
 ;;204.0 
 ;;9002226.02101,"833,204.0 ",.02)
 ;;208.91 
 ;;9002226.02101,"833,279.00 ",.01)
 ;;279.00 
 ;;9002226.02101,"833,279.00 ",.02)
 ;;279.9 
 ;;9002226.02101,"833,V08. ",.01)
 ;;V08. 
 ;;9002226.02101,"833,V08. ",.02)
 ;;V08. 
 ;
OTHER ; OTHER ROUTINES
 Q