ATXD2F4 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 17, 2015;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"S82.011C ")
 ;;1181
 ;;21,"S82.012A ")
 ;;1182
 ;;21,"S82.012B ")
 ;;1183
 ;;21,"S82.012C ")
 ;;1184
 ;;21,"S82.013A ")
 ;;1185
 ;;21,"S82.013B ")
 ;;1186
 ;;21,"S82.013C ")
 ;;1187
 ;;21,"S82.014A ")
 ;;1188
 ;;21,"S82.014B ")
 ;;1189
 ;;21,"S82.014C ")
 ;;1190
 ;;21,"S82.015A ")
 ;;1191
 ;;21,"S82.015B ")
 ;;1192
 ;;21,"S82.015C ")
 ;;1193
 ;;21,"S82.016A ")
 ;;1194
 ;;21,"S82.016B ")
 ;;1195
 ;;21,"S82.016C ")
 ;;1196
 ;;21,"S82.021A ")
 ;;1197
 ;;21,"S82.021B ")
 ;;1198
 ;;21,"S82.021C ")
 ;;1199
 ;;21,"S82.022A ")
 ;;1200
 ;;21,"S82.022B ")
 ;;1201
 ;;21,"S82.022C ")
 ;;1202
 ;;21,"S82.023A ")
 ;;1203
 ;;21,"S82.023B ")
 ;;1204
 ;;21,"S82.023C ")
 ;;1205
 ;;21,"S82.024A ")
 ;;1206
 ;;21,"S82.024B ")
 ;;1207
 ;;21,"S82.024C ")
 ;;1208
 ;;21,"S82.025A ")
 ;;1209
 ;;21,"S82.025B ")
 ;;1210
 ;;21,"S82.025C ")
 ;;1211
 ;;21,"S82.026A ")
 ;;1212
 ;;21,"S82.026B ")
 ;;1213
 ;;21,"S82.026C ")
 ;;1214
 ;;21,"S82.031A ")
 ;;1215
 ;;21,"S82.031B ")
 ;;1216
 ;;21,"S82.031C ")
 ;;1217
 ;;21,"S82.032A ")
 ;;1218
 ;;21,"S82.032B ")
 ;;1219
 ;;21,"S82.032C ")
 ;;1220
 ;;21,"S82.033A ")
 ;;1221
 ;;21,"S82.033B ")
 ;;1222
 ;;21,"S82.033C ")
 ;;1223
 ;;21,"S82.034A ")
 ;;1224
 ;;21,"S82.034B ")
 ;;1225
 ;;21,"S82.034C ")
 ;;1226
 ;;21,"S82.035A ")
 ;;1227
 ;;21,"S82.035B ")
 ;;1228
 ;;21,"S82.035C ")
 ;;1229
 ;;21,"S82.036A ")
 ;;1230
 ;;21,"S82.036B ")
 ;;1231
 ;;21,"S82.036C ")
 ;;1232
 ;;21,"S82.041A ")
 ;;1233
 ;;21,"S82.041B ")
 ;;1234
 ;;21,"S82.041C ")
 ;;1235
 ;;21,"S82.042A ")
 ;;1236
 ;;21,"S82.042B ")
 ;;1237
 ;;21,"S82.042C ")
 ;;1238
 ;;21,"S82.043A ")
 ;;1239
 ;;21,"S82.043B ")
 ;;1240
 ;;21,"S82.043C ")
 ;;1241
 ;;21,"S82.044A ")
 ;;1242
 ;;21,"S82.044B ")
 ;;1243
 ;;21,"S82.044C ")
 ;;1244
 ;;21,"S82.045A ")
 ;;1245
 ;;21,"S82.045B ")
 ;;1246
 ;;21,"S82.045C ")
 ;;1247
 ;;21,"S82.046A ")
 ;;1248
 ;;21,"S82.046B ")
 ;;1249
 ;;21,"S82.046C ")
 ;;1250
 ;;21,"S82.091A ")
 ;;1251
 ;;21,"S82.091B ")
 ;;1252
 ;;21,"S82.091C ")
 ;;1253
 ;;21,"S82.092A ")
 ;;1254
 ;;21,"S82.092B ")
 ;;1255
 ;;21,"S82.092C ")
 ;;1256
 ;;21,"S82.099A ")
 ;;1257
 ;;21,"S82.099B ")
 ;;1258
 ;;21,"S82.099C ")
 ;;1259
 ;;21,"S82.101A ")
 ;;1260
 ;;21,"S82.101B ")
 ;;1261
 ;;21,"S82.101C ")
 ;;1262
 ;;21,"S82.102A ")
 ;;1263
 ;;21,"S82.102B ")
 ;;1264
 ;;21,"S82.102C ")
 ;;1265
 ;;21,"S82.109A ")
 ;;1266
 ;;21,"S82.109B ")
 ;;1267
 ;;21,"S82.109C ")
 ;;1268
 ;;21,"S82.111A ")
 ;;1269
 ;;21,"S82.111B ")
 ;;1270
 ;;21,"S82.111C ")
 ;;1271
 ;;21,"S82.112A ")
 ;;1272
 ;;21,"S82.112B ")
 ;;1273
 ;;21,"S82.112C ")
 ;;1274
 ;;21,"S82.113A ")
 ;;1275
 ;;21,"S82.113B ")
 ;;1276
 ;;21,"S82.113C ")
 ;;1277
 ;;21,"S82.114A ")
 ;;1278
 ;;21,"S82.114B ")
 ;;1279
 ;;21,"S82.114C ")
 ;;1280
 ;;21,"S82.115A ")
 ;;1281
 ;;21,"S82.115B ")
 ;;1282
 ;;21,"S82.115C ")
 ;;1283
 ;;21,"S82.116A ")
 ;;1284
 ;;21,"S82.116B ")
 ;;1285
 ;;21,"S82.116C ")
 ;;1286
 ;;21,"S82.121A ")
 ;;1287
 ;;21,"S82.121B ")
 ;;1288
 ;;21,"S82.121C ")
 ;;1289
 ;;21,"S82.122A ")
 ;;1290
 ;;21,"S82.122B ")
 ;;1291
 ;;21,"S82.122C ")
 ;;1292
 ;;21,"S82.123A ")
 ;;1293
 ;;21,"S82.123B ")
 ;;1294
 ;;21,"S82.123C ")
 ;;1295
 ;;21,"S82.124A ")
 ;;1296
 ;;21,"S82.124B ")
 ;;1297
 ;;21,"S82.124C ")
 ;;1298
 ;;21,"S82.125A ")
 ;;1299
 ;;21,"S82.125B ")
 ;;1300
 ;;21,"S82.125C ")
 ;;1301
 ;;21,"S82.126A ")
 ;;1302
 ;;21,"S82.126B ")
 ;;1303
 ;;21,"S82.126C ")
 ;;1304
 ;;21,"S82.131A ")
 ;;1305
 ;;21,"S82.131B ")
 ;;1306
 ;;21,"S82.131C ")
 ;;1307
 ;;21,"S82.132A ")
 ;;1308
 ;;21,"S82.132B ")
 ;;1309
 ;;21,"S82.132C ")
 ;;1310
 ;;21,"S82.133A ")
 ;;1311
 ;;21,"S82.133B ")
 ;;1312
 ;;21,"S82.133C ")
 ;;1313
 ;;21,"S82.134A ")
 ;;1314
 ;;21,"S82.134B ")
 ;;1315
 ;;21,"S82.134C ")
 ;;1316
 ;;21,"S82.135A ")
 ;;1317
 ;;21,"S82.135B ")
 ;;1318
 ;;21,"S82.135C ")
 ;;1319
 ;;21,"S82.136A ")
 ;;1320
 ;;21,"S82.136B ")
 ;;1321
 ;;21,"S82.136C ")
 ;;1322
 ;;21,"S82.141A ")
 ;;1323
 ;;21,"S82.141B ")
 ;;1324
 ;;21,"S82.141C ")
 ;;1325
 ;;21,"S82.142A ")
 ;;1326
 ;;21,"S82.142B ")
 ;;1327
 ;;21,"S82.142C ")
 ;;1328
 ;;21,"S82.143A ")
 ;;1329
 ;;21,"S82.143B ")
 ;;1330
 ;;21,"S82.143C ")
 ;;1331
 ;;21,"S82.144A ")
 ;;1332
 ;;21,"S82.144B ")
 ;;1333
 ;;21,"S82.144C ")
 ;;1334
 ;;21,"S82.145A ")
 ;;1335
 ;;21,"S82.145B ")
 ;;1336
 ;;21,"S82.145C ")
 ;;1337
 ;;21,"S82.146A ")
 ;;1338
 ;;21,"S82.146B ")
 ;;1339
 ;;21,"S82.146C ")
 ;;1340
 ;;21,"S82.151A ")
 ;;1341
 ;;21,"S82.151B ")
 ;;1342
 ;;21,"S82.151C ")
 ;;1343
 ;;21,"S82.152A ")
 ;;1344
 ;;21,"S82.152B ")
 ;;1345
 ;;21,"S82.152C ")
 ;;1346
 ;;21,"S82.153A ")
 ;;1347
 ;;21,"S82.153B ")
 ;;1348
 ;;21,"S82.153C ")
 ;;1349
 ;;21,"S82.154A ")
 ;;1350
 ;;21,"S82.154B ")
 ;;1351
 ;;21,"S82.154C ")
 ;;1352
 ;;21,"S82.155A ")
 ;;1353
 ;;21,"S82.155B ")
 ;;1354
 ;;21,"S82.155C ")
 ;;1355
 ;;21,"S82.156A ")
 ;;1356
 ;;21,"S82.156B ")
 ;;1357
 ;;21,"S82.156C ")
 ;;1358
 ;;21,"S82.161A ")
 ;;1359
 ;;21,"S82.162A ")
 ;;1360
 ;;21,"S82.169A ")
 ;;1361
 ;;21,"S82.191A ")
 ;;1362
 ;;21,"S82.191B ")
 ;;1363
 ;;21,"S82.191C ")
 ;;1364
 ;;21,"S82.192A ")
 ;;1365
 ;;21,"S82.192B ")
 ;;1366
 ;;21,"S82.192C ")
 ;;1367
 ;;21,"S82.199A ")
 ;;1368
 ;;21,"S82.199B ")
 ;;1369
 ;;21,"S82.199C ")
 ;;1370
 ;;21,"S82.201A ")
 ;;1371
 ;;21,"S82.201B ")
 ;;1372
 ;;21,"S82.201C ")
 ;;1373
 ;;21,"S82.202A ")
 ;;1374
 ;;21,"S82.202B ")
 ;;1375
 ;;21,"S82.202C ")
 ;;1376
 ;;21,"S82.209A ")
 ;;1377
 ;;21,"S82.209B ")
 ;;1378
 ;;21,"S82.209C ")
 ;;1379
 ;;21,"S82.221A ")
 ;;1380
 ;;21,"S82.221B ")
 ;;1381
 ;;21,"S82.221C ")
 ;;1382
 ;;21,"S82.222A ")
 ;;1383
 ;;21,"S82.222B ")
 ;;1384
 ;;21,"S82.222C ")
 ;;1385
 ;;21,"S82.223A ")
 ;;1386
 ;;21,"S82.223B ")
 ;;1387
 ;;21,"S82.223C ")
 ;;1388
 ;;21,"S82.224A ")
 ;;1389
 ;;21,"S82.224B ")
 ;;1390
 ;;21,"S82.224C ")
 ;;1391
 ;;21,"S82.225A ")
 ;;1392
 ;;21,"S82.225B ")
 ;;1393
 ;;21,"S82.225C ")
 ;;1394
 ;;21,"S82.226A ")
 ;;1395
 ;;21,"S82.226B ")
 ;;1396
 ;;21,"S82.226C ")
 ;;1397
 ;;21,"S82.231A ")
 ;;1398
 ;;21,"S82.231B ")
 ;;1399
 ;;21,"S82.231C ")
 ;;1400
 ;;21,"S82.232A ")
 ;;1401
 ;;21,"S82.232B ")
 ;;1402
 ;;21,"S82.232C ")
 ;;1403
 ;;21,"S82.233A ")
 ;;1404
 ;;21,"S82.233B ")
 ;;1405
 ;;21,"S82.233C ")
 ;;1406
 ;;21,"S82.234A ")
 ;;1407
 ;;21,"S82.234B ")
 ;;1408
 ;;21,"S82.234C ")
 ;;1409
 ;;21,"S82.235A ")
 ;;1410
 ;;21,"S82.235B ")
 ;;1411
 ;;21,"S82.235C ")
 ;;1412
 ;;21,"S82.236A ")
 ;;1413
 ;;21,"S82.236B ")
 ;;1414
 ;;21,"S82.236C ")
 ;;1415
 ;;21,"S82.241A ")
 ;;1416
 ;;21,"S82.241B ")
 ;;1417
 ;;21,"S82.241C ")
 ;;1418
 ;;21,"S82.242A ")
 ;;1419
 ;;21,"S82.242B ")
 ;;1420
 ;;21,"S82.242C ")
 ;;1421
 ;;21,"S82.243A ")
 ;;1422
 ;;21,"S82.243B ")
 ;;1423
 ;;21,"S82.243C ")
 ;;1424
 ;;21,"S82.244A ")
 ;;1425
 ;;21,"S82.244B ")
 ;;1426
 ;;21,"S82.244C ")
 ;;1427
 ;;21,"S82.245A ")
 ;;1428
 ;;21,"S82.245B ")
 ;;1429
 ;;21,"S82.245C ")
 ;;1430
 ;;21,"S82.246A ")
 ;;1431
 ;;21,"S82.246B ")
 ;;1432
 ;;21,"S82.246C ")
 ;;1433
 ;;21,"S82.251A ")
 ;;1434
 ;;21,"S82.251B ")
 ;;1435
 ;;21,"S82.251C ")
 ;;1436
 ;;21,"S82.252A ")
 ;;1437
 ;;21,"S82.252B ")
 ;;1438
 ;;21,"S82.252C ")
 ;;1439
 ;;21,"S82.253A ")
 ;;1440
 ;;21,"S82.253B ")
 ;;1441
 ;;21,"S82.253C ")
 ;;1442
 ;;21,"S82.254A ")
 ;;1443
 ;;21,"S82.254B ")
 ;;1444
 ;;21,"S82.254C ")
 ;;1445
 ;;21,"S82.255A ")
 ;;1446
 ;;21,"S82.255B ")
 ;;1447
 ;;21,"S82.255C ")
 ;;1448
 ;;21,"S82.256A ")
 ;;1449
 ;;21,"S82.256B ")
 ;;1450
 ;;21,"S82.256C ")
 ;;1451
 ;;21,"S82.261A ")
 ;;1452
 ;;21,"S82.261B ")
 ;;1453
 ;;21,"S82.261C ")
 ;;1454
 ;;21,"S82.262A ")
 ;;1455
 ;;21,"S82.262B ")
 ;;1456
 ;;21,"S82.262C ")
 ;;1457
 ;;21,"S82.263A ")
 ;;1458
 ;;21,"S82.263B ")
 ;;1459
 ;;21,"S82.263C ")
 ;;1460
 ;;21,"S82.264A ")
 ;;1461
 ;;21,"S82.264B ")
 ;;1462
 ;;21,"S82.264C ")
 ;;1463
 ;;21,"S82.265A ")
 ;;1464
 ;;21,"S82.265B ")
 ;;1465
 ;;21,"S82.265C ")
 ;;1466
 ;;21,"S82.266A ")
 ;;1467
 ;;21,"S82.266B ")
 ;;1468
 ;;21,"S82.266C ")
 ;;1469
 ;;21,"S82.291A ")
 ;;1470
 ;;21,"S82.291B ")
 ;;1471
 ;;21,"S82.291C ")
 ;;1472
 ;;21,"S82.292A ")
 ;;1473
 ;;21,"S82.292B ")
 ;;1474
 ;;21,"S82.292C ")
 ;;1475
 ;;21,"S82.299A ")
 ;;1476
 ;;21,"S82.299B ")
 ;;1477
 ;;21,"S82.299C ")
 ;;1478
 ;;21,"S82.301A ")
 ;;1479
 ;;21,"S82.301B ")
 ;;1480
 ;;21,"S82.301C ")
 ;;1481
 ;;21,"S82.302A ")
 ;;1482
 ;;21,"S82.302B ")
 ;;1483
 ;;21,"S82.302C ")
 ;;1484
 ;;21,"S82.309A ")
 ;;1485
 ;;21,"S82.309B ")
 ;;1486
 ;;21,"S82.309C ")
 ;;1487
 ;;21,"S82.311A ")
 ;;1488
 ;;21,"S82.312A ")
 ;;1489
 ;;21,"S82.319A ")
 ;;1490
 ;;21,"S82.391A ")
 ;;1491
 ;;21,"S82.391B ")
 ;;1492
 ;;21,"S82.391C ")
 ;;1493
 ;;21,"S82.392A ")
 ;;1494
 ;;21,"S82.392B ")
 ;;1495
 ;;21,"S82.392C ")
 ;;1496
 ;;21,"S82.399A ")
 ;;1497
 ;;21,"S82.399B ")
 ;;1498
 ;;21,"S82.399C ")
 ;;1499
 ;;21,"S82.401A ")
 ;;1500
 ;;21,"S82.401B ")
 ;;1501
 ;;21,"S82.401C ")
 ;;1502
 ;;21,"S82.402A ")
 ;;1503
 ;;21,"S82.402B ")
 ;;1504
 ;;21,"S82.402C ")
 ;;1505
 ;;21,"S82.409A ")
 ;;1506
 ;;21,"S82.409B ")
 ;;1507
 ;;21,"S82.409C ")
 ;;1508
 ;;21,"S82.421A ")
 ;;1509
 ;;21,"S82.421B ")
 ;;1510
 ;;21,"S82.421C ")
 ;;1511
 ;;21,"S82.422A ")
 ;;1512
 ;;21,"S82.422B ")
 ;;1513
 ;;21,"S82.422C ")
 ;;1514
 ;;21,"S82.423A ")
 ;;1515
 ;;21,"S82.423B ")
 ;;1516
 ;;21,"S82.423C ")
 ;;1517
 ;;21,"S82.424A ")
 ;;1518
 ;;21,"S82.424B ")
 ;;1519
 ;;21,"S82.424C ")
 ;;1520
 ;;21,"S82.425A ")
 ;;1521
 ;;21,"S82.425B ")
 ;;1522
 ;;21,"S82.425C ")
 ;;1523
 ;;21,"S82.426A ")
 ;;1524
 ;;21,"S82.426B ")
 ;;1525
 ;;21,"S82.426C ")
 ;;1526
 ;;21,"S82.431A ")
 ;;1527
 ;;21,"S82.431B ")
 ;;1528
 ;;21,"S82.431C ")
 ;;1529
 ;;21,"S82.432A ")
 ;;1530
 ;;21,"S82.432B ")
 ;;1531
 ;;21,"S82.432C ")
 ;;1532
 ;;21,"S82.433A ")
 ;;1533
 ;;21,"S82.433B ")
 ;;1534
 ;;21,"S82.433C ")
 ;;1535
 ;;21,"S82.434A ")
 ;;1536
 ;;21,"S82.434B ")
 ;;1537
 ;;21,"S82.434C ")
 ;;1538
 ;;21,"S82.435A ")
 ;;1539
 ;;21,"S82.435B ")
 ;;1540
 ;;21,"S82.435C ")
 ;;1541
 ;;21,"S82.436A ")
 ;;1542
 ;;21,"S82.436B ")
 ;;1543
 ;;21,"S82.436C ")
 ;;1544
 ;;21,"S82.441A ")
 ;;1545
 ;;21,"S82.441B ")
 ;;1546
 ;;21,"S82.441C ")
 ;;1547
 ;;21,"S82.442A ")
 ;;1548
 ;;21,"S82.442B ")
 ;;1549
 ;;21,"S82.442C ")
 ;;1550
 ;;21,"S82.443A ")
 ;;1551
 ;;21,"S82.443B ")
 ;;1552
 ;;21,"S82.443C ")
 ;;1553
 ;;21,"S82.444A ")
 ;;1554
 ;;21,"S82.444B ")
 ;;1555
 ;;21,"S82.444C ")
 ;;1556
 ;;21,"S82.445A ")
 ;;1557
 ;;21,"S82.445B ")
 ;;1558
 ;;21,"S82.445C ")
 ;;1559
 ;;21,"S82.446A ")
 ;;1560
 ;;21,"S82.446B ")
 ;;1561
 ;;21,"S82.446C ")
 ;;1562
 ;;21,"S82.451A ")
 ;;1563
 ;;21,"S82.451B ")
 ;;1564