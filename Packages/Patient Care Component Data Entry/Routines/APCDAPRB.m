APCDAPRB ; IHS/CMI/LAB - PROMPT FOR PROBLEM ;
 ;;2.0;IHS PCC SUITE;**5,6**;MAY 14, 2009;Build 11
 ;
START ;
 X:$D(^DD(9000011,.01,12.1)) ^DD(9000011,.01,12.1) S DIC="^ICD9(",DIC(0)="AEMQ",DIC("A")="Enter Problem Diagnosis: " D ^DIC K DIC
 G:Y="" XIT
 I Y=-1,X=""!(X="^") S APCDTSKI=1,APCDLOOK="" G XIT
 I Y=-1 S APCDTERR=1,APCDLOOK="" G XIT
 S APCDLOOK="`"_+Y,APCDTNQP=X
XIT K Y,X,DO,D,DD,DIPGM
 Q
PL ;EP
 I $G(APCDDATE)="" S APCDDATE=DT
 I $G(APCDLOC)="" S APCDLOC=DUZ(2)
 S DFN=APCDPAT,Y=APCDPAT D ^AUPNPAT K Y
 S APCDPLL=APCDLOC,APCDPLD=$P(APCDDATE,".")
 S APCDPLV=$G(APCDVSIT)
 I APCDPLV<0 S APCDPLV=""
 D EN^XBNEW("PL1^APCDAPRB","DFN;APCDPLL;APCDPLD;APCDPLV;VALM*")
 Q
PL1 ;EP
 D TERM^VALM0
 D ENDE^APCDPL
 Q
PO ;EP
 S DIE="^AUPNPAT(",DR="[APCD PO (ADD)]",DA=APCDPAT D ^DIE K DA,DR,DIE
 Q
MPO ;EP
 S DIE="^AUPNPAT(",DR="[APCD MPO (MPO)]",DA=APCDPAT D ^DIE K DA,DR,DIE
 Q
RPO ;EP
 S DIE="^AUPNPAT(",DR="[APCD RPO (RPO)]",DA=APCDPAT D ^DIE K DA,DR,DIE
 Q
IPO ;EP
 S DIE="^AUPNPAT(",DR="[APCD IPO (IPO)]",DA=APCDPAT D ^DIE K DA,DR,DIE
 Q
APO ;EP
 S DIE="^AUPNPAT(",DR="[APCD APO (APO)]",DA=APCDPAT D ^DIE K DA,DR,DIE
 Q
MNN ;EP
 S DIE="^AUPNPAT(",DR="[APCD MNN (MNN)]",DA=APCDPAT D ^DIE K DA,DR,DIE
 Q
RNO ;EP
 S DIE="^AUPNPAT(",DR="[APCD RNO (RNO)]",DA=APCDPAT D ^DIE K DA,DR,DIE
 Q
PDSP ;EP
 S DIE="^AUPNPAT(",DR="[APCD PDSP (PDSP)]",DA=APCDPAT D ^DIE K DA,DR,DIE
 Q
NON ;EP called from APCD NO (ADD) template
 D ^XBNEW("NO^APCDAPRB:APCD*")
 Q
NOP ;EP called from APCD PO (ADD) template
 NEW APCDADDP
 S APCDADDP=1
 D ^XBNEW("NO1^APCDAPRB:APCD*")
 Q
NO ;EP add a note to a problem
 D ^APCDPROB
 K DIR,DIRUT S DIR(0)="F^1:12",DIR("A")="Enter Problem Number" K DA D ^DIR K DIR
 G:$D(DIRUT) NOX
 S APCDPR=Y
 D ^APCDPLK
 I APCDPERR=1 W $C(7),$C(7),"Not a valid problem number.",! K APCDPERR G NO
 ;display existing notes, get next note number
