AMQQOPT1 ; IHS/CMI/THL - OVERFLOW FROM AMQQOPT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
 Q
CHK I $D(DTOUT)+$D(DUOUT)+(Y=-1)+(Y="")+(Y=U) K AMQQOPT,DIRUT,DUOUT,DTOUT S AMQQQUIT="" Q
 Q
 ;
VIEW ; ENTRY POINT FROM AMQQOPT
 W @IOF,!!!,?15,"*****  VIEW Q-MAN TAXONOMIES AND TEMPLATES  *****",!!!
V1 S DIR(0)="SO^1:LIST Fileman/Q-Man search templates;2:VIEW taxonomies;3:ERASE a search template;4:REMOVE a taxonomy;9:HELP;0:EXIT"
 S DIR("??")="AMQQVIEW"
 S DIR("A")=$C(10)_"     Your choice"
 S DIR("?")="Enter a code from the list or type '??' for more information"
 D ^DIR
 K DIR
 D CHK
 I  K:$G(Y)'="^" AMQQQUIT W @IOF Q
 I Y=9 S XQH=$O(^DIC(9.2,"B","AMQQVIEW","")) D EN1^XQH G VIEW
 I Y=0 K AMQQOPT G EXIT
 I Y=1 D TMP^AMQQVIEW G VIEW
 I Y=2 D TAX^AMQQVIEW G VIEW
 I Y=3 D KTMP G VIEW
 I Y=4 D KTAX G VIEW
EXIT K X,%
 W @IOF
 Q
 ;
KTMP W !!!,"You can only erase your own templates...",!!
 S DIC("A")="TEMPLATE NAME: "
 S DIC(0)="AEQ"
 S DIC="^DIBT("
 S DIC("S")="I $P(^(0),U,5)=DUZ,$D(^(1))"
 D ^DIC
 I $D(DUOUT)+$D(DTOUT)+(Y=-1) K DUOUT,DTOUT Q
ASK W !,"Are you sure you want to do this"
 S %=0
 D YN^DICN
 I $D(DUOUT)+$D(DTOUT) Q
 I %Y["?" W !,"If you say yes, your search template will be deleted.",! G ASK
 I %=-1!(%=2)!'% Q
 S DA=+Y
 S DIK="^DIBT("
 D ^DIK
 W !!,"OK, the template has been erased",!
 H 2
 Q
 ;
KTAX W !!!,"You can only erase your own taxonomies created within Q-MAN...",!!
 S DIC("A")="TAXONOMY NAME: "
 S DIC(0)="AEQ"
 S DIC="^ATXAX("
 S DIC("S")="I $P(^(0),U,5)=DUZ,'$P(^(0),U,8)"
 D ^DIC
 I $D(DUOUT)+$D(DTOUT)+(Y=-1) K DUOUT,DTOUT Q
ASK1 W !,"Are you sure you want to do this"
 S %=0
 D YN^DICN
 I $D(DUOUT)+$D(DTOUT) Q
 I %Y["?" W !,"If you say yes, your taxonomy will be deleted.",! G ASK1
 I %=-1!(%=2)!'% Q
 S DA=+Y
 S DIK="^ATXAX("
 D ^DIK
 K DIK,DIC,DA
 W !!,"OK, the taxonomy has been removed",!
 H 2
 Q
 ;
RMAN ; ENTRY POINT FROM AMQQCMPL
 I $D(AMQQOPT("SPEC")) K AMQQOPT("SPEC") S Y=5 G JUMP
 W @IOF,!!,?15,"*****  R-MAN   CUSTOM REPORT GENERATOR  *****"
 W !!!
 S DIR(0)="SO^1:CUSTOM configured reports;2:E-MAN data export manager;5:SPECIAL reports ('Age Distr Rpt', health summaries, etc.);9:HELP;0:EXIT"
 S DIR("??")="AMQQRMAN"
 S DIR("A")=$C(10)_"     Your choice"
 S DIR("?")="Enter a code from the list or type '??' for more information"
 D ^DIR
 K DIR
 D CHK
 I  W @IOF K AMQQQUIT Q
 I Y=9 S XQH="AMQQRMAN" D EN1^XQH G RMAN
 I Y=0 G EXIT
EMAN I Y=2 D PROG G:'% RMAN S AMQV("OPTION")="EMAN" Q
 I Y<5 W !!,"Sorry, this option is not available in Q-Man Ver. 2",!!,*7 H 3 G RMAN
JUMP I Y=5 D SPEC I '$D(AMQV("OPTION")) K AMQQQUIT G RMAN
 Q
 ;
SPEC W @IOF,!!,?15,"*****  R-MAN    SPECIAL REPORTS  *****"
 K DIR
 K AMQV("OPTION"),AMQQQUIT
 S DIR(0)="SO^1:Age Distribution Report;2:Health summaries;3:Mailing labels;4:Month Distribution Report;5:Time series;6:Workload Distribution Report;9:HELP"
 S DIR("??")="AMQQSPECIAL"
 S DIR("A")=$C(10)_"     Your choice"
 S DIR("?")="Enter a code from the list or type '??' for more information"
 D ^DIR
 K DIR
 D CHK
 I  W @IOF Q
 I Y=9 S XQH=$O(^DIC(9.2,"B","AMQQSPECIAL","")) D EN1^XQH G SPEC
 I Y=0 Q
 I Y S AMQV("OPTION")=$P("AGE^HSUM^MAIL^MONTH^TIME^WORK",U,Y) Q
 S AMQQOPT="SEARCH"
 Q
 ;
PROG ;
 S %=$$KEYCHECK^AMQQUTIL("AMQQZEMAN")
 I '% W !,"Sorry.  This option require a Q-Man E-MAN Access Key.  Check with your site manager.",!!,*7 H 2
 Q
 ;
