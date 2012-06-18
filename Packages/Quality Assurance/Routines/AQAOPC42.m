AQAOPC42 ; IHS/ORDC/LJF - OCC WITH FINDINGS/ACTIONS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn prints the trending report for occurrences with finding and
 ;action data, subtotaling each.
 ;
INIT ; >>> initialize variables
 D INIT^AQAOUTIL S AQAOHCON="Patient"
 S AQAOTY="OCCURRENCES WITH FINDINGS & ACTIONS"
 S AQAORG=$E(AQAOBD,4,5)_"/"_$E(AQAOBD,6,7)_"/"_$E(AQAOBD,2,3)_" to "
 S AQAORG=AQAORG_$E(AQAOED,4,5)_"/"_$E(AQAOED,6,7)_"/"_$E(AQAOED,2,3)
 K ^TMP("AQAO",$J)
 ;
MAIN ; >>> main calls
 I '$D(^TMP("AQAOPC4",$J)) D HEADING^AQAOUTIL,HDG1 W !!,"NO DATA FOUND FOR DATE RANGE SPECIFIED",!! G END
 D LISTING
 I AQAOSTOP'=U D SUMMARY^AQAOPC43
 ;
END ; >>> eoj
 I $D(AQAODLM) W !!,*7,"*** STOP CAPTURE NOW! ***",!
 D ^%ZISC I '$D(ZTQUEUED) D PRTOPT^AQAOVAR
 K ^TMP("AQAOPC4",$J),^TMP("AQAO",$J)
 D KILL^AQAOUTIL Q
 ;
 ;
LISTING ; >> SUBRTN to print occurrence listing if selected
 I $D(AQAODLM),AQAOTYPE="L" D DLMHDG I 1 ;print heading
 E  I AQAOTYPE="L" D HEADING^AQAOUTIL,HDG1
 ;
 S AQAOSUB=0  I '$D(AQAOXSN) D LIST2 Q  ;no spec sorts
 F  S AQAOSUB=$O(^TMP("AQAOPC4",$J,AQAOSUB)) Q:AQAOSUB=""  Q:AQAOSTOP=U  D LIST2 ;spec review sort
 Q
 ;
 ;
LIST2 ; >> SUBRTN for each AQAOSUB list occ with find/actions
 I AQAOSUB'=0 W:AQAOTYPE="L" !!?AQAOIOMX-$L(AQAOSUB)/2,AQAOSUB,!
 S AQAODT=0
 F  S AQAODT=$O(^TMP("AQAOPC4",$J,AQAOSUB,AQAODT)) Q:AQAODT=""  Q:AQAOSTOP=U  D
 .S AQAON=0
 .F  S AQAON=$O(^TMP("AQAOPC4",$J,AQAOSUB,AQAODT,AQAON)) Q:AQAON=""  Q:AQAOSTOP=U  D
 ..S AQAOSTR=$G(^AQAOC(AQAON,0)) ;basic occ data
 ..I AQAOTYPE="L" D
 ...I '$D(AQAODLM),($Y>(IOSL-2)) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG1
 ...S Y=AQAODT X ^DD("DD") I $D(AQAODLM) S Y=$P(Y,",")_" "_$P(Y,",",2)
 ...I $D(AQAODLM) W !,$P(AQAOSTR,U),AQAODLM,Y,AQAODLM ;case&date ASCII
 ...E  W !,$P(AQAOSTR,U),?9,Y ;print case & date
 ...K ^UTILITY("DIQ1",$J) S DIC="^AQAOC(",DA=AQAON,DR=".025" D EN^DIQ1
 ...W:'$D(AQAODLM) ?22
 ...W ^UTILITY("DIQ1",$J,9002167,AQAON,.025) ;age at time of occ
 ...W:$D(AQAODLM) AQAODLM W:'$D(AQAODLM) ?30
 ...W $P(^DPT($P(^AQAOC(AQAON,0),U,2),0),U,2) ;patient's sex
 ...W:$D(AQAODLM) AQAODLM W:'$D(AQAODLM) ?35
 ...W $S(+^AQAOC(AQAON,1)=0:"OPEN",1:"CLOSED") ;case status
 ..;
 ..D FINDING
 ..;print last stage
 ..I AQAOTYPE="L" W:$D(AQAODLM) AQAODLM W:'$D(AQAODLM) ?45 W AQAOS
 ..;print last finding
 ..I AQAOTYPE="L" W:$D(AQAODLM) AQAODLM W:'$D(AQAODLM) ?55 W AQAOF
 ..;print last action
 ..I AQAOTYPE="L" W:$D(AQAODLM) AQAODLM W:'$D(AQAODLM) ?65 W AQAOG
 Q
 ;
 ;
