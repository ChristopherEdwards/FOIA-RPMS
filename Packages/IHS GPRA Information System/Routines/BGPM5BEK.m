BGPM5BEK ;IHS/MSC/MMT-CREATED BY ^ATXSTX ON SEP 12, 2011;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"55045226608 ")
 ;;2645
 ;;21,"55045226609 ")
 ;;2646
 ;;21,"55045226700 ")
 ;;2647
 ;;21,"55045226708 ")
 ;;2648
 ;;21,"55045232201 ")
 ;;2649
 ;;21,"55045232208 ")
 ;;2650
 ;;21,"55045261700 ")
 ;;2651
 ;;21,"55045290400 ")
 ;;785
 ;;21,"55045290402 ")
 ;;786
 ;;21,"55045290409 ")
 ;;787
 ;;21,"55045290500 ")
 ;;788
 ;;21,"55045290503 ")
 ;;789
 ;;21,"55045290506 ")
 ;;790
 ;;21,"55045290508 ")
 ;;791
 ;;21,"55045290600 ")
 ;;792
 ;;21,"55045290601 ")
 ;;793
 ;;21,"55045290602 ")
 ;;794
 ;;21,"55045290606 ")
 ;;795
 ;;21,"55045290609 ")
 ;;796
 ;;21,"55045328701 ")
 ;;797
 ;;21,"55045330001 ")
 ;;2652
 ;;21,"55045360702 ")
 ;;2653
 ;;21,"55045361304 ")
 ;;2654
 ;;21,"55111032001 ")
 ;;2655
 ;;21,"55111032005 ")
 ;;2656
 ;;21,"55111032030 ")
 ;;2657
 ;;21,"55111032078 ")
 ;;2658
 ;;21,"55111032101 ")
 ;;2659
 ;;21,"55111032105 ")
 ;;2660
 ;;21,"55111032130 ")
 ;;2661
 ;;21,"55111032178 ")
 ;;2662
 ;;21,"55111032179 ")
 ;;2663
 ;;21,"55111032201 ")
 ;;2664
 ;;21,"55111032205 ")
 ;;2665
 ;;21,"55111032230 ")
 ;;2666
 ;;21,"55111032278 ")
 ;;2667
 ;;21,"55111032279 ")
 ;;2668
 ;;21,"55111032801 ")
 ;;2009
 ;;21,"55111032805 ")
 ;;2010
 ;;21,"55111032830 ")
 ;;2011
 ;;21,"55111032878 ")
 ;;2012
 ;;21,"55111032879 ")
 ;;2013
 ;;21,"55111032890 ")
 ;;2014
 ;;21,"55111032901 ")
 ;;2015
 ;;21,"55111032905 ")
 ;;2016
 ;;21,"55111032930 ")
 ;;2017
 ;;21,"55111032978 ")
 ;;2018
 ;;21,"55111032979 ")
 ;;2019
 ;;21,"55111032990 ")
 ;;2020
 ;;21,"55111042901 ")
 ;;798
 ;;21,"55111042905 ")
 ;;799
 ;;21,"55111042910 ")
 ;;800
 ;;21,"55111042930 ")
 ;;801
 ;;21,"55111042960 ")
 ;;802
 ;;21,"55111042978 ")
 ;;803
 ;;21,"55111043001 ")
 ;;804
 ;;21,"55111043005 ")
 ;;805
 ;;21,"55111043030 ")
 ;;806
 ;;21,"55111043060 ")
 ;;807
 ;;21,"55111043078 ")
 ;;808
 ;;21,"55111043101 ")
 ;;809
 ;;21,"55111043105 ")
 ;;810
 ;;21,"55111043130 ")
 ;;811
 ;;21,"55111043160 ")
 ;;812
 ;;21,"55111043178 ")
 ;;813
 ;;21,"55111069501 ")
 ;;66
 ;;21,"55111069505 ")
 ;;67
 ;;21,"55111069510 ")
 ;;68
 ;;21,"55111069601 ")
 ;;69
 ;;21,"55111069605 ")
 ;;70
 ;;21,"55111069610 ")
 ;;71
 ;;21,"55111069701 ")
 ;;72
 ;;21,"55111069705 ")
 ;;73
 ;;21,"55111069710 ")
 ;;74
 ;;21,"55154053400 ")
 ;;2678
 ;;21,"55154053404 ")
 ;;2679
 ;;21,"55154053406 ")
 ;;2680
 ;;21,"55154167509 ")
 ;;823
 ;;21,"55154167609 ")
 ;;824
 ;;21,"55154205800 ")
 ;;825
 ;;21,"55154317500 ")
 ;;2681
 ;;21,"55154317504 ")
 ;;2682
 ;;21,"55154317506 ")
 ;;2683
 ;;21,"55154343709 ")
 ;;826
 ;;21,"55154375001 ")
 ;;827
 ;;21,"55154455609 ")
 ;;2684
 ;;21,"55154455709 ")
 ;;2685
 ;;21,"55154456103 ")
 ;;828
 ;;21,"55154507000 ")
 ;;2686
 ;;21,"55154522400 ")
 ;;2687
 ;;21,"55154522407 ")
 ;;2688
 ;;21,"55154542209 ")
 ;;829
 ;;21,"55154547600 ")
 ;;2689
 ;;21,"55154547607 ")
 ;;2690
 ;;21,"55154548700 ")
 ;;830
 ;;21,"55154548707 ")
 ;;831
 ;;21,"55154558800 ")
 ;;2691
 ;;21,"55154566200 ")
 ;;2692
 ;;21,"55154585003 ")
 ;;832
 ;;21,"55154599204 ")
 ;;2693
 ;;21,"55154599206 ")
 ;;2694
 ;;21,"55154619000 ")
 ;;2695
 ;;21,"55154619600 ")
 ;;2696
 ;;21,"55154622408 ")
 ;;2697
 ;;21,"55154622409 ")
 ;;2698
 ;;21,"55154623809 ")
 ;;2699
 ;;21,"55154665703 ")
 ;;833
 ;;21,"55154827009 ")
 ;;2700
 ;;21,"55160012201 ")
 ;;2701
 ;;21,"55160012205 ")
 ;;2702
 ;;21,"55160012301 ")
 ;;2703
 ;;21,"55160012305 ")
 ;;2704
 ;;21,"55160014301 ")
 ;;834
 ;;21,"55160014305 ")
 ;;835
 ;;21,"55160014401 ")
 ;;836
 ;;21,"55160014501 ")
 ;;837
 ;;21,"55288124301 ")
 ;;2705
 ;;21,"55288125201 ")
 ;;2706
 ;;21,"55289006690 ")
 ;;2707
 ;;21,"55289006697 ")
 ;;2708
 ;;21,"55289017142 ")
 ;;4352
 ;;21,"55289018797 ")
 ;;2709
 ;;21,"55289026590 ")
 ;;2710
 ;;21,"55289028130 ")
 ;;75
 ;;21,"55289028160 ")
 ;;76
 ;;21,"55289028186 ")
 ;;77
 ;;21,"55289028190 ")
 ;;78
 ;;21,"55289030193 ")
 ;;2715
 ;;21,"55289038430 ")
 ;;842
 ;;21,"55289038460 ")
 ;;843
 ;;21,"55289038486 ")
 ;;844
 ;;21,"55289038490 ")
 ;;845
 ;;21,"55289038493 ")
 ;;846
 ;;21,"55289038494 ")
 ;;847
 ;;21,"55289060630 ")
 ;;2716
 ;;21,"55289060690 ")
 ;;2717
 ;;21,"55289061514 ")
 ;;848
 ;;21,"55289061530 ")
 ;;849
 ;;21,"55289061560 ")
 ;;850
 ;;21,"55289061586 ")
 ;;851
 ;;21,"55289061590 ")
 ;;852
 ;;21,"55289061593 ")
 ;;853
 ;;21,"55289061594 ")
 ;;854
 ;;21,"55289061598 ")
 ;;855
 ;;21,"55289077907 ")
 ;;2718
 ;;21,"55289080614 ")
 ;;2719
 ;;21,"55289080630 ")
 ;;2720
 ;;21,"55289080660 ")
 ;;2721
 ;;21,"55289080686 ")
 ;;2722
 ;;21,"55289080690 ")
 ;;2723
 ;;21,"55289089201 ")
 ;;2724
 ;;21,"55289089214 ")
 ;;2725
 ;;21,"55289089215 ")
 ;;2726
 ;;21,"55289089230 ")
 ;;2727
 ;;21,"55289089260 ")
 ;;2728
 ;;21,"55289089286 ")
 ;;2729
 ;;21,"55289089290 ")
 ;;2730
 ;;21,"55289089293 ")
 ;;2731
 ;;21,"55289089297 ")
 ;;2732
 ;;21,"55289089298 ")
 ;;2733
 ;;21,"55289091930 ")
 ;;856
 ;;21,"55289091960 ")
 ;;857
 ;;21,"55289091990 ")
 ;;858
 ;;21,"55289091993 ")
 ;;859
 ;;21,"55289091994 ")
 ;;860
 ;;21,"55289091998 ")
 ;;861
 ;;21,"55289093430 ")
 ;;862
 ;;21,"55289093460 ")
 ;;863
 ;;21,"55289093493 ")
 ;;864
 ;;21,"55289093494 ")
 ;;865
 ;;21,"55289093498 ")
 ;;866
 ;;21,"55289097601 ")
 ;;2734
 ;;21,"55289097614 ")
 ;;2735
 ;;21,"55289097630 ")
 ;;2736
 ;;21,"55289097660 ")
 ;;2737
 ;;21,"55289097693 ")
 ;;2738
 ;;21,"55370014607 ")
 ;;2739
 ;;21,"55370014608 ")
 ;;2740
 ;;21,"55370014609 ")
 ;;2741
 ;;21,"55370014707 ")
 ;;2742
 ;;21,"55370014708 ")
 ;;2743
 ;;21,"55370014709 ")
 ;;2744
 ;;21,"55370014907 ")
 ;;2745
 ;;21,"55370014909 ")
 ;;2746
 ;;21,"55370046010 ")
 ;;2747
 ;;21,"55370046011 ")
 ;;2748
 ;;21,"55370046050 ")
 ;;2749
 ;;21,"55370046110 ")
 ;;2750
 ;;21,"55370046111 ")
 ;;2751
 ;;21,"55370046150 ")
 ;;2752
 ;;21,"55370046210 ")
 ;;2753
 ;;21,"55370046211 ")
 ;;2754
 ;;21,"55370046250 ")
 ;;2755
 ;;21,"55370050607 ")
 ;;2756
 ;;21,"55370050608 ")
 ;;2757
 ;;21,"55370050609 ")
 ;;2758
 ;;21,"55370059207 ")
 ;;2759
 ;;21,"55370059407 ")
 ;;2760
 ;;21,"55370059408 ")
 ;;2761
 ;;21,"55370059507 ")
 ;;2762
 ;;21,"55370059607 ")
 ;;2763
 ;;21,"55370059608 ")
 ;;2764
 ;;21,"55370075607 ")
 ;;867
 ;;21,"55370075609 ")
 ;;868
 ;;21,"55370075707 ")
 ;;869
 ;;21,"55370075709 ")
 ;;870
 ;;21,"55370075907 ")
 ;;871
 ;;21,"55370075909 ")
 ;;872
 ;;21,"55567011300 ")
 ;;873
 ;;21,"55567011318 ")
 ;;874
 ;;21,"55567011325 ")
 ;;875
 ;;21,"55567014400 ")
 ;;876
 ;;21,"55567014418 ")
 ;;877
 ;;21,"55567014425 ")
 ;;878
 ;;21,"55567014500 ")
 ;;879
 ;;21,"55567014518 ")
 ;;880
 ;;21,"55567014525 ")
 ;;881
 ;;21,"55567014600 ")
 ;;882
 ;;21,"55567014618 ")
 ;;883
 ;;21,"55567014625 ")
 ;;884
 ;;21,"55887017330 ")
 ;;79
 ;;21,"55887017990 ")
 ;;2766
 ;;21,"55887021230 ")
 ;;2767
 ;;21,"55887022230 ")
 ;;2768
 ;;21,"55887022260 ")
 ;;2769
 ;;21,"55887022290 ")
 ;;2770
 ;;21,"55887033930 ")
 ;;2771
 ;;21,"55887033960 ")
 ;;2772
 ;;21,"55887033990 ")
 ;;2773
 ;;21,"55887036830 ")
 ;;80
 ;;21,"55887036860 ")
 ;;81
 ;;21,"55887036890 ")
 ;;82
 ;;21,"55887036896 ")
 ;;83
 ;;21,"55887041482 ")
 ;;890
 ;;21,"55887041492 ")
 ;;891
 ;;21,"55887053501 ")
 ;;2778
 ;;21,"55887053530 ")
 ;;2779
 ;;21,"55887053560 ")
 ;;2780
 ;;21,"55887053590 ")
 ;;2781
 ;;21,"55887053601 ")
 ;;2782
 ;;21,"55887053630 ")
 ;;2783
 ;;21,"55887053660 ")
 ;;2784
 ;;21,"55887053690 ")
 ;;2785
 ;;21,"55887053699 ")
 ;;2786
 ;;21,"55887057101 ")
 ;;892
 ;;21,"55887057130 ")
 ;;893
 ;;21,"55887057160 ")
 ;;894
 ;;21,"55887057182 ")
 ;;895
 ;;21,"55887057186 ")
 ;;896
 ;;21,"55887057190 ")
 ;;897
 ;;21,"55887057192 ")
 ;;898
 ;;21,"55887061430 ")
 ;;899
 ;;21,"55887061490 ")
 ;;900
 ;;21,"55887062701 ")
 ;;901
 ;;21,"55887062730 ")
 ;;902
 ;;21,"55887062760 ")
 ;;903
 ;;21,"55887062782 ")
 ;;904
 ;;21,"55887062790 ")
 ;;905
 ;;21,"55887062792 ")
 ;;906
 ;;21,"55887065730 ")
 ;;2787
 ;;21,"55887065760 ")
 ;;2788
 ;;21,"55887069301 ")
 ;;2789
 ;;21,"55887069330 ")
 ;;2790
 ;;21,"55887069360 ")
 ;;2791
 ;;21,"55887069390 ")
 ;;2792
 ;;21,"55887072701 ")
 ;;2793
 ;;21,"55887072730 ")
 ;;2794
 ;;21,"55887072760 ")
 ;;2795
 ;;21,"55887072790 ")
 ;;2796
 ;;21,"55887084530 ")
 ;;84
 ;;21,"55887084560 ")
 ;;85
 ;;21,"55887094030 ")
 ;;909
 ;;21,"55887094060 ")
 ;;910
 ;;21,"55887094090 ")
 ;;911
 ;;21,"55887096530 ")
 ;;2799
 ;;21,"57315001001 ")
 ;;2800
 ;;21,"57315001002 ")
 ;;2801
 ;;21,"57315001003 ")
 ;;2802
 ;;21,"57315001004 ")
 ;;2803
 ;;21,"57315001101 ")
 ;;2804
 ;;21,"57315001102 ")
 ;;2805
 ;;21,"57315001103 ")
 ;;2806
 ;;21,"57315001104 ")
 ;;2807
 ;;21,"57315004701 ")
 ;;912
 ;;21,"57315004703 ")
 ;;913
 ;;21,"57315004704 ")
 ;;914
 ;;21,"57315004801 ")
 ;;915
 ;;21,"57315004803 ")
 ;;916
 ;;21,"57315004804 ")
 ;;917
 ;;21,"57315004805 ")
 ;;918
 ;;21,"57315005001 ")
 ;;919
 ;;21,"57315005002 ")
 ;;920
 ;;21,"57315005003 ")
 ;;921
 ;;21,"57664039713 ")
 ;;922
 ;;21,"57664039718 ")
 ;;923
 ;;21,"57664039751 ")
 ;;924
 ;;21,"57664039753 ")
 ;;925
 ;;21,"57664039758 ")
 ;;926
 ;;21,"57664039759 ")
 ;;927
 ;;21,"57664039788 ")
 ;;928
 ;;21,"57664039799 ")
 ;;929
 ;;21,"57664039808 ")
 ;;2808
 ;;21,"57664039813 ")
 ;;2809
 ;;21,"57664039818 ")
 ;;2810
 ;;21,"57664039888 ")
 ;;2811
 ;;21,"57664039908 ")
 ;;2812
 ;;21,"57664039913 ")
 ;;2813
 ;;21,"57664039918 ")
 ;;2814
 ;;21,"57664039988 ")
 ;;2815
 ;;21,"57664043513 ")
 ;;930
 ;;21,"57664043518 ")
 ;;931
 ;;21,"57664043551 ")
 ;;932
 ;;21,"57664043553 ")
 ;;933
 ;;21,"57664043558 ")
 ;;934
 ;;21,"57664043559 ")
 ;;935
 ;;21,"57664043588 ")
 ;;936
 ;;21,"57664043599 ")
 ;;937
 ;;21,"57664047413 ")
 ;;938
 ;;21,"57664047418 ")
 ;;939
 ;;21,"57664047451 ")
 ;;940
 ;;21,"57664047453 ")
 ;;941
 ;;21,"57664047458 ")
 ;;942
 ;;21,"57664047459 ")
 ;;943
 ;;21,"57664047488 ")
 ;;944
 ;;21,"57664047499 ")
 ;;945
 ;;21,"57664072413 ")
 ;;86
 ;;21,"57664072418 ")
 ;;87
 ;;21,"57664072488 ")
 ;;88
 ;;21,"57664072513 ")
 ;;89
 ;;21,"57664072518 ")
 ;;90
 ;;21,"57664072588 ")
 ;;91
 ;;21,"57664072713 ")
 ;;92
 ;;21,"57664072718 ")
 ;;93
 ;;21,"57664072788 ")
 ;;94
 ;;21,"57664099813 ")
 ;;955
 ;;21,"57664099818 ")
 ;;956
 ;;21,"57664099888 ")
 ;;957
 ;;21,"57664099899 ")
 ;;958
 ;;21,"57664099913 ")
 ;;959
 ;;21,"57664099918 ")
 ;;960
 ;;21,"57664099988 ")
 ;;961
 ;;21,"57664099999 ")
 ;;962
 ;;21,"57866346201 ")
 ;;2825
 ;;21,"57866346502 ")
 ;;2826
 ;;21,"57866346505 ")
 ;;2827
 ;;21,"57866466802 ")
 ;;2828
 ;;21,"57866640701 ")
 ;;2829
 ;;21,"57866640801 ")
 ;;2830
 ;;21,"57866640802 ")
 ;;2831
 ;;21,"57866640901 ")
 ;;2832
 ;;21,"57866640902 ")
 ;;2833
 ;;21,"57866640903 ")
 ;;2834
 ;;21,"57866640904 ")
 ;;2835
 ;;21,"57866640905 ")
 ;;2836
 ;;21,"57866640906 ")
 ;;2837
 ;;21,"57866646201 ")
 ;;2838
 ;;21,"57866646203 ")
 ;;2839