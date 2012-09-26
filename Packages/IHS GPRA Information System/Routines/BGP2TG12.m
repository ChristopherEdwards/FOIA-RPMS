BGP2TG12 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1199,55887-0693-30 ",.01)
 ;;55887-0693-30
 ;;9002226.02101,"1199,55887-0693-30 ",.02)
 ;;55887-0693-30
 ;;9002226.02101,"1199,55887-0693-60 ",.01)
 ;;55887-0693-60
 ;;9002226.02101,"1199,55887-0693-60 ",.02)
 ;;55887-0693-60
 ;;9002226.02101,"1199,55887-0693-90 ",.01)
 ;;55887-0693-90
 ;;9002226.02101,"1199,55887-0693-90 ",.02)
 ;;55887-0693-90
 ;;9002226.02101,"1199,55887-0727-30 ",.01)
 ;;55887-0727-30
 ;;9002226.02101,"1199,55887-0727-30 ",.02)
 ;;55887-0727-30
 ;;9002226.02101,"1199,55887-0727-60 ",.01)
 ;;55887-0727-60
 ;;9002226.02101,"1199,55887-0727-60 ",.02)
 ;;55887-0727-60
 ;;9002226.02101,"1199,55887-0727-90 ",.01)
 ;;55887-0727-90
 ;;9002226.02101,"1199,55887-0727-90 ",.02)
 ;;55887-0727-90
 ;;9002226.02101,"1199,55887-0965-30 ",.01)
 ;;55887-0965-30
 ;;9002226.02101,"1199,55887-0965-30 ",.02)
 ;;55887-0965-30
 ;;9002226.02101,"1199,55887-0968-30 ",.01)
 ;;55887-0968-30
 ;;9002226.02101,"1199,55887-0968-30 ",.02)
 ;;55887-0968-30
 ;;9002226.02101,"1199,55887-0969-30 ",.01)
 ;;55887-0969-30
 ;;9002226.02101,"1199,55887-0969-30 ",.02)
 ;;55887-0969-30
 ;;9002226.02101,"1199,57664-0398-13 ",.01)
 ;;57664-0398-13
 ;;9002226.02101,"1199,57664-0398-13 ",.02)
 ;;57664-0398-13
 ;;9002226.02101,"1199,57664-0398-18 ",.01)
 ;;57664-0398-18
 ;;9002226.02101,"1199,57664-0398-18 ",.02)
 ;;57664-0398-18
 ;;9002226.02101,"1199,57664-0398-88 ",.01)
 ;;57664-0398-88
 ;;9002226.02101,"1199,57664-0398-88 ",.02)
 ;;57664-0398-88
 ;;9002226.02101,"1199,57664-0399-13 ",.01)
 ;;57664-0399-13
 ;;9002226.02101,"1199,57664-0399-13 ",.02)
 ;;57664-0399-13
 ;;9002226.02101,"1199,57664-0399-18 ",.01)
 ;;57664-0399-18
 ;;9002226.02101,"1199,57664-0399-18 ",.02)
 ;;57664-0399-18
 ;;9002226.02101,"1199,57664-0399-88 ",.01)
 ;;57664-0399-88
 ;;9002226.02101,"1199,57664-0399-88 ",.02)
 ;;57664-0399-88
 ;;9002226.02101,"1199,57664-0724-88 ",.01)
 ;;57664-0724-88
 ;;9002226.02101,"1199,57664-0724-88 ",.02)
 ;;57664-0724-88
 ;;9002226.02101,"1199,57664-0725-88 ",.01)
 ;;57664-0725-88
 ;;9002226.02101,"1199,57664-0725-88 ",.02)
 ;;57664-0725-88
 ;;9002226.02101,"1199,57664-0727-88 ",.01)
 ;;57664-0727-88
 ;;9002226.02101,"1199,57664-0727-88 ",.02)
 ;;57664-0727-88
 ;;9002226.02101,"1199,57866-0236-01 ",.01)
 ;;57866-0236-01
 ;;9002226.02101,"1199,57866-0236-01 ",.02)
 ;;57866-0236-01
 ;;9002226.02101,"1199,57866-0237-01 ",.01)
 ;;57866-0237-01
 ;;9002226.02101,"1199,57866-0237-01 ",.02)
 ;;57866-0237-01
 ;;9002226.02101,"1199,57866-6302-01 ",.01)
 ;;57866-6302-01
 ;;9002226.02101,"1199,57866-6302-01 ",.02)
 ;;57866-6302-01
 ;;9002226.02101,"1199,57866-6409-01 ",.01)
 ;;57866-6409-01
 ;;9002226.02101,"1199,57866-6409-01 ",.02)
 ;;57866-6409-01
 ;;9002226.02101,"1199,57866-6409-02 ",.01)
 ;;57866-6409-02
 ;;9002226.02101,"1199,57866-6409-02 ",.02)
 ;;57866-6409-02
 ;;9002226.02101,"1199,57866-6409-03 ",.01)
 ;;57866-6409-03
 ;;9002226.02101,"1199,57866-6409-03 ",.02)
 ;;57866-6409-03
 ;;9002226.02101,"1199,57866-6409-04 ",.01)
 ;;57866-6409-04
 ;;9002226.02101,"1199,57866-6409-04 ",.02)
 ;;57866-6409-04
 ;;9002226.02101,"1199,57866-6409-05 ",.01)
 ;;57866-6409-05
 ;;9002226.02101,"1199,57866-6409-05 ",.02)
 ;;57866-6409-05
 ;;9002226.02101,"1199,57866-6409-06 ",.01)
 ;;57866-6409-06
 ;;9002226.02101,"1199,57866-6409-06 ",.02)
 ;;57866-6409-06
 ;;9002226.02101,"1199,57866-6462-01 ",.01)
 ;;57866-6462-01
 ;;9002226.02101,"1199,57866-6462-01 ",.02)
 ;;57866-6462-01
 ;;9002226.02101,"1199,57866-6462-02 ",.01)
 ;;57866-6462-02
 ;;9002226.02101,"1199,57866-6462-02 ",.02)
 ;;57866-6462-02
 ;;9002226.02101,"1199,57866-6463-01 ",.01)
 ;;57866-6463-01
 ;;9002226.02101,"1199,57866-6463-01 ",.02)
 ;;57866-6463-01
 ;;9002226.02101,"1199,57866-6463-02 ",.01)
 ;;57866-6463-02
 ;;9002226.02101,"1199,57866-6463-02 ",.02)
 ;;57866-6463-02
 ;;9002226.02101,"1199,57866-7073-01 ",.01)
 ;;57866-7073-01
 ;;9002226.02101,"1199,57866-7073-01 ",.02)
 ;;57866-7073-01
 ;;9002226.02101,"1199,57866-7073-02 ",.01)
 ;;57866-7073-02
 ;;9002226.02101,"1199,57866-7073-02 ",.02)
 ;;57866-7073-02
 ;;9002226.02101,"1199,57866-7074-01 ",.01)
 ;;57866-7074-01
 ;;9002226.02101,"1199,57866-7074-01 ",.02)
 ;;57866-7074-01
 ;;9002226.02101,"1199,57866-7074-02 ",.01)
 ;;57866-7074-02
 ;;9002226.02101,"1199,57866-7074-02 ",.02)
 ;;57866-7074-02
 ;;9002226.02101,"1199,57866-7991-01 ",.01)
 ;;57866-7991-01
 ;;9002226.02101,"1199,57866-7991-01 ",.02)
 ;;57866-7991-01
 ;;9002226.02101,"1199,58016-0005-00 ",.01)
 ;;58016-0005-00
 ;;9002226.02101,"1199,58016-0005-00 ",.02)
 ;;58016-0005-00
 ;;9002226.02101,"1199,58016-0005-30 ",.01)
 ;;58016-0005-30
 ;;9002226.02101,"1199,58016-0005-30 ",.02)
 ;;58016-0005-30
 ;;9002226.02101,"1199,58016-0005-60 ",.01)
 ;;58016-0005-60
 ;;9002226.02101,"1199,58016-0005-60 ",.02)
 ;;58016-0005-60
 ;;9002226.02101,"1199,58016-0005-90 ",.01)
 ;;58016-0005-90
 ;;9002226.02101,"1199,58016-0005-90 ",.02)
 ;;58016-0005-90
 ;;9002226.02101,"1199,58016-0058-00 ",.01)
 ;;58016-0058-00
 ;;9002226.02101,"1199,58016-0058-00 ",.02)
 ;;58016-0058-00
 ;;9002226.02101,"1199,58016-0058-30 ",.01)
 ;;58016-0058-30
 ;;9002226.02101,"1199,58016-0058-30 ",.02)
 ;;58016-0058-30
 ;;9002226.02101,"1199,58016-0058-60 ",.01)
 ;;58016-0058-60
 ;;9002226.02101,"1199,58016-0058-60 ",.02)
 ;;58016-0058-60
 ;;9002226.02101,"1199,58016-0058-90 ",.01)
 ;;58016-0058-90
 ;;9002226.02101,"1199,58016-0058-90 ",.02)
 ;;58016-0058-90
 ;;9002226.02101,"1199,58016-0334-00 ",.01)
 ;;58016-0334-00
 ;;9002226.02101,"1199,58016-0334-00 ",.02)
 ;;58016-0334-00
 ;;9002226.02101,"1199,58016-0334-02 ",.01)
 ;;58016-0334-02
 ;;9002226.02101,"1199,58016-0334-02 ",.02)
 ;;58016-0334-02
 ;;9002226.02101,"1199,58016-0334-30 ",.01)
 ;;58016-0334-30
 ;;9002226.02101,"1199,58016-0334-30 ",.02)
 ;;58016-0334-30
 ;;9002226.02101,"1199,58016-0334-60 ",.01)
 ;;58016-0334-60
 ;;9002226.02101,"1199,58016-0334-60 ",.02)
 ;;58016-0334-60
 ;;9002226.02101,"1199,58016-0334-90 ",.01)
 ;;58016-0334-90
 ;;9002226.02101,"1199,58016-0334-90 ",.02)
 ;;58016-0334-90
 ;;9002226.02101,"1199,58016-0370-30 ",.01)
 ;;58016-0370-30
 ;;9002226.02101,"1199,58016-0370-30 ",.02)
 ;;58016-0370-30
 ;;9002226.02101,"1199,58016-0376-00 ",.01)
 ;;58016-0376-00
 ;;9002226.02101,"1199,58016-0376-00 ",.02)
 ;;58016-0376-00
 ;;9002226.02101,"1199,58016-0376-02 ",.01)
 ;;58016-0376-02
 ;;9002226.02101,"1199,58016-0376-02 ",.02)
 ;;58016-0376-02
 ;;9002226.02101,"1199,58016-0376-30 ",.01)
 ;;58016-0376-30
 ;;9002226.02101,"1199,58016-0376-30 ",.02)
 ;;58016-0376-30
 ;;9002226.02101,"1199,58016-0376-60 ",.01)
 ;;58016-0376-60
 ;;9002226.02101,"1199,58016-0376-60 ",.02)
 ;;58016-0376-60
 ;;9002226.02101,"1199,58016-0376-90 ",.01)
 ;;58016-0376-90
 ;;9002226.02101,"1199,58016-0376-90 ",.02)
 ;;58016-0376-90
 ;;9002226.02101,"1199,58016-0376-99 ",.01)
 ;;58016-0376-99
 ;;9002226.02101,"1199,58016-0376-99 ",.02)
 ;;58016-0376-99
 ;;9002226.02101,"1199,58016-0378-00 ",.01)
 ;;58016-0378-00
 ;;9002226.02101,"1199,58016-0378-00 ",.02)
 ;;58016-0378-00
 ;;9002226.02101,"1199,58016-0378-02 ",.01)
 ;;58016-0378-02
 ;;9002226.02101,"1199,58016-0378-02 ",.02)
 ;;58016-0378-02
 ;;9002226.02101,"1199,58016-0378-30 ",.01)
 ;;58016-0378-30
 ;;9002226.02101,"1199,58016-0378-30 ",.02)
 ;;58016-0378-30
 ;;9002226.02101,"1199,58016-0378-60 ",.01)
 ;;58016-0378-60
 ;;9002226.02101,"1199,58016-0378-60 ",.02)
 ;;58016-0378-60
 ;;9002226.02101,"1199,58016-0378-90 ",.01)
 ;;58016-0378-90
 ;;9002226.02101,"1199,58016-0378-90 ",.02)
 ;;58016-0378-90
 ;;9002226.02101,"1199,58016-0378-99 ",.01)
 ;;58016-0378-99
 ;;9002226.02101,"1199,58016-0378-99 ",.02)
 ;;58016-0378-99
 ;;9002226.02101,"1199,58016-0411-00 ",.01)
 ;;58016-0411-00
 ;;9002226.02101,"1199,58016-0411-00 ",.02)
 ;;58016-0411-00
 ;;9002226.02101,"1199,58016-0411-02 ",.01)
 ;;58016-0411-02
 ;;9002226.02101,"1199,58016-0411-02 ",.02)
 ;;58016-0411-02
 ;;9002226.02101,"1199,58016-0411-30 ",.01)
 ;;58016-0411-30
 ;;9002226.02101,"1199,58016-0411-30 ",.02)
 ;;58016-0411-30
 ;;9002226.02101,"1199,58016-0411-60 ",.01)
 ;;58016-0411-60
 ;;9002226.02101,"1199,58016-0411-60 ",.02)
 ;;58016-0411-60
 ;;9002226.02101,"1199,58016-0411-90 ",.01)
 ;;58016-0411-90
 ;;9002226.02101,"1199,58016-0411-90 ",.02)
 ;;58016-0411-90
 ;;9002226.02101,"1199,58016-0467-00 ",.01)
 ;;58016-0467-00
 ;;9002226.02101,"1199,58016-0467-00 ",.02)
 ;;58016-0467-00
 ;;9002226.02101,"1199,58016-0467-30 ",.01)
 ;;58016-0467-30
 ;;9002226.02101,"1199,58016-0467-30 ",.02)
 ;;58016-0467-30
 ;;9002226.02101,"1199,58016-0467-60 ",.01)
 ;;58016-0467-60
 ;;9002226.02101,"1199,58016-0467-60 ",.02)
 ;;58016-0467-60
 ;;9002226.02101,"1199,58016-0467-90 ",.01)
 ;;58016-0467-90
 ;;9002226.02101,"1199,58016-0467-90 ",.02)
 ;;58016-0467-90
 ;;9002226.02101,"1199,58016-0691-00 ",.01)
 ;;58016-0691-00
 ;;9002226.02101,"1199,58016-0691-00 ",.02)
 ;;58016-0691-00
 ;;9002226.02101,"1199,58016-0691-30 ",.01)
 ;;58016-0691-30
 ;;9002226.02101,"1199,58016-0691-30 ",.02)
 ;;58016-0691-30
 ;;9002226.02101,"1199,58016-0691-60 ",.01)
 ;;58016-0691-60
 ;;9002226.02101,"1199,58016-0691-60 ",.02)
 ;;58016-0691-60
 ;;9002226.02101,"1199,58016-0691-90 ",.01)
 ;;58016-0691-90
 ;;9002226.02101,"1199,58016-0691-90 ",.02)
 ;;58016-0691-90
 ;;9002226.02101,"1199,58016-0844-00 ",.01)
 ;;58016-0844-00
 ;;9002226.02101,"1199,58016-0844-00 ",.02)
 ;;58016-0844-00
 ;;9002226.02101,"1199,58016-0844-30 ",.01)
 ;;58016-0844-30
 ;;9002226.02101,"1199,58016-0844-30 ",.02)
 ;;58016-0844-30
 ;;9002226.02101,"1199,58016-0844-60 ",.01)
 ;;58016-0844-60
 ;;9002226.02101,"1199,58016-0844-60 ",.02)
 ;;58016-0844-60
 ;;9002226.02101,"1199,58016-0844-90 ",.01)
 ;;58016-0844-90
 ;;9002226.02101,"1199,58016-0844-90 ",.02)
 ;;58016-0844-90
 ;;9002226.02101,"1199,58016-0876-00 ",.01)
 ;;58016-0876-00
 ;;9002226.02101,"1199,58016-0876-00 ",.02)
 ;;58016-0876-00
 ;;9002226.02101,"1199,58016-0876-10 ",.01)
 ;;58016-0876-10
 ;;9002226.02101,"1199,58016-0876-10 ",.02)
 ;;58016-0876-10
 ;;9002226.02101,"1199,58016-0876-12 ",.01)
 ;;58016-0876-12
 ;;9002226.02101,"1199,58016-0876-12 ",.02)
 ;;58016-0876-12
 ;;9002226.02101,"1199,58016-0876-14 ",.01)
 ;;58016-0876-14
 ;;9002226.02101,"1199,58016-0876-14 ",.02)
 ;;58016-0876-14
 ;;9002226.02101,"1199,58016-0876-15 ",.01)
 ;;58016-0876-15
 ;;9002226.02101,"1199,58016-0876-15 ",.02)
 ;;58016-0876-15
 ;;9002226.02101,"1199,58016-0876-20 ",.01)
 ;;58016-0876-20
 ;;9002226.02101,"1199,58016-0876-20 ",.02)
 ;;58016-0876-20
 ;;9002226.02101,"1199,58016-0876-21 ",.01)
 ;;58016-0876-21
 ;;9002226.02101,"1199,58016-0876-21 ",.02)
 ;;58016-0876-21
 ;;9002226.02101,"1199,58016-0876-24 ",.01)
 ;;58016-0876-24
 ;;9002226.02101,"1199,58016-0876-24 ",.02)
 ;;58016-0876-24
 ;;9002226.02101,"1199,58016-0876-28 ",.01)
 ;;58016-0876-28
 ;;9002226.02101,"1199,58016-0876-28 ",.02)
 ;;58016-0876-28
 ;;9002226.02101,"1199,58016-0876-30 ",.01)
 ;;58016-0876-30
 ;;9002226.02101,"1199,58016-0876-30 ",.02)
 ;;58016-0876-30
 ;;9002226.02101,"1199,58016-0876-40 ",.01)
 ;;58016-0876-40
 ;;9002226.02101,"1199,58016-0876-40 ",.02)
 ;;58016-0876-40
 ;;9002226.02101,"1199,58016-0876-50 ",.01)
 ;;58016-0876-50
 ;;9002226.02101,"1199,58016-0876-50 ",.02)
 ;;58016-0876-50
 ;;9002226.02101,"1199,58016-0876-60 ",.01)
 ;;58016-0876-60
 ;;9002226.02101,"1199,58016-0876-60 ",.02)
 ;;58016-0876-60
 ;;9002226.02101,"1199,58864-0027-14 ",.01)
 ;;58864-0027-14
 ;;9002226.02101,"1199,58864-0027-14 ",.02)
 ;;58864-0027-14
 ;;9002226.02101,"1199,58864-0027-30 ",.01)
 ;;58864-0027-30
 ;;9002226.02101,"1199,58864-0027-30 ",.02)
 ;;58864-0027-30
 ;;9002226.02101,"1199,58864-0027-60 ",.01)
 ;;58864-0027-60
 ;;9002226.02101,"1199,58864-0027-60 ",.02)
 ;;58864-0027-60
 ;;9002226.02101,"1199,58864-0027-90 ",.01)
 ;;58864-0027-90
 ;;9002226.02101,"1199,58864-0027-90 ",.02)
 ;;58864-0027-90
 ;;9002226.02101,"1199,58864-0100-30 ",.01)
 ;;58864-0100-30
 ;;9002226.02101,"1199,58864-0100-30 ",.02)
 ;;58864-0100-30
 ;;9002226.02101,"1199,58864-0161-30 ",.01)
 ;;58864-0161-30
 ;;9002226.02101,"1199,58864-0161-30 ",.02)
 ;;58864-0161-30
 ;;9002226.02101,"1199,58864-0161-60 ",.01)
 ;;58864-0161-60
 ;;9002226.02101,"1199,58864-0161-60 ",.02)
 ;;58864-0161-60
 ;;9002226.02101,"1199,58864-0214-30 ",.01)
 ;;58864-0214-30
 ;;9002226.02101,"1199,58864-0214-30 ",.02)
 ;;58864-0214-30
 ;;9002226.02101,"1199,58864-0214-60 ",.01)
 ;;58864-0214-60
 ;;9002226.02101,"1199,58864-0214-60 ",.02)
 ;;58864-0214-60
 ;;9002226.02101,"1199,58864-0224-30 ",.01)
 ;;58864-0224-30
 ;;9002226.02101,"1199,58864-0224-30 ",.02)
 ;;58864-0224-30
 ;;9002226.02101,"1199,58864-0224-60 ",.01)
 ;;58864-0224-60
 ;;9002226.02101,"1199,58864-0224-60 ",.02)
 ;;58864-0224-60
 ;;9002226.02101,"1199,58864-0224-93 ",.01)
 ;;58864-0224-93
 ;;9002226.02101,"1199,58864-0224-93 ",.02)
 ;;58864-0224-93
 ;;9002226.02101,"1199,58864-0689-30 ",.01)
 ;;58864-0689-30
 ;;9002226.02101,"1199,58864-0689-30 ",.02)
 ;;58864-0689-30
 ;;9002226.02101,"1199,58864-0689-60 ",.01)
 ;;58864-0689-60
 ;;9002226.02101,"1199,58864-0689-60 ",.02)
 ;;58864-0689-60
 ;;9002226.02101,"1199,58864-0705-30 ",.01)
 ;;58864-0705-30
 ;;9002226.02101,"1199,58864-0705-30 ",.02)
 ;;58864-0705-30
 ;;9002226.02101,"1199,58864-0711-30 ",.01)
 ;;58864-0711-30
 ;;9002226.02101,"1199,58864-0711-30 ",.02)
 ;;58864-0711-30
 ;;9002226.02101,"1199,58864-0858-30 ",.01)
 ;;58864-0858-30
 ;;9002226.02101,"1199,58864-0858-30 ",.02)
 ;;58864-0858-30
 ;;9002226.02101,"1199,58864-0952-30 ",.01)
 ;;58864-0952-30