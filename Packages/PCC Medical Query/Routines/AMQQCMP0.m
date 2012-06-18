AMQQCMP0 ;IHS/CMI/THL - MAKES SEARCH TEMPLATES ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ; CALLS TASKMAN
 ;-----
RUN D COHORT
EXIT K AMQQFILE,AMQQBACK,%,%Y,I,K,T,X1,X2,XY
 Q
 ;
COHORT K AMQQFILE
 D FILE
 I $D(AMQQQUIT)!('$D(AMQQFILE)) Q
COH1 W !
 S DIC("A")="Enter the name of the SEARCH TEMPLATE: "
 S DIC="^DIBT("
 S DLAYGO=0
 S DIC(0)="AEQL"
 S DIC("S")="I $P(^(0),U,4)=AMQQFILE"
 D ^DIC
 I Y=-1,X=U S AMQQQUIT="" Q
 I Y=-1 W !,"Cohort not saved...",!! K AMQQCHRT Q
 I '$P(Y,U,3) D CHECK G:Y=-1 COH1 D COVER Q:$D(AMQQQUIT)  I Y=-1 G COH1
COSET K AMQQDIBS
 S AMQQDIBT=+Y
 S DA=AMQQDIBT
 S DIE="^DIBT("
 S DR="2////"_DT_";3////"_DUZ(0)_";4////"_AMQQFILE_";5////"_DUZ_";10"
 D ^DIE
 K DIE,DA,DR,DIC
 S AMQQH1=$H
 K AMQQBACK
 W !!,"Next, you will be asked about creating your template in background..." D TASKHELP  ;CMI/GRL
 D BACK
 I $D(AMQQBACK) Q
 I $D(AMQQQUIT) Q
 S (IOP,AMQQIOP)=0
 D ^%ZIS
 I $E(IOST,1,2)'="P-" W !! D WAIT^DICD
 X AMQV(0)
 D DIBT
 Q
 ;
CHECK ;Check to see if user storing results in a template used in this search
 N AMQQCNT
 F AMQQCNT=0:1  Q:'$D(AMQV(AMQQCNT))!(Y=-1)  I AMQV(AMQQCNT)[("DIBT("_+Y) W !,*7,"You cannot save results in a search template currently in use by your search!",!,"Please select a different search template." S Y=-1
 Q
 ;
COVER S AMQQDIBS=Y
 W !!,"The "_$P(Y,U,2)_" cohort already exists.  Want to overwrite"
 S %=2
 D YN^DICN
 S:$D(DTOUT) %Y=U
 K DTOUT
 I %Y=U S AMQQQUIT="" Q
 I "Nn"[$E(%Y) S Y=-1 Q
 I $P(^DIBT(+Y,0),U,5)=DUZ G COVX
 W !!,"Whoops...I just realized you did not create this template, and therefore you",!
 W "are not allowed to overwrite it. (You wouldn't want to destroy someone else's",!
 W "data, would you???)  Try again with a new template name.",!,*7
 S Y=-1
 Q
COVX S DIK="^DIBT("
 S DA=+AMQQDIBS
 D ^DIK
 S DIC=DIK
 S DIC(0)="L"
 S DIADD=1
 S DINUM=+AMQQDIBS
 S X=$P(AMQQDIBS,U,2)
 D ^DIC
 K DIC,DIADD,AMQQDIBS
 S AMQQSAVY=Y
 S DR=".01"
 S DIE="^DIBT("
 S DA=+Y
 D ^DIE
 K DA,DIE,DR
 S Y=AMQQSAVY
 K AMQQSAVY
 I '$D(^DIBT(+Y,0)) S Y=-1
 Q
 ;
FILE I AMQQCCLS="V" S AMQQFILE=9000010
 E  I AMQQCCLS="H" S AMQQFILE=6
 E  S AMQQFILE=9000001
 W !!,"Fileman users please note =>"
 W !,"This template will be attached to IHS' ",$S(AMQQFILE=9000001:"PATIENT file (#9000001)",AMQQFILE=9000010:"VISIT file (#9000010)",1:"PROVIDER file (#6)"),!!
 I AMQQFILE=6 W "=> This template can only be used within File Manager.",!
 Q
 ;
DIBT W !!!,"Search template completed...",*7
 W !!,"This query generates ",AMQQTOT," ""hits""",!
 S AMQQH2=$H
 S X1=AMQQH1
 S X2=AMQQH2
 D ELT
 W "Time required to create search template: ",X,!!
 I '$D(ZTQUEUED) R !,"<>",X:DTIME
 I AMQQFILE=9000001 D
 .K DIR,X,Y
 .S DIR(0)="S^P:Go to PGEN;V:Go to VGEN;Q:Continue with Qman"
 .S DIR("A")="Enter your choice"
 .S DIR("B")="Q"
 .S DIR("?")="Type P, V or Q and press enter"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 Q:Y="Q"  ;PATCH XXX
 I Y="P" D  G ORDER^APCLVL
 .W !!,"OK ... I'll take you to the PGEN Outputs screen",!
 .D HELP
 .S APCLSEAT=AMQQDIBT
 .S APCLPCNT=0
 .S APCLPTCT=0
 .S APCLPTVS="P"
 .S APCLTYPE="PS"
 I Y="V" D  G ORDER^APCLVL
 .W !!,"OK ... I'll take you to VGEN where you will reenter a date range, then select additional Visit data items, or go on to the VGEN Outputs screen",!
 .D HELP
 .S APCLSEAT=AMQQDIBT
 .S APCLPCNT=0
 .S APCLPTCT=0
 .S APCLPTVS="V"
 .S APCLTYPE="VP"
 I AMQQFILE=9000010 D  G:Y=1 BD^APCLVL ;PATCH XXX
 .K DIR
 .S DIR(0)="Y"
 .S DIR("A")="Do you want to go to VGEN"
 .D ^DIR
 .K DIR
 .Q:Y'=1
 .W !!,"OK ... I'll take you to VGEN where you will reenter a date range, then select additional Visit data items, or go on to the VGEN Outputs screen",!
 .D HELP
 .S APCLSEAT=AMQQDIBT
 .S APCLPCNT=0
 .S APCLPTCT=0
 .S APCLPTVS="V"
 .S APCLTYPE="VV"
 ;
 K AMQQH1,AMQQH2,AMQQDIBT
 Q
HELP ;PGEN/VGEN HELP
 K DIR
 S DIR(0)="E"
 S DIR("A")="Press ENTER to continue or '^' to quit"
 D ^DIR
 Q
 ;
MAIL ;SEND MAIL MESSAGES TO USERS RE:TEMPLATES
 S XMDUZ=.5
 S XMTEXT="AMQQMAIL("
 S XMSUB="*** NOTICE OF QMAN SEARCH TEMPLATE COMPLETION ***"
 S AMQQMAIL(1,0)="THE SEARCH TEMPLATE "_$P(^DIBT(AMQQDIBT,0),U)_" IS NOW READY FOR USE"
 S XMY(DUZ)=""
 D ^XMD
 K AMQQMAIL
 Q
 ;
ELT ; ENTRY POINT FROM AMQQCMPP
 S X=(((+X2)-(+X1))*86400)+$P(X2,",",2)-$P(X1,",",2)
 S %=""
 F I=1:1:3 S K=$P("86400^3600^60",U,I),T=$P("DAY^HOUR^MINUTE",U,I),Y=X\K I Y S %=%_Y_" "_T_$S(Y>1:"S, ",1:", "),X=X-(K*Y)
 S %=%_X_" SECOND"
 I X'=1 S %=%_"S"
 S X=%
 Q
 ;
BACK W !!,"Want to run this task in background"
 S %=2
 D YN^DICN
 S %Y=$S(%=2:"N",%=1:"Y",%=0:"?",%=-1:"^",1:0)
 I $D(DTOUT) S %Y=U K DTOUT
 I $E(%Y)=U S AMQQQUIT="" Q
 I "nN"[%Y Q
 ;I $E(%Y)="?" W !!,?5,"ANSWER 'YES' or 'NO'",! G BACK
 I $E(%Y)="?" D TASKHELP G BACK  ;IHS/CMI/GRL
ZT S AMQQBACK=""
 S ZTRTN="TASK^AMQQCMP0"
 S ZTIO=""
 S ZTDTH="NOW"
 S ZTDESC="QUERY UTILITY GENERATING SEARCH TEMPLATE "
 F I=1:1 S %=$P("DT;AMQQ200(;AMQQBACK;AMQQDIBT;DTIME;DUZ(;DUZ;U;AMQV(;AMQQCCLS;^UTILITY(""AMQQ"",$J,""VAR NAME"",;^UTILITY(""AMQQ RAND"",$J,;^UTILITY(""AMQQ TAX"",$J,",";",I) Q:%=""  S ZTSAVE(%)=""
 D ^%ZTLOAD
 D ^%ZISC
 W !!,$S($D(ZTSK):"Search template being generated in background",1:"Background job cancelled due to technical problems"),!!!
 H 3
 Q
 ;
TASK X AMQV(1)
 F I=1:1 S %=$P("AMQQ^AMQQ TAX^AMQQ TEMP^AMQQ SER1^AMQQ SAVE",U,I) Q:%=""  K ^UTILITY(%,$J)
 I $D(ZTQUEUED) S ZTREQ="@"
 D MAIL
 Q
 ;
TASKHELP ;
 W !!,"Answer 'YES' to run in background."
 W !!,"To run in background means to pass the template creation job off to Taskman."
 W !,"Your terminal will be released so additional RPMS work may be performed while"
 W !,"the template is being created.  When finished, Taskman will send you a Mailman"
 W !,"message indicating that the job is ready.  Then, you may use the template in"
 W !,"future Qman searches, PGEN, VGEN and other reports that can utilize templates."
 W !
 W !,"Answer 'NO', to create the search template in foreground."
 W !!,"While the template is being created, data will be displayed to your screen."
 W !,"When the job has finished, you will have the opportunity to go to PGEN or VGEN."
 W !,"Remember ... some templates may take a very long time to finish."
 W !
 D HELP
 Q
