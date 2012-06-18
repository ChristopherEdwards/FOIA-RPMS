AQAOPAR ; IHS/ORDC/LJF - ADD ENTRY TO QI PARAMETER FILE ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains 2 entry points; one for adding a new facility entry
 ;to the QI Parameter file and the other for editing the RPMS linkages
 ;for each facility.
 ;
SITE ; >>> ask user for facility name
 W !! K DIC S DIC="^AUTTLOC(",DIC(0)="AEMZQ"
 S DIC("A")="Select QI FACILITY NAME:  " D ^DIC
 G EXIT:$D(DTOUT),EXIT:$D(DUOUT),EXIT:X="",SITE:Y=-1 S AQAOFAC=+Y
 I $D(^AQAGP(AQAOFAC)) D  G SITE
 .W !!,"This facility is ALREADY set up in the QI Parameter file!!"
 ;
SURE ; >>> ask user if he is sure he wants to add this facility
 W !! K DIR,DIC S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Okay to ADD this facility to the QI PARAMETER file"
 S DIR("?",1)="Answer YES to create an entry in the QI Parameter file"
 S DIR("?",2)="for the facility you selected.  Answer NO to select "
 S DIR("?")="another facility."
 D ^DIR G EXIT:$D(DIRUT),SITE:Y=0
 ;
ADD ; >>> set variables and call file^dicn
 W !! K DD,DO,DIC,DIR S DLAYGO=9002166,DIC="^AQAGP(",DIC(0)="L"
 S (DINUM,X)=AQAOFAC,DIC("DR")="[AQAO PARAM ADD]"
 L +(^AQAGP(0)):1 I '$T D  G EXIT
 .W !!,"CANNOT ADD; ANOTHER USER ADDING TO THIS FILE. TRY AGAIN.",!
 D FILE^DICN L -(^AQAGP(0))
 W !!,"CREATING ENTRY . . ."
 I Y=-1 W !!,"**ERROR**  COULD NOT CREATE ENTRY IN FILE!" G EXIT
 W !!,"ENTRY CREATED!"
 W !!,"To ACTIVATE any of the automatic linkages, please use the option"
 W !,"titled EDIT PARAMETER LINKAGES and select the same facility."
 W !! G SITE
 ;
EXIT ; >>> eoj
 I $D(AQAOFAC) L -^AQAGP(AQAOFAC)
 D KILL^AQAOUTIL K ^UTILITY("DIQ1",$J)
 Q
 ;
 ;
EDIT ;ENTRY POINT for editing of qi parameter file
 ;called by option AQAO PKG PARAMETER LINK
 ;
MENU ; >>> ask user for facility to edit then which links
 I $D(AQAOFAC) L -^AQAGP(AQAOFAC)
 W !! K DIC S DIC="^AQAGP(",DIC(0)="AEMZQ"
 S DIC("A")="Select QI PARAMETER FACILITY:  " D ^DIC
 G EXIT:$D(DTOUT),EXIT:$D(DUOUT),EXIT:X="",MENU:Y=-1 S AQAOFAC=+Y
 L +^AQAGP(AQAOFAC):1 I '$T D  G EDIT
 .W !!,"CANNOT EDIT; ANOTHER USER IS EDITING THIS ENTRY. TRY AGAIN.",!
 ;
MENU1 W !!?5,"Select AUTOMATIC LINKAGES to EDIT . . .",!
 K DIC,DIR S DIR(0)="LO^1:8^K:X#1 X"
 S DIR("A")="Choose ONE or MORE to Edit"
 S AQAOC=0 F I=1001:10:1071 D
 .S X=$P(^AQAGP(AQAOFAC,"ADT"),U,+$E(I,3,4)),AQAOC=AQAOC+1 ;status/cnt
 .S DIR("A",AQAOC)=AQAOC_") "_$P(^DD(9002166.4,I,0),U)
 .S Y=50-$L(DIR("A",AQAOC)),Z="",$P(Z," ",Y)=""
 .S DIR("A",AQAOC)="  "_DIR("A",AQAOC)_Z_$S(X=1:"[ON]",1:"[OFF]")
 S DIR("A",AQAOC+1)=" "
 D ^DIR G MENU:$D(DIRUT),MENU:Y=-1 S AQAORNG=Y
 ;
