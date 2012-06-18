ABMURCN1 ; IHS/SD/SDR - 3PB/UFMS Reconcile Sessions Option   
 ;;2.6;IHS Third Party Billing;**1,8**;NOV 12, 2009
 ;
 ; New routine - v2.5 p12 SDD item 4.9.2.4
 ; Reconcile Sessions Option
 ;
HEADER(ABMFLG) ;EP
 W !!,"The following SESSIONS are currently "_ABMFLG_" =>",!
 W !?3,"(*)  Indicates no activity in session.",!!
 W ?6,"SESSION ID",?18,"CASHIER",?47,"DATE "_$S(ABMFLG="OPEN":"OPENED",1:ABMFLG)
 I ABMFLG["CLOSE" W ?68,"STATUS"
 W !
 S $P(ABMLINE,"-",80)=""
 W ABMLINE,!
 Q
VIEWLIST ;EP
 S ABMS=0,ABMSCNT=0
 F  S ABMS=$O(ABMO(ABMS)) Q:+ABMS=0  D
 .S ABMSDUZ=""
 .F  S ABMSDUZ=$O(ABMO(ABMS,ABMSDUZ)) Q:ABMSDUZ=""  D
 ..S ABMSDT=0
 ..F  S ABMSDT=$O(ABMO(ABMS,ABMSDUZ,ABMSDT)) Q:+ABMSDT=0  D
 ...S ABMSCNT=ABMSCNT+1
 ...W ABMSCNT_"."
 ...W ?5,ABMSDT
 ...W ?21,$S(+ABMSDUZ:$E($P($G(^VA(200,ABMSDUZ,0)),U),1,24),1:"POS CLAIMS")
 ...W ?47,$$CDT^ABMDUTL(ABMSDT)
 ...I $P($G(ABMO(ABMS,ABMSDUZ,ABMSDT)),U)'="" D
 ....S ABMST=$P($G(ABMO(ABMS,ABMSDUZ,ABMSDT)),U)
 ....W ?68,$S(ABMST="O":"OPEN",ABMST="C":"CLOSED",ABMST="R":"RECONCILED",1:"TRANSMITTED")
 ...S ABMOS(ABMSCNT)=ABMS_"^"_ABMSDUZ_"^"_ABMSDT_"^"_$G(ABMO(ABMS,ABMSDUZ,ABMSDT))
 ...I +ABMSDUZ'=0,(+$P($G(ABMO(ABMS,ABMSDUZ,ABMSDT)),U,3)'=1) W ?79,"*"
 ...W !
 I $D(ABMOS),(ABMSCNT>1) D
 .S ABMSCNT=ABMSCNT+1
 .W !,ABMSCNT_". ",?6,$S($G(ABMFLG)="CLOSED":"RECONCILE",1:"CLOSE")_" ALL SESSIONS"
 Q
SELSESS ;SEL SESSIONS
 K ABMY("SESS")
 ;S DIR(0)="NO"  ;abm*2.6*1 HEAT5977
 S DIR(0)="NO^1:"_ABMSCNT_""  ;abm*2.6*1 HEAT5977
 S DIR("A")="Session number or ""^"" to not select any sessions"
 F  D  Q:+Y<1!(Y=ABMSCNT)
 .I '$D(ABMY("SESS")) S DIR("B")=ABMSCNT
 .;I $D(ABMY("SESS")),'$D(ABMY("SESS",ABMSCNT)) S DIR("A")="Select another session",DIR(0)="NO^1:"_(ABMSCNT-1) K DIR("B")  ;abm*2.6*1 HEAT5977
 .I $D(ABMY("SESS")),'$D(ABMY("SESS",ABMSCNT)) S DIR("A")="Select another session",DIR(0)="NO^1:"_(ABMSCNT-1)_"" K DIR("B")  ;abm*2.6*1 HEAT5977
 .D ^DIR K DIR
 .Q:+Y<0
 .Q:$D(DUOUT)!$D(DTOUT)!$D(DIRUT)!$D(DIROUT)
 .S ABMY("SESS",Y)=""
 I '$D(ABMY("SESS")) D
 .I $D(DUOUT)!$D(DTOUT)!$D(DIRUT)!$D(DIROUT) Q
 K DIR
 Q
