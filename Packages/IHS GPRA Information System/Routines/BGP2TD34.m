BGP2TD34 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1729,54868-3726-02 ",.02)
 ;;54868-3726-02
 ;;9002226.02101,"1729,54868-3769-00 ",.01)
 ;;54868-3769-00
 ;;9002226.02101,"1729,54868-3769-00 ",.02)
 ;;54868-3769-00
 ;;9002226.02101,"1729,54868-3846-00 ",.01)
 ;;54868-3846-00
 ;;9002226.02101,"1729,54868-3846-00 ",.02)
 ;;54868-3846-00
 ;;9002226.02101,"1729,54868-3846-01 ",.01)
 ;;54868-3846-01
 ;;9002226.02101,"1729,54868-3846-01 ",.02)
 ;;54868-3846-01
 ;;9002226.02101,"1729,54868-3846-02 ",.01)
 ;;54868-3846-02
 ;;9002226.02101,"1729,54868-3846-02 ",.02)
 ;;54868-3846-02
 ;;9002226.02101,"1729,54868-3846-03 ",.01)
 ;;54868-3846-03
 ;;9002226.02101,"1729,54868-3846-03 ",.02)
 ;;54868-3846-03
 ;;9002226.02101,"1729,54868-3866-00 ",.01)
 ;;54868-3866-00
 ;;9002226.02101,"1729,54868-3866-00 ",.02)
 ;;54868-3866-00
 ;;9002226.02101,"1729,54868-3866-01 ",.01)
 ;;54868-3866-01
 ;;9002226.02101,"1729,54868-3866-01 ",.02)
 ;;54868-3866-01
 ;;9002226.02101,"1729,54868-3891-00 ",.01)
 ;;54868-3891-00
 ;;9002226.02101,"1729,54868-3891-00 ",.02)
 ;;54868-3891-00
 ;;9002226.02101,"1729,54868-3906-00 ",.01)
 ;;54868-3906-00
 ;;9002226.02101,"1729,54868-3906-00 ",.02)
 ;;54868-3906-00
 ;;9002226.02101,"1729,54868-3906-01 ",.01)
 ;;54868-3906-01
 ;;9002226.02101,"1729,54868-3906-01 ",.02)
 ;;54868-3906-01
 ;;9002226.02101,"1729,54868-4003-00 ",.01)
 ;;54868-4003-00
 ;;9002226.02101,"1729,54868-4003-00 ",.02)
 ;;54868-4003-00
 ;;9002226.02101,"1729,54868-4062-00 ",.01)
 ;;54868-4062-00
 ;;9002226.02101,"1729,54868-4062-00 ",.02)
 ;;54868-4062-00
 ;;9002226.02101,"1729,54868-4062-01 ",.01)
 ;;54868-4062-01
 ;;9002226.02101,"1729,54868-4062-01 ",.02)
 ;;54868-4062-01
 ;;9002226.02101,"1729,54868-4066-00 ",.01)
 ;;54868-4066-00
 ;;9002226.02101,"1729,54868-4066-00 ",.02)
 ;;54868-4066-00
 ;;9002226.02101,"1729,54868-4066-01 ",.01)
 ;;54868-4066-01
 ;;9002226.02101,"1729,54868-4066-01 ",.02)
 ;;54868-4066-01
 ;;9002226.02101,"1729,54868-4073-00 ",.01)
 ;;54868-4073-00
 ;;9002226.02101,"1729,54868-4073-00 ",.02)
 ;;54868-4073-00
 ;;9002226.02101,"1729,54868-4073-01 ",.01)
 ;;54868-4073-01
 ;;9002226.02101,"1729,54868-4073-01 ",.02)
 ;;54868-4073-01
 ;;9002226.02101,"1729,54868-4073-02 ",.01)
 ;;54868-4073-02
 ;;9002226.02101,"1729,54868-4073-02 ",.02)
 ;;54868-4073-02
 ;;9002226.02101,"1729,54868-4073-03 ",.01)
 ;;54868-4073-03
 ;;9002226.02101,"1729,54868-4073-03 ",.02)
 ;;54868-4073-03
 ;;9002226.02101,"1729,54868-4074-00 ",.01)
 ;;54868-4074-00
 ;;9002226.02101,"1729,54868-4074-00 ",.02)
 ;;54868-4074-00
 ;;9002226.02101,"1729,54868-4074-01 ",.01)
 ;;54868-4074-01
 ;;9002226.02101,"1729,54868-4074-01 ",.02)
 ;;54868-4074-01
 ;;9002226.02101,"1729,54868-4074-02 ",.01)
 ;;54868-4074-02
 ;;9002226.02101,"1729,54868-4074-02 ",.02)
 ;;54868-4074-02
 ;;9002226.02101,"1729,54868-4074-03 ",.01)
 ;;54868-4074-03
 ;;9002226.02101,"1729,54868-4074-03 ",.02)
 ;;54868-4074-03
 ;;9002226.02101,"1729,54868-4074-04 ",.01)
 ;;54868-4074-04
 ;;9002226.02101,"1729,54868-4074-04 ",.02)
 ;;54868-4074-04
 ;;9002226.02101,"1729,54868-4088-00 ",.01)
 ;;54868-4088-00
 ;;9002226.02101,"1729,54868-4088-00 ",.02)
 ;;54868-4088-00
 ;;9002226.02101,"1729,54868-4088-01 ",.01)
 ;;54868-4088-01
 ;;9002226.02101,"1729,54868-4088-01 ",.02)
 ;;54868-4088-01
 ;;9002226.02101,"1729,54868-4088-02 ",.01)
 ;;54868-4088-02
 ;;9002226.02101,"1729,54868-4088-02 ",.02)
 ;;54868-4088-02
 ;;9002226.02101,"1729,54868-4178-00 ",.01)
 ;;54868-4178-00
 ;;9002226.02101,"1729,54868-4178-00 ",.02)
 ;;54868-4178-00
 ;;9002226.02101,"1729,54868-4199-00 ",.01)
 ;;54868-4199-00
 ;;9002226.02101,"1729,54868-4199-00 ",.02)
 ;;54868-4199-00
 ;;9002226.02101,"1729,54868-4199-01 ",.01)
 ;;54868-4199-01
 ;;9002226.02101,"1729,54868-4199-01 ",.02)
 ;;54868-4199-01
 ;;9002226.02101,"1729,54868-4199-02 ",.01)
 ;;54868-4199-02
 ;;9002226.02101,"1729,54868-4199-02 ",.02)
 ;;54868-4199-02
 ;;9002226.02101,"1729,54868-4209-00 ",.01)
 ;;54868-4209-00
 ;;9002226.02101,"1729,54868-4209-00 ",.02)
 ;;54868-4209-00
 ;;9002226.02101,"1729,54868-4331-00 ",.01)
 ;;54868-4331-00
 ;;9002226.02101,"1729,54868-4331-00 ",.02)
 ;;54868-4331-00
 ;;9002226.02101,"1729,54868-4331-01 ",.01)
 ;;54868-4331-01
 ;;9002226.02101,"1729,54868-4331-01 ",.02)
 ;;54868-4331-01
 ;;9002226.02101,"1729,54868-4331-02 ",.01)
 ;;54868-4331-02
 ;;9002226.02101,"1729,54868-4331-02 ",.02)
 ;;54868-4331-02
 ;;9002226.02101,"1729,54868-4332-00 ",.01)
 ;;54868-4332-00
 ;;9002226.02101,"1729,54868-4332-00 ",.02)
 ;;54868-4332-00
 ;;9002226.02101,"1729,54868-4332-01 ",.01)
 ;;54868-4332-01
 ;;9002226.02101,"1729,54868-4332-01 ",.02)
 ;;54868-4332-01
 ;;9002226.02101,"1729,54868-4332-02 ",.01)
 ;;54868-4332-02
 ;;9002226.02101,"1729,54868-4332-02 ",.02)
 ;;54868-4332-02
 ;;9002226.02101,"1729,54868-4341-00 ",.01)
 ;;54868-4341-00
 ;;9002226.02101,"1729,54868-4341-00 ",.02)
 ;;54868-4341-00
 ;;9002226.02101,"1729,54868-4341-01 ",.01)
 ;;54868-4341-01
 ;;9002226.02101,"1729,54868-4341-01 ",.02)
 ;;54868-4341-01
 ;;9002226.02101,"1729,54868-4357-00 ",.01)
 ;;54868-4357-00
 ;;9002226.02101,"1729,54868-4357-00 ",.02)
 ;;54868-4357-00
 ;;9002226.02101,"1729,54868-4357-01 ",.01)
 ;;54868-4357-01
 ;;9002226.02101,"1729,54868-4357-01 ",.02)
 ;;54868-4357-01
 ;;9002226.02101,"1729,54868-4357-02 ",.01)
 ;;54868-4357-02
 ;;9002226.02101,"1729,54868-4357-02 ",.02)
 ;;54868-4357-02
 ;;9002226.02101,"1729,54868-4357-03 ",.01)
 ;;54868-4357-03
 ;;9002226.02101,"1729,54868-4357-03 ",.02)
 ;;54868-4357-03
 ;;9002226.02101,"1729,54868-4358-00 ",.01)
 ;;54868-4358-00
 ;;9002226.02101,"1729,54868-4358-00 ",.02)
 ;;54868-4358-00
 ;;9002226.02101,"1729,54868-4358-01 ",.01)
 ;;54868-4358-01
 ;;9002226.02101,"1729,54868-4358-01 ",.02)
 ;;54868-4358-01
 ;;9002226.02101,"1729,54868-4358-02 ",.01)
 ;;54868-4358-02
 ;;9002226.02101,"1729,54868-4358-02 ",.02)
 ;;54868-4358-02
 ;;9002226.02101,"1729,54868-4358-03 ",.01)
 ;;54868-4358-03
 ;;9002226.02101,"1729,54868-4358-03 ",.02)
 ;;54868-4358-03
 ;;9002226.02101,"1729,54868-4406-00 ",.01)
 ;;54868-4406-00
 ;;9002226.02101,"1729,54868-4406-00 ",.02)
 ;;54868-4406-00
 ;;9002226.02101,"1729,54868-4413-00 ",.01)
 ;;54868-4413-00
 ;;9002226.02101,"1729,54868-4413-00 ",.02)
 ;;54868-4413-00
 ;;9002226.02101,"1729,54868-4414-00 ",.01)
 ;;54868-4414-00
 ;;9002226.02101,"1729,54868-4414-00 ",.02)
 ;;54868-4414-00
 ;;9002226.02101,"1729,54868-4414-01 ",.01)
 ;;54868-4414-01
 ;;9002226.02101,"1729,54868-4414-01 ",.02)
 ;;54868-4414-01
 ;;9002226.02101,"1729,54868-4425-00 ",.01)
 ;;54868-4425-00
 ;;9002226.02101,"1729,54868-4425-00 ",.02)
 ;;54868-4425-00
 ;;9002226.02101,"1729,54868-4425-01 ",.01)
 ;;54868-4425-01
 ;;9002226.02101,"1729,54868-4425-01 ",.02)
 ;;54868-4425-01
 ;;9002226.02101,"1729,54868-4425-02 ",.01)
 ;;54868-4425-02
 ;;9002226.02101,"1729,54868-4425-02 ",.02)
 ;;54868-4425-02
 ;;9002226.02101,"1729,54868-4425-03 ",.01)
 ;;54868-4425-03
 ;;9002226.02101,"1729,54868-4425-03 ",.02)
 ;;54868-4425-03
 ;;9002226.02101,"1729,54868-4428-00 ",.01)
 ;;54868-4428-00
 ;;9002226.02101,"1729,54868-4428-00 ",.02)
 ;;54868-4428-00
 ;;9002226.02101,"1729,54868-4428-01 ",.01)
 ;;54868-4428-01
 ;;9002226.02101,"1729,54868-4428-01 ",.02)
 ;;54868-4428-01
 ;;9002226.02101,"1729,54868-4428-02 ",.01)
 ;;54868-4428-02
 ;;9002226.02101,"1729,54868-4428-02 ",.02)
 ;;54868-4428-02
 ;;9002226.02101,"1729,54868-4428-03 ",.01)
 ;;54868-4428-03
 ;;9002226.02101,"1729,54868-4428-03 ",.02)
 ;;54868-4428-03
 ;;9002226.02101,"1729,54868-4479-00 ",.01)
 ;;54868-4479-00
 ;;9002226.02101,"1729,54868-4479-00 ",.02)
 ;;54868-4479-00
 ;;9002226.02101,"1729,54868-4479-01 ",.01)
 ;;54868-4479-01
 ;;9002226.02101,"1729,54868-4479-01 ",.02)
 ;;54868-4479-01
 ;;9002226.02101,"1729,54868-4479-02 ",.01)
 ;;54868-4479-02
 ;;9002226.02101,"1729,54868-4479-02 ",.02)
 ;;54868-4479-02
 ;;9002226.02101,"1729,54868-4494-00 ",.01)
 ;;54868-4494-00
 ;;9002226.02101,"1729,54868-4494-00 ",.02)
 ;;54868-4494-00
 ;;9002226.02101,"1729,54868-4526-00 ",.01)
 ;;54868-4526-00
 ;;9002226.02101,"1729,54868-4526-00 ",.02)
 ;;54868-4526-00
 ;;9002226.02101,"1729,54868-4526-01 ",.01)
 ;;54868-4526-01
 ;;9002226.02101,"1729,54868-4526-01 ",.02)
 ;;54868-4526-01
 ;;9002226.02101,"1729,54868-4539-00 ",.01)
 ;;54868-4539-00
 ;;9002226.02101,"1729,54868-4539-00 ",.02)
 ;;54868-4539-00
 ;;9002226.02101,"1729,54868-4539-01 ",.01)
 ;;54868-4539-01
 ;;9002226.02101,"1729,54868-4539-01 ",.02)
 ;;54868-4539-01
 ;;9002226.02101,"1729,54868-4540-00 ",.01)
 ;;54868-4540-00
 ;;9002226.02101,"1729,54868-4540-00 ",.02)
 ;;54868-4540-00
 ;;9002226.02101,"1729,54868-4540-01 ",.01)
 ;;54868-4540-01
 ;;9002226.02101,"1729,54868-4540-01 ",.02)
 ;;54868-4540-01
 ;;9002226.02101,"1729,54868-4540-02 ",.01)
 ;;54868-4540-02
 ;;9002226.02101,"1729,54868-4540-02 ",.02)
 ;;54868-4540-02
 ;;9002226.02101,"1729,54868-4552-00 ",.01)
 ;;54868-4552-00
 ;;9002226.02101,"1729,54868-4552-00 ",.02)
 ;;54868-4552-00
 ;;9002226.02101,"1729,54868-4552-01 ",.01)
 ;;54868-4552-01
 ;;9002226.02101,"1729,54868-4552-01 ",.02)
 ;;54868-4552-01
 ;;9002226.02101,"1729,54868-4555-00 ",.01)
 ;;54868-4555-00
 ;;9002226.02101,"1729,54868-4555-00 ",.02)
 ;;54868-4555-00
 ;;9002226.02101,"1729,54868-4555-01 ",.01)
 ;;54868-4555-01
 ;;9002226.02101,"1729,54868-4555-01 ",.02)
 ;;54868-4555-01
 ;;9002226.02101,"1729,54868-4605-00 ",.01)
 ;;54868-4605-00
 ;;9002226.02101,"1729,54868-4605-00 ",.02)
 ;;54868-4605-00
 ;;9002226.02101,"1729,54868-4605-01 ",.01)
 ;;54868-4605-01
 ;;9002226.02101,"1729,54868-4605-01 ",.02)
 ;;54868-4605-01
 ;;9002226.02101,"1729,54868-4605-02 ",.01)
 ;;54868-4605-02
 ;;9002226.02101,"1729,54868-4605-02 ",.02)
 ;;54868-4605-02
 ;;9002226.02101,"1729,54868-4612-00 ",.01)
 ;;54868-4612-00
 ;;9002226.02101,"1729,54868-4612-00 ",.02)
 ;;54868-4612-00
 ;;9002226.02101,"1729,54868-4637-00 ",.01)
 ;;54868-4637-00
 ;;9002226.02101,"1729,54868-4637-00 ",.02)
 ;;54868-4637-00
 ;;9002226.02101,"1729,54868-4637-01 ",.01)
 ;;54868-4637-01
 ;;9002226.02101,"1729,54868-4637-01 ",.02)
 ;;54868-4637-01
 ;;9002226.02101,"1729,54868-4637-02 ",.01)
 ;;54868-4637-02
 ;;9002226.02101,"1729,54868-4637-02 ",.02)
 ;;54868-4637-02
 ;;9002226.02101,"1729,54868-4637-03 ",.01)
 ;;54868-4637-03
 ;;9002226.02101,"1729,54868-4637-03 ",.02)
 ;;54868-4637-03
 ;;9002226.02101,"1729,54868-4637-04 ",.01)
 ;;54868-4637-04
 ;;9002226.02101,"1729,54868-4637-04 ",.02)
 ;;54868-4637-04
 ;;9002226.02101,"1729,54868-4645-00 ",.01)
 ;;54868-4645-00
 ;;9002226.02101,"1729,54868-4645-00 ",.02)
 ;;54868-4645-00
 ;;9002226.02101,"1729,54868-4645-01 ",.01)
 ;;54868-4645-01
 ;;9002226.02101,"1729,54868-4645-01 ",.02)
 ;;54868-4645-01
 ;;9002226.02101,"1729,54868-4645-02 ",.01)
 ;;54868-4645-02
 ;;9002226.02101,"1729,54868-4645-02 ",.02)
 ;;54868-4645-02
 ;;9002226.02101,"1729,54868-4645-03 ",.01)
 ;;54868-4645-03
 ;;9002226.02101,"1729,54868-4645-03 ",.02)
 ;;54868-4645-03
 ;;9002226.02101,"1729,54868-4646-00 ",.01)
 ;;54868-4646-00
 ;;9002226.02101,"1729,54868-4646-00 ",.02)
 ;;54868-4646-00
 ;;9002226.02101,"1729,54868-4646-02 ",.01)
 ;;54868-4646-02
 ;;9002226.02101,"1729,54868-4646-02 ",.02)
 ;;54868-4646-02
 ;;9002226.02101,"1729,54868-4646-03 ",.01)
 ;;54868-4646-03
 ;;9002226.02101,"1729,54868-4646-03 ",.02)
 ;;54868-4646-03
 ;;9002226.02101,"1729,54868-4646-04 ",.01)
 ;;54868-4646-04
 ;;9002226.02101,"1729,54868-4646-04 ",.02)
 ;;54868-4646-04
 ;;9002226.02101,"1729,54868-4646-05 ",.01)
 ;;54868-4646-05
 ;;9002226.02101,"1729,54868-4646-05 ",.02)
 ;;54868-4646-05
 ;;9002226.02101,"1729,54868-4652-00 ",.01)
 ;;54868-4652-00
 ;;9002226.02101,"1729,54868-4652-00 ",.02)
 ;;54868-4652-00
 ;;9002226.02101,"1729,54868-4652-01 ",.01)
 ;;54868-4652-01
 ;;9002226.02101,"1729,54868-4652-01 ",.02)
 ;;54868-4652-01
 ;;9002226.02101,"1729,54868-4652-02 ",.01)
 ;;54868-4652-02
 ;;9002226.02101,"1729,54868-4652-02 ",.02)
 ;;54868-4652-02
 ;;9002226.02101,"1729,54868-4652-03 ",.01)
 ;;54868-4652-03
 ;;9002226.02101,"1729,54868-4652-03 ",.02)
 ;;54868-4652-03
 ;;9002226.02101,"1729,54868-4652-04 ",.01)
 ;;54868-4652-04
 ;;9002226.02101,"1729,54868-4652-04 ",.02)
 ;;54868-4652-04
 ;;9002226.02101,"1729,54868-4652-05 ",.01)
 ;;54868-4652-05
 ;;9002226.02101,"1729,54868-4652-05 ",.02)
 ;;54868-4652-05
 ;;9002226.02101,"1729,54868-4656-00 ",.01)
 ;;54868-4656-00
 ;;9002226.02101,"1729,54868-4656-00 ",.02)
 ;;54868-4656-00
 ;;9002226.02101,"1729,54868-4656-01 ",.01)
 ;;54868-4656-01
 ;;9002226.02101,"1729,54868-4656-01 ",.02)
 ;;54868-4656-01
 ;;9002226.02101,"1729,54868-4656-02 ",.01)
 ;;54868-4656-02
 ;;9002226.02101,"1729,54868-4656-02 ",.02)
 ;;54868-4656-02
 ;;9002226.02101,"1729,54868-4656-03 ",.01)
 ;;54868-4656-03
 ;;9002226.02101,"1729,54868-4656-03 ",.02)
 ;;54868-4656-03
 ;;9002226.02101,"1729,54868-4657-00 ",.01)
 ;;54868-4657-00
 ;;9002226.02101,"1729,54868-4657-00 ",.02)
 ;;54868-4657-00
 ;;9002226.02101,"1729,54868-4657-01 ",.01)
 ;;54868-4657-01
 ;;9002226.02101,"1729,54868-4657-01 ",.02)
 ;;54868-4657-01
 ;;9002226.02101,"1729,54868-4657-02 ",.01)
 ;;54868-4657-02
 ;;9002226.02101,"1729,54868-4657-02 ",.02)
 ;;54868-4657-02
 ;;9002226.02101,"1729,54868-4657-03 ",.01)
 ;;54868-4657-03
 ;;9002226.02101,"1729,54868-4657-03 ",.02)
 ;;54868-4657-03
 ;;9002226.02101,"1729,54868-4657-04 ",.01)
 ;;54868-4657-04
 ;;9002226.02101,"1729,54868-4657-04 ",.02)
 ;;54868-4657-04
 ;;9002226.02101,"1729,54868-4657-05 ",.01)
 ;;54868-4657-05
 ;;9002226.02101,"1729,54868-4657-05 ",.02)
 ;;54868-4657-05
