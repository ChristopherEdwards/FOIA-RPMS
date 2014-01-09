BGP33I ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON JAN 23, 2013;
 ;;13.0;IHS CLINICAL REPORTING;**1**;NOV 20, 2012;Build 7
 ;;BGP HEDIS ANTIDEPRESSANT NDC
 ;
 ; This routine loads Taxonomy BGP HEDIS ANTIDEPRESSANT NDC
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 D OTHER
 I $O(^TMP("ATX",$J,3.6,0)) D BULL^ATXSTX2
 I $O(^TMP("ATX",$J,9002226,0)) D TAX^ATXSTX2
 D KILL^ATXSTX2
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"00002-3004-75 ")
 ;;2423
 ;;21,"00002-3230-30 ")
 ;;2433
 ;;21,"00002-3231-01 ")
 ;;2435
 ;;21,"00002-3231-30 ")
 ;;2436
 ;;21,"00002-3231-33 ")
 ;;2437
 ;;21,"00002-3232-01 ")
 ;;2429
 ;;21,"00002-3232-30 ")
 ;;2430
 ;;21,"00002-3232-33 ")
 ;;2431
 ;;21,"00002-3233-01 ")
 ;;2443
 ;;21,"00002-3233-30 ")
 ;;2444
 ;;21,"00002-3233-33 ")
 ;;2445
 ;;21,"00002-3234-01 ")
 ;;2439
 ;;21,"00002-3234-30 ")
 ;;2440
 ;;21,"00002-3234-33 ")
 ;;2441
 ;;21,"00002-3235-01 ")
 ;;1747
 ;;21,"00002-3235-33 ")
 ;;1748
 ;;21,"00002-3235-60 ")
 ;;1749
 ;;21,"00002-3237-01 ")
 ;;1793
 ;;21,"00002-3237-04 ")
 ;;1794
 ;;21,"00002-3237-30 ")
 ;;1795
 ;;21,"00002-3237-33 ")
 ;;1796
 ;;21,"00002-3237-34 ")
 ;;1797
 ;;21,"00002-3240-01 ")
 ;;1760
 ;;21,"00002-3240-30 ")
 ;;1761
 ;;21,"00002-3240-33 ")
 ;;1762
 ;;21,"00002-3240-90 ")
 ;;1763
 ;;21,"00002-3270-01 ")
 ;;1798
 ;;21,"00002-3270-04 ")
 ;;1799
 ;;21,"00002-3270-30 ")
 ;;1800
 ;;21,"00002-3270-33 ")
 ;;1801
 ;;21,"00007-4471-20 ")
 ;;4141
 ;;21,"00008-0701-07 ")
 ;;4636
 ;;21,"00008-0701-08 ")
 ;;4637
 ;;21,"00008-0703-07 ")
 ;;4798
 ;;21,"00008-0703-08 ")
 ;;4799
 ;;21,"00008-0704-07 ")
 ;;4915
 ;;21,"00008-0704-08 ")
 ;;4916
 ;;21,"00008-0705-07 ")
 ;;4527
 ;;21,"00008-0705-08 ")
 ;;4528
 ;;21,"00008-0781-07 ")
 ;;4729
 ;;21,"00008-0781-08 ")
 ;;4730
 ;;21,"00008-0833-01 ")
 ;;4829
 ;;21,"00008-0833-02 ")
 ;;4830
 ;;21,"00008-0833-03 ")
 ;;4831
 ;;21,"00008-0833-20 ")
 ;;4832
 ;;21,"00008-0833-21 ")
 ;;4833
 ;;21,"00008-0833-22 ")
 ;;4834
 ;;21,"00008-0836-02 ")
 ;;4547
 ;;21,"00008-0836-03 ")
 ;;4548
 ;;21,"00008-0836-20 ")
 ;;4549
 ;;21,"00008-0836-21 ")
 ;;4550
 ;;21,"00008-0836-22 ")
 ;;4551
 ;;21,"00008-0837-01 ")
 ;;4664
 ;;21,"00008-0837-02 ")
 ;;4665
 ;;21,"00008-0837-03 ")
 ;;4666
 ;;21,"00008-0837-20 ")
 ;;4667
 ;;21,"00008-0837-21 ")
 ;;4668
 ;;21,"00008-0837-22 ")
 ;;4669
 ;;21,"00008-1211-01 ")
 ;;1506
 ;;21,"00008-1211-14 ")
 ;;1507
 ;;21,"00008-1211-30 ")
 ;;1508
 ;;21,"00008-1211-50 ")
 ;;1509
 ;;21,"00008-1222-01 ")
 ;;1502
 ;;21,"00008-1222-14 ")
 ;;1503
 ;;21,"00008-1222-30 ")
 ;;1504
 ;;21,"00008-1222-50 ")
 ;;1505
 ;;21,"00024-5810-30 ")
 ;;956
 ;;21,"00024-5811-30 ")
 ;;957
 ;;21,"00024-5812-30 ")
 ;;958
 ;;21,"00029-3206-13 ")
 ;;3303
 ;;21,"00029-3207-13 ")
 ;;3489
 ;;21,"00029-3208-13 ")
 ;;3582
 ;;21,"00029-3210-13 ")
 ;;3209
 ;;21,"00029-3211-13 ")
 ;;3329
 ;;21,"00029-3211-21 ")
 ;;3330
 ;;21,"00029-3211-59 ")
 ;;3331
 ;;21,"00029-3212-13 ")
 ;;3514
 ;;21,"00029-3213-13 ")
 ;;3594
 ;;21,"00029-3215-48 ")
 ;;3300
 ;;21,"00029-4606-13 ")
 ;;3304
 ;;21,"00029-4607-13 ")
 ;;3490
 ;;21,"00049-4900-30 ")
 ;;3978
 ;;21,"00049-4900-41 ")
 ;;3979
 ;;21,"00049-4900-94 ")
 ;;3980
 ;;21,"00049-4910-30 ")
 ;;3704
 ;;21,"00049-4910-41 ")
 ;;3705
 ;;21,"00049-4910-94 ")
 ;;3706
 ;;21,"00049-4940-23 ")
 ;;3885
 ;;21,"00049-4960-30 ")
 ;;3889
 ;;21,"00052-0105-30 ")
 ;;2641
 ;;21,"00052-0105-90 ")
 ;;2642
 ;;21,"00052-0106-06 ")
 ;;2722
 ;;21,"00052-0106-30 ")
 ;;2723
 ;;21,"00052-0106-90 ")
 ;;2724
 ;;21,"00052-0106-93 ")
 ;;2725
 ;;21,"00052-0107-30 ")
 ;;2736
 ;;21,"00052-0107-90 ")
 ;;2737
 ;;21,"00052-0108-06 ")
 ;;2817
 ;;21,"00052-0108-30 ")
 ;;2818
 ;;21,"00052-0108-90 ")
 ;;2819
 ;;21,"00052-0108-93 ")
 ;;2820
 ;;21,"00052-0109-30 ")
 ;;2830
 ;;21,"00052-0110-06 ")
 ;;2878
 ;;21,"00052-0110-30 ")
 ;;2879
 ;;21,"00052-0110-90 ")
 ;;2880
 ;;21,"00054-0022-13 ")
 ;;3890
 ;;21,"00054-0023-13 ")
 ;;3981
 ;;21,"00054-0023-28 ")
 ;;3982
 ;;21,"00054-0024-13 ")
 ;;3707
 ;;21,"00054-0024-28 ")
 ;;3708
 ;;21,"00054-0062-58 ")
 ;;1055
 ;;21,"00054-0210-25 ")
 ;;3693
 ;;21,"00054-0211-25 ")
 ;;3687
 ;;21,"00054-0273-13 ")
 ;;2620
 ;;21,"00054-0274-13 ")
 ;;2605
 ;;21,"00054-0275-13 ")
 ;;2610
 ;;21,"00054-0276-13 ")
 ;;2615
 ;;21,"00068-0007-01 ")
 ;;1378
 ;;21,"00068-0011-01 ")
 ;;1414
 ;;21,"00068-0015-01 ")
 ;;1474
 ;;21,"00068-0019-01 ")
 ;;1498
 ;;21,"00068-0020-01 ")
 ;;1403
 ;;21,"00068-0021-50 ")
 ;;1410
 ;;21,"00071-0350-60 ")
 ;;3684
 ;;21,"00093-0056-01 ")
 ;;2478
 ;;21,"00093-0057-01 ")
 ;;2448
 ;;21,"00093-0072-01 ")
 ;;2468
 ;;21,"00093-0199-01 ")
 ;;4638
 ;;21,"00093-0280-01 ")
 ;;898
 ;;21,"00093-0280-05 ")
 ;;899
 ;;21,"00093-0280-19 ")
 ;;900
 ;;21,"00093-0280-93 ")
 ;;901
 ;;21,"00093-0290-01 ")
 ;;522
 ;;21,"00093-0290-05 ")
 ;;523
 ;;21,"00093-0290-19 ")
 ;;524
 ;;21,"00093-0290-93 ")
 ;;525
 ;;21,"00093-0637-01 ")
 ;;4365
 ;;21,"00093-0637-10 ")
 ;;4366
 ;;21,"00093-0638-01 ")
 ;;4143
 ;;21,"00093-0638-10 ")
 ;;4144
 ;;21,"00093-0810-01 ")
 ;;2960
 ;;21,"00093-0810-05 ")
 ;;2961
 ;;21,"00093-0811-01 ")
 ;;3044
 ;;21,"00093-0811-05 ")
 ;;3045
 ;;21,"00093-0812-01 ")
 ;;3139
 ;;21,"00093-0812-05 ")
 ;;3140
 ;;21,"00093-0813-01 ")
 ;;3181
 ;;21,"00093-0813-05 ")
 ;;3182
 ;;21,"00093-0956-01 ")
 ;;1347
 ;;21,"00093-0958-01 ")
 ;;1358
 ;;21,"00093-0960-01 ")
 ;;1369
 ;;21,"00093-1024-06 ")
 ;;2896
 ;;21,"00093-1025-06 ")
 ;;2929
 ;;21,"00093-1026-06 ")
 ;;2945
 ;;21,"00093-1042-01 ")
 ;;1943
 ;;21,"00093-1042-10 ")
 ;;1944
 ;;21,"00093-1042-19 ")
 ;;1945
 ;;21,"00093-1042-93 ")
 ;;1946
 ;;21,"00093-1043-01 ")
 ;;2096
 ;;21,"00093-4356-01 ")
 ;;2097
 ;;21,"00093-4356-05 ")
 ;;2098
 ;;21,"00093-4356-10 ")
 ;;2099
 ;;21,"00093-4356-19 ")
 ;;2100
 ;;21,"00093-4356-93 ")
 ;;2101
 ;;21,"00093-4740-01 ")
 ;;959
 ;;21,"00093-4740-10 ")
 ;;960
 ;;21,"00093-4740-19 ")
 ;;961
 ;;21,"00093-4740-93 ")
 ;;962
 ;;21,"00093-4741-01 ")
 ;;1061
 ;;21,"00093-4741-05 ")
 ;;1062
 ;;21,"00093-4741-19 ")
 ;;1063
 ;;21,"00093-4741-50 ")
 ;;1064
 ;;21,"00093-4741-93 ")
 ;;1065
 ;;21,"00093-4742-01 ")
 ;;1216
 ;;21,"00093-4742-05 ")
 ;;1217
 ;;21,"00093-4742-19 ")
 ;;1218
 ;;21,"00093-4742-50 ")
 ;;1219
 ;;21,"00093-4742-93 ")
 ;;1220
 ;;21,"00093-5350-05 ")
 ;;775
 ;;21,"00093-5350-56 ")
 ;;776
 ;;21,"00093-5351-05 ")
 ;;839
 ;;21,"00093-5351-56 ")
 ;;840
 ;;21,"00093-5501-01 ")
 ;;621
 ;;21,"00093-5502-01 ")
 ;;676
 ;;21,"00093-5503-56 ")
 ;;2434
 ;;21,"00093-5504-56 ")
 ;;2438
 ;;21,"00093-5505-56 ")
 ;;2446
 ;;21,"00093-5506-56 ")
 ;;2432
 ;;21,"00093-5507-56 ")
 ;;2442
 ;;21,"00093-5703-01 ")
 ;;677
 ;;21,"00093-5850-01 ")
 ;;1929
 ;;21,"00093-5850-05 ")
 ;;1930
 ;;21,"00093-5850-93 ")
 ;;1931
 ;;21,"00093-5851-01 ")
 ;;1837
 ;;21,"00093-5851-05 ")
 ;;1838
 ;;21,"00093-5851-93 ")
 ;;1839
 ;;21,"00093-5852-01 ")
 ;;1888
 ;;21,"00093-5852-05 ")
 ;;1889
 ;;21,"00093-5852-93 ")
 ;;1890
 ;;21,"00093-6108-12 ")
 ;;2347
 ;;21,"00093-7113-06 ")
 ;;2915
 ;;21,"00093-7114-98 ")
 ;;3210
 ;;21,"00093-7115-98 ")
 ;;3332
 ;;21,"00093-7116-98 ")
 ;;3515
 ;;21,"00093-7121-98 ")
 ;;3595
 ;;21,"00093-7175-10 ")
 ;;3891
 ;;21,"00093-7175-56 ")
 ;;3892
 ;;21,"00093-7176-10 ")
 ;;3983
 ;;21,"00093-7176-56 ")
 ;;3984
 ;;21,"00093-7177-10 ")
 ;;3709
 ;;21,"00093-7177-56 ")
 ;;3710
 ;;21,"00093-7178-01 ")
 ;;2954
 ;;21,"00093-7188-56 ")
 ;;2071
 ;;21,"00093-7198-01 ")
 ;;2356
 ;;21,"00093-7198-05 ")
 ;;2357
 ;;21,"00093-7198-19 ")
 ;;2358
 ;;21,"00093-7198-56 ")
 ;;2359
 ;;21,"00093-7198-93 ")
 ;;2360
 ;;21,"00093-7206-19 ")
 ;;2643
 ;;21,"00093-7206-56 ")
 ;;2644
 ;;21,"00093-7206-93 ")
 ;;2645
 ;;21,"00093-7207-19 ")
 ;;2738
 ;;21,"00093-7207-56 ")
 ;;2739
 ;;21,"00093-7207-93 ")
 ;;2740
 ;;21,"00093-7208-19 ")
 ;;2831
 ;;21,"00093-7208-56 ")
 ;;2832
 ;;21,"00093-7208-93 ")
 ;;2833
 ;;21,"00093-7225-19 ")
 ;;1947
 ;;21,"00093-7225-28 ")
 ;;1948
 ;;21,"00093-7226-19 ")
 ;;2102
 ;;21,"00093-7226-28 ")
 ;;2103
 ;;21,"00093-7303-18 ")
 ;;2726
 ;;21,"00093-7303-65 ")
 ;;2727
 ;;21,"00093-7304-18 ")
 ;;2821
 ;;21,"00093-7304-65 ")
 ;;2822
 ;;21,"00093-7305-02 ")
 ;;2881
 ;;21,"00093-7305-65 ")
 ;;2882
 ;;21,"00093-7380-01 ")
 ;;4731
 ;;21,"00093-7381-01 ")
 ;;4800
 ;;21,"00093-7382-01 ")
 ;;4917
 ;;21,"00093-7383-01 ")
 ;;4529
 ;;21,"00093-7384-05 ")
 ;;4670
 ;;21,"00093-7384-56 ")
 ;;4671
 ;;21,"00093-7384-98 ")
 ;;4672
 ;;21,"00093-7385-05 ")
 ;;4835
 ;;21,"00093-7385-56 ")
 ;;4836
 ;;21,"00093-7385-98 ")
 ;;4837
 ;;21,"00093-7386-05 ")
 ;;4552
 ;;21,"00093-7386-56 ")
 ;;4553
 ;;21,"00093-7386-98 ")
 ;;4554
 ;;21,"00093-9612-12 ")
 ;;1552
 ;;21,"00115-5445-13 ")
 ;;827
 ;;21,"00115-6811-02 ")
 ;;777
 ;;21,"00115-6811-08 ")
 ;;778
 ;;21,"00115-6811-10 ")
 ;;779
 ;;21,"00121-0678-12 ")
 ;;3040
 ;;21,"00121-0678-16 ")
 ;;3041
 ;;21,"00121-0721-04 ")
 ;;2348
 ;;21,"00121-4721-05 ")
 ;;2349
 ;;21,"00131-3265-32 ")
 ;;4792
 ;;21,"00131-3265-46 ")
 ;;4793
 ;;21,"00131-3266-32 ")
 ;;5001
 ;;21,"00131-3266-46 ")
 ;;5002
 ;;21,"00131-3267-32 ")
 ;;4626
 ;;21,"00131-3267-46 ")
 ;;4627
 ;;21,"00131-3268-32 ")
 ;;4632
 ;;21,"00131-3268-46 ")
 ;;4633
 ;;21,"00143-9580-05 ")
 ;;3711
 ;;21,"00143-9580-09 ")
 ;;3712
 ;;21,"00143-9580-30 ")
 ;;3713
 ;;21,"00143-9581-05 ")
 ;;3985
 ;;21,"00143-9581-09 ")
 ;;3986
 ;;21,"00143-9581-30 ")
 ;;3987
 ;;21,"00143-9582-09 ")
 ;;3893
 ;;21,"00143-9582-30 ")
 ;;3894
 ;;21,"00172-4332-49 ")
 ;;2897
 ;;21,"00172-4333-49 ")
 ;;2916
 ;;21,"00172-4334-10 ")
 ;;2930
 ;;21,"00172-4334-49 ")
 ;;2931
 ;;21,"00172-4335-10 ")
 ;;2946
 ;;21,"00172-4335-49 ")
 ;;2947
 ;;21,"00172-4343-10 ")
 ;;2955
 ;;21,"00172-4343-49 ")
 ;;2956
 ;;21,"00172-4346-00 ")
 ;;2361
 ;;21,"00172-4346-10 ")
 ;;2362
 ;;21,"00172-4346-46 ")
 ;;2363
 ;;21,"00172-4346-60 ")
 ;;2364
 ;;21,"00172-4346-70 ")
 ;;2365
 ;;21,"00172-4356-00 ")
 ;;2104
 ;;21,"00172-4356-10 ")
 ;;2105
 ;;21,"00172-4356-60 ")
 ;;2106
 ;;21,"00172-4356-70 ")
 ;;2107
 ;;21,"00172-4356-80 ")
 ;;2108
 ;;21,"00172-4363-00 ")
 ;;1949
 ;;21,"00172-4363-10 ")
 ;;1950
 ;;21,"00172-4363-60 ")
 ;;1951
 ;;21,"00172-4363-80 ")
 ;;1952
 ;;21,"00172-4392-60 ")
 ;;2449
 ;;21,"00172-5672-00 ")
 ;;3895
 ;;21,"00172-5672-10 ")
 ;;3896
 ;;21,"00172-5672-80 ")
 ;;3897
 ;;21,"00172-5673-00 ")
 ;;3988
 ;;21,"00172-5673-10 ")
 ;;3989
 ;;21,"00172-5674-00 ")
 ;;3714
 ;;21,"00172-5674-10 ")
 ;;3715
 ;;21,"00173-0135-55 ")
 ;;678
 ;;21,"00173-0177-55 ")
 ;;902
 ;;21,"00173-0178-55 ")
 ;;526
 ;;21,"00173-0722-00 ")
 ;;828
 ;;21,"00173-0730-01 ")
 ;;780
 ;;21,"00173-0730-02 ")
 ;;781
 ;;21,"00173-0731-01 ")
 ;;841
 ;;21,"00173-0947-55 ")
 ;;622
 ;;21,"00182-1259-00 ")
 ;;4367
 ;;21,"00182-1259-89 ")
 ;;4368
 ;;21,"00182-1260-00 ")
 ;;4145
 ;;21,"00182-1260-89 ")
 ;;4146
 ;;21,"00185-0017-01 ")
 ;;2469
 ;;21,"00185-0020-10 ")
 ;;2646
 ;;21,"00185-0020-30 ")
 ;;2647
 ;;21,"00185-0027-01 ")
 ;;2479
 ;;21,"00185-0027-05 ")
 ;;2480
 ;;21,"00185-0057-30 ")
 ;;3898
 ;;21,"00185-0085-10 ")
 ;;2109
 ;;21,"00185-0153-30 ")
 ;;3990
 ;;21,"00185-0157-01 ")
 ;;2450
 ;;21,"00185-0157-05 ")
 ;;2451
 ;;21,"00185-0212-10 ")
 ;;2741
 ;;21,"00185-0212-30 ")
 ;;2742
 ;;21,"00185-0222-10 ")
 ;;2834
 ;;21,"00185-0222-30 ")
 ;;2835
 ;;21,"00185-0265-30 ")
 ;;3716
 ;;21,"00185-0371-01 ")
 ;;963
 ;;21,"00185-0371-10 ")
 ;;964
 ;;21,"00185-0372-01 ")
 ;;1066
 ;;21,"00185-0373-01 ")
 ;;1221
 ;;21,"00185-0373-05 ")
 ;;1222
 ;;21,"00185-0373-10 ")
 ;;1223
 ;;21,"00185-0410-01 ")
 ;;623
 ;;21,"00185-0410-05 ")
 ;;624
 ;;21,"00185-0410-60 ")
 ;;625
 ;;21,"00185-0415-01 ")
 ;;679
 ;;21,"00185-0415-05 ")
 ;;680
 ;;21,"00185-0415-52 ")
 ;;681
 ;;21,"00185-0415-60 ")
 ;;682
 ;;21,"00185-1111-60 ")
 ;;829
 ;;21,"00187-3805-10 ")
 ;;495
 ;;21,"00187-3806-10 ")
 ;;502
 ;;21,"00228-2721-03 ")
 ;;3899
 ;;21,"00228-2721-09 ")
 ;;3900
 ;;21,"00228-2721-50 ")
 ;;3901
 ;;21,"00228-2722-03 ")
 ;;3991
 ;;21,"00228-2722-09 ")
 ;;3992
 ;;21,"00228-2722-90 ")
 ;;3993
 ;;21,"00228-2723-03 ")
 ;;3717
 ;;21,"00228-2723-09 ")
 ;;3718
 ;;21,"00228-2723-96 ")
 ;;3719
 ;;21,"00247-0038-07 ")
 ;;1415
 ;;21,"00247-0038-14 ")
 ;;1416
 ;;21,"00247-0038-15 ")
 ;;1417
 ;;21,"00247-0038-20 ")
 ;;1418
 ;;21,"00247-0038-25 ")
 ;;1419
 ;;21,"00247-0038-30 ")
 ;;1420
 ;;21,"00247-0038-40 ")
 ;;1421
 ;;21,"00247-0038-60 ")
 ;;1422
 ;;21,"00247-0038-90 ")
 ;;1423
 ;;21,"00247-0370-30 ")
 ;;3183
 ;;21,"00247-0371-03 ")
 ;;3720
 ;;21,"00247-0371-06 ")
 ;;3721
 ;;21,"00247-0371-07 ")
 ;;3722
 ;;21,"00247-0371-10 ")
 ;;3723
 ;;21,"00247-0371-14 ")
 ;;3724
 ;;21,"00247-0371-28 ")
 ;;3725
 ;;21,"00247-0371-30 ")
 ;;3726
 ;;21,"00247-0371-45 ")
 ;;3727
 ;;21,"00247-0371-50 ")
 ;;3728
 ;;21,"00247-0371-60 ")
 ;;3729
 ;;21,"00247-0372-00 ")
 ;;2110
 ;;21,"00247-0372-03 ")
 ;;2111
 ;;21,"00247-0372-04 ")
 ;;2112
 ;;21,"00247-0372-07 ")
 ;;2113
 ;
