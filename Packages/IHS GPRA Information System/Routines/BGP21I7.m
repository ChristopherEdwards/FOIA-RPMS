BGP21I7 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"63629-3998-01 ")
 ;;975
 ;;21,"63739-0299-10 ")
 ;;492
 ;;21,"63739-0300-10 ")
 ;;707
 ;;21,"63739-0301-10 ")
 ;;187
 ;;21,"63874-0501-01 ")
 ;;411
 ;;21,"63874-0501-04 ")
 ;;412
 ;;21,"63874-0501-10 ")
 ;;413
 ;;21,"63874-0501-14 ")
 ;;414
 ;;21,"63874-0501-20 ")
 ;;415
 ;;21,"63874-0501-24 ")
 ;;416
 ;;21,"63874-0501-28 ")
 ;;417
 ;;21,"63874-0501-30 ")
 ;;418
 ;;21,"63874-0501-60 ")
 ;;419
 ;;21,"63874-0501-90 ")
 ;;420
 ;;21,"63874-0635-01 ")
 ;;657
 ;;21,"63874-0635-10 ")
 ;;658
 ;;21,"63874-0635-20 ")
 ;;659
 ;;21,"63874-0635-28 ")
 ;;660
 ;;21,"63874-0635-30 ")
 ;;661
 ;;21,"63874-0635-60 ")
 ;;662
 ;;21,"63874-0635-90 ")
 ;;663
 ;;21,"63874-0974-01 ")
 ;;138
 ;;21,"63874-0974-30 ")
 ;;139
 ;;21,"63874-0974-60 ")
 ;;140
 ;;21,"64679-0528-04 ")
 ;;521
 ;;21,"64679-0528-05 ")
 ;;522
 ;;21,"64679-0529-04 ")
 ;;724
 ;;21,"64679-0529-05 ")
 ;;725
 ;;21,"64679-0530-04 ")
 ;;206
 ;;21,"64679-0530-05 ")
 ;;207
 ;;21,"64764-0155-18 ")
 ;;1120
 ;;21,"64764-0155-60 ")
 ;;1121
 ;;21,"64764-0158-18 ")
 ;;1126
 ;;21,"64764-0158-60 ")
 ;;1127
 ;;21,"64764-0310-30 ")
 ;;1129
 ;;21,"64764-0510-30 ")
 ;;1128
 ;;21,"65162-0174-10 ")
 ;;664
 ;;21,"65162-0174-11 ")
 ;;665
 ;;21,"65162-0174-50 ")
 ;;666
 ;;21,"65162-0175-10 ")
 ;;421
 ;;21,"65162-0175-11 ")
 ;;422
 ;;21,"65162-0175-50 ")
 ;;423
 ;;21,"65162-0177-10 ")
 ;;819
 ;;21,"65162-0177-11 ")
 ;;141
 ;;21,"65162-0177-50 ")
 ;;820
 ;;21,"65162-0179-10 ")
 ;;880
 ;;21,"65243-0239-09 ")
 ;;667
 ;;21,"65243-0239-18 ")
 ;;668
 ;;21,"65243-0239-27 ")
 ;;669
 ;;21,"65243-0288-06 ")
 ;;424
 ;;21,"65243-0288-09 ")
 ;;425
 ;;21,"65243-0288-12 ")
 ;;426
 ;;21,"65243-0288-18 ")
 ;;427
 ;;21,"65243-0289-06 ")
 ;;142
 ;;21,"65243-0289-09 ")
 ;;143
 ;;21,"65243-0289-12 ")
 ;;144
 ;;21,"65243-0289-18 ")
 ;;145
 ;;21,"65243-0371-06 ")
 ;;146
 ;;21,"65243-0371-09 ")
 ;;147
 ;;21,"65243-0372-06 ")
 ;;428
 ;;21,"65243-0372-09 ")
 ;;429
 ;;21,"65243-0372-18 ")
 ;;430
 ;;21,"65243-0373-09 ")
 ;;670
 ;;21,"65862-0008-01 ")
 ;;431
 ;;21,"65862-0008-05 ")
 ;;432
 ;;21,"65862-0008-90 ")
 ;;433
 ;;21,"65862-0008-99 ")
 ;;228
 ;;21,"65862-0009-01 ")
 ;;671
 ;;21,"65862-0009-05 ")
 ;;672
 ;;21,"65862-0009-90 ")
 ;;673
 ;;21,"65862-0010-01 ")
 ;;148
 ;;21,"65862-0010-05 ")
 ;;149
 ;;21,"65862-0010-90 ")
 ;;150
 ;;21,"65862-0010-99 ")
 ;;11
 ;;21,"65862-0080-01 ")
 ;;976
 ;;21,"65862-0080-05 ")
 ;;977
 ;;21,"65862-0081-01 ")
 ;;1021
 ;;21,"65862-0081-05 ")
 ;;1022
 ;;21,"65862-0082-01 ")
 ;;1083
 ;;21,"65862-0082-05 ")
 ;;1084
 ;;21,"66116-0233-30 ")
 ;;1023
 ;;21,"66116-0282-60 ")
 ;;434
 ;;21,"66116-0293-30 ")
 ;;151
 ;;21,"66116-0454-30 ")
 ;;435
 ;;21,"66116-0695-60 ")
 ;;436
 ;;21,"66267-0493-14 ")
 ;;437
 ;;21,"66267-0493-30 ")
 ;;438
 ;;21,"66267-0493-60 ")
 ;;439
 ;;21,"66267-0493-90 ")
 ;;440
 ;;21,"66267-0493-91 ")
 ;;441
 ;;21,"66267-0493-92 ")
 ;;442
 ;;21,"66267-0493-93 ")
 ;;443
 ;;21,"66336-0270-30 ")
 ;;821
 ;;21,"66336-0270-60 ")
 ;;822
 ;;21,"66336-0270-90 ")
 ;;823
 ;;21,"66336-0292-60 ")
 ;;824
 ;;21,"66336-0319-30 ")
 ;;1085
 ;;21,"66336-0358-30 ")
 ;;152
 ;;21,"66336-0358-60 ")
 ;;153
 ;;21,"66336-0358-90 ")
 ;;154
 ;;21,"66336-0784-30 ")
 ;;1086
 ;;21,"66336-0784-60 ")
 ;;1087
 ;;21,"66336-0784-90 ")
 ;;1088
 ;;21,"66336-0850-30 ")
 ;;992
 ;;21,"66336-0850-60 ")
 ;;993
 ;;21,"66336-0883-30 ")
 ;;674
 ;;21,"66336-0883-60 ")
 ;;675
 ;;21,"66336-0884-14 ")
 ;;444
 ;;21,"66336-0884-28 ")
 ;;445
 ;;21,"66336-0884-30 ")
 ;;446
 ;;21,"66336-0884-60 ")
 ;;447
 ;;21,"66336-0884-62 ")
 ;;448
 ;;21,"66336-0884-90 ")
 ;;449
 ;;21,"66689-0011-60 ")
 ;;511
 ;;21,"67544-0047-30 ")
 ;;450
 ;;21,"67544-0047-53 ")
 ;;451
 ;;21,"67544-0047-60 ")
 ;;452
 ;;21,"67544-0047-70 ")
 ;;453
 ;;21,"67544-0047-75 ")
 ;;454
 ;;21,"67544-0047-80 ")
 ;;455
 ;;21,"67544-0047-90 ")
 ;;456
 ;;21,"67544-0047-92 ")
 ;;457
 ;;21,"67544-0047-94 ")
 ;;458
 ;;21,"67544-0047-96 ")
 ;;459
 ;;21,"67544-0107-53 ")
 ;;676
 ;;21,"67544-0107-60 ")
 ;;677
 ;;21,"67544-0107-80 ")
 ;;678
 ;;21,"67544-0107-92 ")
 ;;679
 ;;21,"67544-0163-30 ")
 ;;155
 ;;21,"67544-0163-45 ")
 ;;156
 ;;21,"67544-0163-53 ")
 ;;157
 ;;21,"67544-0163-60 ")
 ;;158
 ;;21,"67544-0163-80 ")
 ;;159
 ;;21,"67544-0296-70 ")
 ;;1089
 ;;21,"67544-0364-70 ")
 ;;1090
 ;;21,"67544-0417-70 ")
 ;;1091
 ;;21,"67544-0421-60 ")
 ;;680
 ;;21,"67544-0421-80 ")
 ;;681
 ;;21,"67544-0421-92 ")
 ;;682
 ;;21,"67544-0422-30 ")
 ;;825
 ;;21,"67544-0422-53 ")
 ;;826
 ;;21,"67544-0422-60 ")
 ;;827
 ;;21,"67544-0422-70 ")
 ;;828
 ;;21,"67544-0422-75 ")
 ;;829
 ;;21,"67544-0422-80 ")
 ;;830
 ;;21,"67544-0422-90 ")
 ;;831
 ;;21,"67544-0422-92 ")
 ;;832
 ;;21,"67544-0422-94 ")
 ;;833
 ;;21,"67544-0422-96 ")
 ;;834
 ;;21,"67544-0424-30 ")
 ;;460
 ;;21,"67544-0424-53 ")
 ;;461
 ;;21,"67544-0424-60 ")
 ;;462
