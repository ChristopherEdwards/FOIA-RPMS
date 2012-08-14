BGP13X6 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON APR 14, 2011 ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"54569-4438-01 ")
 ;;3706
 ;;21,"54569-4454-00 ")
 ;;2879
 ;;21,"54569-4572-00 ")
 ;;3552
 ;;21,"54569-4593-00 ")
 ;;911
 ;;21,"54569-4593-01 ")
 ;;912
 ;;21,"54569-4596-00 ")
 ;;2485
 ;;21,"54569-4696-00 ")
 ;;57
 ;;21,"54569-4696-01 ")
 ;;58
 ;;21,"54569-4714-00 ")
 ;;3502
 ;;21,"54569-4719-00 ")
 ;;3521
 ;;21,"54569-4719-01 ")
 ;;3522
 ;;21,"54569-4721-00 ")
 ;;2095
 ;;21,"54569-4722-00 ")
 ;;3326
 ;;21,"54569-4722-01 ")
 ;;3327
 ;;21,"54569-4766-00 ")
 ;;3485
 ;;21,"54569-4766-01 ")
 ;;3486
 ;;21,"54569-4767-00 ")
 ;;3422
 ;;21,"54569-4767-01 ")
 ;;3423
 ;;21,"54569-4788-00 ")
 ;;768
 ;;21,"54569-4788-01 ")
 ;;769
 ;;21,"54569-4829-00 ")
 ;;347
 ;;21,"54569-4895-00 ")
 ;;3579
 ;;21,"54569-4948-00 ")
 ;;1799
 ;;21,"54569-4990-00 ")
 ;;2786
 ;;21,"54569-5132-00 ")
 ;;1351
 ;;21,"54569-5133-00 ")
 ;;1580
 ;;21,"54569-5133-01 ")
 ;;1581
 ;;21,"54569-5134-00 ")
 ;;1227
 ;;21,"54569-5134-01 ")
 ;;1228
 ;;21,"54569-5134-02 ")
 ;;1229
 ;;21,"54569-5135-00 ")
 ;;1445
 ;;21,"54569-5135-01 ")
 ;;1446
 ;;21,"54569-5232-00 ")
 ;;89
 ;;21,"54569-5232-01 ")
 ;;90
 ;;21,"54569-5282-00 ")
 ;;42
 ;;21,"54569-5283-00 ")
 ;;217
 ;;21,"54569-5284-00 ")
 ;;157
 ;;21,"54569-5284-01 ")
 ;;158
 ;;21,"54569-5285-00 ")
 ;;176
 ;;21,"54569-5286-00 ")
 ;;202
 ;;21,"54569-5361-00 ")
 ;;3891
 ;;21,"54569-5362-00 ")
 ;;3838
 ;;21,"54569-5379-00 ")
 ;;2096
 ;;21,"54569-5420-00 ")
 ;;3103
 ;;21,"54569-5421-00 ")
 ;;3121
 ;;21,"54569-5422-00 ")
 ;;3140
 ;;21,"54569-5434-00 ")
 ;;1928
 ;;21,"54569-5434-03 ")
 ;;1929
 ;;21,"54569-5434-04 ")
 ;;1930
 ;;21,"54569-5435-00 ")
 ;;2234
 ;;21,"54569-5435-03 ")
 ;;2235
 ;;21,"54569-5435-04 ")
 ;;2236
 ;;21,"54569-5437-00 ")
 ;;2097
 ;;21,"54569-5438-00 ")
 ;;2654
 ;;21,"54569-5472-00 ")
 ;;2486
 ;;21,"54569-5601-00 ")
 ;;3398
 ;;21,"54569-5606-00 ")
 ;;3769
 ;;21,"54569-5621-00 ")
 ;;1674
 ;;21,"54569-5665-00 ")
 ;;3399
 ;;21,"54569-5666-00 ")
 ;;3860
 ;;21,"54569-5667-00 ")
 ;;3451
 ;;21,"54569-5667-01 ")
 ;;3452
 ;;21,"54569-5668-00 ")
 ;;624
 ;;21,"54569-5668-01 ")
 ;;625
 ;;21,"54569-5669-00 ")
 ;;699
 ;;21,"54569-5670-00 ")
 ;;770
 ;;21,"54569-5685-00 ")
 ;;203
 ;;21,"54569-5709-00 ")
 ;;2820
 ;;21,"54569-5710-00 ")
 ;;2850
 ;;21,"54569-5711-00 ")
 ;;2880
 ;;21,"54569-5728-00 ")
 ;;2384
 ;;21,"54569-5801-00 ")
 ;;3201
 ;;21,"54569-5867-00 ")
 ;;3590
 ;;21,"54569-5878-00 ")
 ;;8
 ;;21,"54569-5880-01 ")
 ;;3280
 ;;21,"54569-5903-00 ")
 ;;3382
 ;;21,"54569-5916-00 ")
 ;;2771
 ;;21,"54569-5936-00 ")
 ;;2958
 ;;21,"54569-5937-00 ")
 ;;59
 ;;21,"54569-5938-00 ")
 ;;91
 ;;21,"54569-5998-00 ")
 ;;3373
 ;;21,"54569-5999-00 ")
 ;;3246
 ;;21,"54569-6091-00 ")
 ;;348
 ;;21,"54569-6092-00 ")
 ;;421
 ;;21,"54569-6098-00 ")
 ;;1800
 ;;21,"54569-6111-00 ")
 ;;3053
 ;;21,"54569-6111-01 ")
 ;;3054
 ;;21,"54569-6112-00 ")
 ;;2959
 ;;21,"54569-6112-01 ")
 ;;2960
 ;;21,"54569-6173-00 ")
 ;;3741
 ;;21,"54569-6180-00 ")
 ;;3301
 ;;21,"54569-6182-00 ")
 ;;3262
 ;;21,"54868-0009-00 ")
 ;;3215
 ;;21,"54868-0009-01 ")
 ;;3216
 ;;21,"54868-0541-00 ")
 ;;1447
 ;;21,"54868-0541-01 ")
 ;;1448
 ;;21,"54868-0541-03 ")
 ;;1449
 ;;21,"54868-0620-01 ")
 ;;1230
 ;;21,"54868-0620-02 ")
 ;;1231
 ;;21,"54868-0620-03 ")
 ;;1232
 ;;21,"54868-0620-05 ")
 ;;1233
 ;;21,"54868-0669-01 ")
 ;;993
 ;;21,"54868-0669-02 ")
 ;;994
 ;;21,"54868-0669-03 ")
 ;;995
 ;;21,"54868-1001-01 ")
 ;;2237
 ;;21,"54868-1090-01 ")
 ;;1582
 ;;21,"54868-1090-05 ")
 ;;1583
 ;;21,"54868-1090-06 ")
 ;;1584
 ;;21,"54868-1296-01 ")
 ;;1931
 ;;21,"54868-1296-02 ")
 ;;1932
 ;;21,"54868-1415-01 ")
 ;;1105
 ;;21,"54868-1501-00 ")
 ;;2487
 ;;21,"54868-1501-01 ")
 ;;2488
 ;;21,"54868-1502-00 ")
 ;;2238
 ;;21,"54868-1775-01 ")
 ;;913
 ;;21,"54868-1775-04 ")
 ;;914
 ;;21,"54868-1802-00 ")
 ;;574
 ;;21,"54868-1960-00 ")
 ;;2655
 ;;21,"54868-1961-01 ")
 ;;2656
 ;;21,"54868-1961-02 ")
 ;;2657
 ;;21,"54868-1970-01 ")
 ;;1933
 ;;21,"54868-1970-02 ")
 ;;1934
 ;;21,"54868-1970-03 ")
 ;;1935
 ;;21,"54868-2280-00 ")
 ;;1352
 ;;21,"54868-2280-02 ")
 ;;1353
 ;;21,"54868-2335-00 ")
 ;;3601
 ;;21,"54868-2335-01 ")
 ;;3602
 ;;21,"54868-2350-01 ")
 ;;626
 ;;21,"54868-2350-02 ")
 ;;627
 ;;21,"54868-2350-03 ")
 ;;628
 ;;21,"54868-2350-04 ")
 ;;629
 ;;21,"54868-2351-00 ")
 ;;700
 ;;21,"54868-2351-02 ")
 ;;701
 ;;21,"54868-2351-03 ")
 ;;702
 ;;21,"54868-2352-00 ")
 ;;771
 ;;21,"54868-2352-01 ")
 ;;772
 ;;21,"54868-2368-00 ")
 ;;1675
 ;;21,"54868-2368-01 ")
 ;;1676
 ;;21,"54868-2368-02 ")
 ;;1677
 ;;21,"54868-2644-00 ")
 ;;3008
 ;;21,"54868-2644-01 ")
 ;;3009
 ;;21,"54868-2644-02 ")
 ;;3010
 ;;21,"54868-2645-00 ")
 ;;3055
 ;;21,"54868-2645-01 ")
 ;;3056
 ;;21,"54868-2645-02 ")
 ;;3057
 ;;21,"54868-2645-03 ")
 ;;3058
 ;;21,"54868-2665-00 ")
 ;;2821
 ;;21,"54868-2665-01 ")
 ;;2822
 ;;21,"54868-2666-01 ")
 ;;2851
 ;;21,"54868-2666-02 ")
 ;;2852
 ;;21,"54868-2666-03 ")
 ;;2853
 ;;21,"54868-2666-04 ")
 ;;2854
 ;;21,"54868-2847-00 ")
 ;;582
 ;;21,"54868-3279-00 ")
 ;;1726
 ;;21,"54868-3279-02 ")
 ;;1727
 ;;21,"54868-3279-03 ")
 ;;1728
 ;;21,"54868-3307-00 ")
 ;;2908
 ;;21,"54868-3307-01 ")
 ;;2909
 ;;21,"54868-3443-00 ")
 ;;555
 ;;21,"54868-3443-01 ")
 ;;556
 ;;21,"54868-3445-00 ")
 ;;2881
 ;;21,"54868-3445-01 ")
 ;;2882
 ;;21,"54868-3690-01 ")
 ;;825
 ;;21,"54868-3723-01 ")
 ;;915
 ;;21,"54868-3723-02 ")
 ;;916
 ;;21,"54868-3723-03 ")
 ;;917
 ;;21,"54868-3723-04 ")
 ;;918
 ;;21,"54868-3724-01 ")
 ;;996
 ;;21,"54868-3724-02 ")
 ;;997
 ;;21,"54868-3724-03 ")
 ;;998
 ;;21,"54868-3724-04 ")
 ;;999
 ;;21,"54868-3725-01 ")
 ;;1106
 ;;21,"54868-3725-02 ")
 ;;1107
 ;;21,"54868-3725-03 ")
 ;;1108
 ;;21,"54868-3725-04 ")
 ;;1109
 ;;21,"54868-3726-00 ")
 ;;3707
 ;;21,"54868-3726-01 ")
 ;;3708
 ;;21,"54868-3726-02 ")
 ;;3709
 ;;21,"54868-3769-00 ")
 ;;224
 ;;21,"54868-3846-00 ")
 ;;2961
 ;;21,"54868-3846-01 ")
 ;;2962
 ;;21,"54868-3846-02 ")
 ;;2963
 ;;21,"54868-3846-03 ")
 ;;2964
 ;;21,"54868-3866-00 ")
 ;;3328
 ;;21,"54868-3866-01 ")
 ;;3329
 ;;21,"54868-3891-00 ")
 ;;245
 ;;21,"54868-3906-00 ")
 ;;177
 ;;21,"54868-3906-01 ")
 ;;178
 ;;21,"54868-4003-00 ")
 ;;422
 ;;21,"54868-4062-00 ")
 ;;246
 ;;21,"54868-4062-01 ")
 ;;247
 ;;21,"54868-4066-00 ")
 ;;43
 ;;21,"54868-4066-01 ")
 ;;44
 ;;21,"54868-4073-00 ")
 ;;60
 ;;21,"54868-4073-01 ")
 ;;61
 ;;21,"54868-4073-02 ")
 ;;62
 ;;21,"54868-4073-03 ")
 ;;63
 ;;21,"54868-4074-00 ")
 ;;92
 ;;21,"54868-4074-01 ")
 ;;93
 ;;21,"54868-4074-02 ")
 ;;94
 ;;21,"54868-4074-03 ")
 ;;95
 ;;21,"54868-4074-04 ")
 ;;96
 ;;21,"54868-4088-00 ")
 ;;2772
 ;;21,"54868-4088-01 ")
 ;;2773
 ;;21,"54868-4088-02 ")
 ;;2774
 ;;21,"54868-4178-00 ")
 ;;3823
 ;;21,"54868-4199-00 ")
 ;;3553
 ;;21,"54868-4199-01 ")
 ;;3554
 ;;21,"54868-4199-02 ")
 ;;3555
 ;;21,"54868-4209-00 ")
 ;;1801
 ;;21,"54868-4331-00 ")
 ;;1450
 ;;21,"54868-4331-01 ")
 ;;1451
 ;;21,"54868-4331-02 ")
 ;;1452
 ;;21,"54868-4332-00 ")
 ;;1354
 ;;21,"54868-4332-01 ")
 ;;1355
 ;;21,"54868-4332-02 ")
 ;;1356
 ;;21,"54868-4341-00 ")
 ;;3281
 ;;21,"54868-4341-01 ")
 ;;3282
 ;;21,"54868-4357-00 ")
 ;;1585
 ;;21,"54868-4357-01 ")
 ;;1586
 ;;21,"54868-4357-02 ")
 ;;1587
 ;;21,"54868-4358-00 ")
 ;;1234
 ;;21,"54868-4358-01 ")
 ;;1235
 ;;21,"54868-4358-02 ")
 ;;1236
 ;;21,"54868-4358-03 ")
 ;;1237
 ;;21,"54868-4406-00 ")
 ;;3822
 ;;21,"54868-4413-00 ")
 ;;3503
 ;;21,"54868-4414-00 ")
 ;;3580
 ;;21,"54868-4425-00 ")
 ;;3487
 ;;21,"54868-4425-01 ")
 ;;3488
 ;;21,"54868-4425-02 ")
 ;;3489
 ;;21,"54868-4425-03 ")
 ;;3490
 ;;21,"54868-4428-00 ")
 ;;3424
 ;;21,"54868-4428-01 ")
 ;;3425
 ;;21,"54868-4428-02 ")
 ;;3426
 ;;21,"54868-4428-03 ")
 ;;3427
 ;;21,"54868-4479-00 ")
 ;;557
 ;;21,"54868-4479-01 ")
 ;;558
 ;;21,"54868-4479-02 ")
 ;;559
 ;;21,"54868-4494-00 ")
 ;;3225
 ;;21,"54868-4526-00 ")
 ;;3235
 ;;21,"54868-4526-01 ")
 ;;3236
 ;;21,"54868-4539-00 ")
 ;;3809
 ;;21,"54868-4539-01 ")
 ;;3810
 ;;21,"54868-4540-00 ")
 ;;3400
 ;;21,"54868-4540-01 ")
 ;;3401
 ;;21,"54868-4552-00 ")
 ;;2799
 ;;21,"54868-4552-01 ")
 ;;2800
 ;;21,"54868-4555-00 ")
 ;;2805
 ;;21,"54868-4555-01 ")
 ;;2806
 ;;21,"54868-4605-00 ")
 ;;3819
 ;;21,"54868-4605-01 ")
 ;;3820
 ;;21,"54868-4605-02 ")
 ;;3821
 ;;21,"54868-4612-00 ")
 ;;3515
 ;;21,"54868-4637-00 ")
 ;;423
 ;;21,"54868-4637-01 ")
 ;;424
 ;;21,"54868-4637-02 ")
 ;;425
 ;;21,"54868-4637-03 ")
 ;;426
 ;;21,"54868-4637-04 ")
 ;;427
 ;;21,"54868-4645-00 ")
 ;;3839
 ;;21,"54868-4645-01 ")
 ;;3840
 ;;21,"54868-4645-02 ")
 ;;3841
 ;;21,"54868-4645-03 ")
 ;;3842
 ;;21,"54868-4646-00 ")
 ;;2489
 ;;21,"54868-4646-02 ")
 ;;2490
 ;;21,"54868-4646-03 ")
 ;;2491
 ;;21,"54868-4646-04 ")
 ;;2570
 ;;21,"54868-4652-00 ")
 ;;3892
 ;;21,"54868-4652-01 ")
 ;;3893
 ;;21,"54868-4652-02 ")
 ;;3894
 ;;21,"54868-4652-03 ")
 ;;3895
 ;;21,"54868-4652-04 ")
 ;;3896
 ;;21,"54868-4652-05 ")
 ;;3908
 ;;21,"54868-4656-00 ")
 ;;2098
 ;;21,"54868-4656-01 ")
 ;;2099
 ;;21,"54868-4656-02 ")
 ;;2100
 ;;21,"54868-4656-03 ")
 ;;2140
 ;;21,"54868-4657-00 ")
 ;;1936
 ;;21,"54868-4657-01 ")
 ;;1937
 ;;21,"54868-4657-02 ")
 ;;1938
 ;;21,"54868-4657-04 ")
 ;;1939
 ;;21,"54868-4657-05 ")
 ;;1940
 ;;21,"54868-4657-06 ")
 ;;2058
 ;;21,"54868-4658-00 ")
 ;;2239
 ;;21,"54868-4658-01 ")
 ;;2240
 ;;21,"54868-4658-02 ")
 ;;2241
 ;;21,"54868-4658-03 ")
 ;;2242
 ;;21,"54868-4658-04 ")
 ;;2353
 ;;21,"54868-4678-00 ")
 ;;2658
 ;;21,"54868-4678-01 ")
 ;;2659
 ;;21,"54868-4678-02 ")
 ;;2660
 ;;21,"54868-4720-00 ")
 ;;3527
 ;;21,"54868-4720-01 ")
 ;;3528
 ;;21,"54868-4720-02 ")
 ;;3529
 ;;21,"54868-4720-03 ")
 ;;3530
 ;;21,"54868-4729-00 ")
 ;;3198
 ;;21,"54868-4780-00 ")
 ;;2385
 ;;21,"54868-4780-01 ")
 ;;2386
 ;;21,"54868-4785-00 ")
 ;;506
 ;;21,"54868-4785-01 ")
 ;;507
 ;;21,"54868-4785-02 ")
 ;;508
 ;;21,"54868-4785-03 ")
 ;;509
 ;;21,"54868-4869-00 ")
 ;;3202
 ;;21,"54868-4870-00 ")
 ;;9
 ;;21,"54868-4870-01 ")
 ;;10
 ;;21,"54868-4870-02 ")
 ;;11
 ;;21,"54868-4883-00 ")
 ;;2775
 ;;21,"54868-4883-01 ")
 ;;2776
 ;;21,"54868-4883-02 ")
 ;;2777
 ;;21,"54868-4885-00 ")
 ;;3790
 ;;21,"54868-4885-01 ")
 ;;3791
 ;;21,"54868-4904-00 ")
 ;;179
 ;;21,"54868-4904-01 ")
 ;;180
 ;;21,"54868-4977-00 ")
 ;;349
 ;;21,"54868-4977-01 ")
 ;;350
 ;;21,"54868-4977-02 ")
 ;;351
 ;;21,"54868-4986-00 ")
 ;;3770
 ;;21,"54868-4986-01 ")
 ;;3771
 ;;21,"54868-4986-02 ")
 ;;3772
 ;;21,"54868-5001-00 ")
 ;;630
 ;;21,"54868-5001-01 ")
 ;;631
 ;;21,"54868-5055-00 ")
 ;;1729
 ;;21,"54868-5064-00 ")
 ;;1678
 ;;21,"54868-5064-01 ")
 ;;1679
 ;;21,"54868-5075-00 ")
 ;;3374
 ;;21,"54868-5075-01 ")
 ;;3375
 ;;21,"54868-5077-00 ")
 ;;3659
 ;;21,"54868-5078-00 ")
 ;;3383
 ;;21,"54868-5078-01 ")
 ;;3384
 ;;21,"54868-5079-00 ")
 ;;703
 ;;21,"54868-5079-01 ")
 ;;704
 ;;21,"54868-5082-00 ")
 ;;3861
 ;;21,"54868-5082-01 ")
 ;;3862
 ;;21,"54868-5082-02 ")
 ;;3863
 ;;21,"54868-5082-03 ")
 ;;3864
 ;;21,"54868-5099-00 ")
 ;;3141
 ;;21,"54868-5099-01 ")
 ;;3142
 ;;21,"54868-5100-00 ")
 ;;265
 ;;21,"54868-5100-02 ")
 ;;266
 ;;21,"54868-5170-00 ")
 ;;3365
 ;;21,"54868-5170-01 ")
 ;;3366
 ;;21,"54868-5182-00 ")
 ;;1802
 ;;21,"54868-5182-01 ")
 ;;1803
 ;;21,"54868-5182-02 ")
 ;;1804
 ;;21,"54868-5196-00 ")
 ;;858
 ;;21,"54868-5196-01 ")
 ;;859
 ;;21,"54868-5196-02 ")
 ;;860
 ;;21,"54868-5204-00 ")
 ;;773
 ;;21,"54868-5204-01 ")
 ;;774
 ;;21,"54868-5204-02 ")
 ;;775
 ;;21,"54868-5204-03 ")
 ;;776
 ;;21,"54868-5241-00 ")
 ;;2855
 ;;21,"54868-5241-01 ")
 ;;2856
 ;;21,"54868-5241-02 ")
 ;;2857
 ;;21,"54868-5245-00 ")
 ;;2823
 ;;21,"54868-5245-01 ")
 ;;2824
 ;;21,"54868-5245-02 ")
 ;;2825
 ;;21,"54868-5246-00 ")
 ;;2883
 ;;21,"54868-5246-01 ")
 ;;2884
 ;;21,"54868-5256-00 ")
 ;;159
 ;;21,"54868-5279-00 ")
 ;;2910
 ;;21,"54868-5281-00 ")
 ;;3210
 ;;21,"54868-5281-01 ")
 ;;3211