BGP2TD3 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"00440-7142-30 ")
 ;;146
 ;;21,"00440-7142-90 ")
 ;;147
 ;;21,"00440-7143-30 ")
 ;;28
 ;;21,"00440-7143-90 ")
 ;;29
 ;;21,"00440-7190-30 ")
 ;;733
 ;;21,"00440-7190-90 ")
 ;;734
 ;;21,"00440-7192-30 ")
 ;;810
 ;;21,"00440-7192-90 ")
 ;;811
 ;;21,"00440-7193-30 ")
 ;;902
 ;;21,"00440-7193-90 ")
 ;;903
 ;;21,"00440-7230-60 ")
 ;;1079
 ;;21,"00440-7230-90 ")
 ;;1080
 ;;21,"00440-7230-92 ")
 ;;1081
 ;;21,"00440-7230-94 ")
 ;;1082
 ;;21,"00440-7231-30 ")
 ;;1172
 ;;21,"00440-7231-60 ")
 ;;1173
 ;;21,"00440-7231-90 ")
 ;;1174
 ;;21,"00440-7231-91 ")
 ;;1175
 ;;21,"00440-7231-92 ")
 ;;1176
 ;;21,"00440-7231-94 ")
 ;;1177
 ;;21,"00440-7232-30 ")
 ;;1273
 ;;21,"00440-7232-60 ")
 ;;1274
 ;;21,"00440-7232-90 ")
 ;;1275
 ;;21,"00440-7232-91 ")
 ;;1276
 ;;21,"00440-7232-92 ")
 ;;1277
 ;;21,"00440-7232-94 ")
 ;;1278
 ;;21,"00440-7345-99 ")
 ;;4139
 ;;21,"00440-7485-90 ")
 ;;1519
 ;;21,"00440-7486-10 ")
 ;;1803
 ;;21,"00440-7486-30 ")
 ;;1804
 ;;21,"00440-7486-60 ")
 ;;1805
 ;;21,"00440-7486-90 ")
 ;;1806
 ;;21,"00440-7486-91 ")
 ;;1807
 ;;21,"00440-7487-30 ")
 ;;1416
 ;;21,"00440-7487-90 ")
 ;;1417
 ;;21,"00440-7488-90 ")
 ;;1661
 ;;21,"00440-7550-45 ")
 ;;1890
 ;;21,"00440-7550-90 ")
 ;;1891
 ;;21,"00440-7551-45 ")
 ;;1967
 ;;21,"00440-7551-90 ")
 ;;1968
 ;;21,"00440-7552-45 ")
 ;;2033
 ;;21,"00440-7552-90 ")
 ;;2034
 ;;21,"00440-7552-92 ")
 ;;2035
 ;;21,"00440-7674-90 ")
 ;;2895
 ;;21,"00440-7675-30 ")
 ;;2152
 ;;21,"00440-7675-90 ")
 ;;2153
 ;;21,"00440-7675-99 ")
 ;;2154
 ;;21,"00440-7676-14 ")
 ;;2436
 ;;21,"00440-7676-30 ")
 ;;2437
 ;;21,"00440-7676-45 ")
 ;;2438
 ;;21,"00440-7676-90 ")
 ;;2439
 ;;21,"00440-7677-90 ")
 ;;2669
 ;;21,"00440-7682-30 ")
 ;;405
 ;;21,"00440-7683-30 ")
 ;;501
 ;;21,"00440-7683-60 ")
 ;;502
 ;;21,"00440-7684-30 ")
 ;;602
 ;;21,"00440-8072-06 ")
 ;;3179
 ;;21,"00440-8270-06 ")
 ;;3143
 ;;21,"00440-8272-06 ")
 ;;3177
 ;;21,"00440-8567-30 ")
 ;;3426
 ;;21,"00440-8567-60 ")
 ;;3427
 ;;21,"00440-8567-90 ")
 ;;3428
 ;;21,"00440-8568-30 ")
 ;;3448
 ;;21,"00440-8568-60 ")
 ;;3449
 ;;21,"00440-8568-90 ")
 ;;3450
 ;;21,"00440-8569-30 ")
 ;;3468
 ;;21,"00440-8569-60 ")
 ;;3469
 ;;21,"00440-8569-90 ")
 ;;3470
 ;;21,"00490-0067-00 ")
 ;;334
 ;;21,"00490-0067-30 ")
 ;;335
 ;;21,"00490-0067-60 ")
 ;;336
 ;;21,"00490-0067-90 ")
 ;;337
 ;;21,"00490-7030-00 ")
 ;;361
 ;;21,"00490-7030-30 ")
 ;;362
 ;;21,"00490-7030-60 ")
 ;;363
 ;;21,"00490-7030-90 ")
 ;;364
 ;;21,"00574-0110-01 ")
 ;;3063
 ;;21,"00574-0112-15 ")
 ;;3052
 ;;21,"00574-0133-01 ")
 ;;680
 ;;21,"00574-0134-01 ")
 ;;663
 ;;21,"00574-0135-01 ")
 ;;669
 ;;21,"00591-0405-01 ")
 ;;2343
 ;;21,"00591-0405-05 ")
 ;;2344
 ;;21,"00591-0406-01 ")
 ;;2896
 ;;21,"00591-0406-10 ")
 ;;2897
 ;;21,"00591-0407-01 ")
 ;;2163
 ;;21,"00591-0407-10 ")
 ;;2164
 ;;21,"00591-0408-01 ")
 ;;2440
 ;;21,"00591-0408-10 ")
 ;;2441
 ;;21,"00591-0409-01 ")
 ;;2670
 ;;21,"00591-0409-05 ")
 ;;2671
 ;;21,"00591-0409-75 ")
 ;;2672
 ;;21,"00591-0668-01 ")
 ;;1525
 ;;21,"00591-0668-05 ")
 ;;1526
 ;;21,"00591-0669-01 ")
 ;;1794
 ;;21,"00591-0669-05 ")
 ;;1795
 ;;21,"00591-0670-01 ")
 ;;1425
 ;;21,"00591-0670-05 ")
 ;;1426
 ;;21,"00591-0671-01 ")
 ;;1655
 ;;21,"00591-0671-05 ")
 ;;1656
 ;;21,"00591-0860-01 ")
 ;;407
 ;;21,"00591-0860-05 ")
 ;;408
 ;;21,"00591-0861-01 ")
 ;;504
 ;;21,"00591-0861-05 ")
 ;;505
 ;;21,"00591-0862-01 ")
 ;;604
 ;;21,"00591-0862-05 ")
 ;;605
 ;;21,"00591-0885-01 ")
 ;;2639
 ;;21,"00591-3745-10 ")
 ;;4107
 ;;21,"00591-3745-19 ")
 ;;4108
 ;;21,"00591-3746-10 ")
 ;;4179
 ;;21,"00591-3746-19 ")
 ;;4180
 ;;21,"00591-3746-30 ")
 ;;4181
 ;;21,"00591-3747-10 ")
 ;;4040
 ;;21,"00591-3747-19 ")
 ;;4041
 ;;21,"00591-3747-30 ")
 ;;4042
 ;;21,"00591-3757-01 ")
 ;;62
 ;;21,"00591-3758-01 ")
 ;;93
 ;;21,"00591-3758-05 ")
 ;;94
 ;;21,"00591-3759-01 ")
 ;;141
 ;;21,"00591-3759-05 ")
 ;;142
 ;;21,"00591-3760-01 ")
 ;;23
 ;;21,"00591-3760-05 ")
 ;;24
 ;;21,"00591-3761-01 ")
 ;;170
 ;;21,"00591-3762-01 ")
 ;;48
 ;;21,"00597-0039-28 ")
 ;;4266
 ;;21,"00597-0039-37 ")
 ;;4267
 ;;21,"00597-0040-28 ")
 ;;4268
 ;;21,"00597-0040-37 ")
 ;;4269
 ;;21,"00597-0041-28 ")
 ;;4284
 ;;21,"00597-0041-37 ")
 ;;4285
 ;;21,"00597-0042-28 ")
 ;;3768
 ;;21,"00597-0042-37 ")
 ;;3769
 ;;21,"00597-0043-28 ")
 ;;3753
 ;;21,"00597-0043-37 ")
 ;;3754
 ;;21,"00597-0044-28 ")
 ;;3759
 ;;21,"00597-0044-37 ")
 ;;3760
 ;;21,"00597-0124-37 ")
 ;;3511
 ;;21,"00597-0125-37 ")
 ;;3510
 ;;21,"00597-0126-37 ")
 ;;3513
 ;;21,"00597-0127-37 ")
 ;;3512
 ;;21,"00603-4209-21 ")
 ;;2341
 ;;21,"00603-4209-28 ")
 ;;2342
 ;;21,"00603-4210-02 ")
 ;;2898
 ;;21,"00603-4210-16 ")
 ;;2899
 ;;21,"00603-4210-21 ")
 ;;2900
 ;;21,"00603-4210-28 ")
 ;;2901
 ;;21,"00603-4210-32 ")
 ;;2902
 ;;21,"00603-4210-60 ")
 ;;2903
 ;;21,"00603-4211-02 ")
 ;;2157
 ;;21,"00603-4211-21 ")
 ;;2158
 ;;21,"00603-4211-28 ")
 ;;2159
 ;;21,"00603-4211-32 ")
 ;;2160
 ;;21,"00603-4211-34 ")
 ;;2161
 ;;21,"00603-4211-60 ")
 ;;2162
 ;;21,"00603-4212-02 ")
 ;;2442
 ;;21,"00603-4212-21 ")
 ;;2443
 ;;21,"00603-4212-28 ")
 ;;2444
 ;;21,"00603-4212-32 ")
 ;;2445
 ;;21,"00603-4212-34 ")
 ;;2446
 ;;21,"00603-4212-60 ")
 ;;2447
 ;;21,"00603-4213-21 ")
 ;;2637
 ;;21,"00603-4213-28 ")
 ;;2638
 ;;21,"00603-4214-02 ")
 ;;2673
 ;;21,"00603-4214-04 ")
 ;;2674
 ;;21,"00603-4214-21 ")
 ;;2675
 ;;21,"00603-4214-28 ")
 ;;2676
 ;;21,"00603-4214-30 ")
 ;;2677
 ;;21,"00603-4214-32 ")
 ;;2678
 ;;21,"00603-4214-60 ")
 ;;2679
 ;;21,"00615-4519-53 ")
 ;;1085
 ;;21,"00615-4519-63 ")
 ;;1086
 ;;21,"00615-4520-53 ")
 ;;1168
 ;;21,"00615-4520-63 ")
 ;;1169
 ;;21,"00615-4521-53 ")
 ;;1281
 ;;21,"00615-4521-63 ")
 ;;1282
 ;;21,"00615-4590-53 ")
 ;;1799
 ;;21,"00615-4590-63 ")
 ;;1800
 ;;21,"00615-4591-53 ")
 ;;1420
 ;;21,"00615-4591-63 ")
 ;;1421
 ;;21,"00781-1176-01 ")
 ;;503
 ;;21,"00781-1178-01 ")
 ;;606
 ;;21,"00781-1229-01 ")
 ;;1522
 ;;21,"00781-1229-10 ")
 ;;1523
 ;;21,"00781-1229-13 ")
 ;;1524
 ;;21,"00781-1231-01 ")
 ;;1796
 ;;21,"00781-1231-10 ")
 ;;1797
 ;;21,"00781-1231-13 ")
 ;;1798
 ;;21,"00781-1232-01 ")
 ;;1422
 ;;21,"00781-1232-10 ")
 ;;1423
 ;;21,"00781-1232-13 ")
 ;;1424
 ;;21,"00781-1233-01 ")
 ;;1657
 ;;21,"00781-1233-10 ")
 ;;1658
 ;;21,"00781-1665-01 ")
 ;;2904
 ;;21,"00781-1665-92 ")
 ;;2905
 ;;21,"00781-1666-01 ")
 ;;2155
 ;;21,"00781-1666-92 ")
 ;;2156
 ;;21,"00781-1667-01 ")
 ;;2448
 ;;21,"00781-1667-92 ")
 ;;2449
 ;;21,"00781-1668-01 ")
 ;;2680
 ;;21,"00781-1668-92 ")
 ;;2681
 ;;21,"00781-1669-01 ")
 ;;2335
 ;;21,"00781-1673-01 ")
 ;;2642
 ;;21,"00781-1828-01 ")
 ;;1087
 ;;21,"00781-1828-10 ")
 ;;1088
 ;;21,"00781-1829-01 ")
 ;;1166
 ;;21,"00781-1829-10 ")
 ;;1167
 ;;21,"00781-1838-01 ")
 ;;1283
 ;;21,"00781-1838-10 ")
 ;;1284
 ;;21,"00781-1839-01 ")
 ;;1023
 ;;21,"00781-1848-01 ")
 ;;409
 ;;21,"00781-1891-01 ")
 ;;972
 ;;21,"00781-1892-01 ")
 ;;731
 ;;21,"00781-1893-01 ")
 ;;813
 ;;21,"00781-1894-01 ")
 ;;900
 ;;21,"00781-2126-01 ")
 ;;3229
 ;;21,"00781-2127-01 ")
 ;;3349
 ;;21,"00781-2127-05 ")
 ;;3350
 ;;21,"00781-2128-01 ")
 ;;3404
 ;;21,"00781-2128-05 ")
 ;;3405
 ;;21,"00781-2129-01 ")
 ;;3292
 ;;21,"00781-2129-05 ")
 ;;3293
 ;;21,"00781-2271-01 ")
 ;;63
 ;;21,"00781-2271-64 ")
 ;;64
 ;;21,"00781-2272-01 ")
 ;;90
 ;;21,"00781-2272-10 ")
 ;;91
 ;;21,"00781-2272-64 ")
 ;;92
 ;;21,"00781-2273-01 ")
 ;;143
 ;;21,"00781-2273-10 ")
 ;;144
 ;;21,"00781-2273-64 ")
 ;;145
 ;;21,"00781-2274-01 ")
 ;;25
 ;;21,"00781-2274-10 ")
 ;;26
 ;;21,"00781-2274-64 ")
 ;;27
 ;;21,"00781-2277-01 ")
 ;;171
 ;;21,"00781-2279-01 ")
 ;;49
 ;;21,"00781-5083-10 ")
 ;;1892
 ;;21,"00781-5083-92 ")
 ;;1893
 ;;21,"00781-5084-10 ")
 ;;1965
 ;;21,"00781-5084-92 ")
 ;;1966
 ;;21,"00781-5085-92 ")
 ;;2036
 ;;21,"00781-5131-01 ")
 ;;287
 ;;21,"00781-5132-01 ")
 ;;221
 ;;21,"00781-5133-01 ")
 ;;244
 ;;21,"00781-5134-01 ")
 ;;268
 ;;21,"00781-5204-10 ")
 ;;3585
 ;;21,"00781-5204-31 ")
 ;;3586
 ;;21,"00781-5204-92 ")
 ;;3587
 ;;21,"00781-5206-10 ")
 ;;3688
 ;;21,"00781-5206-31 ")
 ;;3689
 ;;21,"00781-5206-92 ")
 ;;3690
 ;;21,"00781-5207-10 ")
 ;;3633
 ;;21,"00781-5207-31 ")
 ;;3634
 ;;21,"00781-5207-92 ")
 ;;3635
 ;;21,"00781-5320-01 ")
 ;;3431
 ;;21,"00781-5321-01 ")
 ;;3445
 ;;21,"00781-5322-01 ")
 ;;3473
 ;;21,"00781-5441-01 ")
 ;;1528
 ;;21,"00781-5441-10 ")
 ;;1529
 ;;21,"00781-5442-01 ")
 ;;1789
 ;;21,"00781-5442-10 ")
 ;;1790
 ;;21,"00781-5443-01 ")
 ;;1429
 ;;21,"00781-5443-10 ")
 ;;1430
 ;;21,"00781-5444-01 ")
 ;;1651
 ;;21,"00781-5444-10 ")
 ;;1652
 ;;21,"00781-5700-10 ")
 ;;4099
 ;;21,"00781-5700-92 ")
 ;;4100
 ;;21,"00781-5701-10 ")
 ;;4192
 ;;21,"00781-5701-31 ")
 ;;4193
 ;;21,"00781-5701-92 ")
 ;;4194
 ;;21,"00781-5702-10 ")
 ;;4034
 ;;21,"00781-5702-31 ")
 ;;4035
 ;;21,"00781-5702-92 ")
 ;;4036
 ;;21,"00781-5805-10 ")
 ;;4101
 ;;21,"00781-5805-92 ")
 ;;4102
 ;;21,"00781-5806-10 ")
 ;;4189
 ;;21,"00781-5806-31 ")
 ;;4190
 ;;21,"00781-5806-92 ")
 ;;4191
 ;;21,"00781-5807-10 ")
 ;;4037
 ;;21,"00781-5807-31 ")
 ;;4038
 ;;21,"00781-5807-92 ")
 ;;4039
 ;;21,"00781-5816-10 ")
 ;;3691
 ;;21,"00781-5816-31 ")
 ;;3692
 ;;21,"00781-5816-92 ")
 ;;3693
 ;;21,"00781-5817-10 ")
 ;;3582
 ;;21,"00781-5817-31 ")
 ;;3583
 ;;21,"00781-5817-92 ")
 ;;3584
 ;;21,"00781-5818-10 ")
 ;;3636
 ;;21,"00781-5818-31 ")
 ;;3637
 ;;21,"00781-5818-92 ")
 ;;3638
 ;;21,"00904-5045-60 ")
 ;;1076
 ;;21,"00904-5045-61 ")
 ;;1077
 ;;21,"00904-5045-80 ")
 ;;1078
 ;;21,"00904-5046-60 ")
 ;;1178
 ;;21,"00904-5046-61 ")
 ;;1179
 ;;21,"00904-5046-80 ")
 ;;1180
 ;;21,"00904-5047-60 ")
 ;;1285
 ;;21,"00904-5047-61 ")
 ;;1286
 ;;21,"00904-5047-80 ")
 ;;1287
 ;;21,"00904-5048-60 ")
 ;;1022
 ;;21,"00904-5501-60 ")
 ;;1527
 ;;21,"00904-5502-60 ")
 ;;1791
 ;;21,"00904-5502-61 ")
 ;;1792
 ;;21,"00904-5502-80 ")
 ;;1793
 ;;21,"00904-5503-60 ")
 ;;1427
 ;;21,"00904-5503-80 ")
 ;;1428
 ;;21,"00904-5504-60 ")
 ;;1653
 ;;21,"00904-5504-80 ")
 ;;1654
 ;;21,"00904-5609-60 ")
 ;;1530
 ;;21,"00904-5609-61 ")
 ;;1531
 ;;21,"00904-5610-60 ")
 ;;1431
 ;;21,"00904-5610-61 ")
 ;;1432
 ;;21,"00904-5610-80 ")
 ;;1433
 ;;21,"00904-5611-60 ")
 ;;1648
 ;;21,"00904-5611-61 ")
 ;;1649
 ;;21,"00904-5611-80 ")
 ;;1650
 ;;21,"00904-5637-61 ")
 ;;2336
 ;;21,"00904-5638-43 ")
 ;;2911
 ;;21,"00904-5638-46 ")
 ;;2912
 ;;21,"00904-5638-61 ")
 ;;2913
 ;;21,"00904-5638-89 ")
 ;;2914
 ;;21,"00904-5639-43 ")
 ;;2165
 ;;21,"00904-5639-46 ")
 ;;2166
 ;;21,"00904-5639-48 ")
 ;;2167
 ;;21,"00904-5639-61 ")
 ;;2168
 ;;21,"00904-5639-89 ")
 ;;2169
 ;;21,"00904-5639-93 ")
 ;;2170
 ;;21,"00904-5640-43 ")
 ;;2461
 ;;21,"00904-5640-46 ")
 ;;2462
 ;;21,"00904-5640-48 ")
 ;;2463
 ;;21,"00904-5640-61 ")
 ;;2464
 ;;21,"00904-5640-89 ")
 ;;2465
 ;;21,"00904-5640-93 ")
 ;;2466
 ;;21,"00904-5641-61 ")
 ;;2641
 ;;21,"00904-5642-43 ")
 ;;2687
 ;;21,"00904-5642-46 ")
 ;;2688
 ;;21,"00904-5642-48 ")
 ;;2689
 ;;21,"00904-5642-52 ")
 ;;2690
 ;;21,"00904-5642-61 ")
 ;;2691
 ;;21,"00904-5642-89 ")
 ;;2692
 ;;21,"00904-5642-93 ")
 ;;2693
 ;;21,"00904-5701-61 ")
 ;;1788
 ;;21,"00904-5757-89 ")
 ;;509
 ;;21,"00904-5778-89 ")
 ;;2337
 ;;21,"00904-5808-43 ")
 ;;2171
 ;;21,"00904-5808-46 ")
 ;;2172
 ;;21,"00904-5808-48 ")
 ;;2173
 ;;21,"00904-5808-61 ")
 ;;2174
 ;;21,"00904-5808-80 ")
 ;;2175
 ;;21,"00904-5808-89 ")
 ;;2176
 ;;21,"00904-5808-93 ")
 ;;2177
 ;;21,"00904-5809-43 ")
 ;;2454
 ;;21,"00904-5809-46 ")
 ;;2455
 ;;21,"00904-5809-48 ")
 ;;2456
 ;;21,"00904-5809-61 ")
 ;;2457
 ;;21,"00904-5809-80 ")
 ;;2458
 ;;21,"00904-5809-89 ")
 ;;2459
 ;;21,"00904-5809-93 ")
 ;;2460
 ;;21,"00904-5810-43 ")
 ;;2694
 ;;21,"00904-5810-46 ")
 ;;2695
 ;;21,"00904-5810-48 ")
 ;;2696
 ;;21,"00904-5810-52 ")
 ;;2697
 ;;21,"00904-5810-61 ")
 ;;2698
 ;;21,"00904-5810-80 ")
 ;;2699
 ;;21,"00904-5810-89 ")
 ;;2700
 ;;21,"00904-5810-93 ")
 ;;2701
 ;;21,"00904-5811-43 ")
 ;;2906
 ;;21,"00904-5811-46 ")
 ;;2907
 ;;21,"00904-5811-61 ")
 ;;2908
 ;;21,"00904-5811-80 ")
 ;;2909
 ;;21,"00904-5811-89 ")
 ;;2910
 ;;21,"00904-5812-40 ")
 ;;2338
 ;;21,"00904-5812-89 ")
 ;;2339
 ;;21,"00904-6189-40 ")
 ;;973
 ;;21,"00904-6190-40 ")
 ;;729
 ;;21,"00904-6191-40 ")
 ;;815
 ;;21,"00904-6192-40 ")
 ;;899
 ;;21,"12280-0005-90 ")
 ;;4074
 ;;21,"12280-0008-00 ")
 ;;4304
 ;;21,"12280-0008-90 ")
 ;;4305
 ;;21,"12280-0009-90 ")
 ;;3808
 ;;21,"12280-0033-00 ")
 ;;961
 ;;21,"12280-0059-90 ")
 ;;3094
 ;;21,"12280-0061-00 ")
 ;;3238
 ;;21,"12280-0063-30 ")
 ;;3937
 ;;21,"12280-0063-90 ")
 ;;3938
 ;;21,"12280-0066-30 ")
 ;;3999
 ;;21,"12280-0067-15 ")
 ;;3795
 ;;21,"12280-0067-30 ")
 ;;3796
 ;;21,"12280-0067-90 ")
 ;;3797
