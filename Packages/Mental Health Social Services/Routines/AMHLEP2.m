AMHLEP2 ; IHS/CMI/LAB - ADD NEW BH ACTIVITY RECORDS 06 Nov 2009 9:21 AM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
ADD ;EP
 S APCDOVRR=""
 D FULL^VALM1
 I '$D(AMHDATE) W !!,"Date not entered." H 5 Q
 I '$G(AMHPAT) W !!,"No patient identified." H 5 Q
 S AMHADPTV=1
 S AMHQUIT=0,AMHACTN=1
 W !,"Creating new record..." K DD,D0,DO,DINUM,DIC,DA,DR
 S DIC(0)="EL",DIC="^AMHREC(",DLAYGO=9002011,DIADD=1,X=AMHDATE,DIC("DR")=".08////^S X=$G(AMHPAT);.02///"_AMHPTYPE_";.03///^S X=DT;.19////"_DUZ_";.33////"_AMHVTYPE_";.28////"_DUZ_";.22///A;.21///^S X=DT"_";1111////1"
 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Behavioral Health Record is NOT complete!!  Deleting Record.",! D PAUSE Q
 ;update multiple of user last update/date edited
 S AMHR=+Y
 S DIE="^AMHREC(",DA=AMHR,DR="5100///NOW",DR(2,9002011.5101)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR
 S DA=AMHR,DIE="^AMHREC(",DR=".02///"_AMHPTYPE_$S($$GETLOC^AMHLEIN(DUZ(2),AMHPTYPE):";.04///`"_$$GETLOC^AMHLEIN(DUZ(2),AMHPTYPE),1:"")_$S($$GETCOMM^AMHLEIN(DUZ(2),AMHPTYPE):";.05///`"_$$GETCOMM^AMHLEIN(DUZ(2),AMHPTYPE),1:"")
 S DR=DR_$S($$GETCLN^AMHLEIN(DUZ(2),AMHPTYPE):";.25///`"_$$GETCLN^AMHLEIN(DUZ(2),AMHPTYPE),1:"")
 S DR=DR_";.11///"_$$GETAWI^AMHLEIN(DUZ(2))_$S($$GETTOC^AMHLEIN(DUZ(2)):";.07///`"_$$GETTOC^AMHLEIN(DUZ(2)),1:"")
 D ^DIE I $D(Y) W !!,"Error updating record......" H 5
 K DR,DA,DIE
 D GETPROV I '$$PPINT^AMHUTIL(AMHR) W !,"No PRIMARY PROVIDER entered!! - Required element" D DEL,EXIT Q
 ;I AMHVTYPE="S"!(AMHVTYPE="U") D SAN^AMHLEP3 G CHK
 ;I AMHVTYPE="I"!(AMHVTYPE="P") D INTAKE^AMHLEP4,EXIT Q
 ;
ADD1 ;
 I AMHVTYPE="R" S DA=AMHR,DDSFILE=9002011,DR="[AMH ADD RECORD]" D ^DDS
 ;I AMHVTYPE="B" S AMHVTYPE="R",DA=AMHR,DDSFILE=9002011,DR="[AMHB ADD RECORD]" D ^DDS
 ;I AMHVTYPE="N" S DA=AMHR,DDSFILE=9002011,DR="[AMHNS ADD RECORD]" D ^DDS
 ;I AMHVTYPE="C" S DA=AMHR,DDSFILE=9002011,DR="[AMH ADD CASE TRACKING REC]" D ^DDS
 ;I AMHVTYPE="A" S DA=AMHR,DDSFILE=9002011,DR="[AMHASA ADD RECORD]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG Q
 ;CHECK RECORD
 ;I AMHVTYPE="N" D GENPOV^AMHLENS
CHK ;  S AMHOKAY=0 D RECCHECK^AMHLE2 I AMHOKAY W !!,"Incomplete record!! Deleting record!!" D DEL,EXIT Q
 D CHECK^AMHLEA
 I AMHZDEL D EXIT Q
 I AMHZED G ADD1
 ;I $G(AMHERROR) W !!,$C(7),$C(7),"PLEASE EDIT THIS RECORD!!",!!
 ;I $P(^AMHREC(AMHR,0),U,2)="C"!($P($G(^AMHREC(AMHR,91)),U)="Y") D CDST
 I AMHVTYPE="R" D REGULAR
 ;I AMHVTYPE="S" D REGULAR
 ;I AMHVTYPE="C" D REGULAR
 ;I AMHVTYPE="N" D REGULAR
 ;I AMHVTYPE="A" D REGULAR
 I $G(AMHNAVR) Q
 ;D CLEAR^VALM1
 D SUIC^AMHLEA,OTHER
 D PCCLINK
 D EXIT
 Q
 ;
