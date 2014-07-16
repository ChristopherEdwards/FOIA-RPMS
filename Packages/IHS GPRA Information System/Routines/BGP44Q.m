BGP44Q ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON SEP 11, 2013;
 ;;14.0;IHS CLINICAL REPORTING;;NOV 14, 2013;Build 101
 ;;BGP PQA BIGUANIDE NDC
 ;
 ; This routine loads Taxonomy BGP PQA BIGUANIDE NDC
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
 ;;21,"00003-4221-11 ")
 ;;879
 ;;21,"00003-4222-16 ")
 ;;878
 ;;21,"00003-4223-11 ")
 ;;880
 ;;21,"00006-0078-61 ")
 ;;897
 ;;21,"00006-0078-62 ")
 ;;898
 ;;21,"00006-0078-82 ")
 ;;899
 ;;21,"00006-0080-61 ")
 ;;900
 ;;21,"00006-0080-62 ")
 ;;901
 ;;21,"00006-0080-82 ")
 ;;902
 ;;21,"00006-0081-31 ")
 ;;903
 ;;21,"00006-0081-54 ")
 ;;904
 ;;21,"00006-0081-82 ")
 ;;905
 ;;21,"00006-0575-61 ")
 ;;886
 ;;21,"00006-0575-62 ")
 ;;887
 ;;21,"00006-0575-82 ")
 ;;888
 ;;21,"00006-0577-61 ")
 ;;889
 ;;21,"00006-0577-62 ")
 ;;890
 ;;21,"00006-0577-82 ")
 ;;891
 ;;21,"00087-6060-05 ")
 ;;11
 ;;21,"00087-6060-10 ")
 ;;12
 ;;21,"00087-6063-13 ")
 ;;704
 ;;21,"00087-6064-13 ")
 ;;828
 ;;21,"00087-6070-05 ")
 ;;317
 ;;21,"00087-6071-11 ")
 ;;494
 ;;21,"00087-6072-11 ")
 ;;946
 ;;21,"00087-6073-11 ")
 ;;976
 ;;21,"00087-6074-11 ")
 ;;1027
 ;;21,"00087-6081-31 ")
 ;;917
 ;;21,"00093-1048-01 ")
 ;;289
 ;;21,"00093-1048-10 ")
 ;;290
 ;;21,"00093-1048-98 ")
 ;;291
 ;;21,"00093-1049-01 ")
 ;;457
 ;;21,"00093-1049-10 ")
 ;;458
 ;;21,"00093-1049-98 ")
 ;;459
 ;;21,"00093-5049-06 ")
 ;;1106
 ;;21,"00093-5049-86 ")
 ;;1107
 ;;21,"00093-5050-06 ")
 ;;1120
 ;;21,"00093-5050-86 ")
 ;;1121
 ;;21,"00093-5710-01 ")
 ;;972
 ;;21,"00093-5710-05 ")
 ;;973
 ;;21,"00093-5711-01 ")
 ;;1015
 ;;21,"00093-5711-05 ")
 ;;1016
 ;;21,"00093-5711-19 ")
 ;;994
 ;;21,"00093-5711-93 ")
 ;;995
 ;;21,"00093-5712-01 ")
 ;;1068
 ;;21,"00093-5712-05 ")
 ;;1069
 ;;21,"00093-5712-19 ")
 ;;1057
 ;;21,"00093-5712-93 ")
 ;;1058
 ;;21,"00093-7212-01 ")
 ;;847
 ;;21,"00093-7214-01 ")
 ;;601
 ;;21,"00093-7214-10 ")
 ;;602
 ;;21,"00093-7214-98 ")
 ;;603
 ;;21,"00093-7267-01 ")
 ;;733
 ;;21,"00093-7267-10 ")
 ;;734
 ;;21,"00093-7455-01 ")
 ;;913
 ;;21,"00093-7456-01 ")
 ;;929
 ;;21,"00093-7457-01 ")
 ;;933
 ;;21,"00169-0092-01 ")
 ;;907
 ;;21,"00169-0093-01 ")
 ;;906
 ;;21,"00173-0837-18 ")
 ;;1130
 ;;21,"00173-0838-18 ")
 ;;1131
 ;;21,"00173-0839-18 ")
 ;;1135
 ;;21,"00173-0840-18 ")
 ;;1138
 ;;21,"00185-4416-01 ")
 ;;796
 ;;21,"00228-2751-11 ")
 ;;959
 ;;21,"00228-2751-50 ")
 ;;960
 ;;21,"00228-2752-11 ")
 ;;1008
 ;;21,"00228-2752-50 ")
 ;;1009
 ;;21,"00228-2753-11 ")
 ;;1094
 ;;21,"00228-2753-50 ")
 ;;1095
 ;;21,"00247-1443-30 ")
 ;;13
 ;;21,"00378-0234-01 ")
 ;;54
 ;;21,"00378-0234-05 ")
 ;;55
 ;;21,"00378-0240-01 ")
 ;;344
 ;;21,"00378-0244-01 ")
 ;;519
 ;;21,"00378-0350-01 ")
 ;;848
 ;;21,"00378-0352-01 ")
 ;;731
 ;;21,"00378-0352-05 ")
 ;;732
 ;;21,"00378-1550-91 ")
 ;;1101
 ;;21,"00378-1575-91 ")
 ;;1115
 ;;21,"00378-3131-01 ")
 ;;908
 ;;21,"00378-3132-01 ")
 ;;918
 ;;21,"00378-3133-01 ")
 ;;944
 ;;21,"00378-7185-05 ")
 ;;108
 ;;21,"00378-7186-05 ")
 ;;389
 ;;21,"00378-7187-05 ")
 ;;553
 ;;21,"00406-2028-01 ")
 ;;286
 ;;21,"00406-2028-05 ")
 ;;287
 ;;21,"00406-2028-10 ")
 ;;288
 ;;21,"00406-2029-01 ")
 ;;460
 ;;21,"00406-2029-05 ")
 ;;461
 ;;21,"00406-2029-10 ")
 ;;462
 ;;21,"00406-2030-05 ")
 ;;633
 ;;21,"00406-2030-10 ")
 ;;634
 ;;21,"00440-7562-95 ")
 ;;1
 ;;21,"00440-7585-90 ")
 ;;971
 ;;21,"00440-7587-90 ")
 ;;1020
 ;;21,"00440-7589-90 ")
 ;;1066
 ;;21,"00440-7589-95 ")
 ;;1065
 ;;21,"00440-7739-14 ")
 ;;201
 ;;21,"00440-7739-60 ")
 ;;202
 ;;21,"00440-7739-90 ")
 ;;203
 ;;21,"00440-7739-92 ")
 ;;204
 ;;21,"00440-7739-94 ")
 ;;205
 ;;21,"00440-7739-95 ")
 ;;206
 ;;21,"00440-7745-90 ")
 ;;440
 ;;21,"00440-7745-92 ")
 ;;441
 ;;21,"00440-7746-90 ")
 ;;665
 ;;21,"00440-7746-92 ")
 ;;666
 ;;21,"00440-7748-90 ")
 ;;749
 ;;21,"00440-7748-92 ")
 ;;750
 ;;21,"00591-2719-60 ")
 ;;860
 ;;21,"00591-2720-60 ")
 ;;864
 ;;21,"00591-3971-01 ")
 ;;914
 ;;21,"00591-3972-01 ")
 ;;928
 ;;21,"00591-3973-01 ")
 ;;934
 ;;21,"00597-0146-18 ")
 ;;872
 ;;21,"00597-0146-60 ")
 ;;873
 ;;21,"00597-0147-18 ")
 ;;874
 ;;21,"00597-0147-60 ")
 ;;875
 ;;21,"00597-0148-18 ")
 ;;876
 ;;21,"00597-0148-60 ")
 ;;877
 ;;21,"00603-4467-21 ")
 ;;117
 ;;21,"00603-4467-28 ")
 ;;118
 ;;21,"00603-4467-32 ")
 ;;119
 ;;21,"00603-4468-21 ")
 ;;463
 ;;21,"00603-4468-28 ")
 ;;464
 ;;21,"00603-4468-32 ")
 ;;465
 ;;21,"00603-4469-21 ")
 ;;630
 ;;21,"00603-4469-28 ")
 ;;631
 ;;21,"00603-4469-32 ")
 ;;632
 ;;21,"00781-5050-01 ")
 ;;80
 ;;21,"00781-5050-05 ")
 ;;81
 ;;21,"00781-5050-10 ")
 ;;14
 ;;21,"00781-5050-61 ")
 ;;15
 ;;21,"00781-5051-01 ")
 ;;319
 ;;21,"00781-5051-05 ")
 ;;320
 ;;21,"00781-5051-61 ")
 ;;321
 ;;21,"00781-5052-01 ")
 ;;495
 ;;21,"00781-5052-05 ")
 ;;496
 ;;21,"00781-5052-61 ")
 ;;497
 ;;21,"00781-5626-60 ")
 ;;1108
 ;;21,"00781-5627-60 ")
 ;;1122
 ;;21,"00904-5849-14 ")
 ;;120
 ;;21,"00904-5849-18 ")
 ;;121
 ;;21,"00904-5849-40 ")
 ;;122
 ;;21,"00904-5849-52 ")
 ;;123
 ;;21,"00904-5849-53 ")
 ;;124
 ;;21,"00904-5849-54 ")
 ;;125
 ;;21,"00904-5849-80 ")
 ;;126
 ;;21,"00904-5849-89 ")
 ;;127
 ;;21,"00904-5849-93 ")
 ;;128
 ;;21,"00904-5850-40 ")
 ;;380
 ;;21,"00904-5850-52 ")
 ;;381
 ;;21,"00904-5850-53 ")
 ;;382
 ;;21,"00904-5850-89 ")
 ;;383
 ;;21,"00904-5850-93 ")
 ;;384
 ;;21,"00904-5851-40 ")
 ;;558
 ;;21,"00904-5851-52 ")
 ;;559
 ;;21,"00904-5851-89 ")
 ;;560
 ;;21,"00904-5851-93 ")
 ;;521
 ;;21,"00904-6090-61 ")
 ;;56
 ;;21,"00904-6091-61 ")
 ;;343
 ;;21,"00904-6092-61 ")
 ;;520
 ;;21,"00904-6107-40 ")
 ;;794
 ;;21,"00904-6107-61 ")
 ;;795
 ;;21,"00904-6108-60 ")
 ;;835
 ;;21,"00904-6108-61 ")
 ;;836
 ;;21,"10544-0058-30 ")
 ;;600
 ;;21,"10544-0253-30 ")
 ;;583
 ;;21,"10544-0254-30 ")
 ;;76
 ;;21,"10544-0255-30 ")
 ;;367
 ;;21,"10631-0206-01 ")
 ;;701
 ;;21,"10631-0206-02 ")
 ;;702
 ;;21,"13411-0163-02 ")
 ;;16
 ;;21,"13411-0163-03 ")
 ;;17
 ;;21,"13411-0163-06 ")
 ;;18
 ;;21,"13411-0163-09 ")
 ;;19
 ;;21,"13411-0163-10 ")
 ;;20
 ;;21,"13411-0164-02 ")
 ;;318
 ;;21,"13411-0164-03 ")
 ;;390
 ;;21,"13411-0164-06 ")
 ;;391
 ;;21,"13411-0164-09 ")
 ;;392
 ;;21,"13411-0164-10 ")
 ;;393
 ;;21,"13668-0280-33 ")
 ;;1102
 ;;21,"13668-0280-60 ")
 ;;1103
 ;;21,"13668-0281-33 ")
 ;;1116
 ;;21,"13668-0281-60 ")
 ;;1117
 ;;21,"13913-0002-13 ")
 ;;706
 ;;21,"13913-0003-16 ")
 ;;869
 ;;21,"14565-0202-10 ")
 ;;787
 ;;21,"14565-0202-50 ")
 ;;788
 ;;21,"16590-0313-30 ")
 ;;21
 ;;21,"16590-0313-60 ")
 ;;22
 ;;21,"16590-0313-72 ")
 ;;23
 ;;21,"16590-0313-82 ")
 ;;24
 ;;21,"16590-0313-90 ")
 ;;25
 ;;21,"16590-0397-30 ")
 ;;498
 ;;21,"16590-0397-60 ")
 ;;499
 ;;21,"16590-0397-90 ")
 ;;500
 ;;21,"20091-0531-01 ")
 ;;82
 ;;21,"20091-0531-05 ")
 ;;83
 ;;21,"20091-0531-10 ")
 ;;84
 ;;21,"20091-0533-01 ")
 ;;361
 ;;21,"20091-0533-05 ")
 ;;362
 ;;21,"20091-0533-10 ")
 ;;363
 ;;21,"20091-0535-01 ")
 ;;580
 ;;21,"20091-0535-05 ")
 ;;581
 ;;21,"20091-0535-10 ")
 ;;582
 ;;21,"21695-0471-00 ")
 ;;57
 ;;21,"21695-0471-30 ")
 ;;58
 ;;21,"21695-0471-60 ")
 ;;59
 ;;21,"21695-0471-72 ")
 ;;60
 ;;21,"21695-0471-78 ")
 ;;61
 ;;21,"21695-0471-90 ")
 ;;62
 ;;21,"21695-0472-30 ")
 ;;341
 ;;21,"21695-0472-60 ")
 ;;342
 ;;21,"21695-0473-00 ")
 ;;522
 ;;21,"21695-0473-30 ")
 ;;523
 ;;21,"21695-0473-60 ")
 ;;627
 ;;21,"21695-0473-78 ")
 ;;628
 ;;21,"21695-0473-90 ")
 ;;629
 ;;21,"21695-0568-30 ")
 ;;1090
 ;;21,"21695-0568-60 ")
 ;;1035
 ;;21,"21695-0828-30 ")
 ;;735
 ;;21,"21695-0828-60 ")
 ;;736
 ;;21,"21695-0828-90 ")
 ;;737
 ;;21,"21695-0894-00 ")
 ;;932
 ;;21,"23155-0102-01 ")
 ;;207
 ;;21,"23155-0102-05 ")
 ;;208
 ;;21,"23155-0102-10 ")
 ;;209
 ;;21,"23155-0103-01 ")
 ;;437
 ;;21,"23155-0103-05 ")
 ;;438
 ;;21,"23155-0103-10 ")
 ;;439
 ;;21,"23155-0104-01 ")
 ;;667
 ;;21,"23155-0104-05 ")
 ;;668
 ;;21,"23155-0104-10 ")
 ;;669
 ;;21,"23155-0115-01 ")
 ;;915
 ;;21,"23155-0116-01 ")
 ;;926
 ;;21,"23155-0117-01 ")
 ;;936
 ;;21,"23155-0233-01 ")
 ;;954
 ;;21,"23155-0233-05 ")
 ;;955
 ;;21,"23155-0234-01 ")
 ;;1006
 ;;21,"23155-0234-05 ")
 ;;1007
 ;;21,"23155-0235-01 ")
 ;;1036
 ;;21,"23155-0235-05 ")
 ;;1037
 ;;21,"23490-6838-01 ")
 ;;246
 ;;21,"23490-6838-02 ")
 ;;247
 ;;21,"23490-6838-03 ")
 ;;248
 ;;21,"23490-6838-04 ")
 ;;249
 ;;21,"23490-6838-09 ")
 ;;250
 ;;21,"23490-6839-01 ")
 ;;482
 ;;21,"23490-6839-02 ")
 ;;483
 ;;21,"23490-7260-01 ")
 ;;524
 ;;21,"23490-7260-02 ")
 ;;525
 ;;21,"23490-7260-03 ")
 ;;526
 ;;21,"23490-7260-04 ")
 ;;527
 ;;21,"23490-7448-03 ")
 ;;996
 ;;21,"23490-7448-06 ")
 ;;997
 ;;21,"23490-7449-01 ")
 ;;1067
 ;;21,"23490-7449-06 ")
 ;;1059
 ;;21,"23490-7449-09 ")
 ;;1060
 ;;21,"23490-7458-03 ")
 ;;789
 ;;21,"23490-7458-06 ")
 ;;790
 ;;21,"23490-7458-07 ")
 ;;791
 ;;21,"23490-7458-12 ")
 ;;792
 ;;21,"23490-7458-16 ")
 ;;793
 ;;21,"29033-0018-01 ")
 ;;746
 ;;21,"29033-0018-05 ")
 ;;747
 ;;21,"29033-0018-10 ")
 ;;748
 ;;21,"29033-0021-01 ")
 ;;846
 ;;21,"33261-0145-02 ")
 ;;596
 ;;21,"33261-0145-30 ")
 ;;597
 ;;21,"33261-0145-60 ")
 ;;598
 ;;21,"33261-0145-90 ")
 ;;599
 ;;21,"33261-0157-02 ")
 ;;242
 ;;21,"33261-0157-30 ")
 ;;243
 ;;21,"33261-0157-60 ")
 ;;244
 ;;21,"33261-0157-90 ")
 ;;245
 ;;21,"33261-0372-30 ")
 ;;784
 ;;21,"33261-0372-60 ")
 ;;785
 ;;21,"33261-0372-90 ")
 ;;786
 ;;21,"33261-0821-30 ")
 ;;1003
 ;;21,"33261-0821-60 ")
 ;;1004
 ;;21,"33261-0821-90 ")
 ;;1005
 ;;21,"33358-0234-00 ")
 ;;97
 ;;21,"33358-0234-30 ")
 ;;98
 ;;21,"33358-0234-60 ")
 ;;99
 ;;21,"33358-0235-60 ")
 ;;827
 ;;21,"33358-0236-30 ")
 ;;368
 ;;21,"33358-0236-60 ")
 ;;369
 ;;21,"33358-0237-30 ")
 ;;551
 ;;21,"33358-0237-60 ")
 ;;552
 ;;21,"35356-0130-60 ")
 ;;1112
 ;;21,"35356-0136-60 ")
 ;;882
 ;;21,"35356-0269-28 ")
 ;;770
 ;;21,"35356-0691-60 ")
 ;;69
 ;;21,"35356-0792-30 ")
 ;;44
 ;;21,"35356-0886-30 ")
 ;;670
 ;;21,"35356-0886-60 ")
 ;;671
 ;;21,"35356-0886-90 ")
 ;;672
 ;;21,"35356-0897-30 ")
 ;;1002
 ;;21,"35356-0922-60 ")
 ;;425
 ;;21,"35356-0932-30 ")
 ;;956
 ;;21,"35356-0932-60 ")
 ;;957
 ;;21,"35356-0932-90 ")
 ;;958
 ;;21,"35356-0959-30 ")
 ;;426
 ;;21,"35356-0959-60 ")
 ;;427
 ;;21,"35356-0959-90 ")
 ;;428
 ;;21,"35356-0970-30 ")
 ;;910
 ;;21,"35356-0970-60 ")
 ;;911
 ;;21,"35356-0970-90 ")
 ;;912
 ;;21,"42254-0071-30 ")
 ;;986
 ;;21,"42291-0605-10 ")
 ;;109
 ;;21,"42291-0605-12 ")
 ;;110
 ;;21,"42291-0605-18 ")
 ;;111
 ;;21,"42291-0605-27 ")
 ;;112
 ;;21,"42291-0605-36 ")
 ;;113
 ;;21,"42291-0605-45 ")
 ;;114
 ;;21,"42291-0605-60 ")
 ;;115
 ;;21,"42291-0605-90 ")
 ;;116
 ;;21,"42291-0606-10 ")
 ;;385
 ;;21,"42291-0606-18 ")
 ;;386
 ;;21,"42291-0606-27 ")
 ;;387
 ;;21,"42291-0606-90 ")
 ;;388
 ;;21,"42291-0607-10 ")
 ;;554
 ;;21,"42291-0607-18 ")
 ;;555
 ;;21,"42291-0607-60 ")
 ;;556
 ;;21,"42291-0607-90 ")
 ;;557
 ;;21,"42291-0610-18 ")
 ;;824
 ;;21,"42291-0610-36 ")
 ;;825
 ;;21,"42291-0610-90 ")
 ;;826
 ;;21,"42291-0611-18 ")
 ;;838
 ;;21,"42291-0612-10 ")
 ;;100
 ;;21,"42291-0612-12 ")
 ;;101
 ;;21,"42291-0612-18 ")
 ;;102
 ;;21,"42291-0612-27 ")
 ;;103
 ;;21,"42291-0612-36 ")
 ;;104
 ;;21,"42291-0612-45 ")
 ;;105
 ;;21,"42291-0612-60 ")
 ;;106
 ;;21,"42291-0612-90 ")
 ;;107
 ;;21,"42291-0613-10 ")
 ;;370
 ;;21,"42291-0613-18 ")
 ;;371
 ;;21,"42291-0613-27 ")
 ;;372
 ;;21,"42291-0613-90 ")
 ;;373
 ;;21,"42291-0614-10 ")
 ;;549
 ;;21,"42291-0614-18 ")
 ;;550
 ;;21,"42291-0614-60 ")
 ;;635
 ;;21,"42291-0614-90 ")
 ;;636
 ;;21,"43063-0012-01 ")
 ;;251
 ;;21,"43063-0012-60 ")
 ;;252
 ;;21,"43063-0012-86 ")
 ;;253
 ;;21,"43063-0012-90 ")
 ;;254
 ;;21,"43063-0012-93 ")
 ;;255
 ;;21,"43063-0012-94 ")
 ;;256
 ;;21,"43063-0372-30 ")
 ;;837
 ;;21,"43063-0397-86 ")
 ;;1056
 ;;21,"43063-0428-90 ")
 ;;781
 ;;21,"43063-0428-93 ")
 ;;782
 ;;21,"43063-0428-94 ")
 ;;783
 ;;21,"43063-0429-93 ")
 ;;339
 ;;21,"43063-0429-94 ")
 ;;340
 ;;21,"43063-0430-30 ")
 ;;528
 ;;21,"43063-0430-60 ")
 ;;529
 ;;21,"43063-0430-90 ")
 ;;530
 ;;21,"43063-0430-93 ")
 ;;531
 ;;21,"43063-0430-94 ")
 ;;532
 ;;21,"43063-0430-98 ")
 ;;533
 ;;21,"43353-0340-30 ")
 ;;218
 ;;21,"43353-0340-53 ")
 ;;219
 ;;21,"43353-0340-60 ")
 ;;220
 ;;21,"43353-0340-70 ")
 ;;221
 ;;21,"43353-0340-75 ")
 ;;222
 ;;21,"43353-0340-80 ")
 ;;223
 ;;21,"43353-0340-92 ")
 ;;224
 ;;21,"43353-0340-94 ")
 ;;225
 ;;21,"43353-0340-96 ")
 ;;226
 ;;21,"43353-0344-53 ")
 ;;421
 ;;21,"43353-0344-60 ")
 ;;422
 ;;21,"43353-0344-80 ")
 ;;423
 ;;21,"43353-0344-92 ")
 ;;424
 ;;21,"43353-0349-30 ")
 ;;681
 ;;21,"43353-0349-45 ")
 ;;682
 ;;21,"43353-0349-53 ")
 ;;683
 ;;21,"43353-0349-60 ")
 ;;684
 ;;21,"43353-0349-73 ")
 ;;685
 ;;21,"43353-0349-80 ")
 ;;686
 ;;21,"43353-0349-86 ")
 ;;687
 ;;21,"43353-0477-30 ")
 ;;278
 ;;21,"43353-0477-53 ")
 ;;279
 ;
OTHER ; OTHER ROUTINES
 D ^BGP44Q10
 D ^BGP44Q11
 D ^BGP44Q12
 D ^BGP44Q13
 D ^BGP44Q14
 D ^BGP44Q2
 D ^BGP44Q3
 D ^BGP44Q4
 D ^BGP44Q5
 D ^BGP44Q6
 D ^BGP44Q7
 D ^BGP44Q8
 D ^BGP44Q9
 Q