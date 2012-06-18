AQAOPR7 ; IHS/ORDC/LJF - REVIEWED OCCURRENCES REPORT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This report prints occurrences listing all reviews and referrals.
 ;This rtn contains the user interface to select open and/or closed
 ;occ, type of report, users, teams, and date range.  The type of
 ;report questions calls extrinsic functions in ^AQAOPU*.
 ;
STATUS ; >>> ask if user wants to select closed or deleted occ
 W !!?2,"Which OCCURRENCES do you want to print?"
 K DIR S DIR(0)="LO^1:3^K:X#1 X",DIR("A",1)="  1.  OPEN"
 S DIR("A",2)="  2.  CLOSED",DIR("A",3)="  3.  DELETED",DIR("A",4)=" "
 S DIR("A")="Select ONE OR MORE, by number separated by commas"
 D ^DIR G END:$D(DIRUT) S AQAOSTAT=Y
 ;
 ;
TYPE ; >> ask user what type of report to print
 K ^TMP("AQAOPR7",$J) W !! K DIR
 S DIR(0)="SO^1:ONE INDICATOR;2:BY KEY FUNCTION;3:FACILITY REPORT"
 S DIR("A")="Select TYPE OF REPORT to print"
 S DIR("?")="Choose ONE from the list by number"
 D ^DIR G END:$D(DIRUT),TYPE:Y=-1
 S X="AQAOPR7"
 S AQAOTP=$S(Y=1:$$IND^AQAOPU(X),Y=2:$$KF^AQAOPU(X),1:$$FACR^AQAOPU1(X))
 K ^TMP("AQAOPR7",$J,2) ;ind you don't have access to
 G TYPE:AQAOTP=U
 ;
 ;
USERS ; >> ask user to screen by user
 W !! K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Do you wish to limit the report by USER" D ^DIR
 G STATUS:$D(DIRUT) S AQAOO("USR",0)="" ;all users
 I Y=1 F  Q:$D(DIRUT)  D  ;ask for users to include
 .W !! K DIR S DIR(0)="PO^200:EMQZ",DIR("A")="Select USER Name"
 .D ^DIR Q:$D(DIRUT) 
 .I Y>0 D  ;set up array for variable pointers to va200 or qi user file
 ..S AQAOO("USR",+Y_";VA(200,")=$P(Y,U,2)
 ..S AQAOO("USR",+Y_";AQAO(9,")=$P(Y,U,2)
 ;
 ;
TEAMS ; >> ask user to screen by teams
 W !! K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Do you wish to limit the report by QI TEAM" D ^DIR
 G USERS:$D(DIRUT) S AQAOO("TEAM",0)="" ;all qi teams
 I Y=1 F  Q:$D(DIRUT)  D  ;ask for users to include
 .W !! K DIR S DIR(0)="PO^9002169.1:EMQZ" D ^DIR Q:$D(DIRUT) 
 .I Y>0 S AQAOO("TEAM",+Y_";AQAO1(1,")=$P(Y,U,2)
 ;
 ;
DATES ; >> ask user to choose date range
 S AQAOBD=$$BDATE^AQAOLKP G END:AQAOBD=U,TEAMS:AQAOBD=""
 S AQAOED=$$EDATE^AQAOLKP G END:AQAOED=U,DATES:AQAOED=""
 ;
 ;
DEV ; >>> get print device
 I $P(AQAOUA("USER"),U,7)=1 D EXPORT^AQAOUTIL G DATES:Y=U
 W !! S %ZIS="QP" D ^%ZIS G END:POP
 I '$D(IO("Q")) U IO G ^AQAOPR71
 K IO("Q") S ZTRTN="^AQAOPR71",ZTDESC="REVIEWED OCC RPRT"
 F I="AQAOTP","AQAOBD","AQAOED","AQAOO(","AQAOSTAT" S ZTSAVE(I)=""
 S ZTSAVE("^TMP(""AQAOPR7"",$J,")=""
 S:$D(AQAODLM) ZTSAVE("AQAODLM")=""
 D ^%ZTLOAD K ZTSK D ^%ZISC D KILL^AQAOUTIL Q
 ;
END ; >>> eoj
 D HOME^%ZIS D KILL^AQAOUTIL K ^TMP("AQAOPR7",$J) Q
