BGP9SXHB ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON MAR 25, 2009 ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"00456-4330-01 ")
 ;;262
 ;;21,"00456-4330-02 ")
 ;;263
 ;;21,"00456-4345-01 ")
 ;;366
 ;;21,"00463-9031-16 ")
 ;;386
 ;;21,"00472-0873-08 ")
 ;;12
 ;;21,"00472-1238-16 ")
 ;;42
 ;;21,"00472-1444-28 ")
 ;;381
 ;;21,"00485-0059-16 ")
 ;;87
 ;;21,"00490-0080-00 ")
 ;;109
 ;;21,"00490-0080-30 ")
 ;;110
 ;;21,"00490-0080-60 ")
 ;;111
 ;;21,"00490-0080-90 ")
 ;;112
 ;;21,"00525-0305-01 ")
 ;;54
 ;;21,"00525-0376-16 ")
 ;;53
 ;;21,"00536-4652-05 ")
 ;;305
 ;;21,"00551-0123-01 ")
 ;;65
 ;;21,"00551-0123-02 ")
 ;;66
 ;;21,"00551-0124-01 ")
 ;;83
 ;;21,"00551-0124-02 ")
 ;;84
 ;;21,"00551-0205-01 ")
 ;;79
 ;;21,"00556-0149-16 ")
 ;;387
 ;;21,"00556-0149-28 ")
 ;;388
 ;;21,"00603-1190-58 ")
 ;;43
 ;;21,"00603-5747-21 ")
 ;;370
 ;;21,"00603-5944-21 ")
 ;;124
 ;;21,"00603-5944-28 ")
 ;;125
 ;;21,"00603-5945-21 ")
 ;;200
 ;;21,"00603-5945-28 ")
 ;;201
 ;;21,"00603-5945-32 ")
 ;;202
 ;;21,"00603-5946-21 ")
 ;;306
 ;;21,"00603-5946-28 ")
 ;;307
 ;;21,"00603-5946-29 ")
 ;;308
 ;;21,"00603-5946-32 ")
 ;;309
 ;;21,"00603-5950-21 ")
 ;;146
 ;;21,"00603-5951-21 ")
 ;;152
 ;;21,"00603-5952-21 ")
 ;;250
 ;;21,"00677-0003-01 ")
 ;;6
 ;;21,"00677-0007-01 ")
 ;;17
 ;;21,"00677-0007-10 ")
 ;;18
 ;;21,"00677-0817-01 ")
 ;;282
 ;;21,"00677-0817-05 ")
 ;;310
 ;;21,"00677-0846-01 ")
 ;;180
 ;;21,"00677-0846-05 ")
 ;;203
 ;;21,"00677-1037-01 ")
 ;;68
 ;;21,"00677-1780-01 ")
 ;;71
 ;;21,"00839-1011-06 ")
 ;;19
 ;;21,"00839-1011-16 ")
 ;;20
 ;;21,"00839-5029-69 ")
 ;;382
 ;;21,"00839-5029-70 ")
 ;;383
 ;;21,"00839-5053-16 ")
 ;;7
 ;;21,"00839-6348-69 ")
 ;;91
 ;;21,"00839-6693-06 ")
 ;;311
 ;;21,"00839-6693-16 ")
 ;;312
 ;;21,"00839-6697-06 ")
 ;;89
 ;;21,"00839-6729-06 ")
 ;;204
 ;;21,"00839-6729-12 ")
 ;;205
 ;;21,"00839-6729-16 ")
 ;;206
 ;;21,"00839-6730-06 ")
 ;;126
 ;;21,"00839-6730-12 ")
 ;;127
 ;;21,"00839-7651-06 ")
 ;;371
 ;;21,"00839-7705-06 ")
 ;;128
 ;;21,"00839-7706-06 ")
 ;;207
 ;;21,"00839-7706-12 ")
 ;;208
 ;;21,"00839-7707-16 ")
 ;;313
 ;;21,"00839-7885-06 ")
 ;;97
 ;;21,"00839-7886-06 ")
 ;;147
 ;;21,"00839-7887-06 ")
 ;;153
 ;;21,"00839-7888-06 ")
 ;;251
 ;;21,"00904-1555-16 ")
 ;;45
 ;;21,"00904-1556-60 ")
 ;;32
 ;;21,"00904-1557-60 ")
 ;;38
 ;;21,"00904-1558-60 ")
 ;;69
 ;;21,"00904-1610-60 ")
 ;;138
 ;;21,"00904-1610-61 ")
 ;;139
 ;;21,"00904-1611-60 ")
 ;;236
 ;;21,"00904-1611-61 ")
 ;;237
 ;;21,"00904-1611-80 ")
 ;;209
 ;;21,"00904-1612-40 ")
 ;;341
 ;;21,"00904-1612-60 ")
 ;;342
 ;;21,"00904-1612-61 ")
 ;;343
 ;;21,"00904-2273-60 ")
 ;;8
 ;;21,"00904-2273-80 ")
 ;;9
 ;;21,"00904-2283-60 ")
 ;;21
 ;;21,"00904-2283-80 ")
 ;;22
 ;;21,"10892-0150-65 ")
 ;;24
 ;;21,"15370-0021-10 ")
 ;;55
 ;;21,"17236-0324-01 ")
 ;;210
 ;;21,"17236-0324-10 ")
 ;;211
 ;;21,"17236-0325-01 ")
 ;;314
 ;;21,"17236-0325-10 ")
 ;;315
 ;;21,"17236-0335-01 ")
 ;;106
 ;;21,"23490-7355-01 ")
 ;;316
 ;;21,"24839-0227-16 ")
 ;;49
 ;;21,"29033-0001-01 ")
 ;;355
 ;;21,"29033-0002-01 ")
 ;;373
 ;;21,"35356-0126-60 ")
 ;;181
 ;;21,"38130-0012-01 ")
 ;;64
 ;;21,"45565-0305-01 ")
 ;;57
 ;;21,"45985-0633-08 ")
 ;;80
 ;;21,"45985-0647-01 ")
 ;;76
 ;;21,"46672-0614-16 ")
 ;;39
 ;;21,"49999-0550-00 ")
 ;;23
 ;;21,"49999-0921-30 ")
 ;;113
 ;;21,"50111-0459-01 ")
 ;;283
 ;;21,"50111-0459-02 ")
 ;;284
 ;;21,"50111-0482-01 ")
 ;;182
 ;;21,"50111-0482-02 ")
 ;;183
 ;;21,"50111-0482-03 ")
 ;;184
 ;;21,"50111-0483-01 ")
 ;;114
 ;;21,"50111-0483-02 ")
 ;;115
 ;;21,"50111-0483-03 ")
 ;;116
 ;;21,"50111-0518-01 ")
 ;;368
 ;;21,"50242-0040-62 ")
 ;;92
 ;;21,"50383-0806-16 ")
 ;;44
 ;;21,"50474-0100-01 ")
 ;;142
 ;;21,"50474-0200-01 ")
 ;;242
 ;;21,"50474-0200-50 ")
 ;;243
 ;;21,"50474-0200-60 ")
 ;;244
 ;;21,"50474-0300-01 ")
 ;;347
 ;;21,"50474-0300-50 ")
 ;;348
 ;;21,"50474-0300-60 ")
 ;;349
 ;;21,"50474-0400-01 ")
 ;;354
 ;;21,"50991-0200-16 ")
 ;;81
 ;;21,"50991-0214-16 ")
 ;;51
 ;;21,"50991-0400-01 ")
 ;;59
 ;;21,"50991-0400-05 ")
 ;;60
 ;;21,"50991-0413-01 ")
 ;;78
 ;;21,"51991-0375-01 ")
 ;;72
 ;;21,"51991-0536-01 ")
 ;;77
 ;;21,"52959-0279-30 ")
 ;;154
 ;;21,"53265-0380-10 ")
 ;;356
 ;;21,"53265-0380-50 ")
 ;;357
 ;;21,"53265-0382-10 ")
 ;;374
 ;;21,"54092-0069-01 ")
 ;;255
 ;;21,"54569-0062-02 ")
 ;;276
 ;;21,"54569-0065-01 ")
 ;;317
 ;;21,"54569-0065-02 ")
 ;;318
 ;;21,"54569-0065-05 ")
 ;;319
 ;;21,"54569-0318-01 ")
 ;;105
 ;;21,"54569-1666-00 ")
 ;;350
 ;;21,"54569-1666-01 ")
 ;;351
 ;;21,"54569-4279-00 ")
 ;;58
 ;;21,"54569-8580-00 ")
 ;;277
 ;;21,"54569-8586-00 ")
 ;;174
 ;;21,"54838-0513-80 ")
 ;;40
 ;;21,"54839-0513-80 ")
 ;;41
 ;;21,"54868-0028-00 ")
 ;;212
 ;;21,"54868-0028-01 ")
 ;;213
 ;;21,"54868-0028-02 ")
 ;;214
 ;;21,"54868-0028-03 ")
 ;;215
 ;;21,"54868-0028-05 ")
 ;;216
 ;;21,"54868-0028-06 ")
 ;;217
 ;;21,"54868-0029-00 ")
 ;;320
 ;;21,"54868-0029-02 ")
 ;;321