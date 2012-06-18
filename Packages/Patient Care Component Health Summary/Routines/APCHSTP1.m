APCHSTP1 ; IHS/CMI/LAB -- CONTINUATION OF ROUTINES ;
 ;;2.0;IHS PCC SUITE;**2,5**;MAY 14, 2009
 ;IHS/CMI/LAB - uncommented age limit on pap smear
 ; 
 ; 
 ;
INRGOAL ;EP called from hmr
 Q:'$$INAC^APCHSMU(APCHSITI)  ;is item turned on or off
 Q:'$$ACTWARF(APCHSPAT,$$FMADD^XLFDT(DT,-45),DT)  ;not a candidate for this reminder, not active prescription for warfarin
 Q:$$MRGOAL^APCHSACG(APCHSPAT)]""  ;has had an INR goal ever
 S APCHLAST="",APCHNEXT="" K APCHSTEX
 I $G(APCHCOLW)="" S APCHCOLW=48
 D GETTPT^APCHSTP(APCHSITI,APCHCOLW,.APCHSTEX)
 D WRITETP^APCHSTP
 Q
INRDUR ;EP called from hmr
 Q:'$$INAC^APCHSMU(APCHSITI)  ;is item turned on or off
 Q:'$$ACTWARF(APCHSPAT,$$FMADD^XLFDT(DT,-45),DT)  ;not a candidate for this reminder, not active prescription for warfarin
 Q:$$MRDUR^APCHSACG(APCHSPAT)]""  ;has had an INR goal ever
 S APCHLAST="",APCHNEXT="" K APCHSTEX
 I $G(APCHCOLW)="" S APCHCOLW=48
 D GETTPT^APCHSTP(APCHSITI,APCHCOLW,.APCHSTEX)
 D WRITETP^APCHSTP
 Q
 ;
INREND ;EP called from hmr
 Q:'$$INAC^APCHSMU(APCHSITI)  ;is item turned on or off
 Q:'$$ACTWARF(APCHSPAT,$$FMADD^XLFDT(DT,-45),DT)  ;not a candidate for this reminder, not active prescription for warfarin
 NEW X,G
 S X=$P($$MREND^APCHSACG(APCHSPAT),U,1)  ;END DATE
 I X="" Q  ;no end date less than t+45
 S G=0
 S X=$P(X,U,1)
 I X<$$FMADD^XLFDT(DT,45) S G=1
 Q:'G  ;not a candidate
 S APCHLAST="",APCHNEXT="" K APCHSTEX
 I $G(APCHCOLW)="" S APCHCOLW=48
 D GETTPT^APCHSTP(APCHSITI,APCHCOLW,.APCHSTEX)
 D WRITETP^APCHSTP
 Q
ACURIN ;EP - called from hmr
 Q:'$$INAC^APCHSMU(APCHSITI)  ;is item turned on or off
 Q:'$$ACTWARF(APCHSPAT,$$FMADD^XLFDT(DT,-45),DT)  ;not a candidate for this reminder, not active prescription for warfarin
 NEW X,G
 S X=$$LASTACUR^APCHSACG(APCHSPAT)
 I $P(X,U,1)'<$$FMADD^XLFDT(DT,-365) Q  ;had one in past year
 S APCHLAST="",APCHNEXT="" K APCHSTEX
 I $G(APCHCOLW)="" S APCHCOLW=48
 D GETTPT^APCHSTP(APCHSITI,APCHCOLW,.APCHSTEX)
 D WRITETP^APCHSTP
 Q
ACCBC ;EP - called from hmr
 Q:'$$INAC^APCHSMU(APCHSITI)  ;is item turned on or off
 Q:'$$ACTWARF(APCHSPAT,$$FMADD^XLFDT(DT,-45),DT)  ;not a candidate for this reminder, not active prescription for warfarin
 NEW X,G
 S X=$$LASTACCB^APCHSACG(APCHSPAT)
 I $P(X,U,1)'<$$FMADD^XLFDT(DT,-365) Q  ;had one in past year
 S APCHLAST="",APCHNEXT="" K APCHSTEX
 I $G(APCHCOLW)="" S APCHCOLW=48
 D GETTPT^APCHSTP(APCHSITI,APCHCOLW,.APCHSTEX)
 D WRITETP^APCHSTP
 Q
