BGP71U12 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 11, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"65597-0104-10 ")
 ;;3688
 ;;21,"65597-0104-30 ")
 ;;3689
 ;;21,"65597-0104-90 ")
 ;;3690
 ;;21,"65597-0105-30 ")
 ;;3691
 ;;21,"65597-0105-90 ")
 ;;3692
 ;;21,"65597-0106-30 ")
 ;;3693
 ;;21,"65597-0106-90 ")
 ;;3694
 ;;21,"65597-0107-30 ")
 ;;3695
 ;;21,"65597-0107-90 ")
 ;;3696
 ;;21,"65597-0110-30 ")
 ;;3697
 ;;21,"65597-0110-90 ")
 ;;3698
 ;;21,"65597-0111-30 ")
 ;;3699
 ;;21,"65597-0111-90 ")
 ;;3700
 ;;21,"65597-0112-30 ")
 ;;3701
 ;;21,"65597-0112-90 ")
 ;;3702
 ;;21,"65597-0113-30 ")
 ;;3703
 ;;21,"65597-0113-90 ")
 ;;3704
 ;;21,"65597-0114-30 ")
 ;;3705
 ;;21,"65597-0114-90 ")
 ;;3706
 ;;21,"65597-0115-30 ")
 ;;3707
 ;;21,"65597-0115-90 ")
 ;;3708
 ;;21,"65597-0116-30 ")
 ;;3709
 ;;21,"65597-0116-90 ")
 ;;3710
 ;;21,"65597-0117-30 ")
 ;;3711
 ;;21,"65597-0117-90 ")
 ;;3712
 ;;21,"65597-0118-30 ")
 ;;3713
 ;;21,"65597-0118-90 ")
 ;;3714
 ;;21,"65862-0037-01 ")
 ;;3715
 ;;21,"65862-0037-05 ")
 ;;3716
 ;;21,"65862-0037-99 ")
 ;;3717
 ;;21,"65862-0038-01 ")
 ;;3718
 ;;21,"65862-0038-05 ")
 ;;3719
 ;;21,"65862-0038-99 ")
 ;;3720
 ;;21,"65862-0039-01 ")
 ;;3721
 ;;21,"65862-0039-05 ")
 ;;3722
 ;;21,"65862-0039-99 ")
 ;;3723
 ;;21,"65862-0040-01 ")
 ;;3724
 ;;21,"65862-0040-05 ")
 ;;3725
 ;;21,"65862-0040-99 ")
 ;;3726
 ;;21,"65862-0041-01 ")
 ;;3727
 ;;21,"65862-0041-05 ")
 ;;3728
 ;;21,"65862-0041-99 ")
 ;;3729
 ;;21,"65862-0042-01 ")
 ;;3730
 ;;21,"65862-0042-05 ")
 ;;3731
 ;;21,"65862-0042-99 ")
 ;;3732
 ;;21,"65862-0043-01 ")
 ;;3733
 ;;21,"65862-0043-05 ")
 ;;3734
 ;;21,"65862-0044-01 ")
 ;;3735
 ;;21,"65862-0044-05 ")
 ;;3736
 ;;21,"65862-0045-01 ")
 ;;3737
 ;;21,"65862-0045-05 ")
 ;;3738
 ;;21,"65862-0116-01 ")
 ;;3739
 ;;21,"65862-0117-01 ")
 ;;3740
 ;;21,"65862-0118-01 ")
 ;;3741
 ;;21,"65862-0161-90 ")
 ;;3742
 ;;21,"65862-0162-30 ")
 ;;3743
 ;;21,"65862-0162-90 ")
 ;;3744
 ;;21,"65862-0163-90 ")
 ;;3745
 ;;21,"65862-0164-01 ")
 ;;3746
 ;;21,"65862-0165-01 ")
 ;;3747
 ;;21,"65862-0166-01 ")
 ;;3748
 ;;21,"65862-0201-90 ")
 ;;3749
 ;;21,"65862-0201-99 ")
 ;;3750
 ;;21,"65862-0202-30 ")
 ;;3751
 ;;21,"65862-0202-90 ")
 ;;3752
 ;;21,"65862-0202-99 ")
 ;;3753
 ;;21,"65862-0203-30 ")
 ;;3754
 ;;21,"65862-0203-90 ")
 ;;3755
 ;;21,"65862-0203-99 ")
 ;;3756
 ;;21,"65862-0286-01 ")
 ;;3757
 ;;21,"65862-0287-01 ")
 ;;3758
 ;;21,"65862-0288-01 ")
 ;;3759
 ;;21,"65862-0308-01 ")
 ;;3760
 ;;21,"65862-0309-01 ")
 ;;3761
 ;;21,"65862-0468-30 ")
 ;;3762
 ;;21,"65862-0468-90 ")
 ;;3763
 ;;21,"65862-0468-99 ")
 ;;3764
 ;;21,"65862-0469-30 ")
 ;;3765
 ;;21,"65862-0469-90 ")
 ;;3766
 ;;21,"65862-0469-99 ")
 ;;3767
 ;;21,"65862-0470-30 ")
 ;;3768
 ;;21,"65862-0470-90 ")
 ;;3769
 ;;21,"65862-0470-99 ")
 ;;3770
 ;;21,"65862-0471-90 ")
 ;;3771
 ;;21,"65862-0472-90 ")
 ;;3772
 ;;21,"65862-0473-90 ")
 ;;3773
 ;;21,"65862-0474-01 ")
 ;;3774
 ;;21,"65862-0474-30 ")
 ;;3775
 ;;21,"65862-0475-01 ")
 ;;3776
 ;;21,"65862-0475-05 ")
 ;;3777
 ;;21,"65862-0476-01 ")
 ;;3778
 ;;21,"65862-0476-05 ")
 ;;3779
 ;;21,"65862-0477-01 ")
 ;;3780
 ;;21,"65862-0477-05 ")
 ;;3781
 ;;21,"65862-0547-90 ")
 ;;3782
 ;;21,"65862-0547-99 ")
 ;;3783
 ;;21,"65862-0548-90 ")
 ;;3784
 ;;21,"65862-0548-99 ")
 ;;3785
 ;;21,"65862-0549-90 ")
 ;;3786
 ;;21,"65862-0549-99 ")
 ;;3787
 ;;21,"65862-0550-05 ")
 ;;3788
 ;;21,"65862-0550-90 ")
 ;;3789
 ;;21,"65862-0551-05 ")
 ;;3790
 ;;21,"65862-0551-90 ")
 ;;3791
 ;;21,"65862-0570-30 ")
 ;;3792
 ;;21,"65862-0571-90 ")
 ;;3793
 ;;21,"65862-0572-90 ")
 ;;3794
 ;;21,"65862-0573-90 ")
 ;;3795
 ;;21,"65862-0582-01 ")
 ;;3796
 ;;21,"65862-0582-05 ")
 ;;3797
 ;;21,"65862-0583-01 ")
 ;;3798
 ;;21,"65862-0583-05 ")
 ;;3799
 ;;21,"65862-0584-01 ")
 ;;3800
 ;;21,"65862-0584-05 ")
 ;;3801
 ;;21,"65862-0585-01 ")
 ;;3802
 ;;21,"65862-0585-05 ")
 ;;3803
 ;;21,"65862-0586-01 ")
 ;;3804
 ;;21,"65862-0586-05 ")
 ;;3805
 ;;21,"65862-0587-01 ")
 ;;3806
 ;;21,"65862-0587-05 ")
 ;;3807
 ;;21,"65862-0617-90 ")
 ;;3808
 ;;21,"65862-0618-90 ")
 ;;3809
 ;;21,"65862-0619-90 ")
 ;;3810
 ;;21,"65862-0620-90 ")
 ;;3811
 ;;21,"65862-0637-30 ")
 ;;3812
 ;;21,"65862-0637-90 ")
 ;;3813
 ;;21,"65862-0638-05 ")
 ;;3814
 ;;21,"65862-0638-30 ")
 ;;3815
 ;;21,"65862-0638-90 ")
 ;;3816
 ;;21,"65862-0639-05 ")
 ;;3817
 ;;21,"65862-0639-30 ")
 ;;3818
 ;;21,"65862-0639-90 ")
 ;;3819
 ;;21,"65862-0867-03 ")
 ;;3820
 ;;21,"65862-0867-10 ")
 ;;3821
 ;;21,"65862-0868-03 ")
 ;;3822
 ;;21,"65862-0868-10 ")
 ;;3823
 ;;21,"65862-0869-03 ")
 ;;3824
 ;;21,"65862-0869-10 ")
 ;;3825
 ;;21,"66105-0503-01 ")
 ;;3826
 ;;21,"66105-0503-03 ")
 ;;3827
 ;;21,"66105-0503-06 ")
 ;;3828
 ;;21,"66105-0503-09 ")
 ;;3829
 ;;21,"66105-0503-15 ")
 ;;3830
 ;;21,"66105-0504-01 ")
 ;;3831
 ;;21,"66105-0504-03 ")
 ;;3832
 ;;21,"66105-0504-06 ")
 ;;3833
 ;;21,"66105-0504-09 ")
 ;;3834
 ;;21,"66105-0504-15 ")
 ;;3835
 ;;21,"66105-0545-01 ")
 ;;3836
 ;;21,"66105-0545-03 ")
 ;;3837
 ;;21,"66105-0545-06 ")
 ;;3838
 ;;21,"66105-0545-09 ")
 ;;3839
 ;;21,"66105-0545-10 ")
 ;;3840
 ;;21,"66105-0553-03 ")
 ;;3841
 ;;21,"66105-0663-03 ")
 ;;3842
 ;;21,"66105-0669-03 ")
 ;;3843
 ;;21,"66105-0842-03 ")
 ;;3844
 ;;21,"66105-0842-06 ")
 ;;3845
 ;;21,"66105-0842-09 ")
 ;;3846
 ;;21,"66105-0842-10 ")
 ;;3847
 ;;21,"66105-0842-28 ")
 ;;3848
 ;;21,"66116-0237-30 ")
 ;;3849
 ;;21,"66116-0279-30 ")
 ;;3850
 ;;21,"66116-0435-30 ")
 ;;3851
 ;;21,"66116-0436-30 ")
 ;;3852
 ;;21,"66267-0253-30 ")
 ;;3853
 ;;21,"66267-0323-30 ")
 ;;3854
 ;;21,"66267-0323-60 ")
 ;;3855
 ;;21,"66267-0323-90 ")
 ;;3856
 ;;21,"66267-0323-91 ")
 ;;3857
 ;;21,"66267-0380-30 ")
 ;;3858
 ;;21,"66267-0380-60 ")
 ;;3859
 ;;21,"66267-0380-90 ")
 ;;3860
 ;;21,"66267-0380-91 ")
 ;;3861
 ;;21,"66267-0413-30 ")
 ;;3862
 ;;21,"66267-0413-60 ")
 ;;3863
 ;;21,"66267-0413-90 ")
 ;;3864
 ;;21,"66267-0413-92 ")
 ;;3865
 ;;21,"66267-0523-30 ")
 ;;3866
 ;;21,"66267-0523-60 ")
 ;;3867
 ;;21,"66267-0570-30 ")
 ;;3868
 ;;21,"66267-0577-30 ")
 ;;3869
 ;;21,"66267-0583-30 ")
 ;;3870
 ;;21,"66267-0751-30 ")
 ;;3871
 ;;21,"66267-0751-90 ")
 ;;3872
 ;;21,"66267-0752-30 ")
 ;;3873
 ;;21,"66267-0752-90 ")
 ;;3874
 ;;21,"66267-1009-00 ")
 ;;3875
 ;;21,"66336-0393-90 ")
 ;;3876
 ;;21,"66336-0572-90 ")
 ;;3877
 ;;21,"66336-0665-15 ")
 ;;3878
 ;;21,"66336-0665-30 ")
 ;;3879
 ;;21,"66336-0666-30 ")
 ;;3880
 ;;21,"66685-0302-00 ")
 ;;3881
 ;;21,"66685-0302-02 ")
 ;;3882
 ;;21,"66685-0303-00 ")
 ;;3883
 ;;21,"66685-0304-00 ")
 ;;3884
 ;;21,"66685-0304-02 ")
 ;;3885
 ;;21,"66685-0706-04 ")
 ;;3886
 ;;21,"67544-0062-30 ")
 ;;3887
 ;;21,"67544-0062-60 ")
 ;;3888
 ;;21,"67544-0062-82 ")
 ;;3889
 ;;21,"67544-0128-15 ")
 ;;3890
 ;;21,"67544-0128-30 ")
 ;;3891
 ;;21,"67544-0128-45 ")
 ;;3892
 ;;21,"67544-0128-53 ")
 ;;3893
 ;;21,"67544-0128-60 ")
 ;;3894
 ;;21,"67544-0134-15 ")
 ;;3895
 ;;21,"67544-0134-30 ")
 ;;3896
 ;;21,"67544-0134-45 ")
 ;;3897
 ;;21,"67544-0134-60 ")
 ;;3898
 ;;21,"67544-0134-80 ")
 ;;3899
 ;;21,"67544-0148-15 ")
 ;;3900
 ;;21,"67544-0148-30 ")
 ;;3901
 ;;21,"67544-0148-45 ")
 ;;3902
 ;;21,"67544-0148-53 ")
 ;;3903
 ;;21,"67544-0148-60 ")
 ;;3904
 ;;21,"67544-0148-80 ")
 ;;3905
 ;;21,"67544-0150-45 ")
 ;;3906
 ;;21,"67544-0150-60 ")
 ;;3907
 ;;21,"67544-0150-73 ")
 ;;3908
 ;;21,"67544-0150-92 ")
 ;;3909
 ;;21,"67544-0159-15 ")
 ;;3910
 ;;21,"67544-0159-30 ")
 ;;3911
 ;;21,"67544-0159-45 ")
 ;;3912
 ;;21,"67544-0159-58 ")
 ;;3913
 ;;21,"67544-0159-60 ")
 ;;3914
 ;;21,"67544-0159-80 ")
 ;;3915
 ;;21,"67544-0160-60 ")
 ;;3916
 ;;21,"67544-0160-80 ")
 ;;3917
 ;;21,"67544-0165-80 ")
 ;;3918
 ;;21,"67544-0173-30 ")
 ;;3919
 ;;21,"67544-0173-45 ")
 ;;3920
 ;;21,"67544-0173-53 ")
 ;;3921
 ;;21,"67544-0173-60 ")
 ;;3922
 ;;21,"67544-0174-30 ")
 ;;3923
 ;;21,"67544-0174-45 ")
 ;;3924
 ;;21,"67544-0174-60 ")
 ;;3925
 ;;21,"67544-0174-80 ")
 ;;3926
 ;;21,"67544-0177-45 ")
 ;;3927
 ;;21,"67544-0192-30 ")
 ;;3928
 ;;21,"67544-0192-45 ")
 ;;3929
 ;;21,"67544-0192-53 ")
 ;;3930
 ;;21,"67544-0192-60 ")
 ;;3931
 ;;21,"67544-0212-45 ")
 ;;3932
 ;;21,"67544-0212-53 ")
 ;;3933
 ;;21,"67544-0218-60 ")
 ;;3934
 ;;21,"67544-0218-82 ")
 ;;3935
 ;;21,"67544-0219-15 ")
 ;;3936
 ;;21,"67544-0219-30 ")
 ;;3937
 ;;21,"67544-0219-45 ")
 ;;3938
 ;;21,"67544-0219-60 ")
 ;;3939
 ;;21,"67544-0234-32 ")
 ;;3940
 ;;21,"67544-0234-45 ")
 ;;3941
 ;;21,"67544-0234-53 ")
 ;;3942
 ;;21,"67544-0250-60 ")
 ;;3943
 ;;21,"67544-0250-80 ")
 ;;3944
 ;;21,"67544-0276-60 ")
 ;;3945
 ;;21,"67544-0276-80 ")
 ;;3946
 ;;21,"67544-0306-30 ")
 ;;3947
 ;;21,"67544-0306-45 ")
 ;;3948
 ;;21,"67544-0306-60 ")
 ;;3949
 ;;21,"67544-0311-30 ")
 ;;3950
 ;;21,"67544-0311-45 ")
 ;;3951
 ;;21,"67544-0321-15 ")
 ;;3952
 ;;21,"67544-0321-30 ")
 ;;3953
 ;;21,"67544-0321-60 ")
 ;;3954
 ;;21,"67544-0322-30 ")
 ;;3955
 ;;21,"67544-0322-45 ")
 ;;3956
 ;;21,"67544-0322-53 ")
 ;;3957
 ;;21,"67544-0322-60 ")
 ;;3958
 ;;21,"67544-0322-73 ")
 ;;3959
 ;;21,"67544-0322-80 ")
 ;;3960
 ;;21,"67544-0322-92 ")
 ;;3961
 ;;21,"67544-0322-94 ")
 ;;3962
 ;;21,"67544-0382-30 ")
 ;;3963
 ;;21,"67544-0382-60 ")
 ;;3964
 ;;21,"67544-0400-45 ")
 ;;3965
 ;;21,"67544-0403-30 ")
 ;;3966
 ;;21,"67544-0403-79 ")
 ;;3967
 ;;21,"67544-0404-30 ")
 ;;3968
 ;;21,"67544-0404-79 ")
 ;;3969
 ;;21,"67544-0418-60 ")
 ;;3970
 ;;21,"67544-0418-80 ")
 ;;3971
 ;;21,"67544-0431-15 ")
 ;;3972
 ;;21,"67544-0431-30 ")
 ;;3973
 ;;21,"67544-0431-45 ")
 ;;3974
 ;;21,"67544-0431-53 ")
 ;;3975
 ;;21,"67544-0431-60 ")
 ;;3976
 ;;21,"67544-0431-70 ")
 ;;3977
 ;;21,"67544-0431-73 ")
 ;;3978
 ;;21,"67544-0431-80 ")
 ;;3979
 ;;21,"67544-0431-92 ")
 ;;3980
 ;;21,"67544-0431-94 ")
 ;;3981
 ;;21,"67544-0997-30 ")
 ;;3982
 ;;21,"68001-0130-00 ")
 ;;3983
 ;;21,"68001-0131-00 ")
 ;;3984
 ;;21,"68001-0132-00 ")
 ;;3985
 ;;21,"68001-0133-00 ")
 ;;3986
 ;;21,"68001-0134-00 ")
 ;;3987
 ;;21,"68001-0135-00 ")
 ;;3988
 ;;21,"68001-0140-04 ")
 ;;3989
 ;;21,"68001-0141-00 ")
 ;;3990
 ;;21,"68001-0141-03 ")
 ;;3991
 ;;21,"68001-0142-00 ")
 ;;3992
 ;;21,"68001-0142-03 ")
 ;;3993
 ;;21,"68001-0143-00 ")
 ;;3994
 ;;21,"68001-0143-03 ")
 ;;3995
 ;;21,"68001-0186-05 ")
 ;;3996
 ;;21,"68001-0187-05 ")
 ;;3997
 ;;21,"68001-0188-05 ")
 ;;3998
 ;;21,"68001-0189-05 ")
 ;;3999
 ;;21,"68001-0207-00 ")
 ;;4000
 ;;21,"68001-0207-08 ")
 ;;4001
 ;;21,"68001-0208-00 ")
 ;;4002
 ;;21,"68001-0208-08 ")
 ;;4003
 ;;21,"68001-0209-00 ")
 ;;4004
 ;;21,"68001-0209-08 ")
 ;;4005
 ;;21,"68001-0210-00 ")
 ;;4006
 ;;21,"68001-0210-08 ")
 ;;4007
 ;;21,"68001-0211-00 ")
 ;;4008
 ;;21,"68001-0211-08 ")
 ;;4009
 ;;21,"68001-0212-00 ")
 ;;4010
 ;;21,"68001-0260-05 ")
 ;;4011
 ;;21,"68001-0268-00 ")
 ;;4012
 ;;21,"68001-0268-08 ")
 ;;4013
 ;;21,"68001-0269-00 ")
 ;;4014
 ;;21,"68001-0269-08 ")
 ;;4015
 ;;21,"68001-0270-00 ")
 ;;4016
 ;;21,"68001-0271-00 ")
 ;;4017
 ;;21,"68001-0271-08 ")
 ;;4018
 ;;21,"68071-0026-30 ")
 ;;4019
 ;;21,"68071-0026-60 ")
 ;;4020