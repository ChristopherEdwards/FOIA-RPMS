BGPM5BFW ;IHS/MSC/MMT-CREATED BY ^ATXSTX ON SEP 12, 2011;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1084,65862002900 ",.01)
 ;;65862002900
 ;;9002226.02101,"1084,65862002900 ",.02)
 ;;65862002900
 ;;9002226.02101,"1084,65862002901 ",.01)
 ;;65862002901
 ;;9002226.02101,"1084,65862002901 ",.02)
 ;;65862002901
 ;;9002226.02101,"1084,65862002905 ",.01)
 ;;65862002905
 ;;9002226.02101,"1084,65862002905 ",.02)
 ;;65862002905
 ;;9002226.02101,"1084,65862002919 ",.01)
 ;;65862002919
 ;;9002226.02101,"1084,65862002919 ",.02)
 ;;65862002919
 ;;9002226.02101,"1084,65862002930 ",.01)
 ;;65862002930
 ;;9002226.02101,"1084,65862002930 ",.02)
 ;;65862002930
 ;;9002226.02101,"1084,65862002999 ",.01)
 ;;65862002999
 ;;9002226.02101,"1084,65862002999 ",.02)
 ;;65862002999
 ;;9002226.02101,"1084,65862003000 ",.01)
 ;;65862003000
 ;;9002226.02101,"1084,65862003000 ",.02)
 ;;65862003000
 ;;9002226.02101,"1084,65862003001 ",.01)
 ;;65862003001
 ;;9002226.02101,"1084,65862003001 ",.02)
 ;;65862003001
 ;;9002226.02101,"1084,65862003005 ",.01)
 ;;65862003005
 ;;9002226.02101,"1084,65862003005 ",.02)
 ;;65862003005
 ;;9002226.02101,"1084,65862003030 ",.01)
 ;;65862003030
 ;;9002226.02101,"1084,65862003030 ",.02)
 ;;65862003030
 ;;9002226.02101,"1084,65862003075 ",.01)
 ;;65862003075
 ;;9002226.02101,"1084,65862003075 ",.02)
 ;;65862003075
 ;;9002226.02101,"1084,65862003099 ",.01)
 ;;65862003099
 ;;9002226.02101,"1084,65862003099 ",.02)
 ;;65862003099
 ;;9002226.02101,"1084,65862008001 ",.01)
 ;;65862008001
 ;;9002226.02101,"1084,65862008001 ",.02)
 ;;65862008001
 ;;9002226.02101,"1084,65862008005 ",.01)
 ;;65862008005
 ;;9002226.02101,"1084,65862008005 ",.02)
 ;;65862008005
 ;;9002226.02101,"1084,65862008030 ",.01)
 ;;65862008030
 ;;9002226.02101,"1084,65862008030 ",.02)
 ;;65862008030
 ;;9002226.02101,"1084,65862008036 ",.01)
 ;;65862008036
 ;;9002226.02101,"1084,65862008036 ",.02)
 ;;65862008036
 ;;9002226.02101,"1084,65862008101 ",.01)
 ;;65862008101
 ;;9002226.02101,"1084,65862008101 ",.02)
 ;;65862008101
 ;;9002226.02101,"1084,65862008105 ",.01)
 ;;65862008105
 ;;9002226.02101,"1084,65862008105 ",.02)
 ;;65862008105
 ;;9002226.02101,"1084,65862008118 ",.01)
 ;;65862008118
 ;;9002226.02101,"1084,65862008118 ",.02)
 ;;65862008118
 ;;9002226.02101,"1084,65862008130 ",.01)
 ;;65862008130
 ;;9002226.02101,"1084,65862008130 ",.02)
 ;;65862008130
 ;;9002226.02101,"1084,65862008201 ",.01)
 ;;65862008201
 ;;9002226.02101,"1084,65862008201 ",.02)
 ;;65862008201
 ;;9002226.02101,"1084,65862008205 ",.01)
 ;;65862008205
 ;;9002226.02101,"1084,65862008205 ",.02)
 ;;65862008205
 ;;9002226.02101,"1084,65862008218 ",.01)
 ;;65862008218
 ;;9002226.02101,"1084,65862008218 ",.02)
 ;;65862008218
 ;;9002226.02101,"1084,65862008230 ",.01)
 ;;65862008230
 ;;9002226.02101,"1084,65862008230 ",.02)
 ;;65862008230
 ;;9002226.02101,"1084,66039015901 ",.01)
 ;;66039015901
 ;;9002226.02101,"1084,66039015901 ",.02)
 ;;66039015901
 ;;9002226.02101,"1084,66039015905 ",.01)
 ;;66039015905
 ;;9002226.02101,"1084,66039015905 ",.02)
 ;;66039015905
 ;;9002226.02101,"1084,66039016001 ",.01)
 ;;66039016001
 ;;9002226.02101,"1084,66039016001 ",.02)
 ;;66039016001
 ;;9002226.02101,"1084,66039016101 ",.01)
 ;;66039016101
 ;;9002226.02101,"1084,66039016101 ",.02)
 ;;66039016101
 ;;9002226.02101,"1084,66105060010 ",.01)
 ;;66105060010
 ;;9002226.02101,"1084,66105060010 ",.02)
 ;;66105060010
 ;;9002226.02101,"1084,66105060110 ",.01)
 ;;66105060110
 ;;9002226.02101,"1084,66105060110 ",.02)
 ;;66105060110
 ;;9002226.02101,"1084,66105063202 ",.01)
 ;;66105063202
 ;;9002226.02101,"1084,66105063202 ",.02)
 ;;66105063202
 ;;9002226.02101,"1084,66105063203 ",.01)
 ;;66105063203
 ;;9002226.02101,"1084,66105063203 ",.02)
 ;;66105063203
 ;;9002226.02101,"1084,66105063206 ",.01)
 ;;66105063206
 ;;9002226.02101,"1084,66105063206 ",.02)
 ;;66105063206
 ;;9002226.02101,"1084,66105063209 ",.01)
 ;;66105063209
 ;;9002226.02101,"1084,66105063209 ",.02)
 ;;66105063209
 ;;9002226.02101,"1084,66105063210 ",.01)
 ;;66105063210
 ;;9002226.02101,"1084,66105063210 ",.02)
 ;;66105063210
 ;;9002226.02101,"1084,66105074323 ",.01)
 ;;66105074323
 ;;9002226.02101,"1084,66105074323 ",.02)
 ;;66105074323
 ;;9002226.02101,"1084,66105074423 ",.01)
 ;;66105074423
 ;;9002226.02101,"1084,66105074423 ",.02)
 ;;66105074423
 ;;9002226.02101,"1084,66105075402 ",.01)
 ;;66105075402
 ;;9002226.02101,"1084,66105075402 ",.02)
 ;;66105075402
 ;;9002226.02101,"1084,66105075403 ",.01)
 ;;66105075403
 ;;9002226.02101,"1084,66105075403 ",.02)
 ;;66105075403
 ;;9002226.02101,"1084,66105075406 ",.01)
 ;;66105075406
 ;;9002226.02101,"1084,66105075406 ",.02)
 ;;66105075406
 ;;9002226.02101,"1084,66105075409 ",.01)
 ;;66105075409
 ;;9002226.02101,"1084,66105075409 ",.02)
 ;;66105075409
 ;;9002226.02101,"1084,66105075410 ",.01)
 ;;66105075410
 ;;9002226.02101,"1084,66105075410 ",.02)
 ;;66105075410
 ;;9002226.02101,"1084,66105075602 ",.01)
 ;;66105075602
 ;;9002226.02101,"1084,66105075602 ",.02)
 ;;66105075602
 ;;9002226.02101,"1084,66105075603 ",.01)
 ;;66105075603
 ;;9002226.02101,"1084,66105075603 ",.02)
 ;;66105075603
 ;;9002226.02101,"1084,66105075606 ",.01)
 ;;66105075606
 ;;9002226.02101,"1084,66105075606 ",.02)
 ;;66105075606
 ;;9002226.02101,"1084,66105075609 ",.01)
 ;;66105075609
 ;;9002226.02101,"1084,66105075609 ",.02)
 ;;66105075609
 ;;9002226.02101,"1084,66105075610 ",.01)
 ;;66105075610
 ;;9002226.02101,"1084,66105075610 ",.02)
 ;;66105075610
 ;;9002226.02101,"1084,66105098402 ",.01)
 ;;66105098402
 ;;9002226.02101,"1084,66105098402 ",.02)
 ;;66105098402
 ;;9002226.02101,"1084,66105098403 ",.01)
 ;;66105098403
 ;;9002226.02101,"1084,66105098403 ",.02)
 ;;66105098403
 ;;9002226.02101,"1084,66105098406 ",.01)
 ;;66105098406
 ;;9002226.02101,"1084,66105098406 ",.02)
 ;;66105098406
 ;;9002226.02101,"1084,66105098409 ",.01)
 ;;66105098409
 ;;9002226.02101,"1084,66105098409 ",.02)
 ;;66105098409
 ;;9002226.02101,"1084,66105098410 ",.01)
 ;;66105098410
 ;;9002226.02101,"1084,66105098410 ",.02)
 ;;66105098410
 ;;9002226.02101,"1084,66105098411 ",.01)
 ;;66105098411
 ;;9002226.02101,"1084,66105098411 ",.02)
 ;;66105098411
 ;;9002226.02101,"1084,66105098450 ",.01)
 ;;66105098450
 ;;9002226.02101,"1084,66105098450 ",.02)
 ;;66105098450
 ;;9002226.02101,"1084,66105098502 ",.01)
 ;;66105098502
 ;;9002226.02101,"1084,66105098502 ",.02)
 ;;66105098502
 ;;9002226.02101,"1084,66105098503 ",.01)
 ;;66105098503
 ;;9002226.02101,"1084,66105098503 ",.02)
 ;;66105098503
 ;;9002226.02101,"1084,66105098506 ",.01)
 ;;66105098506
 ;;9002226.02101,"1084,66105098506 ",.02)
 ;;66105098506
 ;;9002226.02101,"1084,66105098509 ",.01)
 ;;66105098509
 ;;9002226.02101,"1084,66105098509 ",.02)
 ;;66105098509
 ;;9002226.02101,"1084,66105098510 ",.01)
 ;;66105098510
 ;;9002226.02101,"1084,66105098510 ",.02)
 ;;66105098510
 ;;9002226.02101,"1084,66105098511 ",.01)
 ;;66105098511
 ;;9002226.02101,"1084,66105098511 ",.02)
 ;;66105098511
 ;;9002226.02101,"1084,66105098550 ",.01)
 ;;66105098550
 ;;9002226.02101,"1084,66105098550 ",.02)
 ;;66105098550
 ;;9002226.02101,"1084,66105098602 ",.01)
 ;;66105098602
 ;;9002226.02101,"1084,66105098602 ",.02)
 ;;66105098602
 ;;9002226.02101,"1084,66105098603 ",.01)
 ;;66105098603
 ;;9002226.02101,"1084,66105098603 ",.02)
 ;;66105098603
 ;;9002226.02101,"1084,66105098606 ",.01)
 ;;66105098606
 ;;9002226.02101,"1084,66105098606 ",.02)
 ;;66105098606
 ;;9002226.02101,"1084,66105098609 ",.01)
 ;;66105098609
 ;;9002226.02101,"1084,66105098609 ",.02)
 ;;66105098609
 ;;9002226.02101,"1084,66105098610 ",.01)
 ;;66105098610
 ;;9002226.02101,"1084,66105098610 ",.02)
 ;;66105098610
 ;;9002226.02101,"1084,66105098611 ",.01)
 ;;66105098611
 ;;9002226.02101,"1084,66105098611 ",.02)
 ;;66105098611
 ;;9002226.02101,"1084,66105098650 ",.01)
 ;;66105098650
 ;;9002226.02101,"1084,66105098650 ",.02)
 ;;66105098650
 ;;9002226.02101,"1084,66116030530 ",.01)
 ;;66116030530
 ;;9002226.02101,"1084,66116030530 ",.02)
 ;;66116030530
 ;;9002226.02101,"1084,66116030660 ",.01)
 ;;66116030660
 ;;9002226.02101,"1084,66116030660 ",.02)
 ;;66116030660
 ;;9002226.02101,"1084,66116036060 ",.01)
 ;;66116036060
 ;;9002226.02101,"1084,66116036060 ",.02)
 ;;66116036060
 ;;9002226.02101,"1084,66116044030 ",.01)
 ;;66116044030
 ;;9002226.02101,"1084,66116044030 ",.02)
 ;;66116044030
 ;;9002226.02101,"1084,66116044060 ",.01)
 ;;66116044060
 ;;9002226.02101,"1084,66116044060 ",.02)
 ;;66116044060
 ;;9002226.02101,"1084,66116080130 ",.01)
 ;;66116080130
 ;;9002226.02101,"1084,66116080130 ",.02)
 ;;66116080130
 ;;9002226.02101,"1084,66116080560 ",.01)
 ;;66116080560
 ;;9002226.02101,"1084,66116080560 ",.02)
 ;;66116080560
 ;;9002226.02101,"1084,66116080660 ",.01)
 ;;66116080660
 ;;9002226.02101,"1084,66116080660 ",.02)
 ;;66116080660
 ;;9002226.02101,"1084,66116082760 ",.01)
 ;;66116082760
 ;;9002226.02101,"1084,66116082760 ",.02)
 ;;66116082760
 ;;9002226.02101,"1084,66116082860 ",.01)
 ;;66116082860
 ;;9002226.02101,"1084,66116082860 ",.02)
 ;;66116082860
 ;;9002226.02101,"1084,66116087030 ",.01)
 ;;66116087030
 ;;9002226.02101,"1084,66116087030 ",.02)
 ;;66116087030
 ;;9002226.02101,"1084,66143751005 ",.01)
 ;;66143751005
 ;;9002226.02101,"1084,66143751005 ",.02)
 ;;66143751005
 ;;9002226.02101,"1084,66267005460 ",.01)
 ;;66267005460
 ;;9002226.02101,"1084,66267005460 ",.02)
 ;;66267005460
 ;;9002226.02101,"1084,66267010010 ",.01)
 ;;66267010010
 ;;9002226.02101,"1084,66267010010 ",.02)
 ;;66267010010
 ;;9002226.02101,"1084,66267010020 ",.01)
 ;;66267010020
 ;;9002226.02101,"1084,66267010020 ",.02)
 ;;66267010020
 ;;9002226.02101,"1084,66267010030 ",.01)
 ;;66267010030
 ;;9002226.02101,"1084,66267010030 ",.02)
 ;;66267010030
 ;;9002226.02101,"1084,66267010060 ",.01)
 ;;66267010060
 ;;9002226.02101,"1084,66267010060 ",.02)
 ;;66267010060
 ;;9002226.02101,"1084,66267010090 ",.01)
 ;;66267010090
 ;;9002226.02101,"1084,66267010090 ",.02)
 ;;66267010090
 ;;9002226.02101,"1084,66267010205 ",.01)
 ;;66267010205
 ;;9002226.02101,"1084,66267010205 ",.02)
 ;;66267010205
 ;;9002226.02101,"1084,66267010230 ",.01)
 ;;66267010230
 ;;9002226.02101,"1084,66267010230 ",.02)
 ;;66267010230
 ;;9002226.02101,"1084,66267010312 ",.01)
 ;;66267010312
 ;;9002226.02101,"1084,66267010312 ",.02)
 ;;66267010312
 ;;9002226.02101,"1084,66267010330 ",.01)
 ;;66267010330
 ;;9002226.02101,"1084,66267010330 ",.02)
 ;;66267010330
 ;;9002226.02101,"1084,66267010360 ",.01)
 ;;66267010360
 ;;9002226.02101,"1084,66267010360 ",.02)
 ;;66267010360
 ;;9002226.02101,"1084,66267023110 ",.01)
 ;;66267023110
 ;;9002226.02101,"1084,66267023110 ",.02)
 ;;66267023110
 ;;9002226.02101,"1084,66267023115 ",.01)
 ;;66267023115
 ;;9002226.02101,"1084,66267023115 ",.02)
 ;;66267023115
 ;;9002226.02101,"1084,66267023120 ",.01)
 ;;66267023120
 ;;9002226.02101,"1084,66267023120 ",.02)
 ;;66267023120
 ;;9002226.02101,"1084,66267023130 ",.01)
 ;;66267023130
 ;;9002226.02101,"1084,66267023130 ",.02)
 ;;66267023130
 ;;9002226.02101,"1084,66267023140 ",.01)
 ;;66267023140
 ;;9002226.02101,"1084,66267023140 ",.02)
 ;;66267023140
 ;;9002226.02101,"1084,66267031630 ",.01)
 ;;66267031630
 ;;9002226.02101,"1084,66267031630 ",.02)
 ;;66267031630
 ;;9002226.02101,"1084,66267049305 ",.01)
 ;;66267049305
 ;;9002226.02101,"1084,66267049305 ",.02)
 ;;66267049305
 ;;9002226.02101,"1084,66267049312 ",.01)
 ;;66267049312
 ;;9002226.02101,"1084,66267049312 ",.02)
 ;;66267049312
 ;;9002226.02101,"1084,66267049314 ",.01)
 ;;66267049314
 ;;9002226.02101,"1084,66267049314 ",.02)
 ;;66267049314
 ;;9002226.02101,"1084,66267049318 ",.01)
 ;;66267049318