BGPM5ABJ ;IHS/MSC/MMT-CREATED BY ^ATXSTX ON JUL 15, 2011;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"880,64720014150 ",.01)
 ;;64720014150
 ;;9002226.02101,"880,64720014150 ",.02)
 ;;64720014150
 ;;9002226.02101,"880,64720014210 ",.01)
 ;;64720014210
 ;;9002226.02101,"880,64720014210 ",.02)
 ;;64720014210
 ;;9002226.02101,"880,64720014211 ",.01)
 ;;64720014211
 ;;9002226.02101,"880,64720014211 ",.02)
 ;;64720014211
 ;;9002226.02101,"880,64720014250 ",.01)
 ;;64720014250
 ;;9002226.02101,"880,64720014250 ",.02)
 ;;64720014250
 ;;9002226.02101,"880,64720016710 ",.01)
 ;;64720016710
 ;;9002226.02101,"880,64720016710 ",.02)
 ;;64720016710
 ;;9002226.02101,"880,64720016711 ",.01)
 ;;64720016711
 ;;9002226.02101,"880,64720016711 ",.02)
 ;;64720016711
 ;;9002226.02101,"880,64720016750 ",.01)
 ;;64720016750
 ;;9002226.02101,"880,64720016750 ",.02)
 ;;64720016750
 ;;9002226.02101,"880,64720016810 ",.01)
 ;;64720016810
 ;;9002226.02101,"880,64720016810 ",.02)
 ;;64720016810
 ;;9002226.02101,"880,64720016811 ",.01)
 ;;64720016811
 ;;9002226.02101,"880,64720016811 ",.02)
 ;;64720016811
 ;;9002226.02101,"880,64720016850 ",.01)
 ;;64720016850
 ;;9002226.02101,"880,64720016850 ",.02)
 ;;64720016850
 ;;9002226.02101,"880,64720016910 ",.01)
 ;;64720016910
 ;;9002226.02101,"880,64720016910 ",.02)
 ;;64720016910
 ;;9002226.02101,"880,64720016911 ",.01)
 ;;64720016911
 ;;9002226.02101,"880,64720016911 ",.02)
 ;;64720016911
 ;;9002226.02101,"880,64720016950 ",.01)
 ;;64720016950
 ;;9002226.02101,"880,64720016950 ",.02)
 ;;64720016950
 ;;9002226.02101,"880,65862008001 ",.01)
 ;;65862008001
 ;;9002226.02101,"880,65862008001 ",.02)
 ;;65862008001
 ;;9002226.02101,"880,65862008005 ",.01)
 ;;65862008005
 ;;9002226.02101,"880,65862008005 ",.02)
 ;;65862008005
 ;;9002226.02101,"880,65862008030 ",.01)
 ;;65862008030
 ;;9002226.02101,"880,65862008030 ",.02)
 ;;65862008030
 ;;9002226.02101,"880,65862008036 ",.01)
 ;;65862008036
 ;;9002226.02101,"880,65862008036 ",.02)
 ;;65862008036
 ;;9002226.02101,"880,65862008101 ",.01)
 ;;65862008101
 ;;9002226.02101,"880,65862008101 ",.02)
 ;;65862008101
 ;;9002226.02101,"880,65862008105 ",.01)
 ;;65862008105
 ;;9002226.02101,"880,65862008105 ",.02)
 ;;65862008105
 ;;9002226.02101,"880,65862008118 ",.01)
 ;;65862008118
 ;;9002226.02101,"880,65862008118 ",.02)
 ;;65862008118
 ;;9002226.02101,"880,65862008130 ",.01)
 ;;65862008130
 ;;9002226.02101,"880,65862008130 ",.02)
 ;;65862008130
 ;;9002226.02101,"880,65862008201 ",.01)
 ;;65862008201
 ;;9002226.02101,"880,65862008201 ",.02)
 ;;65862008201
 ;;9002226.02101,"880,65862008205 ",.01)
 ;;65862008205
 ;;9002226.02101,"880,65862008205 ",.02)
 ;;65862008205
 ;;9002226.02101,"880,65862008218 ",.01)
 ;;65862008218
 ;;9002226.02101,"880,65862008218 ",.02)
 ;;65862008218
 ;;9002226.02101,"880,65862008230 ",.01)
 ;;65862008230
 ;;9002226.02101,"880,65862008230 ",.02)
 ;;65862008230
 ;;9002226.02101,"880,66336078430 ",.01)
 ;;66336078430
 ;;9002226.02101,"880,66336078430 ",.02)
 ;;66336078430
 ;;9002226.02101,"880,67544036470 ",.01)
 ;;67544036470
 ;;9002226.02101,"880,67544036470 ",.02)
 ;;67544036470
 ;;9002226.02101,"880,67544041770 ",.01)
 ;;67544041770
 ;;9002226.02101,"880,67544041770 ",.02)
 ;;67544041770
 ;;9002226.02101,"880,67544051130 ",.01)
 ;;67544051130
 ;;9002226.02101,"880,67544051130 ",.02)
 ;;67544051130
 ;;9002226.02101,"880,67544051170 ",.01)
 ;;67544051170
 ;;9002226.02101,"880,67544051170 ",.02)
 ;;67544051170
 ;;9002226.02101,"880,67544051194 ",.01)
 ;;67544051194
 ;;9002226.02101,"880,67544051194 ",.02)
 ;;67544051194
 ;;9002226.02101,"880,68071002805 ",.01)
 ;;68071002805
 ;;9002226.02101,"880,68071002805 ",.02)
 ;;68071002805
 ;;9002226.02101,"880,68071002830 ",.01)
 ;;68071002830
 ;;9002226.02101,"880,68071002830 ",.02)
 ;;68071002830
 ;;9002226.02101,"880,68071002860 ",.01)
 ;;68071002860
 ;;9002226.02101,"880,68071002860 ",.02)
 ;;68071002860
 ;;9002226.02101,"880,68071016530 ",.01)
 ;;68071016530
 ;;9002226.02101,"880,68071016530 ",.02)
 ;;68071016530
 ;;9002226.02101,"880,68084013601 ",.01)
 ;;68084013601
 ;;9002226.02101,"880,68084013601 ",.02)
 ;;68084013601
 ;;9002226.02101,"880,68084013701 ",.01)
 ;;68084013701
 ;;9002226.02101,"880,68084013701 ",.02)
 ;;68084013701
 ;;9002226.02101,"880,68084013801 ",.01)
 ;;68084013801
 ;;9002226.02101,"880,68084013801 ",.02)
 ;;68084013801
 ;;9002226.02101,"880,68788096903 ",.01)
 ;;68788096903
 ;;9002226.02101,"880,68788096903 ",.02)
 ;;68788096903
 ;;9002226.02101,"880,68788096906 ",.01)
 ;;68788096906
 ;;9002226.02101,"880,68788096906 ",.02)
 ;;68788096906