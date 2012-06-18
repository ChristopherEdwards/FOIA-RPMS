AQAOPAR1 ; IHS/ORDC/LJF - ADT SERVICE LINKS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains an entry point called by ^AQAOPAR.  The code deals
 ;with the user interface in assigning services to each RPMS link.
 ;
CURRENT ;ENTRY POINT >>> find all services currently linked
 S AQAODR1=".0"_($E(AQAOI,3)+2) ;yes/no field
 S X="1"_($E(AQAOI,3)+2),AQAODR2=$S($D(^DD(9002166.42,X,0)):X,1:"") ;#
 ;
 W @IOF,!!?20,"SERVICES CURRENTLY LINKED TO "
 W $P(^DD(9002166.4,AQAOI,0),U),!!
 K AQAOCUR S AQAOX=0 ;get service ifns
 F  S AQAOX=$O(^AQAGP(AQAOFAC,"SRV",AQAOX)) Q:AQAOX'=+AQAOX  D
 .K DIQ K ^UTILITY("DIQ1",$J) S DIC=9002166.4,DA=AQAOFAC,DR="9000"
 .S (AQAODA,DA(9002166.42))=AQAOX
 .S (AQAODR,DR(9002166.42))=".01;"_AQAODR1
 .D EN^DIQ1 Q:^UTILITY("DIQ1",$J,9002166.42,AQAODA,AQAODR1)'="YES"
 .S AQAOCUR(AQAOX)=^UTILITY("DIQ1",$J,9002166.42,AQAODA,.01)
 ;
 I '$D(AQAOCUR) W !!,"NO SERVICES CURRENTLY LINKED",! G ADD
 ;
 W !! S AQAOX=0
 F  S AQAOX=$O(AQAOCUR(AQAOX)) Q:AQAOX=""  D
 .W !,AQAOCUR(AQAOX)
 .I AQAODR2]"" D
 ..K ^UTILITY("DIQ1",$J) S DIC="^AQAGP(",DA=AQAOFAC,DR="9000"
 ..S (AQAODA,DA(9002166.42))=AQAOX
 ..S (AQAODR,DR(9002166.42))=AQAODR2 D EN^DIQ1
 ..W ?40,^UTILITY("DIQ1",$J,9002166.42,AQAODA,AQAODR)," DAYS"
 ;
EDIT ; >>> ask if user wants to edit or delete any current services
 W !! K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Do you want to EDIT or DELETE any current services"
 D ^DIR G EXIT:$D(DIRUT),ADD:Y=0
 ;
 W !!!,">>> MODIFY/DELETE MODE . . ."
CHOOSE1 W !! K DIC,DIR S DIC="^AQAGP("_AQAOFAC_",""SRV"",",DIC(0)="AEMQZ"
 S DIC("S")="I $D(AQAOCUR(Y))" D ^DIC
 G EXIT:X=U,EXIT:$D(DTOUT),ADD:X="",CHOOSE1:Y=-1
 K DIE S DIE="^AQAGP("_AQAOFAC_",""SRV"","
 S DA=+Y,DA(1)=AQAOFAC,DR=AQAODR1_";"_AQAODR2 D ^DIE
 G CHOOSE1
 ;
 ;
ADD ; >>> ask if user wants to add new services
 W !! K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Do you want to ADD any new services to this link"
 D ^DIR G EXIT:$D(DIRUT),EXIT:Y=0
 ;
 W !!!,">>> ADD MODE . . ."
CHOOSE2 W !! K DIC,DIR S DIC="^DIC(49,",DIC(0)="AEMQZ"
 D ^DIC G EXIT:X=U,EXIT:$D(DTOUT),EXIT:X="",CHOOSE2:Y=-1 S AQAOY=+Y
 I '$D(^AQAGP(AQAOFAC,"SRV","B",+Y)) D  ;add serv multiple
 .S ^AQAGP(AQAOFAC,"SRV",0)="^9002166.42P"
 .S DIC(0)="L",DIC="^AQAGP("_AQAOFAC_",""SRV"",",DA(1)=AQAOFAC
 .S X=$P(Y,U,2) D ^DIC
 K DIE S DIE="^AQAGP("_AQAOFAC_",""SRV"",",DA(1)=AQAOFAC
 S DA=$O(^AQAGP(AQAOFAC,"SRV","B",AQAOY,0)),DR=AQAODR1_"////1;"_AQAODR2
 I DA]"" D ^DIE
 G CHOOSE2
 ;
 ;
EXIT ; >>> eoj
 Q  ;return to calling rtn AQAOPAR
