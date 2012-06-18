APCDAMED ; IHS/CMI/LAB - PROMPT FOR medication ; 12 Oct 2010  6:46 AM
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;
MLUDE ;EP - called from data entry input templates
 ;get provider who updated and date
 ;NEW APCDPRBI
 ;S APCDPRBI=DA
 S APCDP=$G(APCDPAT)
 I 'APCDP S APCDP=$G(DFN)
 S APCDV=$G(APCDVSIT)
 S APCDD=$G(APCDDATE)
 ;
 D EN^XBNEW("MLUDE1^APCDAMED","APCDP;APCDV;APCDD;APCDPRBI")
 Q
MLUDE1 ;EP - called from xbnew
 ;get date pl updated
 S DIR(0)="D^::EPTSX",DIR("A")="Enter the Date the Medication List was Updated by the Provider"
 S DIR("B")=$S($G(APCDD):$$FMTE^XLFDT($P(APCDD,".")),$G(APCDV):$$FMTE^XLFDT($$VD^APCLV(APCDV)),1:$$FMTE^XLFDT(DT)),DIR("?")="This is the visit date or the date the provider updated the medication list.  Enter the Time, if known."
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required." G MLUDE1
 I $P(Y,".")>DT W !!,"Future Dates now allowed.",! G MLUDE1
 S APCDD=Y
MLUDE1P ;GET PROVIDER
 S DIR(0)="9000010.54,1204",DIR("A")="Enter the PROVIDER who Updated the Medication List"
 S DIR("B")=$S($G(APCDV):$$PRIMPROV^APCLV(APCDV,"N"),1:"") KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"This is required."  G MLUDE1P
 S APCDPRV=+Y
 D MLU($G(APCDPRBI),APCDV,APCDP,APCDD,APCDPRV,.APCDRET)
 I $P(APCDRET,U,1)=0 W !!,"error:  ",$P(APCDRET,U,2)
 Q
MLU(APCDPIEN,APCDV,APCDP,APCDD,APCDPRV,RETVAL) ;PEP - called to update MEDICATION update fields
 ;this API can be called to have a V UPDATED/REVIEWED entry and populate the
 ;.11, .12, and .13 fields
 ;input:  APCDPIEN - ien of medication entry
 ;        APCDV - ien of visit, if in the context of a visit
 ;        APCDP - DFN
 ;        APCDD - Date and optionally time of medication list update (fileman format)
 ;        APCDPRV = ien of provider updating the medication list
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
 I APCDV D MLUV Q
 ;NO VISIT SO CREATE EVENT VISIT AND CALL MLUV
 D EVSIT
 Q
MLUV ;have a visit so create a v updated/reviewed for provider APCDPRV if one does
 ;not exist on this visit already.
 NEW APCDX,APCDVD,APCDVRI,APCDVAL
 S APCDVAL=$O(^AUTTCRA("C","MLU",0))
 I APCDVAL="" S RETVAL="0^action item missing" Q
 S APCDVRI=""
 S APCDX=0 F  S APCDX=$O(^AUPNVRUP("AD",APCDV,APCDX)) Q:APCDX=""!(APCDVRI)  D
 .;is this entry a medication list review entry?
 .Q:$P(^AUPNVRUP(APCDX,0),U,1)'=APCDVAL  ;this one isn't a MLU entry
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
 .D MLUV
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
 D MLUV
 Q