VIEWSEL ;EP - view selected sessions for reconciliation
 W !!,"The following SESSIONS have been selected for Reconciliation =>",!
 W !?3,"(*)  Indicates no activity in session.",!!
 W ?6,"SESSION ID",?18,"CASHIER",?47,"DATE OPENED"
 W !
 S $P(ABMLINE,"-",80)=""
 W ABMLINE,!
 I $D(ABMY("SESS",ABMSCNT)),(ABMSCNT>1) D  ;they said all; put all sessions in selection array
 .F ABMI=1:1:(ABMSCNT-1) S ABMY("SESS",ABMI)=""
 .K ABMY("SESS",ABMSCNT)
 S ABMI=0,ABMSCNT=0
 F  S ABMI=$O(ABMC(ABMI)) Q:+ABMI=0  D
 .S ABMSDUZ=""
 .F  S ABMSDUZ=$O(ABMC(ABMI,ABMSDUZ)) Q:ABMSDUZ=""  D
 ..S ABMSDT=0
 ..F  S ABMSDT=$O(ABMC(ABMI,ABMSDUZ,ABMSDT)) Q:+ABMSDT=0  D
 ...S ABMSCNT=ABMSCNT+1
 ...W ABMSCNT_"."
 ...W ?5,ABMSDT
 ...W ?21,$S(+ABMSDUZ:$E($P($G(^VA(200,ABMSDUZ,0)),U),1,24),1:"POS CLAIMS")
 ...W ?47,$$CDT^ABMDUTL(ABMSDT)
 ...I $P($G(ABMC(ABMI,ABMSDUZ,ABMSDT)),U)'="" D
 ....S ABMST=$P($G(ABMC(ABMI,ABMSDUZ,ABMSDT)),U)
 ....W ?68,$S(ABMST="O":"OPEN",ABMST="C":"CLOSED",ABMST="R":"RECONCILED",1:"TRANSMITTED")
 ...I +ABMSDUZ'=0,(+$P($G(ABMC(ABMI,ABMSDUZ,ABMSDT)),U,3)'=1) W ?79,"*"
 ...W !
 I '$D(ABMC) W ?5,"NO CLOSED SESSIONS"
 W !,ABMLINE
 S ABMI=0
 F  S ABMI=$O(ABMY("SESS",ABMI)) Q:+ABMI=0  D
 .S ABMREC=$G(ABMOS(ABMI))
 .W !
 .W ?2,ABMI,".",?5,$P(ABMREC,U)
 .W ?21,$S(+$P(ABMREC,U,2)'=0:$P($G(^VA(200,$P(ABMREC,U,2),0)),U),1:"POS CLAIMS")
 .W ?47,$$CDT^ABMDUTL($P(ABMREC,U,3))
 .I +$P(ABMREC,U,2)'=0,(+$P($G(ABMO($P(ABMREC,U),$P(ABMREC,U,2),$P(ABMREC,U))),U,3)'=1) W ?79,"*"
 W !
 Q
CLOSE ;EP
 W !
 S ABMJ=0
 F  S ABMJ=$O(ABMY("SESS",ABMJ)) Q:+ABMJ=0  D
 .S ABMREC=$G(ABMOS(ABMJ))
 .S ABMSESS=$P(ABMREC,U)
 .S ABMDUZ=$P(ABMREC,U,2)
 .S ABMFD=$P(ABMREC,U,3)
 .D:ABMDUZ EP^ABMXUS9  ;check if user is signed in and in TPB
 .I $G(ABMOPFLG)=1 D  Q
 ..W !,"User "_$P($G(^VA(200,ABMDUZ,0)),U)_" with session ID "_ABMSESS
 ..W " is still signed into TPB so their session will not be closed."
 .D:ABMDUZ CASHTOT^ABMUCASH(ABMDUZ)  ;count claims/bills for session
 .D:'ABMDUZ CASHTOTP^ABMUCASH
 .D CLOSESES^ABMUCUTL(ABMLOC,ABMDUZ,ABMFD)
 .S ABMC(ABMSESS,ABMDUZ,ABMFD)="C"
 .S ABMAFLG=$$ACTIVCK^ABMUUTL(ABMLOC,ABMFD,ABMDUZ)
 .I ABMAFLG'=0 S $P(ABMC(ABMSESS,ABMDUZ,ABMFD),U,3)=1
 Q
