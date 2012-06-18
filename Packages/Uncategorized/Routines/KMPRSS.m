KMPRSS ;SFISC/KAK/RAK - Resource Usage Monitor Status ;3/28/00  08:55
 ;;1.0;CAPACITY MANAGEMENT - RUM;**1,2**;Dec 09, 1998
 ;
STAT ; Status of Resource Usage Monitor collection
 N CHECK,KMPRX,X,Y
 ; check environment
 D ENVCHECK^KMPRUTL1(.CHECK,1)
 ; if RUM turned on but background job not queued ask user if they want
 ; to queue it at this time.
 D:(+CHECK)=200 ENVCHECK^KMPRUTL1(.CHECK)
 W @IOF,!!,?25,"Resource Usage Monitor Status"
 S X="Version "_$P($$VERSION^KMPRUTL,U)
 W !,?(80-$L(X)\2),X,!
 ; patches
 S X=$P($$VERSION^KMPRUTL,U,2)
 W:X]"" ?(80-$L(X)\2),X,!
 W !,?5,"The Resource Usage Monitor is currently "
 I +$G(^%ZTSCH("LOGRSRC")) W "running."
 E  W "stopped."
 W !
 I '$D(^DIC(19,"B","KMPR BACKGROUND DRIVER")) D 
 .W !," The 'RUM Background Driver' option [KMPR BACKGROUND DRIVER] is missing !",*7,!
 E  D
 .S KMPRX=$O(^DIC(19,"B","KMPR BACKGROUND DRIVER",0))
 .S KMPRX=+$O(^DIC(19.2,"B",KMPRX,0))
 .I 'KMPRX W !?5,"The 'RUM Background Driver' [KMPR BACKGROUND DRIVER] is not scheduled",!?5,"to run!",! Q
 .S KMPRX=$G(^DIC(19.2,KMPRX,0))
 .S $P(KMPRX,U,2)=$$FMTE^XLFDT($P(KMPRX,U,2))
 .W !,?5,"The 'RUM Background Driver' [KMPR BACKGROUND DRIVER]"
 .W !?5,"is QUEUED TO RUN AT ",$P(KMPRX,U,2)
 .W !,?5,"with a RESCHEDULING FREQUENCY of '",$P(KMPRX,U,6),"'."
 W !!,?5,"The temporary collection global (i.e., 'XTMP(""KMPR"")') is",$S('$D(^XTMP("KMPR")):" not",1:"")," present",!,?5,"on your system.",!
 W !!,"Press <RETURN> to continue: " R X:DTIME
 ;
 Q
 ;
START ; Start Resource Usage Monitor collection
 N CHECK
 ; check environment
 D ENVCHECK^KMPRUTL1(.CHECK,1)
 ; if RUM does not support this operating system then quit.
 I (+CHECK)=100 W !! D ENVOUTPT^KMPRUTL1(CHECK,1,1) H 1 Q
 I +$G(^%ZTSCH("LOGRSRC")) W !!,?10,"The Resource Usage Monitor is already running.",! H 1 Q
 W ! K DIR S DIR(0)="Y",DIR("B")="YES"
 S DIR("?")="Answer YES to start collecting Resource Usage Monitor data"
 S DIR("A")="Do you want to start Resource Usage Monitor collection"
 D ^DIR G:$D(DTOUT)!$D(DUOUT) END
 I Y D
 .S DIE=8989.3,DA=1,DR="300///YES" D ^DIE
 .W !!,?10,"Resource Usage Monitor collection is started.",!
 .D ENVCHECK^KMPRUTL1(.CHECK,1)
 .; if background driver not scheduled to run then start it up
 .D:(+CHECK=200) QUEBKG^KMPRUTL1
 E  W !!,?10,"Resource Usage Monitor collection is NOT started.",!
 H 1 G END
 ;
STOP ; Stop Resource Usage Monitor collection
 I '+$G(^%ZTSCH("LOGRSRC")) W !!,?10,"The Resource Usage Monitor is already stopped.",! H 1 Q
 W ! K DIR S DIR(0)="Y",DIR("B")="YES"
 S DIR("?")="Answer YES to stop collecting Resource Usage Monitor data"
 S DIR("A")="Do you want to stop Resource Usage Monitor collection"
 D ^DIR G:$D(DTOUT)!$D(DUOUT) END
 I Y D
 .S DIE=8989.3,DA=1,DR="300///NO" D ^DIE
 .W !!,?10,"Resource Usage Monitor collection is stopped.",!
 E  W !!,?10,"Resource Usage Monitor collection is NOT stopped.",!
 H 1
 ;
END ;
 K DA,DIE,DIR,DR,DTOUT,DUOUT,X,Y
 Q
