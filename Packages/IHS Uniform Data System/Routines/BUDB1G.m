BUDB1G ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON JAN 30, 2015;
 ;;9.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 02, 2015;Build 42
 ;;BUD HIV FU CPTS
 ;
 ; This routine loads Taxonomy BUD HIV FU CPTS
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
 ;;21,"86359 ")
 ;;1
 ;;21,"86689 ")
 ;;2
 ;;21,"86701 ")
 ;;3
 ;;21,"87390 ")
 ;;4
 ;;21,"87534 ")
 ;;5
 ;;21,"G9214 ")
 ;;6
 ;;21,"G9242 ")
 ;;7
 ;;9002226,2064,.01)
 ;;BUD HIV FU CPTS
 ;;9002226,2064,.02)
 ;;BUD
 ;;9002226,2064,.04)
 ;;@
 ;;9002226,2064,.06)
 ;;@
 ;;9002226,2064,.08)
 ;;0
 ;;9002226,2064,.09)
 ;;3150130
 ;;9002226,2064,.11)
 ;;@
 ;;9002226,2064,.12)
 ;;455
 ;;9002226,2064,.13)
 ;;1
 ;;9002226,2064,.14)
 ;;@
 ;;9002226,2064,.15)
 ;;81
 ;;9002226,2064,.16)
 ;;@
 ;;9002226,2064,.17)
 ;;@
 ;;9002226,2064,3101)
 ;;@
 ;;9002226.02101,"2064,86359 ",.01)
 ;;86359 
 ;;9002226.02101,"2064,86359 ",.02)
 ;;86361 
 ;;9002226.02101,"2064,86689 ",.01)
 ;;86689 
 ;;9002226.02101,"2064,86689 ",.02)
 ;;86689 
 ;;9002226.02101,"2064,86701 ",.01)
 ;;86701 
 ;;9002226.02101,"2064,86701 ",.02)
 ;;86703 
 ;;9002226.02101,"2064,87390 ",.01)
 ;;87390 
 ;;9002226.02101,"2064,87390 ",.02)
 ;;87391 
 ;;9002226.02101,"2064,87534 ",.01)
 ;;87534 
 ;;9002226.02101,"2064,87534 ",.02)
 ;;87539 
 ;;9002226.02101,"2064,G9214 ",.01)
 ;;G9214 
 ;;9002226.02101,"2064,G9214 ",.02)
 ;;G9214 
 ;;9002226.02101,"2064,G9242 ",.01)
 ;;G9242 
 ;;9002226.02101,"2064,G9242 ",.02)
 ;;G9243 
 ;
OTHER ; OTHER ROUTINES
 Q