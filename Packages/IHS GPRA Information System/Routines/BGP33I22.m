BGP33I22 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON JAN 23, 2013;
 ;;13.0;IHS CLINICAL REPORTING;**1**;NOV 20, 2012;Build 7
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"798,00591-5713-01 ",.02)
 ;;00591-5713-01
 ;;9002226.02101,"798,00591-5714-01 ",.01)
 ;;00591-5714-01
 ;;9002226.02101,"798,00591-5714-01 ",.02)
 ;;00591-5714-01
 ;;9002226.02101,"798,00591-5715-01 ",.01)
 ;;00591-5715-01
 ;;9002226.02101,"798,00591-5715-01 ",.02)
 ;;00591-5715-01
 ;;9002226.02101,"798,00591-5716-30 ",.01)
 ;;00591-5716-30
 ;;9002226.02101,"798,00591-5716-30 ",.02)
 ;;00591-5716-30
 ;;9002226.02101,"798,00591-5786-01 ",.01)
 ;;00591-5786-01
 ;;9002226.02101,"798,00591-5786-01 ",.02)
 ;;00591-5786-01
 ;;9002226.02101,"798,00591-5786-05 ",.01)
 ;;00591-5786-05
 ;;9002226.02101,"798,00591-5786-05 ",.02)
 ;;00591-5786-05
 ;;9002226.02101,"798,00591-5787-01 ",.01)
 ;;00591-5787-01
 ;;9002226.02101,"798,00591-5787-01 ",.02)
 ;;00591-5787-01
 ;;9002226.02101,"798,00591-5787-05 ",.01)
 ;;00591-5787-05
 ;;9002226.02101,"798,00591-5787-05 ",.02)
 ;;00591-5787-05
 ;;9002226.02101,"798,00591-5787-10 ",.01)
 ;;00591-5787-10
 ;;9002226.02101,"798,00591-5787-10 ",.02)
 ;;00591-5787-10
 ;;9002226.02101,"798,00591-5788-01 ",.01)
 ;;00591-5788-01
 ;;9002226.02101,"798,00591-5788-01 ",.02)
 ;;00591-5788-01
 ;;9002226.02101,"798,00591-5788-05 ",.01)
 ;;00591-5788-05
 ;;9002226.02101,"798,00591-5788-05 ",.02)
 ;;00591-5788-05
 ;;9002226.02101,"798,00591-5789-01 ",.01)
 ;;00591-5789-01
 ;;9002226.02101,"798,00591-5789-01 ",.02)
 ;;00591-5789-01
 ;;9002226.02101,"798,00603-2212-02 ",.01)
 ;;00603-2212-02
 ;;9002226.02101,"798,00603-2212-02 ",.02)
 ;;00603-2212-02
 ;;9002226.02101,"798,00603-2212-16 ",.01)
 ;;00603-2212-16
 ;;9002226.02101,"798,00603-2212-16 ",.02)
 ;;00603-2212-16
 ;;9002226.02101,"798,00603-2212-21 ",.01)
 ;;00603-2212-21
 ;;9002226.02101,"798,00603-2212-21 ",.02)
 ;;00603-2212-21
 ;;9002226.02101,"798,00603-2212-32 ",.01)
 ;;00603-2212-32
 ;;9002226.02101,"798,00603-2212-32 ",.02)
 ;;00603-2212-32
 ;;9002226.02101,"798,00603-2213-21 ",.01)
 ;;00603-2213-21
 ;;9002226.02101,"798,00603-2213-21 ",.02)
 ;;00603-2213-21
 ;;9002226.02101,"798,00603-2213-30 ",.01)
 ;;00603-2213-30
 ;;9002226.02101,"798,00603-2213-30 ",.02)
 ;;00603-2213-30
 ;;9002226.02101,"798,00603-2213-32 ",.01)
 ;;00603-2213-32
 ;;9002226.02101,"798,00603-2213-32 ",.02)
 ;;00603-2213-32
 ;;9002226.02101,"798,00603-2214-21 ",.01)
 ;;00603-2214-21
 ;;9002226.02101,"798,00603-2214-21 ",.02)
 ;;00603-2214-21
 ;;9002226.02101,"798,00603-2214-32 ",.01)
 ;;00603-2214-32
 ;;9002226.02101,"798,00603-2214-32 ",.02)
 ;;00603-2214-32
 ;;9002226.02101,"798,00603-2215-21 ",.01)
 ;;00603-2215-21
 ;;9002226.02101,"798,00603-2215-21 ",.02)
 ;;00603-2215-21
 ;;9002226.02101,"798,00603-2216-21 ",.01)
 ;;00603-2216-21
 ;;9002226.02101,"798,00603-2216-21 ",.02)
 ;;00603-2216-21
 ;;9002226.02101,"798,00603-2217-21 ",.01)
 ;;00603-2217-21
 ;;9002226.02101,"798,00603-2217-21 ",.02)
 ;;00603-2217-21
 ;;9002226.02101,"798,00603-6147-21 ",.01)
 ;;00603-6147-21
 ;;9002226.02101,"798,00603-6147-21 ",.02)
 ;;00603-6147-21
 ;;9002226.02101,"798,00603-6147-32 ",.01)
 ;;00603-6147-32
 ;;9002226.02101,"798,00603-6147-32 ",.02)
 ;;00603-6147-32
 ;;9002226.02101,"798,00603-6148-21 ",.01)
 ;;00603-6148-21
 ;;9002226.02101,"798,00603-6148-21 ",.02)
 ;;00603-6148-21
 ;;9002226.02101,"798,00603-6148-32 ",.01)
 ;;00603-6148-32
 ;;9002226.02101,"798,00603-6148-32 ",.02)
 ;;00603-6148-32
 ;;9002226.02101,"798,00603-6149-21 ",.01)
 ;;00603-6149-21
 ;;9002226.02101,"798,00603-6149-21 ",.02)
 ;;00603-6149-21
 ;;9002226.02101,"798,00603-6150-16 ",.01)
 ;;00603-6150-16
 ;;9002226.02101,"798,00603-6150-16 ",.02)
 ;;00603-6150-16
 ;;9002226.02101,"798,00603-6150-21 ",.01)
 ;;00603-6150-21
 ;;9002226.02101,"798,00603-6150-21 ",.02)
 ;;00603-6150-21
 ;;9002226.02101,"798,00603-6150-25 ",.01)
 ;;00603-6150-25
 ;;9002226.02101,"798,00603-6150-25 ",.02)
 ;;00603-6150-25
 ;;9002226.02101,"798,00603-6151-21 ",.01)
 ;;00603-6151-21
 ;;9002226.02101,"798,00603-6151-21 ",.02)
 ;;00603-6151-21
 ;;9002226.02101,"798,00603-6151-25 ",.01)
 ;;00603-6151-25
 ;;9002226.02101,"798,00603-6151-25 ",.02)
 ;;00603-6151-25
 ;;9002226.02101,"798,00603-6156-21 ",.01)
 ;;00603-6156-21
 ;;9002226.02101,"798,00603-6156-21 ",.02)
 ;;00603-6156-21
 ;;9002226.02101,"798,00603-6157-21 ",.01)
 ;;00603-6157-21
 ;;9002226.02101,"798,00603-6157-21 ",.02)
 ;;00603-6157-21
 ;;9002226.02101,"798,00603-6157-25 ",.01)
 ;;00603-6157-25
 ;;9002226.02101,"798,00603-6157-25 ",.02)
 ;;00603-6157-25
 ;;9002226.02101,"798,00603-6160-02 ",.01)
 ;;00603-6160-02
 ;;9002226.02101,"798,00603-6160-02 ",.02)
 ;;00603-6160-02
 ;;9002226.02101,"798,00603-6160-13 ",.01)
 ;;00603-6160-13
 ;;9002226.02101,"798,00603-6160-13 ",.02)
 ;;00603-6160-13
 ;;9002226.02101,"798,00603-6160-16 ",.01)
 ;;00603-6160-16
 ;;9002226.02101,"798,00603-6160-16 ",.02)
 ;;00603-6160-16
 ;;9002226.02101,"798,00603-6160-20 ",.01)
 ;;00603-6160-20
 ;;9002226.02101,"798,00603-6160-20 ",.02)
 ;;00603-6160-20
 ;;9002226.02101,"798,00603-6160-21 ",.01)
 ;;00603-6160-21
 ;;9002226.02101,"798,00603-6160-21 ",.02)
 ;;00603-6160-21
 ;;9002226.02101,"798,00603-6160-28 ",.01)
 ;;00603-6160-28
 ;;9002226.02101,"798,00603-6160-28 ",.02)
 ;;00603-6160-28
 ;;9002226.02101,"798,00603-6160-32 ",.01)
 ;;00603-6160-32
 ;;9002226.02101,"798,00603-6160-32 ",.02)
 ;;00603-6160-32
 ;;9002226.02101,"798,00603-6161-02 ",.01)
 ;;00603-6161-02
 ;;9002226.02101,"798,00603-6161-02 ",.02)
 ;;00603-6161-02
 ;;9002226.02101,"798,00603-6161-04 ",.01)
 ;;00603-6161-04
 ;;9002226.02101,"798,00603-6161-04 ",.02)
 ;;00603-6161-04
 ;;9002226.02101,"798,00603-6161-16 ",.01)
 ;;00603-6161-16
 ;;9002226.02101,"798,00603-6161-16 ",.02)
 ;;00603-6161-16
 ;;9002226.02101,"798,00603-6161-20 ",.01)
 ;;00603-6161-20
 ;;9002226.02101,"798,00603-6161-20 ",.02)
 ;;00603-6161-20
 ;;9002226.02101,"798,00603-6161-21 ",.01)
 ;;00603-6161-21
 ;;9002226.02101,"798,00603-6161-21 ",.02)
 ;;00603-6161-21
 ;;9002226.02101,"798,00603-6161-28 ",.01)
 ;;00603-6161-28
 ;;9002226.02101,"798,00603-6161-28 ",.02)
 ;;00603-6161-28
 ;;9002226.02101,"798,00603-6161-32 ",.01)
 ;;00603-6161-32
 ;;9002226.02101,"798,00603-6161-32 ",.02)
 ;;00603-6161-32
 ;;9002226.02101,"798,00777-3104-02 ",.01)
 ;;00777-3104-02
 ;;9002226.02101,"798,00777-3104-02 ",.02)
 ;;00777-3104-02
 ;;9002226.02101,"798,00777-3105-02 ",.01)
 ;;00777-3105-02
 ;;9002226.02101,"798,00777-3105-02 ",.02)
 ;;00777-3105-02
 ;;9002226.02101,"798,00777-3105-07 ",.01)
 ;;00777-3105-07
 ;;9002226.02101,"798,00777-3105-07 ",.02)
 ;;00777-3105-07
 ;;9002226.02101,"798,00777-3105-30 ",.01)
 ;;00777-3105-30
 ;;9002226.02101,"798,00777-3105-30 ",.02)
 ;;00777-3105-30
 ;;9002226.02101,"798,00777-3105-33 ",.01)
 ;;00777-3105-33
 ;;9002226.02101,"798,00777-3105-33 ",.02)
 ;;00777-3105-33
 ;;9002226.02101,"798,00777-3107-30 ",.01)
 ;;00777-3107-30
 ;;9002226.02101,"798,00777-3107-30 ",.02)
 ;;00777-3107-30
 ;;9002226.02101,"798,00777-5120-58 ",.01)
 ;;00777-5120-58
 ;;9002226.02101,"798,00777-5120-58 ",.02)
 ;;00777-5120-58
 ;;9002226.02101,"798,00781-1053-01 ",.01)
 ;;00781-1053-01
 ;;9002226.02101,"798,00781-1053-01 ",.02)
 ;;00781-1053-01
 ;;9002226.02101,"798,00781-1053-10 ",.01)
 ;;00781-1053-10
 ;;9002226.02101,"798,00781-1053-10 ",.02)
 ;;00781-1053-10
 ;;9002226.02101,"798,00781-1064-01 ",.01)
 ;;00781-1064-01
 ;;9002226.02101,"798,00781-1064-01 ",.02)
 ;;00781-1064-01
 ;;9002226.02101,"798,00781-1064-10 ",.01)
 ;;00781-1064-10
 ;;9002226.02101,"798,00781-1064-10 ",.02)
 ;;00781-1064-10
 ;;9002226.02101,"798,00781-1486-01 ",.01)
 ;;00781-1486-01
 ;;9002226.02101,"798,00781-1486-01 ",.02)
 ;;00781-1486-01
 ;;9002226.02101,"798,00781-1486-10 ",.01)
 ;;00781-1486-10
 ;;9002226.02101,"798,00781-1486-10 ",.02)
 ;;00781-1486-10
 ;;9002226.02101,"798,00781-1487-01 ",.01)
 ;;00781-1487-01
 ;;9002226.02101,"798,00781-1487-01 ",.02)
 ;;00781-1487-01
 ;;9002226.02101,"798,00781-1487-10 ",.01)
 ;;00781-1487-10
 ;;9002226.02101,"798,00781-1487-10 ",.02)
 ;;00781-1487-10
 ;;9002226.02101,"798,00781-1488-01 ",.01)
 ;;00781-1488-01
 ;;9002226.02101,"798,00781-1488-01 ",.02)
 ;;00781-1488-01
 ;;9002226.02101,"798,00781-1488-10 ",.01)
 ;;00781-1488-10
 ;;9002226.02101,"798,00781-1488-10 ",.02)
 ;;00781-1488-10
 ;;9002226.02101,"798,00781-1489-01 ",.01)
 ;;00781-1489-01
 ;;9002226.02101,"798,00781-1489-01 ",.02)
 ;;00781-1489-01
 ;;9002226.02101,"798,00781-1490-01 ",.01)
 ;;00781-1490-01
 ;;9002226.02101,"798,00781-1490-01 ",.02)
 ;;00781-1490-01
 ;;9002226.02101,"798,00781-1491-01 ",.01)
 ;;00781-1491-01
 ;;9002226.02101,"798,00781-1491-01 ",.02)
 ;;00781-1491-01
 ;;9002226.02101,"798,00781-1529-60 ",.01)
 ;;00781-1529-60
 ;;9002226.02101,"798,00781-1529-60 ",.02)
 ;;00781-1529-60
 ;;9002226.02101,"798,00781-1762-01 ",.01)
 ;;00781-1762-01
 ;;9002226.02101,"798,00781-1762-01 ",.02)
 ;;00781-1762-01
 ;;9002226.02101,"798,00781-1764-01 ",.01)
 ;;00781-1764-01
 ;;9002226.02101,"798,00781-1764-01 ",.02)
 ;;00781-1764-01
 ;;9002226.02101,"798,00781-1764-10 ",.01)
 ;;00781-1764-10
 ;;9002226.02101,"798,00781-1764-10 ",.02)
 ;;00781-1764-10
 ;;9002226.02101,"798,00781-1764-13 ",.01)
 ;;00781-1764-13
 ;;9002226.02101,"798,00781-1764-13 ",.02)
 ;;00781-1764-13
 ;;9002226.02101,"798,00781-1766-01 ",.01)
 ;;00781-1766-01
 ;;9002226.02101,"798,00781-1766-01 ",.02)
 ;;00781-1766-01
 ;;9002226.02101,"798,00781-1766-10 ",.01)
 ;;00781-1766-10
 ;;9002226.02101,"798,00781-1766-10 ",.02)
 ;;00781-1766-10
 ;;9002226.02101,"798,00781-1766-13 ",.01)
 ;;00781-1766-13
 ;;9002226.02101,"798,00781-1766-13 ",.02)
 ;;00781-1766-13
 ;;9002226.02101,"798,00781-1971-01 ",.01)
 ;;00781-1971-01
 ;;9002226.02101,"798,00781-1971-01 ",.02)
 ;;00781-1971-01
 ;;9002226.02101,"798,00781-1972-01 ",.01)
 ;;00781-1972-01
 ;;9002226.02101,"798,00781-1972-01 ",.02)
 ;;00781-1972-01
 ;;9002226.02101,"798,00781-1973-01 ",.01)
 ;;00781-1973-01
 ;;9002226.02101,"798,00781-1973-01 ",.02)
 ;;00781-1973-01
 ;;9002226.02101,"798,00781-1974-01 ",.01)
 ;;00781-1974-01
 ;;9002226.02101,"798,00781-1974-01 ",.02)
 ;;00781-1974-01
 ;;9002226.02101,"798,00781-1975-01 ",.01)
 ;;00781-1975-01
 ;;9002226.02101,"798,00781-1975-01 ",.02)
 ;;00781-1975-01
 ;;9002226.02101,"798,00781-1976-50 ",.01)
 ;;00781-1976-50
 ;;9002226.02101,"798,00781-1976-50 ",.02)
 ;;00781-1976-50
 ;;9002226.02101,"798,00781-2027-01 ",.01)
 ;;00781-2027-01
 ;;9002226.02101,"798,00781-2027-01 ",.02)
 ;;00781-2027-01
 ;;9002226.02101,"798,00781-2037-01 ",.01)
 ;;00781-2037-01
 ;;9002226.02101,"798,00781-2037-01 ",.02)
 ;;00781-2037-01
 ;;9002226.02101,"798,00781-2047-01 ",.01)
 ;;00781-2047-01
 ;;9002226.02101,"798,00781-2047-01 ",.02)
 ;;00781-2047-01
 ;;9002226.02101,"798,00781-2822-01 ",.01)
 ;;00781-2822-01
 ;;9002226.02101,"798,00781-2822-01 ",.02)
 ;;00781-2822-01
 ;;9002226.02101,"798,00781-2822-10 ",.01)
 ;;00781-2822-10
 ;;9002226.02101,"798,00781-2822-10 ",.02)
 ;;00781-2822-10
 ;;9002226.02101,"798,00781-2823-01 ",.01)
 ;;00781-2823-01
 ;;9002226.02101,"798,00781-2823-01 ",.02)
 ;;00781-2823-01
 ;;9002226.02101,"798,00781-2823-10 ",.01)
 ;;00781-2823-10
 ;;9002226.02101,"798,00781-2823-10 ",.02)
 ;;00781-2823-10
 ;;9002226.02101,"798,00781-2824-01 ",.01)
 ;;00781-2824-01
 ;;9002226.02101,"798,00781-2824-01 ",.02)
 ;;00781-2824-01
 ;;9002226.02101,"798,00781-2824-10 ",.01)
 ;;00781-2824-10
 ;;9002226.02101,"798,00781-2824-10 ",.02)
 ;;00781-2824-10
 ;;9002226.02101,"798,00781-2824-31 ",.01)
 ;;00781-2824-31
 ;;9002226.02101,"798,00781-2824-31 ",.02)
 ;;00781-2824-31
 ;;9002226.02101,"798,00781-2827-08 ",.01)
 ;;00781-2827-08
 ;;9002226.02101,"798,00781-2827-08 ",.02)
 ;;00781-2827-08
 ;;9002226.02101,"798,00781-2828-08 ",.01)
 ;;00781-2828-08
 ;;9002226.02101,"798,00781-2828-08 ",.02)
 ;;00781-2828-08
 ;;9002226.02101,"798,00781-5157-01 ",.01)
 ;;00781-5157-01
 ;;9002226.02101,"798,00781-5157-01 ",.02)
 ;;00781-5157-01
 ;;9002226.02101,"798,00904-0200-60 ",.01)
 ;;00904-0200-60
 ;;9002226.02101,"798,00904-0200-60 ",.02)
 ;;00904-0200-60
 ;;9002226.02101,"798,00904-0201-61 ",.01)
 ;;00904-0201-61
 ;;9002226.02101,"798,00904-0201-61 ",.02)
 ;;00904-0201-61
 ;;9002226.02101,"798,00904-0202-60 ",.01)
 ;;00904-0202-60
 ;;9002226.02101,"798,00904-0202-60 ",.02)
 ;;00904-0202-60
 ;;9002226.02101,"798,00904-0202-61 ",.01)
 ;;00904-0202-61
 ;;9002226.02101,"798,00904-0202-61 ",.02)
 ;;00904-0202-61
 ;;9002226.02101,"798,00904-0203-61 ",.01)
 ;;00904-0203-61
 ;;9002226.02101,"798,00904-0203-61 ",.02)
 ;;00904-0203-61
 ;;9002226.02101,"798,00904-1261-61 ",.01)
 ;;00904-1261-61
 ;;9002226.02101,"798,00904-1261-61 ",.02)
 ;;00904-1261-61
 ;;9002226.02101,"798,00904-1262-61 ",.01)
 ;;00904-1262-61
 ;;9002226.02101,"798,00904-1262-61 ",.02)
 ;;00904-1262-61
 ;;9002226.02101,"798,00904-3991-61 ",.01)
 ;;00904-3991-61
 ;;9002226.02101,"798,00904-3991-61 ",.02)
 ;;00904-3991-61
 ;;9002226.02101,"798,00904-5219-40 ",.01)
 ;;00904-5219-40
 ;;9002226.02101,"798,00904-5219-40 ",.02)
 ;;00904-5219-40
 ;;9002226.02101,"798,00904-5219-60 ",.01)
 ;;00904-5219-60
 ;;9002226.02101,"798,00904-5219-60 ",.02)
 ;;00904-5219-60
 ;;9002226.02101,"798,00904-5219-80 ",.01)
 ;;00904-5219-80
 ;;9002226.02101,"798,00904-5219-80 ",.02)
 ;;00904-5219-80
 ;;9002226.02101,"798,00904-5220-60 ",.01)
 ;;00904-5220-60
 ;;9002226.02101,"798,00904-5220-60 ",.02)
 ;;00904-5220-60
 ;;9002226.02101,"798,00904-5676-61 ",.01)
 ;;00904-5676-61
 ;;9002226.02101,"798,00904-5676-61 ",.02)
 ;;00904-5676-61
 ;;9002226.02101,"798,00904-5677-61 ",.01)
 ;;00904-5677-61