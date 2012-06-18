BWLOGO ;IHS/ANMC/MWR - DISPLAY LOGO WHEN ENTERING PKG;15-Feb-2003 21:56;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  DISPLAYS LOGO.  GETS VERSION FROM LINE 2 OF THIS ROUTINE.
 ;
 D SETVARS^BWUTL5
 N BWVER,Y
 ;
 S Y=$P($P($T(BWLOGO+1),";;",2),";")
 S BWVER="*     v"_Y_$E("        *",$L(Y),11)
 ;
 W @IOF
 I '$D(DUZ(2)) D  Q
 .W !!!,"DUZ(2) is undefined.  Contact your Site Manager.",!!
 .D DIRZ^BWUTL3
 W !?39,"***"
 W !?35,"*         *"
 W !?32,"*               *"
 W !?30,"*                   *"
 W !?29,"*     W O M E N'S     *"
 W !?29,"*     H E A L T H     *"
 W !?30,"*                   *"
 W !?32,BWVER
 W !?35,"*         *"
 W !?39,"***"
 W !?17,"MAIN MENU",?40,"|",?55,$E($P(^DIC(4,DUZ(2),0),U),1,24)
 W !?37,"---|---"
 W !?40,"|"
 Q
 ;
CHECK ;EP
 ;---> UPON ENTRY VIA MAIN MENU (OR LAB DATA ENTRY MENU), CHECKS TO
 ;---> SEE THAT USER'S DUZ(2) IS SET UP AS A PACKAGE SITE.
 I '$G(DUZ(2)) D WARN D  D CHKOUT Q
 .W !?5,"Your DUZ(2) variable is not defined."
 I '$D(^BWSITE(DUZ(2),0)) D WARN D  D CHKOUT Q
 .W !?5,"Women's Health Site Parameters have NOT been set for the site"
 .W !?5,"you are logged on as: ",$P(^DIC(4,DUZ(2),0),U)
 Q
 ;
WARN ;EP
 W @IOF,!!?35,"WARNING",!?34,"---------",!!
 Q
CHKOUT ;EP
 W !!?5,"At this point you should back out of the Women's Health"
 W !?5,"package and contact your site manager or the person in charge"
 W !?5,"of the Women's Health Software.",!
 I $D(^VA(200,DUZ,51,$O(^DIC(19.1,"B","BWZ MANAGER",0)),0)) D
 .W !?5,"Or, if you wish to set up site parameters for this site,"
 .W !?5,"you may proceed to the Edit Site Parameters option and enter"
 .W !?5,"parameters for this site.  (Synonyms: MF-->FM-->ESP)",!
 D DIRZ^BWUTL3
 Q
