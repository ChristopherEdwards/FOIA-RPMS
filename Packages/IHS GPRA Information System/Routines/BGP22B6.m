BGP22B6 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 21, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"54569-4593-00 ")
 ;;988
 ;;21,"54569-4593-01 ")
 ;;989
 ;;21,"54569-4596-00 ")
 ;;2514
 ;;21,"54569-4696-00 ")
 ;;80
 ;;21,"54569-4696-01 ")
 ;;61
 ;;21,"54569-4714-00 ")
 ;;3670
 ;;21,"54569-4719-00 ")
 ;;3688
 ;;21,"54569-4719-01 ")
 ;;3687
 ;;21,"54569-4721-00 ")
 ;;2145
 ;;21,"54569-4722-00 ")
 ;;3473
 ;;21,"54569-4722-01 ")
 ;;3506
 ;;21,"54569-4766-00 ")
 ;;3656
 ;;21,"54569-4766-01 ")
 ;;3640
 ;;21,"54569-4767-00 ")
 ;;3590
 ;;21,"54569-4767-01 ")
 ;;3572
 ;;21,"54569-4788-00 ")
 ;;805
 ;;21,"54569-4788-01 ")
 ;;801
 ;;21,"54569-4829-00 ")
 ;;388
 ;;21,"54569-4895-00 ")
 ;;3737
 ;;21,"54569-4948-00 ")
 ;;1880
 ;;21,"54569-4990-00 ")
 ;;2895
 ;;21,"54569-5132-00 ")
 ;;1430
 ;;21,"54569-5133-00 ")
 ;;1669
 ;;21,"54569-5133-01 ")
 ;;1670
 ;;21,"54569-5134-00 ")
 ;;1311
 ;;21,"54569-5134-01 ")
 ;;1312
 ;;21,"54569-5134-02 ")
 ;;1313
 ;;21,"54569-5135-00 ")
 ;;1531
 ;;21,"54569-5135-01 ")
 ;;1532
 ;;21,"54569-5232-00 ")
 ;;116
 ;;21,"54569-5232-01 ")
 ;;96
 ;;21,"54569-5282-00 ")
 ;;43
 ;;21,"54569-5283-00 ")
 ;;237
 ;;21,"54569-5284-00 ")
 ;;170
 ;;21,"54569-5284-01 ")
 ;;171
 ;;21,"54569-5285-00 ")
 ;;193
 ;;21,"54569-5286-00 ")
 ;;216
 ;;21,"54569-5361-00 ")
 ;;4098
 ;;21,"54569-5362-00 ")
 ;;4042
 ;;21,"54569-5379-00 ")
 ;;2146
 ;;21,"54569-5420-00 ")
 ;;3228
 ;;21,"54569-5421-00 ")
 ;;3246
 ;;21,"54569-5422-00 ")
 ;;3264
 ;;21,"54569-5434-00 ")
 ;;2043
 ;;21,"54569-5434-03 ")
 ;;2044
 ;;21,"54569-5434-04 ")
 ;;2045
 ;;21,"54569-5434-05 ")
 ;;2046
 ;;21,"54569-5435-00 ")
 ;;2361
 ;;21,"54569-5435-03 ")
 ;;2362
 ;;21,"54569-5435-04 ")
 ;;2363
 ;;21,"54569-5435-05 ")
 ;;2364
 ;;21,"54569-5437-00 ")
 ;;2188
 ;;21,"54569-5437-02 ")
 ;;2189
 ;;21,"54569-5438-00 ")
 ;;2790
 ;;21,"54569-5438-03 ")
 ;;2791
 ;;21,"54569-5472-00 ")
 ;;2621
 ;;21,"54569-5472-02 ")
 ;;2622
 ;;21,"54569-5601-00 ")
 ;;3559
 ;;21,"54569-5606-00 ")
 ;;3963
 ;;21,"54569-5621-00 ")
 ;;1761
 ;;21,"54569-5665-00 ")
 ;;3564
 ;;21,"54569-5666-00 ")
 ;;4064
 ;;21,"54569-5667-00 ")
 ;;3620
 ;;21,"54569-5667-01 ")
 ;;3603
 ;;21,"54569-5668-00 ")
 ;;682
 ;;21,"54569-5668-01 ")
 ;;683
 ;;21,"54569-5668-02 ")
 ;;684
 ;;21,"54569-5669-00 ")
 ;;763
 ;;21,"54569-5669-01 ")
 ;;764
 ;;21,"54569-5670-00 ")
 ;;837
 ;;21,"54569-5670-01 ")
 ;;838
 ;;21,"54569-5685-00 ")
 ;;231
 ;;21,"54569-5685-01 ")
 ;;232
 ;;21,"54569-5709-00 ")
 ;;2939
 ;;21,"54569-5710-00 ")
 ;;2969
 ;;21,"54569-5711-00 ")
 ;;2998
 ;;21,"54569-5728-00 ")
 ;;2485
 ;;21,"54569-5801-00 ")
 ;;3341
 ;;21,"54569-5867-00 ")
 ;;3761
 ;;21,"54569-5878-00 ")
 ;;20
 ;;21,"54569-5880-01 ")
 ;;3450
 ;;21,"54569-5903-00 ")
 ;;3547
 ;;21,"54569-5916-00 ")
 ;;2889
 ;;21,"54569-5936-00 ")
 ;;3084
 ;;21,"54569-5937-00 ")
 ;;81
 ;;21,"54569-5938-00 ")
 ;;117
 ;;21,"54569-5998-00 ")
 ;;3538
 ;;21,"54569-5999-00 ")
 ;;3408
 ;;21,"54569-6091-00 ")
 ;;389
 ;;21,"54569-6091-01 ")
 ;;390
 ;;21,"54569-6092-00 ")
 ;;470
 ;;21,"54569-6092-01 ")
 ;;471
 ;;21,"54569-6098-00 ")
 ;;1881
 ;;21,"54569-6111-00 ")
 ;;3191
 ;;21,"54569-6111-01 ")
 ;;3192
 ;;21,"54569-6112-00 ")
 ;;3085
 ;;21,"54569-6112-01 ")
 ;;3086
 ;;21,"54569-6173-00 ")
 ;;3925
 ;;21,"54569-6173-01 ")
 ;;3926
 ;;21,"54569-6180-00 ")
 ;;3451
 ;;21,"54569-6180-01 ")
 ;;3452
 ;;21,"54569-6182-00 ")
 ;;3409
 ;;21,"54569-6182-01 ")
 ;;3410
 ;;21,"54569-6223-00 ")
 ;;3507
 ;;21,"54868-0009-00 ")
 ;;3356
 ;;21,"54868-0009-01 ")
 ;;3357
 ;;21,"54868-0541-00 ")
 ;;1533
 ;;21,"54868-0541-01 ")
 ;;1534
 ;;21,"54868-0541-03 ")
 ;;1535
 ;;21,"54868-0620-01 ")
 ;;1314
 ;;21,"54868-0620-02 ")
 ;;1315
 ;;21,"54868-0620-03 ")
 ;;1316
 ;;21,"54868-0620-05 ")
 ;;1317
 ;;21,"54868-0669-01 ")
 ;;1039
 ;;21,"54868-0669-02 ")
 ;;1040
 ;;21,"54868-0669-03 ")
 ;;1041
 ;;21,"54868-1001-01 ")
 ;;2365
 ;;21,"54868-1090-01 ")
 ;;1671
 ;;21,"54868-1090-05 ")
 ;;1672
 ;;21,"54868-1090-06 ")
 ;;1673
 ;;21,"54868-1296-01 ")
 ;;2047
 ;;21,"54868-1296-02 ")
 ;;2048
 ;;21,"54868-1415-01 ")
 ;;1150
 ;;21,"54868-1501-00 ")
 ;;2516
 ;;21,"54868-1501-01 ")
 ;;2517
 ;;21,"54868-1502-00 ")
 ;;2366
 ;;21,"54868-1775-01 ")
 ;;967
 ;;21,"54868-1775-04 ")
 ;;968
 ;;21,"54868-1802-00 ")
 ;;619
 ;;21,"54868-1960-00 ")
 ;;2792
 ;;21,"54868-1961-01 ")
 ;;2793
 ;;21,"54868-1961-02 ")
 ;;2794
 ;;21,"54868-1970-01 ")
 ;;2049
 ;;21,"54868-1970-02 ")
 ;;2050
 ;;21,"54868-1970-03 ")
 ;;2051
 ;;21,"54868-2280-00 ")
 ;;1431
 ;;21,"54868-2280-02 ")
 ;;1432
 ;;21,"54868-2335-00 ")
 ;;3803
 ;;21,"54868-2335-01 ")
 ;;3804
 ;;21,"54868-2350-00 ")
 ;;685
 ;;21,"54868-2350-01 ")
 ;;686
 ;;21,"54868-2350-02 ")
 ;;687
 ;;21,"54868-2350-03 ")
 ;;688
 ;;21,"54868-2350-04 ")
 ;;689
 ;;21,"54868-2351-00 ")
 ;;765
 ;;21,"54868-2351-01 ")
 ;;766
 ;;21,"54868-2351-02 ")
 ;;767
 ;;21,"54868-2351-03 ")
 ;;768
 ;;21,"54868-2352-00 ")
 ;;839
 ;;21,"54868-2352-01 ")
 ;;840
 ;;21,"54868-2368-00 ")
 ;;1742
 ;;21,"54868-2368-01 ")
 ;;1743
 ;;21,"54868-2368-02 ")
 ;;1744
 ;;21,"54868-2644-00 ")
 ;;3141
 ;;21,"54868-2644-01 ")
 ;;3142
 ;;21,"54868-2644-02 ")
 ;;3143
 ;;21,"54868-2645-00 ")
 ;;3193
 ;;21,"54868-2645-01 ")
 ;;3194
 ;;21,"54868-2645-02 ")
 ;;3195
 ;;21,"54868-2645-03 ")
 ;;3196
 ;;21,"54868-2665-00 ")
 ;;2940
 ;;21,"54868-2665-01 ")
 ;;2941
 ;;21,"54868-2666-01 ")
 ;;2970
 ;;21,"54868-2666-02 ")
 ;;2971
 ;;21,"54868-2666-03 ")
 ;;2972
 ;;21,"54868-2666-04 ")
 ;;2973
 ;;21,"54868-2847-00 ")
 ;;627
 ;;21,"54868-3279-00 ")
 ;;1794
 ;;21,"54868-3279-02 ")
 ;;1795
 ;;21,"54868-3279-03 ")
 ;;1796
 ;;21,"54868-3307-00 ")
 ;;3027
 ;;21,"54868-3307-01 ")
 ;;3028
 ;;21,"54868-3443-00 ")
 ;;601
 ;;21,"54868-3443-01 ")
 ;;602
 ;;21,"54868-3445-00 ")
 ;;2999
 ;;21,"54868-3445-01 ")
 ;;3000
 ;;21,"54868-3690-01 ")
 ;;883
 ;;21,"54868-3723-01 ")
 ;;990
 ;;21,"54868-3723-02 ")
 ;;991
 ;;21,"54868-3723-03 ")
 ;;992
 ;;21,"54868-3723-04 ")
 ;;993
 ;;21,"54868-3724-01 ")
 ;;1088
 ;;21,"54868-3724-02 ")
 ;;1089
 ;;21,"54868-3724-03 ")
 ;;1090
 ;;21,"54868-3724-04 ")
 ;;1091
 ;;21,"54868-3725-01 ")
 ;;1193
 ;;21,"54868-3725-02 ")
 ;;1194
 ;;21,"54868-3725-03 ")
 ;;1195
 ;;21,"54868-3725-04 ")
 ;;1196
 ;;21,"54868-3726-00 ")
 ;;3927
 ;;21,"54868-3726-01 ")
 ;;3928
 ;;21,"54868-3726-02 ")
 ;;3929
 ;;21,"54868-3769-00 ")
 ;;250
 ;;21,"54868-3846-00 ")
 ;;3087
 ;;21,"54868-3846-01 ")
 ;;3088
 ;;21,"54868-3846-02 ")
 ;;3089
 ;;21,"54868-3846-03 ")
 ;;3090
 ;;21,"54868-3866-00 ")
 ;;3508
 ;;21,"54868-3866-01 ")
 ;;3509
 ;;21,"54868-3891-00 ")
 ;;270
 ;;21,"54868-3906-00 ")
 ;;205
 ;;21,"54868-3906-01 ")
 ;;206
 ;;21,"54868-4003-00 ")
 ;;472
 ;;21,"54868-4062-00 ")
 ;;275
 ;;21,"54868-4062-01 ")
 ;;276
 ;;21,"54868-4066-00 ")
 ;;55
 ;;21,"54868-4066-01 ")
 ;;56
 ;;21,"54868-4073-00 ")
 ;;82
 ;;21,"54868-4073-01 ")
 ;;83
 ;;21,"54868-4073-02 ")
 ;;84
 ;;21,"54868-4073-03 ")
 ;;85
 ;;21,"54868-4074-00 ")
 ;;118
 ;;21,"54868-4074-01 ")
 ;;119
 ;;21,"54868-4074-02 ")
 ;;120
 ;;21,"54868-4074-03 ")
 ;;121
 ;;21,"54868-4074-04 ")
 ;;122
 ;;21,"54868-4088-00 ")
 ;;2890
 ;;21,"54868-4088-01 ")
 ;;2891
 ;;21,"54868-4088-02 ")
 ;;2892
 ;;21,"54868-4178-00 ")
 ;;4021
 ;;21,"54868-4199-00 ")
 ;;3723
 ;;21,"54868-4199-01 ")
 ;;3724
 ;;21,"54868-4199-02 ")
 ;;3725
 ;;21,"54868-4209-00 ")
 ;;1865
 ;;21,"54868-4331-00 ")
 ;;1536
 ;;21,"54868-4331-01 ")
 ;;1537
 ;;21,"54868-4331-02 ")
 ;;1538
 ;;21,"54868-4332-00 ")
 ;;1433
 ;;21,"54868-4332-01 ")
 ;;1434
 ;;21,"54868-4332-02 ")
 ;;1435
 ;;21,"54868-4341-00 ")
 ;;3453
 ;;21,"54868-4341-01 ")
 ;;3454
 ;;21,"54868-4357-00 ")
 ;;1674
 ;;21,"54868-4357-01 ")
 ;;1675
 ;;21,"54868-4357-02 ")
 ;;1676
 ;;21,"54868-4357-03 ")
 ;;1677
 ;;21,"54868-4358-00 ")
 ;;1318
 ;;21,"54868-4358-01 ")
 ;;1319
 ;;21,"54868-4358-02 ")
 ;;1320
 ;;21,"54868-4358-03 ")
 ;;1321
 ;;21,"54868-4406-00 ")
 ;;4020
 ;;21,"54868-4413-00 ")
 ;;3671
 ;;21,"54868-4414-00 ")
 ;;3750
 ;;21,"54868-4414-01 ")
 ;;3751
 ;;21,"54868-4425-00 ")
 ;;3657
 ;;21,"54868-4425-01 ")
 ;;3658
 ;;21,"54868-4425-02 ")
 ;;3659
 ;;21,"54868-4425-03 ")
 ;;3660
 ;;21,"54868-4428-00 ")
 ;;3591
 ;;21,"54868-4428-01 ")
 ;;3577
 ;;21,"54868-4428-02 ")
 ;;3592
 ;;21,"54868-4428-03 ")
 ;;3593
 ;;21,"54868-4479-00 ")
 ;;603
 ;;21,"54868-4479-01 ")
 ;;604
 ;;21,"54868-4479-02 ")
 ;;605
 ;;21,"54868-4494-00 ")
 ;;3366
 ;;21,"54868-4526-00 ")
 ;;3378
 ;;21,"54868-4526-01 ")
 ;;3379
 ;;21,"54868-4539-00 ")
 ;;4002
 ;;21,"54868-4539-01 ")
 ;;4007
 ;;21,"54868-4540-00 ")
 ;;3558
 ;;21,"54868-4540-01 ")
 ;;3565
 ;;21,"54868-4540-02 ")
 ;;3566
 ;;21,"54868-4552-00 ")
 ;;2915
 ;;21,"54868-4552-01 ")
 ;;2916
 ;;21,"54868-4555-00 ")
 ;;2921
 ;;21,"54868-4555-01 ")
 ;;2922
 ;;21,"54868-4605-00 ")
 ;;4013
 ;;21,"54868-4605-01 ")
 ;;4018
 ;;21,"54868-4605-02 ")
 ;;4019
 ;;21,"54868-4612-00 ")
 ;;3683
 ;;21,"54868-4637-00 ")
 ;;473
 ;;21,"54868-4637-01 ")
 ;;474
 ;;21,"54868-4637-02 ")
 ;;475
 ;;21,"54868-4637-03 ")
 ;;476
 ;;21,"54868-4637-04 ")
 ;;477
 ;;21,"54868-4645-00 ")
 ;;4043
 ;;21,"54868-4645-01 ")
 ;;4044
 ;;21,"54868-4645-02 ")
 ;;4045
 ;;21,"54868-4645-03 ")
 ;;4046
 ;;21,"54868-4646-00 ")
 ;;2623
 ;;21,"54868-4646-02 ")
 ;;2624
 ;;21,"54868-4646-03 ")
 ;;2625
 ;;21,"54868-4646-04 ")
 ;;2626
 ;;21,"54868-4646-05 ")
 ;;2627
 ;;21,"54868-4652-00 ")
 ;;4099
 ;;21,"54868-4652-01 ")
 ;;4100
 ;;21,"54868-4652-02 ")
 ;;4101
 ;;21,"54868-4652-03 ")
 ;;4102
 ;;21,"54868-4652-04 ")
 ;;4103
 ;;21,"54868-4652-05 ")
 ;;4104
 ;;21,"54868-4656-00 ")
 ;;2190
 ;;21,"54868-4656-01 ")
 ;;2191
 ;;21,"54868-4656-02 ")
 ;;2192
 ;;21,"54868-4656-03 ")
 ;;2193
 ;;21,"54868-4657-00 ")
 ;;2052
 ;;21,"54868-4657-01 ")
 ;;2053
 ;;21,"54868-4657-02 ")
 ;;2054
 ;;21,"54868-4657-03 ")
 ;;2055
 ;;21,"54868-4657-04 ")
 ;;2056
 ;;21,"54868-4657-05 ")
 ;;1957
 ;;21,"54868-4657-06 ")
 ;;2057
 ;;21,"54868-4658-00 ")
 ;;2367
 ;;21,"54868-4658-01 ")
 ;;2368
 ;;21,"54868-4658-02 ")
 ;;2369
 ;;21,"54868-4658-03 ")
 ;;2370
 ;;21,"54868-4658-04 ")
 ;;2371
 ;;21,"54868-4678-00 ")
 ;;2795
 ;;21,"54868-4678-01 ")
 ;;2796
 ;;21,"54868-4678-02 ")
 ;;2797
 ;;21,"54868-4678-03 ")
 ;;2798
 ;;21,"54868-4720-00 ")
 ;;3696
 ;;21,"54868-4720-01 ")
 ;;3697
 ;;21,"54868-4720-02 ")
 ;;3698
 ;;21,"54868-4720-03 ")
 ;;3699
 ;;21,"54868-4729-00 ")
 ;;3336
 ;;21,"54868-4780-00 ")
 ;;2486
 ;;21,"54868-4780-01 ")
 ;;2487
 ;;21,"54868-4785-00 ")
 ;;561
 ;;21,"54868-4785-01 ")
 ;;562
 ;;21,"54868-4785-02 ")
 ;;563
 ;;21,"54868-4785-03 ")
 ;;564
 ;;21,"54868-4869-00 ")
 ;;3342
 ;;21,"54868-4870-00 ")
 ;;21
 ;;21,"54868-4870-01 ")
 ;;22
 ;;21,"54868-4870-02 ")
 ;;23
 ;;21,"54868-4883-00 ")
 ;;2879
 ;;21,"54868-4883-01 ")
 ;;2880
 ;;21,"54868-4883-02 ")
 ;;2881
 ;;21,"54868-4885-00 ")
 ;;3984
 ;;21,"54868-4885-01 ")
 ;;3985
 ;;21,"54868-4904-00 ")
 ;;207
 ;;21,"54868-4904-01 ")
 ;;208
 ;;21,"54868-4977-00 ")
 ;;391
 ;;21,"54868-4977-01 ")
 ;;392
 ;;21,"54868-4977-02 ")
 ;;393
 ;;21,"54868-4986-00 ")
 ;;3964
 ;;21,"54868-4986-01 ")
 ;;3965
 ;;21,"54868-4986-02 ")
 ;;3966
 ;;21,"54868-5001-00 ")
 ;;690
 ;;21,"54868-5001-01 ")
 ;;691
 ;;21,"54868-5055-00 ")
 ;;1818
 ;;21,"54868-5064-00 ")
 ;;1762
 ;;21,"54868-5064-01 ")
 ;;1763
 ;;21,"54868-5075-00 ")
 ;;3539
 ;;21,"54868-5075-01 ")
 ;;3540
 ;;21,"54868-5077-00 ")
 ;;3863
 ;;21,"54868-5078-00 ")
 ;;3548
 ;;21,"54868-5078-01 ")
 ;;3549
 ;;21,"54868-5079-00 ")
 ;;769
 ;;21,"54868-5079-01 ")
 ;;770
 ;;21,"54868-5079-02 ")
 ;;771
 ;;21,"54868-5082-00 ")
 ;;4065
 ;;21,"54868-5082-01 ")
 ;;4058
 ;;21,"54868-5082-02 ")
 ;;4066
 ;;21,"54868-5082-03 ")
 ;;4067
 ;;21,"54868-5099-00 ")
 ;;3276
 ;;21,"54868-5099-01 ")
 ;;3277
 ;;21,"54868-5100-00 ")
 ;;296
 ;;21,"54868-5100-01 ")
 ;;297
 ;;21,"54868-5100-02 ")
 ;;298
 ;;21,"54868-5170-00 ")
 ;;3530
 ;;21,"54868-5170-01 ")
 ;;3531
 ;;21,"54868-5182-00 ")
 ;;1882
 ;;21,"54868-5182-01 ")
 ;;1883
 ;;21,"54868-5182-02 ")
 ;;1884
 ;;21,"54868-5196-00 ")
 ;;923
 ;;21,"54868-5196-01 ")
 ;;924
 ;;21,"54868-5196-02 ")
 ;;925
 ;;21,"54868-5204-00 ")
 ;;841
 ;;21,"54868-5204-01 ")
 ;;842
 ;;21,"54868-5204-02 ")
 ;;843
 ;;21,"54868-5204-03 ")
 ;;844
 ;;21,"54868-5241-00 ")
 ;;2974
 ;;21,"54868-5241-01 ")
 ;;2975
 ;;21,"54868-5241-02 ")
 ;;2976
 ;;21,"54868-5245-00 ")
 ;;2942
 ;;21,"54868-5245-01 ")
 ;;2943
 ;;21,"54868-5245-02 ")
 ;;2944
 ;;21,"54868-5246-00 ")
 ;;3001
 ;;21,"54868-5246-01 ")
 ;;3002
 ;;21,"54868-5256-00 ")
 ;;190
 ;;21,"54868-5279-00 ")
 ;;3029
 ;;21,"54868-5281-00 ")
 ;;3351
 ;;21,"54868-5281-01 ")
 ;;3352
 ;;21,"54868-5296-00 ")
 ;;233
 ;;21,"54868-5297-00 ")
 ;;3571
 ;;21,"54868-5311-00 ")
 ;;158
 ;;21,"54868-5311-01 ")
 ;;159
