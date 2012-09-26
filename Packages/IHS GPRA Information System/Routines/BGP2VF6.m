BGP2VF6 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 08, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"49999-0538-30 ")
 ;;3121
 ;;21,"49999-0551-30 ")
 ;;535
 ;;21,"49999-0595-30 ")
 ;;4929
 ;;21,"49999-0596-30 ")
 ;;5116
 ;;21,"49999-0597-30 ")
 ;;3399
 ;;21,"49999-0599-15 ")
 ;;4762
 ;;21,"49999-0599-30 ")
 ;;4763
 ;;21,"49999-0599-60 ")
 ;;4764
 ;;21,"49999-0600-00 ")
 ;;1935
 ;;21,"49999-0600-15 ")
 ;;1936
 ;;21,"49999-0600-30 ")
 ;;1937
 ;;21,"49999-0601-15 ")
 ;;3669
 ;;21,"49999-0613-30 ")
 ;;3714
 ;;21,"49999-0618-30 ")
 ;;1860
 ;;21,"49999-0618-60 ")
 ;;1861
 ;;21,"49999-0619-30 ")
 ;;1902
 ;;21,"49999-0619-60 ")
 ;;1903
 ;;21,"49999-0627-00 ")
 ;;1981
 ;;21,"49999-0627-30 ")
 ;;1982
 ;;21,"49999-0627-60 ")
 ;;1983
 ;;21,"49999-0629-30 ")
 ;;2777
 ;;21,"49999-0630-30 ")
 ;;2878
 ;;21,"49999-0631-30 ")
 ;;3400
 ;;21,"49999-0631-60 ")
 ;;3401
 ;;21,"49999-0632-00 ")
 ;;3550
 ;;21,"49999-0632-30 ")
 ;;3551
 ;;21,"49999-0632-60 ")
 ;;3552
 ;;21,"49999-0654-00 ")
 ;;1299
 ;;21,"49999-0654-30 ")
 ;;1300
 ;;21,"49999-0690-30 ")
 ;;1140
 ;;21,"49999-0774-30 ")
 ;;823
 ;;21,"49999-0774-60 ")
 ;;824
 ;;21,"49999-0774-90 ")
 ;;825
 ;;21,"49999-0776-30 ")
 ;;4118
 ;;21,"49999-0776-50 ")
 ;;4119
 ;;21,"49999-0780-30 ")
 ;;3474
 ;;21,"49999-0789-30 ")
 ;;1141
 ;;21,"49999-0789-60 ")
 ;;1142
 ;;21,"49999-0789-90 ")
 ;;1143
 ;;21,"49999-0828-30 ")
 ;;3799
 ;;21,"49999-0860-30 ")
 ;;4231
 ;;21,"49999-0860-60 ")
 ;;4232
 ;;21,"49999-0861-30 ")
 ;;3970
 ;;21,"49999-0861-60 ")
 ;;3971
 ;;21,"49999-0861-90 ")
 ;;3972
 ;;21,"49999-0886-30 ")
 ;;2484
 ;;21,"49999-0909-00 ")
 ;;471
 ;;21,"49999-0909-30 ")
 ;;472
 ;;21,"49999-0913-30 ")
 ;;4485
 ;;21,"49999-0915-90 ")
 ;;3310
 ;;21,"49999-0918-30 ")
 ;;938
 ;;21,"49999-0965-30 ")
 ;;741
 ;;21,"49999-0965-60 ")
 ;;742
 ;;21,"50111-0433-01 ")
 ;;4610
 ;;21,"50111-0433-02 ")
 ;;4611
 ;;21,"50111-0433-03 ")
 ;;4612
 ;;21,"50111-0434-01 ")
 ;;4375
 ;;21,"50111-0434-02 ")
 ;;4376
 ;;21,"50111-0434-03 ")
 ;;4377
 ;;21,"50111-0441-01 ")
 ;;4486
 ;;21,"50111-0441-02 ")
 ;;4487
 ;;21,"50111-0523-03 ")
 ;;3882
 ;;21,"50111-0524-03 ")
 ;;3875
 ;;21,"50111-0647-01 ")
 ;;2067
 ;;21,"50111-0647-02 ")
 ;;2068
 ;;21,"50111-0647-03 ")
 ;;2069
 ;;21,"50111-0648-01 ")
 ;;2262
 ;;21,"50111-0648-02 ")
 ;;2263
 ;;21,"50111-0648-03 ")
 ;;2264
 ;;21,"50111-0648-10 ")
 ;;2265
 ;;21,"50111-0648-44 ")
 ;;2266
 ;;21,"50111-0930-10 ")
 ;;4120
 ;;21,"50111-0931-01 ")
 ;;4233
 ;;21,"50111-0931-02 ")
 ;;4234
 ;;21,"50111-0931-10 ")
 ;;4235
 ;;21,"50111-0932-01 ")
 ;;3973
 ;;21,"50111-0932-02 ")
 ;;3974
 ;;21,"50111-0932-10 ")
 ;;3975
 ;;21,"51079-0047-01 ")
 ;;826
 ;;21,"51079-0047-20 ")
 ;;827
 ;;21,"51079-0086-01 ")
 ;;2778
 ;;21,"51079-0086-20 ")
 ;;2779
 ;;21,"51079-0086-30 ")
 ;;2780
 ;;21,"51079-0086-56 ")
 ;;2781
 ;;21,"51079-0087-01 ")
 ;;2879
 ;;21,"51079-0087-20 ")
 ;;2880
 ;;21,"51079-0087-30 ")
 ;;2881
 ;;21,"51079-0087-56 ")
 ;;2882
 ;;21,"51079-0088-01 ")
 ;;2977
 ;;21,"51079-0088-20 ")
 ;;2978
 ;;21,"51079-0088-56 ")
 ;;2979
 ;;21,"51079-0107-01 ")
 ;;242
 ;;21,"51079-0107-19 ")
 ;;243
 ;;21,"51079-0107-20 ")
 ;;244
 ;;21,"51079-0107-63 ")
 ;;245
 ;;21,"51079-0109-01 ")
 ;;891
 ;;21,"51079-0109-03 ")
 ;;892
 ;;21,"51079-0131-01 ")
 ;;34
 ;;21,"51079-0131-20 ")
 ;;35
 ;;21,"51079-0131-63 ")
 ;;36
 ;;21,"51079-0133-01 ")
 ;;385
 ;;21,"51079-0133-20 ")
 ;;386
 ;;21,"51079-0133-63 ")
 ;;387
 ;;21,"51079-0134-01 ")
 ;;4871
 ;;21,"51079-0134-20 ")
 ;;4872
 ;;21,"51079-0135-01 ")
 ;;5037
 ;;21,"51079-0135-20 ")
 ;;5038
 ;;21,"51079-0136-01 ")
 ;;4765
 ;;21,"51079-0136-04 ")
 ;;4766
 ;;21,"51079-0147-01 ")
 ;;473
 ;;21,"51079-0147-20 ")
 ;;474
 ;;21,"51079-0391-20 ")
 ;;674
 ;;21,"51079-0392-01 ")
 ;;743
 ;;21,"51079-0392-20 ")
 ;;744
 ;;21,"51079-0427-01 ")
 ;;4613
 ;;21,"51079-0427-19 ")
 ;;4614
 ;;21,"51079-0427-20 ")
 ;;4615
 ;;21,"51079-0428-01 ")
 ;;4378
 ;;21,"51079-0428-19 ")
 ;;4379
 ;;21,"51079-0428-20 ")
 ;;4380
 ;;21,"51079-0436-01 ")
 ;;1577
 ;;21,"51079-0436-20 ")
 ;;1578
 ;;21,"51079-0437-01 ")
 ;;1666
 ;;21,"51079-0437-20 ")
 ;;1667
 ;;21,"51079-0438-01 ")
 ;;1750
 ;;21,"51079-0438-20 ")
 ;;1751
 ;;21,"51079-0480-01 ")
 ;;4930
 ;;21,"51079-0480-20 ")
 ;;4931
 ;;21,"51079-0482-01 ")
 ;;5117
 ;;21,"51079-0482-20 ")
 ;;5118
 ;;21,"51079-0482-30 ")
 ;;5119
 ;;21,"51079-0482-56 ")
 ;;5120
 ;;21,"51079-0563-01 ")
 ;;136
 ;;21,"51079-0563-20 ")
 ;;137
 ;;21,"51079-0564-01 ")
 ;;186
 ;;21,"51079-0564-20 ")
 ;;187
 ;;21,"51079-0645-01 ")
 ;;1813
 ;;21,"51079-0645-20 ")
 ;;1814
 ;;21,"51079-0651-01 ")
 ;;1625
 ;;21,"51079-0651-20 ")
 ;;1626
 ;;21,"51079-0762-01 ")
 ;;4121
 ;;21,"51079-0762-20 ")
 ;;4122
 ;;21,"51079-0763-01 ")
 ;;4236
 ;;21,"51079-0763-20 ")
 ;;4237
 ;;21,"51079-0764-01 ")
 ;;3976
 ;;21,"51079-0764-20 ")
 ;;3977
 ;;21,"51079-0774-01 ")
 ;;3553
 ;;21,"51079-0774-20 ")
 ;;3554
 ;;21,"51079-0775-01 ")
 ;;3800
 ;;21,"51079-0775-20 ")
 ;;3801
 ;;21,"51079-0803-01 ")
 ;;3122
 ;;21,"51079-0803-20 ")
 ;;3123
 ;;21,"51079-0804-01 ")
 ;;3221
 ;;21,"51079-0804-19 ")
 ;;3222
 ;;21,"51079-0804-20 ")
 ;;3223
 ;;21,"51079-0805-01 ")
 ;;3311
 ;;21,"51079-0805-20 ")
 ;;3312
 ;;21,"51079-0824-63 ")
 ;;3475
 ;;21,"51079-0825-63 ")
 ;;3670
 ;;21,"51079-0943-01 ")
 ;;939
 ;;21,"51079-0943-20 ")
 ;;940
 ;;21,"51079-0943-30 ")
 ;;941
 ;;21,"51079-0943-56 ")
 ;;942
 ;;21,"51079-0944-01 ")
 ;;582
 ;;21,"51079-0944-20 ")
 ;;583
 ;;21,"51079-0971-01 ")
 ;;2267
 ;;21,"51079-0971-19 ")
 ;;2268
 ;;21,"51079-0971-20 ")
 ;;2269
 ;;21,"51079-0992-01 ")
 ;;2577
 ;;21,"51079-0992-20 ")
 ;;2578
 ;;21,"51079-0993-01 ")
 ;;2547
 ;;21,"51079-0993-20 ")
 ;;2548
 ;;21,"51079-0997-01 ")
 ;;2070
 ;;21,"51079-0997-20 ")
 ;;2071
 ;;21,"51285-0538-02 ")
 ;;4714
 ;;21,"51285-0539-02 ")
 ;;4718
 ;;21,"51285-0554-02 ")
 ;;4712
 ;;21,"51285-0594-02 ")
 ;;3876
 ;;21,"51285-0595-02 ")
 ;;3883
 ;;21,"51285-0910-04 ")
 ;;1579
 ;;21,"51285-0911-04 ")
 ;;1668
 ;;21,"51285-0912-04 ")
 ;;1752
 ;;21,"51655-0062-24 ")
 ;;475
 ;;21,"51655-0082-24 ")
 ;;388
 ;;21,"51655-0121-24 ")
 ;;246
 ;;21,"51655-0121-25 ")
 ;;247
 ;;21,"51655-0148-51 ")
 ;;2629
 ;;21,"51655-0148-77 ")
 ;;2630
 ;;21,"51655-0223-51 ")
 ;;2674
 ;;21,"51655-0633-24 ")
 ;;37
 ;;21,"51655-0634-24 ")
 ;;4616
 ;;21,"51655-0662-24 ")
 ;;4238
 ;;21,"51655-0666-24 ")
 ;;4381
 ;;21,"51672-4001-05 ")
 ;;3124
 ;;21,"51672-4001-06 ")
 ;;3125
 ;;21,"51672-4002-05 ")
 ;;3224
 ;;21,"51672-4002-06 ")
 ;;3225
 ;;21,"51672-4003-05 ")
 ;;3313
 ;;21,"51672-4003-06 ")
 ;;3314
 ;;21,"51672-4004-05 ")
 ;;3357
 ;;21,"51672-4004-06 ")
 ;;3358
 ;;21,"51672-4011-01 ")
 ;;1384
 ;;21,"51672-4011-05 ")
 ;;1385
 ;;21,"51672-4011-06 ")
 ;;1386
 ;;21,"51672-4012-01 ")
 ;;1395
 ;;21,"51672-4012-05 ")
 ;;1396
 ;;21,"51672-4012-06 ")
 ;;1397
 ;;21,"51672-4013-01 ")
 ;;1405
 ;;21,"51672-4013-05 ")
 ;;1406
 ;;21,"51672-4013-06 ")
 ;;1407
 ;;21,"52152-0226-04 ")
 ;;2782
 ;;21,"52152-0226-30 ")
 ;;2783
 ;;21,"52152-0227-04 ")
 ;;2883
 ;;21,"52152-0227-30 ")
 ;;2884
 ;;21,"52152-0228-04 ")
 ;;2980
 ;;21,"52152-0228-30 ")
 ;;2981
 ;;21,"52152-0254-18 ")
 ;;2843
 ;;21,"52152-0255-18 ")
 ;;2949
 ;;21,"52152-0256-18 ")
 ;;3018
 ;;21,"52152-0293-08 ")
 ;;4715
 ;;21,"52152-0293-30 ")
 ;;4716
 ;;21,"52152-0294-08 ")
 ;;4719
 ;;21,"52152-0294-30 ")
 ;;4720
 ;;21,"52152-0341-02 ")
 ;;1418
 ;;21,"52152-0342-02 ")
 ;;1466
 ;;21,"52152-0342-04 ")
 ;;1467
 ;;21,"52152-0342-05 ")
 ;;1468
 ;;21,"52152-0343-02 ")
 ;;1532
 ;;21,"52152-0343-04 ")
 ;;1533
 ;;21,"52152-0343-05 ")
 ;;1534
 ;;21,"52152-0344-02 ")
 ;;1549
 ;;21,"52152-0344-04 ")
 ;;1550
 ;;21,"52152-0345-02 ")
 ;;1439
 ;;21,"52152-0345-04 ")
 ;;1440
 ;;21,"52152-0346-50 ")
 ;;1444
 ;;21,"52959-0008-02 ")
 ;;38
 ;;21,"52959-0008-15 ")
 ;;39
 ;;21,"52959-0008-20 ")
 ;;40
 ;;21,"52959-0008-30 ")
 ;;41
 ;;21,"52959-0008-40 ")
 ;;42
 ;;21,"52959-0008-60 ")
 ;;43
 ;;21,"52959-0008-90 ")
 ;;44
 ;;21,"52959-0010-00 ")
 ;;1144
 ;;21,"52959-0010-30 ")
 ;;1145
 ;;21,"52959-0010-60 ")
 ;;1146
 ;;21,"52959-0128-30 ")
 ;;1419
 ;;21,"52959-0128-60 ")
 ;;1420
 ;;21,"52959-0140-30 ")
 ;;4382
 ;;21,"52959-0140-60 ")
 ;;4383
 ;;21,"52959-0140-90 ")
 ;;4384
 ;;21,"52959-0163-30 ")
 ;;3226
 ;;21,"52959-0173-30 ")
 ;;1862
 ;;21,"52959-0233-00 ")
 ;;2270
 ;;21,"52959-0233-10 ")
 ;;2271
 ;;21,"52959-0233-14 ")
 ;;2272
 ;;21,"52959-0233-20 ")
 ;;2273
 ;;21,"52959-0233-30 ")
 ;;2274
 ;;21,"52959-0233-40 ")
 ;;2275
 ;;21,"52959-0233-50 ")
 ;;2276
 ;;21,"52959-0284-00 ")
 ;;476
 ;;21,"52959-0284-30 ")
 ;;477
 ;;21,"52959-0284-60 ")
 ;;478
 ;;21,"52959-0285-30 ")
 ;;745
 ;;21,"52959-0285-60 ")
 ;;746
 ;;21,"52959-0348-00 ")
 ;;248
 ;;21,"52959-0348-05 ")
 ;;249
 ;;21,"52959-0348-10 ")
 ;;250
 ;;21,"52959-0348-12 ")
 ;;251
 ;;21,"52959-0348-14 ")
 ;;252
 ;;21,"52959-0348-15 ")
 ;;253
 ;;21,"52959-0348-20 ")
 ;;254
 ;;21,"52959-0348-30 ")
 ;;255
 ;;21,"52959-0348-50 ")
 ;;256
 ;;21,"52959-0348-60 ")
 ;;257
 ;;21,"52959-0348-90 ")
 ;;258
 ;;21,"52959-0358-02 ")
 ;;3126
 ;;21,"52959-0358-20 ")
 ;;3127
 ;;21,"52959-0358-30 ")
 ;;3128
 ;;21,"52959-0358-60 ")
 ;;3129
 ;;21,"52959-0358-90 ")
 ;;3130
 ;;21,"52959-0359-02 ")
 ;;3227
 ;;21,"52959-0359-20 ")
 ;;3228
 ;;21,"52959-0359-30 ")
 ;;3229
 ;;21,"52959-0359-50 ")
 ;;3230
 ;;21,"52959-0359-60 ")
 ;;3231
 ;;21,"52959-0359-90 ")
 ;;3232
 ;;21,"52959-0360-12 ")
 ;;3555
 ;;21,"52959-0360-15 ")
 ;;3556
 ;;21,"52959-0360-20 ")
 ;;3557
 ;;21,"52959-0360-30 ")
 ;;3558
 ;;21,"52959-0360-60 ")
 ;;3559
 ;;21,"52959-0361-00 ")
 ;;4239
 ;;21,"52959-0361-14 ")
 ;;4240
 ;;21,"52959-0361-30 ")
 ;;4241
 ;;21,"52959-0361-60 ")
 ;;4242
 ;;21,"52959-0378-15 ")
 ;;4617
 ;;21,"52959-0378-20 ")
 ;;4618
 ;;21,"52959-0378-30 ")
 ;;4619
 ;;21,"52959-0378-60 ")
 ;;4620
 ;;21,"52959-0378-90 ")
 ;;4621
 ;;21,"52959-0388-30 ")
 ;;4767
 ;;21,"52959-0388-60 ")
 ;;4768
 ;;21,"52959-0458-14 ")
 ;;1469
 ;;21,"52959-0458-20 ")
 ;;1470
 ;;21,"52959-0458-30 ")
 ;;1471
 ;;21,"52959-0464-00 ")
 ;;1535
 ;;21,"52959-0464-12 ")
 ;;1536
 ;;21,"52959-0464-14 ")
 ;;1537
 ;;21,"52959-0464-20 ")
 ;;1538
 ;;21,"52959-0514-00 ")
 ;;389
 ;;21,"52959-0514-01 ")
 ;;390
 ;;21,"52959-0514-10 ")
 ;;391
 ;;21,"52959-0514-20 ")
 ;;392
 ;;21,"52959-0514-21 ")
 ;;393
 ;;21,"52959-0514-30 ")
 ;;394
 ;;21,"52959-0514-60 ")
 ;;395
 ;;21,"52959-0514-90 ")
 ;;396
 ;;21,"52959-0519-15 ")
 ;;3315
 ;;21,"52959-0519-30 ")
 ;;3316
 ;;21,"52959-0519-60 ")
 ;;3317
 ;;21,"52959-0537-30 ")
 ;;1580
 ;;21,"52959-0537-90 ")
 ;;1581
 ;;21,"52959-0541-10 ")
 ;;1669
 ;;21,"52959-0541-20 ")
 ;;1670
 ;;21,"52959-0541-30 ")
 ;;1671
 ;;21,"52959-0541-60 ")
 ;;1672
 ;;21,"52959-0542-14 ")
 ;;138
 ;;21,"52959-0542-15 ")
 ;;139
 ;;21,"52959-0542-21 ")
 ;;140
 ;;21,"52959-0542-28 ")
 ;;141
 ;;21,"52959-0542-30 ")
 ;;142
 ;;21,"52959-0542-40 ")
 ;;143
 ;;21,"52959-0542-42 ")
 ;;144
 ;;21,"52959-0550-30 ")
 ;;5039
 ;;21,"52959-0550-60 ")
 ;;5040
 ;;21,"52959-0638-04 ")
 ;;2517
 ;;21,"52959-0639-30 ")
 ;;3402
 ;;21,"52959-0655-00 ")
 ;;584
 ;;21,"52959-0655-02 ")
 ;;585
 ;;21,"52959-0655-30 ")
 ;;586
 ;;21,"52959-0655-40 ")
 ;;587
 ;;21,"52959-0655-60 ")
 ;;588
 ;;21,"52959-0655-90 ")
 ;;589
 ;;21,"52959-0662-30 ")
 ;;1753
 ;;21,"52959-0665-30 ")
 ;;2072
 ;;21,"52959-0669-30 ")
 ;;2073
 ;;21,"52959-0669-59 ")
 ;;2074
 ;;21,"52959-0669-60 ")
 ;;2075
 ;;21,"52959-0703-00 ")
 ;;1938
 ;;21,"52959-0703-30 ")
 ;;1939
 ;;21,"52959-0703-60 ")
 ;;1940
 ;;21,"52959-0704-00 ")
 ;;1984
 ;;21,"52959-0704-30 ")
 ;;1985
 ;;21,"52959-0704-60 ")
 ;;1986
 ;;21,"52959-0717-30 ")
 ;;2485
 ;;21,"52959-0732-00 ")
 ;;2277
 ;;21,"52959-0732-10 ")
 ;;2278
 ;;21,"52959-0732-14 ")
 ;;2279
 ;;21,"52959-0732-15 ")
 ;;2280
 ;;21,"52959-0732-20 ")
 ;;2281
 ;;21,"52959-0732-30 ")
 ;;2282
 ;;21,"52959-0732-40 ")
 ;;2283
 ;;21,"52959-0732-50 ")
 ;;2284
 ;;21,"52959-0732-60 ")
 ;;2285
 ;;21,"52959-0732-90 ")
 ;;2286
 ;;21,"52959-0771-60 ")
 ;;4873
 ;;21,"52959-0773-30 ")
 ;;1147
 ;;21,"52959-0773-52 ")
 ;;1148
 ;;21,"52959-0773-60 ")
 ;;1149
 ;;21,"52959-0774-30 ")
 ;;2784
 ;;21,"52959-0774-60 ")
 ;;2785
 ;;21,"52959-0775-30 ")
 ;;3403
 ;;21,"52959-0775-50 ")
 ;;3404
 ;;21,"52959-0775-60 ")
 ;;3405
 ;;21,"52959-0776-30 ")
 ;;3560
 ;;21,"52959-0776-60 ")
 ;;3561
 ;;21,"52959-0781-30 ")
 ;;3978
 ;;21,"52959-0781-60 ")
 ;;3979
 ;;21,"52959-0787-30 ")
 ;;4123
 ;;21,"52959-0791-30 ")
 ;;2631
 ;;21,"52959-0792-30 ")
 ;;3671
 ;;21,"52959-0805-60 ")
 ;;675
 ;;21,"52959-0806-30 ")
 ;;747
 ;;21,"52959-0806-60 ")
 ;;748
 ;;21,"52959-0818-30 ")
 ;;5121
 ;;21,"52959-0818-60 ")
 ;;5122
 ;;21,"52959-0820-60 ")
 ;;828
 ;;21,"52959-0840-60 ")
 ;;3359