NO1 ;EP
 S APCDPROB=APCDPDFN
 I APCDPROB["`" S APCDPROB=$P(APCDPROB,"`",2)
 ;I $G(APCDPR)]"" W !!,"Problem Number: ",APCDPR,?40,"Diagnosis: ",$P(^ICD9($P(^AUPNPROB(APCDPROB,0),U),0),U)
 I $G(APCDPR)]"" W !!,"Problem Number: ",APCDPR,?40,"Diagnosis: ",$P($$ICDDX^ICDCODE($P(^AUPNPROB(APCDPROB,0),U)),U,2)
 I $O(^AUPNPROB(APCDPROB,11,0)) D
 .W !,"Problem Notes:  " S L=0 F  S L=$O(^AUPNPROB(APCDPROB,11,L)) Q:L'=+L  I $O(^AUPNPROB(APCDPROB,11,L,11,0)) W !?5,$P(^DIC(4,$P(^AUPNPROB(APCDPROB,11,L,0),U),0),U) D
 ..S X=0 F  S X=$O(^AUPNPROB(APCDPROB,11,L,11,X)) Q:X'=+X  W !?10,"Note#",$P(^AUPNPROB(APCDPROB,11,L,11,X,0),U)," ",$$FMTE^XLFDT($P(^(0),U,5),5),?28,$P(^AUPNPROB(APCDPROB,11,L,11,X,0),U,3)
 W ! S DIR(0)="Y",DIR("A")="Add a new Problem Note for this Problem",DIR("B")="N" K DA D ^DIR K DIR
 G:$D(DIRUT) NOX
 G:Y=0 NOX
 ;get next note number
NUM ;
 ;add location multiple if necessary, otherwise get ien in multiple
 S APCDNIEN=$O(^AUPNPROB(APCDPROB,11,"B",APCDLOC,0))
 I APCDNIEN="" S X="`"_APCDLOC,DIC="^AUPNPROB("_APCDPROB_",11,",DA(1)=APCDPROB,DIC(0)="L",DIC("P")=$P(^DD(9000011,1101,0),U,2) D ^DIC K DIC,DA,DR,Y,X S APCDNIEN=$O(^AUPNPROB(APCDPROB,11,"B",APCDLOC,0))
 I APCDNIEN="" W $C(7),$C(7),"ERROR UPDATING NOTE LOCATION MULTIPLE" G NOX
 S (Y,X)=0 F  S Y=$O(^AUPNPROB(APCDPROB,11,APCDNIEN,11,"B",Y)) S:Y X=Y I 'Y S X=X+1 K Y Q
 S APCDNUM=X
 W !!,"Adding ",$P(^DIC(4,APCDLOC,0),U)," Note #",X
 K DIC S X=APCDNUM,DA(1)=APCDNIEN,DA(2)=APCDPROB,DIC="^AUPNPROB("_APCDPROB_",11,"_APCDNIEN_",11,",DIC("P")=$P(^DD(9000011.11,1101,0),U,2),DIC(0)="L" D ^DIC K DA,DR
 I Y=-1 W !!,$C(7),$C(7),"ERROR when updating note number multiple",! G NOX
 S DIE=DIC K DIC W ?10 S %=$S($G(APCDDATE):$P(APCDDATE,"."),1:DT),DA=+Y,DR=".03;.05///^S X=%" D ^DIE K DIE,DR,DA,Y W !!
 S DIE="^AUPNPROB(",DA=APCDPROB,%=$S($G(APCDDATE):$P(APCDDATE,"."),1:DT),DR=".03////"_%_";.14////"_DUZ D ^DIE K DIE,DA,DR,Y
 S DA=APCDPROB
 I '$G(APCDADDP) D PLUDE
 G NO1
 Q
NOX ;
 K Y,APCDPROB,X,L,APCDNUM,APCDNIEN,DIC,DA,DD
 Q
PLUDE ;EP - called from data entry input templates
 ;get provider who updated and date
 ;NEW APCDPRBI
 S APCDTPRD=$G(APCDTPRD)
 S APCDPRBI=DA
 S APCDP=$G(APCDPAT)
 I 'APCDP S APCDP=$G(DFN)
 S APCDV=$G(APCDVSIT)
 I APCDV<0 S APCDV=""
 S APCDD=$G(APCDDATE)
 ;
 D EN^XBNEW("PLUDE1^APCDAPRB","APCDP;APCDV;APCDD;APCDPRBI;APCDTPRD")
 Q
