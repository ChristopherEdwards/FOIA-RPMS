BGP06M18 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAY 23, 2010;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"977,54868-5344-00 ",.02)
 ;;54868-5344-00
 ;;9002226.02101,"977,54868-5344-01 ",.01)
 ;;54868-5344-01
 ;;9002226.02101,"977,54868-5344-01 ",.02)
 ;;54868-5344-01
 ;;9002226.02101,"977,54868-5344-02 ",.01)
 ;;54868-5344-02
 ;;9002226.02101,"977,54868-5344-02 ",.02)
 ;;54868-5344-02
 ;;9002226.02101,"977,54868-5395-00 ",.01)
 ;;54868-5395-00
 ;;9002226.02101,"977,54868-5395-00 ",.02)
 ;;54868-5395-00
 ;;9002226.02101,"977,54868-5400-00 ",.01)
 ;;54868-5400-00
 ;;9002226.02101,"977,54868-5400-00 ",.02)
 ;;54868-5400-00
 ;;9002226.02101,"977,54868-5400-01 ",.01)
 ;;54868-5400-01
 ;;9002226.02101,"977,54868-5400-01 ",.02)
 ;;54868-5400-01
 ;;9002226.02101,"977,54868-5524-00 ",.01)
 ;;54868-5524-00
 ;;9002226.02101,"977,54868-5524-00 ",.02)
 ;;54868-5524-00
 ;;9002226.02101,"977,54868-5524-01 ",.01)
 ;;54868-5524-01
 ;;9002226.02101,"977,54868-5524-01 ",.02)
 ;;54868-5524-01
 ;;9002226.02101,"977,54868-5549-00 ",.01)
 ;;54868-5549-00
 ;;9002226.02101,"977,54868-5549-00 ",.02)
 ;;54868-5549-00
 ;;9002226.02101,"977,54868-5549-01 ",.01)
 ;;54868-5549-01
 ;;9002226.02101,"977,54868-5549-01 ",.02)
 ;;54868-5549-01
 ;;9002226.02101,"977,54868-5564-00 ",.01)
 ;;54868-5564-00
 ;;9002226.02101,"977,54868-5564-00 ",.02)
 ;;54868-5564-00
 ;;9002226.02101,"977,54868-5564-01 ",.01)
 ;;54868-5564-01
 ;;9002226.02101,"977,54868-5564-01 ",.02)
 ;;54868-5564-01
 ;;9002226.02101,"977,54868-5588-00 ",.01)
 ;;54868-5588-00
 ;;9002226.02101,"977,54868-5588-00 ",.02)
 ;;54868-5588-00
 ;;9002226.02101,"977,54868-5614-00 ",.01)
 ;;54868-5614-00
 ;;9002226.02101,"977,54868-5614-00 ",.02)
 ;;54868-5614-00
 ;;9002226.02101,"977,54868-5729-00 ",.01)
 ;;54868-5729-00
 ;;9002226.02101,"977,54868-5729-00 ",.02)
 ;;54868-5729-00
 ;;9002226.02101,"977,54868-5729-01 ",.01)
 ;;54868-5729-01
 ;;9002226.02101,"977,54868-5729-01 ",.02)
 ;;54868-5729-01
 ;;9002226.02101,"977,54868-5729-02 ",.01)
 ;;54868-5729-02
 ;;9002226.02101,"977,54868-5729-02 ",.02)
 ;;54868-5729-02
 ;;9002226.02101,"977,54868-5729-03 ",.01)
 ;;54868-5729-03
 ;;9002226.02101,"977,54868-5729-03 ",.02)
 ;;54868-5729-03
 ;;9002226.02101,"977,54868-5729-04 ",.01)
 ;;54868-5729-04
 ;;9002226.02101,"977,54868-5729-04 ",.02)
 ;;54868-5729-04
 ;;9002226.02101,"977,54868-5730-00 ",.01)
 ;;54868-5730-00
 ;;9002226.02101,"977,54868-5730-00 ",.02)
 ;;54868-5730-00
 ;;9002226.02101,"977,54868-5730-01 ",.01)
 ;;54868-5730-01
 ;;9002226.02101,"977,54868-5730-01 ",.02)
 ;;54868-5730-01
 ;;9002226.02101,"977,54868-5730-02 ",.01)
 ;;54868-5730-02
 ;;9002226.02101,"977,54868-5730-02 ",.02)
 ;;54868-5730-02
 ;;9002226.02101,"977,54868-5730-03 ",.01)
 ;;54868-5730-03
 ;;9002226.02101,"977,54868-5730-03 ",.02)
 ;;54868-5730-03
 ;;9002226.02101,"977,54868-5731-00 ",.01)
 ;;54868-5731-00
 ;;9002226.02101,"977,54868-5731-00 ",.02)
 ;;54868-5731-00
 ;;9002226.02101,"977,54868-5731-01 ",.01)
 ;;54868-5731-01
 ;;9002226.02101,"977,54868-5731-01 ",.02)
 ;;54868-5731-01
 ;;9002226.02101,"977,54868-5731-02 ",.01)
 ;;54868-5731-02
 ;;9002226.02101,"977,54868-5731-02 ",.02)
 ;;54868-5731-02
 ;;9002226.02101,"977,54868-5731-03 ",.01)
 ;;54868-5731-03
 ;;9002226.02101,"977,54868-5731-03 ",.02)
 ;;54868-5731-03
 ;;9002226.02101,"977,54868-5732-00 ",.01)
 ;;54868-5732-00
 ;;9002226.02101,"977,54868-5732-00 ",.02)
 ;;54868-5732-00
 ;;9002226.02101,"977,54868-5755-00 ",.01)
 ;;54868-5755-00
 ;;9002226.02101,"977,54868-5755-00 ",.02)
 ;;54868-5755-00
 ;;9002226.02101,"977,54868-5755-01 ",.01)
 ;;54868-5755-01
 ;;9002226.02101,"977,54868-5755-01 ",.02)
 ;;54868-5755-01
 ;;9002226.02101,"977,54868-5771-00 ",.01)
 ;;54868-5771-00
 ;;9002226.02101,"977,54868-5771-00 ",.02)
 ;;54868-5771-00
 ;;9002226.02101,"977,54868-5869-00 ",.01)
 ;;54868-5869-00
 ;;9002226.02101,"977,54868-5869-00 ",.02)
 ;;54868-5869-00
 ;;9002226.02101,"977,54921-0101-10 ",.01)
 ;;54921-0101-10
 ;;9002226.02101,"977,54921-0101-10 ",.02)
 ;;54921-0101-10
 ;;9002226.02101,"977,54921-0101-39 ",.01)
 ;;54921-0101-39
 ;;9002226.02101,"977,54921-0101-39 ",.02)
 ;;54921-0101-39
 ;;9002226.02101,"977,54921-0105-10 ",.01)
 ;;54921-0105-10
 ;;9002226.02101,"977,54921-0105-10 ",.02)
 ;;54921-0105-10
 ;;9002226.02101,"977,54921-0105-34 ",.01)
 ;;54921-0105-34
 ;;9002226.02101,"977,54921-0105-34 ",.02)
 ;;54921-0105-34
 ;;9002226.02101,"977,54921-0105-39 ",.01)
 ;;54921-0105-39
 ;;9002226.02101,"977,54921-0105-39 ",.02)
 ;;54921-0105-39
 ;;9002226.02101,"977,54921-0107-10 ",.01)
 ;;54921-0107-10
 ;;9002226.02101,"977,54921-0107-10 ",.02)
 ;;54921-0107-10
 ;;9002226.02101,"977,54921-0115-10 ",.01)
 ;;54921-0115-10
 ;;9002226.02101,"977,54921-0115-10 ",.02)
 ;;54921-0115-10
 ;;9002226.02101,"977,54921-0117-10 ",.01)
 ;;54921-0117-10
 ;;9002226.02101,"977,54921-0117-10 ",.02)
 ;;54921-0117-10
 ;;9002226.02101,"977,55045-1236-07 ",.01)
 ;;55045-1236-07
 ;;9002226.02101,"977,55045-1236-07 ",.02)
 ;;55045-1236-07
 ;;9002226.02101,"977,55045-1236-08 ",.01)
 ;;55045-1236-08
 ;;9002226.02101,"977,55045-1236-08 ",.02)
 ;;55045-1236-08
 ;;9002226.02101,"977,55045-1236-09 ",.01)
 ;;55045-1236-09
 ;;9002226.02101,"977,55045-1236-09 ",.02)
 ;;55045-1236-09
 ;;9002226.02101,"977,55045-1860-01 ",.01)
 ;;55045-1860-01
 ;;9002226.02101,"977,55045-1860-01 ",.02)
 ;;55045-1860-01
 ;;9002226.02101,"977,55045-1860-02 ",.01)
 ;;55045-1860-02
 ;;9002226.02101,"977,55045-1860-02 ",.02)
 ;;55045-1860-02
 ;;9002226.02101,"977,55045-1860-06 ",.01)
 ;;55045-1860-06
 ;;9002226.02101,"977,55045-1860-06 ",.02)
 ;;55045-1860-06
 ;;9002226.02101,"977,55045-1860-08 ",.01)
 ;;55045-1860-08
 ;;9002226.02101,"977,55045-1860-08 ",.02)
 ;;55045-1860-08
 ;;9002226.02101,"977,55045-1860-09 ",.01)
 ;;55045-1860-09
 ;;9002226.02101,"977,55045-1860-09 ",.02)
 ;;55045-1860-09
 ;;9002226.02101,"977,55045-2078-01 ",.01)
 ;;55045-2078-01
 ;;9002226.02101,"977,55045-2078-01 ",.02)
 ;;55045-2078-01
 ;;9002226.02101,"977,55045-2078-06 ",.01)
 ;;55045-2078-06
 ;;9002226.02101,"977,55045-2078-06 ",.02)
 ;;55045-2078-06
 ;;9002226.02101,"977,55045-2078-08 ",.01)
 ;;55045-2078-08
 ;;9002226.02101,"977,55045-2078-08 ",.02)
 ;;55045-2078-08
 ;;9002226.02101,"977,55045-2217-00 ",.01)
 ;;55045-2217-00
 ;;9002226.02101,"977,55045-2217-00 ",.02)
 ;;55045-2217-00
 ;;9002226.02101,"977,55045-2217-02 ",.01)
 ;;55045-2217-02
 ;;9002226.02101,"977,55045-2217-02 ",.02)
 ;;55045-2217-02
 ;;9002226.02101,"977,55045-2217-06 ",.01)
 ;;55045-2217-06
 ;;9002226.02101,"977,55045-2217-06 ",.02)
 ;;55045-2217-06
 ;;9002226.02101,"977,55045-2217-08 ",.01)
 ;;55045-2217-08
 ;;9002226.02101,"977,55045-2217-08 ",.02)
 ;;55045-2217-08
 ;;9002226.02101,"977,55045-2217-09 ",.01)
 ;;55045-2217-09
 ;;9002226.02101,"977,55045-2217-09 ",.02)
 ;;55045-2217-09
 ;;9002226.02101,"977,55045-2269-01 ",.01)
 ;;55045-2269-01
 ;;9002226.02101,"977,55045-2269-01 ",.02)
 ;;55045-2269-01
 ;;9002226.02101,"977,55045-2269-02 ",.01)
 ;;55045-2269-02
 ;;9002226.02101,"977,55045-2269-02 ",.02)
 ;;55045-2269-02
 ;;9002226.02101,"977,55045-2269-06 ",.01)
 ;;55045-2269-06
 ;;9002226.02101,"977,55045-2269-06 ",.02)
 ;;55045-2269-06
 ;;9002226.02101,"977,55045-2269-08 ",.01)
 ;;55045-2269-08
 ;;9002226.02101,"977,55045-2269-08 ",.02)
 ;;55045-2269-08
 ;;9002226.02101,"977,55045-2269-09 ",.01)
 ;;55045-2269-09
 ;;9002226.02101,"977,55045-2269-09 ",.02)
 ;;55045-2269-09
 ;;9002226.02101,"977,55045-2282-00 ",.01)
 ;;55045-2282-00
 ;;9002226.02101,"977,55045-2282-00 ",.02)
 ;;55045-2282-00
 ;;9002226.02101,"977,55045-2282-02 ",.01)
 ;;55045-2282-02
 ;;9002226.02101,"977,55045-2282-02 ",.02)
 ;;55045-2282-02
 ;;9002226.02101,"977,55045-2282-06 ",.01)
 ;;55045-2282-06
 ;;9002226.02101,"977,55045-2282-06 ",.02)
 ;;55045-2282-06
 ;;9002226.02101,"977,55045-2282-07 ",.01)
 ;;55045-2282-07
 ;;9002226.02101,"977,55045-2282-07 ",.02)
 ;;55045-2282-07
 ;;9002226.02101,"977,55045-2282-08 ",.01)
 ;;55045-2282-08
 ;;9002226.02101,"977,55045-2282-08 ",.02)
 ;;55045-2282-08
 ;;9002226.02101,"977,55045-2282-09 ",.01)
 ;;55045-2282-09
 ;;9002226.02101,"977,55045-2282-09 ",.02)
 ;;55045-2282-09
 ;;9002226.02101,"977,55045-2431-01 ",.01)
 ;;55045-2431-01
 ;;9002226.02101,"977,55045-2431-01 ",.02)
 ;;55045-2431-01
 ;;9002226.02101,"977,55045-2431-08 ",.01)
 ;;55045-2431-08
 ;;9002226.02101,"977,55045-2431-08 ",.02)
 ;;55045-2431-08
 ;;9002226.02101,"977,55045-2498-01 ",.01)
 ;;55045-2498-01
 ;;9002226.02101,"977,55045-2498-01 ",.02)
 ;;55045-2498-01
 ;;9002226.02101,"977,55045-2498-08 ",.01)
 ;;55045-2498-08
 ;;9002226.02101,"977,55045-2498-08 ",.02)
 ;;55045-2498-08
 ;;9002226.02101,"977,55045-2755-08 ",.01)
 ;;55045-2755-08
 ;;9002226.02101,"977,55045-2755-08 ",.02)
 ;;55045-2755-08
 ;;9002226.02101,"977,55045-2990-08 ",.01)
 ;;55045-2990-08
 ;;9002226.02101,"977,55045-2990-08 ",.02)
 ;;55045-2990-08
 ;;9002226.02101,"977,55045-3006-08 ",.01)
 ;;55045-3006-08
 ;;9002226.02101,"977,55045-3006-08 ",.02)
 ;;55045-3006-08
 ;;9002226.02101,"977,55045-3160-00 ",.01)
 ;;55045-3160-00
 ;;9002226.02101,"977,55045-3160-00 ",.02)
 ;;55045-3160-00
 ;;9002226.02101,"977,55045-3361-01 ",.01)
 ;;55045-3361-01
 ;;9002226.02101,"977,55045-3361-01 ",.02)
 ;;55045-3361-01
 ;;9002226.02101,"977,55045-3361-08 ",.01)
 ;;55045-3361-08
 ;;9002226.02101,"977,55045-3361-08 ",.02)
 ;;55045-3361-08
 ;;9002226.02101,"977,55045-3371-08 ",.01)
 ;;55045-3371-08
 ;;9002226.02101,"977,55045-3371-08 ",.02)
 ;;55045-3371-08
 ;;9002226.02101,"977,55045-3762-08 ",.01)
 ;;55045-3762-08
 ;;9002226.02101,"977,55045-3762-08 ",.02)
 ;;55045-3762-08
 ;;9002226.02101,"977,55045-3798-01 ",.01)
 ;;55045-3798-01
 ;;9002226.02101,"977,55045-3798-01 ",.02)
 ;;55045-3798-01
 ;;9002226.02101,"977,55111-0252-01 ",.01)
 ;;55111-0252-01
 ;;9002226.02101,"977,55111-0252-01 ",.02)
 ;;55111-0252-01
 ;;9002226.02101,"977,55111-0252-05 ",.01)
 ;;55111-0252-05
 ;;9002226.02101,"977,55111-0252-05 ",.02)
 ;;55111-0252-05
 ;;9002226.02101,"977,55111-0253-01 ",.01)
 ;;55111-0253-01
 ;;9002226.02101,"977,55111-0253-01 ",.02)
 ;;55111-0253-01
 ;;9002226.02101,"977,55111-0253-05 ",.01)
 ;;55111-0253-05
 ;;9002226.02101,"977,55111-0253-05 ",.02)
 ;;55111-0253-05
 ;;9002226.02101,"977,55111-0254-01 ",.01)
 ;;55111-0254-01
 ;;9002226.02101,"977,55111-0254-01 ",.02)
 ;;55111-0254-01
 ;;9002226.02101,"977,55111-0254-05 ",.01)
 ;;55111-0254-05
 ;;9002226.02101,"977,55111-0254-05 ",.02)
 ;;55111-0254-05
 ;;9002226.02101,"977,55111-0255-01 ",.01)
 ;;55111-0255-01
 ;;9002226.02101,"977,55111-0255-01 ",.02)
 ;;55111-0255-01
 ;;9002226.02101,"977,55111-0255-05 ",.01)
 ;;55111-0255-05
 ;;9002226.02101,"977,55111-0255-05 ",.02)
 ;;55111-0255-05
 ;;9002226.02101,"977,55289-0093-30 ",.01)
 ;;55289-0093-30
 ;;9002226.02101,"977,55289-0093-30 ",.02)
 ;;55289-0093-30
 ;;9002226.02101,"977,55289-0093-90 ",.01)
 ;;55289-0093-90
 ;;9002226.02101,"977,55289-0093-90 ",.02)
 ;;55289-0093-90
 ;;9002226.02101,"977,55289-0093-93 ",.01)
 ;;55289-0093-93
 ;;9002226.02101,"977,55289-0093-93 ",.02)
 ;;55289-0093-93
 ;;9002226.02101,"977,55289-0093-97 ",.01)
 ;;55289-0093-97
 ;;9002226.02101,"977,55289-0093-97 ",.02)
 ;;55289-0093-97
 ;;9002226.02101,"977,55289-0096-50 ",.01)
 ;;55289-0096-50
 ;;9002226.02101,"977,55289-0096-50 ",.02)
 ;;55289-0096-50
 ;;9002226.02101,"977,55289-0131-97 ",.01)
 ;;55289-0131-97
 ;;9002226.02101,"977,55289-0131-97 ",.02)
 ;;55289-0131-97
 ;;9002226.02101,"977,55289-0171-30 ",.01)
 ;;55289-0171-30
 ;;9002226.02101,"977,55289-0171-30 ",.02)
 ;;55289-0171-30
 ;;9002226.02101,"977,55289-0227-30 ",.01)
 ;;55289-0227-30
 ;;9002226.02101,"977,55289-0227-30 ",.02)
 ;;55289-0227-30
 ;;9002226.02101,"977,55289-0227-90 ",.01)
 ;;55289-0227-90
 ;;9002226.02101,"977,55289-0227-90 ",.02)
 ;;55289-0227-90
 ;;9002226.02101,"977,55289-0227-97 ",.01)
 ;;55289-0227-97
 ;;9002226.02101,"977,55289-0227-97 ",.02)
 ;;55289-0227-97
 ;;9002226.02101,"977,55289-0228-01 ",.01)
 ;;55289-0228-01
 ;;9002226.02101,"977,55289-0228-01 ",.02)
 ;;55289-0228-01
 ;;9002226.02101,"977,55289-0228-03 ",.01)
 ;;55289-0228-03
 ;;9002226.02101,"977,55289-0228-03 ",.02)
 ;;55289-0228-03
 ;;9002226.02101,"977,55289-0228-06 ",.01)
 ;;55289-0228-06
 ;;9002226.02101,"977,55289-0228-06 ",.02)
 ;;55289-0228-06
 ;;9002226.02101,"977,55289-0228-14 ",.01)
 ;;55289-0228-14
 ;;9002226.02101,"977,55289-0228-14 ",.02)
 ;;55289-0228-14
 ;;9002226.02101,"977,55289-0228-30 ",.01)
 ;;55289-0228-30
 ;;9002226.02101,"977,55289-0228-30 ",.02)
 ;;55289-0228-30
 ;;9002226.02101,"977,55289-0228-60 ",.01)
 ;;55289-0228-60
 ;;9002226.02101,"977,55289-0228-60 ",.02)
 ;;55289-0228-60
 ;;9002226.02101,"977,55289-0228-90 ",.01)
 ;;55289-0228-90
 ;;9002226.02101,"977,55289-0228-90 ",.02)
 ;;55289-0228-90
 ;;9002226.02101,"977,55289-0228-97 ",.01)
 ;;55289-0228-97
 ;;9002226.02101,"977,55289-0228-97 ",.02)
 ;;55289-0228-97
 ;;9002226.02101,"977,55289-0233-01 ",.01)
 ;;55289-0233-01
 ;;9002226.02101,"977,55289-0233-01 ",.02)
 ;;55289-0233-01
 ;;9002226.02101,"977,55289-0233-10 ",.01)
 ;;55289-0233-10
 ;;9002226.02101,"977,55289-0233-10 ",.02)
 ;;55289-0233-10
 ;;9002226.02101,"977,55289-0233-12 ",.01)
 ;;55289-0233-12
 ;;9002226.02101,"977,55289-0233-12 ",.02)
 ;;55289-0233-12
 ;;9002226.02101,"977,55289-0233-60 ",.01)
 ;;55289-0233-60
 ;;9002226.02101,"977,55289-0233-60 ",.02)
 ;;55289-0233-60
 ;;9002226.02101,"977,55289-0233-90 ",.01)
 ;;55289-0233-90
 ;;9002226.02101,"977,55289-0233-90 ",.02)
 ;;55289-0233-90
 ;;9002226.02101,"977,55289-0233-97 ",.01)
 ;;55289-0233-97