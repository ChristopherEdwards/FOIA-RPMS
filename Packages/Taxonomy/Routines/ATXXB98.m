ATXXB98 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1804,0QWHX7Z ",.02)
 ;;0QWHX7Z 
 ;;9002226.02101,"1804,0QWHX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWHXJZ ",.01)
 ;;0QWHXJZ 
 ;;9002226.02101,"1804,0QWHXJZ ",.02)
 ;;0QWHXJZ 
 ;;9002226.02101,"1804,0QWHXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWHXKZ ",.01)
 ;;0QWHXKZ 
 ;;9002226.02101,"1804,0QWHXKZ ",.02)
 ;;0QWHXKZ 
 ;;9002226.02101,"1804,0QWHXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWJX4Z ",.01)
 ;;0QWJX4Z 
 ;;9002226.02101,"1804,0QWJX4Z ",.02)
 ;;0QWJX4Z 
 ;;9002226.02101,"1804,0QWJX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWJX5Z ",.01)
 ;;0QWJX5Z 
 ;;9002226.02101,"1804,0QWJX5Z ",.02)
 ;;0QWJX5Z 
 ;;9002226.02101,"1804,0QWJX5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWJX7Z ",.01)
 ;;0QWJX7Z 
 ;;9002226.02101,"1804,0QWJX7Z ",.02)
 ;;0QWJX7Z 
 ;;9002226.02101,"1804,0QWJX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWJXJZ ",.01)
 ;;0QWJXJZ 
 ;;9002226.02101,"1804,0QWJXJZ ",.02)
 ;;0QWJXJZ 
 ;;9002226.02101,"1804,0QWJXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWJXKZ ",.01)
 ;;0QWJXKZ 
 ;;9002226.02101,"1804,0QWJXKZ ",.02)
 ;;0QWJXKZ 
 ;;9002226.02101,"1804,0QWJXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWKX4Z ",.01)
 ;;0QWKX4Z 
 ;;9002226.02101,"1804,0QWKX4Z ",.02)
 ;;0QWKX4Z 
 ;;9002226.02101,"1804,0QWKX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWKX5Z ",.01)
 ;;0QWKX5Z 
 ;;9002226.02101,"1804,0QWKX5Z ",.02)
 ;;0QWKX5Z 
 ;;9002226.02101,"1804,0QWKX5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWKX7Z ",.01)
 ;;0QWKX7Z 
 ;;9002226.02101,"1804,0QWKX7Z ",.02)
 ;;0QWKX7Z 
 ;;9002226.02101,"1804,0QWKX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWKXJZ ",.01)
 ;;0QWKXJZ 
 ;;9002226.02101,"1804,0QWKXJZ ",.02)
 ;;0QWKXJZ 
 ;;9002226.02101,"1804,0QWKXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWKXKZ ",.01)
 ;;0QWKXKZ 
 ;;9002226.02101,"1804,0QWKXKZ ",.02)
 ;;0QWKXKZ 
 ;;9002226.02101,"1804,0QWKXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWLX4Z ",.01)
 ;;0QWLX4Z 
 ;;9002226.02101,"1804,0QWLX4Z ",.02)
 ;;0QWLX4Z 
 ;;9002226.02101,"1804,0QWLX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWLX5Z ",.01)
 ;;0QWLX5Z 
 ;;9002226.02101,"1804,0QWLX5Z ",.02)
 ;;0QWLX5Z 
 ;;9002226.02101,"1804,0QWLX5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWLX7Z ",.01)
 ;;0QWLX7Z 
 ;;9002226.02101,"1804,0QWLX7Z ",.02)
 ;;0QWLX7Z 
 ;;9002226.02101,"1804,0QWLX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWLXJZ ",.01)
 ;;0QWLXJZ 
 ;;9002226.02101,"1804,0QWLXJZ ",.02)
 ;;0QWLXJZ 
 ;;9002226.02101,"1804,0QWLXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWLXKZ ",.01)
 ;;0QWLXKZ 
 ;;9002226.02101,"1804,0QWLXKZ ",.02)
 ;;0QWLXKZ 
 ;;9002226.02101,"1804,0QWLXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWMX4Z ",.01)
 ;;0QWMX4Z 
 ;;9002226.02101,"1804,0QWMX4Z ",.02)
 ;;0QWMX4Z 
 ;;9002226.02101,"1804,0QWMX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWMX5Z ",.01)
 ;;0QWMX5Z 
 ;;9002226.02101,"1804,0QWMX5Z ",.02)
 ;;0QWMX5Z 
 ;;9002226.02101,"1804,0QWMX5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWMX7Z ",.01)
 ;;0QWMX7Z 
 ;;9002226.02101,"1804,0QWMX7Z ",.02)
 ;;0QWMX7Z 
 ;;9002226.02101,"1804,0QWMX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWMXJZ ",.01)
 ;;0QWMXJZ 
 ;;9002226.02101,"1804,0QWMXJZ ",.02)
 ;;0QWMXJZ 
 ;;9002226.02101,"1804,0QWMXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWMXKZ ",.01)
 ;;0QWMXKZ 
 ;;9002226.02101,"1804,0QWMXKZ ",.02)
 ;;0QWMXKZ 
 ;;9002226.02101,"1804,0QWMXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWNX4Z ",.01)
 ;;0QWNX4Z 
 ;;9002226.02101,"1804,0QWNX4Z ",.02)
 ;;0QWNX4Z 
 ;;9002226.02101,"1804,0QWNX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWNX5Z ",.01)
 ;;0QWNX5Z 
 ;;9002226.02101,"1804,0QWNX5Z ",.02)
 ;;0QWNX5Z 
 ;;9002226.02101,"1804,0QWNX5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWNX7Z ",.01)
 ;;0QWNX7Z 
 ;;9002226.02101,"1804,0QWNX7Z ",.02)
 ;;0QWNX7Z 
 ;;9002226.02101,"1804,0QWNX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWNXJZ ",.01)
 ;;0QWNXJZ 
 ;;9002226.02101,"1804,0QWNXJZ ",.02)
 ;;0QWNXJZ 
 ;;9002226.02101,"1804,0QWNXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWNXKZ ",.01)
 ;;0QWNXKZ 
 ;;9002226.02101,"1804,0QWNXKZ ",.02)
 ;;0QWNXKZ 
 ;;9002226.02101,"1804,0QWNXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWPX4Z ",.01)
 ;;0QWPX4Z 
 ;;9002226.02101,"1804,0QWPX4Z ",.02)
 ;;0QWPX4Z 
 ;;9002226.02101,"1804,0QWPX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWPX5Z ",.01)
 ;;0QWPX5Z 
 ;;9002226.02101,"1804,0QWPX5Z ",.02)
 ;;0QWPX5Z 
 ;;9002226.02101,"1804,0QWPX5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWPX7Z ",.01)
 ;;0QWPX7Z 
 ;;9002226.02101,"1804,0QWPX7Z ",.02)
 ;;0QWPX7Z 
 ;;9002226.02101,"1804,0QWPX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWPXJZ ",.01)
 ;;0QWPXJZ 
 ;;9002226.02101,"1804,0QWPXJZ ",.02)
 ;;0QWPXJZ 
 ;;9002226.02101,"1804,0QWPXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWPXKZ ",.01)
 ;;0QWPXKZ 
 ;;9002226.02101,"1804,0QWPXKZ ",.02)
 ;;0QWPXKZ 
 ;;9002226.02101,"1804,0QWPXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWQX4Z ",.01)
 ;;0QWQX4Z 
 ;;9002226.02101,"1804,0QWQX4Z ",.02)
 ;;0QWQX4Z 
 ;;9002226.02101,"1804,0QWQX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWQX5Z ",.01)
 ;;0QWQX5Z 
 ;;9002226.02101,"1804,0QWQX5Z ",.02)
 ;;0QWQX5Z 
 ;;9002226.02101,"1804,0QWQX5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWQX7Z ",.01)
 ;;0QWQX7Z 
 ;;9002226.02101,"1804,0QWQX7Z ",.02)
 ;;0QWQX7Z 
 ;;9002226.02101,"1804,0QWQX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWQXJZ ",.01)
 ;;0QWQXJZ 
 ;;9002226.02101,"1804,0QWQXJZ ",.02)
 ;;0QWQXJZ 
 ;;9002226.02101,"1804,0QWQXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWQXKZ ",.01)
 ;;0QWQXKZ 
 ;;9002226.02101,"1804,0QWQXKZ ",.02)
 ;;0QWQXKZ 
 ;;9002226.02101,"1804,0QWQXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWRX4Z ",.01)
 ;;0QWRX4Z 
 ;;9002226.02101,"1804,0QWRX4Z ",.02)
 ;;0QWRX4Z 
 ;;9002226.02101,"1804,0QWRX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWRX5Z ",.01)
 ;;0QWRX5Z 
 ;;9002226.02101,"1804,0QWRX5Z ",.02)
 ;;0QWRX5Z 
 ;;9002226.02101,"1804,0QWRX5Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWRX7Z ",.01)
 ;;0QWRX7Z 
 ;;9002226.02101,"1804,0QWRX7Z ",.02)
 ;;0QWRX7Z 
 ;;9002226.02101,"1804,0QWRX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWRXJZ ",.01)
 ;;0QWRXJZ 
 ;;9002226.02101,"1804,0QWRXJZ ",.02)
 ;;0QWRXJZ 
 ;;9002226.02101,"1804,0QWRXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWRXKZ ",.01)
 ;;0QWRXKZ 
 ;;9002226.02101,"1804,0QWRXKZ ",.02)
 ;;0QWRXKZ 
 ;;9002226.02101,"1804,0QWRXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWSX4Z ",.01)
 ;;0QWSX4Z 
 ;;9002226.02101,"1804,0QWSX4Z ",.02)
 ;;0QWSX4Z 
 ;;9002226.02101,"1804,0QWSX4Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWSX7Z ",.01)
 ;;0QWSX7Z 
 ;;9002226.02101,"1804,0QWSX7Z ",.02)
 ;;0QWSX7Z 
 ;;9002226.02101,"1804,0QWSX7Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWSXJZ ",.01)
 ;;0QWSXJZ 
 ;;9002226.02101,"1804,0QWSXJZ ",.02)
 ;;0QWSXJZ 
 ;;9002226.02101,"1804,0QWSXJZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWSXKZ ",.01)
 ;;0QWSXKZ 
 ;;9002226.02101,"1804,0QWSXKZ ",.02)
 ;;0QWSXKZ 
 ;;9002226.02101,"1804,0QWSXKZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWYX0Z ",.01)
 ;;0QWYX0Z 
 ;;9002226.02101,"1804,0QWYX0Z ",.02)
 ;;0QWYX0Z 
 ;;9002226.02101,"1804,0QWYX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0QWYXMZ ",.01)
 ;;0QWYXMZ 
 ;;9002226.02101,"1804,0QWYXMZ ",.02)
 ;;0QWYXMZ 
 ;;9002226.02101,"1804,0QWYXMZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0R2YX0Z ",.01)
 ;;0R2YX0Z 
 ;;9002226.02101,"1804,0R2YX0Z ",.02)
 ;;0R2YX0Z 
 ;;9002226.02101,"1804,0R2YX0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0R2YXYZ ",.01)
 ;;0R2YXYZ 
 ;;9002226.02101,"1804,0R2YXYZ ",.02)
 ;;0R2YXYZ 
 ;;9002226.02101,"1804,0R2YXYZ ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH003Z ",.01)
 ;;0RH003Z 
 ;;9002226.02101,"1804,0RH003Z ",.02)
 ;;0RH003Z 
 ;;9002226.02101,"1804,0RH003Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH033Z ",.01)
 ;;0RH033Z 
 ;;9002226.02101,"1804,0RH033Z ",.02)
 ;;0RH033Z 
 ;;9002226.02101,"1804,0RH033Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH043Z ",.01)
 ;;0RH043Z 
 ;;9002226.02101,"1804,0RH043Z ",.02)
 ;;0RH043Z 
 ;;9002226.02101,"1804,0RH043Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH103Z ",.01)
 ;;0RH103Z 
 ;;9002226.02101,"1804,0RH103Z ",.02)
 ;;0RH103Z 
 ;;9002226.02101,"1804,0RH103Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH133Z ",.01)
 ;;0RH133Z 
 ;;9002226.02101,"1804,0RH133Z ",.02)
 ;;0RH133Z 
 ;;9002226.02101,"1804,0RH133Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH143Z ",.01)
 ;;0RH143Z 
 ;;9002226.02101,"1804,0RH143Z ",.02)
 ;;0RH143Z 
 ;;9002226.02101,"1804,0RH143Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH303Z ",.01)
 ;;0RH303Z 
 ;;9002226.02101,"1804,0RH303Z ",.02)
 ;;0RH303Z 
 ;;9002226.02101,"1804,0RH303Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH333Z ",.01)
 ;;0RH333Z 
 ;;9002226.02101,"1804,0RH333Z ",.02)
 ;;0RH333Z 
 ;;9002226.02101,"1804,0RH333Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH343Z ",.01)
 ;;0RH343Z 
 ;;9002226.02101,"1804,0RH343Z ",.02)
 ;;0RH343Z 
 ;;9002226.02101,"1804,0RH343Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH403Z ",.01)
 ;;0RH403Z 
 ;;9002226.02101,"1804,0RH403Z ",.02)
 ;;0RH403Z 
 ;;9002226.02101,"1804,0RH403Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH433Z ",.01)
 ;;0RH433Z 
 ;;9002226.02101,"1804,0RH433Z ",.02)
 ;;0RH433Z 
 ;;9002226.02101,"1804,0RH433Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH443Z ",.01)
 ;;0RH443Z 
 ;;9002226.02101,"1804,0RH443Z ",.02)
 ;;0RH443Z 
 ;;9002226.02101,"1804,0RH443Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH503Z ",.01)
 ;;0RH503Z 
 ;;9002226.02101,"1804,0RH503Z ",.02)
 ;;0RH503Z 
 ;;9002226.02101,"1804,0RH503Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH533Z ",.01)
 ;;0RH533Z 
 ;;9002226.02101,"1804,0RH533Z ",.02)
 ;;0RH533Z 
 ;;9002226.02101,"1804,0RH533Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH543Z ",.01)
 ;;0RH543Z 
 ;;9002226.02101,"1804,0RH543Z ",.02)
 ;;0RH543Z 
 ;;9002226.02101,"1804,0RH543Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH603Z ",.01)
 ;;0RH603Z 
 ;;9002226.02101,"1804,0RH603Z ",.02)
 ;;0RH603Z 
 ;;9002226.02101,"1804,0RH603Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH633Z ",.01)
 ;;0RH633Z 
 ;;9002226.02101,"1804,0RH633Z ",.02)
 ;;0RH633Z 
 ;;9002226.02101,"1804,0RH633Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH643Z ",.01)
 ;;0RH643Z 
 ;;9002226.02101,"1804,0RH643Z ",.02)
 ;;0RH643Z 
 ;;9002226.02101,"1804,0RH643Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH903Z ",.01)
 ;;0RH903Z 
 ;;9002226.02101,"1804,0RH903Z ",.02)
 ;;0RH903Z 
 ;;9002226.02101,"1804,0RH903Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH933Z ",.01)
 ;;0RH933Z 
 ;;9002226.02101,"1804,0RH933Z ",.02)
 ;;0RH933Z 
 ;;9002226.02101,"1804,0RH933Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RH943Z ",.01)
 ;;0RH943Z 
 ;;9002226.02101,"1804,0RH943Z ",.02)
 ;;0RH943Z 
 ;;9002226.02101,"1804,0RH943Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RHA03Z ",.01)
 ;;0RHA03Z 
 ;;9002226.02101,"1804,0RHA03Z ",.02)
 ;;0RHA03Z 
 ;;9002226.02101,"1804,0RHA03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RHA33Z ",.01)
 ;;0RHA33Z 
 ;;9002226.02101,"1804,0RHA33Z ",.02)
 ;;0RHA33Z 
 ;;9002226.02101,"1804,0RHA33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RHA43Z ",.01)
 ;;0RHA43Z 
 ;;9002226.02101,"1804,0RHA43Z ",.02)
 ;;0RHA43Z 
 ;;9002226.02101,"1804,0RHA43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RHB03Z ",.01)
 ;;0RHB03Z 
 ;;9002226.02101,"1804,0RHB03Z ",.02)
 ;;0RHB03Z 
 ;;9002226.02101,"1804,0RHB03Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RHB33Z ",.01)
 ;;0RHB33Z 
 ;;9002226.02101,"1804,0RHB33Z ",.02)
 ;;0RHB33Z 
 ;;9002226.02101,"1804,0RHB33Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RHB43Z ",.01)
 ;;0RHB43Z 
 ;;9002226.02101,"1804,0RHB43Z ",.02)
 ;;0RHB43Z 
 ;;9002226.02101,"1804,0RHB43Z ",.03)
 ;;31
 ;;9002226.02101,"1804,0RHE03Z ",.01)
 ;;0RHE03Z 
 ;;9002226.02101,"1804,0RHE03Z ",.02)
 ;;0RHE03Z 