ATXXA62 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"873,S43.214A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.215A ",.01)
 ;;S43.215A
 ;;9002226.02101,"873,S43.215A ",.02)
 ;;S43.215A
 ;;9002226.02101,"873,S43.215A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.216A ",.01)
 ;;S43.216A
 ;;9002226.02101,"873,S43.216A ",.02)
 ;;S43.216A
 ;;9002226.02101,"873,S43.216A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.221A ",.01)
 ;;S43.221A
 ;;9002226.02101,"873,S43.221A ",.02)
 ;;S43.221A
 ;;9002226.02101,"873,S43.221A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.222A ",.01)
 ;;S43.222A
 ;;9002226.02101,"873,S43.222A ",.02)
 ;;S43.222A
 ;;9002226.02101,"873,S43.222A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.223A ",.01)
 ;;S43.223A
 ;;9002226.02101,"873,S43.223A ",.02)
 ;;S43.223A
 ;;9002226.02101,"873,S43.223A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.224A ",.01)
 ;;S43.224A
 ;;9002226.02101,"873,S43.224A ",.02)
 ;;S43.224A
 ;;9002226.02101,"873,S43.224A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.225A ",.01)
 ;;S43.225A
 ;;9002226.02101,"873,S43.225A ",.02)
 ;;S43.225A
 ;;9002226.02101,"873,S43.225A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.226A ",.01)
 ;;S43.226A
 ;;9002226.02101,"873,S43.226A ",.02)
 ;;S43.226A
 ;;9002226.02101,"873,S43.226A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.301A ",.01)
 ;;S43.301A
 ;;9002226.02101,"873,S43.301A ",.02)
 ;;S43.301A
 ;;9002226.02101,"873,S43.301A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.302A ",.01)
 ;;S43.302A
 ;;9002226.02101,"873,S43.302A ",.02)
 ;;S43.302A
 ;;9002226.02101,"873,S43.302A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.303A ",.01)
 ;;S43.303A
 ;;9002226.02101,"873,S43.303A ",.02)
 ;;S43.303A
 ;;9002226.02101,"873,S43.303A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.304A ",.01)
 ;;S43.304A
 ;;9002226.02101,"873,S43.304A ",.02)
 ;;S43.304A
 ;;9002226.02101,"873,S43.304A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.305A ",.01)
 ;;S43.305A
 ;;9002226.02101,"873,S43.305A ",.02)
 ;;S43.305A
 ;;9002226.02101,"873,S43.305A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.306A ",.01)
 ;;S43.306A
 ;;9002226.02101,"873,S43.306A ",.02)
 ;;S43.306A
 ;;9002226.02101,"873,S43.306A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.311A ",.01)
 ;;S43.311A
 ;;9002226.02101,"873,S43.311A ",.02)
 ;;S43.311A
 ;;9002226.02101,"873,S43.311A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.312A ",.01)
 ;;S43.312A
 ;;9002226.02101,"873,S43.312A ",.02)
 ;;S43.312A
 ;;9002226.02101,"873,S43.312A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.313A ",.01)
 ;;S43.313A
 ;;9002226.02101,"873,S43.313A ",.02)
 ;;S43.313A
 ;;9002226.02101,"873,S43.313A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.314A ",.01)
 ;;S43.314A
 ;;9002226.02101,"873,S43.314A ",.02)
 ;;S43.314A
 ;;9002226.02101,"873,S43.314A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.315A ",.01)
 ;;S43.315A
 ;;9002226.02101,"873,S43.315A ",.02)
 ;;S43.315A
 ;;9002226.02101,"873,S43.315A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.316A ",.01)
 ;;S43.316A
 ;;9002226.02101,"873,S43.316A ",.02)
 ;;S43.316A
 ;;9002226.02101,"873,S43.316A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.391A ",.01)
 ;;S43.391A
 ;;9002226.02101,"873,S43.391A ",.02)
 ;;S43.391A
 ;;9002226.02101,"873,S43.391A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.392A ",.01)
 ;;S43.392A
 ;;9002226.02101,"873,S43.392A ",.02)
 ;;S43.392A
 ;;9002226.02101,"873,S43.392A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.393A ",.01)
 ;;S43.393A
 ;;9002226.02101,"873,S43.393A ",.02)
 ;;S43.393A
 ;;9002226.02101,"873,S43.393A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.394A ",.01)
 ;;S43.394A
 ;;9002226.02101,"873,S43.394A ",.02)
 ;;S43.394A
 ;;9002226.02101,"873,S43.394A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.395A ",.01)
 ;;S43.395A
 ;;9002226.02101,"873,S43.395A ",.02)
 ;;S43.395A
 ;;9002226.02101,"873,S43.395A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.396A ",.01)
 ;;S43.396A
 ;;9002226.02101,"873,S43.396A ",.02)
 ;;S43.396A
 ;;9002226.02101,"873,S43.396A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.401A ",.01)
 ;;S43.401A
 ;;9002226.02101,"873,S43.401A ",.02)
 ;;S43.401A
 ;;9002226.02101,"873,S43.401A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.402A ",.01)
 ;;S43.402A
 ;;9002226.02101,"873,S43.402A ",.02)
 ;;S43.402A
 ;;9002226.02101,"873,S43.402A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.409A ",.01)
 ;;S43.409A
 ;;9002226.02101,"873,S43.409A ",.02)
 ;;S43.409A
 ;;9002226.02101,"873,S43.409A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.411A ",.01)
 ;;S43.411A
 ;;9002226.02101,"873,S43.411A ",.02)
 ;;S43.411A
 ;;9002226.02101,"873,S43.411A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.412A ",.01)
 ;;S43.412A
 ;;9002226.02101,"873,S43.412A ",.02)
 ;;S43.412A
 ;;9002226.02101,"873,S43.412A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.419A ",.01)
 ;;S43.419A
 ;;9002226.02101,"873,S43.419A ",.02)
 ;;S43.419A
 ;;9002226.02101,"873,S43.419A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.421A ",.01)
 ;;S43.421A
 ;;9002226.02101,"873,S43.421A ",.02)
 ;;S43.421A
 ;;9002226.02101,"873,S43.421A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.422A ",.01)
 ;;S43.422A
 ;;9002226.02101,"873,S43.422A ",.02)
 ;;S43.422A
 ;;9002226.02101,"873,S43.422A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.429A ",.01)
 ;;S43.429A
 ;;9002226.02101,"873,S43.429A ",.02)
 ;;S43.429A
 ;;9002226.02101,"873,S43.429A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.431A ",.01)
 ;;S43.431A
 ;;9002226.02101,"873,S43.431A ",.02)
 ;;S43.431A
 ;;9002226.02101,"873,S43.431A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.432A ",.01)
 ;;S43.432A
 ;;9002226.02101,"873,S43.432A ",.02)
 ;;S43.432A
 ;;9002226.02101,"873,S43.432A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.439A ",.01)
 ;;S43.439A
 ;;9002226.02101,"873,S43.439A ",.02)
 ;;S43.439A
 ;;9002226.02101,"873,S43.439A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.491A ",.01)
 ;;S43.491A
 ;;9002226.02101,"873,S43.491A ",.02)
 ;;S43.491A
 ;;9002226.02101,"873,S43.491A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.492A ",.01)
 ;;S43.492A
 ;;9002226.02101,"873,S43.492A ",.02)
 ;;S43.492A
 ;;9002226.02101,"873,S43.492A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.499A ",.01)
 ;;S43.499A
 ;;9002226.02101,"873,S43.499A ",.02)
 ;;S43.499A
 ;;9002226.02101,"873,S43.499A ",.03)
 ;;30
 ;;9002226.02101,"873,S43.50XA ",.01)
 ;;S43.50XA
 ;;9002226.02101,"873,S43.50XA ",.02)
 ;;S43.50XA
 ;;9002226.02101,"873,S43.50XA ",.03)
 ;;30
 ;;9002226.02101,"873,S43.51XA ",.01)
 ;;S43.51XA
 ;;9002226.02101,"873,S43.51XA ",.02)
 ;;S43.51XA
 ;;9002226.02101,"873,S43.51XA ",.03)
 ;;30
 ;;9002226.02101,"873,S43.52XA ",.01)
 ;;S43.52XA
 ;;9002226.02101,"873,S43.52XA ",.02)
 ;;S43.52XA
 ;;9002226.02101,"873,S43.52XA ",.03)
 ;;30
 ;;9002226.02101,"873,S43.60XA ",.01)
 ;;S43.60XA
 ;;9002226.02101,"873,S43.60XA ",.02)
 ;;S43.60XA
 ;;9002226.02101,"873,S43.60XA ",.03)
 ;;30
 ;;9002226.02101,"873,S43.61XA ",.01)
 ;;S43.61XA
 ;;9002226.02101,"873,S43.61XA ",.02)
 ;;S43.61XA
 ;;9002226.02101,"873,S43.61XA ",.03)
 ;;30
 ;;9002226.02101,"873,S43.62XA ",.01)
 ;;S43.62XA
 ;;9002226.02101,"873,S43.62XA ",.02)
 ;;S43.62XA
 ;;9002226.02101,"873,S43.62XA ",.03)
 ;;30
 ;;9002226.02101,"873,S43.80XA ",.01)
 ;;S43.80XA
 ;;9002226.02101,"873,S43.80XA ",.02)
 ;;S43.80XA
 ;;9002226.02101,"873,S43.80XA ",.03)
 ;;30
 ;;9002226.02101,"873,S43.81XA ",.01)
 ;;S43.81XA
 ;;9002226.02101,"873,S43.81XA ",.02)
 ;;S43.81XA
 ;;9002226.02101,"873,S43.81XA ",.03)
 ;;30
 ;;9002226.02101,"873,S43.82XA ",.01)
 ;;S43.82XA
 ;;9002226.02101,"873,S43.82XA ",.02)
 ;;S43.82XA
 ;;9002226.02101,"873,S43.82XA ",.03)
 ;;30
 ;;9002226.02101,"873,S43.90XA ",.01)
 ;;S43.90XA
 ;;9002226.02101,"873,S43.90XA ",.02)
 ;;S43.90XA
 ;;9002226.02101,"873,S43.90XA ",.03)
 ;;30
 ;;9002226.02101,"873,S43.91XA ",.01)
 ;;S43.91XA
 ;;9002226.02101,"873,S43.91XA ",.02)
 ;;S43.91XA
 ;;9002226.02101,"873,S43.91XA ",.03)
 ;;30
 ;;9002226.02101,"873,S43.92XA ",.01)
 ;;S43.92XA
 ;;9002226.02101,"873,S43.92XA ",.02)
 ;;S43.92XA
 ;;9002226.02101,"873,S43.92XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.00XA ",.01)
 ;;S44.00XA
 ;;9002226.02101,"873,S44.00XA ",.02)
 ;;S44.00XA
 ;;9002226.02101,"873,S44.00XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.01XA ",.01)
 ;;S44.01XA
 ;;9002226.02101,"873,S44.01XA ",.02)
 ;;S44.01XA
 ;;9002226.02101,"873,S44.01XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.02XA ",.01)
 ;;S44.02XA
 ;;9002226.02101,"873,S44.02XA ",.02)
 ;;S44.02XA
 ;;9002226.02101,"873,S44.02XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.10XA ",.01)
 ;;S44.10XA
 ;;9002226.02101,"873,S44.10XA ",.02)
 ;;S44.10XA
 ;;9002226.02101,"873,S44.10XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.11XA ",.01)
 ;;S44.11XA
 ;;9002226.02101,"873,S44.11XA ",.02)
 ;;S44.11XA
 ;;9002226.02101,"873,S44.11XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.12XA ",.01)
 ;;S44.12XA
 ;;9002226.02101,"873,S44.12XA ",.02)
 ;;S44.12XA
 ;;9002226.02101,"873,S44.12XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.20XA ",.01)
 ;;S44.20XA
 ;;9002226.02101,"873,S44.20XA ",.02)
 ;;S44.20XA
 ;;9002226.02101,"873,S44.20XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.21XA ",.01)
 ;;S44.21XA
 ;;9002226.02101,"873,S44.21XA ",.02)
 ;;S44.21XA
 ;;9002226.02101,"873,S44.21XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.22XA ",.01)
 ;;S44.22XA
 ;;9002226.02101,"873,S44.22XA ",.02)
 ;;S44.22XA
 ;;9002226.02101,"873,S44.22XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.30XA ",.01)
 ;;S44.30XA
 ;;9002226.02101,"873,S44.30XA ",.02)
 ;;S44.30XA
 ;;9002226.02101,"873,S44.30XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.31XA ",.01)
 ;;S44.31XA
 ;;9002226.02101,"873,S44.31XA ",.02)
 ;;S44.31XA
 ;;9002226.02101,"873,S44.31XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.32XA ",.01)
 ;;S44.32XA
 ;;9002226.02101,"873,S44.32XA ",.02)
 ;;S44.32XA
 ;;9002226.02101,"873,S44.32XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.40XA ",.01)
 ;;S44.40XA
 ;;9002226.02101,"873,S44.40XA ",.02)
 ;;S44.40XA
 ;;9002226.02101,"873,S44.40XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.41XA ",.01)
 ;;S44.41XA
 ;;9002226.02101,"873,S44.41XA ",.02)
 ;;S44.41XA
 ;;9002226.02101,"873,S44.41XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.42XA ",.01)
 ;;S44.42XA
 ;;9002226.02101,"873,S44.42XA ",.02)
 ;;S44.42XA
 ;;9002226.02101,"873,S44.42XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.50XA ",.01)
 ;;S44.50XA
 ;;9002226.02101,"873,S44.50XA ",.02)
 ;;S44.50XA
 ;;9002226.02101,"873,S44.50XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.51XA ",.01)
 ;;S44.51XA
 ;;9002226.02101,"873,S44.51XA ",.02)
 ;;S44.51XA
 ;;9002226.02101,"873,S44.51XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.52XA ",.01)
 ;;S44.52XA
 ;;9002226.02101,"873,S44.52XA ",.02)
 ;;S44.52XA
 ;;9002226.02101,"873,S44.52XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.8X1A ",.01)
 ;;S44.8X1A
 ;;9002226.02101,"873,S44.8X1A ",.02)
 ;;S44.8X1A
 ;;9002226.02101,"873,S44.8X1A ",.03)
 ;;30
 ;;9002226.02101,"873,S44.8X2A ",.01)
 ;;S44.8X2A
 ;;9002226.02101,"873,S44.8X2A ",.02)
 ;;S44.8X2A
 ;;9002226.02101,"873,S44.8X2A ",.03)
 ;;30
 ;;9002226.02101,"873,S44.8X9A ",.01)
 ;;S44.8X9A
 ;;9002226.02101,"873,S44.8X9A ",.02)
 ;;S44.8X9A
 ;;9002226.02101,"873,S44.8X9A ",.03)
 ;;30
 ;;9002226.02101,"873,S44.90XA ",.01)
 ;;S44.90XA
 ;;9002226.02101,"873,S44.90XA ",.02)
 ;;S44.90XA
 ;;9002226.02101,"873,S44.90XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.91XA ",.01)
 ;;S44.91XA
 ;;9002226.02101,"873,S44.91XA ",.02)
 ;;S44.91XA
 ;;9002226.02101,"873,S44.91XA ",.03)
 ;;30
 ;;9002226.02101,"873,S44.92XA ",.01)
 ;;S44.92XA
 ;;9002226.02101,"873,S44.92XA ",.02)
 ;;S44.92XA
 ;;9002226.02101,"873,S44.92XA ",.03)
 ;;30
 ;;9002226.02101,"873,S45.001A ",.01)
 ;;S45.001A
 ;;9002226.02101,"873,S45.001A ",.02)
 ;;S45.001A
 ;;9002226.02101,"873,S45.001A ",.03)
 ;;30