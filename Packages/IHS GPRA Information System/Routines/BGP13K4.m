BGP13K4 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON APR 14, 2011 ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"692,00187-3751-10 ",.02)
 ;;00187-3751-10
 ;;9002226.02101,"692,00187-3758-10 ",.01)
 ;;00187-3758-10
 ;;9002226.02101,"692,00187-3758-10 ",.02)
 ;;00187-3758-10
 ;;9002226.02101,"692,00187-3805-10 ",.01)
 ;;00187-3805-10
 ;;9002226.02101,"692,00187-3805-10 ",.02)
 ;;00187-3805-10
 ;;9002226.02101,"692,00187-3806-10 ",.01)
 ;;00187-3806-10
 ;;9002226.02101,"692,00187-3806-10 ",.02)
 ;;00187-3806-10
 ;;9002226.02101,"692,00187-4051-10 ",.01)
 ;;00187-4051-10
 ;;9002226.02101,"692,00187-4051-10 ",.02)
 ;;00187-4051-10
 ;;9002226.02101,"692,00187-4052-10 ",.01)
 ;;00187-4052-10
 ;;9002226.02101,"692,00187-4052-10 ",.02)
 ;;00187-4052-10
 ;;9002226.02101,"692,00187-4100-10 ",.01)
 ;;00187-4100-10
 ;;9002226.02101,"692,00187-4100-10 ",.02)
 ;;00187-4100-10
 ;;9002226.02101,"692,00228-2051-10 ",.01)
 ;;00228-2051-10
 ;;9002226.02101,"692,00228-2051-10 ",.02)
 ;;00228-2051-10
 ;;9002226.02101,"692,00228-2051-50 ",.01)
 ;;00228-2051-50
 ;;9002226.02101,"692,00228-2051-50 ",.02)
 ;;00228-2051-50
 ;;9002226.02101,"692,00228-2052-10 ",.01)
 ;;00228-2052-10
 ;;9002226.02101,"692,00228-2052-10 ",.02)
 ;;00228-2052-10
 ;;9002226.02101,"692,00228-2052-50 ",.01)
 ;;00228-2052-50
 ;;9002226.02101,"692,00228-2052-50 ",.02)
 ;;00228-2052-50
 ;;9002226.02101,"692,00228-2052-96 ",.01)
 ;;00228-2052-96
 ;;9002226.02101,"692,00228-2052-96 ",.02)
 ;;00228-2052-96
 ;;9002226.02101,"692,00228-2053-10 ",.01)
 ;;00228-2053-10
 ;;9002226.02101,"692,00228-2053-10 ",.02)
 ;;00228-2053-10
 ;;9002226.02101,"692,00228-2053-50 ",.01)
 ;;00228-2053-50
 ;;9002226.02101,"692,00228-2053-50 ",.02)
 ;;00228-2053-50
 ;;9002226.02101,"692,00247-0186-15 ",.01)
 ;;00247-0186-15
 ;;9002226.02101,"692,00247-0186-15 ",.02)
 ;;00247-0186-15
 ;;9002226.02101,"692,00247-0186-16 ",.01)
 ;;00247-0186-16
 ;;9002226.02101,"692,00247-0186-16 ",.02)
 ;;00247-0186-16
 ;;9002226.02101,"692,00247-0186-20 ",.01)
 ;;00247-0186-20
 ;;9002226.02101,"692,00247-0186-20 ",.02)
 ;;00247-0186-20
 ;;9002226.02101,"692,00247-0186-24 ",.01)
 ;;00247-0186-24
 ;;9002226.02101,"692,00247-0186-24 ",.02)
 ;;00247-0186-24
 ;;9002226.02101,"692,00247-0186-30 ",.01)
 ;;00247-0186-30
 ;;9002226.02101,"692,00247-0186-30 ",.02)
 ;;00247-0186-30
 ;;9002226.02101,"692,00247-0187-00 ",.01)
 ;;00247-0187-00
 ;;9002226.02101,"692,00247-0187-00 ",.02)
 ;;00247-0187-00
 ;;9002226.02101,"692,00247-0187-01 ",.01)
 ;;00247-0187-01
 ;;9002226.02101,"692,00247-0187-01 ",.02)
 ;;00247-0187-01
 ;;9002226.02101,"692,00247-0187-02 ",.01)
 ;;00247-0187-02
 ;;9002226.02101,"692,00247-0187-02 ",.02)
 ;;00247-0187-02
 ;;9002226.02101,"692,00247-0187-03 ",.01)
 ;;00247-0187-03
 ;;9002226.02101,"692,00247-0187-03 ",.02)
 ;;00247-0187-03
 ;;9002226.02101,"692,00247-0187-04 ",.01)
 ;;00247-0187-04
 ;;9002226.02101,"692,00247-0187-04 ",.02)
 ;;00247-0187-04
 ;;9002226.02101,"692,00247-0187-05 ",.01)
 ;;00247-0187-05
 ;;9002226.02101,"692,00247-0187-05 ",.02)
 ;;00247-0187-05
 ;;9002226.02101,"692,00247-0187-06 ",.01)
 ;;00247-0187-06
 ;;9002226.02101,"692,00247-0187-06 ",.02)
 ;;00247-0187-06
 ;;9002226.02101,"692,00247-0187-07 ",.01)
 ;;00247-0187-07
 ;;9002226.02101,"692,00247-0187-07 ",.02)
 ;;00247-0187-07
 ;;9002226.02101,"692,00247-0187-10 ",.01)
 ;;00247-0187-10
 ;;9002226.02101,"692,00247-0187-10 ",.02)
 ;;00247-0187-10
 ;;9002226.02101,"692,00247-0187-12 ",.01)
 ;;00247-0187-12
 ;;9002226.02101,"692,00247-0187-12 ",.02)
 ;;00247-0187-12
 ;;9002226.02101,"692,00247-0187-14 ",.01)
 ;;00247-0187-14
 ;;9002226.02101,"692,00247-0187-14 ",.02)
 ;;00247-0187-14
 ;;9002226.02101,"692,00247-0187-15 ",.01)
 ;;00247-0187-15
 ;;9002226.02101,"692,00247-0187-15 ",.02)
 ;;00247-0187-15
 ;;9002226.02101,"692,00247-0187-20 ",.01)
 ;;00247-0187-20
 ;;9002226.02101,"692,00247-0187-20 ",.02)
 ;;00247-0187-20
 ;;9002226.02101,"692,00247-0187-21 ",.01)
 ;;00247-0187-21
 ;;9002226.02101,"692,00247-0187-21 ",.02)
 ;;00247-0187-21
 ;;9002226.02101,"692,00247-0187-28 ",.01)
 ;;00247-0187-28
 ;;9002226.02101,"692,00247-0187-28 ",.02)
 ;;00247-0187-28
 ;;9002226.02101,"692,00247-0187-30 ",.01)
 ;;00247-0187-30
 ;;9002226.02101,"692,00247-0187-30 ",.02)
 ;;00247-0187-30
 ;;9002226.02101,"692,00247-0187-50 ",.01)
 ;;00247-0187-50
 ;;9002226.02101,"692,00247-0187-50 ",.02)
 ;;00247-0187-50
 ;;9002226.02101,"692,00247-0187-60 ",.01)
 ;;00247-0187-60
 ;;9002226.02101,"692,00247-0187-60 ",.02)
 ;;00247-0187-60
 ;;9002226.02101,"692,00247-0187-77 ",.01)
 ;;00247-0187-77
 ;;9002226.02101,"692,00247-0187-77 ",.02)
 ;;00247-0187-77
 ;;9002226.02101,"692,00247-0187-90 ",.01)
 ;;00247-0187-90
 ;;9002226.02101,"692,00247-0187-90 ",.02)
 ;;00247-0187-90
 ;;9002226.02101,"692,00247-0187-98 ",.01)
 ;;00247-0187-98
 ;;9002226.02101,"692,00247-0187-98 ",.02)
 ;;00247-0187-98
 ;;9002226.02101,"692,00247-0345-00 ",.01)
 ;;00247-0345-00
 ;;9002226.02101,"692,00247-0345-00 ",.02)
 ;;00247-0345-00
 ;;9002226.02101,"692,00247-0345-02 ",.01)
 ;;00247-0345-02
 ;;9002226.02101,"692,00247-0345-02 ",.02)
 ;;00247-0345-02
 ;;9002226.02101,"692,00247-0345-03 ",.01)
 ;;00247-0345-03
 ;;9002226.02101,"692,00247-0345-03 ",.02)
 ;;00247-0345-03
 ;;9002226.02101,"692,00247-0345-07 ",.01)
 ;;00247-0345-07
 ;;9002226.02101,"692,00247-0345-07 ",.02)
 ;;00247-0345-07
 ;;9002226.02101,"692,00247-0345-10 ",.01)
 ;;00247-0345-10
 ;;9002226.02101,"692,00247-0345-10 ",.02)
 ;;00247-0345-10
 ;;9002226.02101,"692,00247-0345-15 ",.01)
 ;;00247-0345-15
 ;;9002226.02101,"692,00247-0345-15 ",.02)
 ;;00247-0345-15
 ;;9002226.02101,"692,00247-0345-20 ",.01)
 ;;00247-0345-20
 ;;9002226.02101,"692,00247-0345-20 ",.02)
 ;;00247-0345-20
 ;;9002226.02101,"692,00247-0345-30 ",.01)
 ;;00247-0345-30
 ;;9002226.02101,"692,00247-0345-30 ",.02)
 ;;00247-0345-30
 ;;9002226.02101,"692,00247-0345-98 ",.01)
 ;;00247-0345-98
 ;;9002226.02101,"692,00247-0345-98 ",.02)
 ;;00247-0345-98
 ;;9002226.02101,"692,00247-0430-00 ",.01)
 ;;00247-0430-00
 ;;9002226.02101,"692,00247-0430-00 ",.02)
 ;;00247-0430-00
 ;;9002226.02101,"692,00247-0430-02 ",.01)
 ;;00247-0430-02
 ;;9002226.02101,"692,00247-0430-02 ",.02)
 ;;00247-0430-02
 ;;9002226.02101,"692,00247-0430-03 ",.01)
 ;;00247-0430-03
 ;;9002226.02101,"692,00247-0430-03 ",.02)
 ;;00247-0430-03
 ;;9002226.02101,"692,00247-0430-04 ",.01)
 ;;00247-0430-04
 ;;9002226.02101,"692,00247-0430-04 ",.02)
 ;;00247-0430-04
 ;;9002226.02101,"692,00247-0430-06 ",.01)
 ;;00247-0430-06
 ;;9002226.02101,"692,00247-0430-06 ",.02)
 ;;00247-0430-06
 ;;9002226.02101,"692,00247-0430-07 ",.01)
 ;;00247-0430-07
 ;;9002226.02101,"692,00247-0430-07 ",.02)
 ;;00247-0430-07
 ;;9002226.02101,"692,00247-0430-08 ",.01)
 ;;00247-0430-08
 ;;9002226.02101,"692,00247-0430-08 ",.02)
 ;;00247-0430-08
 ;;9002226.02101,"692,00247-0430-10 ",.01)
 ;;00247-0430-10
 ;;9002226.02101,"692,00247-0430-10 ",.02)
 ;;00247-0430-10
 ;;9002226.02101,"692,00247-0430-15 ",.01)
 ;;00247-0430-15
 ;;9002226.02101,"692,00247-0430-15 ",.02)
 ;;00247-0430-15
 ;;9002226.02101,"692,00247-0430-20 ",.01)
 ;;00247-0430-20
 ;;9002226.02101,"692,00247-0430-20 ",.02)
 ;;00247-0430-20
 ;;9002226.02101,"692,00247-0430-98 ",.01)
 ;;00247-0430-98
 ;;9002226.02101,"692,00247-0430-98 ",.02)
 ;;00247-0430-98
 ;;9002226.02101,"692,00247-0493-00 ",.01)
 ;;00247-0493-00
 ;;9002226.02101,"692,00247-0493-00 ",.02)
 ;;00247-0493-00
 ;;9002226.02101,"692,00247-0493-01 ",.01)
 ;;00247-0493-01
 ;;9002226.02101,"692,00247-0493-01 ",.02)
 ;;00247-0493-01
 ;;9002226.02101,"692,00247-0493-02 ",.01)
 ;;00247-0493-02
 ;;9002226.02101,"692,00247-0493-02 ",.02)
 ;;00247-0493-02
 ;;9002226.02101,"692,00247-0493-03 ",.01)
 ;;00247-0493-03
 ;;9002226.02101,"692,00247-0493-03 ",.02)
 ;;00247-0493-03
 ;;9002226.02101,"692,00247-0493-06 ",.01)
 ;;00247-0493-06
 ;;9002226.02101,"692,00247-0493-06 ",.02)
 ;;00247-0493-06
 ;;9002226.02101,"692,00247-0493-07 ",.01)
 ;;00247-0493-07
 ;;9002226.02101,"692,00247-0493-07 ",.02)
 ;;00247-0493-07
 ;;9002226.02101,"692,00247-0493-10 ",.01)
 ;;00247-0493-10
 ;;9002226.02101,"692,00247-0493-10 ",.02)
 ;;00247-0493-10
 ;;9002226.02101,"692,00247-0493-12 ",.01)
 ;;00247-0493-12
 ;;9002226.02101,"692,00247-0493-12 ",.02)
 ;;00247-0493-12
 ;;9002226.02101,"692,00247-0493-14 ",.01)
 ;;00247-0493-14
 ;;9002226.02101,"692,00247-0493-14 ",.02)
 ;;00247-0493-14
 ;;9002226.02101,"692,00247-0493-15 ",.01)
 ;;00247-0493-15
 ;;9002226.02101,"692,00247-0493-15 ",.02)
 ;;00247-0493-15
 ;;9002226.02101,"692,00247-0493-20 ",.01)
 ;;00247-0493-20
 ;;9002226.02101,"692,00247-0493-20 ",.02)
 ;;00247-0493-20
 ;;9002226.02101,"692,00247-0493-30 ",.01)
 ;;00247-0493-30
 ;;9002226.02101,"692,00247-0493-30 ",.02)
 ;;00247-0493-30
 ;;9002226.02101,"692,00247-0493-50 ",.01)
 ;;00247-0493-50
 ;;9002226.02101,"692,00247-0493-50 ",.02)
 ;;00247-0493-50
 ;;9002226.02101,"692,00247-0493-60 ",.01)
 ;;00247-0493-60
 ;;9002226.02101,"692,00247-0493-60 ",.02)
 ;;00247-0493-60
 ;;9002226.02101,"692,00247-0493-90 ",.01)
 ;;00247-0493-90
 ;;9002226.02101,"692,00247-0493-90 ",.02)
 ;;00247-0493-90
 ;;9002226.02101,"692,00247-0939-00 ",.01)
 ;;00247-0939-00
 ;;9002226.02101,"692,00247-0939-00 ",.02)
 ;;00247-0939-00
 ;;9002226.02101,"692,00247-0939-02 ",.01)
 ;;00247-0939-02
 ;;9002226.02101,"692,00247-0939-02 ",.02)
 ;;00247-0939-02
 ;;9002226.02101,"692,00247-0939-03 ",.01)
 ;;00247-0939-03
 ;;9002226.02101,"692,00247-0939-03 ",.02)
 ;;00247-0939-03
 ;;9002226.02101,"692,00247-0939-06 ",.01)
 ;;00247-0939-06
 ;;9002226.02101,"692,00247-0939-06 ",.02)
 ;;00247-0939-06
 ;;9002226.02101,"692,00247-0939-15 ",.01)
 ;;00247-0939-15
 ;;9002226.02101,"692,00247-0939-15 ",.02)
 ;;00247-0939-15
 ;;9002226.02101,"692,00247-0939-30 ",.01)
 ;;00247-0939-30
 ;;9002226.02101,"692,00247-0939-30 ",.02)
 ;;00247-0939-30
 ;;9002226.02101,"692,00247-1424-04 ",.01)
 ;;00247-1424-04
 ;;9002226.02101,"692,00247-1424-04 ",.02)
 ;;00247-1424-04
 ;;9002226.02101,"692,00247-1424-12 ",.01)
 ;;00247-1424-12
 ;;9002226.02101,"692,00247-1424-12 ",.02)
 ;;00247-1424-12
 ;;9002226.02101,"692,00247-1596-10 ",.01)
 ;;00247-1596-10
 ;;9002226.02101,"692,00247-1596-10 ",.02)
 ;;00247-1596-10
 ;;9002226.02101,"692,00247-1958-04 ",.01)
 ;;00247-1958-04
 ;;9002226.02101,"692,00247-1958-04 ",.02)
 ;;00247-1958-04
 ;;9002226.02101,"692,00364-0775-01 ",.01)
 ;;00364-0775-01
 ;;9002226.02101,"692,00364-0775-01 ",.02)
 ;;00364-0775-01
 ;;9002226.02101,"692,00364-0775-02 ",.01)
 ;;00364-0775-02
 ;;9002226.02101,"692,00364-0775-02 ",.02)
 ;;00364-0775-02
 ;;9002226.02101,"692,00364-0775-05 ",.01)
 ;;00364-0775-05
 ;;9002226.02101,"692,00364-0775-05 ",.02)
 ;;00364-0775-05
 ;;9002226.02101,"692,00378-0211-01 ",.01)
 ;;00378-0211-01
 ;;9002226.02101,"692,00378-0211-01 ",.02)
 ;;00378-0211-01
 ;;9002226.02101,"692,00378-0211-05 ",.01)
 ;;00378-0211-05
 ;;9002226.02101,"692,00378-0211-05 ",.02)
 ;;00378-0211-05
 ;;9002226.02101,"692,00378-0271-01 ",.01)
 ;;00378-0271-01
 ;;9002226.02101,"692,00378-0271-01 ",.02)
 ;;00378-0271-01
 ;;9002226.02101,"692,00378-0271-05 ",.01)
 ;;00378-0271-05
 ;;9002226.02101,"692,00378-0271-05 ",.02)
 ;;00378-0271-05
 ;;9002226.02101,"692,00378-0277-01 ",.01)
 ;;00378-0277-01
 ;;9002226.02101,"692,00378-0277-01 ",.02)
 ;;00378-0277-01
 ;;9002226.02101,"692,00378-0277-05 ",.01)
 ;;00378-0277-05
 ;;9002226.02101,"692,00378-0277-05 ",.02)
 ;;00378-0277-05
 ;;9002226.02101,"692,00378-0345-01 ",.01)
 ;;00378-0345-01
 ;;9002226.02101,"692,00378-0345-01 ",.02)
 ;;00378-0345-01
 ;;9002226.02101,"692,00378-0345-05 ",.01)
 ;;00378-0345-05
 ;;9002226.02101,"692,00378-0345-05 ",.02)
 ;;00378-0345-05
 ;;9002226.02101,"692,00378-0477-01 ",.01)
 ;;00378-0477-01
 ;;9002226.02101,"692,00378-0477-01 ",.02)
 ;;00378-0477-01
 ;;9002226.02101,"692,00378-0477-05 ",.01)
 ;;00378-0477-05
 ;;9002226.02101,"692,00378-0477-05 ",.02)
 ;;00378-0477-05
 ;;9002226.02101,"692,00378-4415-01 ",.01)
 ;;00378-4415-01
 ;;9002226.02101,"692,00378-4415-01 ",.02)
 ;;00378-4415-01
 ;;9002226.02101,"692,00378-4415-05 ",.01)
 ;;00378-4415-05
 ;;9002226.02101,"692,00378-4415-05 ",.02)
 ;;00378-4415-05
 ;;9002226.02101,"692,00378-4430-01 ",.01)
 ;;00378-4430-01
 ;;9002226.02101,"692,00378-4430-01 ",.02)
 ;;00378-4430-01
 ;;9002226.02101,"692,00378-4430-05 ",.01)
 ;;00378-4430-05
 ;;9002226.02101,"692,00378-4430-05 ",.02)
 ;;00378-4430-05
 ;;9002226.02101,"692,00440-7251-30 ",.01)
 ;;00440-7251-30
 ;;9002226.02101,"692,00440-7251-30 ",.02)
 ;;00440-7251-30
 ;;9002226.02101,"692,00440-7252-12 ",.01)
 ;;00440-7252-12
 ;;9002226.02101,"692,00440-7252-12 ",.02)
 ;;00440-7252-12