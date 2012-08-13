INHPOST ; FRW,JSH ; 13 Sep 1999 15:23;Interface - PostInit routine
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
POST ;Post-init for GIS subsystem
 ;
 S X="ERR^INHPOST",@^%ZOSF("TRAP")
 ; Set FILEMAN environment
 D ENV^UTIL
 W !!,"Running Generic Interface Post-Init..."
 ;Set up Interface Site Parameter file
 D SPAR
 ;Set up Interface Operating System file
 D OS
 ;Set up format controller & output controller
 D CONT
 ;Generate & compile scripts
 D GENERAU
 ;Run 4.5 to 4.6 conversion
 D CONV46
 ;Restore env data
 D RESTORE
 Q
 ;
RESTORE ;Rstore site specific control file data
 N DATE,INTITLE
 S INTITLE="4604 Inst"
 S DATE=$O(^UTILITY("INSAVE",INTITLE,"A"),-1)
 I 'DATE W !!,"No GIS site specifc data found to restore!",!! Q
 I '$$RESTORE^INHSYSUL(INTITLE,DATE) W !!,"NOTE: Exceptions in restoring GIS Site specific fields.",!!
 Q
SPAR ;Site Paramter file (#4002)
 Q:$D(^INRHSITE(1,0))#2
 N DA,DIC,DIK,Y,X
 I '($D(^XMB(1,1,0))#2) W *7,!!,"WARNING!  The KERNEL SITE PARAMTER file does not have an entry number 1.","The Interface Site Parameter file will be set up anyway.",!!
 S ^INRHSITE(1,0)=1,DA=1,DIK="^INRHSITE(" D IX1^DIK
 S $P(^INRHSITE(0),U,3,4)="1^1"
 ;Populate required fields
 ;Output controller hang time
 S $P(^INRHSITE(1,0),U,4)=2
 ;Format controller hang time
 S $P(^INRHSITE(1,0),U,5)=2
 ;Max number of output jobs
 S $P(^INRHSITE(1,0),U,7)=5
 ;Hang after starting a job
 S $P(^INRHSITE(1,0),U,9)=1
 ;Max number of formatter jobs
 S $P(^INRHSITE(1,0),U,10)=5
 ;Variable storage
 S $P(^INRHSITE(1,0),U,12)=0
 ;Minutes to be current
 S $P(^INRHSITE(1,0),U,13)=120
 ;$S for variable overflow
 S $P(^INRHSITE(1,0),U,14)=15000
 ;Code to build user variables
 S ^INRHSITE(1,1)="D DVARS^XQ1"
 ;Output controller mode
 S $P(^INRHSITE(1,2),U,1)=1
 ;Output server wait time
 S $P(^INRHSITE(1,2),U,2)=600
 ;Format controller mode
 S $P(^INRHSITE(1,2),U,3)=1
 ;Format server wait time
 S $P(^INRHSITE(1,2),U,4)=600
 ;Default retry rate
 S $P(^INRHSITE(1,0),U,3)="5M"
 ;Default max number of attempts
 S $P(^INRHSITE(1,0),U,2)=2
 ;UIF/error retention days
 S $P(^INRHSITE(1,0),U,11)=15
 ;Message ID prefix
 S X="",Y=+$G(^DD("SITE",1)) I Y S Y=$P($G(^DIC(4,Y,8000)),U,1) I $L(Y) S Y=Y_"-",X=Y
 S $P(^INRHSITE(1,0),U,8)=X
 ;
 S DA=1,DIK="^INRHSITE(" D IX1^DIK
 ;
 Q
 ;
OS ;Operating System file (4002.1)
 Q:$D(^INTHOS(1,0))#2
 N DA,DIC,DIK,Y,X
 S INOS=+$G(^DD("OS"))
 I 'INOS D
 .  W *7,!!,"WARNING!  Unable to detemine the type of MUMPS operating system you are using.",!!
 .  F  D  Q:+Y>0
 ..    S DIC(0)="AEMNQ",DIC="^DD(""OS""," D ^DIC S INOS=+Y
 ..    I +Y<0 W *7,!!,"Please select the MUMPS operating system you are using!",!
 S ^INTHOS(1,0)=INOS,DA=1,DIK="^INTHOS(" D IX1^DIK
 S $P(^INTHOS(0),U,3,4)="1^1"
 ;Populate required fields
 S ^INTHOS(1,1)="J *"
 S ^INTHOS(1,2)="D TMENV^%ZTOS"
 S ^INTHOS(1,3)="D ^%ET"
 Q
 ;
CONT ;Set up format controller & output controller
 ;Build the Output Controller and Format Controller entries in the
 ;  Background Process Control file (#4004)
 N G,DIK,DA
 S G=^DIC(4004,0,"GL")
 I '$D(^INTHPC(1,0)) K ^INTHPC(1) S ^INTHPC(1,0)="OUTPUT CONTROLLER^1",^("ROU")="INHOTM",DIK=G,DA=1 D IX1^DIK W !?5,"Output Controller created."
 I '$D(^INTHPC(2,0)) K ^INTHPC(2) S ^INTHPC(2,0)="FORMAT CONTROLLER^1",^("ROU")="INHFTM",DIK=G,DA=2 D IX1^DIK W !?5,"Format Controller created."
 S (%,I)=0 F  Q:'$O(^INTHPC(I))  S %=%+1,I=$O(^INTHPC(I))
 S $P(^INTHPC(0),U,3,4)=I_"^"_%
 ;
 Q
 ;
GENER ;Generate & compile scripts
 ;
 W !!
 S X=$$YN^UTSRD("Do you want to regenerate all messages? ;1","") D:X ALL^INHSGZ
 W !!
 S X=$$YN^UTSRD("Do you want to recompile all scripts? ;1","") D:X RECOMP^INHSZ
 Q
 ;
CONV46 ;Convert 4.5 to 4.6
 Q
CONV45 ;Convert 4.4 to 4.5
 Q
 N DA,I,INDT I $O(^INLHFTSK(0)) D
 . W !,"Converting FORMAT CONTROLLER queue - ^INLHFTSK - from version 4.4 to 4.5",!
 . L +^INLHFTSK K ^INLHFTSK(-1)
 . S DA=0 F  S DA=$O(^INLHFTSK(DA)) Q:'DA  D
 . . I $D(^INLHFTSK(DA,0))>10 M ^INLHFTSK(DA,2)=^INLHFTSK(DA,0) S ^INLHFTSK(DA,2)=""
 W !,"Converting SITE PARAMETERS - ^INRHSITE - from version 4.4 to 4.5"
 L -^INLHFTSK,+^INRHSITE S DA=^INRHSITE(1,0) F I=7,10 S INDT=$P(DA,U,I) I INDT<3 S $P(DA,U,I)=3
 S ^INRHSITE(1,0)=DA L -^INRHSITE
 Q
GENERAU ;Generate & compile scripts automatically
 W !! D ALLAUTO^INHSGZ
 Q
 ;
