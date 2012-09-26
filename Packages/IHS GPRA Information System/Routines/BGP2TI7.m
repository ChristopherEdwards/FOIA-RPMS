BGP2TI7 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1201,00247-1130-30 ",.02)
 ;;00247-1130-30
 ;;9002226.02101,"1201,00247-1130-60 ",.01)
 ;;00247-1130-60
 ;;9002226.02101,"1201,00247-1130-60 ",.02)
 ;;00247-1130-60
 ;;9002226.02101,"1201,00247-1139-30 ",.01)
 ;;00247-1139-30
 ;;9002226.02101,"1201,00247-1139-30 ",.02)
 ;;00247-1139-30
 ;;9002226.02101,"1201,00247-1139-60 ",.01)
 ;;00247-1139-60
 ;;9002226.02101,"1201,00247-1139-60 ",.02)
 ;;00247-1139-60
 ;;9002226.02101,"1201,00247-1140-30 ",.01)
 ;;00247-1140-30
 ;;9002226.02101,"1201,00247-1140-30 ",.02)
 ;;00247-1140-30
 ;;9002226.02101,"1201,00247-1140-60 ",.01)
 ;;00247-1140-60
 ;;9002226.02101,"1201,00247-1140-60 ",.02)
 ;;00247-1140-60
 ;;9002226.02101,"1201,00247-1152-30 ",.01)
 ;;00247-1152-30
 ;;9002226.02101,"1201,00247-1152-30 ",.02)
 ;;00247-1152-30
 ;;9002226.02101,"1201,00247-1152-60 ",.01)
 ;;00247-1152-60
 ;;9002226.02101,"1201,00247-1152-60 ",.02)
 ;;00247-1152-60
 ;;9002226.02101,"1201,00247-1153-30 ",.01)
 ;;00247-1153-30
 ;;9002226.02101,"1201,00247-1153-30 ",.02)
 ;;00247-1153-30
 ;;9002226.02101,"1201,00247-1153-60 ",.01)
 ;;00247-1153-60
 ;;9002226.02101,"1201,00247-1153-60 ",.02)
 ;;00247-1153-60
 ;;9002226.02101,"1201,00247-1276-30 ",.01)
 ;;00247-1276-30
 ;;9002226.02101,"1201,00247-1276-30 ",.02)
 ;;00247-1276-30
 ;;9002226.02101,"1201,00310-0751-39 ",.01)
 ;;00310-0751-39
 ;;9002226.02101,"1201,00310-0751-39 ",.02)
 ;;00310-0751-39
 ;;9002226.02101,"1201,00310-0751-90 ",.01)
 ;;00310-0751-90
 ;;9002226.02101,"1201,00310-0751-90 ",.02)
 ;;00310-0751-90
 ;;9002226.02101,"1201,00310-0752-39 ",.01)
 ;;00310-0752-39
 ;;9002226.02101,"1201,00310-0752-39 ",.02)
 ;;00310-0752-39
 ;;9002226.02101,"1201,00310-0752-90 ",.01)
 ;;00310-0752-90
 ;;9002226.02101,"1201,00310-0752-90 ",.02)
 ;;00310-0752-90
 ;;9002226.02101,"1201,00310-0754-30 ",.01)
 ;;00310-0754-30
 ;;9002226.02101,"1201,00310-0754-30 ",.02)
 ;;00310-0754-30
 ;;9002226.02101,"1201,00310-0755-90 ",.01)
 ;;00310-0755-90
 ;;9002226.02101,"1201,00310-0755-90 ",.02)
 ;;00310-0755-90
 ;;9002226.02101,"1201,00378-0552-77 ",.01)
 ;;00378-0552-77
 ;;9002226.02101,"1201,00378-0552-77 ",.02)
 ;;00378-0552-77
 ;;9002226.02101,"1201,00378-0553-77 ",.01)
 ;;00378-0553-77
 ;;9002226.02101,"1201,00378-0553-77 ",.02)
 ;;00378-0553-77
 ;;9002226.02101,"1201,00378-0554-77 ",.01)
 ;;00378-0554-77
 ;;9002226.02101,"1201,00378-0554-77 ",.02)
 ;;00378-0554-77
 ;;9002226.02101,"1201,00378-0557-77 ",.01)
 ;;00378-0557-77
 ;;9002226.02101,"1201,00378-0557-77 ",.02)
 ;;00378-0557-77
 ;;9002226.02101,"1201,00378-6161-77 ",.01)
 ;;00378-6161-77
 ;;9002226.02101,"1201,00378-6161-77 ",.02)
 ;;00378-6161-77
 ;;9002226.02101,"1201,00378-6162-77 ",.01)
 ;;00378-6162-77
 ;;9002226.02101,"1201,00378-6162-77 ",.02)
 ;;00378-6162-77
 ;;9002226.02101,"1201,00378-6163-77 ",.01)
 ;;00378-6163-77
 ;;9002226.02101,"1201,00378-6163-77 ",.02)
 ;;00378-6163-77
 ;;9002226.02101,"1201,00378-6164-05 ",.01)
 ;;00378-6164-05
 ;;9002226.02101,"1201,00378-6164-05 ",.02)
 ;;00378-6164-05
 ;;9002226.02101,"1201,00378-6164-77 ",.01)
 ;;00378-6164-77
 ;;9002226.02101,"1201,00378-6164-77 ",.02)
 ;;00378-6164-77
 ;;9002226.02101,"1201,00378-6165-05 ",.01)
 ;;00378-6165-05
 ;;9002226.02101,"1201,00378-6165-05 ",.02)
 ;;00378-6165-05
 ;;9002226.02101,"1201,00378-6165-77 ",.01)
 ;;00378-6165-77
 ;;9002226.02101,"1201,00378-6165-77 ",.02)
 ;;00378-6165-77
 ;;9002226.02101,"1201,00378-6166-05 ",.01)
 ;;00378-6166-05
 ;;9002226.02101,"1201,00378-6166-05 ",.02)
 ;;00378-6166-05
 ;;9002226.02101,"1201,00378-6166-77 ",.01)
 ;;00378-6166-77
 ;;9002226.02101,"1201,00378-6166-77 ",.02)
 ;;00378-6166-77
 ;;9002226.02101,"1201,00378-6167-77 ",.01)
 ;;00378-6167-77
 ;;9002226.02101,"1201,00378-6167-77 ",.02)
 ;;00378-6167-77
 ;;9002226.02101,"1201,00378-6168-05 ",.01)
 ;;00378-6168-05
 ;;9002226.02101,"1201,00378-6168-05 ",.02)
 ;;00378-6168-05
 ;;9002226.02101,"1201,00378-6168-77 ",.01)
 ;;00378-6168-77
 ;;9002226.02101,"1201,00378-6168-77 ",.02)
 ;;00378-6168-77
 ;;9002226.02101,"1201,00378-6169-05 ",.01)
 ;;00378-6169-05
 ;;9002226.02101,"1201,00378-6169-05 ",.02)
 ;;00378-6169-05
 ;;9002226.02101,"1201,00378-6169-77 ",.01)
 ;;00378-6169-77
 ;;9002226.02101,"1201,00378-6169-77 ",.02)
 ;;00378-6169-77
 ;;9002226.02101,"1201,00378-6170-05 ",.01)
 ;;00378-6170-05
 ;;9002226.02101,"1201,00378-6170-05 ",.02)
 ;;00378-6170-05
 ;;9002226.02101,"1201,00378-6170-77 ",.01)
 ;;00378-6170-77
 ;;9002226.02101,"1201,00378-6170-77 ",.02)
 ;;00378-6170-77
 ;;9002226.02101,"1201,00378-6171-77 ",.01)
 ;;00378-6171-77
 ;;9002226.02101,"1201,00378-6171-77 ",.02)
 ;;00378-6171-77
 ;;9002226.02101,"1201,00378-6510-91 ",.01)
 ;;00378-6510-91
 ;;9002226.02101,"1201,00378-6510-91 ",.02)
 ;;00378-6510-91
 ;;9002226.02101,"1201,00378-6520-05 ",.01)
 ;;00378-6520-05
 ;;9002226.02101,"1201,00378-6520-05 ",.02)
 ;;00378-6520-05
 ;;9002226.02101,"1201,00378-6520-91 ",.01)
 ;;00378-6520-91
 ;;9002226.02101,"1201,00378-6520-91 ",.02)
 ;;00378-6520-91
 ;;9002226.02101,"1201,00378-6540-05 ",.01)
 ;;00378-6540-05
 ;;9002226.02101,"1201,00378-6540-05 ",.02)
 ;;00378-6540-05
 ;;9002226.02101,"1201,00378-6540-91 ",.01)
 ;;00378-6540-91
 ;;9002226.02101,"1201,00378-6540-91 ",.02)
 ;;00378-6540-91
 ;;9002226.02101,"1201,00378-8210-10 ",.01)
 ;;00378-8210-10
 ;;9002226.02101,"1201,00378-8210-10 ",.02)
 ;;00378-8210-10
 ;;9002226.02101,"1201,00378-8210-77 ",.01)
 ;;00378-8210-77
 ;;9002226.02101,"1201,00378-8210-77 ",.02)
 ;;00378-8210-77
 ;;9002226.02101,"1201,00378-8220-10 ",.01)
 ;;00378-8220-10
 ;;9002226.02101,"1201,00378-8220-10 ",.02)
 ;;00378-8220-10
 ;;9002226.02101,"1201,00378-8220-77 ",.01)
 ;;00378-8220-77
 ;;9002226.02101,"1201,00378-8220-77 ",.02)
 ;;00378-8220-77
 ;;9002226.02101,"1201,00378-8240-10 ",.01)
 ;;00378-8240-10
 ;;9002226.02101,"1201,00378-8240-10 ",.02)
 ;;00378-8240-10
 ;;9002226.02101,"1201,00378-8240-77 ",.01)
 ;;00378-8240-77
 ;;9002226.02101,"1201,00378-8240-77 ",.02)
 ;;00378-8240-77
 ;;9002226.02101,"1201,00378-8280-05 ",.01)
 ;;00378-8280-05
 ;;9002226.02101,"1201,00378-8280-05 ",.02)
 ;;00378-8280-05
 ;;9002226.02101,"1201,00378-8280-77 ",.01)
 ;;00378-8280-77
 ;;9002226.02101,"1201,00378-8280-77 ",.02)
 ;;00378-8280-77
 ;;9002226.02101,"1201,00406-2065-03 ",.01)
 ;;00406-2065-03
 ;;9002226.02101,"1201,00406-2065-03 ",.02)
 ;;00406-2065-03
 ;;9002226.02101,"1201,00406-2065-05 ",.01)
 ;;00406-2065-05
 ;;9002226.02101,"1201,00406-2065-05 ",.02)
 ;;00406-2065-05
 ;;9002226.02101,"1201,00406-2065-10 ",.01)
 ;;00406-2065-10
 ;;9002226.02101,"1201,00406-2065-10 ",.02)
 ;;00406-2065-10
 ;;9002226.02101,"1201,00406-2065-60 ",.01)
 ;;00406-2065-60
 ;;9002226.02101,"1201,00406-2065-60 ",.02)
 ;;00406-2065-60
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