PLUDE1 ;EP - called from xbnew
 ;get date pl updated
 S DIR(0)="D^::EPTSX",DIR("A")="Enter the Date the Problem List was Updated by the Provider"
 S DIR("B")=$S($G(APCDD):$$FMTE^XLFDT($P(APCDD,".")),$G(APCDV):$$FMTE^XLFDT($$VD^APCLV(APCDV)),1:$$FMTE^XLFDT(DT)),DIR("?")="This is the visit date or the date the provider updated the problem list."
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required." G PLUDE1
 I $P(Y,".")>DT W !!,"Future Dates now allowed.",! G PLUDE1
 S APCDD=Y
PLUDE1P ;GET PROVIDER
 S DIR(0)="9000010.54,1204",DIR("A")="Enter the INDIVIDUAL who Updated the Problem List"
 S DIR("A",1)="Enter the individual that updated the problem list.  "
 S DIR("A",2)="If you are transcribing an update from a PCC Provider, then enter"
 S DIR("A",3)="the individual who requested the change.  If you are data "
 S DIR("A",4)="entry/coder correcting the problem entry such as correcting the "
 S DIR("A",5)="ICD9 code, then enter yourself."
 S DIR("B")=$S($G(APCDTPRD):$P(^VA(200,APCDTPRD,0),U,1),$G(APCDV):$$PRIMPROV^APCLV(APCDV,"N"),1:"") KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required."  G PLUDE1P
 S APCDPRV=+Y
 D PLU($G(APCDPRBI),APCDV,APCDP,APCDD,APCDPRV,.APCDRET)
 I $P(APCDRET,U,1)=0 W !!,"error:  ",$P(APCDRET,U,2)
 Q
PLU(APCDPIEN,APCDV,APCDP,APCDD,APCDPRV,RETVAL) ;PEP - called to update Problem list update fields
 ;this API can be called to have a V UPDATED/REVIEWED entry and populate the
 ;.11, .12, and .13 fields
 ;input:  APCDPIEN - ien of problem list entry
 ;        APCDV - ien of visit, if in the context of a visit
 ;        APCDP - DFN
 ;        APCDD - Date and optionally time of problem list update (fileman format)
 ;        APCDPRV = ien of provider updating the problem list
 ;this API will create a new V UPDATED/REVIEWED entry if there isn't currently one
 ;for Provider APCDP on date APCDD
 ;if not in the context of a visit (APCDV = null) then an event visit will be created
 ;with a V UPDATED/REVIEWED v file entry
 ;
 ;RETURN VALUE:
 ;            ien of V UPDATED/REVIEWED entry that was created
 ;             or 0^error message
 S APCDPIEN=$G(APCDPIEN)
 S APCDV=$G(APCDV)
 S APCDP=$G(APCDP)
 I 'APCDP S RETVAL="0^not a valid patient DFN" Q
 I '$D(^AUPNPAT(APCDP,0)) S RETVAL="0^not a valid patient DFN" Q
 S APCDD=$G(APCDD)
 I 'APCDD S RETVAL="0^no valid date passed" Q
 S APCDPRV=$G(APCDPRV)
 I 'APCDPRV S RETVAL="0^no valid provider ien passed" Q
 S RETVAL=""
 ;
 I APCDV D PLUV Q
 ;NO VISIT SO CREATE EVENT VISIT AND CALL PLUV
 D EVSIT
 Q
PLUV ;have a visit so create a v updated/reviewed for provider APCDPRV if one does
 ;not exist on this visit already.
 NEW APCDX,APCDVD,APCDVRI,APCDVAL
 S APCDVAL=$O(^AUTTCRA("C","PLU",0))
 I APCDVAL="" S RETVAL="0^action item missing" Q
 S APCDVRI=""
 S APCDX=0 F  S APCDX=$O(^AUPNVRUP("AD",APCDV,APCDX)) Q:APCDX=""!(APCDVRI)  D
 .;is this entry a problem list review entry?
 .Q:$P(^AUPNVRUP(APCDX,0),U,1)'=APCDVAL  ;this one isn't a PLU entry
 .Q:$P($G(^AUPNVRUP(APCDX,2)),U,1)
 .Q:$P($G(^AUPNVRUP(APCDX,12)),U,4)'=APCDPRV  ;not this provider
 .S APCDVRI=APCDX  ;found one so don't create one
 .Q
 I APCDVRI S RETVAL=APCDVRI Q
 ;create V UPDATED/REVIEWED entry
 NEW APCDALVR
 S APCDALVR("APCDPAT")=APCDP
 S APCDALVR("APCDVSIT")=APCDV
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.54 (ADD)]"
 S APCDALVR("APCDTCLA")="`"_APCDVAL
 S APCDALVR("APCDTCDT")=APCDD
 S APCDALVR("APCDTEPR")="`"_APCDPRV
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) S RETVAL=0_"^Error creating V UPDATED/REVIEWED entry.  PCC not updated."
 K APCDALVR
 Q
