BGP2TA30 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1064,68084-0064-01 ",.02)
 ;;68084-0064-01
 ;;9002226.02101,"1064,68084-0064-11 ",.01)
 ;;68084-0064-11
 ;;9002226.02101,"1064,68084-0064-11 ",.02)
 ;;68084-0064-11
 ;;9002226.02101,"1064,68084-0266-01 ",.01)
 ;;68084-0266-01
 ;;9002226.02101,"1064,68084-0266-01 ",.02)
 ;;68084-0266-01
 ;;9002226.02101,"1064,68084-0266-11 ",.01)
 ;;68084-0266-11
 ;;9002226.02101,"1064,68084-0266-11 ",.02)
 ;;68084-0266-11
 ;;9002226.02101,"1064,68084-0267-01 ",.01)
 ;;68084-0267-01
 ;;9002226.02101,"1064,68084-0267-01 ",.02)
 ;;68084-0267-01
 ;;9002226.02101,"1064,68084-0267-11 ",.01)
 ;;68084-0267-11
 ;;9002226.02101,"1064,68084-0267-11 ",.02)
 ;;68084-0267-11
 ;;9002226.02101,"1064,68084-0268-01 ",.01)
 ;;68084-0268-01
 ;;9002226.02101,"1064,68084-0268-01 ",.02)
 ;;68084-0268-01
 ;;9002226.02101,"1064,68084-0268-11 ",.01)
 ;;68084-0268-11
 ;;9002226.02101,"1064,68084-0268-11 ",.02)
 ;;68084-0268-11
 ;;9002226.02101,"1064,68084-0294-11 ",.01)
 ;;68084-0294-11
 ;;9002226.02101,"1064,68084-0294-11 ",.02)
 ;;68084-0294-11
 ;;9002226.02101,"1064,68084-0294-21 ",.01)
 ;;68084-0294-21
 ;;9002226.02101,"1064,68084-0294-21 ",.02)
 ;;68084-0294-21
 ;;9002226.02101,"1064,68084-0349-11 ",.01)
 ;;68084-0349-11
 ;;9002226.02101,"1064,68084-0349-11 ",.02)
 ;;68084-0349-11
 ;;9002226.02101,"1064,68084-0349-21 ",.01)
 ;;68084-0349-21
 ;;9002226.02101,"1064,68084-0349-21 ",.02)
 ;;68084-0349-21
 ;;9002226.02101,"1064,68084-0350-01 ",.01)
 ;;68084-0350-01
 ;;9002226.02101,"1064,68084-0350-01 ",.02)
 ;;68084-0350-01
 ;;9002226.02101,"1064,68084-0350-11 ",.01)
 ;;68084-0350-11
 ;;9002226.02101,"1064,68084-0350-11 ",.02)
 ;;68084-0350-11
 ;;9002226.02101,"1064,68084-0351-11 ",.01)
 ;;68084-0351-11
 ;;9002226.02101,"1064,68084-0351-11 ",.02)
 ;;68084-0351-11
 ;;9002226.02101,"1064,68084-0351-21 ",.01)
 ;;68084-0351-21
 ;;9002226.02101,"1064,68084-0351-21 ",.02)
 ;;68084-0351-21
 ;;9002226.02101,"1064,68084-0390-01 ",.01)
 ;;68084-0390-01
 ;;9002226.02101,"1064,68084-0390-01 ",.02)
 ;;68084-0390-01
 ;;9002226.02101,"1064,68084-0390-11 ",.01)
 ;;68084-0390-11
 ;;9002226.02101,"1064,68084-0390-11 ",.02)
 ;;68084-0390-11
 ;;9002226.02101,"1064,68084-0391-01 ",.01)
 ;;68084-0391-01
 ;;9002226.02101,"1064,68084-0391-01 ",.02)
 ;;68084-0391-01
 ;;9002226.02101,"1064,68084-0391-11 ",.01)
 ;;68084-0391-11
 ;;9002226.02101,"1064,68084-0391-11 ",.02)
 ;;68084-0391-11
 ;;9002226.02101,"1064,68084-0392-01 ",.01)
 ;;68084-0392-01
 ;;9002226.02101,"1064,68084-0392-01 ",.02)
 ;;68084-0392-01
 ;;9002226.02101,"1064,68084-0392-11 ",.01)
 ;;68084-0392-11
 ;;9002226.02101,"1064,68084-0392-11 ",.02)
 ;;68084-0392-11
 ;;9002226.02101,"1064,68115-0059-00 ",.01)
 ;;68115-0059-00
 ;;9002226.02101,"1064,68115-0059-00 ",.02)
 ;;68115-0059-00
 ;;9002226.02101,"1064,68115-0059-30 ",.01)
 ;;68115-0059-30
 ;;9002226.02101,"1064,68115-0059-30 ",.02)
 ;;68115-0059-30
 ;;9002226.02101,"1064,68115-0059-90 ",.01)
 ;;68115-0059-90
 ;;9002226.02101,"1064,68115-0059-90 ",.02)
 ;;68115-0059-90
 ;;9002226.02101,"1064,68115-0060-30 ",.01)
 ;;68115-0060-30
 ;;9002226.02101,"1064,68115-0060-30 ",.02)
 ;;68115-0060-30
 ;;9002226.02101,"1064,68115-0060-90 ",.01)
 ;;68115-0060-90
 ;;9002226.02101,"1064,68115-0060-90 ",.02)
 ;;68115-0060-90
 ;;9002226.02101,"1064,68115-0127-00 ",.01)
 ;;68115-0127-00
 ;;9002226.02101,"1064,68115-0127-00 ",.02)
 ;;68115-0127-00
 ;;9002226.02101,"1064,68115-0127-15 ",.01)
 ;;68115-0127-15
 ;;9002226.02101,"1064,68115-0127-15 ",.02)
 ;;68115-0127-15
 ;;9002226.02101,"1064,68115-0127-30 ",.01)
 ;;68115-0127-30
 ;;9002226.02101,"1064,68115-0127-30 ",.02)
 ;;68115-0127-30
 ;;9002226.02101,"1064,68115-0127-60 ",.01)
 ;;68115-0127-60
 ;;9002226.02101,"1064,68115-0127-60 ",.02)
 ;;68115-0127-60
 ;;9002226.02101,"1064,68115-0128-00 ",.01)
 ;;68115-0128-00
 ;;9002226.02101,"1064,68115-0128-00 ",.02)
 ;;68115-0128-00
 ;;9002226.02101,"1064,68115-0128-20 ",.01)
 ;;68115-0128-20
 ;;9002226.02101,"1064,68115-0128-20 ",.02)
 ;;68115-0128-20
 ;;9002226.02101,"1064,68115-0128-30 ",.01)
 ;;68115-0128-30
 ;;9002226.02101,"1064,68115-0128-30 ",.02)
 ;;68115-0128-30
 ;;9002226.02101,"1064,68115-0128-60 ",.01)
 ;;68115-0128-60
 ;;9002226.02101,"1064,68115-0128-60 ",.02)
 ;;68115-0128-60
 ;;9002226.02101,"1064,68115-0128-90 ",.01)
 ;;68115-0128-90
 ;;9002226.02101,"1064,68115-0128-90 ",.02)
 ;;68115-0128-90
 ;;9002226.02101,"1064,68115-0129-30 ",.01)
 ;;68115-0129-30
 ;;9002226.02101,"1064,68115-0129-30 ",.02)
 ;;68115-0129-30
 ;;9002226.02101,"1064,68115-0129-60 ",.01)
 ;;68115-0129-60
 ;;9002226.02101,"1064,68115-0129-60 ",.02)
 ;;68115-0129-60
 ;;9002226.02101,"1064,68115-0207-30 ",.01)
 ;;68115-0207-30
 ;;9002226.02101,"1064,68115-0207-30 ",.02)
 ;;68115-0207-30
 ;;9002226.02101,"1064,68115-0207-60 ",.01)
 ;;68115-0207-60
 ;;9002226.02101,"1064,68115-0207-60 ",.02)
 ;;68115-0207-60
 ;;9002226.02101,"1064,68115-0208-30 ",.01)
 ;;68115-0208-30
 ;;9002226.02101,"1064,68115-0208-30 ",.02)
 ;;68115-0208-30
 ;;9002226.02101,"1064,68115-0208-60 ",.01)
 ;;68115-0208-60
 ;;9002226.02101,"1064,68115-0208-60 ",.02)
 ;;68115-0208-60
 ;;9002226.02101,"1064,68115-0208-90 ",.01)
 ;;68115-0208-90
 ;;9002226.02101,"1064,68115-0208-90 ",.02)
 ;;68115-0208-90
 ;;9002226.02101,"1064,68115-0209-30 ",.01)
 ;;68115-0209-30
 ;;9002226.02101,"1064,68115-0209-30 ",.02)
 ;;68115-0209-30
 ;;9002226.02101,"1064,68115-0215-30 ",.01)
 ;;68115-0215-30
 ;;9002226.02101,"1064,68115-0215-30 ",.02)
 ;;68115-0215-30
 ;;9002226.02101,"1064,68115-0216-30 ",.01)
 ;;68115-0216-30
 ;;9002226.02101,"1064,68115-0216-30 ",.02)
 ;;68115-0216-30
 ;;9002226.02101,"1064,68115-0217-30 ",.01)
 ;;68115-0217-30
 ;;9002226.02101,"1064,68115-0217-30 ",.02)
 ;;68115-0217-30
 ;;9002226.02101,"1064,68115-0361-30 ",.01)
 ;;68115-0361-30
 ;;9002226.02101,"1064,68115-0361-30 ",.02)
 ;;68115-0361-30
 ;;9002226.02101,"1064,68115-0362-00 ",.01)
 ;;68115-0362-00
 ;;9002226.02101,"1064,68115-0362-00 ",.02)
 ;;68115-0362-00
 ;;9002226.02101,"1064,68115-0362-60 ",.01)
 ;;68115-0362-60
 ;;9002226.02101,"1064,68115-0362-60 ",.02)
 ;;68115-0362-60
 ;;9002226.02101,"1064,68115-0363-30 ",.01)
 ;;68115-0363-30
 ;;9002226.02101,"1064,68115-0363-30 ",.02)
 ;;68115-0363-30
 ;;9002226.02101,"1064,68115-0378-30 ",.01)
 ;;68115-0378-30
 ;;9002226.02101,"1064,68115-0378-30 ",.02)
 ;;68115-0378-30
 ;;9002226.02101,"1064,68115-0378-60 ",.01)
 ;;68115-0378-60
 ;;9002226.02101,"1064,68115-0378-60 ",.02)
 ;;68115-0378-60
 ;;9002226.02101,"1064,68115-0396-30 ",.01)
 ;;68115-0396-30
 ;;9002226.02101,"1064,68115-0396-30 ",.02)
 ;;68115-0396-30
 ;;9002226.02101,"1064,68115-0425-90 ",.01)
 ;;68115-0425-90
 ;;9002226.02101,"1064,68115-0425-90 ",.02)
 ;;68115-0425-90
 ;;9002226.02101,"1064,68115-0490-60 ",.01)
 ;;68115-0490-60
 ;;9002226.02101,"1064,68115-0490-60 ",.02)
 ;;68115-0490-60
 ;;9002226.02101,"1064,68115-0530-00 ",.01)
 ;;68115-0530-00
 ;;9002226.02101,"1064,68115-0530-00 ",.02)
 ;;68115-0530-00
 ;;9002226.02101,"1064,68115-0530-30 ",.01)
 ;;68115-0530-30
 ;;9002226.02101,"1064,68115-0530-30 ",.02)
 ;;68115-0530-30
 ;;9002226.02101,"1064,68115-0530-60 ",.01)
 ;;68115-0530-60
 ;;9002226.02101,"1064,68115-0530-60 ",.02)
 ;;68115-0530-60
 ;;9002226.02101,"1064,68115-0573-30 ",.01)
 ;;68115-0573-30
 ;;9002226.02101,"1064,68115-0573-30 ",.02)
 ;;68115-0573-30
 ;;9002226.02101,"1064,68115-0597-00 ",.01)
 ;;68115-0597-00
 ;;9002226.02101,"1064,68115-0597-00 ",.02)
 ;;68115-0597-00
 ;;9002226.02101,"1064,68115-0615-00 ",.01)
 ;;68115-0615-00
 ;;9002226.02101,"1064,68115-0615-00 ",.02)
 ;;68115-0615-00
 ;;9002226.02101,"1064,68115-0621-00 ",.01)
 ;;68115-0621-00
 ;;9002226.02101,"1064,68115-0621-00 ",.02)
 ;;68115-0621-00
 ;;9002226.02101,"1064,68115-0650-00 ",.01)
 ;;68115-0650-00
 ;;9002226.02101,"1064,68115-0650-00 ",.02)
 ;;68115-0650-00
 ;;9002226.02101,"1064,68115-0654-00 ",.01)
 ;;68115-0654-00
 ;;9002226.02101,"1064,68115-0654-00 ",.02)
 ;;68115-0654-00
 ;;9002226.02101,"1064,68115-0673-00 ",.01)
 ;;68115-0673-00
 ;;9002226.02101,"1064,68115-0673-00 ",.02)
 ;;68115-0673-00
 ;;9002226.02101,"1064,68115-0673-30 ",.01)
 ;;68115-0673-30
 ;;9002226.02101,"1064,68115-0673-30 ",.02)
 ;;68115-0673-30
 ;;9002226.02101,"1064,68115-0677-00 ",.01)
 ;;68115-0677-00
 ;;9002226.02101,"1064,68115-0677-00 ",.02)
 ;;68115-0677-00
 ;;9002226.02101,"1064,68115-0677-30 ",.01)
 ;;68115-0677-30
 ;;9002226.02101,"1064,68115-0677-30 ",.02)
 ;;68115-0677-30
 ;;9002226.02101,"1064,68115-0778-00 ",.01)
 ;;68115-0778-00
 ;;9002226.02101,"1064,68115-0778-00 ",.02)
 ;;68115-0778-00
 ;;9002226.02101,"1064,68115-0812-00 ",.01)
 ;;68115-0812-00
 ;;9002226.02101,"1064,68115-0812-00 ",.02)
 ;;68115-0812-00
 ;;9002226.02101,"1064,68115-0812-30 ",.01)
 ;;68115-0812-30
 ;;9002226.02101,"1064,68115-0812-30 ",.02)
 ;;68115-0812-30
 ;;9002226.02101,"1064,68115-0812-60 ",.01)
 ;;68115-0812-60
 ;;9002226.02101,"1064,68115-0812-60 ",.02)
 ;;68115-0812-60
 ;;9002226.02101,"1064,68115-0824-00 ",.01)
 ;;68115-0824-00
 ;;9002226.02101,"1064,68115-0824-00 ",.02)
 ;;68115-0824-00
 ;;9002226.02101,"1064,68115-0889-90 ",.01)
 ;;68115-0889-90
 ;;9002226.02101,"1064,68115-0889-90 ",.02)
 ;;68115-0889-90
 ;;9002226.02101,"1064,68180-0235-01 ",.01)
 ;;68180-0235-01
 ;;9002226.02101,"1064,68180-0235-01 ",.02)
 ;;68180-0235-01
 ;;9002226.02101,"1064,68180-0236-01 ",.01)
 ;;68180-0236-01
 ;;9002226.02101,"1064,68180-0236-01 ",.02)
 ;;68180-0236-01
 ;;9002226.02101,"1064,68180-0237-01 ",.01)
 ;;68180-0237-01
 ;;9002226.02101,"1064,68180-0237-01 ",.02)
 ;;68180-0237-01
 ;;9002226.02101,"1064,68180-0512-01 ",.01)
 ;;68180-0512-01
 ;;9002226.02101,"1064,68180-0512-01 ",.02)
 ;;68180-0512-01
 ;;9002226.02101,"1064,68180-0512-02 ",.01)
 ;;68180-0512-02
 ;;9002226.02101,"1064,68180-0512-02 ",.02)
 ;;68180-0512-02
 ;;9002226.02101,"1064,68180-0512-09 ",.01)
 ;;68180-0512-09
 ;;9002226.02101,"1064,68180-0512-09 ",.02)
 ;;68180-0512-09
 ;;9002226.02101,"1064,68180-0513-01 ",.01)
 ;;68180-0513-01
 ;;9002226.02101,"1064,68180-0513-01 ",.02)
 ;;68180-0513-01
 ;;9002226.02101,"1064,68180-0513-03 ",.01)
 ;;68180-0513-03
 ;;9002226.02101,"1064,68180-0513-03 ",.02)
 ;;68180-0513-03
 ;;9002226.02101,"1064,68180-0514-01 ",.01)
 ;;68180-0514-01
 ;;9002226.02101,"1064,68180-0514-01 ",.02)
 ;;68180-0514-01
 ;;9002226.02101,"1064,68180-0514-03 ",.01)
 ;;68180-0514-03
 ;;9002226.02101,"1064,68180-0514-03 ",.02)
 ;;68180-0514-03
 ;;9002226.02101,"1064,68180-0515-01 ",.01)
 ;;68180-0515-01
 ;;9002226.02101,"1064,68180-0515-01 ",.02)
 ;;68180-0515-01
 ;;9002226.02101,"1064,68180-0515-03 ",.01)
 ;;68180-0515-03
 ;;9002226.02101,"1064,68180-0515-03 ",.02)
 ;;68180-0515-03
 ;;9002226.02101,"1064,68180-0516-01 ",.01)
 ;;68180-0516-01
 ;;9002226.02101,"1064,68180-0516-01 ",.02)
 ;;68180-0516-01
 ;;9002226.02101,"1064,68180-0516-02 ",.01)
 ;;68180-0516-02
 ;;9002226.02101,"1064,68180-0516-02 ",.02)
 ;;68180-0516-02
 ;;9002226.02101,"1064,68180-0517-01 ",.01)
 ;;68180-0517-01
 ;;9002226.02101,"1064,68180-0517-01 ",.02)
 ;;68180-0517-01
 ;;9002226.02101,"1064,68180-0517-03 ",.01)
 ;;68180-0517-03
 ;;9002226.02101,"1064,68180-0517-03 ",.02)
 ;;68180-0517-03
 ;;9002226.02101,"1064,68180-0518-01 ",.01)
 ;;68180-0518-01
 ;;9002226.02101,"1064,68180-0518-01 ",.02)
 ;;68180-0518-01
 ;;9002226.02101,"1064,68180-0518-02 ",.01)
 ;;68180-0518-02
 ;;9002226.02101,"1064,68180-0518-02 ",.02)
 ;;68180-0518-02
 ;;9002226.02101,"1064,68180-0519-01 ",.01)
 ;;68180-0519-01
 ;;9002226.02101,"1064,68180-0519-01 ",.02)
 ;;68180-0519-01
 ;;9002226.02101,"1064,68180-0519-02 ",.01)
 ;;68180-0519-02
 ;;9002226.02101,"1064,68180-0519-02 ",.02)
 ;;68180-0519-02
 ;;9002226.02101,"1064,68180-0520-01 ",.01)
 ;;68180-0520-01
 ;;9002226.02101,"1064,68180-0520-01 ",.02)
 ;;68180-0520-01
 ;;9002226.02101,"1064,68180-0520-02 ",.01)
 ;;68180-0520-02
 ;;9002226.02101,"1064,68180-0520-02 ",.02)
 ;;68180-0520-02
 ;;9002226.02101,"1064,68180-0556-09 ",.01)
 ;;68180-0556-09
 ;;9002226.02101,"1064,68180-0556-09 ",.02)
 ;;68180-0556-09
 ;;9002226.02101,"1064,68180-0557-09 ",.01)
 ;;68180-0557-09
 ;;9002226.02101,"1064,68180-0557-09 ",.02)
 ;;68180-0557-09
 ;;9002226.02101,"1064,68180-0558-09 ",.01)
 ;;68180-0558-09
 ;;9002226.02101,"1064,68180-0558-09 ",.02)
 ;;68180-0558-09
 ;;9002226.02101,"1064,68180-0559-09 ",.01)
 ;;68180-0559-09
 ;;9002226.02101,"1064,68180-0559-09 ",.02)
 ;;68180-0559-09
 ;;9002226.02101,"1064,68180-0566-01 ",.01)
 ;;68180-0566-01
 ;;9002226.02101,"1064,68180-0566-01 ",.02)
 ;;68180-0566-01
 ;;9002226.02101,"1064,68180-0567-01 ",.01)
 ;;68180-0567-01
 ;;9002226.02101,"1064,68180-0567-01 ",.02)
 ;;68180-0567-01
 ;;9002226.02101,"1064,68180-0568-01 ",.01)
 ;;68180-0568-01
 ;;9002226.02101,"1064,68180-0568-01 ",.02)
 ;;68180-0568-01
 ;;9002226.02101,"1064,68180-0588-01 ",.01)
 ;;68180-0588-01
 ;;9002226.02101,"1064,68180-0588-01 ",.02)
 ;;68180-0588-01
 ;;9002226.02101,"1064,68180-0589-01 ",.01)
 ;;68180-0589-01
 ;;9002226.02101,"1064,68180-0589-01 ",.02)
 ;;68180-0589-01
 ;;9002226.02101,"1064,68180-0589-02 ",.01)
 ;;68180-0589-02
 ;;9002226.02101,"1064,68180-0589-02 ",.02)
 ;;68180-0589-02
 ;;9002226.02101,"1064,68180-0590-01 ",.01)
 ;;68180-0590-01
 ;;9002226.02101,"1064,68180-0590-01 ",.02)
 ;;68180-0590-01
 ;;9002226.02101,"1064,68180-0590-02 ",.01)
 ;;68180-0590-02
 ;;9002226.02101,"1064,68180-0590-02 ",.02)
 ;;68180-0590-02
 ;;9002226.02101,"1064,68180-0591-01 ",.01)
 ;;68180-0591-01
 ;;9002226.02101,"1064,68180-0591-01 ",.02)
 ;;68180-0591-01
