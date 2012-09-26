BGP2TA28 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1064,63874-0655-10 ",.02)
 ;;63874-0655-10
 ;;9002226.02101,"1064,63874-0655-20 ",.01)
 ;;63874-0655-20
 ;;9002226.02101,"1064,63874-0655-20 ",.02)
 ;;63874-0655-20
 ;;9002226.02101,"1064,63874-0655-30 ",.01)
 ;;63874-0655-30
 ;;9002226.02101,"1064,63874-0655-30 ",.02)
 ;;63874-0655-30
 ;;9002226.02101,"1064,63874-0655-60 ",.01)
 ;;63874-0655-60
 ;;9002226.02101,"1064,63874-0655-60 ",.02)
 ;;63874-0655-60
 ;;9002226.02101,"1064,63874-0987-01 ",.01)
 ;;63874-0987-01
 ;;9002226.02101,"1064,63874-0987-01 ",.02)
 ;;63874-0987-01
 ;;9002226.02101,"1064,63874-0987-10 ",.01)
 ;;63874-0987-10
 ;;9002226.02101,"1064,63874-0987-10 ",.02)
 ;;63874-0987-10
 ;;9002226.02101,"1064,63874-0987-14 ",.01)
 ;;63874-0987-14
 ;;9002226.02101,"1064,63874-0987-14 ",.02)
 ;;63874-0987-14
 ;;9002226.02101,"1064,63874-0987-20 ",.01)
 ;;63874-0987-20
 ;;9002226.02101,"1064,63874-0987-20 ",.02)
 ;;63874-0987-20
 ;;9002226.02101,"1064,63874-0987-30 ",.01)
 ;;63874-0987-30
 ;;9002226.02101,"1064,63874-0987-30 ",.02)
 ;;63874-0987-30
 ;;9002226.02101,"1064,63874-0987-60 ",.01)
 ;;63874-0987-60
 ;;9002226.02101,"1064,63874-0987-60 ",.02)
 ;;63874-0987-60
 ;;9002226.02101,"1064,63874-1114-09 ",.01)
 ;;63874-1114-09
 ;;9002226.02101,"1064,63874-1114-09 ",.02)
 ;;63874-1114-09
 ;;9002226.02101,"1064,64455-0140-10 ",.01)
 ;;64455-0140-10
 ;;9002226.02101,"1064,64455-0140-10 ",.02)
 ;;64455-0140-10
 ;;9002226.02101,"1064,64455-0140-30 ",.01)
 ;;64455-0140-30
 ;;9002226.02101,"1064,64455-0140-30 ",.02)
 ;;64455-0140-30
 ;;9002226.02101,"1064,64455-0140-90 ",.01)
 ;;64455-0140-90
 ;;9002226.02101,"1064,64455-0140-90 ",.02)
 ;;64455-0140-90
 ;;9002226.02101,"1064,64455-0141-10 ",.01)
 ;;64455-0141-10
 ;;9002226.02101,"1064,64455-0141-10 ",.02)
 ;;64455-0141-10
 ;;9002226.02101,"1064,64455-0141-30 ",.01)
 ;;64455-0141-30
 ;;9002226.02101,"1064,64455-0141-30 ",.02)
 ;;64455-0141-30
 ;;9002226.02101,"1064,64455-0141-90 ",.01)
 ;;64455-0141-90
 ;;9002226.02101,"1064,64455-0141-90 ",.02)
 ;;64455-0141-90
 ;;9002226.02101,"1064,64455-0142-10 ",.01)
 ;;64455-0142-10
 ;;9002226.02101,"1064,64455-0142-10 ",.02)
 ;;64455-0142-10
 ;;9002226.02101,"1064,64455-0142-30 ",.01)
 ;;64455-0142-30
 ;;9002226.02101,"1064,64455-0142-30 ",.02)
 ;;64455-0142-30
 ;;9002226.02101,"1064,64455-0142-90 ",.01)
 ;;64455-0142-90
 ;;9002226.02101,"1064,64455-0142-90 ",.02)
 ;;64455-0142-90
 ;;9002226.02101,"1064,64455-0143-10 ",.01)
 ;;64455-0143-10
 ;;9002226.02101,"1064,64455-0143-10 ",.02)
 ;;64455-0143-10
 ;;9002226.02101,"1064,64455-0143-30 ",.01)
 ;;64455-0143-30
 ;;9002226.02101,"1064,64455-0143-30 ",.02)
 ;;64455-0143-30
 ;;9002226.02101,"1064,64455-0143-90 ",.01)
 ;;64455-0143-90
 ;;9002226.02101,"1064,64455-0143-90 ",.02)
 ;;64455-0143-90
 ;;9002226.02101,"1064,64455-0145-01 ",.01)
 ;;64455-0145-01
 ;;9002226.02101,"1064,64455-0145-01 ",.02)
 ;;64455-0145-01
 ;;9002226.02101,"1064,64455-0146-01 ",.01)
 ;;64455-0146-01
 ;;9002226.02101,"1064,64455-0146-01 ",.02)
 ;;64455-0146-01
 ;;9002226.02101,"1064,64679-0902-01 ",.01)
 ;;64679-0902-01
 ;;9002226.02101,"1064,64679-0902-01 ",.02)
 ;;64679-0902-01
 ;;9002226.02101,"1064,64679-0902-02 ",.01)
 ;;64679-0902-02
 ;;9002226.02101,"1064,64679-0902-02 ",.02)
 ;;64679-0902-02
 ;;9002226.02101,"1064,64679-0903-01 ",.01)
 ;;64679-0903-01
 ;;9002226.02101,"1064,64679-0903-01 ",.02)
 ;;64679-0903-01
 ;;9002226.02101,"1064,64679-0903-02 ",.01)
 ;;64679-0903-02
 ;;9002226.02101,"1064,64679-0903-02 ",.02)
 ;;64679-0903-02
 ;;9002226.02101,"1064,64679-0904-01 ",.01)
 ;;64679-0904-01
 ;;9002226.02101,"1064,64679-0904-01 ",.02)
 ;;64679-0904-01
 ;;9002226.02101,"1064,64679-0904-02 ",.01)
 ;;64679-0904-02
 ;;9002226.02101,"1064,64679-0904-02 ",.02)
 ;;64679-0904-02
 ;;9002226.02101,"1064,64679-0905-01 ",.01)
 ;;64679-0905-01
 ;;9002226.02101,"1064,64679-0905-01 ",.02)
 ;;64679-0905-01
 ;;9002226.02101,"1064,64679-0923-02 ",.01)
 ;;64679-0923-02
 ;;9002226.02101,"1064,64679-0923-02 ",.02)
 ;;64679-0923-02
 ;;9002226.02101,"1064,64679-0923-03 ",.01)
 ;;64679-0923-03
 ;;9002226.02101,"1064,64679-0923-03 ",.02)
 ;;64679-0923-03
 ;;9002226.02101,"1064,64679-0923-09 ",.01)
 ;;64679-0923-09
 ;;9002226.02101,"1064,64679-0923-09 ",.02)
 ;;64679-0923-09
 ;;9002226.02101,"1064,64679-0924-02 ",.01)
 ;;64679-0924-02
 ;;9002226.02101,"1064,64679-0924-02 ",.02)
 ;;64679-0924-02
 ;;9002226.02101,"1064,64679-0924-03 ",.01)
 ;;64679-0924-03
 ;;9002226.02101,"1064,64679-0924-03 ",.02)
 ;;64679-0924-03
 ;;9002226.02101,"1064,64679-0924-09 ",.01)
 ;;64679-0924-09
 ;;9002226.02101,"1064,64679-0924-09 ",.02)
 ;;64679-0924-09
 ;;9002226.02101,"1064,64679-0925-01 ",.01)
 ;;64679-0925-01
 ;;9002226.02101,"1064,64679-0925-01 ",.02)
 ;;64679-0925-01
 ;;9002226.02101,"1064,64679-0925-02 ",.01)
 ;;64679-0925-02
 ;;9002226.02101,"1064,64679-0925-02 ",.02)
 ;;64679-0925-02
 ;;9002226.02101,"1064,64679-0925-03 ",.01)
 ;;64679-0925-03
 ;;9002226.02101,"1064,64679-0925-03 ",.02)
 ;;64679-0925-03
 ;;9002226.02101,"1064,64679-0925-09 ",.01)
 ;;64679-0925-09
 ;;9002226.02101,"1064,64679-0925-09 ",.02)
 ;;64679-0925-09
 ;;9002226.02101,"1064,64679-0926-02 ",.01)
 ;;64679-0926-02
 ;;9002226.02101,"1064,64679-0926-02 ",.02)
 ;;64679-0926-02
 ;;9002226.02101,"1064,64679-0926-03 ",.01)
 ;;64679-0926-03
 ;;9002226.02101,"1064,64679-0926-03 ",.02)
 ;;64679-0926-03
 ;;9002226.02101,"1064,64679-0926-09 ",.01)
 ;;64679-0926-09
 ;;9002226.02101,"1064,64679-0926-09 ",.02)
 ;;64679-0926-09
 ;;9002226.02101,"1064,64679-0927-01 ",.01)
 ;;64679-0927-01
 ;;9002226.02101,"1064,64679-0927-01 ",.02)
 ;;64679-0927-01
 ;;9002226.02101,"1064,64679-0927-02 ",.01)
 ;;64679-0927-02
 ;;9002226.02101,"1064,64679-0927-02 ",.02)
 ;;64679-0927-02
 ;;9002226.02101,"1064,64679-0927-05 ",.01)
 ;;64679-0927-05
 ;;9002226.02101,"1064,64679-0927-05 ",.02)
 ;;64679-0927-05
 ;;9002226.02101,"1064,64679-0927-09 ",.01)
 ;;64679-0927-09
 ;;9002226.02101,"1064,64679-0927-09 ",.02)
 ;;64679-0927-09
 ;;9002226.02101,"1064,64679-0928-01 ",.01)
 ;;64679-0928-01
 ;;9002226.02101,"1064,64679-0928-01 ",.02)
 ;;64679-0928-01
 ;;9002226.02101,"1064,64679-0928-05 ",.01)
 ;;64679-0928-05
 ;;9002226.02101,"1064,64679-0928-05 ",.02)
 ;;64679-0928-05
 ;;9002226.02101,"1064,64679-0928-06 ",.01)
 ;;64679-0928-06
 ;;9002226.02101,"1064,64679-0928-06 ",.02)
 ;;64679-0928-06
 ;;9002226.02101,"1064,64679-0928-10 ",.01)
 ;;64679-0928-10
 ;;9002226.02101,"1064,64679-0928-10 ",.02)
 ;;64679-0928-10
 ;;9002226.02101,"1064,64679-0929-01 ",.01)
 ;;64679-0929-01
 ;;9002226.02101,"1064,64679-0929-01 ",.02)
 ;;64679-0929-01
 ;;9002226.02101,"1064,64679-0929-05 ",.01)
 ;;64679-0929-05
 ;;9002226.02101,"1064,64679-0929-05 ",.02)
 ;;64679-0929-05
 ;;9002226.02101,"1064,64679-0929-06 ",.01)
 ;;64679-0929-06
 ;;9002226.02101,"1064,64679-0929-06 ",.02)
 ;;64679-0929-06
 ;;9002226.02101,"1064,64679-0929-10 ",.01)
 ;;64679-0929-10
 ;;9002226.02101,"1064,64679-0929-10 ",.02)
 ;;64679-0929-10
 ;;9002226.02101,"1064,64679-0941-01 ",.01)
 ;;64679-0941-01
 ;;9002226.02101,"1064,64679-0941-01 ",.02)
 ;;64679-0941-01
 ;;9002226.02101,"1064,64679-0941-05 ",.01)
 ;;64679-0941-05
 ;;9002226.02101,"1064,64679-0941-05 ",.02)
 ;;64679-0941-05
 ;;9002226.02101,"1064,64679-0941-06 ",.01)
 ;;64679-0941-06
 ;;9002226.02101,"1064,64679-0941-06 ",.02)
 ;;64679-0941-06
 ;;9002226.02101,"1064,64679-0941-10 ",.01)
 ;;64679-0941-10
 ;;9002226.02101,"1064,64679-0941-10 ",.02)
 ;;64679-0941-10
 ;;9002226.02101,"1064,64679-0942-01 ",.01)
 ;;64679-0942-01
 ;;9002226.02101,"1064,64679-0942-01 ",.02)
 ;;64679-0942-01
 ;;9002226.02101,"1064,64679-0942-02 ",.01)
 ;;64679-0942-02
 ;;9002226.02101,"1064,64679-0942-02 ",.02)
 ;;64679-0942-02
 ;;9002226.02101,"1064,64679-0942-05 ",.01)
 ;;64679-0942-05
 ;;9002226.02101,"1064,64679-0942-05 ",.02)
 ;;64679-0942-05
 ;;9002226.02101,"1064,64679-0942-09 ",.01)
 ;;64679-0942-09
 ;;9002226.02101,"1064,64679-0942-09 ",.02)
 ;;64679-0942-09
 ;;9002226.02101,"1064,64679-0953-01 ",.01)
 ;;64679-0953-01
 ;;9002226.02101,"1064,64679-0953-01 ",.02)
 ;;64679-0953-01
 ;;9002226.02101,"1064,64679-0953-02 ",.01)
 ;;64679-0953-02
 ;;9002226.02101,"1064,64679-0953-02 ",.02)
 ;;64679-0953-02
 ;;9002226.02101,"1064,64679-0953-05 ",.01)
 ;;64679-0953-05
 ;;9002226.02101,"1064,64679-0953-05 ",.02)
 ;;64679-0953-05
 ;;9002226.02101,"1064,64679-0953-09 ",.01)
 ;;64679-0953-09
 ;;9002226.02101,"1064,64679-0953-09 ",.02)
 ;;64679-0953-09
 ;;9002226.02101,"1064,65162-0751-10 ",.01)
 ;;65162-0751-10
 ;;9002226.02101,"1064,65162-0751-10 ",.02)
 ;;65162-0751-10
 ;;9002226.02101,"1064,65162-0751-50 ",.01)
 ;;65162-0751-50
 ;;9002226.02101,"1064,65162-0751-50 ",.02)
 ;;65162-0751-50
 ;;9002226.02101,"1064,65162-0752-10 ",.01)
 ;;65162-0752-10
 ;;9002226.02101,"1064,65162-0752-10 ",.02)
 ;;65162-0752-10
 ;;9002226.02101,"1064,65162-0752-50 ",.01)
 ;;65162-0752-50
 ;;9002226.02101,"1064,65162-0752-50 ",.02)
 ;;65162-0752-50
 ;;9002226.02101,"1064,65162-0753-10 ",.01)
 ;;65162-0753-10
 ;;9002226.02101,"1064,65162-0753-10 ",.02)
 ;;65162-0753-10
 ;;9002226.02101,"1064,65162-0753-50 ",.01)
 ;;65162-0753-50
 ;;9002226.02101,"1064,65162-0753-50 ",.02)
 ;;65162-0753-50
 ;;9002226.02101,"1064,65162-0754-10 ",.01)
 ;;65162-0754-10
 ;;9002226.02101,"1064,65162-0754-10 ",.02)
 ;;65162-0754-10
 ;;9002226.02101,"1064,65162-0754-50 ",.01)
 ;;65162-0754-50
 ;;9002226.02101,"1064,65162-0754-50 ",.02)
 ;;65162-0754-50
 ;;9002226.02101,"1064,65243-0303-03 ",.01)
 ;;65243-0303-03
 ;;9002226.02101,"1064,65243-0303-03 ",.02)
 ;;65243-0303-03
 ;;9002226.02101,"1064,65243-0314-03 ",.01)
 ;;65243-0314-03
 ;;9002226.02101,"1064,65243-0314-03 ",.02)
 ;;65243-0314-03
 ;;9002226.02101,"1064,65862-0037-01 ",.01)
 ;;65862-0037-01
 ;;9002226.02101,"1064,65862-0037-01 ",.02)
 ;;65862-0037-01
 ;;9002226.02101,"1064,65862-0037-05 ",.01)
 ;;65862-0037-05
 ;;9002226.02101,"1064,65862-0037-05 ",.02)
 ;;65862-0037-05
 ;;9002226.02101,"1064,65862-0038-01 ",.01)
 ;;65862-0038-01
 ;;9002226.02101,"1064,65862-0038-01 ",.02)
 ;;65862-0038-01
 ;;9002226.02101,"1064,65862-0038-05 ",.01)
 ;;65862-0038-05
 ;;9002226.02101,"1064,65862-0038-05 ",.02)
 ;;65862-0038-05
 ;;9002226.02101,"1064,65862-0039-01 ",.01)
 ;;65862-0039-01
 ;;9002226.02101,"1064,65862-0039-01 ",.02)
 ;;65862-0039-01
 ;;9002226.02101,"1064,65862-0039-05 ",.01)
 ;;65862-0039-05
 ;;9002226.02101,"1064,65862-0039-05 ",.02)
 ;;65862-0039-05
 ;;9002226.02101,"1064,65862-0040-01 ",.01)
 ;;65862-0040-01
 ;;9002226.02101,"1064,65862-0040-01 ",.02)
 ;;65862-0040-01
 ;;9002226.02101,"1064,65862-0040-05 ",.01)
 ;;65862-0040-05
 ;;9002226.02101,"1064,65862-0040-05 ",.02)
 ;;65862-0040-05
 ;;9002226.02101,"1064,65862-0041-01 ",.01)
 ;;65862-0041-01
 ;;9002226.02101,"1064,65862-0041-01 ",.02)
 ;;65862-0041-01
 ;;9002226.02101,"1064,65862-0042-01 ",.01)
 ;;65862-0042-01
 ;;9002226.02101,"1064,65862-0042-01 ",.02)
 ;;65862-0042-01
 ;;9002226.02101,"1064,65862-0042-05 ",.01)
 ;;65862-0042-05
 ;;9002226.02101,"1064,65862-0042-05 ",.02)
 ;;65862-0042-05
 ;;9002226.02101,"1064,65862-0043-01 ",.01)
 ;;65862-0043-01
 ;;9002226.02101,"1064,65862-0043-01 ",.02)
 ;;65862-0043-01
 ;;9002226.02101,"1064,65862-0043-05 ",.01)
 ;;65862-0043-05
 ;;9002226.02101,"1064,65862-0043-05 ",.02)
 ;;65862-0043-05
 ;;9002226.02101,"1064,65862-0044-01 ",.01)
 ;;65862-0044-01
 ;;9002226.02101,"1064,65862-0044-01 ",.02)
 ;;65862-0044-01
 ;;9002226.02101,"1064,65862-0044-05 ",.01)
 ;;65862-0044-05
 ;;9002226.02101,"1064,65862-0044-05 ",.02)
 ;;65862-0044-05
 ;;9002226.02101,"1064,65862-0045-01 ",.01)
 ;;65862-0045-01
 ;;9002226.02101,"1064,65862-0045-01 ",.02)
 ;;65862-0045-01
 ;;9002226.02101,"1064,65862-0045-05 ",.01)
 ;;65862-0045-05
 ;;9002226.02101,"1064,65862-0045-05 ",.02)
 ;;65862-0045-05
 ;;9002226.02101,"1064,65862-0116-01 ",.01)
 ;;65862-0116-01
 ;;9002226.02101,"1064,65862-0116-01 ",.02)
 ;;65862-0116-01
 ;;9002226.02101,"1064,65862-0117-01 ",.01)
 ;;65862-0117-01
 ;;9002226.02101,"1064,65862-0117-01 ",.02)
 ;;65862-0117-01
 ;;9002226.02101,"1064,65862-0118-01 ",.01)
 ;;65862-0118-01
 ;;9002226.02101,"1064,65862-0118-01 ",.02)
 ;;65862-0118-01
 ;;9002226.02101,"1064,65862-0162-30 ",.01)
 ;;65862-0162-30
 ;;9002226.02101,"1064,65862-0162-30 ",.02)
 ;;65862-0162-30
 ;;9002226.02101,"1064,65862-0162-90 ",.01)
 ;;65862-0162-90
 ;;9002226.02101,"1064,65862-0162-90 ",.02)
 ;;65862-0162-90
 ;;9002226.02101,"1064,65862-0163-90 ",.01)
 ;;65862-0163-90
 ;;9002226.02101,"1064,65862-0163-90 ",.02)
 ;;65862-0163-90
 ;;9002226.02101,"1064,65862-0164-01 ",.01)
 ;;65862-0164-01
 ;;9002226.02101,"1064,65862-0164-01 ",.02)
 ;;65862-0164-01
 ;;9002226.02101,"1064,65862-0165-01 ",.01)
 ;;65862-0165-01
 ;;9002226.02101,"1064,65862-0165-01 ",.02)
 ;;65862-0165-01
 ;;9002226.02101,"1064,65862-0166-01 ",.01)
 ;;65862-0166-01
 ;;9002226.02101,"1064,65862-0166-01 ",.02)
 ;;65862-0166-01
 ;;9002226.02101,"1064,65862-0286-01 ",.01)
 ;;65862-0286-01
 ;;9002226.02101,"1064,65862-0286-01 ",.02)
 ;;65862-0286-01
 ;;9002226.02101,"1064,65862-0287-01 ",.01)
 ;;65862-0287-01
 ;;9002226.02101,"1064,65862-0287-01 ",.02)
 ;;65862-0287-01
 ;;9002226.02101,"1064,65862-0288-01 ",.01)
 ;;65862-0288-01
 ;;9002226.02101,"1064,65862-0288-01 ",.02)
 ;;65862-0288-01
 ;;9002226.02101,"1064,65862-0308-01 ",.01)
 ;;65862-0308-01
 ;;9002226.02101,"1064,65862-0308-01 ",.02)
 ;;65862-0308-01
 ;;9002226.02101,"1064,65862-0309-01 ",.01)
 ;;65862-0309-01
 ;;9002226.02101,"1064,65862-0309-01 ",.02)
 ;;65862-0309-01
