BGP21M9 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1202,49702-0206-13 ",.01)
 ;;49702-0206-13
 ;;9002226.02101,"1202,49702-0206-13 ",.02)
 ;;49702-0206-13
 ;;9002226.02101,"1202,49702-0207-18 ",.01)
 ;;49702-0207-18
 ;;9002226.02101,"1202,49702-0207-18 ",.02)
 ;;49702-0207-18
 ;;9002226.02101,"1202,49702-0209-24 ",.01)
 ;;49702-0209-24
 ;;9002226.02101,"1202,49702-0209-24 ",.02)
 ;;49702-0209-24
 ;;9002226.02101,"1202,49702-0210-17 ",.01)
 ;;49702-0210-17
 ;;9002226.02101,"1202,49702-0210-17 ",.02)
 ;;49702-0210-17
 ;;9002226.02101,"1202,49702-0212-48 ",.01)
 ;;49702-0212-48
 ;;9002226.02101,"1202,49702-0212-48 ",.02)
 ;;49702-0212-48
 ;;9002226.02101,"1202,49702-0214-18 ",.01)
 ;;49702-0214-18
 ;;9002226.02101,"1202,49702-0214-18 ",.02)
 ;;49702-0214-18
 ;;9002226.02101,"1202,49702-0215-18 ",.01)
 ;;49702-0215-18
 ;;9002226.02101,"1202,49702-0215-18 ",.02)
 ;;49702-0215-18
 ;;9002226.02101,"1202,49702-0216-18 ",.01)
 ;;49702-0216-18
 ;;9002226.02101,"1202,49702-0216-18 ",.02)
 ;;49702-0216-18
 ;;9002226.02101,"1202,49702-0217-18 ",.01)
 ;;49702-0217-18
 ;;9002226.02101,"1202,49702-0217-18 ",.02)
 ;;49702-0217-18
 ;;9002226.02101,"1202,49702-0221-18 ",.01)
 ;;49702-0221-18
 ;;9002226.02101,"1202,49702-0221-18 ",.02)
 ;;49702-0221-18
 ;;9002226.02101,"1202,49702-0221-44 ",.01)
 ;;49702-0221-44
 ;;9002226.02101,"1202,49702-0221-44 ",.02)
 ;;49702-0221-44
 ;;9002226.02101,"1202,49702-0222-48 ",.01)
 ;;49702-0222-48
 ;;9002226.02101,"1202,49702-0222-48 ",.02)
 ;;49702-0222-48
 ;;9002226.02101,"1202,49999-0062-06 ",.01)
 ;;49999-0062-06
 ;;9002226.02101,"1202,49999-0062-06 ",.02)
 ;;49999-0062-06
 ;;9002226.02101,"1202,49999-0062-10 ",.01)
 ;;49999-0062-10
 ;;9002226.02101,"1202,49999-0062-10 ",.02)
 ;;49999-0062-10
 ;;9002226.02101,"1202,49999-0062-60 ",.01)
 ;;49999-0062-60
 ;;9002226.02101,"1202,49999-0062-60 ",.02)
 ;;49999-0062-60
 ;;9002226.02101,"1202,49999-0119-06 ",.01)
 ;;49999-0119-06
 ;;9002226.02101,"1202,49999-0119-06 ",.02)
 ;;49999-0119-06
 ;;9002226.02101,"1202,49999-0119-60 ",.01)
 ;;49999-0119-60
 ;;9002226.02101,"1202,49999-0119-60 ",.02)
 ;;49999-0119-60
 ;;9002226.02101,"1202,49999-0386-18 ",.01)
 ;;49999-0386-18
 ;;9002226.02101,"1202,49999-0386-18 ",.02)
 ;;49999-0386-18
 ;;9002226.02101,"1202,49999-0431-03 ",.01)
 ;;49999-0431-03
 ;;9002226.02101,"1202,49999-0431-03 ",.02)
 ;;49999-0431-03
 ;;9002226.02101,"1202,51129-2999-02 ",.01)
 ;;51129-2999-02
 ;;9002226.02101,"1202,51129-2999-02 ",.02)
 ;;51129-2999-02
 ;;9002226.02101,"1202,52959-0134-18 ",.01)
 ;;52959-0134-18
 ;;9002226.02101,"1202,52959-0134-18 ",.02)
 ;;52959-0134-18
 ;;9002226.02101,"1202,52959-0289-06 ",.01)
 ;;52959-0289-06
 ;;9002226.02101,"1202,52959-0289-06 ",.02)
 ;;52959-0289-06
 ;;9002226.02101,"1202,52959-0289-30 ",.01)
 ;;52959-0289-30
 ;;9002226.02101,"1202,52959-0289-30 ",.02)
 ;;52959-0289-30
 ;;9002226.02101,"1202,52959-0387-06 ",.01)
 ;;52959-0387-06
 ;;9002226.02101,"1202,52959-0387-06 ",.02)
 ;;52959-0387-06
 ;;9002226.02101,"1202,52959-0507-12 ",.01)
 ;;52959-0507-12
 ;;9002226.02101,"1202,52959-0507-12 ",.02)
 ;;52959-0507-12
 ;;9002226.02101,"1202,52959-0507-18 ",.01)
 ;;52959-0507-18
 ;;9002226.02101,"1202,52959-0507-18 ",.02)
 ;;52959-0507-18
 ;;9002226.02101,"1202,52959-0507-24 ",.01)
 ;;52959-0507-24
 ;;9002226.02101,"1202,52959-0507-24 ",.02)
 ;;52959-0507-24
 ;;9002226.02101,"1202,52959-0507-30 ",.01)
 ;;52959-0507-30
 ;;9002226.02101,"1202,52959-0507-30 ",.02)
 ;;52959-0507-30
 ;;9002226.02101,"1202,52959-0508-02 ",.01)
 ;;52959-0508-02
 ;;9002226.02101,"1202,52959-0508-02 ",.02)
 ;;52959-0508-02
 ;;9002226.02101,"1202,52959-0508-04 ",.01)
 ;;52959-0508-04
 ;;9002226.02101,"1202,52959-0508-04 ",.02)
 ;;52959-0508-04
 ;;9002226.02101,"1202,52959-0508-06 ",.01)
 ;;52959-0508-06
 ;;9002226.02101,"1202,52959-0508-06 ",.02)
 ;;52959-0508-06
 ;;9002226.02101,"1202,52959-0508-08 ",.01)
 ;;52959-0508-08
 ;;9002226.02101,"1202,52959-0508-08 ",.02)
 ;;52959-0508-08
 ;;9002226.02101,"1202,52959-0508-14 ",.01)
 ;;52959-0508-14
 ;;9002226.02101,"1202,52959-0508-14 ",.02)
 ;;52959-0508-14
 ;;9002226.02101,"1202,52959-0508-15 ",.01)
 ;;52959-0508-15
 ;;9002226.02101,"1202,52959-0508-15 ",.02)
 ;;52959-0508-15
 ;;9002226.02101,"1202,52959-0508-60 ",.01)
 ;;52959-0508-60
 ;;9002226.02101,"1202,52959-0508-60 ",.02)
 ;;52959-0508-60
 ;;9002226.02101,"1202,52959-0509-06 ",.01)
 ;;52959-0509-06
 ;;9002226.02101,"1202,52959-0509-06 ",.02)
 ;;52959-0509-06
 ;;9002226.02101,"1202,52959-0509-12 ",.01)
 ;;52959-0509-12
 ;;9002226.02101,"1202,52959-0509-12 ",.02)
 ;;52959-0509-12
 ;;9002226.02101,"1202,52959-0509-18 ",.01)
 ;;52959-0509-18
 ;;9002226.02101,"1202,52959-0509-18 ",.02)
 ;;52959-0509-18
 ;;9002226.02101,"1202,52959-0509-20 ",.01)
 ;;52959-0509-20
 ;;9002226.02101,"1202,52959-0509-20 ",.02)
 ;;52959-0509-20
 ;;9002226.02101,"1202,52959-0509-24 ",.01)
 ;;52959-0509-24
 ;;9002226.02101,"1202,52959-0509-24 ",.02)
 ;;52959-0509-24
 ;;9002226.02101,"1202,52959-0509-28 ",.01)
 ;;52959-0509-28
 ;;9002226.02101,"1202,52959-0509-28 ",.02)
 ;;52959-0509-28
 ;;9002226.02101,"1202,52959-0509-30 ",.01)
 ;;52959-0509-30
 ;;9002226.02101,"1202,52959-0509-30 ",.02)
 ;;52959-0509-30
 ;;9002226.02101,"1202,52959-0546-02 ",.01)
 ;;52959-0546-02