ACFOBT ;EP - called from hmr
 Q:'$$INAC^APCHSMU(APCHSITI)  ;is item turned on or off
 Q:'$$ACTWARF(APCHSPAT,$$FMADD^XLFDT(DT,-45),DT)  ;not a candidate for this reminder, not active prescription for warfarin
 NEW X,G
 S X=$$LASTACFO^APCHSACG(APCHSPAT)
 I $P(X,U,1)'<$$FMADD^XLFDT(DT,-365) Q  ;had one in past year
 S APCHLAST="",APCHNEXT="" K APCHSTEX
 I $G(APCHCOLW)="" S APCHCOLW=48
 D GETTPT^APCHSTP(APCHSITI,APCHCOLW,.APCHSTEX)
 D WRITETP^APCHSTP
 Q
ACTWARF(P,BD,ED) ;EP - does patient have active presciption for warfarin, status=A in prescription file.
 NEW APCHMEDS,X,Y,Z,S,M,V,J,E
 I $G(BD)="" S BD=$$FMADD^XLFDT(DT,-365)
 I $G(ED)="" S ED=DT
 D GETMEDS^APCHSMU1(P,BD,ED,"BGP CMS WARFARIN MEDS",,,"WARFARIN",.APCHMEDS)
 ;now loop through all the meds and check status, if not A then kill out of array
 S Z=0 F  S Z=$O(APCHMEDS(Z)) Q:Z'=+Z  D
 .S M=$P(APCHMEDS(Z),U,4)
 .S V=$P(^AUPNVMED(M,0),U,3)
 .I $P(^AUPNVSIT(V,0),U,7)="E" Q  ;count all outside meds as we don't know if active or not so error on side of active
 .I $P($G(^AUPNVMED(M,11)),U,8)]"" Q  ;count EHR outside meds for now, may need to change later
 .I $P($G(^AUPNVMED(M,0)),U,8)<BD  Q  ;discontinued before beginning date
 .Q
 I $O(APCHMEDS(0)) Q 1
 Q 0
HOLDTHIS ;FOR LATER MAYBE
 D
 .S X=$O(^PSRX("APCC",M,0))
 .I 'X Q  ; FOR NOW CONSIDER IT AN OUTSIDE MED  K APCHMEDS(Z)  ;no prescription to check status
 .S S=$$VALI^XBDIQ1(52,X,100)
 .I S=0 Q  ;active
 .I S=3 Q  ;hold
 .I S=5 Q  ;SUSPENSE
 .;recently expired?
 .I S=11 D  Q
 ..;get expiration date
 ..S K=0
 ..S E=$P($G(^PSRX(P,3)),U,6)
 ..S R=$$CHRONIC^APCHS72(M)  ;chronic flag
 ..I 'R D  Q
 ...;not chronic, check to see if expired in past 14 days, if not quit
 ...S J=$$FMDIFF^XLFDT(DT,E)
 ...I J>14 K APCHMEDS(Z) Q  ;more than 14 days ago so don't display
 ..;chronic = check 120 days
 ..S J=$$FMDIFF^XLFDT(DT,E)
 ..I J>120 K APCHMEDS(Z)  ;expired more than 120 days ago
 .I S=12!(S=14) D
 ..S E=$P(^AUPNVMED(M,0),U,8)  ;discontinued date in v med
 ..I E="" S E=$P($G(^PSRX(P,3)),U,5)  ;canceled date in 52
 ..I $$FMDIFF^XLFDT(DT,E)>30 K APCHMEDS(Z) Q  ;only discontinueds in past 30 days
 .K APCHMEDS(Z)
 .Q
 I $O(APCHMEDS(0)) Q 1
 Q 0
