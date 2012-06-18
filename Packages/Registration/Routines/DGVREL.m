DGVREL ;ALB/MRL - RELEASE QUESTIONAIRE ; 2 JUN 87
 ;;5.3;Registration;;Aug 13, 1993
 W !! D:'$D(DT) DT^DICRW S U="^",IOP="HOME" D ^%ZIS K IOP S:'$D(DTIME) DTIME=999 F I=1:1 S J=$P($T(C+I),";;",2) Q:J="QUIT"  W !,J
1 W !!,"ARE YOU READY TO ANSWER THIS QUESTIONNAIRE NOW" S %=2 D YN^DICN G Q:%=2,S:%=1 I '% W !!?4,"NO  - I'm not ready",!?4,"YES - I'm ready to answer your questions" G 1
Q K ^UTILITY($J),%,%H,C,DA,DGC,DGD,DGDOT,DGERR,DGF,DGF1,DGF2,DGFAC,DGFILE,DGH,DGHOW,DGHT,DGI,DGI1,DGH,DGM,DGMT,DGN,DGO,DGPGM,DGR,DGVREL,DGS,DGT,DGT1,DGVAR,DGX,DGX1,DIE,DR,I,J,J1,J2,X,X1,X2,X3,XMDUZ,XMSUB,XMTEXT,XMY,Y,Z
 D CLOSE^DGUTQ Q
S S DGVREL=$$REL^DGVPP() S:$D(^DG(48,DGVREL,0)) DGVRELSD=$S('$P(^(0),"^",4):0,1:+$P(^(0),"^",5)) I DGVREL'>3.5 Q
 Q:'$D(^DG(48,+DGVREL,0))  S (DA,Y)=DGVREL,DIE="^DG(48,",DR="D 120^DGVREL1;120;D 121^DGVREL1;121;D 122^DGVREL1;122;D 123^DGVREL1;123;D 124^DGVREL1;124;D 125^DGVREL1;125;D 126^DGVREL1;126;D 150^DGVREL1;150;" D ^DIE K DR
V S Z="^LETTER^MESSAGE^" R !!,"SEND RESPONSE VIA (L)ETTER OR (M)AILMAN MESSAGE?  ",X:DTIME D IN^DGHELP G Q:X["^"!('$T) I "ML"[X S DGHOW=X D CHK^DGVREL1 G @DGHOW:'DGERR,Q
 W !!?4,"LETTER - To generate release survey on a printer for mailing to ISC.",!?4,"MESSAGE - To transmit release survey as a mailman message if able to do so" G V
 ;
M D W I Y]"" W !,"DO YOU WISH TO RETRANSMIT AS A MAILMAN MESSAGE"
 E  W !!,"ARE YOU READY TO TRANSMIT MESSAGE TO THE ALBANY ISC"
 S %=2 D YN^DICN G T^DGVREL2:%=1,Q:%=2,Q:%=-1 W !!?4,"YES - To Transmit Message",!?4,"NO  - To not Transmit Message." G M
 ;
L S Y=$P(^DG(48,DGVREL,0),"^",2) I Y X ^DD("DD") D W W !,"ENTER AN UP-ARROW [""^""] AT THE 'DEVICE' PROMPT TO ABORT!"
 S DGPGM="L^DGVREL2",DGVAR="DGHOW^DGVRELSD^DGVREL^DUZ" D ZIS^DGUTQ G Q:POP U IO
 G @DGPGM
W S Y=$P(^DG(48,DGVREL,0),"^",2) I Y X ^DD("DD") W !!,"INITIAL RESPONSE WAS SENT VIA ",$S($P(^DG(48,DGVREL,0),"^",3)="M":"MAILMAN MESSAGE",1:"LETTER")," ON ",Y,"."
 Q
C ;
 ;;We, the PIMS developers, at the Albany ISC are most interested in your comments
 ;;concerning this release of PIMS.  This option was written specifically as a means
 ;;for you, the user, to communicate directly with us, the developers, regarding
 ;;the installation process, documentation quality (option documentation, release
 ;;notes, installation guide), etc., and the initial user reaction to the changes/
 ;;enhancements provided with this release.  The option provides for two methods of
 ;;providing us with feedback the first of which is by letter.  After answering all
 ;;the questions which are asked and entering your comments you will be asked if
 ;;you wish to reply via letter or mailman.  The LETTER option allows you to
 ;;generate your comments, survey responses, initialization times, etc., in a
 ;;letter format to this ISC for our review.  This can be queued to any output
 ;;device known to your system and mailed to us.  If you have network mailman up
 ;;and running you may elect to transmit the same data via a mailman message
 ;;directly to us.  Simply choose MAILMAN as the method of output and we'll do the
 ;;rest for you.  A copy of the mailman message will be dropped into your IN basket
 ;;for your records.  Thank you.
 ;;
 ;;                                                      PIMS Developers
 ;;                                                      Albany ISC
 ;;                                                      Troy, New York
 ;;QUIT
