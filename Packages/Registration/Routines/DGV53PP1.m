DGV53PP1 ;MAF/ALB - PARAMETER CHECK AND UPDATE FOR IRT. - APR 2 1993@1100
 ;;5.3;Registration;;Aug 13, 1993
 ;
 ;
EN W !,">>> Checking IRT parameters needed for IRT conversion in the post-init!",!!
 I '$D(^VAS(393,0)) D NOCON G Q
 S DGJTDV=0 F  S DGJTDV=$O(^DG(40.8,DGJTDV)) Q:DGJTDV']""!(+DGJTDV=0)  I $D(^DG(40.8,DGJTDV,0)) I $D(^DG(40.8,DGJTDV,"DT")) D LIST
 I $D(^UTILITY("VAS",$J)) W !,"***The following parameters need to be updated before the IRT conversion will run in the post-init." D PRT,MSG,OKD1
 I '$D(^UTILITY("VAS",$J)) W !!!,"***ALL IRT PARAMETERS ARE UPDATED!"
Q K %,DIC,DIE,DR,DA,DGJTNODE,DGJTADM,DGJATT,DGJPRIM,DGJRES,DGJT,DGJTPAR,DGJTPHDE,DGJSTAT,DGJTDV,DGJDV,DGJDTN,DGJFSIG,DGJY,DGJMSG,DGPGM,IFN,POP,X,^UTILITY("VAS",$J)  Q
LIST S X=^DG(40.8,+DGJTDV,"DT") I $P(X,"^",2)']"" S $P(^UTILITY("VAS",$J,$P(^DG(40.8,DGJTDV,0),"^",1)),"^",1)="DEFAULT PRIMARY PHYSICIAN"
 I $P(X,"^",3)']"" S $P(^UTILITY("VAS",$J,$P(^DG(40.8,DGJTDV,0),"^",1)),"^",2)="ARE REPORTS REVIEWED?"
 I $P(X,"^",3)=1,$P(X,"^",4)']"" S $P(^UTILITY("VAS",$J,$P(^DG(40.8,DGJTDV,0),"^",1)),"^",3)="DEFAULT REVIEWING PHYSICIAN"
 I $P(X,"^",10)']"" S $P(^UTILITY("VAS",$J,$P(^DG(40.8,DGJTDV,0),"^",1)),"^",4)="DEFAULT PHYS. FOR SIGNATURE"
 Q
PRT S DGJTDV=0 F  S DGJTDV=$O(^UTILITY("VAS",$J,DGJTDV)) Q:DGJTDV']""  I $D(^UTILITY("VAS",$J,DGJTDV)) S DGJTNODE=^UTILITY("VAS",$J,DGJTDV) D WRITE
 Q
WRITE W !!,"DIVISION: "_DGJTDV
 I $P(DGJTNODE,"^",1)]"" W !?5,$P(DGJTNODE,"^",1),?32,"     Choices: Primary or Attending Physician"
 I $P(DGJTNODE,"^",2)]"" W !?5,$P(DGJTNODE,"^",2),?34,"   Choices: Yes or No",!?10,"If 'YES' the parameter DEFAULT REVIEWING PHYSICIAN will also be asked",!?32,"     Choices: Primary or Attending Physician"
 I $P(DGJTNODE,"^",3)]"" W !?5,$P(DGJTNODE,"^",3),?32,"     Choices: Primary or Attending Physician"
 I $P(DGJTNODE,"^",4)]"" W !?5,$P(DGJTNODE,"^",4),"     Choices: Primary or Attending Physician"
 Q
MSG W !!!,"***PLEASE CONTACT YOUR MAS OFFICE IF YOU HAVE ANY QUESTIONS AS TO HOW THE",!,"IRT PARAMETERS SHOULD BE ANSWERED!"
 Q
OKD1 S %=2 W !!,"DO YOU WISH TO CONTINUE WITH THE INSTALLATION? " D YN^DICN I '% D YN G OKD1
 I %=1 W !!,"THE INSTALLATION WILL CONTINUE BUT, THE IRT CONVERSION WILL NOT RUN!!!" Q
 I %=2 K DIFQ Q
 Q
YN W !?10,"Choose:",!?25,"Y for YES",!?25,"N for NO",! Q
NOCON  W !!!,"***THIS SITE IS NOT USING THE IRT PACKAGE. PARAMETERS NEED NOT BE UPDATED AND    THE IRT CONVERSION WILL NOT RUN IN THE POST-INIT.***",!! Q
