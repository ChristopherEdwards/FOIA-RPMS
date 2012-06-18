BSDB ; IHS/ANMC/LJF - SET UP A CLINIC VIA SCREENMAN ;
 ;;5.3;PIMS;**1009,1010**;APR 26, 2002
 ;
 ;cmi/anch/maw 10/20/2008 PATCH 1010 added INST which is called from DATA VALIDATION of the DIVISION field of the BSD SET UP CLINIC form
 ;
SETUP(BSDDA) ;EP; clinic setup
 ; called by ^SDB
 ;
 ; -- if no entry in Clinic Setup Parameters file, add one
 NEW DA,DIC,DDR,DLAYGO,BSDERR
 I '$D(^BSDSC(BSDDA)) D  I $G(BSDERR) D MSG^BDGF(BSDERR) Q
 . K DD,DO S DIC="^BSDSC(",DLAYGO=9009017.2,DIC(0)="L"
 . S (X,DINUM)=BSDDA D FILE^DICN
 . I Y=-1 S BSDERR="Adding to IHS file failed; contact supervisor."
 ;
 ; -- if new clinic, ask length of appt up front
 I '$G(^SC(BSDDA,"SL")) D
 . S DIE=44,DA=BSDDA,DR="1912" D ^DIE
 ;
 ; -- call ScreenMan to add/edit parameters
 S DDSFILE=9009017.2,DA=BSDDA,DR="[BSD SET UP CLINIC]" D ^DDS
 K DDSFILE,DR
 Q
 ;
HELP1 ;EP; called by HLPD^SDB1 for help on AVAILABILITY DATE
 W !!?5,"For each day of the week that this clinic meets, enter the"
 W !?5,"FIRST date available.  You will then be asked for the range"
 W !?5,"of appointment times and the number of slots per appointment."
 W !?5,"If you enter a date that has already been set up, you will"
 W !?5,"be changing its appointment schedule.  BE CAREFUL!",!
 Q
 ;
INST(DA,BSDX) ;-- stuff the institution of the division in the HOSPITAL LOCATION file from the DIVISION selected in Set Up A Clinic
 N BSDINST
 S BSDINST=$P($G(^DG(40.8,BSDX,0)),U,7)
 S DIE="^SC(",DR="3////"_$G(BSDINST)
 D ^DIE
 K DIE
 Q
 ;
