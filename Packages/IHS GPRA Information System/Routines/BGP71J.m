BGP71J ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 11, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;;BGP HEDIS ANTICHOLINERGIC NDC
 ;
 ; This routine loads Taxonomy BGP HEDIS ANTICHOLINERGIC NDC
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
 ;;21,"00069-5410-66 ")
 ;;1
 ;;21,"00069-5420-66 ")
 ;;2
 ;;21,"00093-0308-01 ")
 ;;3
 ;;21,"00093-0309-12 ")
 ;;4
 ;;21,"00093-2929-01 ")
 ;;5
 ;;21,"00093-2929-10 ")
 ;;6
 ;;21,"00093-5060-01 ")
 ;;7
 ;;21,"00093-5060-05 ")
 ;;8
 ;;21,"00093-5060-10 ")
 ;;9
 ;;21,"00093-5061-01 ")
 ;;10
 ;;21,"00093-5061-05 ")
 ;;11
 ;;21,"00093-5061-10 ")
 ;;12
 ;;21,"00093-5062-01 ")
 ;;13
 ;;21,"00093-5062-05 ")
 ;;14
 ;;21,"00093-5062-10 ")
 ;;15
 ;;21,"00095-0054-01 ")
 ;;16
 ;;21,"00095-0054-20 ")
 ;;17
 ;;21,"00095-0108-01 ")
 ;;18
 ;;21,"00095-0108-20 ")
 ;;19
 ;;21,"00115-1040-01 ")
 ;;20
 ;;21,"00115-1041-01 ")
 ;;21
 ;;21,"00115-1041-03 ")
 ;;22
 ;;21,"00115-1042-01 ")
 ;;23
 ;;21,"00121-0489-05 ")
 ;;24
 ;;21,"00121-0489-10 ")
 ;;25
 ;;21,"00121-0547-05 ")
 ;;26
 ;;21,"00121-0658-16 ")
 ;;27
 ;;21,"00121-0788-16 ")
 ;;28
 ;;21,"00121-4788-10 ")
 ;;29
 ;;21,"00121-4822-25 ")
 ;;30
 ;;21,"00143-1763-01 ")
 ;;31
 ;;21,"00143-1763-10 ")
 ;;32
 ;;21,"00143-1764-01 ")
 ;;33
 ;;21,"00143-1764-10 ")
 ;;34
 ;;21,"00143-9868-22 ")
 ;;35
 ;;21,"00143-9869-22 ")
 ;;36
 ;;21,"00179-0072-30 ")
 ;;37
 ;;21,"00185-0613-01 ")
 ;;38
 ;;21,"00185-0613-05 ")
 ;;39
 ;;21,"00185-0615-01 ")
 ;;40
 ;;21,"00185-0615-05 ")
 ;;41
 ;;21,"00185-0674-01 ")
 ;;42
 ;;21,"00185-0674-05 ")
 ;;43
 ;;21,"00187-0054-01 ")
 ;;44
 ;;21,"00187-0054-20 ")
 ;;45
 ;;21,"00187-0108-01 ")
 ;;46
 ;;21,"00187-0108-20 ")
 ;;47
 ;;21,"00378-2586-01 ")
 ;;48
 ;;21,"00378-2586-10 ")
 ;;49
 ;;21,"00378-2587-01 ")
 ;;50
 ;;21,"00378-2587-10 ")
 ;;51
 ;;21,"00378-2588-01 ")
 ;;52
 ;;21,"00378-2588-10 ")
 ;;53
 ;;21,"00409-2312-02 ")
 ;;54
 ;;21,"00409-2312-31 ")
 ;;55
 ;;21,"00440-1617-12 ")
 ;;56
 ;;21,"00440-7195-30 ")
 ;;57
 ;;21,"00440-7195-60 ")
 ;;58
 ;;21,"00440-7195-90 ")
 ;;59
 ;;21,"00440-7195-92 ")
 ;;60
 ;;21,"00440-7196-30 ")
 ;;61
 ;;21,"00440-7196-60 ")
 ;;62
 ;;21,"00440-7196-90 ")
 ;;63
 ;;21,"00440-7196-92 ")
 ;;64
 ;;21,"00440-7360-30 ")
 ;;65
 ;;21,"00440-7426-04 ")
 ;;66
 ;;21,"00440-7426-06 ")
 ;;67
 ;;21,"00440-7426-09 ")
 ;;68
 ;;21,"00440-7426-12 ")
 ;;69
 ;;21,"00440-7426-20 ")
 ;;70
 ;;21,"00440-7426-30 ")
 ;;71
 ;;21,"00440-7426-60 ")
 ;;72
 ;;21,"00440-7616-30 ")
 ;;73
 ;;21,"00440-7617-04 ")
 ;;74
 ;;21,"00440-7617-06 ")
 ;;75
 ;;21,"00440-7617-12 ")
 ;;76
 ;;21,"00440-7617-15 ")
 ;;77
 ;;21,"00440-7617-16 ")
 ;;78
 ;;21,"00440-7617-21 ")
 ;;79
 ;;21,"00440-7617-30 ")
 ;;80
 ;;21,"00440-7620-04 ")
 ;;81
 ;;21,"00440-8195-04 ")
 ;;82
 ;;21,"00440-8195-06 ")
 ;;83
 ;;21,"00440-8195-10 ")
 ;;84
 ;;21,"00440-8195-12 ")
 ;;85
 ;;21,"00440-8195-20 ")
 ;;86
 ;;21,"00472-1400-16 ")
 ;;87
 ;;21,"00472-1627-04 ")
 ;;88
 ;;21,"00472-1627-08 ")
 ;;89
 ;;21,"00472-1627-16 ")
 ;;90
 ;;21,"00472-1628-16 ")
 ;;91
 ;;21,"00472-1629-08 ")
 ;;92
 ;;21,"00472-1629-16 ")
 ;;93
 ;;21,"00517-4201-25 ")
 ;;94
 ;;21,"00517-5601-25 ")
 ;;95
 ;;21,"00517-5602-25 ")
 ;;96
 ;;21,"00517-5610-25 ")
 ;;97
 ;;21,"00555-0059-02 ")
 ;;98
 ;;21,"00555-0059-05 ")
 ;;99
 ;;21,"00555-0302-02 ")
 ;;100
 ;;21,"00555-0302-04 ")
 ;;101
 ;;21,"00555-0323-02 ")
 ;;102
 ;;21,"00555-0323-04 ")
 ;;103
 ;;21,"00555-0324-02 ")
 ;;104
 ;;21,"00574-1103-16 ")
 ;;105
 ;;21,"00574-1104-04 ")
 ;;106
 ;;21,"00574-1104-16 ")
 ;;107
 ;;21,"00574-7234-12 ")
 ;;108
 ;;21,"00574-7236-12 ")
 ;;109
 ;;21,"00591-0800-01 ")
 ;;110
 ;;21,"00591-0800-05 ")
 ;;111
 ;;21,"00591-0801-01 ")
 ;;112
 ;;21,"00591-0801-05 ")
 ;;113
 ;;21,"00591-2160-39 ")
 ;;114
 ;;21,"00591-2161-39 ")
 ;;115
 ;;21,"00591-2985-39 ")
 ;;116
 ;;21,"00591-2992-39 ")
 ;;117
 ;;21,"00591-5307-01 ")
 ;;118
 ;;21,"00591-5307-10 ")
 ;;119
 ;;21,"00591-5319-01 ")
 ;;120
 ;;21,"00591-5335-01 ")
 ;;121
 ;;21,"00591-5335-10 ")
 ;;122
 ;;21,"00591-5337-01 ")
 ;;123
 ;;21,"00591-5337-10 ")
 ;;124
 ;;21,"00603-1096-54 ")
 ;;125
 ;;21,"00603-1310-58 ")
 ;;126
 ;;21,"00603-1584-54 ")
 ;;127
 ;;21,"00603-1584-58 ")
 ;;128
 ;;21,"00603-1585-54 ")
 ;;129
 ;;21,"00603-1585-58 ")
 ;;130
 ;;21,"00603-1586-54 ")
 ;;131
 ;;21,"00603-1586-58 ")
 ;;132
 ;;21,"00603-1587-54 ")
 ;;133
 ;;21,"00603-1587-58 ")
 ;;134
 ;;21,"00603-1588-54 ")
 ;;135
 ;;21,"00603-1588-58 ")
 ;;136
 ;;21,"00603-2433-21 ")
 ;;137
 ;;21,"00603-2433-32 ")
 ;;138
 ;;21,"00603-2434-21 ")
 ;;139
 ;;21,"00603-2434-32 ")
 ;;140
 ;;21,"00603-2435-21 ")
 ;;141
 ;;21,"00603-2435-32 ")
 ;;142
 ;;21,"00603-3967-21 ")
 ;;143
 ;;21,"00603-3967-28 ")
 ;;144
 ;;21,"00603-3967-32 ")
 ;;145
 ;;21,"00603-3968-21 ")
 ;;146
 ;;21,"00603-3968-28 ")
 ;;147
 ;;21,"00603-3968-32 ")
 ;;148
 ;;21,"00603-3969-21 ")
 ;;149
 ;;21,"00603-3969-28 ")
 ;;150
 ;;21,"00603-5437-21 ")
 ;;151
 ;;21,"00603-5438-21 ")
 ;;152
 ;;21,"00603-5438-30 ")
 ;;153
 ;;21,"00603-5438-32 ")
 ;;154
 ;;21,"00603-5439-21 ")
 ;;155
 ;;21,"00603-6240-21 ")
 ;;156
 ;;21,"00603-6240-32 ")
 ;;157
 ;;21,"00603-6241-21 ")
 ;;158
 ;;21,"00603-6241-32 ")
 ;;159
 ;;21,"00641-0928-21 ")
 ;;160
 ;;21,"00641-0928-25 ")
 ;;161
 ;;21,"00641-0929-21 ")
 ;;162
 ;;21,"00641-0929-25 ")
 ;;163
 ;;21,"00641-0948-31 ")
 ;;164
 ;;21,"00641-0948-35 ")
 ;;165
 ;;21,"00641-0949-31 ")
 ;;166
 ;;21,"00641-0949-35 ")
 ;;167
 ;;21,"00641-0955-21 ")
 ;;168
 ;;21,"00641-0955-25 ")
 ;;169
 ;;21,"00641-0956-21 ")
 ;;170
 ;;21,"00641-0956-25 ")
 ;;171
 ;;21,"00641-1495-31 ")
 ;;172
 ;;21,"00641-1495-35 ")
 ;;173
 ;;21,"00641-1496-31 ")
 ;;174
 ;;21,"00641-1496-35 ")
 ;;175
 ;;21,"00641-6082-01 ")
 ;;176
 ;;21,"00641-6082-25 ")
 ;;177
 ;;21,"00641-6083-01 ")
 ;;178
 ;;21,"00641-6083-25 ")
 ;;179
 ;;21,"00641-6084-01 ")
 ;;180
 ;;21,"00641-6084-25 ")
 ;;181
 ;;21,"00641-6085-01 ")
 ;;182
 ;;21,"00641-6085-25 ")
 ;;183
 ;;21,"00641-6099-01 ")
 ;;184
 ;;21,"00641-6099-25 ")
 ;;185
 ;;21,"00703-2191-01 ")
 ;;186
 ;;21,"00703-2191-04 ")
 ;;187
 ;;21,"00703-2201-01 ")
 ;;188
 ;;21,"00703-2201-04 ")
 ;;189
 ;;21,"00713-0132-12 ")
 ;;190
 ;;21,"00713-0526-06 ")
 ;;191
 ;;21,"00713-0526-10 ")
 ;;192
 ;;21,"00713-0526-12 ")
 ;;193
 ;;21,"00713-0536-06 ")
 ;;194
 ;;21,"00713-0536-12 ")
 ;;195
 ;;21,"00781-1359-01 ")
 ;;196
 ;;21,"00781-1830-01 ")
 ;;197
 ;;21,"00781-1830-10 ")
 ;;198
 ;;21,"00781-1832-01 ")
 ;;199
 ;;21,"00832-1080-00 ")
 ;;200
 ;;21,"00832-1081-00 ")
 ;;201
 ;;21,"00832-1081-10 ")
 ;;202
 ;;21,"00832-1082-00 ")
 ;;203
 ;;21,"00832-1082-10 ")
 ;;204
 ;;21,"00904-0357-40 ")
 ;;205
 ;;21,"00904-0357-60 ")
 ;;206
 ;;21,"00904-0358-40 ")
 ;;207
 ;;21,"00904-0358-60 ")
 ;;208
 ;;21,"00904-0358-80 ")
 ;;209
 ;;21,"00904-0359-60 ")
 ;;210
 ;;21,"00904-1055-61 ")
 ;;211
 ;;21,"00904-1056-61 ")
 ;;212
 ;;21,"00904-1056-80 ")
 ;;213
 ;;21,"00904-1057-61 ")
 ;;214
 ;;21,"00904-1057-80 ")
 ;;215
 ;;21,"00904-5840-61 ")
 ;;216
 ;;21,"00904-6252-80 ")
 ;;217
 ;;21,"00904-6461-61 ")
 ;;218
 ;;21,"10135-0495-01 ")
 ;;219
 ;;21,"10135-0495-10 ")
 ;;220
 ;;21,"10135-0496-01 ")
 ;;221
 ;;21,"10135-0503-05 ")
 ;;222
 ;;21,"10135-0503-10 ")
 ;;223
 ;;21,"10135-0504-01 ")
 ;;224
 ;;21,"10135-0504-05 ")
 ;;225
 ;;21,"10135-0504-10 ")
 ;;226
 ;;21,"10135-0505-01 ")
 ;;227
 ;;21,"10135-0505-05 ")
 ;;228
 ;;21,"10135-0505-10 ")
 ;;229
 ;;21,"10135-0514-01 ")
 ;;230
 ;;21,"10135-0606-01 ")
 ;;231
 ;;21,"10135-0606-10 ")
 ;;232
 ;;21,"10135-0607-01 ")
 ;;233
 ;;21,"10135-0607-10 ")
 ;;234
 ;;21,"10135-0608-01 ")
 ;;235
 ;;21,"10135-0608-10 ")
 ;;236
 ;;21,"10267-1311-01 ")
 ;;237
 ;;21,"10544-0017-20 ")
 ;;238
 ;;21,"10544-0017-30 ")
 ;;239
 ;;21,"10544-0043-15 ")
 ;;240
 ;;21,"10544-0051-10 ")
 ;;241
 ;;21,"10544-0051-20 ")
 ;;242
 ;;21,"10544-0051-30 ")
 ;;243
 ;;21,"10544-0209-15 ")
 ;;244
 ;;21,"10544-0210-20 ")
 ;;245
 ;;21,"10544-0226-30 ")
 ;;246
 ;;21,"10544-0227-30 ")
 ;;247
 ;;21,"10544-0512-10 ")
 ;;248
 ;;21,"10544-0512-20 ")
 ;;249
 ;;21,"10544-0618-10 ")
 ;;250
 ;;21,"10544-0618-20 ")
 ;;251
 ;;21,"10544-0941-12 ")
 ;;252
 ;;21,"10702-0002-01 ")
 ;;253
 ;;21,"10702-0003-01 ")
 ;;254
 ;;21,"10702-0003-10 ")
 ;;255
 ;;21,"10702-0004-01 ")
 ;;256
 ;;21,"10702-0010-01 ")
 ;;257
 ;;21,"10702-0010-10 ")
 ;;258
 ;;21,"10702-0010-50 ")
 ;;259
 ;;21,"10702-0011-01 ")
 ;;260
 ;;21,"10702-0011-10 ")
 ;;261
 ;;21,"10702-0011-50 ")
 ;;262
 ;;21,"10702-0012-01 ")
 ;;263
 ;;21,"10702-0012-10 ")
 ;;264
 ;;21,"10702-0012-50 ")
 ;;265
 ;;21,"10702-0052-16 ")
 ;;266
 ;;21,"11534-0167-01 ")
 ;;267
 ;;21,"11534-0167-03 ")
 ;;268
 ;;21,"11534-0168-01 ")
 ;;269
 ;;21,"11534-0168-03 ")
 ;;270
 ;;21,"11534-0169-01 ")
 ;;271
 ;;21,"11534-0169-03 ")
 ;;272
 ;;21,"12539-0779-16 ")
 ;;273
 ;;21,"12634-0418-71 ")
 ;;274
 ;;21,"12634-0418-80 ")
 ;;275
 ;;21,"12634-0418-82 ")
 ;;276
 ;;21,"12634-0909-04 ")
 ;;277
 ;;21,"13551-0101-05 ")
 ;;278
 ;;21,"15310-0090-16 ")
 ;;279
 ;;21,"16103-0347-99 ")
 ;;280
 ;;21,"16571-0160-10 ")
 ;;281
 ;;21,"16571-0160-11 ")
 ;;282
 ;;21,"16571-0161-10 ")
 ;;283
 ;;21,"16571-0161-11 ")
 ;;284
 ;;21,"16590-0047-10 ")
 ;;285
 ;;21,"16590-0047-30 ")
 ;;286
 ;;21,"16590-0047-75 ")
 ;;287
 ;;21,"16590-0191-10 ")
 ;;288
 ;;21,"16590-0191-15 ")
 ;;289
 ;;21,"16590-0191-20 ")
 ;;290
 ;;21,"16590-0191-28 ")
 ;;291
 ;;21,"16590-0191-30 ")
 ;;292
 ;;21,"16590-0191-45 ")
 ;;293
 ;;21,"16590-0191-56 ")
 ;;294
 ;;21,"16590-0191-60 ")
 ;;295
 ;;21,"16590-0191-72 ")
 ;;296
 ;;21,"16590-0191-73 ")
 ;;297
 ;;21,"16590-0191-90 ")
 ;;298
 ;;21,"16590-0292-04 ")
 ;;299
 ;;21,"16590-0357-12 ")
 ;;300
 ;;21,"16590-0357-30 ")
 ;;301
 ;;21,"16590-0357-72 ")
 ;;302
 ;;21,"16590-0737-30 ")
 ;;303
 ;;21,"16590-0737-72 ")
 ;;304
 ;;21,"16714-0081-04 ")
 ;;305
 ;;21,"16714-0081-05 ")
 ;;306
 ;;21,"16714-0081-10 ")
 ;;307
 ;;21,"16714-0081-11 ")
 ;;308
 ;;21,"16714-0082-04 ")
 ;;309
 ;;21,"16714-0082-05 ")
 ;;310
 ;;21,"16714-0082-06 ")
 ;;311
 ;;21,"16714-0082-10 ")
 ;;312
 ;;21,"16714-0082-11 ")
 ;;313
 ;;21,"16714-0082-12 ")
 ;;314
 ;;21,"16714-0083-04 ")
 ;;315
 ;;21,"16714-0083-05 ")
 ;;316
 ;;21,"16714-0083-10 ")
 ;;317
 ;;21,"16714-0083-11 ")
 ;;318
 ;;21,"17478-0802-16 ")
 ;;319
 ;;21,"17478-0805-04 ")
 ;;320
 ;;21,"17478-0805-16 ")
 ;;321
 ;;21,"17856-0052-05 ")
 ;;322
 ;;21,"17856-0235-05 ")
 ;;323
 ;;21,"17856-0490-05 ")
 ;;324
 ;;21,"17856-0490-30 ")
 ;;325
 ;;21,"17856-0490-31 ")
 ;;326
 ;;21,"17856-0490-32 ")
 ;;327
 ;;21,"17856-0604-05 ")
 ;;328
 ;;21,"17856-0608-05 ")
 ;;329
 ;;21,"17856-0804-05 ")
 ;;330
 ;;21,"21695-0208-15 ")
 ;;331
 ;;21,"21695-0208-20 ")
 ;;332
 ;;21,"21695-0208-30 ")
 ;;333
 ;;21,"21695-0208-60 ")
 ;;334
 ;;21,"21695-0208-90 ")
 ;;335
 ;;21,"21695-0286-30 ")
 ;;336
 ;;21,"21695-0336-04 ")
 ;;337
 ;;21,"21695-0336-16 ")
 ;;338
 ;;21,"21695-0356-60 ")
 ;;339
 ;
OTHER ; OTHER ROUTINES
 D ^BGP71J10
 D ^BGP71J11
 D ^BGP71J12
 D ^BGP71J13
 D ^BGP71J14
 D ^BGP71J15
 D ^BGP71J16
 D ^BGP71J17
 D ^BGP71J18
 D ^BGP71J19
 D ^BGP71J2
 D ^BGP71J3
 D ^BGP71J4
 D ^BGP71J5
 D ^BGP71J6
 D ^BGP71J7
 D ^BGP71J8
 D ^BGP71J9
 Q