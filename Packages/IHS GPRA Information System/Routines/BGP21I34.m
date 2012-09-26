BGP21I34 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1198,67544-0596-53 ",.01)
 ;;67544-0596-53
 ;;9002226.02101,"1198,67544-0596-53 ",.02)
 ;;67544-0596-53
 ;;9002226.02101,"1198,67544-0596-60 ",.01)
 ;;67544-0596-60
 ;;9002226.02101,"1198,67544-0596-60 ",.02)
 ;;67544-0596-60
 ;;9002226.02101,"1198,67544-0596-80 ",.01)
 ;;67544-0596-80
 ;;9002226.02101,"1198,67544-0596-80 ",.02)
 ;;67544-0596-80
 ;;9002226.02101,"1198,67544-0596-96 ",.01)
 ;;67544-0596-96
 ;;9002226.02101,"1198,67544-0596-96 ",.02)
 ;;67544-0596-96
 ;;9002226.02101,"1198,67544-1081-80 ",.01)
 ;;67544-1081-80
 ;;9002226.02101,"1198,67544-1081-80 ",.02)
 ;;67544-1081-80
 ;;9002226.02101,"1198,67544-1081-94 ",.01)
 ;;67544-1081-94
 ;;9002226.02101,"1198,67544-1081-94 ",.02)
 ;;67544-1081-94
 ;;9002226.02101,"1198,67544-1129-70 ",.01)
 ;;67544-1129-70
 ;;9002226.02101,"1198,67544-1129-70 ",.02)
 ;;67544-1129-70
 ;;9002226.02101,"1198,67544-1198-53 ",.01)
 ;;67544-1198-53
 ;;9002226.02101,"1198,67544-1198-53 ",.02)
 ;;67544-1198-53
 ;;9002226.02101,"1198,67544-1198-60 ",.01)
 ;;67544-1198-60
 ;;9002226.02101,"1198,67544-1198-60 ",.02)
 ;;67544-1198-60
 ;;9002226.02101,"1198,67544-1198-80 ",.01)
 ;;67544-1198-80
 ;;9002226.02101,"1198,67544-1198-80 ",.02)
 ;;67544-1198-80
 ;;9002226.02101,"1198,67544-1216-53 ",.01)
 ;;67544-1216-53
 ;;9002226.02101,"1198,67544-1216-53 ",.02)
 ;;67544-1216-53
 ;;9002226.02101,"1198,67544-1216-60 ",.01)
 ;;67544-1216-60
 ;;9002226.02101,"1198,67544-1216-60 ",.02)
 ;;67544-1216-60
 ;;9002226.02101,"1198,67544-1216-80 ",.01)
 ;;67544-1216-80
 ;;9002226.02101,"1198,67544-1216-80 ",.02)
 ;;67544-1216-80
 ;;9002226.02101,"1198,67544-1216-92 ",.01)
 ;;67544-1216-92
 ;;9002226.02101,"1198,67544-1216-92 ",.02)
 ;;67544-1216-92
 ;;9002226.02101,"1198,67544-1379-80 ",.01)
 ;;67544-1379-80
 ;;9002226.02101,"1198,67544-1379-80 ",.02)
 ;;67544-1379-80
 ;;9002226.02101,"1198,67544-1383-60 ",.01)
 ;;67544-1383-60
 ;;9002226.02101,"1198,67544-1383-60 ",.02)
 ;;67544-1383-60
 ;;9002226.02101,"1198,67544-1383-80 ",.01)
 ;;67544-1383-80
 ;;9002226.02101,"1198,67544-1383-80 ",.02)
 ;;67544-1383-80
 ;;9002226.02101,"1198,67767-0115-01 ",.01)
 ;;67767-0115-01
 ;;9002226.02101,"1198,67767-0115-01 ",.02)
 ;;67767-0115-01
 ;;9002226.02101,"1198,67877-0217-01 ",.01)
 ;;67877-0217-01
 ;;9002226.02101,"1198,67877-0217-01 ",.02)
 ;;67877-0217-01
 ;;9002226.02101,"1198,67877-0217-05 ",.01)
 ;;67877-0217-05
 ;;9002226.02101,"1198,67877-0217-05 ",.02)
 ;;67877-0217-05
 ;;9002226.02101,"1198,67877-0218-01 ",.01)
 ;;67877-0218-01
 ;;9002226.02101,"1198,67877-0218-01 ",.02)
 ;;67877-0218-01
 ;;9002226.02101,"1198,67877-0221-01 ",.01)
 ;;67877-0221-01
 ;;9002226.02101,"1198,67877-0221-01 ",.02)
 ;;67877-0221-01
 ;;9002226.02101,"1198,68071-0028-30 ",.01)
 ;;68071-0028-30
 ;;9002226.02101,"1198,68071-0028-30 ",.02)
 ;;68071-0028-30
 ;;9002226.02101,"1198,68071-0028-60 ",.01)
 ;;68071-0028-60
 ;;9002226.02101,"1198,68071-0028-60 ",.02)
 ;;68071-0028-60
 ;;9002226.02101,"1198,68084-0072-01 ",.01)
 ;;68084-0072-01
 ;;9002226.02101,"1198,68084-0072-01 ",.02)
 ;;68084-0072-01
 ;;9002226.02101,"1198,68084-0072-11 ",.01)
 ;;68084-0072-11
 ;;9002226.02101,"1198,68084-0072-11 ",.02)
 ;;68084-0072-11
 ;;9002226.02101,"1198,68084-0136-01 ",.01)
 ;;68084-0136-01
 ;;9002226.02101,"1198,68084-0136-01 ",.02)
 ;;68084-0136-01
 ;;9002226.02101,"1198,68084-0136-11 ",.01)
 ;;68084-0136-11
 ;;9002226.02101,"1198,68084-0136-11 ",.02)
 ;;68084-0136-11
 ;;9002226.02101,"1198,68084-0137-01 ",.01)
 ;;68084-0137-01
 ;;9002226.02101,"1198,68084-0137-01 ",.02)
 ;;68084-0137-01
 ;;9002226.02101,"1198,68084-0137-11 ",.01)
 ;;68084-0137-11
 ;;9002226.02101,"1198,68084-0137-11 ",.02)
 ;;68084-0137-11
 ;;9002226.02101,"1198,68084-0138-01 ",.01)
 ;;68084-0138-01
 ;;9002226.02101,"1198,68084-0138-01 ",.02)
 ;;68084-0138-01
 ;;9002226.02101,"1198,68084-0138-11 ",.01)
 ;;68084-0138-11
 ;;9002226.02101,"1198,68084-0138-11 ",.02)
 ;;68084-0138-11
 ;;9002226.02101,"1198,68115-0158-30 ",.01)
 ;;68115-0158-30
 ;;9002226.02101,"1198,68115-0158-30 ",.02)
 ;;68115-0158-30
 ;;9002226.02101,"1198,68115-0158-60 ",.01)
 ;;68115-0158-60
 ;;9002226.02101,"1198,68115-0158-60 ",.02)
 ;;68115-0158-60
 ;;9002226.02101,"1198,68115-0159-30 ",.01)
 ;;68115-0159-30
 ;;9002226.02101,"1198,68115-0159-30 ",.02)
 ;;68115-0159-30
 ;;9002226.02101,"1198,68115-0159-60 ",.01)
 ;;68115-0159-60
 ;;9002226.02101,"1198,68115-0159-60 ",.02)
 ;;68115-0159-60
 ;;9002226.02101,"1198,68115-0230-30 ",.01)
 ;;68115-0230-30
 ;;9002226.02101,"1198,68115-0230-30 ",.02)
 ;;68115-0230-30
 ;;9002226.02101,"1198,68115-0230-60 ",.01)
 ;;68115-0230-60
 ;;9002226.02101,"1198,68115-0230-60 ",.02)
 ;;68115-0230-60
 ;;9002226.02101,"1198,68115-0231-00 ",.01)
 ;;68115-0231-00
 ;;9002226.02101,"1198,68115-0231-00 ",.02)
 ;;68115-0231-00
 ;;9002226.02101,"1198,68115-0231-30 ",.01)
 ;;68115-0231-30
 ;;9002226.02101,"1198,68115-0231-30 ",.02)
 ;;68115-0231-30
 ;;9002226.02101,"1198,68115-0231-60 ",.01)
 ;;68115-0231-60
 ;;9002226.02101,"1198,68115-0231-60 ",.02)
 ;;68115-0231-60
 ;;9002226.02101,"1198,68115-0231-90 ",.01)
 ;;68115-0231-90
 ;;9002226.02101,"1198,68115-0231-90 ",.02)
 ;;68115-0231-90
 ;;9002226.02101,"1198,68115-0232-30 ",.01)
 ;;68115-0232-30
