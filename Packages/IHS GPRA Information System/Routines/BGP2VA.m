BGP2VA ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 03, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP QUANT URINE PROT LOINC
 ;
 ; This routine loads Taxonomy BGP QUANT URINE PROT LOINC
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
 ;;21,"11218-5 ")
 ;;1
 ;;21,"12842-1 ")
 ;;2
 ;;21,"13705-9 ")
 ;;3
 ;;21,"13801-6 ")
 ;;4
 ;;21,"13986-5 ")
 ;;5
 ;;21,"13991-5 ")
 ;;6
 ;;21,"13992-3 ")
 ;;7
 ;;21,"14585-4 ")
 ;;8
 ;;21,"14956-7 ")
 ;;9
 ;;21,"14957-5 ")
 ;;10
 ;;21,"14958-3 ")
 ;;11
 ;;21,"14959-1 ")
 ;;12
 ;;21,"1753-3 ")
 ;;13
 ;;21,"1754-1 ")
 ;;14
 ;;21,"1755-8 ")
 ;;15
 ;;21,"1757-4 ")
 ;;16
 ;;21,"17819-4 ")
 ;;17
 ;;21,"18373-1 ")
 ;;18
 ;;21,"20621-9 ")
 ;;19
 ;;21,"21059-1 ")
 ;;20
 ;;21,"21482-5 ")
 ;;21
 ;;21,"26034-9 ")
 ;;22
 ;;21,"26801-1 ")
 ;;23
 ;;21,"27298-9 ")
 ;;24
 ;;21,"2887-8 ")
 ;;25
 ;;21,"2888-6 ")
 ;;26
 ;;21,"2889-4 ")
 ;;27
 ;;21,"2890-2 ")
 ;;28
 ;;21,"30000-4 ")
 ;;29
 ;;21,"30001-2 ")
 ;;30
 ;;21,"30003-8 ")
 ;;31
 ;;21,"32209-9 ")
 ;;65
 ;;21,"32294-1 ")
 ;;32
 ;;21,"32551-4 ")
 ;;33
 ;;21,"34366-5 ")
 ;;34
 ;;21,"34535-5 ")
 ;;35
 ;;21,"35663-4 ")
 ;;36
 ;;21,"40486-3 ")
 ;;37
 ;;21,"40662-9 ")
 ;;38
 ;;21,"40663-7 ")
 ;;39
 ;;21,"40857-5 ")
 ;;40
 ;;21,"43605-5 ")
 ;;41
 ;;21,"43606-3 ")
 ;;42
 ;;21,"43607-1 ")
 ;;43
 ;;21,"44292-1 ")
 ;;44
 ;;21,"47558-2 ")
 ;;45
 ;;21,"49002-9 ")
 ;;46
 ;;21,"49023-5 ")
 ;;47
 ;;21,"50209-6 ")
 ;;48
 ;;21,"50949-7 ")
 ;;66
 ;;21,"51190-7 ")
 ;;49
 ;;21,"53121-0 ")
 ;;50
 ;;21,"53229-1 ")
 ;;51
 ;;21,"53525-2 ")
 ;;52
 ;;21,"53530-2 ")
 ;;53
 ;;21,"53531-0 ")
 ;;54
 ;;21,"53532-8 ")
 ;;55
 ;;21,"56553-1 ")
 ;;56
 ;;21,"57369-1 ")
 ;;57
 ;;21,"58448-2 ")
 ;;58
 ;;21,"58992-9 ")
 ;;59
 ;;21,"59159-4 ")
 ;;60
 ;;21,"60678-0 ")
 ;;67
 ;;21,"63474-1 ")
 ;;61
 ;;21,"6941-9 ")
 ;;62
 ;;21,"6942-7 ")
 ;;63
 ;;21,"9318-7 ")
 ;;64
 ;;9002226,702,.01)
 ;;BGP QUANT URINE PROT LOINC
 ;;9002226,702,.02)
 ;;@
 ;;9002226,702,.04)
 ;;n
 ;;9002226,702,.06)
 ;;@
 ;;9002226,702,.08)
 ;;@
 ;;9002226,702,.09)
 ;;3120322
 ;;9002226,702,.11)
 ;;@
 ;;9002226,702,.12)
 ;;@
 ;;9002226,702,.13)
 ;;1
 ;;9002226,702,.14)
 ;;FIHS
 ;;9002226,702,.15)
 ;;95.3
 ;;9002226,702,.16)
 ;;@
 ;;9002226,702,.17)
 ;;@
 ;;9002226,702,3101)
 ;;@
 ;;9002226.02101,"702,11218-5 ",.01)
 ;;11218-5
 ;;9002226.02101,"702,11218-5 ",.02)
 ;;11218-5
 ;;9002226.02101,"702,12842-1 ",.01)
 ;;12842-1
 ;;9002226.02101,"702,12842-1 ",.02)
 ;;12842-1
 ;;9002226.02101,"702,13705-9 ",.01)
 ;;13705-9
 ;;9002226.02101,"702,13705-9 ",.02)
 ;;13705-9
 ;;9002226.02101,"702,13801-6 ",.01)
 ;;13801-6
 ;;9002226.02101,"702,13801-6 ",.02)
 ;;13801-6
 ;;9002226.02101,"702,13986-5 ",.01)
 ;;13986-5
 ;;9002226.02101,"702,13986-5 ",.02)
 ;;13986-5
 ;;9002226.02101,"702,13991-5 ",.01)
 ;;13991-5
 ;;9002226.02101,"702,13991-5 ",.02)
 ;;13991-5
 ;;9002226.02101,"702,13992-3 ",.01)
 ;;13992-3
 ;;9002226.02101,"702,13992-3 ",.02)
 ;;13992-3
 ;;9002226.02101,"702,14585-4 ",.01)
 ;;14585-4
 ;;9002226.02101,"702,14585-4 ",.02)
 ;;14585-4
 ;;9002226.02101,"702,14956-7 ",.01)
 ;;14956-7
 ;;9002226.02101,"702,14956-7 ",.02)
 ;;14956-7
 ;;9002226.02101,"702,14957-5 ",.01)
 ;;14957-5
 ;;9002226.02101,"702,14957-5 ",.02)
 ;;14957-5
 ;;9002226.02101,"702,14958-3 ",.01)
 ;;14958-3
 ;;9002226.02101,"702,14958-3 ",.02)
 ;;14958-3
 ;;9002226.02101,"702,14959-1 ",.01)
 ;;14959-1
 ;;9002226.02101,"702,14959-1 ",.02)
 ;;14959-1
 ;;9002226.02101,"702,1753-3 ",.01)
 ;;1753-3
 ;;9002226.02101,"702,1753-3 ",.02)
 ;;1753-3
 ;;9002226.02101,"702,1754-1 ",.01)
 ;;1754-1
 ;;9002226.02101,"702,1754-1 ",.02)
 ;;1754-1
 ;;9002226.02101,"702,1755-8 ",.01)
 ;;1755-8
 ;;9002226.02101,"702,1755-8 ",.02)
 ;;1755-8
 ;;9002226.02101,"702,1757-4 ",.01)
 ;;1757-4
 ;;9002226.02101,"702,1757-4 ",.02)
 ;;1757-4
 ;;9002226.02101,"702,17819-4 ",.01)
 ;;17819-4
 ;;9002226.02101,"702,17819-4 ",.02)
 ;;17819-4
 ;;9002226.02101,"702,18373-1 ",.01)
 ;;18373-1
 ;;9002226.02101,"702,18373-1 ",.02)
 ;;18373-1
 ;;9002226.02101,"702,20621-9 ",.01)
 ;;20621-9
 ;;9002226.02101,"702,20621-9 ",.02)
 ;;20621-9
 ;;9002226.02101,"702,21059-1 ",.01)
 ;;21059-1
 ;;9002226.02101,"702,21059-1 ",.02)
 ;;21059-1
 ;;9002226.02101,"702,21482-5 ",.01)
 ;;21482-5
 ;;9002226.02101,"702,21482-5 ",.02)
 ;;21482-5
 ;;9002226.02101,"702,26034-9 ",.01)
 ;;26034-9
 ;;9002226.02101,"702,26034-9 ",.02)
 ;;26034-9
 ;;9002226.02101,"702,26801-1 ",.01)
 ;;26801-1
 ;;9002226.02101,"702,26801-1 ",.02)
 ;;26801-1
 ;;9002226.02101,"702,27298-9 ",.01)
 ;;27298-9
 ;;9002226.02101,"702,27298-9 ",.02)
 ;;27298-9
 ;;9002226.02101,"702,2887-8 ",.01)
 ;;2887-8
 ;;9002226.02101,"702,2887-8 ",.02)
 ;;2887-8
 ;;9002226.02101,"702,2888-6 ",.01)
 ;;2888-6
 ;;9002226.02101,"702,2888-6 ",.02)
 ;;2888-6
 ;;9002226.02101,"702,2889-4 ",.01)
 ;;2889-4
 ;;9002226.02101,"702,2889-4 ",.02)
 ;;2889-4
 ;;9002226.02101,"702,2890-2 ",.01)
 ;;2890-2
 ;;9002226.02101,"702,2890-2 ",.02)
 ;;2890-2
 ;;9002226.02101,"702,30000-4 ",.01)
 ;;30000-4
 ;;9002226.02101,"702,30000-4 ",.02)
 ;;30000-4
 ;;9002226.02101,"702,30001-2 ",.01)
 ;;30001-2
 ;;9002226.02101,"702,30001-2 ",.02)
 ;;30001-2
 ;;9002226.02101,"702,30003-8 ",.01)
 ;;30003-8
 ;;9002226.02101,"702,30003-8 ",.02)
 ;;30003-8
 ;;9002226.02101,"702,32209-9 ",.01)
 ;;32209-9
 ;;9002226.02101,"702,32209-9 ",.02)
 ;;32209-9
 ;;9002226.02101,"702,32294-1 ",.01)
 ;;32294-1
 ;;9002226.02101,"702,32294-1 ",.02)
 ;;32294-1
 ;;9002226.02101,"702,32551-4 ",.01)
 ;;32551-4
 ;;9002226.02101,"702,32551-4 ",.02)
 ;;32551-4
 ;;9002226.02101,"702,34366-5 ",.01)
 ;;34366-5
 ;;9002226.02101,"702,34366-5 ",.02)
 ;;34366-5
 ;;9002226.02101,"702,34535-5 ",.01)
 ;;34535-5
 ;;9002226.02101,"702,34535-5 ",.02)
 ;;34535-5
 ;;9002226.02101,"702,35663-4 ",.01)
 ;;35663-4
 ;;9002226.02101,"702,35663-4 ",.02)
 ;;35663-4
 ;;9002226.02101,"702,40486-3 ",.01)
 ;;40486-3
 ;;9002226.02101,"702,40486-3 ",.02)
 ;;40486-3
 ;;9002226.02101,"702,40662-9 ",.01)
 ;;40662-9
 ;;9002226.02101,"702,40662-9 ",.02)
 ;;40662-9
 ;;9002226.02101,"702,40663-7 ",.01)
 ;;40663-7
 ;;9002226.02101,"702,40663-7 ",.02)
 ;;40663-7
 ;;9002226.02101,"702,40857-5 ",.01)
 ;;40857-5
 ;;9002226.02101,"702,40857-5 ",.02)
 ;;40857-5
 ;;9002226.02101,"702,43605-5 ",.01)
 ;;43605-5
 ;;9002226.02101,"702,43605-5 ",.02)
 ;;43605-5
 ;;9002226.02101,"702,43606-3 ",.01)
 ;;43606-3
 ;;9002226.02101,"702,43606-3 ",.02)
 ;;43606-3
 ;;9002226.02101,"702,43607-1 ",.01)
 ;;43607-1
 ;;9002226.02101,"702,43607-1 ",.02)
 ;;43607-1
 ;;9002226.02101,"702,44292-1 ",.01)
 ;;44292-1
 ;;9002226.02101,"702,44292-1 ",.02)
 ;;44292-1
 ;;9002226.02101,"702,47558-2 ",.01)
 ;;47558-2
 ;;9002226.02101,"702,47558-2 ",.02)
 ;;47558-2
 ;;9002226.02101,"702,49002-9 ",.01)
 ;;49002-9
 ;;9002226.02101,"702,49002-9 ",.02)
 ;;49002-9
 ;;9002226.02101,"702,49023-5 ",.01)
 ;;49023-5
 ;;9002226.02101,"702,49023-5 ",.02)
 ;;49023-5
 ;;9002226.02101,"702,50209-6 ",.01)
 ;;50209-6
 ;;9002226.02101,"702,50209-6 ",.02)
 ;;50209-6
 ;;9002226.02101,"702,50949-7 ",.01)
 ;;50949-7
 ;;9002226.02101,"702,50949-7 ",.02)
 ;;50949-7
 ;;9002226.02101,"702,51190-7 ",.01)
 ;;51190-7
 ;;9002226.02101,"702,51190-7 ",.02)
 ;;51190-7
 ;;9002226.02101,"702,53121-0 ",.01)
 ;;53121-0
 ;;9002226.02101,"702,53121-0 ",.02)
 ;;53121-0
 ;;9002226.02101,"702,53229-1 ",.01)
 ;;53229-1
 ;;9002226.02101,"702,53229-1 ",.02)
 ;;53229-1
 ;;9002226.02101,"702,53525-2 ",.01)
 ;;53525-2
 ;;9002226.02101,"702,53525-2 ",.02)
 ;;53525-2
 ;;9002226.02101,"702,53530-2 ",.01)
 ;;53530-2
 ;;9002226.02101,"702,53530-2 ",.02)
 ;;53530-2
 ;;9002226.02101,"702,53531-0 ",.01)
 ;;53531-0
 ;;9002226.02101,"702,53531-0 ",.02)
 ;;53531-0
 ;;9002226.02101,"702,53532-8 ",.01)
 ;;53532-8
 ;;9002226.02101,"702,53532-8 ",.02)
 ;;53532-8
 ;;9002226.02101,"702,56553-1 ",.01)
 ;;56553-1
 ;;9002226.02101,"702,56553-1 ",.02)
 ;;56553-1
 ;;9002226.02101,"702,57369-1 ",.01)
 ;;57369-1
 ;;9002226.02101,"702,57369-1 ",.02)
 ;;57369-1
 ;;9002226.02101,"702,58448-2 ",.01)
 ;;58448-2
 ;;9002226.02101,"702,58448-2 ",.02)
 ;;58448-2
 ;;9002226.02101,"702,58992-9 ",.01)
 ;;58992-9
 ;;9002226.02101,"702,58992-9 ",.02)
 ;;58992-9
 ;;9002226.02101,"702,59159-4 ",.01)
 ;;59159-4
 ;;9002226.02101,"702,59159-4 ",.02)
 ;;59159-4
 ;;9002226.02101,"702,60678-0 ",.01)
 ;;60678-0
 ;;9002226.02101,"702,60678-0 ",.02)
 ;;60678-0
 ;;9002226.02101,"702,63474-1 ",.01)
 ;;63474-1
 ;;9002226.02101,"702,63474-1 ",.02)
 ;;63474-1
 ;;9002226.02101,"702,6941-9 ",.01)
 ;;6941-9
 ;;9002226.02101,"702,6941-9 ",.02)
 ;;6941-9
 ;;9002226.02101,"702,6942-7 ",.01)
 ;;6942-7
 ;;9002226.02101,"702,6942-7 ",.02)
 ;;6942-7
 ;;9002226.02101,"702,9318-7 ",.01)
 ;;9318-7
 ;;9002226.02101,"702,9318-7 ",.02)
 ;;9318-7
 ;
OTHER ; OTHER ROUTINES
 Q
