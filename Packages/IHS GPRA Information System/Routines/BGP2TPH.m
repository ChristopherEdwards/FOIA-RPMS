BGP2TPH ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 27, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"999,00228-2781-11 ",.02)
 ;;00228-2781-11
 ;;9002226.02101,"999,00228-2781-50 ",.01)
 ;;00228-2781-50
 ;;9002226.02101,"999,00228-2781-50 ",.02)
 ;;00228-2781-50
 ;;9002226.02101,"999,00245-0012-01 ",.01)
 ;;00245-0012-01
 ;;9002226.02101,"999,00245-0012-01 ",.02)
 ;;00245-0012-01
 ;;9002226.02101,"999,00245-0012-11 ",.01)
 ;;00245-0012-11
 ;;9002226.02101,"999,00245-0012-11 ",.02)
 ;;00245-0012-11
 ;;9002226.02101,"999,00245-0012-89 ",.01)
 ;;00245-0012-89
 ;;9002226.02101,"999,00245-0012-89 ",.02)
 ;;00245-0012-89
 ;;9002226.02101,"999,00245-0013-01 ",.01)
 ;;00245-0013-01
 ;;9002226.02101,"999,00245-0013-01 ",.02)
 ;;00245-0013-01
 ;;9002226.02101,"999,00245-0013-11 ",.01)
 ;;00245-0013-11
 ;;9002226.02101,"999,00245-0013-11 ",.02)
 ;;00245-0013-11
 ;;9002226.02101,"999,00245-0013-89 ",.01)
 ;;00245-0013-89
 ;;9002226.02101,"999,00245-0013-89 ",.02)
 ;;00245-0013-89
 ;;9002226.02101,"999,00245-0014-01 ",.01)
 ;;00245-0014-01
 ;;9002226.02101,"999,00245-0014-01 ",.02)
 ;;00245-0014-01
 ;;9002226.02101,"999,00245-0014-11 ",.01)
 ;;00245-0014-11
 ;;9002226.02101,"999,00245-0014-11 ",.02)
 ;;00245-0014-11
 ;;9002226.02101,"999,00245-0014-89 ",.01)
 ;;00245-0014-89
 ;;9002226.02101,"999,00245-0014-89 ",.02)
 ;;00245-0014-89
 ;;9002226.02101,"999,00245-0015-01 ",.01)
 ;;00245-0015-01
 ;;9002226.02101,"999,00245-0015-01 ",.02)
 ;;00245-0015-01
 ;;9002226.02101,"999,00245-0015-11 ",.01)
 ;;00245-0015-11
 ;;9002226.02101,"999,00245-0015-11 ",.02)
 ;;00245-0015-11
 ;;9002226.02101,"999,00245-0015-89 ",.01)
 ;;00245-0015-89
 ;;9002226.02101,"999,00245-0015-89 ",.02)
 ;;00245-0015-89
 ;;9002226.02101,"999,00245-0084-10 ",.01)
 ;;00245-0084-10
 ;;9002226.02101,"999,00245-0084-10 ",.02)
 ;;00245-0084-10
 ;;9002226.02101,"999,00245-0084-11 ",.01)
 ;;00245-0084-11
 ;;9002226.02101,"999,00245-0084-11 ",.02)
 ;;00245-0084-11
 ;;9002226.02101,"999,00245-0085-10 ",.01)
 ;;00245-0085-10
 ;;9002226.02101,"999,00245-0085-10 ",.02)
 ;;00245-0085-10
 ;;9002226.02101,"999,00245-0085-11 ",.01)
 ;;00245-0085-11
 ;;9002226.02101,"999,00245-0085-11 ",.02)
 ;;00245-0085-11
 ;;9002226.02101,"999,00245-0086-10 ",.01)
 ;;00245-0086-10
 ;;9002226.02101,"999,00245-0086-10 ",.02)
 ;;00245-0086-10
 ;;9002226.02101,"999,00245-0086-11 ",.01)
 ;;00245-0086-11
 ;;9002226.02101,"999,00245-0086-11 ",.02)
 ;;00245-0086-11
 ;;9002226.02101,"999,00245-0087-10 ",.01)
 ;;00245-0087-10
 ;;9002226.02101,"999,00245-0087-10 ",.02)
 ;;00245-0087-10
 ;;9002226.02101,"999,00245-0087-11 ",.01)
 ;;00245-0087-11
 ;;9002226.02101,"999,00245-0087-11 ",.02)
 ;;00245-0087-11
 ;;9002226.02101,"999,00247-1012-00 ",.01)
 ;;00247-1012-00
 ;;9002226.02101,"999,00247-1012-00 ",.02)
 ;;00247-1012-00
 ;;9002226.02101,"999,00247-1012-30 ",.01)
 ;;00247-1012-30
 ;;9002226.02101,"999,00247-1012-30 ",.02)
 ;;00247-1012-30
 ;;9002226.02101,"999,00247-1044-30 ",.01)
 ;;00247-1044-30
 ;;9002226.02101,"999,00247-1044-30 ",.02)
 ;;00247-1044-30
 ;;9002226.02101,"999,00247-1044-60 ",.01)
 ;;00247-1044-60
 ;;9002226.02101,"999,00247-1044-60 ",.02)
 ;;00247-1044-60
 ;;9002226.02101,"999,00247-1050-04 ",.01)
 ;;00247-1050-04
 ;;9002226.02101,"999,00247-1050-04 ",.02)
 ;;00247-1050-04
 ;;9002226.02101,"999,00247-1050-30 ",.01)
 ;;00247-1050-30
 ;;9002226.02101,"999,00247-1050-30 ",.02)
 ;;00247-1050-30
 ;;9002226.02101,"999,00247-1050-52 ",.01)
 ;;00247-1050-52
 ;;9002226.02101,"999,00247-1050-52 ",.02)
 ;;00247-1050-52
 ;;9002226.02101,"999,00247-1050-59 ",.01)
 ;;00247-1050-59
 ;;9002226.02101,"999,00247-1050-59 ",.02)
 ;;00247-1050-59
 ;;9002226.02101,"999,00247-1050-60 ",.01)
 ;;00247-1050-60
 ;;9002226.02101,"999,00247-1050-60 ",.02)
 ;;00247-1050-60
 ;;9002226.02101,"999,00247-1051-00 ",.01)
 ;;00247-1051-00
 ;;9002226.02101,"999,00247-1051-00 ",.02)
 ;;00247-1051-00
 ;;9002226.02101,"999,00247-1051-30 ",.01)
 ;;00247-1051-30
 ;;9002226.02101,"999,00247-1051-30 ",.02)
 ;;00247-1051-30
 ;;9002226.02101,"999,00247-1051-60 ",.01)
 ;;00247-1051-60
 ;;9002226.02101,"999,00247-1051-60 ",.02)
 ;;00247-1051-60
 ;;9002226.02101,"999,00247-1051-99 ",.01)
 ;;00247-1051-99
 ;;9002226.02101,"999,00247-1051-99 ",.02)
 ;;00247-1051-99
 ;;9002226.02101,"999,00247-1052-30 ",.01)
 ;;00247-1052-30
 ;;9002226.02101,"999,00247-1052-30 ",.02)
 ;;00247-1052-30
 ;;9002226.02101,"999,00247-1052-45 ",.01)
 ;;00247-1052-45
 ;;9002226.02101,"999,00247-1052-45 ",.02)
 ;;00247-1052-45
 ;;9002226.02101,"999,00247-1065-00 ",.01)
 ;;00247-1065-00
 ;;9002226.02101,"999,00247-1065-00 ",.02)
 ;;00247-1065-00
 ;;9002226.02101,"999,00247-1065-30 ",.01)
 ;;00247-1065-30
 ;;9002226.02101,"999,00247-1065-30 ",.02)
 ;;00247-1065-30
 ;;9002226.02101,"999,00247-1065-60 ",.01)
 ;;00247-1065-60
 ;;9002226.02101,"999,00247-1065-60 ",.02)
 ;;00247-1065-60
 ;;9002226.02101,"999,00247-1065-77 ",.01)
 ;;00247-1065-77
 ;;9002226.02101,"999,00247-1065-77 ",.02)
 ;;00247-1065-77
 ;;9002226.02101,"999,00247-1065-90 ",.01)
 ;;00247-1065-90
 ;;9002226.02101,"999,00247-1065-90 ",.02)
 ;;00247-1065-90
 ;;9002226.02101,"999,00247-1072-00 ",.01)
 ;;00247-1072-00
 ;;9002226.02101,"999,00247-1072-00 ",.02)
 ;;00247-1072-00
 ;;9002226.02101,"999,00247-1072-06 ",.01)
 ;;00247-1072-06
 ;;9002226.02101,"999,00247-1072-06 ",.02)
 ;;00247-1072-06
 ;;9002226.02101,"999,00247-1072-14 ",.01)
 ;;00247-1072-14
 ;;9002226.02101,"999,00247-1072-14 ",.02)
 ;;00247-1072-14
 ;;9002226.02101,"999,00247-1072-30 ",.01)
 ;;00247-1072-30
 ;;9002226.02101,"999,00247-1072-30 ",.02)
 ;;00247-1072-30
 ;;9002226.02101,"999,00247-1072-60 ",.01)
 ;;00247-1072-60
 ;;9002226.02101,"999,00247-1072-60 ",.02)
 ;;00247-1072-60
 ;;9002226.02101,"999,00247-1072-90 ",.01)
 ;;00247-1072-90
 ;;9002226.02101,"999,00247-1072-90 ",.02)
 ;;00247-1072-90
 ;;9002226.02101,"999,00247-1119-14 ",.01)
 ;;00247-1119-14
 ;;9002226.02101,"999,00247-1119-14 ",.02)
 ;;00247-1119-14
 ;;9002226.02101,"999,00247-1119-30 ",.01)
 ;;00247-1119-30
 ;;9002226.02101,"999,00247-1119-30 ",.02)
 ;;00247-1119-30
 ;;9002226.02101,"999,00247-1119-52 ",.01)
 ;;00247-1119-52
 ;;9002226.02101,"999,00247-1119-52 ",.02)
 ;;00247-1119-52
 ;;9002226.02101,"999,00247-1119-60 ",.01)
 ;;00247-1119-60
 ;;9002226.02101,"999,00247-1119-60 ",.02)
 ;;00247-1119-60
 ;;9002226.02101,"999,00247-1120-30 ",.01)
 ;;00247-1120-30
 ;;9002226.02101,"999,00247-1120-30 ",.02)
 ;;00247-1120-30
 ;;9002226.02101,"999,00247-1120-60 ",.01)
 ;;00247-1120-60
 ;;9002226.02101,"999,00247-1120-60 ",.02)
 ;;00247-1120-60
 ;;9002226.02101,"999,00247-1121-30 ",.01)
 ;;00247-1121-30
 ;;9002226.02101,"999,00247-1121-30 ",.02)
 ;;00247-1121-30
 ;;9002226.02101,"999,00247-1121-60 ",.01)
 ;;00247-1121-60
 ;;9002226.02101,"999,00247-1121-60 ",.02)
 ;;00247-1121-60
 ;;9002226.02101,"999,00247-1122-30 ",.01)
 ;;00247-1122-30
 ;;9002226.02101,"999,00247-1122-30 ",.02)
 ;;00247-1122-30
 ;;9002226.02101,"999,00247-1122-60 ",.01)
 ;;00247-1122-60
 ;;9002226.02101,"999,00247-1122-60 ",.02)
 ;;00247-1122-60
 ;;9002226.02101,"999,00247-1123-30 ",.01)
 ;;00247-1123-30
 ;;9002226.02101,"999,00247-1123-30 ",.02)
 ;;00247-1123-30
 ;;9002226.02101,"999,00247-1123-60 ",.01)
 ;;00247-1123-60
 ;;9002226.02101,"999,00247-1123-60 ",.02)
 ;;00247-1123-60
 ;;9002226.02101,"999,00247-1133-30 ",.01)
 ;;00247-1133-30
 ;;9002226.02101,"999,00247-1133-30 ",.02)
 ;;00247-1133-30
 ;;9002226.02101,"999,00247-1133-60 ",.01)
 ;;00247-1133-60
 ;;9002226.02101,"999,00247-1133-60 ",.02)
 ;;00247-1133-60
 ;;9002226.02101,"999,00247-1134-30 ",.01)
 ;;00247-1134-30
 ;;9002226.02101,"999,00247-1134-30 ",.02)
 ;;00247-1134-30
 ;;9002226.02101,"999,00247-1134-60 ",.01)
 ;;00247-1134-60
 ;;9002226.02101,"999,00247-1134-60 ",.02)
 ;;00247-1134-60
 ;;9002226.02101,"999,00247-1146-02 ",.01)
 ;;00247-1146-02
 ;;9002226.02101,"999,00247-1146-02 ",.02)
 ;;00247-1146-02
 ;;9002226.02101,"999,00247-1146-07 ",.01)
 ;;00247-1146-07
 ;;9002226.02101,"999,00247-1146-07 ",.02)
 ;;00247-1146-07
 ;;9002226.02101,"999,00247-1146-30 ",.01)
 ;;00247-1146-30
 ;;9002226.02101,"999,00247-1146-30 ",.02)
 ;;00247-1146-30
 ;;9002226.02101,"999,00247-1146-60 ",.01)
 ;;00247-1146-60
 ;;9002226.02101,"999,00247-1146-60 ",.02)
 ;;00247-1146-60
 ;;9002226.02101,"999,00247-1273-00 ",.01)
 ;;00247-1273-00
 ;;9002226.02101,"999,00247-1273-00 ",.02)
 ;;00247-1273-00
 ;;9002226.02101,"999,00247-1273-30 ",.01)
 ;;00247-1273-30
 ;;9002226.02101,"999,00247-1273-30 ",.02)
 ;;00247-1273-30
 ;;9002226.02101,"999,00247-1273-79 ",.01)
 ;;00247-1273-79
 ;;9002226.02101,"999,00247-1273-79 ",.02)
 ;;00247-1273-79
 ;;9002226.02101,"999,00247-1273-99 ",.01)
 ;;00247-1273-99
 ;;9002226.02101,"999,00247-1273-99 ",.02)
 ;;00247-1273-99
 ;;9002226.02101,"999,00247-1274-00 ",.01)
 ;;00247-1274-00
 ;;9002226.02101,"999,00247-1274-00 ",.02)
 ;;00247-1274-00
 ;;9002226.02101,"999,00247-1274-60 ",.01)
 ;;00247-1274-60
 ;;9002226.02101,"999,00247-1274-60 ",.02)
 ;;00247-1274-60
 ;;9002226.02101,"999,00247-1384-20 ",.01)
 ;;00247-1384-20
 ;;9002226.02101,"999,00247-1384-20 ",.02)
 ;;00247-1384-20
 ;;9002226.02101,"999,00247-1634-30 ",.01)
 ;;00247-1634-30
 ;;9002226.02101,"999,00247-1634-30 ",.02)
 ;;00247-1634-30
 ;;9002226.02101,"999,00247-1671-30 ",.01)
 ;;00247-1671-30
 ;;9002226.02101,"999,00247-1671-30 ",.02)
 ;;00247-1671-30
 ;;9002226.02101,"999,00247-1672-30 ",.01)
 ;;00247-1672-30
 ;;9002226.02101,"999,00247-1672-30 ",.02)
 ;;00247-1672-30
 ;;9002226.02101,"999,00247-1673-30 ",.01)
 ;;00247-1673-30
 ;;9002226.02101,"999,00247-1673-30 ",.02)
 ;;00247-1673-30
 ;;9002226.02101,"999,00247-1801-00 ",.01)
 ;;00247-1801-00
 ;;9002226.02101,"999,00247-1801-00 ",.02)
 ;;00247-1801-00
 ;;9002226.02101,"999,00247-1801-30 ",.01)
 ;;00247-1801-30
 ;;9002226.02101,"999,00247-1801-30 ",.02)
 ;;00247-1801-30
 ;;9002226.02101,"999,00247-1801-60 ",.01)
 ;;00247-1801-60
 ;;9002226.02101,"999,00247-1801-60 ",.02)
 ;;00247-1801-60
 ;;9002226.02101,"999,00247-1801-77 ",.01)
 ;;00247-1801-77
 ;;9002226.02101,"999,00247-1801-77 ",.02)
 ;;00247-1801-77
 ;;9002226.02101,"999,00247-1801-90 ",.01)
 ;;00247-1801-90
 ;;9002226.02101,"999,00247-1801-90 ",.02)
 ;;00247-1801-90
 ;;9002226.02101,"999,00247-1802-00 ",.01)
 ;;00247-1802-00
 ;;9002226.02101,"999,00247-1802-00 ",.02)
 ;;00247-1802-00
 ;;9002226.02101,"999,00247-1802-30 ",.01)
 ;;00247-1802-30
 ;;9002226.02101,"999,00247-1802-30 ",.02)
 ;;00247-1802-30
 ;;9002226.02101,"999,00247-1802-60 ",.01)
 ;;00247-1802-60
 ;;9002226.02101,"999,00247-1802-60 ",.02)
 ;;00247-1802-60
 ;;9002226.02101,"999,00247-1802-77 ",.01)
 ;;00247-1802-77
 ;;9002226.02101,"999,00247-1802-77 ",.02)
 ;;00247-1802-77
 ;;9002226.02101,"999,00247-1802-90 ",.01)
 ;;00247-1802-90
 ;;9002226.02101,"999,00247-1802-90 ",.02)
 ;;00247-1802-90
 ;;9002226.02101,"999,00247-1803-00 ",.01)
 ;;00247-1803-00
 ;;9002226.02101,"999,00247-1803-00 ",.02)
 ;;00247-1803-00
 ;;9002226.02101,"999,00247-1803-30 ",.01)
 ;;00247-1803-30
 ;;9002226.02101,"999,00247-1803-30 ",.02)
 ;;00247-1803-30
 ;;9002226.02101,"999,00247-1803-60 ",.01)
 ;;00247-1803-60
 ;;9002226.02101,"999,00247-1803-60 ",.02)
 ;;00247-1803-60
 ;;9002226.02101,"999,00247-1803-77 ",.01)
 ;;00247-1803-77
 ;;9002226.02101,"999,00247-1803-77 ",.02)
 ;;00247-1803-77
 ;;9002226.02101,"999,00247-1803-90 ",.01)
 ;;00247-1803-90
 ;;9002226.02101,"999,00247-1803-90 ",.02)
 ;;00247-1803-90
 ;;9002226.02101,"999,00247-1887-00 ",.01)
 ;;00247-1887-00
 ;;9002226.02101,"999,00247-1887-00 ",.02)
 ;;00247-1887-00
 ;;9002226.02101,"999,00247-1887-30 ",.01)
 ;;00247-1887-30
 ;;9002226.02101,"999,00247-1887-30 ",.02)
 ;;00247-1887-30
 ;;9002226.02101,"999,00247-1887-60 ",.01)
 ;;00247-1887-60
 ;;9002226.02101,"999,00247-1887-60 ",.02)
 ;;00247-1887-60
 ;;9002226.02101,"999,00247-1887-77 ",.01)
 ;;00247-1887-77
 ;;9002226.02101,"999,00247-1887-77 ",.02)
 ;;00247-1887-77
 ;;9002226.02101,"999,00247-1887-90 ",.01)
 ;;00247-1887-90
 ;;9002226.02101,"999,00247-1887-90 ",.02)
 ;;00247-1887-90
 ;;9002226.02101,"999,00247-1888-00 ",.01)
 ;;00247-1888-00
 ;;9002226.02101,"999,00247-1888-00 ",.02)
 ;;00247-1888-00
 ;;9002226.02101,"999,00247-1888-30 ",.01)
 ;;00247-1888-30
 ;;9002226.02101,"999,00247-1888-30 ",.02)
 ;;00247-1888-30
 ;;9002226.02101,"999,00247-1888-60 ",.01)
 ;;00247-1888-60
 ;;9002226.02101,"999,00247-1888-60 ",.02)
 ;;00247-1888-60
 ;;9002226.02101,"999,00247-1888-77 ",.01)
 ;;00247-1888-77
 ;;9002226.02101,"999,00247-1888-77 ",.02)
 ;;00247-1888-77
 ;;9002226.02101,"999,00247-1888-90 ",.01)
 ;;00247-1888-90
 ;;9002226.02101,"999,00247-1888-90 ",.02)
 ;;00247-1888-90
 ;;9002226.02101,"999,00247-1889-00 ",.01)
 ;;00247-1889-00
 ;;9002226.02101,"999,00247-1889-00 ",.02)
 ;;00247-1889-00
 ;;9002226.02101,"999,00247-1889-30 ",.01)
 ;;00247-1889-30
 ;;9002226.02101,"999,00247-1889-30 ",.02)
 ;;00247-1889-30
 ;;9002226.02101,"999,00247-1889-60 ",.01)
 ;;00247-1889-60
 ;;9002226.02101,"999,00247-1889-60 ",.02)
 ;;00247-1889-60
 ;;9002226.02101,"999,00247-1889-77 ",.01)
 ;;00247-1889-77
 ;;9002226.02101,"999,00247-1889-77 ",.02)
 ;;00247-1889-77
 ;;9002226.02101,"999,00247-1889-90 ",.01)
 ;;00247-1889-90
 ;;9002226.02101,"999,00247-1889-90 ",.02)
 ;;00247-1889-90
 ;;9002226.02101,"999,00247-1923-00 ",.01)
 ;;00247-1923-00
 ;;9002226.02101,"999,00247-1923-00 ",.02)
 ;;00247-1923-00
 ;;9002226.02101,"999,00247-1923-60 ",.01)
 ;;00247-1923-60
 ;;9002226.02101,"999,00247-1923-60 ",.02)
 ;;00247-1923-60
 ;;9002226.02101,"999,00247-2076-30 ",.01)
 ;;00247-2076-30
