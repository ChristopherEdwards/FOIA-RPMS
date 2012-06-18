DWCNST01 ;NEW PROGRAM [ 06/20/97  2:49 PM ]
 ;WRITTEN BY DAN WALZ PIMC TO MAKE A CLINICAL CONSULTATION REQUEST
 ;
 I '$D(DUZ) W !,"DUZ not set ABORTING..." H 3 Q
 I '$D(^VA(200,DUZ,0)) W "Unable to verify user. ABORTING..." H 3 Q
 S USR=$P(^VA(200,DUZ,0),"^",1)
 D ^DWSETSCR
 F II=0:0 D ^%AUCLS,HEAD,REG S:'$D(%) %=1 Q:%'=1
 K II,DIC,DIE,Y,DR,RS,%,USR,IOP,DWDFN,DA,DWDIE,DWDA,RQSV,RSS,IMI,EXUSERN
 D KILL^DWSETSCR
 Q
 ;
REG K XIT W "Do you want to request a consultation (Y/N)" K % D YN^DICN
 I %'=1 Q
 S DIC="^DWCNST01(",DIC(0)="L" D NOW^%DTC S X=% K DD,DO L ^DWCNST01 D FILE^DICN L  ;lock global while adding entry then unlock
 I Y<0 W !!,BLK_HI_"Sorry unable to accept your request - NOTHING DONE..."_NO,!!,"Press <Return> to Continue..." R RS:60 K RS Q
 S DWDFN=+Y
 S DR="3///^S X="_""""_"R"_""""_";15///^S X=USR;20///^S X="_""""_"N"_""""
 S DIE=DIC,DA=DWDFN,DWDIE=DIE,DWDA=DA K DIC D ^DIE
EDIT W !!,HI_"Please respond to all prompts unless marked (optional)."_NO,!
 S DR="8PATIENT associated with this consult" D ^DIE
 I $D(Y)!($D(DTOUT)) D KILQT Q  ;kill node and exit if ^ or timeout
 ;
RQSV ;;W !,HI_"Enter requested service:"_NO
 S DR="1SERVICE to which consult is directed" D ^DIE
 I $D(Y)!($D(DTOUT)) D KILQT Q  ;kill node and exit if ^ or timeout
 D EXTRA ;use this line to display other providers from ^DWCNST03
 S DR="19Name of PROVIDER to whom consult is directed (optional)" D ^DIE
 I $D(Y)!($D(DTOUT)) D KILQT Q  ;kill node and exit if ^ or timeout
 I $D(^DWCNST01(DWDFN,4)) I $P(^(4),"^",8)]"" I +^VA(200,+$P(^(4),"^",8),5)'=+$P(^DWCNST01(DWDFN,0),"^",2) W $C(7),!,HI_"Requested Consultant is not a member of the selected service. Ok"_NO S %=2 D YN^DICN I %'=1 K % G RQSV
 ;
FRSV ;;W !,HI_"Enter service making request:"_NO
 S DR="2SERVICE making the consult request;4R~Name of provider making request" D ^DIE
 I $D(Y)!($D(DTOUT)) D KILQT Q  ;kill node and exit if ^ or timeout
 I $D(^DWCNST01(DWDFN,0)) I $P(^(0),"^",5)]"" I +^VA(200,+$P(^(0),"^",5),5)'=+$P(^DWCNST01(DWDFN,0),"^",3) W $C(7),!,HI_"Consultant making request is not a member of the selected service. Ok"_NO S %=2 D YN^DICN I %'=1 K % G FRSV
 ;
PDX S DR="5Enter Provisional Diagnosis (optional)" D ^DIE
 I $D(Y)!($D(DTOUT)) D KILQT Q  ;kill node and exit if ^ or timeout
 ;;I '$D(^DWCNST01(DWDFN,1)) W !,HI_"Sorry you must enter a provisional diagnosis!"_NO G PDX 
RR S DR="6Enter the REASON for the CONSULT Request (Required)" D ^DIE
 I $D(Y)!($D(DTOUT)) D KILQT Q  ;kill node and exit if ^ or timeout
 I '$D(^DWCNST01(DWDFN,2)) W !,HI_"Sorry you must enter a reason for the request!"_NO G RR 
 D VERIFY
 I $D(XIT) W !!,"Do you want to EDIT the Request" S %=1 D YN^DICN I %=1 K XIT D EDIT
 I $D(XIT) W !!,"Do you want to DELETE this Request" S %=2 D YN^DICN I %=1 D KILQT Q
 D PRT ;do print here
 Q
 ;delete entry if user ^ out
KILQT S DR=".01///@",DA=DWDFN
 D ^DIE
 W !!,HI_"Request ABORTED.  Nothing Done..."_NO,!!,"Press <Return> to Continue..." R RS:60 K RS
 Q
PRT W !!,"Do want to print the Consultation Request" S %=1 D YN^DICN Q:%'=1
 K IOP
 I '$D(^DWCNST01(DWDFN,0)) W !!,HI_"SORRY UNABLE TO SEND YOUR PRINT REQUEST - ABORTING"_NO H 3 Q
 S FLDS="[1966180-FINAL]"
 S DIC=1966180,L=0,BY="NUMBER",FR=DWDFN,TO=DWDFN
 D EN1^DIP
 Q
VERIFY K XIT I '$D(^DWCNST01(DWDFN,0)) W !!,HI_"SORRY UNABLE VERIFY YOU ENTRY - ABORTING"_NO H 3 S XIT="" Q
 S FLDS="[1966180-REQUEST]"
 S DIC=1966180,L=0,BY="NUMBER",FR=DWDFN,TO=DWDFN
 S IOP=0 D EN1^DIP
 W !,HI_"Is this correct" S %=1 D YN^DICN W NO
 I %'=1 S XIT="",DIE=DWDIE,DA=DWDA Q
 Q
 ;
HEAD W ?26,HI_"*****************************",!,?26,"*",?54,"*",!,?26,"* PIMC CONSULTATION REQUEST *",!,?26,"*",?54,"*",!,?26,"*",?34,"Enter Request",?54,"*",!,?26,"*",?54,"*",!,?26,"*****************************"_NO,!!!
 Q         
EXTRA I '$D(^DWCNST01(DWDFN,0)) Q
 S RQSV=+$P(^(0),"^",2) Q:RQSV=0
 I '$D(^DWCNST03("C",RQSV)) Q
 D WRTHD
 S RSS=0 F IMI=0:0 S RSS=+$O(^DWCNST03("C",RQSV,RSS)) Q:RSS=0  D EXTRAPRT
 Q
EXTRAPRT I $D(^DWCNST03(RSS,0)) S EXUSERN=+$P(^(0),"^",1) Q:EXUSERN=0
 I $D(^VA(200,EXUSERN,0)) W !,?15,$P(^(0),"^",1)
 Q
WRTHD W !,HI_"The following are also accepting consults for this service:"_NO
 Q