REGULAR ;EP
 ;D TERM^VALM0,FULL^VALM1
 I '$D(^AMHSITE(DUZ(2),13,"B",DUZ)) Q  ;no access
 S DIR(0)="Y",DIR("A")="Do you want to share this visit information with other providers",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y Q
 K XMY D GETLIST
 I '$D(XMY) G REGULAR
 W !!,"Message will be sent to:" S X=0 F  S X=$O(XMY(X)) Q:X'=+X  W ?28,$P(^VA(200,X,0),U),!
 S DIR(0)="Y",DIR("A")="Do you want to attach a note to this mail message",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G REGULAR
 W !,"Enter the text of your note.",!
 I Y=1 D  D ^XBFMK
 .L +^AMHREC(AMHR):60 S DIE="^AMHREC(",DA=AMHR,DR="9800" D ^DIE L -^AMHREC(AMHR)
 S DIR(0)="Y",DIR("A")="Ready to send mail message",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) K XMY,XMTEXT,XMDUZ,XMZ,XMSUB,AMHEFT Q
 I 'Y K XMY,XMTEXT,XMDUZ,XMZ,XMSUB G REGULAR
FS ;
 S AMHEFT=""
 S DIR(0)="SB^F:FULL;S:SUPPRESSED",DIR("A")="Send Full or Suppressed Form",DIR("B")="S" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) K XMY,XMTEXT,XMDUZ,XMZ,XMSUB,AMHEFT Q
 S AMHEFT=Y
 D MAILMSG
 Q
GETLIST ;
 K XMY
GETLIST1 ;
 K DIC,DR,DD,D0,DO S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Send to: " D ^DIC
 I Y=-1 Q
 S XMY(+Y)=""
 G GETLIST1
 ;
CASE(P,R,T) ;return 1 if case already opened
 S U="^"
 I '$G(P) Q ""
 I '$G(R) Q ""
 I $G(T)="" Q ""
 NEW X,H S (X,H)=0 F  S X=$O(^AMHPCASE("AA",P,9999999-$P($P(^AMHREC(R,0),U),"."),X)) Q:X'=+X   I $P(^AMHPCASE(X,0),U,2)=T,$P(^AMHPCASE(X,0),U,8)=$$PPINT^AMHUTIL(R) S H=1
 Q H
MAILMSG ;
 K ^TMP("AMHS",$J),^TMP("AMHMSG",$J)
 D ^XBFMK
 S AMHX=0 F  S AMHX=$O(XMY(AMHX)) Q:AMHX'=+AMHX  D
 .I '$D(^AMHREC(AMHR,52,"B",AMHX)) S DA=AMHR,DIE="^AMHREC(",DR="5200///`"_AMHX D ^DIE,^XBFMK
 D EP2^AMHLEFP2(AMHR,1)
 S (C,X)=0 F  S X=$O(^TMP("AMHS",$J,"DCS",X)) Q:X'=+X  S C=C+1
 S C=C+1,^TMP("AMHS",$J,"DCS",C)="THIS FORM CONTAINS CONFIDENTIAL PATIENT INFORMATION.  UNAUTHORIZED"
 S C=C+1,^TMP("AMHS",$J,"DCS",C)="REPRODUCTION OF THIS FORM MAY VIOLATE PRIVACY ACT STATUTES AND BE"
 S C=C+1,^TMP("AMHS",$J,"DCS",C)="PUNISHABLE BY LAW."
 S C=C+1,^TMP("AMHS",$J,"DCS",C)="*********** PLEASE DELETE IMMEDIATELY AFTER REVIEW. ***********"
 S AMHC=0 ;put message into new global with header
 S H=$$HRN^AUPNPAT(AMHPAT,DUZ(2),2)
 S:H="" H="<?????>"
 S (%,C)=0 F  S %=$O(^AUPNPAT(AMHPAT,41,%)) Q:%'=+%!(C>4)  I %'=DUZ(2) S H=H_"  "_$$HRN^AUPNPAT(AMHPAT,%,2) S C=C+1
 S AMHC=1,^TMP("AMHMSG",$J,AMHC)="NAME:  "_$P(^DPT(AMHPAT,0),U)_"   "_H
 S AMHC=AMHC+1,^TMP("AMHMSG",$J,AMHC)="SEX: "_$$VAL^XBDIQ1(2,AMHPAT,.02)_"  DOB: "_$$VAL^XBDIQ1(2,AMHPAT,.03)_"   RESIDENCE: "_$$VAL^XBDIQ1(9000001,AMHPAT,1118),AMHC=AMHC+1,^TMP("AMHMSG",$J,AMHC)=""
 S X=0 F  S X=$O(^AMHREC(AMHR,98,X)) Q:X'=+X  S AMHC=AMHC+1,^TMP("AMHMSG",$J,AMHC)=^AMHREC(AMHR,98,X,0)
 S AMHC=AMHC+1,^TMP("AMHMSG",$J,AMHC)="",X=0 F  S X=$O(^TMP("AMHS",$J,"DCS",X)) Q:X'=+X  S AMHC=AMHC+1,^TMP("AMHMSG",$J,AMHC)=^TMP("AMHS",$J,"DCS",X)
 S XMSUB="Patient Encounter in Behavioral Health - CONFIDENTIAL"
 S XMDUZ=$P(^VA(200,DUZ,0),U)
 D XMZ^XMA2
 S AMHXMZ=XMZ
 S XMDUZ=$P(^VA(200,DUZ,0),U)
 S XMTEXT="^TMP(""AMHMSG"",$J,"
 W !,"Sending Mailman message to distribution list"
 D ENL^XMD
 S XMZ=AMHXMZ
 S DA=XMZ,DIE=3.9,DR="1.95///Y;1.96///Y" D ^DIE K DIE,DR,DA
 D ENT1^XMD
 KILL ^TMP("AMHS",$J)
 ;set multiple imn record file
 ;kill vars
 K XMZ,DA,DIE,DR,XMDUZ,AMHXMZ,AMHEFT,XMSUB,AMHX,XMY
 W !,"Message Sent  "
 D PAUSE
 Q
 ;
