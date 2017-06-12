BGP72G3 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 11, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"54868-4402-02 ")
 ;;682
 ;;21,"54868-4402-03 ")
 ;;683
 ;;21,"54868-4422-00 ")
 ;;684
 ;;21,"54868-4422-01 ")
 ;;685
 ;;21,"54868-4422-02 ")
 ;;686
 ;;21,"54868-4422-03 ")
 ;;687
 ;;21,"54868-4422-04 ")
 ;;688
 ;;21,"54868-4422-05 ")
 ;;689
 ;;21,"54868-4871-00 ")
 ;;690
 ;;21,"54868-4871-01 ")
 ;;691
 ;;21,"54868-4871-02 ")
 ;;692
 ;;21,"54868-4871-03 ")
 ;;693
 ;;21,"54868-4873-00 ")
 ;;694
 ;;21,"54868-4873-01 ")
 ;;695
 ;;21,"54868-4873-03 ")
 ;;696
 ;;21,"54868-4873-04 ")
 ;;697
 ;;21,"54868-4950-00 ")
 ;;698
 ;;21,"54868-4950-02 ")
 ;;699
 ;;21,"54868-4950-03 ")
 ;;700
 ;;21,"54868-5112-00 ")
 ;;701
 ;;21,"54868-5112-01 ")
 ;;702
 ;;21,"54868-5207-00 ")
 ;;703
 ;;21,"54868-5207-01 ")
 ;;704
 ;;21,"54868-5255-00 ")
 ;;705
 ;;21,"54868-5255-01 ")
 ;;706
 ;;21,"54868-5258-00 ")
 ;;707
 ;;21,"54868-5425-00 ")
 ;;708
 ;;21,"54868-5440-00 ")
 ;;709
 ;;21,"54868-5440-01 ")
 ;;710
 ;;21,"54868-5501-00 ")
 ;;711
 ;;21,"54868-5587-00 ")
 ;;712
 ;;21,"54868-5587-01 ")
 ;;713
 ;;21,"54868-5835-00 ")
 ;;714
 ;;21,"54868-5837-00 ")
 ;;715
 ;;21,"55048-0856-30 ")
 ;;716
 ;;21,"55048-0857-30 ")
 ;;717
 ;;21,"55048-0858-30 ")
 ;;718
 ;;21,"55048-0859-30 ")
 ;;719
 ;;21,"55048-0861-30 ")
 ;;720
 ;;21,"55048-0880-30 ")
 ;;721
 ;;21,"55111-0678-02 ")
 ;;722
 ;;21,"55111-0678-10 ")
 ;;723
 ;;21,"55111-0678-11 ")
 ;;724
 ;;21,"55111-0679-02 ")
 ;;725
 ;;21,"55111-0679-10 ")
 ;;726
 ;;21,"55111-0679-11 ")
 ;;727
 ;;21,"55111-0680-02 ")
 ;;728
 ;;21,"55111-0680-10 ")
 ;;729
 ;;21,"55111-0680-11 ")
 ;;730
 ;;21,"55111-0681-02 ")
 ;;731
 ;;21,"55111-0681-10 ")
 ;;732
 ;;21,"55111-0681-11 ")
 ;;733
 ;;21,"55154-4024-05 ")
 ;;734
 ;;21,"55154-5440-05 ")
 ;;735
 ;;21,"55154-9399-05 ")
 ;;736
 ;;21,"55289-0286-30 ")
 ;;737
 ;;21,"55289-0286-50 ")
 ;;738
 ;;21,"55289-0340-30 ")
 ;;739
 ;;21,"55289-0773-14 ")
 ;;740
 ;;21,"55289-0773-30 ")
 ;;741
 ;;21,"55289-0773-60 ")
 ;;742
 ;;21,"55289-0773-90 ")
 ;;743
 ;;21,"55700-0005-30 ")
 ;;744
 ;;21,"55700-0005-60 ")
 ;;745
 ;;21,"55700-0005-90 ")
 ;;746
 ;;21,"57237-0119-01 ")
 ;;747
 ;;21,"57237-0119-99 ")
 ;;748
 ;;21,"57237-0120-01 ")
 ;;749
 ;;21,"57237-0120-99 ")
 ;;750
 ;;21,"57237-0121-01 ")
 ;;751
 ;;21,"57237-0121-99 ")
 ;;752
 ;;21,"57237-0122-01 ")
 ;;753
 ;;21,"57237-0122-99 ")
 ;;754
 ;;21,"57237-0123-01 ")
 ;;755
 ;;21,"57237-0123-99 ")
 ;;756
 ;;21,"57237-0124-01 ")
 ;;757
 ;;21,"57237-0124-99 ")
 ;;758
 ;;21,"57237-0125-01 ")
 ;;759
 ;;21,"57237-0125-99 ")
 ;;760
 ;;21,"57237-0126-01 ")
 ;;761
 ;;21,"57237-0126-99 ")
 ;;762
 ;;21,"57237-0127-01 ")
 ;;763
 ;;21,"57237-0127-99 ")
 ;;764
 ;;21,"58118-4027-03 ")
 ;;765
 ;;21,"58118-4027-06 ")
 ;;766
 ;;21,"58118-4027-09 ")
 ;;767
 ;;21,"58118-4028-03 ")
 ;;768
 ;;21,"58118-4029-03 ")
 ;;769
 ;;21,"58118-4029-06 ")
 ;;770
 ;;21,"58118-4029-09 ")
 ;;771
 ;;21,"58118-4030-03 ")
 ;;772
 ;;21,"58118-4030-06 ")
 ;;773
 ;;21,"58118-4030-09 ")
 ;;774
 ;;21,"58118-4031-03 ")
 ;;775
 ;;21,"58118-4031-06 ")
 ;;776
 ;;21,"58118-4031-09 ")
 ;;777
 ;;21,"58118-4032-03 ")
 ;;778
 ;;21,"58118-4033-03 ")
 ;;779
 ;;21,"58118-4033-06 ")
 ;;780
 ;;21,"58118-4033-09 ")
 ;;781
 ;;21,"58118-4034-03 ")
 ;;782
 ;;21,"58118-4034-06 ")
 ;;783
 ;;21,"58118-4034-09 ")
 ;;784
 ;;21,"58118-4035-03 ")
 ;;785
 ;;21,"58118-4035-06 ")
 ;;786
 ;;21,"58118-4035-09 ")
 ;;787
 ;;21,"58517-0360-30 ")
 ;;788
 ;;21,"58864-0030-30 ")
 ;;789
 ;;21,"58864-0035-30 ")
 ;;790
 ;;21,"58864-0223-14 ")
 ;;791
 ;;21,"58864-0223-30 ")
 ;;792
 ;;21,"58864-0301-14 ")
 ;;793
 ;;21,"58864-0357-15 ")
 ;;794
 ;;21,"58864-0698-14 ")
 ;;795
 ;;21,"58864-0698-30 ")
 ;;796
 ;;21,"58864-0773-15 ")
 ;;797
 ;;21,"58864-0773-30 ")
 ;;798
 ;;21,"58864-0879-30 ")
 ;;799
 ;;21,"60429-0784-01 ")
 ;;800
 ;;21,"60429-0784-10 ")
 ;;801
 ;;21,"60429-0784-15 ")
 ;;802
 ;;21,"60429-0784-30 ")
 ;;803
 ;;21,"60429-0784-45 ")
 ;;804
 ;;21,"60429-0784-77 ")
 ;;805
 ;;21,"60429-0785-01 ")
 ;;806
 ;;21,"60429-0785-10 ")
 ;;807
 ;;21,"60429-0785-15 ")
 ;;808
 ;;21,"60429-0785-30 ")
 ;;809
 ;;21,"60429-0785-35 ")
 ;;810
 ;;21,"60429-0785-40 ")
 ;;811
 ;;21,"60429-0785-45 ")
 ;;812
 ;;21,"60429-0785-60 ")
 ;;813
 ;;21,"60429-0785-77 ")
 ;;814
 ;;21,"60429-0785-90 ")
 ;;815
 ;;21,"60429-0786-01 ")
 ;;816
 ;;21,"60429-0786-10 ")
 ;;817
 ;;21,"60429-0786-15 ")
 ;;818
 ;;21,"60429-0786-30 ")
 ;;819
 ;;21,"60429-0786-45 ")
 ;;820
 ;;21,"60429-0786-77 ")
 ;;821
 ;;21,"60429-0787-01 ")
 ;;822
 ;;21,"60429-0787-10 ")
 ;;823
 ;;21,"60429-0787-15 ")
 ;;824
 ;;21,"60429-0787-30 ")
 ;;825
 ;;21,"60429-0787-45 ")
 ;;826
 ;;21,"60429-0787-77 ")
 ;;827
 ;;21,"60429-0788-01 ")
 ;;828
 ;;21,"60429-0788-10 ")
 ;;829
 ;;21,"60429-0788-15 ")
 ;;830
 ;;21,"60429-0788-30 ")
 ;;831
 ;;21,"60429-0788-45 ")
 ;;832
 ;;21,"60429-0788-77 ")
 ;;833
 ;;21,"60429-0789-01 ")
 ;;834
 ;;21,"60429-0789-10 ")
 ;;835
 ;;21,"60429-0789-15 ")
 ;;836
 ;;21,"60429-0789-20 ")
 ;;837
 ;;21,"60429-0789-25 ")
 ;;838
 ;;21,"60429-0789-30 ")
 ;;839
 ;;21,"60429-0789-35 ")
 ;;840
 ;;21,"60429-0789-40 ")
 ;;841
 ;;21,"60429-0789-45 ")
 ;;842
 ;;21,"60429-0789-50 ")
 ;;843
 ;;21,"60429-0789-60 ")
 ;;844
 ;;21,"60429-0789-75 ")
 ;;845
 ;;21,"60429-0789-77 ")
 ;;846
 ;;21,"60429-0789-90 ")
 ;;847
 ;;21,"60429-0790-01 ")
 ;;848
 ;;21,"60429-0790-10 ")
 ;;849
 ;;21,"60429-0790-15 ")
 ;;850
 ;;21,"60429-0790-30 ")
 ;;851
 ;;21,"60429-0790-45 ")
 ;;852
 ;;21,"60429-0790-77 ")
 ;;853
 ;;21,"60429-0791-01 ")
 ;;854
 ;;21,"60429-0791-15 ")
 ;;855
 ;;21,"60429-0791-30 ")
 ;;856
 ;;21,"60429-0791-45 ")
 ;;857
 ;;21,"60429-0791-77 ")
 ;;858
 ;;21,"60429-0792-01 ")
 ;;859
 ;;21,"60429-0792-15 ")
 ;;860
 ;;21,"60429-0792-30 ")
 ;;861
 ;;21,"60429-0792-45 ")
 ;;862
 ;;21,"60429-0792-77 ")
 ;;863
 ;;21,"60505-6078-00 ")
 ;;864
 ;;21,"60505-6078-04 ")
 ;;865
 ;;21,"60505-6079-00 ")
 ;;866
 ;;21,"60505-6079-04 ")
 ;;867
 ;;21,"60505-6080-00 ")
 ;;868
 ;;21,"60505-6080-04 ")
 ;;869
 ;;21,"60505-6081-00 ")
 ;;870
 ;;21,"60505-6081-04 ")
 ;;871
 ;;21,"60760-0031-30 ")
 ;;872
 ;;21,"60760-0033-30 ")
 ;;873
 ;;21,"60760-0034-30 ")
 ;;874
 ;;21,"60760-0040-30 ")
 ;;875
 ;;21,"60760-0041-30 ")
 ;;876
 ;;21,"60760-0043-30 ")
 ;;877
 ;;21,"61553-0203-50 ")
 ;;878
 ;;21,"61553-0204-03 ")
 ;;879
 ;;21,"61553-0205-52 ")
 ;;880
 ;;21,"61553-0214-04 ")
 ;;881
 ;;21,"61553-0400-46 ")
 ;;882
 ;;21,"61553-0402-46 ")
 ;;883
 ;;21,"61553-0418-02 ")
 ;;884
 ;;21,"61553-0419-02 ")
 ;;885
 ;;21,"61553-0420-02 ")
 ;;886
 ;;21,"61553-0905-03 ")
 ;;887
 ;;21,"61553-0906-03 ")
 ;;888
 ;;21,"61553-0907-04 ")
 ;;889
 ;;21,"61553-0908-03 ")
 ;;890
 ;;21,"61553-0910-03 ")
 ;;891
 ;;21,"61553-0911-04 ")
 ;;892
 ;;21,"61553-0912-03 ")
 ;;893
 ;;21,"61553-0913-04 ")
 ;;894
 ;;21,"61553-0914-04 ")
 ;;895
 ;;21,"61553-0915-04 ")
 ;;896
 ;;21,"61553-0931-48 ")
 ;;897
 ;;21,"61553-0941-02 ")
 ;;898
 ;;21,"61553-0942-02 ")
 ;;899
 ;;21,"61553-0948-04 ")
 ;;900
 ;;21,"62037-0839-20 ")
 ;;901
 ;;21,"62037-0849-20 ")
 ;;902
 ;;21,"62037-0861-20 ")
 ;;903
 ;;21,"62037-0862-20 ")
 ;;904
 ;;21,"62037-0863-20 ")
 ;;905
 ;;21,"62037-0864-20 ")
 ;;906
 ;;21,"62037-0866-20 ")
 ;;907
 ;;21,"62584-0984-01 ")
 ;;908
 ;;21,"62584-0984-11 ")
 ;;909
 ;;21,"62584-0994-01 ")
 ;;910
 ;;21,"62584-0994-11 ")
 ;;911
 ;;21,"62584-0994-77 ")
 ;;912
 ;;21,"62856-0101-01 ")
 ;;913
 ;;21,"62856-0101-10 ")
 ;;914
 ;;21,"62856-0125-01 ")
 ;;915
 ;;21,"62856-0125-10 ")
 ;;916
 ;;21,"62856-0150-01 ")
 ;;917
 ;;21,"62856-0150-10 ")
 ;;918
 ;;21,"62856-0180-01 ")
 ;;919
 ;;21,"62856-0180-10 ")
 ;;920
 ;;21,"62856-0250-01 ")
 ;;921
 ;;21,"62856-0250-10 ")
 ;;922
 ;;21,"62856-0251-01 ")
 ;;923
 ;;21,"62856-0500-01 ")
 ;;924
 ;;21,"62856-0500-10 ")
 ;;925
 ;;21,"62856-0750-01 ")
 ;;926
 ;;21,"62856-0750-10 ")
 ;;927
 ;;21,"63323-0017-10 ")
 ;;928
 ;;21,"63323-0047-10 ")
 ;;929
 ;;21,"63323-0262-01 ")
 ;;930
 ;;21,"63323-0262-55 ")
 ;;931
 ;;21,"63323-0276-02 ")
 ;;932
 ;;21,"63323-0459-09 ")
 ;;933
 ;;21,"63323-0540-01 ")
 ;;934
 ;;21,"63323-0540-11 ")
 ;;935
 ;;21,"63323-0540-31 ")
 ;;936
 ;;21,"63323-0540-57 ")
 ;;937
 ;;21,"63323-0542-01 ")
 ;;938
 ;;21,"63323-0542-07 ")
 ;;939
 ;;21,"63323-0543-02 ")
 ;;940
 ;;21,"63323-0544-01 ")
 ;;941
 ;;21,"63323-0544-11 ")
 ;;942
 ;;21,"63323-0545-01 ")
 ;;943
 ;;21,"63323-0545-05 ")
 ;;944
 ;;21,"63323-0549-01 ")
 ;;945
 ;;21,"63323-0557-01 ")
 ;;946
 ;;21,"63323-0565-86 ")
 ;;947
 ;;21,"63323-0565-93 ")
 ;;948
 ;;21,"63323-0568-83 ")
 ;;949
 ;;21,"63323-0568-84 ")
 ;;950
 ;;21,"63323-0568-87 ")
 ;;951
 ;;21,"63323-0568-88 ")
 ;;952
 ;;21,"63323-0568-90 ")
 ;;953
 ;;21,"63323-0568-94 ")
 ;;954
 ;;21,"63323-0568-95 ")
 ;;955
 ;;21,"63323-0568-96 ")
 ;;956
 ;;21,"63323-0568-98 ")
 ;;957
 ;;21,"63323-0568-99 ")
 ;;958
 ;;21,"63323-0569-84 ")
 ;;959
 ;;21,"63323-0569-90 ")
 ;;960
 ;;21,"63323-0569-95 ")
 ;;961
 ;;21,"63323-0569-99 ")
 ;;962
 ;;21,"63323-0915-01 ")
 ;;963
 ;;21,"63629-2548-01 ")
 ;;964
 ;;21,"63629-2548-02 ")
 ;;965
 ;;21,"63629-3177-01 ")
 ;;966
 ;;21,"63629-3177-02 ")
 ;;967
 ;;21,"63629-4017-01 ")
 ;;968
 ;;21,"63629-4017-02 ")
 ;;969
 ;;21,"63629-4017-03 ")
 ;;970
 ;;21,"63629-4017-04 ")
 ;;971
 ;;21,"63629-4017-05 ")
 ;;972
 ;;21,"63629-4122-01 ")
 ;;973
 ;;21,"63629-4122-02 ")
 ;;974
 ;;21,"63629-4122-03 ")
 ;;975
 ;;21,"63629-4122-04 ")
 ;;976
 ;;21,"63629-4122-05 ")
 ;;977
 ;;21,"63629-4122-06 ")
 ;;978
 ;;21,"63629-4417-01 ")
 ;;979
 ;;21,"63629-4417-02 ")
 ;;980
 ;;21,"63629-4417-03 ")
 ;;981
 ;;21,"63629-4748-01 ")
 ;;982
 ;;21,"63629-4748-02 ")
 ;;983
 ;;21,"63629-4748-03 ")
 ;;984
 ;;21,"63739-0900-12 ")
 ;;985
 ;;21,"63739-0900-26 ")
 ;;986
 ;;21,"63739-0901-14 ")
 ;;987
 ;;21,"63739-0901-28 ")
 ;;988
 ;;21,"63739-0920-11 ")
 ;;989
 ;;21,"63739-0920-25 ")
 ;;990
 ;;21,"63739-0931-14 ")
 ;;991
 ;;21,"63739-0931-28 ")
 ;;992
 ;;21,"63739-0942-15 ")
 ;;993
 ;;21,"63739-0942-29 ")
 ;;994
 ;;21,"63739-0953-11 ")
 ;;995
 ;;21,"63739-0953-25 ")
 ;;996
 ;;21,"63739-0964-11 ")
 ;;997
 ;;21,"63739-0964-25 ")
 ;;998
 ;;21,"63739-0986-11 ")
 ;;999
 ;;21,"63739-0986-25 ")
 ;;1000
 ;;21,"63807-0300-31 ")
 ;;1001
 ;;21,"63807-0300-35 ")
 ;;1002
 ;;21,"63807-0360-31 ")
 ;;1003
 ;;21,"63807-0400-31 ")
 ;;1004
 ;;21,"63807-0400-35 ")
 ;;1005
 ;;21,"63807-0500-05 ")
 ;;1006
 ;;21,"63807-0500-31 ")
 ;;1007
 ;;21,"63807-0500-50 ")
 ;;1008
 ;;21,"63807-0500-51 ")
 ;;1009
 ;;21,"63807-0500-55 ")
 ;;1010
 ;;21,"63807-0505-12 ")
 ;;1011
 ;;21,"63807-0560-31 ")
 ;;1012
 ;;21,"63807-0560-51 ")
 ;;1013
 ;;21,"63807-0600-05 ")
 ;;1014
 ;;21,"63807-0600-31 ")
 ;;1015
 ;;21,"63807-0600-51 ")
 ;;1016
 ;;21,"63807-0600-55 ")
 ;;1017
 ;;21,"63807-0605-12 ")
 ;;1018
 ;;21,"63807-0660-31 ")
 ;;1019
 ;;21,"63807-0660-51 ")
 ;;1020
 ;;21,"64253-0222-21 ")
 ;;1021
 ;;21,"64253-0222-22 ")
 ;;1022
 ;;21,"64253-0222-23 ")
 ;;1023