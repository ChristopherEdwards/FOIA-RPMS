BGPM5ARI ;IHS/MSC/SAT-CREATED BY ^ATXSTX ON AUG 16, 2011;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1005,55045293808 ",.02)
 ;;55045293808
 ;;9002226.02101,"1005,55045297500 ",.01)
 ;;55045297500
 ;;9002226.02101,"1005,55045297500 ",.02)
 ;;55045297500
 ;;9002226.02101,"1005,55045297506 ",.01)
 ;;55045297506
 ;;9002226.02101,"1005,55045297506 ",.02)
 ;;55045297506
 ;;9002226.02101,"1005,55045297508 ",.01)
 ;;55045297508
 ;;9002226.02101,"1005,55045297508 ",.02)
 ;;55045297508
 ;;9002226.02101,"1005,55045300000 ",.01)
 ;;55045300000
 ;;9002226.02101,"1005,55045300000 ",.02)
 ;;55045300000
 ;;9002226.02101,"1005,55045300008 ",.01)
 ;;55045300008
 ;;9002226.02101,"1005,55045300008 ",.02)
 ;;55045300008
 ;;9002226.02101,"1005,55045305900 ",.01)
 ;;55045305900
 ;;9002226.02101,"1005,55045305900 ",.02)
 ;;55045305900
 ;;9002226.02101,"1005,55045305908 ",.01)
 ;;55045305908
 ;;9002226.02101,"1005,55045305908 ",.02)
 ;;55045305908
 ;;9002226.02101,"1005,55045315900 ",.01)
 ;;55045315900
 ;;9002226.02101,"1005,55045315900 ",.02)
 ;;55045315900
 ;;9002226.02101,"1005,55045315908 ",.01)
 ;;55045315908
 ;;9002226.02101,"1005,55045315908 ",.02)
 ;;55045315908
 ;;9002226.02101,"1005,55045317900 ",.01)
 ;;55045317900
 ;;9002226.02101,"1005,55045317900 ",.02)
 ;;55045317900
 ;;9002226.02101,"1005,55045318906 ",.01)
 ;;55045318906
 ;;9002226.02101,"1005,55045318906 ",.02)
 ;;55045318906
 ;;9002226.02101,"1005,55045322506 ",.01)
 ;;55045322506
 ;;9002226.02101,"1005,55045322506 ",.02)
 ;;55045322506
 ;;9002226.02101,"1005,55045322508 ",.01)
 ;;55045322508
 ;;9002226.02101,"1005,55045322508 ",.02)
 ;;55045322508
 ;;9002226.02101,"1005,55045335600 ",.01)
 ;;55045335600
 ;;9002226.02101,"1005,55045335600 ",.02)
 ;;55045335600
 ;;9002226.02101,"1005,55045337308 ",.01)
 ;;55045337308
 ;;9002226.02101,"1005,55045337308 ",.02)
 ;;55045337308
 ;;9002226.02101,"1005,55045340909 ",.01)
 ;;55045340909
 ;;9002226.02101,"1005,55045340909 ",.02)
 ;;55045340909
 ;;9002226.02101,"1005,55045364409 ",.01)
 ;;55045364409
 ;;9002226.02101,"1005,55045364409 ",.02)
 ;;55045364409
 ;;9002226.02101,"1005,55045377208 ",.01)
 ;;55045377208
 ;;9002226.02101,"1005,55045377208 ",.02)
 ;;55045377208
 ;;9002226.02101,"1005,55111013301 ",.01)
 ;;55111013301
 ;;9002226.02101,"1005,55111013301 ",.02)
 ;;55111013301
 ;;9002226.02101,"1005,55111013310 ",.01)
 ;;55111013310
 ;;9002226.02101,"1005,55111013310 ",.02)
 ;;55111013310
 ;;9002226.02101,"1005,55111013401 ",.01)
 ;;55111013401
 ;;9002226.02101,"1005,55111013401 ",.02)
 ;;55111013401
 ;;9002226.02101,"1005,55111013410 ",.01)
 ;;55111013410
 ;;9002226.02101,"1005,55111013410 ",.02)
 ;;55111013410
 ;;9002226.02101,"1005,55111062110 ",.01)
 ;;55111062110
 ;;9002226.02101,"1005,55111062110 ",.02)
 ;;55111062110
 ;;9002226.02101,"1005,55111062190 ",.01)
 ;;55111062190
 ;;9002226.02101,"1005,55111062190 ",.02)
 ;;55111062190
 ;;9002226.02101,"1005,55111062210 ",.01)
 ;;55111062210
 ;;9002226.02101,"1005,55111062210 ",.02)
 ;;55111062210
 ;;9002226.02101,"1005,55111062290 ",.01)
 ;;55111062290
 ;;9002226.02101,"1005,55111062290 ",.02)
 ;;55111062290
 ;;9002226.02101,"1005,55111062310 ",.01)
 ;;55111062310
 ;;9002226.02101,"1005,55111062310 ",.02)
 ;;55111062310
 ;;9002226.02101,"1005,55111062390 ",.01)
 ;;55111062390
 ;;9002226.02101,"1005,55111062390 ",.02)
 ;;55111062390
 ;;9002226.02101,"1005,55111062410 ",.01)
 ;;55111062410
 ;;9002226.02101,"1005,55111062410 ",.02)
 ;;55111062410
 ;;9002226.02101,"1005,55111062490 ",.01)
 ;;55111062490
 ;;9002226.02101,"1005,55111062490 ",.02)
 ;;55111062490
 ;;9002226.02101,"1005,55154035505 ",.01)
 ;;55154035505
 ;;9002226.02101,"1005,55154035505 ",.02)
 ;;55154035505
 ;;9002226.02101,"1005,55154052808 ",.01)
 ;;55154052808
 ;;9002226.02101,"1005,55154052808 ",.02)
 ;;55154052808
 ;;9002226.02101,"1005,55154052908 ",.01)
 ;;55154052908
 ;;9002226.02101,"1005,55154052908 ",.02)
 ;;55154052908
 ;;9002226.02101,"1005,55154068900 ",.01)
 ;;55154068900
 ;;9002226.02101,"1005,55154068900 ",.02)
 ;;55154068900
 ;;9002226.02101,"1005,55154069300 ",.01)
 ;;55154069300
 ;;9002226.02101,"1005,55154069300 ",.02)
 ;;55154069300
 ;;9002226.02101,"1005,55154073200 ",.01)
 ;;55154073200
 ;;9002226.02101,"1005,55154073200 ",.02)
 ;;55154073200
 ;;9002226.02101,"1005,55154073500 ",.01)
 ;;55154073500
 ;;9002226.02101,"1005,55154073500 ",.02)
 ;;55154073500
 ;;9002226.02101,"1005,55154120700 ",.01)
 ;;55154120700
 ;;9002226.02101,"1005,55154120700 ",.02)
 ;;55154120700
 ;;9002226.02101,"1005,55154120701 ",.01)
 ;;55154120701
 ;;9002226.02101,"1005,55154120701 ",.02)
 ;;55154120701
 ;;9002226.02101,"1005,55154120800 ",.01)
 ;;55154120800
 ;;9002226.02101,"1005,55154120800 ",.02)
 ;;55154120800
 ;;9002226.02101,"1005,55154120801 ",.01)
 ;;55154120801
 ;;9002226.02101,"1005,55154120801 ",.02)
 ;;55154120801
 ;;9002226.02101,"1005,55154120807 ",.01)
 ;;55154120807
 ;;9002226.02101,"1005,55154120807 ",.02)
 ;;55154120807
 ;;9002226.02101,"1005,55154121100 ",.01)
 ;;55154121100
 ;;9002226.02101,"1005,55154121100 ",.02)
 ;;55154121100
 ;;9002226.02101,"1005,55154121101 ",.01)
 ;;55154121101
 ;;9002226.02101,"1005,55154121101 ",.02)
 ;;55154121101
 ;;9002226.02101,"1005,55154121104 ",.01)
 ;;55154121104
 ;;9002226.02101,"1005,55154121104 ",.02)
 ;;55154121104
 ;;9002226.02101,"1005,55154121106 ",.01)
 ;;55154121106
 ;;9002226.02101,"1005,55154121106 ",.02)
 ;;55154121106
 ;;9002226.02101,"1005,55154121208 ",.01)
 ;;55154121208
 ;;9002226.02101,"1005,55154121208 ",.02)
 ;;55154121208
 ;;9002226.02101,"1005,55154202308 ",.01)
 ;;55154202308
 ;;9002226.02101,"1005,55154202308 ",.02)
 ;;55154202308
 ;;9002226.02101,"1005,55154202408 ",.01)
 ;;55154202408
 ;;9002226.02101,"1005,55154202408 ",.02)
 ;;55154202408
 ;;9002226.02101,"1005,55154225000 ",.01)
 ;;55154225000
 ;;9002226.02101,"1005,55154225000 ",.02)
 ;;55154225000
 ;;9002226.02101,"1005,55154241800 ",.01)
 ;;55154241800
 ;;9002226.02101,"1005,55154241800 ",.02)
 ;;55154241800
 ;;9002226.02101,"1005,55154241807 ",.01)
 ;;55154241807
 ;;9002226.02101,"1005,55154241807 ",.02)
 ;;55154241807
 ;;9002226.02101,"1005,55154242300 ",.01)
 ;;55154242300
 ;;9002226.02101,"1005,55154242300 ",.02)
 ;;55154242300
 ;;9002226.02101,"1005,55154242400 ",.01)
 ;;55154242400
 ;;9002226.02101,"1005,55154242400 ",.02)
 ;;55154242400
 ;;9002226.02101,"1005,55154342500 ",.01)
 ;;55154342500
 ;;9002226.02101,"1005,55154342500 ",.02)
 ;;55154342500
 ;;9002226.02101,"1005,55154342502 ",.01)
 ;;55154342502
 ;;9002226.02101,"1005,55154342502 ",.02)
 ;;55154342502
 ;;9002226.02101,"1005,55154342508 ",.01)
 ;;55154342508
 ;;9002226.02101,"1005,55154342508 ",.02)
 ;;55154342508
 ;;9002226.02101,"1005,55154370600 ",.01)
 ;;55154370600
 ;;9002226.02101,"1005,55154370600 ",.02)
 ;;55154370600
 ;;9002226.02101,"1005,55154370700 ",.01)
 ;;55154370700
 ;;9002226.02101,"1005,55154370700 ",.02)
 ;;55154370700
 ;;9002226.02101,"1005,55154370707 ",.01)
 ;;55154370707
 ;;9002226.02101,"1005,55154370707 ",.02)
 ;;55154370707
 ;;9002226.02101,"1005,55154500100 ",.01)
 ;;55154500100
 ;;9002226.02101,"1005,55154500100 ",.02)
 ;;55154500100
 ;;9002226.02101,"1005,55154500107 ",.01)
 ;;55154500107
 ;;9002226.02101,"1005,55154500107 ",.02)
 ;;55154500107
 ;;9002226.02101,"1005,55154500307 ",.01)
 ;;55154500307
 ;;9002226.02101,"1005,55154500307 ",.02)
 ;;55154500307
 ;;9002226.02101,"1005,55154501100 ",.01)
 ;;55154501100
 ;;9002226.02101,"1005,55154501100 ",.02)
 ;;55154501100
 ;;9002226.02101,"1005,55154501107 ",.01)
 ;;55154501107
 ;;9002226.02101,"1005,55154501107 ",.02)
 ;;55154501107
 ;;9002226.02101,"1005,55154501407 ",.01)
 ;;55154501407
 ;;9002226.02101,"1005,55154501407 ",.02)
 ;;55154501407
 ;;9002226.02101,"1005,55154501500 ",.01)
 ;;55154501500
 ;;9002226.02101,"1005,55154501500 ",.02)
 ;;55154501500
 ;;9002226.02101,"1005,55154501507 ",.01)
 ;;55154501507
 ;;9002226.02101,"1005,55154501507 ",.02)
 ;;55154501507
 ;;9002226.02101,"1005,55154505100 ",.01)
 ;;55154505100
 ;;9002226.02101,"1005,55154505100 ",.02)
 ;;55154505100
 ;;9002226.02101,"1005,55154505200 ",.01)
 ;;55154505200
 ;;9002226.02101,"1005,55154505200 ",.02)
 ;;55154505200
 ;;9002226.02101,"1005,55154505300 ",.01)
 ;;55154505300
 ;;9002226.02101,"1005,55154505300 ",.02)
 ;;55154505300
 ;;9002226.02101,"1005,55154546300 ",.01)
 ;;55154546300
 ;;9002226.02101,"1005,55154546300 ",.02)
 ;;55154546300
 ;;9002226.02101,"1005,55154546500 ",.01)
 ;;55154546500
 ;;9002226.02101,"1005,55154546500 ",.02)
 ;;55154546500
 ;;9002226.02101,"1005,55154547300 ",.01)
 ;;55154547300
 ;;9002226.02101,"1005,55154547300 ",.02)
 ;;55154547300
 ;;9002226.02101,"1005,55154547500 ",.01)
 ;;55154547500
 ;;9002226.02101,"1005,55154547500 ",.02)
 ;;55154547500
 ;;9002226.02101,"1005,55154549307 ",.01)
 ;;55154549307
 ;;9002226.02101,"1005,55154549307 ",.02)
 ;;55154549307
 ;;9002226.02101,"1005,55154612502 ",.01)
 ;;55154612502
 ;;9002226.02101,"1005,55154612502 ",.02)
 ;;55154612502
 ;;9002226.02101,"1005,55154612508 ",.01)
 ;;55154612508
 ;;9002226.02101,"1005,55154612508 ",.02)
 ;;55154612508
 ;;9002226.02101,"1005,55154612608 ",.01)
 ;;55154612608
 ;;9002226.02101,"1005,55154612608 ",.02)
 ;;55154612608
 ;;9002226.02101,"1005,55154615700 ",.01)
 ;;55154615700
 ;;9002226.02101,"1005,55154615700 ",.02)
 ;;55154615700
 ;;9002226.02101,"1005,55154615709 ",.01)
 ;;55154615709
 ;;9002226.02101,"1005,55154615709 ",.02)
 ;;55154615709
 ;;9002226.02101,"1005,55154615800 ",.01)
 ;;55154615800
 ;;9002226.02101,"1005,55154615800 ",.02)
 ;;55154615800
 ;;9002226.02101,"1005,55154615809 ",.01)
 ;;55154615809
 ;;9002226.02101,"1005,55154615809 ",.02)
 ;;55154615809
 ;;9002226.02101,"1005,55154615900 ",.01)
 ;;55154615900
 ;;9002226.02101,"1005,55154615900 ",.02)
 ;;55154615900
 ;;9002226.02101,"1005,55154615909 ",.01)
 ;;55154615909
 ;;9002226.02101,"1005,55154615909 ",.02)
 ;;55154615909
 ;;9002226.02101,"1005,55154617600 ",.01)
 ;;55154617600
 ;;9002226.02101,"1005,55154617600 ",.02)
 ;;55154617600
 ;;9002226.02101,"1005,55154617609 ",.01)
 ;;55154617609
 ;;9002226.02101,"1005,55154617609 ",.02)
 ;;55154617609
 ;;9002226.02101,"1005,55154619100 ",.01)
 ;;55154619100
 ;;9002226.02101,"1005,55154619100 ",.02)
 ;;55154619100
 ;;9002226.02101,"1005,55154619109 ",.01)
 ;;55154619109
 ;;9002226.02101,"1005,55154619109 ",.02)
 ;;55154619109
 ;;9002226.02101,"1005,55154620408 ",.01)
 ;;55154620408
 ;;9002226.02101,"1005,55154620408 ",.02)
 ;;55154620408
 ;;9002226.02101,"1005,55154620608 ",.01)
 ;;55154620608
 ;;9002226.02101,"1005,55154620608 ",.02)
 ;;55154620608
 ;;9002226.02101,"1005,55154620708 ",.01)
 ;;55154620708
 ;;9002226.02101,"1005,55154620708 ",.02)
 ;;55154620708
 ;;9002226.02101,"1005,55154665003 ",.01)
 ;;55154665003
 ;;9002226.02101,"1005,55154665003 ",.02)
 ;;55154665003
 ;;9002226.02101,"1005,55154665103 ",.01)
 ;;55154665103
 ;;9002226.02101,"1005,55154665103 ",.02)
 ;;55154665103
 ;;9002226.02101,"1005,55154665203 ",.01)
 ;;55154665203
 ;;9002226.02101,"1005,55154665203 ",.02)
 ;;55154665203
 ;;9002226.02101,"1005,55154665303 ",.01)
 ;;55154665303
 ;;9002226.02101,"1005,55154665303 ",.02)
 ;;55154665303
 ;;9002226.02101,"1005,55154690100 ",.01)
 ;;55154690100
 ;;9002226.02101,"1005,55154690100 ",.02)
 ;;55154690100
 ;;9002226.02101,"1005,55154690101 ",.01)
 ;;55154690101
 ;;9002226.02101,"1005,55154690101 ",.02)
 ;;55154690101
 ;;9002226.02101,"1005,55154690107 ",.01)
 ;;55154690107
 ;;9002226.02101,"1005,55154690107 ",.02)
 ;;55154690107
 ;;9002226.02101,"1005,55154961000 ",.01)
 ;;55154961000
 ;;9002226.02101,"1005,55154961000 ",.02)
 ;;55154961000