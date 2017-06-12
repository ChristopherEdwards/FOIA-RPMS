BGP71U31 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 11, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1733,42291-0394-10 ",.01)
 ;;42291-0394-10
 ;;9002226.02101,"1733,42291-0394-10 ",.02)
 ;;42291-0394-10
 ;;9002226.02101,"1733,42291-0394-30 ",.01)
 ;;42291-0394-30
 ;;9002226.02101,"1733,42291-0394-30 ",.02)
 ;;42291-0394-30
 ;;9002226.02101,"1733,42291-0394-90 ",.01)
 ;;42291-0394-90
 ;;9002226.02101,"1733,42291-0394-90 ",.02)
 ;;42291-0394-90
 ;;9002226.02101,"1733,42291-0395-10 ",.01)
 ;;42291-0395-10
 ;;9002226.02101,"1733,42291-0395-10 ",.02)
 ;;42291-0395-10
 ;;9002226.02101,"1733,42291-0395-30 ",.01)
 ;;42291-0395-30
 ;;9002226.02101,"1733,42291-0395-30 ",.02)
 ;;42291-0395-30
 ;;9002226.02101,"1733,42291-0395-90 ",.01)
 ;;42291-0395-90
 ;;9002226.02101,"1733,42291-0395-90 ",.02)
 ;;42291-0395-90
 ;;9002226.02101,"1733,42291-0701-90 ",.01)
 ;;42291-0701-90
 ;;9002226.02101,"1733,42291-0701-90 ",.02)
 ;;42291-0701-90
 ;;9002226.02101,"1733,42291-0702-90 ",.01)
 ;;42291-0702-90
 ;;9002226.02101,"1733,42291-0702-90 ",.02)
 ;;42291-0702-90
 ;;9002226.02101,"1733,42291-0703-90 ",.01)
 ;;42291-0703-90
 ;;9002226.02101,"1733,42291-0703-90 ",.02)
 ;;42291-0703-90
 ;;9002226.02101,"1733,42291-0704-90 ",.01)
 ;;42291-0704-90
 ;;9002226.02101,"1733,42291-0704-90 ",.02)
 ;;42291-0704-90
 ;;9002226.02101,"1733,42291-0705-90 ",.01)
 ;;42291-0705-90
 ;;9002226.02101,"1733,42291-0705-90 ",.02)
 ;;42291-0705-90
 ;;9002226.02101,"1733,42291-0706-90 ",.01)
 ;;42291-0706-90
 ;;9002226.02101,"1733,42291-0706-90 ",.02)
 ;;42291-0706-90
 ;;9002226.02101,"1733,42291-0707-90 ",.01)
 ;;42291-0707-90
 ;;9002226.02101,"1733,42291-0707-90 ",.02)
 ;;42291-0707-90
 ;;9002226.02101,"1733,42291-0837-01 ",.01)
 ;;42291-0837-01
 ;;9002226.02101,"1733,42291-0837-01 ",.02)
 ;;42291-0837-01
 ;;9002226.02101,"1733,42291-0838-01 ",.01)
 ;;42291-0838-01
 ;;9002226.02101,"1733,42291-0838-01 ",.02)
 ;;42291-0838-01
 ;;9002226.02101,"1733,42291-0839-01 ",.01)
 ;;42291-0839-01
 ;;9002226.02101,"1733,42291-0839-01 ",.02)
 ;;42291-0839-01
 ;;9002226.02101,"1733,42291-0876-90 ",.01)
 ;;42291-0876-90
 ;;9002226.02101,"1733,42291-0876-90 ",.02)
 ;;42291-0876-90
 ;;9002226.02101,"1733,42291-0877-10 ",.01)
 ;;42291-0877-10
 ;;9002226.02101,"1733,42291-0877-10 ",.02)
 ;;42291-0877-10
 ;;9002226.02101,"1733,42291-0877-90 ",.01)
 ;;42291-0877-90
 ;;9002226.02101,"1733,42291-0877-90 ",.02)
 ;;42291-0877-90
 ;;9002226.02101,"1733,42291-0878-10 ",.01)
 ;;42291-0878-10
 ;;9002226.02101,"1733,42291-0878-10 ",.02)
 ;;42291-0878-10
 ;;9002226.02101,"1733,42291-0878-90 ",.01)
 ;;42291-0878-90
 ;;9002226.02101,"1733,42291-0878-90 ",.02)
 ;;42291-0878-90
 ;;9002226.02101,"1733,42291-0879-50 ",.01)
 ;;42291-0879-50
 ;;9002226.02101,"1733,42291-0879-50 ",.02)
 ;;42291-0879-50
 ;;9002226.02101,"1733,42291-0879-90 ",.01)
 ;;42291-0879-90
 ;;9002226.02101,"1733,42291-0879-90 ",.02)
 ;;42291-0879-90
 ;;9002226.02101,"1733,42291-0880-90 ",.01)
 ;;42291-0880-90
 ;;9002226.02101,"1733,42291-0880-90 ",.02)
 ;;42291-0880-90
 ;;9002226.02101,"1733,42291-0881-10 ",.01)
 ;;42291-0881-10
 ;;9002226.02101,"1733,42291-0881-10 ",.02)
 ;;42291-0881-10
 ;;9002226.02101,"1733,42291-0881-90 ",.01)
 ;;42291-0881-90
 ;;9002226.02101,"1733,42291-0881-90 ",.02)
 ;;42291-0881-90
 ;;9002226.02101,"1733,42291-0882-10 ",.01)
 ;;42291-0882-10
 ;;9002226.02101,"1733,42291-0882-10 ",.02)
 ;;42291-0882-10
 ;;9002226.02101,"1733,42291-0882-90 ",.01)
 ;;42291-0882-90
 ;;9002226.02101,"1733,42291-0882-90 ",.02)
 ;;42291-0882-90
 ;;9002226.02101,"1733,42291-0883-50 ",.01)
 ;;42291-0883-50
 ;;9002226.02101,"1733,42291-0883-50 ",.02)
 ;;42291-0883-50
 ;;9002226.02101,"1733,42291-0883-90 ",.01)
 ;;42291-0883-90
 ;;9002226.02101,"1733,42291-0883-90 ",.02)
 ;;42291-0883-90
 ;;9002226.02101,"1733,42291-0884-90 ",.01)
 ;;42291-0884-90
 ;;9002226.02101,"1733,42291-0884-90 ",.02)
 ;;42291-0884-90
 ;;9002226.02101,"1733,42291-0885-90 ",.01)
 ;;42291-0885-90
 ;;9002226.02101,"1733,42291-0885-90 ",.02)
 ;;42291-0885-90
 ;;9002226.02101,"1733,42291-0886-90 ",.01)
 ;;42291-0886-90
 ;;9002226.02101,"1733,42291-0886-90 ",.02)
 ;;42291-0886-90
 ;;9002226.02101,"1733,42291-0887-90 ",.01)
 ;;42291-0887-90
 ;;9002226.02101,"1733,42291-0887-90 ",.02)
 ;;42291-0887-90
 ;;9002226.02101,"1733,42291-0888-90 ",.01)
 ;;42291-0888-90
 ;;9002226.02101,"1733,42291-0888-90 ",.02)
 ;;42291-0888-90
 ;;9002226.02101,"1733,42549-0700-90 ",.01)
 ;;42549-0700-90
 ;;9002226.02101,"1733,42549-0700-90 ",.02)
 ;;42549-0700-90
 ;;9002226.02101,"1733,42549-0707-90 ",.01)
 ;;42549-0707-90
 ;;9002226.02101,"1733,42549-0707-90 ",.02)
 ;;42549-0707-90
 ;;9002226.02101,"1733,42571-0110-10 ",.01)
 ;;42571-0110-10
 ;;9002226.02101,"1733,42571-0110-10 ",.02)
 ;;42571-0110-10
 ;;9002226.02101,"1733,42571-0110-90 ",.01)
 ;;42571-0110-90
 ;;9002226.02101,"1733,42571-0110-90 ",.02)
 ;;42571-0110-90
 ;;9002226.02101,"1733,42571-0111-10 ",.01)
 ;;42571-0111-10
 ;;9002226.02101,"1733,42571-0111-10 ",.02)
 ;;42571-0111-10
 ;;9002226.02101,"1733,42571-0111-90 ",.01)
 ;;42571-0111-90
 ;;9002226.02101,"1733,42571-0111-90 ",.02)
 ;;42571-0111-90
 ;;9002226.02101,"1733,42571-0112-10 ",.01)
 ;;42571-0112-10
 ;;9002226.02101,"1733,42571-0112-10 ",.02)
 ;;42571-0112-10
 ;;9002226.02101,"1733,42571-0112-90 ",.01)
 ;;42571-0112-90
 ;;9002226.02101,"1733,42571-0112-90 ",.02)
 ;;42571-0112-90
 ;;9002226.02101,"1733,42806-0052-01 ",.01)
 ;;42806-0052-01
 ;;9002226.02101,"1733,42806-0052-01 ",.02)
 ;;42806-0052-01
 ;;9002226.02101,"1733,42806-0053-01 ",.01)
 ;;42806-0053-01
 ;;9002226.02101,"1733,42806-0053-01 ",.02)
 ;;42806-0053-01
 ;;9002226.02101,"1733,42806-0054-01 ",.01)
 ;;42806-0054-01
 ;;9002226.02101,"1733,42806-0054-01 ",.02)
 ;;42806-0054-01
 ;;9002226.02101,"1733,43063-0007-01 ",.01)
 ;;43063-0007-01
 ;;9002226.02101,"1733,43063-0007-01 ",.02)
 ;;43063-0007-01
 ;;9002226.02101,"1733,43063-0007-14 ",.01)
 ;;43063-0007-14
 ;;9002226.02101,"1733,43063-0007-14 ",.02)
 ;;43063-0007-14
 ;;9002226.02101,"1733,43063-0007-30 ",.01)
 ;;43063-0007-30
 ;;9002226.02101,"1733,43063-0007-30 ",.02)
 ;;43063-0007-30
 ;;9002226.02101,"1733,43063-0007-60 ",.01)
 ;;43063-0007-60
 ;;9002226.02101,"1733,43063-0007-60 ",.02)
 ;;43063-0007-60
 ;;9002226.02101,"1733,43063-0007-90 ",.01)
 ;;43063-0007-90
 ;;9002226.02101,"1733,43063-0007-90 ",.02)
 ;;43063-0007-90
 ;;9002226.02101,"1733,43063-0007-98 ",.01)
 ;;43063-0007-98
 ;;9002226.02101,"1733,43063-0007-98 ",.02)
 ;;43063-0007-98
 ;;9002226.02101,"1733,43063-0032-01 ",.01)
 ;;43063-0032-01
 ;;9002226.02101,"1733,43063-0032-01 ",.02)
 ;;43063-0032-01
 ;;9002226.02101,"1733,43063-0065-30 ",.01)
 ;;43063-0065-30
 ;;9002226.02101,"1733,43063-0065-30 ",.02)
 ;;43063-0065-30
 ;;9002226.02101,"1733,43063-0065-90 ",.01)
 ;;43063-0065-90
 ;;9002226.02101,"1733,43063-0065-90 ",.02)
 ;;43063-0065-90
 ;;9002226.02101,"1733,43063-0118-30 ",.01)
 ;;43063-0118-30
 ;;9002226.02101,"1733,43063-0118-30 ",.02)
 ;;43063-0118-30
 ;;9002226.02101,"1733,43063-0118-90 ",.01)
 ;;43063-0118-90
 ;;9002226.02101,"1733,43063-0118-90 ",.02)
 ;;43063-0118-90
 ;;9002226.02101,"1733,43063-0130-90 ",.01)
 ;;43063-0130-90
 ;;9002226.02101,"1733,43063-0130-90 ",.02)
 ;;43063-0130-90
 ;;9002226.02101,"1733,43063-0131-30 ",.01)
 ;;43063-0131-30
 ;;9002226.02101,"1733,43063-0131-30 ",.02)
 ;;43063-0131-30
 ;;9002226.02101,"1733,43063-0132-30 ",.01)
 ;;43063-0132-30
 ;;9002226.02101,"1733,43063-0132-30 ",.02)
 ;;43063-0132-30
 ;;9002226.02101,"1733,43063-0138-90 ",.01)
 ;;43063-0138-90
 ;;9002226.02101,"1733,43063-0138-90 ",.02)
 ;;43063-0138-90
 ;;9002226.02101,"1733,43063-0146-30 ",.01)
 ;;43063-0146-30
 ;;9002226.02101,"1733,43063-0146-30 ",.02)
 ;;43063-0146-30
 ;;9002226.02101,"1733,43063-0171-14 ",.01)
 ;;43063-0171-14
 ;;9002226.02101,"1733,43063-0171-14 ",.02)
 ;;43063-0171-14
 ;;9002226.02101,"1733,43063-0232-30 ",.01)
 ;;43063-0232-30
 ;;9002226.02101,"1733,43063-0232-30 ",.02)
 ;;43063-0232-30
 ;;9002226.02101,"1733,43063-0232-60 ",.01)
 ;;43063-0232-60
 ;;9002226.02101,"1733,43063-0232-60 ",.02)
 ;;43063-0232-60
 ;;9002226.02101,"1733,43063-0233-60 ",.01)
 ;;43063-0233-60
 ;;9002226.02101,"1733,43063-0233-60 ",.02)
 ;;43063-0233-60
 ;;9002226.02101,"1733,43063-0234-60 ",.01)
 ;;43063-0234-60
 ;;9002226.02101,"1733,43063-0234-60 ",.02)
 ;;43063-0234-60
 ;;9002226.02101,"1733,43063-0288-30 ",.01)
 ;;43063-0288-30
 ;;9002226.02101,"1733,43063-0288-30 ",.02)
 ;;43063-0288-30
 ;;9002226.02101,"1733,43063-0288-90 ",.01)
 ;;43063-0288-90
 ;;9002226.02101,"1733,43063-0288-90 ",.02)
 ;;43063-0288-90
 ;;9002226.02101,"1733,43063-0303-30 ",.01)
 ;;43063-0303-30
 ;;9002226.02101,"1733,43063-0303-30 ",.02)
 ;;43063-0303-30
 ;;9002226.02101,"1733,43063-0303-90 ",.01)
 ;;43063-0303-90
 ;;9002226.02101,"1733,43063-0303-90 ",.02)
 ;;43063-0303-90
 ;;9002226.02101,"1733,43063-0347-30 ",.01)
 ;;43063-0347-30
 ;;9002226.02101,"1733,43063-0347-30 ",.02)
 ;;43063-0347-30
 ;;9002226.02101,"1733,43063-0402-60 ",.01)
 ;;43063-0402-60
 ;;9002226.02101,"1733,43063-0402-60 ",.02)
 ;;43063-0402-60
 ;;9002226.02101,"1733,43063-0403-30 ",.01)
 ;;43063-0403-30
 ;;9002226.02101,"1733,43063-0403-30 ",.02)
 ;;43063-0403-30
 ;;9002226.02101,"1733,43063-0414-01 ",.01)
 ;;43063-0414-01
 ;;9002226.02101,"1733,43063-0414-01 ",.02)
 ;;43063-0414-01
 ;;9002226.02101,"1733,43063-0414-90 ",.01)
 ;;43063-0414-90
 ;;9002226.02101,"1733,43063-0414-90 ",.02)
 ;;43063-0414-90
 ;;9002226.02101,"1733,43063-0458-30 ",.01)
 ;;43063-0458-30
 ;;9002226.02101,"1733,43063-0458-30 ",.02)
 ;;43063-0458-30
 ;;9002226.02101,"1733,43063-0458-90 ",.01)
 ;;43063-0458-90
 ;;9002226.02101,"1733,43063-0458-90 ",.02)
 ;;43063-0458-90
 ;;9002226.02101,"1733,43063-0482-90 ",.01)
 ;;43063-0482-90
 ;;9002226.02101,"1733,43063-0482-90 ",.02)
 ;;43063-0482-90
 ;;9002226.02101,"1733,43063-0485-90 ",.01)
 ;;43063-0485-90
 ;;9002226.02101,"1733,43063-0485-90 ",.02)
 ;;43063-0485-90
 ;;9002226.02101,"1733,43063-0502-30 ",.01)
 ;;43063-0502-30
 ;;9002226.02101,"1733,43063-0502-30 ",.02)
 ;;43063-0502-30
 ;;9002226.02101,"1733,43063-0525-30 ",.01)
 ;;43063-0525-30
 ;;9002226.02101,"1733,43063-0525-30 ",.02)
 ;;43063-0525-30
 ;;9002226.02101,"1733,43063-0525-90 ",.01)
 ;;43063-0525-90
 ;;9002226.02101,"1733,43063-0525-90 ",.02)
 ;;43063-0525-90
 ;;9002226.02101,"1733,43063-0571-90 ",.01)
 ;;43063-0571-90
 ;;9002226.02101,"1733,43063-0571-90 ",.02)
 ;;43063-0571-90
 ;;9002226.02101,"1733,43353-0009-30 ",.01)
 ;;43353-0009-30
 ;;9002226.02101,"1733,43353-0009-30 ",.02)
 ;;43353-0009-30
 ;;9002226.02101,"1733,43353-0009-60 ",.01)
 ;;43353-0009-60
 ;;9002226.02101,"1733,43353-0009-60 ",.02)
 ;;43353-0009-60
 ;;9002226.02101,"1733,43353-0037-30 ",.01)
 ;;43353-0037-30
 ;;9002226.02101,"1733,43353-0037-30 ",.02)
 ;;43353-0037-30
 ;;9002226.02101,"1733,43353-0037-60 ",.01)
 ;;43353-0037-60
 ;;9002226.02101,"1733,43353-0037-60 ",.02)
 ;;43353-0037-60
 ;;9002226.02101,"1733,43353-0037-80 ",.01)
 ;;43353-0037-80
 ;;9002226.02101,"1733,43353-0037-80 ",.02)
 ;;43353-0037-80
 ;;9002226.02101,"1733,43353-0045-80 ",.01)
 ;;43353-0045-80
 ;;9002226.02101,"1733,43353-0045-80 ",.02)
 ;;43353-0045-80
 ;;9002226.02101,"1733,43353-0057-60 ",.01)
 ;;43353-0057-60
 ;;9002226.02101,"1733,43353-0057-60 ",.02)
 ;;43353-0057-60
 ;;9002226.02101,"1733,43353-0059-17 ",.01)
 ;;43353-0059-17
 ;;9002226.02101,"1733,43353-0059-17 ",.02)
 ;;43353-0059-17
 ;;9002226.02101,"1733,43353-0059-30 ",.01)
 ;;43353-0059-30
 ;;9002226.02101,"1733,43353-0059-30 ",.02)
 ;;43353-0059-30
 ;;9002226.02101,"1733,43353-0066-17 ",.01)
 ;;43353-0066-17
 ;;9002226.02101,"1733,43353-0066-17 ",.02)
 ;;43353-0066-17
 ;;9002226.02101,"1733,43353-0067-83 ",.01)
 ;;43353-0067-83