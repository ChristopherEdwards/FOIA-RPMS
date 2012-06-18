AMERXMB  ; IHS/OIT/SCR - PRIMARY ROUTINE TO SUPPORT GENERATING AND SENDING BULLETINS 
 ;;3.0;ER VISIT SYSTEM;**1**;FEB 23, 2009
 ;
PATMRG1(AMERODFN,AMERONAM,AMEROPCC,AMERNDFN,AMERNNAM,AMERNPCC,AMERTIME) ; EP from AMERVSIT
 ; Sent when an existing patient associated to an ER VISIT 
 ; is identified as a different existing patient
 N AMERRTRN
 K XMTEXT
 S XMB="AMER ERS PATIENT MERGE"   ; Bulletin name
 S XMB(1)=AMERODFN                ; Original patient dfn
 S XMB(2)=AMERONAM                ; Original patient name
 S XMB(3)=AMERNDFN                ; New patient dfn
 S XMB(4)=AMERNNAM                ; New patient name
 S XMB(5)=AMEROPCC                ; Old VISIT ien
 S XMB(6)=AMERNPCC                ; New VISIT ien
 S XMB(7)=DUZ                     ; New Person ien who made the changes
 S XMB(9)=$P($G(^VA(200,DUZ,0)),U,1)  ; New Person Name who made the changes
 S XMB(10)=AMERTIME                   ; TIME OF VISIT (both old and new are the same)
 S XMY="B.AMER ER PATIENT MERGE ALERTS"
 S XMY(1)="",XMY(DUZ)=""
 D EN^XMB
 I $D(XMB) D EN^DDIOL("bulletin set up not complete - Please contact your site manager","","")
 S AMERRTRN=XMZ
 K XMZ
 Q AMERRTRN
EDITGRP ; EP from OPTION "AMER ER ALERTS MAIL GROUP EDIT"
 N AMERUSER,AMERGRP,AMERDUZ,AMERERR,Y,DIC,DIR,AMERY,AMERQUIT,AMERTYPE,AMERSELF,AMERORG,AMERQUT
 S AMERQUIT=0
 F  Q:AMERQUIT  D
 .S DIC="^VA(200,",DIC(0)="AEQM"
 .D ^DIC K DIC
 .I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT S AMERQUIT=1 Q
 .I +Y<0!(Y="") S AMERQUIT=1 Q
 .S AMERDUZ=+Y
 .S AMERGRP=0,AMERGRP=$O(^XMB(3.8,"B","AMER ER PATIENT MERGE ALERTS",AMERGRP))
 .I AMERGRP="" D
 ..D EN^DDIOL("AMER ER ALERTS MAIL GROUP IS MISSING!!","","!!")
 ..S AMERQUIT=1
 ..Q
 .Q:AMERQUIT
 .S AMERFND=$$CHKUSER(AMERDUZ,AMERGRP)
 .I AMERFND D
 ..D EN^DDIOL("This user is already in the AMER ER PATIENT MERGE ALERTS Mail Group","","!!")
 ..S DIR(0)="Y"
 ..S DIR("A")="Would you like to REMOVE this user from the Mail Group"
 ..S DIR("B")="YES"
 ..D ^DIR
 ..D:Y=1
 ...S AMERY(AMERDUZ)=""
 ...S AMERQUT=1
 ...;S AMERERR=$$DM^XMBGRP(AMERGRP,AMERY,AMERQUT)
 ...S AMERERR=$$DM^XMBGRP(AMERGRP,.AMERY,AMERQUT)  ;IHS/OIT/SCR 05/05/09 patch 1
 ...Q
 ..Q
 .E  D
 ..S DIR(0)="Y"
 ..S DIR("A")="Would you like to ADD this user to the Mail Group"
 ..S DIR("B")="YES"
 ..D ^DIR
 ..D:Y=1
 ...S AMERY(AMERDUZ)=""
 ...S AMERQUT=0
 ...S AMERTYPE=""
 ...S AMERORG=""
 ...S AMERSELF=""
 ...S AMERDESC=""
 ...S AMERGRP=$$MG^XMBGRP(AMERGRP,AMERTYPE,AMERORG,AMERSELF,.AMERY,AMERDESC,AMERQUT)
 ..Q
 .Q
 Q
CHKUSER(AMERDUZ,XMGROUP) ;
 N Y,XMDUZ,AMERFND
 S AMERFND=0
 S Y=XMGROUP
 S XMDUZ=AMERDUZ
 D CHK^XMA21
 I $T S AMERFND=1
 Q AMERFND