FINDING ; >> SUBRTN to find last finding to date for occ
 S (AQAOF,AQAOS,AQAOG,X,Y,Z)="" ;init finding/stage/action to null
 I $P(^AQAOC(AQAON,1),U)=1 D  ;closed occurrences
 .S X=$P($G(^AQAOC(AQAON,"FINAL")),U,4) S:X="" X="??" ;finding
 .S Y=$P($G(^AQAOC(AQAON,"FINAL")),U,2) S:Y="" Y="??" ;stage
 .S Z=$P($G(^AQAOC(AQAON,"FINAL")),U,6) S:Z="" Z="??" ;action
 ;
 I X]"" G COUNT
 S (X,AQAOY)=0 F  S X=$O(^AQAOC(AQAON,"REV",X)) Q:X'=+X  S AQAOY=X
 I AQAOY>0 D  ;else get finding for last review
 .S X=$P(^AQAOC(AQAON,"REV",AQAOY,0),U,5)
 .S Y=$P(^AQAOC(AQAON,"REV",AQAOY,0),U)
 .S Z=$P(^AQAOC(AQAON,"REV",AQAOY,0),U,7)
 G COUNT:X]""
 ;else get initial finding and action
 S X=$P($G(^AQAOC(AQAON,1)),U,5)
 S Y=$P($G(^AQAOC(AQAON,1)),U,3)
 S Z=$P($G(^AQAOC(AQAON,1)),U,6)
 ;
COUNT ;increment counts
 I X="??" D
 .S AQAOF=X
 .S ^TMP("AQAO",$J,"F",AQAOSUB,X)=$G(^TMP("AQAO",$J,"F",AQAOSUB,X))+1
 E  D
 .S AQAOF=$P(^AQAO(8,X,0),U,2)
 .S ^TMP("AQAO",$J,"F",AQAOSUB,$P(^AQAO(8,X,0),U))=$G(^TMP("AQAO",$J,"F",AQAOSUB,$P(^AQAO(8,X,0),U)))+1
 S AQAOS=$S(Y="??":Y,1:$P(^AQAO(7,Y,0),U,2))
 ;
 I Z="??" D
 .S AQAOG=Z
 .S ^TMP("AQAO",$J,"A",AQAOSUB,Z)=$G(^TMP("AQAO",$J,"A",AQAOSUB,Z))+1
 E  D
 .S AQAOG=$P(^AQAO(6,Z,0),U,2)
 .S ^TMP("AQAO",$J,"A",AQAOSUB,$P(^AQAO(6,Z,0),U))=$G(^TMP("AQAO",$J,"A",AQAOSUB,$P(^AQAO(6,Z,0),U)))+1
 Q
 ;
 ;
HDG1 ; >> SUBRTN for second half of heading
 W ?30,"(OCCURRENCE LISTINGS)",!?30,AQAORG,!,AQAOLINE
 W !,"Case #",?9,"Occ Date",?23,"Age",?29,"Sex",?35,"Status",?45,"Stage"
 W ?55,"Findings",?65,"Actions"
 W !,AQAOLINE
 S X="** "_$P(^AQAO(2,AQAOIND,0),U)_"   "_$P(^(0),U,2)_" **"
 W !!?AQAOIOMX-$L(X)/2,X,! ;indicator # and name
 Q
 ;
 ;
HDG2 ; >> SUBRTN for second half of heading2    
 W ?33,"(SUMMARY PAGE)",!?30,AQAORG,!,AQAOLINE,!
 Q
 ;
 ;
DLMHDG ; >> SUBRTN for ASCII heading for listing portion
 W !!!!,"***OCCURRENCE LISTINGS WITH FINDINGS & ACTIONS***",!,AQAORG,!
 W !,"Printed by ",AQAODUZ," Printed on " S %H=$H D YX^%DTC W Y
 F I="Case #","Occ Date","Age","Sex","Status","Stage","Finding","Action" W I,AQAODLM
 Q
