BNPOST ;IHS/OIT/ENM - ADD BNP QUEUE OPTION
 ;;1.0;NATIONAL SITE TRACKING SYSTEM;;07/31/2009
CHK ;EP
 W !!,"Installing BNP AUTO QUEUE option!",!
 W !,"'BNP AUTO QUEUE' will be added to the 'Option File & the Option Scheduling File",! H 5
 D A1
 W !!,"BNP Auto Queue Option Installation Complete!!",!
 Q
 ;
A1 S DA=$O(^DIC(19,"B","BNP AUTO QUEUE",0)) G:'DA OPTION
 W !,*7,*7,"The 'BNP AUTO QUEUE' option has already been installed."
 Q
OPTION S DIC="^DIC(19,",DIC(0)="MZ",X="BNP AUTO QUEUE",DIC("DR")="1///BNP Auto Queue;4///R;25///BNPENV;1.1///BNP AUTO QUEUE"
 K DD,DO D FILE^DICN K DIC
 S DA=+Y,BNPDA=+Y,^DIC(19,DA,1,0)="^^4^4^3090715^^^^",^DIC(19,DA,1,1,0)="This option will loop through the Package file for RPMS package"
 S ^DIC(19,DA,1,2,0)="information including the package name, date installed, namespace,"
 S ^DIC(19,DA,1,3,0)="current version, last patch installed and the date the patch was installed"
 S ^DIC(19,DA,1,4,0)="Also, other information is captured including Operating System data."
 W !,"Option 'BNP AUTO QUEUE' installed!"
PATH ;SETUP OPTION IN OPTION SCHEDULING FILE 19.2
 S DA=$O(^DIC(19.2,"B",BNPDA,0)) G:'DA OPTX
 W !,*7,*7,"The 'BNP AUTO QUEUE' option has already been installed in the Opt Scheduling file."
 Q
OPTX ;
 S DIC="^DIC(19.2,",DIC(0)="MZ",X=BNPDA,DIC("DR")="2///T@1900;6///24H"
 K DD,DO D FILE^DICN K DIC
 W !,*7,*7,"The 'BNP AUTO QUEUE' option has been added to the OPTION SCHEDULING FILE.",!!,"Note: Please manually set the 'Queued to Run Time'"
 W !,"in the Option Scheduling File, thanks!",!
 H 5
 K BNPDA
 Q
EX K DA,X,Y Q
OPTZAP ;EP - REMOVE OPTION FROM OPTION FILE
 ;USED ONLY DURING TESTING
 W !,"Removing old Options......",! S DIK="^DIC(19,"
 S OPT="BNP AUTO QUEUE"
 S DA=$O(^DIC(19,"B",OPT,0)) I DA D ^DIK W !,OPT_" Menu Option...<DELETED>"
 Q
