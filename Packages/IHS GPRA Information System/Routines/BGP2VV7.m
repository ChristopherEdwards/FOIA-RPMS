BGP2VV7 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"736,55045-1599-09 ",.02)
 ;;55045-1599-09
 ;;9002226.02101,"736,55045-2038-03 ",.01)
 ;;55045-2038-03
 ;;9002226.02101,"736,55045-2038-03 ",.02)
 ;;55045-2038-03
 ;;9002226.02101,"736,55045-2999-00 ",.01)
 ;;55045-2999-00
 ;;9002226.02101,"736,55045-2999-00 ",.02)
 ;;55045-2999-00
 ;;9002226.02101,"736,55045-2999-02 ",.01)
 ;;55045-2999-02
 ;;9002226.02101,"736,55045-2999-02 ",.02)
 ;;55045-2999-02
 ;;9002226.02101,"736,55045-2999-03 ",.01)
 ;;55045-2999-03
 ;;9002226.02101,"736,55045-2999-03 ",.02)
 ;;55045-2999-03
 ;;9002226.02101,"736,55045-2999-04 ",.01)
 ;;55045-2999-04
 ;;9002226.02101,"736,55045-2999-04 ",.02)
 ;;55045-2999-04
 ;;9002226.02101,"736,55045-2999-05 ",.01)
 ;;55045-2999-05
 ;;9002226.02101,"736,55045-2999-05 ",.02)
 ;;55045-2999-05
 ;;9002226.02101,"736,55045-2999-07 ",.01)
 ;;55045-2999-07
 ;;9002226.02101,"736,55045-2999-07 ",.02)
 ;;55045-2999-07
 ;;9002226.02101,"736,55045-2999-08 ",.01)
 ;;55045-2999-08
 ;;9002226.02101,"736,55045-2999-08 ",.02)
 ;;55045-2999-08
 ;;9002226.02101,"736,55045-2999-09 ",.01)
 ;;55045-2999-09
 ;;9002226.02101,"736,55045-2999-09 ",.02)
 ;;55045-2999-09
 ;;9002226.02101,"736,55045-3037-08 ",.01)
 ;;55045-3037-08
 ;;9002226.02101,"736,55045-3037-08 ",.02)
 ;;55045-3037-08
 ;;9002226.02101,"736,55045-3095-00 ",.01)
 ;;55045-3095-00
 ;;9002226.02101,"736,55045-3095-00 ",.02)
 ;;55045-3095-00
 ;;9002226.02101,"736,55045-3095-01 ",.01)
 ;;55045-3095-01
 ;;9002226.02101,"736,55045-3095-01 ",.02)
 ;;55045-3095-01
 ;;9002226.02101,"736,55045-3095-09 ",.01)
 ;;55045-3095-09
 ;;9002226.02101,"736,55045-3095-09 ",.02)
 ;;55045-3095-09
 ;;9002226.02101,"736,55045-3099-00 ",.01)
 ;;55045-3099-00
 ;;9002226.02101,"736,55045-3099-00 ",.02)
 ;;55045-3099-00
 ;;9002226.02101,"736,55045-3099-01 ",.01)
 ;;55045-3099-01
 ;;9002226.02101,"736,55045-3099-01 ",.02)
 ;;55045-3099-01
 ;;9002226.02101,"736,55045-3099-03 ",.01)
 ;;55045-3099-03
 ;;9002226.02101,"736,55045-3099-03 ",.02)
 ;;55045-3099-03
 ;;9002226.02101,"736,55045-3099-04 ",.01)
 ;;55045-3099-04
 ;;9002226.02101,"736,55045-3099-04 ",.02)
 ;;55045-3099-04
 ;;9002226.02101,"736,55045-3099-05 ",.01)
 ;;55045-3099-05
 ;;9002226.02101,"736,55045-3099-05 ",.02)
 ;;55045-3099-05
 ;;9002226.02101,"736,55045-3099-07 ",.01)
 ;;55045-3099-07
 ;;9002226.02101,"736,55045-3099-07 ",.02)
 ;;55045-3099-07
 ;;9002226.02101,"736,55045-3099-08 ",.01)
 ;;55045-3099-08
 ;;9002226.02101,"736,55045-3099-08 ",.02)
 ;;55045-3099-08
 ;;9002226.02101,"736,55045-3099-09 ",.01)
 ;;55045-3099-09
 ;;9002226.02101,"736,55045-3099-09 ",.02)
 ;;55045-3099-09
 ;;9002226.02101,"736,55045-3335-00 ",.01)
 ;;55045-3335-00
 ;;9002226.02101,"736,55045-3335-00 ",.02)
 ;;55045-3335-00
 ;;9002226.02101,"736,55045-3335-01 ",.01)
 ;;55045-3335-01
 ;;9002226.02101,"736,55045-3335-01 ",.02)
 ;;55045-3335-01
 ;;9002226.02101,"736,55045-3377-00 ",.01)
 ;;55045-3377-00
 ;;9002226.02101,"736,55045-3377-00 ",.02)
 ;;55045-3377-00
 ;;9002226.02101,"736,55045-3377-01 ",.01)
 ;;55045-3377-01
 ;;9002226.02101,"736,55045-3377-01 ",.02)
 ;;55045-3377-01
 ;;9002226.02101,"736,55045-3377-03 ",.01)
 ;;55045-3377-03
 ;;9002226.02101,"736,55045-3377-03 ",.02)
 ;;55045-3377-03
 ;;9002226.02101,"736,55045-3377-04 ",.01)
 ;;55045-3377-04
 ;;9002226.02101,"736,55045-3377-04 ",.02)
 ;;55045-3377-04
 ;;9002226.02101,"736,55045-3377-05 ",.01)
 ;;55045-3377-05
 ;;9002226.02101,"736,55045-3377-05 ",.02)
 ;;55045-3377-05
 ;;9002226.02101,"736,55045-3377-09 ",.01)
 ;;55045-3377-09
 ;;9002226.02101,"736,55045-3377-09 ",.02)
 ;;55045-3377-09
 ;;9002226.02101,"736,55045-3419-00 ",.01)
 ;;55045-3419-00
 ;;9002226.02101,"736,55045-3419-00 ",.02)
 ;;55045-3419-00
 ;;9002226.02101,"736,55289-0184-20 ",.01)
 ;;55289-0184-20
 ;;9002226.02101,"736,55289-0184-20 ",.02)
 ;;55289-0184-20
 ;;9002226.02101,"736,55289-0231-04 ",.01)
 ;;55289-0231-04
 ;;9002226.02101,"736,55289-0231-04 ",.02)
 ;;55289-0231-04
 ;;9002226.02101,"736,55289-0231-08 ",.01)
 ;;55289-0231-08
 ;;9002226.02101,"736,55289-0231-08 ",.02)
 ;;55289-0231-08
 ;;9002226.02101,"736,55289-0231-12 ",.01)
 ;;55289-0231-12
 ;;9002226.02101,"736,55289-0231-12 ",.02)
 ;;55289-0231-12
 ;;9002226.02101,"736,55289-0231-16 ",.01)
 ;;55289-0231-16
 ;;9002226.02101,"736,55289-0231-16 ",.02)
 ;;55289-0231-16
 ;;9002226.02101,"736,55289-0231-40 ",.01)
 ;;55289-0231-40
 ;;9002226.02101,"736,55289-0231-40 ",.02)
 ;;55289-0231-40
 ;;9002226.02101,"736,55289-0321-30 ",.01)
 ;;55289-0321-30
 ;;9002226.02101,"736,55289-0321-30 ",.02)
 ;;55289-0321-30
 ;;9002226.02101,"736,55289-0324-12 ",.01)
 ;;55289-0324-12
 ;;9002226.02101,"736,55289-0324-12 ",.02)
 ;;55289-0324-12
 ;;9002226.02101,"736,55289-0324-16 ",.01)
 ;;55289-0324-16
 ;;9002226.02101,"736,55289-0324-16 ",.02)
 ;;55289-0324-16
 ;;9002226.02101,"736,55289-0324-60 ",.01)
 ;;55289-0324-60
 ;;9002226.02101,"736,55289-0324-60 ",.02)
 ;;55289-0324-60
 ;;9002226.02101,"736,55289-0852-10 ",.01)
 ;;55289-0852-10
 ;;9002226.02101,"736,55289-0852-10 ",.02)
 ;;55289-0852-10
 ;;9002226.02101,"736,55289-0852-12 ",.01)
 ;;55289-0852-12
 ;;9002226.02101,"736,55289-0852-12 ",.02)
 ;;55289-0852-12
 ;;9002226.02101,"736,55289-0852-20 ",.01)
 ;;55289-0852-20
 ;;9002226.02101,"736,55289-0852-20 ",.02)
 ;;55289-0852-20
 ;;9002226.02101,"736,55289-0889-15 ",.01)
 ;;55289-0889-15
 ;;9002226.02101,"736,55289-0889-15 ",.02)
 ;;55289-0889-15
 ;;9002226.02101,"736,55887-0051-30 ",.01)
 ;;55887-0051-30
 ;;9002226.02101,"736,55887-0051-30 ",.02)
 ;;55887-0051-30
 ;;9002226.02101,"736,55887-0064-04 ",.01)
 ;;55887-0064-04
 ;;9002226.02101,"736,55887-0064-04 ",.02)
 ;;55887-0064-04
 ;;9002226.02101,"736,55887-0171-01 ",.01)
 ;;55887-0171-01
 ;;9002226.02101,"736,55887-0171-01 ",.02)
 ;;55887-0171-01
 ;;9002226.02101,"736,55887-0171-30 ",.01)
 ;;55887-0171-30
 ;;9002226.02101,"736,55887-0171-30 ",.02)
 ;;55887-0171-30
 ;;9002226.02101,"736,55887-0171-60 ",.01)
 ;;55887-0171-60
 ;;9002226.02101,"736,55887-0171-60 ",.02)
 ;;55887-0171-60
 ;;9002226.02101,"736,55887-0171-83 ",.01)
 ;;55887-0171-83
 ;;9002226.02101,"736,55887-0171-83 ",.02)
 ;;55887-0171-83
 ;;9002226.02101,"736,55887-0171-84 ",.01)
 ;;55887-0171-84
 ;;9002226.02101,"736,55887-0171-84 ",.02)
 ;;55887-0171-84
 ;;9002226.02101,"736,55887-0171-86 ",.01)
 ;;55887-0171-86
 ;;9002226.02101,"736,55887-0171-86 ",.02)
 ;;55887-0171-86
 ;;9002226.02101,"736,55887-0171-90 ",.01)
 ;;55887-0171-90
 ;;9002226.02101,"736,55887-0171-90 ",.02)
 ;;55887-0171-90
 ;;9002226.02101,"736,55887-0446-01 ",.01)
 ;;55887-0446-01
 ;;9002226.02101,"736,55887-0446-01 ",.02)
 ;;55887-0446-01
 ;;9002226.02101,"736,55887-0446-30 ",.01)
 ;;55887-0446-30
 ;;9002226.02101,"736,55887-0446-30 ",.02)
 ;;55887-0446-30
 ;;9002226.02101,"736,55887-0446-40 ",.01)
 ;;55887-0446-40
 ;;9002226.02101,"736,55887-0446-40 ",.02)
 ;;55887-0446-40
 ;;9002226.02101,"736,55887-0943-01 ",.01)
 ;;55887-0943-01
 ;;9002226.02101,"736,55887-0943-01 ",.02)
 ;;55887-0943-01
 ;;9002226.02101,"736,55887-0943-10 ",.01)
 ;;55887-0943-10
 ;;9002226.02101,"736,55887-0943-10 ",.02)
 ;;55887-0943-10
 ;;9002226.02101,"736,55887-0943-12 ",.01)
 ;;55887-0943-12
 ;;9002226.02101,"736,55887-0943-12 ",.02)
 ;;55887-0943-12
 ;;9002226.02101,"736,55887-0943-14 ",.01)
 ;;55887-0943-14
 ;;9002226.02101,"736,55887-0943-14 ",.02)
 ;;55887-0943-14
 ;;9002226.02101,"736,55887-0943-15 ",.01)
 ;;55887-0943-15
 ;;9002226.02101,"736,55887-0943-15 ",.02)
 ;;55887-0943-15
 ;;9002226.02101,"736,55887-0943-20 ",.01)
 ;;55887-0943-20
 ;;9002226.02101,"736,55887-0943-20 ",.02)
 ;;55887-0943-20
 ;;9002226.02101,"736,55887-0943-24 ",.01)
 ;;55887-0943-24
 ;;9002226.02101,"736,55887-0943-24 ",.02)
 ;;55887-0943-24
 ;;9002226.02101,"736,55887-0943-25 ",.01)
 ;;55887-0943-25
 ;;9002226.02101,"736,55887-0943-25 ",.02)
 ;;55887-0943-25
 ;;9002226.02101,"736,55887-0943-30 ",.01)
 ;;55887-0943-30
 ;;9002226.02101,"736,55887-0943-30 ",.02)
 ;;55887-0943-30
 ;;9002226.02101,"736,55887-0943-40 ",.01)
 ;;55887-0943-40
 ;;9002226.02101,"736,55887-0943-40 ",.02)
 ;;55887-0943-40
 ;;9002226.02101,"736,55887-0943-50 ",.01)
 ;;55887-0943-50
 ;;9002226.02101,"736,55887-0943-50 ",.02)
 ;;55887-0943-50
 ;;9002226.02101,"736,55887-0943-60 ",.01)
 ;;55887-0943-60
 ;;9002226.02101,"736,55887-0943-60 ",.02)
 ;;55887-0943-60
 ;;9002226.02101,"736,55887-0943-82 ",.01)
 ;;55887-0943-82
 ;;9002226.02101,"736,55887-0943-82 ",.02)
 ;;55887-0943-82
 ;;9002226.02101,"736,55887-0943-90 ",.01)
 ;;55887-0943-90
 ;;9002226.02101,"736,55887-0943-90 ",.02)
 ;;55887-0943-90
 ;;9002226.02101,"736,57664-0467-08 ",.01)
 ;;57664-0467-08
 ;;9002226.02101,"736,57664-0467-08 ",.02)
 ;;57664-0467-08
 ;;9002226.02101,"736,57664-0471-08 ",.01)
 ;;57664-0471-08
 ;;9002226.02101,"736,57664-0471-08 ",.02)
 ;;57664-0471-08
 ;;9002226.02101,"736,57866-4360-01 ",.01)
 ;;57866-4360-01
 ;;9002226.02101,"736,57866-4360-01 ",.02)
 ;;57866-4360-01
 ;;9002226.02101,"736,57866-4360-02 ",.01)
 ;;57866-4360-02
 ;;9002226.02101,"736,57866-4360-02 ",.02)
 ;;57866-4360-02
 ;;9002226.02101,"736,57866-4360-03 ",.01)
 ;;57866-4360-03
 ;;9002226.02101,"736,57866-4360-03 ",.02)
 ;;57866-4360-03
 ;;9002226.02101,"736,57866-4360-04 ",.01)
 ;;57866-4360-04
 ;;9002226.02101,"736,57866-4360-04 ",.02)
 ;;57866-4360-04
 ;;9002226.02101,"736,57866-4361-01 ",.01)
 ;;57866-4361-01
 ;;9002226.02101,"736,57866-4361-01 ",.02)
 ;;57866-4361-01
 ;;9002226.02101,"736,57866-4361-02 ",.01)
 ;;57866-4361-02
 ;;9002226.02101,"736,57866-4361-02 ",.02)
 ;;57866-4361-02
 ;;9002226.02101,"736,57866-4361-03 ",.01)
 ;;57866-4361-03
 ;;9002226.02101,"736,57866-4361-03 ",.02)
 ;;57866-4361-03
 ;;9002226.02101,"736,57866-4361-04 ",.01)
 ;;57866-4361-04
 ;;9002226.02101,"736,57866-4361-04 ",.02)
 ;;57866-4361-04
 ;;9002226.02101,"736,57866-4361-05 ",.01)
 ;;57866-4361-05
 ;;9002226.02101,"736,57866-4361-05 ",.02)
 ;;57866-4361-05
 ;;9002226.02101,"736,57866-4361-06 ",.01)
 ;;57866-4361-06
 ;;9002226.02101,"736,57866-4361-06 ",.02)
 ;;57866-4361-06
 ;;9002226.02101,"736,57866-4361-09 ",.01)
 ;;57866-4361-09
 ;;9002226.02101,"736,57866-4361-09 ",.02)
 ;;57866-4361-09
 ;;9002226.02101,"736,58016-0056-00 ",.01)
 ;;58016-0056-00
 ;;9002226.02101,"736,58016-0056-00 ",.02)
 ;;58016-0056-00
 ;;9002226.02101,"736,58016-0056-30 ",.01)
 ;;58016-0056-30
 ;;9002226.02101,"736,58016-0056-30 ",.02)
 ;;58016-0056-30
 ;;9002226.02101,"736,58016-0056-60 ",.01)
 ;;58016-0056-60
 ;;9002226.02101,"736,58016-0056-60 ",.02)
 ;;58016-0056-60
 ;;9002226.02101,"736,58016-0056-90 ",.01)
 ;;58016-0056-90
 ;;9002226.02101,"736,58016-0056-90 ",.02)
 ;;58016-0056-90
 ;;9002226.02101,"736,58016-0150-00 ",.01)
 ;;58016-0150-00
 ;;9002226.02101,"736,58016-0150-00 ",.02)
 ;;58016-0150-00
 ;;9002226.02101,"736,58016-0150-30 ",.01)
 ;;58016-0150-30
 ;;9002226.02101,"736,58016-0150-30 ",.02)
 ;;58016-0150-30
 ;;9002226.02101,"736,58016-0150-60 ",.01)
 ;;58016-0150-60
 ;;9002226.02101,"736,58016-0150-60 ",.02)
 ;;58016-0150-60
 ;;9002226.02101,"736,58016-0150-90 ",.01)
 ;;58016-0150-90
 ;;9002226.02101,"736,58016-0150-90 ",.02)
 ;;58016-0150-90
 ;;9002226.02101,"736,58016-0212-00 ",.01)
 ;;58016-0212-00
 ;;9002226.02101,"736,58016-0212-00 ",.02)
 ;;58016-0212-00
 ;;9002226.02101,"736,58016-0212-02 ",.01)
 ;;58016-0212-02
 ;;9002226.02101,"736,58016-0212-02 ",.02)
 ;;58016-0212-02
 ;;9002226.02101,"736,58016-0212-03 ",.01)
 ;;58016-0212-03
 ;;9002226.02101,"736,58016-0212-03 ",.02)
 ;;58016-0212-03
 ;;9002226.02101,"736,58016-0212-08 ",.01)
 ;;58016-0212-08
 ;;9002226.02101,"736,58016-0212-08 ",.02)
 ;;58016-0212-08
 ;;9002226.02101,"736,58016-0212-10 ",.01)
 ;;58016-0212-10
 ;;9002226.02101,"736,58016-0212-10 ",.02)
 ;;58016-0212-10
 ;;9002226.02101,"736,58016-0212-12 ",.01)
 ;;58016-0212-12
 ;;9002226.02101,"736,58016-0212-12 ",.02)
 ;;58016-0212-12
 ;;9002226.02101,"736,58016-0212-14 ",.01)
 ;;58016-0212-14
 ;;9002226.02101,"736,58016-0212-14 ",.02)
 ;;58016-0212-14
 ;;9002226.02101,"736,58016-0212-15 ",.01)
 ;;58016-0212-15
 ;;9002226.02101,"736,58016-0212-15 ",.02)
 ;;58016-0212-15
 ;;9002226.02101,"736,58016-0212-16 ",.01)
 ;;58016-0212-16
 ;;9002226.02101,"736,58016-0212-16 ",.02)
 ;;58016-0212-16
 ;;9002226.02101,"736,58016-0212-18 ",.01)
 ;;58016-0212-18
 ;;9002226.02101,"736,58016-0212-18 ",.02)
 ;;58016-0212-18
 ;;9002226.02101,"736,58016-0212-20 ",.01)
 ;;58016-0212-20
 ;;9002226.02101,"736,58016-0212-20 ",.02)
 ;;58016-0212-20
 ;;9002226.02101,"736,58016-0212-21 ",.01)
 ;;58016-0212-21
 ;;9002226.02101,"736,58016-0212-21 ",.02)
 ;;58016-0212-21
 ;;9002226.02101,"736,58016-0212-24 ",.01)
 ;;58016-0212-24
 ;;9002226.02101,"736,58016-0212-24 ",.02)
 ;;58016-0212-24
 ;;9002226.02101,"736,58016-0212-28 ",.01)
 ;;58016-0212-28
 ;;9002226.02101,"736,58016-0212-28 ",.02)
 ;;58016-0212-28
 ;;9002226.02101,"736,58016-0212-30 ",.01)
 ;;58016-0212-30
 ;;9002226.02101,"736,58016-0212-30 ",.02)
 ;;58016-0212-30
 ;;9002226.02101,"736,58016-0212-36 ",.01)
 ;;58016-0212-36
 ;;9002226.02101,"736,58016-0212-36 ",.02)
 ;;58016-0212-36
 ;;9002226.02101,"736,58016-0212-40 ",.01)
 ;;58016-0212-40
 ;;9002226.02101,"736,58016-0212-40 ",.02)
 ;;58016-0212-40
 ;;9002226.02101,"736,58016-0212-42 ",.01)
 ;;58016-0212-42
 ;;9002226.02101,"736,58016-0212-42 ",.02)
 ;;58016-0212-42
 ;;9002226.02101,"736,58016-0212-45 ",.01)
 ;;58016-0212-45
 ;;9002226.02101,"736,58016-0212-45 ",.02)
 ;;58016-0212-45
 ;;9002226.02101,"736,58016-0212-50 ",.01)
 ;;58016-0212-50
