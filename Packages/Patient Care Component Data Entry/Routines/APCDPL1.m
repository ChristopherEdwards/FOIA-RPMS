APCDPL1 ; IHS/CMI/LAB - problem list update ;
 ;;2.0;IHS PCC SUITE;**5,6,7,10,15**;MAY 14, 2009;Build 11
 ;
 ;
DIE ;
 S DA=APCDPIEN,DIE="^AUPNPROB(",DR=APCDTEMP D ^DIE
KDIE ;
 K DIE,DR,DA,DIU,DIV,DQ,D0,DO,DI,DIW,DIY,%,DQ,DLAYGO
 Q
GETPROB ;get record
 S APCDPIEN=0
 S DIR(0)="N^1:"_APCDRCNT_":0",DIR("A")="Select Problem" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"No Problem Seleted" Q
 S APCDP=Y
 S (X,Y)=0 F  S X=$O(^TMP($J,"APCDPL","IDX",X)) Q:X'=+X!(APCDPIEN)  I $O(^TMP($J,"APCDPL","IDX",X,0))=APCDP S Y=$O(^TMP($J,"APCDPL","IDX",X,0)),APCDPIEN=^TMP($J,"APCDPL","IDX",X,Y)
 I '$D(^AUPNPROB(APCDPIEN,0)) W !,"Not a valid PCC PROBLEM." K APCDP S APCDPIEN=0 Q
 D FULL^VALM1
 Q
ADD ;EP - add prob
 D FULL^VALM1
 Q:'$G(APCDPLPT)
 S APCDPAT=APCDPLPT
 S:'$G(APCDLOC) APCDLOC=DUZ(2)
 S:$G(APCDDATE)="" APCDDATE=APCDNDT
 W:$D(IOF) @IOF W !,"Adding a new problem for ",$P(^DPT(APCDPLPT,0),U),".",!!
 D KDIE S DIE("NO^")=1,DLAYGO=9000011,DIE="^AUPNPAT(",DR="[APCD PO (ADD)]",DA=APCDPLPT D ^DIE D KDIE
 K DLAYGO D EXIT
 Q
EDIT ;EP - edit prob
 NEW APCDPIEN,APCDPAT,APCDIAIEP
 D GETPROB
 I 'APCDPIEN D PAUSE,EXIT Q
 S APCDPAT=APCDPLPT
 S:'$G(APCDLOC) APCDLOC=DUZ(2)
 S:$G(APCDDATE)="" APCDDATE=APCDNDT
 S APCDTEMP="[APCD MODIFY PROBLEM]"
 W:$D(IOF) @IOF W !!,"Editing Problem Number: ",$$GETNUM^APCDPL1(APCDPIEN),!
 I $P($G(^AUPNPROB(APCDPIEN,800)),U,1)]"" D  G ACT1
 .W !!,"This problem has been SNOMED coded, you can only edit the Status and",!,"Date of Onset fields."
 .S APCDIAEP=1
 K DIR
 S DIR(0)="9000011,.01",DIR("A")="Diagnosis",DIR("B")=$$GET1^DIQ(9000011,APCDPIEN,.01) KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I +Y'=$$GET1^DIQ(9000011,APCDPIEN,.01) D
 .S DIE="^AUPNPROB(",DR=".01////"_+Y,DA=APCDPIEN D ^DIE K DA,DR,DIE
 D DIE
 S DA=APCDPIEN
 S APCDVSIT=$G(APCDPLV)
 D PLUDE^APCDAPRB
 D EXIT
 Q
GETDX ;
 NEW DA,DIR,DIRUT,Y,X
 S APCDTNDX=$$GET1^DIQ(9000011,APCDTDA,.01,"I")
 S DIR(0)="9000011,.01",DIR("A")="Diagnosis",DIR("B")=$$GET1^DIQ(9000011,APCDTDA,.01) KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S APCDTNDX=+Y
 Q
DEL ;EP - delete prob
 NEW APCDPIEN,APCDPAT
 D GETPROB
 I 'APCDPIEN D PAUSE,EXIT Q
 W:$D(IOF) @IOF
 W !!,"Deleting the following Problem from ",$P($P(^DPT(APCDPLPT,0),U),",",2)," ",$P($P(^(0),U),","),"'s Problem List.",!
 S DA=APCDPIEN,DIC="^AUPNPROB(" D EN^DIQ
 ;
 W !!,"Please Note:  You are NOT permitted to delete a problem without",!,"entering a reason for the deletion."
 W ! S DIR(0)="Y",DIR("A")="Are you sure you want to delete this PROBLEM",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"okay, not deleted." D PAUSE,EXIT Q
 I 'Y W !,"Okay, not deleted." D PAUSE,EXIT Q
 S DA=APCDPIEN,DR="[APCD DELETE PROBLEM]",DIE="^AUPNPROB(" D ^DIE K DA,DIE,DR
 S APCDPAT=APCDPLPT
 S:$G(APCDDATE)="" APCDDATE=APCDNDT
 W !
 S APCDVSIT=$G(APCDPLV)
 S DA=APCDPIEN
 D PLUDE^APCDAPRB
 D PAUSE,EXIT,^XBFMK
 Q
