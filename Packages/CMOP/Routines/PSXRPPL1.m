PSXRPPL1 ;BIR/WPB-Resets Suspense to Print/Transmit ;[ 10/02/97  3:13 PM ]
 ;;2.0;CMOP;**3**;11 Apr 97
 ;This routine will reset the Queued flags and the printed flags in
 ;PS(52.5 to 'Queued' and 'Printed' respectively and either retransmits
 ;the data to the CMOP or prints the labels.
START ;initializes local variables
 I '$D(^XUSEC("PSXCMOPMGR",DUZ)) W !,"You are not authorized to use this option!" Q
 I '$D(^XUSEC("PSX XMIT",DUZ)) W !,"You are not authorized to use this option!" Q
 S SWITCH=0
 K ^TMP($J,"PSX")
QRY ;initial message and option menu
 W !
 S DIR(0)="NAO^1:3:0",DIR("A")="Select (1, 2, 3):  ",DIR("A",1)="  1 - Reset CMOP Batches for Transmission"
 S DIR("A",2)="  2 - Reprint CMOP Batches",DIR("A",4)="  3 - Standard Reprint Batches from Suspense"
 S DIR("?")="Enter a number between 1 and 3.",DIR("??")=$S($G(PSXVER):"^D HELP^PSXSRP",1:"^D MSG2^PSXRHLP") D ^DIR K DIR G:(Y<0)!($D(DIRUT)) EXIT S REPLY=Y K Y,X
 I REPLY="1" S (PSXTRANS,PSXFLAG,SWITCH)=1 G:$G(PSXVER) ^PSXSRST G:'$G(PSXVER) BEGIN
 I REPLY="2" S (PSXTRANS,PSXFLAG,SWITCH)=2 G:$G(PSXVER) ^PSXSRST G:'$G(PSXVER) BEGIN
 I REPLY="3" S PSXFLG=1 G START^PSOSURST
 K REPLY
 Q
BEGIN ;confirms CMOP processing, if Yes, checks for active site and status
 ;in the CMOP System file, if not an active site or the system status
 ;is not stopped the routine exits and processing stops
 W !
 S DIR(0)="Y",DIR("B")="NO",DIR("A")="Are you sure you want to continue",DIR("?",1)="No - Exits."
 S DIR("?")=$S(SWITCH=1:"Yes - Transmits data to the CMOP.",SWITCH=2:"Yes - Prints labels.",1:0) D ^DIR K DIR G:(Y=0)!($D(DIRUT)) EXIT K Y
 S STATUS=$P($G(^PSX(550,+PSXSYS,0)),"^",3) I STATUS'="H" W !,"There is another job in process, please try again later." G EXIT
ASK ;gets date for the resets
 K BEGDATE,ENDDATE W !!,?10,$S($G(SWITCH)=1:"RESET and TRANSMIT CMOP DATA",$G(SWITCH)=2:"RESET and REPRINT CMOP LABELS",1:""),!!!,"**** Date Selection ****",!!
ASK1 I SWITCH=1 S %DT="AEX",%DT("A")="   BEGIN DATE:  " D ^%DT K %DT,%DT("A") G:Y<0 EXIT S PRTDT=Y
 I SWITCH=2 S %DT="AEX",%DT("A")="   BEGIN DATE:  " D ^%DT K %DT,%DT("A") G:Y<0 EXIT S PRTDT=Y
 W !! S %DT="AEX",%DT("A")="   ENDING DATE:  " D ^%DT Q:Y<0  S PSXDTRG=Y K %DT,%DT("A")
 I $G(PRTDT)>$G(PSXDTRG) W !,"Begin Date must be before Ending Date!" G ASK1
 I '$O(^PS(52.5,"AP",PRTDT-1))!($O(^(0))>PSXDTRG) W !!,$S(SWITCH=1:"Nothing to Transmit.",SWITCH=2:"Nothing to Reprint.",1:0) G EXIT
 D SDT S PSXERFLG=0
 I SWITCH=1 D PSXTRANS Q
 I SWITCH=2 D PRINT Q
 S PSXSTAT="H" D PSXSTAT^PSXRSYU
 G EXIT
PSXTRANS ;
 W !!
 S DIR(0)="Y",DIR("B")="YES",DIR("A")="DO YOU WISH TO TRANSMIT TO THE CMOP NOW",DIR("?",1)="No - Exits the option.",DIR("?")="Yes - Transmits to the CMOP." D ^DIR K DIR Q:(Y=0)!($D(DIRUT))  K Y
 S PSXSTAT="T" D PSXSTAT^PSXRSYU,ASK^PSXRSUS
 Q
PRINT ;
 W !!
 S DIR(0)="Y",DIR("B")="YES",DIR("A")="DO YOU WISH REPRINT CMOP LABELS NOW",DIR("?",1)="No - Exits the option.",DIR("?")="Yes - Reprints CMOP labels." D ^DIR K DIR Q:(Y=0)!($D(DIRUT))  K Y
 S PSXSTAT="T" D PSXSTAT^PSXRSYU,ASK^PSXRSUS
 Q
SDT ;the following subroutines go through the PS(52.5 global and pull the
 ;data needed to reset the Queued/Printed nodes
 S SDT=PRTDT-1 F  S SDT=$O(^PS(52.5,"AP",SDT)),DFN=0 Q:(SDT>PSXDTRG)!(SDT="")  D DFN
 Q
DFN ;
 F  S DFN=$O(^PS(52.5,"AP",SDT,DFN)),REC=0 Q:(DFN="")!(DFN'>0)  D REC
 Q
REC ;
 F  S REC=$O(^PS(52.5,"AP",SDT,DFN,REC)) Q:(REC'>0)!(REC="")  D:$G(^PS(52.5,REC,0)) CHECK
 K ZDIV
 Q
CHECK ;
 S STAT=$P($G(^PS(52.5,REC,0)),U,7),PRINT=$G(^PS(52.5,REC,"P")),PSXPTR=$P($G(^PS(52.5,REC,0)),U,1)
 S RXF="" F XXF=0:0 S XXF=$O(^PSRX(PSXPTR,1,XXF)) Q:XXF'>0  S RXF=XXF
 S ZDIV=$S($G(RXF)>0:$P($G(^PSRX(PSXPTR,1,RXF,0)),U,9),1:$P($G(^PSRX(PSXPTR,2)),U,9)) I $G(ZDIV)'=$G(PSOSITE) Q
 S:RXF'="" GONE=$P($G(^PSRX(PSXPTR,1,RXF,0)),U,18)
 S:RXF="" GONE=$P($G(^PSRX(PSXPTR,2)),U,13)
 I (STAT="P")&(PRINT=1)&($G(GONE)="") D RESET
 K GONE,RXF,XXF
 Q
RESET ;resets the Queued/Printed flags to Queued and not Printed
 L +^PS(52.5,REC):DTIME Q:'$T
 S DIE="^PS(52.5,",DA=REC,DR="2////2;3////Q" D ^DIE L -^PS(52.5,REC) K DIE,DR,DA
 S:$G(PSXVER) $P(^PSRX(PSXPTR,"STA"),U,1)=5 S:'$G(PSXVER) $P(^PSRX(PSXPTR,0),U,15)=5 K ^PS(52.5,"AC",DFN,SDT,REC)
 Q
EXIT ;
 K DFN,PSXDAYS,PSXDTRG,SWITCH,STAT,PRINT,PSXTRANS,REC,REPLY,SDT,X,X1,X2,Y,ANSWER,STATUS,PSXFLAG,PSXPTR,PSXSTAT
 K DIR,DIRUT,DTOUT,DUOUT,DIROUT
 Q
