BGP44I15 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON SEP 06, 2013;
 ;;14.0;IHS CLINICAL REPORTING;;NOV 14, 2013;Build 101
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1788,47463-0246-30 ",.02)
 ;;47463-0246-30
 ;;9002226.02101,"1788,47463-0247-30 ",.01)
 ;;47463-0247-30
 ;;9002226.02101,"1788,47463-0247-30 ",.02)
 ;;47463-0247-30
 ;;9002226.02101,"1788,47463-0248-90 ",.01)
 ;;47463-0248-90
 ;;9002226.02101,"1788,47463-0248-90 ",.02)
 ;;47463-0248-90
 ;;9002226.02101,"1788,47463-0434-60 ",.01)
 ;;47463-0434-60
 ;;9002226.02101,"1788,47463-0434-60 ",.02)
 ;;47463-0434-60
 ;;9002226.02101,"1788,47463-0435-60 ",.01)
 ;;47463-0435-60
 ;;9002226.02101,"1788,47463-0435-60 ",.02)
 ;;47463-0435-60
 ;;9002226.02101,"1788,47463-0508-30 ",.01)
 ;;47463-0508-30
 ;;9002226.02101,"1788,47463-0508-30 ",.02)
 ;;47463-0508-30
 ;;9002226.02101,"1788,47463-0509-30 ",.01)
 ;;47463-0509-30
 ;;9002226.02101,"1788,47463-0509-30 ",.02)
 ;;47463-0509-30
 ;;9002226.02101,"1788,47463-0509-60 ",.01)
 ;;47463-0509-60
 ;;9002226.02101,"1788,47463-0509-60 ",.02)
 ;;47463-0509-60
 ;;9002226.02101,"1788,47463-0509-74 ",.01)
 ;;47463-0509-74
 ;;9002226.02101,"1788,47463-0509-74 ",.02)
 ;;47463-0509-74
 ;;9002226.02101,"1788,47463-0509-90 ",.01)
 ;;47463-0509-90
 ;;9002226.02101,"1788,47463-0509-90 ",.02)
 ;;47463-0509-90
 ;;9002226.02101,"1788,47463-0510-30 ",.01)
 ;;47463-0510-30
 ;;9002226.02101,"1788,47463-0510-30 ",.02)
 ;;47463-0510-30
 ;;9002226.02101,"1788,47463-0510-60 ",.01)
 ;;47463-0510-60
 ;;9002226.02101,"1788,47463-0510-60 ",.02)
 ;;47463-0510-60
 ;;9002226.02101,"1788,47463-0510-71 ",.01)
 ;;47463-0510-71
 ;;9002226.02101,"1788,47463-0510-71 ",.02)
 ;;47463-0510-71
 ;;9002226.02101,"1788,47463-0510-74 ",.01)
 ;;47463-0510-74
 ;;9002226.02101,"1788,47463-0510-74 ",.02)
 ;;47463-0510-74
 ;;9002226.02101,"1788,47463-0510-90 ",.01)
 ;;47463-0510-90
 ;;9002226.02101,"1788,47463-0510-90 ",.02)
 ;;47463-0510-90
 ;;9002226.02101,"1788,47463-0583-30 ",.01)
 ;;47463-0583-30
 ;;9002226.02101,"1788,47463-0583-30 ",.02)
 ;;47463-0583-30
 ;;9002226.02101,"1788,47463-0584-30 ",.01)
 ;;47463-0584-30
 ;;9002226.02101,"1788,47463-0584-30 ",.02)
 ;;47463-0584-30
 ;;9002226.02101,"1788,47463-0585-30 ",.01)
 ;;47463-0585-30
 ;;9002226.02101,"1788,47463-0585-30 ",.02)
 ;;47463-0585-30
 ;;9002226.02101,"1788,47463-0611-60 ",.01)
 ;;47463-0611-60
 ;;9002226.02101,"1788,47463-0611-60 ",.02)
 ;;47463-0611-60
 ;;9002226.02101,"1788,47463-0611-74 ",.01)
 ;;47463-0611-74
 ;;9002226.02101,"1788,47463-0611-74 ",.02)
 ;;47463-0611-74
 ;;9002226.02101,"1788,47463-0612-30 ",.01)
 ;;47463-0612-30
 ;;9002226.02101,"1788,47463-0612-30 ",.02)
 ;;47463-0612-30
 ;;9002226.02101,"1788,47463-0764-60 ",.01)
 ;;47463-0764-60
 ;;9002226.02101,"1788,47463-0764-60 ",.02)
 ;;47463-0764-60
 ;;9002226.02101,"1788,47463-0765-30 ",.01)
 ;;47463-0765-30
 ;;9002226.02101,"1788,47463-0765-30 ",.02)
 ;;47463-0765-30
 ;;9002226.02101,"1788,47463-0766-30 ",.01)
 ;;47463-0766-30
 ;;9002226.02101,"1788,47463-0766-30 ",.02)
 ;;47463-0766-30
 ;;9002226.02101,"1788,47463-0777-30 ",.01)
 ;;47463-0777-30
 ;;9002226.02101,"1788,47463-0777-30 ",.02)
 ;;47463-0777-30
 ;;9002226.02101,"1788,49884-0984-01 ",.01)
 ;;49884-0984-01
 ;;9002226.02101,"1788,49884-0984-01 ",.02)
 ;;49884-0984-01
 ;;9002226.02101,"1788,49884-0985-01 ",.01)
 ;;49884-0985-01
 ;;9002226.02101,"1788,49884-0985-01 ",.02)
 ;;49884-0985-01
 ;;9002226.02101,"1788,49999-0106-00 ",.01)
 ;;49999-0106-00
 ;;9002226.02101,"1788,49999-0106-00 ",.02)
 ;;49999-0106-00
 ;;9002226.02101,"1788,49999-0106-01 ",.01)
 ;;49999-0106-01
 ;;9002226.02101,"1788,49999-0106-01 ",.02)
 ;;49999-0106-01
 ;;9002226.02101,"1788,49999-0106-28 ",.01)
 ;;49999-0106-28
 ;;9002226.02101,"1788,49999-0106-28 ",.02)
 ;;49999-0106-28
 ;;9002226.02101,"1788,49999-0106-30 ",.01)
 ;;49999-0106-30
 ;;9002226.02101,"1788,49999-0106-30 ",.02)
 ;;49999-0106-30
 ;;9002226.02101,"1788,49999-0106-60 ",.01)
 ;;49999-0106-60
 ;;9002226.02101,"1788,49999-0106-60 ",.02)
 ;;49999-0106-60
 ;;9002226.02101,"1788,49999-0106-90 ",.01)
 ;;49999-0106-90
 ;;9002226.02101,"1788,49999-0106-90 ",.02)
 ;;49999-0106-90
 ;;9002226.02101,"1788,49999-0107-00 ",.01)
 ;;49999-0107-00
 ;;9002226.02101,"1788,49999-0107-00 ",.02)
 ;;49999-0107-00
 ;;9002226.02101,"1788,49999-0107-20 ",.01)
 ;;49999-0107-20
 ;;9002226.02101,"1788,49999-0107-20 ",.02)
 ;;49999-0107-20
 ;;9002226.02101,"1788,49999-0107-30 ",.01)
 ;;49999-0107-30
 ;;9002226.02101,"1788,49999-0107-30 ",.02)
 ;;49999-0107-30
 ;;9002226.02101,"1788,49999-0107-60 ",.01)
 ;;49999-0107-60
 ;;9002226.02101,"1788,49999-0107-60 ",.02)
 ;;49999-0107-60
 ;;9002226.02101,"1788,49999-0107-90 ",.01)
 ;;49999-0107-90
 ;;9002226.02101,"1788,49999-0107-90 ",.02)
 ;;49999-0107-90
 ;;9002226.02101,"1788,49999-0108-00 ",.01)
 ;;49999-0108-00
 ;;9002226.02101,"1788,49999-0108-00 ",.02)
 ;;49999-0108-00
 ;;9002226.02101,"1788,49999-0108-30 ",.01)
 ;;49999-0108-30
 ;;9002226.02101,"1788,49999-0108-30 ",.02)
 ;;49999-0108-30
 ;;9002226.02101,"1788,49999-0108-60 ",.01)
 ;;49999-0108-60
 ;;9002226.02101,"1788,49999-0108-60 ",.02)
 ;;49999-0108-60
 ;;9002226.02101,"1788,49999-0108-90 ",.01)
 ;;49999-0108-90
 ;;9002226.02101,"1788,49999-0108-90 ",.02)
 ;;49999-0108-90
 ;;9002226.02101,"1788,49999-0113-00 ",.01)
 ;;49999-0113-00
 ;;9002226.02101,"1788,49999-0113-00 ",.02)
 ;;49999-0113-00
 ;;9002226.02101,"1788,49999-0113-01 ",.01)
 ;;49999-0113-01
 ;;9002226.02101,"1788,49999-0113-01 ",.02)
 ;;49999-0113-01
 ;;9002226.02101,"1788,49999-0113-30 ",.01)
 ;;49999-0113-30
 ;;9002226.02101,"1788,49999-0113-30 ",.02)
 ;;49999-0113-30
 ;;9002226.02101,"1788,49999-0113-60 ",.01)
 ;;49999-0113-60
 ;;9002226.02101,"1788,49999-0113-60 ",.02)
 ;;49999-0113-60
 ;;9002226.02101,"1788,49999-0113-90 ",.01)
 ;;49999-0113-90
 ;;9002226.02101,"1788,49999-0113-90 ",.02)
 ;;49999-0113-90
 ;;9002226.02101,"1788,49999-0116-00 ",.01)
 ;;49999-0116-00
 ;;9002226.02101,"1788,49999-0116-00 ",.02)
 ;;49999-0116-00
 ;;9002226.02101,"1788,49999-0116-30 ",.01)
 ;;49999-0116-30
 ;;9002226.02101,"1788,49999-0116-30 ",.02)
 ;;49999-0116-30
 ;;9002226.02101,"1788,49999-0116-60 ",.01)
 ;;49999-0116-60
 ;;9002226.02101,"1788,49999-0116-60 ",.02)
 ;;49999-0116-60
 ;;9002226.02101,"1788,49999-0304-30 ",.01)
 ;;49999-0304-30
 ;;9002226.02101,"1788,49999-0304-30 ",.02)
 ;;49999-0304-30
 ;;9002226.02101,"1788,49999-0401-30 ",.01)
 ;;49999-0401-30
 ;;9002226.02101,"1788,49999-0401-30 ",.02)
 ;;49999-0401-30
 ;;9002226.02101,"1788,49999-0401-60 ",.01)
 ;;49999-0401-60
 ;;9002226.02101,"1788,49999-0401-60 ",.02)
 ;;49999-0401-60
 ;;9002226.02101,"1788,49999-0401-90 ",.01)
 ;;49999-0401-90
 ;;9002226.02101,"1788,49999-0401-90 ",.02)
 ;;49999-0401-90
 ;;9002226.02101,"1788,49999-0449-15 ",.01)
 ;;49999-0449-15
 ;;9002226.02101,"1788,49999-0449-15 ",.02)
 ;;49999-0449-15
 ;;9002226.02101,"1788,49999-0449-30 ",.01)
 ;;49999-0449-30
 ;;9002226.02101,"1788,49999-0449-30 ",.02)
 ;;49999-0449-30
 ;;9002226.02101,"1788,49999-0450-30 ",.01)
 ;;49999-0450-30
 ;;9002226.02101,"1788,49999-0450-30 ",.02)
 ;;49999-0450-30
 ;;9002226.02101,"1788,49999-0451-30 ",.01)
 ;;49999-0451-30
 ;;9002226.02101,"1788,49999-0451-30 ",.02)
 ;;49999-0451-30
 ;;9002226.02101,"1788,49999-0451-90 ",.01)
 ;;49999-0451-90
 ;;9002226.02101,"1788,49999-0451-90 ",.02)
 ;;49999-0451-90
 ;;9002226.02101,"1788,49999-0495-30 ",.01)
 ;;49999-0495-30
 ;;9002226.02101,"1788,49999-0495-30 ",.02)
 ;;49999-0495-30
 ;;9002226.02101,"1788,49999-0495-60 ",.01)
 ;;49999-0495-60
 ;;9002226.02101,"1788,49999-0495-60 ",.02)
 ;;49999-0495-60
 ;;9002226.02101,"1788,49999-0514-30 ",.01)
 ;;49999-0514-30
 ;;9002226.02101,"1788,49999-0514-30 ",.02)
 ;;49999-0514-30
 ;;9002226.02101,"1788,49999-0571-60 ",.01)
 ;;49999-0571-60
 ;;9002226.02101,"1788,49999-0571-60 ",.02)
 ;;49999-0571-60
 ;;9002226.02101,"1788,49999-0660-30 ",.01)
 ;;49999-0660-30
 ;;9002226.02101,"1788,49999-0660-30 ",.02)
 ;;49999-0660-30
 ;;9002226.02101,"1788,49999-0660-60 ",.01)
 ;;49999-0660-60
 ;;9002226.02101,"1788,49999-0660-60 ",.02)
 ;;49999-0660-60
 ;;9002226.02101,"1788,49999-0781-00 ",.01)
 ;;49999-0781-00
 ;;9002226.02101,"1788,49999-0781-00 ",.02)
 ;;49999-0781-00
 ;;9002226.02101,"1788,49999-0781-30 ",.01)
 ;;49999-0781-30
 ;;9002226.02101,"1788,49999-0781-30 ",.02)
 ;;49999-0781-30
 ;;9002226.02101,"1788,49999-0781-60 ",.01)
 ;;49999-0781-60
 ;;9002226.02101,"1788,49999-0781-60 ",.02)
 ;;49999-0781-60
 ;;9002226.02101,"1788,49999-0807-00 ",.01)
 ;;49999-0807-00
 ;;9002226.02101,"1788,49999-0807-00 ",.02)
 ;;49999-0807-00
 ;;9002226.02101,"1788,49999-0807-30 ",.01)
 ;;49999-0807-30
 ;;9002226.02101,"1788,49999-0807-30 ",.02)
 ;;49999-0807-30
 ;;9002226.02101,"1788,49999-0807-60 ",.01)
 ;;49999-0807-60
 ;;9002226.02101,"1788,49999-0807-60 ",.02)
 ;;49999-0807-60
 ;;9002226.02101,"1788,49999-0807-90 ",.01)
 ;;49999-0807-90
 ;;9002226.02101,"1788,49999-0807-90 ",.02)
 ;;49999-0807-90
 ;;9002226.02101,"1788,49999-0808-00 ",.01)
 ;;49999-0808-00
 ;;9002226.02101,"1788,49999-0808-00 ",.02)
 ;;49999-0808-00
 ;;9002226.02101,"1788,49999-0820-60 ",.01)
 ;;49999-0820-60
 ;;9002226.02101,"1788,49999-0820-60 ",.02)
 ;;49999-0820-60
 ;;9002226.02101,"1788,49999-0935-30 ",.01)
 ;;49999-0935-30
 ;;9002226.02101,"1788,49999-0935-30 ",.02)
 ;;49999-0935-30
 ;;9002226.02101,"1788,50268-0531-15 ",.01)
 ;;50268-0531-15
 ;;9002226.02101,"1788,50268-0531-15 ",.02)
 ;;50268-0531-15
 ;;9002226.02101,"1788,51079-0172-01 ",.01)
 ;;51079-0172-01
 ;;9002226.02101,"1788,51079-0172-01 ",.02)
 ;;51079-0172-01
 ;;9002226.02101,"1788,51079-0172-20 ",.01)
 ;;51079-0172-20
 ;;9002226.02101,"1788,51079-0172-20 ",.02)
 ;;51079-0172-20
 ;;9002226.02101,"1788,51079-0173-01 ",.01)
 ;;51079-0173-01
 ;;9002226.02101,"1788,51079-0173-01 ",.02)
 ;;51079-0173-01
 ;;9002226.02101,"1788,51079-0173-08 ",.01)
 ;;51079-0173-08
 ;;9002226.02101,"1788,51079-0173-08 ",.02)
 ;;51079-0173-08
 ;;9002226.02101,"1788,51079-0174-01 ",.01)
 ;;51079-0174-01
 ;;9002226.02101,"1788,51079-0174-01 ",.02)
 ;;51079-0174-01
 ;;9002226.02101,"1788,51079-0174-20 ",.01)
 ;;51079-0174-20
 ;;9002226.02101,"1788,51079-0174-20 ",.02)
 ;;51079-0174-20
 ;;9002226.02101,"1788,51079-0425-01 ",.01)
 ;;51079-0425-01
 ;;9002226.02101,"1788,51079-0425-01 ",.02)
 ;;51079-0425-01
 ;;9002226.02101,"1788,51079-0425-20 ",.01)
 ;;51079-0425-20
 ;;9002226.02101,"1788,51079-0425-20 ",.02)
 ;;51079-0425-20
 ;;9002226.02101,"1788,51079-0426-01 ",.01)
 ;;51079-0426-01
 ;;9002226.02101,"1788,51079-0426-01 ",.02)
 ;;51079-0426-01
 ;;9002226.02101,"1788,51079-0426-20 ",.01)
 ;;51079-0426-20
 ;;9002226.02101,"1788,51079-0426-20 ",.02)
 ;;51079-0426-20
 ;;9002226.02101,"1788,51079-0513-01 ",.01)
 ;;51079-0513-01
 ;;9002226.02101,"1788,51079-0513-01 ",.02)
 ;;51079-0513-01
 ;;9002226.02101,"1788,51079-0513-20 ",.01)
 ;;51079-0513-20
 ;;9002226.02101,"1788,51079-0513-20 ",.02)
 ;;51079-0513-20
 ;;9002226.02101,"1788,51079-0514-01 ",.01)
 ;;51079-0514-01
 ;;9002226.02101,"1788,51079-0514-01 ",.02)
 ;;51079-0514-01
 ;;9002226.02101,"1788,51079-0514-20 ",.01)
 ;;51079-0514-20
 ;;9002226.02101,"1788,51079-0514-20 ",.02)
 ;;51079-0514-20
 ;;9002226.02101,"1788,51079-0515-01 ",.01)
 ;;51079-0515-01
 ;;9002226.02101,"1788,51079-0515-01 ",.02)
 ;;51079-0515-01
 ;;9002226.02101,"1788,51079-0515-20 ",.01)
 ;;51079-0515-20
 ;;9002226.02101,"1788,51079-0515-20 ",.02)
 ;;51079-0515-20
 ;;9002226.02101,"1788,51079-0810-01 ",.01)
 ;;51079-0810-01
 ;;9002226.02101,"1788,51079-0810-01 ",.02)
 ;;51079-0810-01
 ;;9002226.02101,"1788,51079-0810-17 ",.01)
 ;;51079-0810-17
 ;;9002226.02101,"1788,51079-0810-17 ",.02)
 ;;51079-0810-17
 ;;9002226.02101,"1788,51079-0810-19 ",.01)
 ;;51079-0810-19
 ;;9002226.02101,"1788,51079-0810-19 ",.02)
 ;;51079-0810-19
 ;;9002226.02101,"1788,51079-0810-20 ",.01)
 ;;51079-0810-20
 ;;9002226.02101,"1788,51079-0810-20 ",.02)
 ;;51079-0810-20
 ;;9002226.02101,"1788,51079-0811-01 ",.01)
 ;;51079-0811-01
 ;;9002226.02101,"1788,51079-0811-01 ",.02)
 ;;51079-0811-01
 ;;9002226.02101,"1788,51079-0811-17 ",.01)
 ;;51079-0811-17
 ;;9002226.02101,"1788,51079-0811-17 ",.02)
 ;;51079-0811-17
 ;;9002226.02101,"1788,51079-0811-19 ",.01)
 ;;51079-0811-19
 ;;9002226.02101,"1788,51079-0811-19 ",.02)
 ;;51079-0811-19
 ;;9002226.02101,"1788,51079-0811-20 ",.01)
 ;;51079-0811-20
 ;;9002226.02101,"1788,51079-0811-20 ",.02)
 ;;51079-0811-20
 ;;9002226.02101,"1788,51079-0872-01 ",.01)
 ;;51079-0872-01
 ;;9002226.02101,"1788,51079-0872-01 ",.02)
 ;;51079-0872-01
 ;;9002226.02101,"1788,51079-0872-20 ",.01)
 ;;51079-0872-20
 ;;9002226.02101,"1788,51079-0872-20 ",.02)
 ;;51079-0872-20
 ;;9002226.02101,"1788,51079-0873-01 ",.01)
 ;;51079-0873-01
 ;;9002226.02101,"1788,51079-0873-01 ",.02)
 ;;51079-0873-01
 ;;9002226.02101,"1788,51079-0873-17 ",.01)
 ;;51079-0873-17
 ;;9002226.02101,"1788,51079-0873-17 ",.02)
 ;;51079-0873-17
 ;;9002226.02101,"1788,51079-0873-19 ",.01)
 ;;51079-0873-19
 ;;9002226.02101,"1788,51079-0873-19 ",.02)
 ;;51079-0873-19
 ;;9002226.02101,"1788,51079-0873-20 ",.01)
 ;;51079-0873-20
 ;;9002226.02101,"1788,51079-0873-20 ",.02)
 ;;51079-0873-20
 ;;9002226.02101,"1788,51079-0972-01 ",.01)
 ;;51079-0972-01
 ;;9002226.02101,"1788,51079-0972-01 ",.02)
 ;;51079-0972-01
 ;;9002226.02101,"1788,51079-0972-17 ",.01)
 ;;51079-0972-17
 ;;9002226.02101,"1788,51079-0972-17 ",.02)
 ;;51079-0972-17
 ;;9002226.02101,"1788,51079-0972-19 ",.01)
 ;;51079-0972-19
 ;;9002226.02101,"1788,51079-0972-19 ",.02)
 ;;51079-0972-19
 ;;9002226.02101,"1788,51079-0972-20 ",.01)
 ;;51079-0972-20
 ;;9002226.02101,"1788,51079-0972-20 ",.02)
 ;;51079-0972-20