CREATBTH ;EP - create UFMS export entry
 S DIC="^ABMUTXMT("
 S DIC("DR")=".02////"_ABMFILE_";.03////"_DUZ_";.04////"_ABMLOC
 S DIC(0)="L"
 D NOW^%DTC
 S X=%
 D ^DIC
 K DIC
 Q:Y<0
 S ABMPXMIT=+Y
 Q
PRINTSUM ;EP - print sum?
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Print summary screen"
 D ^DIR K DIR
 S ABMXANS=+Y
 Q:ABMXANS=0  ;no, don't print
 S ABMQ("RX")="XIT^ABMURCON"
 S ABMQ("NS")="ABM"
 S ABMQ("RP")="XSUMDISP^ABMURCON"
 D ^ABMDRDBQ
 Q
BATCH ;EP - put bill entry in batch file
 ;user
 K DIC,DIE,DIR,X,Y,DA
 S DA(1)=ABMPXMIT
 I ABMDUZ D
 .S DIC="^ABMUTXMT("_DA(1)_",1,"
 .S DIC("P")=$P(^DD(9002274.46,1,0),U,2)
 .S X="`"_ABMDUZ
 I 'ABMDUZ D
 .S DIC="^ABMUTXMT("_DA(1)_",2,"
 .S DIC("P")=$P(^DD(9002274.46,2,0),U,2)
 .S X=1
 S DIC(0)="L"
 D ^DIC
 Q:+Y<0
 ;sign in date
 K DIC,DIE,X,Y,DA
 S DA(2)=ABMPXMIT
 I ABMDUZ D
 .S DA(1)=ABMDUZ
 .S DIC="^ABMUTXMT("_DA(2)_",1,"_DA(1)_",2,"
 I 'ABMDUZ D
 .S DA(1)=1
 .S DIC="^ABMUTXMT("_DA(2)_",2,"_DA(1)_",2,"
 S (X,DINUM)=ABMSDT
 S DIC(0)="L"
 S DIC("DR")=".02////"_ABMSDT
 D ^DIC
 Q:+Y<0
 ;budget activity
 K DIC,DIE,X,Y,DA
 S DA(3)=ABMPXMIT
 S DA(2)=$S(ABMDUZ:ABMDUZ,1:1)
 S DA(1)=ABMSDT
 I ABMDUZ S DIC="^ABMUTXMT("_DA(3)_",1,"_DA(2)_",2,"_DA(1)_",11,"
 I 'ABMDUZ S DIC="^ABMUTXMT("_DA(3)_",2,"_DA(2)_",2,"_DA(1)_",11,"
 S X=ABMBAOUT
 ;S DIC(0)="L"  ;abm*2.6*8 HEAT28427
 S DIC(0)="LMX"  ;abm*2.6*8 HEAT28427
 D ^DIC
 Q:+Y<0
 S ABMBCHBA=+Y
 ;bills
 K DIC,DIE,X,Y,DA
 S DA(4)=ABMPXMIT
 S DA(3)=$S(ABMDUZ:ABMDUZ,1:1)
 S DA(2)=ABMSDT
 S DA(1)=ABMBCHBA
 I ABMDUZ S DIC="^ABMUTXMT("_DA(4)_",1,"_DA(3)_",2,"_DA(2)_",11,"_DA(1)_",2,"
 I 'ABMDUZ S DIC="^ABMUTXMT("_DA(4)_",2,"_DA(3)_",2,"_DA(2)_",11,"_DA(1)_",2,"
 S X=$P(ABMPREC,U)
 S DIC(0)="L"
 S DIC("DR")=".02////"_$P(ABMPREC,U,2)_";.03////"_$P(ABMPREC,U,3)
 S DIC("DR")=DIC("DR")_";.04////"_+$P($G(^ABMDBILL($P(ABMPREC,U,2),$P(ABMPREC,U,3),2)),U)
 I ABMEXCLD<1 S DIC("DR")=DIC("DR")_";.05////1"  ;excluded data
 D ^DIC
 Q
