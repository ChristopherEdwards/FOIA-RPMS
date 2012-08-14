BMCBULL ; IHS/PHXAO/TMJ - RCIS - SEND BULLETIN ;    
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;IHS/ITSC/FCJ REMOVED EN4,EN5,EN6 AND EN7 
 ;     COMBINED TO CALL EP ENMM FOR MAILMAN MESSAGES
 ;     WILL LIST ANY PREVIOUS MESSAGE SENT AND
 ;     OPTION TO SELECT GROUPS TO SEND MESSAGE TO
 ;     ALSO STORE HISTORY OF MSG SENT IN RCIS MESSAGE FILE
 ;
 ; This routine sends bulletins to RCIS users as appropriate.
 ;
EN1 ; EP - DX BULLETINS
 NEW Y,BMCBULLN,BMCNARR,BMCNODE
 Q:'$G(BMCDFN)
 Q:'$G(BMCRDATE)
 K XMY
 I $D(BMCBULLC) S BMCBULLN="BMC POTENTIAL HIGH COST DX",BMCNODE=21,BMCNARR=$$VAL^XBDIQ1(90001,BMCRIEN,.12) D SEND Q
 I $G(BMCTXL3P),$$TXC^ATXTXCHK(X,BMCTXL3P) S BMCBULLN="BMC 3RD PARTY LIABILITY",BMCNARR=$$VAL^XBDIQ1(90001.01,DA,.01)_"  "_$$VAL^XBDIQ1(90001.01,DA,.019),BMCNODE=25 D SEND
 I $G(BMCTXPHC),$$TXC^ATXTXCHK(X,BMCTXPHC) S BMCBULLN="BMC POTENTIAL HIGH COST DX",BMCNARR=$$VAL^XBDIQ1(90001.01,DA,.01)_"  "_$$VAL^XBDIQ1(90001.01,DA,.019),BMCNODE=21 D SEND Q
 Q
EN2 ;EP - procedure bulletins (high cost, cosmetic, exp)
 NEW Y,BMCBULLN,BMCNARR,BMCNODE
 Q:'$G(BMCDFN)
 Q:'$G(BMCRDATE)
 K XMY
 I $G(BMCTXCHC),$$TXC^ATXTXCHK(X,BMCTXCHC) S BMCBULLN="BMC POTENTIAL HIGH COST PROC",BMCNARR=$$VAL^XBDIQ1(90001.02,DA,.01)_"  "_$$VAL^XBDIQ1(90001.02,DA,.019),BMCNODE=22 D SEND
 I $G(BMCTXCCP),$$TXC^ATXTXCHK(X,BMCTXCCP) S BMCBULLN="BMC COSMETIC PROCEDURE",BMCNARR=$$VAL^XBDIQ1(90001.02,DA,.01)_"  "_$$VAL^XBDIQ1(90001.02,DA,.019),BMCNODE=23 D SEND
 I $G(BMCTXCEX),$$TXC^ATXTXCHK(X,BMCTXCEX) S BMCBULLN="BMC EXPERIMENTAL PROCEDURE",BMCNARR=$$VAL^XBDIQ1(90001.02,DA,.01)_"  "_$$VAL^XBDIQ1(90001.02,DA,.019),BMCNODE=24 D SEND
 Q
SEND ;SEND BULLETIN
 K XMB
 S XMB=BMCBULLN
 S XMB(1)=BMCREC("PAT NAME")
 S XMB(2)=BMCREC("REF DATE")
 S XMB(3)=BMCRNUMB
 S XMB(4)=""
 S Y=$P(^BMCREF(BMCRIEN,0),U,6)
 S:Y XMB(4)=$P(^VA(200,Y,0),U)
 S XMB(5)=$G(BMCNARR)
 K XMY
 S Y=0 F  S Y=$O(^BMCPARM(DUZ(2),BMCNODE,Y)) Q:Y'=+Y  S %=$P(^BMCPARM(DUZ(2),BMCNODE,Y,0),U) I %,$P(^BMCPARM(DUZ(2),BMCNODE,Y,0),U,2)]"",$P(^(0),U,2)[BMCRTYPE S XMY(%)=""
 Q:'$D(XMY)
 D ^XMB
 K XMB,XMY
 Q
 ;
