BGP50M7 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 06, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1201,00093-0928-10 ",.01)
 ;;00093-0928-10
 ;;9002226.02101,"1201,00093-0928-10 ",.02)
 ;;00093-0928-10
 ;;9002226.02101,"1201,00093-0928-19 ",.01)
 ;;00093-0928-19
 ;;9002226.02101,"1201,00093-0928-19 ",.02)
 ;;00093-0928-19
 ;;9002226.02101,"1201,00093-0928-93 ",.01)
 ;;00093-0928-93
 ;;9002226.02101,"1201,00093-0928-93 ",.02)
 ;;00093-0928-93
 ;;9002226.02101,"1201,00093-7152-19 ",.01)
 ;;00093-7152-19
 ;;9002226.02101,"1201,00093-7152-19 ",.02)
 ;;00093-7152-19
 ;;9002226.02101,"1201,00093-7152-56 ",.01)
 ;;00093-7152-56
 ;;9002226.02101,"1201,00093-7152-56 ",.02)
 ;;00093-7152-56
 ;;9002226.02101,"1201,00093-7152-93 ",.01)
 ;;00093-7152-93
 ;;9002226.02101,"1201,00093-7152-93 ",.02)
 ;;00093-7152-93
 ;;9002226.02101,"1201,00093-7152-98 ",.01)
 ;;00093-7152-98
 ;;9002226.02101,"1201,00093-7152-98 ",.02)
 ;;00093-7152-98
 ;;9002226.02101,"1201,00093-7153-10 ",.01)
 ;;00093-7153-10
 ;;9002226.02101,"1201,00093-7153-10 ",.02)
 ;;00093-7153-10
 ;;9002226.02101,"1201,00093-7153-19 ",.01)
 ;;00093-7153-19
 ;;9002226.02101,"1201,00093-7153-19 ",.02)
 ;;00093-7153-19
 ;;9002226.02101,"1201,00093-7153-56 ",.01)
 ;;00093-7153-56
 ;;9002226.02101,"1201,00093-7153-56 ",.02)
 ;;00093-7153-56
 ;;9002226.02101,"1201,00093-7153-93 ",.01)
 ;;00093-7153-93
 ;;9002226.02101,"1201,00093-7153-93 ",.02)
 ;;00093-7153-93
 ;;9002226.02101,"1201,00093-7153-98 ",.01)
 ;;00093-7153-98
 ;;9002226.02101,"1201,00093-7153-98 ",.02)
 ;;00093-7153-98
 ;;9002226.02101,"1201,00093-7154-10 ",.01)
 ;;00093-7154-10
 ;;9002226.02101,"1201,00093-7154-10 ",.02)
 ;;00093-7154-10
 ;;9002226.02101,"1201,00093-7154-19 ",.01)
 ;;00093-7154-19
 ;;9002226.02101,"1201,00093-7154-19 ",.02)
 ;;00093-7154-19
 ;;9002226.02101,"1201,00093-7154-56 ",.01)
 ;;00093-7154-56
 ;;9002226.02101,"1201,00093-7154-56 ",.02)
 ;;00093-7154-56
 ;;9002226.02101,"1201,00093-7154-93 ",.01)
 ;;00093-7154-93
 ;;9002226.02101,"1201,00093-7154-93 ",.02)
 ;;00093-7154-93
 ;;9002226.02101,"1201,00093-7154-98 ",.01)
 ;;00093-7154-98
 ;;9002226.02101,"1201,00093-7154-98 ",.02)
 ;;00093-7154-98
 ;;9002226.02101,"1201,00093-7155-10 ",.01)
 ;;00093-7155-10
 ;;9002226.02101,"1201,00093-7155-10 ",.02)
 ;;00093-7155-10
 ;;9002226.02101,"1201,00093-7155-19 ",.01)
 ;;00093-7155-19
 ;;9002226.02101,"1201,00093-7155-19 ",.02)
 ;;00093-7155-19
 ;;9002226.02101,"1201,00093-7155-56 ",.01)
 ;;00093-7155-56
 ;;9002226.02101,"1201,00093-7155-56 ",.02)
 ;;00093-7155-56
 ;;9002226.02101,"1201,00093-7155-93 ",.01)
 ;;00093-7155-93
 ;;9002226.02101,"1201,00093-7155-93 ",.02)
 ;;00093-7155-93
 ;;9002226.02101,"1201,00093-7155-98 ",.01)
 ;;00093-7155-98
 ;;9002226.02101,"1201,00093-7155-98 ",.02)
 ;;00093-7155-98
 ;;9002226.02101,"1201,00093-7156-10 ",.01)
 ;;00093-7156-10
 ;;9002226.02101,"1201,00093-7156-10 ",.02)
 ;;00093-7156-10
 ;;9002226.02101,"1201,00093-7156-19 ",.01)
 ;;00093-7156-19
 ;;9002226.02101,"1201,00093-7156-19 ",.02)
 ;;00093-7156-19
 ;;9002226.02101,"1201,00093-7156-56 ",.01)
 ;;00093-7156-56
 ;;9002226.02101,"1201,00093-7156-56 ",.02)
 ;;00093-7156-56
 ;;9002226.02101,"1201,00093-7156-93 ",.01)
 ;;00093-7156-93
 ;;9002226.02101,"1201,00093-7156-93 ",.02)
 ;;00093-7156-93
 ;;9002226.02101,"1201,00093-7156-98 ",.01)
 ;;00093-7156-98
 ;;9002226.02101,"1201,00093-7156-98 ",.02)
 ;;00093-7156-98
 ;;9002226.02101,"1201,00093-7201-10 ",.01)
 ;;00093-7201-10
 ;;9002226.02101,"1201,00093-7201-10 ",.02)
 ;;00093-7201-10
 ;;9002226.02101,"1201,00093-7201-98 ",.01)
 ;;00093-7201-98
 ;;9002226.02101,"1201,00093-7201-98 ",.02)
 ;;00093-7201-98
 ;;9002226.02101,"1201,00093-7202-10 ",.01)
 ;;00093-7202-10
 ;;9002226.02101,"1201,00093-7202-10 ",.02)
 ;;00093-7202-10
 ;;9002226.02101,"1201,00093-7202-98 ",.01)
 ;;00093-7202-98
 ;;9002226.02101,"1201,00093-7202-98 ",.02)
 ;;00093-7202-98
 ;;9002226.02101,"1201,00093-7270-10 ",.01)
 ;;00093-7270-10
 ;;9002226.02101,"1201,00093-7270-10 ",.02)
 ;;00093-7270-10
 ;;9002226.02101,"1201,00093-7270-98 ",.01)
 ;;00093-7270-98
 ;;9002226.02101,"1201,00093-7270-98 ",.02)
 ;;00093-7270-98
 ;;9002226.02101,"1201,00093-7442-01 ",.01)
 ;;00093-7442-01
 ;;9002226.02101,"1201,00093-7442-01 ",.02)
 ;;00093-7442-01
 ;;9002226.02101,"1201,00093-7442-56 ",.01)
 ;;00093-7442-56
 ;;9002226.02101,"1201,00093-7442-56 ",.02)
 ;;00093-7442-56
 ;;9002226.02101,"1201,00093-7443-01 ",.01)
 ;;00093-7443-01
 ;;9002226.02101,"1201,00093-7443-01 ",.02)
 ;;00093-7443-01
 ;;9002226.02101,"1201,00093-7443-56 ",.01)
 ;;00093-7443-56
 ;;9002226.02101,"1201,00093-7443-56 ",.02)
 ;;00093-7443-56
 ;;9002226.02101,"1201,00179-0128-80 ",.01)
 ;;00179-0128-80
 ;;9002226.02101,"1201,00179-0128-80 ",.02)
 ;;00179-0128-80
 ;;9002226.02101,"1201,00179-0141-45 ",.01)
 ;;00179-0141-45
 ;;9002226.02101,"1201,00179-0141-45 ",.02)
 ;;00179-0141-45
 ;;9002226.02101,"1201,00185-0070-01 ",.01)
 ;;00185-0070-01
 ;;9002226.02101,"1201,00185-0070-01 ",.02)
 ;;00185-0070-01
 ;;9002226.02101,"1201,00185-0070-05 ",.01)
 ;;00185-0070-05
 ;;9002226.02101,"1201,00185-0070-05 ",.02)
 ;;00185-0070-05
 ;;9002226.02101,"1201,00185-0070-10 ",.01)
 ;;00185-0070-10
 ;;9002226.02101,"1201,00185-0070-10 ",.02)
 ;;00185-0070-10
 ;;9002226.02101,"1201,00185-0070-60 ",.01)
 ;;00185-0070-60
 ;;9002226.02101,"1201,00185-0070-60 ",.02)
 ;;00185-0070-60
 ;;9002226.02101,"1201,00185-0072-01 ",.01)
 ;;00185-0072-01
 ;;9002226.02101,"1201,00185-0072-01 ",.02)
 ;;00185-0072-01
 ;;9002226.02101,"1201,00185-0072-10 ",.01)
 ;;00185-0072-10
 ;;9002226.02101,"1201,00185-0072-10 ",.02)
 ;;00185-0072-10
 ;;9002226.02101,"1201,00185-0072-60 ",.01)
 ;;00185-0072-60
 ;;9002226.02101,"1201,00185-0072-60 ",.02)
 ;;00185-0072-60
 ;;9002226.02101,"1201,00185-0074-01 ",.01)
 ;;00185-0074-01
 ;;9002226.02101,"1201,00185-0074-01 ",.02)
 ;;00185-0074-01
 ;;9002226.02101,"1201,00185-0074-10 ",.01)
 ;;00185-0074-10
 ;;9002226.02101,"1201,00185-0074-10 ",.02)
 ;;00185-0074-10
 ;;9002226.02101,"1201,00185-0074-60 ",.01)
 ;;00185-0074-60
 ;;9002226.02101,"1201,00185-0074-60 ",.02)
 ;;00185-0074-60
 ;;9002226.02101,"1201,00228-2634-06 ",.01)
 ;;00228-2634-06
 ;;9002226.02101,"1201,00228-2634-06 ",.02)
 ;;00228-2634-06
 ;;9002226.02101,"1201,00228-2634-50 ",.01)
 ;;00228-2634-50
 ;;9002226.02101,"1201,00228-2634-50 ",.02)
 ;;00228-2634-50
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
 ;;9002226.02101,"1201,00378-2015-05 ",.01)
 ;;00378-2015-05
 ;;9002226.02101,"1201,00378-2015-05 ",.02)
 ;;00378-2015-05
 ;;9002226.02101,"1201,00378-2015-77 ",.01)
 ;;00378-2015-77
 ;;9002226.02101,"1201,00378-2015-77 ",.02)
 ;;00378-2015-77
 ;;9002226.02101,"1201,00378-2017-05 ",.01)
 ;;00378-2017-05
 ;;9002226.02101,"1201,00378-2017-05 ",.02)
 ;;00378-2017-05
 ;;9002226.02101,"1201,00378-2017-77 ",.01)
 ;;00378-2017-77
 ;;9002226.02101,"1201,00378-2017-77 ",.02)
 ;;00378-2017-77
 ;;9002226.02101,"1201,00378-2121-05 ",.01)
 ;;00378-2121-05
 ;;9002226.02101,"1201,00378-2121-05 ",.02)
 ;;00378-2121-05
 ;;9002226.02101,"1201,00378-2121-77 ",.01)
 ;;00378-2121-77
 ;;9002226.02101,"1201,00378-2121-77 ",.02)
 ;;00378-2121-77
 ;;9002226.02101,"1201,00378-2122-05 ",.01)
 ;;00378-2122-05
 ;;9002226.02101,"1201,00378-2122-05 ",.02)
 ;;00378-2122-05
 ;;9002226.02101,"1201,00378-2122-77 ",.01)
 ;;00378-2122-77
 ;;9002226.02101,"1201,00378-2122-77 ",.02)
 ;;00378-2122-77
 ;;9002226.02101,"1201,00378-3950-05 ",.01)
 ;;00378-3950-05
 ;;9002226.02101,"1201,00378-3950-05 ",.02)
 ;;00378-3950-05
 ;;9002226.02101,"1201,00378-3950-77 ",.01)
 ;;00378-3950-77
 ;;9002226.02101,"1201,00378-3950-77 ",.02)
 ;;00378-3950-77
 ;;9002226.02101,"1201,00378-3951-05 ",.01)
 ;;00378-3951-05
 ;;9002226.02101,"1201,00378-3951-05 ",.02)
 ;;00378-3951-05
 ;;9002226.02101,"1201,00378-3951-77 ",.01)
 ;;00378-3951-77
 ;;9002226.02101,"1201,00378-3951-77 ",.02)
 ;;00378-3951-77
 ;;9002226.02101,"1201,00378-3952-05 ",.01)
 ;;00378-3952-05
 ;;9002226.02101,"1201,00378-3952-05 ",.02)
 ;;00378-3952-05
 ;;9002226.02101,"1201,00378-3952-77 ",.01)
 ;;00378-3952-77
 ;;9002226.02101,"1201,00378-3952-77 ",.02)
 ;;00378-3952-77
 ;;9002226.02101,"1201,00378-3953-05 ",.01)
 ;;00378-3953-05
 ;;9002226.02101,"1201,00378-3953-05 ",.02)
 ;;00378-3953-05
 ;;9002226.02101,"1201,00378-3953-77 ",.01)
 ;;00378-3953-77
 ;;9002226.02101,"1201,00378-3953-77 ",.02)
 ;;00378-3953-77
 ;;9002226.02101,"1201,00378-4513-05 ",.01)
 ;;00378-4513-05
 ;;9002226.02101,"1201,00378-4513-05 ",.02)
 ;;00378-4513-05
 ;;9002226.02101,"1201,00378-4514-05 ",.01)
 ;;00378-4514-05
 ;;9002226.02101,"1201,00378-4514-05 ",.02)
 ;;00378-4514-05
 ;;9002226.02101,"1201,00378-4514-93 ",.01)
 ;;00378-4514-93
 ;;9002226.02101,"1201,00378-4514-93 ",.02)
 ;;00378-4514-93
 ;;9002226.02101,"1201,00378-4518-93 ",.01)
 ;;00378-4518-93
 ;;9002226.02101,"1201,00378-4518-93 ",.02)
 ;;00378-4518-93
 ;;9002226.02101,"1201,00378-4519-93 ",.01)
 ;;00378-4519-93
 ;;9002226.02101,"1201,00378-4519-93 ",.02)
 ;;00378-4519-93
 ;;9002226.02101,"1201,00378-4520-93 ",.01)
 ;;00378-4520-93
 ;;9002226.02101,"1201,00378-4520-93 ",.02)
 ;;00378-4520-93
 ;;9002226.02101,"1201,00378-6161-77 ",.01)
 ;;00378-6161-77
 ;;9002226.02101,"1201,00378-6161-77 ",.02)
 ;;00378-6161-77
 ;;9002226.02101,"1201,00378-6161-93 ",.01)
 ;;00378-6161-93
 ;;9002226.02101,"1201,00378-6161-93 ",.02)
 ;;00378-6161-93
 ;;9002226.02101,"1201,00378-6162-77 ",.01)
 ;;00378-6162-77
 ;;9002226.02101,"1201,00378-6162-77 ",.02)
 ;;00378-6162-77
 ;;9002226.02101,"1201,00378-6162-93 ",.01)
 ;;00378-6162-93
 ;;9002226.02101,"1201,00378-6162-93 ",.02)
 ;;00378-6162-93
 ;;9002226.02101,"1201,00378-6163-77 ",.01)
 ;;00378-6163-77
 ;;9002226.02101,"1201,00378-6163-77 ",.02)
 ;;00378-6163-77
 ;;9002226.02101,"1201,00378-6163-93 ",.01)
 ;;00378-6163-93
 ;;9002226.02101,"1201,00378-6163-93 ",.02)
 ;;00378-6163-93
 ;;9002226.02101,"1201,00378-6164-05 ",.01)
 ;;00378-6164-05
 ;;9002226.02101,"1201,00378-6164-05 ",.02)
 ;;00378-6164-05
 ;;9002226.02101,"1201,00378-6164-77 ",.01)
 ;;00378-6164-77
 ;;9002226.02101,"1201,00378-6164-77 ",.02)
 ;;00378-6164-77
 ;;9002226.02101,"1201,00378-6164-93 ",.01)
 ;;00378-6164-93
 ;;9002226.02101,"1201,00378-6164-93 ",.02)
 ;;00378-6164-93
 ;;9002226.02101,"1201,00378-6165-05 ",.01)
 ;;00378-6165-05
 ;;9002226.02101,"1201,00378-6165-05 ",.02)
 ;;00378-6165-05
 ;;9002226.02101,"1201,00378-6165-77 ",.01)
 ;;00378-6165-77
 ;;9002226.02101,"1201,00378-6165-77 ",.02)
 ;;00378-6165-77
 ;;9002226.02101,"1201,00378-6165-93 ",.01)
 ;;00378-6165-93
 ;;9002226.02101,"1201,00378-6165-93 ",.02)
 ;;00378-6165-93
 ;;9002226.02101,"1201,00378-6166-05 ",.01)
 ;;00378-6166-05
 ;;9002226.02101,"1201,00378-6166-05 ",.02)
 ;;00378-6166-05
 ;;9002226.02101,"1201,00378-6166-77 ",.01)
 ;;00378-6166-77
 ;;9002226.02101,"1201,00378-6166-77 ",.02)
 ;;00378-6166-77
 ;;9002226.02101,"1201,00378-6166-93 ",.01)
 ;;00378-6166-93
 ;;9002226.02101,"1201,00378-6166-93 ",.02)
 ;;00378-6166-93
 ;;9002226.02101,"1201,00378-6167-77 ",.01)
 ;;00378-6167-77
 ;;9002226.02101,"1201,00378-6167-77 ",.02)
 ;;00378-6167-77
 ;;9002226.02101,"1201,00378-6167-93 ",.01)
 ;;00378-6167-93
 ;;9002226.02101,"1201,00378-6167-93 ",.02)
 ;;00378-6167-93
 ;;9002226.02101,"1201,00378-6168-05 ",.01)
 ;;00378-6168-05
 ;;9002226.02101,"1201,00378-6168-05 ",.02)
 ;;00378-6168-05
 ;;9002226.02101,"1201,00378-6168-77 ",.01)
 ;;00378-6168-77
 ;;9002226.02101,"1201,00378-6168-77 ",.02)
 ;;00378-6168-77
 ;;9002226.02101,"1201,00378-6168-93 ",.01)
 ;;00378-6168-93
 ;;9002226.02101,"1201,00378-6168-93 ",.02)
 ;;00378-6168-93
 ;;9002226.02101,"1201,00378-6169-05 ",.01)
 ;;00378-6169-05
 ;;9002226.02101,"1201,00378-6169-05 ",.02)
 ;;00378-6169-05
 ;;9002226.02101,"1201,00378-6169-77 ",.01)
 ;;00378-6169-77
 ;;9002226.02101,"1201,00378-6169-77 ",.02)
 ;;00378-6169-77
 ;;9002226.02101,"1201,00378-6169-93 ",.01)
 ;;00378-6169-93
 ;;9002226.02101,"1201,00378-6169-93 ",.02)
 ;;00378-6169-93
 ;;9002226.02101,"1201,00378-6170-05 ",.01)
 ;;00378-6170-05
 ;;9002226.02101,"1201,00378-6170-05 ",.02)
 ;;00378-6170-05
 ;;9002226.02101,"1201,00378-6170-77 ",.01)
 ;;00378-6170-77
 ;;9002226.02101,"1201,00378-6170-77 ",.02)
 ;;00378-6170-77
 ;;9002226.02101,"1201,00378-6170-93 ",.01)
 ;;00378-6170-93
 ;;9002226.02101,"1201,00378-6170-93 ",.02)
 ;;00378-6170-93
 ;;9002226.02101,"1201,00378-6171-77 ",.01)
 ;;00378-6171-77