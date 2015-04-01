BGP52B10 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 19, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1813,58016-0083-60 ",.01)
 ;;58016-0083-60
 ;;9002226.02101,"1813,58016-0083-60 ",.02)
 ;;58016-0083-60
 ;;9002226.02101,"1813,58016-0083-90 ",.01)
 ;;58016-0083-90
 ;;9002226.02101,"1813,58016-0083-90 ",.02)
 ;;58016-0083-90
 ;;9002226.02101,"1813,58016-0697-00 ",.01)
 ;;58016-0697-00
 ;;9002226.02101,"1813,58016-0697-00 ",.02)
 ;;58016-0697-00
 ;;9002226.02101,"1813,58016-0697-30 ",.01)
 ;;58016-0697-30
 ;;9002226.02101,"1813,58016-0697-30 ",.02)
 ;;58016-0697-30
 ;;9002226.02101,"1813,58016-0697-60 ",.01)
 ;;58016-0697-60
 ;;9002226.02101,"1813,58016-0697-60 ",.02)
 ;;58016-0697-60
 ;;9002226.02101,"1813,58016-0697-90 ",.01)
 ;;58016-0697-90
 ;;9002226.02101,"1813,58016-0697-90 ",.02)
 ;;58016-0697-90
 ;;9002226.02101,"1813,58016-4872-01 ",.01)
 ;;58016-4872-01
 ;;9002226.02101,"1813,58016-4872-01 ",.02)
 ;;58016-4872-01
 ;;9002226.02101,"1813,58118-4027-03 ",.01)
 ;;58118-4027-03
 ;;9002226.02101,"1813,58118-4027-03 ",.02)
 ;;58118-4027-03
 ;;9002226.02101,"1813,58118-4027-06 ",.01)
 ;;58118-4027-06
 ;;9002226.02101,"1813,58118-4027-06 ",.02)
 ;;58118-4027-06
 ;;9002226.02101,"1813,58118-4027-09 ",.01)
 ;;58118-4027-09
 ;;9002226.02101,"1813,58118-4027-09 ",.02)
 ;;58118-4027-09
 ;;9002226.02101,"1813,58118-4028-03 ",.01)
 ;;58118-4028-03
 ;;9002226.02101,"1813,58118-4028-03 ",.02)
 ;;58118-4028-03
 ;;9002226.02101,"1813,58118-4029-03 ",.01)
 ;;58118-4029-03
 ;;9002226.02101,"1813,58118-4029-03 ",.02)
 ;;58118-4029-03
 ;;9002226.02101,"1813,58118-4029-06 ",.01)
 ;;58118-4029-06
 ;;9002226.02101,"1813,58118-4029-06 ",.02)
 ;;58118-4029-06
 ;;9002226.02101,"1813,58118-4029-09 ",.01)
 ;;58118-4029-09
 ;;9002226.02101,"1813,58118-4029-09 ",.02)
 ;;58118-4029-09
 ;;9002226.02101,"1813,58118-4030-03 ",.01)
 ;;58118-4030-03
 ;;9002226.02101,"1813,58118-4030-03 ",.02)
 ;;58118-4030-03
 ;;9002226.02101,"1813,58118-4030-06 ",.01)
 ;;58118-4030-06
 ;;9002226.02101,"1813,58118-4030-06 ",.02)
 ;;58118-4030-06
 ;;9002226.02101,"1813,58118-4030-09 ",.01)
 ;;58118-4030-09
 ;;9002226.02101,"1813,58118-4030-09 ",.02)
 ;;58118-4030-09
 ;;9002226.02101,"1813,58118-4031-03 ",.01)
 ;;58118-4031-03
 ;;9002226.02101,"1813,58118-4031-03 ",.02)
 ;;58118-4031-03
 ;;9002226.02101,"1813,58118-4031-06 ",.01)
 ;;58118-4031-06
 ;;9002226.02101,"1813,58118-4031-06 ",.02)
 ;;58118-4031-06
 ;;9002226.02101,"1813,58118-4031-09 ",.01)
 ;;58118-4031-09
 ;;9002226.02101,"1813,58118-4031-09 ",.02)
 ;;58118-4031-09
 ;;9002226.02101,"1813,58118-4032-03 ",.01)
 ;;58118-4032-03
 ;;9002226.02101,"1813,58118-4032-03 ",.02)
 ;;58118-4032-03
 ;;9002226.02101,"1813,58118-4033-03 ",.01)
 ;;58118-4033-03
 ;;9002226.02101,"1813,58118-4033-03 ",.02)
 ;;58118-4033-03
 ;;9002226.02101,"1813,58118-4033-06 ",.01)
 ;;58118-4033-06
 ;;9002226.02101,"1813,58118-4033-06 ",.02)
 ;;58118-4033-06
 ;;9002226.02101,"1813,58118-4033-09 ",.01)
 ;;58118-4033-09
 ;;9002226.02101,"1813,58118-4033-09 ",.02)
 ;;58118-4033-09
 ;;9002226.02101,"1813,58118-4034-03 ",.01)
 ;;58118-4034-03
 ;;9002226.02101,"1813,58118-4034-03 ",.02)
 ;;58118-4034-03
 ;;9002226.02101,"1813,58118-4034-06 ",.01)
 ;;58118-4034-06
 ;;9002226.02101,"1813,58118-4034-06 ",.02)
 ;;58118-4034-06
 ;;9002226.02101,"1813,58118-4034-09 ",.01)
 ;;58118-4034-09
 ;;9002226.02101,"1813,58118-4034-09 ",.02)
 ;;58118-4034-09
 ;;9002226.02101,"1813,58118-4035-03 ",.01)
 ;;58118-4035-03
 ;;9002226.02101,"1813,58118-4035-03 ",.02)
 ;;58118-4035-03
 ;;9002226.02101,"1813,58118-4035-06 ",.01)
 ;;58118-4035-06
 ;;9002226.02101,"1813,58118-4035-06 ",.02)
 ;;58118-4035-06
 ;;9002226.02101,"1813,58118-4035-09 ",.01)
 ;;58118-4035-09
 ;;9002226.02101,"1813,58118-4035-09 ",.02)
 ;;58118-4035-09
 ;;9002226.02101,"1813,58517-0360-30 ",.01)
 ;;58517-0360-30
 ;;9002226.02101,"1813,58517-0360-30 ",.02)
 ;;58517-0360-30
 ;;9002226.02101,"1813,58864-0030-30 ",.01)
 ;;58864-0030-30
 ;;9002226.02101,"1813,58864-0030-30 ",.02)
 ;;58864-0030-30
 ;;9002226.02101,"1813,58864-0035-30 ",.01)
 ;;58864-0035-30
 ;;9002226.02101,"1813,58864-0035-30 ",.02)
 ;;58864-0035-30
 ;;9002226.02101,"1813,58864-0223-14 ",.01)
 ;;58864-0223-14
 ;;9002226.02101,"1813,58864-0223-14 ",.02)
 ;;58864-0223-14
 ;;9002226.02101,"1813,58864-0223-30 ",.01)
 ;;58864-0223-30
 ;;9002226.02101,"1813,58864-0223-30 ",.02)
 ;;58864-0223-30
 ;;9002226.02101,"1813,58864-0301-14 ",.01)
 ;;58864-0301-14
 ;;9002226.02101,"1813,58864-0301-14 ",.02)
 ;;58864-0301-14
 ;;9002226.02101,"1813,58864-0357-15 ",.01)
 ;;58864-0357-15
 ;;9002226.02101,"1813,58864-0357-15 ",.02)
 ;;58864-0357-15
 ;;9002226.02101,"1813,58864-0698-14 ",.01)
 ;;58864-0698-14
 ;;9002226.02101,"1813,58864-0698-14 ",.02)
 ;;58864-0698-14
 ;;9002226.02101,"1813,58864-0698-30 ",.01)
 ;;58864-0698-30
 ;;9002226.02101,"1813,58864-0698-30 ",.02)
 ;;58864-0698-30
 ;;9002226.02101,"1813,58864-0773-15 ",.01)
 ;;58864-0773-15
 ;;9002226.02101,"1813,58864-0773-15 ",.02)
 ;;58864-0773-15
 ;;9002226.02101,"1813,58864-0773-30 ",.01)
 ;;58864-0773-30
 ;;9002226.02101,"1813,58864-0773-30 ",.02)
 ;;58864-0773-30
 ;;9002226.02101,"1813,58864-0879-30 ",.01)
 ;;58864-0879-30
 ;;9002226.02101,"1813,58864-0879-30 ",.02)
 ;;58864-0879-30
 ;;9002226.02101,"1813,60429-0784-01 ",.01)
 ;;60429-0784-01
 ;;9002226.02101,"1813,60429-0784-01 ",.02)
 ;;60429-0784-01
 ;;9002226.02101,"1813,60429-0784-10 ",.01)
 ;;60429-0784-10
 ;;9002226.02101,"1813,60429-0784-10 ",.02)
 ;;60429-0784-10
 ;;9002226.02101,"1813,60429-0784-15 ",.01)
 ;;60429-0784-15
 ;;9002226.02101,"1813,60429-0784-15 ",.02)
 ;;60429-0784-15
 ;;9002226.02101,"1813,60429-0784-30 ",.01)
 ;;60429-0784-30
 ;;9002226.02101,"1813,60429-0784-30 ",.02)
 ;;60429-0784-30
 ;;9002226.02101,"1813,60429-0784-45 ",.01)
 ;;60429-0784-45
 ;;9002226.02101,"1813,60429-0784-45 ",.02)
 ;;60429-0784-45
 ;;9002226.02101,"1813,60429-0784-77 ",.01)
 ;;60429-0784-77
 ;;9002226.02101,"1813,60429-0784-77 ",.02)
 ;;60429-0784-77
 ;;9002226.02101,"1813,60429-0785-01 ",.01)
 ;;60429-0785-01
 ;;9002226.02101,"1813,60429-0785-01 ",.02)
 ;;60429-0785-01
 ;;9002226.02101,"1813,60429-0785-10 ",.01)
 ;;60429-0785-10
 ;;9002226.02101,"1813,60429-0785-10 ",.02)
 ;;60429-0785-10
 ;;9002226.02101,"1813,60429-0785-15 ",.01)
 ;;60429-0785-15
 ;;9002226.02101,"1813,60429-0785-15 ",.02)
 ;;60429-0785-15
 ;;9002226.02101,"1813,60429-0785-30 ",.01)
 ;;60429-0785-30
 ;;9002226.02101,"1813,60429-0785-30 ",.02)
 ;;60429-0785-30
 ;;9002226.02101,"1813,60429-0785-35 ",.01)
 ;;60429-0785-35
 ;;9002226.02101,"1813,60429-0785-35 ",.02)
 ;;60429-0785-35
 ;;9002226.02101,"1813,60429-0785-40 ",.01)
 ;;60429-0785-40
 ;;9002226.02101,"1813,60429-0785-40 ",.02)
 ;;60429-0785-40
 ;;9002226.02101,"1813,60429-0785-45 ",.01)
 ;;60429-0785-45
 ;;9002226.02101,"1813,60429-0785-45 ",.02)
 ;;60429-0785-45
 ;;9002226.02101,"1813,60429-0785-60 ",.01)
 ;;60429-0785-60
 ;;9002226.02101,"1813,60429-0785-60 ",.02)
 ;;60429-0785-60
 ;;9002226.02101,"1813,60429-0785-77 ",.01)
 ;;60429-0785-77
 ;;9002226.02101,"1813,60429-0785-77 ",.02)
 ;;60429-0785-77
 ;;9002226.02101,"1813,60429-0785-90 ",.01)
 ;;60429-0785-90
 ;;9002226.02101,"1813,60429-0785-90 ",.02)
 ;;60429-0785-90
 ;;9002226.02101,"1813,60429-0786-01 ",.01)
 ;;60429-0786-01
 ;;9002226.02101,"1813,60429-0786-01 ",.02)
 ;;60429-0786-01
 ;;9002226.02101,"1813,60429-0786-10 ",.01)
 ;;60429-0786-10
 ;;9002226.02101,"1813,60429-0786-10 ",.02)
 ;;60429-0786-10
 ;;9002226.02101,"1813,60429-0786-15 ",.01)
 ;;60429-0786-15
 ;;9002226.02101,"1813,60429-0786-15 ",.02)
 ;;60429-0786-15
 ;;9002226.02101,"1813,60429-0786-30 ",.01)
 ;;60429-0786-30
 ;;9002226.02101,"1813,60429-0786-30 ",.02)
 ;;60429-0786-30
 ;;9002226.02101,"1813,60429-0786-45 ",.01)
 ;;60429-0786-45
 ;;9002226.02101,"1813,60429-0786-45 ",.02)
 ;;60429-0786-45
 ;;9002226.02101,"1813,60429-0786-77 ",.01)
 ;;60429-0786-77
 ;;9002226.02101,"1813,60429-0786-77 ",.02)
 ;;60429-0786-77
 ;;9002226.02101,"1813,60429-0787-01 ",.01)
 ;;60429-0787-01
 ;;9002226.02101,"1813,60429-0787-01 ",.02)
 ;;60429-0787-01
 ;;9002226.02101,"1813,60429-0787-10 ",.01)
 ;;60429-0787-10
 ;;9002226.02101,"1813,60429-0787-10 ",.02)
 ;;60429-0787-10
 ;;9002226.02101,"1813,60429-0787-15 ",.01)
 ;;60429-0787-15
 ;;9002226.02101,"1813,60429-0787-15 ",.02)
 ;;60429-0787-15
 ;;9002226.02101,"1813,60429-0787-30 ",.01)
 ;;60429-0787-30
 ;;9002226.02101,"1813,60429-0787-30 ",.02)
 ;;60429-0787-30
 ;;9002226.02101,"1813,60429-0787-45 ",.01)
 ;;60429-0787-45
 ;;9002226.02101,"1813,60429-0787-45 ",.02)
 ;;60429-0787-45
 ;;9002226.02101,"1813,60429-0787-77 ",.01)
 ;;60429-0787-77
 ;;9002226.02101,"1813,60429-0787-77 ",.02)
 ;;60429-0787-77
 ;;9002226.02101,"1813,60429-0788-01 ",.01)
 ;;60429-0788-01
 ;;9002226.02101,"1813,60429-0788-01 ",.02)
 ;;60429-0788-01
 ;;9002226.02101,"1813,60429-0788-10 ",.01)
 ;;60429-0788-10
 ;;9002226.02101,"1813,60429-0788-10 ",.02)
 ;;60429-0788-10
 ;;9002226.02101,"1813,60429-0788-15 ",.01)
 ;;60429-0788-15
 ;;9002226.02101,"1813,60429-0788-15 ",.02)
 ;;60429-0788-15
 ;;9002226.02101,"1813,60429-0788-30 ",.01)
 ;;60429-0788-30
 ;;9002226.02101,"1813,60429-0788-30 ",.02)
 ;;60429-0788-30
 ;;9002226.02101,"1813,60429-0788-45 ",.01)
 ;;60429-0788-45
 ;;9002226.02101,"1813,60429-0788-45 ",.02)
 ;;60429-0788-45
 ;;9002226.02101,"1813,60429-0788-77 ",.01)
 ;;60429-0788-77
 ;;9002226.02101,"1813,60429-0788-77 ",.02)
 ;;60429-0788-77
 ;;9002226.02101,"1813,60429-0789-01 ",.01)
 ;;60429-0789-01
 ;;9002226.02101,"1813,60429-0789-01 ",.02)
 ;;60429-0789-01
 ;;9002226.02101,"1813,60429-0789-10 ",.01)
 ;;60429-0789-10
 ;;9002226.02101,"1813,60429-0789-10 ",.02)
 ;;60429-0789-10
 ;;9002226.02101,"1813,60429-0789-15 ",.01)
 ;;60429-0789-15
 ;;9002226.02101,"1813,60429-0789-15 ",.02)
 ;;60429-0789-15
 ;;9002226.02101,"1813,60429-0789-20 ",.01)
 ;;60429-0789-20
 ;;9002226.02101,"1813,60429-0789-20 ",.02)
 ;;60429-0789-20
 ;;9002226.02101,"1813,60429-0789-25 ",.01)
 ;;60429-0789-25
 ;;9002226.02101,"1813,60429-0789-25 ",.02)
 ;;60429-0789-25
 ;;9002226.02101,"1813,60429-0789-30 ",.01)
 ;;60429-0789-30
 ;;9002226.02101,"1813,60429-0789-30 ",.02)
 ;;60429-0789-30
 ;;9002226.02101,"1813,60429-0789-35 ",.01)
 ;;60429-0789-35
 ;;9002226.02101,"1813,60429-0789-35 ",.02)
 ;;60429-0789-35
 ;;9002226.02101,"1813,60429-0789-40 ",.01)
 ;;60429-0789-40
 ;;9002226.02101,"1813,60429-0789-40 ",.02)
 ;;60429-0789-40
 ;;9002226.02101,"1813,60429-0789-45 ",.01)
 ;;60429-0789-45
 ;;9002226.02101,"1813,60429-0789-45 ",.02)
 ;;60429-0789-45
 ;;9002226.02101,"1813,60429-0789-50 ",.01)
 ;;60429-0789-50
 ;;9002226.02101,"1813,60429-0789-50 ",.02)
 ;;60429-0789-50
 ;;9002226.02101,"1813,60429-0789-60 ",.01)
 ;;60429-0789-60
 ;;9002226.02101,"1813,60429-0789-60 ",.02)
 ;;60429-0789-60
 ;;9002226.02101,"1813,60429-0789-75 ",.01)
 ;;60429-0789-75
 ;;9002226.02101,"1813,60429-0789-75 ",.02)
 ;;60429-0789-75
 ;;9002226.02101,"1813,60429-0789-77 ",.01)
 ;;60429-0789-77
 ;;9002226.02101,"1813,60429-0789-77 ",.02)
 ;;60429-0789-77
 ;;9002226.02101,"1813,60429-0789-90 ",.01)
 ;;60429-0789-90
 ;;9002226.02101,"1813,60429-0789-90 ",.02)
 ;;60429-0789-90
 ;;9002226.02101,"1813,60429-0790-01 ",.01)
 ;;60429-0790-01
 ;;9002226.02101,"1813,60429-0790-01 ",.02)
 ;;60429-0790-01
 ;;9002226.02101,"1813,60429-0790-10 ",.01)
 ;;60429-0790-10
 ;;9002226.02101,"1813,60429-0790-10 ",.02)
 ;;60429-0790-10
 ;;9002226.02101,"1813,60429-0790-15 ",.01)
 ;;60429-0790-15
 ;;9002226.02101,"1813,60429-0790-15 ",.02)
 ;;60429-0790-15
 ;;9002226.02101,"1813,60429-0790-30 ",.01)
 ;;60429-0790-30
 ;;9002226.02101,"1813,60429-0790-30 ",.02)
 ;;60429-0790-30
 ;;9002226.02101,"1813,60429-0790-45 ",.01)
 ;;60429-0790-45
 ;;9002226.02101,"1813,60429-0790-45 ",.02)
 ;;60429-0790-45
 ;;9002226.02101,"1813,60429-0790-77 ",.01)
 ;;60429-0790-77
 ;;9002226.02101,"1813,60429-0790-77 ",.02)
 ;;60429-0790-77
 ;;9002226.02101,"1813,60429-0791-01 ",.01)
 ;;60429-0791-01
 ;;9002226.02101,"1813,60429-0791-01 ",.02)
 ;;60429-0791-01
 ;;9002226.02101,"1813,60429-0791-15 ",.01)
 ;;60429-0791-15
 ;;9002226.02101,"1813,60429-0791-15 ",.02)
 ;;60429-0791-15
 ;;9002226.02101,"1813,60429-0791-30 ",.01)
 ;;60429-0791-30
 ;;9002226.02101,"1813,60429-0791-30 ",.02)
 ;;60429-0791-30
 ;;9002226.02101,"1813,60429-0791-45 ",.01)
 ;;60429-0791-45
 ;;9002226.02101,"1813,60429-0791-45 ",.02)
 ;;60429-0791-45
 ;;9002226.02101,"1813,60429-0791-77 ",.01)
 ;;60429-0791-77
 ;;9002226.02101,"1813,60429-0791-77 ",.02)
 ;;60429-0791-77
 ;;9002226.02101,"1813,60429-0792-01 ",.01)
 ;;60429-0792-01
 ;;9002226.02101,"1813,60429-0792-01 ",.02)
 ;;60429-0792-01
 ;;9002226.02101,"1813,60429-0792-15 ",.01)
 ;;60429-0792-15
 ;;9002226.02101,"1813,60429-0792-15 ",.02)
 ;;60429-0792-15
 ;;9002226.02101,"1813,60429-0792-30 ",.01)
 ;;60429-0792-30
 ;;9002226.02101,"1813,60429-0792-30 ",.02)
 ;;60429-0792-30
 ;;9002226.02101,"1813,60429-0792-45 ",.01)
 ;;60429-0792-45
 ;;9002226.02101,"1813,60429-0792-45 ",.02)
 ;;60429-0792-45
 ;;9002226.02101,"1813,60429-0792-77 ",.01)
 ;;60429-0792-77
 ;;9002226.02101,"1813,60429-0792-77 ",.02)
 ;;60429-0792-77
 ;;9002226.02101,"1813,60505-6078-00 ",.01)
 ;;60505-6078-00
 ;;9002226.02101,"1813,60505-6078-00 ",.02)
 ;;60505-6078-00
 ;;9002226.02101,"1813,60505-6078-04 ",.01)
 ;;60505-6078-04
 ;;9002226.02101,"1813,60505-6078-04 ",.02)
 ;;60505-6078-04
 ;;9002226.02101,"1813,60505-6079-00 ",.01)
 ;;60505-6079-00
 ;;9002226.02101,"1813,60505-6079-00 ",.02)
 ;;60505-6079-00
 ;;9002226.02101,"1813,60505-6079-04 ",.01)
 ;;60505-6079-04