ENX ; EP - POTENTIAL HIGH COST DX
 NEW Y
 Q:'$G(BMCDFN)
 Q:'$G(BMCRDATE)
 K XMY
 S Y=$P(^BMCREF(BMCRIEN,0),U,4)
 Q:Y="N"  ;                           quit if type is In-House
 Q:Y="O"  ;                            quit if type is Other
 I Y="C",BMCCHSS S XMY(BMCCHSS)="" ;  if CHS send to chs supvr
 I Y="I",BMCBOS S XMY(BMCBOS)="" ;    if IHS send to business office
 S Y=$P(^BMCREF(BMCRIEN,0),U,19) ;    send to case manager
 I Y S XMY(Y)=""
 Q:'$D(XMY)  ;                        quit if no addressees
 K XMB
 S XMB="BMC POTENTIAL HIGH COST DX"
 S XMB(1)=BMCREC("PAT NAME")
 S XMB(2)=BMCREC("REF DATE")
 S XMB(3)=BMCRNUMB
 S XMB(4)=""
 S Y=$P(^BMCREF(BMCRIEN,0),U,6)
 S:Y XMB(4)=$P(^VA(200,Y,0),U)
 S Y=$$VAL^XBDIQ1(90001.02,DA,.01)_"  "_$$VAL^XBDIQ1(90001.02,DA,.019)
 S:Y]"" XMB(5)=Y
 D ^XMB
 K XMB,XMY
 Q
 ;
EN3 ;EP 
 NEW Y
 Q:'$G(BMCDFN)
 Q:'$G(BMCRDATE)
 K XMY
 S Y=$P(^BMCREF(BMCRIEN,0),U,4)
 Q:Y="N"  ;                           quit if type is In-House
 Q:Y="O"  ;                            quit if type is Other
 I Y="C",BMCCHSS S XMY(BMCCHSS)="" ;  if CHS send to chs supvr
 I Y="I",BMCBOS S XMY(BMCBOS)="" ;    if IHS send to business office
 S Y=$P(^BMCREF(BMCRIEN,0),U,19) ;    send to case manager
 I Y S XMY(Y)=""
 Q:'$D(XMY)  ;                        quit if no addressees
 K XMB
 S XMB="BMC CPT CATEGORY/PROCEDURE"
 S XMB(1)=BMCREC("PAT NAME")
 S XMB(2)=BMCREC("REF DATE")
 S XMB(3)=BMCRNUMB
 S XMB(4)=""
 S Y=$P(^BMCREF(BMCRIEN,0),U,6)
 S:Y XMB(4)=$P(^VA(200,Y,0),U)
 S Y=$$VAL^XBDIQ1(90001,BMCRIEN,.12)
 S:Y]"" XMB(5)=Y
 S Y=$$VAL^XBDIQ1(90001,BMCRIEN,.13)
 S:Y]"" XMB(6)=Y
 D ^XMB
 K XMB,XMY
 Q
 ;
 ;IHS/ITSC/FCJ REMOVED EN4,EN5,EN6 AND EN7 ADDED ENMM THROUGH EXT 
ENMM ;EP;MESSAGE NEW REF AND MODIFICATIONS
 NEW Y,DIC
 Q:'$G(BMCDFN)
 Q:'$G(BMCRDATE)
MSG ;TEST FOR EXISTING MESSAGES ALREADY SENT
 I $D(^BMCMSG("C",BMCRIEN)) D
 .W !!,"A Message has already been sent for this referral:"
 .S BMCMSG=0 W !?3,"DATE",?25,"SENT BY",?55,"GROUP"
 .F  S BMCMSG=$O(^BMCMSG("C",BMCRIEN,BMCMSG)) Q:BMCMSG'?1N.N  D
 ..S Y=$P(^BMCMSG(BMCMSG,0),U) D DD^%DT
 ..W !?3,Y,?25,$P(^VA(200,$P(^BMCMSG(BMCMSG,0),U,4),0),U)
 ..S BMCGRP=0 F  S BMCGRP=$O(^BMCMSG(BMCMSG,1,BMCGRP)) Q:BMCGRP'?1N.N  D
 ...S BMCGRP1=$P(^BMCMSG(BMCMSG,1,BMCGRP,0),U)
 ...W ?55,$P(^XMB(3.8,BMCGRP1,0),U),!
 E  W !!,"A Message has NOT been sent for this referral."
 S DIR(0)="Y",DIR("A")="Do you wish to send a message",DIR("B")="Y"
 D ^DIR K DIR I $D(DIRUT)!'Y G EXT
