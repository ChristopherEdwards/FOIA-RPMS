BGP7LXEE ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 28, 2006 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"621,51432-0226-03 ",.01)
 ;;51432-0226-03
 ;;9002226.02101,"621,51432-0226-03 ",.02)
 ;;51432-0226-03
 ;;9002226.02101,"621,51432-0226-05 ",.01)
 ;;51432-0226-05
 ;;9002226.02101,"621,51432-0226-05 ",.02)
 ;;51432-0226-05
 ;;9002226.02101,"621,51432-0228-03 ",.01)
 ;;51432-0228-03
 ;;9002226.02101,"621,51432-0228-03 ",.02)
 ;;51432-0228-03
 ;;9002226.02101,"621,51655-0079-25 ",.01)
 ;;51655-0079-25
 ;;9002226.02101,"621,51655-0079-25 ",.02)
 ;;51655-0079-25
 ;;9002226.02101,"621,51655-0079-30 ",.01)
 ;;51655-0079-30
 ;;9002226.02101,"621,51655-0079-30 ",.02)
 ;;51655-0079-30
 ;;9002226.02101,"621,52152-0051-02 ",.01)
 ;;52152-0051-02
 ;;9002226.02101,"621,52152-0051-02 ",.02)
 ;;52152-0051-02
 ;;9002226.02101,"621,52152-0051-04 ",.01)
 ;;52152-0051-04
 ;;9002226.02101,"621,52152-0051-04 ",.02)
 ;;52152-0051-04
 ;;9002226.02101,"621,52152-0051-05 ",.01)
 ;;52152-0051-05
 ;;9002226.02101,"621,52152-0051-05 ",.02)
 ;;52152-0051-05
 ;;9002226.02101,"621,52152-0052-02 ",.01)
 ;;52152-0052-02
 ;;9002226.02101,"621,52152-0052-02 ",.02)
 ;;52152-0052-02
 ;;9002226.02101,"621,52152-0052-04 ",.01)
 ;;52152-0052-04
 ;;9002226.02101,"621,52152-0052-04 ",.02)
 ;;52152-0052-04
 ;;9002226.02101,"621,52152-0052-05 ",.01)
 ;;52152-0052-05
 ;;9002226.02101,"621,52152-0052-05 ",.02)
 ;;52152-0052-05
 ;;9002226.02101,"621,52152-0312-02 ",.01)
 ;;52152-0312-02
 ;;9002226.02101,"621,52152-0312-02 ",.02)
 ;;52152-0312-02
 ;;9002226.02101,"621,52152-0312-05 ",.01)
 ;;52152-0312-05
 ;;9002226.02101,"621,52152-0312-05 ",.02)
 ;;52152-0312-05
 ;;9002226.02101,"621,52152-0313-02 ",.01)
 ;;52152-0313-02
 ;;9002226.02101,"621,52152-0313-02 ",.02)
 ;;52152-0313-02
 ;;9002226.02101,"621,52152-0313-05 ",.01)
 ;;52152-0313-05
 ;;9002226.02101,"621,52152-0313-05 ",.02)
 ;;52152-0313-05
 ;;9002226.02101,"621,52555-0160-01 ",.01)
 ;;52555-0160-01
 ;;9002226.02101,"621,52555-0160-01 ",.02)
 ;;52555-0160-01
 ;;9002226.02101,"621,52555-0160-05 ",.01)
 ;;52555-0160-05
 ;;9002226.02101,"621,52555-0160-05 ",.02)
 ;;52555-0160-05
 ;;9002226.02101,"621,52555-0161-01 ",.01)
 ;;52555-0161-01
 ;;9002226.02101,"621,52555-0161-01 ",.02)
 ;;52555-0161-01
 ;;9002226.02101,"621,52555-0161-10 ",.01)
 ;;52555-0161-10
 ;;9002226.02101,"621,52555-0161-10 ",.02)
 ;;52555-0161-10
 ;;9002226.02101,"621,53489-0148-01 ",.01)
 ;;53489-0148-01
 ;;9002226.02101,"621,53489-0148-01 ",.02)
 ;;53489-0148-01
 ;;9002226.02101,"621,53489-0148-10 ",.01)
 ;;53489-0148-10
 ;;9002226.02101,"621,53489-0148-10 ",.02)
 ;;53489-0148-10
 ;;9002226.02101,"621,53489-0149-01 ",.01)
 ;;53489-0149-01
 ;;9002226.02101,"621,53489-0149-01 ",.02)
 ;;53489-0149-01
 ;;9002226.02101,"621,53489-0149-10 ",.01)
 ;;53489-0149-10
 ;;9002226.02101,"621,53489-0149-10 ",.02)
 ;;53489-0149-10
 ;;9002226.02101,"621,53489-0150-01 ",.01)
 ;;53489-0150-01
 ;;9002226.02101,"621,53489-0150-01 ",.02)
 ;;53489-0150-01
 ;;9002226.02101,"621,53489-0150-10 ",.01)
 ;;53489-0150-10
 ;;9002226.02101,"621,53489-0150-10 ",.02)
 ;;53489-0150-10
 ;;9002226.02101,"621,53489-0500-01 ",.01)
 ;;53489-0500-01
 ;;9002226.02101,"621,53489-0500-01 ",.02)
 ;;53489-0500-01
 ;;9002226.02101,"621,53633-0013-01 ",.01)
 ;;53633-0013-01
 ;;9002226.02101,"621,53633-0013-01 ",.02)
 ;;53633-0013-01
 ;;9002226.02101,"621,53633-0013-10 ",.01)
 ;;53633-0013-10
 ;;9002226.02101,"621,53633-0013-10 ",.02)
 ;;53633-0013-10
 ;;9002226.02101,"621,53633-0013-11 ",.01)
 ;;53633-0013-11
 ;;9002226.02101,"621,53633-0013-11 ",.02)
 ;;53633-0013-11
 ;;9002226.02101,"621,53633-0014-01 ",.01)
 ;;53633-0014-01
 ;;9002226.02101,"621,53633-0014-01 ",.02)
 ;;53633-0014-01
 ;;9002226.02101,"621,53633-0014-10 ",.01)
 ;;53633-0014-10
 ;;9002226.02101,"621,53633-0014-10 ",.02)
 ;;53633-0014-10
 ;;9002226.02101,"621,53633-0014-11 ",.01)
 ;;53633-0014-11
 ;;9002226.02101,"621,53633-0014-11 ",.02)
 ;;53633-0014-11
 ;;9002226.02101,"621,54274-0190-10 ",.01)
 ;;54274-0190-10
 ;;9002226.02101,"621,54274-0190-10 ",.02)
 ;;54274-0190-10
 ;;9002226.02101,"621,54274-0190-30 ",.01)
 ;;54274-0190-30
 ;;9002226.02101,"621,54274-0190-30 ",.02)
 ;;54274-0190-30
 ;;9002226.02101,"621,54274-0191-10 ",.01)
 ;;54274-0191-10
 ;;9002226.02101,"621,54274-0191-10 ",.02)
 ;;54274-0191-10
 ;;9002226.02101,"621,54274-0191-30 ",.01)
 ;;54274-0191-30
 ;;9002226.02101,"621,54274-0191-30 ",.02)
 ;;54274-0191-30
 ;;9002226.02101,"621,54274-0220-10 ",.01)
 ;;54274-0220-10
 ;;9002226.02101,"621,54274-0220-10 ",.02)
 ;;54274-0220-10
 ;;9002226.02101,"621,54274-0220-30 ",.01)
 ;;54274-0220-30
 ;;9002226.02101,"621,54274-0220-30 ",.02)
 ;;54274-0220-30
 ;;9002226.02101,"621,54274-0221-10 ",.01)
 ;;54274-0221-10
 ;;9002226.02101,"621,54274-0221-10 ",.02)
 ;;54274-0221-10
 ;;9002226.02101,"621,54274-0221-30 ",.01)
 ;;54274-0221-30
 ;;9002226.02101,"621,54274-0221-30 ",.02)
 ;;54274-0221-30
 ;;9002226.02101,"621,54868-0063-04 ",.01)
 ;;54868-0063-04
 ;;9002226.02101,"621,54868-0063-04 ",.02)
 ;;54868-0063-04
 ;;9002226.02101,"621,54868-0063-09 ",.01)
 ;;54868-0063-09
 ;;9002226.02101,"621,54868-0063-09 ",.02)
 ;;54868-0063-09
 ;;9002226.02101,"621,54868-0067-04 ",.01)
 ;;54868-0067-04
 ;;9002226.02101,"621,54868-0067-04 ",.02)
 ;;54868-0067-04
 ;;9002226.02101,"621,54868-0067-05 ",.01)
 ;;54868-0067-05
 ;;9002226.02101,"621,54868-0067-05 ",.02)
 ;;54868-0067-05
 ;;9002226.02101,"621,54868-1828-00 ",.01)
 ;;54868-1828-00
 ;;9002226.02101,"621,54868-1828-00 ",.02)
 ;;54868-1828-00
 ;;9002226.02101,"621,54868-1828-02 ",.01)
 ;;54868-1828-02
 ;;9002226.02101,"621,54868-1828-02 ",.02)
 ;;54868-1828-02
 ;;9002226.02101,"621,54868-1832-00 ",.01)
 ;;54868-1832-00
 ;;9002226.02101,"621,54868-1832-00 ",.02)
 ;;54868-1832-00
 ;;9002226.02101,"621,54868-1832-02 ",.01)
 ;;54868-1832-02
 ;;9002226.02101,"621,54868-1832-02 ",.02)
 ;;54868-1832-02
 ;;9002226.02101,"621,54868-1832-03 ",.01)
 ;;54868-1832-03
 ;;9002226.02101,"621,54868-1832-03 ",.02)
 ;;54868-1832-03
 ;;9002226.02101,"621,54868-3311-00 ",.01)
 ;;54868-3311-00
 ;;9002226.02101,"621,54868-3311-00 ",.02)
 ;;54868-3311-00
 ;;9002226.02101,"621,55045-1446-05 ",.01)
 ;;55045-1446-05
 ;;9002226.02101,"621,55045-1446-05 ",.02)
 ;;55045-1446-05
 ;;9002226.02101,"621,55045-1446-07 ",.01)
 ;;55045-1446-07
 ;;9002226.02101,"621,55045-1446-07 ",.02)
 ;;55045-1446-07
 ;;9002226.02101,"621,55045-1446-08 ",.01)
 ;;55045-1446-08
 ;;9002226.02101,"621,55045-1446-08 ",.02)
 ;;55045-1446-08
 ;;9002226.02101,"621,55045-1446-09 ",.01)
 ;;55045-1446-09
 ;;9002226.02101,"621,55045-1446-09 ",.02)
 ;;55045-1446-09
 ;;9002226.02101,"621,55045-2148-04 ",.01)
 ;;55045-2148-04
 ;;9002226.02101,"621,55045-2148-04 ",.02)
 ;;55045-2148-04
 ;;9002226.02101,"621,55175-4094-00 ",.01)
 ;;55175-4094-00
 ;;9002226.02101,"621,55175-4094-00 ",.02)
 ;;55175-4094-00
 ;;9002226.02101,"621,55175-4094-01 ",.01)
 ;;55175-4094-01
 ;;9002226.02101,"621,55175-4094-01 ",.02)
 ;;55175-4094-01
 ;;9002226.02101,"621,55175-4094-02 ",.01)
 ;;55175-4094-02
 ;;9002226.02101,"621,55175-4094-02 ",.02)
 ;;55175-4094-02
 ;;9002226.02101,"621,55175-4094-03 ",.01)
 ;;55175-4094-03
 ;;9002226.02101,"621,55175-4094-03 ",.02)
 ;;55175-4094-03
 ;;9002226.02101,"621,55175-4094-04 ",.01)
 ;;55175-4094-04
 ;;9002226.02101,"621,55175-4094-04 ",.02)
 ;;55175-4094-04
 ;;9002226.02101,"621,55175-4094-05 ",.01)
 ;;55175-4094-05
 ;;9002226.02101,"621,55175-4094-05 ",.02)
 ;;55175-4094-05
 ;;9002226.02101,"621,55175-4094-06 ",.01)
 ;;55175-4094-06
 ;;9002226.02101,"621,55175-4094-06 ",.02)
 ;;55175-4094-06
 ;;9002226.02101,"621,55175-4094-07 ",.01)
 ;;55175-4094-07
 ;;9002226.02101,"621,55175-4094-07 ",.02)
 ;;55175-4094-07
 ;;9002226.02101,"621,55175-4094-08 ",.01)
 ;;55175-4094-08
 ;;9002226.02101,"621,55175-4094-08 ",.02)
 ;;55175-4094-08
 ;;9002226.02101,"621,55289-0138-12 ",.01)
 ;;55289-0138-12
 ;;9002226.02101,"621,55289-0138-12 ",.02)
 ;;55289-0138-12
 ;;9002226.02101,"621,55289-0139-12 ",.01)
 ;;55289-0139-12
 ;;9002226.02101,"621,55289-0139-12 ",.02)
 ;;55289-0139-12
 ;;9002226.02101,"621,55829-0501-10 ",.01)
 ;;55829-0501-10
 ;;9002226.02101,"621,55829-0501-10 ",.02)
 ;;55829-0501-10
 ;;9002226.02101,"621,55887-0985-10 ",.01)
 ;;55887-0985-10
 ;;9002226.02101,"621,55887-0985-10 ",.02)
 ;;55887-0985-10
 ;;9002226.02101,"621,55887-0985-15 ",.01)
 ;;55887-0985-15
 ;;9002226.02101,"621,55887-0985-15 ",.02)
 ;;55887-0985-15
 ;;9002226.02101,"621,56126-0096-11 ",.01)
 ;;56126-0096-11
 ;;9002226.02101,"621,56126-0096-11 ",.02)
 ;;56126-0096-11
 ;;9002226.02101,"621,56126-0097-11 ",.01)
 ;;56126-0097-11
 ;;9002226.02101,"621,56126-0097-11 ",.02)
 ;;56126-0097-11
 ;;9002226.02101,"621,56126-0098-11 ",.01)
 ;;56126-0098-11
 ;;9002226.02101,"621,56126-0098-11 ",.02)
 ;;56126-0098-11
 ;;9002226.02101,"621,56126-0099-11 ",.01)
 ;;56126-0099-11
 ;;9002226.02101,"621,56126-0099-11 ",.02)
 ;;56126-0099-11
 ;;9002226.02101,"621,56126-0101-11 ",.01)
 ;;56126-0101-11
 ;;9002226.02101,"621,56126-0101-11 ",.02)
 ;;56126-0101-11
 ;;9002226.02101,"621,56126-0310-11 ",.01)
 ;;56126-0310-11
 ;;9002226.02101,"621,56126-0310-11 ",.02)
 ;;56126-0310-11
 ;;9002226.02101,"621,56126-0311-11 ",.01)
 ;;56126-0311-11
 ;;9002226.02101,"621,56126-0311-11 ",.02)
 ;;56126-0311-11
 ;;9002226.02101,"621,57480-0362-06 ",.01)
 ;;57480-0362-06
 ;;9002226.02101,"621,57480-0362-06 ",.02)
 ;;57480-0362-06
 ;;9002226.02101,"621,57480-0363-01 ",.01)
 ;;57480-0363-01
 ;;9002226.02101,"621,57480-0363-01 ",.02)
 ;;57480-0363-01
 ;;9002226.02101,"621,57480-0363-06 ",.01)
 ;;57480-0363-06
 ;;9002226.02101,"621,57480-0363-06 ",.02)
 ;;57480-0363-06
 ;;9002226.02101,"621,57480-0364-01 ",.01)
 ;;57480-0364-01
 ;;9002226.02101,"621,57480-0364-01 ",.02)
 ;;57480-0364-01
 ;;9002226.02101,"621,57480-0364-06 ",.01)
 ;;57480-0364-06
 ;;9002226.02101,"621,57480-0364-06 ",.02)
 ;;57480-0364-06
 ;;9002226.02101,"621,57866-1042-01 ",.01)
 ;;57866-1042-01
 ;;9002226.02101,"621,57866-1042-01 ",.02)
 ;;57866-1042-01
 ;;9002226.02101,"621,57866-3874-05 ",.01)
 ;;57866-3874-05
 ;;9002226.02101,"621,57866-3874-05 ",.02)
 ;;57866-3874-05
 ;;9002226.02101,"621,57866-3874-07 ",.01)
 ;;57866-3874-07
 ;;9002226.02101,"621,57866-3874-07 ",.02)
 ;;57866-3874-07
 ;;9002226.02101,"621,57866-3874-09 ",.01)
 ;;57866-3874-09
 ;;9002226.02101,"621,57866-3874-09 ",.02)
 ;;57866-3874-09
 ;;9002226.02101,"621,57866-4642-03 ",.01)
 ;;57866-4642-03
 ;;9002226.02101,"621,57866-4642-03 ",.02)
 ;;57866-4642-03
 ;;9002226.02101,"621,57866-4643-01 ",.01)
 ;;57866-4643-01
 ;;9002226.02101,"621,57866-4643-01 ",.02)
 ;;57866-4643-01
 ;;9002226.02101,"621,57866-4644-01 ",.01)
 ;;57866-4644-01
 ;;9002226.02101,"621,57866-4644-01 ",.02)
 ;;57866-4644-01
 ;;9002226.02101,"621,58016-0406-60 ",.01)
 ;;58016-0406-60
 ;;9002226.02101,"621,58016-0406-60 ",.02)
 ;;58016-0406-60
 ;;9002226.02101,"621,58864-0045-20 ",.01)
 ;;58864-0045-20
 ;;9002226.02101,"621,58864-0045-20 ",.02)
 ;;58864-0045-20
 ;;9002226.02101,"621,58864-0045-30 ",.01)
 ;;58864-0045-30
 ;;9002226.02101,"621,58864-0045-30 ",.02)
 ;;58864-0045-30
 ;;9002226.02101,"621,58864-0045-42 ",.01)
 ;;58864-0045-42
 ;;9002226.02101,"621,58864-0045-42 ",.02)
 ;;58864-0045-42
 ;;9002226.02101,"621,60346-0086-06 ",.01)
 ;;60346-0086-06
 ;;9002226.02101,"621,60346-0086-06 ",.02)
 ;;60346-0086-06
 ;;9002226.02101,"621,60346-0086-15 ",.01)
 ;;60346-0086-15
 ;;9002226.02101,"621,60346-0086-15 ",.02)
 ;;60346-0086-15
 ;;9002226.02101,"621,60346-0086-20 ",.01)
 ;;60346-0086-20
 ;;9002226.02101,"621,60346-0086-20 ",.02)
 ;;60346-0086-20
 ;;9002226.02101,"621,60346-0086-21 ",.01)
 ;;60346-0086-21
 ;;9002226.02101,"621,60346-0086-21 ",.02)
 ;;60346-0086-21
 ;;9002226.02101,"621,60346-0086-24 ",.01)
 ;;60346-0086-24
 ;;9002226.02101,"621,60346-0086-24 ",.02)
 ;;60346-0086-24
 ;;9002226.02101,"621,60346-0086-25 ",.01)
 ;;60346-0086-25
 ;;9002226.02101,"621,60346-0086-25 ",.02)
 ;;60346-0086-25
 ;;9002226.02101,"621,60346-0086-30 ",.01)
 ;;60346-0086-30
 ;;9002226.02101,"621,60346-0086-30 ",.02)
 ;;60346-0086-30
 ;;9002226.02101,"621,60346-0086-40 ",.01)
 ;;60346-0086-40
 ;;9002226.02101,"621,60346-0086-40 ",.02)
 ;;60346-0086-40
 ;;9002226.02101,"621,60346-0086-60 ",.01)
 ;;60346-0086-60
 ;;9002226.02101,"621,60346-0086-60 ",.02)
 ;;60346-0086-60
 ;;9002226.02101,"621,60346-0086-90 ",.01)
 ;;60346-0086-90
 ;;9002226.02101,"621,60346-0086-90 ",.02)
 ;;60346-0086-90
 ;;9002226.02101,"621,60346-0086-94 ",.01)
 ;;60346-0086-94
 ;;9002226.02101,"621,60346-0086-94 ",.02)
 ;;60346-0086-94
 ;;9002226.02101,"621,60346-0796-20 ",.01)
 ;;60346-0796-20
 ;;9002226.02101,"621,60346-0796-20 ",.02)
 ;;60346-0796-20
 ;;9002226.02101,"621,60346-0796-30 ",.01)
 ;;60346-0796-30
 ;;9002226.02101,"621,60346-0796-30 ",.02)
 ;;60346-0796-30
 ;;9002226.02101,"621,60809-0126-55 ",.01)
 ;;60809-0126-55
 ;;9002226.02101,"621,60809-0126-55 ",.02)
 ;;60809-0126-55
 ;;9002226.02101,"621,60809-0126-72 ",.01)
 ;;60809-0126-72
 ;;9002226.02101,"621,60809-0126-72 ",.02)
 ;;60809-0126-72
 ;;9002226.02101,"621,60809-0151-55 ",.01)
 ;;60809-0151-55
 ;;9002226.02101,"621,60809-0151-55 ",.02)
 ;;60809-0151-55
 ;;9002226.02101,"621,60809-0151-72 ",.01)
 ;;60809-0151-72
 ;;9002226.02101,"621,60809-0151-72 ",.02)
 ;;60809-0151-72
 ;;9002226.02101,"621,60809-0152-55 ",.01)
 ;;60809-0152-55
 ;;9002226.02101,"621,60809-0152-55 ",.02)
 ;;60809-0152-55
 ;;9002226.02101,"621,60809-0152-72 ",.01)
 ;;60809-0152-72
 ;;9002226.02101,"621,60809-0152-72 ",.02)
 ;;60809-0152-72