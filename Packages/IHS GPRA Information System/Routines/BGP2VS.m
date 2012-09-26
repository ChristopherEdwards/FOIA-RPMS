BGP2VS ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP HEDIS ORAL ESTROGEN NDC
 ;
 ; This routine loads Taxonomy BGP HEDIS ORAL ESTROGEN NDC
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
 ;;21,"00009-3772-01 ")
 ;;221
 ;;21,"00009-3773-01 ")
 ;;238
 ;;21,"00009-3774-01 ")
 ;;249
 ;;21,"00032-1023-01 ")
 ;;183
 ;;21,"00032-1026-01 ")
 ;;200
 ;;21,"00032-1026-10 ")
 ;;201
 ;;21,"00046-0875-05 ")
 ;;153
 ;;21,"00046-0875-06 ")
 ;;154
 ;;21,"00046-0875-11 ")
 ;;155
 ;;21,"00046-0937-08 ")
 ;;147
 ;;21,"00046-0937-09 ")
 ;;148
 ;;21,"00046-0937-18 ")
 ;;149
 ;;21,"00046-0938-08 ")
 ;;141
 ;;21,"00046-0938-09 ")
 ;;142
 ;;21,"00046-0938-18 ")
 ;;143
 ;;21,"00046-0975-05 ")
 ;;163
 ;;21,"00046-0975-06 ")
 ;;164
 ;;21,"00046-0975-11 ")
 ;;165
 ;;21,"00046-1100-81 ")
 ;;1
 ;;21,"00046-1100-91 ")
 ;;2
 ;;21,"00046-1101-81 ")
 ;;27
 ;;21,"00046-1102-81 ")
 ;;31
 ;;21,"00046-1102-91 ")
 ;;32
 ;;21,"00046-1103-81 ")
 ;;81
 ;;21,"00046-1104-81 ")
 ;;96
 ;;21,"00046-1104-91 ")
 ;;97
 ;;21,"00046-1105-11 ")
 ;;144
 ;;21,"00046-1106-11 ")
 ;;150
 ;;21,"00046-1107-11 ")
 ;;156
 ;;21,"00046-2573-01 ")
 ;;169
 ;;21,"00046-2573-05 ")
 ;;170
 ;;21,"00046-2573-06 ")
 ;;171
 ;;21,"00046-2579-11 ")
 ;;172
 ;;21,"00182-1976-01 ")
 ;;222
 ;;21,"00182-1977-01 ")
 ;;239
 ;;21,"00182-1978-01 ")
 ;;250
 ;;21,"00247-0249-00 ")
 ;;82
 ;;21,"00247-0249-15 ")
 ;;83
 ;;21,"00247-0249-30 ")
 ;;84
 ;;21,"00247-0249-60 ")
 ;;85
 ;;21,"00247-0249-90 ")
 ;;86
 ;;21,"00247-0250-00 ")
 ;;98
 ;;21,"00247-0250-28 ")
 ;;99
 ;;21,"00247-0250-30 ")
 ;;100
 ;;21,"00247-0251-00 ")
 ;;33
 ;;21,"00247-0251-01 ")
 ;;34
 ;;21,"00247-0251-30 ")
 ;;35
 ;;21,"00247-0251-60 ")
 ;;36
 ;;21,"00247-0251-90 ")
 ;;37
 ;;21,"00247-1226-30 ")
 ;;3
 ;;21,"00247-1702-01 ")
 ;;157
 ;;21,"00247-1702-28 ")
 ;;158
 ;;21,"00247-1703-28 ")
 ;;173
 ;;21,"00247-2156-30 ")
 ;;223
 ;;21,"00339-5981-12 ")
 ;;224
 ;;21,"00339-5983-12 ")
 ;;240
 ;;21,"00339-5985-12 ")
 ;;251
 ;;21,"00378-4551-01 ")
 ;;225
 ;;21,"00378-4553-01 ")
 ;;241
 ;;21,"00440-8171-90 ")
 ;;101
 ;;21,"00527-1409-01 ")
 ;;202
 ;;21,"00527-1409-10 ")
 ;;203
 ;;21,"00527-1410-01 ")
 ;;184
 ;;21,"00527-1410-10 ")
 ;;185
 ;;21,"00555-0727-02 ")
 ;;226
 ;;21,"00555-0728-02 ")
 ;;242
 ;;21,"00555-0729-02 ")
 ;;252
 ;;21,"00591-0414-01 ")
 ;;227
 ;;21,"00591-0415-01 ")
 ;;243
 ;;21,"00591-0416-01 ")
 ;;253
 ;;21,"10135-0469-01 ")
 ;;186
 ;;21,"10135-0470-01 ")
 ;;204
 ;;21,"11528-0010-01 ")
 ;;205
 ;;21,"11528-0020-01 ")
 ;;187
 ;;21,"12280-0039-00 ")
 ;;38
 ;;21,"15310-0010-01 ")
 ;;206
 ;;21,"15310-0020-01 ")
 ;;188
 ;;21,"23490-6906-01 ")
 ;;228
 ;;21,"33358-0295-30 ")
 ;;87
 ;;21,"35356-0249-00 ")
 ;;4
 ;;21,"35356-0250-00 ")
 ;;88
 ;;21,"35356-0251-00 ")
 ;;28
 ;;21,"35356-0276-28 ")
 ;;145
 ;;21,"35356-0277-28 ")
 ;;159
 ;;21,"35356-0278-28 ")
 ;;166
 ;;21,"35356-0279-28 ")
 ;;151
 ;;21,"35356-0426-30 ")
 ;;102
 ;;21,"49999-0109-00 ")
 ;;39
 ;;21,"49999-0109-30 ")
 ;;40
 ;;21,"49999-0109-90 ")
 ;;41
 ;;21,"50220-0001-01 ")
 ;;189
 ;;21,"50220-0002-01 ")
 ;;207
 ;;21,"51285-0011-02 ")
 ;;244
 ;;21,"51285-0406-02 ")
 ;;136
 ;;21,"51285-0407-02 ")
 ;;137
 ;;21,"51285-0408-02 ")
 ;;138
 ;;21,"51285-0409-02 ")
 ;;139
 ;;21,"51285-0410-02 ")
 ;;140
 ;;21,"51285-0441-02 ")
 ;;123
 ;;21,"51285-0442-02 ")
 ;;127
 ;;21,"51285-0442-05 ")
 ;;128
 ;;21,"51285-0443-02 ")
 ;;132
 ;;21,"51285-0444-02 ")
 ;;133
 ;;21,"51285-0446-02 ")
 ;;124
 ;;21,"51655-0452-24 ")
 ;;42
 ;;21,"51655-0452-25 ")
 ;;43
 ;;21,"51991-0078-01 ")
 ;;190
 ;;21,"51991-0079-01 ")
 ;;208
 ;;21,"52959-0222-00 ")
 ;;103
 ;;21,"52959-0223-00 ")
 ;;44
 ;;21,"52959-0223-30 ")
 ;;45
 ;;21,"52959-0326-10 ")
 ;;229
 ;;21,"53746-0077-01 ")
 ;;191
 ;;21,"53746-0078-01 ")
 ;;209
 ;;21,"54569-0811-01 ")
 ;;5
 ;;21,"54569-0812-00 ")
 ;;46
 ;;21,"54569-0812-01 ")
 ;;47
 ;;21,"54569-0812-02 ")
 ;;48
 ;;21,"54569-0812-05 ")
 ;;49
 ;;21,"54569-0813-00 ")
 ;;104
 ;;21,"54569-0813-01 ")
 ;;105
 ;;21,"54569-0849-00 ")
 ;;89
 ;;21,"54569-0849-01 ")
 ;;90
 ;;21,"54569-4354-01 ")
 ;;192
 ;;21,"54569-4618-00 ")
 ;;160
 ;;21,"54569-4673-00 ")
 ;;174
 ;;21,"54569-4925-00 ")
 ;;167
 ;;21,"54569-8006-00 ")
 ;;50
 ;;21,"54569-8006-01 ")
 ;;51
 ;;21,"54569-8006-02 ")
 ;;52
 ;;21,"54569-8014-00 ")
 ;;106
 ;;21,"54569-8500-00 ")
 ;;53
 ;;21,"54569-8500-01 ")
 ;;54
 ;;21,"54569-8500-02 ")
 ;;55
 ;;21,"54569-8505-00 ")
 ;;107
 ;;21,"54569-8505-01 ")
 ;;108
 ;;21,"54569-8505-02 ")
 ;;109
 ;;21,"54569-8517-00 ")
 ;;6
 ;;21,"54569-8517-01 ")
 ;;7
 ;;21,"54569-8518-00 ")
 ;;91
 ;;21,"54569-8518-01 ")
 ;;92
 ;;21,"54569-8525-00 ")
 ;;230
 ;;21,"54569-8551-00 ")
 ;;245
 ;;21,"54868-0365-00 ")
 ;;93
 ;;21,"54868-0365-02 ")
 ;;94
 ;;21,"54868-0365-03 ")
 ;;95
 ;;21,"54868-0451-00 ")
 ;;56
 ;;21,"54868-0451-01 ")
 ;;57
 ;;21,"54868-0451-02 ")
 ;;58
 ;;21,"54868-0451-03 ")
 ;;59
 ;;21,"54868-0451-06 ")
 ;;60
 ;;21,"54868-0451-07 ")
 ;;61
 ;;21,"54868-0453-00 ")
 ;;110
 ;;21,"54868-0453-01 ")
 ;;111
 ;;21,"54868-0453-02 ")
 ;;112
 ;;21,"54868-0453-04 ")
 ;;113
 ;;21,"54868-0453-05 ")
 ;;114
 ;;21,"54868-0453-06 ")
 ;;115
 ;;21,"54868-1261-00 ")
 ;;246
 ;;21,"54868-1262-00 ")
 ;;231
 ;;21,"54868-1262-01 ")
 ;;232
 ;;21,"54868-1262-02 ")
 ;;233
 ;;21,"54868-1432-00 ")
 ;;134
 ;;21,"54868-1432-01 ")
 ;;135
 ;;21,"54868-2702-00 ")
 ;;8
 ;;21,"54868-2702-01 ")
 ;;9
 ;;21,"54868-2702-02 ")
 ;;10
 ;;21,"54868-2702-03 ")
 ;;11
 ;;21,"54868-2702-04 ")
 ;;12
 ;;21,"54868-3114-00 ")
 ;;234
 ;;21,"54868-3114-01 ")
 ;;235
 ;;21,"54868-3564-00 ")
 ;;193
 ;;21,"54868-3564-01 ")
 ;;194
 ;;21,"54868-3564-02 ")
 ;;195
 ;;21,"54868-3565-00 ")
 ;;210
 ;;21,"54868-3565-01 ")
 ;;211
 ;;21,"54868-3565-02 ")
 ;;212
 ;;21,"54868-3653-00 ")
 ;;254
 ;;21,"54868-3799-00 ")
 ;;161
 ;;21,"54868-3800-00 ")
 ;;175
 ;;21,"54868-4149-00 ")
 ;;247
 ;;21,"54868-4149-01 ")
 ;;248
 ;;21,"54868-4761-01 ")
 ;;255
 ;;21,"54868-4761-02 ")
 ;;256
 ;;21,"54868-4771-00 ")
 ;;213
 ;;21,"54868-4771-01 ")
 ;;214
 ;;21,"54868-4771-02 ")
 ;;215
 ;;21,"54868-4865-00 ")
 ;;29
 ;;21,"54868-4865-01 ")
 ;;30
 ;;21,"54868-4866-00 ")
 ;;152
 ;;21,"54868-4879-00 ")
 ;;129
 ;;21,"54868-4879-01 ")
 ;;130
 ;;21,"54868-4879-02 ")
 ;;131
 ;;21,"54868-5047-00 ")
 ;;146
 ;;21,"54868-5415-00 ")
 ;;125
 ;;21,"54868-5415-01 ")
 ;;126
 ;;21,"54868-5540-00 ")
 ;;168
 ;;21,"54868-5934-00 ")
 ;;177
 ;;21,"54868-5934-01 ")
 ;;178
 ;;21,"55045-3480-01 ")
 ;;216
 ;;21,"55289-0047-25 ")
 ;;116
 ;;21,"55289-0047-30 ")
 ;;117
 ;;21,"55289-0047-42 ")
 ;;118
 ;;21,"55289-0047-90 ")
 ;;119
 ;;21,"55289-0123-30 ")
 ;;13
 ;;21,"55289-0943-07 ")
 ;;62
 ;;21,"55289-0943-25 ")
 ;;63
 ;;21,"55289-0943-28 ")
 ;;64
 ;;21,"55289-0943-30 ")
 ;;65
 ;;21,"55887-0324-30 ")
 ;;236
 ;;21,"55887-0702-30 ")
 ;;66
 ;;21,"58016-0744-00 ")
 ;;14
 ;;21,"58016-0744-10 ")
 ;;15
 ;;21,"58016-0744-12 ")
 ;;16
 ;;21,"58016-0744-14 ")
 ;;17
 ;;21,"58016-0744-15 ")
 ;;18
 ;;21,"58016-0744-20 ")
 ;;19
 ;;21,"58016-0744-30 ")
 ;;20
 ;;21,"58016-0948-00 ")
 ;;67
 ;;21,"58016-0948-10 ")
 ;;68
 ;;21,"58016-0948-12 ")
 ;;69
 ;;21,"58016-0948-14 ")
 ;;70
 ;;21,"58016-0948-15 ")
 ;;71
 ;;21,"58016-0948-20 ")
 ;;72
 ;;21,"58016-0948-30 ")
 ;;73
 ;;21,"58016-0948-50 ")
 ;;74
 ;;21,"58016-4074-01 ")
 ;;162
 ;;21,"58864-0422-28 ")
 ;;75
 ;;21,"58864-0422-30 ")
 ;;76
 ;;21,"58864-0951-30 ")
 ;;179
 ;;21,"61570-0072-01 ")
 ;;176
 ;;21,"61570-0073-01 ")
 ;;180
 ;;21,"61570-0074-01 ")
 ;;181
 ;;21,"61570-0075-50 ")
 ;;182
 ;;21,"62559-1490-00 ")
 ;;217
 ;;21,"62559-1507-00 ")
 ;;196
 ;;21,"63874-0158-01 ")
 ;;21
 ;;21,"63874-0158-10 ")
 ;;22
 ;;21,"63874-0158-14 ")
 ;;23
 ;;21,"63874-0158-15 ")
 ;;24
 ;;21,"63874-0158-20 ")
 ;;25
 ;;21,"63874-0158-30 ")
 ;;26
 ;;21,"65162-0877-10 ")
 ;;197
 ;;21,"65162-0878-10 ")
 ;;218
 ;;21,"66105-0137-10 ")
 ;;77
 ;;21,"66105-0138-10 ")
 ;;120
 ;;21,"66267-0174-30 ")
 ;;78
 ;;21,"66336-0599-30 ")
 ;;79
 ;;21,"66336-0977-30 ")
 ;;237
 ;;21,"66993-0920-02 ")
 ;;219
 ;;21,"66993-0921-02 ")
 ;;198
 ;;21,"67801-0326-03 ")
 ;;80
 ;;21,"67801-0327-03 ")
 ;;121
 ;;21,"68115-0294-30 ")
 ;;122
 ;;21,"68462-0173-01 ")
 ;;199
 ;;21,"68462-0174-01 ")
 ;;220
 ;;9002226,722,.01)
 ;;BGP HEDIS ORAL ESTROGEN NDC
 ;;9002226,722,.02)
 ;;@
 ;;9002226,722,.04)
 ;;n
 ;;9002226,722,.06)
 ;;@
 ;;9002226,722,.08)
 ;;@
 ;;9002226,722,.09)
 ;;3120312
 ;;9002226,722,.11)
 ;;@
 ;;9002226,722,.12)
 ;;@
 ;;9002226,722,.13)
 ;;1
 ;;9002226,722,.14)
 ;;@
 ;;9002226,722,.15)
 ;;@
 ;;9002226,722,.16)
 ;;@
 ;;9002226,722,.17)
 ;;@
 ;;9002226,722,3101)
 ;;@
 ;;9002226.02101,"722,00009-3772-01 ",.01)
 ;;00009-3772-01
 ;;9002226.02101,"722,00009-3772-01 ",.02)
 ;;00009-3772-01
 ;;9002226.02101,"722,00009-3773-01 ",.01)
 ;;00009-3773-01
 ;;9002226.02101,"722,00009-3773-01 ",.02)
 ;;00009-3773-01
 ;;9002226.02101,"722,00009-3774-01 ",.01)
 ;;00009-3774-01
 ;;9002226.02101,"722,00009-3774-01 ",.02)
 ;;00009-3774-01
 ;;9002226.02101,"722,00032-1023-01 ",.01)
 ;;00032-1023-01
 ;;9002226.02101,"722,00032-1023-01 ",.02)
 ;;00032-1023-01
 ;;9002226.02101,"722,00032-1026-01 ",.01)
 ;;00032-1026-01
 ;;9002226.02101,"722,00032-1026-01 ",.02)
 ;;00032-1026-01
 ;;9002226.02101,"722,00032-1026-10 ",.01)
 ;;00032-1026-10
 ;;9002226.02101,"722,00032-1026-10 ",.02)
 ;;00032-1026-10
 ;;9002226.02101,"722,00046-0875-05 ",.01)
 ;;00046-0875-05
 ;;9002226.02101,"722,00046-0875-05 ",.02)
 ;;00046-0875-05
 ;;9002226.02101,"722,00046-0875-06 ",.01)
 ;;00046-0875-06
 ;;9002226.02101,"722,00046-0875-06 ",.02)
 ;;00046-0875-06
 ;;9002226.02101,"722,00046-0875-11 ",.01)
 ;;00046-0875-11
 ;;9002226.02101,"722,00046-0875-11 ",.02)
 ;;00046-0875-11
 ;;9002226.02101,"722,00046-0937-08 ",.01)
 ;;00046-0937-08
 ;;9002226.02101,"722,00046-0937-08 ",.02)
 ;;00046-0937-08
 ;;9002226.02101,"722,00046-0937-09 ",.01)
 ;;00046-0937-09
 ;;9002226.02101,"722,00046-0937-09 ",.02)
 ;;00046-0937-09
 ;;9002226.02101,"722,00046-0937-18 ",.01)
 ;;00046-0937-18
 ;;9002226.02101,"722,00046-0937-18 ",.02)
 ;;00046-0937-18
 ;;9002226.02101,"722,00046-0938-08 ",.01)
 ;;00046-0938-08
 ;;9002226.02101,"722,00046-0938-08 ",.02)
 ;;00046-0938-08
 ;;9002226.02101,"722,00046-0938-09 ",.01)
 ;;00046-0938-09
 ;;9002226.02101,"722,00046-0938-09 ",.02)
 ;;00046-0938-09
 ;;9002226.02101,"722,00046-0938-18 ",.01)
 ;;00046-0938-18
 ;;9002226.02101,"722,00046-0938-18 ",.02)
 ;;00046-0938-18
 ;;9002226.02101,"722,00046-0975-05 ",.01)
 ;;00046-0975-05
 ;;9002226.02101,"722,00046-0975-05 ",.02)
 ;;00046-0975-05
 ;;9002226.02101,"722,00046-0975-06 ",.01)
 ;;00046-0975-06
 ;;9002226.02101,"722,00046-0975-06 ",.02)
 ;;00046-0975-06
 ;;9002226.02101,"722,00046-0975-11 ",.01)
 ;;00046-0975-11
 ;;9002226.02101,"722,00046-0975-11 ",.02)
 ;;00046-0975-11
 ;;9002226.02101,"722,00046-1100-81 ",.01)
 ;;00046-1100-81
 ;;9002226.02101,"722,00046-1100-81 ",.02)
 ;;00046-1100-81
 ;;9002226.02101,"722,00046-1100-91 ",.01)
 ;;00046-1100-91
 ;;9002226.02101,"722,00046-1100-91 ",.02)
 ;;00046-1100-91
 ;;9002226.02101,"722,00046-1101-81 ",.01)
 ;;00046-1101-81
 ;;9002226.02101,"722,00046-1101-81 ",.02)
 ;;00046-1101-81
 ;;9002226.02101,"722,00046-1102-81 ",.01)
 ;;00046-1102-81
 ;;9002226.02101,"722,00046-1102-81 ",.02)
 ;;00046-1102-81
 ;;9002226.02101,"722,00046-1102-91 ",.01)
 ;;00046-1102-91
 ;;9002226.02101,"722,00046-1102-91 ",.02)
 ;;00046-1102-91
 ;;9002226.02101,"722,00046-1103-81 ",.01)
 ;;00046-1103-81
 ;;9002226.02101,"722,00046-1103-81 ",.02)
 ;;00046-1103-81
 ;;9002226.02101,"722,00046-1104-81 ",.01)
 ;;00046-1104-81
 ;;9002226.02101,"722,00046-1104-81 ",.02)
 ;;00046-1104-81
 ;;9002226.02101,"722,00046-1104-91 ",.01)
 ;;00046-1104-91
 ;;9002226.02101,"722,00046-1104-91 ",.02)
 ;;00046-1104-91
 ;;9002226.02101,"722,00046-1105-11 ",.01)
 ;;00046-1105-11
 ;;9002226.02101,"722,00046-1105-11 ",.02)
 ;;00046-1105-11
 ;;9002226.02101,"722,00046-1106-11 ",.01)
 ;;00046-1106-11
 ;;9002226.02101,"722,00046-1106-11 ",.02)
 ;;00046-1106-11
 ;;9002226.02101,"722,00046-1107-11 ",.01)
 ;;00046-1107-11
 ;;9002226.02101,"722,00046-1107-11 ",.02)
 ;;00046-1107-11
 ;;9002226.02101,"722,00046-2573-01 ",.01)
 ;;00046-2573-01
 ;;9002226.02101,"722,00046-2573-01 ",.02)
 ;;00046-2573-01
 ;;9002226.02101,"722,00046-2573-05 ",.01)
 ;;00046-2573-05
 ;;9002226.02101,"722,00046-2573-05 ",.02)
 ;;00046-2573-05
 ;;9002226.02101,"722,00046-2573-06 ",.01)
 ;;00046-2573-06
 ;;9002226.02101,"722,00046-2573-06 ",.02)
 ;;00046-2573-06
 ;;9002226.02101,"722,00046-2579-11 ",.01)
 ;;00046-2579-11
 ;;9002226.02101,"722,00046-2579-11 ",.02)
 ;;00046-2579-11
 ;;9002226.02101,"722,00182-1976-01 ",.01)
 ;;00182-1976-01
 ;;9002226.02101,"722,00182-1976-01 ",.02)
 ;;00182-1976-01
 ;;9002226.02101,"722,00182-1977-01 ",.01)
 ;;00182-1977-01
 ;;9002226.02101,"722,00182-1977-01 ",.02)
 ;;00182-1977-01
 ;
OTHER ; OTHER ROUTINES
 D ^BGP2VS2
 D ^BGP2VS3
 Q
