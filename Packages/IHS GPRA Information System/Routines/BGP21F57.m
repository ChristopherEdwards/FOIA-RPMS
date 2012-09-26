BGP21F57 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
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
 ;;9002226.02101,"1195,58016-0528-00 ",.01)
 ;;58016-0528-00
 ;;9002226.02101,"1195,58016-0528-00 ",.02)
 ;;58016-0528-00
 ;;9002226.02101,"1195,58016-0528-30 ",.01)
 ;;58016-0528-30
 ;;9002226.02101,"1195,58016-0528-30 ",.02)
 ;;58016-0528-30
 ;;9002226.02101,"1195,58016-0528-60 ",.01)
 ;;58016-0528-60
 ;;9002226.02101,"1195,58016-0528-60 ",.02)
 ;;58016-0528-60
 ;;9002226.02101,"1195,58016-0529-00 ",.01)
 ;;58016-0529-00
 ;;9002226.02101,"1195,58016-0529-00 ",.02)
 ;;58016-0529-00
 ;;9002226.02101,"1195,58016-0529-10 ",.01)
 ;;58016-0529-10
 ;;9002226.02101,"1195,58016-0529-10 ",.02)
 ;;58016-0529-10
 ;;9002226.02101,"1195,58016-0529-30 ",.01)
 ;;58016-0529-30
 ;;9002226.02101,"1195,58016-0529-30 ",.02)
 ;;58016-0529-30
 ;;9002226.02101,"1195,58016-0529-50 ",.01)
 ;;58016-0529-50
 ;;9002226.02101,"1195,58016-0529-50 ",.02)
 ;;58016-0529-50
 ;;9002226.02101,"1195,58016-0531-00 ",.01)
 ;;58016-0531-00
 ;;9002226.02101,"1195,58016-0531-00 ",.02)
 ;;58016-0531-00
 ;;9002226.02101,"1195,58016-0531-30 ",.01)
 ;;58016-0531-30
 ;;9002226.02101,"1195,58016-0531-30 ",.02)
 ;;58016-0531-30
 ;;9002226.02101,"1195,58016-0532-00 ",.01)
 ;;58016-0532-00
 ;;9002226.02101,"1195,58016-0532-00 ",.02)
 ;;58016-0532-00
 ;;9002226.02101,"1195,58016-0532-02 ",.01)
 ;;58016-0532-02
 ;;9002226.02101,"1195,58016-0532-02 ",.02)
 ;;58016-0532-02
 ;;9002226.02101,"1195,58016-0532-60 ",.01)
 ;;58016-0532-60
 ;;9002226.02101,"1195,58016-0532-60 ",.02)
 ;;58016-0532-60
 ;;9002226.02101,"1195,58016-0582-00 ",.01)
 ;;58016-0582-00
 ;;9002226.02101,"1195,58016-0582-00 ",.02)
 ;;58016-0582-00
 ;;9002226.02101,"1195,58016-0582-15 ",.01)
 ;;58016-0582-15
 ;;9002226.02101,"1195,58016-0582-15 ",.02)
 ;;58016-0582-15
 ;;9002226.02101,"1195,58016-0582-20 ",.01)
 ;;58016-0582-20
 ;;9002226.02101,"1195,58016-0582-20 ",.02)
 ;;58016-0582-20
 ;;9002226.02101,"1195,58016-0582-30 ",.01)
 ;;58016-0582-30
 ;;9002226.02101,"1195,58016-0582-30 ",.02)
 ;;58016-0582-30
 ;;9002226.02101,"1195,58016-0582-60 ",.01)
 ;;58016-0582-60
 ;;9002226.02101,"1195,58016-0582-60 ",.02)
 ;;58016-0582-60
 ;;9002226.02101,"1195,58016-0604-00 ",.01)
 ;;58016-0604-00
 ;;9002226.02101,"1195,58016-0604-00 ",.02)
 ;;58016-0604-00
 ;;9002226.02101,"1195,58016-0640-00 ",.01)
 ;;58016-0640-00
 ;;9002226.02101,"1195,58016-0640-00 ",.02)
 ;;58016-0640-00
 ;;9002226.02101,"1195,58016-0640-15 ",.01)
 ;;58016-0640-15
 ;;9002226.02101,"1195,58016-0640-15 ",.02)
 ;;58016-0640-15
 ;;9002226.02101,"1195,58016-0640-20 ",.01)
 ;;58016-0640-20
 ;;9002226.02101,"1195,58016-0640-20 ",.02)
 ;;58016-0640-20
 ;;9002226.02101,"1195,58016-0640-30 ",.01)
 ;;58016-0640-30
 ;;9002226.02101,"1195,58016-0640-30 ",.02)
 ;;58016-0640-30
 ;;9002226.02101,"1195,58016-0771-00 ",.01)
 ;;58016-0771-00
 ;;9002226.02101,"1195,58016-0771-00 ",.02)
 ;;58016-0771-00
 ;;9002226.02101,"1195,58016-0771-12 ",.01)
 ;;58016-0771-12
 ;;9002226.02101,"1195,58016-0771-12 ",.02)
 ;;58016-0771-12
 ;;9002226.02101,"1195,58016-0771-15 ",.01)
 ;;58016-0771-15
 ;;9002226.02101,"1195,58016-0771-15 ",.02)
 ;;58016-0771-15
 ;;9002226.02101,"1195,58016-0771-20 ",.01)
 ;;58016-0771-20
 ;;9002226.02101,"1195,58016-0771-20 ",.02)
 ;;58016-0771-20
