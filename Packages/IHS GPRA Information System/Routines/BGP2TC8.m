BGP2TC8 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1195,00006-0136-68 ",.02)
 ;;00006-0136-68
 ;;9002226.02101,"1195,00006-0437-68 ",.01)
 ;;00006-0437-68
 ;;9002226.02101,"1195,00006-0437-68 ",.02)
 ;;00006-0437-68
 ;;9002226.02101,"1195,00007-3370-13 ",.01)
 ;;00007-3370-13
 ;;9002226.02101,"1195,00007-3370-13 ",.02)
 ;;00007-3370-13
 ;;9002226.02101,"1195,00007-3370-59 ",.01)
 ;;00007-3370-59
 ;;9002226.02101,"1195,00007-3370-59 ",.02)
 ;;00007-3370-59
 ;;9002226.02101,"1195,00007-3371-13 ",.01)
 ;;00007-3371-13
 ;;9002226.02101,"1195,00007-3371-13 ",.02)
 ;;00007-3371-13
 ;;9002226.02101,"1195,00007-3371-59 ",.01)
 ;;00007-3371-59
 ;;9002226.02101,"1195,00007-3371-59 ",.02)
 ;;00007-3371-59
 ;;9002226.02101,"1195,00007-3372-13 ",.01)
 ;;00007-3372-13
 ;;9002226.02101,"1195,00007-3372-13 ",.02)
 ;;00007-3372-13
 ;;9002226.02101,"1195,00007-3372-59 ",.01)
 ;;00007-3372-59
 ;;9002226.02101,"1195,00007-3372-59 ",.02)
 ;;00007-3372-59
 ;;9002226.02101,"1195,00007-3373-13 ",.01)
 ;;00007-3373-13
 ;;9002226.02101,"1195,00007-3373-13 ",.02)
 ;;00007-3373-13
 ;;9002226.02101,"1195,00007-3373-59 ",.01)
 ;;00007-3373-59
 ;;9002226.02101,"1195,00007-3373-59 ",.02)
 ;;00007-3373-59
 ;;9002226.02101,"1195,00007-4139-20 ",.01)
 ;;00007-4139-20
 ;;9002226.02101,"1195,00007-4139-20 ",.02)
 ;;00007-4139-20
 ;;9002226.02101,"1195,00007-4139-55 ",.01)
 ;;00007-4139-55
 ;;9002226.02101,"1195,00007-4139-55 ",.02)
 ;;00007-4139-55
 ;;9002226.02101,"1195,00007-4140-20 ",.01)
 ;;00007-4140-20
 ;;9002226.02101,"1195,00007-4140-20 ",.02)
 ;;00007-4140-20
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
 ;;9002226.02101,"1195,00078-0459-09 ",.02)
 ;;00078-0459-09
 ;;9002226.02101,"1195,00078-0460-05 ",.01)
 ;;00078-0460-05
 ;;9002226.02101,"1195,00078-0460-05 ",.02)
 ;;00078-0460-05
 ;;9002226.02101,"1195,00078-0461-05 ",.01)
 ;;00078-0461-05
 ;;9002226.02101,"1195,00078-0461-05 ",.02)
 ;;00078-0461-05
 ;;9002226.02101,"1195,00078-0462-05 ",.01)
 ;;00078-0462-05
 ;;9002226.02101,"1195,00078-0462-05 ",.02)
 ;;00078-0462-05
 ;;9002226.02101,"1195,00085-0244-04 ",.01)
 ;;00085-0244-04
 ;;9002226.02101,"1195,00085-0244-04 ",.02)
 ;;00085-0244-04
 ;;9002226.02101,"1195,00085-0244-05 ",.01)
 ;;00085-0244-05
 ;;9002226.02101,"1195,00085-0244-05 ",.02)
 ;;00085-0244-05
 ;;9002226.02101,"1195,00085-0244-07 ",.01)
 ;;00085-0244-07
 ;;9002226.02101,"1195,00085-0244-07 ",.02)
 ;;00085-0244-07
 ;;9002226.02101,"1195,00085-0244-08 ",.01)
 ;;00085-0244-08
 ;;9002226.02101,"1195,00085-0244-08 ",.02)
 ;;00085-0244-08
 ;;9002226.02101,"1195,00085-0438-03 ",.01)
 ;;00085-0438-03
 ;;9002226.02101,"1195,00085-0438-03 ",.02)
 ;;00085-0438-03
 ;;9002226.02101,"1195,00085-0438-05 ",.01)
 ;;00085-0438-05
 ;;9002226.02101,"1195,00085-0438-05 ",.02)
 ;;00085-0438-05
 ;;9002226.02101,"1195,00085-0438-06 ",.01)
 ;;00085-0438-06
 ;;9002226.02101,"1195,00085-0438-06 ",.02)
 ;;00085-0438-06
 ;;9002226.02101,"1195,00085-0752-04 ",.01)
 ;;00085-0752-04
 ;;9002226.02101,"1195,00085-0752-04 ",.02)
 ;;00085-0752-04
 ;;9002226.02101,"1195,00085-0752-05 ",.01)
 ;;00085-0752-05
 ;;9002226.02101,"1195,00085-0752-05 ",.02)
 ;;00085-0752-05
 ;;9002226.02101,"1195,00085-0752-07 ",.01)
 ;;00085-0752-07
 ;;9002226.02101,"1195,00085-0752-07 ",.02)
 ;;00085-0752-07
 ;;9002226.02101,"1195,00085-0752-08 ",.01)
 ;;00085-0752-08
 ;;9002226.02101,"1195,00085-0752-08 ",.02)
 ;;00085-0752-08
 ;;9002226.02101,"1195,00091-4500-15 ",.01)
 ;;00091-4500-15
 ;;9002226.02101,"1195,00091-4500-15 ",.02)
 ;;00091-4500-15
 ;;9002226.02101,"1195,00093-0051-01 ",.01)
 ;;00093-0051-01
 ;;9002226.02101,"1195,00093-0051-01 ",.02)
 ;;00093-0051-01
 ;;9002226.02101,"1195,00093-0051-05 ",.01)
 ;;00093-0051-05
 ;;9002226.02101,"1195,00093-0051-05 ",.02)
 ;;00093-0051-05
 ;;9002226.02101,"1195,00093-0135-01 ",.01)
 ;;00093-0135-01
 ;;9002226.02101,"1195,00093-0135-01 ",.02)
 ;;00093-0135-01
 ;;9002226.02101,"1195,00093-0135-05 ",.01)
 ;;00093-0135-05
 ;;9002226.02101,"1195,00093-0135-05 ",.02)
 ;;00093-0135-05
 ;;9002226.02101,"1195,00093-0733-01 ",.01)
 ;;00093-0733-01
 ;;9002226.02101,"1195,00093-0733-01 ",.02)
 ;;00093-0733-01
 ;;9002226.02101,"1195,00093-0733-10 ",.01)
 ;;00093-0733-10
 ;;9002226.02101,"1195,00093-0733-10 ",.02)
 ;;00093-0733-10
 ;;9002226.02101,"1195,00093-0734-01 ",.01)
 ;;00093-0734-01
 ;;9002226.02101,"1195,00093-0734-01 ",.02)
 ;;00093-0734-01
 ;;9002226.02101,"1195,00093-0734-10 ",.01)
 ;;00093-0734-10
 ;;9002226.02101,"1195,00093-0734-10 ",.02)
 ;;00093-0734-10
 ;;9002226.02101,"1195,00093-0752-01 ",.01)
 ;;00093-0752-01
 ;;9002226.02101,"1195,00093-0752-01 ",.02)
 ;;00093-0752-01
 ;;9002226.02101,"1195,00093-0752-10 ",.01)
 ;;00093-0752-10
 ;;9002226.02101,"1195,00093-0752-10 ",.02)
 ;;00093-0752-10
 ;;9002226.02101,"1195,00093-0753-01 ",.01)
 ;;00093-0753-01
 ;;9002226.02101,"1195,00093-0753-01 ",.02)
 ;;00093-0753-01
 ;;9002226.02101,"1195,00093-0753-05 ",.01)
 ;;00093-0753-05
 ;;9002226.02101,"1195,00093-0753-05 ",.02)
 ;;00093-0753-05
 ;;9002226.02101,"1195,00093-0787-01 ",.01)
 ;;00093-0787-01
 ;;9002226.02101,"1195,00093-0787-01 ",.02)
 ;;00093-0787-01
 ;;9002226.02101,"1195,00093-0787-10 ",.01)
 ;;00093-0787-10
 ;;9002226.02101,"1195,00093-0787-10 ",.02)
 ;;00093-0787-10
 ;;9002226.02101,"1195,00093-4235-01 ",.01)
 ;;00093-4235-01
 ;;9002226.02101,"1195,00093-4235-01 ",.02)
 ;;00093-4235-01
 ;;9002226.02101,"1195,00093-4236-01 ",.01)
 ;;00093-4236-01
 ;;9002226.02101,"1195,00093-4236-01 ",.02)
 ;;00093-4236-01
 ;;9002226.02101,"1195,00093-4237-01 ",.01)
 ;;00093-4237-01
 ;;9002226.02101,"1195,00093-4237-01 ",.02)
 ;;00093-4237-01
 ;;9002226.02101,"1195,00093-5270-56 ",.01)
 ;;00093-5270-56
 ;;9002226.02101,"1195,00093-5270-56 ",.02)
 ;;00093-5270-56
 ;;9002226.02101,"1195,00093-5271-56 ",.01)
 ;;00093-5271-56
 ;;9002226.02101,"1195,00093-5271-56 ",.02)
 ;;00093-5271-56
 ;;9002226.02101,"1195,00093-7295-01 ",.01)
 ;;00093-7295-01
 ;;9002226.02101,"1195,00093-7295-01 ",.02)
 ;;00093-7295-01
 ;;9002226.02101,"1195,00093-7295-05 ",.01)
 ;;00093-7295-05
 ;;9002226.02101,"1195,00093-7295-05 ",.02)
 ;;00093-7295-05
 ;;9002226.02101,"1195,00093-7296-01 ",.01)
 ;;00093-7296-01
 ;;9002226.02101,"1195,00093-7296-01 ",.02)
 ;;00093-7296-01
 ;;9002226.02101,"1195,00093-7296-05 ",.01)
 ;;00093-7296-05
 ;;9002226.02101,"1195,00093-7296-05 ",.02)
 ;;00093-7296-05
 ;;9002226.02101,"1195,00115-5311-01 ",.01)
 ;;00115-5311-01
 ;;9002226.02101,"1195,00115-5311-01 ",.02)
 ;;00115-5311-01
 ;;9002226.02101,"1195,00115-5322-01 ",.01)
 ;;00115-5322-01
 ;;9002226.02101,"1195,00115-5322-01 ",.02)
 ;;00115-5322-01
 ;;9002226.02101,"1195,00172-4217-60 ",.01)
 ;;00172-4217-60
 ;;9002226.02101,"1195,00172-4217-60 ",.02)
 ;;00172-4217-60
 ;;9002226.02101,"1195,00172-4218-60 ",.01)
 ;;00172-4218-60
 ;;9002226.02101,"1195,00172-4218-60 ",.02)
 ;;00172-4218-60
 ;;9002226.02101,"1195,00172-4235-60 ",.01)
 ;;00172-4235-60
 ;;9002226.02101,"1195,00172-4235-60 ",.02)
 ;;00172-4235-60
 ;;9002226.02101,"1195,00172-4235-70 ",.01)
 ;;00172-4235-70
 ;;9002226.02101,"1195,00172-4235-70 ",.02)
 ;;00172-4235-70
 ;;9002226.02101,"1195,00172-4236-60 ",.01)
 ;;00172-4236-60
 ;;9002226.02101,"1195,00172-4236-60 ",.02)
 ;;00172-4236-60
 ;;9002226.02101,"1195,00172-4237-60 ",.01)
 ;;00172-4237-60
 ;;9002226.02101,"1195,00172-4237-60 ",.02)
 ;;00172-4237-60
 ;;9002226.02101,"1195,00172-4238-60 ",.01)
 ;;00172-4238-60
 ;;9002226.02101,"1195,00172-4238-60 ",.02)
 ;;00172-4238-60
 ;;9002226.02101,"1195,00172-4239-60 ",.01)
 ;;00172-4239-60
 ;;9002226.02101,"1195,00172-4239-60 ",.02)
 ;;00172-4239-60
 ;;9002226.02101,"1195,00172-4364-00 ",.01)
 ;;00172-4364-00
 ;;9002226.02101,"1195,00172-4364-00 ",.02)
 ;;00172-4364-00
 ;;9002226.02101,"1195,00172-4364-10 ",.01)
 ;;00172-4364-10
 ;;9002226.02101,"1195,00172-4364-10 ",.02)
 ;;00172-4364-10
 ;;9002226.02101,"1195,00172-4364-60 ",.01)
 ;;00172-4364-60
 ;;9002226.02101,"1195,00172-4364-60 ",.02)
 ;;00172-4364-60
 ;;9002226.02101,"1195,00172-4364-70 ",.01)
 ;;00172-4364-70
 ;;9002226.02101,"1195,00172-4364-70 ",.02)
 ;;00172-4364-70
 ;;9002226.02101,"1195,00172-4365-00 ",.01)
 ;;00172-4365-00
 ;;9002226.02101,"1195,00172-4365-00 ",.02)
 ;;00172-4365-00
 ;;9002226.02101,"1195,00172-4365-10 ",.01)
 ;;00172-4365-10
 ;;9002226.02101,"1195,00172-4365-10 ",.02)
 ;;00172-4365-10
