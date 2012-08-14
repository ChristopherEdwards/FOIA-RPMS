BGP06A33 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAY 23, 2010;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"974,00472-1285-06 ",.01)
 ;;00472-1285-06
 ;;9002226.02101,"974,00472-1285-06 ",.02)
 ;;00472-1285-06
 ;;9002226.02101,"974,00472-1285-09 ",.01)
 ;;00472-1285-09
 ;;9002226.02101,"974,00472-1285-09 ",.02)
 ;;00472-1285-09
 ;;9002226.02101,"974,00472-1285-16 ",.01)
 ;;00472-1285-16
 ;;9002226.02101,"974,00472-1285-16 ",.02)
 ;;00472-1285-16
 ;;9002226.02101,"974,00472-1285-33 ",.01)
 ;;00472-1285-33
 ;;9002226.02101,"974,00472-1285-33 ",.02)
 ;;00472-1285-33
 ;;9002226.02101,"974,00485-0041-50 ",.01)
 ;;00485-0041-50
 ;;9002226.02101,"974,00485-0041-50 ",.02)
 ;;00485-0041-50
 ;;9002226.02101,"974,00527-1335-01 ",.01)
 ;;00527-1335-01
 ;;9002226.02101,"974,00527-1335-01 ",.02)
 ;;00527-1335-01
 ;;9002226.02101,"974,00527-1336-01 ",.01)
 ;;00527-1336-01
 ;;9002226.02101,"974,00527-1336-01 ",.02)
 ;;00527-1336-01
 ;;9002226.02101,"974,00527-1338-25 ",.01)
 ;;00527-1338-25
 ;;9002226.02101,"974,00527-1338-25 ",.02)
 ;;00527-1338-25
 ;;9002226.02101,"974,00527-1338-50 ",.01)
 ;;00527-1338-50
 ;;9002226.02101,"974,00527-1338-50 ",.02)
 ;;00527-1338-50
 ;;9002226.02101,"974,00527-1382-01 ",.01)
 ;;00527-1382-01
 ;;9002226.02101,"974,00527-1382-01 ",.02)
 ;;00527-1382-01
 ;;9002226.02101,"974,00527-1383-01 ",.01)
 ;;00527-1383-01
 ;;9002226.02101,"974,00527-1383-01 ",.02)
 ;;00527-1383-01
 ;;9002226.02101,"974,00527-1383-02 ",.01)
 ;;00527-1383-02
 ;;9002226.02101,"974,00527-1383-02 ",.02)
 ;;00527-1383-02
 ;;9002226.02101,"974,00527-1384-01 ",.01)
 ;;00527-1384-01
 ;;9002226.02101,"974,00527-1384-01 ",.02)
 ;;00527-1384-01
 ;;9002226.02101,"974,00527-1385-01 ",.01)
 ;;00527-1385-01
 ;;9002226.02101,"974,00527-1385-01 ",.02)
 ;;00527-1385-01
 ;;9002226.02101,"974,00527-1386-50 ",.01)
 ;;00527-1386-50
 ;;9002226.02101,"974,00527-1386-50 ",.02)
 ;;00527-1386-50
 ;;9002226.02101,"974,00527-1442-01 ",.01)
 ;;00527-1442-01
 ;;9002226.02101,"974,00527-1442-01 ",.02)
 ;;00527-1442-01
 ;;9002226.02101,"974,00527-1443-01 ",.01)
 ;;00527-1443-01
 ;;9002226.02101,"974,00527-1443-01 ",.02)
 ;;00527-1443-01
 ;;9002226.02101,"974,00527-1443-05 ",.01)
 ;;00527-1443-05
 ;;9002226.02101,"974,00527-1443-05 ",.02)
 ;;00527-1443-05
 ;;9002226.02101,"974,00536-0105-71 ",.01)
 ;;00536-0105-71
 ;;9002226.02101,"974,00536-0105-71 ",.02)
 ;;00536-0105-71
 ;;9002226.02101,"974,00536-0230-05 ",.01)
 ;;00536-0230-05
 ;;9002226.02101,"974,00536-0230-05 ",.02)
 ;;00536-0230-05
 ;;9002226.02101,"974,00536-1375-01 ",.01)
 ;;00536-1375-01
 ;;9002226.02101,"974,00536-1375-01 ",.02)
 ;;00536-1375-01
 ;;9002226.02101,"974,00536-1482-01 ",.01)
 ;;00536-1482-01
 ;;9002226.02101,"974,00536-1482-01 ",.02)
 ;;00536-1482-01
 ;;9002226.02101,"974,00536-1492-06 ",.01)
 ;;00536-1492-06
 ;;9002226.02101,"974,00536-1492-06 ",.02)
 ;;00536-1492-06
 ;;9002226.02101,"974,00536-1725-85 ",.01)
 ;;00536-1725-85
 ;;9002226.02101,"974,00536-1725-85 ",.02)
 ;;00536-1725-85
 ;;9002226.02101,"974,00536-4692-01 ",.01)
 ;;00536-4692-01
 ;;9002226.02101,"974,00536-4692-01 ",.02)
 ;;00536-4692-01
 ;;9002226.02101,"974,00555-0010-02 ",.01)
 ;;00555-0010-02
 ;;9002226.02101,"974,00555-0010-02 ",.02)
 ;;00555-0010-02
 ;;9002226.02101,"974,00555-0010-05 ",.01)
 ;;00555-0010-05
 ;;9002226.02101,"974,00555-0010-05 ",.02)
 ;;00555-0010-05
 ;;9002226.02101,"974,00555-0011-02 ",.01)
 ;;00555-0011-02
 ;;9002226.02101,"974,00555-0011-02 ",.02)
 ;;00555-0011-02
 ;;9002226.02101,"974,00555-0011-05 ",.01)
 ;;00555-0011-05
 ;;9002226.02101,"974,00555-0011-05 ",.02)
 ;;00555-0011-05
 ;;9002226.02101,"974,00555-0215-22 ",.01)
 ;;00555-0215-22
 ;;9002226.02101,"974,00555-0215-22 ",.02)
 ;;00555-0215-22
 ;;9002226.02101,"974,00555-0215-23 ",.01)
 ;;00555-0215-23
 ;;9002226.02101,"974,00555-0215-23 ",.02)
 ;;00555-0215-23
 ;;9002226.02101,"974,00555-0259-02 ",.01)
 ;;00555-0259-02
 ;;9002226.02101,"974,00555-0259-02 ",.02)
 ;;00555-0259-02
 ;;9002226.02101,"974,00555-0259-04 ",.01)
 ;;00555-0259-04
 ;;9002226.02101,"974,00555-0259-04 ",.02)
 ;;00555-0259-04
 ;;9002226.02101,"974,00555-0379-87 ",.01)
 ;;00555-0379-87
 ;;9002226.02101,"974,00555-0379-87 ",.02)
 ;;00555-0379-87
 ;;9002226.02101,"974,00555-0380-87 ",.01)
 ;;00555-0380-87
 ;;9002226.02101,"974,00555-0380-87 ",.02)
 ;;00555-0380-87
 ;;9002226.02101,"974,00555-0445-21 ",.01)
 ;;00555-0445-21
 ;;9002226.02101,"974,00555-0445-21 ",.02)
 ;;00555-0445-21
 ;;9002226.02101,"974,00555-0445-22 ",.01)
 ;;00555-0445-22
 ;;9002226.02101,"974,00555-0445-22 ",.02)
 ;;00555-0445-22
 ;;9002226.02101,"974,00555-0445-23 ",.01)
 ;;00555-0445-23
 ;;9002226.02101,"974,00555-0445-23 ",.02)
 ;;00555-0445-23
 ;;9002226.02101,"974,00555-0582-02 ",.01)
 ;;00555-0582-02
 ;;9002226.02101,"974,00555-0582-02 ",.02)
 ;;00555-0582-02
 ;;9002226.02101,"974,00555-0582-10 ",.01)
 ;;00555-0582-10
 ;;9002226.02101,"974,00555-0582-10 ",.02)
 ;;00555-0582-10
 ;;9002226.02101,"974,00555-0584-02 ",.01)
 ;;00555-0584-02
 ;;9002226.02101,"974,00555-0584-02 ",.02)
 ;;00555-0584-02
 ;;9002226.02101,"974,00555-0584-04 ",.01)
 ;;00555-0584-04
 ;;9002226.02101,"974,00555-0584-04 ",.02)
 ;;00555-0584-04
 ;;9002226.02101,"974,00555-0694-02 ",.01)
 ;;00555-0694-02
 ;;9002226.02101,"974,00555-0694-02 ",.02)
 ;;00555-0694-02
 ;;9002226.02101,"974,00555-0695-02 ",.01)
 ;;00555-0695-02
 ;;9002226.02101,"974,00555-0695-02 ",.02)
 ;;00555-0695-02
 ;;9002226.02101,"974,00555-0696-10 ",.01)
 ;;00555-0696-10
 ;;9002226.02101,"974,00555-0696-10 ",.02)
 ;;00555-0696-10
 ;;9002226.02101,"974,00555-0814-02 ",.01)
 ;;00555-0814-02
 ;;9002226.02101,"974,00555-0814-02 ",.02)
 ;;00555-0814-02
 ;;9002226.02101,"974,00555-0815-02 ",.01)
 ;;00555-0815-02
 ;;9002226.02101,"974,00555-0815-02 ",.02)
 ;;00555-0815-02
 ;;9002226.02101,"974,00555-0816-10 ",.01)
 ;;00555-0816-10
 ;;9002226.02101,"974,00555-0816-10 ",.02)
 ;;00555-0816-10
 ;;9002226.02101,"974,00591-0309-01 ",.01)
 ;;00591-0309-01
 ;;9002226.02101,"974,00591-0309-01 ",.02)
 ;;00591-0309-01
 ;;9002226.02101,"974,00591-0310-50 ",.01)
 ;;00591-0310-50
 ;;9002226.02101,"974,00591-0310-50 ",.02)
 ;;00591-0310-50
 ;;9002226.02101,"974,00591-0410-01 ",.01)
 ;;00591-0410-01
 ;;9002226.02101,"974,00591-0410-01 ",.02)
 ;;00591-0410-01
 ;;9002226.02101,"974,00591-0411-50 ",.01)
 ;;00591-0411-50
 ;;9002226.02101,"974,00591-0411-50 ",.02)
 ;;00591-0411-50
 ;;9002226.02101,"974,00591-0498-05 ",.01)
 ;;00591-0498-05
 ;;9002226.02101,"974,00591-0498-05 ",.02)
 ;;00591-0498-05
 ;;9002226.02101,"974,00591-0498-50 ",.01)
 ;;00591-0498-50
 ;;9002226.02101,"974,00591-0498-50 ",.02)
 ;;00591-0498-50
 ;;9002226.02101,"974,00591-0499-05 ",.01)
 ;;00591-0499-05
 ;;9002226.02101,"974,00591-0499-05 ",.02)
 ;;00591-0499-05
 ;;9002226.02101,"974,00591-0499-50 ",.01)
 ;;00591-0499-50
 ;;9002226.02101,"974,00591-0499-50 ",.02)
 ;;00591-0499-50
 ;;9002226.02101,"974,00591-0500-50 ",.01)
 ;;00591-0500-50
 ;;9002226.02101,"974,00591-0500-50 ",.02)
 ;;00591-0500-50
 ;;9002226.02101,"974,00591-1557-01 ",.01)
 ;;00591-1557-01
 ;;9002226.02101,"974,00591-1557-01 ",.02)
 ;;00591-1557-01
 ;;9002226.02101,"974,00591-2365-69 ",.01)
 ;;00591-2365-69
 ;;9002226.02101,"974,00591-2365-69 ",.02)
 ;;00591-2365-69
 ;;9002226.02101,"974,00591-2366-68 ",.01)
 ;;00591-2366-68
 ;;9002226.02101,"974,00591-2366-68 ",.02)
 ;;00591-2366-68
 ;;9002226.02101,"974,00591-3120-01 ",.01)
 ;;00591-3120-01
 ;;9002226.02101,"974,00591-3120-01 ",.02)
 ;;00591-3120-01
 ;;9002226.02101,"974,00591-3120-16 ",.01)
 ;;00591-3120-16
 ;;9002226.02101,"974,00591-3120-16 ",.02)
 ;;00591-3120-16
 ;;9002226.02101,"974,00591-3153-01 ",.01)
 ;;00591-3153-01
 ;;9002226.02101,"974,00591-3153-01 ",.02)
 ;;00591-3153-01
 ;;9002226.02101,"974,00591-3224-15 ",.01)
 ;;00591-3224-15
 ;;9002226.02101,"974,00591-3224-15 ",.02)
 ;;00591-3224-15
 ;;9002226.02101,"974,00591-3225-15 ",.01)
 ;;00591-3225-15
 ;;9002226.02101,"974,00591-3225-15 ",.02)
 ;;00591-3225-15
 ;;9002226.02101,"974,00591-3550-68 ",.01)
 ;;00591-3550-68
 ;;9002226.02101,"974,00591-3550-68 ",.02)
 ;;00591-3550-68
 ;;9002226.02101,"974,00591-5440-05 ",.01)
 ;;00591-5440-05
 ;;9002226.02101,"974,00591-5440-05 ",.02)
 ;;00591-5440-05
 ;;9002226.02101,"974,00591-5440-50 ",.01)
 ;;00591-5440-50
 ;;9002226.02101,"974,00591-5440-50 ",.02)
 ;;00591-5440-50
 ;;9002226.02101,"974,00591-5535-50 ",.01)
 ;;00591-5535-50
 ;;9002226.02101,"974,00591-5535-50 ",.02)
 ;;00591-5535-50
 ;;9002226.02101,"974,00591-5546-01 ",.01)
 ;;00591-5546-01
 ;;9002226.02101,"974,00591-5546-01 ",.02)
 ;;00591-5546-01
 ;;9002226.02101,"974,00591-5546-05 ",.01)
 ;;00591-5546-05
 ;;9002226.02101,"974,00591-5546-05 ",.02)
 ;;00591-5546-05
 ;;9002226.02101,"974,00591-5547-01 ",.01)
 ;;00591-5547-01
 ;;9002226.02101,"974,00591-5547-01 ",.02)
 ;;00591-5547-01
 ;;9002226.02101,"974,00591-5547-05 ",.01)
 ;;00591-5547-05
 ;;9002226.02101,"974,00591-5547-05 ",.02)
 ;;00591-5547-05
 ;;9002226.02101,"974,00591-5553-05 ",.01)
 ;;00591-5553-05
 ;;9002226.02101,"974,00591-5553-05 ",.02)
 ;;00591-5553-05
 ;;9002226.02101,"974,00591-5553-50 ",.01)
 ;;00591-5553-50
 ;;9002226.02101,"974,00591-5553-50 ",.02)
 ;;00591-5553-50
 ;;9002226.02101,"974,00591-5571-01 ",.01)
 ;;00591-5571-01
 ;;9002226.02101,"974,00591-5571-01 ",.02)
 ;;00591-5571-01
 ;;9002226.02101,"974,00591-5694-01 ",.01)
 ;;00591-5694-01
 ;;9002226.02101,"974,00591-5694-01 ",.02)
 ;;00591-5694-01
 ;;9002226.02101,"974,00591-5694-60 ",.01)
 ;;00591-5694-60
 ;;9002226.02101,"974,00591-5694-60 ",.02)
 ;;00591-5694-60
 ;;9002226.02101,"974,00591-5695-50 ",.01)
 ;;00591-5695-50
 ;;9002226.02101,"974,00591-5695-50 ",.02)
 ;;00591-5695-50
 ;;9002226.02101,"974,00591-5708-01 ",.01)
 ;;00591-5708-01
 ;;9002226.02101,"974,00591-5708-01 ",.02)
 ;;00591-5708-01
 ;;9002226.02101,"974,00603-1202-58 ",.01)
 ;;00603-1202-58
 ;;9002226.02101,"974,00603-1202-58 ",.02)
 ;;00603-1202-58
 ;;9002226.02101,"974,00603-1203-58 ",.01)
 ;;00603-1203-58
 ;;9002226.02101,"974,00603-1203-58 ",.02)
 ;;00603-1203-58
 ;;9002226.02101,"974,00603-1206-58 ",.01)
 ;;00603-1206-58
 ;;9002226.02101,"974,00603-1206-58 ",.02)
 ;;00603-1206-58
 ;;9002226.02101,"974,00603-1207-58 ",.01)
 ;;00603-1207-58
 ;;9002226.02101,"974,00603-1207-58 ",.02)
 ;;00603-1207-58
 ;;9002226.02101,"974,00603-1687-58 ",.01)
 ;;00603-1687-58
 ;;9002226.02101,"974,00603-1687-58 ",.02)
 ;;00603-1687-58
 ;;9002226.02101,"974,00603-1688-58 ",.01)
 ;;00603-1688-58
 ;;9002226.02101,"974,00603-1688-58 ",.02)
 ;;00603-1688-58
 ;;9002226.02101,"974,00603-2267-28 ",.01)
 ;;00603-2267-28
 ;;9002226.02101,"974,00603-2267-28 ",.02)
 ;;00603-2267-28
 ;;9002226.02101,"974,00603-2273-21 ",.01)
 ;;00603-2273-21
 ;;9002226.02101,"974,00603-2273-21 ",.02)
 ;;00603-2273-21
 ;;9002226.02101,"974,00603-2274-21 ",.01)
 ;;00603-2274-21
 ;;9002226.02101,"974,00603-2274-21 ",.02)
 ;;00603-2274-21
 ;;9002226.02101,"974,00603-2291-21 ",.01)
 ;;00603-2291-21
 ;;9002226.02101,"974,00603-2291-21 ",.02)
 ;;00603-2291-21
 ;;9002226.02101,"974,00603-2291-28 ",.01)
 ;;00603-2291-28
 ;;9002226.02101,"974,00603-2291-28 ",.02)
 ;;00603-2291-28
 ;;9002226.02101,"974,00603-2586-21 ",.01)
 ;;00603-2586-21
 ;;9002226.02101,"974,00603-2586-21 ",.02)
 ;;00603-2586-21
 ;;9002226.02101,"974,00603-2595-21 ",.01)
 ;;00603-2595-21
 ;;9002226.02101,"974,00603-2595-21 ",.02)
 ;;00603-2595-21
 ;;9002226.02101,"974,00603-2595-28 ",.01)
 ;;00603-2595-28
 ;;9002226.02101,"974,00603-2595-28 ",.02)
 ;;00603-2595-28
 ;;9002226.02101,"974,00603-2596-21 ",.01)
 ;;00603-2596-21
 ;;9002226.02101,"974,00603-2596-21 ",.02)
 ;;00603-2596-21
 ;;9002226.02101,"974,00603-2596-28 ",.01)
 ;;00603-2596-28
 ;;9002226.02101,"974,00603-2596-28 ",.02)
 ;;00603-2596-28
 ;;9002226.02101,"974,00603-2619-21 ",.01)
 ;;00603-2619-21
 ;;9002226.02101,"974,00603-2619-21 ",.02)
 ;;00603-2619-21
 ;;9002226.02101,"974,00603-2620-21 ",.01)
 ;;00603-2620-21
 ;;9002226.02101,"974,00603-2620-21 ",.02)
 ;;00603-2620-21
 ;;9002226.02101,"974,00603-2909-21 ",.01)
 ;;00603-2909-21
 ;;9002226.02101,"974,00603-2909-21 ",.02)
 ;;00603-2909-21
 ;;9002226.02101,"974,00603-3241-21 ",.01)
 ;;00603-3241-21
 ;;9002226.02101,"974,00603-3241-21 ",.02)
 ;;00603-3241-21
 ;;9002226.02101,"974,00603-3242-21 ",.01)
 ;;00603-3242-21
 ;;9002226.02101,"974,00603-3242-21 ",.02)
 ;;00603-3242-21
 ;;9002226.02101,"974,00603-3480-19 ",.01)
 ;;00603-3480-19
 ;;9002226.02101,"974,00603-3480-19 ",.02)
 ;;00603-3480-19
 ;;9002226.02101,"974,00603-3481-19 ",.01)
 ;;00603-3481-19
 ;;9002226.02101,"974,00603-3481-19 ",.02)
 ;;00603-3481-19
 ;;9002226.02101,"974,00603-3481-28 ",.01)
 ;;00603-3481-28
 ;;9002226.02101,"974,00603-3481-28 ",.02)
 ;;00603-3481-28
 ;;9002226.02101,"974,00603-3482-19 ",.01)
 ;;00603-3482-19
 ;;9002226.02101,"974,00603-3482-19 ",.02)
 ;;00603-3482-19
 ;;9002226.02101,"974,00603-3482-28 ",.01)
 ;;00603-3482-28
 ;;9002226.02101,"974,00603-3482-28 ",.02)
 ;;00603-3482-28
 ;;9002226.02101,"974,00603-3548-21 ",.01)
 ;;00603-3548-21
 ;;9002226.02101,"974,00603-3548-21 ",.02)
 ;;00603-3548-21
 ;;9002226.02101,"974,00603-3548-28 ",.01)
 ;;00603-3548-28
 ;;9002226.02101,"974,00603-3548-28 ",.02)
 ;;00603-3548-28
 ;;9002226.02101,"974,00603-3551-21 ",.01)
 ;;00603-3551-21
 ;;9002226.02101,"974,00603-3551-21 ",.02)
 ;;00603-3551-21
 ;;9002226.02101,"974,00603-3552-21 ",.01)
 ;;00603-3552-21
 ;;9002226.02101,"974,00603-3552-21 ",.02)
 ;;00603-3552-21
 ;;9002226.02101,"974,00603-3552-28 ",.01)
 ;;00603-3552-28
 ;;9002226.02101,"974,00603-3552-28 ",.02)
 ;;00603-3552-28