BGP2TI16 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1201,57866-7982-01 ",.01)
 ;;57866-7982-01
 ;;9002226.02101,"1201,57866-7982-01 ",.02)
 ;;57866-7982-01
 ;;9002226.02101,"1201,57866-7983-01 ",.01)
 ;;57866-7983-01
 ;;9002226.02101,"1201,57866-7983-01 ",.02)
 ;;57866-7983-01
 ;;9002226.02101,"1201,57866-7986-01 ",.01)
 ;;57866-7986-01
 ;;9002226.02101,"1201,57866-7986-01 ",.02)
 ;;57866-7986-01
 ;;9002226.02101,"1201,57866-8615-01 ",.01)
 ;;57866-8615-01
 ;;9002226.02101,"1201,57866-8615-01 ",.02)
 ;;57866-8615-01
 ;;9002226.02101,"1201,58016-0006-00 ",.01)
 ;;58016-0006-00
 ;;9002226.02101,"1201,58016-0006-00 ",.02)
 ;;58016-0006-00
 ;;9002226.02101,"1201,58016-0006-30 ",.01)
 ;;58016-0006-30
 ;;9002226.02101,"1201,58016-0006-30 ",.02)
 ;;58016-0006-30
 ;;9002226.02101,"1201,58016-0006-60 ",.01)
 ;;58016-0006-60
 ;;9002226.02101,"1201,58016-0006-60 ",.02)
 ;;58016-0006-60
 ;;9002226.02101,"1201,58016-0006-90 ",.01)
 ;;58016-0006-90
 ;;9002226.02101,"1201,58016-0006-90 ",.02)
 ;;58016-0006-90
 ;;9002226.02101,"1201,58016-0007-00 ",.01)
 ;;58016-0007-00
 ;;9002226.02101,"1201,58016-0007-00 ",.02)
 ;;58016-0007-00
 ;;9002226.02101,"1201,58016-0007-30 ",.01)
 ;;58016-0007-30
 ;;9002226.02101,"1201,58016-0007-30 ",.02)
 ;;58016-0007-30
 ;;9002226.02101,"1201,58016-0007-60 ",.01)
 ;;58016-0007-60
 ;;9002226.02101,"1201,58016-0007-60 ",.02)
 ;;58016-0007-60
 ;;9002226.02101,"1201,58016-0007-90 ",.01)
 ;;58016-0007-90
 ;;9002226.02101,"1201,58016-0007-90 ",.02)
 ;;58016-0007-90
 ;;9002226.02101,"1201,58016-0008-00 ",.01)
 ;;58016-0008-00
 ;;9002226.02101,"1201,58016-0008-00 ",.02)
 ;;58016-0008-00
 ;;9002226.02101,"1201,58016-0008-30 ",.01)
 ;;58016-0008-30
 ;;9002226.02101,"1201,58016-0008-30 ",.02)
 ;;58016-0008-30
 ;;9002226.02101,"1201,58016-0008-60 ",.01)
 ;;58016-0008-60
 ;;9002226.02101,"1201,58016-0008-60 ",.02)
 ;;58016-0008-60
 ;;9002226.02101,"1201,58016-0008-90 ",.01)
 ;;58016-0008-90
 ;;9002226.02101,"1201,58016-0008-90 ",.02)
 ;;58016-0008-90
 ;;9002226.02101,"1201,58016-0012-00 ",.01)
 ;;58016-0012-00
 ;;9002226.02101,"1201,58016-0012-00 ",.02)
 ;;58016-0012-00
 ;;9002226.02101,"1201,58016-0012-30 ",.01)
 ;;58016-0012-30
 ;;9002226.02101,"1201,58016-0012-30 ",.02)
 ;;58016-0012-30
 ;;9002226.02101,"1201,58016-0012-60 ",.01)
 ;;58016-0012-60
 ;;9002226.02101,"1201,58016-0012-60 ",.02)
 ;;58016-0012-60
 ;;9002226.02101,"1201,58016-0012-90 ",.01)
 ;;58016-0012-90
 ;;9002226.02101,"1201,58016-0012-90 ",.02)
 ;;58016-0012-90
 ;;9002226.02101,"1201,58016-0013-00 ",.01)
 ;;58016-0013-00
 ;;9002226.02101,"1201,58016-0013-00 ",.02)
 ;;58016-0013-00
 ;;9002226.02101,"1201,58016-0013-30 ",.01)
 ;;58016-0013-30
 ;;9002226.02101,"1201,58016-0013-30 ",.02)
 ;;58016-0013-30
 ;;9002226.02101,"1201,58016-0013-60 ",.01)
 ;;58016-0013-60
 ;;9002226.02101,"1201,58016-0013-60 ",.02)
 ;;58016-0013-60
 ;;9002226.02101,"1201,58016-0013-90 ",.01)
 ;;58016-0013-90
 ;;9002226.02101,"1201,58016-0013-90 ",.02)
 ;;58016-0013-90
 ;;9002226.02101,"1201,58016-0037-00 ",.01)
 ;;58016-0037-00
 ;;9002226.02101,"1201,58016-0037-00 ",.02)
 ;;58016-0037-00
 ;;9002226.02101,"1201,58016-0037-30 ",.01)
 ;;58016-0037-30
 ;;9002226.02101,"1201,58016-0037-30 ",.02)
 ;;58016-0037-30
 ;;9002226.02101,"1201,58016-0037-60 ",.01)
 ;;58016-0037-60
 ;;9002226.02101,"1201,58016-0037-60 ",.02)
 ;;58016-0037-60
 ;;9002226.02101,"1201,58016-0037-90 ",.01)
 ;;58016-0037-90
 ;;9002226.02101,"1201,58016-0037-90 ",.02)
 ;;58016-0037-90
 ;;9002226.02101,"1201,58016-0051-00 ",.01)
 ;;58016-0051-00
 ;;9002226.02101,"1201,58016-0051-00 ",.02)
 ;;58016-0051-00
 ;;9002226.02101,"1201,58016-0051-30 ",.01)
 ;;58016-0051-30
 ;;9002226.02101,"1201,58016-0051-30 ",.02)
 ;;58016-0051-30
 ;;9002226.02101,"1201,58016-0051-60 ",.01)
 ;;58016-0051-60
 ;;9002226.02101,"1201,58016-0051-60 ",.02)
 ;;58016-0051-60
 ;;9002226.02101,"1201,58016-0051-90 ",.01)
 ;;58016-0051-90
 ;;9002226.02101,"1201,58016-0051-90 ",.02)
 ;;58016-0051-90
 ;;9002226.02101,"1201,58016-0052-00 ",.01)
 ;;58016-0052-00
 ;;9002226.02101,"1201,58016-0052-00 ",.02)
 ;;58016-0052-00
 ;;9002226.02101,"1201,58016-0052-30 ",.01)
 ;;58016-0052-30
 ;;9002226.02101,"1201,58016-0052-30 ",.02)
 ;;58016-0052-30
 ;;9002226.02101,"1201,58016-0052-60 ",.01)
 ;;58016-0052-60
 ;;9002226.02101,"1201,58016-0052-60 ",.02)
 ;;58016-0052-60
 ;;9002226.02101,"1201,58016-0052-90 ",.01)
 ;;58016-0052-90
 ;;9002226.02101,"1201,58016-0052-90 ",.02)
 ;;58016-0052-90
 ;;9002226.02101,"1201,58016-0071-00 ",.01)
 ;;58016-0071-00
 ;;9002226.02101,"1201,58016-0071-00 ",.02)
 ;;58016-0071-00
 ;;9002226.02101,"1201,58016-0071-30 ",.01)
 ;;58016-0071-30
 ;;9002226.02101,"1201,58016-0071-30 ",.02)
 ;;58016-0071-30
 ;;9002226.02101,"1201,58016-0071-60 ",.01)
 ;;58016-0071-60
 ;;9002226.02101,"1201,58016-0071-60 ",.02)
 ;;58016-0071-60
 ;;9002226.02101,"1201,58016-0071-90 ",.01)
 ;;58016-0071-90
 ;;9002226.02101,"1201,58016-0071-90 ",.02)
 ;;58016-0071-90
 ;;9002226.02101,"1201,58016-0364-00 ",.01)
 ;;58016-0364-00
 ;;9002226.02101,"1201,58016-0364-00 ",.02)
 ;;58016-0364-00
 ;;9002226.02101,"1201,58016-0364-30 ",.01)
 ;;58016-0364-30
 ;;9002226.02101,"1201,58016-0364-30 ",.02)
 ;;58016-0364-30
 ;;9002226.02101,"1201,58016-0364-60 ",.01)
 ;;58016-0364-60
 ;;9002226.02101,"1201,58016-0364-60 ",.02)
 ;;58016-0364-60
 ;;9002226.02101,"1201,58016-0364-90 ",.01)
 ;;58016-0364-90
 ;;9002226.02101,"1201,58016-0364-90 ",.02)
 ;;58016-0364-90
 ;;9002226.02101,"1201,58016-0365-00 ",.01)
 ;;58016-0365-00
 ;;9002226.02101,"1201,58016-0365-00 ",.02)
 ;;58016-0365-00
 ;;9002226.02101,"1201,58016-0365-30 ",.01)
 ;;58016-0365-30
 ;;9002226.02101,"1201,58016-0365-30 ",.02)
 ;;58016-0365-30
 ;;9002226.02101,"1201,58016-0365-60 ",.01)
 ;;58016-0365-60
 ;;9002226.02101,"1201,58016-0365-60 ",.02)
 ;;58016-0365-60
 ;;9002226.02101,"1201,58016-0365-90 ",.01)
 ;;58016-0365-90
 ;;9002226.02101,"1201,58016-0365-90 ",.02)
 ;;58016-0365-90
 ;;9002226.02101,"1201,58016-0385-00 ",.01)
 ;;58016-0385-00
 ;;9002226.02101,"1201,58016-0385-00 ",.02)
 ;;58016-0385-00
 ;;9002226.02101,"1201,58016-0385-30 ",.01)
 ;;58016-0385-30
 ;;9002226.02101,"1201,58016-0385-30 ",.02)
 ;;58016-0385-30
 ;;9002226.02101,"1201,58016-0385-60 ",.01)
 ;;58016-0385-60
 ;;9002226.02101,"1201,58016-0385-60 ",.02)
 ;;58016-0385-60
 ;;9002226.02101,"1201,58016-0385-90 ",.01)
 ;;58016-0385-90
 ;;9002226.02101,"1201,58016-0385-90 ",.02)
 ;;58016-0385-90
 ;;9002226.02101,"1201,58016-0425-00 ",.01)
 ;;58016-0425-00
 ;;9002226.02101,"1201,58016-0425-00 ",.02)
 ;;58016-0425-00
 ;;9002226.02101,"1201,58016-0425-30 ",.01)
 ;;58016-0425-30
 ;;9002226.02101,"1201,58016-0425-30 ",.02)
 ;;58016-0425-30
 ;;9002226.02101,"1201,58016-0425-60 ",.01)
 ;;58016-0425-60
 ;;9002226.02101,"1201,58016-0425-60 ",.02)
 ;;58016-0425-60
 ;;9002226.02101,"1201,58016-0425-90 ",.01)
 ;;58016-0425-90
 ;;9002226.02101,"1201,58016-0425-90 ",.02)
 ;;58016-0425-90
 ;;9002226.02101,"1201,58016-0546-00 ",.01)
 ;;58016-0546-00
 ;;9002226.02101,"1201,58016-0546-00 ",.02)
 ;;58016-0546-00
 ;;9002226.02101,"1201,58016-0900-00 ",.01)
 ;;58016-0900-00
 ;;9002226.02101,"1201,58016-0900-00 ",.02)
 ;;58016-0900-00
 ;;9002226.02101,"1201,58016-0900-02 ",.01)
 ;;58016-0900-02
 ;;9002226.02101,"1201,58016-0900-02 ",.02)
 ;;58016-0900-02
 ;;9002226.02101,"1201,58016-0900-30 ",.01)
 ;;58016-0900-30
 ;;9002226.02101,"1201,58016-0900-30 ",.02)
 ;;58016-0900-30
 ;;9002226.02101,"1201,58016-0900-60 ",.01)
 ;;58016-0900-60
 ;;9002226.02101,"1201,58016-0900-60 ",.02)
 ;;58016-0900-60
 ;;9002226.02101,"1201,58016-0900-90 ",.01)
 ;;58016-0900-90
 ;;9002226.02101,"1201,58016-0900-90 ",.02)
 ;;58016-0900-90
 ;;9002226.02101,"1201,58016-0922-00 ",.01)
 ;;58016-0922-00
 ;;9002226.02101,"1201,58016-0922-00 ",.02)
 ;;58016-0922-00
 ;;9002226.02101,"1201,58016-0922-02 ",.01)
 ;;58016-0922-02
 ;;9002226.02101,"1201,58016-0922-02 ",.02)
 ;;58016-0922-02
 ;;9002226.02101,"1201,58016-0922-30 ",.01)
 ;;58016-0922-30
 ;;9002226.02101,"1201,58016-0922-30 ",.02)
 ;;58016-0922-30
 ;;9002226.02101,"1201,58016-0922-60 ",.01)
 ;;58016-0922-60
 ;;9002226.02101,"1201,58016-0922-60 ",.02)
 ;;58016-0922-60
 ;;9002226.02101,"1201,58016-0922-90 ",.01)
 ;;58016-0922-90
 ;;9002226.02101,"1201,58016-0922-90 ",.02)
 ;;58016-0922-90
 ;;9002226.02101,"1201,58016-0979-00 ",.01)
 ;;58016-0979-00
 ;;9002226.02101,"1201,58016-0979-00 ",.02)
 ;;58016-0979-00
 ;;9002226.02101,"1201,58016-0979-02 ",.01)
 ;;58016-0979-02
 ;;9002226.02101,"1201,58016-0979-02 ",.02)
 ;;58016-0979-02
 ;;9002226.02101,"1201,58016-0979-20 ",.01)
 ;;58016-0979-20
 ;;9002226.02101,"1201,58016-0979-20 ",.02)
 ;;58016-0979-20
 ;;9002226.02101,"1201,58016-0979-30 ",.01)
 ;;58016-0979-30
 ;;9002226.02101,"1201,58016-0979-30 ",.02)
 ;;58016-0979-30
 ;;9002226.02101,"1201,58016-0979-60 ",.01)
 ;;58016-0979-60
 ;;9002226.02101,"1201,58016-0979-60 ",.02)
 ;;58016-0979-60
 ;;9002226.02101,"1201,58016-0979-90 ",.01)
 ;;58016-0979-90
 ;;9002226.02101,"1201,58016-0979-90 ",.02)
 ;;58016-0979-90
 ;;9002226.02101,"1201,58864-0608-30 ",.01)
 ;;58864-0608-30
 ;;9002226.02101,"1201,58864-0608-30 ",.02)
 ;;58864-0608-30
 ;;9002226.02101,"1201,58864-0623-15 ",.01)
 ;;58864-0623-15
 ;;9002226.02101,"1201,58864-0623-15 ",.02)
 ;;58864-0623-15
 ;;9002226.02101,"1201,58864-0623-30 ",.01)
 ;;58864-0623-30
 ;;9002226.02101,"1201,58864-0623-30 ",.02)
 ;;58864-0623-30
 ;;9002226.02101,"1201,58864-0653-30 ",.01)
 ;;58864-0653-30
 ;;9002226.02101,"1201,58864-0653-30 ",.02)
 ;;58864-0653-30
 ;;9002226.02101,"1201,58864-0682-30 ",.01)
 ;;58864-0682-30
 ;;9002226.02101,"1201,58864-0682-30 ",.02)
 ;;58864-0682-30
 ;;9002226.02101,"1201,58864-0685-30 ",.01)
 ;;58864-0685-30
 ;;9002226.02101,"1201,58864-0685-30 ",.02)
 ;;58864-0685-30
 ;;9002226.02101,"1201,58864-0739-30 ",.01)
 ;;58864-0739-30
 ;;9002226.02101,"1201,58864-0739-30 ",.02)
 ;;58864-0739-30
 ;;9002226.02101,"1201,58864-0743-15 ",.01)
 ;;58864-0743-15
 ;;9002226.02101,"1201,58864-0743-15 ",.02)
 ;;58864-0743-15
 ;;9002226.02101,"1201,58864-0743-30 ",.01)
 ;;58864-0743-30
 ;;9002226.02101,"1201,58864-0743-30 ",.02)
 ;;58864-0743-30
 ;;9002226.02101,"1201,58864-0760-30 ",.01)
 ;;58864-0760-30
 ;;9002226.02101,"1201,58864-0760-30 ",.02)
 ;;58864-0760-30
 ;;9002226.02101,"1201,58864-0780-30 ",.01)
 ;;58864-0780-30
 ;;9002226.02101,"1201,58864-0780-30 ",.02)
 ;;58864-0780-30
 ;;9002226.02101,"1201,58864-0780-60 ",.01)
 ;;58864-0780-60
 ;;9002226.02101,"1201,58864-0780-60 ",.02)
 ;;58864-0780-60
 ;;9002226.02101,"1201,58864-0781-30 ",.01)
 ;;58864-0781-30
 ;;9002226.02101,"1201,58864-0781-30 ",.02)
 ;;58864-0781-30
 ;;9002226.02101,"1201,58864-0834-30 ",.01)
 ;;58864-0834-30
 ;;9002226.02101,"1201,58864-0834-30 ",.02)
 ;;58864-0834-30
 ;;9002226.02101,"1201,59630-0628-30 ",.01)
 ;;59630-0628-30
 ;;9002226.02101,"1201,59630-0628-30 ",.02)
 ;;59630-0628-30
 ;;9002226.02101,"1201,59630-0629-30 ",.01)
 ;;59630-0629-30
 ;;9002226.02101,"1201,59630-0629-30 ",.02)
 ;;59630-0629-30
 ;;9002226.02101,"1201,59630-0630-30 ",.01)
 ;;59630-0630-30
 ;;9002226.02101,"1201,59630-0630-30 ",.02)
 ;;59630-0630-30
 ;;9002226.02101,"1201,60429-0248-10 ",.01)
 ;;60429-0248-10
 ;;9002226.02101,"1201,60429-0248-10 ",.02)
 ;;60429-0248-10
 ;;9002226.02101,"1201,60429-0248-60 ",.01)
 ;;60429-0248-60
 ;;9002226.02101,"1201,60429-0248-60 ",.02)
 ;;60429-0248-60
 ;;9002226.02101,"1201,60429-0249-10 ",.01)
 ;;60429-0249-10
 ;;9002226.02101,"1201,60429-0249-10 ",.02)
 ;;60429-0249-10
 ;;9002226.02101,"1201,60429-0249-60 ",.01)
 ;;60429-0249-60
 ;;9002226.02101,"1201,60429-0249-60 ",.02)
 ;;60429-0249-60
 ;;9002226.02101,"1201,60429-0250-10 ",.01)
 ;;60429-0250-10
 ;;9002226.02101,"1201,60429-0250-10 ",.02)
 ;;60429-0250-10
 ;;9002226.02101,"1201,60429-0250-60 ",.01)
 ;;60429-0250-60
 ;;9002226.02101,"1201,60429-0250-60 ",.02)
 ;;60429-0250-60
 ;;9002226.02101,"1201,60429-0250-90 ",.01)
 ;;60429-0250-90
 ;;9002226.02101,"1201,60429-0250-90 ",.02)
 ;;60429-0250-90
 ;;9002226.02101,"1201,60505-0168-05 ",.01)
 ;;60505-0168-05
 ;;9002226.02101,"1201,60505-0168-05 ",.02)
 ;;60505-0168-05
 ;;9002226.02101,"1201,60505-0168-09 ",.01)
 ;;60505-0168-09
 ;;9002226.02101,"1201,60505-0168-09 ",.02)
 ;;60505-0168-09
 ;;9002226.02101,"1201,60505-0169-07 ",.01)
 ;;60505-0169-07
 ;;9002226.02101,"1201,60505-0169-07 ",.02)
 ;;60505-0169-07
 ;;9002226.02101,"1201,60505-0169-09 ",.01)
 ;;60505-0169-09
 ;;9002226.02101,"1201,60505-0169-09 ",.02)
 ;;60505-0169-09
 ;;9002226.02101,"1201,60505-0170-07 ",.01)
 ;;60505-0170-07
 ;;9002226.02101,"1201,60505-0170-07 ",.02)
 ;;60505-0170-07
 ;;9002226.02101,"1201,60505-0170-08 ",.01)
 ;;60505-0170-08
 ;;9002226.02101,"1201,60505-0170-08 ",.02)
 ;;60505-0170-08
 ;;9002226.02101,"1201,60505-0170-09 ",.01)
 ;;60505-0170-09
 ;;9002226.02101,"1201,60505-0170-09 ",.02)
 ;;60505-0170-09
 ;;9002226.02101,"1201,60505-0177-00 ",.01)
 ;;60505-0177-00
 ;;9002226.02101,"1201,60505-0177-00 ",.02)
 ;;60505-0177-00
 ;;9002226.02101,"1201,60505-0178-00 ",.01)
 ;;60505-0178-00
 ;;9002226.02101,"1201,60505-0178-00 ",.02)
 ;;60505-0178-00
 ;;9002226.02101,"1201,60505-0179-00 ",.01)
 ;;60505-0179-00
 ;;9002226.02101,"1201,60505-0179-00 ",.02)
 ;;60505-0179-00
 ;;9002226.02101,"1201,60505-1323-05 ",.01)
 ;;60505-1323-05
 ;;9002226.02101,"1201,60505-1323-05 ",.02)
 ;;60505-1323-05
 ;;9002226.02101,"1201,60505-1323-09 ",.01)
 ;;60505-1323-09
 ;;9002226.02101,"1201,60505-1323-09 ",.02)
 ;;60505-1323-09
 ;;9002226.02101,"1201,60598-0006-90 ",.01)
 ;;60598-0006-90