AN ;EP - add a note
 NEW APCDPIEN
 D GETPROB
 I 'APCDPIEN D PAUSE,EXIT Q
 D NO1^APCDPL2
 D EXIT
 Q
MN ;EP -  modify a note
 NEW APCDPIEN
 D GETPROB
 I 'APCDPIEN D PAUSE,EXIT Q
 D MN1^APCDPL2
 D PAUSE,EXIT
 Q
RNO ;EP - remove a note
 NEW APCDPIEN
 D GETPROB
 I 'APCDPIEN D PAUSE,EXIT Q
 D RNO1^APCDPL2
 D PAUSE,EXIT
 Q
ACT ;EP - called from protocol
 NEW APCDPIEN,APCDNDT,APCDPAT
 S APCDNDT=$P(APCDDATE,".")
 D GETPROB
 I 'APCDPIEN D PAUSE,EXIT Q
 ;
ACT1 ;D DIE
 S DA=APCDPIEN,APCDTOLD=$P(^AUPNPROB(APCDPIEN,0),U,12)
 D CPS^APCDAPRB
 ;I $P(^AUPNPROB(APCDPIEN,0),U,12)=APCDTOLD G ACTE
 I $G(APCDIAEP) NEW DIE S DIE="^AUPNPROB(",DA=APCDPIEN,DR=".13" D ^DIE K DIE,DA,DR
 I '$G(APCDIAEP),$P(^AUPNPROB(APCDPIEN,0),U,12)=APCDTOLD G ACTE
 S APCDPAT=APCDPLPT
 S:'$G(APCDLOC) APCDLOC=DUZ(2)
 S:$G(APCDDATE)="" APCDDATE=APCDNDT
 S APCDVSIT=$G(APCDPLV)
 S DA=APCDPIEN
 D PLUDE^APCDAPRB
ACTE ;
 ;I $G(APCDIAEP) NEW DIE S DIE="^AUPNPROB(",DA=APCDPIEN,DR=".13" D ^DIE K DIE,DA,DR,APCDIAEP
 K APCDTOLD,APCDIAEP
 D EXIT
 Q
INACT ;EP - called from protocol to inactivate an active problem
 NEW APCDPIEN,APCDNDT,APCDPAT
 S APCDNDT=$P(APCDDATE,".")
 D GETPROB
 I 'APCDPIEN D PAUSE,EXIT Q
 I $P(^AUPNPROB(APCDPIEN,0),U,12)="I" W !!,"That problem is already INACTIVE!!",! D PAUSE,EXIT Q
 S APCDTEMP=".12///I;.03////^S X=APCDNDT;.14////^S X=DUZ"
 W:$D(IOF) @IOF W !,"Inactivating Problem ... "
 D DIE
 S APCDPAT=APCDPLPT
 ;S:'$G(APCDLOC) APCDLOC=DUZ(2)
 S:$G(APCDDATE)="" APCDDATE=APCDNDT
 S APCDPLV=$G(APCDVSIT)
 S DA=APCDPIEN
 D PLUDE^APCDAPRB
 D EXIT
 Q
HS ;EP - health summary
 D FULL^VALM1
 S X="" I DUZ(2),$D(^APCCCTRL(DUZ(2),0))#2 S X=$P(^(0),U,3) I X,$D(^APCHSCTL(X,0)) S X=$P(^APCHSCTL(X,0),U)
 I $D(^DISV(DUZ,"^APCHSCTL(")) S Y=^("^APCHSCTL(") I $D(^APCHSCTL(Y,0)) S X=$P(^(0),U,1)
 S:X="" X="ADULT REGULAR"
 K DIC,DR,DD S DIC("B")=X,DIC="^APCHSCTL(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DD,D0,D1,DQ
 I Y=-1 D PAUSE,EXIT Q
 S APCHSTYP=+Y,APCHSPAT=APCDPLPT
 S APCDHDR="PCC Health Summary for "_$P(^DPT(APCDPLPT,0),U)
 D VIEWR^XBLM("EN^APCHS",APCDHDR)
 S (DFN,Y)=APCDPLPT D ^AUPNPAT
 K APCHSPAT,APCHSTYP,APCHSTAT,APCHSMTY,AMCHDAYS,AMCHDOB,APCDHDR
 D EXIT
 Q
