AMHAPRB ; IHS/CMI/LAB - PROMPT FOR PROBLEM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**2**;JUN 18, 2010;Build 23
 ;
PLUDE(AMHPRBI,AMHP,AMHV,AMHD,AMHTPRD) ;EP - called from data entry input templates
 ;
 D EN^XBNEW("PLUDE1^AMHAPRB","AMHP;AMHV;AMHD;AMHPRBI;AMHTPRD")
 Q
PLUDE1 ;EP - called from xbnew
 ;get date pl updated
 I $G(AMHD)="" S AMHD=$P(^AMHREC(AMHV,0),U,1)
 S DIR(0)="D^::EPTSX",DIR("A")="Enter the Date the Problem List was Updated by the Provider"
 S DIR("B")=$$FMTE^XLFDT(DT),DIR("?")="This is the visit date or the date the provider updated the problem list."
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required." G PLUDE1
 I $P(Y,".")>DT W !!,"Future Dates now allowed.",! G PLUDE1
 S AMHD=Y
PLUDE1P ;GET PROVIDER
 S DIR(0)="9002011.14,1204",DIR("A")="Enter the individual that updated the Problem List"
 S DIR("A",1)="Enter the individual that updated the Problem List. If you are"
 S DIR("A",2)="transcribing an update from a BHS provider, then enter the name"
 S DIR("A",3)="of the provider.  If you are a data entry/coder correcting the"
 S DIR("A",4)="Problem List (for instance, correcting the DSM code) then enter your"
 S DIR("A",5)="own name."
 S DIR("B")=$S($G(AMHV):$$PRIMPROV^AMHUTIL(AMHV,"N"),1:"") KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required."  G PLUDE1P
 S AMHPRV=+Y
 D PLU($G(AMHPRBI),AMHV,AMHP,AMHD,AMHPRV,.AMHRET)
 I $P(AMHRET,U,1)=0 W !!,"error:  ",$P(AMHRET,U,2)
 Q
PLU(AMHPIEN,AMHV,AMHP,AMHD,AMHPRV,RETVAL) ;PEP - called to update Problem list update fields
 ;this API can be called to have a V UPDATED/REVIEWED entry and populate the
 ;.11, .12, and .13 fields
 ;input:  AMHPIEN - ien of problem list entry
 ;        AMHV - ien of RECORD, if in the context of a visit
 ;        AMHP - DFN
 ;        AMHD - Date and optionally time of problem list update (fileman format)
 ;        AMHPRV = ien of provider updating the problem list
 ;this API will create a new V UPDATED/REVIEWED entry if there isn't currently one
 ;for Provider AMHP on date AMHD
 ;if not in the context of a visit (AMHV = null) then an event visit will be created
 ;with a V UPDATED/REVIEWED v file entry
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
 I AMHV D PLUV Q
 Q
PLUV ;have a visit so create a v updated/reviewed for provider AMHPRV if one does
 ;not exist on this visit already.
 NEW AMHX,AMHVD,AMHVRI,AMHVAL
 S AMHVAL=$O(^AUTTCRA("C","PLU",0))
 I AMHVAL="" S RETVAL="0^action item missing" Q
 S AMHVRI=""
 S AMHX=0 F  S AMHX=$O(^AMHRRUP("AD",AMHV,AMHX)) Q:AMHX=""!(AMHVRI)  D
 .;is this entry a problem list review entry?
 .Q:$P(^AMHRRUP(AMHX,0),U,1)'=AMHVAL  ;this one isn't a PLU entry
 .Q:$P($G(^AMHRRUP(AMHX,2)),U,1)
 .Q:$P($G(^AMHRRUP(AMHX,12)),U,4)'=AMHPRV  ;not this provider
 .S AMHVRI=AMHX  ;found one so don't create one
 .Q
 I AMHVRI S RETVAL=AMHVRI Q
 ;create MHSS UPDATED/REVIEWED entry
 S DIC="^AMHRRUP(",X=AMHVAL,DIC("DR")=".02////"_AMHP_";.03////"_AMHV_";1201////"_AMHD_";1204////"_AMHPRV,DIADD=1,DLAYGO=9002011.14,DIC(0)="EL"
 D FILE^DICN
 K DLAYGO,DIADD,DIC,DA
 Q