REEXPB ;EP - put re-export entry in batch file
 ;user
 K DIC,DIE,DIR,X,Y,DA
 S DA(1)=ABMPXMIT
 S DIC="^ABMUTXMT("_DA(1)_",1,"
 S DIC("P")=$P(^DD(9002274.46,1,0),U,2)
 S X="`"_ABMDUZ
 S DIC(0)="L"
 D ^DIC
 Q:+Y<0
 ;sign in date
 K DIC,DIE,X,Y,DA
 S DA(2)=ABMPXMIT
 S DA(1)=ABMDUZ
 S DIC="^ABMUTXMT("_DA(2)_",1,"_DA(1)_",2,"
 S (X,DINUM)=ABMSDT
 S DIC(0)="L"
 S DIC("DR")=".02////"_ABMSDT
 D ^DIC
 Q:+Y<0
 ;
 ;re-export IEN
 K DIC,DIE,X,Y,DA
 S DA(3)=ABMPXMIT
 S DA(2)=ABMDUZ
 S DA(1)=ABMSDT
 I ABMDUZ S DIC="^ABMUTXMT("_DA(3)_",1,"_DA(2)_",2,"_DA(1)_",3,"
 I 'ABMDUZ S DIC="^ABMUTXMT("_DA(3)_",2,"_DA(2)_",2,"_DA(1)_",3,"
 S X=ABMPBTCH
 S DIC(0)="L"
 D ^DIC
 Q:+Y<0
 S ABMREXP=+Y
 Q
BILL ;EP - put entry in bill multiple for transmit date and save UFMS invoice#
 ;transmit date
 S ABMHOLD=DUZ(2)
 S DUZ(2)=$P(ABMPREC,U,2)
 K DIC,DIE,X,Y,DA
 S DIC(0)="L"
 S DA(1)=ABMP("BDFN")
 S DIC="^ABMDBILL(DUZ(2),"_DA(1)_",69,"
 S DIC("P")=$P(^DD(9002274.4,69,0),U,2)
 S X=ABMPXMIT  ;date from batch
 S DIC("DR")=".02////"_ABMPASUF_ABMSASUF_$S(+$G(ABMUAOF)'=0:$P($G(^AUTTLOC(ABMP("LDFN"),0)),U,7),1:"")_ABMP("BDFN")
 I ABMEXCLD<1 S DIC("DR")=DIC("DR")_";.03////1"  ;excluded data
 D ^DIC
 S DUZ(2)=ABMHOLD
 Q
NOSEND ;EP - don't send but mark as reconciled
 W !,"Sessions will be marked as reconciled..."
 F  S ABMSESS=$O(ABMC(ABMSESS)) Q:+ABMSESS=0  D
 .S ABMDUZ=""
 .F  S ABMDUZ=$O(ABMC(ABMSESS,ABMDUZ)) Q:ABMDUZ=""  D
 ..S ABMSDT=0
 ..F  S ABMSDT=$O(ABMC(ABMSESS,ABMDUZ,ABMSDT)) Q:+ABMSDT=0  D
 ...I ABMDUZ D
 ....D RCONSESS
 ...I 'ABMDUZ D  ;POS CLAIMS
 ....S ABMUSER=0
 ....F  S ABMUSER=$O(^ABMUCASH(ABMLOC,20,ABMUSER)) Q:+ABMUSER=0  D
 .....D RCONSESS
 D PRINTSUM^ABMURCON
 W !,"EXITING Reconcile sessions option..."
 Q
RCONSESS ;EP - mark session as transmitted
 K DIC,DIE,DA,DR,X,Y
 S DA(2)=DUZ(2)
 S DA(1)=$S(ABMDUZ:ABMDUZ,1:1)
 S:ABMDUZ DIE="^ABMUCASH("_DA(2)_",10,"_DA(1)_",20,"
 S:'ABMDUZ DIE="^ABMUCASH("_DA(2)_",20,"_DA(1)_",20,"
 S DA=ABMSDT
 S DR=".04///R;.07///NOW"  ;reconciled status w/date
 D ^DIE
 Q
