AQAOUSM ; IHS/ORDC/LJF - PRINT TEAM MEMBER LIST ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the user interface and print code to list members
 ;of a selected QI team.
 ;
TEAM ; >>> choose team to print
 W !! K DIC S DIC="^AQAO1(1,",DIC(0)="AEZMQ" D ^DIC G EXIT:Y=-1
 S AQAOTM=+Y,AQAOTMN=$P(Y,U,2)
 ;
DEV ; >>> get print device
 W !! S %ZIS="QP" D ^%ZIS G EXIT:POP
 I '$D(IO("Q")) U IO G CALC
 K IO("Q") S ZTRTN="CALC^AQAOUSM",ZTDESC="TEAM MEMBER LIST"
 S ZTSAVE("AQAOTM")="",ZTSAVE("AQAOTMN")=""
 D ^%ZTLOAD K ZTSK D ^%ZISC G EXIT
 ;
 ;
CALC ;ENTRY POINT called by ZTLOAD when report is queued
 ; >> for this team, find members and sort in alpha order
 K ^TMP("AQAOUSM",$J) S AQAOX=0
 F  S AQAOX=$O(^AQAO(9,"AB",AQAOTM,AQAOX)) Q:AQAOX=""  D
 .S AQAOY=0
 .F  S AQAOY=$O(^AQAO(9,"AB",AQAOTM,AQAOX,AQAOY)) Q:AQAOY=""  D
 ..Q:'$D(^AQAO(9,AQAOX,"TM",AQAOY,0))  S AQAOS=^(0)
 ..S X=$P(^VA(200,AQAOX,0),U) ;user name
 ..S ^TMP("AQAOUSM",$J,X,AQAOX)=$P(AQAOS,U,2) ;save in alpha order
 ;
PRINT ; >> take sorted list and print
 D INIT^AQAOUTIL S AQAOTY="QI TEAM MEMBERSHIP LIST" D HEADING^AQAOUTIL
 D HDG2
 S AQAOUSN=0
 F  S AQAOUSN=$O(^TMP("AQAOUSM",$J,AQAOUSN)) Q:AQAOUSN=""  Q:AQAOSTOP=U  D
 .S AQAOUSR=0
 .F  S AQAOUSR=$O(^TMP("AQAOUSM",$J,AQAOUSN,AQAOUSR)) Q:AQAOUSR=""  Q:AQAOSTOP=U  D
 ..S AQAOS=^TMP("AQAOUSM",$J,AQAOUSN,AQAOUSR)
 ..W !,$E(AQAOUSN,1,25) ;print member name
 ..S Y=$P(AQAOS,U),C=$P(^DD(9002168.91,.02,0),U,2) D Y^DIQ W ?45,Y
 ..I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 ;
EXIT ; >> eoj
 D ^%ZISC
 I '$D(ZTQUEUED) D PRTOPT^AQAOVAR
 D KILL^AQAOUTIL K ^TMP("AQAOUSM",$J) Q
 ;
 ;
HDG2 ; >> SUBRTN to print 2nd half of heading
 W ?AQAOIOMX-$L(AQAOTMN)/2,AQAOTMN,!,AQAOLINE
 W !,"Name",?45,"Pkg Access Level",!,AQAOLIN2,!
 Q
