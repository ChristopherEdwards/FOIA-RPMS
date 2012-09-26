BGP2VI2 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 08, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"561,00078-0619-15 ",.02)
 ;;00078-0619-15
 ;;9002226.02101,"561,00083-0167-02 ",.01)
 ;;00083-0167-02
 ;;9002226.02101,"561,00083-0167-02 ",.02)
 ;;00083-0167-02
 ;;9002226.02101,"561,00083-0167-74 ",.01)
 ;;00083-0167-74
 ;;9002226.02101,"561,00083-0167-74 ",.02)
 ;;00083-0167-74
 ;;9002226.02101,"561,00085-0208-02 ",.01)
 ;;00085-0208-02
 ;;9002226.02101,"561,00085-0208-02 ",.02)
 ;;00085-0208-02
 ;;9002226.02101,"561,00085-0209-01 ",.01)
 ;;00085-0209-01
 ;;9002226.02101,"561,00085-0209-01 ",.02)
 ;;00085-0209-01
 ;;9002226.02101,"561,00085-0614-02 ",.01)
 ;;00085-0614-02
 ;;9002226.02101,"561,00085-0614-02 ",.02)
 ;;00085-0614-02
 ;;9002226.02101,"561,00085-1132-01 ",.01)
 ;;00085-1132-01
 ;;9002226.02101,"561,00085-1132-01 ",.02)
 ;;00085-1132-01
 ;;9002226.02101,"561,00085-1336-01 ",.01)
 ;;00085-1336-01
 ;;9002226.02101,"561,00085-1336-01 ",.02)
 ;;00085-1336-01
 ;;9002226.02101,"561,00085-1341-01 ",.01)
 ;;00085-1341-01
 ;;9002226.02101,"561,00085-1341-01 ",.02)
 ;;00085-1341-01
 ;;9002226.02101,"561,00085-1341-02 ",.01)
 ;;00085-1341-02
 ;;9002226.02101,"561,00085-1341-02 ",.02)
 ;;00085-1341-02
 ;;9002226.02101,"561,00085-1341-03 ",.01)
 ;;00085-1341-03
 ;;9002226.02101,"561,00085-1341-03 ",.02)
 ;;00085-1341-03
 ;;9002226.02101,"561,00085-1341-04 ",.01)
 ;;00085-1341-04
 ;;9002226.02101,"561,00085-1341-04 ",.02)
 ;;00085-1341-04
 ;;9002226.02101,"561,00085-1401-01 ",.01)
 ;;00085-1401-01
 ;;9002226.02101,"561,00085-1401-01 ",.02)
 ;;00085-1401-01
 ;;9002226.02101,"561,00085-1402-01 ",.01)
 ;;00085-1402-01
 ;;9002226.02101,"561,00085-1402-01 ",.02)
 ;;00085-1402-01
 ;;9002226.02101,"561,00085-1402-02 ",.01)
 ;;00085-1402-02
 ;;9002226.02101,"561,00085-1402-02 ",.02)
 ;;00085-1402-02
 ;;9002226.02101,"561,00085-1461-02 ",.01)
 ;;00085-1461-02
 ;;9002226.02101,"561,00085-1461-02 ",.02)
 ;;00085-1461-02
 ;;9002226.02101,"561,00085-1461-07 ",.01)
 ;;00085-1461-07
 ;;9002226.02101,"561,00085-1461-07 ",.02)
 ;;00085-1461-07
 ;;9002226.02101,"561,00085-1806-01 ",.01)
 ;;00085-1806-01
 ;;9002226.02101,"561,00085-1806-01 ",.02)
 ;;00085-1806-01
 ;;9002226.02101,"561,00085-4610-01 ",.01)
 ;;00085-4610-01
 ;;9002226.02101,"561,00085-4610-01 ",.02)
 ;;00085-4610-01
 ;;9002226.02101,"561,00085-7206-01 ",.01)
 ;;00085-7206-01
 ;;9002226.02101,"561,00085-7206-01 ",.02)
 ;;00085-7206-01
 ;;9002226.02101,"561,00089-0815-21 ",.01)
 ;;00089-0815-21
 ;;9002226.02101,"561,00089-0815-21 ",.02)
 ;;00089-0815-21
 ;;9002226.02101,"561,00093-6815-45 ",.01)
 ;;00093-6815-45
 ;;9002226.02101,"561,00093-6815-45 ",.02)
 ;;00093-6815-45
 ;;9002226.02101,"561,00093-6815-73 ",.01)
 ;;00093-6815-73
 ;;9002226.02101,"561,00093-6815-73 ",.02)
 ;;00093-6815-73
 ;;9002226.02101,"561,00093-6816-45 ",.01)
 ;;00093-6816-45
 ;;9002226.02101,"561,00093-6816-45 ",.02)
 ;;00093-6816-45
 ;;9002226.02101,"561,00093-6816-73 ",.01)
 ;;00093-6816-73
 ;;9002226.02101,"561,00093-6816-73 ",.02)
 ;;00093-6816-73
 ;;9002226.02101,"561,00172-6405-44 ",.01)
 ;;00172-6405-44
 ;;9002226.02101,"561,00172-6405-44 ",.02)
 ;;00172-6405-44
 ;;9002226.02101,"561,00172-6405-49 ",.01)
 ;;00172-6405-49
 ;;9002226.02101,"561,00172-6405-49 ",.02)
 ;;00172-6405-49
 ;;9002226.02101,"561,00172-6406-49 ",.01)
 ;;00172-6406-49
 ;;9002226.02101,"561,00172-6406-49 ",.02)
 ;;00172-6406-49
 ;;9002226.02101,"561,00172-6406-59 ",.01)
 ;;00172-6406-59
 ;;9002226.02101,"561,00172-6406-59 ",.02)
 ;;00172-6406-59
 ;;9002226.02101,"561,00173-0520-00 ",.01)
 ;;00173-0520-00
 ;;9002226.02101,"561,00173-0520-00 ",.02)
 ;;00173-0520-00
 ;;9002226.02101,"561,00173-0521-00 ",.01)
 ;;00173-0521-00
 ;;9002226.02101,"561,00173-0521-00 ",.02)
 ;;00173-0521-00
 ;;9002226.02101,"561,00173-0600-02 ",.01)
 ;;00173-0600-02
 ;;9002226.02101,"561,00173-0600-02 ",.02)
 ;;00173-0600-02
 ;;9002226.02101,"561,00173-0601-02 ",.01)
 ;;00173-0601-02
 ;;9002226.02101,"561,00173-0601-02 ",.02)
 ;;00173-0601-02
 ;;9002226.02101,"561,00173-0602-02 ",.01)
 ;;00173-0602-02
 ;;9002226.02101,"561,00173-0602-02 ",.02)
 ;;00173-0602-02
 ;;9002226.02101,"561,00173-0682-20 ",.01)
 ;;00173-0682-20
 ;;9002226.02101,"561,00173-0682-20 ",.02)
 ;;00173-0682-20
 ;;9002226.02101,"561,00173-0682-21 ",.01)
 ;;00173-0682-21
 ;;9002226.02101,"561,00173-0682-21 ",.02)
 ;;00173-0682-21
 ;;9002226.02101,"561,00173-0682-24 ",.01)
 ;;00173-0682-24
 ;;9002226.02101,"561,00173-0682-24 ",.02)
 ;;00173-0682-24
 ;;9002226.02101,"561,00173-0682-54 ",.01)
 ;;00173-0682-54
 ;;9002226.02101,"561,00173-0682-54 ",.02)
 ;;00173-0682-54
 ;;9002226.02101,"561,00173-0682-81 ",.01)
 ;;00173-0682-81
 ;;9002226.02101,"561,00173-0682-81 ",.02)
 ;;00173-0682-81
 ;;9002226.02101,"561,00173-0695-00 ",.01)
 ;;00173-0695-00
 ;;9002226.02101,"561,00173-0695-00 ",.02)
 ;;00173-0695-00
 ;;9002226.02101,"561,00173-0695-02 ",.01)
 ;;00173-0695-02
 ;;9002226.02101,"561,00173-0695-02 ",.02)
 ;;00173-0695-02
 ;;9002226.02101,"561,00173-0695-04 ",.01)
 ;;00173-0695-04
 ;;9002226.02101,"561,00173-0695-04 ",.02)
 ;;00173-0695-04
 ;;9002226.02101,"561,00173-0696-00 ",.01)
 ;;00173-0696-00
 ;;9002226.02101,"561,00173-0696-00 ",.02)
 ;;00173-0696-00
 ;;9002226.02101,"561,00173-0696-02 ",.01)
 ;;00173-0696-02
 ;;9002226.02101,"561,00173-0696-02 ",.02)
 ;;00173-0696-02
 ;;9002226.02101,"561,00173-0696-04 ",.01)
 ;;00173-0696-04
 ;;9002226.02101,"561,00173-0696-04 ",.02)
 ;;00173-0696-04
 ;;9002226.02101,"561,00173-0697-00 ",.01)
 ;;00173-0697-00
 ;;9002226.02101,"561,00173-0697-00 ",.02)
 ;;00173-0697-00
 ;;9002226.02101,"561,00173-0697-02 ",.01)
 ;;00173-0697-02
 ;;9002226.02101,"561,00173-0697-02 ",.02)
 ;;00173-0697-02
 ;;9002226.02101,"561,00173-0697-04 ",.01)
 ;;00173-0697-04
 ;;9002226.02101,"561,00173-0697-04 ",.02)
 ;;00173-0697-04
 ;;9002226.02101,"561,00173-0715-00 ",.01)
 ;;00173-0715-00
 ;;9002226.02101,"561,00173-0715-00 ",.02)
 ;;00173-0715-00
 ;;9002226.02101,"561,00173-0715-20 ",.01)
 ;;00173-0715-20
 ;;9002226.02101,"561,00173-0715-20 ",.02)
 ;;00173-0715-20
 ;;9002226.02101,"561,00173-0715-22 ",.01)
 ;;00173-0715-22
 ;;9002226.02101,"561,00173-0715-22 ",.02)
 ;;00173-0715-22
 ;;9002226.02101,"561,00173-0716-00 ",.01)
 ;;00173-0716-00
 ;;9002226.02101,"561,00173-0716-00 ",.02)
 ;;00173-0716-00
 ;;9002226.02101,"561,00173-0716-20 ",.01)
 ;;00173-0716-20
 ;;9002226.02101,"561,00173-0716-20 ",.02)
 ;;00173-0716-20
 ;;9002226.02101,"561,00173-0716-22 ",.01)
 ;;00173-0716-22
 ;;9002226.02101,"561,00173-0716-22 ",.02)
 ;;00173-0716-22
 ;;9002226.02101,"561,00173-0717-00 ",.01)
 ;;00173-0717-00
 ;;9002226.02101,"561,00173-0717-00 ",.02)
 ;;00173-0717-00
 ;;9002226.02101,"561,00173-0717-20 ",.01)
 ;;00173-0717-20
 ;;9002226.02101,"561,00173-0717-20 ",.02)
 ;;00173-0717-20
 ;;9002226.02101,"561,00173-0717-22 ",.01)
 ;;00173-0717-22
 ;;9002226.02101,"561,00173-0717-22 ",.02)
 ;;00173-0717-22
 ;;9002226.02101,"561,00173-0718-00 ",.01)
 ;;00173-0718-00
 ;;9002226.02101,"561,00173-0718-00 ",.02)
 ;;00173-0718-00
 ;;9002226.02101,"561,00173-0718-20 ",.01)
 ;;00173-0718-20
 ;;9002226.02101,"561,00173-0718-20 ",.02)
 ;;00173-0718-20
 ;;9002226.02101,"561,00173-0719-00 ",.01)
 ;;00173-0719-00
 ;;9002226.02101,"561,00173-0719-00 ",.02)
 ;;00173-0719-00
 ;;9002226.02101,"561,00173-0719-20 ",.01)
 ;;00173-0719-20
 ;;9002226.02101,"561,00173-0719-20 ",.02)
 ;;00173-0719-20
 ;;9002226.02101,"561,00173-0720-00 ",.01)
 ;;00173-0720-00
 ;;9002226.02101,"561,00173-0720-00 ",.02)
 ;;00173-0720-00
 ;;9002226.02101,"561,00173-0720-20 ",.01)
 ;;00173-0720-20
 ;;9002226.02101,"561,00173-0720-20 ",.02)
 ;;00173-0720-20
 ;;9002226.02101,"561,00182-6014-65 ",.01)
 ;;00182-6014-65
 ;;9002226.02101,"561,00182-6014-65 ",.02)
 ;;00182-6014-65
 ;;9002226.02101,"561,00186-0370-20 ",.01)
 ;;00186-0370-20
 ;;9002226.02101,"561,00186-0370-20 ",.02)
 ;;00186-0370-20
 ;;9002226.02101,"561,00186-0370-28 ",.01)
 ;;00186-0370-28
 ;;9002226.02101,"561,00186-0370-28 ",.02)
 ;;00186-0370-28
 ;;9002226.02101,"561,00186-0372-20 ",.01)
 ;;00186-0372-20
 ;;9002226.02101,"561,00186-0372-20 ",.02)
 ;;00186-0372-20
 ;;9002226.02101,"561,00186-0372-28 ",.01)
 ;;00186-0372-28
 ;;9002226.02101,"561,00186-0372-28 ",.02)
 ;;00186-0372-28
 ;;9002226.02101,"561,00186-0426-04 ",.01)
 ;;00186-0426-04
 ;;9002226.02101,"561,00186-0426-04 ",.02)
 ;;00186-0426-04
 ;;9002226.02101,"561,00186-0915-42 ",.01)
 ;;00186-0915-42
 ;;9002226.02101,"561,00186-0915-42 ",.02)
 ;;00186-0915-42
 ;;9002226.02101,"561,00186-0916-12 ",.01)
 ;;00186-0916-12
 ;;9002226.02101,"561,00186-0916-12 ",.02)
 ;;00186-0916-12
 ;;9002226.02101,"561,00186-0917-06 ",.01)
 ;;00186-0917-06
 ;;9002226.02101,"561,00186-0917-06 ",.02)
 ;;00186-0917-06
 ;;9002226.02101,"561,00186-1988-04 ",.01)
 ;;00186-1988-04
 ;;9002226.02101,"561,00186-1988-04 ",.02)
 ;;00186-1988-04
 ;;9002226.02101,"561,00186-1989-04 ",.01)
 ;;00186-1989-04
 ;;9002226.02101,"561,00186-1989-04 ",.02)
 ;;00186-1989-04
 ;;9002226.02101,"561,00186-1990-04 ",.01)
 ;;00186-1990-04
 ;;9002226.02101,"561,00186-1990-04 ",.02)
 ;;00186-1990-04
 ;;9002226.02101,"561,00247-0084-17 ",.01)
 ;;00247-0084-17
 ;;9002226.02101,"561,00247-0084-17 ",.02)
 ;;00247-0084-17
 ;;9002226.02101,"561,00247-0084-86 ",.01)
 ;;00247-0084-86
 ;;9002226.02101,"561,00247-0084-86 ",.02)
 ;;00247-0084-86
 ;;9002226.02101,"561,00247-0171-10 ",.01)
 ;;00247-0171-10
 ;;9002226.02101,"561,00247-0171-10 ",.02)
 ;;00247-0171-10
 ;;9002226.02101,"561,00247-0171-12 ",.01)
 ;;00247-0171-12
 ;;9002226.02101,"561,00247-0171-12 ",.02)
 ;;00247-0171-12
 ;;9002226.02101,"561,00247-0171-30 ",.01)
 ;;00247-0171-30
 ;;9002226.02101,"561,00247-0171-30 ",.02)
 ;;00247-0171-30
 ;;9002226.02101,"561,00247-0171-75 ",.01)
 ;;00247-0171-75
 ;;9002226.02101,"561,00247-0171-75 ",.02)
 ;;00247-0171-75
 ;;9002226.02101,"561,00247-0190-20 ",.01)
 ;;00247-0190-20
 ;;9002226.02101,"561,00247-0190-20 ",.02)
 ;;00247-0190-20
 ;;9002226.02101,"561,00247-0348-17 ",.01)
 ;;00247-0348-17
 ;;9002226.02101,"561,00247-0348-17 ",.02)
 ;;00247-0348-17
 ;;9002226.02101,"561,00247-0588-41 ",.01)
 ;;00247-0588-41
 ;;9002226.02101,"561,00247-0588-41 ",.02)
 ;;00247-0588-41
 ;;9002226.02101,"561,00247-0657-10 ",.01)
 ;;00247-0657-10
 ;;9002226.02101,"561,00247-0657-10 ",.02)
 ;;00247-0657-10
 ;;9002226.02101,"561,00247-0657-47 ",.01)
 ;;00247-0657-47
 ;;9002226.02101,"561,00247-0657-47 ",.02)
 ;;00247-0657-47
 ;;9002226.02101,"561,00247-0657-65 ",.01)
 ;;00247-0657-65
 ;;9002226.02101,"561,00247-0657-65 ",.02)
 ;;00247-0657-65
 ;;9002226.02101,"561,00247-0658-50 ",.01)
 ;;00247-0658-50
 ;;9002226.02101,"561,00247-0658-50 ",.02)
 ;;00247-0658-50
 ;;9002226.02101,"561,00247-0659-07 ",.01)
 ;;00247-0659-07
 ;;9002226.02101,"561,00247-0659-07 ",.02)
 ;;00247-0659-07
 ;;9002226.02101,"561,00247-0667-08 ",.01)
 ;;00247-0667-08
 ;;9002226.02101,"561,00247-0667-08 ",.02)
 ;;00247-0667-08
 ;;9002226.02101,"561,00247-0674-41 ",.01)
 ;;00247-0674-41
 ;;9002226.02101,"561,00247-0674-41 ",.02)
 ;;00247-0674-41
 ;;9002226.02101,"561,00247-0703-07 ",.01)
 ;;00247-0703-07
 ;;9002226.02101,"561,00247-0703-07 ",.02)
 ;;00247-0703-07
 ;;9002226.02101,"561,00247-0870-20 ",.01)
 ;;00247-0870-20
 ;;9002226.02101,"561,00247-0870-20 ",.02)
 ;;00247-0870-20
 ;;9002226.02101,"561,00247-0871-20 ",.01)
 ;;00247-0871-20
 ;;9002226.02101,"561,00247-0871-20 ",.02)
 ;;00247-0871-20
 ;;9002226.02101,"561,00247-0873-02 ",.01)
 ;;00247-0873-02
 ;;9002226.02101,"561,00247-0873-02 ",.02)
 ;;00247-0873-02
 ;;9002226.02101,"561,00247-0873-52 ",.01)
 ;;00247-0873-52
 ;;9002226.02101,"561,00247-0873-52 ",.02)
 ;;00247-0873-52
 ;;9002226.02101,"561,00247-0873-60 ",.01)
 ;;00247-0873-60
 ;;9002226.02101,"561,00247-0873-60 ",.02)
 ;;00247-0873-60
 ;;9002226.02101,"561,00247-0912-17 ",.01)
 ;;00247-0912-17
 ;;9002226.02101,"561,00247-0912-17 ",.02)
 ;;00247-0912-17
 ;;9002226.02101,"561,00247-1174-17 ",.01)
 ;;00247-1174-17
 ;;9002226.02101,"561,00247-1174-17 ",.02)
 ;;00247-1174-17
 ;;9002226.02101,"561,00247-1364-17 ",.01)
 ;;00247-1364-17
 ;;9002226.02101,"561,00247-1364-17 ",.02)
 ;;00247-1364-17
 ;;9002226.02101,"561,00247-1696-93 ",.01)
 ;;00247-1696-93
 ;;9002226.02101,"561,00247-1696-93 ",.02)
 ;;00247-1696-93
 ;;9002226.02101,"561,00247-1973-60 ",.01)
 ;;00247-1973-60
 ;;9002226.02101,"561,00247-1973-60 ",.02)
 ;;00247-1973-60
 ;;9002226.02101,"561,00247-1983-60 ",.01)
 ;;00247-1983-60
 ;;9002226.02101,"561,00247-1983-60 ",.02)
 ;;00247-1983-60
 ;;9002226.02101,"561,00247-2072-60 ",.01)
 ;;00247-2072-60
 ;;9002226.02101,"561,00247-2072-60 ",.02)
 ;;00247-2072-60
 ;;9002226.02101,"561,00247-2215-60 ",.01)
 ;;00247-2215-60
 ;;9002226.02101,"561,00247-2215-60 ",.02)
 ;;00247-2215-60
 ;;9002226.02101,"561,00247-2224-72 ",.01)
 ;;00247-2224-72
 ;;9002226.02101,"561,00247-2224-72 ",.02)
 ;;00247-2224-72
 ;;9002226.02101,"561,00247-2225-72 ",.01)
 ;;00247-2225-72
 ;;9002226.02101,"561,00247-2225-72 ",.02)
 ;;00247-2225-72
 ;;9002226.02101,"561,00247-2226-72 ",.01)
 ;;00247-2226-72
 ;;9002226.02101,"561,00247-2226-72 ",.02)
 ;;00247-2226-72
 ;;9002226.02101,"561,00247-2227-01 ",.01)
 ;;00247-2227-01
 ;;9002226.02101,"561,00247-2227-01 ",.02)
 ;;00247-2227-01
 ;;9002226.02101,"561,00247-2297-58 ",.01)
 ;;00247-2297-58
 ;;9002226.02101,"561,00247-2297-58 ",.02)
 ;;00247-2297-58
 ;;9002226.02101,"561,00378-6990-52 ",.01)
 ;;00378-6990-52
 ;;9002226.02101,"561,00378-6990-52 ",.02)
 ;;00378-6990-52
 ;;9002226.02101,"561,00378-6990-58 ",.01)
 ;;00378-6990-58
