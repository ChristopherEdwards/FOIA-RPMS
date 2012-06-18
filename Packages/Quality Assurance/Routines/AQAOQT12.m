AQAOQT12 ; IHS/ORDC/LJF - MULTIVOTING SUBRTNS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry point to handle the multivoting functions.
 ;
LIST ;ENTRY POINT: SUBRTN to list ideas entered for this meeting
 ;called by ^AQAOQT1
 I '$D(AQAOAR1) D GETLIST ;gather categories & ideas not categorized
 W @IOF
 W !,"CATEGORIZED IDEAS ENTERED FOR ",$P(^AQAO1(8,AQAOMTG,0),U,3),":",!
 S AQAOX=0,AQAOJ=1
MORE F AQAOI=AQAOJ:1:AQAOJ+12 S AQAOX=$O(AQAOAR1(AQAOX)) Q:AQAOX=""  D
 .W !?5,AQAOX_". "_$P(AQAOAR1(AQAOX),U)
 S AQAOJ=AQAOI+1 Q:AQAOX=""  ;end of list
 K DIR S DIR("A")="Press RETURN to continue or ""^"" to exit"
 S DIR(0)="E" D ^DIR G MORE:Y=1
 Q
 ;
 ;
VOTE ;ENTRY POINT: SUBRTN to enter votes of each participant
 ;called by ^AQAOQT1
 K AQAOAR2
 I '$D(AQAOAR1) D GETLIST ;gather categories to vote on
 W !!?20,"*** VOTING SESSION ***",!!
 K DIR S DIR(0)="NO^1:99",DIR("A")="How many VOTES per person"
 S DIR("?",1)="Please tell me how many VOTES each participant is "
 S DIR("?",2)="allowed to cast in this voting session."
 S DIR("?",3)="Each voter must cast ALL his/her votes for any of them"
 S DIR("?",4)="to be counted.",DIR("?",5)=" "
 S DIR("?")="Enter a number between 1 and 99." D ^DIR Q:$D(DIRUT)
 Q:Y=-1  S AQAOCNT=Y
 ;
VOTER ; >> ask for each voter in turn
 W !! K DIR S DIR(0)="FO^1:50",DIR("A")="Select VOTER"
 D ^DIR Q:$D(DIRUT)  G VOTER:Y=-1 S AQAOUSR=Y
 D POLL ;ask for votes
 G VOTER:'$D(AQAOAR2(AQAOUSR)) ;no votes to file
 ;
 ; >> file voting results for this voter
 S AQAOX=0,DIE="^AQAO1(7,"
 F  S AQAOX=$O(AQAOAR2(AQAOUSR,AQAOX)) Q:AQAOX=""  D
 .S AQAOIFN=$P(AQAOAR1(AQAOX),U,2) ;get ifn from category list
 .I '$D(^AQAO1(7,AQAOIFN,"MV",0)) S ^(0)="^9002169.71"
 .I '$O(^AQAO1(7,AQAOIFN,"MV","B",AQAOUSR,0)) D ADDVTR Q:Y=-1  ;add votr multpl
 .S DA=$O(^AQAO1(7,AQAOIFN,"MV","B",AQAOUSR,0)) Q:DA=""
 .S DIE="^AQAO1(7,"_AQAOIFN_",""MV"",",DA(1)=AQAOIFN
 .S DR=".02////"_AQAOAR2(AQAOUSR,AQAOX) D ^DIE ;file votes
 W !!,"VOTES FOR USER ",AQAOUSR," FILED..." G VOTER
 ;
 ;
ADDVTR ; >> SUBRTN to add voter multiple to category
 K DIC S DIC="^AQAO1(7,"_AQAOIFN_",""MV"",",DIC(0)="L",DA(1)=AQAOIFN
 S X=AQAOUSR,DIC("P")=$P(^DD(9002169.7,1,0),U,2) D ^DIC
 Q
 ;
 ;
