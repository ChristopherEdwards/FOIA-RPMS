BGP22B2 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 21, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"00093-7372-10 ")
 ;;102
 ;;21,"00093-7373-01 ")
 ;;3
 ;;21,"00093-7373-10 ")
 ;;4
 ;;21,"00093-7436-01 ")
 ;;3129
 ;;21,"00093-7437-01 ")
 ;;3175
 ;;21,"00093-7438-01 ")
 ;;3067
 ;;21,"00093-8132-01 ")
 ;;971
 ;;21,"00093-8132-10 ")
 ;;962
 ;;21,"00093-8133-01 ")
 ;;1055
 ;;21,"00093-8133-10 ")
 ;;1054
 ;;21,"00093-8134-01 ")
 ;;1162
 ;;21,"00093-8134-10 ")
 ;;1157
 ;;21,"00093-8135-01 ")
 ;;918
 ;;21,"00143-1171-01 ")
 ;;972
 ;;21,"00143-1171-10 ")
 ;;973
 ;;21,"00143-1171-25 ")
 ;;942
 ;;21,"00143-1172-01 ")
 ;;1056
 ;;21,"00143-1172-10 ")
 ;;1057
 ;;21,"00143-1172-25 ")
 ;;1013
 ;;21,"00143-1173-01 ")
 ;;1163
 ;;21,"00143-1173-10 ")
 ;;1164
 ;;21,"00143-1173-25 ")
 ;;1129
 ;;21,"00143-1174-01 ")
 ;;919
 ;;21,"00143-1174-25 ")
 ;;908
 ;;21,"00143-1262-01 ")
 ;;361
 ;;21,"00143-1262-10 ")
 ;;362
 ;;21,"00143-1263-01 ")
 ;;441
 ;;21,"00143-1263-10 ")
 ;;442
 ;;21,"00143-1264-01 ")
 ;;528
 ;;21,"00143-1264-10 ")
 ;;529
 ;;21,"00143-1265-01 ")
 ;;2166
 ;;21,"00143-1265-09 ")
 ;;2161
 ;;21,"00143-1265-10 ")
 ;;2167
 ;;21,"00143-1266-01 ")
 ;;2729
 ;;21,"00143-1266-09 ")
 ;;2720
 ;;21,"00143-1266-10 ")
 ;;2730
 ;;21,"00143-1266-30 ")
 ;;2721
 ;;21,"00143-1266-45 ")
 ;;2722
 ;;21,"00143-1267-01 ")
 ;;1971
 ;;21,"00143-1267-09 ")
 ;;1959
 ;;21,"00143-1267-10 ")
 ;;1972
 ;;21,"00143-1267-18 ")
 ;;1960
 ;;21,"00143-1267-30 ")
 ;;1961
 ;;21,"00143-1267-45 ")
 ;;1962
 ;;21,"00143-1268-01 ")
 ;;2270
 ;;21,"00143-1268-09 ")
 ;;2261
 ;;21,"00143-1268-10 ")
 ;;2271
 ;;21,"00143-1268-18 ")
 ;;2262
 ;;21,"00143-1268-30 ")
 ;;2263
 ;;21,"00143-1268-45 ")
 ;;2264
 ;;21,"00143-1270-01 ")
 ;;2550
 ;;21,"00143-1270-09 ")
 ;;2543
 ;;21,"00143-1270-10 ")
 ;;2551
 ;;21,"00143-1270-18 ")
 ;;2544
 ;;21,"00143-1270-30 ")
 ;;2545
 ;;21,"00143-1270-45 ")
 ;;2546
 ;;21,"00143-1280-01 ")
 ;;2465
 ;;21,"00143-1280-10 ")
 ;;2466
 ;;21,"00143-9125-01 ")
 ;;3230
 ;;21,"00143-9126-01 ")
 ;;3248
 ;;21,"00143-9127-01 ")
 ;;3266
 ;;21,"00172-2515-60 ")
 ;;246
 ;;21,"00172-3757-00 ")
 ;;2163
 ;;21,"00172-3757-10 ")
 ;;2164
 ;;21,"00172-3757-60 ")
 ;;2168
 ;;21,"00172-3757-70 ")
 ;;2169
 ;;21,"00172-3758-00 ")
 ;;2731
 ;;21,"00172-3758-10 ")
 ;;2732
 ;;21,"00172-3758-60 ")
 ;;2733
 ;;21,"00172-3758-70 ")
 ;;2734
 ;;21,"00172-3758-80 ")
 ;;2735
 ;;21,"00172-3759-00 ")
 ;;1968
 ;;21,"00172-3759-10 ")
 ;;1969
 ;;21,"00172-3759-60 ")
 ;;1973
 ;;21,"00172-3759-70 ")
 ;;1974
 ;;21,"00172-3759-80 ")
 ;;1975
 ;;21,"00172-3759-85 ")
 ;;1923
 ;;21,"00172-3760-00 ")
 ;;2272
 ;;21,"00172-3760-10 ")
 ;;2273
 ;;21,"00172-3760-60 ")
 ;;2274
 ;;21,"00172-3760-70 ")
 ;;2275
 ;;21,"00172-3760-80 ")
 ;;2276
 ;;21,"00172-3760-85 ")
 ;;2226
 ;;21,"00172-3761-00 ")
 ;;2548
 ;;21,"00172-3761-10 ")
 ;;2549
 ;;21,"00172-3761-60 ")
 ;;2552
 ;;21,"00172-3761-70 ")
 ;;2553
 ;;21,"00172-3761-80 ")
 ;;2528
 ;;21,"00172-3762-00 ")
 ;;2467
 ;;21,"00172-3762-10 ")
 ;;2468
 ;;21,"00172-3762-60 ")
 ;;2469
 ;;21,"00172-3762-70 ")
 ;;2470
 ;;21,"00172-4195-10 ")
 ;;1410
 ;;21,"00172-4195-60 ")
 ;;1397
 ;;21,"00172-4195-64 ")
 ;;1378
 ;;21,"00172-4195-80 ")
 ;;1398
 ;;21,"00172-4195-93 ")
 ;;1411
 ;;21,"00172-4196-10 ")
 ;;1634
 ;;21,"00172-4196-60 ")
 ;;1618
 ;;21,"00172-4196-64 ")
 ;;1589
 ;;21,"00172-4196-80 ")
 ;;1619
 ;;21,"00172-4196-93 ")
 ;;1635
 ;;21,"00172-4197-10 ")
 ;;1272
 ;;21,"00172-4197-60 ")
 ;;1255
 ;;21,"00172-4197-80 ")
 ;;1256
 ;;21,"00172-4197-93 ")
 ;;1273
 ;;21,"00172-4198-10 ")
 ;;1498
 ;;21,"00172-4198-60 ")
 ;;1481
 ;;21,"00172-4198-64 ")
 ;;1458
 ;;21,"00172-4198-80 ")
 ;;1482
 ;;21,"00172-4198-93 ")
 ;;1499
 ;;21,"00172-5025-60 ")
 ;;267
 ;;21,"00172-5032-00 ")
 ;;530
 ;;21,"00172-5032-10 ")
 ;;531
 ;;21,"00172-5032-60 ")
 ;;532
 ;;21,"00172-5032-70 ")
 ;;533
 ;;21,"00172-5032-80 ")
 ;;510
 ;;21,"00172-5033-00 ")
 ;;358
 ;;21,"00172-5033-10 ")
 ;;359
 ;;21,"00172-5033-60 ")
 ;;363
 ;;21,"00172-5033-70 ")
 ;;364
 ;;21,"00172-5033-80 ")
 ;;342
 ;;21,"00172-5034-00 ")
 ;;443
 ;;21,"00172-5034-10 ")
 ;;444
 ;;21,"00172-5034-60 ")
 ;;445
 ;;21,"00172-5034-70 ")
 ;;446
 ;;21,"00172-5034-80 ")
 ;;418
 ;;21,"00172-5350-60 ")
 ;;874
 ;;21,"00172-5350-70 ")
 ;;875
 ;;21,"00172-5351-10 ")
 ;;649
 ;;21,"00172-5351-60 ")
 ;;651
 ;;21,"00172-5351-70 ")
 ;;650
 ;;21,"00172-5351-80 ")
 ;;646
 ;;21,"00172-5352-10 ")
 ;;727
 ;;21,"00172-5352-60 ")
 ;;722
 ;;21,"00172-5352-70 ")
 ;;728
 ;;21,"00172-5352-80 ")
 ;;723
 ;;21,"00172-5353-10 ")
 ;;810
 ;;21,"00172-5353-60 ")
 ;;806
 ;;21,"00172-5353-70 ")
 ;;811
 ;;21,"00172-5353-80 ")
 ;;807
 ;;21,"00172-5360-60 ")
 ;;240
 ;;21,"00172-5361-60 ")
 ;;180
 ;;21,"00172-5361-70 ")
 ;;179
 ;;21,"00172-5362-60 ")
 ;;199
 ;;21,"00172-5362-70 ")
 ;;198
 ;;21,"00172-5363-60 ")
 ;;223
 ;;21,"00172-5363-70 ")
 ;;222
 ;;21,"00182-2623-89 ")
 ;;1032
 ;;21,"00185-0025-01 ")
 ;;2170
 ;;21,"00185-0025-10 ")
 ;;2171
 ;;21,"00185-0041-09 ")
 ;;1753
 ;;21,"00185-0041-10 ")
 ;;1754
 ;;21,"00185-0042-09 ")
 ;;1810
 ;;21,"00185-0042-10 ")
 ;;1811
 ;;21,"00185-0047-09 ")
 ;;1871
 ;;21,"00185-0047-10 ")
 ;;1872
 ;;21,"00185-0048-01 ")
 ;;821
 ;;21,"00185-0048-05 ")
 ;;822
 ;;21,"00185-0053-01 ")
 ;;662
 ;;21,"00185-0053-05 ")
 ;;663
 ;;21,"00185-0101-01 ")
 ;;1976
 ;;21,"00185-0101-10 ")
 ;;1977
 ;;21,"00185-0101-33 ")
 ;;1978
 ;;21,"00185-0102-01 ")
 ;;2277
 ;;21,"00185-0102-10 ")
 ;;2278
 ;;21,"00185-0102-33 ")
 ;;2279
 ;;21,"00185-0103-01 ")
 ;;2471
 ;;21,"00185-0103-10 ")
 ;;2472
 ;;21,"00185-0104-01 ")
 ;;2554
 ;;21,"00185-0104-10 ")
 ;;2555
 ;;21,"00185-0114-01 ")
 ;;1406
 ;;21,"00185-0114-10 ")
 ;;1407
 ;;21,"00185-0114-50 ")
 ;;1408
 ;;21,"00185-0124-01 ")
 ;;242
 ;;21,"00185-0127-01 ")
 ;;1626
 ;;21,"00185-0127-10 ")
 ;;1627
 ;;21,"00185-0127-50 ")
 ;;1628
 ;;21,"00185-0147-01 ")
 ;;1263
 ;;21,"00185-0147-10 ")
 ;;1262
 ;;21,"00185-0147-50 ")
 ;;1264
 ;;21,"00185-0151-01 ")
 ;;312
 ;;21,"00185-0152-01 ")
 ;;447
 ;;21,"00185-0152-10 ")
 ;;448
 ;;21,"00185-0172-01 ")
 ;;286
 ;;21,"00185-0172-10 ")
 ;;287
 ;;21,"00185-0173-01 ")
 ;;534
 ;;21,"00185-0173-10 ")
 ;;535
 ;;21,"00185-0204-01 ")
 ;;182
 ;;21,"00185-0211-01 ")
 ;;201
 ;;21,"00185-0214-01 ")
 ;;1487
 ;;21,"00185-0214-10 ")
 ;;1488
 ;;21,"00185-0214-50 ")
 ;;1489
 ;;21,"00185-0277-01 ")
 ;;225
 ;;21,"00185-0341-01 ")
 ;;326
 ;;21,"00185-0342-01 ")
 ;;335
 ;;21,"00185-0505-01 ")
 ;;885
 ;;21,"00185-0505-05 ")
 ;;886
 ;;21,"00185-0820-01 ")
 ;;739
 ;;21,"00185-0820-05 ")
 ;;740
 ;;21,"00185-5400-01 ")
 ;;2736
 ;;21,"00185-5400-10 ")
 ;;2737
 ;;21,"00185-5400-33 ")
 ;;2738
 ;;21,"00185-7100-01 ")
 ;;365
 ;;21,"00185-7100-10 ")
 ;;366
 ;;21,"00186-0001-31 ")
 ;;143
 ;;21,"00186-0001-68 ")
 ;;144
 ;;21,"00186-0002-31 ")
 ;;142
 ;;21,"00186-0004-31 ")
 ;;3685
 ;;21,"00186-0008-31 ")
 ;;3689
 ;;21,"00186-0016-28 ")
 ;;3666
 ;;21,"00186-0016-31 ")
 ;;3667
 ;;21,"00186-0016-54 ")
 ;;3668
 ;;21,"00186-0032-28 ")
 ;;3679
 ;;21,"00186-0032-31 ")
 ;;3680
 ;;21,"00186-0032-54 ")
 ;;3681
 ;;21,"00186-0162-28 ")
 ;;3334
 ;;21,"00186-0162-54 ")
 ;;3335
 ;;21,"00186-0322-28 ")
 ;;3339
 ;;21,"00186-0322-54 ")
 ;;3340
 ;;21,"00186-0324-54 ")
 ;;3347
 ;;21,"00228-2658-11 ")
 ;;1386
 ;;21,"00228-2658-96 ")
 ;;1387
 ;;21,"00228-2659-11 ")
 ;;1601
 ;;21,"00228-2659-96 ")
 ;;1602
 ;;21,"00228-2660-11 ")
 ;;1235
 ;;21,"00228-2660-96 ")
 ;;1236
 ;;21,"00228-2661-11 ")
 ;;1466
 ;;21,"00228-2661-96 ")
 ;;1467
 ;;21,"00228-2695-11 ")
 ;;3124
 ;;21,"00228-2695-50 ")
 ;;3125
 ;;21,"00228-2696-11 ")
 ;;3170
 ;;21,"00228-2696-50 ")
 ;;3171
 ;;21,"00228-2697-11 ")
 ;;3063
 ;;21,"00228-2697-50 ")
 ;;3064
 ;;21,"00228-2706-03 ")
 ;;343
 ;;21,"00228-2706-11 ")
 ;;344
 ;;21,"00228-2707-03 ")
 ;;419
 ;;21,"00228-2707-11 ")
 ;;420
 ;;21,"00228-2708-03 ")
 ;;512
 ;;21,"00228-2708-11 ")
 ;;513
 ;;21,"00245-0193-01 ")
 ;;3842
 ;;21,"00245-0193-10 ")
 ;;3843
 ;;21,"00245-0193-30 ")
 ;;3844
 ;;21,"00245-0193-90 ")
 ;;3845
 ;;21,"00245-0194-01 ")
 ;;3895
 ;;21,"00245-0194-10 ")
 ;;3896
 ;;21,"00245-0194-30 ")
 ;;3897
 ;;21,"00245-0194-90 ")
 ;;3898
 ;;21,"00245-0195-01 ")
 ;;3774
 ;;21,"00245-0195-10 ")
 ;;3775
 ;;21,"00245-0195-30 ")
 ;;3776
 ;;21,"00245-0195-90 ")
 ;;3777
 ;;21,"00247-1023-00 ")
 ;;2280
 ;;21,"00247-1023-30 ")
 ;;2281
 ;;21,"00247-1023-60 ")
 ;;2282
 ;;21,"00247-1090-30 ")
 ;;3068
 ;;21,"00247-1090-60 ")
 ;;3069
 ;;21,"00247-1091-30 ")
 ;;3176
 ;;21,"00247-1091-60 ")
 ;;3177
 ;;21,"00247-1147-10 ")
 ;;1979
 ;;21,"00247-1147-30 ")
 ;;1980
 ;;21,"00247-1147-60 ")
 ;;1981
 ;;21,"00247-1149-30 ")
 ;;449
 ;;21,"00247-1149-60 ")
 ;;450
 ;;21,"00247-1150-30 ")
 ;;536
 ;;21,"00247-1150-60 ")
 ;;537
 ;;21,"00247-1222-00 ")
 ;;1146
 ;;21,"00247-1396-30 ")
 ;;2172
 ;;21,"00310-0130-10 ")
 ;;2719
 ;;21,"00310-0130-11 ")
 ;;2739
 ;;21,"00310-0130-34 ")
 ;;2694
 ;;21,"00310-0130-39 ")
 ;;2700
 ;;21,"00310-0131-10 ")
 ;;1956
 ;;21,"00310-0131-11 ")
 ;;1982
 ;;21,"00310-0131-34 ")
 ;;1916
 ;;21,"00310-0131-39 ")
 ;;1931
 ;;21,"00310-0131-73 ")
 ;;1921
 ;;21,"00310-0132-10 ")
 ;;2259
 ;;21,"00310-0132-11 ")
 ;;2283
 ;;21,"00310-0132-34 ")
 ;;2223
 ;;21,"00310-0132-39 ")
 ;;2233
 ;;21,"00310-0132-73 ")
 ;;2224
 ;;21,"00310-0133-10 ")
 ;;2463
 ;;21,"00310-0133-11 ")
 ;;2473
 ;;21,"00310-0134-10 ")
 ;;2542
 ;;21,"00310-0134-11 ")
 ;;2556
 ;;21,"00310-0135-10 ")
 ;;2173
 ;;21,"00310-0141-10 ")
 ;;355
 ;;21,"00310-0141-11 ")
 ;;367
 ;;21,"00310-0142-10 ")
 ;;438
 ;;21,"00310-0142-11 ")
 ;;451
 ;;21,"00310-0145-10 ")
 ;;523
 ;;21,"00310-0145-11 ")
 ;;538
 ;;21,"00378-0081-01 ")
 ;;253
 ;;21,"00378-0083-01 ")
 ;;259
 ;;21,"00378-0084-01 ")
 ;;266
 ;;21,"00378-0086-01 ")
 ;;274
 ;;21,"00378-0226-77 ")
 ;;2937
 ;;21,"00378-0254-77 ")
 ;;2966
 ;;21,"00378-0272-77 ")
 ;;2994
 ;;21,"00378-0441-01 ")
 ;;887
 ;;21,"00378-0443-01 ")
 ;;664
 ;;21,"00378-0444-01 ")
 ;;741
 ;;21,"00378-0447-01 ")
 ;;823
 ;;21,"00378-0542-77 ")
 ;;618
 ;;21,"00378-0543-77 ")
 ;;626
 ;;21,"00378-0544-77 ")
 ;;635
 ;;21,"00378-0712-01 ")
 ;;313
 ;;21,"00378-0723-01 ")
 ;;288
 ;;21,"00378-1012-01 ")
 ;;368
 ;;21,"00378-1051-01 ")
 ;;1414
 ;;21,"00378-1051-05 ")
 ;;1415
 ;;21,"00378-1052-01 ")
 ;;1642
 ;;21,"00378-1052-10 ")
 ;;1643
 ;;21,"00378-1053-01 ")
 ;;1280
 ;;21,"00378-1053-10 ")
 ;;1281
 ;;21,"00378-1054-01 ")
 ;;1503
 ;;21,"00378-1054-05 ")
 ;;1504
 ;;21,"00378-1117-77 ")
 ;;3025
 ;;21,"00378-1418-77 ")
 ;;3487
 ;;21,"00378-1418-93 ")
 ;;3488
 ;;21,"00378-1419-10 ")
 ;;3394
 ;;21,"00378-1419-77 ")
 ;;3395
 ;;21,"00378-1419-93 ")
 ;;3396
 ;;21,"00378-1420-77 ")
 ;;3435
 ;;21,"00378-1420-93 ")
 ;;3436
 ;;21,"00378-2012-01 ")
 ;;452
 ;;21,"00378-2025-01 ")
 ;;539
 ;;21,"00378-2072-01 ")
 ;;2174
 ;;21,"00378-2073-01 ")
 ;;2740
 ;;21,"00378-2073-10 ")
 ;;2741
 ;;21,"00378-2074-01 ")
 ;;1983
 ;;21,"00378-2074-10 ")
 ;;1984
 ;;21,"00378-2075-01 ")
 ;;2284
 ;;21,"00378-2075-10 ")
 ;;2285
 ;;21,"00378-2076-01 ")
 ;;2557
 ;;21,"00378-2076-05 ")
 ;;2558
 ;;21,"00378-2077-01 ")
 ;;2474
 ;;21,"00378-3007-01 ")
 ;;974
 ;;21,"00378-3007-10 ")
 ;;975
 ;;21,"00378-3012-01 ")
 ;;1058
 ;;21,"00378-3012-10 ")
 ;;1059
 ;;21,"00378-3017-01 ")
 ;;1165
 ;;21,"00378-3017-10 ")
 ;;1166
 ;;21,"00378-3022-01 ")
 ;;920
 ;;21,"00378-3241-01 ")
 ;;3233
 ;;21,"00378-3242-01 ")
 ;;3251
 ;;21,"00378-3243-01 ")
 ;;3269
 ;;21,"00378-4041-77 ")
 ;;3846
 ;;21,"00378-4042-77 ")
 ;;3899
 ;;21,"00378-4042-93 ")
 ;;3900
 ;;21,"00378-4043-77 ")
 ;;3778
 ;;21,"00378-4043-93 ")
 ;;3779
 ;;21,"00378-4725-01 ")
 ;;243
 ;;21,"00378-4735-01 ")
 ;;183
 ;;21,"00378-4745-01 ")
 ;;202
 ;;21,"00378-4775-01 ")
 ;;226
 ;;21,"00440-7140-30 ")
 ;;47
 ;;21,"00440-7140-90 ")
 ;;48
 ;;21,"00440-7141-30 ")
 ;;67
 ;;21,"00440-7141-90 ")
 ;;68
 ;;21,"00440-7142-30 ")
 ;;103
 ;;21,"00440-7142-90 ")
 ;;104
 ;;21,"00440-7143-30 ")
 ;;5
 ;;21,"00440-7143-90 ")
 ;;6
 ;;21,"00440-7190-30 ")
 ;;665
 ;;21,"00440-7190-90 ")
 ;;666
 ;;21,"00440-7192-30 ")
 ;;742
 ;;21,"00440-7192-90 ")
 ;;743
 ;;21,"00440-7193-30 ")
 ;;824
 ;;21,"00440-7193-90 ")
 ;;825
 ;;21,"00440-7230-60 ")
 ;;976
 ;;21,"00440-7230-90 ")
 ;;977
 ;;21,"00440-7230-92 ")
 ;;978
 ;;21,"00440-7230-94 ")
 ;;979
 ;;21,"00440-7231-30 ")
 ;;1060
 ;;21,"00440-7231-60 ")
 ;;1061
 ;;21,"00440-7231-90 ")
 ;;1062
 ;;21,"00440-7231-91 ")
 ;;1063
 ;;21,"00440-7231-92 ")
 ;;1064
 ;;21,"00440-7231-94 ")
 ;;1065
 ;;21,"00440-7232-30 ")
 ;;1167
 ;;21,"00440-7232-60 ")
 ;;1168
 ;;21,"00440-7232-90 ")
 ;;1169
 ;;21,"00440-7232-91 ")
 ;;1170
 ;;21,"00440-7232-92 ")
 ;;1171
 ;;21,"00440-7232-94 ")
 ;;1172
 ;;21,"00440-7345-99 ")
 ;;3901
 ;;21,"00440-7485-90 ")
 ;;1416
