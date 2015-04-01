BGP47X12 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 17, 2014;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1195,00378-3632-01 ",.01)
 ;;00378-3632-01
 ;;9002226.02101,"1195,00378-3632-01 ",.02)
 ;;00378-3632-01
 ;;9002226.02101,"1195,00378-3632-02 ",.01)
 ;;00378-3632-02
 ;;9002226.02101,"1195,00378-3632-02 ",.02)
 ;;00378-3632-02
 ;;9002226.02101,"1195,00378-3632-05 ",.01)
 ;;00378-3632-05
 ;;9002226.02101,"1195,00378-3632-05 ",.02)
 ;;00378-3632-05
 ;;9002226.02101,"1195,00378-3632-07 ",.01)
 ;;00378-3632-07
 ;;9002226.02101,"1195,00378-3632-07 ",.02)
 ;;00378-3632-07
 ;;9002226.02101,"1195,00378-3633-01 ",.01)
 ;;00378-3633-01
 ;;9002226.02101,"1195,00378-3633-01 ",.02)
 ;;00378-3633-01
 ;;9002226.02101,"1195,00378-3633-02 ",.01)
 ;;00378-3633-02
 ;;9002226.02101,"1195,00378-3633-02 ",.02)
 ;;00378-3633-02
 ;;9002226.02101,"1195,00378-3633-05 ",.01)
 ;;00378-3633-05
 ;;9002226.02101,"1195,00378-3633-05 ",.02)
 ;;00378-3633-05
 ;;9002226.02101,"1195,00378-3633-07 ",.01)
 ;;00378-3633-07
 ;;9002226.02101,"1195,00378-3633-07 ",.02)
 ;;00378-3633-07
 ;;9002226.02101,"1195,00378-3634-01 ",.01)
 ;;00378-3634-01
 ;;9002226.02101,"1195,00378-3634-01 ",.02)
 ;;00378-3634-01
 ;;9002226.02101,"1195,00378-3634-02 ",.01)
 ;;00378-3634-02
 ;;9002226.02101,"1195,00378-3634-02 ",.02)
 ;;00378-3634-02
 ;;9002226.02101,"1195,00378-3634-05 ",.01)
 ;;00378-3634-05
 ;;9002226.02101,"1195,00378-3634-05 ",.02)
 ;;00378-3634-05
 ;;9002226.02101,"1195,00378-3634-07 ",.01)
 ;;00378-3634-07
 ;;9002226.02101,"1195,00378-3634-07 ",.02)
 ;;00378-3634-07
 ;;9002226.02101,"1195,00378-4595-10 ",.01)
 ;;00378-4595-10
 ;;9002226.02101,"1195,00378-4595-10 ",.02)
 ;;00378-4595-10
 ;;9002226.02101,"1195,00378-4595-77 ",.01)
 ;;00378-4595-77
 ;;9002226.02101,"1195,00378-4595-77 ",.02)
 ;;00378-4595-77
 ;;9002226.02101,"1195,00378-4596-10 ",.01)
 ;;00378-4596-10
 ;;9002226.02101,"1195,00378-4596-10 ",.02)
 ;;00378-4596-10
 ;;9002226.02101,"1195,00378-4596-77 ",.01)
 ;;00378-4596-77
 ;;9002226.02101,"1195,00378-4596-77 ",.02)
 ;;00378-4596-77
 ;;9002226.02101,"1195,00378-4597-10 ",.01)
 ;;00378-4597-10
 ;;9002226.02101,"1195,00378-4597-10 ",.02)
 ;;00378-4597-10
 ;;9002226.02101,"1195,00378-4597-77 ",.01)
 ;;00378-4597-77
 ;;9002226.02101,"1195,00378-4597-77 ",.02)
 ;;00378-4597-77
 ;;9002226.02101,"1195,00378-4598-05 ",.01)
 ;;00378-4598-05
 ;;9002226.02101,"1195,00378-4598-05 ",.02)
 ;;00378-4598-05
 ;;9002226.02101,"1195,00378-4598-77 ",.01)
 ;;00378-4598-77
 ;;9002226.02101,"1195,00378-4598-77 ",.02)
 ;;00378-4598-77
 ;;9002226.02101,"1195,00378-6160-01 ",.01)
 ;;00378-6160-01
 ;;9002226.02101,"1195,00378-6160-01 ",.02)
 ;;00378-6160-01
 ;;9002226.02101,"1195,00378-6160-05 ",.01)
 ;;00378-6160-05
 ;;9002226.02101,"1195,00378-6160-05 ",.02)
 ;;00378-6160-05
 ;;9002226.02101,"1195,00378-6180-01 ",.01)
 ;;00378-6180-01
 ;;9002226.02101,"1195,00378-6180-01 ",.02)
 ;;00378-6180-01
 ;;9002226.02101,"1195,00378-6180-05 ",.01)
 ;;00378-6180-05
 ;;9002226.02101,"1195,00378-6180-05 ",.02)
 ;;00378-6180-05
 ;;9002226.02101,"1195,00378-6220-01 ",.01)
 ;;00378-6220-01
 ;;9002226.02101,"1195,00378-6220-01 ",.02)
 ;;00378-6220-01
 ;;9002226.02101,"1195,00378-6220-05 ",.01)
 ;;00378-6220-05
 ;;9002226.02101,"1195,00378-6220-05 ",.02)
 ;;00378-6220-05
 ;;9002226.02101,"1195,00378-6260-01 ",.01)
 ;;00378-6260-01
 ;;9002226.02101,"1195,00378-6260-01 ",.02)
 ;;00378-6260-01
 ;;9002226.02101,"1195,00378-6260-05 ",.01)
 ;;00378-6260-05
 ;;9002226.02101,"1195,00378-6260-05 ",.02)
 ;;00378-6260-05
 ;;9002226.02101,"1195,00406-2022-01 ",.01)
 ;;00406-2022-01
 ;;9002226.02101,"1195,00406-2022-01 ",.02)
 ;;00406-2022-01
 ;;9002226.02101,"1195,00406-2022-10 ",.01)
 ;;00406-2022-10
 ;;9002226.02101,"1195,00406-2022-10 ",.02)
 ;;00406-2022-10
 ;;9002226.02101,"1195,00406-2023-01 ",.01)
 ;;00406-2023-01
 ;;9002226.02101,"1195,00406-2023-01 ",.02)
 ;;00406-2023-01
 ;;9002226.02101,"1195,00406-2023-10 ",.01)
 ;;00406-2023-10
 ;;9002226.02101,"1195,00406-2023-10 ",.02)
 ;;00406-2023-10
 ;;9002226.02101,"1195,00406-2024-01 ",.01)
 ;;00406-2024-01
 ;;9002226.02101,"1195,00406-2024-01 ",.02)
 ;;00406-2024-01
 ;;9002226.02101,"1195,00406-2024-10 ",.01)
 ;;00406-2024-10
 ;;9002226.02101,"1195,00406-2024-10 ",.02)
 ;;00406-2024-10
 ;;9002226.02101,"1195,00440-7170-30 ",.01)
 ;;00440-7170-30
 ;;9002226.02101,"1195,00440-7170-30 ",.02)
 ;;00440-7170-30
 ;;9002226.02101,"1195,00440-7170-45 ",.01)
 ;;00440-7170-45
 ;;9002226.02101,"1195,00440-7170-45 ",.02)
 ;;00440-7170-45
 ;;9002226.02101,"1195,00440-7170-90 ",.01)
 ;;00440-7170-90
 ;;9002226.02101,"1195,00440-7170-90 ",.02)
 ;;00440-7170-90
 ;;9002226.02101,"1195,00440-7171-06 ",.01)
 ;;00440-7171-06
 ;;9002226.02101,"1195,00440-7171-06 ",.02)
 ;;00440-7171-06
 ;;9002226.02101,"1195,00440-7171-10 ",.01)
 ;;00440-7171-10
 ;;9002226.02101,"1195,00440-7171-10 ",.02)
 ;;00440-7171-10
 ;;9002226.02101,"1195,00440-7171-30 ",.01)
 ;;00440-7171-30
 ;;9002226.02101,"1195,00440-7171-30 ",.02)
 ;;00440-7171-30
 ;;9002226.02101,"1195,00440-7171-45 ",.01)
 ;;00440-7171-45
 ;;9002226.02101,"1195,00440-7171-45 ",.02)
 ;;00440-7171-45
 ;;9002226.02101,"1195,00440-7171-60 ",.01)
 ;;00440-7171-60
 ;;9002226.02101,"1195,00440-7171-60 ",.02)
 ;;00440-7171-60
 ;;9002226.02101,"1195,00440-7171-90 ",.01)
 ;;00440-7171-90
 ;;9002226.02101,"1195,00440-7171-90 ",.02)
 ;;00440-7171-90
 ;;9002226.02101,"1195,00440-7171-92 ",.01)
 ;;00440-7171-92
 ;;9002226.02101,"1195,00440-7171-92 ",.02)
 ;;00440-7171-92
 ;;9002226.02101,"1195,00440-7172-30 ",.01)
 ;;00440-7172-30
 ;;9002226.02101,"1195,00440-7172-30 ",.02)
 ;;00440-7172-30
 ;;9002226.02101,"1195,00440-7172-90 ",.01)
 ;;00440-7172-90
 ;;9002226.02101,"1195,00440-7172-90 ",.02)
 ;;00440-7172-90
 ;;9002226.02101,"1195,00440-7678-60 ",.01)
 ;;00440-7678-60
 ;;9002226.02101,"1195,00440-7678-60 ",.02)
 ;;00440-7678-60
 ;;9002226.02101,"1195,00440-7679-60 ",.01)
 ;;00440-7679-60
 ;;9002226.02101,"1195,00440-7679-60 ",.02)
 ;;00440-7679-60
 ;;9002226.02101,"1195,00440-7680-60 ",.01)
 ;;00440-7680-60
 ;;9002226.02101,"1195,00440-7680-60 ",.02)
 ;;00440-7680-60
 ;;9002226.02101,"1195,00440-7681-60 ",.01)
 ;;00440-7681-60
 ;;9002226.02101,"1195,00440-7681-60 ",.02)
 ;;00440-7681-60
 ;;9002226.02101,"1195,00440-7784-45 ",.01)
 ;;00440-7784-45
 ;;9002226.02101,"1195,00440-7784-45 ",.02)
 ;;00440-7784-45
 ;;9002226.02101,"1195,00440-7784-90 ",.01)
 ;;00440-7784-90
 ;;9002226.02101,"1195,00440-7784-90 ",.02)
 ;;00440-7784-90
 ;;9002226.02101,"1195,00440-7785-06 ",.01)
 ;;00440-7785-06
 ;;9002226.02101,"1195,00440-7785-06 ",.02)
 ;;00440-7785-06
 ;;9002226.02101,"1195,00440-7785-20 ",.01)
 ;;00440-7785-20
 ;;9002226.02101,"1195,00440-7785-20 ",.02)
 ;;00440-7785-20
 ;;9002226.02101,"1195,00440-7785-28 ",.01)
 ;;00440-7785-28
 ;;9002226.02101,"1195,00440-7785-28 ",.02)
 ;;00440-7785-28
 ;;9002226.02101,"1195,00440-7785-30 ",.01)
 ;;00440-7785-30
 ;;9002226.02101,"1195,00440-7785-30 ",.02)
 ;;00440-7785-30
 ;;9002226.02101,"1195,00440-7785-45 ",.01)
 ;;00440-7785-45
 ;;9002226.02101,"1195,00440-7785-45 ",.02)
 ;;00440-7785-45
 ;;9002226.02101,"1195,00440-7785-60 ",.01)
 ;;00440-7785-60
 ;;9002226.02101,"1195,00440-7785-60 ",.02)
 ;;00440-7785-60
 ;;9002226.02101,"1195,00440-7785-90 ",.01)
 ;;00440-7785-90
 ;;9002226.02101,"1195,00440-7785-90 ",.02)
 ;;00440-7785-90
 ;;9002226.02101,"1195,00440-7785-92 ",.01)
 ;;00440-7785-92
 ;;9002226.02101,"1195,00440-7785-92 ",.02)
 ;;00440-7785-92
 ;;9002226.02101,"1195,00440-7785-94 ",.01)
 ;;00440-7785-94
 ;;9002226.02101,"1195,00440-7785-94 ",.02)
 ;;00440-7785-94
 ;;9002226.02101,"1195,00440-7786-06 ",.01)
 ;;00440-7786-06
 ;;9002226.02101,"1195,00440-7786-06 ",.02)
 ;;00440-7786-06
 ;;9002226.02101,"1195,00440-7786-30 ",.01)
 ;;00440-7786-30
 ;;9002226.02101,"1195,00440-7786-30 ",.02)
 ;;00440-7786-30
 ;;9002226.02101,"1195,00440-7786-60 ",.01)
 ;;00440-7786-60
 ;;9002226.02101,"1195,00440-7786-60 ",.02)
 ;;00440-7786-60
 ;;9002226.02101,"1195,00440-7786-92 ",.01)
 ;;00440-7786-92
 ;;9002226.02101,"1195,00440-7786-92 ",.02)
 ;;00440-7786-92
 ;;9002226.02101,"1195,00440-7786-94 ",.01)
 ;;00440-7786-94
 ;;9002226.02101,"1195,00440-7786-94 ",.02)
 ;;00440-7786-94
 ;;9002226.02101,"1195,00440-8230-60 ",.01)
 ;;00440-8230-60
 ;;9002226.02101,"1195,00440-8230-60 ",.02)
 ;;00440-8230-60
 ;;9002226.02101,"1195,00440-8230-90 ",.01)
 ;;00440-8230-90
 ;;9002226.02101,"1195,00440-8230-90 ",.02)
 ;;00440-8230-90
 ;;9002226.02101,"1195,00440-8230-91 ",.01)
 ;;00440-8230-91
 ;;9002226.02101,"1195,00440-8230-91 ",.02)
 ;;00440-8230-91
 ;;9002226.02101,"1195,00440-8230-92 ",.01)
 ;;00440-8230-92
 ;;9002226.02101,"1195,00440-8230-92 ",.02)
 ;;00440-8230-92
 ;;9002226.02101,"1195,00440-8230-94 ",.01)
 ;;00440-8230-94
 ;;9002226.02101,"1195,00440-8230-94 ",.02)
 ;;00440-8230-94
 ;;9002226.02101,"1195,00440-8230-99 ",.01)
 ;;00440-8230-99
 ;;9002226.02101,"1195,00440-8230-99 ",.02)
 ;;00440-8230-99
 ;;9002226.02101,"1195,00440-8231-60 ",.01)
 ;;00440-8231-60
 ;;9002226.02101,"1195,00440-8231-60 ",.02)
 ;;00440-8231-60
 ;;9002226.02101,"1195,00440-8231-90 ",.01)
 ;;00440-8231-90
 ;;9002226.02101,"1195,00440-8231-90 ",.02)
 ;;00440-8231-90
 ;;9002226.02101,"1195,00440-8231-92 ",.01)
 ;;00440-8231-92
 ;;9002226.02101,"1195,00440-8231-92 ",.02)
 ;;00440-8231-92
 ;;9002226.02101,"1195,00440-8231-94 ",.01)
 ;;00440-8231-94
 ;;9002226.02101,"1195,00440-8231-94 ",.02)
 ;;00440-8231-94
 ;;9002226.02101,"1195,00440-8232-30 ",.01)
 ;;00440-8232-30
 ;;9002226.02101,"1195,00440-8232-30 ",.02)
 ;;00440-8232-30
 ;;9002226.02101,"1195,00440-8232-90 ",.01)
 ;;00440-8232-90
 ;;9002226.02101,"1195,00440-8232-90 ",.02)
 ;;00440-8232-90
 ;;9002226.02101,"1195,00440-8232-94 ",.01)
 ;;00440-8232-94
 ;;9002226.02101,"1195,00440-8232-94 ",.02)
 ;;00440-8232-94
 ;;9002226.02101,"1195,00440-8233-90 ",.01)
 ;;00440-8233-90
 ;;9002226.02101,"1195,00440-8233-90 ",.02)
 ;;00440-8233-90
 ;;9002226.02101,"1195,00440-8233-94 ",.01)
 ;;00440-8233-94
 ;;9002226.02101,"1195,00440-8233-94 ",.02)
 ;;00440-8233-94
 ;;9002226.02101,"1195,00440-8234-90 ",.01)
 ;;00440-8234-90
 ;;9002226.02101,"1195,00440-8234-90 ",.02)
 ;;00440-8234-90
 ;;9002226.02101,"1195,00440-8234-94 ",.01)
 ;;00440-8234-94
 ;;9002226.02101,"1195,00440-8234-94 ",.02)
 ;;00440-8234-94
 ;;9002226.02101,"1195,00456-1402-01 ",.01)
 ;;00456-1402-01
 ;;9002226.02101,"1195,00456-1402-01 ",.02)
 ;;00456-1402-01
 ;;9002226.02101,"1195,00456-1402-11 ",.01)
 ;;00456-1402-11
 ;;9002226.02101,"1195,00456-1402-11 ",.02)
 ;;00456-1402-11
 ;;9002226.02101,"1195,00456-1402-30 ",.01)
 ;;00456-1402-30
 ;;9002226.02101,"1195,00456-1402-30 ",.02)
 ;;00456-1402-30
 ;;9002226.02101,"1195,00456-1402-63 ",.01)
 ;;00456-1402-63
 ;;9002226.02101,"1195,00456-1402-63 ",.02)
 ;;00456-1402-63
 ;;9002226.02101,"1195,00456-1405-01 ",.01)
 ;;00456-1405-01
 ;;9002226.02101,"1195,00456-1405-01 ",.02)
 ;;00456-1405-01
 ;;9002226.02101,"1195,00456-1405-11 ",.01)
 ;;00456-1405-11
 ;;9002226.02101,"1195,00456-1405-11 ",.02)
 ;;00456-1405-11
 ;;9002226.02101,"1195,00456-1405-30 ",.01)
 ;;00456-1405-30
 ;;9002226.02101,"1195,00456-1405-30 ",.02)
 ;;00456-1405-30
 ;;9002226.02101,"1195,00456-1405-63 ",.01)
 ;;00456-1405-63
 ;;9002226.02101,"1195,00456-1405-63 ",.02)
 ;;00456-1405-63
 ;;9002226.02101,"1195,00456-1410-01 ",.01)
 ;;00456-1410-01
 ;;9002226.02101,"1195,00456-1410-01 ",.02)
 ;;00456-1410-01
 ;;9002226.02101,"1195,00456-1410-11 ",.01)
 ;;00456-1410-11
 ;;9002226.02101,"1195,00456-1410-11 ",.02)
 ;;00456-1410-11
 ;;9002226.02101,"1195,00456-1410-30 ",.01)
 ;;00456-1410-30
 ;;9002226.02101,"1195,00456-1410-30 ",.02)
 ;;00456-1410-30
 ;;9002226.02101,"1195,00456-1410-63 ",.01)
 ;;00456-1410-63
 ;;9002226.02101,"1195,00456-1410-63 ",.02)
 ;;00456-1410-63
 ;;9002226.02101,"1195,00456-1420-01 ",.01)
 ;;00456-1420-01
 ;;9002226.02101,"1195,00456-1420-01 ",.02)
 ;;00456-1420-01
 ;;9002226.02101,"1195,00456-1420-30 ",.01)
 ;;00456-1420-30
 ;;9002226.02101,"1195,00456-1420-30 ",.02)
 ;;00456-1420-30
 ;;9002226.02101,"1195,00490-0053-00 ",.01)
 ;;00490-0053-00
 ;;9002226.02101,"1195,00490-0053-00 ",.02)
 ;;00490-0053-00
 ;;9002226.02101,"1195,00490-0053-30 ",.01)
 ;;00490-0053-30
 ;;9002226.02101,"1195,00490-0053-30 ",.02)
 ;;00490-0053-30
 ;;9002226.02101,"1195,00490-0053-60 ",.01)
 ;;00490-0053-60
 ;;9002226.02101,"1195,00490-0053-60 ",.02)
 ;;00490-0053-60
 ;;9002226.02101,"1195,00490-0053-90 ",.01)
 ;;00490-0053-90
 ;;9002226.02101,"1195,00490-0053-90 ",.02)
 ;;00490-0053-90
 ;;9002226.02101,"1195,00591-0437-01 ",.01)
 ;;00591-0437-01
 ;;9002226.02101,"1195,00591-0437-01 ",.02)
 ;;00591-0437-01
 ;;9002226.02101,"1195,00591-0438-01 ",.01)
 ;;00591-0438-01
 ;;9002226.02101,"1195,00591-0438-01 ",.02)
 ;;00591-0438-01
 ;;9002226.02101,"1195,00591-0462-01 ",.01)
 ;;00591-0462-01
 ;;9002226.02101,"1195,00591-0462-01 ",.02)
 ;;00591-0462-01
 ;;9002226.02101,"1195,00591-0462-10 ",.01)
 ;;00591-0462-10
 ;;9002226.02101,"1195,00591-0462-10 ",.02)
 ;;00591-0462-10
 ;;9002226.02101,"1195,00591-0463-01 ",.01)
 ;;00591-0463-01
 ;;9002226.02101,"1195,00591-0463-01 ",.02)
 ;;00591-0463-01
 ;;9002226.02101,"1195,00591-0463-10 ",.01)
 ;;00591-0463-10
 ;;9002226.02101,"1195,00591-0463-10 ",.02)
 ;;00591-0463-10
 ;;9002226.02101,"1195,00591-0605-01 ",.01)
 ;;00591-0605-01
 ;;9002226.02101,"1195,00591-0605-01 ",.02)
 ;;00591-0605-01
 ;;9002226.02101,"1195,00591-0605-05 ",.01)
 ;;00591-0605-05
 ;;9002226.02101,"1195,00591-0605-05 ",.02)
 ;;00591-0605-05
 ;;9002226.02101,"1195,00591-0606-01 ",.01)
 ;;00591-0606-01