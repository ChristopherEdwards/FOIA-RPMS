BGP2TD49 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1729,67544-0148-80 ",.01)
 ;;67544-0148-80
 ;;9002226.02101,"1729,67544-0148-80 ",.02)
 ;;67544-0148-80
 ;;9002226.02101,"1729,67544-0150-45 ",.01)
 ;;67544-0150-45
 ;;9002226.02101,"1729,67544-0150-45 ",.02)
 ;;67544-0150-45
 ;;9002226.02101,"1729,67544-0150-60 ",.01)
 ;;67544-0150-60
 ;;9002226.02101,"1729,67544-0150-60 ",.02)
 ;;67544-0150-60
 ;;9002226.02101,"1729,67544-0150-73 ",.01)
 ;;67544-0150-73
 ;;9002226.02101,"1729,67544-0150-73 ",.02)
 ;;67544-0150-73
 ;;9002226.02101,"1729,67544-0150-92 ",.01)
 ;;67544-0150-92
 ;;9002226.02101,"1729,67544-0150-92 ",.02)
 ;;67544-0150-92
 ;;9002226.02101,"1729,67544-0159-15 ",.01)
 ;;67544-0159-15
 ;;9002226.02101,"1729,67544-0159-15 ",.02)
 ;;67544-0159-15
 ;;9002226.02101,"1729,67544-0159-30 ",.01)
 ;;67544-0159-30
 ;;9002226.02101,"1729,67544-0159-30 ",.02)
 ;;67544-0159-30
 ;;9002226.02101,"1729,67544-0159-45 ",.01)
 ;;67544-0159-45
 ;;9002226.02101,"1729,67544-0159-45 ",.02)
 ;;67544-0159-45
 ;;9002226.02101,"1729,67544-0159-58 ",.01)
 ;;67544-0159-58
 ;;9002226.02101,"1729,67544-0159-58 ",.02)
 ;;67544-0159-58
 ;;9002226.02101,"1729,67544-0159-60 ",.01)
 ;;67544-0159-60
 ;;9002226.02101,"1729,67544-0159-60 ",.02)
 ;;67544-0159-60
 ;;9002226.02101,"1729,67544-0159-80 ",.01)
 ;;67544-0159-80
 ;;9002226.02101,"1729,67544-0159-80 ",.02)
 ;;67544-0159-80
 ;;9002226.02101,"1729,67544-0160-60 ",.01)
 ;;67544-0160-60
 ;;9002226.02101,"1729,67544-0160-60 ",.02)
 ;;67544-0160-60
 ;;9002226.02101,"1729,67544-0160-80 ",.01)
 ;;67544-0160-80
 ;;9002226.02101,"1729,67544-0160-80 ",.02)
 ;;67544-0160-80
 ;;9002226.02101,"1729,67544-0165-60 ",.01)
 ;;67544-0165-60
 ;;9002226.02101,"1729,67544-0165-60 ",.02)
 ;;67544-0165-60
 ;;9002226.02101,"1729,67544-0165-80 ",.01)
 ;;67544-0165-80
 ;;9002226.02101,"1729,67544-0165-80 ",.02)
 ;;67544-0165-80
 ;;9002226.02101,"1729,67544-0166-80 ",.01)
 ;;67544-0166-80
 ;;9002226.02101,"1729,67544-0166-80 ",.02)
 ;;67544-0166-80
 ;;9002226.02101,"1729,67544-0173-30 ",.01)
 ;;67544-0173-30
 ;;9002226.02101,"1729,67544-0173-30 ",.02)
 ;;67544-0173-30
 ;;9002226.02101,"1729,67544-0173-45 ",.01)
 ;;67544-0173-45
 ;;9002226.02101,"1729,67544-0173-45 ",.02)
 ;;67544-0173-45
 ;;9002226.02101,"1729,67544-0173-53 ",.01)
 ;;67544-0173-53
 ;;9002226.02101,"1729,67544-0173-53 ",.02)
 ;;67544-0173-53
 ;;9002226.02101,"1729,67544-0173-60 ",.01)
 ;;67544-0173-60
 ;;9002226.02101,"1729,67544-0173-60 ",.02)
 ;;67544-0173-60
 ;;9002226.02101,"1729,67544-0174-30 ",.01)
 ;;67544-0174-30
 ;;9002226.02101,"1729,67544-0174-30 ",.02)
 ;;67544-0174-30
 ;;9002226.02101,"1729,67544-0174-45 ",.01)
 ;;67544-0174-45
 ;;9002226.02101,"1729,67544-0174-45 ",.02)
 ;;67544-0174-45
 ;;9002226.02101,"1729,67544-0174-60 ",.01)
 ;;67544-0174-60
 ;;9002226.02101,"1729,67544-0174-60 ",.02)
 ;;67544-0174-60
 ;;9002226.02101,"1729,67544-0174-80 ",.01)
 ;;67544-0174-80
 ;;9002226.02101,"1729,67544-0174-80 ",.02)
 ;;67544-0174-80
 ;;9002226.02101,"1729,67544-0175-80 ",.01)
 ;;67544-0175-80
 ;;9002226.02101,"1729,67544-0175-80 ",.02)
 ;;67544-0175-80
 ;;9002226.02101,"1729,67544-0177-45 ",.01)
 ;;67544-0177-45
 ;;9002226.02101,"1729,67544-0177-45 ",.02)
 ;;67544-0177-45
 ;;9002226.02101,"1729,67544-0192-30 ",.01)
 ;;67544-0192-30
 ;;9002226.02101,"1729,67544-0192-30 ",.02)
 ;;67544-0192-30
 ;;9002226.02101,"1729,67544-0192-45 ",.01)
 ;;67544-0192-45
 ;;9002226.02101,"1729,67544-0192-45 ",.02)
 ;;67544-0192-45
 ;;9002226.02101,"1729,67544-0192-53 ",.01)
 ;;67544-0192-53
 ;;9002226.02101,"1729,67544-0192-53 ",.02)
 ;;67544-0192-53
 ;;9002226.02101,"1729,67544-0192-60 ",.01)
 ;;67544-0192-60
 ;;9002226.02101,"1729,67544-0192-60 ",.02)
 ;;67544-0192-60
 ;;9002226.02101,"1729,67544-0201-45 ",.01)
 ;;67544-0201-45
 ;;9002226.02101,"1729,67544-0201-45 ",.02)
 ;;67544-0201-45
 ;;9002226.02101,"1729,67544-0202-15 ",.01)
 ;;67544-0202-15
 ;;9002226.02101,"1729,67544-0202-15 ",.02)
 ;;67544-0202-15
 ;;9002226.02101,"1729,67544-0202-30 ",.01)
 ;;67544-0202-30
 ;;9002226.02101,"1729,67544-0202-30 ",.02)
 ;;67544-0202-30
 ;;9002226.02101,"1729,67544-0202-45 ",.01)
 ;;67544-0202-45
 ;;9002226.02101,"1729,67544-0202-45 ",.02)
 ;;67544-0202-45
 ;;9002226.02101,"1729,67544-0202-80 ",.01)
 ;;67544-0202-80
 ;;9002226.02101,"1729,67544-0202-80 ",.02)
 ;;67544-0202-80
 ;;9002226.02101,"1729,67544-0212-45 ",.01)
 ;;67544-0212-45
 ;;9002226.02101,"1729,67544-0212-45 ",.02)
 ;;67544-0212-45
 ;;9002226.02101,"1729,67544-0212-53 ",.01)
 ;;67544-0212-53
 ;;9002226.02101,"1729,67544-0212-53 ",.02)
 ;;67544-0212-53
 ;;9002226.02101,"1729,67544-0216-80 ",.01)
 ;;67544-0216-80
 ;;9002226.02101,"1729,67544-0216-80 ",.02)
 ;;67544-0216-80
 ;;9002226.02101,"1729,67544-0218-60 ",.01)
 ;;67544-0218-60
 ;;9002226.02101,"1729,67544-0218-60 ",.02)
 ;;67544-0218-60
 ;;9002226.02101,"1729,67544-0218-82 ",.01)
 ;;67544-0218-82
 ;;9002226.02101,"1729,67544-0218-82 ",.02)
 ;;67544-0218-82
 ;;9002226.02101,"1729,67544-0219-15 ",.01)
 ;;67544-0219-15
 ;;9002226.02101,"1729,67544-0219-15 ",.02)
 ;;67544-0219-15
 ;;9002226.02101,"1729,67544-0219-30 ",.01)
 ;;67544-0219-30
 ;;9002226.02101,"1729,67544-0219-30 ",.02)
 ;;67544-0219-30
 ;;9002226.02101,"1729,67544-0219-45 ",.01)
 ;;67544-0219-45
 ;;9002226.02101,"1729,67544-0219-45 ",.02)
 ;;67544-0219-45
 ;;9002226.02101,"1729,67544-0219-60 ",.01)
 ;;67544-0219-60
 ;;9002226.02101,"1729,67544-0219-60 ",.02)
 ;;67544-0219-60
 ;;9002226.02101,"1729,67544-0234-45 ",.01)
 ;;67544-0234-45
 ;;9002226.02101,"1729,67544-0234-45 ",.02)
 ;;67544-0234-45
 ;;9002226.02101,"1729,67544-0234-53 ",.01)
 ;;67544-0234-53
 ;;9002226.02101,"1729,67544-0234-53 ",.02)
 ;;67544-0234-53
 ;;9002226.02101,"1729,67544-0250-60 ",.01)
 ;;67544-0250-60
 ;;9002226.02101,"1729,67544-0250-60 ",.02)
 ;;67544-0250-60
 ;;9002226.02101,"1729,67544-0276-60 ",.01)
 ;;67544-0276-60
 ;;9002226.02101,"1729,67544-0276-60 ",.02)
 ;;67544-0276-60
 ;;9002226.02101,"1729,67544-0286-80 ",.01)
 ;;67544-0286-80
 ;;9002226.02101,"1729,67544-0286-80 ",.02)
 ;;67544-0286-80
 ;;9002226.02101,"1729,67544-0300-15 ",.01)
 ;;67544-0300-15
 ;;9002226.02101,"1729,67544-0300-15 ",.02)
 ;;67544-0300-15
 ;;9002226.02101,"1729,67544-0300-30 ",.01)
 ;;67544-0300-30
 ;;9002226.02101,"1729,67544-0300-30 ",.02)
 ;;67544-0300-30
 ;;9002226.02101,"1729,67544-0300-45 ",.01)
 ;;67544-0300-45
 ;;9002226.02101,"1729,67544-0300-45 ",.02)
 ;;67544-0300-45
 ;;9002226.02101,"1729,67544-0306-30 ",.01)
 ;;67544-0306-30
 ;;9002226.02101,"1729,67544-0306-30 ",.02)
 ;;67544-0306-30
 ;;9002226.02101,"1729,67544-0306-40 ",.01)
 ;;67544-0306-40
 ;;9002226.02101,"1729,67544-0306-40 ",.02)
 ;;67544-0306-40
 ;;9002226.02101,"1729,67544-0306-45 ",.01)
 ;;67544-0306-45
 ;;9002226.02101,"1729,67544-0306-45 ",.02)
 ;;67544-0306-45
 ;;9002226.02101,"1729,67544-0306-60 ",.01)
 ;;67544-0306-60
 ;;9002226.02101,"1729,67544-0306-60 ",.02)
 ;;67544-0306-60
 ;;9002226.02101,"1729,67544-0311-30 ",.01)
 ;;67544-0311-30
 ;;9002226.02101,"1729,67544-0311-30 ",.02)
 ;;67544-0311-30
 ;;9002226.02101,"1729,67544-0311-45 ",.01)
 ;;67544-0311-45
 ;;9002226.02101,"1729,67544-0311-45 ",.02)
 ;;67544-0311-45
 ;;9002226.02101,"1729,67544-0315-80 ",.01)
 ;;67544-0315-80
 ;;9002226.02101,"1729,67544-0315-80 ",.02)
 ;;67544-0315-80
 ;;9002226.02101,"1729,67544-0321-15 ",.01)
 ;;67544-0321-15
 ;;9002226.02101,"1729,67544-0321-15 ",.02)
 ;;67544-0321-15
 ;;9002226.02101,"1729,67544-0321-30 ",.01)
 ;;67544-0321-30
 ;;9002226.02101,"1729,67544-0321-30 ",.02)
 ;;67544-0321-30
 ;;9002226.02101,"1729,67544-0321-60 ",.01)
 ;;67544-0321-60
 ;;9002226.02101,"1729,67544-0321-60 ",.02)
 ;;67544-0321-60
 ;;9002226.02101,"1729,67544-0322-15 ",.01)
 ;;67544-0322-15
 ;;9002226.02101,"1729,67544-0322-15 ",.02)
 ;;67544-0322-15
 ;;9002226.02101,"1729,67544-0322-30 ",.01)
 ;;67544-0322-30
 ;;9002226.02101,"1729,67544-0322-30 ",.02)
 ;;67544-0322-30
 ;;9002226.02101,"1729,67544-0322-45 ",.01)
 ;;67544-0322-45
 ;;9002226.02101,"1729,67544-0322-45 ",.02)
 ;;67544-0322-45
 ;;9002226.02101,"1729,67544-0322-53 ",.01)
 ;;67544-0322-53
 ;;9002226.02101,"1729,67544-0322-53 ",.02)
 ;;67544-0322-53
 ;;9002226.02101,"1729,67544-0322-60 ",.01)
 ;;67544-0322-60
 ;;9002226.02101,"1729,67544-0322-60 ",.02)
 ;;67544-0322-60
 ;;9002226.02101,"1729,67544-0322-70 ",.01)
 ;;67544-0322-70
 ;;9002226.02101,"1729,67544-0322-70 ",.02)
 ;;67544-0322-70
 ;;9002226.02101,"1729,67544-0322-73 ",.01)
 ;;67544-0322-73
 ;;9002226.02101,"1729,67544-0322-73 ",.02)
 ;;67544-0322-73
 ;;9002226.02101,"1729,67544-0322-80 ",.01)
 ;;67544-0322-80
 ;;9002226.02101,"1729,67544-0322-80 ",.02)
 ;;67544-0322-80
 ;;9002226.02101,"1729,67544-0322-92 ",.01)
 ;;67544-0322-92
 ;;9002226.02101,"1729,67544-0322-92 ",.02)
 ;;67544-0322-92
 ;;9002226.02101,"1729,67544-0322-94 ",.01)
 ;;67544-0322-94
 ;;9002226.02101,"1729,67544-0322-94 ",.02)
 ;;67544-0322-94
 ;;9002226.02101,"1729,67544-0350-80 ",.01)
 ;;67544-0350-80
 ;;9002226.02101,"1729,67544-0350-80 ",.02)
 ;;67544-0350-80
 ;;9002226.02101,"1729,67544-0377-60 ",.01)
 ;;67544-0377-60
 ;;9002226.02101,"1729,67544-0377-60 ",.02)
 ;;67544-0377-60
 ;;9002226.02101,"1729,67544-0380-30 ",.01)
 ;;67544-0380-30
 ;;9002226.02101,"1729,67544-0380-30 ",.02)
 ;;67544-0380-30
 ;;9002226.02101,"1729,67544-0380-60 ",.01)
 ;;67544-0380-60
 ;;9002226.02101,"1729,67544-0380-60 ",.02)
 ;;67544-0380-60
 ;;9002226.02101,"1729,67544-0381-15 ",.01)
 ;;67544-0381-15
 ;;9002226.02101,"1729,67544-0381-15 ",.02)
 ;;67544-0381-15
 ;;9002226.02101,"1729,67544-0381-30 ",.01)
 ;;67544-0381-30
 ;;9002226.02101,"1729,67544-0381-30 ",.02)
 ;;67544-0381-30
 ;;9002226.02101,"1729,67544-0381-45 ",.01)
 ;;67544-0381-45
 ;;9002226.02101,"1729,67544-0381-45 ",.02)
 ;;67544-0381-45
 ;;9002226.02101,"1729,67544-0381-53 ",.01)
 ;;67544-0381-53
 ;;9002226.02101,"1729,67544-0381-53 ",.02)
 ;;67544-0381-53
 ;;9002226.02101,"1729,67544-0381-60 ",.01)
 ;;67544-0381-60
 ;;9002226.02101,"1729,67544-0381-60 ",.02)
 ;;67544-0381-60
 ;;9002226.02101,"1729,67544-0381-70 ",.01)
 ;;67544-0381-70
 ;;9002226.02101,"1729,67544-0381-70 ",.02)
 ;;67544-0381-70
 ;;9002226.02101,"1729,67544-0381-73 ",.01)
 ;;67544-0381-73
 ;;9002226.02101,"1729,67544-0381-73 ",.02)
 ;;67544-0381-73
 ;;9002226.02101,"1729,67544-0381-80 ",.01)
 ;;67544-0381-80
 ;;9002226.02101,"1729,67544-0381-80 ",.02)
 ;;67544-0381-80
 ;;9002226.02101,"1729,67544-0381-92 ",.01)
 ;;67544-0381-92
 ;;9002226.02101,"1729,67544-0381-92 ",.02)
 ;;67544-0381-92
 ;;9002226.02101,"1729,67544-0381-94 ",.01)
 ;;67544-0381-94
 ;;9002226.02101,"1729,67544-0381-94 ",.02)
 ;;67544-0381-94
 ;;9002226.02101,"1729,67544-0382-30 ",.01)
 ;;67544-0382-30
 ;;9002226.02101,"1729,67544-0382-30 ",.02)
 ;;67544-0382-30
 ;;9002226.02101,"1729,67544-0400-45 ",.01)
 ;;67544-0400-45
 ;;9002226.02101,"1729,67544-0400-45 ",.02)
 ;;67544-0400-45
 ;;9002226.02101,"1729,67544-0403-30 ",.01)
 ;;67544-0403-30
 ;;9002226.02101,"1729,67544-0403-30 ",.02)
 ;;67544-0403-30
 ;;9002226.02101,"1729,67544-0404-30 ",.01)
 ;;67544-0404-30
 ;;9002226.02101,"1729,67544-0404-30 ",.02)
 ;;67544-0404-30
 ;;9002226.02101,"1729,67544-0418-30 ",.01)
 ;;67544-0418-30
 ;;9002226.02101,"1729,67544-0418-30 ",.02)
 ;;67544-0418-30
 ;;9002226.02101,"1729,67544-0418-60 ",.01)
 ;;67544-0418-60
 ;;9002226.02101,"1729,67544-0418-60 ",.02)
 ;;67544-0418-60
 ;;9002226.02101,"1729,67544-0418-80 ",.01)
 ;;67544-0418-80
 ;;9002226.02101,"1729,67544-0418-80 ",.02)
 ;;67544-0418-80
 ;;9002226.02101,"1729,67544-0431-15 ",.01)
 ;;67544-0431-15
 ;;9002226.02101,"1729,67544-0431-15 ",.02)
 ;;67544-0431-15
 ;;9002226.02101,"1729,67544-0431-30 ",.01)
 ;;67544-0431-30
 ;;9002226.02101,"1729,67544-0431-30 ",.02)
 ;;67544-0431-30
 ;;9002226.02101,"1729,67544-0431-45 ",.01)
 ;;67544-0431-45
 ;;9002226.02101,"1729,67544-0431-45 ",.02)
 ;;67544-0431-45
 ;;9002226.02101,"1729,67544-0431-53 ",.01)
 ;;67544-0431-53
 ;;9002226.02101,"1729,67544-0431-53 ",.02)
 ;;67544-0431-53
 ;;9002226.02101,"1729,67544-0431-60 ",.01)
 ;;67544-0431-60
 ;;9002226.02101,"1729,67544-0431-60 ",.02)
 ;;67544-0431-60
 ;;9002226.02101,"1729,67544-0431-70 ",.01)
 ;;67544-0431-70
 ;;9002226.02101,"1729,67544-0431-70 ",.02)
 ;;67544-0431-70
 ;;9002226.02101,"1729,67544-0431-73 ",.01)
 ;;67544-0431-73
 ;;9002226.02101,"1729,67544-0431-73 ",.02)
 ;;67544-0431-73
 ;;9002226.02101,"1729,67544-0431-80 ",.01)
 ;;67544-0431-80
 ;;9002226.02101,"1729,67544-0431-80 ",.02)
 ;;67544-0431-80
 ;;9002226.02101,"1729,67544-0431-92 ",.01)
 ;;67544-0431-92
 ;;9002226.02101,"1729,67544-0431-92 ",.02)
 ;;67544-0431-92
 ;;9002226.02101,"1729,67544-0431-94 ",.01)
 ;;67544-0431-94
 ;;9002226.02101,"1729,67544-0431-94 ",.02)
 ;;67544-0431-94
 ;;9002226.02101,"1729,67544-0454-15 ",.01)
 ;;67544-0454-15
 ;;9002226.02101,"1729,67544-0454-15 ",.02)
 ;;67544-0454-15
 ;;9002226.02101,"1729,67544-0454-30 ",.01)
 ;;67544-0454-30
 ;;9002226.02101,"1729,67544-0454-30 ",.02)
 ;;67544-0454-30
 ;;9002226.02101,"1729,67544-0454-40 ",.01)
 ;;67544-0454-40
 ;;9002226.02101,"1729,67544-0454-40 ",.02)
 ;;67544-0454-40
 ;;9002226.02101,"1729,67544-0454-45 ",.01)
 ;;67544-0454-45
 ;;9002226.02101,"1729,67544-0454-45 ",.02)
 ;;67544-0454-45
 ;;9002226.02101,"1729,67544-0454-60 ",.01)
 ;;67544-0454-60
 ;;9002226.02101,"1729,67544-0454-60 ",.02)
 ;;67544-0454-60
 ;;9002226.02101,"1729,67544-0489-15 ",.01)
 ;;67544-0489-15
 ;;9002226.02101,"1729,67544-0489-15 ",.02)
 ;;67544-0489-15
 ;;9002226.02101,"1729,67544-0489-30 ",.01)
 ;;67544-0489-30
