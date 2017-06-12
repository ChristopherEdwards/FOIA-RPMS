BGP71T20 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 11, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1218,52959-0212-60 ",.02)
 ;;52959-0212-60
 ;;9002226.02101,"1218,52959-0241-30 ",.01)
 ;;52959-0241-30
 ;;9002226.02101,"1218,52959-0241-30 ",.02)
 ;;52959-0241-30
 ;;9002226.02101,"1218,52959-0253-00 ",.01)
 ;;52959-0253-00
 ;;9002226.02101,"1218,52959-0253-00 ",.02)
 ;;52959-0253-00
 ;;9002226.02101,"1218,52959-0253-20 ",.01)
 ;;52959-0253-20
 ;;9002226.02101,"1218,52959-0253-20 ",.02)
 ;;52959-0253-20
 ;;9002226.02101,"1218,52959-0253-30 ",.01)
 ;;52959-0253-30
 ;;9002226.02101,"1218,52959-0253-30 ",.02)
 ;;52959-0253-30
 ;;9002226.02101,"1218,52959-0253-40 ",.01)
 ;;52959-0253-40
 ;;9002226.02101,"1218,52959-0253-40 ",.02)
 ;;52959-0253-40
 ;;9002226.02101,"1218,52959-0258-30 ",.01)
 ;;52959-0258-30
 ;;9002226.02101,"1218,52959-0258-30 ",.02)
 ;;52959-0258-30
 ;;9002226.02101,"1218,52959-0258-60 ",.01)
 ;;52959-0258-60
 ;;9002226.02101,"1218,52959-0258-60 ",.02)
 ;;52959-0258-60
 ;;9002226.02101,"1218,52959-0280-30 ",.01)
 ;;52959-0280-30
 ;;9002226.02101,"1218,52959-0280-30 ",.02)
 ;;52959-0280-30
 ;;9002226.02101,"1218,52959-0337-10 ",.01)
 ;;52959-0337-10
 ;;9002226.02101,"1218,52959-0337-10 ",.02)
 ;;52959-0337-10
 ;;9002226.02101,"1218,52959-0337-30 ",.01)
 ;;52959-0337-30
 ;;9002226.02101,"1218,52959-0337-30 ",.02)
 ;;52959-0337-30
 ;;9002226.02101,"1218,52959-0463-01 ",.01)
 ;;52959-0463-01
 ;;9002226.02101,"1218,52959-0463-01 ",.02)
 ;;52959-0463-01
 ;;9002226.02101,"1218,52959-0463-30 ",.01)
 ;;52959-0463-30
 ;;9002226.02101,"1218,52959-0463-30 ",.02)
 ;;52959-0463-30
 ;;9002226.02101,"1218,52959-0463-60 ",.01)
 ;;52959-0463-60
 ;;9002226.02101,"1218,52959-0463-60 ",.02)
 ;;52959-0463-60
 ;;9002226.02101,"1218,52959-0543-30 ",.01)
 ;;52959-0543-30
 ;;9002226.02101,"1218,52959-0543-30 ",.02)
 ;;52959-0543-30
 ;;9002226.02101,"1218,52959-0827-30 ",.01)
 ;;52959-0827-30
 ;;9002226.02101,"1218,52959-0827-30 ",.02)
 ;;52959-0827-30
 ;;9002226.02101,"1218,52959-0839-30 ",.01)
 ;;52959-0839-30
 ;;9002226.02101,"1218,52959-0839-30 ",.02)
 ;;52959-0839-30
 ;;9002226.02101,"1218,52959-0839-60 ",.01)
 ;;52959-0839-60
 ;;9002226.02101,"1218,52959-0839-60 ",.02)
 ;;52959-0839-60
 ;;9002226.02101,"1218,52959-0895-60 ",.01)
 ;;52959-0895-60
 ;;9002226.02101,"1218,52959-0895-60 ",.02)
 ;;52959-0895-60
 ;;9002226.02101,"1218,53002-1004-00 ",.01)
 ;;53002-1004-00
 ;;9002226.02101,"1218,53002-1004-00 ",.02)
 ;;53002-1004-00
 ;;9002226.02101,"1218,53002-1004-03 ",.01)
 ;;53002-1004-03
 ;;9002226.02101,"1218,53002-1004-03 ",.02)
 ;;53002-1004-03
 ;;9002226.02101,"1218,53002-1004-06 ",.01)
 ;;53002-1004-06
 ;;9002226.02101,"1218,53002-1004-06 ",.02)
 ;;53002-1004-06
 ;;9002226.02101,"1218,53002-1108-00 ",.01)
 ;;53002-1108-00
 ;;9002226.02101,"1218,53002-1108-00 ",.02)
 ;;53002-1108-00
 ;;9002226.02101,"1218,53002-1108-03 ",.01)
 ;;53002-1108-03
 ;;9002226.02101,"1218,53002-1108-03 ",.02)
 ;;53002-1108-03
 ;;9002226.02101,"1218,53002-1108-06 ",.01)
 ;;53002-1108-06
 ;;9002226.02101,"1218,53002-1108-06 ",.02)
 ;;53002-1108-06
 ;;9002226.02101,"1218,53002-1138-00 ",.01)
 ;;53002-1138-00
 ;;9002226.02101,"1218,53002-1138-00 ",.02)
 ;;53002-1138-00
 ;;9002226.02101,"1218,53002-1138-03 ",.01)
 ;;53002-1138-03
 ;;9002226.02101,"1218,53002-1138-03 ",.02)
 ;;53002-1138-03
 ;;9002226.02101,"1218,53002-1138-06 ",.01)
 ;;53002-1138-06
 ;;9002226.02101,"1218,53002-1138-06 ",.02)
 ;;53002-1138-06
 ;;9002226.02101,"1218,53217-0181-00 ",.01)
 ;;53217-0181-00
 ;;9002226.02101,"1218,53217-0181-00 ",.02)
 ;;53217-0181-00
 ;;9002226.02101,"1218,53217-0181-30 ",.01)
 ;;53217-0181-30
 ;;9002226.02101,"1218,53217-0181-30 ",.02)
 ;;53217-0181-30
 ;;9002226.02101,"1218,53217-0181-90 ",.01)
 ;;53217-0181-90
 ;;9002226.02101,"1218,53217-0181-90 ",.02)
 ;;53217-0181-90
 ;;9002226.02101,"1218,53217-0201-00 ",.01)
 ;;53217-0201-00
 ;;9002226.02101,"1218,53217-0201-00 ",.02)
 ;;53217-0201-00
 ;;9002226.02101,"1218,53217-0201-30 ",.01)
 ;;53217-0201-30
 ;;9002226.02101,"1218,53217-0201-30 ",.02)
 ;;53217-0201-30
 ;;9002226.02101,"1218,53217-0201-60 ",.01)
 ;;53217-0201-60
 ;;9002226.02101,"1218,53217-0201-60 ",.02)
 ;;53217-0201-60
 ;;9002226.02101,"1218,53217-0201-90 ",.01)
 ;;53217-0201-90
 ;;9002226.02101,"1218,53217-0201-90 ",.02)
 ;;53217-0201-90
 ;;9002226.02101,"1218,53489-0529-01 ",.01)
 ;;53489-0529-01
 ;;9002226.02101,"1218,53489-0529-01 ",.02)
 ;;53489-0529-01
 ;;9002226.02101,"1218,53489-0529-10 ",.01)
 ;;53489-0529-10
 ;;9002226.02101,"1218,53489-0529-10 ",.02)
 ;;53489-0529-10
 ;;9002226.02101,"1218,53489-0530-01 ",.01)
 ;;53489-0530-01
 ;;9002226.02101,"1218,53489-0530-01 ",.02)
 ;;53489-0530-01
 ;;9002226.02101,"1218,53489-0530-10 ",.01)
 ;;53489-0530-10
 ;;9002226.02101,"1218,53489-0530-10 ",.02)
 ;;53489-0530-10
 ;;9002226.02101,"1218,53489-0531-01 ",.01)
 ;;53489-0531-01
 ;;9002226.02101,"1218,53489-0531-01 ",.02)
 ;;53489-0531-01
 ;;9002226.02101,"1218,53489-0532-01 ",.01)
 ;;53489-0532-01
 ;;9002226.02101,"1218,53489-0532-01 ",.02)
 ;;53489-0532-01
 ;;9002226.02101,"1218,53489-0536-01 ",.01)
 ;;53489-0536-01
 ;;9002226.02101,"1218,53489-0536-01 ",.02)
 ;;53489-0536-01
 ;;9002226.02101,"1218,53489-0536-10 ",.01)
 ;;53489-0536-10
 ;;9002226.02101,"1218,53489-0536-10 ",.02)
 ;;53489-0536-10
 ;;9002226.02101,"1218,54348-0142-30 ",.01)
 ;;54348-0142-30
 ;;9002226.02101,"1218,54348-0142-30 ",.02)
 ;;54348-0142-30
 ;;9002226.02101,"1218,54458-0300-30 ",.01)
 ;;54458-0300-30
 ;;9002226.02101,"1218,54458-0300-30 ",.02)
 ;;54458-0300-30
 ;;9002226.02101,"1218,54458-0300-31 ",.01)
 ;;54458-0300-31
 ;;9002226.02101,"1218,54458-0300-31 ",.02)
 ;;54458-0300-31
 ;;9002226.02101,"1218,54458-0301-30 ",.01)
 ;;54458-0301-30
 ;;9002226.02101,"1218,54458-0301-30 ",.02)
 ;;54458-0301-30
 ;;9002226.02101,"1218,54458-0301-31 ",.01)
 ;;54458-0301-31
 ;;9002226.02101,"1218,54458-0301-31 ",.02)
 ;;54458-0301-31
 ;;9002226.02101,"1218,54458-0302-30 ",.01)
 ;;54458-0302-30
 ;;9002226.02101,"1218,54458-0302-30 ",.02)
 ;;54458-0302-30
 ;;9002226.02101,"1218,54458-0302-31 ",.01)
 ;;54458-0302-31
 ;;9002226.02101,"1218,54458-0302-31 ",.02)
 ;;54458-0302-31
 ;;9002226.02101,"1218,54569-0557-01 ",.01)
 ;;54569-0557-01
 ;;9002226.02101,"1218,54569-0557-01 ",.02)
 ;;54569-0557-01
 ;;9002226.02101,"1218,54569-0557-02 ",.01)
 ;;54569-0557-02
 ;;9002226.02101,"1218,54569-0557-02 ",.02)
 ;;54569-0557-02
 ;;9002226.02101,"1218,54569-0559-01 ",.01)
 ;;54569-0559-01
 ;;9002226.02101,"1218,54569-0559-01 ",.02)
 ;;54569-0559-01
 ;;9002226.02101,"1218,54569-0559-06 ",.01)
 ;;54569-0559-06
 ;;9002226.02101,"1218,54569-0559-06 ",.02)
 ;;54569-0559-06
 ;;9002226.02101,"1218,54569-0561-01 ",.01)
 ;;54569-0561-01
 ;;9002226.02101,"1218,54569-0561-01 ",.02)
 ;;54569-0561-01
 ;;9002226.02101,"1218,54569-0561-06 ",.01)
 ;;54569-0561-06
 ;;9002226.02101,"1218,54569-0561-06 ",.02)
 ;;54569-0561-06
 ;;9002226.02101,"1218,54569-3097-00 ",.01)
 ;;54569-3097-00
 ;;9002226.02101,"1218,54569-3097-00 ",.02)
 ;;54569-3097-00
 ;;9002226.02101,"1218,54569-3432-00 ",.01)
 ;;54569-3432-00
 ;;9002226.02101,"1218,54569-3432-00 ",.02)
 ;;54569-3432-00
 ;;9002226.02101,"1218,54569-3432-01 ",.01)
 ;;54569-3432-01
 ;;9002226.02101,"1218,54569-3432-01 ",.02)
 ;;54569-3432-01
 ;;9002226.02101,"1218,54569-3432-04 ",.01)
 ;;54569-3432-04
 ;;9002226.02101,"1218,54569-3432-04 ",.02)
 ;;54569-3432-04
 ;;9002226.02101,"1218,54569-3432-07 ",.01)
 ;;54569-3432-07
 ;;9002226.02101,"1218,54569-3432-07 ",.02)
 ;;54569-3432-07
 ;;9002226.02101,"1218,54569-3432-08 ",.01)
 ;;54569-3432-08
 ;;9002226.02101,"1218,54569-3432-08 ",.02)
 ;;54569-3432-08
 ;;9002226.02101,"1218,54569-3654-00 ",.01)
 ;;54569-3654-00
 ;;9002226.02101,"1218,54569-3654-00 ",.02)
 ;;54569-3654-00
 ;;9002226.02101,"1218,54569-3654-03 ",.01)
 ;;54569-3654-03
 ;;9002226.02101,"1218,54569-3654-03 ",.02)
 ;;54569-3654-03
 ;;9002226.02101,"1218,54569-3654-04 ",.01)
 ;;54569-3654-04
 ;;9002226.02101,"1218,54569-3654-04 ",.02)
 ;;54569-3654-04
 ;;9002226.02101,"1218,54569-3654-05 ",.01)
 ;;54569-3654-05
 ;;9002226.02101,"1218,54569-3654-05 ",.02)
 ;;54569-3654-05
 ;;9002226.02101,"1218,54569-3654-06 ",.01)
 ;;54569-3654-06
 ;;9002226.02101,"1218,54569-3654-06 ",.02)
 ;;54569-3654-06
 ;;9002226.02101,"1218,54569-3787-00 ",.01)
 ;;54569-3787-00
 ;;9002226.02101,"1218,54569-3787-00 ",.02)
 ;;54569-3787-00
 ;;9002226.02101,"1218,54569-3787-01 ",.01)
 ;;54569-3787-01
 ;;9002226.02101,"1218,54569-3787-01 ",.02)
 ;;54569-3787-01
 ;;9002226.02101,"1218,54569-3787-04 ",.01)
 ;;54569-3787-04
 ;;9002226.02101,"1218,54569-3787-04 ",.02)
 ;;54569-3787-04
 ;;9002226.02101,"1218,54569-3787-05 ",.01)
 ;;54569-3787-05
 ;;9002226.02101,"1218,54569-3787-05 ",.02)
 ;;54569-3787-05
 ;;9002226.02101,"1218,54569-3788-00 ",.01)
 ;;54569-3788-00
 ;;9002226.02101,"1218,54569-3788-00 ",.02)
 ;;54569-3788-00
 ;;9002226.02101,"1218,54569-3788-01 ",.01)
 ;;54569-3788-01
 ;;9002226.02101,"1218,54569-3788-01 ",.02)
 ;;54569-3788-01
 ;;9002226.02101,"1218,54569-3788-03 ",.01)
 ;;54569-3788-03
 ;;9002226.02101,"1218,54569-3788-03 ",.02)
 ;;54569-3788-03
 ;;9002226.02101,"1218,54569-3788-04 ",.01)
 ;;54569-3788-04
 ;;9002226.02101,"1218,54569-3788-04 ",.02)
 ;;54569-3788-04
 ;;9002226.02101,"1218,54569-3885-00 ",.01)
 ;;54569-3885-00
 ;;9002226.02101,"1218,54569-3885-00 ",.02)
 ;;54569-3885-00
 ;;9002226.02101,"1218,54569-3885-02 ",.01)
 ;;54569-3885-02
 ;;9002226.02101,"1218,54569-3885-02 ",.02)
 ;;54569-3885-02
 ;;9002226.02101,"1218,54569-3885-04 ",.01)
 ;;54569-3885-04
 ;;9002226.02101,"1218,54569-3885-04 ",.02)
 ;;54569-3885-04
 ;;9002226.02101,"1218,54569-3885-05 ",.01)
 ;;54569-3885-05
 ;;9002226.02101,"1218,54569-3885-05 ",.02)
 ;;54569-3885-05
 ;;9002226.02101,"1218,54569-3885-06 ",.01)
 ;;54569-3885-06
 ;;9002226.02101,"1218,54569-3885-06 ",.02)
 ;;54569-3885-06
 ;;9002226.02101,"1218,54569-4441-00 ",.01)
 ;;54569-4441-00
 ;;9002226.02101,"1218,54569-4441-00 ",.02)
 ;;54569-4441-00
 ;;9002226.02101,"1218,54569-4442-00 ",.01)
 ;;54569-4442-00
 ;;9002226.02101,"1218,54569-4442-00 ",.02)
 ;;54569-4442-00
 ;;9002226.02101,"1218,54569-5404-00 ",.01)
 ;;54569-5404-00
 ;;9002226.02101,"1218,54569-5404-00 ",.02)
 ;;54569-5404-00
 ;;9002226.02101,"1218,54569-5404-01 ",.01)
 ;;54569-5404-01
 ;;9002226.02101,"1218,54569-5404-01 ",.02)
 ;;54569-5404-01
 ;;9002226.02101,"1218,54569-5404-02 ",.01)
 ;;54569-5404-02
 ;;9002226.02101,"1218,54569-5404-02 ",.02)
 ;;54569-5404-02
 ;;9002226.02101,"1218,54569-5417-00 ",.01)
 ;;54569-5417-00
 ;;9002226.02101,"1218,54569-5417-00 ",.02)
 ;;54569-5417-00
 ;;9002226.02101,"1218,54569-5417-01 ",.01)
 ;;54569-5417-01
 ;;9002226.02101,"1218,54569-5417-01 ",.02)
 ;;54569-5417-01
 ;;9002226.02101,"1218,54569-5419-00 ",.01)
 ;;54569-5419-00
 ;;9002226.02101,"1218,54569-5419-00 ",.02)
 ;;54569-5419-00
 ;;9002226.02101,"1218,54569-5419-01 ",.01)
 ;;54569-5419-01
 ;;9002226.02101,"1218,54569-5419-01 ",.02)
 ;;54569-5419-01
 ;;9002226.02101,"1218,54569-5870-00 ",.01)
 ;;54569-5870-00
 ;;9002226.02101,"1218,54569-5870-00 ",.02)
 ;;54569-5870-00
 ;;9002226.02101,"1218,54569-5870-01 ",.01)
 ;;54569-5870-01
 ;;9002226.02101,"1218,54569-5870-01 ",.02)
 ;;54569-5870-01
 ;;9002226.02101,"1218,54569-5870-02 ",.01)
 ;;54569-5870-02
 ;;9002226.02101,"1218,54569-5870-02 ",.02)
 ;;54569-5870-02
 ;;9002226.02101,"1218,54569-5954-00 ",.01)
 ;;54569-5954-00
 ;;9002226.02101,"1218,54569-5954-00 ",.02)
 ;;54569-5954-00
 ;;9002226.02101,"1218,54569-5954-01 ",.01)
 ;;54569-5954-01
 ;;9002226.02101,"1218,54569-5954-01 ",.02)
 ;;54569-5954-01
 ;;9002226.02101,"1218,54569-5961-00 ",.01)
 ;;54569-5961-00
 ;;9002226.02101,"1218,54569-5961-00 ",.02)
 ;;54569-5961-00