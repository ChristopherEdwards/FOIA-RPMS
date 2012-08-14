BGP21F18 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.0;IHS CLINICAL REPORTING;;JAN 9, 2012;Build 51
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1195,00007-4140-55 ",.01)
 ;;00007-4140-55
 ;;9002226.02101,"1195,00007-4140-55 ",.02)
 ;;00007-4140-55
 ;;9002226.02101,"1195,00007-4141-20 ",.01)
 ;;00007-4141-20
 ;;9002226.02101,"1195,00007-4141-20 ",.02)
 ;;00007-4141-20
 ;;9002226.02101,"1195,00007-4141-55 ",.01)
 ;;00007-4141-55
 ;;9002226.02101,"1195,00007-4141-55 ",.02)
 ;;00007-4141-55
 ;;9002226.02101,"1195,00007-4142-20 ",.01)
 ;;00007-4142-20
 ;;9002226.02101,"1195,00007-4142-20 ",.02)
 ;;00007-4142-20
 ;;9002226.02101,"1195,00007-4142-55 ",.01)
 ;;00007-4142-55
 ;;9002226.02101,"1195,00007-4142-55 ",.02)
 ;;00007-4142-55
 ;;9002226.02101,"1195,00008-4177-01 ",.01)
 ;;00008-4177-01
 ;;9002226.02101,"1195,00008-4177-01 ",.02)
 ;;00008-4177-01
 ;;9002226.02101,"1195,00008-4179-01 ",.01)
 ;;00008-4179-01
 ;;9002226.02101,"1195,00008-4179-01 ",.02)
 ;;00008-4179-01
 ;;9002226.02101,"1195,00024-2300-20 ",.01)
 ;;00024-2300-20
 ;;9002226.02101,"1195,00024-2300-20 ",.02)
 ;;00024-2300-20
 ;;9002226.02101,"1195,00024-2301-10 ",.01)
 ;;00024-2301-10
 ;;9002226.02101,"1195,00024-2301-10 ",.02)
 ;;00024-2301-10
 ;;9002226.02101,"1195,00025-5101-31 ",.01)
 ;;00025-5101-31
 ;;9002226.02101,"1195,00025-5101-31 ",.02)
 ;;00025-5101-31
 ;;9002226.02101,"1195,00025-5201-31 ",.01)
 ;;00025-5201-31
 ;;9002226.02101,"1195,00025-5201-31 ",.02)
 ;;00025-5201-31
 ;;9002226.02101,"1195,00028-0035-01 ",.01)
 ;;00028-0035-01
 ;;9002226.02101,"1195,00028-0035-01 ",.02)
 ;;00028-0035-01
 ;;9002226.02101,"1195,00028-0051-01 ",.01)
 ;;00028-0051-01
 ;;9002226.02101,"1195,00028-0051-01 ",.02)
 ;;00028-0051-01
 ;;9002226.02101,"1195,00028-0051-10 ",.01)
 ;;00028-0051-10
 ;;9002226.02101,"1195,00028-0051-10 ",.02)
 ;;00028-0051-10
 ;;9002226.02101,"1195,00028-0053-01 ",.01)
 ;;00028-0053-01
 ;;9002226.02101,"1195,00028-0053-01 ",.02)
 ;;00028-0053-01
 ;;9002226.02101,"1195,00028-0071-01 ",.01)
 ;;00028-0071-01
 ;;9002226.02101,"1195,00028-0071-01 ",.02)
 ;;00028-0071-01
 ;;9002226.02101,"1195,00028-0071-10 ",.01)
 ;;00028-0071-10
 ;;9002226.02101,"1195,00028-0071-10 ",.02)
 ;;00028-0071-10
 ;;9002226.02101,"1195,00028-0071-61 ",.01)
 ;;00028-0071-61
 ;;9002226.02101,"1195,00028-0071-61 ",.02)
 ;;00028-0071-61
 ;;9002226.02101,"1195,00028-0073-01 ",.01)
 ;;00028-0073-01
 ;;9002226.02101,"1195,00028-0073-01 ",.02)
 ;;00028-0073-01
 ;;9002226.02101,"1195,00046-0421-81 ",.01)
 ;;00046-0421-81
 ;;9002226.02101,"1195,00046-0421-81 ",.02)
 ;;00046-0421-81
 ;;9002226.02101,"1195,00046-0421-95 ",.01)
 ;;00046-0421-95
 ;;9002226.02101,"1195,00046-0421-95 ",.02)
 ;;00046-0421-95
 ;;9002226.02101,"1195,00046-0422-81 ",.01)
 ;;00046-0422-81
 ;;9002226.02101,"1195,00046-0422-81 ",.02)
 ;;00046-0422-81
 ;;9002226.02101,"1195,00046-0422-95 ",.01)
 ;;00046-0422-95
 ;;9002226.02101,"1195,00046-0422-95 ",.02)
 ;;00046-0422-95
 ;;9002226.02101,"1195,00046-0424-81 ",.01)
 ;;00046-0424-81
 ;;9002226.02101,"1195,00046-0424-81 ",.02)
 ;;00046-0424-81
 ;;9002226.02101,"1195,00046-0424-95 ",.01)
 ;;00046-0424-95
 ;;9002226.02101,"1195,00046-0424-95 ",.02)
 ;;00046-0424-95
 ;;9002226.02101,"1195,00046-0426-81 ",.01)
 ;;00046-0426-81
 ;;9002226.02101,"1195,00046-0426-81 ",.02)
 ;;00046-0426-81
 ;;9002226.02101,"1195,00046-0428-81 ",.01)
 ;;00046-0428-81
 ;;9002226.02101,"1195,00046-0428-81 ",.02)
 ;;00046-0428-81
 ;;9002226.02101,"1195,00046-0470-81 ",.01)
 ;;00046-0470-81
 ;;9002226.02101,"1195,00046-0470-81 ",.02)
 ;;00046-0470-81
 ;;9002226.02101,"1195,00046-0471-81 ",.01)
 ;;00046-0471-81
 ;;9002226.02101,"1195,00046-0471-81 ",.02)
 ;;00046-0471-81
 ;;9002226.02101,"1195,00046-0473-81 ",.01)
 ;;00046-0473-81
 ;;9002226.02101,"1195,00046-0473-81 ",.02)
 ;;00046-0473-81
 ;;9002226.02101,"1195,00046-0479-81 ",.01)
 ;;00046-0479-81
 ;;9002226.02101,"1195,00046-0479-81 ",.02)
 ;;00046-0479-81
 ;;9002226.02101,"1195,00046-0484-81 ",.01)
 ;;00046-0484-81
 ;;9002226.02101,"1195,00046-0484-81 ",.02)
 ;;00046-0484-81
 ;;9002226.02101,"1195,00046-0488-81 ",.01)
 ;;00046-0488-81
 ;;9002226.02101,"1195,00046-0488-81 ",.02)
 ;;00046-0488-81
 ;;9002226.02101,"1195,00054-3727-63 ",.01)
 ;;00054-3727-63
 ;;9002226.02101,"1195,00054-3727-63 ",.02)
 ;;00054-3727-63
 ;;9002226.02101,"1195,00054-3728-44 ",.01)
 ;;00054-3728-44
 ;;9002226.02101,"1195,00054-3728-44 ",.02)
 ;;00054-3728-44
 ;;9002226.02101,"1195,00054-3730-63 ",.01)
 ;;00054-3730-63
 ;;9002226.02101,"1195,00054-3730-63 ",.02)
 ;;00054-3730-63
 ;;9002226.02101,"1195,00054-8764-16 ",.01)
 ;;00054-8764-16
 ;;9002226.02101,"1195,00054-8764-16 ",.02)
 ;;00054-8764-16
 ;;9002226.02101,"1195,00074-1664-13 ",.01)
 ;;00074-1664-13
 ;;9002226.02101,"1195,00074-1664-13 ",.02)
 ;;00074-1664-13
 ;;9002226.02101,"1195,00074-1665-13 ",.01)
 ;;00074-1665-13
 ;;9002226.02101,"1195,00074-1665-13 ",.02)
 ;;00074-1665-13
 ;;9002226.02101,"1195,00078-0458-05 ",.01)
 ;;00078-0458-05
 ;;9002226.02101,"1195,00078-0458-05 ",.02)
 ;;00078-0458-05
 ;;9002226.02101,"1195,00078-0458-09 ",.01)
 ;;00078-0458-09
 ;;9002226.02101,"1195,00078-0458-09 ",.02)
 ;;00078-0458-09
 ;;9002226.02101,"1195,00078-0459-05 ",.01)
 ;;00078-0459-05
 ;;9002226.02101,"1195,00078-0459-05 ",.02)
 ;;00078-0459-05
 ;;9002226.02101,"1195,00078-0459-09 ",.01)
 ;;00078-0459-09