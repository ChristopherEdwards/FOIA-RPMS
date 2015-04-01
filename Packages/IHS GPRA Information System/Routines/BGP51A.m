BGP51A ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 19, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;;BGP HEP C CONF TEST LOINC
 ;
 ; This routine loads Taxonomy BGP HEP C CONF TEST LOINC
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
 ;;21,"10676-5 ")
 ;;17
 ;;21,"11011-4 ")
 ;;19
 ;;21,"11259-9 ")
 ;;16
 ;;21,"20416-4 ")
 ;;28
 ;;21,"20571-6 ")
 ;;27
 ;;21,"29609-5 ")
 ;;18
 ;;21,"32286-7 ")
 ;;3
 ;;21,"34703-9 ")
 ;;22
 ;;21,"34704-7 ")
 ;;21
 ;;21,"38180-6 ")
 ;;24
 ;;21,"42003-4 ")
 ;;25
 ;;21,"42617-1 ")
 ;;23
 ;;21,"47252-2 ")
 ;;26
 ;;21,"48574-8 ")
 ;;2
 ;;21,"48575-5 ")
 ;;5
 ;;21,"48576-3 ")
 ;;34
 ;;21,"48796-7 ")
 ;;1
 ;;21,"49369-2 ")
 ;;15
 ;;21,"49370-0 ")
 ;;11
 ;;21,"49371-8 ")
 ;;33
 ;;21,"49372-6 ")
 ;;38
 ;;21,"49373-4 ")
 ;;14
 ;;21,"49374-2 ")
 ;;10
 ;;21,"49375-9 ")
 ;;32
 ;;21,"49376-7 ")
 ;;36
 ;;21,"49377-5 ")
 ;;12
 ;;21,"49378-3 ")
 ;;8
 ;;21,"49379-1 ")
 ;;30
 ;;21,"49380-9 ")
 ;;39
 ;;21,"49603-4 ")
 ;;13
 ;;21,"49604-2 ")
 ;;9
 ;;21,"49605-9 ")
 ;;37
 ;;21,"49607-5 ")
 ;;4
 ;;21,"49608-3 ")
 ;;31
 ;;21,"49758-6 ")
 ;;20
 ;;21,"50023-1 ")
 ;;40
 ;;21,"5010-4 ")
 ;;6
 ;;21,"5011-2 ")
 ;;29
 ;;21,"5012-0 ")
 ;;35
 ;;21,"51655-9 ")
 ;;7
 ;;9002226,1824,.01)
 ;;BGP HEP C CONF TEST LOINC
 ;;9002226,1824,.02)
 ;;HEP C CONF
 ;;9002226,1824,.04)
 ;;n
 ;;9002226,1824,.06)
 ;;@
 ;;9002226,1824,.08)
 ;;@
 ;;9002226,1824,.09)
 ;;@
 ;;9002226,1824,.11)
 ;;@
 ;;9002226,1824,.12)
 ;;@
 ;;9002226,1824,.13)
 ;;1
 ;;9002226,1824,.14)
 ;;FIHS
 ;;9002226,1824,.15)
 ;;95.3
 ;;9002226,1824,.16)
 ;;@
 ;;9002226,1824,.17)
 ;;@
 ;;9002226,1824,3101)
 ;;@
 ;;9002226.02101,"1824,10676-5 ",.01)
 ;;10676-5
 ;;9002226.02101,"1824,10676-5 ",.02)
 ;;10676-5
 ;;9002226.02101,"1824,11011-4 ",.01)
 ;;11011-4
 ;;9002226.02101,"1824,11011-4 ",.02)
 ;;11011-4
 ;;9002226.02101,"1824,11259-9 ",.01)
 ;;11259-9
 ;;9002226.02101,"1824,11259-9 ",.02)
 ;;11259-9
 ;;9002226.02101,"1824,20416-4 ",.01)
 ;;20416-4
 ;;9002226.02101,"1824,20416-4 ",.02)
 ;;20416-4
 ;;9002226.02101,"1824,20571-6 ",.01)
 ;;20571-6
 ;;9002226.02101,"1824,20571-6 ",.02)
 ;;20571-6
 ;;9002226.02101,"1824,29609-5 ",.01)
 ;;29609-5
 ;;9002226.02101,"1824,29609-5 ",.02)
 ;;29609-5
 ;;9002226.02101,"1824,32286-7 ",.01)
 ;;32286-7
 ;;9002226.02101,"1824,32286-7 ",.02)
 ;;32286-7
 ;;9002226.02101,"1824,34703-9 ",.01)
 ;;34703-9
 ;;9002226.02101,"1824,34703-9 ",.02)
 ;;34703-9
 ;;9002226.02101,"1824,34704-7 ",.01)
 ;;34704-7
 ;;9002226.02101,"1824,34704-7 ",.02)
 ;;34704-7
 ;;9002226.02101,"1824,38180-6 ",.01)
 ;;38180-6
 ;;9002226.02101,"1824,38180-6 ",.02)
 ;;38180-6
 ;;9002226.02101,"1824,42003-4 ",.01)
 ;;42003-4
 ;;9002226.02101,"1824,42003-4 ",.02)
 ;;42003-4
 ;;9002226.02101,"1824,42617-1 ",.01)
 ;;42617-1
 ;;9002226.02101,"1824,42617-1 ",.02)
 ;;42617-1
 ;;9002226.02101,"1824,47252-2 ",.01)
 ;;47252-2
 ;;9002226.02101,"1824,47252-2 ",.02)
 ;;47252-2
 ;;9002226.02101,"1824,48574-8 ",.01)
 ;;48574-8
 ;;9002226.02101,"1824,48574-8 ",.02)
 ;;48574-8
 ;;9002226.02101,"1824,48575-5 ",.01)
 ;;48575-5
 ;;9002226.02101,"1824,48575-5 ",.02)
 ;;48575-5
 ;;9002226.02101,"1824,48576-3 ",.01)
 ;;48576-3
 ;;9002226.02101,"1824,48576-3 ",.02)
 ;;48576-3
 ;;9002226.02101,"1824,48796-7 ",.01)
 ;;48796-7
 ;;9002226.02101,"1824,48796-7 ",.02)
 ;;48796-7
 ;;9002226.02101,"1824,49369-2 ",.01)
 ;;49369-2
 ;;9002226.02101,"1824,49369-2 ",.02)
 ;;49369-2
 ;;9002226.02101,"1824,49370-0 ",.01)
 ;;49370-0
 ;;9002226.02101,"1824,49370-0 ",.02)
 ;;49370-0
 ;;9002226.02101,"1824,49371-8 ",.01)
 ;;49371-8
 ;;9002226.02101,"1824,49371-8 ",.02)
 ;;49371-8
 ;;9002226.02101,"1824,49372-6 ",.01)
 ;;49372-6
 ;;9002226.02101,"1824,49372-6 ",.02)
 ;;49372-6
 ;;9002226.02101,"1824,49373-4 ",.01)
 ;;49373-4
 ;;9002226.02101,"1824,49373-4 ",.02)
 ;;49373-4
 ;;9002226.02101,"1824,49374-2 ",.01)
 ;;49374-2
 ;;9002226.02101,"1824,49374-2 ",.02)
 ;;49374-2
 ;;9002226.02101,"1824,49375-9 ",.01)
 ;;49375-9
 ;;9002226.02101,"1824,49375-9 ",.02)
 ;;49375-9
 ;;9002226.02101,"1824,49376-7 ",.01)
 ;;49376-7
 ;;9002226.02101,"1824,49376-7 ",.02)
 ;;49376-7
 ;;9002226.02101,"1824,49377-5 ",.01)
 ;;49377-5
 ;;9002226.02101,"1824,49377-5 ",.02)
 ;;49377-5
 ;;9002226.02101,"1824,49378-3 ",.01)
 ;;49378-3
 ;;9002226.02101,"1824,49378-3 ",.02)
 ;;49378-3
 ;;9002226.02101,"1824,49379-1 ",.01)
 ;;49379-1
 ;;9002226.02101,"1824,49379-1 ",.02)
 ;;49379-1
 ;;9002226.02101,"1824,49380-9 ",.01)
 ;;49380-9
 ;;9002226.02101,"1824,49380-9 ",.02)
 ;;49380-9
 ;;9002226.02101,"1824,49603-4 ",.01)
 ;;49603-4
 ;;9002226.02101,"1824,49603-4 ",.02)
 ;;49603-4
 ;;9002226.02101,"1824,49604-2 ",.01)
 ;;49604-2
 ;;9002226.02101,"1824,49604-2 ",.02)
 ;;49604-2
 ;;9002226.02101,"1824,49605-9 ",.01)
 ;;49605-9
 ;;9002226.02101,"1824,49605-9 ",.02)
 ;;49605-9
 ;;9002226.02101,"1824,49607-5 ",.01)
 ;;49607-5
 ;;9002226.02101,"1824,49607-5 ",.02)
 ;;49607-5
 ;;9002226.02101,"1824,49608-3 ",.01)
 ;;49608-3
 ;;9002226.02101,"1824,49608-3 ",.02)
 ;;49608-3
 ;;9002226.02101,"1824,49758-6 ",.01)
 ;;49758-6
 ;;9002226.02101,"1824,49758-6 ",.02)
 ;;49758-6
 ;;9002226.02101,"1824,50023-1 ",.01)
 ;;50023-1
 ;;9002226.02101,"1824,50023-1 ",.02)
 ;;50023-1
 ;;9002226.02101,"1824,5010-4 ",.01)
 ;;5010-4
 ;;9002226.02101,"1824,5010-4 ",.02)
 ;;5010-4
 ;;9002226.02101,"1824,5011-2 ",.01)
 ;;5011-2
 ;;9002226.02101,"1824,5011-2 ",.02)
 ;;5011-2
 ;;9002226.02101,"1824,5012-0 ",.01)
 ;;5012-0
 ;;9002226.02101,"1824,5012-0 ",.02)
 ;;5012-0
 ;;9002226.02101,"1824,51655-9 ",.01)
 ;;51655-9
 ;;9002226.02101,"1824,51655-9 ",.02)
 ;;51655-9
 ;
OTHER ; OTHER ROUTINES
 Q