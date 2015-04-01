BGP47S9 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 16, 2014;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"804,00031-7449-70 ",.02)
 ;;00031-7449-70
 ;;9002226.02101,"804,00037-2001-01 ",.01)
 ;;00037-2001-01
 ;;9002226.02101,"804,00037-2001-01 ",.02)
 ;;00037-2001-01
 ;;9002226.02101,"804,00037-2001-03 ",.01)
 ;;00037-2001-03
 ;;9002226.02101,"804,00037-2001-03 ",.02)
 ;;00037-2001-03
 ;;9002226.02101,"804,00037-2001-85 ",.01)
 ;;00037-2001-85
 ;;9002226.02101,"804,00037-2001-85 ",.02)
 ;;00037-2001-85
 ;;9002226.02101,"804,00037-2103-01 ",.01)
 ;;00037-2103-01
 ;;9002226.02101,"804,00037-2103-01 ",.02)
 ;;00037-2103-01
 ;;9002226.02101,"804,00037-2103-03 ",.01)
 ;;00037-2103-03
 ;;9002226.02101,"804,00037-2103-03 ",.02)
 ;;00037-2103-03
 ;;9002226.02101,"804,00037-2103-85 ",.01)
 ;;00037-2103-85
 ;;9002226.02101,"804,00037-2103-85 ",.02)
 ;;00037-2103-85
 ;;9002226.02101,"804,00037-2250-10 ",.01)
 ;;00037-2250-10
 ;;9002226.02101,"804,00037-2250-10 ",.02)
 ;;00037-2250-10
 ;;9002226.02101,"804,00037-2250-30 ",.01)
 ;;00037-2250-30
 ;;9002226.02101,"804,00037-2250-30 ",.02)
 ;;00037-2250-30
 ;;9002226.02101,"804,00037-2403-01 ",.01)
 ;;00037-2403-01
 ;;9002226.02101,"804,00037-2403-01 ",.02)
 ;;00037-2403-01
 ;;9002226.02101,"804,00045-0325-60 ",.01)
 ;;00045-0325-60
 ;;9002226.02101,"804,00045-0325-60 ",.02)
 ;;00045-0325-60
 ;;9002226.02101,"804,00045-0325-70 ",.01)
 ;;00045-0325-70
 ;;9002226.02101,"804,00045-0325-70 ",.02)
 ;;00045-0325-70
 ;;9002226.02101,"804,00086-0062-10 ",.01)
 ;;00086-0062-10
 ;;9002226.02101,"804,00086-0062-10 ",.02)
 ;;00086-0062-10
 ;;9002226.02101,"804,00086-0062-50 ",.01)
 ;;00086-0062-50
 ;;9002226.02101,"804,00086-0062-50 ",.02)
 ;;00086-0062-50
 ;;9002226.02101,"804,00089-0221-10 ",.01)
 ;;00089-0221-10
 ;;9002226.02101,"804,00089-0221-10 ",.02)
 ;;00089-0221-10
 ;;9002226.02101,"804,00089-0231-10 ",.01)
 ;;00089-0231-10
 ;;9002226.02101,"804,00089-0231-10 ",.02)
 ;;00089-0231-10
 ;;9002226.02101,"804,00089-0233-10 ",.01)
 ;;00089-0233-10
 ;;9002226.02101,"804,00089-0233-10 ",.02)
 ;;00089-0233-10
 ;;9002226.02101,"804,00089-0540-06 ",.01)
 ;;00089-0540-06
 ;;9002226.02101,"804,00089-0540-06 ",.02)
 ;;00089-0540-06
 ;;9002226.02101,"804,00091-7429-63 ",.01)
 ;;00091-7429-63
 ;;9002226.02101,"804,00091-7429-63 ",.02)
 ;;00091-7429-63
 ;;9002226.02101,"804,00091-7449-63 ",.01)
 ;;00091-7449-63
 ;;9002226.02101,"804,00091-7449-63 ",.02)
 ;;00091-7449-63
 ;;9002226.02101,"804,00091-7449-70 ",.01)
 ;;00091-7449-70
 ;;9002226.02101,"804,00091-7449-70 ",.02)
 ;;00091-7449-70
 ;;9002226.02101,"804,00093-0542-01 ",.01)
 ;;00093-0542-01
 ;;9002226.02101,"804,00093-0542-01 ",.02)
 ;;00093-0542-01
 ;;9002226.02101,"804,00093-0542-05 ",.01)
 ;;00093-0542-05
 ;;9002226.02101,"804,00093-0542-05 ",.02)
 ;;00093-0542-05
 ;;9002226.02101,"804,00093-1919-19 ",.01)
 ;;00093-1919-19
 ;;9002226.02101,"804,00093-1919-19 ",.02)
 ;;00093-1919-19
 ;;9002226.02101,"804,00095-0150-06 ",.01)
 ;;00095-0150-06
 ;;9002226.02101,"804,00095-0150-06 ",.02)
 ;;00095-0150-06
 ;;9002226.02101,"804,00095-0300-06 ",.01)
 ;;00095-0300-06
 ;;9002226.02101,"804,00095-0300-06 ",.02)
 ;;00095-0300-06
 ;;9002226.02101,"804,00115-2011-01 ",.01)
 ;;00115-2011-01
 ;;9002226.02101,"804,00115-2011-01 ",.02)
 ;;00115-2011-01
 ;;9002226.02101,"804,00115-2011-02 ",.01)
 ;;00115-2011-02
 ;;9002226.02101,"804,00115-2011-02 ",.02)
 ;;00115-2011-02
 ;;9002226.02101,"804,00143-1176-01 ",.01)
 ;;00143-1176-01
 ;;9002226.02101,"804,00143-1176-01 ",.02)
 ;;00143-1176-01
 ;;9002226.02101,"804,00143-1176-05 ",.01)
 ;;00143-1176-05
 ;;9002226.02101,"804,00143-1176-05 ",.02)
 ;;00143-1176-05
 ;;9002226.02101,"804,00143-1176-10 ",.01)
 ;;00143-1176-10
 ;;9002226.02101,"804,00143-1176-10 ",.02)
 ;;00143-1176-10
 ;;9002226.02101,"804,00143-1290-01 ",.01)
 ;;00143-1290-01
 ;;9002226.02101,"804,00143-1290-01 ",.02)
 ;;00143-1290-01
 ;;9002226.02101,"804,00143-1290-05 ",.01)
 ;;00143-1290-05
 ;;9002226.02101,"804,00143-1290-05 ",.02)
 ;;00143-1290-05
 ;;9002226.02101,"804,00143-1292-01 ",.01)
 ;;00143-1292-01
 ;;9002226.02101,"804,00143-1292-01 ",.02)
 ;;00143-1292-01
 ;;9002226.02101,"804,00143-1292-05 ",.01)
 ;;00143-1292-05
 ;;9002226.02101,"804,00143-1292-05 ",.02)
 ;;00143-1292-05
 ;;9002226.02101,"804,00143-9749-01 ",.01)
 ;;00143-9749-01
 ;;9002226.02101,"804,00143-9749-01 ",.02)
 ;;00143-9749-01
 ;;9002226.02101,"804,00143-9749-05 ",.01)
 ;;00143-9749-05
 ;;9002226.02101,"804,00143-9749-05 ",.02)
 ;;00143-9749-05
 ;;9002226.02101,"804,00143-9749-10 ",.01)
 ;;00143-9749-10
 ;;9002226.02101,"804,00143-9749-10 ",.02)
 ;;00143-9749-10
 ;;9002226.02101,"804,00172-2813-60 ",.01)
 ;;00172-2813-60
 ;;9002226.02101,"804,00172-2813-60 ",.02)
 ;;00172-2813-60
 ;;9002226.02101,"804,00182-0573-89 ",.01)
 ;;00182-0573-89
 ;;9002226.02101,"804,00182-0573-89 ",.02)
 ;;00182-0573-89
 ;;9002226.02101,"804,00182-1919-00 ",.01)
 ;;00182-1919-00
 ;;9002226.02101,"804,00182-1919-00 ",.02)
 ;;00182-1919-00
 ;;9002226.02101,"804,00182-1919-89 ",.01)
 ;;00182-1919-89
 ;;9002226.02101,"804,00182-1919-89 ",.02)
 ;;00182-1919-89
 ;;9002226.02101,"804,00185-0022-01 ",.01)
 ;;00185-0022-01
 ;;9002226.02101,"804,00185-0022-01 ",.02)
 ;;00185-0022-01
 ;;9002226.02101,"804,00185-0022-10 ",.01)
 ;;00185-0022-10
 ;;9002226.02101,"804,00185-0022-10 ",.02)
 ;;00185-0022-10
 ;;9002226.02101,"804,00185-0448-01 ",.01)
 ;;00185-0448-01
 ;;9002226.02101,"804,00185-0448-01 ",.02)
 ;;00185-0448-01
 ;;9002226.02101,"804,00185-0448-10 ",.01)
 ;;00185-0448-10
 ;;9002226.02101,"804,00185-0448-10 ",.02)
 ;;00185-0448-10
 ;;9002226.02101,"804,00185-0713-01 ",.01)
 ;;00185-0713-01
 ;;9002226.02101,"804,00185-0713-01 ",.02)
 ;;00185-0713-01
 ;;9002226.02101,"804,00185-0713-05 ",.01)
 ;;00185-0713-05
 ;;9002226.02101,"804,00185-0713-05 ",.02)
 ;;00185-0713-05
 ;;9002226.02101,"804,00185-0714-01 ",.01)
 ;;00185-0714-01
 ;;9002226.02101,"804,00185-0714-01 ",.02)
 ;;00185-0714-01
 ;;9002226.02101,"804,00185-0724-01 ",.01)
 ;;00185-0724-01
 ;;9002226.02101,"804,00185-0724-01 ",.02)
 ;;00185-0724-01
 ;;9002226.02101,"804,00185-0724-05 ",.01)
 ;;00185-0724-05
 ;;9002226.02101,"804,00185-0724-05 ",.02)
 ;;00185-0724-05
 ;;9002226.02101,"804,00185-0749-01 ",.01)
 ;;00185-0749-01
 ;;9002226.02101,"804,00185-0749-01 ",.02)
 ;;00185-0749-01
 ;;9002226.02101,"804,00247-0013-00 ",.01)
 ;;00247-0013-00
 ;;9002226.02101,"804,00247-0013-00 ",.02)
 ;;00247-0013-00
 ;;9002226.02101,"804,00247-0013-03 ",.01)
 ;;00247-0013-03
 ;;9002226.02101,"804,00247-0013-03 ",.02)
 ;;00247-0013-03
 ;;9002226.02101,"804,00247-0013-06 ",.01)
 ;;00247-0013-06
 ;;9002226.02101,"804,00247-0013-06 ",.02)
 ;;00247-0013-06
 ;;9002226.02101,"804,00247-0013-07 ",.01)
 ;;00247-0013-07
 ;;9002226.02101,"804,00247-0013-07 ",.02)
 ;;00247-0013-07
 ;;9002226.02101,"804,00247-0013-08 ",.01)
 ;;00247-0013-08
 ;;9002226.02101,"804,00247-0013-08 ",.02)
 ;;00247-0013-08
 ;;9002226.02101,"804,00247-0013-09 ",.01)
 ;;00247-0013-09
 ;;9002226.02101,"804,00247-0013-09 ",.02)
 ;;00247-0013-09
 ;;9002226.02101,"804,00247-0013-15 ",.01)
 ;;00247-0013-15
 ;;9002226.02101,"804,00247-0013-15 ",.02)
 ;;00247-0013-15
 ;;9002226.02101,"804,00247-0013-18 ",.01)
 ;;00247-0013-18
 ;;9002226.02101,"804,00247-0013-18 ",.02)
 ;;00247-0013-18
 ;;9002226.02101,"804,00247-0013-20 ",.01)
 ;;00247-0013-20
 ;;9002226.02101,"804,00247-0013-20 ",.02)
 ;;00247-0013-20
 ;;9002226.02101,"804,00247-0013-21 ",.01)
 ;;00247-0013-21
 ;;9002226.02101,"804,00247-0013-21 ",.02)
 ;;00247-0013-21
 ;;9002226.02101,"804,00247-0013-25 ",.01)
 ;;00247-0013-25
 ;;9002226.02101,"804,00247-0013-25 ",.02)
 ;;00247-0013-25
 ;;9002226.02101,"804,00247-0013-28 ",.01)
 ;;00247-0013-28
 ;;9002226.02101,"804,00247-0013-28 ",.02)
 ;;00247-0013-28
 ;;9002226.02101,"804,00247-0013-30 ",.01)
 ;;00247-0013-30
 ;;9002226.02101,"804,00247-0013-30 ",.02)
 ;;00247-0013-30
 ;;9002226.02101,"804,00247-0013-40 ",.01)
 ;;00247-0013-40
 ;;9002226.02101,"804,00247-0013-40 ",.02)
 ;;00247-0013-40
 ;;9002226.02101,"804,00247-0013-60 ",.01)
 ;;00247-0013-60
 ;;9002226.02101,"804,00247-0013-60 ",.02)
 ;;00247-0013-60
 ;;9002226.02101,"804,00247-0013-98 ",.01)
 ;;00247-0013-98
 ;;9002226.02101,"804,00247-0013-98 ",.02)
 ;;00247-0013-98
 ;;9002226.02101,"804,00247-0088-00 ",.01)
 ;;00247-0088-00
 ;;9002226.02101,"804,00247-0088-00 ",.02)
 ;;00247-0088-00
 ;;9002226.02101,"804,00247-0088-02 ",.01)
 ;;00247-0088-02
 ;;9002226.02101,"804,00247-0088-02 ",.02)
 ;;00247-0088-02
 ;;9002226.02101,"804,00247-0088-04 ",.01)
 ;;00247-0088-04
 ;;9002226.02101,"804,00247-0088-04 ",.02)
 ;;00247-0088-04
 ;;9002226.02101,"804,00247-0088-07 ",.01)
 ;;00247-0088-07
 ;;9002226.02101,"804,00247-0088-07 ",.02)
 ;;00247-0088-07
 ;;9002226.02101,"804,00247-0088-14 ",.01)
 ;;00247-0088-14
 ;;9002226.02101,"804,00247-0088-14 ",.02)
 ;;00247-0088-14
 ;;9002226.02101,"804,00247-0088-15 ",.01)
 ;;00247-0088-15
 ;;9002226.02101,"804,00247-0088-15 ",.02)
 ;;00247-0088-15
 ;;9002226.02101,"804,00247-0088-16 ",.01)
 ;;00247-0088-16
 ;;9002226.02101,"804,00247-0088-16 ",.02)
 ;;00247-0088-16
 ;;9002226.02101,"804,00247-0088-18 ",.01)
 ;;00247-0088-18
 ;;9002226.02101,"804,00247-0088-18 ",.02)
 ;;00247-0088-18
 ;;9002226.02101,"804,00247-0088-20 ",.01)
 ;;00247-0088-20
 ;;9002226.02101,"804,00247-0088-20 ",.02)
 ;;00247-0088-20
 ;;9002226.02101,"804,00247-0088-28 ",.01)
 ;;00247-0088-28
 ;;9002226.02101,"804,00247-0088-28 ",.02)
 ;;00247-0088-28
 ;;9002226.02101,"804,00247-0088-30 ",.01)
 ;;00247-0088-30
 ;;9002226.02101,"804,00247-0088-30 ",.02)
 ;;00247-0088-30
 ;;9002226.02101,"804,00247-0088-40 ",.01)
 ;;00247-0088-40
 ;;9002226.02101,"804,00247-0088-40 ",.02)
 ;;00247-0088-40
 ;;9002226.02101,"804,00247-0088-52 ",.01)
 ;;00247-0088-52
 ;;9002226.02101,"804,00247-0088-52 ",.02)
 ;;00247-0088-52
 ;;9002226.02101,"804,00247-0088-56 ",.01)
 ;;00247-0088-56
 ;;9002226.02101,"804,00247-0088-56 ",.02)
 ;;00247-0088-56
 ;;9002226.02101,"804,00247-0088-60 ",.01)
 ;;00247-0088-60
 ;;9002226.02101,"804,00247-0088-60 ",.02)
 ;;00247-0088-60
 ;;9002226.02101,"804,00247-0112-10 ",.01)
 ;;00247-0112-10
 ;;9002226.02101,"804,00247-0112-10 ",.02)
 ;;00247-0112-10
 ;;9002226.02101,"804,00247-0112-15 ",.01)
 ;;00247-0112-15
 ;;9002226.02101,"804,00247-0112-15 ",.02)
 ;;00247-0112-15
 ;;9002226.02101,"804,00247-0112-16 ",.01)
 ;;00247-0112-16
 ;;9002226.02101,"804,00247-0112-16 ",.02)
 ;;00247-0112-16
 ;;9002226.02101,"804,00247-0112-20 ",.01)
 ;;00247-0112-20
 ;;9002226.02101,"804,00247-0112-20 ",.02)
 ;;00247-0112-20
 ;;9002226.02101,"804,00247-0112-24 ",.01)
 ;;00247-0112-24
 ;;9002226.02101,"804,00247-0112-24 ",.02)
 ;;00247-0112-24
 ;;9002226.02101,"804,00247-0112-28 ",.01)
 ;;00247-0112-28
 ;;9002226.02101,"804,00247-0112-28 ",.02)
 ;;00247-0112-28
 ;;9002226.02101,"804,00247-0112-30 ",.01)
 ;;00247-0112-30
 ;;9002226.02101,"804,00247-0112-30 ",.02)
 ;;00247-0112-30
 ;;9002226.02101,"804,00247-0112-40 ",.01)
 ;;00247-0112-40
 ;;9002226.02101,"804,00247-0112-40 ",.02)
 ;;00247-0112-40
 ;;9002226.02101,"804,00247-0180-03 ",.01)
 ;;00247-0180-03
 ;;9002226.02101,"804,00247-0180-03 ",.02)
 ;;00247-0180-03
 ;;9002226.02101,"804,00247-0180-06 ",.01)
 ;;00247-0180-06
 ;;9002226.02101,"804,00247-0180-06 ",.02)
 ;;00247-0180-06
 ;;9002226.02101,"804,00247-0180-10 ",.01)
 ;;00247-0180-10
 ;;9002226.02101,"804,00247-0180-10 ",.02)
 ;;00247-0180-10
 ;;9002226.02101,"804,00247-0180-12 ",.01)
 ;;00247-0180-12
 ;;9002226.02101,"804,00247-0180-12 ",.02)
 ;;00247-0180-12
 ;;9002226.02101,"804,00247-0180-14 ",.01)
 ;;00247-0180-14
 ;;9002226.02101,"804,00247-0180-14 ",.02)
 ;;00247-0180-14
 ;;9002226.02101,"804,00247-0180-15 ",.01)
 ;;00247-0180-15
 ;;9002226.02101,"804,00247-0180-15 ",.02)
 ;;00247-0180-15
 ;;9002226.02101,"804,00247-0180-20 ",.01)
 ;;00247-0180-20
 ;;9002226.02101,"804,00247-0180-20 ",.02)
 ;;00247-0180-20
 ;;9002226.02101,"804,00247-0180-24 ",.01)
 ;;00247-0180-24
 ;;9002226.02101,"804,00247-0180-24 ",.02)
 ;;00247-0180-24
 ;;9002226.02101,"804,00247-0180-28 ",.01)
 ;;00247-0180-28
 ;;9002226.02101,"804,00247-0180-28 ",.02)
 ;;00247-0180-28
 ;;9002226.02101,"804,00247-0180-40 ",.01)
 ;;00247-0180-40
 ;;9002226.02101,"804,00247-0180-40 ",.02)
 ;;00247-0180-40
 ;;9002226.02101,"804,00247-0180-60 ",.01)
 ;;00247-0180-60
 ;;9002226.02101,"804,00247-0180-60 ",.02)
 ;;00247-0180-60
 ;;9002226.02101,"804,00247-0286-06 ",.01)
 ;;00247-0286-06
 ;;9002226.02101,"804,00247-0286-06 ",.02)
 ;;00247-0286-06
 ;;9002226.02101,"804,00247-0286-16 ",.01)
 ;;00247-0286-16
 ;;9002226.02101,"804,00247-0286-16 ",.02)
 ;;00247-0286-16
 ;;9002226.02101,"804,00247-0286-18 ",.01)
 ;;00247-0286-18
 ;;9002226.02101,"804,00247-0286-18 ",.02)
 ;;00247-0286-18
 ;;9002226.02101,"804,00247-0286-20 ",.01)
 ;;00247-0286-20
 ;;9002226.02101,"804,00247-0286-20 ",.02)
 ;;00247-0286-20
 ;;9002226.02101,"804,00247-0286-30 ",.01)
 ;;00247-0286-30
 ;;9002226.02101,"804,00247-0286-30 ",.02)
 ;;00247-0286-30
 ;;9002226.02101,"804,00247-0286-40 ",.01)
 ;;00247-0286-40
 ;;9002226.02101,"804,00247-0286-40 ",.02)
 ;;00247-0286-40
 ;;9002226.02101,"804,00247-0341-20 ",.01)
 ;;00247-0341-20
 ;;9002226.02101,"804,00247-0341-20 ",.02)
 ;;00247-0341-20
 ;;9002226.02101,"804,00247-0341-30 ",.01)
 ;;00247-0341-30
 ;;9002226.02101,"804,00247-0341-30 ",.02)
 ;;00247-0341-30
 ;;9002226.02101,"804,00247-0367-10 ",.01)
 ;;00247-0367-10
 ;;9002226.02101,"804,00247-0367-10 ",.02)
 ;;00247-0367-10
 ;;9002226.02101,"804,00247-0367-18 ",.01)
 ;;00247-0367-18