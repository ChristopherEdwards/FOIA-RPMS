BGP47Y ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 17, 2014;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;;BGP PQA RASA NDC
 ;
 ; This routine loads Taxonomy BGP PQA RASA NDC
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
 ;;21,"00003-0338-50 ")
 ;;4092
 ;;21,"00003-0349-50 ")
 ;;4100
 ;;21,"00003-0384-50 ")
 ;;4107
 ;;21,"00003-0390-50 ")
 ;;4113
 ;;21,"00003-0450-51 ")
 ;;329
 ;;21,"00003-0450-54 ")
 ;;330
 ;;21,"00003-0450-75 ")
 ;;331
 ;;21,"00003-0452-50 ")
 ;;410
 ;;21,"00003-0452-51 ")
 ;;411
 ;;21,"00003-0452-75 ")
 ;;412
 ;;21,"00003-0482-50 ")
 ;;536
 ;;21,"00003-0482-51 ")
 ;;537
 ;;21,"00003-0482-75 ")
 ;;538
 ;;21,"00003-0485-50 ")
 ;;644
 ;;21,"00006-0014-28 ")
 ;;758
 ;;21,"00006-0014-68 ")
 ;;759
 ;;21,"00006-0014-82 ")
 ;;760
 ;;21,"00006-0014-87 ")
 ;;761
 ;;21,"00006-0014-94 ")
 ;;762
 ;;21,"00006-0015-28 ")
 ;;1526
 ;;21,"00006-0015-31 ")
 ;;1527
 ;;21,"00006-0015-58 ")
 ;;1528
 ;;21,"00006-0019-28 ")
 ;;1721
 ;;21,"00006-0019-54 ")
 ;;1722
 ;;21,"00006-0019-58 ")
 ;;1723
 ;;21,"00006-0019-72 ")
 ;;1724
 ;;21,"00006-0019-82 ")
 ;;1725
 ;;21,"00006-0019-86 ")
 ;;1726
 ;;21,"00006-0019-87 ")
 ;;1727
 ;;21,"00006-0019-94 ")
 ;;1728
 ;;21,"00006-0106-28 ")
 ;;1975
 ;;21,"00006-0106-31 ")
 ;;1976
 ;;21,"00006-0106-54 ")
 ;;1977
 ;;21,"00006-0106-58 ")
 ;;1978
 ;;21,"00006-0106-72 ")
 ;;1979
 ;;21,"00006-0106-82 ")
 ;;1980
 ;;21,"00006-0106-87 ")
 ;;1981
 ;;21,"00006-0106-94 ")
 ;;1982
 ;;21,"00006-0140-31 ")
 ;;4403
 ;;21,"00006-0140-58 ")
 ;;4404
 ;;21,"00006-0142-31 ")
 ;;4508
 ;;21,"00006-0142-58 ")
 ;;4509
 ;;21,"00006-0145-31 ")
 ;;4286
 ;;21,"00006-0145-58 ")
 ;;4287
 ;;21,"00006-0173-68 ")
 ;;4143
 ;;21,"00006-0207-28 ")
 ;;2245
 ;;21,"00006-0207-31 ")
 ;;2246
 ;;21,"00006-0207-54 ")
 ;;2247
 ;;21,"00006-0207-58 ")
 ;;2248
 ;;21,"00006-0207-72 ")
 ;;2249
 ;;21,"00006-0207-82 ")
 ;;2250
 ;;21,"00006-0207-87 ")
 ;;2251
 ;;21,"00006-0207-94 ")
 ;;2252
 ;;21,"00006-0237-58 ")
 ;;2535
 ;;21,"00006-0712-28 ")
 ;;906
 ;;21,"00006-0712-68 ")
 ;;907
 ;;21,"00006-0712-82 ")
 ;;908
 ;;21,"00006-0712-87 ")
 ;;909
 ;;21,"00006-0712-94 ")
 ;;910
 ;;21,"00006-0713-28 ")
 ;;1074
 ;;21,"00006-0713-68 ")
 ;;1075
 ;;21,"00006-0713-82 ")
 ;;1076
 ;;21,"00006-0713-87 ")
 ;;1077
 ;;21,"00006-0713-94 ")
 ;;1078
 ;;21,"00006-0714-28 ")
 ;;1219
 ;;21,"00006-0714-68 ")
 ;;1220
 ;;21,"00006-0714-82 ")
 ;;1221
 ;;21,"00006-0714-87 ")
 ;;1222
 ;;21,"00006-0714-94 ")
 ;;1223
 ;;21,"00006-0717-01 ")
 ;;4749
 ;;21,"00006-0717-31 ")
 ;;4750
 ;;21,"00006-0717-54 ")
 ;;4751
 ;;21,"00006-0717-58 ")
 ;;4752
 ;;21,"00006-0717-82 ")
 ;;4753
 ;;21,"00006-0720-68 ")
 ;;4177
 ;;21,"00006-0745-31 ")
 ;;4818
 ;;21,"00006-0745-54 ")
 ;;4819
 ;;21,"00006-0745-82 ")
 ;;4820
 ;;21,"00006-0747-28 ")
 ;;4883
 ;;21,"00006-0747-31 ")
 ;;4884
 ;;21,"00006-0747-54 ")
 ;;4885
 ;;21,"00006-0747-58 ")
 ;;4886
 ;;21,"00006-0747-81 ")
 ;;4887
 ;;21,"00006-0747-82 ")
 ;;4888
 ;;21,"00006-0951-01 ")
 ;;3257
 ;;21,"00006-0951-28 ")
 ;;3258
 ;;21,"00006-0951-54 ")
 ;;3259
 ;;21,"00006-0951-58 ")
 ;;3260
 ;;21,"00006-0951-82 ")
 ;;3261
 ;;21,"00006-0951-87 ")
 ;;3262
 ;;21,"00006-0952-01 ")
 ;;3342
 ;;21,"00006-0952-31 ")
 ;;3343
 ;;21,"00006-0952-54 ")
 ;;3344
 ;;21,"00006-0952-58 ")
 ;;3345
 ;;21,"00006-0952-82 ")
 ;;3346
 ;;21,"00006-0960-01 ")
 ;;3446
 ;;21,"00006-0960-31 ")
 ;;3447
 ;;21,"00006-0960-54 ")
 ;;3448
 ;;21,"00006-0960-58 ")
 ;;3449
 ;;21,"00006-0960-82 ")
 ;;3450
 ;;21,"00006-0960-86 ")
 ;;3451
 ;;21,"00024-5850-30 ")
 ;;3083
 ;;21,"00024-5850-90 ")
 ;;3084
 ;;21,"00024-5851-30 ")
 ;;3131
 ;;21,"00024-5851-90 ")
 ;;3132
 ;;21,"00024-5852-30 ")
 ;;3197
 ;;21,"00024-5852-90 ")
 ;;3198
 ;;21,"00024-5855-30 ")
 ;;4667
 ;;21,"00024-5855-90 ")
 ;;4668
 ;;21,"00024-5856-30 ")
 ;;4702
 ;;21,"00024-5856-90 ")
 ;;4703
 ;;21,"00032-1101-01 ")
 ;;2563
 ;;21,"00032-1102-01 ")
 ;;2567
 ;;21,"00032-1103-01 ")
 ;;2573
 ;;21,"00048-5805-01 ")
 ;;2955
 ;;21,"00048-5805-41 ")
 ;;2956
 ;;21,"00048-5806-01 ")
 ;;2977
 ;;21,"00048-5806-41 ")
 ;;2978
 ;;21,"00048-5807-01 ")
 ;;2998
 ;;21,"00048-5807-41 ")
 ;;2999
 ;;21,"00048-5912-40 ")
 ;;3977
 ;;21,"00048-5921-80 ")
 ;;3980
 ;;21,"00048-5922-40 ")
 ;;3988
 ;;21,"00048-5942-40 ")
 ;;3994
 ;;21,"00051-5044-01 ")
 ;;3062
 ;;21,"00051-5044-42 ")
 ;;3063
 ;;21,"00051-5046-01 ")
 ;;3071
 ;;21,"00051-5046-42 ")
 ;;3072
 ;;21,"00054-0106-25 ")
 ;;2736
 ;;21,"00054-0107-20 ")
 ;;2773
 ;;21,"00054-0107-25 ")
 ;;2774
 ;;21,"00054-0107-29 ")
 ;;2775
 ;;21,"00054-0108-20 ")
 ;;2846
 ;;21,"00054-0108-25 ")
 ;;2847
 ;;21,"00054-0108-29 ")
 ;;2848
 ;;21,"00054-0109-25 ")
 ;;2918
 ;;21,"00054-0109-29 ")
 ;;2919
 ;;21,"00054-0110-25 ")
 ;;2564
 ;;21,"00054-0111-25 ")
 ;;2569
 ;;21,"00054-0112-25 ")
 ;;2575
 ;;21,"00054-0123-22 ")
 ;;3284
 ;;21,"00054-0124-22 ")
 ;;3371
 ;;21,"00054-0125-22 ")
 ;;3477
 ;;21,"00054-0126-22 ")
 ;;4763
 ;;21,"00054-0127-22 ")
 ;;4889
 ;;21,"00054-0250-13 ")
 ;;3090
 ;;21,"00054-0250-22 ")
 ;;3091
 ;;21,"00054-0251-13 ")
 ;;3156
 ;;21,"00054-0251-22 ")
 ;;3157
 ;;21,"00054-0252-13 ")
 ;;3216
 ;;21,"00054-0252-22 ")
 ;;3217
 ;;21,"00054-0254-13 ")
 ;;4682
 ;;21,"00054-0254-22 ")
 ;;4683
 ;;21,"00054-0255-13 ")
 ;;4716
 ;;21,"00054-0255-22 ")
 ;;4717
 ;;21,"00054-0277-22 ")
 ;;4821
 ;;21,"00071-0220-06 ")
 ;;4554
 ;;21,"00071-0220-23 ")
 ;;4555
 ;;21,"00071-0222-06 ")
 ;;4539
 ;;21,"00071-0222-23 ")
 ;;4540
 ;;21,"00071-0223-06 ")
 ;;4573
 ;;21,"00071-0223-23 ")
 ;;4574
 ;;21,"00071-0527-23 ")
 ;;2581
 ;;21,"00071-0527-40 ")
 ;;2582
 ;;21,"00071-0530-23 ")
 ;;2610
 ;;21,"00071-0530-40 ")
 ;;2611
 ;;21,"00071-0532-23 ")
 ;;2648
 ;;21,"00071-0532-40 ")
 ;;2649
 ;;21,"00071-0535-23 ")
 ;;2683
 ;;21,"00074-2278-11 ")
 ;;2957
 ;;21,"00074-2278-13 ")
 ;;2958
 ;;21,"00074-2279-11 ")
 ;;2975
 ;;21,"00074-2279-13 ")
 ;;2976
 ;;21,"00074-2280-11 ")
 ;;3000
 ;;21,"00074-2280-13 ")
 ;;3001
 ;;21,"00074-3015-11 ")
 ;;4654
 ;;21,"00074-3020-11 ")
 ;;4661
 ;;21,"00074-3025-11 ")
 ;;3061
 ;;21,"00074-3040-11 ")
 ;;3073
 ;;21,"00074-3287-13 ")
 ;;3981
 ;;21,"00074-3288-13 ")
 ;;3976
 ;;21,"00074-3289-13 ")
 ;;3987
 ;;21,"00074-3290-13 ")
 ;;3995
 ;;21,"00078-0314-05 ")
 ;;5006
 ;;21,"00078-0314-06 ")
 ;;5007
 ;;21,"00078-0314-33 ")
 ;;5008
 ;;21,"00078-0314-34 ")
 ;;5009
 ;;21,"00078-0314-61 ")
 ;;5010
 ;;21,"00078-0315-05 ")
 ;;5058
 ;;21,"00078-0315-06 ")
 ;;5059
 ;;21,"00078-0315-15 ")
 ;;5060
 ;;21,"00078-0315-17 ")
 ;;5061
 ;;21,"00078-0315-34 ")
 ;;5062
 ;;21,"00078-0315-61 ")
 ;;5063
 ;;21,"00078-0315-67 ")
 ;;5064
 ;;21,"00078-0358-05 ")
 ;;3648
 ;;21,"00078-0358-06 ")
 ;;3649
 ;;21,"00078-0358-33 ")
 ;;3650
 ;;21,"00078-0358-34 ")
 ;;3651
 ;;21,"00078-0358-61 ")
 ;;3652
 ;;21,"00078-0359-05 ")
 ;;3664
 ;;21,"00078-0359-06 ")
 ;;3665
 ;;21,"00078-0359-17 ")
 ;;3666
 ;;21,"00078-0359-34 ")
 ;;3667
 ;;21,"00078-0359-61 ")
 ;;3668
 ;;21,"00078-0360-05 ")
 ;;3704
 ;;21,"00078-0360-06 ")
 ;;3705
 ;;21,"00078-0360-11 ")
 ;;3706
 ;;21,"00078-0360-34 ")
 ;;3707
 ;;21,"00078-0364-05 ")
 ;;3937
 ;;21,"00078-0376-06 ")
 ;;3617
 ;;21,"00078-0376-15 ")
 ;;3618
 ;;21,"00078-0379-05 ")
 ;;3966
 ;;21,"00078-0383-05 ")
 ;;5104
 ;;21,"00078-0383-06 ")
 ;;5105
 ;;21,"00078-0383-15 ")
 ;;5120
 ;;21,"00078-0383-17 ")
 ;;5121
 ;;21,"00078-0383-34 ")
 ;;5103
 ;;21,"00078-0383-61 ")
 ;;5122
 ;;21,"00078-0383-67 ")
 ;;5123
 ;;21,"00078-0384-05 ")
 ;;3886
 ;;21,"00078-0404-05 ")
 ;;3744
 ;;21,"00078-0405-05 ")
 ;;3791
 ;;21,"00078-0406-05 ")
 ;;3854
 ;;21,"00078-0423-06 ")
 ;;3614
 ;;21,"00078-0423-15 ")
 ;;3615
 ;;21,"00078-0423-61 ")
 ;;3616
 ;;21,"00078-0447-05 ")
 ;;43
 ;;21,"00078-0448-05 ")
 ;;120
 ;;21,"00078-0449-05 ")
 ;;219
 ;;21,"00078-0450-05 ")
 ;;325
 ;;21,"00078-0451-05 ")
 ;;4015
 ;;21,"00078-0452-05 ")
 ;;4038
 ;;21,"00078-0453-05 ")
 ;;4066
 ;;21,"00078-0454-05 ")
 ;;4090
 ;;21,"00078-0471-11 ")
 ;;5149
 ;;21,"00078-0471-15 ")
 ;;5150
 ;;21,"00078-0471-34 ")
 ;;5151
 ;;21,"00078-0471-67 ")
 ;;5152
 ;;21,"00078-0472-11 ")
 ;;5178
 ;;21,"00078-0472-15 ")
 ;;5179
 ;;21,"00078-0472-34 ")
 ;;5180
 ;;21,"00078-0472-67 ")
 ;;5181
 ;;21,"00078-0485-15 ")
 ;;3712
 ;;21,"00078-0485-35 ")
 ;;3713
 ;;21,"00078-0485-61 ")
 ;;3714
 ;;21,"00078-0486-15 ")
 ;;3720
 ;;21,"00078-0486-35 ")
 ;;3721
 ;;21,"00078-0486-61 ")
 ;;3722
 ;;21,"00078-0488-15 ")
 ;;4607
 ;;21,"00078-0489-15 ")
 ;;4611
 ;;21,"00078-0490-15 ")
 ;;4608
 ;;21,"00078-0491-15 ")
 ;;4613
 ;;21,"00078-0521-15 ")
 ;;5222
 ;;21,"00078-0522-15 ")
 ;;5223
 ;;21,"00078-0523-15 ")
 ;;5224
 ;;21,"00078-0524-15 ")
 ;;5227
 ;;21,"00078-0559-15 ")
 ;;5205
 ;;21,"00078-0560-15 ")
 ;;5206
 ;;21,"00078-0561-15 ")
 ;;5207
 ;;21,"00078-0562-15 ")
 ;;5208
 ;;21,"00078-0563-15 ")
 ;;5209
 ;;21,"00078-0572-15 ")
 ;;5228
 ;;21,"00078-0574-15 ")
 ;;5229
 ;;21,"00078-0603-15 ")
 ;;5230
 ;;21,"00078-0604-15 ")
 ;;5231
 ;;21,"00078-0605-15 ")
 ;;5232
 ;;21,"00078-0606-15 ")
 ;;5233
 ;;21,"00078-0610-15 ")
 ;;5234
 ;;21,"00078-0611-15 ")
 ;;5235
 ;;21,"00078-0612-15 ")
 ;;5236
 ;;21,"00078-0613-15 ")
 ;;5237
 ;;21,"00078-0614-15 ")
 ;;5238
 ;;21,"00083-0057-30 ")
 ;;4014
 ;;21,"00083-0059-30 ")
 ;;44
 ;;21,"00083-0059-32 ")
 ;;45
 ;;21,"00083-0059-90 ")
 ;;46
 ;;21,"00083-0063-30 ")
 ;;117
 ;;21,"00083-0063-32 ")
 ;;118
 ;;21,"00083-0063-90 ")
 ;;119
 ;;21,"00083-0072-30 ")
 ;;4039
 ;;21,"00083-0074-30 ")
 ;;4065
 ;;21,"00083-0075-30 ")
 ;;4091
 ;;21,"00083-0079-30 ")
 ;;220
 ;;21,"00083-0079-32 ")
 ;;221
 ;;21,"00083-0079-90 ")
 ;;222
 ;;21,"00083-0094-30 ")
 ;;322
 ;;21,"00083-0094-32 ")
 ;;323
 ;;21,"00083-0094-90 ")
 ;;324
 ;;21,"00083-2255-30 ")
 ;;3743
 ;;21,"00083-2260-30 ")
 ;;3792
 ;;21,"00083-2265-30 ")
 ;;3853
 ;;21,"00087-0158-46 ")
 ;;1284
 ;;21,"00087-0158-85 ")
 ;;1285
 ;;21,"00087-0609-42 ")
 ;;1379
 ;;21,"00087-0609-45 ")
 ;;1380
 ;;21,"00087-0609-85 ")
 ;;1381
 ;;21,"00087-1202-13 ")
 ;;1442
 ;;21,"00087-1492-01 ")
 ;;4188
 ;;21,"00087-1493-01 ")
 ;;4198
 ;;21,"00087-2771-31 ")
 ;;3081
 ;;21,"00087-2771-32 ")
 ;;3082
 ;;21,"00087-2772-15 ")
 ;;3133
 ;;21,"00087-2772-31 ")
 ;;3134
 ;;21,"00087-2772-32 ")
 ;;3135
 ;;21,"00087-2772-35 ")
 ;;3136
 ;;21,"00087-2773-15 ")
 ;;3199
 ;;21,"00087-2773-31 ")
 ;;3200
 ;;21,"00087-2773-32 ")
 ;;3201
 ;;21,"00087-2775-31 ")
 ;;4665
 ;;21,"00087-2775-32 ")
 ;;4666
 ;;21,"00087-2776-31 ")
 ;;4704
 ;;21,"00087-2776-32 ")
 ;;4705
 ;;21,"00087-2788-31 ")
 ;;4736
 ;;21,"00087-2788-32 ")
 ;;4737
 ;;21,"00087-2875-31 ")
 ;;4663
 ;;21,"00087-2875-32 ")
 ;;4664
 ;;21,"00087-2876-31 ")
 ;;4706
 ;;21,"00087-2876-32 ")
 ;;4707
 ;;21,"00091-3707-01 ")
 ;;2548
 ;;21,"00091-3707-09 ")
 ;;2549
 ;;21,"00091-3712-01 ")
 ;;4519
 ;;21,"00091-3715-01 ")
 ;;2561
 ;;21,"00091-3715-09 ")
 ;;2562
 ;;21,"00091-3720-01 ")
 ;;4526
 ;;21,"00091-3725-01 ")
 ;;4535
 ;;21,"00093-0017-01 ")
 ;;2542
 ;;21,"00093-0026-01 ")
 ;;730
 ;;21,"00093-0026-10 ")
 ;;731
 ;;21,"00093-0027-01 ")
 ;;844
 ;;21,"00093-0027-10 ")
 ;;845
 ;;21,"00093-0027-50 ")
 ;;846
 ;;21,"00093-0028-01 ")
 ;;986
 ;;21,"00093-0028-10 ")
 ;;987
 ;;21,"00093-0028-50 ")
 ;;988
 ;;21,"00093-0029-01 ")
 ;;1158
 ;;21,"00093-0029-10 ")
 ;;1159
 ;;21,"00093-0029-50 ")
 ;;1160
 ;;21,"00093-0091-01 ")
 ;;364
 ;;21,"00093-0091-10 ")
 ;;365
 ;;21,"00093-0092-01 ")
 ;;481
 ;;21,"00093-0092-10 ")
 ;;482
 ;;21,"00093-0097-01 ")
 ;;579
 ;;21,"00093-0097-10 ")
 ;;580
 ;;21,"00093-0098-01 ")
 ;;653
 ;;21,"00093-0176-01 ")
 ;;4096
 ;;21,"00093-0177-01 ")
 ;;4103
 ;;21,"00093-0181-01 ")
 ;;4109
 ;;21,"00093-0182-01 ")
 ;;4116
 ;;21,"00093-1035-01 ")
 ;;4206
 ;;21,"00093-1036-01 ")
 ;;4362
 ;;21,"00093-1036-05 ")
 ;;4363
 ;;21,"00093-1037-01 ")
 ;;4433
 ;;21,"00093-1037-05 ")
 ;;4434
 ;;21,"00093-1044-01 ")
 ;;4135
 ;;21,"00093-1052-01 ")
 ;;4154
 ;;21,"00093-1052-10 ")
 ;;4155
 ;;21,"00093-1111-01 ")
 ;;1505
 ;;21,"00093-1112-01 ")
 ;;1633
 ;;21,"00093-1112-10 ")
 ;;1634
 ;;21,"00093-1113-01 ")
 ;;1816
 ;;21,"00093-1113-10 ")
 ;;1817
 ;;21,"00093-1114-01 ")
 ;;2146
 ;;21,"00093-1114-10 ")
 ;;2147
 ;;21,"00093-1115-01 ")
 ;;2369
 ;;21,"00093-1115-05 ")
 ;;2370
 ;;21,"00093-5124-01 ")
 ;;6
 ;;21,"00093-5125-01 ")
 ;;80
 ;;21,"00093-5125-05 ")
 ;;81
 ;;21,"00093-5126-01 ")
 ;;179
 ;;21,"00093-5126-05 ")
 ;;180
 ;;21,"00093-5127-01 ")
 ;;251
 ;;21,"00093-5150-01 ")
 ;;2550
 ;;21,"00093-5157-01 ")
 ;;2308
 ;;21,"00093-5213-01 ")
 ;;4515
 ;;21,"00093-5214-01 ")
 ;;4520
 ;;21,"00093-5215-01 ")
 ;;4527
 ;;21,"00093-5456-98 ")
 ;;2596
 ;;21,"00093-5457-98 ")
 ;;2628
 ;;21,"00093-5458-98 ")
 ;;2665
 ;;21,"00093-5459-98 ")
 ;;2704
 ;;21,"00093-7222-10 ")
 ;;1272
 ;
