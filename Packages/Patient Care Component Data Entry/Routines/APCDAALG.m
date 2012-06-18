APCDAALG ; IHS/CMI/LAB - ALLERGY ENTRY INTO ALLERGY PACKAGE ;
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;
 ;
EP ;
 I '$D(^XUSEC("GMRA-USER",DUZ)) W !!,"You have not been assigned the Allergy Tracking user key.",!,"Please see your supervisor.",! Q
 I $T(EN21^GMRAPEM0)="" W !!,"The Allergy tracking system has not been installed.",!,"Enter allergies through the problem list.",! Q
 S DFN=APCDPAT
 D EN^XBNEW("EP1^APCDAALG","DFN")
 I '$G(DFN) S DFN=APCDPAT
 D ALUDE
 Q
EP1 ;
 D EN21^GMRAPEM0
 D EN^XBVK("GMRA"),EN^XBVK("VA")
 Q
ANYACTA(APCDSDFN,EDATE) ;
 I $G(EDATE)="" S EDATE=DT
 NEW G,APCDNKAI,X,H,D
 I '$D(^GMR(120.8,"B",APCDSDFN)) Q 0
 I $O(^GMR(120.8,"ANKA",APCDSDFN,""))="n" I $O(^GMR(120.8,"ANKA",APCDSDFN,"n","")) Q 0
 S X="",G=0 F  S X=$O(^GMR(120.8,"B",APCDSDFN,X)) Q:(X="")!(G)  D
 .Q:$$TEST(X)
 .S H=$G(^GMR(120.8,X,0))
 .Q:'H
 .Q:$P(H,U,22)]""  ;DONT WANT IN EITHER CASE-N SHOULD ALREADY BE TAKEN CARE OF IN XREF AND NOT GET HERE AND IF Y NEED TO LOOK ELSEWHERE IHS/OKCAO/POC 5/25/2001
 .S D=$P($P(H,U,4),".",1)
 .Q:D=""
 .S G=1
 Q G
TEST(CHECKIT) ;CHECK IF VERIFED AND NOT ENTERED IN ERROR
 N CHECK
 S CHECK=0 ;CHECK=1 ENTERED IN ERROR OR NOT VERIFED
 ;S:$D(^GMR(120.8,CHECKIT,"ER")) CHECK=1
 S:$P($G(^GMR(120.8,CHECKIT,"ER")),U)=1 CHECK=1  ;CMI/GRL  *17*
 Q CHECK
ALUDE ;EP
 ;get provider who updated and date
 ;NEW APCDPRBI
 ;S APCDPRBI=DA
 S APCDP=$G(APCDPAT)
 I 'APCDP S APCDP=$G(DFN)
 S APCDV=$G(APCDVSIT)
 S APCDD=$G(APCDDATE)
 ;
 D EN^XBNEW("ALUDE1^APCDAALG","APCDP;APCDV;APCDD;APCDPRBI")
 Q
ALUDE1 ;EP - called from xbnew
 ;get date pl updated
 W !!
 K DIR
 S DIR(0)="Y",DIR("A")="Was the Allergy List Updated",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y Q
 S DIR(0)="D^::EPTSX",DIR("A")="Enter the Date the Allergy List was Updated by the Provider"
 S DIR("B")=$S($G(APCDD):$$FMTE^XLFDT($P(APCDD,".")),$G(APCDV):$$FMTE^XLFDT($$VD^APCLV(APCDV)),1:$$FMTE^XLFDT(DT)),DIR("?")="This is the visit date or the date the provider updated the Allergy list."
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required." G ALUDE1
 I $P(Y,".")>DT W !!,"Future Dates now allowed.",! G ALUDE1
 S APCDD=Y
ALUDE1P ;GET PROVIDER
 S DIR(0)="9000010.54,1204",DIR("A")="Enter the PROVIDER who Updated the Allergy List"
 S DIR("B")=$S($G(APCDV):$$PRIMPROV^APCLV(APCDV,"N"),1:"") KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required."  G ALUDE1P
 S APCDPRV=+Y
 D ALU($G(APCDPRBI),APCDV,APCDP,APCDD,APCDPRV,.APCDRET)
 I $P(APCDRET,U,1)=0 W !!,"error:  ",$P(APCDRET,U,2)
 Q
ALU(APCDPIEN,APCDV,APCDP,APCDD,APCDPRV,RETVAL) ;PEP - called to update Allergy update fields
 ;this API can be called to have a V UPDATED/REVIEWED entry and populate the
 ;.11, .12, and .13 fields
 ;input:  APCDPIEN - ien of Allergy entry
 ;        APCDV - ien of visit, if in the context of a visit
 ;        APCDP - DFN
 ;        APCDD - Date and optionally time of Allergy list update (fileman format)
 ;        APCDPRV = ien of provider updating the Allergy list
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
 I APCDV D ALUV Q
 ;NO VISIT SO CREATE EVENT VISIT AND CALL ALUV
 D EVSIT
 Q
ALUV ;have a visit so create a v updated/reviewed for provider APCDPRV if one does
 ;not exist on this visit already.
 NEW APCDX,APCDVD,APCDVRI,APCDVAL
 S APCDVAL=$O(^AUTTCRA("C","ALU",0))
 I APCDVAL="" S RETVAL="0^action item missing" Q
 S APCDVRI=""
 S APCDX=0 F  S APCDX=$O(^AUPNVRUP("AD",APCDV,APCDX)) Q:APCDX=""!(APCDVRI)  D
 .;is this entry a Allergy list review entry?
 .Q:$P(^AUPNVRUP(APCDX,0),U,1)'=APCDVAL  ;this one isn't a ALU entry
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
 .D ALUV
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
 D ALUV
 Q
ALR(APCDTDA) ;EP - called from naA template to create ALR entry
 D EN^XBNEW("ALR1^APCDAALG","APCDTDA")
 Q
ALR1 ;
 ;create MLR entry on this visit
 ;create V UPDATED/REVIEWED entry
 NEW APCDALVR,APCDVAL
 S APCDVAL=$O(^AUTTCRA("C","ALR",0))
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
