BGP48F9 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 17, 2014;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1201,00406-2065-90 ",.01)
 ;;00406-2065-90
 ;;9002226.02101,"1201,00406-2065-90 ",.02)
 ;;00406-2065-90
 ;;9002226.02101,"1201,00406-2066-03 ",.01)
 ;;00406-2066-03
 ;;9002226.02101,"1201,00406-2066-03 ",.02)
 ;;00406-2066-03
 ;;9002226.02101,"1201,00406-2066-05 ",.01)
 ;;00406-2066-05
 ;;9002226.02101,"1201,00406-2066-05 ",.02)
 ;;00406-2066-05
 ;;9002226.02101,"1201,00406-2066-10 ",.01)
 ;;00406-2066-10
 ;;9002226.02101,"1201,00406-2066-10 ",.02)
 ;;00406-2066-10
 ;;9002226.02101,"1201,00406-2066-60 ",.01)
 ;;00406-2066-60
 ;;9002226.02101,"1201,00406-2066-60 ",.02)
 ;;00406-2066-60
 ;;9002226.02101,"1201,00406-2066-90 ",.01)
 ;;00406-2066-90
 ;;9002226.02101,"1201,00406-2066-90 ",.02)
 ;;00406-2066-90
 ;;9002226.02101,"1201,00406-2067-03 ",.01)
 ;;00406-2067-03
 ;;9002226.02101,"1201,00406-2067-03 ",.02)
 ;;00406-2067-03
 ;;9002226.02101,"1201,00406-2067-05 ",.01)
 ;;00406-2067-05
 ;;9002226.02101,"1201,00406-2067-05 ",.02)
 ;;00406-2067-05
 ;;9002226.02101,"1201,00406-2067-10 ",.01)
 ;;00406-2067-10
 ;;9002226.02101,"1201,00406-2067-10 ",.02)
 ;;00406-2067-10
 ;;9002226.02101,"1201,00406-2067-60 ",.01)
 ;;00406-2067-60
 ;;9002226.02101,"1201,00406-2067-60 ",.02)
 ;;00406-2067-60
 ;;9002226.02101,"1201,00406-2067-90 ",.01)
 ;;00406-2067-90
 ;;9002226.02101,"1201,00406-2067-90 ",.02)
 ;;00406-2067-90
 ;;9002226.02101,"1201,00406-2068-03 ",.01)
 ;;00406-2068-03
 ;;9002226.02101,"1201,00406-2068-03 ",.02)
 ;;00406-2068-03
 ;;9002226.02101,"1201,00406-2068-05 ",.01)
 ;;00406-2068-05
 ;;9002226.02101,"1201,00406-2068-05 ",.02)
 ;;00406-2068-05
 ;;9002226.02101,"1201,00406-2068-10 ",.01)
 ;;00406-2068-10
 ;;9002226.02101,"1201,00406-2068-10 ",.02)
 ;;00406-2068-10
 ;;9002226.02101,"1201,00406-2068-60 ",.01)
 ;;00406-2068-60
 ;;9002226.02101,"1201,00406-2068-60 ",.02)
 ;;00406-2068-60
 ;;9002226.02101,"1201,00406-2068-90 ",.01)
 ;;00406-2068-90
 ;;9002226.02101,"1201,00406-2068-90 ",.02)
 ;;00406-2068-90
 ;;9002226.02101,"1201,00406-2069-03 ",.01)
 ;;00406-2069-03
 ;;9002226.02101,"1201,00406-2069-03 ",.02)
 ;;00406-2069-03
 ;;9002226.02101,"1201,00406-2069-05 ",.01)
 ;;00406-2069-05
 ;;9002226.02101,"1201,00406-2069-05 ",.02)
 ;;00406-2069-05
 ;;9002226.02101,"1201,00406-2069-10 ",.01)
 ;;00406-2069-10
 ;;9002226.02101,"1201,00406-2069-10 ",.02)
 ;;00406-2069-10
 ;;9002226.02101,"1201,00406-2069-60 ",.01)
 ;;00406-2069-60
 ;;9002226.02101,"1201,00406-2069-60 ",.02)
 ;;00406-2069-60
 ;;9002226.02101,"1201,00406-2069-90 ",.01)
 ;;00406-2069-90
 ;;9002226.02101,"1201,00406-2069-90 ",.02)
 ;;00406-2069-90
 ;;9002226.02101,"1201,00440-7125-30 ",.01)
 ;;00440-7125-30
 ;;9002226.02101,"1201,00440-7125-30 ",.02)
 ;;00440-7125-30
 ;;9002226.02101,"1201,00440-7125-60 ",.01)
 ;;00440-7125-60
 ;;9002226.02101,"1201,00440-7125-60 ",.02)
 ;;00440-7125-60
 ;;9002226.02101,"1201,00440-7125-90 ",.01)
 ;;00440-7125-90
 ;;9002226.02101,"1201,00440-7125-90 ",.02)
 ;;00440-7125-90
 ;;9002226.02101,"1201,00440-7126-30 ",.01)
 ;;00440-7126-30
 ;;9002226.02101,"1201,00440-7126-30 ",.02)
 ;;00440-7126-30
 ;;9002226.02101,"1201,00440-7126-60 ",.01)
 ;;00440-7126-60
 ;;9002226.02101,"1201,00440-7126-60 ",.02)
 ;;00440-7126-60
 ;;9002226.02101,"1201,00440-7126-90 ",.01)
 ;;00440-7126-90
 ;;9002226.02101,"1201,00440-7126-90 ",.02)
 ;;00440-7126-90
 ;;9002226.02101,"1201,00440-7127-30 ",.01)
 ;;00440-7127-30
 ;;9002226.02101,"1201,00440-7127-30 ",.02)
 ;;00440-7127-30
 ;;9002226.02101,"1201,00440-7127-60 ",.01)
 ;;00440-7127-60
 ;;9002226.02101,"1201,00440-7127-60 ",.02)
 ;;00440-7127-60
 ;;9002226.02101,"1201,00440-7127-90 ",.01)
 ;;00440-7127-90
 ;;9002226.02101,"1201,00440-7127-90 ",.02)
 ;;00440-7127-90
 ;;9002226.02101,"1201,00440-7128-30 ",.01)
 ;;00440-7128-30
 ;;9002226.02101,"1201,00440-7128-30 ",.02)
 ;;00440-7128-30
 ;;9002226.02101,"1201,00440-7128-60 ",.01)
 ;;00440-7128-60
 ;;9002226.02101,"1201,00440-7128-60 ",.02)
 ;;00440-7128-60
 ;;9002226.02101,"1201,00440-7128-90 ",.01)
 ;;00440-7128-90
 ;;9002226.02101,"1201,00440-7128-90 ",.02)
 ;;00440-7128-90
 ;;9002226.02101,"1201,00440-7692-30 ",.01)
 ;;00440-7692-30
 ;;9002226.02101,"1201,00440-7692-30 ",.02)
 ;;00440-7692-30
 ;;9002226.02101,"1201,00440-7692-60 ",.01)
 ;;00440-7692-60
 ;;9002226.02101,"1201,00440-7692-60 ",.02)
 ;;00440-7692-60
 ;;9002226.02101,"1201,00440-7693-30 ",.01)
 ;;00440-7693-30
 ;;9002226.02101,"1201,00440-7693-30 ",.02)
 ;;00440-7693-30
 ;;9002226.02101,"1201,00440-7693-60 ",.01)
 ;;00440-7693-60
 ;;9002226.02101,"1201,00440-7693-60 ",.02)
 ;;00440-7693-60
 ;;9002226.02101,"1201,00440-7694-30 ",.01)
 ;;00440-7694-30
 ;;9002226.02101,"1201,00440-7694-30 ",.02)
 ;;00440-7694-30
 ;;9002226.02101,"1201,00440-7694-60 ",.01)
 ;;00440-7694-60
 ;;9002226.02101,"1201,00440-7694-60 ",.02)
 ;;00440-7694-60
 ;;9002226.02101,"1201,00440-8155-30 ",.01)
 ;;00440-8155-30
 ;;9002226.02101,"1201,00440-8155-30 ",.02)
 ;;00440-8155-30
 ;;9002226.02101,"1201,00440-8155-60 ",.01)
 ;;00440-8155-60
 ;;9002226.02101,"1201,00440-8155-60 ",.02)
 ;;00440-8155-60
 ;;9002226.02101,"1201,00440-8155-81 ",.01)
 ;;00440-8155-81
 ;;9002226.02101,"1201,00440-8155-81 ",.02)
 ;;00440-8155-81
 ;;9002226.02101,"1201,00440-8155-85 ",.01)
 ;;00440-8155-85
 ;;9002226.02101,"1201,00440-8155-85 ",.02)
 ;;00440-8155-85
 ;;9002226.02101,"1201,00440-8155-89 ",.01)
 ;;00440-8155-89
 ;;9002226.02101,"1201,00440-8155-89 ",.02)
 ;;00440-8155-89
 ;;9002226.02101,"1201,00440-8155-90 ",.01)
 ;;00440-8155-90
 ;;9002226.02101,"1201,00440-8155-90 ",.02)
 ;;00440-8155-90
 ;;9002226.02101,"1201,00440-8156-30 ",.01)
 ;;00440-8156-30
 ;;9002226.02101,"1201,00440-8156-30 ",.02)
 ;;00440-8156-30
 ;;9002226.02101,"1201,00440-8156-60 ",.01)
 ;;00440-8156-60
 ;;9002226.02101,"1201,00440-8156-60 ",.02)
 ;;00440-8156-60
 ;;9002226.02101,"1201,00440-8156-81 ",.01)
 ;;00440-8156-81
 ;;9002226.02101,"1201,00440-8156-81 ",.02)
 ;;00440-8156-81
 ;;9002226.02101,"1201,00440-8156-85 ",.01)
 ;;00440-8156-85
 ;;9002226.02101,"1201,00440-8156-85 ",.02)
 ;;00440-8156-85
 ;;9002226.02101,"1201,00440-8156-89 ",.01)
 ;;00440-8156-89
 ;;9002226.02101,"1201,00440-8156-89 ",.02)
 ;;00440-8156-89
 ;;9002226.02101,"1201,00440-8156-90 ",.01)
 ;;00440-8156-90
 ;;9002226.02101,"1201,00440-8156-90 ",.02)
 ;;00440-8156-90
 ;;9002226.02101,"1201,00440-8157-30 ",.01)
 ;;00440-8157-30
 ;;9002226.02101,"1201,00440-8157-30 ",.02)
 ;;00440-8157-30
 ;;9002226.02101,"1201,00440-8157-60 ",.01)
 ;;00440-8157-60
 ;;9002226.02101,"1201,00440-8157-60 ",.02)
 ;;00440-8157-60
 ;;9002226.02101,"1201,00440-8157-81 ",.01)
 ;;00440-8157-81
 ;;9002226.02101,"1201,00440-8157-81 ",.02)
 ;;00440-8157-81
 ;;9002226.02101,"1201,00440-8157-85 ",.01)
 ;;00440-8157-85
 ;;9002226.02101,"1201,00440-8157-85 ",.02)
 ;;00440-8157-85
 ;;9002226.02101,"1201,00440-8157-89 ",.01)
 ;;00440-8157-89
 ;;9002226.02101,"1201,00440-8157-89 ",.02)
 ;;00440-8157-89
 ;;9002226.02101,"1201,00440-8157-90 ",.01)
 ;;00440-8157-90
 ;;9002226.02101,"1201,00440-8157-90 ",.02)
 ;;00440-8157-90
 ;;9002226.02101,"1201,00440-8158-30 ",.01)
 ;;00440-8158-30
 ;;9002226.02101,"1201,00440-8158-30 ",.02)
 ;;00440-8158-30
 ;;9002226.02101,"1201,00440-8158-60 ",.01)
 ;;00440-8158-60
 ;;9002226.02101,"1201,00440-8158-60 ",.02)
 ;;00440-8158-60
 ;;9002226.02101,"1201,00440-8158-90 ",.01)
 ;;00440-8158-90
 ;;9002226.02101,"1201,00440-8158-90 ",.02)
 ;;00440-8158-90
 ;;9002226.02101,"1201,00440-8320-30 ",.01)
 ;;00440-8320-30
 ;;9002226.02101,"1201,00440-8320-30 ",.02)
 ;;00440-8320-30
 ;;9002226.02101,"1201,00440-8320-90 ",.01)
 ;;00440-8320-90
 ;;9002226.02101,"1201,00440-8320-90 ",.02)
 ;;00440-8320-90
 ;;9002226.02101,"1201,00440-8321-30 ",.01)
 ;;00440-8321-30
 ;;9002226.02101,"1201,00440-8321-30 ",.02)
 ;;00440-8321-30
 ;;9002226.02101,"1201,00440-8321-90 ",.01)
 ;;00440-8321-90
 ;;9002226.02101,"1201,00440-8321-90 ",.02)
 ;;00440-8321-90
 ;;9002226.02101,"1201,00440-8322-30 ",.01)
 ;;00440-8322-30
 ;;9002226.02101,"1201,00440-8322-30 ",.02)
 ;;00440-8322-30
 ;;9002226.02101,"1201,00440-8322-90 ",.01)
 ;;00440-8322-90
 ;;9002226.02101,"1201,00440-8322-90 ",.02)
 ;;00440-8322-90
 ;;9002226.02101,"1201,00440-8323-30 ",.01)
 ;;00440-8323-30
 ;;9002226.02101,"1201,00440-8323-30 ",.02)
 ;;00440-8323-30
 ;;9002226.02101,"1201,00440-8323-90 ",.01)
 ;;00440-8323-90
 ;;9002226.02101,"1201,00440-8323-90 ",.02)
 ;;00440-8323-90
 ;;9002226.02101,"1201,00440-8324-30 ",.01)
 ;;00440-8324-30
 ;;9002226.02101,"1201,00440-8324-30 ",.02)
 ;;00440-8324-30
 ;;9002226.02101,"1201,00440-8324-90 ",.01)
 ;;00440-8324-90
 ;;9002226.02101,"1201,00440-8324-90 ",.02)
 ;;00440-8324-90
 ;;9002226.02101,"1201,00591-0013-10 ",.01)
 ;;00591-0013-10
 ;;9002226.02101,"1201,00591-0013-10 ",.02)
 ;;00591-0013-10
 ;;9002226.02101,"1201,00591-0013-19 ",.01)
 ;;00591-0013-19
 ;;9002226.02101,"1201,00591-0013-19 ",.02)
 ;;00591-0013-19
 ;;9002226.02101,"1201,00591-0014-10 ",.01)
 ;;00591-0014-10
 ;;9002226.02101,"1201,00591-0014-10 ",.02)
 ;;00591-0014-10
 ;;9002226.02101,"1201,00591-0014-19 ",.01)
 ;;00591-0014-19
 ;;9002226.02101,"1201,00591-0014-19 ",.02)
 ;;00591-0014-19
 ;;9002226.02101,"1201,00591-0016-10 ",.01)
 ;;00591-0016-10
 ;;9002226.02101,"1201,00591-0016-10 ",.02)
 ;;00591-0016-10
 ;;9002226.02101,"1201,00591-0016-19 ",.01)
 ;;00591-0016-19
 ;;9002226.02101,"1201,00591-0016-19 ",.02)
 ;;00591-0016-19
 ;;9002226.02101,"1201,00591-0019-05 ",.01)
 ;;00591-0019-05
 ;;9002226.02101,"1201,00591-0019-05 ",.02)
 ;;00591-0019-05
 ;;9002226.02101,"1201,00591-0019-19 ",.01)
 ;;00591-0019-19
 ;;9002226.02101,"1201,00591-0019-19 ",.02)
 ;;00591-0019-19
 ;;9002226.02101,"1201,00591-3774-10 ",.01)
 ;;00591-3774-10
 ;;9002226.02101,"1201,00591-3774-10 ",.02)
 ;;00591-3774-10
 ;;9002226.02101,"1201,00591-3774-19 ",.01)
 ;;00591-3774-19
 ;;9002226.02101,"1201,00591-3774-19 ",.02)
 ;;00591-3774-19
 ;;9002226.02101,"1201,00591-3775-10 ",.01)
 ;;00591-3775-10
 ;;9002226.02101,"1201,00591-3775-10 ",.02)
 ;;00591-3775-10
 ;;9002226.02101,"1201,00591-3775-19 ",.01)
 ;;00591-3775-19
 ;;9002226.02101,"1201,00591-3775-19 ",.02)
 ;;00591-3775-19
 ;;9002226.02101,"1201,00591-3776-05 ",.01)
 ;;00591-3776-05
 ;;9002226.02101,"1201,00591-3776-05 ",.02)
 ;;00591-3776-05
 ;;9002226.02101,"1201,00591-3776-19 ",.01)
 ;;00591-3776-19
 ;;9002226.02101,"1201,00591-3776-19 ",.02)
 ;;00591-3776-19
 ;;9002226.02101,"1201,00591-3777-05 ",.01)
 ;;00591-3777-05
 ;;9002226.02101,"1201,00591-3777-05 ",.02)
 ;;00591-3777-05
 ;;9002226.02101,"1201,00591-3777-19 ",.01)
 ;;00591-3777-19
 ;;9002226.02101,"1201,00591-3777-19 ",.02)
 ;;00591-3777-19
 ;;9002226.02101,"1201,00781-1210-10 ",.01)
 ;;00781-1210-10
 ;;9002226.02101,"1201,00781-1210-10 ",.02)
 ;;00781-1210-10
 ;;9002226.02101,"1201,00781-1210-60 ",.01)
 ;;00781-1210-60
 ;;9002226.02101,"1201,00781-1210-60 ",.02)
 ;;00781-1210-60
 ;;9002226.02101,"1201,00781-1213-10 ",.01)
 ;;00781-1213-10
 ;;9002226.02101,"1201,00781-1213-10 ",.02)
 ;;00781-1213-10
 ;;9002226.02101,"1201,00781-1213-60 ",.01)
 ;;00781-1213-60
 ;;9002226.02101,"1201,00781-1213-60 ",.02)
 ;;00781-1213-60
 ;;9002226.02101,"1201,00781-1323-05 ",.01)
 ;;00781-1323-05
 ;;9002226.02101,"1201,00781-1323-05 ",.02)
 ;;00781-1323-05
 ;;9002226.02101,"1201,00781-1323-60 ",.01)
 ;;00781-1323-60
 ;;9002226.02101,"1201,00781-1323-60 ",.02)
 ;;00781-1323-60
 ;;9002226.02101,"1201,00781-5070-31 ",.01)
 ;;00781-5070-31
 ;;9002226.02101,"1201,00781-5070-31 ",.02)
 ;;00781-5070-31
 ;;9002226.02101,"1201,00781-5070-92 ",.01)
 ;;00781-5070-92
 ;;9002226.02101,"1201,00781-5070-92 ",.02)
 ;;00781-5070-92
 ;;9002226.02101,"1201,00781-5071-31 ",.01)
 ;;00781-5071-31
 ;;9002226.02101,"1201,00781-5071-31 ",.02)
 ;;00781-5071-31
 ;;9002226.02101,"1201,00781-5071-92 ",.01)
 ;;00781-5071-92
 ;;9002226.02101,"1201,00781-5071-92 ",.02)
 ;;00781-5071-92
 ;;9002226.02101,"1201,00781-5072-31 ",.01)
 ;;00781-5072-31
 ;;9002226.02101,"1201,00781-5072-31 ",.02)
 ;;00781-5072-31
 ;;9002226.02101,"1201,00781-5072-92 ",.01)
 ;;00781-5072-92
 ;;9002226.02101,"1201,00781-5072-92 ",.02)
 ;;00781-5072-92
 ;;9002226.02101,"1201,00781-5073-31 ",.01)
 ;;00781-5073-31
 ;;9002226.02101,"1201,00781-5073-31 ",.02)
 ;;00781-5073-31
 ;;9002226.02101,"1201,00781-5073-92 ",.01)
 ;;00781-5073-92
 ;;9002226.02101,"1201,00781-5073-92 ",.02)
 ;;00781-5073-92
 ;;9002226.02101,"1201,00781-5074-31 ",.01)
 ;;00781-5074-31
 ;;9002226.02101,"1201,00781-5074-31 ",.02)
 ;;00781-5074-31
 ;;9002226.02101,"1201,00781-5074-92 ",.01)
 ;;00781-5074-92
 ;;9002226.02101,"1201,00781-5074-92 ",.02)
 ;;00781-5074-92
 ;;9002226.02101,"1201,00781-5231-10 ",.01)
 ;;00781-5231-10
 ;;9002226.02101,"1201,00781-5231-10 ",.02)
 ;;00781-5231-10
 ;;9002226.02101,"1201,00781-5231-92 ",.01)
 ;;00781-5231-92
 ;;9002226.02101,"1201,00781-5231-92 ",.02)
 ;;00781-5231-92
 ;;9002226.02101,"1201,00781-5232-10 ",.01)
 ;;00781-5232-10
 ;;9002226.02101,"1201,00781-5232-10 ",.02)
 ;;00781-5232-10
 ;;9002226.02101,"1201,00781-5232-92 ",.01)
 ;;00781-5232-92
 ;;9002226.02101,"1201,00781-5232-92 ",.02)
 ;;00781-5232-92
 ;;9002226.02101,"1201,00781-5234-10 ",.01)
 ;;00781-5234-10
 ;;9002226.02101,"1201,00781-5234-10 ",.02)
 ;;00781-5234-10
 ;;9002226.02101,"1201,00781-5234-92 ",.01)
 ;;00781-5234-92
 ;;9002226.02101,"1201,00781-5234-92 ",.02)
 ;;00781-5234-92
 ;;9002226.02101,"1201,00781-5381-92 ",.01)
 ;;00781-5381-92
 ;;9002226.02101,"1201,00781-5381-92 ",.02)
 ;;00781-5381-92
 ;;9002226.02101,"1201,00781-5382-92 ",.01)
 ;;00781-5382-92