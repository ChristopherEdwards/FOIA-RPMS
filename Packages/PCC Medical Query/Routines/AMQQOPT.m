AMQQOPT ;IHS/CMI/THL - QUERY OPTIONS ;
 ;;2.0;IHS PCC SUITE;**2,4,5**;MAY 14, 2009
 ;-----
ADAM I $D(AMQQADAM) D SEL G EXIT
 I $D(AMQQAGIN) D SEL G EXIT
HELLO W @IOF,!!,?12,"*****  WELCOME TO Q-MAN: THE PCC QUERY UTILITY  *****"
RUN D WARN
 D SEC
 I $D(AMQQQUIT) G EXIT
 S DIR(0)="E"
 D ^DIR
 K DIR
 I $D(DUOUT)+$D(DTOUT) K DTOUT,DIRUT,DUOUT S AMQQQUIT="" G EXIT
 D SEL
EXIT K X,%,Y
 Q
 ;
WARN S X=""
 S $P(X,"*",80)=""
 W !!!,X,!
W1 W "**         WARNING...Q-Man produces confidential patient information.        **"
 W !,"**     View only in private.  Keep all printed reports in a secure area.     **",!
 W "**          Ask your site manager for the current Q-Man Users Guide.         **",!,X,!!!
 Q
 ;
SEC I '($D(DUZ)#2) D NOUSER Q
 I 'DUZ D NOUSER Q
 I '$D(DUZ(2)) D NOSITE Q
 I 'DUZ(2) D NOSITE Q
 W !,"Query utility: IHS PCC SUITE Q-MAN Ver. ",AMQQVER
 S %=$P(@AMQQ200(3)@(DUZ,0),U)
 S %=$P(%,",",2,9)_" "_$P(%,",")
 W !,"Current user: ",%
 W !,"Chart numbers will be displayed for: ",$P(^DIC(4,DUZ(2),0),U)
 W !,"Access to demographic data: PERMITTED"
 W !,"Access to clinical data: "
 S %=$$KEYCHECK^AMQQUTIL("AMQQZCLIN")
 W $S(%:"PERMITTED",1:"DENIED"),!
 S %=$$KEYCHECK^AMQQUTIL("AMQQZPROG")
 W "Programmer privileges: ",$S(%:"YES",1:"NO"),!!!
 Q
 ;
NOUSER W !!,"USER NOT IDENTIFIED...SESSION ABORTED",!!,*7 G NO1
NOSITE W !!,"LOCATION NOT IDENTIFIED...SESSION ABORTED",!!,*7
NO1 S AMQQQUIT=""
 H 3
 Q
 ;
CHECK Q  ;S %=$$KEYCHECK^AMQQUTIL("AMQQZPROG") ;IHS/CMI/THL PATCH XXX
 I '% K AMQQOPT W "Sorry...Programmer privileges are required for this option",!!,*7 H 3 W @IOF
 Q
 ;
SEL W @IOF,!!?25,"*****  Q-MAN OPTIONS  *****",!!!
SEL1 S DIR(0)="SO^1:SEARCH PCC Database (dialogue interface);2:FAST Facts (natural language interface);3:RUN Search Logic;4:VIEW/DELETE Taxonomies and Search Templates;5:FILEMAN Print;9:HELP;0:EXIT"
 S DIR("A")=$C(10)_"     Your choice"
 S DIR("B")="SEARCH"
 S DIR("?")="Select an option or type '??' for more information"
 S DIR("??")="AMQQMENU"
 D ^DIR
 K DIR,AMQQDLIM
 I $G(DUOUT)+$G(DTOUT)+'Y K DTOUT,DIRUT,DUOUT S AMQQQUIT="" Q
OUT1 W !!
 I Y=1 S AMQQOPT="SEARCH" Q
 I Y=2 S AMQQOPT="FAST" Q
 I Y=3 S AMQQOPT="SAVE" D CHECK G:'$D(AMQQOPT) SEL1 Q
 I Y=4 S AMQQOPT="VIEW" D VIEW G SEL
 I Y=5 S %=$$KEYCHECK^AMQQUTIL("AMQQZCLIN") I '% W "Sorry...Clinical privileges are required for this option",!!,*7 H 3 G SEL
 I Y=5 D ^DIP G SEL
 I Y=9 S XQH=$O(^DIC(9.2,"B","AMQQMENU","")),DIC(0)="X" D EN^XQH G SEL
 Q
 ;
OUT ; ENTRY POINT FROM AMQQCMPL
 I $D(AMQQEN31) S AMQV("OPTION")="COHORT" Q
 K AMQV("OPTION")
 D OUTPUT
 I $D(AMQQQUIT) G OUTEXIT
 I Y=-1 D  Q
 .I $D(AMQV("OPTION")),$D(AMQQQUIT),"AGEHSUMMAILMONTHTIMEWORK"[AMQV("OPTION") S AMQQOPT("SPEC")=""
 S AMQV("OPTION")=$P("LIST^PRINT^COUNT^COHORT^STORE^RMAN",U,Y)
OUTEXIT K X,POP,DTOUT
 S AMQQ("AGIN")=""
 Q
 ;
OUTPUT ; - EP - FROM AMQQQE1
 K AMQQDVQU
 I $D(AMQQOPT("ASCII")) S Y=6 K AMQQOPT("ASCII") G RMAN
 I $D(AMQQOPT("SPEC")) S Y=6 G RMAN
 W @IOF,!!,?20,"*****  Q-MAN OUTPUT OPTIONS  *****",!!
OS S DIR(0)="SO^1:DISPLAY results on the screen;2:PRINT results on paper;3:COUNT 'hits';4:STORE results of a search in a FM search template;5:SAVE search logic for future use;6:R-MAN special report generator"
 S DIR(0)=DIR(0)_";7:DELIMITED file via screen capture;9:HELP;0:EXIT"
 S DIR("??")="AMQQOUTPUT"
 S DIR("?")="Enter a code from the list or '??' for more information on each choice"
 S DIR("A")=$C(10)_"     Your choice"
 S DIR("B")="DISPLAY"
 D ^DIR
 K DIR
 I $D(DUOUT)+$D(DTOUT) K DIRUT,DUOUT,DTOUT S AMQQQUIT="" Q
 I Y=9 S XQH="AMQQOUTPUT",DIC(0)="X" D EN^XQH G OUTPUT
 I 'Y S AMQQQUIT="" Q
 I Y=7 S AMQQDLIM=1 S Y=1
 I Y=5,$D(AMQQCPLF) W "  (Already selected...try again)",*7,! G OS
RMAN I Y=6 D RMAN^AMQQOPT1 G:'$D(AMQV("OPTION")) OS I '$D(AMQQQUIT) D @(AMQV("OPTION")_"^AMQQRMAN") S Y=-1 I $D(AMQQRERF) K AMQQRERF D  G OUTPUT
 .I $D(AMQV("OPTION")),$D(AMQQQUIT),"AGEHSUMMAILMONTHTIMEWORK"[AMQV("OPTION") S AMQQOPT("SPEC")=""
 Q
 ;
VIEW D VIEW^AMQQOPT1
 Q
 ;