GETLIST ; >> SUBRTN to gather categories and ideas not categorized
 K AQAOARR S AQAOX=0
 F  S AQAOX=$O(^AQAO1(7,"AC",AQAOMTG,AQAOX)) Q:AQAOX=""  D
 .Q:'$D(^AQAO1(7,AQAOX,0))  S AQAOS=^(0)
 .S AQAOY=$S($P(AQAOS,U,3)'="":$P(AQAOS,U,3),1:$P(AQAOS,U))
 .S AQAOARR(AQAOY)=AQAOX
 Q:'$D(AQAOARR)  ;no ideas entered
 S AQAOX=0
 F I=1:1 S AQAOX=$O(AQAOARR(AQAOX)) Q:AQAOX=""  D
 .S AQAOAR1(I)=AQAOX_U_AQAOARR(AQAOX) ;number categories
 Q
 ;
 ;
POLL ; >> SUBRTN to poll a participant
 K AQAOAR2(AQAOUSR) ;ARRAY(user,category # in AQAOAR1)=votes
CATEGORY ; >> ask participant to choose category to vote on
 W !!,"CHOICE OF CATEGORIES:",!
 K DIR S AQAOI=0,AQAOJ=1
LOOP F AQAOI=AQAOJ:1:AQAOJ+12 Q:'$D(AQAOAR1(AQAOI))  D
 .S DIR("A",AQAOI)=AQAOI_". "_$P(AQAOAR1(AQAOI),U)
 S DIR(0)="NO^1:"_(AQAOI-1),DIR("A")="Select CATEGORY"
 I $D(AQAOAR1(AQAOI+1)) S DIR("A")="Select CATEGORY (Press RETURN to see more)"
 D ^DIR
 I $D(AQAOAR1(AQAOI+1)) S AQAOJ=AQAOI+1 K DIR("A") G LOOP:X=""
 G CHECK:$D(DIRUT),CHECK:Y=-1 S AQAOCAT=Y
 ;
 ; >> ask for number of votes for this category
 W ! K DIR S DIR(0)="NO^0:"_AQAOCNT,DIR("A")="# OF VOTES" D ^DIR
 I Y=0 K AQAOAR2(AQAOUSR,AQAOCAT) ;deleting vote
 I Y>0 S AQAOAR2(AQAOUSR,AQAOCAT)=Y ;recording vote
 G CATEGORY ;return to vote on another category
 ;
 ;
CHECK ; >> display votes for this user and give options
 W @IOF,!!?20,"*** VOTING SUMMARY FOR ",AQAOUSR," ***",!
 I '$D(AQAOAR2(AQAOUSR)) W !!,"NO VOTES TAKEN" S AQAOZ=0 G CHOICE
 S (AQAOX,AQAOY)=0
 F  S AQAOX=$O(AQAOAR2(AQAOUSR,AQAOX)) Q:AQAOX=""  D
 .W !,$P(AQAOAR1(AQAOX),U),?40,AQAOAR2(AQAOUSR,AQAOX)
 .S AQAOY=AQAOY+AQAOAR2(AQAOUSR,AQAOX) ;count total votes for person
 W !?40,"____",!,"TOTAL VOTES CAST:",?40,AQAOY
 W ?60,$S(AQAOY=AQAOCNT:"",AQAOY>AQAOCNT:"OVER VOTED",1:"UNDER VOTED")
 ;
CHOICE ; >> give participant choice to revote or quit
 W !! K DIR S DIR("A")="Select CHOICE"
 I AQAOY=AQAOCNT S DIR(0)="S^1:REVOTE;2:QUIT & FILE RESULTS"
 E  S DIR(0)="S^1:REVOTE;2:QUIT, NO RESULTS FILED"
 S DIR("?",1)="You may now REVOTE or QUIT this round"
 S DIR("?",2)="If the votes cast MATCH the number you had to cast,"
 S DIR("?",3)="quitting will file your votes.  But if you cast MORE"
 S DIR("?",4)="than the allotted number or LESS than the allotted"
 S DIR("?",5)="number of votes, your votes will not be filed.  In those"
 S DIR("?",6)="please REVOTE!",DIR("?")="Make your choice now."
 D ^DIR G CATEGORY:$D(DIRUT),CHOICE:Y=-1,CATEGORY:Y=1
 I AQAOY'=AQAOCNT K AQAOAR2(AQAOUSR)
 Q
 ;
 ;
RESULTS ;ENTRY POINT: SUBRTN to pirnt multivoting results
 S AQAOPT1="RESULTS^AQAOQT13" D DEV^AQAOQT1 Q  ;set for results only
