BGP50F50 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 05, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1728,68084-0349-11 ",.02)
 ;;68084-0349-11
 ;;9002226.02101,"1728,68084-0349-21 ",.01)
 ;;68084-0349-21
 ;;9002226.02101,"1728,68084-0349-21 ",.02)
 ;;68084-0349-21
 ;;9002226.02101,"1728,68084-0350-01 ",.01)
 ;;68084-0350-01
 ;;9002226.02101,"1728,68084-0350-01 ",.02)
 ;;68084-0350-01
 ;;9002226.02101,"1728,68084-0350-11 ",.01)
 ;;68084-0350-11
 ;;9002226.02101,"1728,68084-0350-11 ",.02)
 ;;68084-0350-11
 ;;9002226.02101,"1728,68084-0351-11 ",.01)
 ;;68084-0351-11
 ;;9002226.02101,"1728,68084-0351-11 ",.02)
 ;;68084-0351-11
 ;;9002226.02101,"1728,68084-0351-21 ",.01)
 ;;68084-0351-21
 ;;9002226.02101,"1728,68084-0351-21 ",.02)
 ;;68084-0351-21
 ;;9002226.02101,"1728,68084-0390-01 ",.01)
 ;;68084-0390-01
 ;;9002226.02101,"1728,68084-0390-01 ",.02)
 ;;68084-0390-01
 ;;9002226.02101,"1728,68084-0390-11 ",.01)
 ;;68084-0390-11
 ;;9002226.02101,"1728,68084-0390-11 ",.02)
 ;;68084-0390-11
 ;;9002226.02101,"1728,68084-0391-01 ",.01)
 ;;68084-0391-01
 ;;9002226.02101,"1728,68084-0391-01 ",.02)
 ;;68084-0391-01
 ;;9002226.02101,"1728,68084-0391-11 ",.01)
 ;;68084-0391-11
 ;;9002226.02101,"1728,68084-0391-11 ",.02)
 ;;68084-0391-11
 ;;9002226.02101,"1728,68084-0392-01 ",.01)
 ;;68084-0392-01
 ;;9002226.02101,"1728,68084-0392-01 ",.02)
 ;;68084-0392-01
 ;;9002226.02101,"1728,68084-0392-11 ",.01)
 ;;68084-0392-11
 ;;9002226.02101,"1728,68084-0392-11 ",.02)
 ;;68084-0392-11
 ;;9002226.02101,"1728,68084-0518-11 ",.01)
 ;;68084-0518-11
 ;;9002226.02101,"1728,68084-0518-11 ",.02)
 ;;68084-0518-11
 ;;9002226.02101,"1728,68084-0518-21 ",.01)
 ;;68084-0518-21
 ;;9002226.02101,"1728,68084-0518-21 ",.02)
 ;;68084-0518-21
 ;;9002226.02101,"1728,68084-0519-11 ",.01)
 ;;68084-0519-11
 ;;9002226.02101,"1728,68084-0519-11 ",.02)
 ;;68084-0519-11
 ;;9002226.02101,"1728,68084-0519-21 ",.01)
 ;;68084-0519-21
 ;;9002226.02101,"1728,68084-0519-21 ",.02)
 ;;68084-0519-21
 ;;9002226.02101,"1728,68084-0644-11 ",.01)
 ;;68084-0644-11
 ;;9002226.02101,"1728,68084-0644-11 ",.02)
 ;;68084-0644-11
 ;;9002226.02101,"1728,68084-0644-21 ",.01)
 ;;68084-0644-21
 ;;9002226.02101,"1728,68084-0644-21 ",.02)
 ;;68084-0644-21
 ;;9002226.02101,"1728,68084-0726-32 ",.01)
 ;;68084-0726-32
 ;;9002226.02101,"1728,68084-0726-32 ",.02)
 ;;68084-0726-32
 ;;9002226.02101,"1728,68084-0726-33 ",.01)
 ;;68084-0726-33
 ;;9002226.02101,"1728,68084-0726-33 ",.02)
 ;;68084-0726-33
 ;;9002226.02101,"1728,68084-0727-11 ",.01)
 ;;68084-0727-11
 ;;9002226.02101,"1728,68084-0727-11 ",.02)
 ;;68084-0727-11
 ;;9002226.02101,"1728,68084-0727-21 ",.01)
 ;;68084-0727-21
 ;;9002226.02101,"1728,68084-0727-21 ",.02)
 ;;68084-0727-21
 ;;9002226.02101,"1728,68084-0739-25 ",.01)
 ;;68084-0739-25
 ;;9002226.02101,"1728,68084-0739-25 ",.02)
 ;;68084-0739-25
 ;;9002226.02101,"1728,68084-0739-95 ",.01)
 ;;68084-0739-95
 ;;9002226.02101,"1728,68084-0739-95 ",.02)
 ;;68084-0739-95
 ;;9002226.02101,"1728,68084-0749-11 ",.01)
 ;;68084-0749-11
 ;;9002226.02101,"1728,68084-0749-11 ",.02)
 ;;68084-0749-11
 ;;9002226.02101,"1728,68084-0749-21 ",.01)
 ;;68084-0749-21
 ;;9002226.02101,"1728,68084-0749-21 ",.02)
 ;;68084-0749-21
 ;;9002226.02101,"1728,68084-0765-11 ",.01)
 ;;68084-0765-11
 ;;9002226.02101,"1728,68084-0765-11 ",.02)
 ;;68084-0765-11
 ;;9002226.02101,"1728,68084-0765-21 ",.01)
 ;;68084-0765-21
 ;;9002226.02101,"1728,68084-0765-21 ",.02)
 ;;68084-0765-21
 ;;9002226.02101,"1728,68084-0766-11 ",.01)
 ;;68084-0766-11
 ;;9002226.02101,"1728,68084-0766-11 ",.02)
 ;;68084-0766-11
 ;;9002226.02101,"1728,68084-0766-21 ",.01)
 ;;68084-0766-21
 ;;9002226.02101,"1728,68084-0766-21 ",.02)
 ;;68084-0766-21
 ;;9002226.02101,"1728,68180-0101-02 ",.01)
 ;;68180-0101-02
 ;;9002226.02101,"1728,68180-0101-02 ",.02)
 ;;68180-0101-02
 ;;9002226.02101,"1728,68180-0101-09 ",.01)
 ;;68180-0101-09
 ;;9002226.02101,"1728,68180-0101-09 ",.02)
 ;;68180-0101-09
 ;;9002226.02101,"1728,68180-0102-02 ",.01)
 ;;68180-0102-02
 ;;9002226.02101,"1728,68180-0102-02 ",.02)
 ;;68180-0102-02
 ;;9002226.02101,"1728,68180-0102-09 ",.01)
 ;;68180-0102-09
 ;;9002226.02101,"1728,68180-0102-09 ",.02)
 ;;68180-0102-09
 ;;9002226.02101,"1728,68180-0103-02 ",.01)
 ;;68180-0103-02
 ;;9002226.02101,"1728,68180-0103-02 ",.02)
 ;;68180-0103-02
 ;;9002226.02101,"1728,68180-0103-09 ",.01)
 ;;68180-0103-09
 ;;9002226.02101,"1728,68180-0103-09 ",.02)
 ;;68180-0103-09
 ;;9002226.02101,"1728,68180-0104-02 ",.01)
 ;;68180-0104-02
 ;;9002226.02101,"1728,68180-0104-02 ",.02)
 ;;68180-0104-02
 ;;9002226.02101,"1728,68180-0104-09 ",.01)
 ;;68180-0104-09
 ;;9002226.02101,"1728,68180-0104-09 ",.02)
 ;;68180-0104-09
 ;;9002226.02101,"1728,68180-0105-02 ",.01)
 ;;68180-0105-02
 ;;9002226.02101,"1728,68180-0105-02 ",.02)
 ;;68180-0105-02
 ;;9002226.02101,"1728,68180-0105-09 ",.01)
 ;;68180-0105-09
 ;;9002226.02101,"1728,68180-0105-09 ",.02)
 ;;68180-0105-09
 ;;9002226.02101,"1728,68180-0196-06 ",.01)
 ;;68180-0196-06
 ;;9002226.02101,"1728,68180-0196-06 ",.02)
 ;;68180-0196-06
 ;;9002226.02101,"1728,68180-0197-06 ",.01)
 ;;68180-0197-06
 ;;9002226.02101,"1728,68180-0197-06 ",.02)
 ;;68180-0197-06
 ;;9002226.02101,"1728,68180-0198-06 ",.01)
 ;;68180-0198-06
 ;;9002226.02101,"1728,68180-0198-06 ",.02)
 ;;68180-0198-06
 ;;9002226.02101,"1728,68180-0199-06 ",.01)
 ;;68180-0199-06
 ;;9002226.02101,"1728,68180-0199-06 ",.02)
 ;;68180-0199-06
 ;;9002226.02101,"1728,68180-0210-03 ",.01)
 ;;68180-0210-03
 ;;9002226.02101,"1728,68180-0210-03 ",.02)
 ;;68180-0210-03
 ;;9002226.02101,"1728,68180-0210-09 ",.01)
 ;;68180-0210-09
 ;;9002226.02101,"1728,68180-0210-09 ",.02)
 ;;68180-0210-09
 ;;9002226.02101,"1728,68180-0211-03 ",.01)
 ;;68180-0211-03
 ;;9002226.02101,"1728,68180-0211-03 ",.02)
 ;;68180-0211-03
 ;;9002226.02101,"1728,68180-0211-09 ",.01)
 ;;68180-0211-09
 ;;9002226.02101,"1728,68180-0211-09 ",.02)
 ;;68180-0211-09
 ;;9002226.02101,"1728,68180-0212-03 ",.01)
 ;;68180-0212-03
 ;;9002226.02101,"1728,68180-0212-03 ",.02)
 ;;68180-0212-03
 ;;9002226.02101,"1728,68180-0212-09 ",.01)
 ;;68180-0212-09
 ;;9002226.02101,"1728,68180-0212-09 ",.02)
 ;;68180-0212-09
 ;;9002226.02101,"1728,68180-0215-03 ",.01)
 ;;68180-0215-03
 ;;9002226.02101,"1728,68180-0215-03 ",.02)
 ;;68180-0215-03
 ;;9002226.02101,"1728,68180-0215-06 ",.01)
 ;;68180-0215-06
 ;;9002226.02101,"1728,68180-0215-06 ",.02)
 ;;68180-0215-06
 ;;9002226.02101,"1728,68180-0215-09 ",.01)
 ;;68180-0215-09
 ;;9002226.02101,"1728,68180-0215-09 ",.02)
 ;;68180-0215-09
 ;;9002226.02101,"1728,68180-0216-03 ",.01)
 ;;68180-0216-03
 ;;9002226.02101,"1728,68180-0216-03 ",.02)
 ;;68180-0216-03
 ;;9002226.02101,"1728,68180-0216-06 ",.01)
 ;;68180-0216-06
 ;;9002226.02101,"1728,68180-0216-06 ",.02)
 ;;68180-0216-06
 ;;9002226.02101,"1728,68180-0216-09 ",.01)
 ;;68180-0216-09
 ;;9002226.02101,"1728,68180-0216-09 ",.02)
 ;;68180-0216-09
 ;;9002226.02101,"1728,68180-0217-03 ",.01)
 ;;68180-0217-03
 ;;9002226.02101,"1728,68180-0217-03 ",.02)
 ;;68180-0217-03
 ;;9002226.02101,"1728,68180-0217-06 ",.01)
 ;;68180-0217-06
 ;;9002226.02101,"1728,68180-0217-06 ",.02)
 ;;68180-0217-06
 ;;9002226.02101,"1728,68180-0217-09 ",.01)
 ;;68180-0217-09
 ;;9002226.02101,"1728,68180-0217-09 ",.02)
 ;;68180-0217-09
 ;;9002226.02101,"1728,68180-0235-01 ",.01)
 ;;68180-0235-01
 ;;9002226.02101,"1728,68180-0235-01 ",.02)
 ;;68180-0235-01
 ;;9002226.02101,"1728,68180-0236-01 ",.01)
 ;;68180-0236-01
 ;;9002226.02101,"1728,68180-0236-01 ",.02)
 ;;68180-0236-01
 ;;9002226.02101,"1728,68180-0237-01 ",.01)
 ;;68180-0237-01
 ;;9002226.02101,"1728,68180-0237-01 ",.02)
 ;;68180-0237-01
 ;;9002226.02101,"1728,68180-0410-06 ",.01)
 ;;68180-0410-06
 ;;9002226.02101,"1728,68180-0410-06 ",.02)
 ;;68180-0410-06
 ;;9002226.02101,"1728,68180-0410-09 ",.01)
 ;;68180-0410-09
 ;;9002226.02101,"1728,68180-0410-09 ",.02)
 ;;68180-0410-09
 ;;9002226.02101,"1728,68180-0411-06 ",.01)
 ;;68180-0411-06
 ;;9002226.02101,"1728,68180-0411-06 ",.02)
 ;;68180-0411-06
 ;;9002226.02101,"1728,68180-0411-09 ",.01)
 ;;68180-0411-09
 ;;9002226.02101,"1728,68180-0411-09 ",.02)
 ;;68180-0411-09
 ;;9002226.02101,"1728,68180-0412-06 ",.01)
 ;;68180-0412-06
 ;;9002226.02101,"1728,68180-0412-06 ",.02)
 ;;68180-0412-06
 ;;9002226.02101,"1728,68180-0412-09 ",.01)
 ;;68180-0412-09
 ;;9002226.02101,"1728,68180-0412-09 ",.02)
 ;;68180-0412-09
 ;;9002226.02101,"1728,68180-0413-06 ",.01)
 ;;68180-0413-06
 ;;9002226.02101,"1728,68180-0413-06 ",.02)
 ;;68180-0413-06
 ;;9002226.02101,"1728,68180-0413-09 ",.01)
 ;;68180-0413-09
 ;;9002226.02101,"1728,68180-0413-09 ",.02)
 ;;68180-0413-09
 ;;9002226.02101,"1728,68180-0414-06 ",.01)
 ;;68180-0414-06
 ;;9002226.02101,"1728,68180-0414-06 ",.02)
 ;;68180-0414-06
 ;;9002226.02101,"1728,68180-0414-09 ",.01)
 ;;68180-0414-09
 ;;9002226.02101,"1728,68180-0414-09 ",.02)
 ;;68180-0414-09
 ;;9002226.02101,"1728,68180-0512-01 ",.01)
 ;;68180-0512-01
 ;;9002226.02101,"1728,68180-0512-01 ",.02)
 ;;68180-0512-01
 ;;9002226.02101,"1728,68180-0512-02 ",.01)
 ;;68180-0512-02
 ;;9002226.02101,"1728,68180-0512-02 ",.02)
 ;;68180-0512-02
 ;;9002226.02101,"1728,68180-0512-09 ",.01)
 ;;68180-0512-09
 ;;9002226.02101,"1728,68180-0512-09 ",.02)
 ;;68180-0512-09
 ;;9002226.02101,"1728,68180-0513-01 ",.01)
 ;;68180-0513-01
 ;;9002226.02101,"1728,68180-0513-01 ",.02)
 ;;68180-0513-01
 ;;9002226.02101,"1728,68180-0513-03 ",.01)
 ;;68180-0513-03
 ;;9002226.02101,"1728,68180-0513-03 ",.02)
 ;;68180-0513-03
 ;;9002226.02101,"1728,68180-0513-09 ",.01)
 ;;68180-0513-09
 ;;9002226.02101,"1728,68180-0513-09 ",.02)
 ;;68180-0513-09
 ;;9002226.02101,"1728,68180-0514-01 ",.01)
 ;;68180-0514-01
 ;;9002226.02101,"1728,68180-0514-01 ",.02)
 ;;68180-0514-01
 ;;9002226.02101,"1728,68180-0514-03 ",.01)
 ;;68180-0514-03
 ;;9002226.02101,"1728,68180-0514-03 ",.02)
 ;;68180-0514-03
 ;;9002226.02101,"1728,68180-0514-09 ",.01)
 ;;68180-0514-09
 ;;9002226.02101,"1728,68180-0514-09 ",.02)
 ;;68180-0514-09
 ;;9002226.02101,"1728,68180-0515-01 ",.01)
 ;;68180-0515-01
 ;;9002226.02101,"1728,68180-0515-01 ",.02)
 ;;68180-0515-01
 ;;9002226.02101,"1728,68180-0515-03 ",.01)
 ;;68180-0515-03
 ;;9002226.02101,"1728,68180-0515-03 ",.02)
 ;;68180-0515-03
 ;;9002226.02101,"1728,68180-0515-09 ",.01)
 ;;68180-0515-09
 ;;9002226.02101,"1728,68180-0515-09 ",.02)
 ;;68180-0515-09
 ;;9002226.02101,"1728,68180-0516-01 ",.01)
 ;;68180-0516-01
 ;;9002226.02101,"1728,68180-0516-01 ",.02)
 ;;68180-0516-01
 ;;9002226.02101,"1728,68180-0516-02 ",.01)
 ;;68180-0516-02
 ;;9002226.02101,"1728,68180-0516-02 ",.02)
 ;;68180-0516-02
 ;;9002226.02101,"1728,68180-0516-09 ",.01)
 ;;68180-0516-09
 ;;9002226.02101,"1728,68180-0516-09 ",.02)
 ;;68180-0516-09
 ;;9002226.02101,"1728,68180-0517-01 ",.01)
 ;;68180-0517-01
 ;;9002226.02101,"1728,68180-0517-01 ",.02)
 ;;68180-0517-01
 ;;9002226.02101,"1728,68180-0517-03 ",.01)
 ;;68180-0517-03
 ;;9002226.02101,"1728,68180-0517-03 ",.02)
 ;;68180-0517-03
 ;;9002226.02101,"1728,68180-0517-09 ",.01)
 ;;68180-0517-09
 ;;9002226.02101,"1728,68180-0517-09 ",.02)
 ;;68180-0517-09
 ;;9002226.02101,"1728,68180-0518-01 ",.01)
 ;;68180-0518-01
 ;;9002226.02101,"1728,68180-0518-01 ",.02)
 ;;68180-0518-01
 ;;9002226.02101,"1728,68180-0518-02 ",.01)
 ;;68180-0518-02
 ;;9002226.02101,"1728,68180-0518-02 ",.02)
 ;;68180-0518-02
 ;;9002226.02101,"1728,68180-0519-01 ",.01)
 ;;68180-0519-01
 ;;9002226.02101,"1728,68180-0519-01 ",.02)
 ;;68180-0519-01
 ;;9002226.02101,"1728,68180-0519-02 ",.01)
 ;;68180-0519-02
 ;;9002226.02101,"1728,68180-0519-02 ",.02)
 ;;68180-0519-02
 ;;9002226.02101,"1728,68180-0520-01 ",.01)
 ;;68180-0520-01
 ;;9002226.02101,"1728,68180-0520-01 ",.02)
 ;;68180-0520-01
 ;;9002226.02101,"1728,68180-0520-02 ",.01)
 ;;68180-0520-02
 ;;9002226.02101,"1728,68180-0520-02 ",.02)
 ;;68180-0520-02
 ;;9002226.02101,"1728,68180-0556-09 ",.01)
 ;;68180-0556-09
 ;;9002226.02101,"1728,68180-0556-09 ",.02)
 ;;68180-0556-09
 ;;9002226.02101,"1728,68180-0557-09 ",.01)
 ;;68180-0557-09
 ;;9002226.02101,"1728,68180-0557-09 ",.02)
 ;;68180-0557-09
 ;;9002226.02101,"1728,68180-0558-09 ",.01)
 ;;68180-0558-09
 ;;9002226.02101,"1728,68180-0558-09 ",.02)
 ;;68180-0558-09
 ;;9002226.02101,"1728,68180-0559-09 ",.01)
 ;;68180-0559-09
 ;;9002226.02101,"1728,68180-0559-09 ",.02)
 ;;68180-0559-09
 ;;9002226.02101,"1728,68180-0566-01 ",.01)
 ;;68180-0566-01
 ;;9002226.02101,"1728,68180-0566-01 ",.02)
 ;;68180-0566-01
 ;;9002226.02101,"1728,68180-0567-01 ",.01)
 ;;68180-0567-01
 ;;9002226.02101,"1728,68180-0567-01 ",.02)
 ;;68180-0567-01
 ;;9002226.02101,"1728,68180-0568-01 ",.01)
 ;;68180-0568-01
 ;;9002226.02101,"1728,68180-0568-01 ",.02)
 ;;68180-0568-01
 ;;9002226.02101,"1728,68180-0588-01 ",.01)
 ;;68180-0588-01
 ;;9002226.02101,"1728,68180-0588-01 ",.02)
 ;;68180-0588-01
 ;;9002226.02101,"1728,68180-0589-01 ",.01)
 ;;68180-0589-01
 ;;9002226.02101,"1728,68180-0589-01 ",.02)
 ;;68180-0589-01
 ;;9002226.02101,"1728,68180-0589-02 ",.01)
 ;;68180-0589-02
 ;;9002226.02101,"1728,68180-0589-02 ",.02)
 ;;68180-0589-02
 ;;9002226.02101,"1728,68180-0589-09 ",.01)
 ;;68180-0589-09
 ;;9002226.02101,"1728,68180-0589-09 ",.02)
 ;;68180-0589-09
 ;;9002226.02101,"1728,68180-0590-01 ",.01)
 ;;68180-0590-01
 ;;9002226.02101,"1728,68180-0590-01 ",.02)
 ;;68180-0590-01
 ;;9002226.02101,"1728,68180-0590-02 ",.01)
 ;;68180-0590-02
 ;;9002226.02101,"1728,68180-0590-02 ",.02)
 ;;68180-0590-02
 ;;9002226.02101,"1728,68180-0590-09 ",.01)
 ;;68180-0590-09
 ;;9002226.02101,"1728,68180-0590-09 ",.02)
 ;;68180-0590-09