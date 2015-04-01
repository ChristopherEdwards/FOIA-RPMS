BGP51W28 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 19, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1774,63874-0665-30 ",.02)
 ;;63874-0665-30
 ;;9002226.02101,"1774,63874-0665-60 ",.01)
 ;;63874-0665-60
 ;;9002226.02101,"1774,63874-0665-60 ",.02)
 ;;63874-0665-60
 ;;9002226.02101,"1774,63874-0665-90 ",.01)
 ;;63874-0665-90
 ;;9002226.02101,"1774,63874-0665-90 ",.02)
 ;;63874-0665-90
 ;;9002226.02101,"1774,63874-0974-01 ",.01)
 ;;63874-0974-01
 ;;9002226.02101,"1774,63874-0974-01 ",.02)
 ;;63874-0974-01
 ;;9002226.02101,"1774,63874-0974-30 ",.01)
 ;;63874-0974-30
 ;;9002226.02101,"1774,63874-0974-30 ",.02)
 ;;63874-0974-30
 ;;9002226.02101,"1774,63874-0974-60 ",.01)
 ;;63874-0974-60
 ;;9002226.02101,"1774,63874-0974-60 ",.02)
 ;;63874-0974-60
 ;;9002226.02101,"1774,64720-0123-10 ",.01)
 ;;64720-0123-10
 ;;9002226.02101,"1774,64720-0123-10 ",.02)
 ;;64720-0123-10
 ;;9002226.02101,"1774,64720-0124-10 ",.01)
 ;;64720-0124-10
 ;;9002226.02101,"1774,64720-0124-10 ",.02)
 ;;64720-0124-10
 ;;9002226.02101,"1774,64720-0125-10 ",.01)
 ;;64720-0125-10
 ;;9002226.02101,"1774,64720-0125-10 ",.02)
 ;;64720-0125-10
 ;;9002226.02101,"1774,64720-0125-11 ",.01)
 ;;64720-0125-11
 ;;9002226.02101,"1774,64720-0125-11 ",.02)
 ;;64720-0125-11
 ;;9002226.02101,"1774,64764-0121-03 ",.01)
 ;;64764-0121-03
 ;;9002226.02101,"1774,64764-0121-03 ",.02)
 ;;64764-0121-03
 ;;9002226.02101,"1774,64764-0123-03 ",.01)
 ;;64764-0123-03
 ;;9002226.02101,"1774,64764-0123-03 ",.02)
 ;;64764-0123-03
 ;;9002226.02101,"1774,64764-0124-03 ",.01)
 ;;64764-0124-03
 ;;9002226.02101,"1774,64764-0124-03 ",.02)
 ;;64764-0124-03
 ;;9002226.02101,"1774,64764-0125-30 ",.01)
 ;;64764-0125-30
 ;;9002226.02101,"1774,64764-0125-30 ",.02)
 ;;64764-0125-30
 ;;9002226.02101,"1774,64764-0151-04 ",.01)
 ;;64764-0151-04
 ;;9002226.02101,"1774,64764-0151-04 ",.02)
 ;;64764-0151-04
 ;;9002226.02101,"1774,64764-0151-05 ",.01)
 ;;64764-0151-05
 ;;9002226.02101,"1774,64764-0151-05 ",.02)
 ;;64764-0151-05
 ;;9002226.02101,"1774,64764-0151-06 ",.01)
 ;;64764-0151-06
 ;;9002226.02101,"1774,64764-0151-06 ",.02)
 ;;64764-0151-06
 ;;9002226.02101,"1774,64764-0155-18 ",.01)
 ;;64764-0155-18
 ;;9002226.02101,"1774,64764-0155-18 ",.02)
 ;;64764-0155-18
 ;;9002226.02101,"1774,64764-0155-60 ",.01)
 ;;64764-0155-60
 ;;9002226.02101,"1774,64764-0155-60 ",.02)
 ;;64764-0155-60
 ;;9002226.02101,"1774,64764-0158-18 ",.01)
 ;;64764-0158-18
 ;;9002226.02101,"1774,64764-0158-18 ",.02)
 ;;64764-0158-18
 ;;9002226.02101,"1774,64764-0158-60 ",.01)
 ;;64764-0158-60
 ;;9002226.02101,"1774,64764-0158-60 ",.02)
 ;;64764-0158-60
 ;;9002226.02101,"1774,64764-0250-30 ",.01)
 ;;64764-0250-30
 ;;9002226.02101,"1774,64764-0250-30 ",.02)
 ;;64764-0250-30
 ;;9002226.02101,"1774,64764-0251-03 ",.01)
 ;;64764-0251-03
 ;;9002226.02101,"1774,64764-0251-03 ",.02)
 ;;64764-0251-03
 ;;9002226.02101,"1774,64764-0253-03 ",.01)
 ;;64764-0253-03
 ;;9002226.02101,"1774,64764-0253-03 ",.02)
 ;;64764-0253-03
 ;;9002226.02101,"1774,64764-0254-03 ",.01)
 ;;64764-0254-03
 ;;9002226.02101,"1774,64764-0254-03 ",.02)
 ;;64764-0254-03
 ;;9002226.02101,"1774,64764-0301-14 ",.01)
 ;;64764-0301-14
 ;;9002226.02101,"1774,64764-0301-14 ",.02)
 ;;64764-0301-14
 ;;9002226.02101,"1774,64764-0301-15 ",.01)
 ;;64764-0301-15
 ;;9002226.02101,"1774,64764-0301-15 ",.02)
 ;;64764-0301-15
 ;;9002226.02101,"1774,64764-0301-16 ",.01)
 ;;64764-0301-16
 ;;9002226.02101,"1774,64764-0301-16 ",.02)
 ;;64764-0301-16
 ;;9002226.02101,"1774,64764-0302-30 ",.01)
 ;;64764-0302-30
 ;;9002226.02101,"1774,64764-0302-30 ",.02)
 ;;64764-0302-30
 ;;9002226.02101,"1774,64764-0304-30 ",.01)
 ;;64764-0304-30
 ;;9002226.02101,"1774,64764-0304-30 ",.02)
 ;;64764-0304-30
 ;;9002226.02101,"1774,64764-0310-30 ",.01)
 ;;64764-0310-30
 ;;9002226.02101,"1774,64764-0310-30 ",.02)
 ;;64764-0310-30
 ;;9002226.02101,"1774,64764-0335-60 ",.01)
 ;;64764-0335-60
 ;;9002226.02101,"1774,64764-0335-60 ",.02)
 ;;64764-0335-60
 ;;9002226.02101,"1774,64764-0337-60 ",.01)
 ;;64764-0337-60
 ;;9002226.02101,"1774,64764-0337-60 ",.02)
 ;;64764-0337-60
 ;;9002226.02101,"1774,64764-0451-24 ",.01)
 ;;64764-0451-24
 ;;9002226.02101,"1774,64764-0451-24 ",.02)
 ;;64764-0451-24
 ;;9002226.02101,"1774,64764-0451-25 ",.01)
 ;;64764-0451-25
 ;;9002226.02101,"1774,64764-0451-25 ",.02)
 ;;64764-0451-25
 ;;9002226.02101,"1774,64764-0451-26 ",.01)
 ;;64764-0451-26
 ;;9002226.02101,"1774,64764-0451-26 ",.02)
 ;;64764-0451-26
 ;;9002226.02101,"1774,64764-0510-30 ",.01)
 ;;64764-0510-30
 ;;9002226.02101,"1774,64764-0510-30 ",.02)
 ;;64764-0510-30
 ;;9002226.02101,"1774,64764-0625-30 ",.01)
 ;;64764-0625-30
 ;;9002226.02101,"1774,64764-0625-30 ",.02)
 ;;64764-0625-30
 ;;9002226.02101,"1774,65084-0416-18 ",.01)
 ;;65084-0416-18
 ;;9002226.02101,"1774,65084-0416-18 ",.02)
 ;;65084-0416-18
 ;;9002226.02101,"1774,65084-0416-20 ",.01)
 ;;65084-0416-20
 ;;9002226.02101,"1774,65084-0416-20 ",.02)
 ;;65084-0416-20
 ;;9002226.02101,"1774,65162-0174-10 ",.01)
 ;;65162-0174-10
 ;;9002226.02101,"1774,65162-0174-10 ",.02)
 ;;65162-0174-10
 ;;9002226.02101,"1774,65162-0174-11 ",.01)
 ;;65162-0174-11
 ;;9002226.02101,"1774,65162-0174-11 ",.02)
 ;;65162-0174-11
 ;;9002226.02101,"1774,65162-0174-50 ",.01)
 ;;65162-0174-50
 ;;9002226.02101,"1774,65162-0174-50 ",.02)
 ;;65162-0174-50
 ;;9002226.02101,"1774,65162-0175-10 ",.01)
 ;;65162-0175-10
 ;;9002226.02101,"1774,65162-0175-10 ",.02)
 ;;65162-0175-10
 ;;9002226.02101,"1774,65162-0175-11 ",.01)
 ;;65162-0175-11
 ;;9002226.02101,"1774,65162-0175-11 ",.02)
 ;;65162-0175-11
 ;;9002226.02101,"1774,65162-0175-50 ",.01)
 ;;65162-0175-50
 ;;9002226.02101,"1774,65162-0175-50 ",.02)
 ;;65162-0175-50
 ;;9002226.02101,"1774,65162-0177-10 ",.01)
 ;;65162-0177-10
 ;;9002226.02101,"1774,65162-0177-10 ",.02)
 ;;65162-0177-10
 ;;9002226.02101,"1774,65162-0177-11 ",.01)
 ;;65162-0177-11
 ;;9002226.02101,"1774,65162-0177-11 ",.02)
 ;;65162-0177-11
 ;;9002226.02101,"1774,65162-0177-50 ",.01)
 ;;65162-0177-50
 ;;9002226.02101,"1774,65162-0177-50 ",.02)
 ;;65162-0177-50
 ;;9002226.02101,"1774,65162-0218-10 ",.01)
 ;;65162-0218-10
 ;;9002226.02101,"1774,65162-0218-10 ",.02)
 ;;65162-0218-10
 ;;9002226.02101,"1774,65162-0218-11 ",.01)
 ;;65162-0218-11
 ;;9002226.02101,"1774,65162-0218-11 ",.02)
 ;;65162-0218-11
 ;;9002226.02101,"1774,65162-0218-50 ",.01)
 ;;65162-0218-50
 ;;9002226.02101,"1774,65162-0218-50 ",.02)
 ;;65162-0218-50
 ;;9002226.02101,"1774,65162-0219-10 ",.01)
 ;;65162-0219-10
 ;;9002226.02101,"1774,65162-0219-10 ",.02)
 ;;65162-0219-10
 ;;9002226.02101,"1774,65162-0219-11 ",.01)
 ;;65162-0219-11
 ;;9002226.02101,"1774,65162-0219-11 ",.02)
 ;;65162-0219-11
 ;;9002226.02101,"1774,65162-0219-50 ",.01)
 ;;65162-0219-50
 ;;9002226.02101,"1774,65162-0219-50 ",.02)
 ;;65162-0219-50
 ;;9002226.02101,"1774,65162-0220-10 ",.01)
 ;;65162-0220-10
 ;;9002226.02101,"1774,65162-0220-10 ",.02)
 ;;65162-0220-10
 ;;9002226.02101,"1774,65162-0220-11 ",.01)
 ;;65162-0220-11
 ;;9002226.02101,"1774,65162-0220-11 ",.02)
 ;;65162-0220-11
 ;;9002226.02101,"1774,65162-0220-50 ",.01)
 ;;65162-0220-50
 ;;9002226.02101,"1774,65162-0220-50 ",.02)
 ;;65162-0220-50
 ;;9002226.02101,"1774,65243-0176-09 ",.01)
 ;;65243-0176-09
 ;;9002226.02101,"1774,65243-0176-09 ",.02)
 ;;65243-0176-09
 ;;9002226.02101,"1774,65243-0176-12 ",.01)
 ;;65243-0176-12
 ;;9002226.02101,"1774,65243-0176-12 ",.02)
 ;;65243-0176-12
 ;;9002226.02101,"1774,65243-0176-18 ",.01)
 ;;65243-0176-18
 ;;9002226.02101,"1774,65243-0176-18 ",.02)
 ;;65243-0176-18
 ;;9002226.02101,"1774,65243-0176-27 ",.01)
 ;;65243-0176-27
 ;;9002226.02101,"1774,65243-0176-27 ",.02)
 ;;65243-0176-27
 ;;9002226.02101,"1774,65243-0176-36 ",.01)
 ;;65243-0176-36
 ;;9002226.02101,"1774,65243-0176-36 ",.02)
 ;;65243-0176-36
 ;;9002226.02101,"1774,65243-0183-18 ",.01)
 ;;65243-0183-18
 ;;9002226.02101,"1774,65243-0183-18 ",.02)
 ;;65243-0183-18
 ;;9002226.02101,"1774,65243-0185-36 ",.01)
 ;;65243-0185-36
 ;;9002226.02101,"1774,65243-0185-36 ",.02)
 ;;65243-0185-36
 ;;9002226.02101,"1774,65243-0195-09 ",.01)
 ;;65243-0195-09
 ;;9002226.02101,"1774,65243-0195-09 ",.02)
 ;;65243-0195-09
 ;;9002226.02101,"1774,65243-0195-12 ",.01)
 ;;65243-0195-12
 ;;9002226.02101,"1774,65243-0195-12 ",.02)
 ;;65243-0195-12
 ;;9002226.02101,"1774,65243-0196-09 ",.01)
 ;;65243-0196-09
 ;;9002226.02101,"1774,65243-0196-09 ",.02)
 ;;65243-0196-09
 ;;9002226.02101,"1774,65243-0239-09 ",.01)
 ;;65243-0239-09
 ;;9002226.02101,"1774,65243-0239-09 ",.02)
 ;;65243-0239-09
 ;;9002226.02101,"1774,65243-0239-18 ",.01)
 ;;65243-0239-18
 ;;9002226.02101,"1774,65243-0239-18 ",.02)
 ;;65243-0239-18
 ;;9002226.02101,"1774,65243-0239-27 ",.01)
 ;;65243-0239-27
 ;;9002226.02101,"1774,65243-0239-27 ",.02)
 ;;65243-0239-27
 ;;9002226.02101,"1774,65243-0288-06 ",.01)
 ;;65243-0288-06
 ;;9002226.02101,"1774,65243-0288-06 ",.02)
 ;;65243-0288-06
 ;;9002226.02101,"1774,65243-0288-09 ",.01)
 ;;65243-0288-09
 ;;9002226.02101,"1774,65243-0288-09 ",.02)
 ;;65243-0288-09
 ;;9002226.02101,"1774,65243-0288-12 ",.01)
 ;;65243-0288-12
 ;;9002226.02101,"1774,65243-0288-12 ",.02)
 ;;65243-0288-12
 ;;9002226.02101,"1774,65243-0288-18 ",.01)
 ;;65243-0288-18
 ;;9002226.02101,"1774,65243-0288-18 ",.02)
 ;;65243-0288-18
 ;;9002226.02101,"1774,65243-0289-06 ",.01)
 ;;65243-0289-06
 ;;9002226.02101,"1774,65243-0289-06 ",.02)
 ;;65243-0289-06
 ;;9002226.02101,"1774,65243-0289-09 ",.01)
 ;;65243-0289-09
 ;;9002226.02101,"1774,65243-0289-09 ",.02)
 ;;65243-0289-09
 ;;9002226.02101,"1774,65243-0289-12 ",.01)
 ;;65243-0289-12
 ;;9002226.02101,"1774,65243-0289-12 ",.02)
 ;;65243-0289-12
 ;;9002226.02101,"1774,65243-0289-18 ",.01)
 ;;65243-0289-18
 ;;9002226.02101,"1774,65243-0289-18 ",.02)
 ;;65243-0289-18
 ;;9002226.02101,"1774,65243-0325-09 ",.01)
 ;;65243-0325-09
 ;;9002226.02101,"1774,65243-0325-09 ",.02)
 ;;65243-0325-09
 ;;9002226.02101,"1774,65243-0325-18 ",.01)
 ;;65243-0325-18
 ;;9002226.02101,"1774,65243-0325-18 ",.02)
 ;;65243-0325-18
 ;;9002226.02101,"1774,65243-0343-09 ",.01)
 ;;65243-0343-09
 ;;9002226.02101,"1774,65243-0343-09 ",.02)
 ;;65243-0343-09
 ;;9002226.02101,"1774,65243-0343-36 ",.01)
 ;;65243-0343-36
 ;;9002226.02101,"1774,65243-0343-36 ",.02)
 ;;65243-0343-36
 ;;9002226.02101,"1774,65243-0346-09 ",.01)
 ;;65243-0346-09
 ;;9002226.02101,"1774,65243-0346-09 ",.02)
 ;;65243-0346-09
 ;;9002226.02101,"1774,65243-0371-06 ",.01)
 ;;65243-0371-06
 ;;9002226.02101,"1774,65243-0371-06 ",.02)
 ;;65243-0371-06
 ;;9002226.02101,"1774,65243-0371-09 ",.01)
 ;;65243-0371-09
 ;;9002226.02101,"1774,65243-0371-09 ",.02)
 ;;65243-0371-09
 ;;9002226.02101,"1774,65243-0372-06 ",.01)
 ;;65243-0372-06
 ;;9002226.02101,"1774,65243-0372-06 ",.02)
 ;;65243-0372-06
 ;;9002226.02101,"1774,65243-0372-09 ",.01)
 ;;65243-0372-09
 ;;9002226.02101,"1774,65243-0372-09 ",.02)
 ;;65243-0372-09
 ;;9002226.02101,"1774,65243-0372-18 ",.01)
 ;;65243-0372-18
 ;;9002226.02101,"1774,65243-0372-18 ",.02)
 ;;65243-0372-18
 ;;9002226.02101,"1774,65243-0373-09 ",.01)
 ;;65243-0373-09
 ;;9002226.02101,"1774,65243-0373-09 ",.02)
 ;;65243-0373-09
 ;;9002226.02101,"1774,65243-0375-09 ",.01)
 ;;65243-0375-09
 ;;9002226.02101,"1774,65243-0375-09 ",.02)
 ;;65243-0375-09
 ;;9002226.02101,"1774,65243-0378-09 ",.01)
 ;;65243-0378-09
 ;;9002226.02101,"1774,65243-0378-09 ",.02)
 ;;65243-0378-09
 ;;9002226.02101,"1774,65862-0008-01 ",.01)
 ;;65862-0008-01
 ;;9002226.02101,"1774,65862-0008-01 ",.02)
 ;;65862-0008-01
 ;;9002226.02101,"1774,65862-0008-05 ",.01)
 ;;65862-0008-05
 ;;9002226.02101,"1774,65862-0008-05 ",.02)
 ;;65862-0008-05
 ;;9002226.02101,"1774,65862-0008-90 ",.01)
 ;;65862-0008-90
 ;;9002226.02101,"1774,65862-0008-90 ",.02)
 ;;65862-0008-90
 ;;9002226.02101,"1774,65862-0008-99 ",.01)
 ;;65862-0008-99
 ;;9002226.02101,"1774,65862-0008-99 ",.02)
 ;;65862-0008-99
 ;;9002226.02101,"1774,65862-0009-01 ",.01)
 ;;65862-0009-01
 ;;9002226.02101,"1774,65862-0009-01 ",.02)
 ;;65862-0009-01
 ;;9002226.02101,"1774,65862-0009-05 ",.01)
 ;;65862-0009-05
 ;;9002226.02101,"1774,65862-0009-05 ",.02)
 ;;65862-0009-05
 ;;9002226.02101,"1774,65862-0009-90 ",.01)
 ;;65862-0009-90
 ;;9002226.02101,"1774,65862-0009-90 ",.02)
 ;;65862-0009-90
 ;;9002226.02101,"1774,65862-0010-01 ",.01)
 ;;65862-0010-01
 ;;9002226.02101,"1774,65862-0010-01 ",.02)
 ;;65862-0010-01
 ;;9002226.02101,"1774,65862-0010-05 ",.01)
 ;;65862-0010-05
 ;;9002226.02101,"1774,65862-0010-05 ",.02)
 ;;65862-0010-05
 ;;9002226.02101,"1774,65862-0010-46 ",.01)
 ;;65862-0010-46
 ;;9002226.02101,"1774,65862-0010-46 ",.02)
 ;;65862-0010-46
 ;;9002226.02101,"1774,65862-0010-90 ",.01)
 ;;65862-0010-90
 ;;9002226.02101,"1774,65862-0010-90 ",.02)
 ;;65862-0010-90
 ;;9002226.02101,"1774,65862-0010-99 ",.01)
 ;;65862-0010-99
 ;;9002226.02101,"1774,65862-0010-99 ",.02)
 ;;65862-0010-99
 ;;9002226.02101,"1774,65862-0028-01 ",.01)
 ;;65862-0028-01
 ;;9002226.02101,"1774,65862-0028-01 ",.02)
 ;;65862-0028-01
 ;;9002226.02101,"1774,65862-0029-01 ",.01)
 ;;65862-0029-01
 ;;9002226.02101,"1774,65862-0029-01 ",.02)
 ;;65862-0029-01
 ;;9002226.02101,"1774,65862-0029-05 ",.01)
 ;;65862-0029-05
 ;;9002226.02101,"1774,65862-0029-05 ",.02)
 ;;65862-0029-05
 ;;9002226.02101,"1774,65862-0030-01 ",.01)
 ;;65862-0030-01
 ;;9002226.02101,"1774,65862-0030-01 ",.02)
 ;;65862-0030-01
 ;;9002226.02101,"1774,65862-0030-99 ",.01)
 ;;65862-0030-99
 ;;9002226.02101,"1774,65862-0030-99 ",.02)
 ;;65862-0030-99
 ;;9002226.02101,"1774,65862-0080-01 ",.01)
 ;;65862-0080-01
 ;;9002226.02101,"1774,65862-0080-01 ",.02)
 ;;65862-0080-01