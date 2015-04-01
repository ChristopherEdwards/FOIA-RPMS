BGP51I5 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 19, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"726,66116-0430-30 ",.02)
 ;;66116-0430-30
 ;;9002226.02101,"726,66267-0078-30 ",.01)
 ;;66267-0078-30
 ;;9002226.02101,"726,66267-0078-30 ",.02)
 ;;66267-0078-30
 ;;9002226.02101,"726,66267-0401-10 ",.01)
 ;;66267-0401-10
 ;;9002226.02101,"726,66267-0401-10 ",.02)
 ;;66267-0401-10
 ;;9002226.02101,"726,66267-0443-30 ",.01)
 ;;66267-0443-30
 ;;9002226.02101,"726,66267-0443-30 ",.02)
 ;;66267-0443-30
 ;;9002226.02101,"726,66336-0140-60 ",.01)
 ;;66336-0140-60
 ;;9002226.02101,"726,66336-0140-60 ",.02)
 ;;66336-0140-60
 ;;9002226.02101,"726,66336-0374-30 ",.01)
 ;;66336-0374-30
 ;;9002226.02101,"726,66336-0374-30 ",.02)
 ;;66336-0374-30
 ;;9002226.02101,"726,66336-0459-60 ",.01)
 ;;66336-0459-60
 ;;9002226.02101,"726,66336-0459-60 ",.02)
 ;;66336-0459-60
 ;;9002226.02101,"726,66336-0607-30 ",.01)
 ;;66336-0607-30
 ;;9002226.02101,"726,66336-0607-30 ",.02)
 ;;66336-0607-30
 ;;9002226.02101,"726,67544-0090-30 ",.01)
 ;;67544-0090-30
 ;;9002226.02101,"726,67544-0090-30 ",.02)
 ;;67544-0090-30
 ;;9002226.02101,"726,67544-0090-60 ",.01)
 ;;67544-0090-60
 ;;9002226.02101,"726,67544-0090-60 ",.02)
 ;;67544-0090-60
 ;;9002226.02101,"726,67544-0091-30 ",.01)
 ;;67544-0091-30
 ;;9002226.02101,"726,67544-0091-30 ",.02)
 ;;67544-0091-30
 ;;9002226.02101,"726,67544-0091-60 ",.01)
 ;;67544-0091-60
 ;;9002226.02101,"726,67544-0091-60 ",.02)
 ;;67544-0091-60
 ;;9002226.02101,"726,67544-0091-70 ",.01)
 ;;67544-0091-70
 ;;9002226.02101,"726,67544-0091-70 ",.02)
 ;;67544-0091-70
 ;;9002226.02101,"726,67544-0519-60 ",.01)
 ;;67544-0519-60
 ;;9002226.02101,"726,67544-0519-60 ",.02)
 ;;67544-0519-60
 ;;9002226.02101,"726,67544-0594-60 ",.01)
 ;;67544-0594-60
 ;;9002226.02101,"726,67544-0594-60 ",.02)
 ;;67544-0594-60
 ;;9002226.02101,"726,67544-0777-60 ",.01)
 ;;67544-0777-60
 ;;9002226.02101,"726,67544-0777-60 ",.02)
 ;;67544-0777-60
 ;;9002226.02101,"726,67544-0778-60 ",.01)
 ;;67544-0778-60
 ;;9002226.02101,"726,67544-0778-60 ",.02)
 ;;67544-0778-60
 ;;9002226.02101,"726,67857-0705-01 ",.01)
 ;;67857-0705-01
 ;;9002226.02101,"726,67857-0705-01 ",.02)
 ;;67857-0705-01
 ;;9002226.02101,"726,67857-0705-05 ",.01)
 ;;67857-0705-05
 ;;9002226.02101,"726,67857-0705-05 ",.02)
 ;;67857-0705-05
 ;;9002226.02101,"726,67857-0706-01 ",.01)
 ;;67857-0706-01
 ;;9002226.02101,"726,67857-0706-01 ",.02)
 ;;67857-0706-01
 ;;9002226.02101,"726,68084-0022-01 ",.01)
 ;;68084-0022-01
 ;;9002226.02101,"726,68084-0022-01 ",.02)
 ;;68084-0022-01
 ;;9002226.02101,"726,68084-0022-11 ",.01)
 ;;68084-0022-11
 ;;9002226.02101,"726,68084-0022-11 ",.02)
 ;;68084-0022-11
 ;;9002226.02101,"726,68084-0508-01 ",.01)
 ;;68084-0508-01
 ;;9002226.02101,"726,68084-0508-01 ",.02)
 ;;68084-0508-01
 ;;9002226.02101,"726,68084-0508-11 ",.01)
 ;;68084-0508-11
 ;;9002226.02101,"726,68084-0508-11 ",.02)
 ;;68084-0508-11
 ;;9002226.02101,"726,68084-0509-01 ",.01)
 ;;68084-0509-01
 ;;9002226.02101,"726,68084-0509-01 ",.02)
 ;;68084-0509-01
 ;;9002226.02101,"726,68084-0509-11 ",.01)
 ;;68084-0509-11
 ;;9002226.02101,"726,68084-0509-11 ",.02)
 ;;68084-0509-11
 ;;9002226.02101,"726,68084-0521-01 ",.01)
 ;;68084-0521-01
 ;;9002226.02101,"726,68084-0521-01 ",.02)
 ;;68084-0521-01
 ;;9002226.02101,"726,68084-0521-11 ",.01)
 ;;68084-0521-11
 ;;9002226.02101,"726,68084-0521-11 ",.02)
 ;;68084-0521-11
 ;;9002226.02101,"726,68084-0748-11 ",.01)
 ;;68084-0748-11
 ;;9002226.02101,"726,68084-0748-11 ",.02)
 ;;68084-0748-11
 ;;9002226.02101,"726,68084-0748-21 ",.01)
 ;;68084-0748-21
 ;;9002226.02101,"726,68084-0748-21 ",.02)
 ;;68084-0748-21
 ;;9002226.02101,"726,68094-0752-59 ",.01)
 ;;68094-0752-59
 ;;9002226.02101,"726,68094-0752-59 ",.02)
 ;;68094-0752-59
 ;;9002226.02101,"726,68094-0752-62 ",.01)
 ;;68094-0752-62
 ;;9002226.02101,"726,68094-0752-62 ",.02)
 ;;68094-0752-62