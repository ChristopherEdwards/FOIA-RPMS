BGP21F64 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1195,63874-0332-02 ",.01)
 ;;63874-0332-02
 ;;9002226.02101,"1195,63874-0332-02 ",.02)
 ;;63874-0332-02
 ;;9002226.02101,"1195,63874-0332-07 ",.01)
 ;;63874-0332-07
 ;;9002226.02101,"1195,63874-0332-07 ",.02)
 ;;63874-0332-07
 ;;9002226.02101,"1195,63874-0332-10 ",.01)
 ;;63874-0332-10
 ;;9002226.02101,"1195,63874-0332-10 ",.02)
 ;;63874-0332-10
 ;;9002226.02101,"1195,63874-0332-14 ",.01)
 ;;63874-0332-14
 ;;9002226.02101,"1195,63874-0332-14 ",.02)
 ;;63874-0332-14
 ;;9002226.02101,"1195,63874-0332-15 ",.01)
 ;;63874-0332-15
 ;;9002226.02101,"1195,63874-0332-15 ",.02)
 ;;63874-0332-15
 ;;9002226.02101,"1195,63874-0332-20 ",.01)
 ;;63874-0332-20
 ;;9002226.02101,"1195,63874-0332-20 ",.02)
 ;;63874-0332-20
 ;;9002226.02101,"1195,63874-0332-30 ",.01)
 ;;63874-0332-30
 ;;9002226.02101,"1195,63874-0332-30 ",.02)
 ;;63874-0332-30
 ;;9002226.02101,"1195,63874-0332-60 ",.01)
 ;;63874-0332-60
 ;;9002226.02101,"1195,63874-0332-60 ",.02)
 ;;63874-0332-60
 ;;9002226.02101,"1195,63874-0332-90 ",.01)
 ;;63874-0332-90
 ;;9002226.02101,"1195,63874-0332-90 ",.02)
 ;;63874-0332-90
 ;;9002226.02101,"1195,63874-0368-01 ",.01)
 ;;63874-0368-01
 ;;9002226.02101,"1195,63874-0368-01 ",.02)
 ;;63874-0368-01
 ;;9002226.02101,"1195,63874-0368-02 ",.01)
 ;;63874-0368-02
 ;;9002226.02101,"1195,63874-0368-02 ",.02)
 ;;63874-0368-02
 ;;9002226.02101,"1195,63874-0368-15 ",.01)
 ;;63874-0368-15
 ;;9002226.02101,"1195,63874-0368-15 ",.02)
 ;;63874-0368-15
 ;;9002226.02101,"1195,63874-0368-20 ",.01)
 ;;63874-0368-20
 ;;9002226.02101,"1195,63874-0368-20 ",.02)
 ;;63874-0368-20
 ;;9002226.02101,"1195,63874-0368-28 ",.01)
 ;;63874-0368-28
 ;;9002226.02101,"1195,63874-0368-28 ",.02)
 ;;63874-0368-28
 ;;9002226.02101,"1195,63874-0368-30 ",.01)
 ;;63874-0368-30
 ;;9002226.02101,"1195,63874-0368-30 ",.02)
 ;;63874-0368-30
 ;;9002226.02101,"1195,63874-0368-60 ",.01)
 ;;63874-0368-60
 ;;9002226.02101,"1195,63874-0368-60 ",.02)
 ;;63874-0368-60
 ;;9002226.02101,"1195,63874-0388-01 ",.01)
 ;;63874-0388-01
 ;;9002226.02101,"1195,63874-0388-01 ",.02)
 ;;63874-0388-01
 ;;9002226.02101,"1195,63874-0388-07 ",.01)
 ;;63874-0388-07
 ;;9002226.02101,"1195,63874-0388-07 ",.02)
 ;;63874-0388-07
 ;;9002226.02101,"1195,63874-0388-10 ",.01)
 ;;63874-0388-10
 ;;9002226.02101,"1195,63874-0388-10 ",.02)
 ;;63874-0388-10
 ;;9002226.02101,"1195,63874-0388-12 ",.01)
 ;;63874-0388-12
 ;;9002226.02101,"1195,63874-0388-12 ",.02)
 ;;63874-0388-12
 ;;9002226.02101,"1195,63874-0388-15 ",.01)
 ;;63874-0388-15
 ;;9002226.02101,"1195,63874-0388-15 ",.02)
 ;;63874-0388-15
 ;;9002226.02101,"1195,63874-0388-20 ",.01)
 ;;63874-0388-20
 ;;9002226.02101,"1195,63874-0388-20 ",.02)
 ;;63874-0388-20
 ;;9002226.02101,"1195,63874-0388-30 ",.01)
 ;;63874-0388-30
 ;;9002226.02101,"1195,63874-0388-30 ",.02)
 ;;63874-0388-30
 ;;9002226.02101,"1195,63874-0406-01 ",.01)
 ;;63874-0406-01
 ;;9002226.02101,"1195,63874-0406-01 ",.02)
 ;;63874-0406-01
 ;;9002226.02101,"1195,63874-0406-10 ",.01)
 ;;63874-0406-10
 ;;9002226.02101,"1195,63874-0406-10 ",.02)
 ;;63874-0406-10
 ;;9002226.02101,"1195,63874-0406-14 ",.01)
 ;;63874-0406-14
 ;;9002226.02101,"1195,63874-0406-14 ",.02)
 ;;63874-0406-14
 ;;9002226.02101,"1195,63874-0406-15 ",.01)
 ;;63874-0406-15
 ;;9002226.02101,"1195,63874-0406-15 ",.02)
 ;;63874-0406-15
 ;;9002226.02101,"1195,63874-0406-20 ",.01)
 ;;63874-0406-20
 ;;9002226.02101,"1195,63874-0406-20 ",.02)
 ;;63874-0406-20
 ;;9002226.02101,"1195,63874-0406-28 ",.01)
 ;;63874-0406-28
 ;;9002226.02101,"1195,63874-0406-28 ",.02)
 ;;63874-0406-28
 ;;9002226.02101,"1195,63874-0406-30 ",.01)
 ;;63874-0406-30
 ;;9002226.02101,"1195,63874-0406-30 ",.02)
 ;;63874-0406-30
 ;;9002226.02101,"1195,63874-0406-60 ",.01)
 ;;63874-0406-60
 ;;9002226.02101,"1195,63874-0406-60 ",.02)
 ;;63874-0406-60
 ;;9002226.02101,"1195,63874-0407-01 ",.01)
 ;;63874-0407-01
 ;;9002226.02101,"1195,63874-0407-01 ",.02)
 ;;63874-0407-01
 ;;9002226.02101,"1195,63874-0407-10 ",.01)
 ;;63874-0407-10
 ;;9002226.02101,"1195,63874-0407-10 ",.02)
 ;;63874-0407-10
 ;;9002226.02101,"1195,63874-0407-15 ",.01)
 ;;63874-0407-15
 ;;9002226.02101,"1195,63874-0407-15 ",.02)
 ;;63874-0407-15
 ;;9002226.02101,"1195,63874-0407-20 ",.01)
 ;;63874-0407-20
 ;;9002226.02101,"1195,63874-0407-20 ",.02)
 ;;63874-0407-20
 ;;9002226.02101,"1195,63874-0407-30 ",.01)
 ;;63874-0407-30
 ;;9002226.02101,"1195,63874-0407-30 ",.02)
 ;;63874-0407-30
 ;;9002226.02101,"1195,63874-0407-60 ",.01)
 ;;63874-0407-60
 ;;9002226.02101,"1195,63874-0407-60 ",.02)
 ;;63874-0407-60
 ;;9002226.02101,"1195,63874-0407-90 ",.01)
 ;;63874-0407-90
 ;;9002226.02101,"1195,63874-0407-90 ",.02)
 ;;63874-0407-90
 ;;9002226.02101,"1195,63874-0454-01 ",.01)
 ;;63874-0454-01
 ;;9002226.02101,"1195,63874-0454-01 ",.02)
 ;;63874-0454-01
 ;;9002226.02101,"1195,63874-0454-02 ",.01)
 ;;63874-0454-02
 ;;9002226.02101,"1195,63874-0454-02 ",.02)
 ;;63874-0454-02
 ;;9002226.02101,"1195,63874-0454-04 ",.01)
 ;;63874-0454-04
 ;;9002226.02101,"1195,63874-0454-04 ",.02)
 ;;63874-0454-04
 ;;9002226.02101,"1195,63874-0454-15 ",.01)
 ;;63874-0454-15
 ;;9002226.02101,"1195,63874-0454-15 ",.02)
 ;;63874-0454-15
 ;;9002226.02101,"1195,63874-0454-20 ",.01)
 ;;63874-0454-20
