BGP2VJ6 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 27, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"747,55887-0678-60 ",.02)
 ;;55887-0678-60
 ;;9002226.02101,"747,55887-0847-60 ",.01)
 ;;55887-0847-60
 ;;9002226.02101,"747,55887-0847-60 ",.02)
 ;;55887-0847-60
 ;;9002226.02101,"747,55887-0847-90 ",.01)
 ;;55887-0847-90
 ;;9002226.02101,"747,55887-0847-90 ",.02)
 ;;55887-0847-90
 ;;9002226.02101,"747,57866-4651-02 ",.01)
 ;;57866-4651-02
 ;;9002226.02101,"747,57866-4651-02 ",.02)
 ;;57866-4651-02
 ;;9002226.02101,"747,57866-4652-02 ",.01)
 ;;57866-4652-02
 ;;9002226.02101,"747,57866-4652-02 ",.02)
 ;;57866-4652-02
 ;;9002226.02101,"747,58016-4604-01 ",.01)
 ;;58016-4604-01
 ;;9002226.02101,"747,58016-4604-01 ",.02)
 ;;58016-4604-01
 ;;9002226.02101,"747,58016-4813-01 ",.01)
 ;;58016-4813-01
 ;;9002226.02101,"747,58016-4813-01 ",.02)
 ;;58016-4813-01
 ;;9002226.02101,"747,58864-0658-30 ",.01)
 ;;58864-0658-30
 ;;9002226.02101,"747,58864-0658-30 ",.02)
 ;;58864-0658-30
 ;;9002226.02101,"747,58864-0694-30 ",.01)
 ;;58864-0694-30
 ;;9002226.02101,"747,58864-0694-30 ",.02)
 ;;58864-0694-30
 ;;9002226.02101,"747,59243-0021-10 ",.01)
 ;;59243-0021-10
 ;;9002226.02101,"747,59243-0021-10 ",.02)
 ;;59243-0021-10
 ;;9002226.02101,"747,59310-0175-40 ",.01)
 ;;59310-0175-40
 ;;9002226.02101,"747,59310-0175-40 ",.02)
 ;;59310-0175-40
 ;;9002226.02101,"747,59310-0177-80 ",.01)
 ;;59310-0177-80
 ;;9002226.02101,"747,59310-0177-80 ",.02)
 ;;59310-0177-80
 ;;9002226.02101,"747,59310-0202-40 ",.01)
 ;;59310-0202-40
 ;;9002226.02101,"747,59310-0202-40 ",.02)
 ;;59310-0202-40
 ;;9002226.02101,"747,59310-0204-80 ",.01)
 ;;59310-0204-80
 ;;9002226.02101,"747,59310-0204-80 ",.02)
 ;;59310-0204-80
 ;;9002226.02101,"747,60258-0335-16 ",.01)
 ;;60258-0335-16
 ;;9002226.02101,"747,60258-0335-16 ",.02)
 ;;60258-0335-16
 ;;9002226.02101,"747,60258-0336-01 ",.01)
 ;;60258-0336-01
 ;;9002226.02101,"747,60258-0336-01 ",.02)
 ;;60258-0336-01
 ;;9002226.02101,"747,60258-0371-16 ",.01)
 ;;60258-0371-16
 ;;9002226.02101,"747,60258-0371-16 ",.02)
 ;;60258-0371-16
 ;;9002226.02101,"747,60346-0282-74 ",.01)
 ;;60346-0282-74
 ;;9002226.02101,"747,60346-0282-74 ",.02)
 ;;60346-0282-74
 ;;9002226.02101,"747,60432-0157-06 ",.01)
 ;;60432-0157-06
 ;;9002226.02101,"747,60432-0157-06 ",.02)
 ;;60432-0157-06
 ;;9002226.02101,"747,60432-0157-21 ",.01)
 ;;60432-0157-21
 ;;9002226.02101,"747,60432-0157-21 ",.02)
 ;;60432-0157-21
 ;;9002226.02101,"747,60505-0802-01 ",.01)
 ;;60505-0802-01
 ;;9002226.02101,"747,60505-0802-01 ",.02)
 ;;60505-0802-01
 ;;9002226.02101,"747,60505-0802-02 ",.01)
 ;;60505-0802-02
 ;;9002226.02101,"747,60505-0802-02 ",.02)
 ;;60505-0802-02
 ;;9002226.02101,"747,60598-0061-60 ",.01)
 ;;60598-0061-60
 ;;9002226.02101,"747,60598-0061-60 ",.02)
 ;;60598-0061-60
 ;;9002226.02101,"747,60793-0010-12 ",.01)
 ;;60793-0010-12
 ;;9002226.02101,"747,60793-0010-12 ",.02)
 ;;60793-0010-12
 ;;9002226.02101,"747,60793-0010-60 ",.01)
 ;;60793-0010-60
 ;;9002226.02101,"747,60793-0010-60 ",.02)
 ;;60793-0010-60
 ;;9002226.02101,"747,60793-0011-08 ",.01)
 ;;60793-0011-08
 ;;9002226.02101,"747,60793-0011-08 ",.02)
 ;;60793-0011-08
 ;;9002226.02101,"747,60793-0011-14 ",.01)
 ;;60793-0011-14
 ;;9002226.02101,"747,60793-0011-14 ",.02)
 ;;60793-0011-14
 ;;9002226.02101,"747,60793-0120-01 ",.01)
 ;;60793-0120-01
 ;;9002226.02101,"747,60793-0120-01 ",.02)
 ;;60793-0120-01
 ;;9002226.02101,"747,61392-0016-30 ",.01)
 ;;61392-0016-30
 ;;9002226.02101,"747,61392-0016-30 ",.02)
 ;;61392-0016-30
 ;;9002226.02101,"747,61392-0016-45 ",.01)
 ;;61392-0016-45
 ;;9002226.02101,"747,61392-0016-45 ",.02)
 ;;61392-0016-45
 ;;9002226.02101,"747,61392-0016-51 ",.01)
 ;;61392-0016-51
 ;;9002226.02101,"747,61392-0016-51 ",.02)
 ;;61392-0016-51
 ;;9002226.02101,"747,61392-0016-54 ",.01)
 ;;61392-0016-54
 ;;9002226.02101,"747,61392-0016-54 ",.02)
 ;;61392-0016-54
 ;;9002226.02101,"747,61392-0016-56 ",.01)
 ;;61392-0016-56
 ;;9002226.02101,"747,61392-0016-56 ",.02)
 ;;61392-0016-56
 ;;9002226.02101,"747,61392-0016-60 ",.01)
 ;;61392-0016-60
 ;;9002226.02101,"747,61392-0016-60 ",.02)
 ;;61392-0016-60
 ;;9002226.02101,"747,61392-0016-90 ",.01)
 ;;61392-0016-90
 ;;9002226.02101,"747,61392-0016-90 ",.02)
 ;;61392-0016-90
 ;;9002226.02101,"747,61392-0016-91 ",.01)
 ;;61392-0016-91
 ;;9002226.02101,"747,61392-0016-91 ",.02)
 ;;61392-0016-91
 ;;9002226.02101,"747,61392-0017-30 ",.01)
 ;;61392-0017-30
 ;;9002226.02101,"747,61392-0017-30 ",.02)
 ;;61392-0017-30
 ;;9002226.02101,"747,61392-0017-51 ",.01)
 ;;61392-0017-51
 ;;9002226.02101,"747,61392-0017-51 ",.02)
 ;;61392-0017-51
 ;;9002226.02101,"747,61392-0017-54 ",.01)
 ;;61392-0017-54
 ;;9002226.02101,"747,61392-0017-54 ",.02)
 ;;61392-0017-54
 ;;9002226.02101,"747,61392-0017-56 ",.01)
 ;;61392-0017-56
 ;;9002226.02101,"747,61392-0017-56 ",.02)
 ;;61392-0017-56
 ;;9002226.02101,"747,61392-0017-60 ",.01)
 ;;61392-0017-60
 ;;9002226.02101,"747,61392-0017-60 ",.02)
 ;;61392-0017-60
 ;;9002226.02101,"747,61392-0017-90 ",.01)
 ;;61392-0017-90
 ;;9002226.02101,"747,61392-0017-90 ",.02)
 ;;61392-0017-90
 ;;9002226.02101,"747,61392-0017-91 ",.01)
 ;;61392-0017-91
 ;;9002226.02101,"747,61392-0017-91 ",.02)
 ;;61392-0017-91
 ;;9002226.02101,"747,61570-0019-01 ",.01)
 ;;61570-0019-01
 ;;9002226.02101,"747,61570-0019-01 ",.02)
 ;;61570-0019-01
 ;;9002226.02101,"747,61570-0020-01 ",.01)
 ;;61570-0020-01
 ;;9002226.02101,"747,61570-0020-01 ",.02)
 ;;61570-0020-01
 ;;9002226.02101,"747,61570-0022-01 ",.01)
 ;;61570-0022-01
 ;;9002226.02101,"747,61570-0022-01 ",.02)
 ;;61570-0022-01
 ;;9002226.02101,"747,63402-0711-01 ",.01)
 ;;63402-0711-01
 ;;9002226.02101,"747,63402-0711-01 ",.02)
 ;;63402-0711-01
 ;;9002226.02101,"747,63402-0712-01 ",.01)
 ;;63402-0712-01
 ;;9002226.02101,"747,63402-0712-01 ",.02)
 ;;63402-0712-01
 ;;9002226.02101,"747,63629-1639-01 ",.01)
 ;;63629-1639-01
 ;;9002226.02101,"747,63629-1639-01 ",.02)
 ;;63629-1639-01
 ;;9002226.02101,"747,63629-2792-01 ",.01)
 ;;63629-2792-01
 ;;9002226.02101,"747,63629-2792-01 ",.02)
 ;;63629-2792-01
 ;;9002226.02101,"747,63629-2792-02 ",.01)
 ;;63629-2792-02
 ;;9002226.02101,"747,63629-2792-02 ",.02)
 ;;63629-2792-02
 ;;9002226.02101,"747,63629-3551-01 ",.01)
 ;;63629-3551-01
 ;;9002226.02101,"747,63629-3551-01 ",.02)
 ;;63629-3551-01
 ;;9002226.02101,"747,63874-0443-01 ",.01)
 ;;63874-0443-01
 ;;9002226.02101,"747,63874-0443-01 ",.02)
 ;;63874-0443-01
 ;;9002226.02101,"747,63874-0443-15 ",.01)
 ;;63874-0443-15
 ;;9002226.02101,"747,63874-0443-15 ",.02)
 ;;63874-0443-15
 ;;9002226.02101,"747,63874-0443-20 ",.01)
 ;;63874-0443-20
 ;;9002226.02101,"747,63874-0443-20 ",.02)
 ;;63874-0443-20
 ;;9002226.02101,"747,63874-0443-30 ",.01)
 ;;63874-0443-30
 ;;9002226.02101,"747,63874-0443-30 ",.02)
 ;;63874-0443-30
 ;;9002226.02101,"747,63874-0447-01 ",.01)
 ;;63874-0447-01
 ;;9002226.02101,"747,63874-0447-01 ",.02)
 ;;63874-0447-01
 ;;9002226.02101,"747,63874-0447-15 ",.01)
 ;;63874-0447-15
 ;;9002226.02101,"747,63874-0447-15 ",.02)
 ;;63874-0447-15
 ;;9002226.02101,"747,63874-0447-20 ",.01)
 ;;63874-0447-20
 ;;9002226.02101,"747,63874-0447-20 ",.02)
 ;;63874-0447-20
 ;;9002226.02101,"747,63874-0447-30 ",.01)
 ;;63874-0447-30
 ;;9002226.02101,"747,63874-0447-30 ",.02)
 ;;63874-0447-30
 ;;9002226.02101,"747,63874-0447-60 ",.01)
 ;;63874-0447-60
 ;;9002226.02101,"747,63874-0447-60 ",.02)
 ;;63874-0447-60
 ;;9002226.02101,"747,63874-0675-01 ",.01)
 ;;63874-0675-01
 ;;9002226.02101,"747,63874-0675-01 ",.02)
 ;;63874-0675-01
 ;;9002226.02101,"747,63874-0675-15 ",.01)
 ;;63874-0675-15
 ;;9002226.02101,"747,63874-0675-15 ",.02)
 ;;63874-0675-15
 ;;9002226.02101,"747,63874-0675-20 ",.01)
 ;;63874-0675-20
 ;;9002226.02101,"747,63874-0675-20 ",.02)
 ;;63874-0675-20
 ;;9002226.02101,"747,63874-0675-30 ",.01)
 ;;63874-0675-30
 ;;9002226.02101,"747,63874-0675-30 ",.02)
 ;;63874-0675-30
 ;;9002226.02101,"747,63874-0714-20 ",.01)
 ;;63874-0714-20
 ;;9002226.02101,"747,63874-0714-20 ",.02)
 ;;63874-0714-20
 ;;9002226.02101,"747,63874-0744-12 ",.01)
 ;;63874-0744-12
 ;;9002226.02101,"747,63874-0744-12 ",.02)
 ;;63874-0744-12
 ;;9002226.02101,"747,63874-0744-24 ",.01)
 ;;63874-0744-24
 ;;9002226.02101,"747,63874-0744-24 ",.02)
 ;;63874-0744-24
 ;;9002226.02101,"747,64661-0814-16 ",.01)
 ;;64661-0814-16
 ;;9002226.02101,"747,64661-0814-16 ",.02)
 ;;64661-0814-16
 ;;9002226.02101,"747,65162-0324-10 ",.01)
 ;;65162-0324-10
 ;;9002226.02101,"747,65162-0324-10 ",.02)
 ;;65162-0324-10
 ;;9002226.02101,"747,65162-0324-11 ",.01)
 ;;65162-0324-11
 ;;9002226.02101,"747,65162-0324-11 ",.02)
 ;;65162-0324-11
 ;;9002226.02101,"747,65162-0325-10 ",.01)
 ;;65162-0325-10
 ;;9002226.02101,"747,65162-0325-10 ",.02)
 ;;65162-0325-10
 ;;9002226.02101,"747,65162-0325-11 ",.01)
 ;;65162-0325-11
 ;;9002226.02101,"747,65162-0325-11 ",.02)
 ;;65162-0325-11
 ;;9002226.02101,"747,65162-0335-10 ",.01)
 ;;65162-0335-10
 ;;9002226.02101,"747,65162-0335-10 ",.02)
 ;;65162-0335-10
 ;;9002226.02101,"747,66105-0164-02 ",.01)
 ;;66105-0164-02
 ;;9002226.02101,"747,66105-0164-02 ",.02)
 ;;66105-0164-02
 ;;9002226.02101,"747,66105-0164-03 ",.01)
 ;;66105-0164-03
 ;;9002226.02101,"747,66105-0164-03 ",.02)
 ;;66105-0164-03
 ;;9002226.02101,"747,66105-0164-06 ",.01)
 ;;66105-0164-06
 ;;9002226.02101,"747,66105-0164-06 ",.02)
 ;;66105-0164-06
 ;;9002226.02101,"747,66105-0164-09 ",.01)
 ;;66105-0164-09
 ;;9002226.02101,"747,66105-0164-09 ",.02)
 ;;66105-0164-09
 ;;9002226.02101,"747,66105-0164-10 ",.01)
 ;;66105-0164-10
 ;;9002226.02101,"747,66105-0164-10 ",.02)
 ;;66105-0164-10
 ;;9002226.02101,"747,66105-0501-06 ",.01)
 ;;66105-0501-06
 ;;9002226.02101,"747,66105-0501-06 ",.02)
 ;;66105-0501-06
 ;;9002226.02101,"747,66105-0502-06 ",.01)
 ;;66105-0502-06
 ;;9002226.02101,"747,66105-0502-06 ",.02)
 ;;66105-0502-06
 ;;9002226.02101,"747,66336-0596-30 ",.01)
 ;;66336-0596-30
 ;;9002226.02101,"747,66336-0596-30 ",.02)
 ;;66336-0596-30
 ;;9002226.02101,"747,67781-0251-01 ",.01)
 ;;67781-0251-01
 ;;9002226.02101,"747,67781-0251-01 ",.02)
 ;;67781-0251-01
 ;;9002226.02101,"747,67781-0251-05 ",.01)
 ;;67781-0251-05
 ;;9002226.02101,"747,67781-0251-05 ",.02)
 ;;67781-0251-05
 ;;9002226.02101,"747,67781-0252-01 ",.01)
 ;;67781-0252-01
 ;;9002226.02101,"747,67781-0252-01 ",.02)
 ;;67781-0252-01
 ;;9002226.02101,"747,67801-0305-03 ",.01)
 ;;67801-0305-03
 ;;9002226.02101,"747,67801-0305-03 ",.02)
 ;;67801-0305-03
 ;;9002226.02101,"747,68115-0328-60 ",.01)
 ;;68115-0328-60
 ;;9002226.02101,"747,68115-0328-60 ",.02)
 ;;68115-0328-60
 ;;9002226.02101,"747,68115-0547-20 ",.01)
 ;;68115-0547-20
 ;;9002226.02101,"747,68115-0547-20 ",.02)
 ;;68115-0547-20
 ;;9002226.02101,"747,68115-0638-60 ",.01)
 ;;68115-0638-60
 ;;9002226.02101,"747,68115-0638-60 ",.02)
 ;;68115-0638-60
 ;;9002226.02101,"747,68115-0652-01 ",.01)
 ;;68115-0652-01
 ;;9002226.02101,"747,68115-0652-01 ",.02)
 ;;68115-0652-01
 ;;9002226.02101,"747,68115-0653-01 ",.01)
 ;;68115-0653-01
 ;;9002226.02101,"747,68115-0653-01 ",.02)
 ;;68115-0653-01
 ;;9002226.02101,"747,68115-0657-01 ",.01)
 ;;68115-0657-01
 ;;9002226.02101,"747,68115-0657-01 ",.02)
 ;;68115-0657-01
 ;;9002226.02101,"747,68115-0760-01 ",.01)
 ;;68115-0760-01
 ;;9002226.02101,"747,68115-0760-01 ",.02)
 ;;68115-0760-01
 ;;9002226.02101,"747,68115-0775-07 ",.01)
 ;;68115-0775-07
 ;;9002226.02101,"747,68115-0775-07 ",.02)
 ;;68115-0775-07
 ;;9002226.02101,"747,68115-0923-30 ",.01)
 ;;68115-0923-30
 ;;9002226.02101,"747,68115-0923-30 ",.02)
 ;;68115-0923-30
 ;;9002226.02101,"747,68115-0923-90 ",.01)
 ;;68115-0923-90
 ;;9002226.02101,"747,68115-0923-90 ",.02)
 ;;68115-0923-90
 ;;9002226.02101,"747,68115-0924-60 ",.01)
 ;;68115-0924-60
 ;;9002226.02101,"747,68115-0924-60 ",.02)
 ;;68115-0924-60
 ;;9002226.02101,"747,68258-3031-01 ",.01)
 ;;68258-3031-01
 ;;9002226.02101,"747,68258-3031-01 ",.02)
 ;;68258-3031-01
 ;;9002226.02101,"747,68258-3032-03 ",.01)
 ;;68258-3032-03
 ;;9002226.02101,"747,68258-3032-03 ",.02)
 ;;68258-3032-03
 ;;9002226.02101,"747,68258-3033-03 ",.01)
 ;;68258-3033-03
 ;;9002226.02101,"747,68258-3033-03 ",.02)
 ;;68258-3033-03
 ;;9002226.02101,"747,68462-0356-01 ",.01)
 ;;68462-0356-01
 ;;9002226.02101,"747,68462-0356-01 ",.02)
 ;;68462-0356-01
 ;;9002226.02101,"747,68462-0380-01 ",.01)
 ;;68462-0380-01
 ;;9002226.02101,"747,68462-0380-01 ",.02)
 ;;68462-0380-01
 ;;9002226.02101,"747,68734-0700-10 ",.01)
 ;;68734-0700-10
 ;;9002226.02101,"747,68734-0700-10 ",.02)
 ;;68734-0700-10
 ;;9002226.02101,"747,68734-0710-10 ",.01)
 ;;68734-0710-10
 ;;9002226.02101,"747,68734-0710-10 ",.02)
 ;;68734-0710-10
