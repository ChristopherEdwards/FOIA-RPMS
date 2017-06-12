BGP71T ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 11, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;;BGP PQA BETA BLOCKER NDC
 ;
 ; This routine loads Taxonomy BGP PQA BETA BLOCKER NDC
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
 ;;21,"00007-3370-13 ")
 ;;1
 ;;21,"00007-3371-13 ")
 ;;2
 ;;21,"00007-3372-13 ")
 ;;3
 ;;21,"00007-3373-13 ")
 ;;4
 ;;21,"00007-4139-20 ")
 ;;5
 ;;21,"00007-4140-20 ")
 ;;6
 ;;21,"00007-4141-20 ")
 ;;7
 ;;21,"00007-4142-20 ")
 ;;8
 ;;21,"00024-2300-20 ")
 ;;9
 ;;21,"00024-2301-10 ")
 ;;10
 ;;21,"00054-3727-63 ")
 ;;11
 ;;21,"00054-3730-63 ")
 ;;12
 ;;21,"00078-0458-05 ")
 ;;13
 ;;21,"00078-0459-05 ")
 ;;14
 ;;21,"00078-0460-05 ")
 ;;15
 ;;21,"00078-0461-05 ")
 ;;16
 ;;21,"00093-0051-01 ")
 ;;17
 ;;21,"00093-0051-05 ")
 ;;18
 ;;21,"00093-0135-01 ")
 ;;19
 ;;21,"00093-0135-05 ")
 ;;20
 ;;21,"00093-0733-01 ")
 ;;21
 ;;21,"00093-0733-10 ")
 ;;22
 ;;21,"00093-0734-01 ")
 ;;23
 ;;21,"00093-0734-10 ")
 ;;24
 ;;21,"00093-0752-01 ")
 ;;25
 ;;21,"00093-0752-10 ")
 ;;26
 ;;21,"00093-0753-01 ")
 ;;27
 ;;21,"00093-0753-05 ")
 ;;28
 ;;21,"00093-0787-01 ")
 ;;29
 ;;21,"00093-0787-10 ")
 ;;30
 ;;21,"00093-4235-01 ")
 ;;31
 ;;21,"00093-4236-01 ")
 ;;32
 ;;21,"00093-4237-01 ")
 ;;33
 ;;21,"00093-5270-56 ")
 ;;34
 ;;21,"00093-5271-56 ")
 ;;35
 ;;21,"00093-7295-01 ")
 ;;36
 ;;21,"00093-7295-05 ")
 ;;37
 ;;21,"00093-7296-01 ")
 ;;38
 ;;21,"00093-7296-05 ")
 ;;39
 ;;21,"00115-5311-01 ")
 ;;40
 ;;21,"00115-5322-01 ")
 ;;41
 ;;21,"00172-4364-00 ")
 ;;42
 ;;21,"00172-4364-10 ")
 ;;43
 ;;21,"00172-4364-60 ")
 ;;44
 ;;21,"00172-4364-70 ")
 ;;45
 ;;21,"00172-4365-60 ")
 ;;46
 ;;21,"00172-4365-70 ")
 ;;47
 ;;21,"00172-4366-60 ")
 ;;48
 ;;21,"00173-0347-44 ")
 ;;49
 ;;21,"00173-0790-01 ")
 ;;50
 ;;21,"00173-0790-02 ")
 ;;51
 ;;21,"00173-0791-01 ")
 ;;52
 ;;21,"00173-0791-02 ")
 ;;53
 ;;21,"00185-0010-01 ")
 ;;54
 ;;21,"00185-0010-05 ")
 ;;55
 ;;21,"00185-0117-01 ")
 ;;56
 ;;21,"00185-0117-05 ")
 ;;57
 ;;21,"00185-0118-01 ")
 ;;58
 ;;21,"00185-0118-05 ")
 ;;59
 ;;21,"00185-0281-01 ")
 ;;60
 ;;21,"00185-0283-10 ")
 ;;61
 ;;21,"00185-0284-10 ")
 ;;62
 ;;21,"00185-0701-01 ")
 ;;63
 ;;21,"00185-0701-05 ")
 ;;64
 ;;21,"00185-0701-30 ")
 ;;65
 ;;21,"00185-0704-01 ")
 ;;66
 ;;21,"00185-0704-05 ")
 ;;67
 ;;21,"00185-0704-30 ")
 ;;68
 ;;21,"00185-0707-01 ")
 ;;69
 ;;21,"00185-0707-05 ")
 ;;70
 ;;21,"00185-0707-30 ")
 ;;71
 ;;21,"00185-0771-01 ")
 ;;72
 ;;21,"00185-0771-30 ")
 ;;73
 ;;21,"00185-0774-01 ")
 ;;74
 ;;21,"00185-0774-30 ")
 ;;75
 ;;21,"00186-1088-05 ")
 ;;76
 ;;21,"00186-1088-39 ")
 ;;77
 ;;21,"00186-1090-05 ")
 ;;78
 ;;21,"00186-1090-39 ")
 ;;79
 ;;21,"00186-1092-05 ")
 ;;80
 ;;21,"00186-1092-39 ")
 ;;81
 ;;21,"00186-1094-05 ")
 ;;82
 ;;21,"00228-2778-11 ")
 ;;83
 ;;21,"00228-2778-50 ")
 ;;84
 ;;21,"00228-2779-11 ")
 ;;85
 ;;21,"00228-2779-50 ")
 ;;86
 ;;21,"00228-2780-11 ")
 ;;87
 ;;21,"00228-2780-50 ")
 ;;88
 ;;21,"00228-2781-11 ")
 ;;89
 ;;21,"00228-2781-50 ")
 ;;90
 ;;21,"00245-0084-10 ")
 ;;91
 ;;21,"00245-0084-11 ")
 ;;92
 ;;21,"00245-0085-10 ")
 ;;93
 ;;21,"00245-0085-11 ")
 ;;94
 ;;21,"00245-0086-10 ")
 ;;95
 ;;21,"00245-0086-11 ")
 ;;96
 ;;21,"00245-0087-10 ")
 ;;97
 ;;21,"00245-0087-11 ")
 ;;98
 ;;21,"00310-0101-10 ")
 ;;99
 ;;21,"00310-0105-10 ")
 ;;100
 ;;21,"00310-0107-10 ")
 ;;101
 ;;21,"00310-0115-10 ")
 ;;102
 ;;21,"00310-0117-10 ")
 ;;103
 ;;21,"00310-1087-30 ")
 ;;104
 ;;21,"00310-1095-30 ")
 ;;105
 ;;21,"00310-1097-30 ")
 ;;106
 ;;21,"00378-0018-01 ")
 ;;107
 ;;21,"00378-0018-02 ")
 ;;108
 ;;21,"00378-0018-05 ")
 ;;109
 ;;21,"00378-0018-07 ")
 ;;110
 ;;21,"00378-0018-91 ")
 ;;111
 ;;21,"00378-0028-01 ")
 ;;112
 ;;21,"00378-0032-01 ")
 ;;113
 ;;21,"00378-0032-02 ")
 ;;114
 ;;21,"00378-0032-04 ")
 ;;115
 ;;21,"00378-0032-10 ")
 ;;116
 ;;21,"00378-0047-01 ")
 ;;117
 ;;21,"00378-0047-02 ")
 ;;118
 ;;21,"00378-0047-04 ")
 ;;119
 ;;21,"00378-0047-10 ")
 ;;120
 ;;21,"00378-0052-01 ")
 ;;121
 ;;21,"00378-0055-01 ")
 ;;122
 ;;21,"00378-0096-01 ")
 ;;123
 ;;21,"00378-0127-01 ")
 ;;124
 ;;21,"00378-0182-01 ")
 ;;125
 ;;21,"00378-0182-10 ")
 ;;126
 ;;21,"00378-0183-01 ")
 ;;127
 ;;21,"00378-0183-10 ")
 ;;128
 ;;21,"00378-0184-01 ")
 ;;129
 ;;21,"00378-0184-10 ")
 ;;130
 ;;21,"00378-0185-01 ")
 ;;131
 ;;21,"00378-0185-05 ")
 ;;132
 ;;21,"00378-0187-01 ")
 ;;133
 ;;21,"00378-0218-01 ")
 ;;134
 ;;21,"00378-0218-10 ")
 ;;135
 ;;21,"00378-0221-01 ")
 ;;136
 ;;21,"00378-0231-01 ")
 ;;137
 ;;21,"00378-0231-10 ")
 ;;138
 ;;21,"00378-0347-01 ")
 ;;139
 ;;21,"00378-0424-01 ")
 ;;140
 ;;21,"00378-0434-01 ")
 ;;141
 ;;21,"00378-0445-01 ")
 ;;142
 ;;21,"00378-0501-01 ")
 ;;143
 ;;21,"00378-0501-10 ")
 ;;144
 ;;21,"00378-0503-01 ")
 ;;145
 ;;21,"00378-0503-10 ")
 ;;146
 ;;21,"00378-0505-01 ")
 ;;147
 ;;21,"00378-0505-05 ")
 ;;148
 ;;21,"00378-0523-01 ")
 ;;149
 ;;21,"00378-0523-93 ")
 ;;150
 ;;21,"00378-0524-01 ")
 ;;151
 ;;21,"00378-0524-93 ")
 ;;152
 ;;21,"00378-0715-01 ")
 ;;153
 ;;21,"00378-0731-01 ")
 ;;154
 ;;21,"00378-0757-01 ")
 ;;155
 ;;21,"00378-0757-10 ")
 ;;156
 ;;21,"00378-0757-93 ")
 ;;157
 ;;21,"00378-1132-01 ")
 ;;158
 ;;21,"00378-1132-10 ")
 ;;159
 ;;21,"00378-1171-01 ")
 ;;160
 ;;21,"00378-1171-10 ")
 ;;161
 ;;21,"00378-1200-01 ")
 ;;162
 ;;21,"00378-1400-01 ")
 ;;163
 ;;21,"00378-2063-01 ")
 ;;164
 ;;21,"00378-2064-01 ")
 ;;165
 ;;21,"00378-2064-93 ")
 ;;166
 ;;21,"00378-3631-01 ")
 ;;167
 ;;21,"00378-3631-02 ")
 ;;168
 ;;21,"00378-3631-05 ")
 ;;169
 ;;21,"00378-3631-07 ")
 ;;170
 ;;21,"00378-3632-01 ")
 ;;171
 ;;21,"00378-3632-02 ")
 ;;172
 ;;21,"00378-3632-05 ")
 ;;173
 ;;21,"00378-3632-07 ")
 ;;174
 ;;21,"00378-3633-01 ")
 ;;175
 ;;21,"00378-3633-02 ")
 ;;176
 ;;21,"00378-3633-05 ")
 ;;177
 ;;21,"00378-3633-07 ")
 ;;178
 ;;21,"00378-3634-01 ")
 ;;179
 ;;21,"00378-3634-02 ")
 ;;180
 ;;21,"00378-3634-05 ")
 ;;181
 ;;21,"00378-3634-07 ")
 ;;182
 ;;21,"00378-4593-01 ")
 ;;183
 ;;21,"00378-4593-05 ")
 ;;184
 ;;21,"00378-4594-01 ")
 ;;185
 ;;21,"00378-4594-05 ")
 ;;186
 ;;21,"00378-4595-10 ")
 ;;187
 ;;21,"00378-4595-77 ")
 ;;188
 ;;21,"00378-4596-10 ")
 ;;189
 ;;21,"00378-4596-77 ")
 ;;190
 ;;21,"00378-4597-10 ")
 ;;191
 ;;21,"00378-4597-77 ")
 ;;192
 ;;21,"00378-4598-05 ")
 ;;193
 ;;21,"00378-4598-77 ")
 ;;194
 ;;21,"00378-6160-01 ")
 ;;195
 ;;21,"00378-6160-05 ")
 ;;196
 ;;21,"00378-6180-01 ")
 ;;197
 ;;21,"00378-6180-05 ")
 ;;198
 ;;21,"00378-6220-01 ")
 ;;199
 ;;21,"00378-6220-05 ")
 ;;200
 ;;21,"00378-6260-01 ")
 ;;201
 ;;21,"00378-6260-05 ")
 ;;202
 ;;21,"00406-2022-01 ")
 ;;203
 ;;21,"00406-2022-10 ")
 ;;204
 ;;21,"00406-2023-01 ")
 ;;205
 ;;21,"00406-2023-10 ")
 ;;206
 ;;21,"00406-2024-01 ")
 ;;207
 ;;21,"00406-2024-10 ")
 ;;208
 ;;21,"00440-7170-30 ")
 ;;209
 ;;21,"00440-7170-45 ")
 ;;210
 ;;21,"00440-7170-90 ")
 ;;211
 ;;21,"00440-7171-06 ")
 ;;212
 ;;21,"00440-7171-10 ")
 ;;213
 ;;21,"00440-7171-30 ")
 ;;214
 ;;21,"00440-7171-45 ")
 ;;215
 ;;21,"00440-7171-60 ")
 ;;216
 ;;21,"00440-7171-90 ")
 ;;217
 ;;21,"00440-7171-92 ")
 ;;218
 ;;21,"00440-7172-30 ")
 ;;219
 ;;21,"00440-7172-90 ")
 ;;220
 ;;21,"00440-7678-60 ")
 ;;221
 ;;21,"00440-7679-60 ")
 ;;222
 ;;21,"00440-7784-45 ")
 ;;223
 ;;21,"00440-7784-90 ")
 ;;224
 ;;21,"00440-7785-06 ")
 ;;225
 ;;21,"00440-7785-20 ")
 ;;226
 ;;21,"00440-7785-28 ")
 ;;227
 ;;21,"00440-7785-30 ")
 ;;228
 ;;21,"00440-7785-45 ")
 ;;229
 ;;21,"00440-7785-60 ")
 ;;230
 ;;21,"00440-7785-90 ")
 ;;231
 ;;21,"00440-7785-92 ")
 ;;232
 ;;21,"00440-7785-94 ")
 ;;233
 ;;21,"00440-7786-06 ")
 ;;234
 ;;21,"00440-7786-30 ")
 ;;235
 ;;21,"00440-7786-60 ")
 ;;236
 ;;21,"00440-7786-92 ")
 ;;237
 ;;21,"00440-7786-94 ")
 ;;238
 ;;21,"00440-8230-60 ")
 ;;239
 ;;21,"00440-8230-90 ")
 ;;240
 ;;21,"00440-8230-91 ")
 ;;241
 ;;21,"00440-8230-92 ")
 ;;242
 ;;21,"00440-8230-94 ")
 ;;243
 ;;21,"00440-8232-30 ")
 ;;244
 ;;21,"00440-8232-90 ")
 ;;245
 ;;21,"00440-8232-94 ")
 ;;246
 ;;21,"00440-8233-94 ")
 ;;247
 ;;21,"00440-8234-90 ")
 ;;248
 ;;21,"00440-8234-94 ")
 ;;249
 ;;21,"00456-1402-01 ")
 ;;250
 ;;21,"00456-1402-11 ")
 ;;251
 ;;21,"00456-1402-30 ")
 ;;252
 ;;21,"00456-1402-63 ")
 ;;253
 ;;21,"00456-1405-01 ")
 ;;254
 ;;21,"00456-1405-11 ")
 ;;255
 ;;21,"00456-1405-30 ")
 ;;256
 ;;21,"00456-1405-63 ")
 ;;257
 ;;21,"00456-1405-90 ")
 ;;258
 ;;21,"00456-1410-01 ")
 ;;259
 ;;21,"00456-1410-11 ")
 ;;260
 ;;21,"00456-1410-30 ")
 ;;261
 ;;21,"00456-1410-63 ")
 ;;262
 ;;21,"00456-1410-90 ")
 ;;263
 ;;21,"00456-1420-01 ")
 ;;264
 ;;21,"00456-1420-30 ")
 ;;265
 ;;21,"00456-1420-90 ")
 ;;266
 ;;21,"00591-0462-01 ")
 ;;267
 ;;21,"00591-0462-10 ")
 ;;268
 ;;21,"00591-0463-01 ")
 ;;269
 ;;21,"00591-0463-10 ")
 ;;270
 ;;21,"00591-0605-01 ")
 ;;271
 ;;21,"00591-0605-05 ")
 ;;272
 ;;21,"00591-0606-01 ")
 ;;273
 ;;21,"00591-0606-05 ")
 ;;274
 ;;21,"00591-0607-01 ")
 ;;275
 ;;21,"00591-5554-01 ")
 ;;276
 ;;21,"00591-5554-10 ")
 ;;277
 ;;21,"00591-5555-01 ")
 ;;278
 ;;21,"00591-5555-10 ")
 ;;279
 ;;21,"00591-5556-01 ")
 ;;280
 ;;21,"00591-5556-10 ")
 ;;281
 ;;21,"00591-5557-01 ")
 ;;282
 ;;21,"00591-5557-05 ")
 ;;283
 ;;21,"00591-5782-01 ")
 ;;284
 ;;21,"00591-5783-01 ")
 ;;285
 ;;21,"00603-5482-21 ")
 ;;286
 ;;21,"00603-5482-32 ")
 ;;287
 ;;21,"00603-5483-02 ")
 ;;288
 ;;21,"00603-5483-21 ")
 ;;289
 ;;21,"00603-5483-32 ")
 ;;290
 ;;21,"00603-5484-21 ")
 ;;291
 ;;21,"00603-5484-32 ")
 ;;292
 ;;21,"00603-5485-21 ")
 ;;293
 ;;21,"00603-5486-21 ")
 ;;294
 ;;21,"00603-5486-28 ")
 ;;295
 ;;21,"00781-1078-01 ")
 ;;296
 ;;21,"00781-1078-10 ")
 ;;297
 ;;21,"00781-1181-01 ")
 ;;298
 ;;21,"00781-1181-10 ")
 ;;299
 ;;21,"00781-1181-92 ")
 ;;300
 ;;21,"00781-1182-01 ")
 ;;301
 ;;21,"00781-1182-10 ")
 ;;302
 ;;21,"00781-1182-92 ")
 ;;303
 ;;21,"00781-1183-01 ")
 ;;304
 ;;21,"00781-1183-10 ")
 ;;305
 ;;21,"00781-1183-92 ")
 ;;306
 ;;21,"00781-1223-01 ")
 ;;307
 ;;21,"00781-1223-10 ")
 ;;308
 ;;21,"00781-1228-01 ")
 ;;309
 ;;21,"00781-1228-10 ")
 ;;310
 ;;21,"00781-1506-01 ")
 ;;311
 ;;21,"00781-1506-10 ")
 ;;312
 ;;21,"00781-1507-01 ")
 ;;313
 ;;21,"00781-1507-10 ")
 ;;314
 ;;21,"00781-5220-01 ")
 ;;315
 ;;21,"00781-5220-10 ")
 ;;316
 ;;21,"00781-5221-01 ")
 ;;317
 ;;21,"00781-5222-01 ")
 ;;318
 ;;21,"00781-5223-01 ")
 ;;319
 ;;21,"00781-5224-01 ")
 ;;320
 ;;21,"00781-5225-01 ")
 ;;321
 ;;21,"00781-5225-10 ")
 ;;322
 ;;21,"00781-5229-01 ")
 ;;323
 ;;21,"00781-5229-10 ")
 ;;324
 ;;21,"00781-5630-01 ")
 ;;325
 ;;21,"00904-0411-61 ")
 ;;326
 ;;21,"00904-5392-61 ")
 ;;327
 ;;21,"00904-5928-61 ")
 ;;328
 ;;21,"00904-5929-61 ")
 ;;329
 ;;21,"00904-5930-61 ")
 ;;330
 ;;21,"00904-6033-61 ")
 ;;331
 ;;21,"00904-6034-61 ")
 ;;332
 ;;21,"00904-6096-61 ")
 ;;333
 ;;21,"00904-6097-61 ")
 ;;334
 ;;21,"00904-6098-61 ")
 ;;335
 ;;21,"00904-6099-61 ")
 ;;336
 ;;21,"00904-6162-61 ")
 ;;337
 ;;21,"00904-6169-61 ")
 ;;338
 ;;21,"00904-6170-61 ")
 ;;339
 ;
OTHER ; OTHER ROUTINES
 D ^BGP71T10
 D ^BGP71T11
 D ^BGP71T12
 D ^BGP71T13
 D ^BGP71T14
 D ^BGP71T15
 D ^BGP71T16
 D ^BGP71T17
 D ^BGP71T18
 D ^BGP71T19
 D ^BGP71T2
 D ^BGP71T20
 D ^BGP71T21
 D ^BGP71T22
 D ^BGP71T23
 D ^BGP71T24
 D ^BGP71T25
 D ^BGP71T26
 D ^BGP71T27
 D ^BGP71T28
 D ^BGP71T29
 D ^BGP71T3
 D ^BGP71T30
 D ^BGP71T31
 D ^BGP71T32
 D ^BGP71T4
 D ^BGP71T5
 D ^BGP71T6
 D ^BGP71T7
 D ^BGP71T8
 D ^BGP71T9
 Q