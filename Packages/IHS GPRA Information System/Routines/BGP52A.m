BGP52A ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 19, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;;BGP PQA NON-WARF ANTICOAG NDC
 ;
 ; This routine loads Taxonomy BGP PQA NON-WARF ANTICOAG NDC
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
 ;;21,"00003-0893-21 ")
 ;;10
 ;;21,"00003-0893-31 ")
 ;;11
 ;;21,"00003-0894-21 ")
 ;;12
 ;;21,"00003-0894-31 ")
 ;;13
 ;;21,"00597-0107-54 ")
 ;;1
 ;;21,"00597-0107-60 ")
 ;;2
 ;;21,"00597-0135-54 ")
 ;;6
 ;;21,"00597-0135-60 ")
 ;;7
 ;;21,"00597-0149-54 ")
 ;;3
 ;;21,"00597-0149-60 ")
 ;;4
 ;;21,"21695-0899-60 ")
 ;;5
 ;;21,"42254-0376-01 ")
 ;;23
 ;;21,"50458-0578-10 ")
 ;;17
 ;;21,"50458-0578-30 ")
 ;;18
 ;;21,"50458-0578-90 ")
 ;;19
 ;;21,"50458-0579-10 ")
 ;;20
 ;;21,"50458-0579-30 ")
 ;;21
 ;;21,"50458-0579-90 ")
 ;;22
 ;;21,"50458-0580-10 ")
 ;;15
 ;;21,"50458-0580-30 ")
 ;;16
 ;;21,"54569-6276-00 ")
 ;;8
 ;;21,"54569-6513-00 ")
 ;;9
 ;;21,"54569-6514-00 ")
 ;;14
 ;;9002226,1784,.01)
 ;;BGP PQA NON-WARF ANTICOAG NDC
 ;;9002226,1784,.02)
 ;;BGP PQA
 ;;9002226,1784,.04)
 ;;n
 ;;9002226,1784,.06)
 ;;@
 ;;9002226,1784,.08)
 ;;@
 ;;9002226,1784,.09)
 ;;3140819
 ;;9002226,1784,.11)
 ;;@
 ;;9002226,1784,.12)
 ;;@
 ;;9002226,1784,.13)
 ;;1
 ;;9002226,1784,.14)
 ;;@
 ;;9002226,1784,.15)
 ;;50.67
 ;;9002226,1784,.16)
 ;;@
 ;;9002226,1784,.17)
 ;;@
 ;;9002226,1784,3101)
 ;;@
 ;;9002226.02101,"1784,00003-0893-21 ",.01)
 ;;00003-0893-21
 ;;9002226.02101,"1784,00003-0893-21 ",.02)
 ;;00003-0893-21
 ;;9002226.02101,"1784,00003-0893-31 ",.01)
 ;;00003-0893-31
 ;;9002226.02101,"1784,00003-0893-31 ",.02)
 ;;00003-0893-31
 ;;9002226.02101,"1784,00003-0894-21 ",.01)
 ;;00003-0894-21
 ;;9002226.02101,"1784,00003-0894-21 ",.02)
 ;;00003-0894-21
 ;;9002226.02101,"1784,00003-0894-31 ",.01)
 ;;00003-0894-31
 ;;9002226.02101,"1784,00003-0894-31 ",.02)
 ;;00003-0894-31
 ;;9002226.02101,"1784,00597-0107-54 ",.01)
 ;;00597-0107-54
 ;;9002226.02101,"1784,00597-0107-54 ",.02)
 ;;00597-0107-54
 ;;9002226.02101,"1784,00597-0107-60 ",.01)
 ;;00597-0107-60
 ;;9002226.02101,"1784,00597-0107-60 ",.02)
 ;;00597-0107-60
 ;;9002226.02101,"1784,00597-0135-54 ",.01)
 ;;00597-0135-54
 ;;9002226.02101,"1784,00597-0135-54 ",.02)
 ;;00597-0135-54
 ;;9002226.02101,"1784,00597-0135-60 ",.01)
 ;;00597-0135-60
 ;;9002226.02101,"1784,00597-0135-60 ",.02)
 ;;00597-0135-60
 ;;9002226.02101,"1784,00597-0149-54 ",.01)
 ;;00597-0149-54
 ;;9002226.02101,"1784,00597-0149-54 ",.02)
 ;;00597-0149-54
 ;;9002226.02101,"1784,00597-0149-60 ",.01)
 ;;00597-0149-60
 ;;9002226.02101,"1784,00597-0149-60 ",.02)
 ;;00597-0149-60
 ;;9002226.02101,"1784,21695-0899-60 ",.01)
 ;;21695-0899-60
 ;;9002226.02101,"1784,21695-0899-60 ",.02)
 ;;21695-0899-60
 ;;9002226.02101,"1784,42254-0376-01 ",.01)
 ;;42254-0376-01
 ;;9002226.02101,"1784,42254-0376-01 ",.02)
 ;;42254-0376-01
 ;;9002226.02101,"1784,50458-0578-10 ",.01)
 ;;50458-0578-10
 ;;9002226.02101,"1784,50458-0578-10 ",.02)
 ;;50458-0578-10
 ;;9002226.02101,"1784,50458-0578-30 ",.01)
 ;;50458-0578-30
 ;;9002226.02101,"1784,50458-0578-30 ",.02)
 ;;50458-0578-30
 ;;9002226.02101,"1784,50458-0578-90 ",.01)
 ;;50458-0578-90
 ;;9002226.02101,"1784,50458-0578-90 ",.02)
 ;;50458-0578-90
 ;;9002226.02101,"1784,50458-0579-10 ",.01)
 ;;50458-0579-10
 ;;9002226.02101,"1784,50458-0579-10 ",.02)
 ;;50458-0579-10
 ;;9002226.02101,"1784,50458-0579-30 ",.01)
 ;;50458-0579-30
 ;;9002226.02101,"1784,50458-0579-30 ",.02)
 ;;50458-0579-30
 ;;9002226.02101,"1784,50458-0579-90 ",.01)
 ;;50458-0579-90
 ;;9002226.02101,"1784,50458-0579-90 ",.02)
 ;;50458-0579-90
 ;;9002226.02101,"1784,50458-0580-10 ",.01)
 ;;50458-0580-10
 ;;9002226.02101,"1784,50458-0580-10 ",.02)
 ;;50458-0580-10
 ;;9002226.02101,"1784,50458-0580-30 ",.01)
 ;;50458-0580-30
 ;;9002226.02101,"1784,50458-0580-30 ",.02)
 ;;50458-0580-30
 ;;9002226.02101,"1784,54569-6276-00 ",.01)
 ;;54569-6276-00
 ;;9002226.02101,"1784,54569-6276-00 ",.02)
 ;;54569-6276-00
 ;;9002226.02101,"1784,54569-6513-00 ",.01)
 ;;54569-6513-00
 ;;9002226.02101,"1784,54569-6513-00 ",.02)
 ;;54569-6513-00
 ;;9002226.02101,"1784,54569-6514-00 ",.01)
 ;;54569-6514-00
 ;;9002226.02101,"1784,54569-6514-00 ",.02)
 ;;54569-6514-00
 ;
OTHER ; OTHER ROUTINES
 Q