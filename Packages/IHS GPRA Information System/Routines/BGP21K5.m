BGP21K5 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1200,58016-0082-30 ",.02)
 ;;58016-0082-30
 ;;9002226.02101,"1200,58016-0082-60 ",.01)
 ;;58016-0082-60
 ;;9002226.02101,"1200,58016-0082-60 ",.02)
 ;;58016-0082-60
 ;;9002226.02101,"1200,58016-0082-90 ",.01)
 ;;58016-0082-90
 ;;9002226.02101,"1200,58016-0082-90 ",.02)
 ;;58016-0082-90
 ;;9002226.02101,"1200,58864-0670-14 ",.01)
 ;;58864-0670-14
 ;;9002226.02101,"1200,58864-0670-14 ",.02)
 ;;58864-0670-14
 ;;9002226.02101,"1200,58864-0670-30 ",.01)
 ;;58864-0670-30
 ;;9002226.02101,"1200,58864-0670-30 ",.02)
 ;;58864-0670-30
 ;;9002226.02101,"1200,58864-0687-30 ",.01)
 ;;58864-0687-30
 ;;9002226.02101,"1200,58864-0687-30 ",.02)
 ;;58864-0687-30
 ;;9002226.02101,"1200,58864-0687-60 ",.01)
 ;;58864-0687-60
 ;;9002226.02101,"1200,58864-0687-60 ",.02)
 ;;58864-0687-60
 ;;9002226.02101,"1200,58864-0745-15 ",.01)
 ;;58864-0745-15
 ;;9002226.02101,"1200,58864-0745-15 ",.02)
 ;;58864-0745-15
 ;;9002226.02101,"1200,58864-0745-30 ",.01)
 ;;58864-0745-30
 ;;9002226.02101,"1200,58864-0745-30 ",.02)
 ;;58864-0745-30
 ;;9002226.02101,"1200,58864-0827-60 ",.01)
 ;;58864-0827-60
 ;;9002226.02101,"1200,58864-0827-60 ",.02)
 ;;58864-0827-60
 ;;9002226.02101,"1200,63629-1269-01 ",.01)
 ;;63629-1269-01
 ;;9002226.02101,"1200,63629-1269-01 ",.02)
 ;;63629-1269-01
 ;;9002226.02101,"1200,64764-0151-04 ",.01)
 ;;64764-0151-04
 ;;9002226.02101,"1200,64764-0151-04 ",.02)
 ;;64764-0151-04
 ;;9002226.02101,"1200,64764-0151-05 ",.01)
 ;;64764-0151-05
 ;;9002226.02101,"1200,64764-0151-05 ",.02)
 ;;64764-0151-05
 ;;9002226.02101,"1200,64764-0151-06 ",.01)
 ;;64764-0151-06
 ;;9002226.02101,"1200,64764-0151-06 ",.02)
 ;;64764-0151-06
 ;;9002226.02101,"1200,64764-0155-18 ",.01)
 ;;64764-0155-18
 ;;9002226.02101,"1200,64764-0155-18 ",.02)
 ;;64764-0155-18
 ;;9002226.02101,"1200,64764-0155-60 ",.01)
 ;;64764-0155-60
 ;;9002226.02101,"1200,64764-0155-60 ",.02)
 ;;64764-0155-60
 ;;9002226.02101,"1200,64764-0158-18 ",.01)
 ;;64764-0158-18
 ;;9002226.02101,"1200,64764-0158-18 ",.02)
 ;;64764-0158-18
 ;;9002226.02101,"1200,64764-0158-60 ",.01)
 ;;64764-0158-60
 ;;9002226.02101,"1200,64764-0158-60 ",.02)
 ;;64764-0158-60
 ;;9002226.02101,"1200,64764-0301-14 ",.01)
 ;;64764-0301-14
 ;;9002226.02101,"1200,64764-0301-14 ",.02)
 ;;64764-0301-14
 ;;9002226.02101,"1200,64764-0301-15 ",.01)
 ;;64764-0301-15
 ;;9002226.02101,"1200,64764-0301-15 ",.02)
 ;;64764-0301-15
 ;;9002226.02101,"1200,64764-0301-16 ",.01)
 ;;64764-0301-16
 ;;9002226.02101,"1200,64764-0301-16 ",.02)
 ;;64764-0301-16
 ;;9002226.02101,"1200,64764-0302-30 ",.01)
 ;;64764-0302-30
 ;;9002226.02101,"1200,64764-0302-30 ",.02)
 ;;64764-0302-30
 ;;9002226.02101,"1200,64764-0304-30 ",.01)
 ;;64764-0304-30
 ;;9002226.02101,"1200,64764-0304-30 ",.02)
 ;;64764-0304-30
 ;;9002226.02101,"1200,64764-0310-30 ",.01)
 ;;64764-0310-30
 ;;9002226.02101,"1200,64764-0310-30 ",.02)
 ;;64764-0310-30
 ;;9002226.02101,"1200,64764-0451-24 ",.01)
 ;;64764-0451-24
 ;;9002226.02101,"1200,64764-0451-24 ",.02)
 ;;64764-0451-24
 ;;9002226.02101,"1200,64764-0451-25 ",.01)
 ;;64764-0451-25
 ;;9002226.02101,"1200,64764-0451-25 ",.02)
 ;;64764-0451-25
 ;;9002226.02101,"1200,64764-0451-26 ",.01)
 ;;64764-0451-26
 ;;9002226.02101,"1200,64764-0451-26 ",.02)
 ;;64764-0451-26
 ;;9002226.02101,"1200,64764-0510-30 ",.01)
 ;;64764-0510-30
 ;;9002226.02101,"1200,64764-0510-30 ",.02)
 ;;64764-0510-30
 ;;9002226.02101,"1200,65243-0195-09 ",.01)
 ;;65243-0195-09
 ;;9002226.02101,"1200,65243-0195-09 ",.02)
 ;;65243-0195-09
 ;;9002226.02101,"1200,65243-0195-12 ",.01)
 ;;65243-0195-12
 ;;9002226.02101,"1200,65243-0195-12 ",.02)
 ;;65243-0195-12
 ;;9002226.02101,"1200,65243-0196-09 ",.01)
 ;;65243-0196-09
 ;;9002226.02101,"1200,65243-0196-09 ",.02)
 ;;65243-0196-09
 ;;9002226.02101,"1200,66105-0145-01 ",.01)
 ;;66105-0145-01
 ;;9002226.02101,"1200,66105-0145-01 ",.02)
 ;;66105-0145-01
 ;;9002226.02101,"1200,66105-0145-03 ",.01)
 ;;66105-0145-03
 ;;9002226.02101,"1200,66105-0145-03 ",.02)
 ;;66105-0145-03
 ;;9002226.02101,"1200,66105-0145-06 ",.01)
 ;;66105-0145-06
 ;;9002226.02101,"1200,66105-0145-06 ",.02)
 ;;66105-0145-06
 ;;9002226.02101,"1200,66105-0145-09 ",.01)
 ;;66105-0145-09
 ;;9002226.02101,"1200,66105-0145-09 ",.02)
 ;;66105-0145-09
 ;;9002226.02101,"1200,66105-0145-15 ",.01)
 ;;66105-0145-15
 ;;9002226.02101,"1200,66105-0145-15 ",.02)
 ;;66105-0145-15
 ;;9002226.02101,"1200,66105-0154-01 ",.01)
 ;;66105-0154-01
 ;;9002226.02101,"1200,66105-0154-01 ",.02)
 ;;66105-0154-01
 ;;9002226.02101,"1200,66105-0154-03 ",.01)
 ;;66105-0154-03
 ;;9002226.02101,"1200,66105-0154-03 ",.02)
 ;;66105-0154-03
 ;;9002226.02101,"1200,66105-0154-06 ",.01)
 ;;66105-0154-06
 ;;9002226.02101,"1200,66105-0154-06 ",.02)
 ;;66105-0154-06
 ;;9002226.02101,"1200,66105-0154-09 ",.01)
 ;;66105-0154-09
 ;;9002226.02101,"1200,66105-0154-09 ",.02)
 ;;66105-0154-09
 ;;9002226.02101,"1200,66105-0154-15 ",.01)
 ;;66105-0154-15
 ;;9002226.02101,"1200,66105-0154-15 ",.02)
 ;;66105-0154-15
 ;;9002226.02101,"1200,66105-0156-01 ",.01)
 ;;66105-0156-01
 ;;9002226.02101,"1200,66105-0156-01 ",.02)
 ;;66105-0156-01
 ;;9002226.02101,"1200,66105-0156-03 ",.01)
 ;;66105-0156-03
 ;;9002226.02101,"1200,66105-0156-03 ",.02)
 ;;66105-0156-03
