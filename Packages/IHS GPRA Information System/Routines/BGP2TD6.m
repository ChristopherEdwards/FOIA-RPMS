BGP2TD6 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"51138-0336-30 ")
 ;;1671
 ;;21,"51138-0348-30 ")
 ;;3199
 ;;21,"51138-0349-30 ")
 ;;3105
 ;;21,"51138-0350-30 ")
 ;;3137
 ;;21,"51138-0351-30 ")
 ;;3170
 ;;21,"51138-0357-30 ")
 ;;690
 ;;21,"51138-0358-10 ")
 ;;700
 ;;21,"51138-0358-30 ")
 ;;701
 ;;21,"51138-0359-30 ")
 ;;713
 ;;21,"51138-0379-30 ")
 ;;981
 ;;21,"51138-0380-30 ")
 ;;743
 ;;21,"51138-0381-30 ")
 ;;823
 ;;21,"51138-0382-30 ")
 ;;914
 ;;21,"51138-0392-30 ")
 ;;282
 ;;21,"51138-0393-30 ")
 ;;211
 ;;21,"51138-0394-30 ")
 ;;235
 ;;21,"51138-0395-30 ")
 ;;261
 ;;21,"51138-0396-30 ")
 ;;982
 ;;21,"51138-0397-30 ")
 ;;742
 ;;21,"51138-0398-30 ")
 ;;824
 ;;21,"51138-0399-30 ")
 ;;913
 ;;21,"51138-0418-30 ")
 ;;58
 ;;21,"51138-0419-30 ")
 ;;81
 ;;21,"51138-0420-30 ")
 ;;135
 ;;21,"51138-0422-30 ")
 ;;15
 ;;21,"51138-0424-30 ")
 ;;3235
 ;;21,"51138-0425-30 ")
 ;;3333
 ;;21,"51138-0426-10 ")
 ;;3395
 ;;21,"51138-0426-30 ")
 ;;3396
 ;;21,"51138-0427-10 ")
 ;;3280
 ;;21,"51138-0427-30 ")
 ;;3281
 ;;21,"51138-0432-30 ")
 ;;57
 ;;21,"51138-0433-30 ")
 ;;80
 ;;21,"51138-0434-30 ")
 ;;134
 ;;21,"51138-0435-30 ")
 ;;14
 ;;21,"51138-0443-30 ")
 ;;368
 ;;21,"51138-0444-30 ")
 ;;343
 ;;21,"51138-0476-30 ")
 ;;3673
 ;;21,"51138-0477-30 ")
 ;;3569
 ;;21,"51138-0478-30 ")
 ;;3618
 ;;21,"51138-0493-30 ")
 ;;3887
 ;;21,"51138-0494-30 ")
 ;;3897
 ;;21,"51138-0505-15 ")
 ;;1059
 ;;21,"51138-0505-30 ")
 ;;1060
 ;;21,"51138-0506-30 ")
 ;;1153
 ;;21,"51138-0507-30 ")
 ;;1254
 ;;21,"51138-0508-20 ")
 ;;1013
 ;;21,"51138-0508-45 ")
 ;;1014
 ;;21,"51138-0515-30 ")
 ;;4067
 ;;21,"51138-0516-30 ")
 ;;4126
 ;;21,"51138-0517-30 ")
 ;;3991
 ;;21,"51138-0520-30 ")
 ;;1897
 ;;21,"51138-0521-30 ")
 ;;1970
 ;;21,"51138-0522-30 ")
 ;;2041
 ;;21,"51138-0531-10 ")
 ;;74
 ;;21,"51138-0531-30 ")
 ;;75
 ;;21,"51138-0532-10 ")
 ;;110
 ;;21,"51138-0532-30 ")
 ;;111
 ;;21,"51138-0533-10 ")
 ;;153
 ;;21,"51138-0533-30 ")
 ;;154
 ;;21,"51138-0534-10 ")
 ;;173
 ;;21,"51138-0534-30 ")
 ;;174
 ;;21,"51138-0535-10 ")
 ;;35
 ;;21,"51138-0535-30 ")
 ;;36
 ;;21,"51138-0536-10 ")
 ;;51
 ;;21,"51138-0536-30 ")
 ;;52
 ;;21,"51138-0551-30 ")
 ;;434
 ;;21,"51138-0552-30 ")
 ;;477
 ;;21,"51138-0553-30 ")
 ;;582
 ;;21,"51138-0554-30 ")
 ;;433
 ;;21,"51138-0555-30 ")
 ;;476
 ;;21,"51138-0556-30 ")
 ;;583
 ;;21,"51138-0573-30 ")
 ;;3423
 ;;21,"51138-0574-30 ")
 ;;3442
 ;;21,"51138-0575-10 ")
 ;;3464
 ;;21,"51138-0575-30 ")
 ;;3465
 ;;21,"51138-0576-30 ")
 ;;182
 ;;21,"51138-0577-20 ")
 ;;190
 ;;21,"51138-0577-30 ")
 ;;191
 ;;21,"51138-0578-10 ")
 ;;197
 ;;21,"51138-0578-30 ")
 ;;198
 ;;21,"51138-0579-10 ")
 ;;207
 ;;21,"51138-0579-20 ")
 ;;208
 ;;21,"51138-0579-30 ")
 ;;209
 ;;21,"51655-0278-25 ")
 ;;1241
 ;;21,"51655-0279-24 ")
 ;;1008
 ;;21,"51655-0286-24 ")
 ;;1838
 ;;21,"51655-0287-24 ")
 ;;1475
 ;;21,"51655-0311-25 ")
 ;;1126
 ;;21,"51655-0975-24 ")
 ;;1049
 ;;21,"51672-4037-01 ")
 ;;1548
 ;;21,"51672-4037-03 ")
 ;;1549
 ;;21,"51672-4038-01 ")
 ;;1817
 ;;21,"51672-4038-03 ")
 ;;1818
 ;;21,"51672-4039-01 ")
 ;;1450
 ;;21,"51672-4039-03 ")
 ;;1451
 ;;21,"51672-4040-01 ")
 ;;1669
 ;;21,"51672-4040-03 ")
 ;;1670
 ;;21,"51672-4045-01 ")
 ;;367
 ;;21,"51672-4046-01 ")
 ;;344
 ;;21,"52152-0238-08 ")
 ;;695
 ;;21,"52152-0238-30 ")
 ;;696
 ;;21,"52152-0239-08 ")
 ;;707
 ;;21,"52152-0239-30 ")
 ;;708
 ;;21,"52152-0240-08 ")
 ;;719
 ;;21,"52152-0240-30 ")
 ;;720
 ;;21,"52544-0668-01 ")
 ;;1550
 ;;21,"52544-0668-05 ")
 ;;1551
 ;;21,"52544-0669-01 ")
 ;;1815
 ;;21,"52544-0669-05 ")
 ;;1816
 ;;21,"52544-0670-01 ")
 ;;1448
 ;;21,"52544-0670-05 ")
 ;;1449
 ;;21,"52544-0671-01 ")
 ;;1667
 ;;21,"52959-0137-15 ")
 ;;432
 ;;21,"52959-0180-30 ")
 ;;1446
 ;;21,"52959-0180-60 ")
 ;;1447
 ;;21,"52959-0498-00 ")
 ;;475
 ;;21,"52959-0728-15 ")
 ;;2213
 ;;21,"52959-0728-20 ")
 ;;2214
 ;;21,"52959-0728-30 ")
 ;;2215
 ;;21,"52959-0728-90 ")
 ;;2216
 ;;21,"52959-0729-30 ")
 ;;2380
 ;;21,"52959-0729-60 ")
 ;;2381
 ;;21,"52959-0729-90 ")
 ;;2382
 ;;21,"52959-0753-00 ")
 ;;2759
 ;;21,"52959-0753-30 ")
 ;;2760
 ;;21,"52959-0756-30 ")
 ;;4382
 ;;21,"52959-0831-30 ")
 ;;820
 ;;21,"52959-0835-30 ")
 ;;908
 ;;21,"52959-0835-60 ")
 ;;909
 ;;21,"52959-0841-30 ")
 ;;744
 ;;21,"52959-0841-60 ")
 ;;745
 ;;21,"52959-0854-20 ")
 ;;2856
 ;;21,"52959-0854-30 ")
 ;;2857
 ;;21,"52959-0907-30 ")
 ;;262
 ;;21,"52959-0942-30 ")
 ;;1668
 ;;21,"52959-0973-30 ")
 ;;2352
 ;;21,"52959-0975-30 ")
 ;;2855
 ;;21,"52959-0997-30 ")
 ;;584
 ;;21,"53002-0431-00 ")
 ;;1150
 ;;21,"53002-0431-30 ")
 ;;1151
 ;;21,"53002-0431-60 ")
 ;;1152
 ;;21,"53002-1086-00 ")
 ;;1255
 ;;21,"53002-1086-03 ")
 ;;1256
 ;;21,"53002-1086-06 ")
 ;;1257
 ;;21,"53002-1123-00 ")
 ;;2210
 ;;21,"53002-1123-03 ")
 ;;2211
 ;;21,"53002-1123-06 ")
 ;;2212
 ;;21,"53002-1178-00 ")
 ;;2372
 ;;21,"53002-1178-03 ")
 ;;2373
 ;;21,"53002-1178-06 ")
 ;;2374
 ;;21,"53002-1225-00 ")
 ;;2852
 ;;21,"53002-1225-03 ")
 ;;2853
 ;;21,"53002-1225-06 ")
 ;;2854
 ;;21,"53002-1463-00 ")
 ;;2755
 ;;21,"53002-1463-03 ")
 ;;2756
 ;;21,"54348-0099-30 ")
 ;;983
 ;;21,"54348-0100-30 ")
 ;;741
 ;;21,"54458-0956-10 ")
 ;;910
 ;;21,"54458-0957-10 ")
 ;;819
 ;;21,"54458-0958-10 ")
 ;;740
 ;;21,"54458-0959-10 ")
 ;;984
 ;;21,"54458-0991-05 ")
 ;;580
 ;;21,"54458-0991-10 ")
 ;;581
 ;;21,"54458-0992-10 ")
 ;;478
 ;;21,"54458-0993-09 ")
 ;;435
 ;;21,"54458-0994-10 ")
 ;;2754
 ;;21,"54458-0995-10 ")
 ;;2656
 ;;21,"54458-0996-10 ")
 ;;2375
 ;;21,"54458-0997-10 ")
 ;;2209
 ;;21,"54458-0998-09 ")
 ;;2851
 ;;21,"54458-0999-09 ")
 ;;2349
 ;;21,"54569-0522-00 ")
 ;;1046
 ;;21,"54569-0522-01 ")
 ;;1047
 ;;21,"54569-0522-03 ")
 ;;1048
 ;;21,"54569-0523-00 ")
 ;;1124
 ;;21,"54569-0523-02 ")
 ;;1125
 ;;21,"54569-0606-00 ")
 ;;1839
 ;;21,"54569-0606-01 ")
 ;;1840
 ;;21,"54569-0607-00 ")
 ;;1476
 ;;21,"54569-0607-01 ")
 ;;1477
 ;;21,"54569-0612-00 ")
 ;;1692
 ;;21,"54569-1752-03 ")
 ;;2250
 ;;21,"54569-1944-00 ")
 ;;2285
 ;;21,"54569-1944-01 ")
 ;;2286
 ;;21,"54569-1944-02 ")
 ;;2287
 ;;21,"54569-1944-03 ")
 ;;2288
 ;;21,"54569-2051-01 ")
 ;;2591
 ;;21,"54569-2665-01 ")
 ;;2592
 ;;21,"54569-2665-02 ")
 ;;2593
 ;;21,"54569-3258-01 ")
 ;;1565
 ;;21,"54569-3300-00 ")
 ;;3024
 ;;21,"54569-3300-01 ")
 ;;3025
 ;;21,"54569-3359-00 ")
 ;;881
 ;;21,"54569-3359-01 ")
 ;;882
 ;;21,"54569-3359-02 ")
 ;;883
 ;;21,"54569-3423-00 ")
 ;;790
 ;;21,"54569-3423-01 ")
 ;;791
 ;;21,"54569-3423-04 ")
 ;;792
 ;;21,"54569-3713-00 ")
 ;;3299
 ;;21,"54569-3714-00 ")
 ;;3354
 ;;21,"54569-3733-02 ")
 ;;1001
 ;;21,"54569-3771-00 ")
 ;;3026
 ;;21,"54569-3808-00 ")
 ;;1903
 ;;21,"54569-3809-00 ")
 ;;1975
 ;;21,"54569-3984-00 ")
 ;;3097
 ;;21,"54569-3984-01 ")
 ;;3098
 ;;21,"54569-3985-00 ")
 ;;3127
 ;;21,"54569-4246-00 ")
 ;;1144
 ;;21,"54569-4246-01 ")
 ;;1145
 ;;21,"54569-4246-03 ")
 ;;1146
 ;;21,"54569-4246-04 ")
 ;;1147
 ;;21,"54569-4246-05 ")
 ;;1148
 ;;21,"54569-4246-07 ")
 ;;1149
 ;;21,"54569-4247-00 ")
 ;;1258
 ;;21,"54569-4247-02 ")
 ;;1259
 ;;21,"54569-4247-03 ")
 ;;1260
 ;;21,"54569-4247-04 ")
 ;;1261
 ;;21,"54569-4276-00 ")
 ;;3058
 ;;21,"54569-4437-00 ")
 ;;4066
 ;;21,"54569-4438-00 ")
 ;;4127
 ;;21,"54569-4438-01 ")
 ;;4128
 ;;21,"54569-4454-00 ")
 ;;3164
 ;;21,"54569-4572-00 ")
 ;;3932
 ;;21,"54569-4593-00 ")
 ;;1061
 ;;21,"54569-4593-01 ")
 ;;1062
 ;;21,"54569-4593-03 ")
 ;;1063
 ;;21,"54569-4596-00 ")
 ;;2847
 ;;21,"54569-4696-00 ")
 ;;112
 ;;21,"54569-4696-01 ")
 ;;113
 ;;21,"54569-4714-00 ")
 ;;3886
 ;;21,"54569-4719-00 ")
 ;;3903
 ;;21,"54569-4719-01 ")
 ;;3904
 ;;21,"54569-4721-00 ")
 ;;2364
 ;;21,"54569-4722-00 ")
 ;;3674
 ;;21,"54569-4722-01 ")
 ;;3675
 ;;21,"54569-4766-00 ")
 ;;3868
 ;;21,"54569-4766-01 ")
 ;;3869
 ;;21,"54569-4766-03 ")
 ;;3870
 ;;21,"54569-4767-00 ")
 ;;3777
 ;;21,"54569-4767-01 ")
 ;;3778
 ;;21,"54569-4767-03 ")
 ;;3779
 ;;21,"54569-4788-00 ")
 ;;957
 ;;21,"54569-4788-01 ")
 ;;958
 ;;21,"54569-4829-00 ")
 ;;474
 ;;21,"54569-4895-00 ")
 ;;3973
 ;;21,"54569-4948-00 ")
 ;;2046
 ;;21,"54569-4990-00 ")
 ;;3068
 ;;21,"54569-5132-00 ")
 ;;1553
 ;;21,"54569-5133-00 ")
 ;;1812
 ;;21,"54569-5133-01 ")
 ;;1813
 ;;21,"54569-5134-00 ")
 ;;1443
 ;;21,"54569-5134-01 ")
 ;;1444
 ;;21,"54569-5134-02 ")
 ;;1445
 ;;21,"54569-5135-00 ")
 ;;1665
 ;;21,"54569-5135-01 ")
 ;;1666
 ;;21,"54569-5232-00 ")
 ;;155
 ;;21,"54569-5232-01 ")
 ;;156
 ;;21,"54569-5282-00 ")
 ;;76
 ;;21,"54569-5283-00 ")
 ;;290
 ;;21,"54569-5284-00 ")
 ;;233
 ;;21,"54569-5284-01 ")
 ;;234
 ;;21,"54569-5285-00 ")
 ;;258
 ;;21,"54569-5286-00 ")
 ;;278
 ;;21,"54569-5361-00 ")
 ;;4381
 ;;21,"54569-5362-00 ")
 ;;4288
 ;;21,"54569-5379-00 ")
 ;;2371
 ;;21,"54569-5420-00 ")
 ;;3422
 ;;21,"54569-5421-00 ")
 ;;3441
 ;;21,"54569-5422-00 ")
 ;;3460
 ;;21,"54569-5434-00 ")
 ;;2205
 ;;21,"54569-5434-03 ")
 ;;2206
 ;;21,"54569-5434-04 ")
 ;;2207
 ;;21,"54569-5434-05 ")
 ;;2208
 ;;21,"54569-5435-00 ")
 ;;2376
 ;;21,"54569-5435-03 ")
 ;;2377
 ;;21,"54569-5435-04 ")
 ;;2378
 ;;21,"54569-5435-05 ")
 ;;2379
 ;;21,"54569-5437-00 ")
 ;;2350
 ;;21,"54569-5437-02 ")
 ;;2351
 ;;21,"54569-5438-00 ")
 ;;2849
 ;;21,"54569-5438-03 ")
 ;;2850
 ;;21,"54569-5472-00 ")
 ;;2757
 ;;21,"54569-5472-02 ")
 ;;2758
 ;;21,"54569-5601-00 ")
 ;;3766
 ;;21,"54569-5606-00 ")
 ;;4235
 ;;21,"54569-5621-00 ")
 ;;1894
 ;;21,"54569-5665-00 ")
 ;;3765
 ;;21,"54569-5666-00 ")
 ;;4337
 ;;21,"54569-5667-00 ")
 ;;3812
 ;;21,"54569-5667-01 ")
 ;;3813
 ;;21,"54569-5668-00 ")
 ;;737
 ;;21,"54569-5668-01 ")
 ;;738
 ;;21,"54569-5668-02 ")
 ;;739
 ;;21,"54569-5669-00 ")
 ;;821
 ;;21,"54569-5669-01 ")
 ;;822
 ;;21,"54569-5670-00 ")
 ;;911
 ;;21,"54569-5670-01 ")
 ;;912
 ;;21,"54569-5685-00 ")
 ;;259
 ;;21,"54569-5685-01 ")
 ;;260
 ;;21,"54569-5709-00 ")
 ;;3101
 ;;21,"54569-5710-00 ")
 ;;3132
 ;;21,"54569-5711-00 ")
 ;;3167
 ;;21,"54569-5728-00 ")
 ;;2653
 ;;21,"54569-5801-00 ")
 ;;3518
 ;;21,"54569-5867-00 ")
 ;;3983
 ;;21,"54569-5878-00 ")
 ;;37
 ;;21,"54569-5880-01 ")
 ;;3615
 ;;21,"54569-5903-00 ")
 ;;3749
 ;;21,"54569-5916-00 ")
 ;;3046
 ;;21,"54569-5936-00 ")
 ;;3241
 ;;21,"54569-5937-00 ")
 ;;79
 ;;21,"54569-5938-00 ")
 ;;133
 ;;21,"54569-5998-00 ")
 ;;3733
 ;;21,"54569-5999-00 ")
 ;;3568
 ;;21,"54569-6091-00 ")
 ;;430
 ;;21,"54569-6091-01 ")
 ;;431
 ;;21,"54569-6092-00 ")
 ;;479
 ;;21,"54569-6092-01 ")
 ;;480
 ;;21,"54569-6098-00 ")
 ;;2037
 ;;21,"54569-6110-01 ")
 ;;3839
 ;;21,"54569-6111-00 ")
 ;;3393
 ;;21,"54569-6111-01 ")
 ;;3394
 ;;21,"54569-6112-00 ")
 ;;3278
 ;;21,"54569-6112-01 ")
 ;;3279
 ;;21,"54569-6173-00 ")
 ;;4203
 ;;21,"54569-6173-01 ")
 ;;4204
 ;;21,"54569-6180-00 ")
 ;;3641
 ;;21,"54569-6180-01 ")
 ;;3642
 ;;21,"54569-6182-00 ")
 ;;3591
 ;;21,"54569-6182-01 ")
 ;;3592
 ;;21,"54569-6223-00 ")
 ;;3700
 ;;21,"54569-6228-00 ")
 ;;575
 ;;21,"54569-6273-00 ")
 ;;4412
 ;;21,"54569-6274-00 ")
 ;;4423
 ;;21,"54868-0009-00 ")
 ;;3535
 ;;21,"54868-0009-01 ")
 ;;3536
 ;;21,"54868-0541-00 ")
 ;;1693
 ;;21,"54868-0541-01 ")
 ;;1694
 ;;21,"54868-0541-03 ")
 ;;1695
 ;;21,"54868-0620-01 ")
 ;;1478
 ;;21,"54868-0620-02 ")
 ;;1479
 ;;21,"54868-0620-03 ")
 ;;1480
 ;;21,"54868-0620-05 ")
 ;;1481
 ;;21,"54868-0669-01 ")
 ;;1121
 ;;21,"54868-0669-02 ")
 ;;1122
 ;;21,"54868-0669-03 ")
 ;;1123
 ;;21,"54868-1001-01 ")
 ;;2594
 ;;21,"54868-1090-01 ")
 ;;1841
 ;;21,"54868-1090-05 ")
 ;;1842
 ;;21,"54868-1090-06 ")
 ;;1843
 ;;21,"54868-1296-01 ")
 ;;2283
 ;;21,"54868-1296-02 ")
 ;;2284
 ;;21,"54868-1415-01 ")
 ;;1240
 ;;21,"54868-1501-00 ")
 ;;2842
 ;;21,"54868-1501-01 ")
 ;;2843
 ;;21,"54868-1502-00 ")
 ;;2590
 ;;21,"54868-1775-01 ")
 ;;1044
 ;;21,"54868-1775-04 ")
 ;;1045
 ;;21,"54868-1802-00 ")
 ;;689
 ;;21,"54868-1960-00 ")
 ;;3023
 ;;21,"54868-1961-01 ")
 ;;3027
 ;;21,"54868-1961-02 ")
 ;;3028
 ;;21,"54868-1970-01 ")
 ;;2251
 ;;21,"54868-1970-02 ")
 ;;2252
 ;;21,"54868-1970-03 ")
 ;;2253
 ;;21,"54868-2280-00 ")
 ;;1566
 ;;21,"54868-2280-02 ")
 ;;1567
 ;;21,"54868-2335-00 ")
 ;;3989
 ;;21,"54868-2335-01 ")
 ;;3990
 ;;21,"54868-2350-00 ")
 ;;793
 ;;21,"54868-2350-01 ")
 ;;794
 ;;21,"54868-2350-02 ")
 ;;795
 ;;21,"54868-2350-03 ")
 ;;796
 ;;21,"54868-2350-04 ")
 ;;797
 ;;21,"54868-2351-00 ")
 ;;884
 ;;21,"54868-2351-01 ")
 ;;885
 ;;21,"54868-2351-02 ")
 ;;886
 ;;21,"54868-2351-03 ")
 ;;887
 ;;21,"54868-2352-00 ")
 ;;959
 ;;21,"54868-2352-01 ")
 ;;960
 ;;21,"54868-2368-00 ")
 ;;1904
 ;;21,"54868-2368-01 ")
 ;;1905
 ;;21,"54868-2368-02 ")
 ;;1906
 ;;21,"54868-2644-00 ")
 ;;3300
 ;;21,"54868-2644-01 ")
 ;;3301
 ;;21,"54868-2644-02 ")
 ;;3302
 ;;21,"54868-2645-00 ")
 ;;3355
 ;;21,"54868-2645-01 ")
 ;;3356
 ;;21,"54868-2645-02 ")
 ;;3357