PRIMPROB(R) ;
 I '$G(R) Q ""
 NEW X S X=$O(^AMHRPRO("AD",R,0))
 I 'X Q ""
 Q $P(^AMHRPRO(X,0),U)
CDST ;EP
 ;create record in CDMIS Staging file
 I $P($G(^AMHREC(AMHR,91)),U)'="Y" Q
 I $D(^AMHRCDST("B",AMHR)) W !!,"There is already a initial/discharge entry for this visit.",!,"Editing existing data...." H 2 S AMHCDR=$O(^AMHRCDST("B",AMHR,0)) G CDST1
 W !!,"Creating Initial Chemical Dependency data record..." H 1
 D ^XBFMK S DIC="^AMHRCDST(",DIC(0)="AEMQ",DIADD=1,DLAYGO=9002011.06,X=AMHR K DD,DO D FILE^DICN K DIADD,DLAYGO,DD,DO,DIC
 I Y=-1 W !!,$C(7),$C(7),"Notify supervisor....error in creating Initial Staging record.." D PAUSE Q
 S AMHCDR=+Y
CDST1 K DIADD,DLAYGO D ^XBFMK
 S DA=AMHCDR,DIE="^AMHRCDST(",DR=".02////"_AMHPAT_";.03////"_$$PRIMPROB(AMHR)_";.04////"_DT_";.05////"_DUZ_";.19////"_$P(^AMHREC(AMHR,0),U,32) D ^DIE
 I $D(Y) W !!,$C(7),$C(7),"Notify supervisor....error in creating Initial Staging record.." D PAUSE Q
 S DA=AMHCDR,DDSFILE=9002011.06,DR="[AMH ENTER/EDIT STAGING TOOL]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG Q
 Q
CDSTDEL ;
 W !!,"There is a staging tool entry for this visit and this visit",!,"is not an INITIAL, REOPEN, TRAN/DISC/CLOSE or FOLLOW UP.",!
 S DIR(0)="Y",DIR("A")="Do you want to delete this staging tool entry",DIR("B")="N" KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 Q:'Y
 S DA=$O(^AMHRCDST("B",AMHR,0)),DIK="^AMHRCDST(" D ^DIK
 Q
OTHER ;EP - collect other data if patient related
 I $G(AMHZDO) G OTHERX
 S AMHXX=$$ESIG^AMHESIG(AMHR)
 I '$G(AMHXX) D  I $P(AMHXX,U,4),AMHANS G OTHER
 .W !!,$P(AMHXX,U,3),!
 .I '$P(AMHXX,U,4) D PAUSE Q
 .S DIR(0)="Y",DIR("A")="Do you wish to enter a SOAP/Progress Note",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 .Q:$D(DIRUT)
 .S AMHANS=Y Q:'Y
 .S DIE="^AMHREC(",DR=3101,DA=AMHR D ^DIE K DA,DIE,DR
 I AMHXX D ESIGGFI^AMHESIG(AMHR)
OTHERX D FULL^VALM1
 W @IOF,!!!?20,"*******  OTHER INFORMATION  *******",!!
 D RMENU
 S DIR("B")=9,DIR(0)="NO^1:9",DIR("A")="Choose one of the above" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=9
 S AMHSELE=+Y D OTHER1
 G OTHER
OTHER1 ;
 I '$G(AMHPAT) W $C(7),"You MUST Identify the Patient first!!" S AMHPAT="" D GETPAT Q:'AMHPAT
 W !
 D @AMHSELE
 Q
