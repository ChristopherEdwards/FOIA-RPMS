BGP7LXOC ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 29, 2006 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"60809-0500-55 ")
 ;;455
 ;;21,"60809-0500-72 ")
 ;;456
 ;;21,"61570-0073-05 ")
 ;;574
 ;;21,"62584-0802-01 ")
 ;;806
 ;;21,"62584-0802-33 ")
 ;;807
 ;;21,"62584-0803-01 ")
 ;;812
 ;;21,"62584-0919-01 ")
 ;;457
 ;;21,"62584-0919-85 ")
 ;;458
 ;;21,"63304-0677-01 ")
 ;;171
 ;;21,"63739-0185-02 ")
 ;;808
 ;;21,"63739-0215-01 ")
 ;;459
 ;;21,"63739-0215-03 ")
 ;;460
 ;;21,"63739-0215-15 ")
 ;;461
 ;;21,"63874-0201-01 ")
 ;;858
 ;;21,"63874-0201-03 ")
 ;;462
 ;;21,"63874-0201-04 ")
 ;;859
 ;;21,"63874-0201-05 ")
 ;;860
 ;;21,"63874-0201-08 ")
 ;;861
 ;;21,"63874-0201-10 ")
 ;;862
 ;;21,"63874-0201-12 ")
 ;;463
 ;;21,"63874-0201-14 ")
 ;;863
 ;;21,"63874-0201-15 ")
 ;;464
 ;;21,"63874-0201-16 ")
 ;;864
 ;;21,"63874-0201-18 ")
 ;;865
 ;;21,"63874-0201-20 ")
 ;;465
 ;;21,"63874-0201-21 ")
 ;;866
 ;;21,"63874-0201-24 ")
 ;;867
 ;;21,"63874-0201-25 ")
 ;;868
 ;;21,"63874-0201-28 ")
 ;;869
 ;;21,"63874-0201-30 ")
 ;;466
 ;;21,"63874-0201-35 ")
 ;;870
 ;;21,"63874-0201-36 ")
 ;;871
 ;;21,"63874-0201-40 ")
 ;;872
 ;;21,"63874-0201-42 ")
 ;;873
 ;;21,"63874-0201-45 ")
 ;;874
 ;;21,"63874-0201-48 ")
 ;;875
 ;;21,"63874-0201-50 ")
 ;;467
 ;;21,"63874-0201-56 ")
 ;;876
 ;;21,"63874-0201-60 ")
 ;;877
 ;;21,"63874-0201-71 ")
 ;;878
 ;;21,"63874-0201-72 ")
 ;;879
 ;;21,"63874-0201-74 ")
 ;;880
 ;;21,"63874-0201-77 ")
 ;;881
 ;;21,"63874-0201-80 ")
 ;;882
 ;;21,"63874-0201-84 ")
 ;;883
 ;;21,"63874-0201-90 ")
 ;;884
 ;;21,"66116-0251-60 ")
 ;;809
 ;;21,"66116-0285-30 ")
 ;;631
 ;;21,"66116-0437-30 ")
 ;;600
 ;;21,"66116-0438-30 ")
 ;;528
 ;;21,"66267-0174-30 ")
 ;;632
 ;;21,"66267-0178-00 ")
 ;;885
 ;;21,"66267-0178-06 ")
 ;;468
 ;;21,"66267-0178-12 ")
 ;;469
 ;;21,"66267-0178-15 ")
 ;;470
 ;;21,"66267-0178-20 ")
 ;;471
 ;;21,"66267-0178-30 ")
 ;;472
 ;;21,"66267-0178-40 ")
 ;;473
 ;;21,"66267-0178-60 ")
 ;;474
 ;;21,"66267-0178-90 ")
 ;;475
 ;;21,"66267-0179-20 ")
 ;;172
 ;;21,"66267-0179-30 ")
 ;;173
 ;;21,"66267-0487-30 ")
 ;;476
 ;;21,"66591-0612-41 ")
 ;;477
 ;;21,"66591-0622-41 ")
 ;;174
 ;;21,"66591-0631-41 ")
 ;;182
 ;;21,"66591-0631-51 ")
 ;;183
 ;;21,"66591-0641-41 ")
 ;;478
 ;;21,"66591-0641-51 ")
 ;;479
 ;;21,"66591-0651-41 ")
 ;;480
 ;;21,"66591-0662-41 ")
 ;;481
 ;;21,"66591-0691-41 ")
 ;;482
 ;;21,"66591-1622-41 ")
 ;;175
 ;;21,"68030-6681-01 ")
 ;;633
 ;;21,"68030-6681-02 ")
 ;;634
 ;;21,"68030-6681-03 ")
 ;;635
 ;;21,"68030-6682-01 ")
 ;;575
 ;;21,"68030-7987-01 ")
 ;;576
 ;;21,"68030-9960-01 ")
 ;;636
 ;;21,"68115-0305-00 ")
 ;;483
 ;;21,"68115-0305-15 ")
 ;;886
 ;;21,"68115-0305-20 ")
 ;;484
 ;;21,"68115-0305-25 ")
 ;;485
 ;;21,"68115-0305-30 ")
 ;;486
 ;;21,"68115-0305-40 ")
 ;;487
 ;;21,"68115-0305-42 ")
 ;;887
 ;;21,"68115-0305-45 ")
 ;;888
 ;;21,"68115-0305-50 ")
 ;;889
 ;;21,"68115-0305-60 ")
 ;;488
 ;;21,"68115-0305-84 ")
 ;;890
 ;;21,"68115-0305-90 ")
 ;;489
 ;;21,"68115-0305-99 ")
 ;;490
 ;;21,"68115-0306-12 ")
 ;;176
 ;;21,"68115-0306-30 ")
 ;;177
 ;;21,"68115-0306-60 ")
 ;;178
 ;;21,"68115-0462-00 ")
 ;;491
 ;;21,"68115-0462-30 ")
 ;;492
 ;;21,"68115-0462-60 ")
 ;;493
 ;;21,"68115-0605-00 ")
 ;;494
 ;;21,"68115-0743-00 ")
 ;;495
 ;;21,"68115-0815-00 ")
 ;;496
 ;;9002226,632,.01)
 ;;BGP HEDIS NARCOTIC NDC
 ;;9002226,632,.02)
 ;;@
 ;;9002226,632,.04)
 ;;n
 ;;9002226,632,.06)
 ;;@
 ;;9002226,632,.08)
 ;;@
 ;;9002226,632,.09)
 ;;@
 ;;9002226,632,.11)
 ;;@
 ;;9002226,632,.12)
 ;;@
 ;;9002226,632,.13)
 ;;1
 ;;9002226,632,.14)
 ;;@
 ;;9002226,632,.15)
 ;;@
 ;;9002226,632,.16)
 ;;@
 ;;9002226,632,.17)
 ;;@
 ;;9002226,632,3101)
 ;;@
 ;;9002226.02101,"632,00002-0351-02 ",.01)
 ;;00002-0351-02
 ;;9002226.02101,"632,00002-0351-02 ",.02)
 ;;00002-0351-02
 ;;9002226.02101,"632,00002-0353-02 ",.01)
 ;;00002-0353-02
 ;;9002226.02101,"632,00002-0353-02 ",.02)
 ;;00002-0353-02
 ;;9002226.02101,"632,00002-0353-03 ",.01)
 ;;00002-0353-03
 ;;9002226.02101,"632,00002-0353-03 ",.02)
 ;;00002-0353-03
 ;;9002226.02101,"632,00002-0353-33 ",.01)
 ;;00002-0353-33
 ;;9002226.02101,"632,00002-0353-33 ",.02)
 ;;00002-0353-33
 ;;9002226.02101,"632,00002-0363-02 ",.01)
 ;;00002-0363-02
 ;;9002226.02101,"632,00002-0363-02 ",.02)
 ;;00002-0363-02
 ;;9002226.02101,"632,00002-0363-03 ",.01)
 ;;00002-0363-03
 ;;9002226.02101,"632,00002-0363-03 ",.02)
 ;;00002-0363-03
 ;;9002226.02101,"632,00002-0363-33 ",.01)
 ;;00002-0363-33
 ;;9002226.02101,"632,00002-0363-33 ",.02)
 ;;00002-0363-33
 ;;9002226.02101,"632,00002-0363-46 ",.01)
 ;;00002-0363-46
 ;;9002226.02101,"632,00002-0363-46 ",.02)
 ;;00002-0363-46
 ;;9002226.02101,"632,00002-0803-02 ",.01)
 ;;00002-0803-02
 ;;9002226.02101,"632,00002-0803-02 ",.02)
 ;;00002-0803-02
 ;;9002226.02101,"632,00002-0803-03 ",.01)
 ;;00002-0803-03
 ;;9002226.02101,"632,00002-0803-03 ",.02)
 ;;00002-0803-03
 ;;9002226.02101,"632,00002-0803-33 ",.01)
 ;;00002-0803-33
 ;;9002226.02101,"632,00002-0803-33 ",.02)
 ;;00002-0803-33
 ;;9002226.02101,"632,00002-3111-02 ",.01)
 ;;00002-3111-02
 ;;9002226.02101,"632,00002-3111-02 ",.02)
 ;;00002-3111-02
 ;;9002226.02101,"632,00002-3111-03 ",.01)
 ;;00002-3111-03
 ;;9002226.02101,"632,00002-3111-03 ",.02)
 ;;00002-3111-03
 ;;9002226.02101,"632,00008-0085-01 ",.01)
 ;;00008-0085-01
 ;;9002226.02101,"632,00008-0085-01 ",.02)
 ;;00008-0085-01
 ;;9002226.02101,"632,00008-0085-02 ",.01)
 ;;00008-0085-02
 ;;9002226.02101,"632,00008-0085-02 ",.02)
 ;;00008-0085-02
 ;;9002226.02101,"632,00008-0235-01 ",.01)
 ;;00008-0235-01
 ;;9002226.02101,"632,00008-0235-01 ",.02)
 ;;00008-0235-01
 ;;9002226.02101,"632,00008-0235-50 ",.01)
 ;;00008-0235-50
 ;;9002226.02101,"632,00008-0235-50 ",.02)
 ;;00008-0235-50
 ;;9002226.02101,"632,00008-0258-01 ",.01)
 ;;00008-0258-01
 ;;9002226.02101,"632,00008-0258-01 ",.02)
 ;;00008-0258-01
 ;;9002226.02101,"632,00008-0259-01 ",.01)
 ;;00008-0259-01
 ;;9002226.02101,"632,00008-0259-01 ",.02)
 ;;00008-0259-01
 ;;9002226.02101,"632,00008-0261-02 ",.01)
 ;;00008-0261-02
 ;;9002226.02101,"632,00008-0261-02 ",.02)
 ;;00008-0261-02
 ;;9002226.02101,"632,00008-0308-03 ",.01)
 ;;00008-0308-03
 ;;9002226.02101,"632,00008-0308-03 ",.02)
 ;;00008-0308-03
 ;;9002226.02101,"632,00008-0601-02 ",.01)
 ;;00008-0601-02
 ;;9002226.02101,"632,00008-0601-02 ",.02)
 ;;00008-0601-02
 ;;9002226.02101,"632,00008-0601-50 ",.01)
 ;;00008-0601-50
 ;;9002226.02101,"632,00008-0601-50 ",.02)
 ;;00008-0601-50
 ;;9002226.02101,"632,00008-0602-02 ",.01)
 ;;00008-0602-02
 ;;9002226.02101,"632,00008-0602-02 ",.02)
 ;;00008-0602-02
 ;;9002226.02101,"632,00008-0602-50 ",.01)
 ;;00008-0602-50
 ;;9002226.02101,"632,00008-0602-50 ",.02)
 ;;00008-0602-50
 ;;9002226.02101,"632,00008-0605-02 ",.01)
 ;;00008-0605-02
 ;;9002226.02101,"632,00008-0605-02 ",.02)
 ;;00008-0605-02
 ;;9002226.02101,"632,00008-0605-50 ",.01)
 ;;00008-0605-50
 ;;9002226.02101,"632,00008-0605-50 ",.02)
 ;;00008-0605-50
 ;;9002226.02101,"632,00008-0613-02 ",.01)
 ;;00008-0613-02
 ;;9002226.02101,"632,00008-0613-02 ",.02)
 ;;00008-0613-02
 ;;9002226.02101,"632,00008-0613-50 ",.01)
 ;;00008-0613-50
 ;;9002226.02101,"632,00008-0613-50 ",.02)
 ;;00008-0613-50
 ;;9002226.02101,"632,00024-0329-01 ",.01)
 ;;00024-0329-01
 ;;9002226.02101,"632,00024-0329-01 ",.02)
 ;;00024-0329-01
 ;;9002226.02101,"632,00024-0332-06 ",.01)
 ;;00024-0332-06
 ;;9002226.02101,"632,00024-0332-06 ",.02)
 ;;00024-0332-06
 ;;9002226.02101,"632,00024-0335-02 ",.01)
 ;;00024-0335-02
 ;;9002226.02101,"632,00024-0335-02 ",.02)
 ;;00024-0335-02
 ;;9002226.02101,"632,00024-0335-04 ",.01)
 ;;00024-0335-04
 ;;9002226.02101,"632,00024-0335-04 ",.02)
 ;;00024-0335-04
 ;;9002226.02101,"632,00024-0335-06 ",.01)
 ;;00024-0335-06
 ;;9002226.02101,"632,00024-0335-06 ",.02)
 ;;00024-0335-06
 ;;9002226.02101,"632,00024-0337-04 ",.01)
 ;;00024-0337-04
 ;;9002226.02101,"632,00024-0337-04 ",.02)
 ;;00024-0337-04
 ;;9002226.02101,"632,00024-0361-04 ",.01)
 ;;00024-0361-04
 ;;9002226.02101,"632,00024-0361-04 ",.02)
 ;;00024-0361-04
 ;;9002226.02101,"632,00024-0362-04 ",.01)
 ;;00024-0362-04
 ;;9002226.02101,"632,00024-0362-04 ",.02)
 ;;00024-0362-04
 ;;9002226.02101,"632,00024-0363-04 ",.01)
 ;;00024-0363-04
 ;;9002226.02101,"632,00024-0363-04 ",.02)
 ;;00024-0363-04
 ;;9002226.02101,"632,00024-0364-04 ",.01)
 ;;00024-0364-04
 ;;9002226.02101,"632,00024-0364-04 ",.02)
 ;;00024-0364-04
 ;;9002226.02101,"632,00024-0365-04 ",.01)
 ;;00024-0365-04
 ;;9002226.02101,"632,00024-0365-04 ",.02)
 ;;00024-0365-04
 ;;9002226.02101,"632,00024-0371-04 ",.01)
 ;;00024-0371-04
 ;;9002226.02101,"632,00024-0371-04 ",.02)
 ;;00024-0371-04
 ;;9002226.02101,"632,00024-0372-04 ",.01)
 ;;00024-0372-04
 ;;9002226.02101,"632,00024-0372-04 ",.02)
 ;;00024-0372-04
 ;;9002226.02101,"632,00024-0373-04 ",.01)
 ;;00024-0373-04
 ;;9002226.02101,"632,00024-0373-04 ",.02)
 ;;00024-0373-04
 ;;9002226.02101,"632,00024-0374-04 ",.01)
 ;;00024-0374-04
 ;;9002226.02101,"632,00024-0374-04 ",.02)
 ;;00024-0374-04
 ;;9002226.02101,"632,00024-0375-04 ",.01)
 ;;00024-0375-04
 ;;9002226.02101,"632,00024-0375-04 ",.02)
 ;;00024-0375-04
 ;;9002226.02101,"632,00024-1916-01 ",.01)
 ;;00024-1916-01
 ;;9002226.02101,"632,00024-1916-01 ",.02)
 ;;00024-1916-01
 ;;9002226.02101,"632,00024-1917-02 ",.01)
 ;;00024-1917-02
 ;;9002226.02101,"632,00024-1917-02 ",.02)
 ;;00024-1917-02
 ;;9002226.02101,"632,00024-1919-02 ",.01)
 ;;00024-1919-02
 ;;9002226.02101,"632,00024-1919-02 ",.02)
 ;;00024-1919-02
 ;;9002226.02101,"632,00024-1924-04 ",.01)
 ;;00024-1924-04
 ;;9002226.02101,"632,00024-1924-04 ",.02)
 ;;00024-1924-04
 ;;9002226.02101,"632,00024-1924-14 ",.01)
 ;;00024-1924-14
 ;;9002226.02101,"632,00024-1924-14 ",.02)
 ;;00024-1924-14
 ;;9002226.02101,"632,00024-1926-04 ",.01)
 ;;00024-1926-04
 ;;9002226.02101,"632,00024-1926-04 ",.02)
 ;;00024-1926-04
 ;;9002226.02101,"632,00024-1937-04 ",.01)
 ;;00024-1937-04
 ;;9002226.02101,"632,00024-1937-04 ",.02)
 ;;00024-1937-04
 ;;9002226.02101,"632,00024-1951-04 ",.01)
 ;;00024-1951-04
 ;;9002226.02101,"632,00024-1951-04 ",.02)
 ;;00024-1951-04
 ;;9002226.02101,"632,00046-0936-99 ",.01)
 ;;00046-0936-99
 ;;9002226.02101,"632,00046-0936-99 ",.02)
 ;;00046-0936-99
 ;;9002226.02101,"632,00046-0937-04 ",.01)
 ;;00046-0937-04
 ;;9002226.02101,"632,00046-0937-04 ",.02)
 ;;00046-0937-04
 ;;9002226.02101,"632,00047-2890-23 ",.01)
 ;;00047-2890-23
 ;;9002226.02101,"632,00047-2890-23 ",.02)
 ;;00047-2890-23
 ;;9002226.02101,"632,00054-3545-63 ",.01)
 ;;00054-3545-63
 ;;9002226.02101,"632,00054-3545-63 ",.02)
 ;;00054-3545-63
 ;;9002226.02101,"632,00054-4595-25 ",.01)
 ;;00054-4595-25
 ;;9002226.02101,"632,00054-4595-25 ",.02)
 ;;00054-4595-25
 ;;9002226.02101,"632,00054-4596-25 ",.01)
 ;;00054-4596-25
 ;;9002226.02101,"632,00054-4596-25 ",.02)
 ;;00054-4596-25
 ;;9002226.02101,"632,00054-8545-16 ",.01)
 ;;00054-8545-16
 ;;9002226.02101,"632,00054-8545-16 ",.02)
 ;;00054-8545-16
 ;;9002226.02101,"632,00054-8595-11 ",.01)
 ;;00054-8595-11
 ;;9002226.02101,"632,00054-8595-11 ",.02)
 ;;00054-8595-11
 ;;9002226.02101,"632,00054-8596-11 ",.01)
 ;;00054-8596-11
 ;;9002226.02101,"632,00054-8596-11 ",.02)
 ;;00054-8596-11
 ;;9002226.02101,"632,00074-1176-01 ",.01)
 ;;00074-1176-01
 ;;9002226.02101,"632,00074-1176-01 ",.02)
 ;;00074-1176-01
 ;;9002226.02101,"632,00074-1176-02 ",.01)
 ;;00074-1176-02
 ;;9002226.02101,"632,00074-1176-02 ",.02)
 ;;00074-1176-02
 ;;9002226.02101,"632,00074-1176-11 ",.01)
 ;;00074-1176-11
 ;;9002226.02101,"632,00074-1176-11 ",.02)
 ;;00074-1176-11
 ;;9002226.02101,"632,00074-1176-21 ",.01)
 ;;00074-1176-21
 ;;9002226.02101,"632,00074-1176-21 ",.02)
 ;;00074-1176-21
 ;;9002226.02101,"632,00074-1176-30 ",.01)
 ;;00074-1176-30
 ;;9002226.02101,"632,00074-1176-30 ",.02)
 ;;00074-1176-30
 ;;9002226.02101,"632,00074-1176-31 ",.01)
 ;;00074-1176-31
 ;;9002226.02101,"632,00074-1176-31 ",.02)
 ;;00074-1176-31
 ;;9002226.02101,"632,00074-1178-01 ",.01)
 ;;00074-1178-01
 ;;9002226.02101,"632,00074-1178-01 ",.02)
 ;;00074-1178-01
 ;;9002226.02101,"632,00074-1178-02 ",.01)
 ;;00074-1178-02
 ;;9002226.02101,"632,00074-1178-02 ",.02)
 ;;00074-1178-02
 ;;9002226.02101,"632,00074-1178-11 ",.01)
 ;;00074-1178-11
 ;;9002226.02101,"632,00074-1178-11 ",.02)
 ;;00074-1178-11
 ;;9002226.02101,"632,00074-1178-21 ",.01)
 ;;00074-1178-21
 ;;9002226.02101,"632,00074-1178-21 ",.02)
 ;;00074-1178-21
 ;;9002226.02101,"632,00074-1178-30 ",.01)
 ;;00074-1178-30
 ;;9002226.02101,"632,00074-1178-30 ",.02)
 ;;00074-1178-30
 ;;9002226.02101,"632,00074-1178-31 ",.01)
 ;;00074-1178-31
 ;;9002226.02101,"632,00074-1178-31 ",.02)
 ;;00074-1178-31
 ;;9002226.02101,"632,00074-1179-01 ",.01)
 ;;00074-1179-01
 ;;9002226.02101,"632,00074-1179-01 ",.02)
 ;;00074-1179-01
 ;;9002226.02101,"632,00074-1179-02 ",.01)
 ;;00074-1179-02
 ;;9002226.02101,"632,00074-1179-02 ",.02)
 ;;00074-1179-02
 ;;9002226.02101,"632,00074-1179-11 ",.01)
 ;;00074-1179-11
 ;;9002226.02101,"632,00074-1179-11 ",.02)
 ;;00074-1179-11
 ;;9002226.02101,"632,00074-1179-21 ",.01)
 ;;00074-1179-21
 ;;9002226.02101,"632,00074-1179-21 ",.02)
 ;;00074-1179-21
 ;;9002226.02101,"632,00074-1179-30 ",.01)
 ;;00074-1179-30
 ;;9002226.02101,"632,00074-1179-30 ",.02)
 ;;00074-1179-30
 ;;9002226.02101,"632,00074-1179-31 ",.01)
 ;;00074-1179-31