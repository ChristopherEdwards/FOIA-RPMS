BGP71S17 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 11, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"875,50436-4842-01 ",.01)
 ;;50436-4842-01
 ;;9002226.02101,"875,50436-4842-01 ",.02)
 ;;50436-4842-01
 ;;9002226.02101,"875,50436-4842-02 ",.01)
 ;;50436-4842-02
 ;;9002226.02101,"875,50436-4842-02 ",.02)
 ;;50436-4842-02
 ;;9002226.02101,"875,50436-4842-03 ",.01)
 ;;50436-4842-03
 ;;9002226.02101,"875,50436-4842-03 ",.02)
 ;;50436-4842-03
 ;;9002226.02101,"875,50436-4842-04 ",.01)
 ;;50436-4842-04
 ;;9002226.02101,"875,50436-4842-04 ",.02)
 ;;50436-4842-04
 ;;9002226.02101,"875,50436-7601-01 ",.01)
 ;;50436-7601-01
 ;;9002226.02101,"875,50436-7601-01 ",.02)
 ;;50436-7601-01
 ;;9002226.02101,"875,50436-9802-01 ",.01)
 ;;50436-9802-01
 ;;9002226.02101,"875,50436-9802-01 ",.02)
 ;;50436-9802-01
 ;;9002226.02101,"875,50436-9802-03 ",.01)
 ;;50436-9802-03
 ;;9002226.02101,"875,50436-9802-03 ",.02)
 ;;50436-9802-03
 ;;9002226.02101,"875,50436-9802-05 ",.01)
 ;;50436-9802-05
 ;;9002226.02101,"875,50436-9802-05 ",.02)
 ;;50436-9802-05
 ;;9002226.02101,"875,50436-9802-06 ",.01)
 ;;50436-9802-06
 ;;9002226.02101,"875,50436-9802-06 ",.02)
 ;;50436-9802-06
 ;;9002226.02101,"875,50458-0625-60 ",.01)
 ;;50458-0625-60
 ;;9002226.02101,"875,50458-0625-60 ",.02)
 ;;50458-0625-60
 ;;9002226.02101,"875,51021-0274-01 ",.01)
 ;;51021-0274-01
 ;;9002226.02101,"875,51021-0274-01 ",.02)
 ;;51021-0274-01
 ;;9002226.02101,"875,51021-0333-30 ",.01)
 ;;51021-0333-30
 ;;9002226.02101,"875,51021-0333-30 ",.02)
 ;;51021-0333-30
 ;;9002226.02101,"875,51021-0333-60 ",.01)
 ;;51021-0333-60
 ;;9002226.02101,"875,51021-0333-60 ",.02)
 ;;51021-0333-60
 ;;9002226.02101,"875,51079-0644-01 ",.01)
 ;;51079-0644-01
 ;;9002226.02101,"875,51079-0644-01 ",.02)
 ;;51079-0644-01
 ;;9002226.02101,"875,51079-0644-17 ",.01)
 ;;51079-0644-17
 ;;9002226.02101,"875,51079-0644-17 ",.02)
 ;;51079-0644-17
 ;;9002226.02101,"875,51079-0644-19 ",.01)
 ;;51079-0644-19
 ;;9002226.02101,"875,51079-0644-19 ",.02)
 ;;51079-0644-19
 ;;9002226.02101,"875,51079-0644-20 ",.01)
 ;;51079-0644-20
 ;;9002226.02101,"875,51079-0644-20 ",.02)
 ;;51079-0644-20
 ;;9002226.02101,"875,51079-0819-01 ",.01)
 ;;51079-0819-01
 ;;9002226.02101,"875,51079-0819-01 ",.02)
 ;;51079-0819-01
 ;;9002226.02101,"875,51079-0819-20 ",.01)
 ;;51079-0819-20
 ;;9002226.02101,"875,51079-0819-20 ",.02)
 ;;51079-0819-20
 ;;9002226.02101,"875,51525-5901-01 ",.01)
 ;;51525-5901-01
 ;;9002226.02101,"875,51525-5901-01 ",.02)
 ;;51525-5901-01
 ;;9002226.02101,"875,51655-0376-52 ",.01)
 ;;51655-0376-52
 ;;9002226.02101,"875,51655-0376-52 ",.02)
 ;;51655-0376-52
 ;;9002226.02101,"875,51655-0440-54 ",.01)
 ;;51655-0440-54
 ;;9002226.02101,"875,51655-0440-54 ",.02)
 ;;51655-0440-54
 ;;9002226.02101,"875,51991-0467-01 ",.01)
 ;;51991-0467-01
 ;;9002226.02101,"875,51991-0467-01 ",.02)
 ;;51991-0467-01
 ;;9002226.02101,"875,51991-0468-01 ",.01)
 ;;51991-0468-01
 ;;9002226.02101,"875,51991-0468-01 ",.02)
 ;;51991-0468-01
 ;;9002226.02101,"875,51991-0468-10 ",.01)
 ;;51991-0468-10
 ;;9002226.02101,"875,51991-0468-10 ",.02)
 ;;51991-0468-10
 ;;9002226.02101,"875,52244-0429-10 ",.01)
 ;;52244-0429-10
 ;;9002226.02101,"875,52244-0429-10 ",.02)
 ;;52244-0429-10
 ;;9002226.02101,"875,52244-0449-10 ",.01)
 ;;52244-0449-10
 ;;9002226.02101,"875,52244-0449-10 ",.02)
 ;;52244-0449-10
 ;;9002226.02101,"875,52959-0026-00 ",.01)
 ;;52959-0026-00
 ;;9002226.02101,"875,52959-0026-00 ",.02)
 ;;52959-0026-00
 ;;9002226.02101,"875,52959-0026-03 ",.01)
 ;;52959-0026-03
 ;;9002226.02101,"875,52959-0026-03 ",.02)
 ;;52959-0026-03
 ;;9002226.02101,"875,52959-0026-06 ",.01)
 ;;52959-0026-06
 ;;9002226.02101,"875,52959-0026-06 ",.02)
 ;;52959-0026-06
 ;;9002226.02101,"875,52959-0026-10 ",.01)
 ;;52959-0026-10
 ;;9002226.02101,"875,52959-0026-10 ",.02)
 ;;52959-0026-10
 ;;9002226.02101,"875,52959-0026-12 ",.01)
 ;;52959-0026-12
 ;;9002226.02101,"875,52959-0026-12 ",.02)
 ;;52959-0026-12
 ;;9002226.02101,"875,52959-0026-14 ",.01)
 ;;52959-0026-14
 ;;9002226.02101,"875,52959-0026-14 ",.02)
 ;;52959-0026-14
 ;;9002226.02101,"875,52959-0026-15 ",.01)
 ;;52959-0026-15
 ;;9002226.02101,"875,52959-0026-15 ",.02)
 ;;52959-0026-15
 ;;9002226.02101,"875,52959-0026-20 ",.01)
 ;;52959-0026-20
 ;;9002226.02101,"875,52959-0026-20 ",.02)
 ;;52959-0026-20
 ;;9002226.02101,"875,52959-0026-21 ",.01)
 ;;52959-0026-21
 ;;9002226.02101,"875,52959-0026-21 ",.02)
 ;;52959-0026-21
 ;;9002226.02101,"875,52959-0026-24 ",.01)
 ;;52959-0026-24
 ;;9002226.02101,"875,52959-0026-24 ",.02)
 ;;52959-0026-24
 ;;9002226.02101,"875,52959-0026-25 ",.01)
 ;;52959-0026-25
 ;;9002226.02101,"875,52959-0026-25 ",.02)
 ;;52959-0026-25
 ;;9002226.02101,"875,52959-0026-28 ",.01)
 ;;52959-0026-28
 ;;9002226.02101,"875,52959-0026-28 ",.02)
 ;;52959-0026-28
 ;;9002226.02101,"875,52959-0026-30 ",.01)
 ;;52959-0026-30
 ;;9002226.02101,"875,52959-0026-30 ",.02)
 ;;52959-0026-30
 ;;9002226.02101,"875,52959-0026-32 ",.01)
 ;;52959-0026-32
 ;;9002226.02101,"875,52959-0026-32 ",.02)
 ;;52959-0026-32
 ;;9002226.02101,"875,52959-0026-40 ",.01)
 ;;52959-0026-40
 ;;9002226.02101,"875,52959-0026-40 ",.02)
 ;;52959-0026-40
 ;;9002226.02101,"875,52959-0026-45 ",.01)
 ;;52959-0026-45
 ;;9002226.02101,"875,52959-0026-45 ",.02)
 ;;52959-0026-45
 ;;9002226.02101,"875,52959-0026-50 ",.01)
 ;;52959-0026-50
 ;;9002226.02101,"875,52959-0026-50 ",.02)
 ;;52959-0026-50
 ;;9002226.02101,"875,52959-0026-52 ",.01)
 ;;52959-0026-52
 ;;9002226.02101,"875,52959-0026-52 ",.02)
 ;;52959-0026-52
 ;;9002226.02101,"875,52959-0026-56 ",.01)
 ;;52959-0026-56
 ;;9002226.02101,"875,52959-0026-56 ",.02)
 ;;52959-0026-56
 ;;9002226.02101,"875,52959-0026-60 ",.01)
 ;;52959-0026-60
 ;;9002226.02101,"875,52959-0026-60 ",.02)
 ;;52959-0026-60
 ;;9002226.02101,"875,52959-0026-80 ",.01)
 ;;52959-0026-80
 ;;9002226.02101,"875,52959-0026-80 ",.02)
 ;;52959-0026-80
 ;;9002226.02101,"875,52959-0026-90 ",.01)
 ;;52959-0026-90
 ;;9002226.02101,"875,52959-0026-90 ",.02)
 ;;52959-0026-90
 ;;9002226.02101,"875,52959-0035-00 ",.01)
 ;;52959-0035-00
 ;;9002226.02101,"875,52959-0035-00 ",.02)
 ;;52959-0035-00
 ;;9002226.02101,"875,52959-0035-01 ",.01)
 ;;52959-0035-01
 ;;9002226.02101,"875,52959-0035-01 ",.02)
 ;;52959-0035-01
 ;;9002226.02101,"875,52959-0035-10 ",.01)
 ;;52959-0035-10
 ;;9002226.02101,"875,52959-0035-10 ",.02)
 ;;52959-0035-10
 ;;9002226.02101,"875,52959-0035-20 ",.01)
 ;;52959-0035-20
 ;;9002226.02101,"875,52959-0035-20 ",.02)
 ;;52959-0035-20
 ;;9002226.02101,"875,52959-0035-21 ",.01)
 ;;52959-0035-21
 ;;9002226.02101,"875,52959-0035-21 ",.02)
 ;;52959-0035-21
 ;;9002226.02101,"875,52959-0035-28 ",.01)
 ;;52959-0035-28
 ;;9002226.02101,"875,52959-0035-28 ",.02)
 ;;52959-0035-28
 ;;9002226.02101,"875,52959-0035-30 ",.01)
 ;;52959-0035-30
 ;;9002226.02101,"875,52959-0035-30 ",.02)
 ;;52959-0035-30
 ;;9002226.02101,"875,52959-0035-40 ",.01)
 ;;52959-0035-40
 ;;9002226.02101,"875,52959-0035-40 ",.02)
 ;;52959-0035-40
 ;;9002226.02101,"875,52959-0035-56 ",.01)
 ;;52959-0035-56
 ;;9002226.02101,"875,52959-0035-56 ",.02)
 ;;52959-0035-56
 ;;9002226.02101,"875,52959-0035-60 ",.01)
 ;;52959-0035-60
 ;;9002226.02101,"875,52959-0035-60 ",.02)
 ;;52959-0035-60
 ;;9002226.02101,"875,52959-0035-70 ",.01)
 ;;52959-0035-70
 ;;9002226.02101,"875,52959-0035-70 ",.02)
 ;;52959-0035-70
 ;;9002226.02101,"875,52959-0035-90 ",.01)
 ;;52959-0035-90
 ;;9002226.02101,"875,52959-0035-90 ",.02)
 ;;52959-0035-90
 ;;9002226.02101,"875,52959-0042-00 ",.01)
 ;;52959-0042-00
 ;;9002226.02101,"875,52959-0042-00 ",.02)
 ;;52959-0042-00
 ;;9002226.02101,"875,52959-0042-02 ",.01)
 ;;52959-0042-02
 ;;9002226.02101,"875,52959-0042-02 ",.02)
 ;;52959-0042-02
 ;;9002226.02101,"875,52959-0042-04 ",.01)
 ;;52959-0042-04
 ;;9002226.02101,"875,52959-0042-04 ",.02)
 ;;52959-0042-04
 ;;9002226.02101,"875,52959-0042-07 ",.01)
 ;;52959-0042-07
 ;;9002226.02101,"875,52959-0042-07 ",.02)
 ;;52959-0042-07
 ;;9002226.02101,"875,52959-0042-10 ",.01)
 ;;52959-0042-10
 ;;9002226.02101,"875,52959-0042-10 ",.02)
 ;;52959-0042-10
 ;;9002226.02101,"875,52959-0042-12 ",.01)
 ;;52959-0042-12
 ;;9002226.02101,"875,52959-0042-12 ",.02)
 ;;52959-0042-12
 ;;9002226.02101,"875,52959-0042-14 ",.01)
 ;;52959-0042-14
 ;;9002226.02101,"875,52959-0042-14 ",.02)
 ;;52959-0042-14
 ;;9002226.02101,"875,52959-0042-15 ",.01)
 ;;52959-0042-15
 ;;9002226.02101,"875,52959-0042-15 ",.02)
 ;;52959-0042-15
 ;;9002226.02101,"875,52959-0042-20 ",.01)
 ;;52959-0042-20
 ;;9002226.02101,"875,52959-0042-20 ",.02)
 ;;52959-0042-20
 ;;9002226.02101,"875,52959-0042-21 ",.01)
 ;;52959-0042-21
 ;;9002226.02101,"875,52959-0042-21 ",.02)
 ;;52959-0042-21
 ;;9002226.02101,"875,52959-0042-25 ",.01)
 ;;52959-0042-25
 ;;9002226.02101,"875,52959-0042-25 ",.02)
 ;;52959-0042-25
 ;;9002226.02101,"875,52959-0042-28 ",.01)
 ;;52959-0042-28
 ;;9002226.02101,"875,52959-0042-28 ",.02)
 ;;52959-0042-28
 ;;9002226.02101,"875,52959-0042-30 ",.01)
 ;;52959-0042-30
 ;;9002226.02101,"875,52959-0042-30 ",.02)
 ;;52959-0042-30
 ;;9002226.02101,"875,52959-0042-35 ",.01)
 ;;52959-0042-35
 ;;9002226.02101,"875,52959-0042-35 ",.02)
 ;;52959-0042-35
 ;;9002226.02101,"875,52959-0042-40 ",.01)
 ;;52959-0042-40
 ;;9002226.02101,"875,52959-0042-40 ",.02)
 ;;52959-0042-40
 ;;9002226.02101,"875,52959-0042-45 ",.01)
 ;;52959-0042-45
 ;;9002226.02101,"875,52959-0042-45 ",.02)
 ;;52959-0042-45
 ;;9002226.02101,"875,52959-0042-60 ",.01)
 ;;52959-0042-60
 ;;9002226.02101,"875,52959-0042-60 ",.02)
 ;;52959-0042-60
 ;;9002226.02101,"875,52959-0042-90 ",.01)
 ;;52959-0042-90
 ;;9002226.02101,"875,52959-0042-90 ",.02)
 ;;52959-0042-90
 ;;9002226.02101,"875,52959-0099-00 ",.01)
 ;;52959-0099-00
 ;;9002226.02101,"875,52959-0099-00 ",.02)
 ;;52959-0099-00
 ;;9002226.02101,"875,52959-0099-03 ",.01)
 ;;52959-0099-03
 ;;9002226.02101,"875,52959-0099-03 ",.02)
 ;;52959-0099-03
 ;;9002226.02101,"875,52959-0099-10 ",.01)
 ;;52959-0099-10
 ;;9002226.02101,"875,52959-0099-10 ",.02)
 ;;52959-0099-10
 ;;9002226.02101,"875,52959-0099-15 ",.01)
 ;;52959-0099-15
 ;;9002226.02101,"875,52959-0099-15 ",.02)
 ;;52959-0099-15
 ;;9002226.02101,"875,52959-0099-20 ",.01)
 ;;52959-0099-20
 ;;9002226.02101,"875,52959-0099-20 ",.02)
 ;;52959-0099-20
 ;;9002226.02101,"875,52959-0099-21 ",.01)
 ;;52959-0099-21
 ;;9002226.02101,"875,52959-0099-21 ",.02)
 ;;52959-0099-21
 ;;9002226.02101,"875,52959-0099-28 ",.01)
 ;;52959-0099-28
 ;;9002226.02101,"875,52959-0099-28 ",.02)
 ;;52959-0099-28
 ;;9002226.02101,"875,52959-0099-30 ",.01)
 ;;52959-0099-30
 ;;9002226.02101,"875,52959-0099-30 ",.02)
 ;;52959-0099-30
 ;;9002226.02101,"875,52959-0099-40 ",.01)
 ;;52959-0099-40
 ;;9002226.02101,"875,52959-0099-40 ",.02)
 ;;52959-0099-40
 ;;9002226.02101,"875,52959-0099-45 ",.01)
 ;;52959-0099-45
 ;;9002226.02101,"875,52959-0099-45 ",.02)
 ;;52959-0099-45
 ;;9002226.02101,"875,52959-0099-50 ",.01)
 ;;52959-0099-50
 ;;9002226.02101,"875,52959-0099-50 ",.02)
 ;;52959-0099-50
 ;;9002226.02101,"875,52959-0099-60 ",.01)
 ;;52959-0099-60
 ;;9002226.02101,"875,52959-0099-60 ",.02)
 ;;52959-0099-60
 ;;9002226.02101,"875,52959-0099-90 ",.01)
 ;;52959-0099-90
 ;;9002226.02101,"875,52959-0099-90 ",.02)
 ;;52959-0099-90
 ;;9002226.02101,"875,52959-0167-00 ",.01)
 ;;52959-0167-00
 ;;9002226.02101,"875,52959-0167-00 ",.02)
 ;;52959-0167-00
 ;;9002226.02101,"875,52959-0167-03 ",.01)
 ;;52959-0167-03
 ;;9002226.02101,"875,52959-0167-03 ",.02)
 ;;52959-0167-03
 ;;9002226.02101,"875,52959-0167-10 ",.01)
 ;;52959-0167-10
 ;;9002226.02101,"875,52959-0167-10 ",.02)
 ;;52959-0167-10
 ;;9002226.02101,"875,52959-0167-12 ",.01)
 ;;52959-0167-12
 ;;9002226.02101,"875,52959-0167-12 ",.02)
 ;;52959-0167-12