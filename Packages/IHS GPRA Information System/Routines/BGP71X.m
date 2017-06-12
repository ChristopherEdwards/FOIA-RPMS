BGP71X ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 11, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;;BGP PQA SULFONYLUREA NDC
 ;
 ; This routine loads Taxonomy BGP PQA SULFONYLUREA NDC
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
 ;;21,"00009-0341-01 ")
 ;;1
 ;;21,"00009-0352-01 ")
 ;;2
 ;;21,"00009-0352-04 ")
 ;;3
 ;;21,"00009-3449-01 ")
 ;;4
 ;;21,"00009-3449-03 ")
 ;;5
 ;;21,"00039-0051-10 ")
 ;;6
 ;;21,"00039-0052-10 ")
 ;;7
 ;;21,"00039-0052-70 ")
 ;;8
 ;;21,"00039-0053-05 ")
 ;;9
 ;;21,"00039-0221-10 ")
 ;;10
 ;;21,"00039-0222-10 ")
 ;;11
 ;;21,"00039-0223-10 ")
 ;;12
 ;;21,"00049-0170-01 ")
 ;;13
 ;;21,"00049-0174-02 ")
 ;;14
 ;;21,"00049-0174-03 ")
 ;;15
 ;;21,"00049-0178-07 ")
 ;;16
 ;;21,"00049-0178-08 ")
 ;;17
 ;;21,"00049-1550-66 ")
 ;;18
 ;;21,"00049-1550-73 ")
 ;;19
 ;;21,"00049-1560-66 ")
 ;;20
 ;;21,"00049-1560-73 ")
 ;;21
 ;;21,"00049-4110-66 ")
 ;;22
 ;;21,"00049-4120-66 ")
 ;;23
 ;;21,"00087-6072-11 ")
 ;;24
 ;;21,"00087-6073-11 ")
 ;;25
 ;;21,"00087-6074-11 ")
 ;;26
 ;;21,"00093-5710-01 ")
 ;;27
 ;;21,"00093-5710-05 ")
 ;;28
 ;;21,"00093-5711-01 ")
 ;;29
 ;;21,"00093-5711-05 ")
 ;;30
 ;;21,"00093-5712-01 ")
 ;;31
 ;;21,"00093-5712-05 ")
 ;;32
 ;;21,"00093-7254-01 ")
 ;;33
 ;;21,"00093-7255-01 ")
 ;;34
 ;;21,"00093-7256-01 ")
 ;;35
 ;;21,"00093-7256-52 ")
 ;;36
 ;;21,"00093-7261-05 ")
 ;;37
 ;;21,"00093-7262-05 ")
 ;;38
 ;;21,"00093-7455-01 ")
 ;;39
 ;;21,"00093-7456-01 ")
 ;;40
 ;;21,"00093-7457-01 ")
 ;;41
 ;;21,"00093-8034-01 ")
 ;;42
 ;;21,"00093-8035-01 ")
 ;;43
 ;;21,"00093-8035-05 ")
 ;;44
 ;;21,"00093-8036-01 ")
 ;;45
 ;;21,"00093-8342-01 ")
 ;;46
 ;;21,"00093-8343-01 ")
 ;;47
 ;;21,"00093-8343-05 ")
 ;;48
 ;;21,"00093-8343-10 ")
 ;;49
 ;;21,"00093-8343-98 ")
 ;;50
 ;;21,"00093-8344-01 ")
 ;;51
 ;;21,"00093-8344-05 ")
 ;;52
 ;;21,"00093-8344-10 ")
 ;;53
 ;;21,"00093-8344-98 ")
 ;;54
 ;;21,"00093-9364-01 ")
 ;;55
 ;;21,"00093-9364-05 ")
 ;;56
 ;;21,"00093-9364-10 ")
 ;;57
 ;;21,"00093-9433-01 ")
 ;;58
 ;;21,"00093-9433-05 ")
 ;;59
 ;;21,"00093-9477-53 ")
 ;;60
 ;;21,"00143-9918-01 ")
 ;;61
 ;;21,"00143-9919-01 ")
 ;;62
 ;;21,"00143-9919-05 ")
 ;;63
 ;;21,"00143-9920-01 ")
 ;;64
 ;;21,"00143-9920-05 ")
 ;;65
 ;;21,"00143-9920-10 ")
 ;;66
 ;;21,"00172-3649-00 ")
 ;;67
 ;;21,"00172-3649-60 ")
 ;;68
 ;;21,"00172-3650-00 ")
 ;;69
 ;;21,"00172-3650-60 ")
 ;;70
 ;;21,"00172-3650-70 ")
 ;;71
 ;;21,"00173-0841-13 ")
 ;;72
 ;;21,"00173-0842-13 ")
 ;;73
 ;;21,"00173-0843-13 ")
 ;;74
 ;;21,"00173-0844-13 ")
 ;;75
 ;;21,"00173-0845-13 ")
 ;;76
 ;;21,"00182-2646-89 ")
 ;;77
 ;;21,"00228-2751-11 ")
 ;;78
 ;;21,"00228-2751-50 ")
 ;;79
 ;;21,"00228-2752-11 ")
 ;;80
 ;;21,"00228-2752-50 ")
 ;;81
 ;;21,"00228-2753-11 ")
 ;;82
 ;;21,"00228-2753-50 ")
 ;;83
 ;;21,"00228-2898-03 ")
 ;;84
 ;;21,"00228-2899-96 ")
 ;;85
 ;;21,"00228-2900-96 ")
 ;;86
 ;;21,"00378-0197-01 ")
 ;;87
 ;;21,"00378-0210-01 ")
 ;;88
 ;;21,"00378-0215-01 ")
 ;;89
 ;;21,"00378-0215-05 ")
 ;;90
 ;;21,"00378-0217-01 ")
 ;;91
 ;;21,"00378-0340-93 ")
 ;;92
 ;;21,"00378-0342-01 ")
 ;;93
 ;;21,"00378-0342-10 ")
 ;;94
 ;;21,"00378-0431-01 ")
 ;;95
 ;;21,"00378-0431-10 ")
 ;;96
 ;;21,"00378-0551-01 ")
 ;;97
 ;;21,"00378-1105-01 ")
 ;;98
 ;;21,"00378-1105-05 ")
 ;;99
 ;;21,"00378-1110-01 ")
 ;;100
 ;;21,"00378-1110-05 ")
 ;;101
 ;;21,"00378-1113-01 ")
 ;;102
 ;;21,"00378-1125-01 ")
 ;;103
 ;;21,"00378-1125-10 ")
 ;;104
 ;;21,"00378-1142-01 ")
 ;;105
 ;;21,"00378-3131-01 ")
 ;;106
 ;;21,"00378-3132-01 ")
 ;;107
 ;;21,"00378-3133-01 ")
 ;;108
 ;;21,"00378-4011-01 ")
 ;;109
 ;;21,"00378-4012-01 ")
 ;;110
 ;;21,"00378-4013-01 ")
 ;;111
 ;;21,"00440-7565-14 ")
 ;;112
 ;;21,"00440-7565-30 ")
 ;;113
 ;;21,"00440-7565-60 ")
 ;;114
 ;;21,"00440-7565-90 ")
 ;;115
 ;;21,"00440-7566-30 ")
 ;;116
 ;;21,"00440-7566-60 ")
 ;;117
 ;;21,"00440-7566-90 ")
 ;;118
 ;;21,"00440-7566-91 ")
 ;;119
 ;;21,"00440-7566-92 ")
 ;;120
 ;;21,"00440-7568-90 ")
 ;;121
 ;;21,"00440-7568-92 ")
 ;;122
 ;;21,"00440-7569-90 ")
 ;;123
 ;;21,"00440-7569-92 ")
 ;;124
 ;;21,"00440-7570-20 ")
 ;;125
 ;;21,"00440-7571-14 ")
 ;;126
 ;;21,"00440-7571-30 ")
 ;;127
 ;;21,"00440-7571-60 ")
 ;;128
 ;;21,"00440-7571-90 ")
 ;;129
 ;;21,"00440-7571-91 ")
 ;;130
 ;;21,"00440-7571-92 ")
 ;;131
 ;;21,"00440-7571-94 ")
 ;;132
 ;;21,"00440-7571-95 ")
 ;;133
 ;;21,"00440-7585-90 ")
 ;;134
 ;;21,"00440-7587-90 ")
 ;;135
 ;;21,"00440-7589-90 ")
 ;;136
 ;;21,"00440-7589-95 ")
 ;;137
 ;;21,"00591-0460-01 ")
 ;;138
 ;;21,"00591-0460-05 ")
 ;;139
 ;;21,"00591-0460-10 ")
 ;;140
 ;;21,"00591-0461-01 ")
 ;;141
 ;;21,"00591-0461-05 ")
 ;;142
 ;;21,"00591-0461-10 ")
 ;;143
 ;;21,"00591-0844-01 ")
 ;;144
 ;;21,"00591-0844-10 ")
 ;;145
 ;;21,"00591-0844-15 ")
 ;;146
 ;;21,"00591-0845-01 ")
 ;;147
 ;;21,"00591-0845-10 ")
 ;;148
 ;;21,"00591-0845-15 ")
 ;;149
 ;;21,"00591-0900-30 ")
 ;;150
 ;;21,"00603-3744-21 ")
 ;;151
 ;;21,"00603-3744-28 ")
 ;;152
 ;;21,"00603-3745-21 ")
 ;;153
 ;;21,"00603-3745-28 ")
 ;;154
 ;;21,"00603-3746-21 ")
 ;;155
 ;;21,"00603-3746-28 ")
 ;;156
 ;;21,"00781-1452-01 ")
 ;;157
 ;;21,"00781-1452-10 ")
 ;;158
 ;;21,"00781-1453-01 ")
 ;;159
 ;;21,"00781-1453-10 ")
 ;;160
 ;;21,"00781-5634-31 ")
 ;;161
 ;;21,"00781-5635-31 ")
 ;;162
 ;;21,"00832-0491-10 ")
 ;;163
 ;;21,"00832-0491-11 ")
 ;;164
 ;;21,"00832-0492-10 ")
 ;;165
 ;;21,"00832-0492-11 ")
 ;;166
 ;;21,"00904-6123-61 ")
 ;;167
 ;;21,"00904-6124-61 ")
 ;;168
 ;;21,"00904-6137-60 ")
 ;;169
 ;;21,"00904-6138-40 ")
 ;;170
 ;;21,"00904-6138-60 ")
 ;;171
 ;;21,"00904-6139-60 ")
 ;;172
 ;;21,"00904-6139-80 ")
 ;;173
 ;;21,"10370-0190-01 ")
 ;;174
 ;;21,"10370-0190-05 ")
 ;;175
 ;;21,"10370-0191-01 ")
 ;;176
 ;;21,"10370-0191-05 ")
 ;;177
 ;;21,"10544-0192-30 ")
 ;;178
 ;;21,"10544-0217-30 ")
 ;;179
 ;;21,"10544-0219-30 ")
 ;;180
 ;;21,"10544-0579-30 ")
 ;;181
 ;;21,"10544-0579-90 ")
 ;;182
 ;;21,"16590-0286-30 ")
 ;;183
 ;;21,"16590-0286-60 ")
 ;;184
 ;;21,"16590-0286-90 ")
 ;;185
 ;;21,"16590-0287-30 ")
 ;;186
 ;;21,"16590-0287-60 ")
 ;;187
 ;;21,"16729-0001-01 ")
 ;;188
 ;;21,"16729-0002-01 ")
 ;;189
 ;;21,"16729-0003-01 ")
 ;;190
 ;;21,"16729-0139-00 ")
 ;;191
 ;;21,"16729-0139-16 ")
 ;;192
 ;;21,"16729-0140-00 ")
 ;;193
 ;;21,"16729-0140-16 ")
 ;;194
 ;;21,"21695-0467-30 ")
 ;;195
 ;;21,"21695-0467-60 ")
 ;;196
 ;;21,"21695-0468-30 ")
 ;;197
 ;;21,"21695-0468-60 ")
 ;;198
 ;;21,"21695-0468-72 ")
 ;;199
 ;;21,"21695-0468-78 ")
 ;;200
 ;;21,"21695-0469-30 ")
 ;;201
 ;;21,"21695-0469-60 ")
 ;;202
 ;;21,"21695-0469-90 ")
 ;;203
 ;;21,"21695-0470-00 ")
 ;;204
 ;;21,"21695-0470-30 ")
 ;;205
 ;;21,"21695-0470-60 ")
 ;;206
 ;;21,"21695-0470-78 ")
 ;;207
 ;;21,"21695-0470-90 ")
 ;;208
 ;;21,"21695-0568-30 ")
 ;;209
 ;;21,"21695-0746-30 ")
 ;;210
 ;;21,"21695-0746-90 ")
 ;;211
 ;;21,"21695-0747-30 ")
 ;;212
 ;;21,"21695-0747-60 ")
 ;;213
 ;;21,"21695-0747-90 ")
 ;;214
 ;;21,"21695-0894-00 ")
 ;;215
 ;;21,"21695-0967-30 ")
 ;;216
 ;;21,"21695-0993-72 ")
 ;;217
 ;;21,"23155-0056-01 ")
 ;;218
 ;;21,"23155-0057-01 ")
 ;;219
 ;;21,"23155-0058-01 ")
 ;;220
 ;;21,"23155-0058-10 ")
 ;;221
 ;;21,"23155-0115-01 ")
 ;;222
 ;;21,"23155-0116-01 ")
 ;;223
 ;;21,"23155-0117-01 ")
 ;;224
 ;;21,"23155-0233-01 ")
 ;;225
 ;;21,"23155-0233-05 ")
 ;;226
 ;;21,"23155-0234-01 ")
 ;;227
 ;;21,"23155-0234-05 ")
 ;;228
 ;;21,"23155-0235-01 ")
 ;;229
 ;;21,"23155-0235-05 ")
 ;;230
 ;;21,"33261-0209-30 ")
 ;;231
 ;;21,"33261-0209-60 ")
 ;;232
 ;;21,"33261-0209-90 ")
 ;;233
 ;;21,"33261-0397-00 ")
 ;;234
 ;;21,"33261-0397-30 ")
 ;;235
 ;;21,"33261-0397-60 ")
 ;;236
 ;;21,"33261-0397-90 ")
 ;;237
 ;;21,"33261-0411-00 ")
 ;;238
 ;;21,"33261-0411-30 ")
 ;;239
 ;;21,"33261-0411-60 ")
 ;;240
 ;;21,"33261-0411-90 ")
 ;;241
 ;;21,"33261-0433-00 ")
 ;;242
 ;;21,"33261-0433-30 ")
 ;;243
 ;;21,"33261-0433-60 ")
 ;;244
 ;;21,"33261-0433-90 ")
 ;;245
 ;;21,"33261-0813-30 ")
 ;;246
 ;;21,"33261-0813-60 ")
 ;;247
 ;;21,"33261-0813-90 ")
 ;;248
 ;;21,"33261-0821-30 ")
 ;;249
 ;;21,"33261-0821-60 ")
 ;;250
 ;;21,"33261-0821-90 ")
 ;;251
 ;;21,"33261-0830-30 ")
 ;;252
 ;;21,"33261-0830-60 ")
 ;;253
 ;;21,"33261-0830-90 ")
 ;;254
 ;;21,"33261-0831-30 ")
 ;;255
 ;;21,"33261-0831-60 ")
 ;;256
 ;;21,"33261-0831-90 ")
 ;;257
 ;;21,"33261-0835-30 ")
 ;;258
 ;;21,"33261-0835-60 ")
 ;;259
 ;;21,"33261-0835-90 ")
 ;;260
 ;;21,"33261-0892-00 ")
 ;;261
 ;;21,"33261-0892-30 ")
 ;;262
 ;;21,"33261-0892-60 ")
 ;;263
 ;;21,"33261-0892-90 ")
 ;;264
 ;;21,"33261-0961-30 ")
 ;;265
 ;;21,"33261-0961-60 ")
 ;;266
 ;;21,"33261-0961-90 ")
 ;;267
 ;;21,"33358-0157-30 ")
 ;;268
 ;;21,"33358-0157-60 ")
 ;;269
 ;;21,"33358-0158-00 ")
 ;;270
 ;;21,"33358-0158-30 ")
 ;;271
 ;;21,"33358-0158-60 ")
 ;;272
 ;;21,"33358-0160-30 ")
 ;;273
 ;;21,"33358-0160-60 ")
 ;;274
 ;;21,"33358-0161-01 ")
 ;;275
 ;;21,"33358-0161-30 ")
 ;;276
 ;;21,"33358-0161-60 ")
 ;;277
 ;;21,"33358-0161-90 ")
 ;;278
 ;;21,"35356-0099-60 ")
 ;;279
 ;;21,"35356-0121-90 ")
 ;;280
 ;;21,"35356-0360-30 ")
 ;;281
 ;;21,"35356-0360-60 ")
 ;;282
 ;;21,"35356-0360-90 ")
 ;;283
 ;;21,"35356-0875-30 ")
 ;;284
 ;;21,"35356-0875-60 ")
 ;;285
 ;;21,"35356-0896-30 ")
 ;;286
 ;;21,"35356-0897-30 ")
 ;;287
 ;;21,"35356-0897-60 ")
 ;;288
 ;;21,"35356-0897-90 ")
 ;;289
 ;;21,"35356-0899-30 ")
 ;;290
 ;;21,"35356-0899-60 ")
 ;;291
 ;;21,"35356-0899-90 ")
 ;;292
 ;;21,"35356-0931-30 ")
 ;;293
 ;;21,"35356-0931-60 ")
 ;;294
 ;;21,"35356-0931-90 ")
 ;;295
 ;;21,"35356-0932-30 ")
 ;;296
 ;;21,"35356-0932-60 ")
 ;;297
 ;;21,"35356-0932-90 ")
 ;;298
 ;;21,"35356-0970-30 ")
 ;;299
 ;;21,"35356-0970-60 ")
 ;;300
 ;;21,"35356-0970-90 ")
 ;;301
 ;;21,"35356-0995-30 ")
 ;;302
 ;;21,"35356-0995-60 ")
 ;;303
 ;;21,"35356-0995-90 ")
 ;;304
 ;;21,"42254-0071-30 ")
 ;;305
 ;;21,"42254-0090-60 ")
 ;;306
 ;;21,"42254-0281-30 ")
 ;;307
 ;;21,"42254-0281-90 ")
 ;;308
 ;;21,"42291-0305-01 ")
 ;;309
 ;;21,"42291-0306-01 ")
 ;;310
 ;;21,"42291-0316-50 ")
 ;;311
 ;;21,"42291-0317-10 ")
 ;;312
 ;;21,"42549-0498-30 ")
 ;;313
 ;;21,"42549-0499-30 ")
 ;;314
 ;;21,"42571-0100-01 ")
 ;;315
 ;;21,"42571-0100-05 ")
 ;;316
 ;;21,"42571-0101-01 ")
 ;;317
 ;;21,"42571-0101-05 ")
 ;;318
 ;;21,"42571-0103-01 ")
 ;;319
 ;;21,"42571-0103-05 ")
 ;;320
 ;;21,"43063-0034-30 ")
 ;;321
 ;;21,"43063-0034-90 ")
 ;;322
 ;;21,"43063-0119-90 ")
 ;;323
 ;;21,"43063-0120-90 ")
 ;;324
 ;;21,"43063-0121-30 ")
 ;;325
 ;;21,"43063-0121-90 ")
 ;;326
 ;;21,"43063-0122-30 ")
 ;;327
 ;;21,"43063-0122-90 ")
 ;;328
 ;;21,"43063-0397-86 ")
 ;;329
 ;;21,"43063-0433-14 ")
 ;;330
 ;;21,"43063-0433-30 ")
 ;;331
 ;;21,"43063-0433-86 ")
 ;;332
 ;;21,"43063-0433-90 ")
 ;;333
 ;;21,"43063-0433-93 ")
 ;;334
 ;;21,"43063-0587-90 ")
 ;;335
 ;;21,"43353-0369-53 ")
 ;;336
 ;;21,"43353-0369-60 ")
 ;;337
 ;;21,"43353-0369-70 ")
 ;;338
 ;;21,"43353-0369-80 ")
 ;;339
 ;
OTHER ; OTHER ROUTINES
 D ^BGP71X10
 D ^BGP71X11
 D ^BGP71X12
 D ^BGP71X13
 D ^BGP71X14
 D ^BGP71X15
 D ^BGP71X2
 D ^BGP71X3
 D ^BGP71X4
 D ^BGP71X5
 D ^BGP71X6
 D ^BGP71X7
 D ^BGP71X8
 D ^BGP71X9
 Q