OTHER ; OTHER ROUTINES
 D ^BGP47Y10
 D ^BGP47Y11
 D ^BGP47Y12
 D ^BGP47Y13
 D ^BGP47Y14
 D ^BGP47Y15
 D ^BGP47Y16
 D ^BGP47Y17
 D ^BGP47Y18
 D ^BGP47Y19
 D ^BGP47Y2
 D ^BGP47Y20
 D ^BGP47Y21
 D ^BGP47Y22
 D ^BGP47Y23
 D ^BGP47Y24
 D ^BGP47Y25
 D ^BGP47Y26
 D ^BGP47Y27
 D ^BGP47Y28
 D ^BGP47Y29
 D ^BGP47Y3
 D ^BGP47Y30
 D ^BGP47Y31
 D ^BGP47Y32
 D ^BGP47Y33
 D ^BGP47Y34
 D ^BGP47Y35
 D ^BGP47Y36
 D ^BGP47Y37
 D ^BGP47Y38
 D ^BGP47Y39
 D ^BGP47Y4
 D ^BGP47Y40
 D ^BGP47Y41
 D ^BGP47Y42
 D ^BGP47Y43
 D ^BGP47Y44
 D ^BGP47Y45
 D ^BGP47Y46
 D ^BGP47Y47
 D ^BGP47Y48
 D ^BGP47Y49
 D ^BGP47Y5
 D ^BGP47Y50
 D ^BGP47Y51
 D ^BGP47Y52
 D ^BGP47Y53
 D ^BGP47Y54
 D ^BGP47Y55
 D ^BGP47Y56
 D ^BGP47Y57
 D ^BGP47Y58
 D ^BGP47Y59
 D ^BGP47Y6
 D ^BGP47Y60
 D ^BGP47Y61
 D ^BGP47Y62
 D ^BGP47Y7
 D ^BGP47Y8
 D ^BGP47Y9
 Q