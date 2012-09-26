BGP21H53 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1197,58864-0649-30 ",.01)
 ;;58864-0649-30
 ;;9002226.02101,"1197,58864-0649-30 ",.02)
 ;;58864-0649-30
 ;;9002226.02101,"1197,58864-0649-60 ",.01)
 ;;58864-0649-60
 ;;9002226.02101,"1197,58864-0649-60 ",.02)
 ;;58864-0649-60
 ;;9002226.02101,"1197,58864-0657-30 ",.01)
 ;;58864-0657-30
 ;;9002226.02101,"1197,58864-0657-30 ",.02)
 ;;58864-0657-30
 ;;9002226.02101,"1197,58864-0669-14 ",.01)
 ;;58864-0669-14
 ;;9002226.02101,"1197,58864-0669-14 ",.02)
 ;;58864-0669-14
 ;;9002226.02101,"1197,58864-0677-30 ",.01)
 ;;58864-0677-30
 ;;9002226.02101,"1197,58864-0677-30 ",.02)
 ;;58864-0677-30
 ;;9002226.02101,"1197,58864-0706-14 ",.01)
 ;;58864-0706-14
 ;;9002226.02101,"1197,58864-0706-14 ",.02)
 ;;58864-0706-14
 ;;9002226.02101,"1197,58864-0706-60 ",.01)
 ;;58864-0706-60
 ;;9002226.02101,"1197,58864-0706-60 ",.02)
 ;;58864-0706-60
 ;;9002226.02101,"1197,58864-0713-30 ",.01)
 ;;58864-0713-30
 ;;9002226.02101,"1197,58864-0713-30 ",.02)
 ;;58864-0713-30
 ;;9002226.02101,"1197,58864-0714-30 ",.01)
 ;;58864-0714-30
 ;;9002226.02101,"1197,58864-0714-30 ",.02)
 ;;58864-0714-30
 ;;9002226.02101,"1197,58864-0720-30 ",.01)
 ;;58864-0720-30
 ;;9002226.02101,"1197,58864-0720-30 ",.02)
 ;;58864-0720-30
 ;;9002226.02101,"1197,58864-0720-60 ",.01)
 ;;58864-0720-60
 ;;9002226.02101,"1197,58864-0720-60 ",.02)
 ;;58864-0720-60
 ;;9002226.02101,"1197,58864-0723-30 ",.01)
 ;;58864-0723-30
 ;;9002226.02101,"1197,58864-0723-30 ",.02)
 ;;58864-0723-30
 ;;9002226.02101,"1197,58864-0724-30 ",.01)
 ;;58864-0724-30
 ;;9002226.02101,"1197,58864-0724-30 ",.02)
 ;;58864-0724-30
 ;;9002226.02101,"1197,58864-0810-30 ",.01)
 ;;58864-0810-30
 ;;9002226.02101,"1197,58864-0810-30 ",.02)
 ;;58864-0810-30
 ;;9002226.02101,"1197,58864-0810-90 ",.01)
 ;;58864-0810-90
 ;;9002226.02101,"1197,58864-0810-90 ",.02)
 ;;58864-0810-90
 ;;9002226.02101,"1197,58864-0824-01 ",.01)
 ;;58864-0824-01
 ;;9002226.02101,"1197,58864-0824-01 ",.02)
 ;;58864-0824-01
 ;;9002226.02101,"1197,58864-0824-14 ",.01)
 ;;58864-0824-14
 ;;9002226.02101,"1197,58864-0824-14 ",.02)
 ;;58864-0824-14
 ;;9002226.02101,"1197,58864-0873-14 ",.01)
 ;;58864-0873-14
 ;;9002226.02101,"1197,58864-0873-14 ",.02)
 ;;58864-0873-14
 ;;9002226.02101,"1197,58864-0873-30 ",.01)
 ;;58864-0873-30
 ;;9002226.02101,"1197,58864-0873-30 ",.02)
 ;;58864-0873-30
 ;;9002226.02101,"1197,58864-0966-01 ",.01)
 ;;58864-0966-01
 ;;9002226.02101,"1197,58864-0966-01 ",.02)
 ;;58864-0966-01
 ;;9002226.02101,"1197,59630-0440-10 ",.01)
 ;;59630-0440-10
 ;;9002226.02101,"1197,59630-0440-10 ",.02)
 ;;59630-0440-10
 ;;9002226.02101,"1197,59630-0441-10 ",.01)
 ;;59630-0441-10
 ;;9002226.02101,"1197,59630-0441-10 ",.02)
 ;;59630-0441-10
 ;;9002226.02101,"1197,59630-0442-10 ",.01)
 ;;59630-0442-10
 ;;9002226.02101,"1197,59630-0442-10 ",.02)
 ;;59630-0442-10
 ;;9002226.02101,"1197,59630-0443-10 ",.01)
 ;;59630-0443-10
 ;;9002226.02101,"1197,59630-0443-10 ",.02)
 ;;59630-0443-10
 ;;9002226.02101,"1197,59630-0500-10 ",.01)
 ;;59630-0500-10
 ;;9002226.02101,"1197,59630-0500-10 ",.02)
 ;;59630-0500-10
 ;;9002226.02101,"1197,59630-0501-10 ",.01)
 ;;59630-0501-10
 ;;9002226.02101,"1197,59630-0501-10 ",.02)
 ;;59630-0501-10
 ;;9002226.02101,"1197,59630-0502-10 ",.01)
 ;;59630-0502-10
 ;;9002226.02101,"1197,59630-0502-10 ",.02)
 ;;59630-0502-10
 ;;9002226.02101,"1197,59630-0503-10 ",.01)
 ;;59630-0503-10
 ;;9002226.02101,"1197,59630-0503-10 ",.02)
 ;;59630-0503-10
 ;;9002226.02101,"1197,59762-1520-01 ",.01)
 ;;59762-1520-01
 ;;9002226.02101,"1197,59762-1520-01 ",.02)
 ;;59762-1520-01
 ;;9002226.02101,"1197,59762-1520-02 ",.01)
 ;;59762-1520-02
 ;;9002226.02101,"1197,59762-1520-02 ",.02)
 ;;59762-1520-02
 ;;9002226.02101,"1197,59762-1530-01 ",.01)
 ;;59762-1530-01
 ;;9002226.02101,"1197,59762-1530-01 ",.02)
 ;;59762-1530-01
 ;;9002226.02101,"1197,59762-1530-02 ",.01)
 ;;59762-1530-02
 ;;9002226.02101,"1197,59762-1530-02 ",.02)
 ;;59762-1530-02
 ;;9002226.02101,"1197,59762-1530-03 ",.01)
 ;;59762-1530-03
 ;;9002226.02101,"1197,59762-1530-03 ",.02)
 ;;59762-1530-03
 ;;9002226.02101,"1197,59762-1530-04 ",.01)
 ;;59762-1530-04
 ;;9002226.02101,"1197,59762-1530-04 ",.02)
 ;;59762-1530-04
 ;;9002226.02101,"1197,59762-1530-05 ",.01)
 ;;59762-1530-05
 ;;9002226.02101,"1197,59762-1530-05 ",.02)
 ;;59762-1530-05
 ;;9002226.02101,"1197,59762-1540-01 ",.01)
 ;;59762-1540-01
 ;;9002226.02101,"1197,59762-1540-01 ",.02)
 ;;59762-1540-01
 ;;9002226.02101,"1197,59762-1540-02 ",.01)
 ;;59762-1540-02
 ;;9002226.02101,"1197,59762-1540-02 ",.02)
 ;;59762-1540-02
 ;;9002226.02101,"1197,59762-1540-03 ",.01)
 ;;59762-1540-03
 ;;9002226.02101,"1197,59762-1540-03 ",.02)
 ;;59762-1540-03
 ;;9002226.02101,"1197,59762-1540-04 ",.01)
 ;;59762-1540-04
 ;;9002226.02101,"1197,59762-1540-04 ",.02)
 ;;59762-1540-04
 ;;9002226.02101,"1197,59762-6690-03 ",.01)
 ;;59762-6690-03
 ;;9002226.02101,"1197,59762-6690-03 ",.02)
 ;;59762-6690-03
 ;;9002226.02101,"1197,59762-6690-05 ",.01)
 ;;59762-6690-05
 ;;9002226.02101,"1197,59762-6690-05 ",.02)
 ;;59762-6690-05
 ;;9002226.02101,"1197,59762-6690-08 ",.01)
 ;;59762-6690-08
 ;;9002226.02101,"1197,59762-6690-08 ",.02)
 ;;59762-6690-08
 ;;9002226.02101,"1197,59762-6691-03 ",.01)
 ;;59762-6691-03
