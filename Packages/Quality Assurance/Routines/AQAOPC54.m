AQAOPC54 ; IHS/ORDC/LJF - PRINT PROGRESS REPORT-ACTIONS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtns does the actual printing of the action plans for the
 ;quarterly progress report.  There are 2 entry points, one for
 ;hard-copy prints and one for ASCII-format captures.
 ;
ACTION ;ENTRY POINT from ^AQAOPC52 hard copy print
 W !!,"Action #",?13,"Plan Status",?43,"Implemented",?56,"Reviewed"
 W ?67,"Closed",!,AQAOLIN2
 S AQAOAC=0
 F  S AQAOAC=$O(^TMP("AQAOPC5B",$J,AQAOIND,AQAOAC)) Q:AQAOAC=""  Q:AQAOSTOP=U  D
 .K ^UTILITY("DIQ1",$J) S DIC="^AQAO(5,",DR=".01:.06;.15",DA=AQAOAC
 .S DIQ(0)="IE" D EN^DIQ1
 .W !,^UTILITY("DIQ1",$J,9002168.5,AQAOAC,.01,"E") ;plan id #
 .W ?13,$E(^UTILITY("DIQ1",$J,9002168.5,AQAOAC,.05,"E"),1,30) ;status
 .W ?44 S X=^UTILITY("DIQ1",$J,9002168.5,AQAOAC,.03,"I") I X>0 D
 ..W $J($$FMTE^XLFDT(X,"2D"),8) ;implementation date
 .W ?56 S X=^UTILITY("DIQ1",$J,9002168.5,AQAOAC,.04,"I") I X>0 D
 ..W $J($$FMTE^XLFDT(X,"2D"),8) ;proposed review date
 .W ?68 S X=^UTILITY("DIQ1",$J,9002168.5,AQAOAC,.06,"I") I X>0 D
 ..W $J($$FMTE^XLFDT(X,"2D"),8) ;date plan closed
 .W !?1,"Action Type:  ",^UTILITY("DIQ1",$J,9002168.5,AQAOAC,.02,"E")
 .W !?3,"Next Step:  ",^UTILITY("DIQ1",$J,9002168.5,AQAOAC,.15,"E")
 .W ! K ^UTILITY("DIQ1",$J)
 Q
 ;
 ;
ACTDLM ;ENTRY POINT from ^AQAOPC53 ASCII capture print
 W !!
 F I="Action #","Plan Status","Implemented","Reviewed","Closed" W I,AQAODLM
 W ! S AQAOAC=0
 F  S AQAOAC=$O(^TMP("AQAOPC5B",$J,AQAOIND,AQAOAC)) Q:AQAOAC=""  Q:AQAOSTOP=U  D
 .Q:'$D(^AQAO(5,AQAOAC,0))  S AQAOSTR=^(0)
 .W !,$P(AQAOSTR,U),AQAODLM ;action #
 .S Y=$P(AQAOSTR,U,5),C=$P(^DD(9002168.5,.05,0),U,2) D Y^DIQ W Y,AQAODLM
 .S Y=$P(AQAOSTR,U,3),C=$P(^DD(9002168.5,.03,0),U,2) D Y^DIQ W Y,AQAODLM
 .S Y=$P(AQAOSTR,U,4),C=$P(^DD(9002168.5,.04,0),U,2) D Y^DIQ W Y,AQAODLM
 .S Y=$P(AQAOSTR,U,6),C=$P(^DD(9002168.5,.06,0),U,2) D Y^DIQ W Y,AQAODLM
 .S Y=$P(AQAOSTR,U,2),C=$P(^DD(9002168.5,.02,0),U,2) D Y^DIQ W Y,AQAODLM
 .S Y=$P(AQAOSTR,U,15),C=$P(^DD(9002168.5,.15,0),U,2) D Y^DIQ W Y
 Q
