AMHBPL3 ; IHS/CMI/LAB - problem list update from list manager ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**2**;JUN 18, 2010;Build 23
 ;
NAP ;EP - called from protocol to add a problem to problem list
 NEW AMHPRV,AMHD
 D FULL^VALM1
 I $$ANYACTP^AMHAPRB(AMHPAT) D  Q
 .W !!,"There are ACTIVE Problems on this patient's BH Problem list.  You"
 .W !,"cannot use this action item."
 .D PAUSE^AMHBPL1,EXIT^AMHBPL1 Q
NAPDE1 ;EP - called from xbnew
 S DIR(0)="Y",DIR("A")="Did the Provider indicate that the patient has No Active BH Problems",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !,"No action taken." D PAUSE^AMHBPL1,EXIT^AMHBPL1 Q
 I 'Y W !,"No action taken." D PAUSE^AMHBPL1,EXIT^AMHBPL1 Q
 S DIR(0)="D^::EPTSX",DIR("A")="Enter the Date the Provider documented 'No Active BH Problems'"
 S DIR("B")=$$FMTE^XLFDT(DT),DIR("?")="This is the visit date or the date the provider provided the information."
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required." G NAPDE1
 I $P(Y,".")>DT W !!,"Future Dates not allowed.",! G NAPDE1
 S AMHD=Y
NAPDE1P ;GET PROVIDER
 S DIR(0)="9002011.14,1204",DIR("A")="Enter the PROVIDER who documented 'No Active BH Problems'"
 S DIR("B")=$$PRIMPROV^AMHUTIL(AMHR,"N") KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required."  G NAPDE1P
 S AMHPRV=+Y
 D NAPADD(AMHR,AMHPAT,AMHD,AMHPRV,.AMHRET)
 I $P(AMHRET,U,1)=0 W !!,"error:  ",$P(AMHRET,U,2)
 D PAUSE^AMHBPL1,EXIT^AMHBPL1
 Q
NAPADD(AMHV,AMHP,AMHD,AMHPRV,RETVAL) ;PEP - called to update BH Problem list update fields
 ;this API can be called to have a MHSS RECORD UPDATED/REVIEWED entry and populate the
 ;
 ;RETURN VALUE:
 ;            ien of MHSS RECORD UPDATED/REVIEWED entry that was created
 ;             or 0^error message
 S AMHV=$G(AMHV)
 S AMHP=$G(AMHP)
 I 'AMHP S RETVAL="0^not a valid patient DFN" Q
 I '$D(^AUPNPAT(AMHP,0)) S RETVAL="0^not a valid patient DFN" Q
 S AMHD=$G(AMHD)
 I 'AMHD S RETVAL="0^no valid date passed" Q
 S AMHPRV=$G(AMHPRV)
 I 'AMHPRV S RETVAL="0^no valid provider ien passed" Q
 S RETVAL=""
 ;
 I AMHV D NAPV Q
 Q
NAPV ;have a visit so create a MHSS RECORD updated/reviewed for provider AMHPRV if one does
 ;not exist on this visit already.
 NEW AMHX,AMHVD,AMHVRI,AMHVAL
 S AMHVAL=$O(^AUTTCRA("C","NAP",0))
 I AMHVAL="" S RETVAL="0^action item missing" Q
 S AMHVRI=""
 S AMHX=0 F  S AMHX=$O(^AMHRRUP("AD",AMHV,AMHX)) Q:AMHX=""!(AMHVRI)  D
 .;is this entry a problem list review entry?
 .Q:$P(^AMHRRUP(AMHX,0),U,1)'=AMHVAL  ;this one isn't a NAP entry
 .Q:$P($G(^AMHRRUP(AMHX,2)),U,1)
 .Q:$P($G(^AMHRRUP(AMHX,12)),U,4)'=AMHPRV  ;not this provider
 .S AMHVRI=AMHX  ;found one so don't create one
 .Q
 I AMHVRI S RETVAL=AMHVRI D PLRV Q
 S DIC="^AMHRRUP(",X=AMHVAL,DIC("DR")=".02////"_AMHP_";.03////"_AMHV_";1201////"_AMHD_";1204////"_AMHPRV,DIADD=1,DLAYGO=9002011.14,DIC(0)="EL"
 D FILE^DICN
 K DLAYGO,DIADD,DIC,DA
 D PLRV
 Q