LOOP ; >>> loop thru links chosen and edit
 S AQAOI=+AQAORNG,AQAOI=10_(AQAOI-1)_1 ;get next link
 ;
 ; >> print status of link
 W !!!,"Current status of ",$P(^DD(9002166.4,AQAOI,0),U),":  "
 K ^UTILITY("DIQ1",$J)
 S DIC=9002166.4,DA=AQAOFAC,DR="" F I=0,1,3 S DR=DR_(AQAOI+I)_";"
 D EN^DIQ1 W ^UTILITY("DIQ1",$J,9002166.4,AQAOFAC,AQAOI)
 W !?11,"INDICATOR:  "
 W $S(^UTILITY("DIQ1",$J,9002166.4,AQAOFAC,AQAOI+1)="":"<NONE DEFINED>",1:^(AQAOI+1))
 W ?40,"OKAY TO DUPLICATE ON SAME DAY:  "
 W ^UTILITY("DIQ1",$J,9002166.4,AQAOFAC,AQAOI+3)
 ;
IND ; >> indicator edit
 W !! K DIR S DIR(0)="F^7:7",DIR("A")=$P(^DD(9002166.4,AQAOI+1,0),U)
 S DIR("?")="Enter INDICATOR #; Must be 7 characters long."
 S DIR("??")="^D INDQUES^AQAOPAR"
 S DIR("B")=$P(^AQAGP(AQAOFAC,"ADT"),U,+$E(AQAOI+1,3,4))
 K:DIR("B")="" DIR("B") D ^DIR
 G MENU:$D(DTOUT),RESET:$D(DUOUT)
 I '$D(^AQAO(2,"B",Y)) W !!,*7,"INDICATOR DOES NOT EXIST IN FILE!" G IND
 S Z=$O(^AQAO(2,"B",Y,0))
 I Z="" W !!,*7,"INDICATOR DOES NOT EXIST IN FILE!" G IND
 I $P(^AQAO(2,Z,0),U,6)'="A" W !!,*7,"INDICATOR INACTIVE!" G IND
 K DIE S DIE="^AQAGP(",DA=AQAOFAC,DR=(AQAOI+1)_"////"_Y D ^DIE
 ;
DUPOKAY ; >> ask user if dup entry okay for linkage
 K DIE,DIC S DIE="^AQAGP(",DA=AQAOFAC,DR=(AQAOI+3)_";"_AQAOI
 D ^DIE
 ;
SERVICES ; >> link services to this linkage
 I $P(^AQAGP(AQAOFAC,"ADT"),U,$E(AQAOI,3,4))=1 D CURRENT^AQAOPAR1
 ;
RESET ; >> reset to remaining links selected
 S AQAORNG=$P(AQAORNG,",",2,99)
 G MENU1:+AQAORNG=0 ;end of loop
 G LOOP ;otherwise continue looping thru range selected
 ;
 ;
INDQUES ;ENTRY POINT called by xecute help on indicator fields
 S DIC="^AQAO(2,",DIC(0)="EMZQ",D="B",DZ="??"
 D DQ^DICQ
 Q
 ;
 ;
DUPQUES ;ENTRY POINT called by xecute help on dupl okay? fields 
 W !!?5,"Answer YES to allow a duplicate event on the same day to "
 W !?5,"create another occurrence;  Answer NO to allow only ONE event"
 W !?5,"per day to be entered as an occurrence.",!!
 Q
 ;
 ;
LNKQUES ;ENTRY POINT called by xecute help on link fields
 W !!?5,"Answer ON to turn on the link;"
 W !?5,"Answer OFF to turn off the link.",!!
 Q
 ;
 ;
RICU ;ENTRY POINT called by xecute help on Return to ICU-# of days field
 W !!,"Enter the number of days between stays in ICU that you want"
 W !,"to track.  FOr example, to track all returns to ICU within 72"
 W !,"hours, enter 3 for three days.",!!
 Q