BSD ;
 NEW APCDBSDV
 K APCDIN
 S APCDIN("PAT")=APCDP
 S APCDIN("VISIT DATE")=APCDD_".12"
 S APCDIN("SITE")=DUZ(2)
 S APCDIN("VISIT TYPE")=$S($P($G(^APCCCTRL(DUZ(2),0)),U,4)]"":$P(^APCCCTRL(DUZ(2),0),U,4),1:"O")
 S APCDIN("SRV CAT")="E"
 S APCDIN("TIME RANGE")=0
 S APCDIN("USR")=DUZ
 K APCDALVR
 K APCDBSDV
 D GETVISIT^APCDAPI4(.APCDIN,.APCDBSDV)
 S T=$P(APCDBSDV(0),U,2)
 I T]"" S RETVAL="0^could not create event visit" Q   ;errored
 S V=$O(APCDBSDV(0)) S APCDV=V
 I $G(APCDBSDV(V))="ADD" D DEDT^APCDEA2(APCDV)
 Q
EVSIT ;EP - get/create event visit
 I $L($T(^BSDAPI4)) D  Q
 .D BSD
 .D PLUV
 K APCDVSIT
 K APCDALVR
 S APCDALVR("APCDAUTO")=""
 S APCDALVR("APCDPAT")=APCDP
 S APCDALVR("APCDCAT")="E"
 S APCDALVR("APCDLOC")=DUZ(2)
 S APCDALVR("APCDTYPE")=$S($P($G(^APCCCTRL(DUZ(2),0)),U,4)]"":$P(^APCCCTRL(DUZ(2),0),U,4),1:"O")
 S APCDALVR("APCDDATE")=APCDD_".12"
 D ^APCDALV
 S APCDV=$G(APCDALVR("APCDVSIT"))
 I $G(APCDALVR("APCDVSIT","NEW")) D DEDT^APCDEA2(APCDVSIT)
 K APCDALVR
 D PLUV
 Q
ANYACTP(P,EDATE) ;EP - does this patient have any active problems?
 I '$G(P) Q 0
 S EDATE=$G(EDATE)
 NEW X,Y,Z
 S Z=0
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(Z)  D
 .Q:'$D(^AUPNPROB(X,0))
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .I EDATE,$P(^AUPNPROB(X,0),U,8)>EDATE Q
 .S Z=1
 .Q
 Q Z
PLR(APCDTDA) ;EP - called from nap template to create PLR entry
 D EN^XBNEW("PLR1^APCDAPRB","APCDTDA")
 Q
PLR1 ;
 ;create PLR entry on this visit
 ;create V UPDATED/REVIEWED entry
 NEW APCDALVR,APCDVAL
 S APCDVAL=$O(^AUTTCRA("C","PLR",0))
 S APCDALVR("APCDPAT")=$P(^AUPNVRUP(APCDTDA,0),U,2)
 S APCDALVR("APCDVSIT")=$P(^AUPNVRUP(APCDTDA,0),U,3)
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.54 (ADD)]"
 S APCDALVR("APCDTCLA")="`"_APCDVAL
 S APCDALVR("APCDTCDT")=$P($G(^AUPNVRUP(APCDTDA,12)),U,1)
 I $P($G(^AUPNVRUP(APCDTDA,12)),U,4) S APCDALVR("APCDTEPR")="`"_$P(^AUPNVRUP(APCDTDA,12),U,4)
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) S RETVAL=0_"^Error creating V UPDATED/REVIEWED entry.  PCC not updated."
 K APCDALVR
 Q
