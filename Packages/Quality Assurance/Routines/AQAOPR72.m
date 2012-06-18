AQAOPR72 ; IHS/ORDC/LJF - PRINT REVIEWED OCC RPRT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn prints the occurrences by indicator listing all reviews
 ;performed and who performed them.
 ;
INIT ; >>> initialize variables
 D INIT^AQAOUTIL S AQAOHCON="Patient"
 S AQAOTY="REVIEWED OCCURRENCES REPORT"
 S AQAORG=$E(AQAOBD,4,5)_"/"_$E(AQAOBD,6,7)_"/"_$E(AQAOBD,2,3)_" to "
 S AQAORG=AQAORG_$E(AQAOED,4,5)_"/"_$E(AQAOED,6,7)_"/"_$E(AQAOED,2,3)
 S AQAONOT=0 ;counter for occ not reviewed
 K ^TMP("AQAO",$J)
 ;
MAIN ; >>> main calls
 I '$D(^TMP("AQAOPR7A",$J)) D 
 .D HEADING^AQAOUTIL,HDG1
 .W !!,"NO DATA FOUND FOR DATE RANGE SPECIFIED",!!
 E  D LISTING I AQAOSTOP'=U D SUMMARY^AQAOPR73
 ;
END ; >>> eoj
 D ^%ZISC I '$D(ZTQUEUED) D PRTOPT^AQAOVAR
 K ^TMP("AQAOPR7",$J),^TMP("AQAOPR7A",$J),^TMP("AQAO",$J)
 K AQAOINAC D KILL^AQAOUTIL Q
 ;
 ;
LISTING ; >> SUBRTN to print occurrence listing if selected
 D HEADING^AQAOUTIL,HDG1
 ;
 S AQAOIND=0 ;loop by indicator and print occurrences
 F  S AQAOIND=$O(^TMP("AQAOPR7A",$J,AQAOIND)) Q:AQAOIND=""  Q:AQAOSTOP=U  D
 .D LIST2 Q:AQAOSTOP=U  ;list each occ with reviews
 Q
 ;
 ;
LIST2 ; >> SUBRTN for each AQAOIND list occ with reviews
 I AQAOIND'=0 W !!?AQAOIOMX-$L(AQAOIND)/2,AQAOIND,!
 S AQAODT=0
 F  S AQAODT=$O(^TMP("AQAOPR7A",$J,AQAOIND,AQAODT)) Q:AQAODT=""  Q:AQAOSTOP=U  D
 .S AQAON=0
 .F  S AQAON=$O(^TMP("AQAOPR7A",$J,AQAOIND,AQAODT,AQAON)) Q:AQAON=""  Q:AQAOSTOP=U  D
 ..S AQAOSTR=$G(^AQAOC(AQAON,0)),AQAOSTR1=$G(^(1)) ;basic occ data
 ..I $Y>(IOSL-2) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG1
 ..S Y=AQAODT X ^DD("DD") W !,$P(AQAOSTR,U),?9,Y ;print case & date
 ..K ^UTILITY("DIQ1",$J) S DIC="^AQAOC(",DA=AQAON,DR=".025" D EN^DIQ1
 ..W ?22,$S(+AQAOSTR1=0:"OPEN",+AQAOSTR1=1:"CLOSED",1:"DELETED") ;status
 ..;
 ..D FINDING
 Q
 ;
 ;
