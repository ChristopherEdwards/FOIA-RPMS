BGP2VK4 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 08, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"723,00078-0609-05 ",.01)
 ;;00078-0609-05
 ;;9002226.02101,"723,00078-0609-05 ",.02)
 ;;00078-0609-05
 ;;9002226.02101,"723,00083-0003-30 ",.01)
 ;;00083-0003-30
 ;;9002226.02101,"723,00083-0003-30 ",.02)
 ;;00083-0003-30
 ;;9002226.02101,"723,00083-0007-30 ",.01)
 ;;00083-0007-30
 ;;9002226.02101,"723,00083-0007-30 ",.02)
 ;;00083-0007-30
 ;;9002226.02101,"723,00083-0034-30 ",.01)
 ;;00083-0034-30
 ;;9002226.02101,"723,00083-0034-30 ",.02)
 ;;00083-0034-30
 ;;9002226.02101,"723,00093-2109-01 ",.01)
 ;;00093-2109-01
 ;;9002226.02101,"723,00093-2109-01 ",.02)
 ;;00093-2109-01
 ;;9002226.02101,"723,00093-2110-01 ",.01)
 ;;00093-2110-01
 ;;9002226.02101,"723,00093-2110-01 ",.02)
 ;;00093-2110-01
 ;;9002226.02101,"723,00093-5275-01 ",.01)
 ;;00093-5275-01
 ;;9002226.02101,"723,00093-5275-01 ",.02)
 ;;00093-5275-01
 ;;9002226.02101,"723,00093-5276-01 ",.01)
 ;;00093-5276-01
 ;;9002226.02101,"723,00093-5276-01 ",.02)
 ;;00093-5276-01
 ;;9002226.02101,"723,00093-5277-01 ",.01)
 ;;00093-5277-01
 ;;9002226.02101,"723,00093-5277-01 ",.02)
 ;;00093-5277-01
 ;;9002226.02101,"723,00115-1205-01 ",.01)
 ;;00115-1205-01
 ;;9002226.02101,"723,00115-1205-01 ",.02)
 ;;00115-1205-01
 ;;9002226.02101,"723,00115-1328-01 ",.01)
 ;;00115-1328-01
 ;;9002226.02101,"723,00115-1328-01 ",.02)
 ;;00115-1328-01
 ;;9002226.02101,"723,00115-1329-01 ",.01)
 ;;00115-1329-01
 ;;9002226.02101,"723,00115-1329-01 ",.02)
 ;;00115-1329-01
 ;;9002226.02101,"723,00115-1330-01 ",.01)
 ;;00115-1330-01
 ;;9002226.02101,"723,00115-1330-01 ",.02)
 ;;00115-1330-01
 ;;9002226.02101,"723,00115-1331-01 ",.01)
 ;;00115-1331-01
 ;;9002226.02101,"723,00115-1331-01 ",.02)
 ;;00115-1331-01
 ;;9002226.02101,"723,00115-1332-01 ",.01)
 ;;00115-1332-01
 ;;9002226.02101,"723,00115-1332-01 ",.02)
 ;;00115-1332-01
 ;;9002226.02101,"723,00115-1333-01 ",.01)
 ;;00115-1333-01
 ;;9002226.02101,"723,00115-1333-01 ",.02)
 ;;00115-1333-01
 ;;9002226.02101,"723,00147-0102-20 ",.01)
 ;;00147-0102-20
 ;;9002226.02101,"723,00147-0102-20 ",.02)
 ;;00147-0102-20
 ;;9002226.02101,"723,00147-0109-10 ",.01)
 ;;00147-0109-10
 ;;9002226.02101,"723,00147-0109-10 ",.02)
 ;;00147-0109-10
 ;;9002226.02101,"723,00147-0109-20 ",.01)
 ;;00147-0109-20
 ;;9002226.02101,"723,00147-0109-20 ",.02)
 ;;00147-0109-20
 ;;9002226.02101,"723,00147-0135-20 ",.01)
 ;;00147-0135-20
 ;;9002226.02101,"723,00147-0135-20 ",.02)
 ;;00147-0135-20
 ;;9002226.02101,"723,00147-0136-10 ",.01)
 ;;00147-0136-10
 ;;9002226.02101,"723,00147-0136-10 ",.02)
 ;;00147-0136-10
 ;;9002226.02101,"723,00147-0136-20 ",.01)
 ;;00147-0136-20
 ;;9002226.02101,"723,00147-0136-20 ",.02)
 ;;00147-0136-20
 ;;9002226.02101,"723,00147-0198-10 ",.01)
 ;;00147-0198-10
 ;;9002226.02101,"723,00147-0198-10 ",.02)
 ;;00147-0198-10
 ;;9002226.02101,"723,00147-0198-20 ",.01)
 ;;00147-0198-20
 ;;9002226.02101,"723,00147-0198-20 ",.02)
 ;;00147-0198-20
 ;;9002226.02101,"723,00147-0201-10 ",.01)
 ;;00147-0201-10
 ;;9002226.02101,"723,00147-0201-10 ",.02)
 ;;00147-0201-10
 ;;9002226.02101,"723,00147-0201-20 ",.01)
 ;;00147-0201-20
 ;;9002226.02101,"723,00147-0201-20 ",.02)
 ;;00147-0201-20
 ;;9002226.02101,"723,00147-0202-10 ",.01)
 ;;00147-0202-10
 ;;9002226.02101,"723,00147-0202-10 ",.02)
 ;;00147-0202-10
 ;;9002226.02101,"723,00147-0202-20 ",.01)
 ;;00147-0202-20
 ;;9002226.02101,"723,00147-0202-20 ",.02)
 ;;00147-0202-20
 ;;9002226.02101,"723,00147-0231-10 ",.01)
 ;;00147-0231-10
 ;;9002226.02101,"723,00147-0231-10 ",.02)
 ;;00147-0231-10
 ;;9002226.02101,"723,00147-0231-20 ",.01)
 ;;00147-0231-20
 ;;9002226.02101,"723,00147-0231-20 ",.02)
 ;;00147-0231-20
 ;;9002226.02101,"723,00147-0232-10 ",.01)
 ;;00147-0232-10
 ;;9002226.02101,"723,00147-0232-10 ",.02)
 ;;00147-0232-10
 ;;9002226.02101,"723,00147-0232-20 ",.01)
 ;;00147-0232-20
 ;;9002226.02101,"723,00147-0232-20 ",.02)
 ;;00147-0232-20
 ;;9002226.02101,"723,00147-0234-10 ",.01)
 ;;00147-0234-10
 ;;9002226.02101,"723,00147-0234-10 ",.02)
 ;;00147-0234-10
 ;;9002226.02101,"723,00147-0234-20 ",.01)
 ;;00147-0234-20
 ;;9002226.02101,"723,00147-0234-20 ",.02)
 ;;00147-0234-20
 ;;9002226.02101,"723,00147-0235-10 ",.01)
 ;;00147-0235-10
 ;;9002226.02101,"723,00147-0235-10 ",.02)
 ;;00147-0235-10
 ;;9002226.02101,"723,00147-0235-20 ",.01)
 ;;00147-0235-20
 ;;9002226.02101,"723,00147-0235-20 ",.02)
 ;;00147-0235-20
 ;;9002226.02101,"723,00147-0237-10 ",.01)
 ;;00147-0237-10
 ;;9002226.02101,"723,00147-0237-10 ",.02)
 ;;00147-0237-10
 ;;9002226.02101,"723,00147-0237-20 ",.01)
 ;;00147-0237-20
 ;;9002226.02101,"723,00147-0237-20 ",.02)
 ;;00147-0237-20
 ;;9002226.02101,"723,00147-0248-10 ",.01)
 ;;00147-0248-10
 ;;9002226.02101,"723,00147-0248-10 ",.02)
 ;;00147-0248-10
 ;;9002226.02101,"723,00147-0248-20 ",.01)
 ;;00147-0248-20
 ;;9002226.02101,"723,00147-0248-20 ",.02)
 ;;00147-0248-20
 ;;9002226.02101,"723,00147-0249-10 ",.01)
 ;;00147-0249-10
 ;;9002226.02101,"723,00147-0249-10 ",.02)
 ;;00147-0249-10
 ;;9002226.02101,"723,00147-0249-20 ",.01)
 ;;00147-0249-20
 ;;9002226.02101,"723,00147-0249-20 ",.02)
 ;;00147-0249-20
 ;;9002226.02101,"723,00147-0251-10 ",.01)
 ;;00147-0251-10
 ;;9002226.02101,"723,00147-0251-10 ",.02)
 ;;00147-0251-10
 ;;9002226.02101,"723,00147-0251-20 ",.01)
 ;;00147-0251-20
 ;;9002226.02101,"723,00147-0251-20 ",.02)
 ;;00147-0251-20
 ;;9002226.02101,"723,00147-0253-10 ",.01)
 ;;00147-0253-10
 ;;9002226.02101,"723,00147-0253-10 ",.02)
 ;;00147-0253-10
 ;;9002226.02101,"723,00147-0253-20 ",.01)
 ;;00147-0253-20
 ;;9002226.02101,"723,00147-0253-20 ",.02)
 ;;00147-0253-20
 ;;9002226.02101,"723,00147-0254-10 ",.01)
 ;;00147-0254-10
 ;;9002226.02101,"723,00147-0254-10 ",.02)
 ;;00147-0254-10
 ;;9002226.02101,"723,00147-0254-20 ",.01)
 ;;00147-0254-20
 ;;9002226.02101,"723,00147-0254-20 ",.02)
 ;;00147-0254-20
 ;;9002226.02101,"723,00182-0205-01 ",.01)
 ;;00182-0205-01
 ;;9002226.02101,"723,00182-0205-01 ",.02)
 ;;00182-0205-01
 ;;9002226.02101,"723,00182-0205-10 ",.01)
 ;;00182-0205-10
 ;;9002226.02101,"723,00182-0205-10 ",.02)
 ;;00182-0205-10
 ;;9002226.02101,"723,00182-0870-01 ",.01)
 ;;00182-0870-01
 ;;9002226.02101,"723,00182-0870-01 ",.02)
 ;;00182-0870-01
 ;;9002226.02101,"723,00182-0870-02 ",.01)
 ;;00182-0870-02
 ;;9002226.02101,"723,00182-0870-02 ",.02)
 ;;00182-0870-02
 ;;9002226.02101,"723,00182-1066-01 ",.01)
 ;;00182-1066-01
 ;;9002226.02101,"723,00182-1066-01 ",.02)
 ;;00182-1066-01
 ;;9002226.02101,"723,00182-1066-10 ",.01)
 ;;00182-1066-10
 ;;9002226.02101,"723,00182-1066-10 ",.02)
 ;;00182-1066-10
 ;;9002226.02101,"723,00182-1173-01 ",.01)
 ;;00182-1173-01
 ;;9002226.02101,"723,00182-1173-01 ",.02)
 ;;00182-1173-01
 ;;9002226.02101,"723,00182-1173-10 ",.01)
 ;;00182-1173-10
 ;;9002226.02101,"723,00182-1173-10 ",.02)
 ;;00182-1173-10
 ;;9002226.02101,"723,00182-1174-01 ",.01)
 ;;00182-1174-01
 ;;9002226.02101,"723,00182-1174-01 ",.02)
 ;;00182-1174-01
 ;;9002226.02101,"723,00182-1436-01 ",.01)
 ;;00182-1436-01
 ;;9002226.02101,"723,00182-1436-01 ",.02)
 ;;00182-1436-01
 ;;9002226.02101,"723,00182-9147-01 ",.01)
 ;;00182-9147-01
 ;;9002226.02101,"723,00182-9147-01 ",.02)
 ;;00182-9147-01
 ;;9002226.02101,"723,00185-0084-01 ",.01)
 ;;00185-0084-01
 ;;9002226.02101,"723,00185-0084-01 ",.02)
 ;;00185-0084-01
 ;;9002226.02101,"723,00185-0111-01 ",.01)
 ;;00185-0111-01
 ;;9002226.02101,"723,00185-0111-01 ",.02)
 ;;00185-0111-01
 ;;9002226.02101,"723,00185-0401-01 ",.01)
 ;;00185-0401-01
 ;;9002226.02101,"723,00185-0401-01 ",.02)
 ;;00185-0401-01
 ;;9002226.02101,"723,00185-0404-01 ",.01)
 ;;00185-0404-01
 ;;9002226.02101,"723,00185-0404-01 ",.02)
 ;;00185-0404-01
 ;;9002226.02101,"723,00185-0644-01 ",.01)
 ;;00185-0644-01
 ;;9002226.02101,"723,00185-0644-01 ",.02)
 ;;00185-0644-01
 ;;9002226.02101,"723,00185-0644-10 ",.01)
 ;;00185-0644-10
 ;;9002226.02101,"723,00185-0644-10 ",.02)
 ;;00185-0644-10
 ;;9002226.02101,"723,00185-0647-01 ",.01)
 ;;00185-0647-01
 ;;9002226.02101,"723,00185-0647-01 ",.02)
 ;;00185-0647-01
 ;;9002226.02101,"723,00185-0647-10 ",.01)
 ;;00185-0647-10
 ;;9002226.02101,"723,00185-0647-10 ",.02)
 ;;00185-0647-10
 ;;9002226.02101,"723,00185-4057-01 ",.01)
 ;;00185-4057-01
 ;;9002226.02101,"723,00185-4057-01 ",.02)
 ;;00185-4057-01
 ;;9002226.02101,"723,00185-4057-10 ",.01)
 ;;00185-4057-10
 ;;9002226.02101,"723,00185-4057-10 ",.02)
 ;;00185-4057-10
 ;;9002226.02101,"723,00185-5000-01 ",.01)
 ;;00185-5000-01
 ;;9002226.02101,"723,00185-5000-01 ",.02)
 ;;00185-5000-01
 ;;9002226.02101,"723,00185-5000-10 ",.01)
 ;;00185-5000-10
 ;;9002226.02101,"723,00185-5000-10 ",.02)
 ;;00185-5000-10
 ;;9002226.02101,"723,00185-5254-01 ",.01)
 ;;00185-5254-01
 ;;9002226.02101,"723,00185-5254-01 ",.02)
 ;;00185-5254-01
 ;;9002226.02101,"723,00185-5254-10 ",.01)
 ;;00185-5254-10
 ;;9002226.02101,"723,00185-5254-10 ",.02)
 ;;00185-5254-10
 ;;9002226.02101,"723,00187-0497-01 ",.01)
 ;;00187-0497-01
 ;;9002226.02101,"723,00187-0497-01 ",.02)
 ;;00187-0497-01
 ;;9002226.02101,"723,00187-0497-02 ",.01)
 ;;00187-0497-02
 ;;9002226.02101,"723,00187-0497-02 ",.02)
 ;;00187-0497-02
 ;;9002226.02101,"723,00187-0498-01 ",.01)
 ;;00187-0498-01
 ;;9002226.02101,"723,00187-0498-01 ",.02)
 ;;00187-0498-01
 ;;9002226.02101,"723,00187-0498-02 ",.01)
 ;;00187-0498-02
 ;;9002226.02101,"723,00187-0498-02 ",.02)
 ;;00187-0498-02
 ;;9002226.02101,"723,00228-3016-11 ",.01)
 ;;00228-3016-11
 ;;9002226.02101,"723,00228-3016-11 ",.02)
 ;;00228-3016-11
 ;;9002226.02101,"723,00247-0625-00 ",.01)
 ;;00247-0625-00
 ;;9002226.02101,"723,00247-0625-00 ",.02)
 ;;00247-0625-00
 ;;9002226.02101,"723,00247-0625-07 ",.01)
 ;;00247-0625-07
 ;;9002226.02101,"723,00247-0625-07 ",.02)
 ;;00247-0625-07
 ;;9002226.02101,"723,00247-0625-14 ",.01)
 ;;00247-0625-14
 ;;9002226.02101,"723,00247-0625-14 ",.02)
 ;;00247-0625-14
 ;;9002226.02101,"723,00247-0625-15 ",.01)
 ;;00247-0625-15
 ;;9002226.02101,"723,00247-0625-15 ",.02)
 ;;00247-0625-15
 ;;9002226.02101,"723,00247-0625-28 ",.01)
 ;;00247-0625-28
 ;;9002226.02101,"723,00247-0625-28 ",.02)
 ;;00247-0625-28
 ;;9002226.02101,"723,00247-0625-30 ",.01)
 ;;00247-0625-30
 ;;9002226.02101,"723,00247-0625-30 ",.02)
 ;;00247-0625-30
 ;;9002226.02101,"723,00247-0625-33 ",.01)
 ;;00247-0625-33
 ;;9002226.02101,"723,00247-0625-33 ",.02)
 ;;00247-0625-33
 ;;9002226.02101,"723,00247-0948-07 ",.01)
 ;;00247-0948-07
 ;;9002226.02101,"723,00247-0948-07 ",.02)
 ;;00247-0948-07
 ;;9002226.02101,"723,00247-0948-14 ",.01)
 ;;00247-0948-14
 ;;9002226.02101,"723,00247-0948-14 ",.02)
 ;;00247-0948-14
 ;;9002226.02101,"723,00247-0948-28 ",.01)
 ;;00247-0948-28
 ;;9002226.02101,"723,00247-0948-28 ",.02)
 ;;00247-0948-28
 ;;9002226.02101,"723,00247-0948-30 ",.01)
 ;;00247-0948-30
 ;;9002226.02101,"723,00247-0948-30 ",.02)
 ;;00247-0948-30
 ;;9002226.02101,"723,00247-1315-14 ",.01)
 ;;00247-1315-14
 ;;9002226.02101,"723,00247-1315-14 ",.02)
 ;;00247-1315-14
 ;;9002226.02101,"723,00247-1316-30 ",.01)
 ;;00247-1316-30
 ;;9002226.02101,"723,00247-1316-30 ",.02)
 ;;00247-1316-30
 ;;9002226.02101,"723,00247-1355-30 ",.01)
 ;;00247-1355-30
 ;;9002226.02101,"723,00247-1355-30 ",.02)
 ;;00247-1355-30
 ;;9002226.02101,"723,00247-1492-07 ",.01)
 ;;00247-1492-07
 ;;9002226.02101,"723,00247-1492-07 ",.02)
 ;;00247-1492-07
 ;;9002226.02101,"723,00247-1492-14 ",.01)
 ;;00247-1492-14
 ;;9002226.02101,"723,00247-1492-14 ",.02)
 ;;00247-1492-14
 ;;9002226.02101,"723,00247-1492-28 ",.01)
 ;;00247-1492-28
 ;;9002226.02101,"723,00247-1492-28 ",.02)
 ;;00247-1492-28
 ;;9002226.02101,"723,00247-1492-30 ",.01)
 ;;00247-1492-30
 ;;9002226.02101,"723,00247-1492-30 ",.02)
 ;;00247-1492-30
 ;;9002226.02101,"723,00247-1493-07 ",.01)
 ;;00247-1493-07
 ;;9002226.02101,"723,00247-1493-07 ",.02)
 ;;00247-1493-07
 ;;9002226.02101,"723,00247-1493-14 ",.01)
 ;;00247-1493-14
 ;;9002226.02101,"723,00247-1493-14 ",.02)
 ;;00247-1493-14
 ;;9002226.02101,"723,00247-1493-28 ",.01)
 ;;00247-1493-28
 ;;9002226.02101,"723,00247-1493-28 ",.02)
 ;;00247-1493-28
 ;;9002226.02101,"723,00247-1493-30 ",.01)
 ;;00247-1493-30
 ;;9002226.02101,"723,00247-1493-30 ",.02)
 ;;00247-1493-30
 ;;9002226.02101,"723,00247-1494-30 ",.01)
 ;;00247-1494-30
 ;;9002226.02101,"723,00247-1494-30 ",.02)
 ;;00247-1494-30
 ;;9002226.02101,"723,00247-1495-21 ",.01)
 ;;00247-1495-21
 ;;9002226.02101,"723,00247-1495-21 ",.02)
 ;;00247-1495-21
 ;;9002226.02101,"723,00247-1495-30 ",.01)
 ;;00247-1495-30
 ;;9002226.02101,"723,00247-1495-30 ",.02)
 ;;00247-1495-30
 ;;9002226.02101,"723,00247-1717-30 ",.01)
 ;;00247-1717-30
 ;;9002226.02101,"723,00247-1717-30 ",.02)
 ;;00247-1717-30
 ;;9002226.02101,"723,00247-1718-30 ",.01)
 ;;00247-1718-30
 ;;9002226.02101,"723,00247-1718-30 ",.02)
 ;;00247-1718-30
 ;;9002226.02101,"723,00247-1896-00 ",.01)
 ;;00247-1896-00
 ;;9002226.02101,"723,00247-1896-00 ",.02)
 ;;00247-1896-00
 ;;9002226.02101,"723,00247-1896-30 ",.01)
 ;;00247-1896-30
 ;;9002226.02101,"723,00247-1896-30 ",.02)
 ;;00247-1896-30
 ;;9002226.02101,"723,00247-1896-60 ",.01)
 ;;00247-1896-60
 ;;9002226.02101,"723,00247-1896-60 ",.02)
 ;;00247-1896-60
 ;;9002226.02101,"723,00247-1896-77 ",.01)
 ;;00247-1896-77
 ;;9002226.02101,"723,00247-1896-77 ",.02)
 ;;00247-1896-77
 ;;9002226.02101,"723,00247-1896-90 ",.01)
 ;;00247-1896-90
 ;;9002226.02101,"723,00247-1896-90 ",.02)
 ;;00247-1896-90
 ;;9002226.02101,"723,00378-8115-01 ",.01)
 ;;00378-8115-01
 ;;9002226.02101,"723,00378-8115-01 ",.02)
 ;;00378-8115-01