ANYACTP(P,EDATE) ;EP - does this patient have any active problems?
 I '$G(P) Q 0
 S EDATE=$G(EDATE)
 NEW X,Y,Z
 S Z=0
 S X=0 F  S X=$O(^AMHPPROB("AC",P,X)) Q:X'=+X!(Z)  D
 .Q:'$D(^AMHPPROB(X,0))
 .Q:$P(^AMHPPROB(X,0),U,12)'="A"
 .I EDATE,$P(^AMHPPROB(X,0),U,8)>EDATE Q
 .S Z=1
 .Q
 Q Z
PLUPCC(AMHREC,AMHPIEN,AMHP) ;EP
 I '$G(AMHREC) Q
 I '$D(^AMHREC(AMHREC,0)) Q
 NEW AMHV,DIE,DA,DR
 S AMHV=$P(^AMHREC(AMHREC,0),U,16)
 ;set field to let link know to create PCC V Updated/Reviewed entry that PCC PL was updated by BH provider
 S DA=AMHREC,DIE="^AMHREC(",DR="1801///"_$P(^AMHREC(AMHREC,0),U,1)_";1802////"_AMHP D ^DIE K DIE,DA,DR
 I 'AMHV Q  ;No pcc visit yet, it will get updated later
 ;create V updated/reviewed and attach it to the pcc visit.  call pcc routines
 NEW AMHVAL S AMHVAL=""
 D PLU^APCDAPRB($G(AMHPIEN),AMHV,$P(^AMHREC(AMHREC,0),U,8),$P(^AMHREC(AMHREC,0),U,1),$S(AMHP:AMHP,1:DUZ),.AMHVAL)
 Q
 ;
PLRPCC(AMHREC,AMHD,AMHPROV) ;EP
 I '$G(AMHREC) Q
 I '$D(^AMHREC(AMHREC,0)) Q
 NEW AMHV,DIE,DA,DR
 S AMHV=$P(^AMHREC(AMHREC,0),U,16)
 ;set field to let link know to create PCC V Updated/Reviewed entry that PCC PL was updated by BH provider
 S DA=AMHREC,DIE="^AMHREC(",DR="1803///"_$P(^AMHREC(AMHREC,0),U,1)_";1804////"_AMHPROV D ^DIE K DIE,DA,DR
 I 'AMHV Q  ;No pcc visit yet, it will get updated later
 ;create V updated/reviewed and attach it to the pcc visit.  call pcc routines
 NEW AMHVAL S AMHVAL=""
 D PLRADD^APCDPL1(AMHV,$P(^AMHREC(AMHREC,0),U,8),$P(^AMHREC(AMHREC,0),U,1),$S(AMHPROV:AMHPROV,1:DUZ),.AMHVAL)
 Q
 ;
NAPPCC(AMHREC,AMHD,AMHPROV) ;EP
 I '$G(AMHREC) Q
 I '$D(^AMHREC(AMHREC,0)) Q
 NEW AMHV,DIE,DA,DR
 S AMHV=$P(^AMHREC(AMHREC,0),U,16)
 ;set field to let link know to create PCC V Updated/Reviewed entry that PCC PL was updated by BH provider
 S DA=AMHREC,DIE="^AMHREC(",DR="1805///"_$P(^AMHREC(AMHREC,0),U,1)_";1806////"_AMHPROV D ^DIE K DIE,DA,DR
 I 'AMHV Q  ;No pcc visit yet, it will get updated later
 ;create V updated/reviewed and attach it to the pcc visit.  call pcc routines
 NEW AMHVAL S AMHVAL=""
 D NAPADD^APCDPL1(AMHV,$P(^AMHREC(AMHREC,0),U,8),$P(^AMHREC(AMHREC,0),U,1),$S(AMHPROV:AMHPROV,1:DUZ),.AMHVAL)
 Q