FINDING ; >> SUBRTN to find findings,etc. for occ
 ;get initial finding and action
 S AQAOW=$P($G(^AQAOC(AQAON,1)),U,8) ;review date
 S AQAOX=$P($G(^AQAOC(AQAON,1)),U,5) ;finding
 S AQAOY=$P($G(^AQAOC(AQAON,1)),U,4) ;reviewer
 S AQAOZ=$P($G(^AQAOC(AQAON,1)),U,6) ;action
 S X=$P($G(^AQAOC(AQAON,1)),U,9) ;referred to;PATCH 3
 I X]"" S AQAOAR(1)=X,X=1,Y=0 F  S Y=$O(^AQAOC(AQAON,"IADDRV",Y)) Q:Y'=+Y  D  ;PATCH 3
 .S X=X+1,AQAOAR(X)=$P($G(^AQAOC(AQAON,"IADDRV",Y,0)),U) ;addl referrals
 I AQAOW="" S AQAONOT=AQAONOT+1 Q  ;occ not reviewed
 W !?22,"Reviews:"
 D PRINTREV K AQAOAR
 ;
 S AQAOR=0 F  S AQAOR=$O(^AQAOC(AQAON,"REV",AQAOR)) Q:AQAOR'=+AQAOR  D
 .S AQAOW=$P(^AQAOC(AQAON,"REV",AQAOR,0),U,4) ;review date
 .S AQAOX=$P(^AQAOC(AQAON,"REV",AQAOR,0),U,5) ;finding
 .S AQAOY=$P(^AQAOC(AQAON,"REV",AQAOR,0),U,2) ;reviewer
 .S AQAOZ=$P(^AQAOC(AQAON,"REV",AQAOR,0),U,7) ;action
 .S (X,Y)=0 F  S Y=$O(^AQAOC(AQAON,"REV",AQAOR,"ADDRV",Y)) Q:Y'=+Y  D
 ..S X=X+1,AQAOAR(X)=$P($G(^AQAOC(AQAON,"REV",AQAOR,"ADDRV",Y,0)),U)
 .D PRINTREV K AQAOAR
 ;
 I $P(^AQAOC(AQAON,1),U)=1 D  ;closed occurrences
 .S AQAOW=$P($G(^AQAOC(AQAON,"FINAL")),U) ;review date
 .S AQAOX=$P($G(^AQAOC(AQAON,"FINAL")),U,4) ;finding
 .S AQAOY=$P($G(^AQAOC(AQAON,"FINAL")),U,5)_";VA(200," ;reviewer
 .S AQAOZ=$P($G(^AQAOC(AQAON,"FINAL")),U,6) ;action
 .D PRINTREV
 Q
 ;
 ;
PRINTREV ; SUBRTN to print rev date,reviewer,finding,action
 Q:AQAOW=""
 S Y=AQAOW,C=$P(^DD(9002167,.18,0),U,2) D Y^DIQ W ?32,Y ;review date
 S Y=AQAOY,C=$P(^DD(9002167,.14,0),U,2) D Y^DIQ ;reviewer
 W ?47,$$NAME
 I Y]"" S ^TMP("AQAO",$J,Y,AQAOIND,AQAON)=""
 S Y=$S(AQAOX="":"",1:$P($G(^AQAO(8,AQAOX,0)),U,2)) W ?62,Y ;finding
 S Y=$S(AQAOZ="":"",1:$P($G(^AQAO(6,AQAOZ,0)),U,2)) W ?72,Y ;action
 I $D(AQAOAR) S AQAOX=0 F  S AQAOX=$O(AQAOAR(AQAOX)) Q:AQAOX=""  D
 .W:AQAOX=1 !?47,"Referred to:" W:AQAOX>1 !
 .S Y=AQAOAR(AQAOX),C=$P(^DD(9002167,.19,0),U,2) D Y^DIQ ;referrals
 .W ?62,$$NAME
 W ! Q
 ;
 ;
HDG1 ; >> SUBRTN for second half of heading
 W ?30,AQAORG,!,AQAOLINE
 W !,"Case #",?9,"Occ Date",?22,"Status"
 W ?32,"Rev Date",?47,"Revwr",?62,"Finding",?72,"Action"
 W !,AQAOLINE
 Q
 ;
 ;
HDG2 ; >> SUBRTN for second half of heading2    
 W ?33,"(SUMMARY PAGE)",!?30,AQAORG,!,AQAOLINE,!
 Q
 ;
 ;
NAME() ; >> EXTRN VAR for printing names
 I Y'["," S Y=$E(Y,1,12) Q Y
 S Y=$P(Y,",")_","_$E($P(Y,",",2),1),Y=$E(Y,1,12) Q Y
