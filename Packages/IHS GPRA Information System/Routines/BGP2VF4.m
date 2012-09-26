BGP2VF4 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 08, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"13107-0003-30 ")
 ;;2869
 ;;21,"13107-0003-34 ")
 ;;2870
 ;;21,"13107-0005-01 ")
 ;;1006
 ;;21,"13107-0005-05 ")
 ;;1007
 ;;21,"13107-0006-01 ")
 ;;1117
 ;;21,"13107-0006-05 ")
 ;;1118
 ;;21,"13107-0007-01 ")
 ;;1278
 ;;21,"13107-0007-05 ")
 ;;1279
 ;;21,"13107-0031-05 ")
 ;;2764
 ;;21,"13107-0031-30 ")
 ;;2765
 ;;21,"13107-0031-34 ")
 ;;2766
 ;;21,"13107-0032-05 ")
 ;;2969
 ;;21,"13107-0032-30 ")
 ;;2970
 ;;21,"13107-0032-34 ")
 ;;2971
 ;;21,"13107-0154-30 ")
 ;;3386
 ;;21,"13107-0155-05 ")
 ;;3514
 ;;21,"13107-0155-30 ")
 ;;3515
 ;;21,"13107-0155-99 ")
 ;;3516
 ;;21,"13107-0156-30 ")
 ;;3701
 ;;21,"13107-0156-99 ")
 ;;3702
 ;;21,"13107-0157-30 ")
 ;;3783
 ;;21,"13107-0157-99 ")
 ;;3784
 ;;21,"13411-0100-01 ")
 ;;4860
 ;;21,"13411-0100-03 ")
 ;;4861
 ;;21,"13411-0109-01 ")
 ;;4862
 ;;21,"13411-0109-06 ")
 ;;4863
 ;;21,"13411-0109-09 ")
 ;;4864
 ;;21,"13411-0109-10 ")
 ;;4865
 ;;21,"13411-0110-01 ")
 ;;5019
 ;;21,"13411-0110-03 ")
 ;;5020
 ;;21,"13411-0110-06 ")
 ;;5021
 ;;21,"13411-0110-09 ")
 ;;5022
 ;;21,"13411-0110-10 ")
 ;;5023
 ;;21,"13411-0152-01 ")
 ;;4198
 ;;21,"13411-0152-03 ")
 ;;4199
 ;;21,"13411-0152-06 ")
 ;;4200
 ;;21,"13411-0152-09 ")
 ;;4201
 ;;21,"13411-0152-15 ")
 ;;4202
 ;;21,"13411-0153-01 ")
 ;;3930
 ;;21,"13411-0153-03 ")
 ;;3931
 ;;21,"13411-0153-06 ")
 ;;3932
 ;;21,"13411-0153-09 ")
 ;;3933
 ;;21,"13411-0153-15 ")
 ;;3934
 ;;21,"13411-0172-01 ")
 ;;2050
 ;;21,"13411-0172-03 ")
 ;;2051
 ;;21,"13411-0172-06 ")
 ;;2052
 ;;21,"13411-0172-09 ")
 ;;2053
 ;;21,"13411-0172-10 ")
 ;;2054
 ;;21,"13411-0173-01 ")
 ;;2232
 ;;21,"13411-0173-03 ")
 ;;2233
 ;;21,"13411-0173-06 ")
 ;;2234
 ;;21,"13411-0173-09 ")
 ;;2235
 ;;21,"13411-0173-10 ")
 ;;2236
 ;;21,"13668-0004-01 ")
 ;;4095
 ;;21,"13668-0004-05 ")
 ;;4096
 ;;21,"13668-0004-10 ")
 ;;4097
 ;;21,"13668-0004-30 ")
 ;;4098
 ;;21,"13668-0004-50 ")
 ;;4099
 ;;21,"13668-0004-90 ")
 ;;4100
 ;;21,"13668-0005-01 ")
 ;;4203
 ;;21,"13668-0005-05 ")
 ;;4204
 ;;21,"13668-0005-10 ")
 ;;4205
 ;;21,"13668-0005-30 ")
 ;;4206
 ;;21,"13668-0005-50 ")
 ;;4207
 ;;21,"13668-0005-90 ")
 ;;4208
 ;;21,"13668-0006-01 ")
 ;;3935
 ;;21,"13668-0006-05 ")
 ;;3936
 ;;21,"13668-0006-10 ")
 ;;3937
 ;;21,"13668-0006-30 ")
 ;;3938
 ;;21,"13668-0006-50 ")
 ;;3939
 ;;21,"13668-0006-90 ")
 ;;3940
 ;;21,"13668-0009-01 ")
 ;;1008
 ;;21,"13668-0009-05 ")
 ;;1009
 ;;21,"13668-0009-09 ")
 ;;1010
 ;;21,"13668-0009-74 ")
 ;;1011
 ;;21,"13668-0010-01 ")
 ;;1119
 ;;21,"13668-0010-05 ")
 ;;1120
 ;;21,"13668-0010-06 ")
 ;;1121
 ;;21,"13668-0010-30 ")
 ;;1122
 ;;21,"13668-0011-01 ")
 ;;1280
 ;;21,"13668-0011-05 ")
 ;;1281
 ;;21,"13668-0011-08 ")
 ;;1282
 ;;21,"13668-0011-30 ")
 ;;1283
 ;;21,"13668-0018-30 ")
 ;;4866
 ;;21,"13668-0018-90 ")
 ;;4867
 ;;21,"13668-0019-30 ")
 ;;5024
 ;;21,"13668-0019-90 ")
 ;;5025
 ;;21,"13668-0020-30 ")
 ;;4750
 ;;21,"13668-0020-90 ")
 ;;4751
 ;;21,"16241-0759-01 ")
 ;;2415
 ;;21,"16252-0533-30 ")
 ;;4101
 ;;21,"16252-0533-50 ")
 ;;4102
 ;;21,"16252-0534-30 ")
 ;;4209
 ;;21,"16252-0534-50 ")
 ;;4210
 ;;21,"16252-0534-90 ")
 ;;4211
 ;;21,"16252-0535-30 ")
 ;;3941
 ;;21,"16252-0535-50 ")
 ;;3942
 ;;21,"16252-0535-90 ")
 ;;3943
 ;;21,"16590-0011-30 ")
 ;;18
 ;;21,"16590-0011-56 ")
 ;;19
 ;;21,"16590-0011-60 ")
 ;;20
 ;;21,"16590-0011-72 ")
 ;;21
 ;;21,"16590-0011-90 ")
 ;;22
 ;;21,"16590-0012-15 ")
 ;;221
 ;;21,"16590-0012-30 ")
 ;;222
 ;;21,"16590-0012-60 ")
 ;;223
 ;;21,"16590-0012-90 ")
 ;;224
 ;;21,"16590-0013-30 ")
 ;;374
 ;;21,"16590-0013-60 ")
 ;;375
 ;;21,"16590-0013-90 ")
 ;;376
 ;;21,"16590-0036-30 ")
 ;;665
 ;;21,"16590-0036-60 ")
 ;;666
 ;;21,"16590-0037-30 ")
 ;;931
 ;;21,"16590-0037-60 ")
 ;;932
 ;;21,"16590-0038-30 ")
 ;;729
 ;;21,"16590-0038-60 ")
 ;;730
 ;;21,"16590-0055-30 ")
 ;;1012
 ;;21,"16590-0055-60 ")
 ;;1013
 ;;21,"16590-0055-90 ")
 ;;1014
 ;;21,"16590-0056-30 ")
 ;;1123
 ;;21,"16590-0056-60 ")
 ;;1124
 ;;21,"16590-0056-90 ")
 ;;1125
 ;;21,"16590-0066-30 ")
 ;;1848
 ;;21,"16590-0066-60 ")
 ;;1849
 ;;21,"16590-0067-30 ")
 ;;1890
 ;;21,"16590-0067-60 ")
 ;;1891
 ;;21,"16590-0081-30 ")
 ;;1740
 ;;21,"16590-0081-60 ")
 ;;1741
 ;;21,"16590-0081-72 ")
 ;;1742
 ;;21,"16590-0081-90 ")
 ;;1743
 ;;21,"16590-0083-30 ")
 ;;4920
 ;;21,"16590-0083-60 ")
 ;;4921
 ;;21,"16590-0084-30 ")
 ;;5108
 ;;21,"16590-0084-60 ")
 ;;5109
 ;;21,"16590-0085-30 ")
 ;;4868
 ;;21,"16590-0085-60 ")
 ;;4869
 ;;21,"16590-0086-30 ")
 ;;5026
 ;;21,"16590-0086-60 ")
 ;;5027
 ;;21,"16590-0087-30 ")
 ;;4752
 ;;21,"16590-0087-60 ")
 ;;4753
 ;;21,"16590-0099-30 ")
 ;;2055
 ;;21,"16590-0099-60 ")
 ;;2056
 ;;21,"16590-0100-30 ")
 ;;2237
 ;;21,"16590-0100-60 ")
 ;;2238
 ;;21,"16590-0100-90 ")
 ;;2239
 ;;21,"16590-0139-30 ")
 ;;1928
 ;;21,"16590-0139-60 ")
 ;;1929
 ;;21,"16590-0153-30 ")
 ;;2767
 ;;21,"16590-0153-60 ")
 ;;2768
 ;;21,"16590-0154-30 ")
 ;;2871
 ;;21,"16590-0154-60 ")
 ;;2872
 ;;21,"16590-0155-30 ")
 ;;2972
 ;;21,"16590-0155-60 ")
 ;;2973
 ;;21,"16590-0166-30 ")
 ;;3034
 ;;21,"16590-0166-60 ")
 ;;3035
 ;;21,"16590-0166-90 ")
 ;;3036
 ;;21,"16590-0171-30 ")
 ;;3205
 ;;21,"16590-0171-60 ")
 ;;3206
 ;;21,"16590-0171-90 ")
 ;;3207
 ;;21,"16590-0181-30 ")
 ;;3517
 ;;21,"16590-0181-60 ")
 ;;3518
 ;;21,"16590-0181-90 ")
 ;;3519
 ;;21,"16590-0231-30 ")
 ;;4591
 ;;21,"16590-0231-60 ")
 ;;4592
 ;;21,"16590-0231-90 ")
 ;;4593
 ;;21,"16590-0232-30 ")
 ;;4356
 ;;21,"16590-0232-45 ")
 ;;4357
 ;;21,"16590-0232-60 ")
 ;;4358
 ;;21,"16590-0232-90 ")
 ;;4359
 ;;21,"16590-0246-30 ")
 ;;878
 ;;21,"16590-0246-60 ")
 ;;879
 ;;21,"16590-0246-90 ")
 ;;880
 ;;21,"16590-0249-30 ")
 ;;4103
 ;;21,"16590-0249-60 ")
 ;;4104
 ;;21,"16590-0249-90 ")
 ;;4105
 ;;21,"16590-0250-30 ")
 ;;4212
 ;;21,"16590-0250-60 ")
 ;;4213
 ;;21,"16590-0250-90 ")
 ;;4214
 ;;21,"16590-0251-30 ")
 ;;3944
 ;;21,"16590-0251-60 ")
 ;;3945
 ;;21,"16590-0251-90 ")
 ;;3946
 ;;21,"16590-0322-30 ")
 ;;3387
 ;;21,"16590-0322-56 ")
 ;;3388
 ;;21,"16590-0322-60 ")
 ;;3389
 ;;21,"16590-0322-72 ")
 ;;3390
 ;;21,"16590-0322-90 ")
 ;;3391
 ;;21,"16590-0416-30 ")
 ;;3947
 ;;21,"16590-0437-30 ")
 ;;131
 ;;21,"16590-0482-30 ")
 ;;1850
 ;;21,"16590-0482-60 ")
 ;;1851
 ;;21,"16590-0482-72 ")
 ;;1852
 ;;21,"16590-0482-90 ")
 ;;1853
 ;;21,"16590-0483-30 ")
 ;;1892
 ;;21,"16590-0483-60 ")
 ;;1893
 ;;21,"16590-0483-72 ")
 ;;1894
 ;;21,"16590-0483-90 ")
 ;;1895
 ;;21,"16590-0484-30 ")
 ;;1524
 ;;21,"16590-0484-60 ")
 ;;1525
 ;;21,"16590-0484-72 ")
 ;;1526
 ;;21,"16590-0484-90 ")
 ;;1527
 ;;21,"16590-0490-30 ")
 ;;2465
 ;;21,"16590-0490-60 ")
 ;;2466
 ;;21,"16590-0490-72 ")
 ;;2467
 ;;21,"16590-0490-90 ")
 ;;2468
 ;;21,"16590-0497-30 ")
 ;;1973
 ;;21,"16590-0497-60 ")
 ;;1974
 ;;21,"16590-0497-72 ")
 ;;1975
 ;;21,"16590-0497-90 ")
 ;;1976
 ;;21,"16590-0510-30 ")
 ;;3353
 ;;21,"16590-0510-60 ")
 ;;3354
 ;;21,"16590-0510-72 ")
 ;;3355
 ;;21,"16590-0510-90 ")
 ;;3356
 ;;21,"16590-0512-06 ")
 ;;3703
 ;;21,"16590-0512-30 ")
 ;;3704
 ;;21,"16590-0512-60 ")
 ;;3705
 ;;21,"16590-0512-72 ")
 ;;3706
 ;;21,"16590-0512-90 ")
 ;;3707
 ;;21,"16590-0513-30 ")
 ;;3785
 ;;21,"16590-0513-56 ")
 ;;3786
 ;;21,"16590-0513-60 ")
 ;;3787
 ;;21,"16590-0513-72 ")
 ;;3788
 ;;21,"16590-0513-90 ")
 ;;3789
 ;;21,"16590-0514-30 ")
 ;;3468
 ;;21,"16590-0514-60 ")
 ;;3469
 ;;21,"16590-0514-72 ")
 ;;3470
 ;;21,"16590-0514-90 ")
 ;;3471
 ;;21,"16590-0526-30 ")
 ;;814
 ;;21,"16590-0526-60 ")
 ;;815
 ;;21,"16590-0526-90 ")
 ;;816
 ;;21,"16590-0577-30 ")
 ;;2625
 ;;21,"16714-0351-02 ")
 ;;2057
 ;;21,"16714-0351-03 ")
 ;;2058
 ;;21,"16714-0352-02 ")
 ;;2240
 ;;21,"16714-0352-03 ")
 ;;2241
 ;;21,"16714-0353-01 ")
 ;;2469
 ;;21,"16714-0353-02 ")
 ;;2470
 ;;21,"16714-0353-03 ")
 ;;2471
 ;;21,"16714-0353-04 ")
 ;;2472
 ;;21,"16714-0601-01 ")
 ;;4072
 ;;21,"16714-0611-01 ")
 ;;4106
 ;;21,"16714-0611-04 ")
 ;;4107
 ;;21,"16714-0611-05 ")
 ;;4108
 ;;21,"16714-0611-06 ")
 ;;4109
 ;;21,"16714-0612-01 ")
 ;;4215
 ;;21,"16714-0612-04 ")
 ;;4216
 ;;21,"16714-0612-05 ")
 ;;4217
 ;;21,"16714-0612-06 ")
 ;;4218
 ;;21,"16714-0613-01 ")
 ;;3948
 ;;21,"16714-0613-04 ")
 ;;3949
 ;;21,"16714-0613-05 ")
 ;;3950
 ;;21,"16714-0613-06 ")
 ;;3951
 ;;21,"17236-0358-11 ")
 ;;1809
 ;;21,"17236-0359-11 ")
 ;;1621
 ;;21,"17856-0540-30 ")
 ;;1080
 ;;21,"18837-0034-30 ")
 ;;1854
 ;;21,"18837-0034-60 ")
 ;;1855
 ;;21,"18837-0035-30 ")
 ;;1896
 ;;21,"18837-0035-60 ")
 ;;1897
 ;;21,"18837-0035-90 ")
 ;;1898
 ;;21,"18837-0048-30 ")
 ;;4754
 ;;21,"18837-0048-60 ")
 ;;4755
 ;;21,"18837-0048-90 ")
 ;;4756
 ;;21,"18837-0049-30 ")
 ;;5028
 ;;21,"18837-0049-60 ")
 ;;5029
 ;;21,"18837-0049-90 ")
 ;;5030
 ;;21,"18837-0054-30 ")
 ;;2242
 ;;21,"18837-0054-60 ")
 ;;2243
 ;;21,"18837-0054-90 ")
 ;;2244
 ;;21,"18837-0076-30 ")
 ;;1930
 ;;21,"18837-0076-90 ")
 ;;1931
 ;;21,"18837-0077-30 ")
 ;;1977
 ;;21,"18837-0093-60 ")
 ;;2769
 ;;21,"18837-0114-30 ")
 ;;3208
 ;;21,"18837-0121-30 ")
 ;;3520
 ;;21,"18837-0160-30 ")
 ;;4360
 ;;21,"18837-0162-30 ")
 ;;4594
 ;;21,"18837-0162-60 ")
 ;;4595
 ;;21,"18837-0175-30 ")
 ;;817
 ;;21,"18837-0176-30 ")
 ;;881
 ;;21,"18837-0185-60 ")
 ;;3952
 ;;21,"18837-0185-90 ")
 ;;3953
 ;;21,"18837-0207-60 ")
 ;;1833
 ;;21,"18837-0222-30 ")
 ;;3521
 ;;21,"18837-0242-30 ")
 ;;1015
 ;;21,"18837-0278-30 ")
 ;;3790
 ;;21,"18837-0354-30 ")
 ;;818
 ;;21,"21695-0017-00 ")
 ;;933
 ;;21,"21695-0017-60 ")
 ;;934
 ;;21,"21695-0018-00 ")
 ;;573
 ;;21,"21695-0018-30 ")
 ;;574
 ;;21,"21695-0018-60 ")
 ;;575
 ;;21,"21695-0018-90 ")
 ;;576
 ;;21,"21695-0019-30 ")
 ;;731
 ;;21,"21695-0019-60 ")
 ;;732
 ;;21,"21695-0020-60 ")
 ;;858
 ;;21,"21695-0030-00 ")
 ;;1016
 ;;21,"21695-0031-00 ")
 ;;1126
 ;;21,"21695-0032-00 ")
 ;;1284
 ;;21,"21695-0032-30 ")
 ;;1285
 ;;21,"21695-0045-15 ")
 ;;4870
 ;;21,"21695-0046-15 ")
 ;;5031
 ;;21,"21695-0046-30 ")
 ;;5032
 ;;21,"21695-0046-45 ")
 ;;5033
 ;;21,"21695-0047-15 ")
 ;;4757
 ;;21,"21695-0047-45 ")
 ;;4758
 ;;21,"21695-0052-20 ")
 ;;2059
 ;;21,"21695-0052-30 ")
 ;;2060
 ;;21,"21695-0052-60 ")
 ;;2061
 ;;21,"21695-0052-90 ")
 ;;2062
 ;;21,"21695-0053-30 ")
 ;;2245
 ;;21,"21695-0053-60 ")
 ;;2246
 ;;21,"21695-0053-90 ")
 ;;2247
 ;;21,"21695-0054-07 ")
 ;;2473
 ;;21,"21695-0054-30 ")
 ;;2474
 ;;21,"21695-0054-60 ")
 ;;2475
 ;;21,"21695-0054-90 ")
 ;;2476
 ;;21,"21695-0073-15 ")
 ;;1932
 ;;21,"21695-0073-30 ")
 ;;1933
 ;;21,"21695-0073-45 ")
 ;;1934
 ;;21,"21695-0074-15 ")
 ;;1978
 ;;21,"21695-0074-30 ")
 ;;1979
 ;;21,"21695-0081-00 ")
 ;;2770
 ;;21,"21695-0081-30 ")
 ;;2771
 ;;21,"21695-0081-60 ")
 ;;2772
 ;;21,"21695-0082-00 ")
 ;;2873
 ;;21,"21695-0082-30 ")
 ;;2874
 ;;21,"21695-0082-60 ")
 ;;2875
 ;;21,"21695-0083-30 ")
 ;;2974
 ;;21,"21695-0093-30 ")
 ;;3111
 ;;21,"21695-0093-60 ")
 ;;3112
 ;;21,"21695-0093-90 ")
 ;;3113
 ;;21,"21695-0094-30 ")
 ;;3209
 ;;21,"21695-0094-60 ")
 ;;3210
 ;;21,"21695-0094-90 ")
 ;;3211
 ;;21,"21695-0101-30 ")
 ;;3392
 ;;21,"21695-0101-60 ")
 ;;3393
 ;;21,"21695-0101-90 ")
 ;;3394
 ;;21,"21695-0102-30 ")
 ;;3522
 ;;21,"21695-0102-60 ")
 ;;3523
 ;;21,"21695-0102-90 ")
 ;;3524
 ;;21,"21695-0103-30 ")
 ;;3708
 ;;21,"21695-0103-90 ")
 ;;3709
 ;;21,"21695-0104-30 ")
 ;;3791
 ;;21,"21695-0104-90 ")
 ;;3792
 ;;21,"21695-0133-30 ")
 ;;4596
 ;;21,"21695-0133-60 ")
 ;;4597
 ;;21,"21695-0133-90 ")
 ;;4598
 ;;21,"21695-0134-30 ")
 ;;4361
 ;;21,"21695-0134-60 ")
 ;;4362
 ;;21,"21695-0134-90 ")
 ;;4363
 ;;21,"21695-0135-60 ")
 ;;4477
 ;;21,"21695-0137-15 ")
 ;;819
 ;;21,"21695-0137-30 ")
 ;;820
 ;;21,"21695-0137-45 ")
 ;;821
 ;;21,"21695-0138-15 ")
 ;;882
 ;;21,"21695-0138-30 ")
 ;;883
 ;;21,"21695-0145-15 ")
 ;;1856
 ;;21,"21695-0145-30 ")
 ;;1857
 ;;21,"21695-0146-15 ")
 ;;1899
 ;;21,"21695-0159-15 ")
 ;;3472
 ;;21,"21695-0159-30 ")
 ;;3473
 ;;21,"21695-0160-30 ")
 ;;3668
 ;;21,"21695-0164-30 ")
 ;;4110
 ;;21,"21695-0165-30 ")
 ;;4219
 ;;21,"21695-0166-30 ")
 ;;3954
 ;;21,"21695-0174-60 ")
 ;;3037
 ;;21,"21695-0175-60 ")
 ;;3052
 ;;21,"21695-0176-30 ")
 ;;3067
 ;;21,"21695-0176-60 ")
 ;;3068
 ;;21,"21695-0177-30 ")
 ;;3085
 ;;21,"21695-0177-60 ")
 ;;3086
 ;;21,"21695-0251-30 ")
 ;;225
 ;;21,"21695-0251-60 ")
 ;;226
 ;;21,"21695-0251-90 ")
 ;;227
 ;;21,"21695-0253-30 ")
 ;;132
 ;;21,"21695-0279-30 ")
 ;;822
 ;;21,"21695-0295-60 ")
 ;;667
 ;;21,"21695-0296-15 ")
 ;;5034
 ;;21,"21695-0320-00 ")
 ;;2159
 ;;21,"21695-0320-90 ")
 ;;2160
 ;;21,"21695-0321-00 ")
 ;;2416
 ;;21,"21695-0321-30 ")
 ;;2417
 ;;21,"21695-0321-60 ")
 ;;2418
 ;;21,"21695-0321-90 ")
 ;;2419
 ;;21,"21695-0428-00 ")
 ;;1460
 ;;21,"21695-0428-28 ")
 ;;1461
 ;;21,"21695-0428-30 ")
 ;;1462