ANYACTM(APCDSDFN,EDATE) ;EP - medications component
 ;get all meds in the past year +30 days
 NEW APCDMEDS,APCDMED,X,M,I,N,D,APCDKEEP,APCDM,APCDRXN,APCDRXO,APCDRX0,APCDSREF,APCDSTAT,C,APCDN,APCDI,APCDD,APCDC
 NEW X,M,D,N,C,Z,P,I,EXPDT,Y
 ;
 ;store each drug by inverse date
 I '$G(EDATE) S EDATE=DT
 K APCDMED,APCDALL
 ;GET ALL PRESCRIPTIONS IN PHARMACY PATIENT FILE FOR -395 TO TODAY BY EXPIRATION DATE IN PS(55
 S EXPDT=$$FMADD^XLFDT(EDATE,-395)
 F  S EXPDT=$O(^PS(55,APCDSDFN,"P","A",EXPDT)) Q:EXPDT'=+EXPDT  D
 .S I=0 F  S I=$O(^PS(55,APCDSDFN,"P","A",EXPDT,I)) Q:I'=+I  D
 ..Q:'$D(^PSRX(I,0))
 ..S D=$P(^PSRX(I,0),U,6)
 ..I '$D(^PSDRUG(D,0)) Q  ;no drug
 ..S N=$P(^PSDRUG(D,0),U)
 ..S P=$P(^PSRX(I,0),U,2)
 ..I P'=APCDSDFN Q  ;oops, bad data
 ..S L=$P($G(^PSRX(I,3)),U,1)  ;last dispensed date
 ..I L="" S L=$O(^PSRX(I,1,"B",9999999),-1)
 ..I L="" S L=$P($G(^PSRX(I,2)),U,2)
 ..I L="" S L=$P(^PSRX(I,0),U,13)
 ..Q:L=""
 ..S L=9999999-L
 ..S S=$P($G(^PSRX(I,"STA")),U,1)
 ..Q:S=1
 ..Q:S=4
 ..Q:S=10
 ..Q:S=12
 ..Q:S=13
 ..Q:S=14
 ..Q:S=15
 ..Q:S=16
 ..S APCDALL(N,D,L,I)=S
 ;now kill off all except the latest one
 K APCDKEEP
 S N="" F  S N=$O(APCDALL(N)) Q:N=""  D
 .S D=0 F  S D=$O(APCDALL(N,D)) Q:D=""  D
 ..Q:$D(APCDKEEP(N,D))
 ..S L=$O(APCDALL(N,D,0))
 ..S I=$O(APCDALL(N,D,L,0))
 ..S APCDKEEP(N,D,L,I)=APCDALL(N,D,L,I)
 ;now go through and group them
 S N="" F  S N=$O(APCDKEEP(N)) Q:N=""  D
 .S D=0 F  S D=$O(APCDKEEP(N,D)) Q:D=""  D
 ..S L=0 F  S L=$O(APCDKEEP(N,D,L)) Q:L=""  D
 ...S I=0 F  S I=$O(APCDKEEP(N,D,L,I)) Q:I'=+I  D
 ....S S=APCDKEEP(N,D,L,I)
 ....I S=11 D GRP2 Q
 ....D GRP1
 ;NOW GET OUTSIDE MEDS DEFINED AS ANY WITH 1108 FIELD OR EVENT VISIT SERVICE CATEGORY
 K APCDMEDS,APCDM
 D GETMEDS^APCHSMU1(APCDSDFN,$$FMADD^XLFDT(DT,-365),DT,,,,,.APCDMEDS)
 ;store each drug by inverse date
 S X=0 F  S X=$O(APCDMEDS(X)) Q:X'=+X  D
 .S M=$P(APCDMEDS(X),U,4)
 .S V=$P(^AUPNVMED(M,0),U,3)
 .I $P(^AUPNVSIT(V,0),U,7)'="E",$P($G(^AUPNVMED(M,11)),U,8)="" Q
 .Q:$P(^AUPNVMED(M,0),U,8)  ;discontinued
 .S D=$P(^AUPNVMED(M,0),U,1)
 .S N=$S($P(^AUPNVMED(M,0),U,4)]"":$P(^AUPNVMED(M,0),U,4),1:$P(^PSDRUG(D,0),U,1))
 .S APCDM(N,D,(9999999-$P(APCDMEDS(X),U,1)))=APCDMEDS(X)
 ;now get rid of all except the latest one
 K APCDKEEP
 S N="" F  S N=$O(APCDM(N)) Q:N=""  D
 .S D=0 F  S D=$O(APCDM(N,D)) Q:D=""  D
 ..Q:$D(APCDMED(N,D))
 ..S X=$O(APCDM(N,D,0))
 ..S M=$P(APCDM(N,D,X),U,4)
 ..S APCDMED(1,N,D,X)=M_U_"M"
 I $O(APCDMED(0)) Q 1
 K APCDMED
 ;now get all NVA meds that did not move to PCC V MED
 S X=0 F  S X=$O(^PS(55,APCDSDFN,"NVA",X)) Q:X'=+X  D
 .I $P($G(^PS(55,APCDSDFN,"NVA",X,999999911)),U,1),$D(^AUPNVMED($P(^PS(55,APCDSDFN,"NVA",X,999999911),U,1),0)) Q  ;got this with V MED
 .S L=$P($P($G(^PS(55,APCDSDFN,"NVA",X,0)),U,10),".")
 .S L=9999999-L
 .I L<$$FMADD^XLFDT(DT,-365) Q
 .Q:$P(^PS(55,APCDSDFN,"NVA",X,0),U,6)=1  ;discontinued
 .I $P(^PS(55,APCDSDFN,"NVA",X,0),U,7)]""  ;discontinued date
 .S APCDMED(1)=""
 I $O(APCDMED(0)) Q 1
 ;NOW CHECK TO SEE IF THERE ARE ANY MEDS IN V MED IN THE PAST 30 DAYS
 K APCDMEDS
 D GETMEDS^APCHSMU1(APCDSDFN,$$FMADD^XLFDT(DT,-31),DT,,,,,.APCDMEDS)
 I $O(APCDMEDS(0)) Q 2
 Q 0
GRP2 ;
 Q:'$D(^PS(55,APCDSDFN,"P","CP",I))  ;CHRONIC ONLY
 S C=$S(I:$D(^PS(55,APCDSDFN,"P","CP",I)),1:0)
 S Y=$S(C:120,1:14)
 Q:$$FMDIFF^XLFDT(DT,$P($G(^PSRX(I,2)),U,6))>Y
 S APCDMED(2,N,D,L)=I_U_"P"
 Q
GRP1 ;
 S APCDMED(1,N,D,L)=I_U_"P"
 Q
MLR(APCDTDA) ;EP - called from nap template to create PLR entry
 D EN^XBNEW("MLR1^APCDAMED","APCDTDA")
 Q
MLR1 ;
 ;create MLR entry on this visit
 ;create V UPDATED/REVIEWED entry
 NEW APCDALVR,APCDVAL
 S APCDVAL=$O(^AUTTCRA("C","MLR",0))
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