DD ;EP - called from protocol detail
 NEW APCDPIEN
 D GETPROB
 I 'APCDPIEN D PAUSE,EXIT Q
 D DIQ^XBLM(9000011,APCDPIEN)
 D EXIT
 Q
FS ;EP -FACE SHEET
 D FULL^VALM1
 S APCDHDR="Demographic Face Sheet For "_$P(^DPT(APCDPLPT,0),U)
 D VIEWR^XBLM("START^AGFACE",APCDHDR)
 K AGOPT,AGDENT,AGMVDF,APCDHDR
 D EXIT
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press return to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
GETNUM(P) ;EP - get problem number 
 NEW N,F
 S N=""
 I 'P Q N
 I '$D(^AUPNPROB(P,0)) Q N
 S F=$P(^AUPNPROB(P,0),U,6)
 S N=$S($P(^AUTTLOC(F,0),U,7)]"":$J($P(^(0),U,7),4),1:"??")_$P(^AUPNPROB(P,0),U,7)
 Q N
EXIT ;
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER^APCDPL
 S VALMCNT=APCDLINE
 D HDR^APCDPL
 K APCDTEMP,APCDPRMT,APCDP,APCDPIEN,APCDAF,APCDF,APCDP0,APCDPRB
 D KDIE
 Q
NAP ;EP - called from protocol
 D FULL^VALM1
 Q:'$G(APCDPLPT)
 I $$ANYACTP^APCDAPRB(APCDPLPT) D  Q
 .W !!,"There are active problems on this patient's problem list.  You"
 .W !,"cannot use this action item."
 .D PAUSE,EXIT Q
 S APCDPAT=APCDPLPT
 S:'$G(APCDLOC) APCDLOC=DUZ(2)
 S:$G(APCDDATE)="" APCDDATE=APCDNDT
NAPDE1 ;EP - called from xbnew
 S DIR(0)="Y",DIR("A")="Did the Provider indicate that the patient has No Active Problems",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !,"No action taken." D PAUSE,EXIT Q
 I 'Y W !,"No action taken." D PAUSE,EXIT Q
 S DIR(0)="D^::EPTSX",DIR("A")="Enter the Date the Provider documented 'No Active Problems'"
 S DIR("B")=$S($G(APCDDATE):$$FMTE^XLFDT($P(APCDDATE,".")),$G(APCDPLV):$$FMTE^XLFDT($$VD^APCLV(APCDPLV)),1:$$FMTE^XLFDT(DT)),DIR("?")="This is the visit date or the date the provider provided the information."
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required." G NAPDE1
 I $P(Y,".")>DT W !!,"Future Dates not allowed.",! G NAPDE1
 S APCDD=Y
NAPDE1P ;GET PROVIDER
 S DIR(0)="9000010.54,1204",DIR("A")="Enter the PROVIDER who documented 'No Active Problems'"
 S DIR("B")=$S($G(APCDPLV):$$PRIMPROV^APCLV(APCDPLV,"N"),1:"") KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required."  G NAPDE1P
 S APCDPRV=+Y
 D NAPADD($G(APCDPLV),APCDPAT,APCDD,APCDPRV,.APCDRET)
 I $P(APCDRET,U,1)=0 W !!,"error:  ",$P(APCDRET,U,2)
 D PAUSE,EXIT
 Q
NAPADD(APCDV,APCDP,APCDD,APCDPRV,RETVAL) ;PEP - called to update Problem list update fields
 ;this API can be called to have a V UPDATED/REVIEWED entry and populate the
 ;.11, .12, and .13 fields
 ;input:  
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
 I APCDV D NAPV Q
 ;NO VISIT SO CREATE EVENT VISIT AND CALL NAPV
 D EVSIT,NAPV
 Q
NAPV ;have a visit so create a v updated/reviewed for provider APCDPRV if one does
 ;not exist on this visit already.
 NEW APCDX,APCDVD,APCDVRI,APCDVAL
 S APCDVAL=$O(^AUTTCRA("C","NAP",0))
 I APCDVAL="" S RETVAL="0^action item missing" Q
 S APCDVRI=""
 S APCDX=0 F  S APCDX=$O(^AUPNVRUP("AD",APCDV,APCDX)) Q:APCDX=""!(APCDVRI)  D
 .;is this entry a problem list review entry?
 .Q:$P(^AUPNVRUP(APCDX,0),U,1)'=APCDVAL  ;this one isn't a NAP entry
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
 D PLRV
 Q
