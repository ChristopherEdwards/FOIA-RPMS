BGP9VXDL ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON MAR 25, 2009 ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"858,017.54 ",.01)
 ;;017.54 
 ;;9002226.02101,"858,017.54 ",.02)
 ;;017.54 
 ;;9002226.02101,"858,017.55 ",.01)
 ;;017.55 
 ;;9002226.02101,"858,017.55 ",.02)
 ;;017.55 
 ;;9002226.02101,"858,017.56 ",.01)
 ;;017.56 
 ;;9002226.02101,"858,017.56 ",.02)
 ;;017.56 
 ;;9002226.02101,"858,017.60 ",.01)
 ;;017.60 
 ;;9002226.02101,"858,017.60 ",.02)
 ;;017.60 
 ;;9002226.02101,"858,017.61 ",.01)
 ;;017.61 
 ;;9002226.02101,"858,017.61 ",.02)
 ;;017.61 
 ;;9002226.02101,"858,017.62 ",.01)
 ;;017.62 
 ;;9002226.02101,"858,017.62 ",.02)
 ;;017.62 
 ;;9002226.02101,"858,017.63 ",.01)
 ;;017.63 
 ;;9002226.02101,"858,017.63 ",.02)
 ;;017.63 
 ;;9002226.02101,"858,017.64 ",.01)
 ;;017.64 
 ;;9002226.02101,"858,017.64 ",.02)
 ;;017.64 
 ;;9002226.02101,"858,017.65 ",.01)
 ;;017.65 
 ;;9002226.02101,"858,017.65 ",.02)
 ;;017.65 
 ;;9002226.02101,"858,017.66 ",.01)
 ;;017.66 
 ;;9002226.02101,"858,017.66 ",.02)
 ;;017.66 
 ;;9002226.02101,"858,017.70 ",.01)
 ;;017.70 
 ;;9002226.02101,"858,017.70 ",.02)
 ;;017.70 
 ;;9002226.02101,"858,017.71 ",.01)
 ;;017.71 
 ;;9002226.02101,"858,017.71 ",.02)
 ;;017.71 
 ;;9002226.02101,"858,017.72 ",.01)
 ;;017.72 
 ;;9002226.02101,"858,017.72 ",.02)
 ;;017.72 
 ;;9002226.02101,"858,017.73 ",.01)
 ;;017.73 
 ;;9002226.02101,"858,017.73 ",.02)
 ;;017.73 
 ;;9002226.02101,"858,017.74 ",.01)
 ;;017.74 
 ;;9002226.02101,"858,017.74 ",.02)
 ;;017.74 
 ;;9002226.02101,"858,017.75 ",.01)
 ;;017.75 
 ;;9002226.02101,"858,017.75 ",.02)
 ;;017.75 
 ;;9002226.02101,"858,017.76 ",.01)
 ;;017.76 
 ;;9002226.02101,"858,017.76 ",.02)
 ;;017.76 
 ;;9002226.02101,"858,017.80 ",.01)
 ;;017.80 
 ;;9002226.02101,"858,017.80 ",.02)
 ;;017.80 
 ;;9002226.02101,"858,017.81 ",.01)
 ;;017.81 
 ;;9002226.02101,"858,017.81 ",.02)
 ;;017.81 
 ;;9002226.02101,"858,017.82 ",.01)
 ;;017.82 
 ;;9002226.02101,"858,017.82 ",.02)
 ;;017.82 
 ;;9002226.02101,"858,017.83 ",.01)
 ;;017.83 
 ;;9002226.02101,"858,017.83 ",.02)
 ;;017.83 
 ;;9002226.02101,"858,017.84 ",.01)
 ;;017.84 
 ;;9002226.02101,"858,017.84 ",.02)
 ;;017.84 
 ;;9002226.02101,"858,017.85 ",.01)
 ;;017.85 
 ;;9002226.02101,"858,017.85 ",.02)
 ;;017.85 
 ;;9002226.02101,"858,017.86 ",.01)
 ;;017.86 
 ;;9002226.02101,"858,017.86 ",.02)
 ;;017.86 
 ;;9002226.02101,"858,017.90 ",.01)
 ;;017.90 
 ;;9002226.02101,"858,017.90 ",.02)
 ;;017.90 
 ;;9002226.02101,"858,017.91 ",.01)
 ;;017.91 
 ;;9002226.02101,"858,017.91 ",.02)
 ;;017.91 
 ;;9002226.02101,"858,017.92 ",.01)
 ;;017.92 
 ;;9002226.02101,"858,017.92 ",.02)
 ;;017.92 
 ;;9002226.02101,"858,017.93 ",.01)
 ;;017.93 
 ;;9002226.02101,"858,017.93 ",.02)
 ;;017.93 
 ;;9002226.02101,"858,017.94 ",.01)
 ;;017.94 
 ;;9002226.02101,"858,017.94 ",.02)
 ;;017.94 
 ;;9002226.02101,"858,017.95 ",.01)
 ;;017.95 
 ;;9002226.02101,"858,017.95 ",.02)
 ;;017.95 
 ;;9002226.02101,"858,017.96 ",.01)
 ;;017.96 
 ;;9002226.02101,"858,017.96 ",.02)
 ;;017.96 
 ;;9002226.02101,"858,018.00 ",.01)
 ;;018.00 
 ;;9002226.02101,"858,018.00 ",.02)
 ;;018.00 
 ;;9002226.02101,"858,018.01 ",.01)
 ;;018.01 
 ;;9002226.02101,"858,018.01 ",.02)
 ;;018.01 
 ;;9002226.02101,"858,018.02 ",.01)
 ;;018.02 
 ;;9002226.02101,"858,018.02 ",.02)
 ;;018.02 
 ;;9002226.02101,"858,018.03 ",.01)
 ;;018.03 
 ;;9002226.02101,"858,018.03 ",.02)
 ;;018.03 
 ;;9002226.02101,"858,018.04 ",.01)
 ;;018.04 
 ;;9002226.02101,"858,018.04 ",.02)
 ;;018.04 
 ;;9002226.02101,"858,018.05 ",.01)
 ;;018.05 
 ;;9002226.02101,"858,018.05 ",.02)
 ;;018.05 
 ;;9002226.02101,"858,018.06 ",.01)
 ;;018.06 
 ;;9002226.02101,"858,018.06 ",.02)
 ;;018.06 
 ;;9002226.02101,"858,018.80 ",.01)
 ;;018.80 
 ;;9002226.02101,"858,018.80 ",.02)
 ;;018.80 
 ;;9002226.02101,"858,018.81 ",.01)
 ;;018.81 
 ;;9002226.02101,"858,018.81 ",.02)
 ;;018.81 
 ;;9002226.02101,"858,018.82 ",.01)
 ;;018.82 
 ;;9002226.02101,"858,018.82 ",.02)
 ;;018.82 
 ;;9002226.02101,"858,018.83 ",.01)
 ;;018.83 
 ;;9002226.02101,"858,018.83 ",.02)
 ;;018.83 
 ;;9002226.02101,"858,018.84 ",.01)
 ;;018.84 
 ;;9002226.02101,"858,018.84 ",.02)
 ;;018.84 
 ;;9002226.02101,"858,018.85 ",.01)
 ;;018.85 
 ;;9002226.02101,"858,018.85 ",.02)
 ;;018.85 
 ;;9002226.02101,"858,018.86 ",.01)
 ;;018.86 
 ;;9002226.02101,"858,018.86 ",.02)
 ;;018.86 
 ;;9002226.02101,"858,018.90 ",.01)
 ;;018.90 
 ;;9002226.02101,"858,018.90 ",.02)
 ;;018.90 
 ;;9002226.02101,"858,018.91 ",.01)
 ;;018.91 
 ;;9002226.02101,"858,018.91 ",.02)
 ;;018.91 
 ;;9002226.02101,"858,018.92 ",.01)
 ;;018.92 
 ;;9002226.02101,"858,018.92 ",.02)
 ;;018.92 
 ;;9002226.02101,"858,018.93 ",.01)
 ;;018.93 
 ;;9002226.02101,"858,018.93 ",.02)
 ;;018.93 
 ;;9002226.02101,"858,018.94 ",.01)
 ;;018.94 
 ;;9002226.02101,"858,018.94 ",.02)
 ;;018.94 
 ;;9002226.02101,"858,018.95 ",.01)
 ;;018.95 
 ;;9002226.02101,"858,018.95 ",.02)
 ;;018.95 
 ;;9002226.02101,"858,018.96 ",.01)
 ;;018.96 
 ;;9002226.02101,"858,018.96 ",.02)
 ;;018.96 
 ;;9002226.02101,"858,020.0 ",.01)
 ;;020.0 
 ;;9002226.02101,"858,020.0 ",.02)
 ;;020.0 
 ;;9002226.02101,"858,020.1 ",.01)
 ;;020.1 