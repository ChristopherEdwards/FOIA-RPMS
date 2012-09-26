BGP21F17 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"68382-0022-01 ")
 ;;515
 ;;21,"68382-0022-10 ")
 ;;516
 ;;21,"68382-0023-01 ")
 ;;716
 ;;21,"68382-0023-10 ")
 ;;717
 ;;21,"68382-0024-01 ")
 ;;372
 ;;21,"68382-0024-10 ")
 ;;373
 ;;21,"68382-0092-01 ")
 ;;1028
 ;;21,"68382-0092-05 ")
 ;;1029
 ;;21,"68382-0092-17 ")
 ;;1030
 ;;21,"68382-0093-01 ")
 ;;1108
 ;;21,"68382-0093-05 ")
 ;;1109
 ;;21,"68382-0093-17 ")
 ;;1110
 ;;21,"68382-0094-01 ")
 ;;884
 ;;21,"68382-0094-05 ")
 ;;885
 ;;21,"68382-0094-17 ")
 ;;886
 ;;21,"68382-0095-01 ")
 ;;966
 ;;21,"68382-0095-05 ")
 ;;967
 ;;21,"68382-0095-17 ")
 ;;968
 ;;21,"68387-0537-30 ")
 ;;718
 ;;21,"68387-0538-30 ")
 ;;719
 ;;21,"68387-0539-30 ")
 ;;374
 ;;21,"68462-0162-01 ")
 ;;1031
 ;;21,"68462-0162-05 ")
 ;;1032
 ;;21,"68462-0163-01 ")
 ;;1111
 ;;21,"68462-0163-05 ")
 ;;1112
 ;;21,"68462-0164-01 ")
 ;;887
 ;;21,"68462-0164-05 ")
 ;;888
 ;;21,"68462-0165-01 ")
 ;;969
 ;;21,"68462-0165-05 ")
 ;;970
 ;;21,"68645-0190-59 ")
 ;;1858
 ;;21,"68645-0191-59 ")
 ;;1569
 ;;9002226,1195,.01)
 ;;BGP PQA BETA BLOCKER NDC
 ;;9002226,1195,.02)
 ;;@
 ;;9002226,1195,.04)
 ;;n
 ;;9002226,1195,.06)
 ;;@
 ;;9002226,1195,.08)
 ;;@
 ;;9002226,1195,.09)
 ;;@
 ;;9002226,1195,.11)
 ;;@
 ;;9002226,1195,.12)
 ;;@
 ;;9002226,1195,.13)
 ;;1
 ;;9002226,1195,.14)
 ;;@
 ;;9002226,1195,.15)
 ;;@
 ;;9002226,1195,.16)
 ;;@
 ;;9002226,1195,.17)
 ;;@
 ;;9002226,1195,3101)
 ;;@
 ;;9002226.02101,"1195,00003-0207-50 ",.01)
 ;;00003-0207-50
 ;;9002226.02101,"1195,00003-0207-50 ",.02)
 ;;00003-0207-50
 ;;9002226.02101,"1195,00003-0207-76 ",.01)
 ;;00003-0207-76
 ;;9002226.02101,"1195,00003-0207-76 ",.02)
 ;;00003-0207-76
 ;;9002226.02101,"1195,00003-0208-50 ",.01)
 ;;00003-0208-50
 ;;9002226.02101,"1195,00003-0208-50 ",.02)
 ;;00003-0208-50
 ;;9002226.02101,"1195,00003-0232-50 ",.01)
 ;;00003-0232-50
 ;;9002226.02101,"1195,00003-0232-50 ",.02)
 ;;00003-0232-50
 ;;9002226.02101,"1195,00003-0241-50 ",.01)
 ;;00003-0241-50
 ;;9002226.02101,"1195,00003-0241-50 ",.02)
 ;;00003-0241-50
 ;;9002226.02101,"1195,00003-0241-76 ",.01)
 ;;00003-0241-76
 ;;9002226.02101,"1195,00003-0241-76 ",.02)
 ;;00003-0241-76
 ;;9002226.02101,"1195,00003-0246-49 ",.01)
 ;;00003-0246-49
 ;;9002226.02101,"1195,00003-0246-49 ",.02)
 ;;00003-0246-49
 ;;9002226.02101,"1195,00003-0283-50 ",.01)
 ;;00003-0283-50
 ;;9002226.02101,"1195,00003-0283-50 ",.02)
 ;;00003-0283-50
 ;;9002226.02101,"1195,00005-3219-43 ",.01)
 ;;00005-3219-43
 ;;9002226.02101,"1195,00005-3219-43 ",.02)
 ;;00005-3219-43
 ;;9002226.02101,"1195,00005-3220-34 ",.01)
 ;;00005-3220-34
 ;;9002226.02101,"1195,00005-3220-34 ",.02)
 ;;00005-3220-34
 ;;9002226.02101,"1195,00005-3234-23 ",.01)
 ;;00005-3234-23
 ;;9002226.02101,"1195,00005-3234-23 ",.02)
 ;;00005-3234-23
 ;;9002226.02101,"1195,00005-3235-38 ",.01)
 ;;00005-3235-38
 ;;9002226.02101,"1195,00005-3235-38 ",.02)
 ;;00005-3235-38
 ;;9002226.02101,"1195,00005-3238-23 ",.01)
 ;;00005-3238-23
 ;;9002226.02101,"1195,00005-3238-23 ",.02)
 ;;00005-3238-23
 ;;9002226.02101,"1195,00005-3816-38 ",.01)
 ;;00005-3816-38
 ;;9002226.02101,"1195,00005-3816-38 ",.02)
 ;;00005-3816-38
 ;;9002226.02101,"1195,00005-3817-38 ",.01)
 ;;00005-3817-38
 ;;9002226.02101,"1195,00005-3817-38 ",.02)
 ;;00005-3817-38
 ;;9002226.02101,"1195,00006-0059-68 ",.01)
 ;;00006-0059-68
 ;;9002226.02101,"1195,00006-0059-68 ",.02)
 ;;00006-0059-68
 ;;9002226.02101,"1195,00006-0067-68 ",.01)
 ;;00006-0067-68
 ;;9002226.02101,"1195,00006-0067-68 ",.02)
 ;;00006-0067-68
 ;;9002226.02101,"1195,00006-0136-68 ",.01)
 ;;00006-0136-68
 ;;9002226.02101,"1195,00006-0136-68 ",.02)
 ;;00006-0136-68
 ;;9002226.02101,"1195,00006-0437-68 ",.01)
 ;;00006-0437-68
 ;;9002226.02101,"1195,00006-0437-68 ",.02)
 ;;00006-0437-68
 ;;9002226.02101,"1195,00007-3370-13 ",.01)
 ;;00007-3370-13
 ;;9002226.02101,"1195,00007-3370-13 ",.02)
 ;;00007-3370-13
 ;;9002226.02101,"1195,00007-3370-59 ",.01)
 ;;00007-3370-59
 ;;9002226.02101,"1195,00007-3370-59 ",.02)
 ;;00007-3370-59
 ;;9002226.02101,"1195,00007-3371-13 ",.01)
 ;;00007-3371-13
 ;;9002226.02101,"1195,00007-3371-13 ",.02)
 ;;00007-3371-13
 ;;9002226.02101,"1195,00007-3371-59 ",.01)
 ;;00007-3371-59
 ;;9002226.02101,"1195,00007-3371-59 ",.02)
 ;;00007-3371-59
 ;;9002226.02101,"1195,00007-3372-13 ",.01)
 ;;00007-3372-13
 ;;9002226.02101,"1195,00007-3372-13 ",.02)
 ;;00007-3372-13
 ;;9002226.02101,"1195,00007-3372-59 ",.01)
 ;;00007-3372-59
 ;;9002226.02101,"1195,00007-3372-59 ",.02)
 ;;00007-3372-59
 ;;9002226.02101,"1195,00007-3373-13 ",.01)
 ;;00007-3373-13
 ;;9002226.02101,"1195,00007-3373-13 ",.02)
 ;;00007-3373-13
 ;;9002226.02101,"1195,00007-3373-59 ",.01)
 ;;00007-3373-59
 ;;9002226.02101,"1195,00007-3373-59 ",.02)
 ;;00007-3373-59
 ;;9002226.02101,"1195,00007-4139-20 ",.01)
 ;;00007-4139-20
 ;;9002226.02101,"1195,00007-4139-20 ",.02)
 ;;00007-4139-20
 ;;9002226.02101,"1195,00007-4139-55 ",.01)
 ;;00007-4139-55
 ;;9002226.02101,"1195,00007-4139-55 ",.02)
 ;;00007-4139-55
 ;;9002226.02101,"1195,00007-4140-20 ",.01)
 ;;00007-4140-20
 ;;9002226.02101,"1195,00007-4140-20 ",.02)
 ;;00007-4140-20
