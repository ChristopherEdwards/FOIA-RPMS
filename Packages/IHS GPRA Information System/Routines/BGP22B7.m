BGP22B7 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 21, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"54868-5313-00 ")
 ;;234
 ;;21,"54868-5313-01 ")
 ;;235
 ;;21,"54868-5320-00 ")
 ;;163
 ;;21,"54868-5320-01 ")
 ;;164
 ;;21,"54868-5320-02 ")
 ;;165
 ;;21,"54868-5320-03 ")
 ;;166
 ;;21,"54868-5320-04 ")
 ;;167
 ;;21,"54868-5323-00 ")
 ;;3621
 ;;21,"54868-5323-01 ")
 ;;3622
 ;;21,"54868-5346-00 ")
 ;;327
 ;;21,"54868-5346-01 ")
 ;;328
 ;;21,"54868-5392-00 ")
 ;;896
 ;;21,"54868-5418-00 ")
 ;;3557
 ;;21,"54868-5423-00 ")
 ;;2902
 ;;21,"54868-5423-01 ")
 ;;2903
 ;;21,"54868-5465-00 ")
 ;;3383
 ;;21,"54868-5465-01 ")
 ;;3384
 ;;21,"54868-5466-00 ")
 ;;3706
 ;;21,"54868-5466-01 ")
 ;;3707
 ;;21,"54868-5469-00 ")
 ;;336
 ;;21,"54868-5469-01 ")
 ;;337
 ;;21,"54868-5475-00 ")
 ;;636
 ;;21,"54868-5489-00 ")
 ;;3691
 ;;21,"54868-5503-00 ")
 ;;319
 ;;21,"54868-5503-01 ")
 ;;320
 ;;21,"54868-5548-00 ")
 ;;152
 ;;21,"54868-5548-01 ")
 ;;153
 ;;21,"54868-5548-02 ")
 ;;154
 ;;21,"54868-5591-00 ")
 ;;3686
 ;;21,"54868-5607-00 ")
 ;;3638
 ;;21,"54868-5607-01 ")
 ;;3639
 ;;21,"54868-5690-00 ")
 ;;39
 ;;21,"54868-5690-01 ")
 ;;40
 ;;21,"54868-5690-02 ")
 ;;41
 ;;21,"54868-5690-03 ")
 ;;42
 ;;21,"54868-5705-00 ")
 ;;3411
 ;;21,"54868-5747-00 ")
 ;;3044
 ;;21,"54868-5747-01 ")
 ;;3045
 ;;21,"54868-5780-00 ")
 ;;3630
 ;;21,"54868-5780-01 ")
 ;;3631
 ;;21,"54868-5781-00 ")
 ;;24
 ;;21,"54868-5781-01 ")
 ;;25
 ;;21,"54868-5781-02 ")
 ;;26
 ;;21,"54868-5781-03 ")
 ;;27
 ;;21,"54868-5782-00 ")
 ;;123
 ;;21,"54868-5782-01 ")
 ;;124
 ;;21,"54868-5782-02 ")
 ;;125
 ;;21,"54868-5782-03 ")
 ;;126
 ;;21,"54868-5782-04 ")
 ;;127
 ;;21,"54868-5783-00 ")
 ;;140
 ;;21,"54868-5783-01 ")
 ;;141
 ;;21,"54868-5787-00 ")
 ;;260
 ;;21,"54868-5792-00 ")
 ;;86
 ;;21,"54868-5792-01 ")
 ;;87
 ;;21,"54868-5792-02 ")
 ;;88
 ;;21,"54868-5793-00 ")
 ;;57
 ;;21,"54868-5793-01 ")
 ;;58
 ;;21,"54868-5804-00 ")
 ;;3316
 ;;21,"54868-5842-00 ")
 ;;3197
 ;;21,"54868-5842-01 ")
 ;;3198
 ;;21,"54868-5842-02 ")
 ;;3199
 ;;21,"54868-5842-03 ")
 ;;3200
 ;;21,"54868-5843-00 ")
 ;;3091
 ;;21,"54868-5843-01 ")
 ;;3092
 ;;21,"54868-5843-02 ")
 ;;3093
 ;;21,"54868-5856-00 ")
 ;;3144
 ;;21,"54868-5856-01 ")
 ;;3145
 ;;21,"54868-5896-00 ")
 ;;3046
 ;;21,"54868-5928-00 ")
 ;;2904
 ;;21,"54868-5977-00 ")
 ;;4077
 ;;21,"54868-5983-00 ")
 ;;3319
 ;;21,"54868-5983-01 ")
 ;;3320
 ;;21,"54868-5996-00 ")
 ;;3326
 ;;21,"54868-5996-01 ")
 ;;3327
 ;;21,"54868-5997-00 ")
 ;;3323
 ;;21,"54868-5997-01 ")
 ;;3324
 ;;21,"54868-6036-00 ")
 ;;3309
 ;;21,"54868-6061-00 ")
 ;;3278
 ;;21,"54868-6061-01 ")
 ;;3279
 ;;21,"54868-6104-00 ")
 ;;3930
 ;;21,"54868-6104-01 ")
 ;;3931
 ;;21,"54868-6107-00 ")
 ;;3805
 ;;21,"54868-6107-01 ")
 ;;3806
 ;;21,"54868-6108-00 ")
 ;;3412
 ;;21,"54868-6108-01 ")
 ;;3413
 ;;21,"54868-6109-00 ")
 ;;3455
 ;;21,"54868-6109-01 ")
 ;;3456
 ;;21,"54868-6110-00 ")
 ;;3510
 ;;21,"54868-6110-01 ")
 ;;3511
 ;;21,"54868-6117-00 ")
 ;;3864
 ;;21,"54868-6123-00 ")
 ;;3288
 ;;21,"54868-6193-00 ")
 ;;4001
 ;;21,"54868-6250-00 ")
 ;;3305
 ;;21,"55045-1820-08 ")
 ;;1239
 ;;21,"55045-2201-01 ")
 ;;845
 ;;21,"55045-2376-00 ")
 ;;1092
 ;;21,"55045-2376-08 ")
 ;;1093
 ;;21,"55045-2376-09 ")
 ;;1094
 ;;21,"55045-2424-00 ")
 ;;1197
 ;;21,"55045-2424-06 ")
 ;;1198
 ;;21,"55045-2799-00 ")
 ;;1678
 ;;21,"55045-2827-00 ")
 ;;1322
 ;;21,"55045-2827-08 ")
 ;;1323
 ;;21,"55045-2832-00 ")
 ;;1539
 ;;21,"55045-2832-08 ")
 ;;1540
 ;;21,"55045-2929-06 ")
 ;;2058
 ;;21,"55045-2929-08 ")
 ;;2059
 ;;21,"55045-2936-00 ")
 ;;2372
 ;;21,"55045-2937-00 ")
 ;;2060
 ;;21,"55045-2938-00 ")
 ;;2799
 ;;21,"55045-2938-08 ")
 ;;2800
 ;;21,"55045-2975-00 ")
 ;;2628
 ;;21,"55045-2975-06 ")
 ;;2629
 ;;21,"55045-2975-08 ")
 ;;2630
 ;;21,"55045-3000-00 ")
 ;;478
 ;;21,"55045-3059-00 ")
 ;;2194
 ;;21,"55045-3059-08 ")
 ;;2195
 ;;21,"55045-3159-00 ")
 ;;394
 ;;21,"55045-3225-06 ")
 ;;565
 ;;21,"55045-3373-08 ")
 ;;321
 ;;21,"55045-3401-08 ")
 ;;3932
 ;;21,"55045-3409-09 ")
 ;;4105
 ;;21,"55045-3772-08 ")
 ;;2373
 ;;21,"55111-0133-01 ")
 ;;322
 ;;21,"55111-0134-01 ")
 ;;299
 ;;21,"55111-0338-01 ")
 ;;59
 ;;21,"55111-0339-01 ")
 ;;89
 ;;21,"55111-0339-05 ")
 ;;90
 ;;21,"55111-0340-01 ")
 ;;128
 ;;21,"55111-0340-05 ")
 ;;129
 ;;21,"55111-0341-01 ")
 ;;28
 ;;21,"55111-0341-05 ")
 ;;29
 ;;21,"55111-0438-90 ")
 ;;3047
 ;;21,"55111-0439-05 ")
 ;;3146
 ;;21,"55111-0439-90 ")
 ;;3147
 ;;21,"55111-0440-05 ")
 ;;3201
 ;;21,"55111-0440-90 ")
 ;;3202
 ;;21,"55111-0441-05 ")
 ;;3094
 ;;21,"55111-0441-90 ")
 ;;3095
 ;;21,"55111-0621-90 ")
 ;;3019
 ;;21,"55111-0622-90 ")
 ;;2931
 ;;21,"55111-0623-90 ")
 ;;2960
 ;;21,"55111-0624-90 ")
 ;;2989
 ;;21,"55289-0039-30 ")
 ;;130
 ;;21,"55289-0086-30 ")
 ;;772
 ;;21,"55289-0096-30 ")
 ;;91
 ;;21,"55289-0106-30 ")
 ;;2374
 ;;21,"55289-0109-30 ")
 ;;647
 ;;21,"55289-0109-97 ")
 ;;692
 ;;21,"55289-0212-30 ")
 ;;1199
 ;;21,"55289-0212-90 ")
 ;;1200
 ;;21,"55289-0238-30 ")
 ;;3807
 ;;21,"55289-0344-30 ")
 ;;1095
 ;;21,"55289-0344-90 ")
 ;;1096
 ;;21,"55289-0436-30 ")
 ;;3986
 ;;21,"55289-0443-30 ")
 ;;3550
 ;;21,"55289-0483-30 ")
 ;;1324
 ;;21,"55289-0484-30 ")
 ;;300
 ;;21,"55289-0506-30 ")
 ;;1042
 ;;21,"55289-0506-97 ")
 ;;1097
 ;;21,"55289-0509-30 ")
 ;;2061
 ;;21,"55289-0522-30 ")
 ;;3457
 ;;21,"55289-0552-30 ")
 ;;3030
 ;;21,"55289-0553-30 ")
 ;;2945
 ;;21,"55289-0554-30 ")
 ;;2977
 ;;21,"55289-0555-30 ")
 ;;3003
 ;;21,"55289-0573-30 ")
 ;;518
 ;;21,"55289-0577-30 ")
 ;;2375
 ;;21,"55289-0591-30 ")
 ;;1325
 ;;21,"55289-0591-90 ")
 ;;1326
 ;;21,"55289-0622-03 ")
 ;;1679
 ;;21,"55289-0622-30 ")
 ;;1680
 ;;21,"55289-0638-01 ")
 ;;2062
 ;;21,"55289-0638-12 ")
 ;;2063
 ;;21,"55289-0638-14 ")
 ;;2064
 ;;21,"55289-0638-30 ")
 ;;2065
 ;;21,"55289-0638-60 ")
 ;;2066
 ;;21,"55289-0638-90 ")
 ;;2067
 ;;21,"55289-0638-98 ")
 ;;2068
 ;;21,"55289-0694-10 ")
 ;;1681
 ;;21,"55289-0694-30 ")
 ;;1682
 ;;21,"55289-0694-90 ")
 ;;1683
 ;;21,"55289-0696-14 ")
 ;;2376
 ;;21,"55289-0696-30 ")
 ;;2377
 ;;21,"55289-0696-60 ")
 ;;2378
 ;;21,"55289-0696-90 ")
 ;;2379
 ;;21,"55289-0696-98 ")
 ;;2380
 ;;21,"55289-0815-30 ")
 ;;3661
 ;;21,"55289-0817-30 ")
 ;;4047
 ;;21,"55289-0820-30 ")
 ;;3623
 ;;21,"55289-0825-30 ")
 ;;4106
 ;;21,"55289-0838-30 ")
 ;;3594
 ;;21,"55289-0867-30 ")
 ;;3096
 ;;21,"55289-0876-30 ")
 ;;4068
 ;;21,"55289-0878-30 ")
 ;;566
 ;;21,"55289-0884-30 ")
 ;;2801
 ;;21,"55289-0884-90 ")
 ;;2802
 ;;21,"55289-0917-30 ")
 ;;2631
 ;;21,"55289-0917-90 ")
 ;;2632
 ;;21,"55289-0929-08 ")
 ;;2069
 ;;21,"55289-0929-30 ")
 ;;2070
 ;;21,"55289-0963-30 ")
 ;;897
 ;;21,"55289-0981-30 ")
 ;;30
 ;;21,"55289-0984-30 ")
 ;;1541
 ;;21,"55370-0142-07 ")
 ;;1009
 ;;21,"55370-0142-09 ")
 ;;1010
 ;;21,"55370-0144-07 ")
 ;;1125
 ;;21,"55370-0144-09 ")
 ;;1126
 ;;21,"55370-0145-07 ")
 ;;907
 ;;21,"55370-0164-07 ")
 ;;939
 ;;21,"55370-0164-09 ")
 ;;940
 ;;21,"55887-0099-30 ")
 ;;1409
 ;;21,"55887-0223-30 ")
 ;;812
 ;;21,"55887-0227-30 ")
 ;;1490
 ;;21,"55887-0227-60 ")
 ;;1491
 ;;21,"55887-0322-30 ")
 ;;729
 ;;21,"55887-0366-30 ")
 ;;177
 ;;21,"55887-0366-60 ")
 ;;173
 ;;21,"55887-0366-90 ")
 ;;174
 ;;21,"55887-0392-30 ")
 ;;4024
 ;;21,"55887-0392-60 ")
 ;;4025
 ;;21,"55887-0392-90 ")
 ;;4026
 ;;21,"55887-0425-30 ")
 ;;349
 ;;21,"55887-0425-60 ")
 ;;350
 ;;21,"55887-0425-82 ")
 ;;346
 ;;21,"55887-0425-90 ")
 ;;351
 ;;21,"55887-0426-30 ")
 ;;427
 ;;21,"55887-0426-60 ")
 ;;428
 ;;21,"55887-0426-82 ")
 ;;421
 ;;21,"55887-0426-90 ")
 ;;429
 ;;21,"55887-0432-30 ")
 ;;3830
 ;;21,"55887-0432-60 ")
 ;;3831
 ;;21,"55887-0432-90 ")
 ;;3829
 ;;21,"55887-0532-30 ")
 ;;520
 ;;21,"55887-0532-90 ")
 ;;521
 ;;21,"55887-0558-30 ")
 ;;1492
 ;;21,"55887-0558-60 ")
 ;;1479
 ;;21,"55887-0558-82 ")
 ;;1480
 ;;21,"55887-0558-90 ")
 ;;1493
 ;;21,"55887-0569-30 ")
 ;;2536
 ;;21,"55887-0569-60 ")
 ;;2537
 ;;21,"55887-0569-82 ")
 ;;2523
 ;;21,"55887-0569-90 ")
 ;;2538
 ;;21,"55887-0581-30 ")
 ;;2249
 ;;21,"55887-0581-60 ")
 ;;2250
 ;;21,"55887-0581-82 ")
 ;;2251
 ;;21,"55887-0581-90 ")
 ;;2252
 ;;21,"55887-0582-30 ")
 ;;1151
 ;;21,"55887-0582-60 ")
 ;;1152
 ;;21,"55887-0582-90 ")
 ;;1153
 ;;21,"55887-0589-30 ")
 ;;2712
 ;;21,"55887-0589-60 ")
 ;;2713
 ;;21,"55887-0589-82 ")
 ;;2714
 ;;21,"55887-0589-90 ")
 ;;2715
 ;;21,"55887-0590-30 ")
 ;;2156
 ;;21,"55887-0590-60 ")
 ;;2157
 ;;21,"55887-0590-82 ")
 ;;2158
 ;;21,"55887-0590-90 ")
 ;;2159
 ;;21,"55887-0591-01 ")
 ;;1946
 ;;21,"55887-0591-20 ")
 ;;1947
 ;;21,"55887-0591-30 ")
 ;;1948
 ;;21,"55887-0591-60 ")
 ;;1949
 ;;21,"55887-0591-82 ")
 ;;1950
 ;;21,"55887-0591-90 ")
 ;;1951
 ;;21,"55887-0594-30 ")
 ;;308
 ;;21,"55887-0594-60 ")
 ;;305
 ;;21,"55887-0594-82 ")
 ;;306
 ;;21,"55887-0594-90 ")
 ;;309
 ;;21,"55887-0595-30 ")
 ;;282
 ;;21,"55887-0595-60 ")
 ;;280
 ;;21,"55887-0595-82 ")
 ;;281
 ;;21,"55887-0595-90 ")
 ;;283
 ;;21,"55887-0596-30 ")
 ;;1629
 ;;21,"55887-0596-60 ")
 ;;1630
 ;;21,"55887-0596-82 ")
 ;;1617
 ;;21,"55887-0596-90 ")
 ;;1631
 ;;21,"55887-0612-30 ")
 ;;1265
 ;;21,"55887-0612-60 ")
 ;;1253
 ;;21,"55887-0612-82 ")
 ;;1254
 ;;21,"55887-0612-90 ")
 ;;1266
 ;;21,"55887-0984-30 ")
 ;;1399
 ;;21,"55887-0987-30 ")
 ;;2927
 ;;21,"55953-0132-40 ")
 ;;941
 ;;21,"57866-0064-09 ")
 ;;356
 ;;21,"57866-0065-01 ")
 ;;434
 ;;21,"57866-0245-01 ")
 ;;2724
 ;;21,"57866-0246-01 ")
 ;;1963
 ;;21,"57866-0249-01 ")
 ;;1049
 ;;21,"57866-0274-01 ")
 ;;1868
 ;;21,"57866-0275-02 ")
 ;;1736
 ;;21,"57866-2000-01 ")
 ;;2725
 ;;21,"57866-2000-02 ")
 ;;2726
 ;;21,"57866-2901-02 ")
 ;;4081
 ;;21,"57866-3136-01 ")
 ;;2071
 ;;21,"57866-3138-01 ")
 ;;1788
 ;;21,"57866-4000-01 ")
 ;;1964
 ;;21,"57866-4000-02 ")
 ;;1965
 ;;21,"57866-4420-01 ")
 ;;2932
 ;;21,"57866-4421-01 ")
 ;;2961
 ;;21,"57866-4423-01 ")
 ;;3020
 ;;21,"57866-4424-01 ")
 ;;2990
 ;;21,"57866-5000-01 ")
 ;;2265
 ;;21,"57866-5000-02 ")
 ;;2266
 ;;21,"57866-6000-01 ")
 ;;2464
 ;;21,"57866-6103-01 ")
 ;;1158
 ;;21,"57866-6103-02 ")
 ;;1159
 ;;21,"57866-6103-03 ")
 ;;1160
 ;;21,"57866-6103-04 ")
 ;;1161
 ;;21,"57866-6106-01 ")
 ;;1050
 ;;21,"57866-6106-02 ")
 ;;1051
 ;;21,"57866-6106-03 ")
 ;;1052
 ;;21,"57866-6106-04 ")
 ;;1053
 ;;21,"57866-6700-02 ")
 ;;1966
 ;;21,"57866-6701-02 ")
 ;;2267
 ;;21,"57866-6705-01 ")
 ;;1967
 ;;21,"57866-6706-01 ")
 ;;2268
 ;;21,"57866-6859-01 ")
 ;;1636
 ;;21,"57866-6859-02 ")
 ;;1637
 ;;21,"57866-6859-03 ")
 ;;1638
 ;;21,"57866-6859-04 ")
 ;;1639
 ;;21,"57866-7000-01 ")
 ;;357
 ;;21,"57866-7985-01 ")
 ;;2727
 ;;21,"57866-7989-01 ")
 ;;2518
 ;;21,"57866-7992-01 ")
 ;;435
 ;;21,"57866-8000-01 ")
 ;;436
 ;;21,"57866-8000-02 ")
 ;;437
 ;;21,"57866-8700-01 ")
 ;;2547
 ;;21,"58016-0053-00 ")
 ;;3987
 ;;21,"58016-0053-30 ")
 ;;3988
 ;;21,"58016-0053-60 ")
 ;;3989
 ;;21,"58016-0053-90 ")
 ;;3990
 ;;21,"58016-0065-00 ")
 ;;209
 ;;21,"58016-0065-30 ")
 ;;210
 ;;21,"58016-0065-60 ")
 ;;211
 ;;21,"58016-0065-90 ")
 ;;212
 ;;21,"58016-0066-00 ")
 ;;3967
 ;;21,"58016-0066-30 ")
 ;;3968
 ;;21,"58016-0066-60 ")
 ;;3969
 ;;21,"58016-0066-90 ")
 ;;3970
 ;;21,"58016-0069-00 ")
 ;;2488
 ;;21,"58016-0069-30 ")
 ;;2489
 ;;21,"58016-0069-60 ")
 ;;2490
 ;;21,"58016-0069-90 ")
 ;;2491
 ;;21,"58016-0228-00 ")
 ;;479
 ;;21,"58016-0228-02 ")
 ;;480
 ;;21,"58016-0228-30 ")
 ;;481
 ;;21,"58016-0228-60 ")
 ;;482
 ;;21,"58016-0228-90 ")
 ;;483
 ;;21,"58016-0363-00 ")
 ;;2381
 ;;21,"58016-0363-14 ")
 ;;2382
 ;;21,"58016-0363-21 ")
 ;;2383
 ;;21,"58016-0363-30 ")
 ;;2384
 ;;21,"58016-0363-60 ")
 ;;2385
 ;;21,"58016-0420-00 ")
 ;;693
 ;;21,"58016-0420-10 ")
 ;;694
 ;;21,"58016-0420-30 ")
 ;;695
 ;;21,"58016-0420-60 ")
 ;;696
 ;;21,"58016-0420-90 ")
 ;;697
 ;;21,"58016-0564-00 ")
 ;;2803
 ;;21,"58016-0564-30 ")
 ;;2804
 ;;21,"58016-0564-60 ")
 ;;2805
 ;;21,"58016-0564-90 ")
 ;;2806
 ;;21,"58016-0571-00 ")
 ;;1542
 ;;21,"58016-0571-30 ")
 ;;1543
 ;;21,"58016-0571-60 ")
 ;;1544
 ;;21,"58016-0571-90 ")
 ;;1545
 ;;21,"58016-0579-00 ")
 ;;1684
 ;;21,"58016-0579-20 ")
 ;;1685
 ;;21,"58016-0579-30 ")
 ;;1686
 ;;21,"58016-0579-60 ")
 ;;1687
 ;;21,"58016-0580-00 ")
 ;;1327
 ;;21,"58016-0580-20 ")
 ;;1328
 ;;21,"58016-0580-30 ")
 ;;1329
 ;;21,"58016-0580-60 ")
 ;;1330
 ;;21,"58016-0581-00 ")
 ;;1546
 ;;21,"58016-0581-20 ")
 ;;1547
 ;;21,"58016-0581-30 ")
 ;;1548
 ;;21,"58016-0581-60 ")
 ;;1549
 ;;21,"58016-0646-00 ")
 ;;2519
 ;;21,"58016-0646-30 ")
 ;;2520
 ;;21,"58016-0646-60 ")
 ;;2521
 ;;21,"58016-0646-90 ")
 ;;2522
 ;;21,"58016-0685-00 ")
 ;;773
 ;;21,"58016-0685-10 ")
 ;;774
 ;;21,"58016-0685-30 ")
 ;;775
 ;;21,"58016-0685-60 ")
 ;;776
 ;;21,"58016-0685-90 ")
 ;;777
 ;;21,"58016-0686-00 ")
 ;;846
 ;;21,"58016-0686-10 ")
 ;;847
