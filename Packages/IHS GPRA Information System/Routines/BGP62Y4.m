BGP62Y4 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON JAN 11, 2016;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"00409-6476-44 ")
 ;;2520
 ;;21,"00409-6478-44 ")
 ;;2518
 ;;21,"00409-6482-01 ")
 ;;2521
 ;;21,"00409-7332-01 ")
 ;;6781
 ;;21,"00409-7332-61 ")
 ;;6782
 ;;21,"00409-7333-04 ")
 ;;6783
 ;;21,"00409-7333-49 ")
 ;;6784
 ;;21,"00409-7334-10 ")
 ;;6821
 ;;21,"00409-7335-03 ")
 ;;6836
 ;;21,"00409-7335-61 ")
 ;;6837
 ;;21,"00409-7336-04 ")
 ;;6838
 ;;21,"00409-7336-49 ")
 ;;6839
 ;;21,"00409-7337-01 ")
 ;;6870
 ;;21,"00409-7338-01 ")
 ;;6906
 ;;21,"00430-0112-24 ")
 ;;6121
 ;;21,"00430-0112-96 ")
 ;;6122
 ;;21,"00430-0113-20 ")
 ;;6297
 ;;21,"00430-0114-20 ")
 ;;6303
 ;;21,"00430-0115-20 ")
 ;;6298
 ;;21,"00430-0115-95 ")
 ;;6299
 ;;21,"00430-2782-17 ")
 ;;1403
 ;;21,"00430-2783-17 ")
 ;;1536
 ;;21,"00440-1101-30 ")
 ;;480
 ;;21,"00440-2406-20 ")
 ;;5648
 ;;21,"00440-7101-30 ")
 ;;481
 ;;21,"00440-7105-30 ")
 ;;179
 ;;21,"00440-7108-20 ")
 ;;1219
 ;;21,"00440-7175-06 ")
 ;;2642
 ;;21,"00440-7240-28 ")
 ;;1589
 ;;21,"00440-7241-21 ")
 ;;1818
 ;;21,"00440-7290-06 ")
 ;;4180
 ;;21,"00440-7291-20 ")
 ;;4356
 ;;21,"00440-7300-30 ")
 ;;2223
 ;;21,"00440-7381-40 ")
 ;;3981
 ;;21,"00440-7483-92 ")
 ;;6139
 ;;21,"00440-7512-40 ")
 ;;3514
 ;;21,"00440-8050-40 ")
 ;;3619
 ;;21,"00440-8055-40 ")
 ;;3620
 ;;21,"00440-8056-20 ")
 ;;3766
 ;;21,"00440-8358-20 ")
 ;;5649
 ;;21,"00440-8406-03 ")
 ;;5650
 ;;21,"00440-8505-40 ")
 ;;6596
 ;;21,"00472-0850-10 ")
 ;;5912
 ;;21,"00472-1285-16 ")
 ;;5531
 ;;21,"00472-1285-33 ")
 ;;5532
 ;;21,"00480-7146-99 ")
 ;;2643
 ;;21,"00480-7169-99 ")
 ;;2784
 ;;21,"00490-0085-00 ")
 ;;5010
 ;;21,"00490-0085-30 ")
 ;;5011
 ;;21,"00490-0085-60 ")
 ;;5012
 ;;21,"00490-0085-90 ")
 ;;5013
 ;;21,"00517-8711-10 ")
 ;;6785
 ;;21,"00517-8722-10 ")
 ;;6840
 ;;21,"00517-8725-10 ")
 ;;6871
 ;;21,"00517-8750-10 ")
 ;;6907
 ;;21,"00527-1335-01 ")
 ;;6403
 ;;21,"00527-1336-01 ")
 ;;5913
 ;;21,"00527-1338-25 ")
 ;;6370
 ;;21,"00527-1338-50 ")
 ;;6371
 ;;21,"00527-1381-04 ")
 ;;2510
 ;;21,"00527-1382-01 ")
 ;;2224
 ;;21,"00527-1383-01 ")
 ;;2425
 ;;21,"00527-1383-02 ")
 ;;2426
 ;;21,"00527-1384-01 ")
 ;;4181
 ;;21,"00527-1385-01 ")
 ;;4357
 ;;21,"00527-1386-50 ")
 ;;4692
 ;;21,"00527-1442-01 ")
 ;;5579
 ;;21,"00527-1443-01 ")
 ;;5651
 ;;21,"00527-1443-05 ")
 ;;5652
 ;;21,"00527-1535-01 ")
 ;;6414
 ;;21,"00527-1537-30 ")
 ;;6390
 ;;21,"00555-0011-02 ")
 ;;6597
 ;;21,"00555-0011-05 ")
 ;;6598
 ;;21,"00555-0178-01 ")
 ;;6501
 ;;21,"00555-0178-02 ")
 ;;6502
 ;;21,"00555-0179-01 ")
 ;;6567
 ;;21,"00555-0179-02 ")
 ;;6568
 ;;21,"00555-0180-01 ")
 ;;6490
 ;;21,"00555-0180-02 ")
 ;;6491
 ;;21,"00555-0259-02 ")
 ;;3422
 ;;21,"00555-0259-04 ")
 ;;3423
 ;;21,"00555-0379-87 ")
 ;;4317
 ;;21,"00555-0380-87 ")
 ;;4679
 ;;21,"00555-0445-22 ")
 ;;3549
 ;;21,"00555-0445-23 ")
 ;;3550
 ;;21,"00555-0816-10 ")
 ;;4693
 ;;21,"00574-0129-01 ")
 ;;2512
 ;;21,"00591-0410-01 ")
 ;;6396
 ;;21,"00591-0411-50 ")
 ;;6353
 ;;21,"00591-2234-01 ")
 ;;6599
 ;;21,"00591-2234-10 ")
 ;;6600
 ;;21,"00591-2235-01 ")
 ;;6681
 ;;21,"00591-2235-10 ")
 ;;6682
 ;;21,"00591-2365-69 ")
 ;;1306
 ;;21,"00591-2404-01 ")
 ;;6408
 ;;21,"00591-2805-60 ")
 ;;3042
 ;;21,"00591-2932-01 ")
 ;;2427
 ;;21,"00591-3120-01 ")
 ;;2428
 ;;21,"00591-3120-16 ")
 ;;2429
 ;;21,"00591-3153-01 ")
 ;;6544
 ;;21,"00591-3224-15 ")
 ;;5363
 ;;21,"00591-3549-69 ")
 ;;1307
 ;;21,"00591-3550-57 ")
 ;;1336
 ;;21,"00591-3550-68 ")
 ;;1337
 ;;21,"00591-5440-05 ")
 ;;5948
 ;;21,"00591-5440-50 ")
 ;;5949
 ;;21,"00591-5535-50 ")
 ;;6308
 ;;21,"00591-5553-05 ")
 ;;6140
 ;;21,"00591-5553-50 ")
 ;;6141
 ;;21,"00591-5571-01 ")
 ;;2137
 ;;21,"00591-5694-01 ")
 ;;6512
 ;;21,"00591-5694-60 ")
 ;;6513
 ;;21,"00591-5695-50 ")
 ;;6431
 ;;21,"00591-5708-01 ")
 ;;2225
 ;;21,"00603-1684-58 ")
 ;;5533
 ;;21,"00603-1685-58 ")
 ;;5534
 ;;21,"00603-3480-19 ")
 ;;6309
 ;;21,"00603-3481-19 ")
 ;;5950
 ;;21,"00603-3481-28 ")
 ;;5951
 ;;21,"00603-3482-19 ")
 ;;6142
 ;;21,"00603-3482-28 ")
 ;;6143
 ;;21,"00603-5780-21 ")
 ;;5580
 ;;21,"00603-5780-28 ")
 ;;5581
 ;;21,"00603-5781-21 ")
 ;;5653
 ;;21,"00603-5781-28 ")
 ;;5654
 ;;21,"00603-6500-84 ")
 ;;99
 ;;21,"00603-8537-47 ")
 ;;5186
 ;;21,"00686-3145-09 ")
 ;;1590
 ;;21,"00703-0315-01 ")
 ;;6872
 ;;21,"00703-0315-03 ")
 ;;6873
 ;;21,"00703-0325-03 ")
 ;;6908
 ;;21,"00703-0335-04 ")
 ;;6786
 ;;21,"00703-0346-03 ")
 ;;6841
 ;;21,"00703-0359-01 ")
 ;;6822
 ;;21,"00703-0956-01 ")
 ;;4061
 ;;21,"00703-0956-03 ")
 ;;4062
 ;;21,"00703-0958-01 ")
 ;;4063
 ;;21,"00703-0958-03 ")
 ;;4064
 ;;21,"00703-0960-31 ")
 ;;4090
 ;;21,"00703-0960-36 ")
 ;;4091
 ;;21,"00703-0969-31 ")
 ;;4077
 ;;21,"00703-0969-36 ")
 ;;4078
 ;;21,"00703-9089-01 ")
 ;;2522
 ;;21,"00703-9503-01 ")
 ;;5505
 ;;21,"00703-9503-03 ")
 ;;5506
 ;;21,"00703-9514-01 ")
 ;;5507
 ;;21,"00703-9514-03 ")
 ;;5508
 ;;21,"00703-9526-01 ")
 ;;5509
 ;;21,"00777-0869-02 ")
 ;;1591
 ;;21,"00777-0869-20 ")
 ;;1592
 ;;21,"00777-0871-02 ")
 ;;1819
 ;;21,"00777-0871-20 ")
 ;;1820
 ;;21,"00781-1205-01 ")
 ;;3621
 ;;21,"00781-1205-10 ")
 ;;3622
 ;;21,"00781-1496-01 ")
 ;;2644
 ;;21,"00781-1496-31 ")
 ;;2645
 ;;21,"00781-1496-68 ")
 ;;2646
 ;;21,"00781-1496-69 ")
 ;;2647
 ;;21,"00781-1497-01 ")
 ;;2856
 ;;21,"00781-1497-31 ")
 ;;2857
 ;;21,"00781-1619-66 ")
 ;;930
 ;;21,"00781-1643-66 ")
 ;;1007
 ;;21,"00781-1655-01 ")
 ;;3767
 ;;21,"00781-1655-10 ")
 ;;3768
 ;;21,"00781-1831-20 ")
 ;;1069
 ;;21,"00781-1852-20 ")
 ;;1220
 ;;21,"00781-1874-31 ")
 ;;970
 ;;21,"00781-1941-31 ")
 ;;2785
 ;;21,"00781-1941-33 ")
 ;;2786
 ;;21,"00781-1943-39 ")
 ;;900
 ;;21,"00781-1943-82 ")
 ;;901
 ;;21,"00781-1961-60 ")
 ;;2891
 ;;21,"00781-1962-60 ")
 ;;2946
 ;;21,"00781-2020-01 ")
 ;;180
 ;;21,"00781-2020-05 ")
 ;;181
 ;;21,"00781-2020-31 ")
 ;;182
 ;;21,"00781-2020-76 ")
 ;;183
 ;;21,"00781-2112-01 ")
 ;;2226
 ;;21,"00781-2113-01 ")
 ;;2430
 ;;21,"00781-2113-17 ")
 ;;2431
 ;;21,"00781-2144-01 ")
 ;;785
 ;;21,"00781-2144-05 ")
 ;;786
 ;;21,"00781-2145-01 ")
 ;;847
 ;;21,"00781-2145-05 ")
 ;;848
 ;;21,"00781-2176-60 ")
 ;;7002
 ;;21,"00781-2176-64 ")
 ;;7003
 ;;21,"00781-2176-69 ")
 ;;7004
 ;;21,"00781-2248-01 ")
 ;;3911
 ;;21,"00781-2258-01 ")
 ;;3982
 ;;21,"00781-2268-60 ")
 ;;6342
 ;;21,"00781-2613-01 ")
 ;;482
 ;;21,"00781-2613-05 ")
 ;;483
 ;;21,"00781-2613-31 ")
 ;;484
 ;;21,"00781-2613-76 ")
 ;;485
 ;;21,"00781-2938-01 ")
 ;;1425
 ;;21,"00781-2938-50 ")
 ;;1426
 ;;21,"00781-3206-85 ")
 ;;6874
 ;;21,"00781-3206-95 ")
 ;;6875
 ;;21,"00781-3207-85 ")
 ;;6909
 ;;21,"00781-3207-95 ")
 ;;6910
 ;;21,"00781-3208-85 ")
 ;;6787
 ;;21,"00781-3208-95 ")
 ;;6788
 ;;21,"00781-3209-90 ")
 ;;6842
 ;;21,"00781-3209-95 ")
 ;;6843
 ;;21,"00781-3210-46 ")
 ;;6823
 ;;21,"00781-3239-09 ")
 ;;4079
 ;;21,"00781-3240-09 ")
 ;;4092
 ;;21,"00781-3288-09 ")
 ;;2183
 ;;21,"00781-3289-09 ")
 ;;2190
 ;;21,"00781-3289-91 ")
 ;;2191
 ;;21,"00781-3290-09 ")
 ;;2199
 ;;21,"00781-3338-70 ")
 ;;1368
 ;;21,"00781-3338-85 ")
 ;;1369
 ;;21,"00781-3341-09 ")
 ;;4113
 ;;21,"00781-3342-09 ")
 ;;4124
 ;;21,"00781-3342-46 ")
 ;;4125
 ;;21,"00781-3343-09 ")
 ;;4136
 ;;21,"00781-3343-55 ")
 ;;4137
 ;;21,"00781-3400-78 ")
 ;;36
 ;;21,"00781-3400-95 ")
 ;;37
 ;;21,"00781-3402-78 ")
 ;;59
 ;;21,"00781-3402-95 ")
 ;;60
 ;;21,"00781-3404-85 ")
 ;;7
 ;;21,"00781-3404-95 ")
 ;;8
 ;;21,"00781-3407-78 ")
 ;;70
 ;;21,"00781-3407-95 ")
 ;;71
 ;;21,"00781-3408-80 ")
 ;;44
 ;;21,"00781-3408-95 ")
 ;;45
 ;;21,"00781-3409-46 ")
 ;;23
 ;;21,"00781-3409-95 ")
 ;;24
 ;;21,"00781-3412-15 ")
 ;;9
 ;;21,"00781-3412-92 ")
 ;;10
 ;;21,"00781-3413-15 ")
 ;;46
 ;;21,"00781-3413-92 ")
 ;;47
 ;;21,"00781-3450-70 ")
 ;;1370
 ;;21,"00781-3450-95 ")
 ;;1371
 ;;21,"00781-3451-70 ")
 ;;1308
 ;;21,"00781-3451-96 ")
 ;;1309
 ;;21,"00781-3452-46 ")
 ;;1338
 ;;21,"00781-3452-95 ")
 ;;1339
 ;;21,"00781-3918-96 ")
 ;;5102
 ;;21,"00781-5043-01 ")
 ;;5272
 ;;21,"00781-5044-01 ")
 ;;5329
 ;;21,"00781-5044-50 ")
 ;;5330
 ;;21,"00781-5060-01 ")
 ;;706
 ;;21,"00781-5060-20 ")
 ;;707
 ;;21,"00781-5061-01 ")
 ;;725
 ;;21,"00781-5061-20 ")
 ;;726
 ;;21,"00781-5115-01 ")
 ;;5914
 ;;21,"00781-5385-01 ")
 ;;6503
 ;;21,"00781-5385-31 ")
 ;;6504
 ;;21,"00781-5386-01 ")
 ;;6569
 ;;21,"00781-5386-31 ")
 ;;6570
 ;;21,"00781-5387-01 ")
 ;;6492
 ;;21,"00781-5387-31 ")
 ;;6493
 ;;21,"00781-5438-20 ")
 ;;7067
 ;;21,"00781-5439-01 ")
 ;;7082
 ;;21,"00781-5439-20 ")
 ;;7083
 ;;21,"00781-5790-01 ")
 ;;4785
 ;;21,"00781-5790-50 ")
 ;;4786
 ;;21,"00781-5791-01 ")
 ;;4858
 ;;21,"00781-5791-50 ")
 ;;4859
 ;;21,"00781-5792-20 ")
 ;;4961
 ;;21,"00781-5792-50 ")
 ;;4962
 ;;21,"00781-6022-46 ")
 ;;2872
 ;;21,"00781-6022-52 ")
 ;;2873
 ;;21,"00781-6023-46 ")
 ;;2922
 ;;21,"00781-6023-52 ")
 ;;2923
 ;;21,"00781-6039-46 ")
 ;;100
 ;;21,"00781-6039-55 ")
 ;;101
 ;;21,"00781-6039-58 ")
 ;;102
 ;;21,"00781-6041-46 ")
 ;;388
 ;;21,"00781-6041-55 ")
 ;;389
 ;;21,"00781-6041-58 ")
 ;;390
 ;;21,"00781-6077-46 ")
 ;;6947
 ;;21,"00781-6077-61 ")
 ;;6948
 ;;21,"00781-6078-46 ")
 ;;6974
 ;;21,"00781-6078-61 ")
 ;;6975
 ;;21,"00781-6102-46 ")
 ;;941
 ;;21,"00781-6104-46 ")
 ;;1021
 ;;21,"00781-6120-46 ")
 ;;3603
 ;;21,"00781-6120-48 ")
 ;;3604
 ;;21,"00781-6121-46 ")
 ;;3723
 ;;21,"00781-6135-94 ")
 ;;3588
 ;;21,"00781-6135-95 ")
 ;;3589
 ;;21,"00781-6136-94 ")
 ;;3578
 ;;21,"00781-6139-48 ")
 ;;1180
 ;;21,"00781-6139-54 ")
 ;;1181
 ;;21,"00781-6139-57 ")
 ;;1182
 ;;21,"00781-6153-94 ")
 ;;3593
 ;;21,"00781-6153-95 ")
 ;;3594
 ;;21,"00781-6156-46 ")
 ;;146
 ;;21,"00781-6156-52 ")
 ;;147
 ;;21,"00781-6156-57 ")
 ;;148
 ;;21,"00781-6157-46 ")
 ;;432
 ;;21,"00781-6157-52 ")
 ;;433
 ;;21,"00781-6157-57 ")
 ;;434
 ;;21,"00781-6168-46 ")
 ;;7093
 ;;21,"00781-6168-52 ")
 ;;7094
 ;;21,"00781-6169-46 ")
 ;;7073
 ;;21,"00781-6169-52 ")
 ;;7074
 ;;21,"00781-6202-46 ")
 ;;5240
 ;;21,"00781-6202-57 ")
 ;;5241
 ;;21,"00781-6202-91 ")
 ;;5242
 ;;21,"00781-6203-46 ")
 ;;5292
 ;;21,"00781-6203-57 ")
 ;;5293
 ;;21,"00781-6203-91 ")
 ;;5294
 ;;21,"00781-9205-96 ")
 ;;5103
 ;;21,"00781-9206-96 ")
 ;;5067
 ;;21,"00781-9207-95 ")
 ;;5087
 ;;21,"00781-9220-09 ")
 ;;2184
 ;;21,"00781-9220-91 ")
 ;;2185
 ;;21,"00781-9221-09 ")
 ;;2192
 ;;21,"00781-9221-91 ")
 ;;2193
 ;;21,"00781-9222-09 ")
 ;;2200
 ;;21,"00781-9222-91 ")
 ;;2201
 ;;21,"00781-9327-85 ")
 ;;6911
 ;;21,"00781-9327-95 ")
 ;;6912
 ;;21,"00781-9328-95 ")
 ;;6789
 ;;21,"00781-9329-90 ")
 ;;6844
 ;;21,"00781-9330-46 ")
 ;;6824
 ;;21,"00781-9337-46 ")
 ;;1340
 ;;21,"00781-9337-95 ")
 ;;1341
 ;;21,"00781-9338-95 ")
 ;;1372
 ;;21,"00781-9339-85 ")
 ;;1310
 ;;21,"00781-9339-96 ")
 ;;1311
 ;;21,"00781-9404-95 ")
 ;;11
 ;;21,"00781-9407-78 ")
 ;;72
 ;;21,"00781-9407-95 ")
 ;;73
 ;;21,"00781-9408-95 ")
 ;;48
 ;;21,"00781-9409-46 ")
 ;;25
 ;;21,"00781-9409-95 ")
 ;;26
 ;;21,"00781-9409-96 ")
 ;;27
 ;;21,"00781-9412-92 ")
 ;;12
 ;;21,"00781-9413-92 ")
 ;;49
 ;;21,"00781-9451-96 ")
 ;;1312