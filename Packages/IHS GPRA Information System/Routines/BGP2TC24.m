BGP2TC24 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1195,57664-0242-13 ",.02)
 ;;57664-0242-13
 ;;9002226.02101,"1195,57664-0242-18 ",.01)
 ;;57664-0242-18
 ;;9002226.02101,"1195,57664-0242-18 ",.02)
 ;;57664-0242-18
 ;;9002226.02101,"1195,57664-0242-88 ",.01)
 ;;57664-0242-88
 ;;9002226.02101,"1195,57664-0242-88 ",.02)
 ;;57664-0242-88
 ;;9002226.02101,"1195,57664-0244-13 ",.01)
 ;;57664-0244-13
 ;;9002226.02101,"1195,57664-0244-13 ",.02)
 ;;57664-0244-13
 ;;9002226.02101,"1195,57664-0244-18 ",.01)
 ;;57664-0244-18
 ;;9002226.02101,"1195,57664-0244-18 ",.02)
 ;;57664-0244-18
 ;;9002226.02101,"1195,57664-0244-88 ",.01)
 ;;57664-0244-88
 ;;9002226.02101,"1195,57664-0244-88 ",.02)
 ;;57664-0244-88
 ;;9002226.02101,"1195,57664-0245-13 ",.01)
 ;;57664-0245-13
 ;;9002226.02101,"1195,57664-0245-13 ",.02)
 ;;57664-0245-13
 ;;9002226.02101,"1195,57664-0245-18 ",.01)
 ;;57664-0245-18
 ;;9002226.02101,"1195,57664-0245-18 ",.02)
 ;;57664-0245-18
 ;;9002226.02101,"1195,57664-0245-88 ",.01)
 ;;57664-0245-88
 ;;9002226.02101,"1195,57664-0245-88 ",.02)
 ;;57664-0245-88
 ;;9002226.02101,"1195,57664-0247-13 ",.01)
 ;;57664-0247-13
 ;;9002226.02101,"1195,57664-0247-13 ",.02)
 ;;57664-0247-13
 ;;9002226.02101,"1195,57664-0247-18 ",.01)
 ;;57664-0247-18
 ;;9002226.02101,"1195,57664-0247-18 ",.02)
 ;;57664-0247-18
 ;;9002226.02101,"1195,57664-0247-88 ",.01)
 ;;57664-0247-88
 ;;9002226.02101,"1195,57664-0247-88 ",.02)
 ;;57664-0247-88
 ;;9002226.02101,"1195,57664-0264-18 ",.01)
 ;;57664-0264-18
 ;;9002226.02101,"1195,57664-0264-18 ",.02)
 ;;57664-0264-18
 ;;9002226.02101,"1195,57664-0264-88 ",.01)
 ;;57664-0264-88
 ;;9002226.02101,"1195,57664-0264-88 ",.02)
 ;;57664-0264-88
 ;;9002226.02101,"1195,57664-0265-18 ",.01)
 ;;57664-0265-18
 ;;9002226.02101,"1195,57664-0265-18 ",.02)
 ;;57664-0265-18
 ;;9002226.02101,"1195,57664-0265-88 ",.01)
 ;;57664-0265-88
 ;;9002226.02101,"1195,57664-0265-88 ",.02)
 ;;57664-0265-88
 ;;9002226.02101,"1195,57664-0266-18 ",.01)
 ;;57664-0266-18
 ;;9002226.02101,"1195,57664-0266-18 ",.02)
 ;;57664-0266-18
 ;;9002226.02101,"1195,57664-0266-88 ",.01)
 ;;57664-0266-88
 ;;9002226.02101,"1195,57664-0266-88 ",.02)
 ;;57664-0266-88
 ;;9002226.02101,"1195,57664-0477-08 ",.01)
 ;;57664-0477-08
 ;;9002226.02101,"1195,57664-0477-08 ",.02)
 ;;57664-0477-08
 ;;9002226.02101,"1195,57664-0477-18 ",.01)
 ;;57664-0477-18
 ;;9002226.02101,"1195,57664-0477-18 ",.02)
 ;;57664-0477-18
 ;;9002226.02101,"1195,57664-0477-52 ",.01)
 ;;57664-0477-52
 ;;9002226.02101,"1195,57664-0477-52 ",.02)
 ;;57664-0477-52
 ;;9002226.02101,"1195,57664-0477-58 ",.01)
 ;;57664-0477-58
 ;;9002226.02101,"1195,57664-0477-58 ",.02)
 ;;57664-0477-58
 ;;9002226.02101,"1195,57664-0506-08 ",.01)
 ;;57664-0506-08
 ;;9002226.02101,"1195,57664-0506-08 ",.02)
 ;;57664-0506-08
 ;;9002226.02101,"1195,57664-0506-18 ",.01)
 ;;57664-0506-18
 ;;9002226.02101,"1195,57664-0506-18 ",.02)
 ;;57664-0506-18
 ;;9002226.02101,"1195,57664-0506-52 ",.01)
 ;;57664-0506-52
 ;;9002226.02101,"1195,57664-0506-52 ",.02)
 ;;57664-0506-52
 ;;9002226.02101,"1195,57664-0506-58 ",.01)
 ;;57664-0506-58
 ;;9002226.02101,"1195,57664-0506-58 ",.02)
 ;;57664-0506-58
 ;;9002226.02101,"1195,57866-0219-01 ",.01)
 ;;57866-0219-01
 ;;9002226.02101,"1195,57866-0219-01 ",.02)
 ;;57866-0219-01
 ;;9002226.02101,"1195,57866-0251-01 ",.01)
 ;;57866-0251-01
 ;;9002226.02101,"1195,57866-0251-01 ",.02)
 ;;57866-0251-01
 ;;9002226.02101,"1195,57866-2607-02 ",.01)
 ;;57866-2607-02
 ;;9002226.02101,"1195,57866-2607-02 ",.02)
 ;;57866-2607-02
 ;;9002226.02101,"1195,57866-2608-02 ",.01)
 ;;57866-2608-02
 ;;9002226.02101,"1195,57866-2608-02 ",.02)
 ;;57866-2608-02
 ;;9002226.02101,"1195,57866-3155-01 ",.01)
 ;;57866-3155-01
 ;;9002226.02101,"1195,57866-3155-01 ",.02)
 ;;57866-3155-01
 ;;9002226.02101,"1195,57866-3330-01 ",.01)
 ;;57866-3330-01
 ;;9002226.02101,"1195,57866-3330-01 ",.02)
 ;;57866-3330-01
 ;;9002226.02101,"1195,57866-3330-03 ",.01)
 ;;57866-3330-03
 ;;9002226.02101,"1195,57866-3330-03 ",.02)
 ;;57866-3330-03
 ;;9002226.02101,"1195,57866-3330-05 ",.01)
 ;;57866-3330-05
 ;;9002226.02101,"1195,57866-3330-05 ",.02)
 ;;57866-3330-05
 ;;9002226.02101,"1195,57866-3331-01 ",.01)
 ;;57866-3331-01
 ;;9002226.02101,"1195,57866-3331-01 ",.02)
 ;;57866-3331-01
 ;;9002226.02101,"1195,57866-3331-02 ",.01)
 ;;57866-3331-02
 ;;9002226.02101,"1195,57866-3331-02 ",.02)
 ;;57866-3331-02
 ;;9002226.02101,"1195,57866-3331-03 ",.01)
 ;;57866-3331-03
 ;;9002226.02101,"1195,57866-3331-03 ",.02)
 ;;57866-3331-03
 ;;9002226.02101,"1195,57866-3332-01 ",.01)
 ;;57866-3332-01
 ;;9002226.02101,"1195,57866-3332-01 ",.02)
 ;;57866-3332-01
 ;;9002226.02101,"1195,57866-3332-03 ",.01)
 ;;57866-3332-03
 ;;9002226.02101,"1195,57866-3332-03 ",.02)
 ;;57866-3332-03
 ;;9002226.02101,"1195,57866-4309-01 ",.01)
 ;;57866-4309-01
 ;;9002226.02101,"1195,57866-4309-01 ",.02)
 ;;57866-4309-01
 ;;9002226.02101,"1195,57866-4313-01 ",.01)
 ;;57866-4313-01
 ;;9002226.02101,"1195,57866-4313-01 ",.02)
 ;;57866-4313-01
 ;;9002226.02101,"1195,57866-4313-04 ",.01)
 ;;57866-4313-04
 ;;9002226.02101,"1195,57866-4313-04 ",.02)
 ;;57866-4313-04
 ;;9002226.02101,"1195,57866-4314-01 ",.01)
 ;;57866-4314-01
 ;;9002226.02101,"1195,57866-4314-01 ",.02)
 ;;57866-4314-01
 ;;9002226.02101,"1195,57866-4315-01 ",.01)
 ;;57866-4315-01
 ;;9002226.02101,"1195,57866-4315-01 ",.02)
 ;;57866-4315-01
 ;;9002226.02101,"1195,57866-4316-01 ",.01)
 ;;57866-4316-01
 ;;9002226.02101,"1195,57866-4316-01 ",.02)
 ;;57866-4316-01
 ;;9002226.02101,"1195,57866-4655-01 ",.01)
 ;;57866-4655-01
 ;;9002226.02101,"1195,57866-4655-01 ",.02)
 ;;57866-4655-01
 ;;9002226.02101,"1195,57866-4655-02 ",.01)
 ;;57866-4655-02
 ;;9002226.02101,"1195,57866-4655-02 ",.02)
 ;;57866-4655-02
 ;;9002226.02101,"1195,57866-4911-01 ",.01)
 ;;57866-4911-01
 ;;9002226.02101,"1195,57866-4911-01 ",.02)
 ;;57866-4911-01
 ;;9002226.02101,"1195,57866-4912-01 ",.01)
 ;;57866-4912-01
 ;;9002226.02101,"1195,57866-4912-01 ",.02)
 ;;57866-4912-01
 ;;9002226.02101,"1195,57866-4913-01 ",.01)
 ;;57866-4913-01
 ;;9002226.02101,"1195,57866-4913-01 ",.02)
 ;;57866-4913-01
 ;;9002226.02101,"1195,57866-4914-01 ",.01)
 ;;57866-4914-01
 ;;9002226.02101,"1195,57866-4914-01 ",.02)
 ;;57866-4914-01
 ;;9002226.02101,"1195,57866-6337-01 ",.01)
 ;;57866-6337-01
 ;;9002226.02101,"1195,57866-6337-01 ",.02)
 ;;57866-6337-01
 ;;9002226.02101,"1195,57866-6338-01 ",.01)
 ;;57866-6338-01
 ;;9002226.02101,"1195,57866-6338-01 ",.02)
 ;;57866-6338-01
 ;;9002226.02101,"1195,57866-6339-01 ",.01)
 ;;57866-6339-01
 ;;9002226.02101,"1195,57866-6339-01 ",.02)
 ;;57866-6339-01
 ;;9002226.02101,"1195,57866-6578-01 ",.01)
 ;;57866-6578-01
 ;;9002226.02101,"1195,57866-6578-01 ",.02)
 ;;57866-6578-01
 ;;9002226.02101,"1195,57866-6578-02 ",.01)
 ;;57866-6578-02
 ;;9002226.02101,"1195,57866-6578-02 ",.02)
 ;;57866-6578-02
 ;;9002226.02101,"1195,57866-6578-03 ",.01)
 ;;57866-6578-03
 ;;9002226.02101,"1195,57866-6578-03 ",.02)
 ;;57866-6578-03
 ;;9002226.02101,"1195,57866-6578-05 ",.01)
 ;;57866-6578-05
 ;;9002226.02101,"1195,57866-6578-05 ",.02)
 ;;57866-6578-05
 ;;9002226.02101,"1195,57866-6579-01 ",.01)
 ;;57866-6579-01
 ;;9002226.02101,"1195,57866-6579-01 ",.02)
 ;;57866-6579-01
 ;;9002226.02101,"1195,57866-6579-03 ",.01)
 ;;57866-6579-03
 ;;9002226.02101,"1195,57866-6579-03 ",.02)
 ;;57866-6579-03
 ;;9002226.02101,"1195,57866-6622-01 ",.01)
 ;;57866-6622-01
 ;;9002226.02101,"1195,57866-6622-01 ",.02)
 ;;57866-6622-01
 ;;9002226.02101,"1195,57866-6623-01 ",.01)
 ;;57866-6623-01
 ;;9002226.02101,"1195,57866-6623-01 ",.02)
 ;;57866-6623-01
 ;;9002226.02101,"1195,57866-7067-01 ",.01)
 ;;57866-7067-01
 ;;9002226.02101,"1195,57866-7067-01 ",.02)
 ;;57866-7067-01
 ;;9002226.02101,"1195,57866-7067-02 ",.01)
 ;;57866-7067-02
 ;;9002226.02101,"1195,57866-7067-02 ",.02)
 ;;57866-7067-02
 ;;9002226.02101,"1195,57866-7068-01 ",.01)
 ;;57866-7068-01
 ;;9002226.02101,"1195,57866-7068-01 ",.02)
 ;;57866-7068-01
 ;;9002226.02101,"1195,57866-7068-02 ",.01)
 ;;57866-7068-02
 ;;9002226.02101,"1195,57866-7068-02 ",.02)
 ;;57866-7068-02
 ;;9002226.02101,"1195,57866-9803-02 ",.01)
 ;;57866-9803-02
 ;;9002226.02101,"1195,57866-9803-02 ",.02)
 ;;57866-9803-02
 ;;9002226.02101,"1195,58016-0001-00 ",.01)
 ;;58016-0001-00
 ;;9002226.02101,"1195,58016-0001-00 ",.02)
 ;;58016-0001-00
 ;;9002226.02101,"1195,58016-0001-30 ",.01)
 ;;58016-0001-30
 ;;9002226.02101,"1195,58016-0001-30 ",.02)
 ;;58016-0001-30
 ;;9002226.02101,"1195,58016-0001-60 ",.01)
 ;;58016-0001-60
 ;;9002226.02101,"1195,58016-0001-60 ",.02)
 ;;58016-0001-60
 ;;9002226.02101,"1195,58016-0001-90 ",.01)
 ;;58016-0001-90
 ;;9002226.02101,"1195,58016-0001-90 ",.02)
 ;;58016-0001-90
 ;;9002226.02101,"1195,58016-0045-00 ",.01)
 ;;58016-0045-00
 ;;9002226.02101,"1195,58016-0045-00 ",.02)
 ;;58016-0045-00
 ;;9002226.02101,"1195,58016-0045-30 ",.01)
 ;;58016-0045-30
 ;;9002226.02101,"1195,58016-0045-30 ",.02)
 ;;58016-0045-30
 ;;9002226.02101,"1195,58016-0045-60 ",.01)
 ;;58016-0045-60
 ;;9002226.02101,"1195,58016-0045-60 ",.02)
 ;;58016-0045-60
 ;;9002226.02101,"1195,58016-0045-90 ",.01)
 ;;58016-0045-90
 ;;9002226.02101,"1195,58016-0045-90 ",.02)
 ;;58016-0045-90
 ;;9002226.02101,"1195,58016-0136-30 ",.01)
 ;;58016-0136-30
 ;;9002226.02101,"1195,58016-0136-30 ",.02)
 ;;58016-0136-30
 ;;9002226.02101,"1195,58016-0286-00 ",.01)
 ;;58016-0286-00
 ;;9002226.02101,"1195,58016-0286-00 ",.02)
 ;;58016-0286-00
 ;;9002226.02101,"1195,58016-0286-02 ",.01)
 ;;58016-0286-02
 ;;9002226.02101,"1195,58016-0286-02 ",.02)
 ;;58016-0286-02
 ;;9002226.02101,"1195,58016-0286-30 ",.01)
 ;;58016-0286-30
 ;;9002226.02101,"1195,58016-0286-30 ",.02)
 ;;58016-0286-30
 ;;9002226.02101,"1195,58016-0286-60 ",.01)
 ;;58016-0286-60
 ;;9002226.02101,"1195,58016-0286-60 ",.02)
 ;;58016-0286-60
 ;;9002226.02101,"1195,58016-0286-90 ",.01)
 ;;58016-0286-90
 ;;9002226.02101,"1195,58016-0286-90 ",.02)
 ;;58016-0286-90
 ;;9002226.02101,"1195,58016-0300-00 ",.01)
 ;;58016-0300-00
 ;;9002226.02101,"1195,58016-0300-00 ",.02)
 ;;58016-0300-00
 ;;9002226.02101,"1195,58016-0300-30 ",.01)
 ;;58016-0300-30
 ;;9002226.02101,"1195,58016-0300-30 ",.02)
 ;;58016-0300-30
 ;;9002226.02101,"1195,58016-0300-60 ",.01)
 ;;58016-0300-60
 ;;9002226.02101,"1195,58016-0300-60 ",.02)
 ;;58016-0300-60
 ;;9002226.02101,"1195,58016-0300-90 ",.01)
 ;;58016-0300-90
 ;;9002226.02101,"1195,58016-0300-90 ",.02)
 ;;58016-0300-90
 ;;9002226.02101,"1195,58016-0331-00 ",.01)
 ;;58016-0331-00
 ;;9002226.02101,"1195,58016-0331-00 ",.02)
 ;;58016-0331-00
 ;;9002226.02101,"1195,58016-0331-30 ",.01)
 ;;58016-0331-30
 ;;9002226.02101,"1195,58016-0331-30 ",.02)
 ;;58016-0331-30
 ;;9002226.02101,"1195,58016-0331-60 ",.01)
 ;;58016-0331-60
 ;;9002226.02101,"1195,58016-0331-60 ",.02)
 ;;58016-0331-60
 ;;9002226.02101,"1195,58016-0331-90 ",.01)
 ;;58016-0331-90
 ;;9002226.02101,"1195,58016-0331-90 ",.02)
 ;;58016-0331-90
 ;;9002226.02101,"1195,58016-0333-00 ",.01)
 ;;58016-0333-00
 ;;9002226.02101,"1195,58016-0333-00 ",.02)
 ;;58016-0333-00
 ;;9002226.02101,"1195,58016-0333-15 ",.01)
 ;;58016-0333-15
 ;;9002226.02101,"1195,58016-0333-15 ",.02)
 ;;58016-0333-15
 ;;9002226.02101,"1195,58016-0333-30 ",.01)
 ;;58016-0333-30
 ;;9002226.02101,"1195,58016-0333-30 ",.02)
 ;;58016-0333-30
 ;;9002226.02101,"1195,58016-0333-60 ",.01)
 ;;58016-0333-60
 ;;9002226.02101,"1195,58016-0333-60 ",.02)
 ;;58016-0333-60
 ;;9002226.02101,"1195,58016-0373-00 ",.01)
 ;;58016-0373-00
 ;;9002226.02101,"1195,58016-0373-00 ",.02)
 ;;58016-0373-00
 ;;9002226.02101,"1195,58016-0373-02 ",.01)
 ;;58016-0373-02
 ;;9002226.02101,"1195,58016-0373-02 ",.02)
 ;;58016-0373-02
 ;;9002226.02101,"1195,58016-0373-30 ",.01)
 ;;58016-0373-30
 ;;9002226.02101,"1195,58016-0373-30 ",.02)
 ;;58016-0373-30
 ;;9002226.02101,"1195,58016-0373-60 ",.01)
 ;;58016-0373-60
 ;;9002226.02101,"1195,58016-0373-60 ",.02)
 ;;58016-0373-60
 ;;9002226.02101,"1195,58016-0373-90 ",.01)
 ;;58016-0373-90
 ;;9002226.02101,"1195,58016-0373-90 ",.02)
 ;;58016-0373-90
 ;;9002226.02101,"1195,58016-0442-00 ",.01)
 ;;58016-0442-00
 ;;9002226.02101,"1195,58016-0442-00 ",.02)
 ;;58016-0442-00
 ;;9002226.02101,"1195,58016-0442-02 ",.01)
 ;;58016-0442-02
 ;;9002226.02101,"1195,58016-0442-02 ",.02)
 ;;58016-0442-02
 ;;9002226.02101,"1195,58016-0442-30 ",.01)
 ;;58016-0442-30
 ;;9002226.02101,"1195,58016-0442-30 ",.02)
 ;;58016-0442-30
 ;;9002226.02101,"1195,58016-0442-60 ",.01)
 ;;58016-0442-60
 ;;9002226.02101,"1195,58016-0442-60 ",.02)
 ;;58016-0442-60
 ;;9002226.02101,"1195,58016-0442-90 ",.01)
 ;;58016-0442-90
 ;;9002226.02101,"1195,58016-0442-90 ",.02)
 ;;58016-0442-90
 ;;9002226.02101,"1195,58016-0442-99 ",.01)
 ;;58016-0442-99
 ;;9002226.02101,"1195,58016-0442-99 ",.02)
 ;;58016-0442-99
 ;;9002226.02101,"1195,58016-0467-30 ",.01)
 ;;58016-0467-30
 ;;9002226.02101,"1195,58016-0467-30 ",.02)
 ;;58016-0467-30
 ;;9002226.02101,"1195,58016-0526-00 ",.01)
 ;;58016-0526-00
 ;;9002226.02101,"1195,58016-0526-00 ",.02)
 ;;58016-0526-00
 ;;9002226.02101,"1195,58016-0526-02 ",.01)
 ;;58016-0526-02
 ;;9002226.02101,"1195,58016-0526-02 ",.02)
 ;;58016-0526-02
 ;;9002226.02101,"1195,58016-0526-30 ",.01)
 ;;58016-0526-30
 ;;9002226.02101,"1195,58016-0526-30 ",.02)
 ;;58016-0526-30
 ;;9002226.02101,"1195,58016-0526-60 ",.01)
 ;;58016-0526-60
 ;;9002226.02101,"1195,58016-0526-60 ",.02)
 ;;58016-0526-60
 ;;9002226.02101,"1195,58016-0526-90 ",.01)
 ;;58016-0526-90
 ;;9002226.02101,"1195,58016-0526-90 ",.02)
 ;;58016-0526-90
