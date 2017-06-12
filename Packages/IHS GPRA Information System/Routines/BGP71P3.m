BGP71P3 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 11, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"54868-6212-01 ")
 ;;682
 ;;21,"54868-6251-00 ")
 ;;683
 ;;21,"55048-0091-30 ")
 ;;684
 ;;21,"55048-0092-30 ")
 ;;685
 ;;21,"55048-0093-30 ")
 ;;686
 ;;21,"55048-0225-30 ")
 ;;687
 ;;21,"55048-0248-30 ")
 ;;688
 ;;21,"55048-0248-90 ")
 ;;689
 ;;21,"55048-0269-30 ")
 ;;690
 ;;21,"55048-0273-60 ")
 ;;691
 ;;21,"55048-0273-71 ")
 ;;692
 ;;21,"55111-0695-01 ")
 ;;693
 ;;21,"55111-0696-01 ")
 ;;694
 ;;21,"55111-0696-10 ")
 ;;695
 ;;21,"55111-0697-01 ")
 ;;696
 ;;21,"55111-0697-10 ")
 ;;697
 ;;21,"55289-0066-90 ")
 ;;698
 ;;21,"55289-0101-30 ")
 ;;699
 ;;21,"55289-0101-50 ")
 ;;700
 ;;21,"55289-0262-90 ")
 ;;701
 ;;21,"55289-0281-30 ")
 ;;702
 ;;21,"55289-0281-60 ")
 ;;703
 ;;21,"55289-0281-86 ")
 ;;704
 ;;21,"55289-0281-90 ")
 ;;705
 ;;21,"55289-0396-30 ")
 ;;706
 ;;21,"55289-0603-07 ")
 ;;707
 ;;21,"55289-0603-21 ")
 ;;708
 ;;21,"55289-0603-30 ")
 ;;709
 ;;21,"55289-0603-90 ")
 ;;710
 ;;21,"55289-0606-30 ")
 ;;711
 ;;21,"55289-0606-90 ")
 ;;712
 ;;21,"55289-0761-01 ")
 ;;713
 ;;21,"55289-0761-30 ")
 ;;714
 ;;21,"55289-0761-90 ")
 ;;715
 ;;21,"55289-0892-01 ")
 ;;716
 ;;21,"55289-0892-14 ")
 ;;717
 ;;21,"55289-0892-15 ")
 ;;718
 ;;21,"55289-0892-30 ")
 ;;719
 ;;21,"55289-0892-60 ")
 ;;720
 ;;21,"55289-0892-86 ")
 ;;721
 ;;21,"55289-0892-90 ")
 ;;722
 ;;21,"55289-0892-93 ")
 ;;723
 ;;21,"55289-0892-98 ")
 ;;724
 ;;21,"55700-0030-30 ")
 ;;725
 ;;21,"55700-0030-60 ")
 ;;726
 ;;21,"55700-0030-90 ")
 ;;727
 ;;21,"55700-0114-90 ")
 ;;728
 ;;21,"55700-0395-30 ")
 ;;729
 ;;21,"55700-0395-60 ")
 ;;730
 ;;21,"55700-0395-90 ")
 ;;731
 ;;21,"57237-0020-01 ")
 ;;732
 ;;21,"57237-0021-01 ")
 ;;733
 ;;21,"57237-0021-05 ")
 ;;734
 ;;21,"57237-0021-99 ")
 ;;735
 ;;21,"57237-0022-01 ")
 ;;736
 ;;21,"57237-0022-05 ")
 ;;737
 ;;21,"57237-0022-99 ")
 ;;738
 ;;21,"57237-0023-01 ")
 ;;739
 ;;21,"57237-0023-05 ")
 ;;740
 ;;21,"57237-0024-01 ")
 ;;741
 ;;21,"57237-0024-05 ")
 ;;742
 ;;21,"57237-0025-01 ")
 ;;743
 ;;21,"57237-0025-05 ")
 ;;744
 ;;21,"58118-0886-03 ")
 ;;745
 ;;21,"58118-2331-03 ")
 ;;746
 ;;21,"58118-2331-09 ")
 ;;747
 ;;21,"58118-2332-03 ")
 ;;748
 ;;21,"58118-2332-09 ")
 ;;749
 ;;21,"58118-8343-08 ")
 ;;750
 ;;21,"58118-8343-09 ")
 ;;751
 ;;21,"58864-0224-30 ")
 ;;752
 ;;21,"58864-0224-60 ")
 ;;753
 ;;21,"58864-0224-93 ")
 ;;754
 ;;21,"58864-0711-30 ")
 ;;755
 ;;21,"58864-0803-30 ")
 ;;756
 ;;21,"58864-0804-30 ")
 ;;757
 ;;21,"58864-0951-30 ")
 ;;758
 ;;21,"58864-0952-30 ")
 ;;759
 ;;21,"58864-0953-30 ")
 ;;760
 ;;21,"59762-2331-06 ")
 ;;761
 ;;21,"59762-2331-08 ")
 ;;762
 ;;21,"59762-2332-06 ")
 ;;763
 ;;21,"59762-2332-08 ")
 ;;764
 ;;21,"59762-3725-01 ")
 ;;765
 ;;21,"59762-3727-06 ")
 ;;766
 ;;21,"59762-7021-05 ")
 ;;767
 ;;21,"59762-7021-09 ")
 ;;768
 ;;21,"59762-7022-05 ")
 ;;769
 ;;21,"59762-7022-09 ")
 ;;770
 ;;21,"60429-0283-01 ")
 ;;771
 ;;21,"60429-0284-01 ")
 ;;772
 ;;21,"60429-0285-01 ")
 ;;773
 ;;21,"60429-0327-01 ")
 ;;774
 ;;21,"60429-0328-01 ")
 ;;775
 ;;21,"60429-0328-05 ")
 ;;776
 ;;21,"60429-0329-01 ")
 ;;777
 ;;21,"60429-0329-05 ")
 ;;778
 ;;21,"60429-0433-01 ")
 ;;779
 ;;21,"60429-0433-05 ")
 ;;780
 ;;21,"60432-0126-08 ")
 ;;781
 ;;21,"60432-0126-16 ")
 ;;782
 ;;21,"60505-0368-01 ")
 ;;783
 ;;21,"60846-0201-01 ")
 ;;784
 ;;21,"60846-0202-01 ")
 ;;785
 ;;21,"61570-0072-01 ")
 ;;786
 ;;21,"61570-0073-01 ")
 ;;787
 ;;21,"61570-0074-01 ")
 ;;788
 ;;21,"61570-0075-50 ")
 ;;789
 ;;21,"61919-0330-30 ")
 ;;790
 ;;21,"61919-0330-60 ")
 ;;791
 ;;21,"61919-0378-60 ")
 ;;792
 ;;21,"61919-0418-60 ")
 ;;793
 ;;21,"62559-0149-01 ")
 ;;794
 ;;21,"62559-0150-01 ")
 ;;795
 ;;21,"63629-1392-01 ")
 ;;796
 ;;21,"63629-1392-02 ")
 ;;797
 ;;21,"63629-1392-03 ")
 ;;798
 ;;21,"63629-1393-01 ")
 ;;799
 ;;21,"63629-1393-02 ")
 ;;800
 ;;21,"63629-1393-03 ")
 ;;801
 ;;21,"63629-1393-04 ")
 ;;802
 ;;21,"63629-2793-01 ")
 ;;803
 ;;21,"63629-2793-03 ")
 ;;804
 ;;21,"63629-2793-04 ")
 ;;805
 ;;21,"63629-2793-05 ")
 ;;806
 ;;21,"63629-2907-01 ")
 ;;807
 ;;21,"63629-2907-02 ")
 ;;808
 ;;21,"63629-3397-03 ")
 ;;809
 ;;21,"63629-3755-01 ")
 ;;810
 ;;21,"63629-3755-02 ")
 ;;811
 ;;21,"63629-3998-01 ")
 ;;812
 ;;21,"63629-4368-01 ")
 ;;813
 ;;21,"63629-4368-02 ")
 ;;814
 ;;21,"63629-4368-03 ")
 ;;815
 ;;21,"63629-4368-04 ")
 ;;816
 ;;21,"63739-0119-10 ")
 ;;817
 ;;21,"63739-0165-10 ")
 ;;818
 ;;21,"63739-0549-51 ")
 ;;819
 ;;21,"63874-0317-01 ")
 ;;820
 ;;21,"63874-0317-02 ")
 ;;821
 ;;21,"63874-0317-04 ")
 ;;822
 ;;21,"63874-0317-10 ")
 ;;823
 ;;21,"63874-0317-12 ")
 ;;824
 ;;21,"63874-0317-14 ")
 ;;825
 ;;21,"63874-0317-15 ")
 ;;826
 ;;21,"63874-0317-20 ")
 ;;827
 ;;21,"63874-0317-24 ")
 ;;828
 ;;21,"63874-0317-28 ")
 ;;829
 ;;21,"63874-0317-30 ")
 ;;830
 ;;21,"63874-0317-40 ")
 ;;831
 ;;21,"63874-0317-50 ")
 ;;832
 ;;21,"63874-0317-60 ")
 ;;833
 ;;21,"63874-0317-90 ")
 ;;834
 ;;21,"63874-0357-01 ")
 ;;835
 ;;21,"63874-0357-02 ")
 ;;836
 ;;21,"63874-0357-10 ")
 ;;837
 ;;21,"63874-0357-12 ")
 ;;838
 ;;21,"63874-0357-14 ")
 ;;839
 ;;21,"63874-0357-15 ")
 ;;840
 ;;21,"63874-0357-20 ")
 ;;841
 ;;21,"63874-0357-21 ")
 ;;842
 ;;21,"63874-0357-24 ")
 ;;843
 ;;21,"63874-0357-30 ")
 ;;844
 ;;21,"63874-0357-40 ")
 ;;845
 ;;21,"63874-0357-60 ")
 ;;846
 ;;21,"63874-0588-01 ")
 ;;847
 ;;21,"63874-0588-04 ")
 ;;848
 ;;21,"63874-0588-10 ")
 ;;849
 ;;21,"63874-0588-14 ")
 ;;850
 ;;21,"63874-0588-20 ")
 ;;851
 ;;21,"63874-0588-30 ")
 ;;852
 ;;21,"63874-0588-60 ")
 ;;853
 ;;21,"63874-0588-80 ")
 ;;854
 ;;21,"63874-0588-90 ")
 ;;855
 ;;21,"63874-0665-01 ")
 ;;856
 ;;21,"63874-0665-04 ")
 ;;857
 ;;21,"63874-0665-10 ")
 ;;858
 ;;21,"63874-0665-14 ")
 ;;859
 ;;21,"63874-0665-30 ")
 ;;860
 ;;21,"63874-0665-60 ")
 ;;861
 ;;21,"63874-0665-90 ")
 ;;862
 ;;21,"64011-0215-41 ")
 ;;863
 ;;21,"64205-0048-30 ")
 ;;864
 ;;21,"64205-0048-90 ")
 ;;865
 ;;21,"64205-0488-30 ")
 ;;866
 ;;21,"64205-0488-90 ")
 ;;867
 ;;21,"64248-0101-01 ")
 ;;868
 ;;21,"64248-0102-01 ")
 ;;869
 ;;21,"64720-0123-10 ")
 ;;870
 ;;21,"64720-0124-10 ")
 ;;871
 ;;21,"64720-0125-10 ")
 ;;872
 ;;21,"64720-0125-11 ")
 ;;873
 ;;21,"64720-0290-10 ")
 ;;874
 ;;21,"64720-0291-10 ")
 ;;875
 ;;21,"64720-0292-10 ")
 ;;876
 ;;21,"64720-0292-11 ")
 ;;877
 ;;21,"64727-3298-01 ")
 ;;878
 ;;21,"64727-3298-02 ")
 ;;879
 ;;21,"64727-3299-01 ")
 ;;880
 ;;21,"64727-3299-02 ")
 ;;881
 ;;21,"64727-3300-01 ")
 ;;882
 ;;21,"64727-3300-02 ")
 ;;883
 ;;21,"64727-3302-01 ")
 ;;884
 ;;21,"64727-3302-02 ")
 ;;885
 ;;21,"64727-3303-01 ")
 ;;886
 ;;21,"64727-3303-02 ")
 ;;887
 ;;21,"64727-3305-01 ")
 ;;888
 ;;21,"64727-3305-02 ")
 ;;889
 ;;21,"64727-3307-01 ")
 ;;890
 ;;21,"64727-3307-02 ")
 ;;891
 ;;21,"64727-3308-01 ")
 ;;892
 ;;21,"64727-3308-02 ")
 ;;893
 ;;21,"64727-3309-01 ")
 ;;894
 ;;21,"64727-3309-02 ")
 ;;895
 ;;21,"64727-3310-01 ")
 ;;896
 ;;21,"64727-3310-02 ")
 ;;897
 ;;21,"64727-3312-01 ")
 ;;898
 ;;21,"64727-3312-02 ")
 ;;899
 ;;21,"64727-3320-01 ")
 ;;900
 ;;21,"64727-3320-02 ")
 ;;901
 ;;21,"64727-3340-01 ")
 ;;902
 ;;21,"64727-3340-02 ")
 ;;903
 ;;21,"64727-5450-01 ")
 ;;904
 ;;21,"64727-5450-02 ")
 ;;905
 ;;21,"64727-5550-01 ")
 ;;906
 ;;21,"64727-5550-02 ")
 ;;907
 ;;21,"64727-5650-01 ")
 ;;908
 ;;21,"64727-5650-02 ")
 ;;909
 ;;21,"64727-5750-01 ")
 ;;910
 ;;21,"64727-5750-02 ")
 ;;911
 ;;21,"64727-5850-01 ")
 ;;912
 ;;21,"64727-5850-02 ")
 ;;913
 ;;21,"64727-5950-01 ")
 ;;914
 ;;21,"64727-5950-02 ")
 ;;915
 ;;21,"64727-6050-01 ")
 ;;916
 ;;21,"64727-6050-02 ")
 ;;917
 ;;21,"64727-6150-01 ")
 ;;918
 ;;21,"64727-6150-02 ")
 ;;919
 ;;21,"64727-7065-01 ")
 ;;920
 ;;21,"64727-7065-02 ")
 ;;921
 ;;21,"64727-7070-01 ")
 ;;922
 ;;21,"64727-7070-02 ")
 ;;923
 ;;21,"64727-7072-01 ")
 ;;924
 ;;21,"64727-7072-02 ")
 ;;925
 ;;21,"64727-7073-01 ")
 ;;926
 ;;21,"64727-7073-02 ")
 ;;927
 ;;21,"64727-7074-01 ")
 ;;928
 ;;21,"64727-7074-02 ")
 ;;929
 ;;21,"64727-7075-01 ")
 ;;930
 ;;21,"64727-7075-02 ")
 ;;931
 ;;21,"64727-7078-01 ")
 ;;932
 ;;21,"64727-7078-02 ")
 ;;933
 ;;21,"64727-7080-01 ")
 ;;934
 ;;21,"64727-7080-02 ")
 ;;935
 ;;21,"64727-7085-01 ")
 ;;936
 ;;21,"64727-7085-02 ")
 ;;937
 ;;21,"64727-7090-01 ")
 ;;938
 ;;21,"64727-7090-02 ")
 ;;939
 ;;21,"64727-7095-01 ")
 ;;940
 ;;21,"64727-7095-02 ")
 ;;941
 ;;21,"64727-7100-01 ")
 ;;942
 ;;21,"64727-7100-02 ")
 ;;943
 ;;21,"64727-7150-01 ")
 ;;944
 ;;21,"64727-7150-02 ")
 ;;945
 ;;21,"65243-0176-09 ")
 ;;946
 ;;21,"65243-0176-12 ")
 ;;947
 ;;21,"65243-0176-18 ")
 ;;948
 ;;21,"65243-0176-27 ")
 ;;949
 ;;21,"65243-0176-36 ")
 ;;950
 ;;21,"65243-0185-36 ")
 ;;951
 ;;21,"65243-0325-09 ")
 ;;952
 ;;21,"65243-0325-18 ")
 ;;953
 ;;21,"65243-0343-09 ")
 ;;954
 ;;21,"65243-0343-36 ")
 ;;955
 ;;21,"65243-0375-09 ")
 ;;956
 ;;21,"65862-0028-01 ")
 ;;957
 ;;21,"65862-0029-01 ")
 ;;958
 ;;21,"65862-0029-05 ")
 ;;959
 ;;21,"65862-0030-01 ")
 ;;960
 ;;21,"65862-0030-99 ")
 ;;961
 ;;21,"65862-0080-01 ")
 ;;962
 ;;21,"65862-0080-05 ")
 ;;963
 ;;21,"65862-0081-01 ")
 ;;964
 ;;21,"65862-0081-05 ")
 ;;965
 ;;21,"65862-0082-01 ")
 ;;966
 ;;21,"65862-0082-05 ")
 ;;967
 ;;21,"66105-0984-03 ")
 ;;968
 ;;21,"66105-0984-06 ")
 ;;969
 ;;21,"66105-0984-10 ")
 ;;970
 ;;21,"66105-0984-11 ")
 ;;971
 ;;21,"66105-0984-50 ")
 ;;972
 ;;21,"66105-0985-03 ")
 ;;973
 ;;21,"66105-0985-06 ")
 ;;974
 ;;21,"66105-0985-10 ")
 ;;975
 ;;21,"66105-0985-11 ")
 ;;976
 ;;21,"66105-0985-50 ")
 ;;977
 ;;21,"66105-0986-03 ")
 ;;978
 ;;21,"66105-0986-06 ")
 ;;979
 ;;21,"66105-0986-10 ")
 ;;980
 ;;21,"66105-0986-11 ")
 ;;981
 ;;21,"66105-0986-50 ")
 ;;982
 ;;21,"66116-0233-30 ")
 ;;983
 ;;21,"66116-0285-30 ")
 ;;984
 ;;21,"66116-0437-30 ")
 ;;985
 ;;21,"66116-0438-30 ")
 ;;986
 ;;21,"66267-0093-60 ")
 ;;987
 ;;21,"66267-0103-30 ")
 ;;988
 ;;21,"66267-0174-30 ")
 ;;989
 ;;21,"66336-0028-90 ")
 ;;990
 ;;21,"66336-0712-90 ")
 ;;991
 ;;21,"66689-0020-01 ")
 ;;992
 ;;21,"66689-0020-50 ")
 ;;993
 ;;21,"67253-0460-10 ")
 ;;994
 ;;21,"67253-0461-10 ")
 ;;995
 ;;21,"67253-0461-11 ")
 ;;996
 ;;21,"67253-0461-50 ")
 ;;997
 ;;21,"67253-0462-10 ")
 ;;998
 ;;21,"67253-0462-11 ")
 ;;999
 ;;21,"67253-0462-50 ")
 ;;1000
 ;;21,"67544-0296-70 ")
 ;;1001
 ;;21,"67544-0511-30 ")
 ;;1002
 ;;21,"67544-0511-70 ")
 ;;1003
 ;;21,"67544-0511-94 ")
 ;;1004
 ;;21,"67544-0566-53 ")
 ;;1005
 ;;21,"67544-0566-60 ")
 ;;1006
 ;;21,"67544-0566-70 ")
 ;;1007
 ;;21,"67544-0566-80 ")
 ;;1008
 ;;21,"67544-0566-92 ")
 ;;1009
 ;;21,"67544-0566-94 ")
 ;;1010
 ;;21,"67544-0613-53 ")
 ;;1011
 ;;21,"67544-0653-53 ")
 ;;1012
 ;;21,"67544-0653-60 ")
 ;;1013
 ;;21,"67544-0653-70 ")
 ;;1014
 ;;21,"67544-0653-80 ")
 ;;1015
 ;;21,"67544-0653-90 ")
 ;;1016
 ;;21,"67544-0653-92 ")
 ;;1017
 ;;21,"67544-0653-94 ")
 ;;1018
 ;;21,"67544-0653-98 ")
 ;;1019
 ;;21,"67544-0661-41 ")
 ;;1020
 ;;21,"67544-0661-81 ")
 ;;1021
 ;;21,"67544-0875-60 ")
 ;;1022
 ;;21,"67544-0875-80 ")
 ;;1023