MGRP ;SELECT MAIL GROUPS TO SEND MESSAGE TO
 ;ENTER THE GROUP TO SEND IT TO AND ADD ENTRY TO THE RCIS MESSAGE FILE
 S BMCGRP="BMC",DIR(0)="S^",Y=0
 F  S BMCGRP=$O(^XMB(3.8,"B",BMCGRP)) Q:$E(BMCGRP,1,3)'="BMC"  D
 .S BMCGRP1=0 S BMCGRP1=$O(^XMB(3.8,"B",BMCGRP,BMCGRP1))
 .S Y=Y+1,BMCGRP(Y)=BMCGRP_U_BMCGRP1
 I Y=0 W !,"THERE ARE NOT ANY RCIS MAIL GROUPS SET UP.",!,"If you would like to set up a mail group, use Mail Groups Option under the",!,"RCIS Management Menu." Q
 F I=1:1:Y W !?5,I_".  "_$P(BMCGRP(I),U)
 S DIR("A")="To select recipient group(s) enter a list or range of numbers"
 S DIR(0)="L^1:"_Y
 D ^DIR I $D(DIRUT) W !?5,"***MESSAGE WAS NOT SENT***" G EXT
SNDMSG ;SEND BULLETIN
 K XMB,XMY
 F I=1:1 Q:$P(Y,",",I)'?1N.N  S XMY("G."_$P(BMCGRP($P(Y,",",I)),U))="",BMCGRPS($P(BMCGRP($P(Y,",",I)),U,2))=""
 S Y=$P(^BMCREF(BMCRIEN,0),U,4)
 S XMZ=""
 ;REF IF OPTION SET AND USER ANSWERS YES....
 ;Q:Y="N"  ;quit if In-House referral ;FCJ REMOVED
 S XMB="BMC REFERRAL ALERT"  ;FCJ NEW BULLETIN
 S XMB(1)=BMCREC("PAT NAME")
 S XMB(2)=BMCREC("REF DATE")
 S XMB(3)=BMCRNUMB
 S XMB(4)=""
 S XMB(5)=$$VAL^XBDIQ1(90001,BMCRIEN,1201)
 S XMB(6)=$$FACREF^BMCRLU(BMCRIEN)
 S XMB(7)=$$VAL^XBDIQ1(90001,BMCRIEN,1301)
 S XMB(8)=$$VAL^XBDIQ1(90001,BMCRIEN,.32)
 S Y=$P(^BMCREF(BMCRIEN,0),U,6)
 S:Y XMB(4)=$P(^VA(200,Y,0),U)
 S XMB(9)=$$VAL^XBDIQ1(90001,BMCRIEN,.04)
 ;IHS/ITSC/FCJ ADDED BO COM FR RCIS COMMENTS FILE,LIFO DISPLAY
 I $D(^BMCCOM("AD",BMCRIEN)) D
 .S BMCL=0,BMCL2=10
 .F  S BMCL=$O(^BMCCOM("AD",BMCRIEN,BMCL)) Q:BMCL'?1N.N  D
 ..Q:$P(^BMCCOM(BMCL,0),U,5)'="B"
 ..I $D(^BMCCOM(BMCL,1)) D
 ...S XMB(BMCL2)="  Date: "_$$FMTE^XLFDT($P(^BMCCOM(BMCL,0),U),"5D")_"  By: "_$$VAL^XBDIQ1(90001.03,BMCL,.04)
 ...S BMCL1=0
 ...F  S BMCL1=$O(^BMCCOM(BMCL,1,BMCL1)) Q:BMCL1'?1N.N  D
 ....S BMCL2=BMCL2+1
 ....S XMB(BMCL2)=^BMCCOM(BMCL,1,BMCL1,0)
 ..S BMCL2=BMCL2+1
 D EN^XMB
 I $D(XMB) W !?5,"***ERROR: NO MESSAGE SENT***" G EXT
 W !?5,"***MESSAGE SENT***"
ADD ;IF MESSAGE SENT ADD TO RCIS MESSAGE FILE
 S (DIE,DIC)="^BMCMSG(",DIC(0)="L"
 D NOW^%DTC S X=%
 S DIC("DR")=".02////"_BMCRIEN_";.03////"_BMCRNUMB_";.04////"_DUZ_";.05////REFERRAL ALERT"
 D ^DIC
 S DA(1)=+Y,(DIE,DIC)=DIC_DA(1)_",1,",DA=1
 I '$D(^BMCREG(DA(1),1)) S ^BMCREG(DA(1),1,0)="^90001.571P^^"
 D ^DIC
 S BMCGRP=0  F  S BMCGRP=$O(BMCGRPS(BMCGRP))  Q:BMCGRP'?1N.N  D
 .S DR=".01////"_BMCGRP
 .D ^DIE
 .S $P(^BMCMSG(DA(1),1,0),U,3,4)=DA_U_DA
 .S DA=DA+1
EXT K XMB,XMY,XMZ,DIR,DIC,DIE,DA,DR
 K BMCMSG,BMCGRP,BMCGRPS,BMCGRP1,BMCL,BMCL1,BMCL2,BMCLDT,BMCTMP
 Q