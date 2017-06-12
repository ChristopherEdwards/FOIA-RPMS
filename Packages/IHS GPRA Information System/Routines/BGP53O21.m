BGP53O21 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 24, 2015;
 ;;15.1;IHS CLINICAL REPORTING;;MAY 06, 2015;Build 143
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1064,58016-0228-90 ",.01)
 ;;58016-0228-90
 ;;9002226.02101,"1064,58016-0228-90 ",.02)
 ;;58016-0228-90
 ;;9002226.02101,"1064,58016-0363-00 ",.01)
 ;;58016-0363-00
 ;;9002226.02101,"1064,58016-0363-00 ",.02)
 ;;58016-0363-00
 ;;9002226.02101,"1064,58016-0363-14 ",.01)
 ;;58016-0363-14
 ;;9002226.02101,"1064,58016-0363-14 ",.02)
 ;;58016-0363-14
 ;;9002226.02101,"1064,58016-0363-21 ",.01)
 ;;58016-0363-21
 ;;9002226.02101,"1064,58016-0363-21 ",.02)
 ;;58016-0363-21
 ;;9002226.02101,"1064,58016-0363-30 ",.01)
 ;;58016-0363-30
 ;;9002226.02101,"1064,58016-0363-30 ",.02)
 ;;58016-0363-30
 ;;9002226.02101,"1064,58016-0363-60 ",.01)
 ;;58016-0363-60
 ;;9002226.02101,"1064,58016-0363-60 ",.02)
 ;;58016-0363-60
 ;;9002226.02101,"1064,58016-0420-00 ",.01)
 ;;58016-0420-00
 ;;9002226.02101,"1064,58016-0420-00 ",.02)
 ;;58016-0420-00
 ;;9002226.02101,"1064,58016-0420-10 ",.01)
 ;;58016-0420-10
 ;;9002226.02101,"1064,58016-0420-10 ",.02)
 ;;58016-0420-10
 ;;9002226.02101,"1064,58016-0420-30 ",.01)
 ;;58016-0420-30
 ;;9002226.02101,"1064,58016-0420-30 ",.02)
 ;;58016-0420-30
 ;;9002226.02101,"1064,58016-0420-60 ",.01)
 ;;58016-0420-60
 ;;9002226.02101,"1064,58016-0420-60 ",.02)
 ;;58016-0420-60
 ;;9002226.02101,"1064,58016-0420-90 ",.01)
 ;;58016-0420-90
 ;;9002226.02101,"1064,58016-0420-90 ",.02)
 ;;58016-0420-90
 ;;9002226.02101,"1064,58016-0564-00 ",.01)
 ;;58016-0564-00
 ;;9002226.02101,"1064,58016-0564-00 ",.02)
 ;;58016-0564-00
 ;;9002226.02101,"1064,58016-0564-30 ",.01)
 ;;58016-0564-30
 ;;9002226.02101,"1064,58016-0564-30 ",.02)
 ;;58016-0564-30
 ;;9002226.02101,"1064,58016-0564-60 ",.01)
 ;;58016-0564-60
 ;;9002226.02101,"1064,58016-0564-60 ",.02)
 ;;58016-0564-60
 ;;9002226.02101,"1064,58016-0564-90 ",.01)
 ;;58016-0564-90
 ;;9002226.02101,"1064,58016-0564-90 ",.02)
 ;;58016-0564-90
 ;;9002226.02101,"1064,58016-0571-00 ",.01)
 ;;58016-0571-00
 ;;9002226.02101,"1064,58016-0571-00 ",.02)
 ;;58016-0571-00
 ;;9002226.02101,"1064,58016-0571-30 ",.01)
 ;;58016-0571-30
 ;;9002226.02101,"1064,58016-0571-30 ",.02)
 ;;58016-0571-30
 ;;9002226.02101,"1064,58016-0571-60 ",.01)
 ;;58016-0571-60
 ;;9002226.02101,"1064,58016-0571-60 ",.02)
 ;;58016-0571-60
 ;;9002226.02101,"1064,58016-0571-90 ",.01)
 ;;58016-0571-90
 ;;9002226.02101,"1064,58016-0571-90 ",.02)
 ;;58016-0571-90
 ;;9002226.02101,"1064,58016-0579-00 ",.01)
 ;;58016-0579-00
 ;;9002226.02101,"1064,58016-0579-00 ",.02)
 ;;58016-0579-00
 ;;9002226.02101,"1064,58016-0579-20 ",.01)
 ;;58016-0579-20
 ;;9002226.02101,"1064,58016-0579-20 ",.02)
 ;;58016-0579-20
 ;;9002226.02101,"1064,58016-0579-30 ",.01)
 ;;58016-0579-30
 ;;9002226.02101,"1064,58016-0579-30 ",.02)
 ;;58016-0579-30
 ;;9002226.02101,"1064,58016-0579-60 ",.01)
 ;;58016-0579-60
 ;;9002226.02101,"1064,58016-0579-60 ",.02)
 ;;58016-0579-60
 ;;9002226.02101,"1064,58016-0580-20 ",.01)
 ;;58016-0580-20
 ;;9002226.02101,"1064,58016-0580-20 ",.02)
 ;;58016-0580-20
 ;;9002226.02101,"1064,58016-0580-30 ",.01)
 ;;58016-0580-30
 ;;9002226.02101,"1064,58016-0580-30 ",.02)
 ;;58016-0580-30
 ;;9002226.02101,"1064,58016-0580-60 ",.01)
 ;;58016-0580-60
 ;;9002226.02101,"1064,58016-0580-60 ",.02)
 ;;58016-0580-60
 ;;9002226.02101,"1064,58016-0581-00 ",.01)
 ;;58016-0581-00
 ;;9002226.02101,"1064,58016-0581-00 ",.02)
 ;;58016-0581-00
 ;;9002226.02101,"1064,58016-0581-20 ",.01)
 ;;58016-0581-20
 ;;9002226.02101,"1064,58016-0581-20 ",.02)
 ;;58016-0581-20
 ;;9002226.02101,"1064,58016-0581-30 ",.01)
 ;;58016-0581-30
 ;;9002226.02101,"1064,58016-0581-30 ",.02)
 ;;58016-0581-30
 ;;9002226.02101,"1064,58016-0581-60 ",.01)
 ;;58016-0581-60
 ;;9002226.02101,"1064,58016-0581-60 ",.02)
 ;;58016-0581-60
 ;;9002226.02101,"1064,58016-0646-00 ",.01)
 ;;58016-0646-00
 ;;9002226.02101,"1064,58016-0646-00 ",.02)
 ;;58016-0646-00
 ;;9002226.02101,"1064,58016-0646-30 ",.01)
 ;;58016-0646-30
 ;;9002226.02101,"1064,58016-0646-30 ",.02)
 ;;58016-0646-30
 ;;9002226.02101,"1064,58016-0646-60 ",.01)
 ;;58016-0646-60
 ;;9002226.02101,"1064,58016-0646-60 ",.02)
 ;;58016-0646-60
 ;;9002226.02101,"1064,58016-0646-90 ",.01)
 ;;58016-0646-90
 ;;9002226.02101,"1064,58016-0646-90 ",.02)
 ;;58016-0646-90
 ;;9002226.02101,"1064,58016-0685-00 ",.01)
 ;;58016-0685-00
 ;;9002226.02101,"1064,58016-0685-00 ",.02)
 ;;58016-0685-00
 ;;9002226.02101,"1064,58016-0685-10 ",.01)
 ;;58016-0685-10
 ;;9002226.02101,"1064,58016-0685-10 ",.02)
 ;;58016-0685-10
 ;;9002226.02101,"1064,58016-0685-30 ",.01)
 ;;58016-0685-30
 ;;9002226.02101,"1064,58016-0685-30 ",.02)
 ;;58016-0685-30
 ;;9002226.02101,"1064,58016-0685-60 ",.01)
 ;;58016-0685-60
 ;;9002226.02101,"1064,58016-0685-60 ",.02)
 ;;58016-0685-60
 ;;9002226.02101,"1064,58016-0685-90 ",.01)
 ;;58016-0685-90
 ;;9002226.02101,"1064,58016-0685-90 ",.02)
 ;;58016-0685-90
 ;;9002226.02101,"1064,58016-0686-00 ",.01)
 ;;58016-0686-00
 ;;9002226.02101,"1064,58016-0686-00 ",.02)
 ;;58016-0686-00
 ;;9002226.02101,"1064,58016-0686-10 ",.01)
 ;;58016-0686-10
 ;;9002226.02101,"1064,58016-0686-10 ",.02)
 ;;58016-0686-10
 ;;9002226.02101,"1064,58016-0686-30 ",.01)
 ;;58016-0686-30
 ;;9002226.02101,"1064,58016-0686-30 ",.02)
 ;;58016-0686-30
 ;;9002226.02101,"1064,58016-0686-60 ",.01)
 ;;58016-0686-60
 ;;9002226.02101,"1064,58016-0686-60 ",.02)
 ;;58016-0686-60
 ;;9002226.02101,"1064,58016-0686-90 ",.01)
 ;;58016-0686-90
 ;;9002226.02101,"1064,58016-0686-90 ",.02)
 ;;58016-0686-90
 ;;9002226.02101,"1064,58016-0760-30 ",.01)
 ;;58016-0760-30
 ;;9002226.02101,"1064,58016-0760-30 ",.02)
 ;;58016-0760-30
 ;;9002226.02101,"1064,58016-0917-00 ",.01)
 ;;58016-0917-00
 ;;9002226.02101,"1064,58016-0917-00 ",.02)
 ;;58016-0917-00
 ;;9002226.02101,"1064,58016-0917-30 ",.01)
 ;;58016-0917-30
 ;;9002226.02101,"1064,58016-0917-30 ",.02)
 ;;58016-0917-30
 ;;9002226.02101,"1064,58016-0917-60 ",.01)
 ;;58016-0917-60
 ;;9002226.02101,"1064,58016-0917-60 ",.02)
 ;;58016-0917-60
 ;;9002226.02101,"1064,58016-0917-90 ",.01)
 ;;58016-0917-90
 ;;9002226.02101,"1064,58016-0917-90 ",.02)
 ;;58016-0917-90
 ;;9002226.02101,"1064,58016-0956-00 ",.01)
 ;;58016-0956-00
 ;;9002226.02101,"1064,58016-0956-00 ",.02)
 ;;58016-0956-00
 ;;9002226.02101,"1064,58016-0956-30 ",.01)
 ;;58016-0956-30
 ;;9002226.02101,"1064,58016-0956-30 ",.02)
 ;;58016-0956-30
 ;;9002226.02101,"1064,58016-0956-60 ",.01)
 ;;58016-0956-60
 ;;9002226.02101,"1064,58016-0956-60 ",.02)
 ;;58016-0956-60
 ;;9002226.02101,"1064,58016-0956-90 ",.01)
 ;;58016-0956-90
 ;;9002226.02101,"1064,58016-0956-90 ",.02)
 ;;58016-0956-90
 ;;9002226.02101,"1064,58016-0963-00 ",.01)
 ;;58016-0963-00
 ;;9002226.02101,"1064,58016-0963-00 ",.02)
 ;;58016-0963-00
 ;;9002226.02101,"1064,58016-0963-30 ",.01)
 ;;58016-0963-30
 ;;9002226.02101,"1064,58016-0963-30 ",.02)
 ;;58016-0963-30
 ;;9002226.02101,"1064,58016-0963-60 ",.01)
 ;;58016-0963-60
 ;;9002226.02101,"1064,58016-0963-60 ",.02)
 ;;58016-0963-60
 ;;9002226.02101,"1064,58016-0963-90 ",.01)
 ;;58016-0963-90
 ;;9002226.02101,"1064,58016-0963-90 ",.02)
 ;;58016-0963-90
 ;;9002226.02101,"1064,58016-0998-30 ",.01)
 ;;58016-0998-30
 ;;9002226.02101,"1064,58016-0998-30 ",.02)
 ;;58016-0998-30
 ;;9002226.02101,"1064,58016-0998-60 ",.01)
 ;;58016-0998-60
 ;;9002226.02101,"1064,58016-0998-60 ",.02)
 ;;58016-0998-60
 ;;9002226.02101,"1064,58016-0998-90 ",.01)
 ;;58016-0998-90
 ;;9002226.02101,"1064,58016-0998-90 ",.02)
 ;;58016-0998-90
 ;;9002226.02101,"1064,58864-0006-30 ",.01)
 ;;58864-0006-30
 ;;9002226.02101,"1064,58864-0006-30 ",.02)
 ;;58864-0006-30
 ;;9002226.02101,"1064,58864-0066-28 ",.01)
 ;;58864-0066-28
 ;;9002226.02101,"1064,58864-0066-28 ",.02)
 ;;58864-0066-28
 ;;9002226.02101,"1064,58864-0603-15 ",.01)
 ;;58864-0603-15
 ;;9002226.02101,"1064,58864-0603-15 ",.02)
 ;;58864-0603-15
 ;;9002226.02101,"1064,58864-0603-30 ",.01)
 ;;58864-0603-30
 ;;9002226.02101,"1064,58864-0603-30 ",.02)
 ;;58864-0603-30
 ;;9002226.02101,"1064,58864-0603-90 ",.01)
 ;;58864-0603-90
 ;;9002226.02101,"1064,58864-0603-90 ",.02)
 ;;58864-0603-90
 ;;9002226.02101,"1064,58864-0618-15 ",.01)
 ;;58864-0618-15
 ;;9002226.02101,"1064,58864-0618-15 ",.02)
 ;;58864-0618-15
 ;;9002226.02101,"1064,58864-0618-30 ",.01)
 ;;58864-0618-30
 ;;9002226.02101,"1064,58864-0618-30 ",.02)
 ;;58864-0618-30
 ;;9002226.02101,"1064,58864-0654-30 ",.01)
 ;;58864-0654-30
 ;;9002226.02101,"1064,58864-0654-30 ",.02)
 ;;58864-0654-30
 ;;9002226.02101,"1064,58864-0661-30 ",.01)
 ;;58864-0661-30
 ;;9002226.02101,"1064,58864-0661-30 ",.02)
 ;;58864-0661-30
 ;;9002226.02101,"1064,58864-0674-30 ",.01)
 ;;58864-0674-30
 ;;9002226.02101,"1064,58864-0674-30 ",.02)
 ;;58864-0674-30
 ;;9002226.02101,"1064,58864-0750-30 ",.01)
 ;;58864-0750-30
 ;;9002226.02101,"1064,58864-0750-30 ",.02)
 ;;58864-0750-30
 ;;9002226.02101,"1064,58864-0753-30 ",.01)
 ;;58864-0753-30
 ;;9002226.02101,"1064,58864-0753-30 ",.02)
 ;;58864-0753-30
 ;;9002226.02101,"1064,58864-0753-90 ",.01)
 ;;58864-0753-90
 ;;9002226.02101,"1064,58864-0753-90 ",.02)
 ;;58864-0753-90
 ;;9002226.02101,"1064,58864-0754-30 ",.01)
 ;;58864-0754-30
 ;;9002226.02101,"1064,58864-0754-30 ",.02)
 ;;58864-0754-30
 ;;9002226.02101,"1064,58864-0755-30 ",.01)
 ;;58864-0755-30
 ;;9002226.02101,"1064,58864-0755-30 ",.02)
 ;;58864-0755-30
 ;;9002226.02101,"1064,58864-0762-30 ",.01)
 ;;58864-0762-30
 ;;9002226.02101,"1064,58864-0762-30 ",.02)
 ;;58864-0762-30
 ;;9002226.02101,"1064,58864-0838-30 ",.01)
 ;;58864-0838-30
 ;;9002226.02101,"1064,58864-0838-30 ",.02)
 ;;58864-0838-30
 ;;9002226.02101,"1064,58864-0847-30 ",.01)
 ;;58864-0847-30
 ;;9002226.02101,"1064,58864-0847-30 ",.02)
 ;;58864-0847-30
 ;;9002226.02101,"1064,58864-0859-30 ",.01)
 ;;58864-0859-30
 ;;9002226.02101,"1064,58864-0859-30 ",.02)
 ;;58864-0859-30
 ;;9002226.02101,"1064,58864-0863-30 ",.01)
 ;;58864-0863-30
 ;;9002226.02101,"1064,58864-0863-30 ",.02)
 ;;58864-0863-30
 ;;9002226.02101,"1064,58864-0869-30 ",.01)
 ;;58864-0869-30
 ;;9002226.02101,"1064,58864-0869-30 ",.02)
 ;;58864-0869-30
 ;;9002226.02101,"1064,59762-0220-01 ",.01)
 ;;59762-0220-01
 ;;9002226.02101,"1064,59762-0220-01 ",.02)
 ;;59762-0220-01
 ;;9002226.02101,"1064,59762-0222-01 ",.01)
 ;;59762-0222-01
 ;;9002226.02101,"1064,59762-0222-01 ",.02)
 ;;59762-0222-01
 ;;9002226.02101,"1064,59762-0223-01 ",.01)
 ;;59762-0223-01
 ;;9002226.02101,"1064,59762-0223-01 ",.02)
 ;;59762-0223-01
 ;;9002226.02101,"1064,59762-2140-01 ",.01)
 ;;59762-2140-01
 ;;9002226.02101,"1064,59762-2140-01 ",.02)
 ;;59762-2140-01
 ;;9002226.02101,"1064,59762-2140-06 ",.01)
 ;;59762-2140-06
 ;;9002226.02101,"1064,59762-2140-06 ",.02)
 ;;59762-2140-06
 ;;9002226.02101,"1064,59762-2141-01 ",.01)
 ;;59762-2141-01
 ;;9002226.02101,"1064,59762-2141-01 ",.02)
 ;;59762-2141-01
 ;;9002226.02101,"1064,59762-2141-06 ",.01)
 ;;59762-2141-06
 ;;9002226.02101,"1064,59762-2141-06 ",.02)
 ;;59762-2141-06
 ;;9002226.02101,"1064,59762-2142-01 ",.01)
 ;;59762-2142-01
 ;;9002226.02101,"1064,59762-2142-01 ",.02)
 ;;59762-2142-01
 ;;9002226.02101,"1064,59762-2142-06 ",.01)
 ;;59762-2142-06
 ;;9002226.02101,"1064,59762-2142-06 ",.02)
 ;;59762-2142-06
 ;;9002226.02101,"1064,59762-2270-01 ",.01)
 ;;59762-2270-01
 ;;9002226.02101,"1064,59762-2270-01 ",.02)
 ;;59762-2270-01
 ;;9002226.02101,"1064,59762-2270-03 ",.01)
 ;;59762-2270-03
 ;;9002226.02101,"1064,59762-2270-03 ",.02)
 ;;59762-2270-03
 ;;9002226.02101,"1064,59762-2270-07 ",.01)
 ;;59762-2270-07
 ;;9002226.02101,"1064,59762-2270-07 ",.02)
 ;;59762-2270-07
 ;;9002226.02101,"1064,59762-2271-01 ",.01)
 ;;59762-2271-01
 ;;9002226.02101,"1064,59762-2271-01 ",.02)
 ;;59762-2271-01
 ;;9002226.02101,"1064,59762-2271-03 ",.01)
 ;;59762-2271-03
 ;;9002226.02101,"1064,59762-2271-03 ",.02)
 ;;59762-2271-03
 ;;9002226.02101,"1064,59762-2271-07 ",.01)
 ;;59762-2271-07
 ;;9002226.02101,"1064,59762-2271-07 ",.02)
 ;;59762-2271-07
 ;;9002226.02101,"1064,59762-2272-01 ",.01)
 ;;59762-2272-01
 ;;9002226.02101,"1064,59762-2272-01 ",.02)
 ;;59762-2272-01
 ;;9002226.02101,"1064,59762-2272-03 ",.01)
 ;;59762-2272-03
 ;;9002226.02101,"1064,59762-2272-03 ",.02)
 ;;59762-2272-03
 ;;9002226.02101,"1064,59762-2272-07 ",.01)
 ;;59762-2272-07
 ;;9002226.02101,"1064,59762-2272-07 ",.02)
 ;;59762-2272-07
 ;;9002226.02101,"1064,59762-2273-01 ",.01)
 ;;59762-2273-01
 ;;9002226.02101,"1064,59762-2273-01 ",.02)
 ;;59762-2273-01
 ;;9002226.02101,"1064,59762-2273-03 ",.01)
 ;;59762-2273-03
 ;;9002226.02101,"1064,59762-2273-03 ",.02)
 ;;59762-2273-03
 ;;9002226.02101,"1064,59762-2273-07 ",.01)
 ;;59762-2273-07
 ;;9002226.02101,"1064,59762-2273-07 ",.02)
 ;;59762-2273-07
 ;;9002226.02101,"1064,59762-2274-01 ",.01)
 ;;59762-2274-01
 ;;9002226.02101,"1064,59762-2274-01 ",.02)
 ;;59762-2274-01
 ;;9002226.02101,"1064,59762-2274-03 ",.01)
 ;;59762-2274-03
 ;;9002226.02101,"1064,59762-2274-03 ",.02)
 ;;59762-2274-03
 ;;9002226.02101,"1064,59762-2274-07 ",.01)
 ;;59762-2274-07
 ;;9002226.02101,"1064,59762-2274-07 ",.02)
 ;;59762-2274-07
 ;;9002226.02101,"1064,59762-2275-01 ",.01)
 ;;59762-2275-01
 ;;9002226.02101,"1064,59762-2275-01 ",.02)
 ;;59762-2275-01
 ;;9002226.02101,"1064,59762-2275-03 ",.01)
 ;;59762-2275-03
 ;;9002226.02101,"1064,59762-2275-03 ",.02)
 ;;59762-2275-03
 ;;9002226.02101,"1064,59762-2275-07 ",.01)
 ;;59762-2275-07
 ;;9002226.02101,"1064,59762-2275-07 ",.02)
 ;;59762-2275-07
 ;;9002226.02101,"1064,59762-3146-01 ",.01)
 ;;59762-3146-01
 ;;9002226.02101,"1064,59762-3146-01 ",.02)
 ;;59762-3146-01
 ;;9002226.02101,"1064,59762-3146-02 ",.01)
 ;;59762-3146-02