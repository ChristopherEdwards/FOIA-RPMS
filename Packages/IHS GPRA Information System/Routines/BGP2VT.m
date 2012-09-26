BGP2VT ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP HEDIS GASTRO ANTISPASM NDC
 ;
 ; This routine loads Taxonomy BGP HEDIS GASTRO ANTISPASM NDC
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
 ;;21,"00054-4721-25 ")
 ;;179
 ;;21,"00115-3200-01 ")
 ;;1
 ;;21,"00115-3200-03 ")
 ;;2
 ;;21,"00115-3220-01 ")
 ;;97
 ;;21,"00115-3220-03 ")
 ;;98
 ;;21,"00115-4308-01 ")
 ;;180
 ;;21,"00115-4308-03 ")
 ;;181
 ;;21,"00143-1227-01 ")
 ;;99
 ;;21,"00143-1227-10 ")
 ;;100
 ;;21,"00143-3126-01 ")
 ;;3
 ;;21,"00143-3126-10 ")
 ;;4
 ;;21,"00182-1858-01 ")
 ;;182
 ;;21,"00247-0188-00 ")
 ;;5
 ;;21,"00247-0188-02 ")
 ;;6
 ;;21,"00247-0188-03 ")
 ;;7
 ;;21,"00247-0188-04 ")
 ;;8
 ;;21,"00247-0188-06 ")
 ;;9
 ;;21,"00247-0188-10 ")
 ;;10
 ;;21,"00247-0188-12 ")
 ;;11
 ;;21,"00247-0188-14 ")
 ;;12
 ;;21,"00247-0188-15 ")
 ;;13
 ;;21,"00247-0188-20 ")
 ;;14
 ;;21,"00247-0188-24 ")
 ;;15
 ;;21,"00247-0188-30 ")
 ;;16
 ;;21,"00247-0188-40 ")
 ;;17
 ;;21,"00247-0582-03 ")
 ;;101
 ;;21,"00247-0582-04 ")
 ;;102
 ;;21,"00247-0582-05 ")
 ;;103
 ;;21,"00247-0582-10 ")
 ;;104
 ;;21,"00247-0582-12 ")
 ;;105
 ;;21,"00247-0582-15 ")
 ;;106
 ;;21,"00247-0582-20 ")
 ;;107
 ;;21,"00247-0582-24 ")
 ;;108
 ;;21,"00247-0582-30 ")
 ;;109
 ;;21,"00247-1360-20 ")
 ;;183
 ;;21,"00247-1360-24 ")
 ;;184
 ;;21,"00247-2079-30 ")
 ;;94
 ;;21,"00378-1610-01 ")
 ;;18
 ;;21,"00378-1610-05 ")
 ;;19
 ;;21,"00378-1620-01 ")
 ;;110
 ;;21,"00378-1620-05 ")
 ;;111
 ;;21,"00440-7385-10 ")
 ;;112
 ;;21,"00527-0586-01 ")
 ;;20
 ;;21,"00527-0586-10 ")
 ;;21
 ;;21,"00527-1282-01 ")
 ;;113
 ;;21,"00527-1282-10 ")
 ;;114
 ;;21,"00591-0794-01 ")
 ;;22
 ;;21,"00591-0794-10 ")
 ;;23
 ;;21,"00591-0795-01 ")
 ;;115
 ;;21,"00591-0795-10 ")
 ;;116
 ;;21,"00603-1161-58 ")
 ;;95
 ;;21,"00603-3265-21 ")
 ;;24
 ;;21,"00603-3265-32 ")
 ;;25
 ;;21,"00603-3266-21 ")
 ;;117
 ;;21,"00615-0327-01 ")
 ;;26
 ;;21,"00615-0327-10 ")
 ;;27
 ;;21,"00615-1516-10 ")
 ;;118
 ;;21,"00904-0195-60 ")
 ;;119
 ;;21,"00904-2344-40 ")
 ;;185
 ;;21,"00904-2344-60 ")
 ;;186
 ;;21,"00904-7896-80 ")
 ;;28
 ;;21,"10135-0520-01 ")
 ;;29
 ;;21,"10135-0520-10 ")
 ;;30
 ;;21,"10135-0521-01 ")
 ;;120
 ;;21,"16590-0077-30 ")
 ;;31
 ;;21,"16590-0077-60 ")
 ;;32
 ;;21,"16590-0077-72 ")
 ;;33
 ;;21,"16590-0077-90 ")
 ;;34
 ;;21,"21695-0218-30 ")
 ;;35
 ;;21,"23490-5428-01 ")
 ;;36
 ;;21,"23490-5428-02 ")
 ;;37
 ;;21,"23490-5428-03 ")
 ;;38
 ;;21,"23490-5431-02 ")
 ;;121
 ;;21,"23490-5431-03 ")
 ;;122
 ;;21,"23490-5431-04 ")
 ;;123
 ;;21,"43063-0045-04 ")
 ;;124
 ;;21,"43063-0045-06 ")
 ;;125
 ;;21,"43063-0112-04 ")
 ;;39
 ;;21,"43063-0112-06 ")
 ;;40
 ;;21,"49727-0054-05 ")
 ;;41
 ;;21,"49999-0081-00 ")
 ;;126
 ;;21,"49999-0081-20 ")
 ;;127
 ;;21,"49999-0081-30 ")
 ;;128
 ;;21,"49999-0291-20 ")
 ;;42
 ;;21,"51079-0118-01 ")
 ;;43
 ;;21,"51079-0118-20 ")
 ;;44
 ;;21,"51079-0119-01 ")
 ;;129
 ;;21,"51079-0119-20 ")
 ;;130
 ;;21,"51655-0293-24 ")
 ;;131
 ;;21,"52959-0168-00 ")
 ;;45
 ;;21,"52959-0168-30 ")
 ;;46
 ;;21,"52959-0221-00 ")
 ;;132
 ;;21,"52959-0221-20 ")
 ;;133
 ;;21,"52959-0221-30 ")
 ;;134
 ;;21,"52959-0390-30 ")
 ;;135
 ;;21,"54569-0417-00 ")
 ;;47
 ;;21,"54569-0417-02 ")
 ;;48
 ;;21,"54569-0417-03 ")
 ;;49
 ;;21,"54569-0417-04 ")
 ;;50
 ;;21,"54569-0417-06 ")
 ;;51
 ;;21,"54569-0417-07 ")
 ;;52
 ;;21,"54569-0418-00 ")
 ;;136
 ;;21,"54569-0419-00 ")
 ;;137
 ;;21,"54569-0419-02 ")
 ;;138
 ;;21,"54569-0419-04 ")
 ;;139
 ;;21,"54569-0419-07 ")
 ;;140
 ;;21,"54868-0033-00 ")
 ;;53
 ;;21,"54868-0033-02 ")
 ;;54
 ;;21,"54868-0033-03 ")
 ;;55
 ;;21,"54868-0033-05 ")
 ;;56
 ;;21,"54868-0033-06 ")
 ;;57
 ;;21,"54868-0033-07 ")
 ;;58
 ;;21,"54868-0033-08 ")
 ;;59
 ;;21,"54868-0392-01 ")
 ;;141
 ;;21,"54868-0818-00 ")
 ;;142
 ;;21,"54868-0818-01 ")
 ;;143
 ;;21,"54868-0818-03 ")
 ;;144
 ;;21,"54868-0818-05 ")
 ;;145
 ;;21,"54868-0818-07 ")
 ;;146
 ;;21,"54868-0818-08 ")
 ;;147
 ;;21,"54902-0073-01 ")
 ;;194
 ;;21,"54902-0074-01 ")
 ;;187
 ;;21,"54902-0074-05 ")
 ;;188
 ;;21,"54902-0074-52 ")
 ;;189
 ;;21,"55045-1467-01 ")
 ;;148
 ;;21,"55045-1467-02 ")
 ;;149
 ;;21,"55045-1467-03 ")
 ;;150
 ;;21,"55045-1467-06 ")
 ;;151
 ;;21,"55045-1467-08 ")
 ;;152
 ;;21,"55045-1467-09 ")
 ;;153
 ;;21,"55045-2197-01 ")
 ;;60
 ;;21,"55045-2197-02 ")
 ;;61
 ;;21,"55045-2197-05 ")
 ;;62
 ;;21,"55045-2197-06 ")
 ;;63
 ;;21,"55045-2197-08 ")
 ;;64
 ;;21,"55045-2197-09 ")
 ;;65
 ;;21,"55289-0095-15 ")
 ;;154
 ;;21,"55289-0095-17 ")
 ;;155
 ;;21,"55289-0095-20 ")
 ;;156
 ;;21,"55289-0095-30 ")
 ;;157
 ;;21,"55289-0095-60 ")
 ;;158
 ;;21,"55289-0923-20 ")
 ;;66
 ;;21,"55289-0923-30 ")
 ;;67
 ;;21,"55887-0470-16 ")
 ;;159
 ;;21,"55887-0470-30 ")
 ;;160
 ;;21,"55887-0909-15 ")
 ;;68
 ;;21,"55887-0909-30 ")
 ;;69
 ;;21,"55887-0909-60 ")
 ;;70
 ;;21,"55887-0909-90 ")
 ;;71
 ;;21,"57866-3367-03 ")
 ;;72
 ;;21,"57866-3377-01 ")
 ;;161
 ;;21,"57866-3377-04 ")
 ;;162
 ;;21,"58016-0019-00 ")
 ;;190
 ;;21,"58016-0019-30 ")
 ;;191
 ;;21,"58016-0019-60 ")
 ;;192
 ;;21,"58016-0019-90 ")
 ;;193
 ;;21,"58016-0702-12 ")
 ;;73
 ;;21,"58016-0702-30 ")
 ;;74
 ;;21,"58016-0703-00 ")
 ;;163
 ;;21,"58016-0703-12 ")
 ;;164
 ;;21,"58016-0703-30 ")
 ;;165
 ;;21,"58864-0153-30 ")
 ;;75
 ;;21,"58914-0012-10 ")
 ;;76
 ;;21,"58914-0013-10 ")
 ;;166
 ;;21,"58914-0015-16 ")
 ;;96
 ;;21,"60429-0155-01 ")
 ;;77
 ;;21,"60429-0155-10 ")
 ;;78
 ;;21,"60429-0156-01 ")
 ;;167
 ;;21,"60429-0156-10 ")
 ;;168
 ;;21,"61392-0041-45 ")
 ;;169
 ;;21,"61392-0041-54 ")
 ;;170
 ;;21,"61392-0041-56 ")
 ;;171
 ;;21,"61392-0041-91 ")
 ;;172
 ;;21,"63629-1299-01 ")
 ;;173
 ;;21,"63874-0463-01 ")
 ;;79
 ;;21,"63874-0463-02 ")
 ;;80
 ;;21,"63874-0463-04 ")
 ;;81
 ;;21,"63874-0463-10 ")
 ;;82
 ;;21,"63874-0463-12 ")
 ;;83
 ;;21,"63874-0463-20 ")
 ;;84
 ;;21,"63874-0463-21 ")
 ;;85
 ;;21,"63874-0463-28 ")
 ;;86
 ;;21,"63874-0463-30 ")
 ;;87
 ;;21,"63874-0463-60 ")
 ;;88
 ;;21,"63874-0463-90 ")
 ;;89
 ;;21,"66267-0074-30 ")
 ;;174
 ;;21,"66336-0911-30 ")
 ;;90
 ;;21,"68115-0106-20 ")
 ;;91
 ;;21,"68115-0106-30 ")
 ;;92
 ;;21,"68115-0106-60 ")
 ;;93
 ;;21,"68115-0107-10 ")
 ;;175
 ;;21,"68115-0107-15 ")
 ;;176
 ;;21,"68115-0107-20 ")
 ;;177
 ;;21,"68115-0107-30 ")
 ;;178
 ;;9002226,732,.01)
 ;;BGP HEDIS GASTRO ANTISPASM NDC
 ;;9002226,732,.02)
 ;;@
 ;;9002226,732,.04)
 ;;n
 ;;9002226,732,.06)
 ;;@
 ;;9002226,732,.08)
 ;;@
 ;;9002226,732,.09)
 ;;3120312
 ;;9002226,732,.11)
 ;;@
 ;;9002226,732,.12)
 ;;@
 ;;9002226,732,.13)
 ;;1
 ;;9002226,732,.14)
 ;;@
 ;;9002226,732,.15)
 ;;@
 ;;9002226,732,.16)
 ;;@
 ;;9002226,732,.17)
 ;;@
 ;;9002226,732,3101)
 ;;@
 ;;9002226.02101,"732,00054-4721-25 ",.01)
 ;;00054-4721-25
 ;;9002226.02101,"732,00054-4721-25 ",.02)
 ;;00054-4721-25
 ;;9002226.02101,"732,00115-3200-01 ",.01)
 ;;00115-3200-01
 ;;9002226.02101,"732,00115-3200-01 ",.02)
 ;;00115-3200-01
 ;;9002226.02101,"732,00115-3200-03 ",.01)
 ;;00115-3200-03
 ;;9002226.02101,"732,00115-3200-03 ",.02)
 ;;00115-3200-03
 ;;9002226.02101,"732,00115-3220-01 ",.01)
 ;;00115-3220-01
 ;;9002226.02101,"732,00115-3220-01 ",.02)
 ;;00115-3220-01
 ;;9002226.02101,"732,00115-3220-03 ",.01)
 ;;00115-3220-03
 ;;9002226.02101,"732,00115-3220-03 ",.02)
 ;;00115-3220-03
 ;;9002226.02101,"732,00115-4308-01 ",.01)
 ;;00115-4308-01
 ;;9002226.02101,"732,00115-4308-01 ",.02)
 ;;00115-4308-01
 ;;9002226.02101,"732,00115-4308-03 ",.01)
 ;;00115-4308-03
 ;;9002226.02101,"732,00115-4308-03 ",.02)
 ;;00115-4308-03
 ;;9002226.02101,"732,00143-1227-01 ",.01)
 ;;00143-1227-01
 ;;9002226.02101,"732,00143-1227-01 ",.02)
 ;;00143-1227-01
 ;;9002226.02101,"732,00143-1227-10 ",.01)
 ;;00143-1227-10
 ;;9002226.02101,"732,00143-1227-10 ",.02)
 ;;00143-1227-10
 ;;9002226.02101,"732,00143-3126-01 ",.01)
 ;;00143-3126-01
 ;;9002226.02101,"732,00143-3126-01 ",.02)
 ;;00143-3126-01
 ;;9002226.02101,"732,00143-3126-10 ",.01)
 ;;00143-3126-10
 ;;9002226.02101,"732,00143-3126-10 ",.02)
 ;;00143-3126-10
 ;;9002226.02101,"732,00182-1858-01 ",.01)
 ;;00182-1858-01
 ;;9002226.02101,"732,00182-1858-01 ",.02)
 ;;00182-1858-01
 ;;9002226.02101,"732,00247-0188-00 ",.01)
 ;;00247-0188-00
 ;;9002226.02101,"732,00247-0188-00 ",.02)
 ;;00247-0188-00
 ;;9002226.02101,"732,00247-0188-02 ",.01)
 ;;00247-0188-02
 ;;9002226.02101,"732,00247-0188-02 ",.02)
 ;;00247-0188-02
 ;;9002226.02101,"732,00247-0188-03 ",.01)
 ;;00247-0188-03
 ;;9002226.02101,"732,00247-0188-03 ",.02)
 ;;00247-0188-03
 ;;9002226.02101,"732,00247-0188-04 ",.01)
 ;;00247-0188-04
 ;;9002226.02101,"732,00247-0188-04 ",.02)
 ;;00247-0188-04
 ;;9002226.02101,"732,00247-0188-06 ",.01)
 ;;00247-0188-06
 ;;9002226.02101,"732,00247-0188-06 ",.02)
 ;;00247-0188-06
 ;;9002226.02101,"732,00247-0188-10 ",.01)
 ;;00247-0188-10
 ;;9002226.02101,"732,00247-0188-10 ",.02)
 ;;00247-0188-10
 ;;9002226.02101,"732,00247-0188-12 ",.01)
 ;;00247-0188-12
 ;;9002226.02101,"732,00247-0188-12 ",.02)
 ;;00247-0188-12
 ;;9002226.02101,"732,00247-0188-14 ",.01)
 ;;00247-0188-14
 ;;9002226.02101,"732,00247-0188-14 ",.02)
 ;;00247-0188-14
 ;;9002226.02101,"732,00247-0188-15 ",.01)
 ;;00247-0188-15
 ;;9002226.02101,"732,00247-0188-15 ",.02)
 ;;00247-0188-15
 ;;9002226.02101,"732,00247-0188-20 ",.01)
 ;;00247-0188-20
 ;;9002226.02101,"732,00247-0188-20 ",.02)
 ;;00247-0188-20
 ;;9002226.02101,"732,00247-0188-24 ",.01)
 ;;00247-0188-24
 ;;9002226.02101,"732,00247-0188-24 ",.02)
 ;;00247-0188-24
 ;;9002226.02101,"732,00247-0188-30 ",.01)
 ;;00247-0188-30
 ;;9002226.02101,"732,00247-0188-30 ",.02)
 ;;00247-0188-30
 ;;9002226.02101,"732,00247-0188-40 ",.01)
 ;;00247-0188-40
 ;;9002226.02101,"732,00247-0188-40 ",.02)
 ;;00247-0188-40
 ;;9002226.02101,"732,00247-0582-03 ",.01)
 ;;00247-0582-03
 ;;9002226.02101,"732,00247-0582-03 ",.02)
 ;;00247-0582-03
 ;;9002226.02101,"732,00247-0582-04 ",.01)
 ;;00247-0582-04
 ;;9002226.02101,"732,00247-0582-04 ",.02)
 ;;00247-0582-04
 ;;9002226.02101,"732,00247-0582-05 ",.01)
 ;;00247-0582-05
 ;;9002226.02101,"732,00247-0582-05 ",.02)
 ;;00247-0582-05
 ;;9002226.02101,"732,00247-0582-10 ",.01)
 ;;00247-0582-10
 ;;9002226.02101,"732,00247-0582-10 ",.02)
 ;;00247-0582-10
 ;;9002226.02101,"732,00247-0582-12 ",.01)
 ;;00247-0582-12
 ;;9002226.02101,"732,00247-0582-12 ",.02)
 ;;00247-0582-12
 ;;9002226.02101,"732,00247-0582-15 ",.01)
 ;;00247-0582-15
 ;;9002226.02101,"732,00247-0582-15 ",.02)
 ;;00247-0582-15
 ;;9002226.02101,"732,00247-0582-20 ",.01)
 ;;00247-0582-20
 ;;9002226.02101,"732,00247-0582-20 ",.02)
 ;;00247-0582-20
 ;;9002226.02101,"732,00247-0582-24 ",.01)
 ;;00247-0582-24
 ;;9002226.02101,"732,00247-0582-24 ",.02)
 ;;00247-0582-24
 ;;9002226.02101,"732,00247-0582-30 ",.01)
 ;;00247-0582-30
 ;;9002226.02101,"732,00247-0582-30 ",.02)
 ;;00247-0582-30
 ;;9002226.02101,"732,00247-1360-20 ",.01)
 ;;00247-1360-20
 ;;9002226.02101,"732,00247-1360-20 ",.02)
 ;;00247-1360-20
 ;;9002226.02101,"732,00247-1360-24 ",.01)
 ;;00247-1360-24
 ;;9002226.02101,"732,00247-1360-24 ",.02)
 ;;00247-1360-24
 ;;9002226.02101,"732,00247-2079-30 ",.01)
 ;;00247-2079-30
 ;;9002226.02101,"732,00247-2079-30 ",.02)
 ;;00247-2079-30
 ;;9002226.02101,"732,00378-1610-01 ",.01)
 ;;00378-1610-01
 ;;9002226.02101,"732,00378-1610-01 ",.02)
 ;;00378-1610-01
 ;;9002226.02101,"732,00378-1610-05 ",.01)
 ;;00378-1610-05
 ;;9002226.02101,"732,00378-1610-05 ",.02)
 ;;00378-1610-05
 ;;9002226.02101,"732,00378-1620-01 ",.01)
 ;;00378-1620-01
 ;;9002226.02101,"732,00378-1620-01 ",.02)
 ;;00378-1620-01
 ;;9002226.02101,"732,00378-1620-05 ",.01)
 ;;00378-1620-05
 ;;9002226.02101,"732,00378-1620-05 ",.02)
 ;;00378-1620-05
 ;;9002226.02101,"732,00440-7385-10 ",.01)
 ;;00440-7385-10
 ;;9002226.02101,"732,00440-7385-10 ",.02)
 ;;00440-7385-10
 ;;9002226.02101,"732,00527-0586-01 ",.01)
 ;;00527-0586-01
 ;;9002226.02101,"732,00527-0586-01 ",.02)
 ;;00527-0586-01
 ;;9002226.02101,"732,00527-0586-10 ",.01)
 ;;00527-0586-10
 ;;9002226.02101,"732,00527-0586-10 ",.02)
 ;;00527-0586-10
 ;;9002226.02101,"732,00527-1282-01 ",.01)
 ;;00527-1282-01
 ;;9002226.02101,"732,00527-1282-01 ",.02)
 ;;00527-1282-01
 ;;9002226.02101,"732,00527-1282-10 ",.01)
 ;;00527-1282-10
 ;;9002226.02101,"732,00527-1282-10 ",.02)
 ;;00527-1282-10
 ;;9002226.02101,"732,00591-0794-01 ",.01)
 ;;00591-0794-01
 ;;9002226.02101,"732,00591-0794-01 ",.02)
 ;;00591-0794-01
 ;;9002226.02101,"732,00591-0794-10 ",.01)
 ;;00591-0794-10
 ;;9002226.02101,"732,00591-0794-10 ",.02)
 ;;00591-0794-10
 ;;9002226.02101,"732,00591-0795-01 ",.01)
 ;;00591-0795-01
 ;;9002226.02101,"732,00591-0795-01 ",.02)
 ;;00591-0795-01
 ;;9002226.02101,"732,00591-0795-10 ",.01)
 ;;00591-0795-10
 ;;9002226.02101,"732,00591-0795-10 ",.02)
 ;;00591-0795-10
 ;;9002226.02101,"732,00603-1161-58 ",.01)
 ;;00603-1161-58
 ;;9002226.02101,"732,00603-1161-58 ",.02)
 ;;00603-1161-58
 ;;9002226.02101,"732,00603-3265-21 ",.01)
 ;;00603-3265-21
 ;;9002226.02101,"732,00603-3265-21 ",.02)
 ;;00603-3265-21
 ;;9002226.02101,"732,00603-3265-32 ",.01)
 ;;00603-3265-32
 ;
OTHER ; OTHER ROUTINES
 D ^BGP2VT2
 D ^BGP2VT3
 Q
