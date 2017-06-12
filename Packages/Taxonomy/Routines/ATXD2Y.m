ATXD2Y ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 28, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;BGP IVD DXS
 ;
 ; This routine loads Taxonomy BGP IVD DXS
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
 ;;21,"411.0 ")
 ;;1
 ;;21,"413.0 ")
 ;;2
 ;;21,"414.2 ")
 ;;3
 ;;21,"414.8 ")
 ;;4
 ;;21,"429.2 ")
 ;;5
 ;;21,"433.0 ")
 ;;6
 ;;21,"440.1 ")
 ;;7
 ;;21,"440.4 ")
 ;;8
 ;;21,"444.0 ")
 ;;9
 ;;21,"I20.0 ")
 ;;10
 ;;21,"I20.1 ")
 ;;11
 ;;21,"I20.8 ")
 ;;12
 ;;21,"I20.9 ")
 ;;13
 ;;21,"I24.0 ")
 ;;14
 ;;21,"I24.1 ")
 ;;15
 ;;21,"I24.8 ")
 ;;16
 ;;21,"I24.9 ")
 ;;17
 ;;21,"I25.10 ")
 ;;18
 ;;21,"I25.110 ")
 ;;19
 ;;21,"I25.111 ")
 ;;20
 ;;21,"I25.118 ")
 ;;21
 ;;21,"I25.119 ")
 ;;22
 ;;21,"I25.5 ")
 ;;23
 ;;21,"I25.6 ")
 ;;24
 ;;21,"I25.700 ")
 ;;25
 ;;21,"I25.701 ")
 ;;26
 ;;21,"I25.708 ")
 ;;27
 ;;21,"I25.709 ")
 ;;28
 ;;21,"I25.710 ")
 ;;29
 ;;21,"I25.711 ")
 ;;30
 ;;21,"I25.718 ")
 ;;31
 ;;21,"I25.719 ")
 ;;32
 ;;21,"I25.720 ")
 ;;33
 ;;21,"I25.721 ")
 ;;34
 ;;21,"I25.728 ")
 ;;35
 ;;21,"I25.729 ")
 ;;36
 ;;21,"I25.730 ")
 ;;37
 ;;21,"I25.731 ")
 ;;38
 ;;21,"I25.738 ")
 ;;39
 ;;21,"I25.739 ")
 ;;40
 ;;21,"I25.750 ")
 ;;41
 ;;21,"I25.751 ")
 ;;42
 ;;21,"I25.758 ")
 ;;43
 ;;21,"I25.759 ")
 ;;44
 ;;21,"I25.760 ")
 ;;45
 ;;21,"I25.761 ")
 ;;46
 ;;21,"I25.768 ")
 ;;47
 ;;21,"I25.769 ")
 ;;48
 ;;21,"I25.790 ")
 ;;49
 ;;21,"I25.791 ")
 ;;50
 ;;21,"I25.798 ")
 ;;51
 ;;21,"I25.799 ")
 ;;52
 ;;21,"I25.810 ")
 ;;53
 ;;21,"I25.811 ")
 ;;54
 ;;21,"I25.812 ")
 ;;55
 ;;21,"I70.201 ")
 ;;56
 ;;21,"I70.202 ")
 ;;57
 ;;21,"I70.203 ")
 ;;58
 ;;21,"I70.208 ")
 ;;59
 ;;21,"I70.209 ")
 ;;60
 ;;21,"I70.211 ")
 ;;61
 ;;21,"I70.212 ")
 ;;62
 ;;21,"I70.213 ")
 ;;63
 ;;21,"I70.218 ")
 ;;64
 ;;21,"I70.219 ")
 ;;65
 ;;21,"I70.221 ")
 ;;66
 ;;21,"I70.222 ")
 ;;67
 ;;21,"I70.223 ")
 ;;68
 ;;21,"I70.228 ")
 ;;69
 ;;21,"I70.229 ")
 ;;70
 ;;21,"I70.231 ")
 ;;71
 ;;21,"I70.232 ")
 ;;72
 ;;21,"I70.233 ")
 ;;73
 ;;21,"I70.234 ")
 ;;74
 ;;21,"I70.235 ")
 ;;75
 ;;21,"I70.238 ")
 ;;76
 ;;21,"I70.239 ")
 ;;77
 ;;21,"I70.241 ")
 ;;78
 ;;21,"I70.242 ")
 ;;79
 ;;21,"I70.243 ")
 ;;80
 ;;21,"I70.244 ")
 ;;81
 ;;21,"I70.245 ")
 ;;82
 ;;21,"I70.248 ")
 ;;83
 ;;21,"I70.249 ")
 ;;84
 ;;21,"I70.25 ")
 ;;85
 ;;21,"I70.261 ")
 ;;86
 ;;21,"I70.262 ")
 ;;87
 ;;21,"I70.263 ")
 ;;88
 ;;21,"I70.268 ")
 ;;89
 ;;21,"I70.269 ")
 ;;90
 ;;21,"I70.291 ")
 ;;91
 ;;21,"I70.292 ")
 ;;92
 ;;21,"I70.293 ")
 ;;93
 ;;21,"I70.298 ")
 ;;94
 ;;21,"I70.299 ")
 ;;95
 ;;21,"I70.92 ")
 ;;96
 ;;21,"I75.011 ")
 ;;97
 ;;21,"I75.012 ")
 ;;98
 ;;21,"I75.013 ")
 ;;99
 ;;21,"I75.019 ")
 ;;100
 ;;21,"I75.021 ")
 ;;101
 ;;21,"I75.022 ")
 ;;102
 ;;21,"I75.023 ")
 ;;103
 ;;21,"I75.029 ")
 ;;104
 ;;21,"I75.81 ")
 ;;105
 ;;21,"I75.89 ")
 ;;106
 ;;9002226,525,.01)
 ;;BGP IVD DXS
 ;;9002226,525,.02)
 ;;@
 ;;9002226,525,.04)
 ;;n
 ;;9002226,525,.06)
 ;;@
 ;;9002226,525,.08)
 ;;0
 ;;9002226,525,.09)
 ;;3130515
 ;;9002226,525,.11)
 ;;@
 ;;9002226,525,.12)
 ;;31
 ;;9002226,525,.13)
 ;;1
 ;;9002226,525,.14)
 ;;@
 ;;9002226,525,.15)
 ;;80
 ;;9002226,525,.16)
 ;;@
 ;;9002226,525,.17)
 ;;@
 ;;9002226,525,3101)
 ;;@
 ;;9002226.02101,"525,411.0 ",.01)
 ;;411.0 
 ;;9002226.02101,"525,411.0 ",.02)
 ;;411.89 
 ;;9002226.02101,"525,411.0 ",.03)
 ;;1
 ;;9002226.02101,"525,413.0 ",.01)
 ;;413.0 
 ;;9002226.02101,"525,413.0 ",.02)
 ;;414.07 
 ;;9002226.02101,"525,413.0 ",.03)
 ;;1
 ;;9002226.02101,"525,414.2 ",.01)
 ;;414.2 
 ;;9002226.02101,"525,414.2 ",.02)
 ;;414.2 
 ;;9002226.02101,"525,414.2 ",.03)
 ;;1
 ;;9002226.02101,"525,414.8 ",.01)
 ;;414.8 
 ;;9002226.02101,"525,414.8 ",.02)
 ;;414.9 
 ;;9002226.02101,"525,414.8 ",.03)
 ;;1
 ;;9002226.02101,"525,429.2 ",.01)
 ;;429.2 
 ;;9002226.02101,"525,429.2 ",.02)
 ;;429.2 
 ;;9002226.02101,"525,429.2 ",.03)
 ;;1
 ;;9002226.02101,"525,433.0 ",.01)
 ;;433.0 
 ;;9002226.02101,"525,433.0 ",.02)
 ;;434.91 
 ;;9002226.02101,"525,433.0 ",.03)
 ;;1
 ;;9002226.02101,"525,440.1 ",.01)
 ;;440.1 
 ;;9002226.02101,"525,440.1 ",.02)
 ;;440.29 
 ;;9002226.02101,"525,440.1 ",.03)
 ;;1
 ;;9002226.02101,"525,440.4 ",.01)
 ;;440.4 
 ;;9002226.02101,"525,440.4 ",.02)
 ;;440.4 
 ;;9002226.02101,"525,440.4 ",.03)
 ;;1
 ;;9002226.02101,"525,444.0 ",.01)
 ;;444.0 
 ;;9002226.02101,"525,444.0 ",.02)
 ;;445.89 
 ;;9002226.02101,"525,444.0 ",.03)
 ;;1
 ;;9002226.02101,"525,I20.0 ",.01)
 ;;I20.0
 ;;9002226.02101,"525,I20.0 ",.02)
 ;;I20.0
 ;;9002226.02101,"525,I20.0 ",.03)
 ;;30
 ;;9002226.02101,"525,I20.1 ",.01)
 ;;I20.1
 ;;9002226.02101,"525,I20.1 ",.02)
 ;;I20.1
 ;;9002226.02101,"525,I20.1 ",.03)
 ;;30
 ;;9002226.02101,"525,I20.8 ",.01)
 ;;I20.8
 ;;9002226.02101,"525,I20.8 ",.02)
 ;;I20.8
 ;;9002226.02101,"525,I20.8 ",.03)
 ;;30
 ;;9002226.02101,"525,I20.9 ",.01)
 ;;I20.9
 ;;9002226.02101,"525,I20.9 ",.02)
 ;;I20.9
 ;;9002226.02101,"525,I20.9 ",.03)
 ;;30
 ;;9002226.02101,"525,I24.0 ",.01)
 ;;I24.0
 ;;9002226.02101,"525,I24.0 ",.02)
 ;;I24.0
 ;;9002226.02101,"525,I24.0 ",.03)
 ;;30
 ;;9002226.02101,"525,I24.1 ",.01)
 ;;I24.1
 ;;9002226.02101,"525,I24.1 ",.02)
 ;;I24.1
 ;;9002226.02101,"525,I24.1 ",.03)
 ;;30
 ;;9002226.02101,"525,I24.8 ",.01)
 ;;I24.8
 ;;9002226.02101,"525,I24.8 ",.02)
 ;;I24.8
 ;;9002226.02101,"525,I24.8 ",.03)
 ;;30
 ;;9002226.02101,"525,I24.9 ",.01)
 ;;I24.9
 ;;9002226.02101,"525,I24.9 ",.02)
 ;;I24.9
 ;;9002226.02101,"525,I24.9 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.10 ",.01)
 ;;I25.10
 ;;9002226.02101,"525,I25.10 ",.02)
 ;;I25.10
 ;;9002226.02101,"525,I25.10 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.110 ",.01)
 ;;I25.110
 ;;9002226.02101,"525,I25.110 ",.02)
 ;;I25.110
 ;;9002226.02101,"525,I25.110 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.111 ",.01)
 ;;I25.111
 ;;9002226.02101,"525,I25.111 ",.02)
 ;;I25.111
 ;;9002226.02101,"525,I25.111 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.118 ",.01)
 ;;I25.118
 ;;9002226.02101,"525,I25.118 ",.02)
 ;;I25.118
 ;;9002226.02101,"525,I25.118 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.119 ",.01)
 ;;I25.119
 ;;9002226.02101,"525,I25.119 ",.02)
 ;;I25.119
 ;;9002226.02101,"525,I25.119 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.5 ",.01)
 ;;I25.5
 ;;9002226.02101,"525,I25.5 ",.02)
 ;;I25.5
 ;;9002226.02101,"525,I25.5 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.6 ",.01)
 ;;I25.6
 ;;9002226.02101,"525,I25.6 ",.02)
 ;;I25.6
 ;;9002226.02101,"525,I25.6 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.700 ",.01)
 ;;I25.700
 ;;9002226.02101,"525,I25.700 ",.02)
 ;;I25.700
 ;;9002226.02101,"525,I25.700 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.701 ",.01)
 ;;I25.701
 ;;9002226.02101,"525,I25.701 ",.02)
 ;;I25.701
 ;;9002226.02101,"525,I25.701 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.708 ",.01)
 ;;I25.708
 ;;9002226.02101,"525,I25.708 ",.02)
 ;;I25.708
 ;;9002226.02101,"525,I25.708 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.709 ",.01)
 ;;I25.709
 ;;9002226.02101,"525,I25.709 ",.02)
 ;;I25.709
 ;;9002226.02101,"525,I25.709 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.710 ",.01)
 ;;I25.710
 ;;9002226.02101,"525,I25.710 ",.02)
 ;;I25.710
 ;;9002226.02101,"525,I25.710 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.711 ",.01)
 ;;I25.711
 ;;9002226.02101,"525,I25.711 ",.02)
 ;;I25.711
 ;;9002226.02101,"525,I25.711 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.718 ",.01)
 ;;I25.718
 ;;9002226.02101,"525,I25.718 ",.02)
 ;;I25.718
 ;;9002226.02101,"525,I25.718 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.719 ",.01)
 ;;I25.719
 ;;9002226.02101,"525,I25.719 ",.02)
 ;;I25.719
 ;;9002226.02101,"525,I25.719 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.720 ",.01)
 ;;I25.720
 ;;9002226.02101,"525,I25.720 ",.02)
 ;;I25.720
 ;;9002226.02101,"525,I25.720 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.721 ",.01)
 ;;I25.721
 ;;9002226.02101,"525,I25.721 ",.02)
 ;;I25.721
 ;;9002226.02101,"525,I25.721 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.728 ",.01)
 ;;I25.728
 ;;9002226.02101,"525,I25.728 ",.02)
 ;;I25.728
 ;;9002226.02101,"525,I25.728 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.729 ",.01)
 ;;I25.729
 ;;9002226.02101,"525,I25.729 ",.02)
 ;;I25.729
 ;;9002226.02101,"525,I25.729 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.730 ",.01)
 ;;I25.730
 ;;9002226.02101,"525,I25.730 ",.02)
 ;;I25.730
 ;;9002226.02101,"525,I25.730 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.731 ",.01)
 ;;I25.731
 ;;9002226.02101,"525,I25.731 ",.02)
 ;;I25.731
 ;;9002226.02101,"525,I25.731 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.738 ",.01)
 ;;I25.738
 ;;9002226.02101,"525,I25.738 ",.02)
 ;;I25.738
 ;;9002226.02101,"525,I25.738 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.739 ",.01)
 ;;I25.739
 ;;9002226.02101,"525,I25.739 ",.02)
 ;;I25.739
 ;;9002226.02101,"525,I25.739 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.750 ",.01)
 ;;I25.750
 ;;9002226.02101,"525,I25.750 ",.02)
 ;;I25.750
 ;;9002226.02101,"525,I25.750 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.751 ",.01)
 ;;I25.751
 ;;9002226.02101,"525,I25.751 ",.02)
 ;;I25.751
 ;;9002226.02101,"525,I25.751 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.758 ",.01)
 ;;I25.758
 ;;9002226.02101,"525,I25.758 ",.02)
 ;;I25.758
 ;;9002226.02101,"525,I25.758 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.759 ",.01)
 ;;I25.759
 ;;9002226.02101,"525,I25.759 ",.02)
 ;;I25.759
 ;;9002226.02101,"525,I25.759 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.760 ",.01)
 ;;I25.760
 ;;9002226.02101,"525,I25.760 ",.02)
 ;;I25.760
 ;;9002226.02101,"525,I25.760 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.761 ",.01)
 ;;I25.761
 ;;9002226.02101,"525,I25.761 ",.02)
 ;;I25.761
 ;;9002226.02101,"525,I25.761 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.768 ",.01)
 ;;I25.768
 ;;9002226.02101,"525,I25.768 ",.02)
 ;;I25.768
 ;;9002226.02101,"525,I25.768 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.769 ",.01)
 ;;I25.769
 ;;9002226.02101,"525,I25.769 ",.02)
 ;;I25.769
 ;;9002226.02101,"525,I25.769 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.790 ",.01)
 ;;I25.790
 ;;9002226.02101,"525,I25.790 ",.02)
 ;;I25.790
 ;;9002226.02101,"525,I25.790 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.791 ",.01)
 ;;I25.791
 ;;9002226.02101,"525,I25.791 ",.02)
 ;;I25.791
 ;;9002226.02101,"525,I25.791 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.798 ",.01)
 ;;I25.798
 ;;9002226.02101,"525,I25.798 ",.02)
 ;;I25.798
 ;;9002226.02101,"525,I25.798 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.799 ",.01)
 ;;I25.799
 ;;9002226.02101,"525,I25.799 ",.02)
 ;;I25.799
 ;;9002226.02101,"525,I25.799 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.810 ",.01)
 ;;I25.810
 ;;9002226.02101,"525,I25.810 ",.02)
 ;;I25.810
 ;;9002226.02101,"525,I25.810 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.811 ",.01)
 ;;I25.811
 ;;9002226.02101,"525,I25.811 ",.02)
 ;;I25.811
 ;;9002226.02101,"525,I25.811 ",.03)
 ;;30
 ;;9002226.02101,"525,I25.812 ",.01)
 ;;I25.812
 ;;9002226.02101,"525,I25.812 ",.02)
 ;;I25.812
 ;;9002226.02101,"525,I25.812 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.201 ",.01)
 ;;I70.201
 ;;9002226.02101,"525,I70.201 ",.02)
 ;;I70.201
 ;;9002226.02101,"525,I70.201 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.202 ",.01)
 ;;I70.202
 ;;9002226.02101,"525,I70.202 ",.02)
 ;;I70.202
 ;;9002226.02101,"525,I70.202 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.203 ",.01)
 ;;I70.203
 ;;9002226.02101,"525,I70.203 ",.02)
 ;;I70.203
 ;;9002226.02101,"525,I70.203 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.208 ",.01)
 ;;I70.208
 ;;9002226.02101,"525,I70.208 ",.02)
 ;;I70.208
 ;;9002226.02101,"525,I70.208 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.209 ",.01)
 ;;I70.209
 ;;9002226.02101,"525,I70.209 ",.02)
 ;;I70.209
 ;;9002226.02101,"525,I70.209 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.211 ",.01)
 ;;I70.211
 ;;9002226.02101,"525,I70.211 ",.02)
 ;;I70.211
 ;;9002226.02101,"525,I70.211 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.212 ",.01)
 ;;I70.212
 ;;9002226.02101,"525,I70.212 ",.02)
 ;;I70.212
 ;;9002226.02101,"525,I70.212 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.213 ",.01)
 ;;I70.213
 ;;9002226.02101,"525,I70.213 ",.02)
 ;;I70.213
 ;;9002226.02101,"525,I70.213 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.218 ",.01)
 ;;I70.218
 ;;9002226.02101,"525,I70.218 ",.02)
 ;;I70.218
 ;;9002226.02101,"525,I70.218 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.219 ",.01)
 ;;I70.219
 ;;9002226.02101,"525,I70.219 ",.02)
 ;;I70.219
 ;;9002226.02101,"525,I70.219 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.221 ",.01)
 ;;I70.221
 ;;9002226.02101,"525,I70.221 ",.02)
 ;;I70.221
 ;;9002226.02101,"525,I70.221 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.222 ",.01)
 ;;I70.222
 ;;9002226.02101,"525,I70.222 ",.02)
 ;;I70.222
 ;;9002226.02101,"525,I70.222 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.223 ",.01)
 ;;I70.223
 ;;9002226.02101,"525,I70.223 ",.02)
 ;;I70.223
 ;;9002226.02101,"525,I70.223 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.228 ",.01)
 ;;I70.228
 ;;9002226.02101,"525,I70.228 ",.02)
 ;;I70.228
 ;;9002226.02101,"525,I70.228 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.229 ",.01)
 ;;I70.229
 ;;9002226.02101,"525,I70.229 ",.02)
 ;;I70.229
 ;;9002226.02101,"525,I70.229 ",.03)
 ;;30
 ;;9002226.02101,"525,I70.231 ",.01)
 ;;I70.231
 ;;9002226.02101,"525,I70.231 ",.02)
 ;;I70.231
 ;
OTHER ; OTHER ROUTINES
 D ^ATXD2Y2
 Q