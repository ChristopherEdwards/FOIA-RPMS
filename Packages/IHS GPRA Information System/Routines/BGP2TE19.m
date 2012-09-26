BGP2TE19 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1197,54868-1008-00 ",.02)
 ;;54868-1008-00
 ;;9002226.02101,"1197,54868-1008-01 ",.01)
 ;;54868-1008-01
 ;;9002226.02101,"1197,54868-1008-01 ",.02)
 ;;54868-1008-01
 ;;9002226.02101,"1197,54868-1008-02 ",.01)
 ;;54868-1008-02
 ;;9002226.02101,"1197,54868-1008-02 ",.02)
 ;;54868-1008-02
 ;;9002226.02101,"1197,54868-1207-00 ",.01)
 ;;54868-1207-00
 ;;9002226.02101,"1197,54868-1207-00 ",.02)
 ;;54868-1207-00
 ;;9002226.02101,"1197,54868-1207-01 ",.01)
 ;;54868-1207-01
 ;;9002226.02101,"1197,54868-1207-01 ",.02)
 ;;54868-1207-01
 ;;9002226.02101,"1197,54868-1283-00 ",.01)
 ;;54868-1283-00
 ;;9002226.02101,"1197,54868-1283-00 ",.02)
 ;;54868-1283-00
 ;;9002226.02101,"1197,54868-1283-01 ",.01)
 ;;54868-1283-01
 ;;9002226.02101,"1197,54868-1283-01 ",.02)
 ;;54868-1283-01
 ;;9002226.02101,"1197,54868-1443-03 ",.01)
 ;;54868-1443-03
 ;;9002226.02101,"1197,54868-1443-03 ",.02)
 ;;54868-1443-03
 ;;9002226.02101,"1197,54868-1550-03 ",.01)
 ;;54868-1550-03
 ;;9002226.02101,"1197,54868-1550-03 ",.02)
 ;;54868-1550-03
 ;;9002226.02101,"1197,54868-2147-02 ",.01)
 ;;54868-2147-02
 ;;9002226.02101,"1197,54868-2147-02 ",.02)
 ;;54868-2147-02
 ;;9002226.02101,"1197,54868-2148-03 ",.01)
 ;;54868-2148-03
 ;;9002226.02101,"1197,54868-2148-03 ",.02)
 ;;54868-2148-03
 ;;9002226.02101,"1197,54868-2149-00 ",.01)
 ;;54868-2149-00
 ;;9002226.02101,"1197,54868-2149-00 ",.02)
 ;;54868-2149-00
 ;;9002226.02101,"1197,54868-2149-02 ",.01)
 ;;54868-2149-02
 ;;9002226.02101,"1197,54868-2149-02 ",.02)
 ;;54868-2149-02
 ;;9002226.02101,"1197,54868-2150-01 ",.01)
 ;;54868-2150-01
 ;;9002226.02101,"1197,54868-2150-01 ",.02)
 ;;54868-2150-01
 ;;9002226.02101,"1197,54868-2167-00 ",.01)
 ;;54868-2167-00
 ;;9002226.02101,"1197,54868-2167-00 ",.02)
 ;;54868-2167-00
 ;;9002226.02101,"1197,54868-2167-02 ",.01)
 ;;54868-2167-02
 ;;9002226.02101,"1197,54868-2167-02 ",.02)
 ;;54868-2167-02
 ;;9002226.02101,"1197,54868-2168-02 ",.01)
 ;;54868-2168-02
 ;;9002226.02101,"1197,54868-2168-02 ",.02)
 ;;54868-2168-02
 ;;9002226.02101,"1197,54868-2168-03 ",.01)
 ;;54868-2168-03
 ;;9002226.02101,"1197,54868-2168-03 ",.02)
 ;;54868-2168-03
 ;;9002226.02101,"1197,54868-2200-00 ",.01)
 ;;54868-2200-00
 ;;9002226.02101,"1197,54868-2200-00 ",.02)
 ;;54868-2200-00
 ;;9002226.02101,"1197,54868-2200-02 ",.01)
 ;;54868-2200-02
 ;;9002226.02101,"1197,54868-2200-02 ",.02)
 ;;54868-2200-02
 ;;9002226.02101,"1197,54868-2207-00 ",.01)
 ;;54868-2207-00
 ;;9002226.02101,"1197,54868-2207-00 ",.02)
 ;;54868-2207-00
 ;;9002226.02101,"1197,54868-2207-01 ",.01)
 ;;54868-2207-01
 ;;9002226.02101,"1197,54868-2207-01 ",.02)
 ;;54868-2207-01
 ;;9002226.02101,"1197,54868-2207-02 ",.01)
 ;;54868-2207-02
 ;;9002226.02101,"1197,54868-2207-02 ",.02)
 ;;54868-2207-02
 ;;9002226.02101,"1197,54868-2207-03 ",.01)
 ;;54868-2207-03
 ;;9002226.02101,"1197,54868-2207-03 ",.02)
 ;;54868-2207-03
 ;;9002226.02101,"1197,54868-2207-04 ",.01)
 ;;54868-2207-04
 ;;9002226.02101,"1197,54868-2207-04 ",.02)
 ;;54868-2207-04
 ;;9002226.02101,"1197,54868-2207-05 ",.01)
 ;;54868-2207-05
 ;;9002226.02101,"1197,54868-2207-05 ",.02)
 ;;54868-2207-05
 ;;9002226.02101,"1197,54868-2207-06 ",.01)
 ;;54868-2207-06
 ;;9002226.02101,"1197,54868-2207-06 ",.02)
 ;;54868-2207-06
 ;;9002226.02101,"1197,54868-2207-07 ",.01)
 ;;54868-2207-07
 ;;9002226.02101,"1197,54868-2207-07 ",.02)
 ;;54868-2207-07
 ;;9002226.02101,"1197,54868-2211-00 ",.01)
 ;;54868-2211-00
 ;;9002226.02101,"1197,54868-2211-00 ",.02)
 ;;54868-2211-00
 ;;9002226.02101,"1197,54868-2276-01 ",.01)
 ;;54868-2276-01
 ;;9002226.02101,"1197,54868-2276-01 ",.02)
 ;;54868-2276-01
 ;;9002226.02101,"1197,54868-2276-02 ",.01)
 ;;54868-2276-02
 ;;9002226.02101,"1197,54868-2276-02 ",.02)
 ;;54868-2276-02
 ;;9002226.02101,"1197,54868-2277-00 ",.01)
 ;;54868-2277-00
 ;;9002226.02101,"1197,54868-2277-00 ",.02)
 ;;54868-2277-00
 ;;9002226.02101,"1197,54868-2290-00 ",.01)
 ;;54868-2290-00
 ;;9002226.02101,"1197,54868-2290-00 ",.02)
 ;;54868-2290-00
 ;;9002226.02101,"1197,54868-2290-01 ",.01)
 ;;54868-2290-01
 ;;9002226.02101,"1197,54868-2290-01 ",.02)
 ;;54868-2290-01
 ;;9002226.02101,"1197,54868-2290-02 ",.01)
 ;;54868-2290-02
 ;;9002226.02101,"1197,54868-2290-02 ",.02)
 ;;54868-2290-02
 ;;9002226.02101,"1197,54868-2290-03 ",.01)
 ;;54868-2290-03
 ;;9002226.02101,"1197,54868-2290-03 ",.02)
 ;;54868-2290-03
 ;;9002226.02101,"1197,54868-2290-04 ",.01)
 ;;54868-2290-04
 ;;9002226.02101,"1197,54868-2290-04 ",.02)
 ;;54868-2290-04
 ;;9002226.02101,"1197,54868-2322-01 ",.01)
 ;;54868-2322-01
 ;;9002226.02101,"1197,54868-2322-01 ",.02)
 ;;54868-2322-01
 ;;9002226.02101,"1197,54868-2322-02 ",.01)
 ;;54868-2322-02
 ;;9002226.02101,"1197,54868-2322-02 ",.02)
 ;;54868-2322-02
 ;;9002226.02101,"1197,54868-2322-03 ",.01)
 ;;54868-2322-03
 ;;9002226.02101,"1197,54868-2322-03 ",.02)
 ;;54868-2322-03
 ;;9002226.02101,"1197,54868-2469-00 ",.01)
 ;;54868-2469-00
 ;;9002226.02101,"1197,54868-2469-00 ",.02)
 ;;54868-2469-00
 ;;9002226.02101,"1197,54868-2469-01 ",.01)
 ;;54868-2469-01
 ;;9002226.02101,"1197,54868-2469-01 ",.02)
 ;;54868-2469-01
 ;;9002226.02101,"1197,54868-2868-00 ",.01)
 ;;54868-2868-00
 ;;9002226.02101,"1197,54868-2868-00 ",.02)
 ;;54868-2868-00
 ;;9002226.02101,"1197,54868-2868-01 ",.01)
 ;;54868-2868-01
 ;;9002226.02101,"1197,54868-2868-01 ",.02)
 ;;54868-2868-01
 ;;9002226.02101,"1197,54868-2868-02 ",.01)
 ;;54868-2868-02
 ;;9002226.02101,"1197,54868-2868-02 ",.02)
 ;;54868-2868-02
 ;;9002226.02101,"1197,54868-2868-05 ",.01)
 ;;54868-2868-05
 ;;9002226.02101,"1197,54868-2868-05 ",.02)
 ;;54868-2868-05
 ;;9002226.02101,"1197,54868-2869-00 ",.01)
 ;;54868-2869-00
 ;;9002226.02101,"1197,54868-2869-00 ",.02)
 ;;54868-2869-00
 ;;9002226.02101,"1197,54868-2869-01 ",.01)
 ;;54868-2869-01
 ;;9002226.02101,"1197,54868-2869-01 ",.02)
 ;;54868-2869-01
 ;;9002226.02101,"1197,54868-2869-03 ",.01)
 ;;54868-2869-03
 ;;9002226.02101,"1197,54868-2869-03 ",.02)
 ;;54868-2869-03
 ;;9002226.02101,"1197,54868-2870-00 ",.01)
 ;;54868-2870-00
 ;;9002226.02101,"1197,54868-2870-00 ",.02)
 ;;54868-2870-00
 ;;9002226.02101,"1197,54868-2873-00 ",.01)
 ;;54868-2873-00
 ;;9002226.02101,"1197,54868-2873-00 ",.02)
 ;;54868-2873-00
 ;;9002226.02101,"1197,54868-2873-01 ",.01)
 ;;54868-2873-01
 ;;9002226.02101,"1197,54868-2873-01 ",.02)
 ;;54868-2873-01
 ;;9002226.02101,"1197,54868-2873-03 ",.01)
 ;;54868-2873-03
 ;;9002226.02101,"1197,54868-2873-03 ",.02)
 ;;54868-2873-03
 ;;9002226.02101,"1197,54868-2873-04 ",.01)
 ;;54868-2873-04
 ;;9002226.02101,"1197,54868-2873-04 ",.02)
 ;;54868-2873-04
 ;;9002226.02101,"1197,54868-2873-05 ",.01)
 ;;54868-2873-05
 ;;9002226.02101,"1197,54868-2873-05 ",.02)
 ;;54868-2873-05
 ;;9002226.02101,"1197,54868-2885-00 ",.01)
 ;;54868-2885-00
 ;;9002226.02101,"1197,54868-2885-00 ",.02)
 ;;54868-2885-00
 ;;9002226.02101,"1197,54868-2975-02 ",.01)
 ;;54868-2975-02
 ;;9002226.02101,"1197,54868-2975-02 ",.02)
 ;;54868-2975-02
 ;;9002226.02101,"1197,54868-2975-03 ",.01)
 ;;54868-2975-03
 ;;9002226.02101,"1197,54868-2975-03 ",.02)
 ;;54868-2975-03
 ;;9002226.02101,"1197,54868-3102-00 ",.01)
 ;;54868-3102-00
 ;;9002226.02101,"1197,54868-3102-00 ",.02)
 ;;54868-3102-00
 ;;9002226.02101,"1197,54868-3102-03 ",.01)
 ;;54868-3102-03
 ;;9002226.02101,"1197,54868-3102-03 ",.02)
 ;;54868-3102-03
 ;;9002226.02101,"1197,54868-3103-00 ",.01)
 ;;54868-3103-00
 ;;9002226.02101,"1197,54868-3103-00 ",.02)
 ;;54868-3103-00
 ;;9002226.02101,"1197,54868-3103-02 ",.01)
 ;;54868-3103-02
 ;;9002226.02101,"1197,54868-3103-02 ",.02)
 ;;54868-3103-02
 ;;9002226.02101,"1197,54868-3103-03 ",.01)
 ;;54868-3103-03
 ;;9002226.02101,"1197,54868-3103-03 ",.02)
 ;;54868-3103-03
 ;;9002226.02101,"1197,54868-3103-04 ",.01)
 ;;54868-3103-04
 ;;9002226.02101,"1197,54868-3103-04 ",.02)
 ;;54868-3103-04
 ;;9002226.02101,"1197,54868-3103-05 ",.01)
 ;;54868-3103-05
 ;;9002226.02101,"1197,54868-3103-05 ",.02)
 ;;54868-3103-05
 ;;9002226.02101,"1197,54868-3214-00 ",.01)
 ;;54868-3214-00
 ;;9002226.02101,"1197,54868-3214-00 ",.02)
 ;;54868-3214-00
 ;;9002226.02101,"1197,54868-3214-01 ",.01)
 ;;54868-3214-01
 ;;9002226.02101,"1197,54868-3214-01 ",.02)
 ;;54868-3214-01
 ;;9002226.02101,"1197,54868-3287-00 ",.01)
 ;;54868-3287-00
 ;;9002226.02101,"1197,54868-3287-00 ",.02)
 ;;54868-3287-00
 ;;9002226.02101,"1197,54868-3287-01 ",.01)
 ;;54868-3287-01
 ;;9002226.02101,"1197,54868-3287-01 ",.02)
 ;;54868-3287-01
 ;;9002226.02101,"1197,54868-3300-00 ",.01)
 ;;54868-3300-00
 ;;9002226.02101,"1197,54868-3300-00 ",.02)
 ;;54868-3300-00
 ;;9002226.02101,"1197,54868-3300-01 ",.01)
 ;;54868-3300-01
 ;;9002226.02101,"1197,54868-3300-01 ",.02)
 ;;54868-3300-01
 ;;9002226.02101,"1197,54868-3300-02 ",.01)
 ;;54868-3300-02
 ;;9002226.02101,"1197,54868-3300-02 ",.02)
 ;;54868-3300-02
 ;;9002226.02101,"1197,54868-3300-03 ",.01)
 ;;54868-3300-03
 ;;9002226.02101,"1197,54868-3300-03 ",.02)
 ;;54868-3300-03
 ;;9002226.02101,"1197,54868-3300-04 ",.01)
 ;;54868-3300-04
 ;;9002226.02101,"1197,54868-3300-04 ",.02)
 ;;54868-3300-04
 ;;9002226.02101,"1197,54868-3464-01 ",.01)
 ;;54868-3464-01
 ;;9002226.02101,"1197,54868-3464-01 ",.02)
 ;;54868-3464-01
 ;;9002226.02101,"1197,54868-3464-02 ",.01)
 ;;54868-3464-02
 ;;9002226.02101,"1197,54868-3464-02 ",.02)
 ;;54868-3464-02
 ;;9002226.02101,"1197,54868-3774-00 ",.01)
 ;;54868-3774-00
 ;;9002226.02101,"1197,54868-3774-00 ",.02)
 ;;54868-3774-00
 ;;9002226.02101,"1197,54868-3817-00 ",.01)
 ;;54868-3817-00
 ;;9002226.02101,"1197,54868-3817-00 ",.02)
 ;;54868-3817-00
 ;;9002226.02101,"1197,54868-3853-01 ",.01)
 ;;54868-3853-01
 ;;9002226.02101,"1197,54868-3853-01 ",.02)
 ;;54868-3853-01
 ;;9002226.02101,"1197,54868-3853-02 ",.01)
 ;;54868-3853-02
 ;;9002226.02101,"1197,54868-3853-02 ",.02)
 ;;54868-3853-02
 ;;9002226.02101,"1197,54868-3853-03 ",.01)
 ;;54868-3853-03
 ;;9002226.02101,"1197,54868-3853-03 ",.02)
 ;;54868-3853-03
 ;;9002226.02101,"1197,54868-3956-00 ",.01)
 ;;54868-3956-00
 ;;9002226.02101,"1197,54868-3956-00 ",.02)
 ;;54868-3956-00
 ;;9002226.02101,"1197,54868-3956-01 ",.01)
 ;;54868-3956-01
 ;;9002226.02101,"1197,54868-3956-01 ",.02)
 ;;54868-3956-01
 ;;9002226.02101,"1197,54868-3956-02 ",.01)
 ;;54868-3956-02
 ;;9002226.02101,"1197,54868-3956-02 ",.02)
 ;;54868-3956-02
 ;;9002226.02101,"1197,54868-3958-00 ",.01)
 ;;54868-3958-00
 ;;9002226.02101,"1197,54868-3958-00 ",.02)
 ;;54868-3958-00
 ;;9002226.02101,"1197,54868-4011-00 ",.01)
 ;;54868-4011-00
 ;;9002226.02101,"1197,54868-4011-00 ",.02)
 ;;54868-4011-00
 ;;9002226.02101,"1197,54868-4011-01 ",.01)
 ;;54868-4011-01
 ;;9002226.02101,"1197,54868-4011-01 ",.02)
 ;;54868-4011-01
 ;;9002226.02101,"1197,54868-4011-02 ",.01)
 ;;54868-4011-02
 ;;9002226.02101,"1197,54868-4011-02 ",.02)
 ;;54868-4011-02
 ;;9002226.02101,"1197,54868-4011-03 ",.01)
 ;;54868-4011-03
 ;;9002226.02101,"1197,54868-4011-03 ",.02)
 ;;54868-4011-03
 ;;9002226.02101,"1197,54868-4064-00 ",.01)
 ;;54868-4064-00
 ;;9002226.02101,"1197,54868-4064-00 ",.02)
 ;;54868-4064-00
 ;;9002226.02101,"1197,54868-4064-01 ",.01)
 ;;54868-4064-01
 ;;9002226.02101,"1197,54868-4064-01 ",.02)
 ;;54868-4064-01
 ;;9002226.02101,"1197,54868-4066-00 ",.01)
 ;;54868-4066-00
 ;;9002226.02101,"1197,54868-4066-00 ",.02)
 ;;54868-4066-00
 ;;9002226.02101,"1197,54868-4066-01 ",.01)
 ;;54868-4066-01
 ;;9002226.02101,"1197,54868-4066-01 ",.02)
 ;;54868-4066-01
 ;;9002226.02101,"1197,54868-4068-00 ",.01)
 ;;54868-4068-00
 ;;9002226.02101,"1197,54868-4068-00 ",.02)
 ;;54868-4068-00
 ;;9002226.02101,"1197,54868-4073-00 ",.01)
 ;;54868-4073-00
 ;;9002226.02101,"1197,54868-4073-00 ",.02)
 ;;54868-4073-00
 ;;9002226.02101,"1197,54868-4073-01 ",.01)
 ;;54868-4073-01
 ;;9002226.02101,"1197,54868-4073-01 ",.02)
 ;;54868-4073-01
 ;;9002226.02101,"1197,54868-4073-02 ",.01)
 ;;54868-4073-02
 ;;9002226.02101,"1197,54868-4073-02 ",.02)
 ;;54868-4073-02
 ;;9002226.02101,"1197,54868-4073-03 ",.01)
 ;;54868-4073-03
 ;;9002226.02101,"1197,54868-4073-03 ",.02)
 ;;54868-4073-03
 ;;9002226.02101,"1197,54868-4074-00 ",.01)
 ;;54868-4074-00
 ;;9002226.02101,"1197,54868-4074-00 ",.02)
 ;;54868-4074-00
 ;;9002226.02101,"1197,54868-4074-01 ",.01)
 ;;54868-4074-01
 ;;9002226.02101,"1197,54868-4074-01 ",.02)
 ;;54868-4074-01
 ;;9002226.02101,"1197,54868-4074-02 ",.01)
 ;;54868-4074-02
 ;;9002226.02101,"1197,54868-4074-02 ",.02)
 ;;54868-4074-02
 ;;9002226.02101,"1197,54868-4074-03 ",.01)
 ;;54868-4074-03
 ;;9002226.02101,"1197,54868-4074-03 ",.02)
 ;;54868-4074-03
 ;;9002226.02101,"1197,54868-4074-04 ",.01)
 ;;54868-4074-04
 ;;9002226.02101,"1197,54868-4074-04 ",.02)
 ;;54868-4074-04
 ;;9002226.02101,"1197,54868-4184-00 ",.01)
 ;;54868-4184-00
 ;;9002226.02101,"1197,54868-4184-00 ",.02)
 ;;54868-4184-00
 ;;9002226.02101,"1197,54868-4184-01 ",.01)
 ;;54868-4184-01
 ;;9002226.02101,"1197,54868-4184-01 ",.02)
 ;;54868-4184-01
 ;;9002226.02101,"1197,54868-4184-02 ",.01)
 ;;54868-4184-02
 ;;9002226.02101,"1197,54868-4184-02 ",.02)
 ;;54868-4184-02
 ;;9002226.02101,"1197,54868-4186-00 ",.01)
 ;;54868-4186-00
 ;;9002226.02101,"1197,54868-4186-00 ",.02)
 ;;54868-4186-00
 ;;9002226.02101,"1197,54868-4186-01 ",.01)
 ;;54868-4186-01
 ;;9002226.02101,"1197,54868-4186-01 ",.02)
 ;;54868-4186-01
 ;;9002226.02101,"1197,54868-4186-02 ",.01)
 ;;54868-4186-02
 ;;9002226.02101,"1197,54868-4186-02 ",.02)
 ;;54868-4186-02
 ;;9002226.02101,"1197,54868-4186-03 ",.01)
 ;;54868-4186-03
 ;;9002226.02101,"1197,54868-4186-03 ",.02)
 ;;54868-4186-03
