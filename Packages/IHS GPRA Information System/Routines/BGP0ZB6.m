BGP0ZB6 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAY 23, 2010;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;
 ;;3374
 ;;
 ;;3375
 ;;
 ;;1301
 ;;
 ;;1304
 ;;
 ;;1302
 ;;
 ;;163
 ;;
 ;;3376
 ;;
 ;;3408
 ;;
 ;;1303
 ;;
 ;;2276
 ;;
 ;;2266
 ;;
 ;;479
 ;;
 ;;480
 ;;
 ;;481
 ;;
 ;;3272
 ;;
 ;;3273
 ;;
 ;;2051
 ;;
 ;;2048
 ;;
 ;;2049
 ;;
 ;;2050
 ;;
 ;;180
 ;;
 ;;181
 ;;
 ;;1163
 ;;
 ;;1164
 ;;
 ;;15
 ;;
 ;;868
 ;;
 ;;1460
 ;;
 ;;1461
 ;;
 ;;1462
 ;;
 ;;2741
 ;;
 ;;2742
 ;;
 ;;2743