PLR ;EP - called from protocol to add a problem to problem list
 NEW AMHPIEN,AMHNDT
 D FULL^VALM1
PLRDE1 ;EP - called from xbnew
 S DIR(0)="Y",DIR("A")="Did the Provider indicate that he/she reviewed the Problem List",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !,"No action taken." D PAUSE^AMHBPL1,EXIT^AMHBPL1 Q
 I 'Y W !,"No action taken." D PAUSE^AMHBPL1,EXIT^AMHBPL1 Q
 S DIR(0)="D^::EPTSX",DIR("A")="Enter the Date the Provider Reviewed the Problem List"
 S DIR("B")=$$FMTE^XLFDT(DT),DIR("?")="This is the visit date or the date the provider provided the information."
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required." G PLRDE1
 I $P(Y,".")>DT W !!,"Future Dates not allowed.",! G PLRDE1
 S AMHD=Y
PLRDE1P ;GET PROVIDER
 S DIR(0)="9002011.14,1204",DIR("A")="Enter the PROVIDER who Reviewed the Problem List"
 S DIR("B")=$$PRIMPROV^AMHUTIL(AMHR,"N") KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required."  G PLRDE1P
 S AMHPRV=+Y
 D PLRADD(AMHR,AMHPAT,AMHD,AMHPRV,.AMHRET)
 I $P(AMHRET,U,1)=0 W !!,"error:  ",$P(AMHRET,U,2)
 D PAUSE^AMHBPL1,EXIT^AMHBPL1
 Q
PLRADD(AMHV,AMHP,AMHD,AMHPRV,RETVAL) ;PEP - called to update Problem list update fields
 ;this API can be called to have a V UPDATED/REVIEWED entry and populate the
 ;
 ;RETURN VALUE:
 ;            ien of V UPDATED/REVIEWED entry that was created
 ;             or 0^error message
 S AMHPIEN=$G(AMHPIEN)
 S AMHV=$G(AMHV)
 S AMHP=$G(AMHP)
 I 'AMHP S RETVAL="0^not a valid patient DFN" Q
 I '$D(^AUPNPAT(AMHP,0)) S RETVAL="0^not a valid patient DFN" Q
 S AMHD=$G(AMHD)
 I 'AMHD S RETVAL="0^no valid date passed" Q
 S AMHPRV=$G(AMHPRV)
 I 'AMHPRV S RETVAL="0^no valid provider ien passed" Q
 S RETVAL=""
 ;
 I AMHV D PLRV Q
 Q
PLRV ;have a visit so create a v updated/reviewed for provider AMHPRV if one does
 ;not exist on this visit already.
 NEW AMHX,AMHVD,AMHVRI,AMHVAL
 S AMHVAL=$O(^AUTTCRA("C","PLR",0))
 I AMHVAL="" S RETVAL="0^action item missing" Q
 S AMHVRI=""
 S AMHX=0 F  S AMHX=$O(^AMHRRUP("AD",AMHV,AMHX)) Q:AMHX=""!(AMHVRI)  D
 .;is this entry a problem list review entry?
 .Q:$P(^AMHRRUP(AMHX,0),U,1)'=AMHVAL  ;this one isn't a PLR entry
 .Q:$P($G(^AMHRRUP(AMHX,2)),U,1)
 .Q:$P($G(^AMHRRUP(AMHX,12)),U,4)'=AMHPRV  ;not this provider
 .S AMHVRI=AMHX  ;found one so don't create one
 .Q
 I AMHVRI S RETVAL=AMHVRI Q
 S DIC="^AMHRRUP(",X=AMHVAL,DIC("DR")=".02////"_AMHP_";.03////"_AMHV_";1201////"_AMHD_";1204////"_AMHPRV,DIADD=1,DLAYGO=9002011.14,DIC(0)="EL"
 D FILE^DICN
 K DLAYGO,DIADD,DIC,DA
 Q
 ;
