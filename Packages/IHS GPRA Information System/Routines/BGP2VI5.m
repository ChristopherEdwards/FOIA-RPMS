BGP2VI5 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 08, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"561,60432-0157-21 ",.02)
 ;;60432-0157-21
 ;;9002226.02101,"561,60432-0676-01 ",.01)
 ;;60432-0676-01
 ;;9002226.02101,"561,60432-0676-01 ",.02)
 ;;60432-0676-01
 ;;9002226.02101,"561,60505-0802-01 ",.01)
 ;;60505-0802-01
 ;;9002226.02101,"561,60505-0802-01 ",.02)
 ;;60505-0802-01
 ;;9002226.02101,"561,60505-0802-02 ",.01)
 ;;60505-0802-02
 ;;9002226.02101,"561,60505-0802-02 ",.02)
 ;;60505-0802-02
 ;;9002226.02101,"561,60505-0807-01 ",.01)
 ;;60505-0807-01
 ;;9002226.02101,"561,60505-0807-01 ",.02)
 ;;60505-0807-01
 ;;9002226.02101,"561,60505-0808-01 ",.01)
 ;;60505-0808-01
 ;;9002226.02101,"561,60505-0808-01 ",.02)
 ;;60505-0808-01
 ;;9002226.02101,"561,60598-0061-60 ",.01)
 ;;60598-0061-60
 ;;9002226.02101,"561,60598-0061-60 ",.02)
 ;;60598-0061-60
 ;;9002226.02101,"561,60793-0010-12 ",.01)
 ;;60793-0010-12
 ;;9002226.02101,"561,60793-0010-12 ",.02)
 ;;60793-0010-12
 ;;9002226.02101,"561,60793-0010-60 ",.01)
 ;;60793-0010-60
 ;;9002226.02101,"561,60793-0010-60 ",.02)
 ;;60793-0010-60
 ;;9002226.02101,"561,60793-0011-08 ",.01)
 ;;60793-0011-08
 ;;9002226.02101,"561,60793-0011-08 ",.02)
 ;;60793-0011-08
 ;;9002226.02101,"561,60793-0011-14 ",.01)
 ;;60793-0011-14
 ;;9002226.02101,"561,60793-0011-14 ",.02)
 ;;60793-0011-14
 ;;9002226.02101,"561,60793-0120-01 ",.01)
 ;;60793-0120-01
 ;;9002226.02101,"561,60793-0120-01 ",.02)
 ;;60793-0120-01
 ;;9002226.02101,"561,62037-0794-44 ",.01)
 ;;62037-0794-44
 ;;9002226.02101,"561,62037-0794-44 ",.02)
 ;;62037-0794-44
 ;;9002226.02101,"561,63402-0510-01 ",.01)
 ;;63402-0510-01
 ;;9002226.02101,"561,63402-0510-01 ",.02)
 ;;63402-0510-01
 ;;9002226.02101,"561,63402-0511-24 ",.01)
 ;;63402-0511-24
 ;;9002226.02101,"561,63402-0511-24 ",.02)
 ;;63402-0511-24
 ;;9002226.02101,"561,63402-0512-24 ",.01)
 ;;63402-0512-24
 ;;9002226.02101,"561,63402-0512-24 ",.02)
 ;;63402-0512-24
 ;;9002226.02101,"561,63402-0513-24 ",.01)
 ;;63402-0513-24
 ;;9002226.02101,"561,63402-0513-24 ",.02)
 ;;63402-0513-24
 ;;9002226.02101,"561,63402-0515-30 ",.01)
 ;;63402-0515-30
 ;;9002226.02101,"561,63402-0515-30 ",.02)
 ;;63402-0515-30
 ;;9002226.02101,"561,63402-0711-01 ",.01)
 ;;63402-0711-01
 ;;9002226.02101,"561,63402-0711-01 ",.02)
 ;;63402-0711-01
 ;;9002226.02101,"561,63402-0712-01 ",.01)
 ;;63402-0712-01
 ;;9002226.02101,"561,63402-0712-01 ",.02)
 ;;63402-0712-01
 ;;9002226.02101,"561,63402-0911-30 ",.01)
 ;;63402-0911-30
 ;;9002226.02101,"561,63402-0911-30 ",.02)
 ;;63402-0911-30
 ;;9002226.02101,"561,63402-0911-64 ",.01)
 ;;63402-0911-64
 ;;9002226.02101,"561,63402-0911-64 ",.02)
 ;;63402-0911-64
 ;;9002226.02101,"561,63874-0708-20 ",.01)
 ;;63874-0708-20
 ;;9002226.02101,"561,63874-0708-20 ",.02)
 ;;63874-0708-20
 ;;9002226.02101,"561,63874-0714-20 ",.01)
 ;;63874-0714-20
 ;;9002226.02101,"561,63874-0714-20 ",.02)
 ;;63874-0714-20
 ;;9002226.02101,"561,63874-0749-17 ",.01)
 ;;63874-0749-17
 ;;9002226.02101,"561,63874-0749-17 ",.02)
 ;;63874-0749-17
 ;;9002226.02101,"561,66267-0995-17 ",.01)
 ;;66267-0995-17
 ;;9002226.02101,"561,66267-0995-17 ",.02)
 ;;66267-0995-17
 ;;9002226.02101,"561,66794-0001-25 ",.01)
 ;;66794-0001-25
 ;;9002226.02101,"561,66794-0001-25 ",.02)
 ;;66794-0001-25
 ;;9002226.02101,"561,66794-0001-30 ",.01)
 ;;66794-0001-30
 ;;9002226.02101,"561,66794-0001-30 ",.02)
 ;;66794-0001-30
 ;;9002226.02101,"561,66794-0001-60 ",.01)
 ;;66794-0001-60
 ;;9002226.02101,"561,66794-0001-60 ",.02)
 ;;66794-0001-60
 ;;9002226.02101,"561,68115-0547-20 ",.01)
 ;;68115-0547-20
 ;;9002226.02101,"561,68115-0547-20 ",.02)
 ;;68115-0547-20
 ;;9002226.02101,"561,68115-0651-60 ",.01)
 ;;68115-0651-60
 ;;9002226.02101,"561,68115-0651-60 ",.02)
 ;;68115-0651-60
 ;;9002226.02101,"561,68115-0652-01 ",.01)
 ;;68115-0652-01
 ;;9002226.02101,"561,68115-0652-01 ",.02)
 ;;68115-0652-01
 ;;9002226.02101,"561,68115-0653-01 ",.01)
 ;;68115-0653-01
 ;;9002226.02101,"561,68115-0653-01 ",.02)
 ;;68115-0653-01
 ;;9002226.02101,"561,68115-0657-01 ",.01)
 ;;68115-0657-01
 ;;9002226.02101,"561,68115-0657-01 ",.02)
 ;;68115-0657-01
 ;;9002226.02101,"561,68115-0711-20 ",.01)
 ;;68115-0711-20
 ;;9002226.02101,"561,68115-0711-20 ",.02)
 ;;68115-0711-20
 ;;9002226.02101,"561,68115-0760-01 ",.01)
 ;;68115-0760-01
 ;;9002226.02101,"561,68115-0760-01 ",.02)
 ;;68115-0760-01
 ;;9002226.02101,"561,68115-0769-17 ",.01)
 ;;68115-0769-17
 ;;9002226.02101,"561,68115-0769-17 ",.02)
 ;;68115-0769-17
 ;;9002226.02101,"561,68115-0775-07 ",.01)
 ;;68115-0775-07
 ;;9002226.02101,"561,68115-0775-07 ",.02)
 ;;68115-0775-07
 ;;9002226.02101,"561,68115-0924-60 ",.01)
 ;;68115-0924-60
 ;;9002226.02101,"561,68115-0924-60 ",.02)
 ;;68115-0924-60
 ;;9002226.02101,"561,68115-0995-17 ",.01)
 ;;68115-0995-17
 ;;9002226.02101,"561,68115-0995-17 ",.02)
 ;;68115-0995-17
 ;;9002226.02101,"561,68258-3031-01 ",.01)
 ;;68258-3031-01
 ;;9002226.02101,"561,68258-3031-01 ",.02)
 ;;68258-3031-01
 ;;9002226.02101,"561,68258-3037-01 ",.01)
 ;;68258-3037-01
 ;;9002226.02101,"561,68258-3037-01 ",.02)
 ;;68258-3037-01