BSD ;
 NEW APCDBSDV,APCDIN,Y
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
 NEW APCDDATE,AUPNPAT,AUPNDOB,AUPNSEX,AUPNDOD,AUPNDAYS,APCDPAT
 D GETVISIT^APCDAPI4(.APCDIN,.APCDBSDV)
 ;S Y=APCDP D ^AUPNPAT
 S T=$P(APCDBSDV(0),U,2)
 I T]"" S RETVAL="0^could not create event visit" Q
 S V=$O(APCDBSDV(0)) S APCDV=V
 I $G(APCDBSDV(V))="ADD" D DEDT^APCDEA2(APCDV)
 Q
EVSIT ;EP - get/create event visit
 I $L($T(^BSDAPI4)) D  Q
 .D BSD
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
 Q
PLR ;EP - called from protocol
 NEW APCDPIEN,APCDNDT,APCDPAT
 S APCDNDT=$P(APCDDATE,".")
 D FULL^VALM1
 Q:'$G(APCDPLPT)
 S APCDPAT=APCDPLPT
 S:'$G(APCDLOC) APCDLOC=DUZ(2)
 S:$G(APCDDATE)="" APCDDATE=APCDNDT
PLRDE1 ;EP - called from xbnew
 S DIR(0)="Y",DIR("A")="Did the Provider indicate that he/she reviewed the Problem List",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !,"No action taken." D PAUSE,EXIT Q
 I 'Y W !,"No action taken." D PAUSE,EXIT Q
 S DIR(0)="D^::EPTSX",DIR("A")="Enter the Date the Provider Reviewed the Problem List"
 S DIR("B")=$S($G(APCDDATE):$$FMTE^XLFDT($P(APCDDATE,".")),$G(APCDPLV):$$FMTE^XLFDT($$VD^APCLV(APCDPLV)),1:$$FMTE^XLFDT(DT)),DIR("?")="This is the visit date or the date the provider provided the information."
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required." G PLRDE1
 I $P(Y,".")>DT W !!,"Future Dates not allowed.",! G PLRDE1
 S APCDD=Y
PLRDE1P ;GET PROVIDER
 S DIR(0)="9000010.54,1204",DIR("A")="Enter the PROVIDER who Reviewed the Problem List"
 S DIR("B")=$S($G(APCDPLV):$$PRIMPROV^APCLV(APCDPLV,"N"),1:"") KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required."  G PLRDE1P
 S APCDPRV=+Y
 D PLRADD($G(APCDPLV),APCDPAT,APCDD,APCDPRV,.APCDRET)
 I $P(APCDRET,U,1)=0 W !!,"error:  ",$P(APCDRET,U,2)
 D PAUSE,EXIT
 Q
PLRADD(APCDV,APCDP,APCDD,APCDPRV,RETVAL) ;PEP - called to update Problem list update fields
 ;this API can be called to have a V UPDATED/REVIEWED entry and populate the
 ;.11, .12, and .13 fields
 ;input:  
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
 I APCDV D PLRV Q
 ;NO VISIT SO CREATE EVENT VISIT AND CALL PLRV
 D EVSIT,PLRV
 Q
PLRV ;have a visit so create a v updated/reviewed for provider APCDPRV if one does
 ;not exist on this visit already.
 NEW APCDX,APCDVD,APCDVRI,APCDVAL
 S APCDVAL=$O(^AUTTCRA("C","PLR",0))
 I APCDVAL="" S RETVAL="0^action item missing" Q
 S APCDVRI=""
 S APCDX=0 F  S APCDX=$O(^AUPNVRUP("AD",APCDV,APCDX)) Q:APCDX=""!(APCDVRI)  D
 .;is this entry a problem list review entry?
 .Q:$P(^AUPNVRUP(APCDX,0),U,1)'=APCDVAL  ;this one isn't a PLR entry
 .Q:$P($G(^AUPNVRUP(APCDX,2)),U,1)
 .Q:$P($G(^AUPNVRUP(APCDX,12)),U,4)'=APCDPRV  ;not this provider
 .S APCDVRI=APCDX  ;found one so don't create one
 .Q
 I APCDVRI S RETVAL=APCDVRI Q
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
RESOLVE ;EP - called from protocol
 NEW APCDPIEN,APCDNDT,APCDPAT
 S APCDNDT=$P(APCDDATE,".")
 D GETPROB
 I 'APCDPIEN D PAUSE,EXIT Q
 I $P(^AUPNPROB(APCDPIEN,0),U,12)="R" W !!,"That problem is already RESOLVED!!",! D PAUSE,EXIT Q
 S APCDTEMP=".12///R;.03////^S X=APCDNDT;.14////^S X=DUZ"
 W:$D(IOF) @IOF W !,"Resolving Problem ... "
 D DIE
 S APCDPAT=APCDPLPT
 S:$G(APCDDATE)="" APCDDATE=APCDNDT
 S APCDPLV=$G(APCDVSIT)
 S DA=APCDPIEN
 D PLUDE^APCDAPRB
 D EXIT
 Q
