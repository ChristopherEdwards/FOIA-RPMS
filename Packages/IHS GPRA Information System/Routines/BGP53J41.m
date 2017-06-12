BGP53J41 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 23, 2015;
 ;;15.1;IHS CLINICAL REPORTING;;MAY 06, 2015;Build 143
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"798,58016-0031-30 ",.01)
 ;;58016-0031-30
 ;;9002226.02101,"798,58016-0031-30 ",.02)
 ;;58016-0031-30
 ;;9002226.02101,"798,58016-0031-60 ",.01)
 ;;58016-0031-60
 ;;9002226.02101,"798,58016-0031-60 ",.02)
 ;;58016-0031-60
 ;;9002226.02101,"798,58016-0031-90 ",.01)
 ;;58016-0031-90
 ;;9002226.02101,"798,58016-0031-90 ",.02)
 ;;58016-0031-90
 ;;9002226.02101,"798,58016-0100-00 ",.01)
 ;;58016-0100-00
 ;;9002226.02101,"798,58016-0100-00 ",.02)
 ;;58016-0100-00
 ;;9002226.02101,"798,58016-0100-30 ",.01)
 ;;58016-0100-30
 ;;9002226.02101,"798,58016-0100-30 ",.02)
 ;;58016-0100-30
 ;;9002226.02101,"798,58016-0100-60 ",.01)
 ;;58016-0100-60
 ;;9002226.02101,"798,58016-0100-60 ",.02)
 ;;58016-0100-60
 ;;9002226.02101,"798,58016-0100-90 ",.01)
 ;;58016-0100-90
 ;;9002226.02101,"798,58016-0100-90 ",.02)
 ;;58016-0100-90
 ;;9002226.02101,"798,58016-0178-00 ",.01)
 ;;58016-0178-00
 ;;9002226.02101,"798,58016-0178-00 ",.02)
 ;;58016-0178-00
 ;;9002226.02101,"798,58016-0178-02 ",.01)
 ;;58016-0178-02
 ;;9002226.02101,"798,58016-0178-02 ",.02)
 ;;58016-0178-02
 ;;9002226.02101,"798,58016-0178-04 ",.01)
 ;;58016-0178-04
 ;;9002226.02101,"798,58016-0178-04 ",.02)
 ;;58016-0178-04
 ;;9002226.02101,"798,58016-0178-05 ",.01)
 ;;58016-0178-05
 ;;9002226.02101,"798,58016-0178-05 ",.02)
 ;;58016-0178-05
 ;;9002226.02101,"798,58016-0178-10 ",.01)
 ;;58016-0178-10
 ;;9002226.02101,"798,58016-0178-10 ",.02)
 ;;58016-0178-10
 ;;9002226.02101,"798,58016-0178-12 ",.01)
 ;;58016-0178-12
 ;;9002226.02101,"798,58016-0178-12 ",.02)
 ;;58016-0178-12
 ;;9002226.02101,"798,58016-0178-14 ",.01)
 ;;58016-0178-14
 ;;9002226.02101,"798,58016-0178-14 ",.02)
 ;;58016-0178-14
 ;;9002226.02101,"798,58016-0178-15 ",.01)
 ;;58016-0178-15
 ;;9002226.02101,"798,58016-0178-15 ",.02)
 ;;58016-0178-15
 ;;9002226.02101,"798,58016-0178-20 ",.01)
 ;;58016-0178-20
 ;;9002226.02101,"798,58016-0178-20 ",.02)
 ;;58016-0178-20
 ;;9002226.02101,"798,58016-0178-30 ",.01)
 ;;58016-0178-30
 ;;9002226.02101,"798,58016-0178-30 ",.02)
 ;;58016-0178-30
 ;;9002226.02101,"798,58016-0178-40 ",.01)
 ;;58016-0178-40
 ;;9002226.02101,"798,58016-0178-40 ",.02)
 ;;58016-0178-40
 ;;9002226.02101,"798,58016-0178-50 ",.01)
 ;;58016-0178-50
 ;;9002226.02101,"798,58016-0178-50 ",.02)
 ;;58016-0178-50
 ;;9002226.02101,"798,58016-0178-60 ",.01)
 ;;58016-0178-60
 ;;9002226.02101,"798,58016-0178-60 ",.02)
 ;;58016-0178-60
 ;;9002226.02101,"798,58016-0178-89 ",.01)
 ;;58016-0178-89
 ;;9002226.02101,"798,58016-0178-89 ",.02)
 ;;58016-0178-89
 ;;9002226.02101,"798,58016-0178-90 ",.01)
 ;;58016-0178-90
 ;;9002226.02101,"798,58016-0178-90 ",.02)
 ;;58016-0178-90
 ;;9002226.02101,"798,58016-0178-99 ",.01)
 ;;58016-0178-99
 ;;9002226.02101,"798,58016-0178-99 ",.02)
 ;;58016-0178-99
 ;;9002226.02101,"798,58016-0220-00 ",.01)
 ;;58016-0220-00
 ;;9002226.02101,"798,58016-0220-00 ",.02)
 ;;58016-0220-00
 ;;9002226.02101,"798,58016-0220-30 ",.01)
 ;;58016-0220-30
 ;;9002226.02101,"798,58016-0220-30 ",.02)
 ;;58016-0220-30
 ;;9002226.02101,"798,58016-0220-60 ",.01)
 ;;58016-0220-60
 ;;9002226.02101,"798,58016-0220-60 ",.02)
 ;;58016-0220-60
 ;;9002226.02101,"798,58016-0220-90 ",.01)
 ;;58016-0220-90
 ;;9002226.02101,"798,58016-0220-90 ",.02)
 ;;58016-0220-90
 ;;9002226.02101,"798,58016-0224-00 ",.01)
 ;;58016-0224-00
 ;;9002226.02101,"798,58016-0224-00 ",.02)
 ;;58016-0224-00
 ;;9002226.02101,"798,58016-0224-02 ",.01)
 ;;58016-0224-02
 ;;9002226.02101,"798,58016-0224-02 ",.02)
 ;;58016-0224-02
 ;;9002226.02101,"798,58016-0224-04 ",.01)
 ;;58016-0224-04
 ;;9002226.02101,"798,58016-0224-04 ",.02)
 ;;58016-0224-04
 ;;9002226.02101,"798,58016-0224-05 ",.01)
 ;;58016-0224-05
 ;;9002226.02101,"798,58016-0224-05 ",.02)
 ;;58016-0224-05
 ;;9002226.02101,"798,58016-0224-10 ",.01)
 ;;58016-0224-10
 ;;9002226.02101,"798,58016-0224-10 ",.02)
 ;;58016-0224-10
 ;;9002226.02101,"798,58016-0224-12 ",.01)
 ;;58016-0224-12
 ;;9002226.02101,"798,58016-0224-12 ",.02)
 ;;58016-0224-12
 ;;9002226.02101,"798,58016-0224-14 ",.01)
 ;;58016-0224-14
 ;;9002226.02101,"798,58016-0224-14 ",.02)
 ;;58016-0224-14
 ;;9002226.02101,"798,58016-0224-15 ",.01)
 ;;58016-0224-15
 ;;9002226.02101,"798,58016-0224-15 ",.02)
 ;;58016-0224-15
 ;;9002226.02101,"798,58016-0224-20 ",.01)
 ;;58016-0224-20
 ;;9002226.02101,"798,58016-0224-20 ",.02)
 ;;58016-0224-20
 ;;9002226.02101,"798,58016-0224-30 ",.01)
 ;;58016-0224-30
 ;;9002226.02101,"798,58016-0224-30 ",.02)
 ;;58016-0224-30
 ;;9002226.02101,"798,58016-0224-40 ",.01)
 ;;58016-0224-40
 ;;9002226.02101,"798,58016-0224-40 ",.02)
 ;;58016-0224-40
 ;;9002226.02101,"798,58016-0224-50 ",.01)
 ;;58016-0224-50
 ;;9002226.02101,"798,58016-0224-50 ",.02)
 ;;58016-0224-50
 ;;9002226.02101,"798,58016-0224-60 ",.01)
 ;;58016-0224-60
 ;;9002226.02101,"798,58016-0224-60 ",.02)
 ;;58016-0224-60
 ;;9002226.02101,"798,58016-0224-89 ",.01)
 ;;58016-0224-89
 ;;9002226.02101,"798,58016-0224-89 ",.02)
 ;;58016-0224-89
 ;;9002226.02101,"798,58016-0224-90 ",.01)
 ;;58016-0224-90
 ;;9002226.02101,"798,58016-0224-90 ",.02)
 ;;58016-0224-90
 ;;9002226.02101,"798,58016-0224-99 ",.01)
 ;;58016-0224-99
 ;;9002226.02101,"798,58016-0224-99 ",.02)
 ;;58016-0224-99
 ;;9002226.02101,"798,58016-0240-00 ",.01)
 ;;58016-0240-00
 ;;9002226.02101,"798,58016-0240-00 ",.02)
 ;;58016-0240-00
 ;;9002226.02101,"798,58016-0240-02 ",.01)
 ;;58016-0240-02
 ;;9002226.02101,"798,58016-0240-02 ",.02)
 ;;58016-0240-02
 ;;9002226.02101,"798,58016-0240-03 ",.01)
 ;;58016-0240-03
 ;;9002226.02101,"798,58016-0240-03 ",.02)
 ;;58016-0240-03
 ;;9002226.02101,"798,58016-0240-30 ",.01)
 ;;58016-0240-30
 ;;9002226.02101,"798,58016-0240-30 ",.02)
 ;;58016-0240-30
 ;;9002226.02101,"798,58016-0240-60 ",.01)
 ;;58016-0240-60
 ;;9002226.02101,"798,58016-0240-60 ",.02)
 ;;58016-0240-60
 ;;9002226.02101,"798,58016-0240-90 ",.01)
 ;;58016-0240-90
 ;;9002226.02101,"798,58016-0240-90 ",.02)
 ;;58016-0240-90
 ;;9002226.02101,"798,58016-0263-00 ",.01)
 ;;58016-0263-00
 ;;9002226.02101,"798,58016-0263-00 ",.02)
 ;;58016-0263-00
 ;;9002226.02101,"798,58016-0263-02 ",.01)
 ;;58016-0263-02
 ;;9002226.02101,"798,58016-0263-02 ",.02)
 ;;58016-0263-02
 ;;9002226.02101,"798,58016-0263-03 ",.01)
 ;;58016-0263-03
 ;;9002226.02101,"798,58016-0263-03 ",.02)
 ;;58016-0263-03
 ;;9002226.02101,"798,58016-0263-10 ",.01)
 ;;58016-0263-10
 ;;9002226.02101,"798,58016-0263-10 ",.02)
 ;;58016-0263-10
 ;;9002226.02101,"798,58016-0263-12 ",.01)
 ;;58016-0263-12
 ;;9002226.02101,"798,58016-0263-12 ",.02)
 ;;58016-0263-12
 ;;9002226.02101,"798,58016-0263-15 ",.01)
 ;;58016-0263-15
 ;;9002226.02101,"798,58016-0263-15 ",.02)
 ;;58016-0263-15
 ;;9002226.02101,"798,58016-0263-20 ",.01)
 ;;58016-0263-20
 ;;9002226.02101,"798,58016-0263-20 ",.02)
 ;;58016-0263-20
 ;;9002226.02101,"798,58016-0263-28 ",.01)
 ;;58016-0263-28
 ;;9002226.02101,"798,58016-0263-28 ",.02)
 ;;58016-0263-28
 ;;9002226.02101,"798,58016-0263-30 ",.01)
 ;;58016-0263-30
 ;;9002226.02101,"798,58016-0263-30 ",.02)
 ;;58016-0263-30
 ;;9002226.02101,"798,58016-0263-60 ",.01)
 ;;58016-0263-60
 ;;9002226.02101,"798,58016-0263-60 ",.02)
 ;;58016-0263-60
 ;;9002226.02101,"798,58016-0263-73 ",.01)
 ;;58016-0263-73
 ;;9002226.02101,"798,58016-0263-73 ",.02)
 ;;58016-0263-73
 ;;9002226.02101,"798,58016-0263-89 ",.01)
 ;;58016-0263-89
 ;;9002226.02101,"798,58016-0263-89 ",.02)
 ;;58016-0263-89
 ;;9002226.02101,"798,58016-0263-90 ",.01)
 ;;58016-0263-90
 ;;9002226.02101,"798,58016-0263-90 ",.02)
 ;;58016-0263-90
 ;;9002226.02101,"798,58016-0282-00 ",.01)
 ;;58016-0282-00
 ;;9002226.02101,"798,58016-0282-00 ",.02)
 ;;58016-0282-00
 ;;9002226.02101,"798,58016-0282-30 ",.01)
 ;;58016-0282-30
 ;;9002226.02101,"798,58016-0282-30 ",.02)
 ;;58016-0282-30
 ;;9002226.02101,"798,58016-0282-60 ",.01)
 ;;58016-0282-60
 ;;9002226.02101,"798,58016-0282-60 ",.02)
 ;;58016-0282-60
 ;;9002226.02101,"798,58016-0282-90 ",.01)
 ;;58016-0282-90
 ;;9002226.02101,"798,58016-0282-90 ",.02)
 ;;58016-0282-90
 ;;9002226.02101,"798,58016-0323-00 ",.01)
 ;;58016-0323-00
 ;;9002226.02101,"798,58016-0323-00 ",.02)
 ;;58016-0323-00
 ;;9002226.02101,"798,58016-0323-10 ",.01)
 ;;58016-0323-10
 ;;9002226.02101,"798,58016-0323-10 ",.02)
 ;;58016-0323-10
 ;;9002226.02101,"798,58016-0323-14 ",.01)
 ;;58016-0323-14
 ;;9002226.02101,"798,58016-0323-14 ",.02)
 ;;58016-0323-14
 ;;9002226.02101,"798,58016-0323-15 ",.01)
 ;;58016-0323-15
 ;;9002226.02101,"798,58016-0323-15 ",.02)
 ;;58016-0323-15
 ;;9002226.02101,"798,58016-0323-20 ",.01)
 ;;58016-0323-20
 ;;9002226.02101,"798,58016-0323-20 ",.02)
 ;;58016-0323-20
 ;;9002226.02101,"798,58016-0323-21 ",.01)
 ;;58016-0323-21
 ;;9002226.02101,"798,58016-0323-21 ",.02)
 ;;58016-0323-21
 ;;9002226.02101,"798,58016-0323-28 ",.01)
 ;;58016-0323-28
 ;;9002226.02101,"798,58016-0323-28 ",.02)
 ;;58016-0323-28
 ;;9002226.02101,"798,58016-0323-30 ",.01)
 ;;58016-0323-30
 ;;9002226.02101,"798,58016-0323-30 ",.02)
 ;;58016-0323-30
 ;;9002226.02101,"798,58016-0323-40 ",.01)
 ;;58016-0323-40
 ;;9002226.02101,"798,58016-0323-40 ",.02)
 ;;58016-0323-40
 ;;9002226.02101,"798,58016-0323-50 ",.01)
 ;;58016-0323-50
 ;;9002226.02101,"798,58016-0323-50 ",.02)
 ;;58016-0323-50
 ;;9002226.02101,"798,58016-0323-60 ",.01)
 ;;58016-0323-60
 ;;9002226.02101,"798,58016-0323-60 ",.02)
 ;;58016-0323-60
 ;;9002226.02101,"798,58016-0323-90 ",.01)
 ;;58016-0323-90
 ;;9002226.02101,"798,58016-0323-90 ",.02)
 ;;58016-0323-90
 ;;9002226.02101,"798,58016-0336-00 ",.01)
 ;;58016-0336-00
 ;;9002226.02101,"798,58016-0336-00 ",.02)
 ;;58016-0336-00
 ;;9002226.02101,"798,58016-0336-30 ",.01)
 ;;58016-0336-30
 ;;9002226.02101,"798,58016-0336-30 ",.02)
 ;;58016-0336-30
 ;;9002226.02101,"798,58016-0336-60 ",.01)
 ;;58016-0336-60
 ;;9002226.02101,"798,58016-0336-60 ",.02)
 ;;58016-0336-60
 ;;9002226.02101,"798,58016-0336-90 ",.01)
 ;;58016-0336-90
 ;;9002226.02101,"798,58016-0336-90 ",.02)
 ;;58016-0336-90
 ;;9002226.02101,"798,58016-0349-00 ",.01)
 ;;58016-0349-00
 ;;9002226.02101,"798,58016-0349-00 ",.02)
 ;;58016-0349-00
 ;;9002226.02101,"798,58016-0349-10 ",.01)
 ;;58016-0349-10
 ;;9002226.02101,"798,58016-0349-10 ",.02)
 ;;58016-0349-10
 ;;9002226.02101,"798,58016-0349-14 ",.01)
 ;;58016-0349-14
 ;;9002226.02101,"798,58016-0349-14 ",.02)
 ;;58016-0349-14
 ;;9002226.02101,"798,58016-0349-15 ",.01)
 ;;58016-0349-15
 ;;9002226.02101,"798,58016-0349-15 ",.02)
 ;;58016-0349-15
 ;;9002226.02101,"798,58016-0349-20 ",.01)
 ;;58016-0349-20
 ;;9002226.02101,"798,58016-0349-20 ",.02)
 ;;58016-0349-20
 ;;9002226.02101,"798,58016-0349-21 ",.01)
 ;;58016-0349-21
 ;;9002226.02101,"798,58016-0349-21 ",.02)
 ;;58016-0349-21
 ;;9002226.02101,"798,58016-0349-30 ",.01)
 ;;58016-0349-30
 ;;9002226.02101,"798,58016-0349-30 ",.02)
 ;;58016-0349-30
 ;;9002226.02101,"798,58016-0349-40 ",.01)
 ;;58016-0349-40
 ;;9002226.02101,"798,58016-0349-40 ",.02)
 ;;58016-0349-40
 ;;9002226.02101,"798,58016-0349-50 ",.01)
 ;;58016-0349-50
 ;;9002226.02101,"798,58016-0349-50 ",.02)
 ;;58016-0349-50
 ;;9002226.02101,"798,58016-0349-60 ",.01)
 ;;58016-0349-60
 ;;9002226.02101,"798,58016-0349-60 ",.02)
 ;;58016-0349-60
 ;;9002226.02101,"798,58016-0349-90 ",.01)
 ;;58016-0349-90
 ;;9002226.02101,"798,58016-0349-90 ",.02)
 ;;58016-0349-90
 ;;9002226.02101,"798,58016-0350-00 ",.01)
 ;;58016-0350-00
 ;;9002226.02101,"798,58016-0350-00 ",.02)
 ;;58016-0350-00
 ;;9002226.02101,"798,58016-0350-10 ",.01)
 ;;58016-0350-10
 ;;9002226.02101,"798,58016-0350-10 ",.02)
 ;;58016-0350-10
 ;;9002226.02101,"798,58016-0350-14 ",.01)
 ;;58016-0350-14
 ;;9002226.02101,"798,58016-0350-14 ",.02)
 ;;58016-0350-14
 ;;9002226.02101,"798,58016-0350-15 ",.01)
 ;;58016-0350-15
 ;;9002226.02101,"798,58016-0350-15 ",.02)
 ;;58016-0350-15
 ;;9002226.02101,"798,58016-0350-20 ",.01)
 ;;58016-0350-20
 ;;9002226.02101,"798,58016-0350-20 ",.02)
 ;;58016-0350-20
 ;;9002226.02101,"798,58016-0350-21 ",.01)
 ;;58016-0350-21
 ;;9002226.02101,"798,58016-0350-21 ",.02)
 ;;58016-0350-21
 ;;9002226.02101,"798,58016-0350-28 ",.01)
 ;;58016-0350-28
 ;;9002226.02101,"798,58016-0350-28 ",.02)
 ;;58016-0350-28
 ;;9002226.02101,"798,58016-0350-30 ",.01)
 ;;58016-0350-30
 ;;9002226.02101,"798,58016-0350-30 ",.02)
 ;;58016-0350-30
 ;;9002226.02101,"798,58016-0350-40 ",.01)
 ;;58016-0350-40
 ;;9002226.02101,"798,58016-0350-40 ",.02)
 ;;58016-0350-40
 ;;9002226.02101,"798,58016-0350-50 ",.01)
 ;;58016-0350-50
 ;;9002226.02101,"798,58016-0350-50 ",.02)
 ;;58016-0350-50
 ;;9002226.02101,"798,58016-0350-60 ",.01)
 ;;58016-0350-60
 ;;9002226.02101,"798,58016-0350-60 ",.02)
 ;;58016-0350-60
 ;;9002226.02101,"798,58016-0350-90 ",.01)
 ;;58016-0350-90
 ;;9002226.02101,"798,58016-0350-90 ",.02)
 ;;58016-0350-90
 ;;9002226.02101,"798,58016-0351-00 ",.01)
 ;;58016-0351-00
 ;;9002226.02101,"798,58016-0351-00 ",.02)
 ;;58016-0351-00
 ;;9002226.02101,"798,58016-0351-10 ",.01)
 ;;58016-0351-10
 ;;9002226.02101,"798,58016-0351-10 ",.02)
 ;;58016-0351-10
 ;;9002226.02101,"798,58016-0351-14 ",.01)
 ;;58016-0351-14
 ;;9002226.02101,"798,58016-0351-14 ",.02)
 ;;58016-0351-14
 ;;9002226.02101,"798,58016-0351-15 ",.01)
 ;;58016-0351-15
 ;;9002226.02101,"798,58016-0351-15 ",.02)
 ;;58016-0351-15
 ;;9002226.02101,"798,58016-0351-20 ",.01)
 ;;58016-0351-20
 ;;9002226.02101,"798,58016-0351-20 ",.02)
 ;;58016-0351-20
 ;;9002226.02101,"798,58016-0351-21 ",.01)
 ;;58016-0351-21
 ;;9002226.02101,"798,58016-0351-21 ",.02)
 ;;58016-0351-21