OTHER ; OTHER ROUTINES
 D ^BGP33I10
 D ^BGP33I11
 D ^BGP33I12
 D ^BGP33I13
 D ^BGP33I14
 D ^BGP33I15
 D ^BGP33I16
 D ^BGP33I17
 D ^BGP33I18
 D ^BGP33I19
 D ^BGP33I2
 D ^BGP33I20
 D ^BGP33I21
 D ^BGP33I22
 D ^BGP33I23
 D ^BGP33I24
 D ^BGP33I25
 D ^BGP33I26
 D ^BGP33I27
 D ^BGP33I28
 D ^BGP33I29
 D ^BGP33I3
 D ^BGP33I30
 D ^BGP33I31
 D ^BGP33I32
 D ^BGP33I33
 D ^BGP33I34
 D ^BGP33I35
 D ^BGP33I36
 D ^BGP33I37
 D ^BGP33I38
 D ^BGP33I39
 D ^BGP33I4
 D ^BGP33I40
 D ^BGP33I41
 D ^BGP33I42
 D ^BGP33I43
 D ^BGP33I44
 D ^BGP33I45
 D ^BGP33I46
 D ^BGP33I47
 D ^BGP33I48
 D ^BGP33I49
 D ^BGP33I5
 D ^BGP33I50
 D ^BGP33I51
 D ^BGP33I52
 D ^BGP33I53
 D ^BGP33I54
 D ^BGP33I55
 D ^BGP33I56
 D ^BGP33I57
 D ^BGP33I58
 D ^BGP33I59
 D ^BGP33I6
 D ^BGP33I7
 D ^BGP33I8
 D ^BGP33I9
 Q