GETPROV ;EP - get providers
 K DIR,DIC,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR("B")=$P(^VA(200,DUZ,0),U),DIR(0)="9002011.02,.01O",DIR("A")="Enter PRIMARY PROVIDER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=""
 S X=+Y,DIC("DR")=".02////"_$G(AMHPAT)_";.03////"_AMHR_";.04///PRIMARY",DIC="^AMHRPROV(",DIC(0)="MLQ",DLAYGO=9002011.02,DIADD=1 K DD,DO D FILE^DICN K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 I Y=-1 W !!,"Creating Primary Provider entry failed!!!",$C(7),$C(7) H 2
 Q
GETPAT ;EP
 D ^XBFMK
 S AMHC=0
GETPAT1 I $G(AMHDET)="S" W:$D(IOF)&(AMHC=0) @IOF W !!!!!!!!?20,"TYPE THE PATIENT'S HRN, NAME, SSN OR DOB" S DIC("A")="                    Patient:  "
 S AMHPAT=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 K AMHC Q
 S AMHPAT=+Y
 S X=AMHPAT D ^AMHPEDIT I '$D(X) S AMHC=AMHC+1 G GETPAT1
 I $G(AUPNDOD)]"" W !!?10,"***** PATIENT'S DATE OF DEATH IS ",$$FMTE^XLFDT(AUPNDOD),!! H 2
 W !?25,"Ok" S %=1 D YN^DICN I %'=1 S AMHPAT="" K AMHC Q
 K AMHC
 Q
DEL ;EP
 I $$IINTAKE^AMHLEDEL(AMHR) W !!,"This visit has an Initial Intake with Updates, it can not be deleted",!,"until the update documents have been deleted." D PAUSE Q
 S AMHVDLT=$P(^AMHREC(AMHR,0),U,16)
 S AMHRDEL=AMHR
 D EN^AMHLEDEL
 W !,"Record deleted." D PAUSE
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
RMENU ;EP
 W:$G(AMHACTN)'=1 !
 W !,"Update, add or append any of the following data"
 W !!,?5,"1). Update any of the following information:"
 W !,?10,"Designated Providers, Patient Flag"
 W !,?5,"2). Patient Case Open/Admit/Closed Data"
 W !,?5,"3). Personal History Information"
 W !?5,"4). Appointments (Scheduling System)"
 W !?5,"5). Treatment Plan Update"
 W !?5,"6). Print an Encounter Form"
 W !?5,"7). Add/Update/Print Intake Document"
 W !?5,"8). Add/Update Suicide Forms"
 W !,?5,"9). None of the Above (Quit)"
 Q
HEADER ;
 W:$D(IOF) @IOF
 W !,AMHDASH
 W !,"Date of Service:  ",$$FTIME^VALM1(AMHDATE),!,AMHDASH
 Q
PCCLINK ;EP -PCC LINK
 D PCCLINK^AMHLE2
 Q
 ;
EXIT ;CLEAN UP AND EXIT
 ;D TERM^VALM0
 S VALMBCK="R"
 ;D GATHER^AMHLEL
 ;S VALMCNT=AMHRCNT
 ;D HDR^AMHLE
 K AMHV,AMHF,AMHDR,AMHR,AMHQUIT,AMHRDEL,AMHV,AMHVDLT,AMHNAME,AMHPTSV,AMHX,AMHERROR,AMHR0,APCDPKG,APCDV,AMHNONE,AMHOKAY,AMHOTH,AMHSHIGH
 K X,Y,Z,I
 Q
1 ;
 I '$D(^AMHPATR(AMHPAT)) S DIC="^AMHPATR(",DIC(0)="L",DLAYGO=9002011.55,X="`"_AMHPAT D ^DIC I Y=-1 D ^XBFMK W !!,"FAILED TO ADD PATIENT TO BH PATIENT DATA FILE" Q
 S DA=AMHPAT,DDSFILE=9002011.55,DR="[AMH PATIENT RELATED DATA]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG Q
 Q
2 ;
 D EP^AMHLCD
 D FULL^VALM1
 Q
3 ;
 D PHX^AMHLE3
 Q
6 ;print encounter form
 I $G(AMHR),$G(AMHPAT) S %=AMHR,%1=AMHPAT D EN^XBNEW("PEF^AMHLE3","%;%1") Q
 D ^AMHLEFP
 ;clean up
 Q
4 ;scheduling system
 D APPT^AMHVRL2(AMHPAT)
 ;D RESET^AMHVRL
 Q
5 ;treatment Plan
 D EP1^AMHLETP(AMHPAT)
 Q
7 ;intake
 I $G(AMHR) D EP1^AMHLEIV(AMHR,AMHPAT) Q
 Q
8 ;suicide forms
 I $G(AMHR) D EN^AMHLESF
 Q
