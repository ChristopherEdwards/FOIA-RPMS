BGP2WT ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 28, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP HDL LOINC CODES
 ;
 ; This routine loads Taxonomy BGP HDL LOINC CODES
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
 ;;21,"11054-4 ")
 ;;17
 ;;21,"12771-2 ")
 ;;18
 ;;21,"12772-0 ")
 ;;1
 ;;21,"14646-4 ")
 ;;2
 ;;21,"16616-5 ")
 ;;19
 ;;21,"18263-4 ")
 ;;3
 ;;21,"2085-9 ")
 ;;4
 ;;21,"2086-7 ")
 ;;5
 ;;21,"2095-8 ")
 ;;20
 ;;21,"26015-8 ")
 ;;21
 ;;21,"26016-6 ")
 ;;22
 ;;21,"26017-4 ")
 ;;23
 ;;21,"27340-9 ")
 ;;24
 ;;21,"32309-7 ")
 ;;25
 ;;21,"35197-3 ")
 ;;6
 ;;21,"44733-4 ")
 ;;26
 ;;21,"44915-7 ")
 ;;27
 ;;21,"47220-9 ")
 ;;28
 ;;21,"47221-7 ")
 ;;29
 ;;21,"48090-5 ")
 ;;30
 ;;21,"49130-8 ")
 ;;7
 ;;21,"50409-2 ")
 ;;31
 ;;21,"54467-6 ")
 ;;16
 ;;21,"54468-4 ")
 ;;15
 ;;21,"54469-2 ")
 ;;14
 ;;21,"54470-0 ")
 ;;13
 ;;21,"54471-8 ")
 ;;12
 ;;21,"55607-6 ")
 ;;32
 ;;21,"56132-4 ")
 ;;11
 ;;21,"56133-2 ")
 ;;10
 ;;21,"57936-7 ")
 ;;9
 ;;21,"57937-5 ")
 ;;8
 ;;21,"9322-9 ")
 ;;33
 ;;21,"9830-1 ")
 ;;34
 ;;21,"9832-7 ")
 ;;35
 ;;21,"9833-5 ")
 ;;36
 ;;9002226,333,.01)
 ;;BGP HDL LOINC CODES
 ;;9002226,333,.02)
 ;;@
 ;;9002226,333,.04)
 ;;n
 ;;9002226,333,.06)
 ;;@
 ;;9002226,333,.08)
 ;;@
 ;;9002226,333,.09)
 ;;@
 ;;9002226,333,.11)
 ;;@
 ;;9002226,333,.12)
 ;;@
 ;;9002226,333,.13)
 ;;1
 ;;9002226,333,.14)
 ;;FIHS
 ;;9002226,333,.15)
 ;;95.3
 ;;9002226,333,.16)
 ;;@
 ;;9002226,333,.17)
 ;;@
 ;;9002226,333,3101)
 ;;@
 ;;9002226.02101,"333,11054-4 ",.01)
 ;;11054-4
 ;;9002226.02101,"333,11054-4 ",.02)
 ;;11054-4
 ;;9002226.02101,"333,12771-2 ",.01)
 ;;12771-2
 ;;9002226.02101,"333,12771-2 ",.02)
 ;;12771-2
 ;;9002226.02101,"333,12772-0 ",.01)
 ;;12772-0
 ;;9002226.02101,"333,12772-0 ",.02)
 ;;12772-0
 ;;9002226.02101,"333,14646-4 ",.01)
 ;;14646-4
 ;;9002226.02101,"333,14646-4 ",.02)
 ;;14646-4
 ;;9002226.02101,"333,16616-5 ",.01)
 ;;16616-5
 ;;9002226.02101,"333,16616-5 ",.02)
 ;;16616-5
 ;;9002226.02101,"333,18263-4 ",.01)
 ;;18263-4
 ;;9002226.02101,"333,18263-4 ",.02)
 ;;18263-4
 ;;9002226.02101,"333,2085-9 ",.01)
 ;;2085-9
 ;;9002226.02101,"333,2085-9 ",.02)
 ;;2085-9
 ;;9002226.02101,"333,2086-7 ",.01)
 ;;2086-7
 ;;9002226.02101,"333,2086-7 ",.02)
 ;;2086-7
 ;;9002226.02101,"333,2095-8 ",.01)
 ;;2095-8
 ;;9002226.02101,"333,2095-8 ",.02)
 ;;2095-8
 ;;9002226.02101,"333,26015-8 ",.01)
 ;;26015-8
 ;;9002226.02101,"333,26015-8 ",.02)
 ;;26015-8
 ;;9002226.02101,"333,26016-6 ",.01)
 ;;26016-6
 ;;9002226.02101,"333,26016-6 ",.02)
 ;;26016-6
 ;;9002226.02101,"333,26017-4 ",.01)
 ;;26017-4
 ;;9002226.02101,"333,26017-4 ",.02)
 ;;26017-4
 ;;9002226.02101,"333,27340-9 ",.01)
 ;;27340-9
 ;;9002226.02101,"333,27340-9 ",.02)
 ;;27340-9
 ;;9002226.02101,"333,32309-7 ",.01)
 ;;32309-7
 ;;9002226.02101,"333,32309-7 ",.02)
 ;;32309-7
 ;;9002226.02101,"333,35197-3 ",.01)
 ;;35197-3
 ;;9002226.02101,"333,35197-3 ",.02)
 ;;35197-3
 ;;9002226.02101,"333,44733-4 ",.01)
 ;;44733-4
 ;;9002226.02101,"333,44733-4 ",.02)
 ;;44733-4
 ;;9002226.02101,"333,44915-7 ",.01)
 ;;44915-7
 ;;9002226.02101,"333,44915-7 ",.02)
 ;;44915-7
 ;;9002226.02101,"333,47220-9 ",.01)
 ;;47220-9
 ;;9002226.02101,"333,47220-9 ",.02)
 ;;47220-9
 ;;9002226.02101,"333,47221-7 ",.01)
 ;;47221-7
 ;;9002226.02101,"333,47221-7 ",.02)
 ;;47221-7
 ;;9002226.02101,"333,48090-5 ",.01)
 ;;48090-5
 ;;9002226.02101,"333,48090-5 ",.02)
 ;;48090-5
 ;;9002226.02101,"333,49130-8 ",.01)
 ;;49130-8
 ;;9002226.02101,"333,49130-8 ",.02)
 ;;49130-8
 ;;9002226.02101,"333,50409-2 ",.01)
 ;;50409-2
 ;;9002226.02101,"333,50409-2 ",.02)
 ;;50409-2
 ;;9002226.02101,"333,54467-6 ",.01)
 ;;54467-6
 ;;9002226.02101,"333,54467-6 ",.02)
 ;;54467-6
 ;;9002226.02101,"333,54468-4 ",.01)
 ;;54468-4
 ;;9002226.02101,"333,54468-4 ",.02)
 ;;54468-4
 ;;9002226.02101,"333,54469-2 ",.01)
 ;;54469-2
 ;;9002226.02101,"333,54469-2 ",.02)
 ;;54469-2
 ;;9002226.02101,"333,54470-0 ",.01)
 ;;54470-0
 ;;9002226.02101,"333,54470-0 ",.02)
 ;;54470-0
 ;;9002226.02101,"333,54471-8 ",.01)
 ;;54471-8
 ;;9002226.02101,"333,54471-8 ",.02)
 ;;54471-8
 ;;9002226.02101,"333,55607-6 ",.01)
 ;;55607-6
 ;;9002226.02101,"333,55607-6 ",.02)
 ;;55607-6
 ;;9002226.02101,"333,56132-4 ",.01)
 ;;56132-4
 ;;9002226.02101,"333,56132-4 ",.02)
 ;;56132-4
 ;;9002226.02101,"333,56133-2 ",.01)
 ;;56133-2
 ;;9002226.02101,"333,56133-2 ",.02)
 ;;56133-2
 ;;9002226.02101,"333,57936-7 ",.01)
 ;;57936-7
 ;;9002226.02101,"333,57936-7 ",.02)
 ;;57936-7
 ;;9002226.02101,"333,57937-5 ",.01)
 ;;57937-5
 ;;9002226.02101,"333,57937-5 ",.02)
 ;;57937-5
 ;;9002226.02101,"333,9322-9 ",.01)
 ;;9322-9
 ;;9002226.02101,"333,9322-9 ",.02)
 ;;9322-9
 ;;9002226.02101,"333,9830-1 ",.01)
 ;;9830-1
 ;;9002226.02101,"333,9830-1 ",.02)
 ;;9830-1
 ;;9002226.02101,"333,9832-7 ",.01)
 ;;9832-7
 ;;9002226.02101,"333,9832-7 ",.02)
 ;;9832-7
 ;;9002226.02101,"333,9833-5 ",.01)
 ;;9833-5
 ;;9002226.02101,"333,9833-5 ",.02)
 ;;9833-5
 ;
OTHER ; OTHER ROUTINES
 Q
