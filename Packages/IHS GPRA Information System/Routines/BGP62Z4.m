BGP62Z4 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON JAN 11, 2016;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"13411-0109-06 ")
 ;;1320
 ;;21,"13411-0109-09 ")
 ;;1321
 ;;21,"13411-0109-10 ")
 ;;1322
 ;;21,"13411-0110-01 ")
 ;;1496
 ;;21,"13411-0110-03 ")
 ;;1497
 ;;21,"13411-0110-06 ")
 ;;1498
 ;;21,"13411-0110-09 ")
 ;;1499
 ;;21,"13411-0110-10 ")
 ;;1500
 ;;21,"13411-0152-01 ")
 ;;3576
 ;;21,"13411-0152-03 ")
 ;;3577
 ;;21,"13411-0152-06 ")
 ;;3578
 ;;21,"13411-0152-09 ")
 ;;3579
 ;;21,"13411-0152-15 ")
 ;;3580
 ;;21,"13411-0153-01 ")
 ;;3313
 ;;21,"13411-0153-03 ")
 ;;3314
 ;;21,"13411-0153-06 ")
 ;;3315
 ;;21,"13411-0153-09 ")
 ;;3316
 ;;21,"13411-0153-15 ")
 ;;3317
 ;;21,"13411-0172-01 ")
 ;;2310
 ;;21,"13411-0172-03 ")
 ;;2311
 ;;21,"13411-0172-06 ")
 ;;2312
 ;;21,"13411-0172-09 ")
 ;;2313
 ;;21,"13411-0172-10 ")
 ;;2314
 ;;21,"13411-0173-01 ")
 ;;2469
 ;;21,"13411-0173-03 ")
 ;;2470
 ;;21,"13411-0173-06 ")
 ;;2471
 ;;21,"13411-0173-09 ")
 ;;2472
 ;;21,"13411-0173-10 ")
 ;;2473
 ;;21,"13668-0004-01 ")
 ;;3479
 ;;21,"13668-0004-05 ")
 ;;3480
 ;;21,"13668-0004-10 ")
 ;;3481
 ;;21,"13668-0004-30 ")
 ;;3482
 ;;21,"13668-0004-50 ")
 ;;3483
 ;;21,"13668-0004-90 ")
 ;;3484
 ;;21,"13668-0005-01 ")
 ;;3581
 ;;21,"13668-0005-05 ")
 ;;3582
 ;;21,"13668-0005-10 ")
 ;;3583
 ;;21,"13668-0005-30 ")
 ;;3584
 ;;21,"13668-0005-50 ")
 ;;3585
 ;;21,"13668-0005-90 ")
 ;;3586
 ;;21,"13668-0006-01 ")
 ;;3318
 ;;21,"13668-0006-05 ")
 ;;3319
 ;;21,"13668-0006-10 ")
 ;;3320
 ;;21,"13668-0006-30 ")
 ;;3321
 ;;21,"13668-0006-50 ")
 ;;3322
 ;;21,"13668-0006-90 ")
 ;;3323
 ;;21,"13668-0009-01 ")
 ;;1683
 ;;21,"13668-0009-05 ")
 ;;1684
 ;;21,"13668-0009-09 ")
 ;;1685
 ;;21,"13668-0009-30 ")
 ;;1686
 ;;21,"13668-0009-74 ")
 ;;1687
 ;;21,"13668-0010-01 ")
 ;;1804
 ;;21,"13668-0010-05 ")
 ;;1805
 ;;21,"13668-0010-06 ")
 ;;1806
 ;;21,"13668-0010-30 ")
 ;;1807
 ;;21,"13668-0010-74 ")
 ;;1808
 ;;21,"13668-0011-01 ")
 ;;1978
 ;;21,"13668-0011-05 ")
 ;;1979
 ;;21,"13668-0011-08 ")
 ;;1980
 ;;21,"13668-0011-30 ")
 ;;1981
 ;;21,"13668-0011-74 ")
 ;;1982
 ;;21,"13668-0018-01 ")
 ;;1323
 ;;21,"13668-0018-05 ")
 ;;1324
 ;;21,"13668-0018-30 ")
 ;;1325
 ;;21,"13668-0018-74 ")
 ;;1326
 ;;21,"13668-0018-90 ")
 ;;1327
 ;;21,"13668-0019-01 ")
 ;;1501
 ;;21,"13668-0019-05 ")
 ;;1502
 ;;21,"13668-0019-30 ")
 ;;1503
 ;;21,"13668-0019-74 ")
 ;;1504
 ;;21,"13668-0019-90 ")
 ;;1505
 ;;21,"13668-0020-01 ")
 ;;1193
 ;;21,"13668-0020-05 ")
 ;;1194
 ;;21,"13668-0020-30 ")
 ;;1195
 ;;21,"13668-0020-74 ")
 ;;1196
 ;;21,"13668-0020-90 ")
 ;;1197
 ;;21,"13668-0109-60 ")
 ;;999
 ;;21,"13668-0110-05 ")
 ;;1030
 ;;21,"13668-0110-30 ")
 ;;1031
 ;;21,"13668-0111-05 ")
 ;;1097
 ;;21,"13668-0111-30 ")
 ;;1098
 ;;21,"13668-0135-01 ")
 ;;2259
 ;;21,"13668-0135-05 ")
 ;;2260
 ;;21,"13668-0135-10 ")
 ;;2261
 ;;21,"13668-0136-01 ")
 ;;2123
 ;;21,"13668-0136-05 ")
 ;;2124
 ;;21,"13668-0136-10 ")
 ;;2125
 ;;21,"13668-0137-01 ")
 ;;2200
 ;;21,"13668-0137-05 ")
 ;;2201
 ;;21,"13668-0137-10 ")
 ;;2202
 ;;21,"13668-0330-01 ")
 ;;789
 ;;21,"13668-0330-05 ")
 ;;790
 ;;21,"13668-0331-01 ")
 ;;549
 ;;21,"13668-0331-05 ")
 ;;550
 ;;21,"13668-0332-01 ")
 ;;668
 ;;21,"13668-0333-01 ")
 ;;749
 ;;21,"13668-0430-60 ")
 ;;104
 ;;21,"13668-0431-25 ")
 ;;176
 ;;21,"13668-0431-60 ")
 ;;177
 ;;21,"13668-0432-60 ")
 ;;323
 ;;21,"16241-0759-01 ")
 ;;2653
 ;;21,"16252-0533-30 ")
 ;;3485
 ;;21,"16252-0533-50 ")
 ;;3486
 ;;21,"16252-0534-30 ")
 ;;3587
 ;;21,"16252-0534-50 ")
 ;;3588
 ;;21,"16252-0534-90 ")
 ;;3589
 ;;21,"16252-0535-30 ")
 ;;3324
 ;;21,"16252-0535-50 ")
 ;;3325
 ;;21,"16252-0535-90 ")
 ;;3326
 ;;21,"16590-0011-30 ")
 ;;4005
 ;;21,"16590-0011-56 ")
 ;;4006
 ;;21,"16590-0011-60 ")
 ;;4007
 ;;21,"16590-0011-72 ")
 ;;4008
 ;;21,"16590-0011-90 ")
 ;;4009
 ;;21,"16590-0012-15 ")
 ;;4224
 ;;21,"16590-0012-28 ")
 ;;4225
 ;;21,"16590-0012-30 ")
 ;;4226
 ;;21,"16590-0012-56 ")
 ;;4227
 ;;21,"16590-0012-60 ")
 ;;4228
 ;;21,"16590-0012-72 ")
 ;;4229
 ;;21,"16590-0012-82 ")
 ;;4230
 ;;21,"16590-0012-90 ")
 ;;4231
 ;;21,"16590-0013-28 ")
 ;;4386
 ;;21,"16590-0013-30 ")
 ;;4387
 ;;21,"16590-0013-60 ")
 ;;4388
 ;;21,"16590-0013-82 ")
 ;;4389
 ;;21,"16590-0013-90 ")
 ;;4390
 ;;21,"16590-0036-30 ")
 ;;105
 ;;21,"16590-0036-60 ")
 ;;106
 ;;21,"16590-0037-30 ")
 ;;406
 ;;21,"16590-0037-60 ")
 ;;407
 ;;21,"16590-0038-30 ")
 ;;178
 ;;21,"16590-0038-56 ")
 ;;179
 ;;21,"16590-0038-60 ")
 ;;180
 ;;21,"16590-0038-90 ")
 ;;181
 ;;21,"16590-0055-30 ")
 ;;1688
 ;;21,"16590-0055-60 ")
 ;;1689
 ;;21,"16590-0055-90 ")
 ;;1690
 ;;21,"16590-0056-15 ")
 ;;1809
 ;;21,"16590-0056-30 ")
 ;;1810
 ;;21,"16590-0056-60 ")
 ;;1811
 ;;21,"16590-0056-71 ")
 ;;1812
 ;;21,"16590-0056-90 ")
 ;;1813
 ;;21,"16590-0066-30 ")
 ;;1032
 ;;21,"16590-0066-60 ")
 ;;1033
 ;;21,"16590-0067-30 ")
 ;;1099
 ;;21,"16590-0067-60 ")
 ;;1100
 ;;21,"16590-0081-28 ")
 ;;4823
 ;;21,"16590-0081-30 ")
 ;;4824
 ;;21,"16590-0081-60 ")
 ;;4825
 ;;21,"16590-0081-72 ")
 ;;4826
 ;;21,"16590-0081-90 ")
 ;;4827
 ;;21,"16590-0083-30 ")
 ;;1378
 ;;21,"16590-0083-60 ")
 ;;1379
 ;;21,"16590-0084-30 ")
 ;;1583
 ;;21,"16590-0084-60 ")
 ;;1584
 ;;21,"16590-0085-30 ")
 ;;1328
 ;;21,"16590-0085-60 ")
 ;;1329
 ;;21,"16590-0086-30 ")
 ;;1506
 ;;21,"16590-0086-56 ")
 ;;1507
 ;;21,"16590-0086-60 ")
 ;;1508
 ;;21,"16590-0086-90 ")
 ;;1509
 ;;21,"16590-0087-60 ")
 ;;1198
 ;;21,"16590-0099-30 ")
 ;;2315
 ;;21,"16590-0099-60 ")
 ;;2316
 ;;21,"16590-0100-28 ")
 ;;2474
 ;;21,"16590-0100-30 ")
 ;;2475
 ;;21,"16590-0100-56 ")
 ;;2476
 ;;21,"16590-0100-60 ")
 ;;2477
 ;;21,"16590-0100-71 ")
 ;;2478
 ;;21,"16590-0100-90 ")
 ;;2479
 ;;21,"16590-0139-30 ")
 ;;2126
 ;;21,"16590-0139-60 ")
 ;;2127
 ;;21,"16590-0153-30 ")
 ;;3751
 ;;21,"16590-0153-60 ")
 ;;3752
 ;;21,"16590-0154-30 ")
 ;;3843
 ;;21,"16590-0154-45 ")
 ;;3844
 ;;21,"16590-0154-56 ")
 ;;3845
 ;;21,"16590-0154-60 ")
 ;;3846
 ;;21,"16590-0154-90 ")
 ;;3847
 ;;21,"16590-0155-30 ")
 ;;3933
 ;;21,"16590-0155-60 ")
 ;;3934
 ;;21,"16590-0166-30 ")
 ;;474
 ;;21,"16590-0166-60 ")
 ;;475
 ;;21,"16590-0166-90 ")
 ;;476
 ;;21,"16590-0171-30 ")
 ;;5127
 ;;21,"16590-0171-60 ")
 ;;5128
 ;;21,"16590-0171-90 ")
 ;;5129
 ;;21,"16590-0181-15 ")
 ;;2964
 ;;21,"16590-0181-28 ")
 ;;2965
 ;;21,"16590-0181-30 ")
 ;;2966
 ;;21,"16590-0181-60 ")
 ;;2967
 ;;21,"16590-0181-90 ")
 ;;2968
 ;;21,"16590-0231-15 ")
 ;;791
 ;;21,"16590-0231-30 ")
 ;;792
 ;;21,"16590-0231-45 ")
 ;;793
 ;;21,"16590-0231-60 ")
 ;;794
 ;;21,"16590-0231-82 ")
 ;;795
 ;;21,"16590-0231-90 ")
 ;;796
 ;;21,"16590-0232-15 ")
 ;;551
 ;;21,"16590-0232-28 ")
 ;;552
 ;;21,"16590-0232-30 ")
 ;;553
 ;;21,"16590-0232-45 ")
 ;;554
 ;;21,"16590-0232-60 ")
 ;;555
 ;;21,"16590-0232-71 ")
 ;;556
 ;;21,"16590-0232-90 ")
 ;;557
 ;;21,"16590-0246-30 ")
 ;;347
 ;;21,"16590-0246-60 ")
 ;;348
 ;;21,"16590-0246-90 ")
 ;;349
 ;;21,"16590-0249-30 ")
 ;;3487
 ;;21,"16590-0249-60 ")
 ;;3488
 ;;21,"16590-0249-90 ")
 ;;3489
 ;;21,"16590-0250-30 ")
 ;;3590
 ;;21,"16590-0250-60 ")
 ;;3591
 ;;21,"16590-0250-90 ")
 ;;3592
 ;;21,"16590-0251-30 ")
 ;;3327
 ;;21,"16590-0251-60 ")
 ;;3328
 ;;21,"16590-0251-90 ")
 ;;3329
 ;;21,"16590-0270-30 ")
 ;;2788
 ;;21,"16590-0270-60 ")
 ;;2789
 ;;21,"16590-0270-90 ")
 ;;2790
 ;;21,"16590-0322-30 ")
 ;;2830
 ;;21,"16590-0322-56 ")
 ;;2831
 ;;21,"16590-0322-60 ")
 ;;2832
 ;;21,"16590-0322-72 ")
 ;;2833
 ;;21,"16590-0322-90 ")
 ;;2834
 ;;21,"16590-0416-10 ")
 ;;3330
 ;;21,"16590-0416-15 ")
 ;;3331
 ;;21,"16590-0416-30 ")
 ;;3332
 ;;21,"16590-0416-60 ")
 ;;3333
 ;;21,"16590-0416-90 ")
 ;;3334
 ;;21,"16590-0437-30 ")
 ;;4120
 ;;21,"16590-0437-60 ")
 ;;4121
 ;;21,"16590-0437-90 ")
 ;;4122
 ;;21,"16590-0457-15 ")
 ;;3593
 ;;21,"16590-0457-28 ")
 ;;3594
 ;;21,"16590-0457-30 ")
 ;;3595
 ;;21,"16590-0457-60 ")
 ;;3596
 ;;21,"16590-0457-90 ")
 ;;3597
 ;;21,"16590-0480-30 ")
 ;;1983
 ;;21,"16590-0480-45 ")
 ;;1984
 ;;21,"16590-0480-60 ")
 ;;1985
 ;;21,"16590-0480-90 ")
 ;;1986
 ;;21,"16590-0482-30 ")
 ;;1034
 ;;21,"16590-0482-60 ")
 ;;1035
 ;;21,"16590-0482-72 ")
 ;;1036
 ;;21,"16590-0482-90 ")
 ;;1037
 ;;21,"16590-0483-30 ")
 ;;1101
 ;;21,"16590-0483-60 ")
 ;;1102
 ;;21,"16590-0483-72 ")
 ;;1103
 ;;21,"16590-0483-90 ")
 ;;1104
 ;;21,"16590-0484-30 ")
 ;;4668
 ;;21,"16590-0484-60 ")
 ;;4669
 ;;21,"16590-0484-72 ")
 ;;4670
 ;;21,"16590-0484-90 ")
 ;;4671
 ;;21,"16590-0490-30 ")
 ;;2694
 ;;21,"16590-0490-60 ")
 ;;2695
 ;;21,"16590-0490-72 ")
 ;;2696
 ;;21,"16590-0490-90 ")
 ;;2697
 ;;21,"16590-0497-30 ")
 ;;2203
 ;;21,"16590-0497-60 ")
 ;;2204
 ;;21,"16590-0497-72 ")
 ;;2205
 ;;21,"16590-0497-90 ")
 ;;2206
 ;;21,"16590-0510-30 ")
 ;;5258
 ;;21,"16590-0510-60 ")
 ;;5259
 ;;21,"16590-0510-72 ")
 ;;5260
 ;;21,"16590-0510-90 ")
 ;;5261
 ;;21,"16590-0512-06 ")
 ;;3140
 ;;21,"16590-0512-30 ")
 ;;3141
 ;;21,"16590-0512-60 ")
 ;;3142
 ;;21,"16590-0512-72 ")
 ;;3143
 ;;21,"16590-0512-90 ")
 ;;3144
 ;;21,"16590-0513-30 ")
 ;;3217
 ;;21,"16590-0513-56 ")
 ;;3218
 ;;21,"16590-0513-60 ")
 ;;3219
 ;;21,"16590-0513-72 ")
 ;;3220
 ;;21,"16590-0513-90 ")
 ;;3221
 ;;21,"16590-0514-30 ")
 ;;2918
 ;;21,"16590-0514-60 ")
 ;;2919
 ;;21,"16590-0514-72 ")
 ;;2920
 ;;21,"16590-0514-90 ")
 ;;2921
 ;;21,"16590-0526-30 ")
 ;;276
 ;;21,"16590-0526-60 ")
 ;;277
 ;;21,"16590-0526-90 ")
 ;;278
 ;;21,"16590-0541-30 ")
 ;;4495
 ;;21,"16590-0541-60 ")
 ;;4496
 ;;21,"16590-0541-72 ")
 ;;4497
 ;;21,"16590-0541-90 ")
 ;;4498
 ;;21,"16590-0577-30 ")
 ;;4937
 ;;21,"16590-0585-28 ")
 ;;669
 ;;21,"16590-0585-30 ")
 ;;670
 ;;21,"16590-0585-60 ")
 ;;671
 ;;21,"16590-0585-71 ")
 ;;672
 ;;21,"16590-0585-90 ")
 ;;673
 ;;21,"16590-0631-30 ")
 ;;4696
 ;;21,"16590-0631-60 ")
 ;;4697
 ;;21,"16590-0631-71 ")
 ;;4698
 ;;21,"16590-0631-90 ")
 ;;4699
 ;;21,"16590-0644-30 ")
 ;;1380
 ;;21,"16590-0644-60 ")
 ;;1381
 ;;21,"16590-0644-90 ")
 ;;1382
 ;;21,"16590-0700-30 ")
 ;;3490
 ;;21,"16590-0700-60 ")
 ;;3491
 ;;21,"16590-0700-82 ")
 ;;3492
 ;;21,"16590-0764-30 ")
 ;;4736
 ;;21,"16590-0764-60 ")
 ;;4737
 ;;21,"16590-0764-90 ")
 ;;4738
 ;;21,"16590-0843-90 ")
 ;;2480
 ;;21,"16714-0311-01 ")
 ;;1276
 ;;21,"16714-0312-01 ")
 ;;1383
 ;;21,"16714-0313-01 ")
 ;;1455
 ;;21,"16714-0314-01 ")
 ;;1585
 ;;21,"16714-0315-01 ")
 ;;1163
 ;;21,"16714-0334-01 ")
 ;;107
 ;;21,"16714-0334-02 ")
 ;;108
 ;;21,"16714-0334-03 ")
 ;;109
 ;;21,"16714-0335-01 ")
 ;;182
 ;;21,"16714-0335-02 ")
 ;;183
 ;;21,"16714-0335-03 ")
 ;;184
 ;;21,"16714-0336-01 ")
 ;;324
 ;;21,"16714-0351-01 ")
 ;;2317
 ;;21,"16714-0351-02 ")
 ;;2318
 ;;21,"16714-0351-03 ")
 ;;2319
 ;;21,"16714-0352-01 ")
 ;;2481
 ;;21,"16714-0352-02 ")
 ;;2482
 ;;21,"16714-0352-03 ")
 ;;2483
 ;;21,"16714-0353-01 ")
 ;;2698
 ;;21,"16714-0353-02 ")
 ;;2699
 ;;21,"16714-0353-03 ")
 ;;2700
 ;;21,"16714-0353-04 ")
 ;;2701
 ;;21,"16714-0446-01 ")
 ;;4010
 ;;21,"16714-0446-02 ")
 ;;4011
 ;;21,"16714-0447-01 ")
 ;;4232
 ;;21,"16714-0447-02 ")
 ;;4233
 ;;21,"16714-0448-01 ")
 ;;4391