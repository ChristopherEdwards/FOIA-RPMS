BGP72A13 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 11, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1876,00597-0168-60 ",.01)
 ;;00597-0168-60
 ;;9002226.02101,"1876,00597-0168-60 ",.02)
 ;;00597-0168-60
 ;;9002226.02101,"1876,00597-0175-18 ",.01)
 ;;00597-0175-18
 ;;9002226.02101,"1876,00597-0175-18 ",.02)
 ;;00597-0175-18
 ;;9002226.02101,"1876,00597-0175-60 ",.01)
 ;;00597-0175-60
 ;;9002226.02101,"1876,00597-0175-60 ",.02)
 ;;00597-0175-60
 ;;9002226.02101,"1876,00597-0180-18 ",.01)
 ;;00597-0180-18
 ;;9002226.02101,"1876,00597-0180-18 ",.02)
 ;;00597-0180-18
 ;;9002226.02101,"1876,00597-0180-60 ",.01)
 ;;00597-0180-60
 ;;9002226.02101,"1876,00597-0180-60 ",.02)
 ;;00597-0180-60
 ;;9002226.02101,"1876,00597-0182-30 ",.01)
 ;;00597-0182-30
 ;;9002226.02101,"1876,00597-0182-30 ",.02)
 ;;00597-0182-30
 ;;9002226.02101,"1876,00597-0182-39 ",.01)
 ;;00597-0182-39
 ;;9002226.02101,"1876,00597-0182-39 ",.02)
 ;;00597-0182-39
 ;;9002226.02101,"1876,00597-0182-90 ",.01)
 ;;00597-0182-90
 ;;9002226.02101,"1876,00597-0182-90 ",.02)
 ;;00597-0182-90
 ;;9002226.02101,"1876,00603-3744-21 ",.01)
 ;;00603-3744-21
 ;;9002226.02101,"1876,00603-3744-21 ",.02)
 ;;00603-3744-21
 ;;9002226.02101,"1876,00603-3744-28 ",.01)
 ;;00603-3744-28
 ;;9002226.02101,"1876,00603-3744-28 ",.02)
 ;;00603-3744-28
 ;;9002226.02101,"1876,00603-3745-21 ",.01)
 ;;00603-3745-21
 ;;9002226.02101,"1876,00603-3745-21 ",.02)
 ;;00603-3745-21
 ;;9002226.02101,"1876,00603-3745-28 ",.01)
 ;;00603-3745-28
 ;;9002226.02101,"1876,00603-3745-28 ",.02)
 ;;00603-3745-28
 ;;9002226.02101,"1876,00603-3746-21 ",.01)
 ;;00603-3746-21
 ;;9002226.02101,"1876,00603-3746-21 ",.02)
 ;;00603-3746-21
 ;;9002226.02101,"1876,00603-3746-28 ",.01)
 ;;00603-3746-28
 ;;9002226.02101,"1876,00603-3746-28 ",.02)
 ;;00603-3746-28
 ;;9002226.02101,"1876,00603-4467-21 ",.01)
 ;;00603-4467-21
 ;;9002226.02101,"1876,00603-4467-21 ",.02)
 ;;00603-4467-21
 ;;9002226.02101,"1876,00603-4467-28 ",.01)
 ;;00603-4467-28
 ;;9002226.02101,"1876,00603-4467-28 ",.02)
 ;;00603-4467-28
 ;;9002226.02101,"1876,00603-4467-32 ",.01)
 ;;00603-4467-32
 ;;9002226.02101,"1876,00603-4467-32 ",.02)
 ;;00603-4467-32
 ;;9002226.02101,"1876,00603-4468-21 ",.01)
 ;;00603-4468-21
 ;;9002226.02101,"1876,00603-4468-21 ",.02)
 ;;00603-4468-21
 ;;9002226.02101,"1876,00603-4468-28 ",.01)
 ;;00603-4468-28
 ;;9002226.02101,"1876,00603-4468-28 ",.02)
 ;;00603-4468-28
 ;;9002226.02101,"1876,00603-4468-32 ",.01)
 ;;00603-4468-32
 ;;9002226.02101,"1876,00603-4468-32 ",.02)
 ;;00603-4468-32
 ;;9002226.02101,"1876,00603-4469-21 ",.01)
 ;;00603-4469-21
 ;;9002226.02101,"1876,00603-4469-21 ",.02)
 ;;00603-4469-21
 ;;9002226.02101,"1876,00603-4469-28 ",.01)
 ;;00603-4469-28
 ;;9002226.02101,"1876,00603-4469-28 ",.02)
 ;;00603-4469-28
 ;;9002226.02101,"1876,00603-4469-32 ",.01)
 ;;00603-4469-32
 ;;9002226.02101,"1876,00603-4469-32 ",.02)
 ;;00603-4469-32
 ;;9002226.02101,"1876,00781-1452-01 ",.01)
 ;;00781-1452-01
 ;;9002226.02101,"1876,00781-1452-01 ",.02)
 ;;00781-1452-01
 ;;9002226.02101,"1876,00781-1452-10 ",.01)
 ;;00781-1452-10
 ;;9002226.02101,"1876,00781-1452-10 ",.02)
 ;;00781-1452-10
 ;;9002226.02101,"1876,00781-1453-01 ",.01)
 ;;00781-1453-01
 ;;9002226.02101,"1876,00781-1453-01 ",.02)
 ;;00781-1453-01
 ;;9002226.02101,"1876,00781-1453-10 ",.01)
 ;;00781-1453-10
 ;;9002226.02101,"1876,00781-1453-10 ",.02)
 ;;00781-1453-10
 ;;9002226.02101,"1876,00781-5050-01 ",.01)
 ;;00781-5050-01
 ;;9002226.02101,"1876,00781-5050-01 ",.02)
 ;;00781-5050-01
 ;;9002226.02101,"1876,00781-5050-05 ",.01)
 ;;00781-5050-05
 ;;9002226.02101,"1876,00781-5050-05 ",.02)
 ;;00781-5050-05
 ;;9002226.02101,"1876,00781-5050-10 ",.01)
 ;;00781-5050-10
 ;;9002226.02101,"1876,00781-5050-10 ",.02)
 ;;00781-5050-10
 ;;9002226.02101,"1876,00781-5050-61 ",.01)
 ;;00781-5050-61
 ;;9002226.02101,"1876,00781-5050-61 ",.02)
 ;;00781-5050-61
 ;;9002226.02101,"1876,00781-5051-01 ",.01)
 ;;00781-5051-01
 ;;9002226.02101,"1876,00781-5051-01 ",.02)
 ;;00781-5051-01
 ;;9002226.02101,"1876,00781-5051-05 ",.01)
 ;;00781-5051-05
 ;;9002226.02101,"1876,00781-5051-05 ",.02)
 ;;00781-5051-05
 ;;9002226.02101,"1876,00781-5051-61 ",.01)
 ;;00781-5051-61
 ;;9002226.02101,"1876,00781-5051-61 ",.02)
 ;;00781-5051-61
 ;;9002226.02101,"1876,00781-5052-01 ",.01)
 ;;00781-5052-01
 ;;9002226.02101,"1876,00781-5052-01 ",.02)
 ;;00781-5052-01
 ;;9002226.02101,"1876,00781-5052-05 ",.01)
 ;;00781-5052-05
 ;;9002226.02101,"1876,00781-5052-05 ",.02)
 ;;00781-5052-05
 ;;9002226.02101,"1876,00781-5052-61 ",.01)
 ;;00781-5052-61
 ;;9002226.02101,"1876,00781-5052-61 ",.02)
 ;;00781-5052-61
 ;;9002226.02101,"1876,00781-5148-01 ",.01)
 ;;00781-5148-01
 ;;9002226.02101,"1876,00781-5148-01 ",.02)
 ;;00781-5148-01
 ;;9002226.02101,"1876,00781-5149-01 ",.01)
 ;;00781-5149-01
 ;;9002226.02101,"1876,00781-5149-01 ",.02)
 ;;00781-5149-01
 ;;9002226.02101,"1876,00781-5150-01 ",.01)
 ;;00781-5150-01
 ;;9002226.02101,"1876,00781-5150-01 ",.02)
 ;;00781-5150-01
 ;;9002226.02101,"1876,00781-5420-10 ",.01)
 ;;00781-5420-10
 ;;9002226.02101,"1876,00781-5420-10 ",.02)
 ;;00781-5420-10
 ;;9002226.02101,"1876,00781-5420-31 ",.01)
 ;;00781-5420-31
 ;;9002226.02101,"1876,00781-5420-31 ",.02)
 ;;00781-5420-31
 ;;9002226.02101,"1876,00781-5420-92 ",.01)
 ;;00781-5420-92
 ;;9002226.02101,"1876,00781-5420-92 ",.02)
 ;;00781-5420-92
 ;;9002226.02101,"1876,00781-5421-10 ",.01)
 ;;00781-5421-10
 ;;9002226.02101,"1876,00781-5421-10 ",.02)
 ;;00781-5421-10
 ;;9002226.02101,"1876,00781-5421-31 ",.01)
 ;;00781-5421-31
 ;;9002226.02101,"1876,00781-5421-31 ",.02)
 ;;00781-5421-31
 ;;9002226.02101,"1876,00781-5421-92 ",.01)
 ;;00781-5421-92
 ;;9002226.02101,"1876,00781-5421-92 ",.02)
 ;;00781-5421-92
 ;;9002226.02101,"1876,00781-5422-10 ",.01)
 ;;00781-5422-10
 ;;9002226.02101,"1876,00781-5422-10 ",.02)
 ;;00781-5422-10
 ;;9002226.02101,"1876,00781-5422-31 ",.01)
 ;;00781-5422-31
 ;;9002226.02101,"1876,00781-5422-31 ",.02)
 ;;00781-5422-31
 ;;9002226.02101,"1876,00781-5422-92 ",.01)
 ;;00781-5422-92
 ;;9002226.02101,"1876,00781-5422-92 ",.02)
 ;;00781-5422-92
 ;;9002226.02101,"1876,00781-5626-60 ",.01)
 ;;00781-5626-60
 ;;9002226.02101,"1876,00781-5626-60 ",.02)
 ;;00781-5626-60
 ;;9002226.02101,"1876,00781-5627-60 ",.01)
 ;;00781-5627-60
 ;;9002226.02101,"1876,00781-5627-60 ",.02)
 ;;00781-5627-60
 ;;9002226.02101,"1876,00781-5634-31 ",.01)
 ;;00781-5634-31
 ;;9002226.02101,"1876,00781-5634-31 ",.02)
 ;;00781-5634-31
 ;;9002226.02101,"1876,00781-5635-31 ",.01)
 ;;00781-5635-31
 ;;9002226.02101,"1876,00781-5635-31 ",.02)
 ;;00781-5635-31
 ;;9002226.02101,"1876,00832-0491-10 ",.01)
 ;;00832-0491-10
 ;;9002226.02101,"1876,00832-0491-10 ",.02)
 ;;00832-0491-10
 ;;9002226.02101,"1876,00832-0491-11 ",.01)
 ;;00832-0491-11
 ;;9002226.02101,"1876,00832-0491-11 ",.02)
 ;;00832-0491-11
 ;;9002226.02101,"1876,00832-0492-10 ",.01)
 ;;00832-0492-10
 ;;9002226.02101,"1876,00832-0492-10 ",.02)
 ;;00832-0492-10
 ;;9002226.02101,"1876,00832-0492-11 ",.01)
 ;;00832-0492-11
 ;;9002226.02101,"1876,00832-0492-11 ",.02)
 ;;00832-0492-11
 ;;9002226.02101,"1876,00904-5794-61 ",.01)
 ;;00904-5794-61
 ;;9002226.02101,"1876,00904-5794-61 ",.02)
 ;;00904-5794-61
 ;;9002226.02101,"1876,00904-5849-14 ",.01)
 ;;00904-5849-14
 ;;9002226.02101,"1876,00904-5849-14 ",.02)
 ;;00904-5849-14
 ;;9002226.02101,"1876,00904-5849-18 ",.01)
 ;;00904-5849-18
 ;;9002226.02101,"1876,00904-5849-18 ",.02)
 ;;00904-5849-18
 ;;9002226.02101,"1876,00904-5849-40 ",.01)
 ;;00904-5849-40
 ;;9002226.02101,"1876,00904-5849-40 ",.02)
 ;;00904-5849-40
 ;;9002226.02101,"1876,00904-5849-52 ",.01)
 ;;00904-5849-52
 ;;9002226.02101,"1876,00904-5849-52 ",.02)
 ;;00904-5849-52
 ;;9002226.02101,"1876,00904-5849-53 ",.01)
 ;;00904-5849-53
 ;;9002226.02101,"1876,00904-5849-53 ",.02)
 ;;00904-5849-53
 ;;9002226.02101,"1876,00904-5849-54 ",.01)
 ;;00904-5849-54
 ;;9002226.02101,"1876,00904-5849-54 ",.02)
 ;;00904-5849-54
 ;;9002226.02101,"1876,00904-5849-80 ",.01)
 ;;00904-5849-80
 ;;9002226.02101,"1876,00904-5849-80 ",.02)
 ;;00904-5849-80
 ;;9002226.02101,"1876,00904-5849-89 ",.01)
 ;;00904-5849-89
 ;;9002226.02101,"1876,00904-5849-89 ",.02)
 ;;00904-5849-89
 ;;9002226.02101,"1876,00904-5849-93 ",.01)
 ;;00904-5849-93
 ;;9002226.02101,"1876,00904-5849-93 ",.02)
 ;;00904-5849-93
 ;;9002226.02101,"1876,00904-5850-40 ",.01)
 ;;00904-5850-40
 ;;9002226.02101,"1876,00904-5850-40 ",.02)
 ;;00904-5850-40
 ;;9002226.02101,"1876,00904-5850-52 ",.01)
 ;;00904-5850-52
 ;;9002226.02101,"1876,00904-5850-52 ",.02)
 ;;00904-5850-52
 ;;9002226.02101,"1876,00904-5850-53 ",.01)
 ;;00904-5850-53
 ;;9002226.02101,"1876,00904-5850-53 ",.02)
 ;;00904-5850-53
 ;;9002226.02101,"1876,00904-5850-89 ",.01)
 ;;00904-5850-89
 ;;9002226.02101,"1876,00904-5850-89 ",.02)
 ;;00904-5850-89
 ;;9002226.02101,"1876,00904-5850-93 ",.01)
 ;;00904-5850-93
 ;;9002226.02101,"1876,00904-5850-93 ",.02)
 ;;00904-5850-93
 ;;9002226.02101,"1876,00904-5851-40 ",.01)
 ;;00904-5851-40
 ;;9002226.02101,"1876,00904-5851-40 ",.02)
 ;;00904-5851-40
 ;;9002226.02101,"1876,00904-5851-52 ",.01)
 ;;00904-5851-52
 ;;9002226.02101,"1876,00904-5851-52 ",.02)
 ;;00904-5851-52
 ;;9002226.02101,"1876,00904-5851-89 ",.01)
 ;;00904-5851-89
 ;;9002226.02101,"1876,00904-5851-89 ",.02)
 ;;00904-5851-89
 ;;9002226.02101,"1876,00904-5851-93 ",.01)
 ;;00904-5851-93
 ;;9002226.02101,"1876,00904-5851-93 ",.02)
 ;;00904-5851-93
 ;;9002226.02101,"1876,00904-6090-61 ",.01)
 ;;00904-6090-61
 ;;9002226.02101,"1876,00904-6090-61 ",.02)
 ;;00904-6090-61
 ;;9002226.02101,"1876,00904-6091-61 ",.01)
 ;;00904-6091-61
 ;;9002226.02101,"1876,00904-6091-61 ",.02)
 ;;00904-6091-61
 ;;9002226.02101,"1876,00904-6092-61 ",.01)
 ;;00904-6092-61
 ;;9002226.02101,"1876,00904-6092-61 ",.02)
 ;;00904-6092-61
 ;;9002226.02101,"1876,00904-6123-61 ",.01)
 ;;00904-6123-61
 ;;9002226.02101,"1876,00904-6123-61 ",.02)
 ;;00904-6123-61
 ;;9002226.02101,"1876,00904-6124-61 ",.01)
 ;;00904-6124-61
 ;;9002226.02101,"1876,00904-6124-61 ",.02)
 ;;00904-6124-61
 ;;9002226.02101,"1876,00904-6137-60 ",.01)
 ;;00904-6137-60
 ;;9002226.02101,"1876,00904-6137-60 ",.02)
 ;;00904-6137-60
 ;;9002226.02101,"1876,00904-6138-40 ",.01)
 ;;00904-6138-40
 ;;9002226.02101,"1876,00904-6138-40 ",.02)
 ;;00904-6138-40
 ;;9002226.02101,"1876,00904-6138-60 ",.01)
 ;;00904-6138-60
 ;;9002226.02101,"1876,00904-6138-60 ",.02)
 ;;00904-6138-60
 ;;9002226.02101,"1876,00904-6139-60 ",.01)
 ;;00904-6139-60
 ;;9002226.02101,"1876,00904-6139-60 ",.02)
 ;;00904-6139-60
 ;;9002226.02101,"1876,00904-6139-80 ",.01)
 ;;00904-6139-80
 ;;9002226.02101,"1876,00904-6139-80 ",.02)
 ;;00904-6139-80
 ;;9002226.02101,"1876,00904-6326-61 ",.01)
 ;;00904-6326-61
 ;;9002226.02101,"1876,00904-6326-61 ",.02)
 ;;00904-6326-61
 ;;9002226.02101,"1876,00904-6327-61 ",.01)
 ;;00904-6327-61
 ;;9002226.02101,"1876,00904-6327-61 ",.02)
 ;;00904-6327-61
 ;;9002226.02101,"1876,00904-6328-61 ",.01)
 ;;00904-6328-61
 ;;9002226.02101,"1876,00904-6328-61 ",.02)
 ;;00904-6328-61
 ;;9002226.02101,"1876,00904-6343-14 ",.01)
 ;;00904-6343-14
 ;;9002226.02101,"1876,00904-6343-14 ",.02)
 ;;00904-6343-14
 ;;9002226.02101,"1876,00904-6343-18 ",.01)
 ;;00904-6343-18
 ;;9002226.02101,"1876,00904-6343-18 ",.02)
 ;;00904-6343-18
 ;;9002226.02101,"1876,00904-6343-40 ",.01)
 ;;00904-6343-40
 ;;9002226.02101,"1876,00904-6343-40 ",.02)
 ;;00904-6343-40
 ;;9002226.02101,"1876,00904-6343-52 ",.01)
 ;;00904-6343-52
 ;;9002226.02101,"1876,00904-6343-52 ",.02)
 ;;00904-6343-52
 ;;9002226.02101,"1876,00904-6343-53 ",.01)
 ;;00904-6343-53
 ;;9002226.02101,"1876,00904-6343-53 ",.02)
 ;;00904-6343-53
 ;;9002226.02101,"1876,00904-6343-54 ",.01)
 ;;00904-6343-54