BGP2TPU ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 27, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"999,60505-2609-01 ",.02)
 ;;60505-2609-01
 ;;9002226.02101,"999,60505-2609-08 ",.01)
 ;;60505-2609-08
 ;;9002226.02101,"999,60505-2609-08 ",.02)
 ;;60505-2609-08
 ;;9002226.02101,"999,60793-0283-01 ",.01)
 ;;60793-0283-01
 ;;9002226.02101,"999,60793-0283-01 ",.02)
 ;;60793-0283-01
 ;;9002226.02101,"999,60793-0284-01 ",.01)
 ;;60793-0284-01
 ;;9002226.02101,"999,60793-0284-01 ",.02)
 ;;60793-0284-01
 ;;9002226.02101,"999,60793-0800-01 ",.01)
 ;;60793-0800-01
 ;;9002226.02101,"999,60793-0800-01 ",.02)
 ;;60793-0800-01
 ;;9002226.02101,"999,60793-0801-01 ",.01)
 ;;60793-0801-01
 ;;9002226.02101,"999,60793-0801-01 ",.02)
 ;;60793-0801-01
 ;;9002226.02101,"999,60793-0802-01 ",.01)
 ;;60793-0802-01
 ;;9002226.02101,"999,60793-0802-01 ",.02)
 ;;60793-0802-01
 ;;9002226.02101,"999,60814-0710-01 ",.01)
 ;;60814-0710-01
 ;;9002226.02101,"999,60814-0710-01 ",.02)
 ;;60814-0710-01
 ;;9002226.02101,"999,60814-0710-10 ",.01)
 ;;60814-0710-10
 ;;9002226.02101,"999,60814-0710-10 ",.02)
 ;;60814-0710-10
 ;;9002226.02101,"999,60814-0711-01 ",.01)
 ;;60814-0711-01
 ;;9002226.02101,"999,60814-0711-01 ",.02)
 ;;60814-0711-01
 ;;9002226.02101,"999,60814-0711-10 ",.01)
 ;;60814-0711-10
 ;;9002226.02101,"999,60814-0711-10 ",.02)
 ;;60814-0711-10
 ;;9002226.02101,"999,60976-0346-43 ",.01)
 ;;60976-0346-43
 ;;9002226.02101,"999,60976-0346-43 ",.02)
 ;;60976-0346-43
 ;;9002226.02101,"999,60976-0346-44 ",.01)
 ;;60976-0346-44
 ;;9002226.02101,"999,60976-0346-44 ",.02)
 ;;60976-0346-44
 ;;9002226.02101,"999,60976-0346-47 ",.01)
 ;;60976-0346-47
 ;;9002226.02101,"999,60976-0346-47 ",.02)
 ;;60976-0346-47
 ;;9002226.02101,"999,61392-0018-30 ",.01)
 ;;61392-0018-30
 ;;9002226.02101,"999,61392-0018-30 ",.02)
 ;;61392-0018-30
 ;;9002226.02101,"999,61392-0018-31 ",.01)
 ;;61392-0018-31
 ;;9002226.02101,"999,61392-0018-31 ",.02)
 ;;61392-0018-31
 ;;9002226.02101,"999,61392-0018-32 ",.01)
 ;;61392-0018-32
 ;;9002226.02101,"999,61392-0018-32 ",.02)
 ;;61392-0018-32
 ;;9002226.02101,"999,61392-0018-39 ",.01)
 ;;61392-0018-39
 ;;9002226.02101,"999,61392-0018-39 ",.02)
 ;;61392-0018-39
 ;;9002226.02101,"999,61392-0018-45 ",.01)
 ;;61392-0018-45
 ;;9002226.02101,"999,61392-0018-45 ",.02)
 ;;61392-0018-45
 ;;9002226.02101,"999,61392-0018-51 ",.01)
 ;;61392-0018-51
 ;;9002226.02101,"999,61392-0018-51 ",.02)
 ;;61392-0018-51
 ;;9002226.02101,"999,61392-0018-54 ",.01)
 ;;61392-0018-54
 ;;9002226.02101,"999,61392-0018-54 ",.02)
 ;;61392-0018-54
 ;;9002226.02101,"999,61392-0018-56 ",.01)
 ;;61392-0018-56
 ;;9002226.02101,"999,61392-0018-56 ",.02)
 ;;61392-0018-56
 ;;9002226.02101,"999,61392-0018-60 ",.01)
 ;;61392-0018-60
 ;;9002226.02101,"999,61392-0018-60 ",.02)
 ;;61392-0018-60
 ;;9002226.02101,"999,61392-0018-90 ",.01)
 ;;61392-0018-90
 ;;9002226.02101,"999,61392-0018-90 ",.02)
 ;;61392-0018-90
 ;;9002226.02101,"999,61392-0018-91 ",.01)
 ;;61392-0018-91
 ;;9002226.02101,"999,61392-0018-91 ",.02)
 ;;61392-0018-91
 ;;9002226.02101,"999,61392-0069-30 ",.01)
 ;;61392-0069-30
 ;;9002226.02101,"999,61392-0069-30 ",.02)
 ;;61392-0069-30
 ;;9002226.02101,"999,61392-0069-31 ",.01)
 ;;61392-0069-31
 ;;9002226.02101,"999,61392-0069-31 ",.02)
 ;;61392-0069-31
 ;;9002226.02101,"999,61392-0069-32 ",.01)
 ;;61392-0069-32
 ;;9002226.02101,"999,61392-0069-32 ",.02)
 ;;61392-0069-32
 ;;9002226.02101,"999,61392-0069-39 ",.01)
 ;;61392-0069-39
 ;;9002226.02101,"999,61392-0069-39 ",.02)
 ;;61392-0069-39
 ;;9002226.02101,"999,61392-0069-45 ",.01)
 ;;61392-0069-45
 ;;9002226.02101,"999,61392-0069-45 ",.02)
 ;;61392-0069-45
 ;;9002226.02101,"999,61392-0069-51 ",.01)
 ;;61392-0069-51
 ;;9002226.02101,"999,61392-0069-51 ",.02)
 ;;61392-0069-51
 ;;9002226.02101,"999,61392-0069-54 ",.01)
 ;;61392-0069-54
 ;;9002226.02101,"999,61392-0069-54 ",.02)
 ;;61392-0069-54
 ;;9002226.02101,"999,61392-0069-60 ",.01)
 ;;61392-0069-60
 ;;9002226.02101,"999,61392-0069-60 ",.02)
 ;;61392-0069-60
 ;;9002226.02101,"999,61392-0069-90 ",.01)
 ;;61392-0069-90
 ;;9002226.02101,"999,61392-0069-90 ",.02)
 ;;61392-0069-90
 ;;9002226.02101,"999,61392-0069-91 ",.01)
 ;;61392-0069-91
 ;;9002226.02101,"999,61392-0069-91 ",.02)
 ;;61392-0069-91
 ;;9002226.02101,"999,61392-0280-45 ",.01)
 ;;61392-0280-45
 ;;9002226.02101,"999,61392-0280-45 ",.02)
 ;;61392-0280-45
 ;;9002226.02101,"999,61392-0280-56 ",.01)
 ;;61392-0280-56
 ;;9002226.02101,"999,61392-0280-56 ",.02)
 ;;61392-0280-56
 ;;9002226.02101,"999,61392-0280-91 ",.01)
 ;;61392-0280-91
 ;;9002226.02101,"999,61392-0280-91 ",.02)
 ;;61392-0280-91
 ;;9002226.02101,"999,61392-0286-45 ",.01)
 ;;61392-0286-45
 ;;9002226.02101,"999,61392-0286-45 ",.02)
 ;;61392-0286-45
 ;;9002226.02101,"999,61392-0286-56 ",.01)
 ;;61392-0286-56
 ;;9002226.02101,"999,61392-0286-56 ",.02)
 ;;61392-0286-56
 ;;9002226.02101,"999,61392-0286-91 ",.01)
 ;;61392-0286-91
 ;;9002226.02101,"999,61392-0286-91 ",.02)
 ;;61392-0286-91
 ;;9002226.02101,"999,61392-0395-31 ",.01)
 ;;61392-0395-31
 ;;9002226.02101,"999,61392-0395-31 ",.02)
 ;;61392-0395-31
 ;;9002226.02101,"999,61392-0395-32 ",.01)
 ;;61392-0395-32
 ;;9002226.02101,"999,61392-0395-32 ",.02)
 ;;61392-0395-32
 ;;9002226.02101,"999,61392-0395-39 ",.01)
 ;;61392-0395-39
 ;;9002226.02101,"999,61392-0395-39 ",.02)
 ;;61392-0395-39
 ;;9002226.02101,"999,61392-0395-45 ",.01)
 ;;61392-0395-45
 ;;9002226.02101,"999,61392-0395-45 ",.02)
 ;;61392-0395-45
 ;;9002226.02101,"999,61392-0395-54 ",.01)
 ;;61392-0395-54
 ;;9002226.02101,"999,61392-0395-54 ",.02)
 ;;61392-0395-54
 ;;9002226.02101,"999,61392-0395-56 ",.01)
 ;;61392-0395-56
 ;;9002226.02101,"999,61392-0395-56 ",.02)
 ;;61392-0395-56
 ;;9002226.02101,"999,61392-0395-91 ",.01)
 ;;61392-0395-91
 ;;9002226.02101,"999,61392-0395-91 ",.02)
 ;;61392-0395-91
 ;;9002226.02101,"999,61392-0420-34 ",.01)
 ;;61392-0420-34
 ;;9002226.02101,"999,61392-0420-34 ",.02)
 ;;61392-0420-34
 ;;9002226.02101,"999,61392-0420-45 ",.01)
 ;;61392-0420-45
 ;;9002226.02101,"999,61392-0420-45 ",.02)
 ;;61392-0420-45
 ;;9002226.02101,"999,61392-0420-56 ",.01)
 ;;61392-0420-56
 ;;9002226.02101,"999,61392-0420-56 ",.02)
 ;;61392-0420-56
 ;;9002226.02101,"999,61392-0420-91 ",.01)
 ;;61392-0420-91
 ;;9002226.02101,"999,61392-0420-91 ",.02)
 ;;61392-0420-91
 ;;9002226.02101,"999,61392-0423-34 ",.01)
 ;;61392-0423-34
 ;;9002226.02101,"999,61392-0423-34 ",.02)
 ;;61392-0423-34
 ;;9002226.02101,"999,61392-0423-45 ",.01)
 ;;61392-0423-45
 ;;9002226.02101,"999,61392-0423-45 ",.02)
 ;;61392-0423-45
 ;;9002226.02101,"999,61392-0423-56 ",.01)
 ;;61392-0423-56
 ;;9002226.02101,"999,61392-0423-56 ",.02)
 ;;61392-0423-56
 ;;9002226.02101,"999,61392-0423-91 ",.01)
 ;;61392-0423-91
 ;;9002226.02101,"999,61392-0423-91 ",.02)
 ;;61392-0423-91
 ;;9002226.02101,"999,61392-0427-30 ",.01)
 ;;61392-0427-30
 ;;9002226.02101,"999,61392-0427-30 ",.02)
 ;;61392-0427-30
 ;;9002226.02101,"999,61392-0427-31 ",.01)
 ;;61392-0427-31
 ;;9002226.02101,"999,61392-0427-31 ",.02)
 ;;61392-0427-31
 ;;9002226.02101,"999,61392-0427-32 ",.01)
 ;;61392-0427-32
 ;;9002226.02101,"999,61392-0427-32 ",.02)
 ;;61392-0427-32
 ;;9002226.02101,"999,61392-0427-39 ",.01)
 ;;61392-0427-39
 ;;9002226.02101,"999,61392-0427-39 ",.02)
 ;;61392-0427-39
 ;;9002226.02101,"999,61392-0427-45 ",.01)
 ;;61392-0427-45
 ;;9002226.02101,"999,61392-0427-45 ",.02)
 ;;61392-0427-45
 ;;9002226.02101,"999,61392-0427-51 ",.01)
 ;;61392-0427-51
 ;;9002226.02101,"999,61392-0427-51 ",.02)
 ;;61392-0427-51
 ;;9002226.02101,"999,61392-0427-54 ",.01)
 ;;61392-0427-54
 ;;9002226.02101,"999,61392-0427-54 ",.02)
 ;;61392-0427-54
 ;;9002226.02101,"999,61392-0427-56 ",.01)
 ;;61392-0427-56
 ;;9002226.02101,"999,61392-0427-56 ",.02)
 ;;61392-0427-56
 ;;9002226.02101,"999,61392-0427-60 ",.01)
 ;;61392-0427-60
 ;;9002226.02101,"999,61392-0427-60 ",.02)
 ;;61392-0427-60
 ;;9002226.02101,"999,61392-0427-90 ",.01)
 ;;61392-0427-90
 ;;9002226.02101,"999,61392-0427-90 ",.02)
 ;;61392-0427-90
 ;;9002226.02101,"999,61392-0427-91 ",.01)
 ;;61392-0427-91
 ;;9002226.02101,"999,61392-0427-91 ",.02)
 ;;61392-0427-91
 ;;9002226.02101,"999,61392-0430-45 ",.01)
 ;;61392-0430-45
 ;;9002226.02101,"999,61392-0430-45 ",.02)
 ;;61392-0430-45
 ;;9002226.02101,"999,61392-0430-56 ",.01)
 ;;61392-0430-56
 ;;9002226.02101,"999,61392-0430-56 ",.02)
 ;;61392-0430-56
 ;;9002226.02101,"999,61392-0430-91 ",.01)
 ;;61392-0430-91
 ;;9002226.02101,"999,61392-0430-91 ",.02)
 ;;61392-0430-91
 ;;9002226.02101,"999,61392-0542-45 ",.01)
 ;;61392-0542-45
 ;;9002226.02101,"999,61392-0542-45 ",.02)
 ;;61392-0542-45
 ;;9002226.02101,"999,61392-0542-51 ",.01)
 ;;61392-0542-51
 ;;9002226.02101,"999,61392-0542-51 ",.02)
 ;;61392-0542-51
 ;;9002226.02101,"999,61392-0542-54 ",.01)
 ;;61392-0542-54
 ;;9002226.02101,"999,61392-0542-54 ",.02)
 ;;61392-0542-54
 ;;9002226.02101,"999,61392-0542-91 ",.01)
 ;;61392-0542-91
 ;;9002226.02101,"999,61392-0542-91 ",.02)
 ;;61392-0542-91
 ;;9002226.02101,"999,61392-0543-45 ",.01)
 ;;61392-0543-45
 ;;9002226.02101,"999,61392-0543-45 ",.02)
 ;;61392-0543-45
 ;;9002226.02101,"999,61392-0543-54 ",.01)
 ;;61392-0543-54
 ;;9002226.02101,"999,61392-0543-54 ",.02)
 ;;61392-0543-54
 ;;9002226.02101,"999,61392-0543-56 ",.01)
 ;;61392-0543-56
 ;;9002226.02101,"999,61392-0543-56 ",.02)
 ;;61392-0543-56
 ;;9002226.02101,"999,61392-0543-91 ",.01)
 ;;61392-0543-91
 ;;9002226.02101,"999,61392-0543-91 ",.02)
 ;;61392-0543-91
 ;;9002226.02101,"999,61392-0546-30 ",.01)
 ;;61392-0546-30
 ;;9002226.02101,"999,61392-0546-30 ",.02)
 ;;61392-0546-30
 ;;9002226.02101,"999,61392-0546-31 ",.01)
 ;;61392-0546-31
 ;;9002226.02101,"999,61392-0546-31 ",.02)
 ;;61392-0546-31
 ;;9002226.02101,"999,61392-0546-32 ",.01)
 ;;61392-0546-32
 ;;9002226.02101,"999,61392-0546-32 ",.02)
 ;;61392-0546-32
 ;;9002226.02101,"999,61392-0546-39 ",.01)
 ;;61392-0546-39
 ;;9002226.02101,"999,61392-0546-39 ",.02)
 ;;61392-0546-39
 ;;9002226.02101,"999,61392-0546-45 ",.01)
 ;;61392-0546-45
 ;;9002226.02101,"999,61392-0546-45 ",.02)
 ;;61392-0546-45
 ;;9002226.02101,"999,61392-0546-51 ",.01)
 ;;61392-0546-51
 ;;9002226.02101,"999,61392-0546-51 ",.02)
 ;;61392-0546-51
 ;;9002226.02101,"999,61392-0546-54 ",.01)
 ;;61392-0546-54
 ;;9002226.02101,"999,61392-0546-54 ",.02)
 ;;61392-0546-54
 ;;9002226.02101,"999,61392-0546-56 ",.01)
 ;;61392-0546-56
 ;;9002226.02101,"999,61392-0546-56 ",.02)
 ;;61392-0546-56
 ;;9002226.02101,"999,61392-0546-60 ",.01)
 ;;61392-0546-60
 ;;9002226.02101,"999,61392-0546-60 ",.02)
 ;;61392-0546-60
 ;;9002226.02101,"999,61392-0546-90 ",.01)
 ;;61392-0546-90
 ;;9002226.02101,"999,61392-0546-90 ",.02)
 ;;61392-0546-90
 ;;9002226.02101,"999,61392-0546-91 ",.01)
 ;;61392-0546-91
 ;;9002226.02101,"999,61392-0546-91 ",.02)
 ;;61392-0546-91
 ;;9002226.02101,"999,61570-0175-01 ",.01)
 ;;61570-0175-01
 ;;9002226.02101,"999,61570-0175-01 ",.02)
 ;;61570-0175-01
 ;;9002226.02101,"999,61570-0176-01 ",.01)
 ;;61570-0176-01
 ;;9002226.02101,"999,61570-0176-01 ",.02)
 ;;61570-0176-01
 ;;9002226.02101,"999,61570-0200-01 ",.01)
 ;;61570-0200-01
 ;;9002226.02101,"999,61570-0200-01 ",.02)
 ;;61570-0200-01
 ;;9002226.02101,"999,61570-0201-01 ",.01)
 ;;61570-0201-01
 ;;9002226.02101,"999,61570-0201-01 ",.02)
 ;;61570-0201-01
 ;;9002226.02101,"999,61570-0202-01 ",.01)
 ;;61570-0202-01
 ;;9002226.02101,"999,61570-0202-01 ",.02)
 ;;61570-0202-01
 ;;9002226.02101,"999,62037-0830-01 ",.01)
 ;;62037-0830-01
 ;;9002226.02101,"999,62037-0830-01 ",.02)
 ;;62037-0830-01
 ;;9002226.02101,"999,62037-0830-10 ",.01)
 ;;62037-0830-10
 ;;9002226.02101,"999,62037-0830-10 ",.02)
 ;;62037-0830-10
 ;;9002226.02101,"999,62037-0831-01 ",.01)
 ;;62037-0831-01
 ;;9002226.02101,"999,62037-0831-01 ",.02)
 ;;62037-0831-01
 ;;9002226.02101,"999,62037-0831-10 ",.01)
 ;;62037-0831-10
 ;;9002226.02101,"999,62037-0831-10 ",.02)
 ;;62037-0831-10
 ;;9002226.02101,"999,62037-0832-01 ",.01)
 ;;62037-0832-01
 ;;9002226.02101,"999,62037-0832-01 ",.02)
 ;;62037-0832-01
 ;;9002226.02101,"999,62037-0832-10 ",.01)
 ;;62037-0832-10
 ;;9002226.02101,"999,62037-0832-10 ",.02)
 ;;62037-0832-10
 ;;9002226.02101,"999,62037-0833-01 ",.01)
 ;;62037-0833-01
 ;;9002226.02101,"999,62037-0833-01 ",.02)
 ;;62037-0833-01
 ;;9002226.02101,"999,62037-0833-10 ",.01)
 ;;62037-0833-10
 ;;9002226.02101,"999,62037-0833-10 ",.02)
 ;;62037-0833-10
 ;;9002226.02101,"999,62269-0256-24 ",.01)
 ;;62269-0256-24
 ;;9002226.02101,"999,62269-0256-24 ",.02)
 ;;62269-0256-24
 ;;9002226.02101,"999,62269-0256-30 ",.01)
 ;;62269-0256-30
 ;;9002226.02101,"999,62269-0256-30 ",.02)
 ;;62269-0256-30
 ;;9002226.02101,"999,62269-0256-54 ",.01)
 ;;62269-0256-54
 ;;9002226.02101,"999,62269-0256-54 ",.02)
 ;;62269-0256-54
 ;;9002226.02101,"999,62269-0257-24 ",.01)
 ;;62269-0257-24
 ;;9002226.02101,"999,62269-0257-24 ",.02)
 ;;62269-0257-24
 ;;9002226.02101,"999,62269-0259-30 ",.01)
 ;;62269-0259-30
 ;;9002226.02101,"999,62269-0259-30 ",.02)
 ;;62269-0259-30
 ;;9002226.02101,"999,62584-0265-01 ",.01)
 ;;62584-0265-01
 ;;9002226.02101,"999,62584-0265-01 ",.02)
 ;;62584-0265-01
 ;;9002226.02101,"999,62584-0265-11 ",.01)
 ;;62584-0265-11
 ;;9002226.02101,"999,62584-0265-11 ",.02)
 ;;62584-0265-11
 ;;9002226.02101,"999,62584-0266-01 ",.01)
 ;;62584-0266-01
 ;;9002226.02101,"999,62584-0266-01 ",.02)
 ;;62584-0266-01
 ;;9002226.02101,"999,62584-0266-11 ",.01)
 ;;62584-0266-11
 ;;9002226.02101,"999,62584-0266-11 ",.02)
 ;;62584-0266-11
 ;;9002226.02101,"999,62584-0267-01 ",.01)
 ;;62584-0267-01
