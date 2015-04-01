BGP51Q9 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 19, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"60429-0234-90 ")
 ;;844
 ;;21,"60429-0235-10 ")
 ;;882
 ;;21,"60429-0235-18 ")
 ;;883
 ;;21,"60429-0235-45 ")
 ;;884
 ;;21,"60429-0235-90 ")
 ;;885
 ;;21,"60429-0236-10 ")
 ;;946
 ;;21,"60429-0236-18 ")
 ;;947
 ;;21,"60429-0236-45 ")
 ;;948
 ;;21,"60429-0236-90 ")
 ;;949
 ;;21,"60429-0257-01 ")
 ;;474
 ;;21,"60429-0316-10 ")
 ;;2586
 ;;21,"60429-0316-30 ")
 ;;2587
 ;;21,"60429-0316-90 ")
 ;;2588
 ;;21,"60429-0317-10 ")
 ;;2736
 ;;21,"60429-0317-30 ")
 ;;2737
 ;;21,"60429-0317-90 ")
 ;;2738
 ;;21,"60429-0318-10 ")
 ;;2845
 ;;21,"60429-0318-30 ")
 ;;2846
 ;;21,"60429-0318-90 ")
 ;;2847
 ;;21,"60429-0728-01 ")
 ;;992
 ;;21,"60429-0728-10 ")
 ;;993
 ;;21,"60429-0728-30 ")
 ;;994
 ;;21,"60429-0728-90 ")
 ;;995
 ;;21,"60429-0729-01 ")
 ;;1078
 ;;21,"60429-0729-10 ")
 ;;1079
 ;;21,"60429-0729-30 ")
 ;;1080
 ;;21,"60429-0729-45 ")
 ;;1081
 ;;21,"60429-0729-90 ")
 ;;1082
 ;;21,"60429-0730-01 ")
 ;;1272
 ;;21,"60429-0730-10 ")
 ;;1273
 ;;21,"60429-0730-30 ")
 ;;1274
 ;;21,"60429-0730-45 ")
 ;;1275
 ;;21,"60429-0730-90 ")
 ;;1276
 ;;21,"60429-0731-01 ")
 ;;1491
 ;;21,"60429-0731-10 ")
 ;;1492
 ;;21,"60429-0731-30 ")
 ;;1493
 ;;21,"60429-0731-45 ")
 ;;1494
 ;;21,"60429-0731-90 ")
 ;;1495
 ;;21,"60429-0732-10 ")
 ;;1725
 ;;21,"60429-0732-30 ")
 ;;1726
 ;;21,"60429-0732-90 ")
 ;;1727
 ;;21,"60429-0733-01 ")
 ;;1786
 ;;21,"60429-0733-10 ")
 ;;1787
 ;;21,"60429-0733-30 ")
 ;;1788
 ;;21,"60429-0733-45 ")
 ;;1789
 ;;21,"60429-0733-90 ")
 ;;1790
 ;;21,"60429-0755-10 ")
 ;;839
 ;;21,"60429-0755-45 ")
 ;;840
 ;;21,"60429-0755-90 ")
 ;;841
 ;;21,"60429-0756-10 ")
 ;;878
 ;;21,"60429-0756-18 ")
 ;;879
 ;;21,"60429-0756-45 ")
 ;;880
 ;;21,"60429-0756-90 ")
 ;;881
 ;;21,"60429-0757-10 ")
 ;;942
 ;;21,"60429-0757-18 ")
 ;;943
 ;;21,"60429-0757-45 ")
 ;;944
 ;;21,"60429-0757-90 ")
 ;;945
 ;;21,"60505-0003-06 ")
 ;;294
 ;;21,"60505-0003-09 ")
 ;;295
 ;;21,"60505-0004-06 ")
 ;;364
 ;;21,"60505-0004-09 ")
 ;;365
 ;;21,"60505-0005-06 ")
 ;;444
 ;;21,"60505-0005-09 ")
 ;;445
 ;;21,"60505-0006-06 ")
 ;;472
 ;;21,"60505-0006-09 ")
 ;;473
 ;;21,"60505-0049-07 ")
 ;;478
 ;;21,"60505-0049-09 ")
 ;;479
 ;;21,"60505-0050-07 ")
 ;;616
 ;;21,"60505-0050-09 ")
 ;;617
 ;;21,"60505-0051-07 ")
 ;;714
 ;;21,"60505-0051-09 ")
 ;;715
 ;;21,"60505-0052-09 ")
 ;;822
 ;;21,"60505-0172-00 ")
 ;;2008
 ;;21,"60505-0172-01 ")
 ;;2009
 ;;21,"60505-0173-00 ")
 ;;2033
 ;;21,"60505-0173-01 ")
 ;;2034
 ;;21,"60505-0174-00 ")
 ;;2063
 ;;21,"60505-0174-01 ")
 ;;2064
 ;;21,"60505-0175-00 ")
 ;;2095
 ;;21,"60505-0175-01 ")
 ;;2096
 ;;21,"60505-0184-00 ")
 ;;999
 ;;21,"60505-0185-00 ")
 ;;1088
 ;;21,"60505-0185-01 ")
 ;;1089
 ;;21,"60505-0185-07 ")
 ;;1090
 ;;21,"60505-0185-09 ")
 ;;1091
 ;;21,"60505-0186-00 ")
 ;;1305
 ;;21,"60505-0186-01 ")
 ;;1306
 ;;21,"60505-0186-07 ")
 ;;1307
 ;;21,"60505-0186-09 ")
 ;;1308
 ;;21,"60505-0187-00 ")
 ;;1496
 ;;21,"60505-0187-01 ")
 ;;1497
 ;;21,"60505-0187-07 ")
 ;;1498
 ;;21,"60505-0187-09 ")
 ;;1499
 ;;21,"60505-0188-00 ")
 ;;1728
 ;;21,"60505-0188-01 ")
 ;;1729
 ;;21,"60505-0189-00 ")
 ;;1791
 ;;21,"60505-0189-01 ")
 ;;1792
 ;;21,"60505-0189-08 ")
 ;;1793
 ;;21,"60505-0189-09 ")
 ;;1794
 ;;21,"60505-0205-03 ")
 ;;3428
 ;;21,"60505-0205-07 ")
 ;;3429
 ;;21,"60505-0206-03 ")
 ;;3500
 ;;21,"60505-0206-07 ")
 ;;3501
 ;;21,"60505-0207-03 ")
 ;;3605
 ;;21,"60505-0207-07 ")
 ;;3606
 ;;21,"60505-0208-01 ")
 ;;3368
 ;;21,"60505-0209-01 ")
 ;;3369
 ;;21,"60505-0265-01 ")
 ;;26
 ;;21,"60505-0266-01 ")
 ;;79
 ;;21,"60505-0266-05 ")
 ;;80
 ;;21,"60505-0267-01 ")
 ;;158
 ;;21,"60505-0267-05 ")
 ;;159
 ;;21,"60505-0268-01 ")
 ;;232
 ;;21,"60505-0268-05 ")
 ;;233
 ;;21,"60505-0271-01 ")
 ;;1975
 ;;21,"60505-0272-01 ")
 ;;1981
 ;;21,"60505-2510-02 ")
 ;;846
 ;;21,"60505-2510-04 ")
 ;;847
 ;;21,"60505-2511-02 ")
 ;;886
 ;;21,"60505-2511-04 ")
 ;;887
 ;;21,"60505-2512-02 ")
 ;;950
 ;;21,"60505-2512-08 ")
 ;;951
 ;;21,"60505-2684-08 ")
 ;;1092
 ;;21,"60505-2684-09 ")
 ;;1093
 ;;21,"60505-2685-01 ")
 ;;1309
 ;;21,"60505-2685-09 ")
 ;;1310
 ;;21,"60505-2686-09 ")
 ;;1500
 ;;21,"60505-2688-08 ")
 ;;1795
 ;;21,"60505-2688-09 ")
 ;;1796
 ;;21,"60505-2875-01 ")
 ;;2120
 ;;21,"60505-2876-00 ")
 ;;2146
 ;;21,"60505-2876-01 ")
 ;;2147
 ;;21,"60505-2876-05 ")
 ;;2148
 ;;21,"60505-2877-00 ")
 ;;2194
 ;;21,"60505-2877-01 ")
 ;;2195
 ;;21,"60505-2877-05 ")
 ;;2196
 ;;21,"60505-2878-00 ")
 ;;2261
 ;;21,"60505-2878-01 ")
 ;;2262
 ;;21,"60505-2878-05 ")
 ;;2263
 ;;21,"60505-2915-03 ")
 ;;3922
 ;;21,"60505-2915-09 ")
 ;;3923
 ;;21,"60505-2916-03 ")
 ;;3990
 ;;21,"60505-2916-09 ")
 ;;3991
 ;;21,"60505-2917-03 ")
 ;;4057
 ;;21,"60505-2917-09 ")
 ;;4058
 ;;21,"60505-3160-08 ")
 ;;2584
 ;;21,"60505-3160-09 ")
 ;;2585
 ;;21,"60505-3161-03 ")
 ;;2739
 ;;21,"60505-3161-08 ")
 ;;2740
 ;;21,"60505-3161-09 ")
 ;;2741
 ;;21,"60505-3162-03 ")
 ;;2843
 ;;21,"60505-3162-09 ")
 ;;2844
 ;;21,"60505-3409-05 ")
 ;;3714
 ;;21,"60505-3409-09 ")
 ;;3715
 ;;21,"60505-3410-05 ")
 ;;3725
 ;;21,"60505-3410-09 ")
 ;;3726
 ;;21,"60505-3411-05 ")
 ;;3741
 ;;21,"60505-3411-09 ")
 ;;3742
 ;;21,"60505-3547-03 ")
 ;;2429
 ;;21,"60505-3547-09 ")
 ;;2430
 ;;21,"60505-3548-03 ")
 ;;2499
 ;;21,"60505-3548-05 ")
 ;;2500
 ;;21,"60505-3548-09 ")
 ;;2501
 ;;21,"60505-3549-03 ")
 ;;2557
 ;;21,"60505-3549-05 ")
 ;;2558
 ;;21,"60505-3549-09 ")
 ;;2559
 ;;21,"60505-3603-03 ")
 ;;3862
 ;;21,"60505-3603-09 ")
 ;;3863
 ;;21,"60505-3604-03 ")
 ;;3897
 ;;21,"60505-3604-09 ")
 ;;3898
 ;;21,"60505-3618-03 ")
 ;;2358
 ;;21,"60505-3619-03 ")
 ;;2364
 ;;21,"60505-3620-03 ")
 ;;2381
 ;;21,"60505-3620-09 ")
 ;;2382
 ;;21,"60505-3621-03 ")
 ;;2393
 ;;21,"60505-3621-09 ")
 ;;2394
 ;;21,"60505-3758-05 ")
 ;;3802
 ;;21,"60505-3758-09 ")
 ;;3803
 ;;21,"60505-3759-05 ")
 ;;3816
 ;;21,"60505-3759-09 ")
 ;;3817
 ;;21,"60505-3760-09 ")
 ;;3822
 ;;21,"60505-3806-09 ")
 ;;4205
 ;;21,"60505-3807-09 ")
 ;;4240
 ;;21,"60505-3808-09 ")
 ;;4295
 ;;21,"60505-3809-09 ")
 ;;4331
 ;;21,"60505-3810-09 ")
 ;;4364
 ;;21,"60760-0063-30 ")
 ;;3426
 ;;21,"60760-0063-90 ")
 ;;3427
 ;;21,"60760-0064-30 ")
 ;;3502
 ;;21,"60760-0064-90 ")
 ;;3503
 ;;21,"60760-0065-30 ")
 ;;3603
 ;;21,"60760-0065-90 ")
 ;;3604
 ;;21,"60760-0082-90 ")
 ;;162
 ;;21,"60760-0083-30 ")
 ;;238
 ;;21,"60760-0128-30 ")
 ;;1525
 ;;21,"60760-0128-90 ")
 ;;1526
 ;;21,"60760-0129-90 ")
 ;;2729
 ;;21,"60760-0130-90 ")
 ;;2832
 ;;21,"60760-0224-30 ")
 ;;730
 ;;21,"60760-0225-30 ")
 ;;492
 ;;21,"60760-0266-30 ")
 ;;1107
 ;;21,"60760-0266-90 ")
 ;;1108
 ;;21,"60760-0267-30 ")
 ;;1315
 ;;21,"60760-0267-90 ")
 ;;1316
 ;;21,"60760-0270-30 ")
 ;;1810
 ;;21,"60760-0270-90 ")
 ;;1811
 ;;21,"60760-0302-30 ")
 ;;446
 ;;21,"60951-0185-92 ")
 ;;2590
 ;;21,"60951-0186-30 ")
 ;;2727
 ;;21,"60951-0186-92 ")
 ;;2728
 ;;21,"60951-0187-30 ")
 ;;2833
 ;;21,"60951-0187-92 ")
 ;;2834
 ;;21,"61570-0110-01 ")
 ;;2119
 ;;21,"61570-0111-01 ")
 ;;2141
 ;;21,"61570-0112-01 ")
 ;;2189
 ;;21,"61570-0120-01 ")
 ;;2254
 ;;21,"63304-0337-01 ")
 ;;27
 ;;21,"63304-0338-01 ")
 ;;77
 ;;21,"63304-0338-05 ")
 ;;78
 ;;21,"63304-0339-01 ")
 ;;160
 ;;21,"63304-0339-05 ")
 ;;161
 ;;21,"63304-0340-01 ")
 ;;239
 ;;21,"63304-0340-05 ")
 ;;240
 ;;21,"63304-0403-01 ")
 ;;3403
 ;;21,"63304-0404-01 ")
 ;;3414
 ;;21,"63304-0531-01 ")
 ;;1004
 ;;21,"63304-0532-01 ")
 ;;1105
 ;;21,"63304-0532-10 ")
 ;;1106
 ;;21,"63304-0533-01 ")
 ;;1317
 ;;21,"63304-0533-10 ")
 ;;1318
 ;;21,"63304-0534-01 ")
 ;;1523
 ;;21,"63304-0534-10 ")
 ;;1524
 ;;21,"63304-0535-01 ")
 ;;1812
 ;;21,"63304-0535-10 ")
 ;;1813
 ;;21,"63304-0536-01 ")
 ;;3497
 ;;21,"63304-0536-05 ")
 ;;3419
 ;;21,"63304-0537-01 ")
 ;;3596
 ;;21,"63304-0537-05 ")
 ;;3499
 ;;21,"63304-0538-01 ")
 ;;3689
 ;;21,"63304-0538-05 ")
 ;;3600
 ;;21,"63304-0548-90 ")
 ;;2011
 ;;21,"63304-0549-90 ")
 ;;2035
 ;;21,"63304-0550-90 ")
 ;;2065
 ;;21,"63304-0551-90 ")
 ;;2097
 ;;21,"63304-0599-01 ")
 ;;1736
 ;;21,"63629-1241-01 ")
 ;;2066
 ;;21,"63629-1242-01 ")
 ;;2089
 ;;21,"63629-1253-01 ")
 ;;2255
 ;;21,"63629-1253-02 ")
 ;;2256
 ;;21,"63629-1254-01 ")
 ;;2190
 ;;21,"63629-1254-02 ")
 ;;2191
 ;;21,"63629-1337-01 ")
 ;;2635
 ;;21,"63629-1337-02 ")
 ;;2636
 ;;21,"63629-1337-03 ")
 ;;2637
 ;;21,"63629-1338-01 ")
 ;;361
 ;;21,"63629-1338-02 ")
 ;;362
 ;;21,"63629-1338-03 ")
 ;;363
 ;;21,"63629-1454-01 ")
 ;;3139
 ;;21,"63629-1522-01 ")
 ;;593
 ;;21,"63629-1522-02 ")
 ;;594
 ;;21,"63629-1522-03 ")
 ;;595
 ;;21,"63629-1522-04 ")
 ;;596
 ;;21,"63629-1525-01 ")
 ;;823
 ;;21,"63629-1525-02 ")
 ;;824
 ;;21,"63629-1525-03 ")
 ;;825
 ;;21,"63629-1526-01 ")
 ;;727
 ;;21,"63629-1526-02 ")
 ;;728
 ;;21,"63629-1526-03 ")
 ;;729
 ;;21,"63629-1679-01 ")
 ;;3415
 ;;21,"63629-1679-02 ")
 ;;3416
 ;;21,"63629-1679-03 ")
 ;;3417
 ;;21,"63629-1679-04 ")
 ;;3418
 ;;21,"63629-1706-01 ")
 ;;469
 ;;21,"63629-1706-02 ")
 ;;470
 ;;21,"63629-1706-03 ")
 ;;471
 ;;21,"63629-1728-01 ")
 ;;163
 ;;21,"63629-1728-02 ")
 ;;164
 ;;21,"63629-1728-03 ")
 ;;165
 ;;21,"63629-1761-01 ")
 ;;1109
 ;;21,"63629-1809-01 ")
 ;;3292
 ;;21,"63629-1809-02 ")
 ;;3293
 ;;21,"63629-1809-03 ")
 ;;3306
 ;;21,"63629-2541-01 ")
 ;;447
 ;;21,"63629-2541-02 ")
 ;;448
 ;;21,"63629-2541-03 ")
 ;;449
 ;;21,"63629-2541-04 ")
 ;;450
 ;;21,"63629-2672-01 ")
 ;;74
 ;;21,"63629-2672-02 ")
 ;;75
 ;;21,"63629-2672-03 ")
 ;;76
 ;;21,"63629-2679-01 ")
 ;;28
 ;;21,"63629-2680-01 ")
 ;;3307
 ;;21,"63629-2680-02 ")
 ;;3308
 ;;21,"63629-2680-03 ")
 ;;3309
 ;;21,"63629-2688-01 ")
 ;;1311
 ;;21,"63629-2688-02 ")
 ;;1312
 ;;21,"63629-2688-03 ")
 ;;1313
 ;;21,"63629-2735-01 ")
 ;;3329
 ;;21,"63629-2896-01 ")
 ;;296
 ;;21,"63629-2908-01 ")
 ;;1528
 ;;21,"63629-2908-02 ")
 ;;1529
 ;;21,"63629-2908-03 ")
 ;;1530
 ;;21,"63629-2908-04 ")
 ;;1531
 ;;21,"63629-2912-01 ")
 ;;2748
 ;;21,"63629-2912-02 ")
 ;;2749
 ;;21,"63629-2912-03 ")
 ;;2750
 ;;21,"63629-2912-04 ")
 ;;2751
 ;;21,"63629-2923-01 ")
 ;;236
 ;;21,"63629-2923-02 ")
 ;;237
 ;;21,"63629-2935-01 ")
 ;;1814
 ;;21,"63629-2935-02 ")
 ;;1815
 ;;21,"63629-2935-03 ")
 ;;1816
 ;;21,"63629-2935-04 ")
 ;;1817
 ;;21,"63629-3217-01 ")
 ;;3370
 ;;21,"63629-3344-01 ")
 ;;4059
 ;;21,"63629-3344-02 ")
 ;;4060
 ;;21,"63629-3371-01 ")
 ;;2982
 ;;21,"63629-3371-02 ")
 ;;2983
 ;;21,"63629-3371-03 ")
 ;;2984
 ;;21,"63629-3371-04 ")
 ;;2985
 ;;21,"63629-3373-01 ")
 ;;2434
 ;;21,"63629-3373-02 ")
 ;;2435
 ;;21,"63629-3373-03 ")
 ;;2436
 ;;21,"63629-3373-04 ")
 ;;2437
 ;;21,"63629-3374-01 ")
 ;;3830
 ;;21,"63629-3374-02 ")
 ;;3831
 ;;21,"63629-3374-03 ")
 ;;3832
 ;;21,"63629-3374-04 ")
 ;;3833
 ;;21,"63629-3376-01 ")
 ;;2365
 ;;21,"63629-3376-02 ")
 ;;2366
 ;;21,"63629-3376-03 ")
 ;;2367
 ;;21,"63629-3376-04 ")
 ;;2368
 ;;21,"63629-3377-01 ")
 ;;3804
 ;;21,"63629-3377-02 ")
 ;;3805
 ;;21,"63629-3377-03 ")
 ;;3806
 ;;21,"63629-3377-04 ")
 ;;3807
 ;;21,"63629-3390-01 ")
 ;;2871
 ;;21,"63629-3390-02 ")
 ;;2872
 ;;21,"63629-3390-03 ")
 ;;2873
 ;;21,"63629-3390-04 ")
 ;;2874
 ;;21,"63629-3739-01 ")
 ;;3598
 ;;21,"63629-3739-02 ")
 ;;3599
 ;;21,"63739-0349-10 ")
 ;;1314
 ;;21,"63739-0350-10 ")
 ;;1527
 ;;21,"63739-0513-10 ")
 ;;2589
 ;;21,"63739-0514-10 ")
 ;;2730
 ;;21,"63739-0515-10 ")
 ;;2791
 ;;21,"63739-0527-10 ")
 ;;3946
 ;;21,"63739-0528-10 ")
 ;;4019
 ;;21,"63739-0529-10 ")
 ;;4082
 ;;21,"63874-0058-10 ")
 ;;2083
 ;;21,"63874-0058-15 ")
 ;;2084
 ;;21,"63874-0058-30 ")
 ;;2085
 ;;21,"63874-0058-90 ")
 ;;2086
 ;;21,"63874-0347-01 ")
 ;;338
 ;;21,"63874-0347-02 ")
 ;;339
 ;;21,"63874-0347-05 ")
 ;;340
 ;;21,"63874-0347-20 ")
 ;;341
 ;;21,"63874-0347-30 ")
 ;;342
 ;;21,"63874-0347-40 ")
 ;;343
 ;;21,"63874-0347-42 ")
 ;;344
 ;;21,"63874-0347-45 ")
 ;;345
 ;;21,"63874-0347-90 ")
 ;;346
 ;;21,"63874-0348-01 ")
 ;;421
 ;;21,"63874-0348-10 ")
 ;;422
 ;;21,"63874-0348-14 ")
 ;;423
 ;;21,"63874-0348-20 ")
 ;;424
 ;;21,"63874-0348-30 ")
 ;;425
 ;;21,"63874-0348-60 ")
 ;;426
 ;;21,"63874-0348-90 ")
 ;;427
 ;;21,"63874-0349-01 ")
 ;;465
 ;;21,"63874-0349-10 ")
 ;;466
 ;;21,"63874-0349-30 ")
 ;;467
 ;;21,"63874-0379-10 ")
 ;;2000
 ;;21,"63874-0379-30 ")
 ;;2001
 ;;21,"63874-0423-01 ")
 ;;532
 ;;21,"63874-0423-07 ")
 ;;533
 ;;21,"63874-0423-10 ")
 ;;534
 ;;21,"63874-0423-14 ")
 ;;535
 ;;21,"63874-0423-20 ")
 ;;536
 ;;21,"63874-0423-30 ")
 ;;537
 ;;21,"63874-0423-60 ")
 ;;538
 ;;21,"63874-0514-01 ")
 ;;1548
 ;;21,"63874-0514-10 ")
 ;;1549
 ;;21,"63874-0514-14 ")
 ;;1550
 ;;21,"63874-0514-15 ")
 ;;1551
 ;;21,"63874-0514-16 ")
 ;;1552
 ;;21,"63874-0514-20 ")
 ;;1553
 ;;21,"63874-0514-28 ")
 ;;1554
 ;;21,"63874-0514-30 ")
 ;;1555