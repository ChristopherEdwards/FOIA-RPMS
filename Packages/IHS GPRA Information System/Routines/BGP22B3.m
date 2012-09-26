BGP22B3 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 21, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"00440-7486-10 ")
 ;;1644
 ;;21,"00440-7486-30 ")
 ;;1645
 ;;21,"00440-7486-60 ")
 ;;1646
 ;;21,"00440-7486-90 ")
 ;;1647
 ;;21,"00440-7486-91 ")
 ;;1648
 ;;21,"00440-7487-30 ")
 ;;1282
 ;;21,"00440-7487-90 ")
 ;;1283
 ;;21,"00440-7488-90 ")
 ;;1505
 ;;21,"00440-7550-45 ")
 ;;1755
 ;;21,"00440-7550-90 ")
 ;;1756
 ;;21,"00440-7551-45 ")
 ;;1812
 ;;21,"00440-7551-90 ")
 ;;1813
 ;;21,"00440-7552-45 ")
 ;;1873
 ;;21,"00440-7552-90 ")
 ;;1874
 ;;21,"00440-7552-92 ")
 ;;1875
 ;;21,"00440-7674-90 ")
 ;;2742
 ;;21,"00440-7675-30 ")
 ;;1985
 ;;21,"00440-7675-90 ")
 ;;1986
 ;;21,"00440-7675-99 ")
 ;;1941
 ;;21,"00440-7676-14 ")
 ;;2286
 ;;21,"00440-7676-30 ")
 ;;2287
 ;;21,"00440-7676-45 ")
 ;;2288
 ;;21,"00440-7676-90 ")
 ;;2289
 ;;21,"00440-7677-90 ")
 ;;2559
 ;;21,"00440-7682-30 ")
 ;;369
 ;;21,"00440-7683-30 ")
 ;;453
 ;;21,"00440-7683-60 ")
 ;;454
 ;;21,"00440-7684-30 ")
 ;;540
 ;;21,"00440-8072-06 ")
 ;;2995
 ;;21,"00440-8270-06 ")
 ;;2967
 ;;21,"00440-8272-06 ")
 ;;2996
 ;;21,"00440-8567-30 ")
 ;;3234
 ;;21,"00440-8567-60 ")
 ;;3235
 ;;21,"00440-8567-90 ")
 ;;3236
 ;;21,"00440-8568-30 ")
 ;;3252
 ;;21,"00440-8568-60 ")
 ;;3253
 ;;21,"00440-8568-90 ")
 ;;3254
 ;;21,"00440-8569-30 ")
 ;;3270
 ;;21,"00440-8569-60 ")
 ;;3271
 ;;21,"00440-8569-90 ")
 ;;3272
 ;;21,"00490-0067-00 ")
 ;;289
 ;;21,"00490-0067-30 ")
 ;;290
 ;;21,"00490-0067-60 ")
 ;;291
 ;;21,"00490-0067-90 ")
 ;;292
 ;;21,"00490-7030-00 ")
 ;;314
 ;;21,"00490-7030-30 ")
 ;;315
 ;;21,"00490-7030-60 ")
 ;;316
 ;;21,"00490-7030-90 ")
 ;;317
 ;;21,"00574-0110-01 ")
 ;;2900
 ;;21,"00574-0112-15 ")
 ;;2886
 ;;21,"00574-0133-01 ")
 ;;611
 ;;21,"00574-0134-01 ")
 ;;592
 ;;21,"00574-0135-01 ")
 ;;599
 ;;21,"00591-0405-01 ")
 ;;2175
 ;;21,"00591-0405-05 ")
 ;;2176
 ;;21,"00591-0406-01 ")
 ;;2743
 ;;21,"00591-0406-10 ")
 ;;2744
 ;;21,"00591-0407-01 ")
 ;;1987
 ;;21,"00591-0407-10 ")
 ;;1988
 ;;21,"00591-0408-01 ")
 ;;2290
 ;;21,"00591-0408-10 ")
 ;;2291
 ;;21,"00591-0409-01 ")
 ;;2560
 ;;21,"00591-0409-05 ")
 ;;2561
 ;;21,"00591-0409-75 ")
 ;;2541
 ;;21,"00591-0668-01 ")
 ;;1402
 ;;21,"00591-0668-05 ")
 ;;1403
 ;;21,"00591-0669-01 ")
 ;;1620
 ;;21,"00591-0669-05 ")
 ;;1621
 ;;21,"00591-0670-01 ")
 ;;1257
 ;;21,"00591-0670-05 ")
 ;;1260
 ;;21,"00591-0671-01 ")
 ;;1483
 ;;21,"00591-0671-05 ")
 ;;1486
 ;;21,"00591-0860-01 ")
 ;;370
 ;;21,"00591-0860-05 ")
 ;;371
 ;;21,"00591-0861-01 ")
 ;;455
 ;;21,"00591-0861-05 ")
 ;;456
 ;;21,"00591-0862-01 ")
 ;;541
 ;;21,"00591-0862-05 ")
 ;;542
 ;;21,"00591-0885-01 ")
 ;;2475
 ;;21,"00591-3745-10 ")
 ;;3847
 ;;21,"00591-3745-19 ")
 ;;3848
 ;;21,"00591-3746-10 ")
 ;;3902
 ;;21,"00591-3746-19 ")
 ;;3903
 ;;21,"00591-3746-30 ")
 ;;3904
 ;;21,"00591-3747-10 ")
 ;;3780
 ;;21,"00591-3747-19 ")
 ;;3781
 ;;21,"00591-3747-30 ")
 ;;3782
 ;;21,"00591-3757-01 ")
 ;;49
 ;;21,"00591-3758-01 ")
 ;;69
 ;;21,"00591-3758-05 ")
 ;;70
 ;;21,"00591-3759-01 ")
 ;;105
 ;;21,"00591-3759-05 ")
 ;;106
 ;;21,"00591-3760-01 ")
 ;;7
 ;;21,"00591-3760-05 ")
 ;;8
 ;;21,"00597-0039-28 ")
 ;;3997
 ;;21,"00597-0039-37 ")
 ;;3998
 ;;21,"00597-0040-28 ")
 ;;4003
 ;;21,"00597-0040-37 ")
 ;;4004
 ;;21,"00597-0041-28 ")
 ;;4014
 ;;21,"00597-0041-37 ")
 ;;4015
 ;;21,"00597-0042-28 ")
 ;;3568
 ;;21,"00597-0042-37 ")
 ;;3569
 ;;21,"00597-0043-28 ")
 ;;3553
 ;;21,"00597-0043-37 ")
 ;;3555
 ;;21,"00597-0044-28 ")
 ;;3560
 ;;21,"00597-0044-37 ")
 ;;3562
 ;;21,"00597-0124-37 ")
 ;;3329
 ;;21,"00597-0125-37 ")
 ;;3328
 ;;21,"00597-0126-37 ")
 ;;3331
 ;;21,"00597-0127-37 ")
 ;;3330
 ;;21,"00603-4209-21 ")
 ;;2177
 ;;21,"00603-4209-28 ")
 ;;2178
 ;;21,"00603-4210-02 ")
 ;;2745
 ;;21,"00603-4210-16 ")
 ;;2746
 ;;21,"00603-4210-21 ")
 ;;2747
 ;;21,"00603-4210-28 ")
 ;;2748
 ;;21,"00603-4210-32 ")
 ;;2749
 ;;21,"00603-4210-60 ")
 ;;2750
 ;;21,"00603-4211-02 ")
 ;;1989
 ;;21,"00603-4211-21 ")
 ;;1990
 ;;21,"00603-4211-28 ")
 ;;1991
 ;;21,"00603-4211-32 ")
 ;;1992
 ;;21,"00603-4211-34 ")
 ;;1993
 ;;21,"00603-4211-60 ")
 ;;1994
 ;;21,"00603-4212-02 ")
 ;;2292
 ;;21,"00603-4212-21 ")
 ;;2293
 ;;21,"00603-4212-28 ")
 ;;2294
 ;;21,"00603-4212-32 ")
 ;;2295
 ;;21,"00603-4212-34 ")
 ;;2296
 ;;21,"00603-4212-60 ")
 ;;2297
 ;;21,"00603-4213-21 ")
 ;;2476
 ;;21,"00603-4213-28 ")
 ;;2477
 ;;21,"00603-4214-02 ")
 ;;2562
 ;;21,"00603-4214-04 ")
 ;;2563
 ;;21,"00603-4214-21 ")
 ;;2564
 ;;21,"00603-4214-28 ")
 ;;2565
 ;;21,"00603-4214-30 ")
 ;;2566
 ;;21,"00603-4214-32 ")
 ;;2567
 ;;21,"00603-4214-60 ")
 ;;2568
 ;;21,"00615-4519-53 ")
 ;;954
 ;;21,"00615-4519-63 ")
 ;;955
 ;;21,"00615-4520-53 ")
 ;;1025
 ;;21,"00615-4520-63 ")
 ;;1026
 ;;21,"00615-4521-53 ")
 ;;1140
 ;;21,"00615-4521-63 ")
 ;;1141
 ;;21,"00615-4590-53 ")
 ;;1607
 ;;21,"00615-4590-63 ")
 ;;1608
 ;;21,"00615-4591-53 ")
 ;;1244
 ;;21,"00615-4591-63 ")
 ;;1245
 ;;21,"00781-1176-01 ")
 ;;425
 ;;21,"00781-1178-01 ")
 ;;519
 ;;21,"00781-1229-01 ")
 ;;1391
 ;;21,"00781-1229-10 ")
 ;;1392
 ;;21,"00781-1229-13 ")
 ;;1393
 ;;21,"00781-1231-01 ")
 ;;1609
 ;;21,"00781-1231-10 ")
 ;;1610
 ;;21,"00781-1231-13 ")
 ;;1611
 ;;21,"00781-1232-01 ")
 ;;1246
 ;;21,"00781-1232-10 ")
 ;;1247
 ;;21,"00781-1232-13 ")
 ;;1248
 ;;21,"00781-1233-01 ")
 ;;1472
 ;;21,"00781-1233-10 ")
 ;;1473
 ;;21,"00781-1665-01 ")
 ;;2751
 ;;21,"00781-1665-92 ")
 ;;2752
 ;;21,"00781-1666-01 ")
 ;;1995
 ;;21,"00781-1666-92 ")
 ;;1996
 ;;21,"00781-1667-01 ")
 ;;2298
 ;;21,"00781-1667-92 ")
 ;;2299
 ;;21,"00781-1668-01 ")
 ;;2569
 ;;21,"00781-1668-92 ")
 ;;2570
 ;;21,"00781-1669-01 ")
 ;;2179
 ;;21,"00781-1673-01 ")
 ;;2478
 ;;21,"00781-1828-01 ")
 ;;980
 ;;21,"00781-1828-10 ")
 ;;981
 ;;21,"00781-1829-01 ")
 ;;1066
 ;;21,"00781-1829-10 ")
 ;;1067
 ;;21,"00781-1838-01 ")
 ;;1173
 ;;21,"00781-1838-10 ")
 ;;1174
 ;;21,"00781-1839-01 ")
 ;;921
 ;;21,"00781-1848-01 ")
 ;;348
 ;;21,"00781-1891-01 ")
 ;;888
 ;;21,"00781-1892-01 ")
 ;;667
 ;;21,"00781-1893-01 ")
 ;;725
 ;;21,"00781-1894-01 ")
 ;;809
 ;;21,"00781-2126-01 ")
 ;;3039
 ;;21,"00781-2127-01 ")
 ;;3130
 ;;21,"00781-2127-05 ")
 ;;3131
 ;;21,"00781-2128-01 ")
 ;;3178
 ;;21,"00781-2128-05 ")
 ;;3179
 ;;21,"00781-2129-01 ")
 ;;3070
 ;;21,"00781-2129-05 ")
 ;;3071
 ;;21,"00781-2271-01 ")
 ;;50
 ;;21,"00781-2271-64 ")
 ;;51
 ;;21,"00781-2272-01 ")
 ;;71
 ;;21,"00781-2272-10 ")
 ;;72
 ;;21,"00781-2272-64 ")
 ;;73
 ;;21,"00781-2273-01 ")
 ;;107
 ;;21,"00781-2273-10 ")
 ;;108
 ;;21,"00781-2273-64 ")
 ;;109
 ;;21,"00781-2274-01 ")
 ;;9
 ;;21,"00781-2274-10 ")
 ;;10
 ;;21,"00781-2274-64 ")
 ;;11
 ;;21,"00781-2277-01 ")
 ;;137
 ;;21,"00781-2279-01 ")
 ;;36
 ;;21,"00781-5083-10 ")
 ;;1739
 ;;21,"00781-5083-92 ")
 ;;1738
 ;;21,"00781-5084-10 ")
 ;;1791
 ;;21,"00781-5084-92 ")
 ;;1789
 ;;21,"00781-5085-92 ")
 ;;1863
 ;;21,"00781-5131-01 ")
 ;;244
 ;;21,"00781-5132-01 ")
 ;;184
 ;;21,"00781-5133-01 ")
 ;;203
 ;;21,"00781-5134-01 ")
 ;;227
 ;;21,"00781-5204-10 ")
 ;;3397
 ;;21,"00781-5204-31 ")
 ;;3398
 ;;21,"00781-5204-92 ")
 ;;3399
 ;;21,"00781-5206-10 ")
 ;;3489
 ;;21,"00781-5206-31 ")
 ;;3490
 ;;21,"00781-5206-92 ")
 ;;3491
 ;;21,"00781-5207-31 ")
 ;;3437
 ;;21,"00781-5207-92 ")
 ;;3438
 ;;21,"00781-5320-01 ")
 ;;3237
 ;;21,"00781-5321-01 ")
 ;;3255
 ;;21,"00781-5322-01 ")
 ;;3273
 ;;21,"00781-5441-01 ")
 ;;1417
 ;;21,"00781-5441-10 ")
 ;;1418
 ;;21,"00781-5442-01 ")
 ;;1649
 ;;21,"00781-5442-10 ")
 ;;1650
 ;;21,"00781-5443-01 ")
 ;;1284
 ;;21,"00781-5443-10 ")
 ;;1285
 ;;21,"00781-5444-01 ")
 ;;1506
 ;;21,"00781-5444-10 ")
 ;;1507
 ;;21,"00781-5700-10 ")
 ;;3849
 ;;21,"00781-5700-92 ")
 ;;3850
 ;;21,"00781-5701-31 ")
 ;;3905
 ;;21,"00781-5701-92 ")
 ;;3906
 ;;21,"00781-5702-10 ")
 ;;3783
 ;;21,"00781-5702-31 ")
 ;;3784
 ;;21,"00781-5702-92 ")
 ;;3785
 ;;21,"00781-5805-10 ")
 ;;3851
 ;;21,"00781-5805-92 ")
 ;;3852
 ;;21,"00781-5806-10 ")
 ;;3907
 ;;21,"00781-5806-31 ")
 ;;3908
 ;;21,"00781-5806-92 ")
 ;;3909
 ;;21,"00781-5807-10 ")
 ;;3786
 ;;21,"00781-5807-31 ")
 ;;3787
 ;;21,"00781-5807-92 ")
 ;;3788
 ;;21,"00781-5816-10 ")
 ;;3492
 ;;21,"00781-5816-31 ")
 ;;3493
 ;;21,"00781-5816-92 ")
 ;;3494
 ;;21,"00781-5817-10 ")
 ;;3400
 ;;21,"00781-5817-31 ")
 ;;3401
 ;;21,"00781-5817-92 ")
 ;;3402
 ;;21,"00781-5818-10 ")
 ;;3439
 ;;21,"00781-5818-31 ")
 ;;3440
 ;;21,"00781-5818-92 ")
 ;;3441
 ;;21,"00904-5045-60 ")
 ;;950
 ;;21,"00904-5045-61 ")
 ;;982
 ;;21,"00904-5045-80 ")
 ;;956
 ;;21,"00904-5046-60 ")
 ;;1030
 ;;21,"00904-5046-61 ")
 ;;1068
 ;;21,"00904-5046-80 ")
 ;;1031
 ;;21,"00904-5047-60 ")
 ;;1128
 ;;21,"00904-5047-61 ")
 ;;1175
 ;;21,"00904-5047-80 ")
 ;;1142
 ;;21,"00904-5048-60 ")
 ;;912
 ;;21,"00904-5501-60 ")
 ;;1419
 ;;21,"00904-5502-60 ")
 ;;1615
 ;;21,"00904-5502-61 ")
 ;;1651
 ;;21,"00904-5502-80 ")
 ;;1616
 ;;21,"00904-5503-60 ")
 ;;1242
 ;;21,"00904-5503-80 ")
 ;;1243
 ;;21,"00904-5504-60 ")
 ;;1470
 ;;21,"00904-5504-80 ")
 ;;1471
 ;;21,"00904-5609-60 ")
 ;;1390
 ;;21,"00904-5609-61 ")
 ;;1420
 ;;21,"00904-5610-60 ")
 ;;1252
 ;;21,"00904-5610-61 ")
 ;;1286
 ;;21,"00904-5610-80 ")
 ;;1251
 ;;21,"00904-5611-60 ")
 ;;1476
 ;;21,"00904-5611-61 ")
 ;;1508
 ;;21,"00904-5611-80 ")
 ;;1477
 ;;21,"00904-5637-61 ")
 ;;2147
 ;;21,"00904-5638-43 ")
 ;;2709
 ;;21,"00904-5638-46 ")
 ;;2708
 ;;21,"00904-5638-61 ")
 ;;2706
 ;;21,"00904-5638-89 ")
 ;;2753
 ;;21,"00904-5639-43 ")
 ;;1997
 ;;21,"00904-5639-46 ")
 ;;1998
 ;;21,"00904-5639-48 ")
 ;;1999
 ;;21,"00904-5639-61 ")
 ;;1940
 ;;21,"00904-5639-89 ")
 ;;2000
 ;;21,"00904-5639-93 ")
 ;;1943
 ;;21,"00904-5640-43 ")
 ;;2244
 ;;21,"00904-5640-46 ")
 ;;2300
 ;;21,"00904-5640-48 ")
 ;;2301
 ;;21,"00904-5640-61 ")
 ;;2241
 ;;21,"00904-5640-89 ")
 ;;2302
 ;;21,"00904-5640-93 ")
 ;;2245
 ;;21,"00904-5641-61 ")
 ;;2479
 ;;21,"00904-5642-43 ")
 ;;2532
 ;;21,"00904-5642-46 ")
 ;;2533
 ;;21,"00904-5642-48 ")
 ;;2534
 ;;21,"00904-5642-52 ")
 ;;2531
 ;;21,"00904-5642-61 ")
 ;;2530
 ;;21,"00904-5642-89 ")
 ;;2571
 ;;21,"00904-5642-93 ")
 ;;2535
 ;;21,"00904-5701-61 ")
 ;;1652
 ;;21,"00904-5757-89 ")
 ;;422
 ;;21,"00904-5778-89 ")
 ;;2154
 ;;21,"00904-5808-43 ")
 ;;2001
 ;;21,"00904-5808-46 ")
 ;;2002
 ;;21,"00904-5808-48 ")
 ;;2003
 ;;21,"00904-5808-61 ")
 ;;2004
 ;;21,"00904-5808-80 ")
 ;;2005
 ;;21,"00904-5808-89 ")
 ;;2006
 ;;21,"00904-5808-93 ")
 ;;2007
 ;;21,"00904-5809-43 ")
 ;;2303
 ;;21,"00904-5809-46 ")
 ;;2304
 ;;21,"00904-5809-48 ")
 ;;2305
 ;;21,"00904-5809-61 ")
 ;;2306
 ;;21,"00904-5809-80 ")
 ;;2307
 ;;21,"00904-5809-89 ")
 ;;2308
 ;;21,"00904-5809-93 ")
 ;;2309
 ;;21,"00904-5810-43 ")
 ;;2572
 ;;21,"00904-5810-46 ")
 ;;2573
 ;;21,"00904-5810-48 ")
 ;;2574
 ;;21,"00904-5810-52 ")
 ;;2575
 ;;21,"00904-5810-61 ")
 ;;2576
 ;;21,"00904-5810-80 ")
 ;;2577
 ;;21,"00904-5810-89 ")
 ;;2578
 ;;21,"00904-5810-93 ")
 ;;2579
 ;;21,"00904-5811-43 ")
 ;;2754
 ;;21,"00904-5811-46 ")
 ;;2755
 ;;21,"00904-5811-61 ")
 ;;2756
 ;;21,"00904-5811-80 ")
 ;;2757
 ;;21,"00904-5811-89 ")
 ;;2758
 ;;21,"00904-5812-40 ")
 ;;2160
 ;;21,"00904-5812-89 ")
 ;;2162
 ;;21,"00904-6189-40 ")
 ;;889
 ;;21,"00904-6190-40 ")
 ;;668
 ;;21,"00904-6191-40 ")
 ;;744
 ;;21,"00904-6192-40 ")
 ;;826
 ;;21,"12280-0005-90 ")
 ;;3832
 ;;21,"12280-0008-00 ")
 ;;4023
 ;;21,"12280-0008-90 ")
 ;;4027
 ;;21,"12280-0009-90 ")
 ;;3604
 ;;21,"12280-0033-00 ")
 ;;813
 ;;21,"12280-0059-90 ")
 ;;2930
 ;;21,"12280-0061-00 ")
 ;;3060
 ;;21,"12280-0063-30 ")
 ;;3709
 ;;21,"12280-0063-90 ")
 ;;3710
 ;;21,"12280-0066-30 ")
 ;;3763
 ;;21,"12280-0067-15 ")
 ;;3574
 ;;21,"12280-0067-30 ")
 ;;3575
 ;;21,"12280-0067-90 ")
 ;;3576
 ;;21,"12280-0120-30 ")
 ;;220
 ;;21,"12280-0121-30 ")
 ;;197
 ;;21,"12280-0123-30 ")
 ;;178
 ;;21,"12280-0124-30 ")
 ;;522
 ;;21,"12280-0126-30 ")
 ;;430
 ;;21,"12280-0126-60 ")
 ;;431
 ;;21,"12280-0127-30 ")
 ;;353
 ;;21,"12280-0129-60 ")
 ;;2462
 ;;21,"12280-0144-00 ")
 ;;2253
 ;;21,"12280-0168-30 ")
 ;;3978
 ;;21,"12280-0168-90 ")
 ;;3979
 ;;21,"12280-0183-30 ")
 ;;354
 ;;21,"12280-0220-00 ")
 ;;221
 ;;21,"12280-0228-90 ")
 ;;2958
 ;;21,"12280-0340-30 ")
 ;;3678
 ;;21,"12280-0369-30 ")
 ;;3738
 ;;21,"12280-0369-90 ")
 ;;3739
 ;;21,"12280-0370-30 ")
 ;;3358
 ;;21,"12280-0370-90 ")
 ;;3359
 ;;21,"12280-0371-30 ")
 ;;3371
 ;;21,"12280-0371-90 ")
 ;;3372
 ;;21,"12280-0375-30 ")
 ;;3957
 ;;21,"12280-0375-90 ")
 ;;3958
 ;;21,"12280-0378-90 ")
 ;;4057
 ;;21,"12280-0379-90 ")
 ;;3624
 ;;21,"12280-0380-30 ")
 ;;3474
 ;;21,"12280-0380-90 ")
 ;;3475
 ;;21,"12280-0382-30 ")
 ;;3554
 ;;21,"12280-0383-30 ")
 ;;3561
 ;;21,"13411-0106-01 ")
 ;;3715
 ;;21,"13411-0106-03 ")
 ;;3716
 ;;21,"13411-0106-06 ")
 ;;3717
