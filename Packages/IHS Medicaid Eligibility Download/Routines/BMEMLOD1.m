BMEMLOD1 ; IHS/PHXAO/TMJ - LOAD THE MEDICAID TAPE ; 
 ;;1.0T1;MEDICAID ELIGIBILITY DOWNLOAD;;JUN 25, 2003
 ;
 ;This routine is a Main Driver (Currently NOT USED)
 ;The purpose was for User Interface and TaskMan Usage
 ;The program currently utilizes AZAMLOAD which simply runs AZAGMED,AZAMED,AZAMFALL
 ;
MAIN ; -- this is the main program loop    
 K S,T,T1,GET,TM
 D CTRM Q:S
 ;D CTM Q:TM
 D ^AZAMWRN
 D ASKB Q:'T1  Q:$D(DIRUT)
 D ASKA Q:'T  Q:$D(DIRUT)
 D LOOP,END
 Q
 ;
CTRM ; -- check the terminal to make sure it's not a LAT device    
 S S=0
 ;I $V(2*$P+$V(5,-5),-3,2)/4+$V(272,-4)=$J,$ZB($V($V($P*4+$V(7,-5))+20,-3,4),#10000000,1) D  
 . W !!,"You are logged into a LAT device."
 . W !,"Please log into a UNIX device to run this!!"
 . H 2
 . S S=1
 Q
 ;
CTM ; -- check to make sure this is after hours (after 4:00pm)
 S TM=0
 N % D NOW^%DTC S NW=$E($P(%,".",2),1,4)
 ;I NW<1600 D
 . W !!!,"This can only be started between the hours of 4pm and 12am!!"
 . S TM=1
 . H 2
 Q
ASKA ; -- ask if they are sure
 W !,"The file is now ready to upload"
 W !,"Running this process will delete the old exception file",!
 N X,Y,DIR S DIR(0)="Y",DIR("A")="Are you sure wish to continue "
 S DIR("B")="Y" D ^DIR S T=Y Q:$D(DIRUT)  K DIR
 Q
 ;
ASKB ; -- ask about current medicaid file
 W !,"I will now get the most current file from the Area Office",!
 N X,Y,DIR S DIR(0)="Y",DIR("B")="Y"
 S DIR("A")="Do you wish to continue "
 D ^DIR S T1=Y Q:$D(DIRUT)  K DIR
 I T1 D
 . S GET="/usr/spool/uucppublic/MED0606401.0299"
 . W !,"Getting the most current file from area now..."
 . W !,"This could take up to 5 minutes, please stand by..."
 . S X=$$TERMINAL^%HOSTCMD(GET)
 . W !,"The file is now here!!"
 Q
 ;
LOOP ; -- this is the actual process    
 W !,"Now loading the State of Arizona Medicaid File....."
 W !!,"This process could take up to 8 hours, please QUE to run after 6pm."
 K IO("Q")
 S ZTRTN="TASK^AZAMLOAD",ZTDESC="Load Medicaid Tape",ZTIO=""
 D ^%ZTLOAD K ZTSK
 ;D TASK^AZAMLOAD
 Q
TASK ;
 ;S $ZT="^%ET"  ;IHS/ANMC/FBD-2/3/98-DEBUG
 ;UNCOMMENT THE FOLLOWING ON DECEMBER 1, 1995
 D ^AZAGMED,^AZAMED
 ;D ^AZAMED
 Q
 ;
 ;D ^AZAGMED
 ;W !!,"Finished loading the State of Arizona Medicaid File"
 ;W !!,"Now uploading the State information into the RPMS database..."
 ;D ^AZAMED
 ;Q
 ;
END ; -- write the final message
 ;W !!,"Finished, uploading the medicaid information into RPMS"
 ;W !!,"The new information is in the RPMS database"
 Q
