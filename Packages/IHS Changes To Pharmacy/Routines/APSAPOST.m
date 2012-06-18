APSAPOST ;IHS/DSD/ENM - ADD AWP OPTIONS ; 5/6/94 [ 03/13/98  8:58 AM ]
 ;;6.1;IHS PHARMACY AWP;;03/13/98
CHK W !! I $G(^DD(52,0,"VR"))<6 W !!,*7,"Version 6.0 must be installed before running this routine." G EX
 W !!,"Installing APSA AWP AUTO QUEUE and APSA AWP MANUAL UPDATE options!",!!!,?30,"N O T I C E ! ! ",!!!,"OPTIONS.......",!
 W !,"'APSA AWP AUTO QUEUE' will be added to the 'PSO AUTOQUEUE JOBS' option."
 W !,"'APSA AWP MANUAL UPDATE' will be added to your 'PSO MAINTENANCE' menu.",! H 5
 D A1,A2
 D ZNDC^APSAWP2 ;RE-INDEX THE ZNDC XREF IN THE DRUG FILE
 W !!,"Installation Complete!!",!
 Q
 ;
A1 S DA=$O(^DIC(19,"B","APSA AWP AUTO QUEUE",0)) G:'DA OPTION
 W !,*7,*7,"The 'APSA AWP AUTO QUEUE' option has already been installed."
 Q
A2 S DA=$O(^DIC(19,"B","APSA AWP MANUAL UPDATE",0)) G:'DA OPTION1
 W !,*7,*7,"The 'APSA AWP MANUAL UPDATE' option has already been installed." G EX
OPTION S DIC="^DIC(19,",DIC(0)="MZ",X="APSA AWP AUTO QUEUE",DIC("DR")="1///AWP Auto Queue;4///R;25///EP^APSAWP2;1.1///AWP AUTO QUEUE"
 K DD,DO D FILE^DICN K DIC
 S DA=+Y,APSADA=+Y,^DIC(19,DA,1,0)="^^4^4^2980122^^^^",^DIC(19,DA,1,1,0)="This option will check for new Medi-Span AWP data in your AWP Med-Trans File"
 S ^DIC(19,DA,1,2,0)="and automatically update your local drug file with AWP pricing data."
 S ^DIC(19,DA,1,3,0)="It will also send a mail message to your pharmacy supervisor for any"
 S ^DIC(19,DA,1,4,0)="active drugs that couldn't be updated."
 W !,"Option 'AWP AUTO QUEUE' installed!"
PATH ;SETUP OPTION IN OPTION SCHEDULING FILE 19.2
 S DA=$O(^DIC(19.2,"B",APSADA,0)) G:'DA OPTX
 W !,*7,*7,"The 'APSA AWP AUTO QUEUE' option has already been installed in the Opt Scheduling file."
 Q
OPTX ;
 S DIC="^DIC(19.2,",DIC(0)="MZ",X=APSADA,DIC("DR")="6///24H"
 K DD,DO D FILE^DICN K DIC
 W !,*7,*7,"The 'APSA AWP AUTO QUEUE' option has been added to the OPTION SCHEDULING FILE.",!!,"Note: Please advise the Pharmacy Manager to set the 'Queued to Run Time'"
 W !,"       located in the 'PSO MAINTENANCE' (Queue Background Jobs) option.",!!
 H 5
 K APSADA
 Q
OPTION1 S DIC="^DIC(19,",DIC(0)="MZ",X="APSA AWP MANUAL UPDATE",DIC("DR")="1///AWP Manual Update;4///R;25///MANU^APSAWP2;1.1///AWP MANUAL UPDATE"
 K DD,DO D FILE^DICN K DIC
 S DA=+Y,^DIC(19,DA,1,0)="^^3^3^2980122^^^^",^DIC(19,DA,1,1,0)="This option will allow you to manually rerun the Medi-Span AWP update"
 S ^DIC(19,DA,1,2,0)="and automatically update your local drug file with AWP pricing data.",^DIC(19,DA,1,3,0)="It will also send a mail message to your pharmacy supervisor for any active drugs that couldn't be updated."
 W !,"Option 'AWP MANUAL UPDATE' installed!"
 D MENU
 Q
MENU S DA(1)=$O(^DIC(19,"B","PSO MAINTENANCE",0))
 I 'DA(1) W !!,*7,*7,"*** The 'APSA AWP AUTO QUEUE' option has not been added to the PSO MAINTENANCE menu",!,"    because the PSO MAINTENANCE menu does not exist on your system. Install"
 I  W !,"    the PSO MAINTENANCE menu then rerun this routine again." G EX
 S THERE=$O(^DIC(19,DA(1),10,"B",DA,0))
 I THERE W !,*7,*7,"The AWP MANUAL UPDATE option has already been added to the PSO MAINTENANCE menu.",!!,"Finished!",! G EX
 S X=DA,DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="MZ" S:'$D(^DIC(19,DA(1),10,0)) ^DIC(19,DA(1),10,0)="^19.01IP^^" K DD,DO D FILE^DICN K DIC
 S $P(^DIC(19,DA(1),10,+Y,0),"^",2)="AWPM" ;SET SYNONYM
 W !,"Option added to PSO MAINTENANCE menu!"
 Q
EX K DA,THERE,X,Y Q
