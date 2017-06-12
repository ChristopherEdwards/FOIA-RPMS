BGP72E ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 11, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;;BGP PQA CONTROLLER NDC
 ;
 ; This routine loads Taxonomy BGP PQA CONTROLLER NDC
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
 ;;21,"00006-0117-01 ")
 ;;1
 ;;21,"00006-0117-28 ")
 ;;2
 ;;21,"00006-0275-31 ")
 ;;3
 ;;21,"00006-0275-54 ")
 ;;4
 ;;21,"00006-0711-31 ")
 ;;5
 ;;21,"00006-0711-54 ")
 ;;6
 ;;21,"00006-1711-31 ")
 ;;7
 ;;21,"00006-1711-54 ")
 ;;8
 ;;21,"00006-3841-30 ")
 ;;9
 ;;21,"00006-9117-31 ")
 ;;10
 ;;21,"00006-9117-54 ")
 ;;11
 ;;21,"00006-9117-80 ")
 ;;12
 ;;21,"00006-9275-31 ")
 ;;13
 ;;21,"00006-9275-54 ")
 ;;14
 ;;21,"00037-7590-12 ")
 ;;15
 ;;21,"00037-7590-63 ")
 ;;16
 ;;21,"00054-0259-13 ")
 ;;17
 ;;21,"00054-0259-22 ")
 ;;18
 ;;21,"00054-0288-13 ")
 ;;19
 ;;21,"00054-0288-22 ")
 ;;20
 ;;21,"00054-0289-13 ")
 ;;21
 ;;21,"00054-0289-22 ")
 ;;22
 ;;21,"00085-1341-01 ")
 ;;23
 ;;21,"00085-1341-02 ")
 ;;24
 ;;21,"00085-1341-03 ")
 ;;25
 ;;21,"00085-1341-04 ")
 ;;26
 ;;21,"00085-1341-06 ")
 ;;27
 ;;21,"00085-1341-07 ")
 ;;28
 ;;21,"00085-1401-01 ")
 ;;29
 ;;21,"00085-1402-01 ")
 ;;30
 ;;21,"00085-1402-02 ")
 ;;31
 ;;21,"00085-1461-02 ")
 ;;32
 ;;21,"00085-1461-07 ")
 ;;33
 ;;21,"00085-4333-01 ")
 ;;34
 ;;21,"00085-4334-01 ")
 ;;35
 ;;21,"00085-4610-01 ")
 ;;36
 ;;21,"00085-4610-05 ")
 ;;37
 ;;21,"00085-7206-01 ")
 ;;38
 ;;21,"00085-7206-07 ")
 ;;39
 ;;21,"00093-7424-56 ")
 ;;40
 ;;21,"00093-7424-98 ")
 ;;41
 ;;21,"00093-7425-56 ")
 ;;42
 ;;21,"00093-7425-98 ")
 ;;43
 ;;21,"00093-7426-10 ")
 ;;44
 ;;21,"00093-7426-56 ")
 ;;45
 ;;21,"00093-7426-98 ")
 ;;46
 ;;21,"00143-9649-09 ")
 ;;47
 ;;21,"00143-9649-10 ")
 ;;48
 ;;21,"00143-9649-30 ")
 ;;49
 ;;21,"00143-9650-09 ")
 ;;50
 ;;21,"00143-9650-10 ")
 ;;51
 ;;21,"00143-9650-30 ")
 ;;52
 ;;21,"00143-9651-09 ")
 ;;53
 ;;21,"00143-9651-10 ")
 ;;54
 ;;21,"00143-9651-30 ")
 ;;55
 ;;21,"00173-0520-00 ")
 ;;56
 ;;21,"00173-0521-00 ")
 ;;57
 ;;21,"00173-0600-02 ")
 ;;58
 ;;21,"00173-0601-00 ")
 ;;59
 ;;21,"00173-0601-02 ")
 ;;60
 ;;21,"00173-0602-00 ")
 ;;61
 ;;21,"00173-0602-02 ")
 ;;62
 ;;21,"00173-0695-00 ")
 ;;63
 ;;21,"00173-0695-04 ")
 ;;64
 ;;21,"00173-0696-00 ")
 ;;65
 ;;21,"00173-0696-04 ")
 ;;66
 ;;21,"00173-0697-00 ")
 ;;67
 ;;21,"00173-0697-04 ")
 ;;68
 ;;21,"00173-0715-20 ")
 ;;69
 ;;21,"00173-0715-22 ")
 ;;70
 ;;21,"00173-0716-20 ")
 ;;71
 ;;21,"00173-0716-22 ")
 ;;72
 ;;21,"00173-0717-20 ")
 ;;73
 ;;21,"00173-0717-22 ")
 ;;74
 ;;21,"00173-0718-20 ")
 ;;75
 ;;21,"00173-0719-20 ")
 ;;76
 ;;21,"00173-0720-20 ")
 ;;77
 ;;21,"00173-0859-10 ")
 ;;78
 ;;21,"00173-0859-14 ")
 ;;79
 ;;21,"00173-0874-10 ")
 ;;80
 ;;21,"00173-0874-14 ")
 ;;81
 ;;21,"00173-0876-10 ")
 ;;82
 ;;21,"00173-0876-14 ")
 ;;83
 ;;21,"00173-0882-10 ")
 ;;84
 ;;21,"00173-0882-14 ")
 ;;85
 ;;21,"00186-0370-20 ")
 ;;86
 ;;21,"00186-0370-28 ")
 ;;87
 ;;21,"00186-0372-20 ")
 ;;88
 ;;21,"00186-0372-28 ")
 ;;89
 ;;21,"00186-0916-12 ")
 ;;90
 ;;21,"00186-0917-06 ")
 ;;91
 ;;21,"00310-0401-60 ")
 ;;92
 ;;21,"00310-0402-60 ")
 ;;93
 ;;21,"00310-0411-60 ")
 ;;94
 ;;21,"00310-0412-60 ")
 ;;95
 ;;21,"00378-5201-93 ")
 ;;96
 ;;21,"00378-5204-93 ")
 ;;97
 ;;21,"00378-5205-93 ")
 ;;98
 ;;21,"00378-6040-17 ")
 ;;99
 ;;21,"00378-6040-93 ")
 ;;100
 ;;21,"00440-8355-99 ")
 ;;101
 ;;21,"00440-8530-30 ")
 ;;102
 ;;21,"00440-8531-10 ")
 ;;103
 ;;21,"00440-8531-30 ")
 ;;104
 ;;21,"00440-8531-90 ")
 ;;105
 ;;21,"00440-8531-94 ")
 ;;106
 ;;21,"00440-8532-20 ")
 ;;107
 ;;21,"00440-8532-30 ")
 ;;108
 ;;21,"00440-8532-90 ")
 ;;109
 ;;21,"00440-8532-94 ")
 ;;110
 ;;21,"00456-4310-01 ")
 ;;111
 ;;21,"00456-4320-01 ")
 ;;112
 ;;21,"00456-4330-01 ")
 ;;113
 ;;21,"00603-4653-02 ")
 ;;114
 ;;21,"00603-4653-16 ")
 ;;115
 ;;21,"00603-4653-28 ")
 ;;116
 ;;21,"00603-4653-32 ")
 ;;117
 ;;21,"00603-4654-02 ")
 ;;118
 ;;21,"00603-4654-16 ")
 ;;119
 ;;21,"00603-4654-28 ")
 ;;120
 ;;21,"00603-4654-32 ")
 ;;121
 ;;21,"00603-4655-02 ")
 ;;122
 ;;21,"00603-4655-16 ")
 ;;123
 ;;21,"00603-4655-28 ")
 ;;124
 ;;21,"00603-4655-32 ")
 ;;125
 ;;21,"00603-4655-34 ")
 ;;126
 ;;21,"00781-5554-31 ")
 ;;127
 ;;21,"00781-5554-92 ")
 ;;128
 ;;21,"00781-5555-31 ")
 ;;129
 ;;21,"00781-5555-92 ")
 ;;130
 ;;21,"00781-5560-31 ")
 ;;131
 ;;21,"00781-5560-92 ")
 ;;132
 ;;21,"00904-5887-61 ")
 ;;133
 ;;21,"00904-5888-61 ")
 ;;134
 ;;21,"00904-5889-61 ")
 ;;135
 ;;21,"00904-6310-61 ")
 ;;136
 ;;21,"00904-6529-61 ")
 ;;137
 ;;21,"10122-0901-12 ")
 ;;138
 ;;21,"10122-0902-12 ")
 ;;139
 ;;21,"13668-0079-05 ")
 ;;140
 ;;21,"13668-0079-30 ")
 ;;141
 ;;21,"13668-0079-90 ")
 ;;142
 ;;21,"13668-0080-05 ")
 ;;143
 ;;21,"13668-0080-30 ")
 ;;144
 ;;21,"13668-0080-90 ")
 ;;145
 ;;21,"13668-0081-05 ")
 ;;146
 ;;21,"13668-0081-30 ")
 ;;147
 ;;21,"13668-0081-32 ")
 ;;148
 ;;21,"13668-0081-90 ")
 ;;149
 ;;21,"16590-0860-71 ")
 ;;150
 ;;21,"16729-0119-10 ")
 ;;151
 ;;21,"16729-0119-15 ")
 ;;152
 ;;21,"16729-0119-17 ")
 ;;153
 ;;21,"21695-0196-01 ")
 ;;154
 ;;21,"21695-0197-01 ")
 ;;155
 ;;21,"21695-0221-30 ")
 ;;156
 ;;21,"21695-0291-01 ")
 ;;157
 ;;21,"21695-0361-60 ")
 ;;158
 ;;21,"21695-0565-30 ")
 ;;159
 ;;21,"23155-0062-01 ")
 ;;160
 ;;21,"23155-0063-01 ")
 ;;161
 ;;21,"27241-0015-31 ")
 ;;162
 ;;21,"27241-0016-03 ")
 ;;163
 ;;21,"27241-0016-09 ")
 ;;164
 ;;21,"27241-0017-03 ")
 ;;165
 ;;21,"27241-0017-09 ")
 ;;166
 ;;21,"27241-0018-03 ")
 ;;167
 ;;21,"27241-0018-09 ")
 ;;168
 ;;21,"27241-0018-90 ")
 ;;169
 ;;21,"29033-0001-01 ")
 ;;170
 ;;21,"29033-0002-01 ")
 ;;171
 ;;21,"29300-0220-10 ")
 ;;172
 ;;21,"29300-0220-13 ")
 ;;173
 ;;21,"29300-0220-19 ")
 ;;174
 ;;21,"31722-0726-10 ")
 ;;175
 ;;21,"31722-0726-30 ")
 ;;176
 ;;21,"31722-0726-90 ")
 ;;177
 ;;21,"31722-0727-30 ")
 ;;178
 ;;21,"31722-0727-90 ")
 ;;179
 ;;21,"31722-0728-30 ")
 ;;180
 ;;21,"31722-0728-90 ")
 ;;181
 ;;21,"33261-0873-01 ")
 ;;182
 ;;21,"33261-0874-01 ")
 ;;183
 ;;21,"33261-0969-00 ")
 ;;184
 ;;21,"33261-0969-30 ")
 ;;185
 ;;21,"33261-0969-60 ")
 ;;186
 ;;21,"33261-0969-90 ")
 ;;187
 ;;21,"33342-0102-07 ")
 ;;188
 ;;21,"33342-0102-10 ")
 ;;189
 ;;21,"33342-0102-15 ")
 ;;190
 ;;21,"33342-0110-07 ")
 ;;191
 ;;21,"33342-0110-10 ")
 ;;192
 ;;21,"33342-0111-07 ")
 ;;193
 ;;21,"33342-0111-10 ")
 ;;194
 ;;21,"35356-0099-14 ")
 ;;195
 ;;21,"35356-0126-60 ")
 ;;196
 ;;21,"35356-0157-01 ")
 ;;197
 ;;21,"35356-0494-01 ")
 ;;198
 ;;21,"35356-0904-60 ")
 ;;199
 ;;21,"42254-0263-30 ")
 ;;200
 ;;21,"42254-0263-90 ")
 ;;201
 ;;21,"42291-0621-10 ")
 ;;202
 ;;21,"42291-0621-30 ")
 ;;203
 ;;21,"42291-0621-55 ")
 ;;204
 ;;21,"42291-0621-90 ")
 ;;205
 ;;21,"42291-0622-30 ")
 ;;206
 ;;21,"42291-0622-90 ")
 ;;207
 ;;21,"42291-0623-30 ")
 ;;208
 ;;21,"42291-0623-90 ")
 ;;209
 ;;21,"42291-0813-90 ")
 ;;210
 ;;21,"42291-0814-90 ")
 ;;211
 ;;21,"42291-0815-90 ")
 ;;212
 ;;21,"42858-0701-01 ")
 ;;213
 ;;21,"42858-0702-01 ")
 ;;214
 ;;21,"43063-0380-15 ")
 ;;215
 ;;21,"43063-0380-30 ")
 ;;216
 ;;21,"43063-0381-21 ")
 ;;217
 ;;21,"43063-0381-30 ")
 ;;218
 ;;21,"43353-0291-80 ")
 ;;219
 ;;21,"43353-0879-09 ")
 ;;220
 ;;21,"47463-0530-30 ")
 ;;221
 ;;21,"47463-0531-30 ")
 ;;222
 ;;21,"49884-0010-02 ")
 ;;223
 ;;21,"49884-0011-02 ")
 ;;224
 ;;21,"49884-0303-02 ")
 ;;225
 ;;21,"49884-0304-02 ")
 ;;226
 ;;21,"49884-0554-02 ")
 ;;227
 ;;21,"49999-0300-28 ")
 ;;228
 ;;21,"49999-0533-30 ")
 ;;229
 ;;21,"49999-0533-90 ")
 ;;230
 ;;21,"49999-0614-01 ")
 ;;231
 ;;21,"49999-0614-12 ")
 ;;232
 ;;21,"49999-0819-60 ")
 ;;233
 ;;21,"49999-0884-30 ")
 ;;234
 ;;21,"49999-0884-90 ")
 ;;235
 ;;21,"49999-0921-30 ")
 ;;236
 ;;21,"49999-0952-30 ")
 ;;237
 ;;21,"49999-0984-60 ")
 ;;238
 ;;21,"49999-0985-60 ")
 ;;239
 ;;21,"50111-0459-01 ")
 ;;240
 ;;21,"50111-0459-02 ")
 ;;241
 ;;21,"50111-0459-03 ")
 ;;242
 ;;21,"50111-0482-01 ")
 ;;243
 ;;21,"50111-0482-02 ")
 ;;244
 ;;21,"50111-0482-03 ")
 ;;245
 ;;21,"50111-0483-01 ")
 ;;246
 ;;21,"50111-0483-02 ")
 ;;247
 ;;21,"50111-0518-01 ")
 ;;248
 ;;21,"50268-0573-11 ")
 ;;249
 ;;21,"50268-0573-15 ")
 ;;250
 ;;21,"50268-0574-11 ")
 ;;251
 ;;21,"50268-0574-15 ")
 ;;252
 ;;21,"50268-0575-11 ")
 ;;253
 ;;21,"50268-0575-15 ")
 ;;254
 ;;21,"50474-0100-01 ")
 ;;255
 ;;21,"50474-0200-01 ")
 ;;256
 ;;21,"50474-0200-50 ")
 ;;257
 ;;21,"50474-0300-01 ")
 ;;258
 ;;21,"50474-0300-50 ")
 ;;259
 ;;21,"50474-0400-01 ")
 ;;260
 ;;21,"51079-0223-01 ")
 ;;261
 ;;21,"51079-0223-20 ")
 ;;262
 ;;21,"52244-0100-10 ")
 ;;263
 ;;21,"52244-0200-10 ")
 ;;264
 ;;21,"52244-0300-10 ")
 ;;265
 ;;21,"52244-0400-10 ")
 ;;266
 ;;21,"54458-0890-10 ")
 ;;267
 ;;21,"54569-2483-01 ")
 ;;268
 ;;21,"54569-2483-02 ")
 ;;269
 ;;21,"54569-4605-00 ")
 ;;270
 ;;21,"54569-4605-01 ")
 ;;271
 ;;21,"54569-4736-00 ")
 ;;272
 ;;21,"54569-4867-00 ")
 ;;273
 ;;21,"54569-5241-00 ")
 ;;274
 ;;21,"54569-5242-00 ")
 ;;275
 ;;21,"54569-5243-00 ")
 ;;276
 ;;21,"54569-5663-00 ")
 ;;277
 ;;21,"54569-5671-00 ")
 ;;278
 ;;21,"54569-5702-00 ")
 ;;279
 ;;21,"54569-5928-00 ")
 ;;280
 ;;21,"54569-6265-00 ")
 ;;281
 ;;21,"54569-6266-00 ")
 ;;282
 ;;21,"54569-6321-00 ")
 ;;283
 ;;21,"54569-6348-00 ")
 ;;284
 ;;21,"54569-6348-01 ")
 ;;285
 ;;21,"54569-6349-00 ")
 ;;286
 ;;21,"54569-6349-01 ")
 ;;287
 ;;21,"54569-6390-00 ")
 ;;288
 ;;21,"54569-6430-00 ")
 ;;289
 ;;21,"54569-6430-01 ")
 ;;290
 ;;21,"54569-6466-00 ")
 ;;291
 ;;21,"54569-6611-00 ")
 ;;292
 ;;21,"54569-6612-00 ")
 ;;293
 ;;21,"54868-0028-01 ")
 ;;294
 ;;21,"54868-0028-02 ")
 ;;295
 ;;21,"54868-0028-06 ")
 ;;296
 ;;21,"54868-0029-02 ")
 ;;297
 ;;21,"54868-0029-05 ")
 ;;298
 ;;21,"54868-0029-06 ")
 ;;299
 ;;21,"54868-0029-07 ")
 ;;300
 ;;21,"54868-1461-01 ")
 ;;301
 ;;21,"54868-1461-02 ")
 ;;302
 ;;21,"54868-3283-01 ")
 ;;303
 ;;21,"54868-3283-02 ")
 ;;304
 ;;21,"54868-4481-00 ")
 ;;305
 ;;21,"54868-4516-00 ")
 ;;306
 ;;21,"54868-4517-00 ")
 ;;307
 ;;21,"54868-4518-00 ")
 ;;308
 ;;21,"54868-4630-00 ")
 ;;309
 ;;21,"54868-4847-00 ")
 ;;310
 ;;21,"54868-4972-01 ")
 ;;311
 ;;21,"54868-5362-00 ")
 ;;312
 ;;21,"54868-5547-00 ")
 ;;313
 ;;21,"54868-5547-01 ")
 ;;314
 ;;21,"54868-5547-02 ")
 ;;315
 ;;21,"54868-5637-00 ")
 ;;316
 ;;21,"54868-5844-00 ")
 ;;317
 ;;21,"54868-5857-00 ")
 ;;318
 ;;21,"54868-5857-01 ")
 ;;319
 ;;21,"54868-5858-00 ")
 ;;320
 ;;21,"54868-5858-01 ")
 ;;321
 ;;21,"54868-5936-00 ")
 ;;322
 ;;21,"54868-5937-00 ")
 ;;323
 ;;21,"54868-5989-00 ")
 ;;324
 ;;21,"54868-5990-00 ")
 ;;325
 ;;21,"54868-5995-00 ")
 ;;326
 ;;21,"54868-6361-00 ")
 ;;327
 ;;21,"55048-0530-30 ")
 ;;328
 ;;21,"55048-0531-30 ")
 ;;329
 ;;21,"55111-0593-30 ")
 ;;330
 ;;21,"55111-0593-90 ")
 ;;331
 ;;21,"55111-0594-30 ")
 ;;332
 ;;21,"55111-0594-90 ")
 ;;333
 ;;21,"55111-0625-60 ")
 ;;334
 ;;21,"55111-0626-60 ")
 ;;335
 ;;21,"55111-0725-10 ")
 ;;336
 ;;21,"55111-0725-30 ")
 ;;337
 ;;21,"55111-0725-90 ")
 ;;338
 ;;21,"55111-0725-94 ")
 ;;339
 ;
OTHER ; OTHER ROUTINES
 D ^BGP72E2
 D ^BGP72E3
 D ^BGP72E4
 D ^BGP72E5
 D ^BGP72E6
 D ^BGP72E7
 Q