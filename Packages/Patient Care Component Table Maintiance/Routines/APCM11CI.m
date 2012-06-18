APCM11CI ; IHS/CMI/LAB - IHS area GPRA 10 Dec 2006 9:12 AM ;
 ;;2.0;IHS PCC SUITE;**6**;MAY 14, 2009;Build 11
 ;
CALCIND ;EP - CALCULATE ALL MEASURES
 ;for this patient get all of their visits in the time period and save in APCMVSTS for use in all measures
 K APCMVSTS,APCMHVTP
 D ALLV^APCLAPIU(DFN,APCMBDAT,APCMEDAT,"APCMVSTS")
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .S APCMHV=$$HADV(DFN,APCMP,APCMBDAT,APCMEDAT,.APCMVSTS)
 .I APCMHV S APCMHVTP(APCMP)=APCMHV
 ;all measures except attestation and non-patient
 I APCMRPTT=2 D
 .S APCMHV=$$HADVH(DFN,APCMFAC,APCMBDAT,APCMEDAT,.APCMVSTS) I APCMHV S APCMHVTP(APCMFAC)=APCMHV
 .S APCMVDOD=$$VDOD(DFN,APCMFAC,APCMBDAT,APCMEDAT,.APCMVSTS)  ;did patient have an H visit with Death as discharge type
 S APCMIC=0 F  S APCMIC=$O(APCMIND(APCMIC)) Q:APCMIC'=+APCMIC  D
 .Q:$P(^APCMMUM(APCMIC,0),U,6)="A"
 .Q:$P(^APCMMUM(APCMIC,0),U,12)=0
 .K APCMSTOP,APCMVAL,APCMVALU,A,B,C,D,E,F,G,H,I,J,K,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 .S APCMVALU=""
 .I $D(^APCMMUM(APCMIC,1)) X ^APCMMUM(APCMIC,1)
 Q
CALCINDA ;EP - CALCULATE ATTESTATION MEASURES
 S APCMIC=0 F  S APCMIC=$O(APCMIND(APCMIC)) Q:APCMIC'=+APCMIC  D
 .;Q:$P(^APCMMUM(APCMIC,0),U,6)="R"
 .Q:$P(^APCMMUM(APCMIC,0),U,12)=1
 .K APCMSTOP,APCMVAL,APCMVALU,A,B,C,D,E,F,G,H,I,J,K,M,N,O,P,Q,R,S,T,V,W,X,Y,Z,APCMVALU
 .K APCMN1,APCMD1
 .S APCMVALU=""
 .I $D(^APCMMUM(APCMIC,1)) X ^APCMMUM(APCMIC,1)
 Q
S1(BQITYP,BQIVAL) ; Return data by patient for iCare into global reference BQIGREF
 ;Input Variables
 ;  BQITYP - Type of value
 ;           D = Denominator
 ;           N = Numerator
 ;  BQIVAL - Value of the type; 0 or 1
 ;Assumed variables
 ;  APCMVALUE - the measure value
 ;  BQIGREF  - global reference where data will be stored temporarily
 ;  APCMIC    - Indicator IEN
 ;  APCMI     - Individual Indicator IEN
 ;  DFN      - Patient IEN
 ;
 ; If no value of BQIGREF, then it's the regular GPRA report calling the code
 ; and nothing needs to be set for iCare.
 Q:$G(BQIGREF)=""
 ;
 ; If no denominator or numerator value, then it doesn't need to be set for iCare
 I '$G(BQIVAL) Q
 ;
 NEW BQITIT,BQILTIT,BQILTIT1,BQILTIT2,BQILTIT3,BQILDTI1,BQILDTI2
 NEW BQIDTIT,BQIFTIT,BQITWEN,BQICURR,BQIIDTA,BQIDTA,BQILDTI3
 S BQIIDTA=$G(^APCMMUMC(APCMI,0))
 S BQIDTA=$G(^APCMMUMC(APCMI,14))
 ;
 ; Get the Individual Indicator TITLE (1404) 
 S BQITIT=$P(BQIDTA,U,4)
 ;
 ; Get the Individual Indicator LINE TITLE 1 (.15)
 S BQILTIT1=$P(BQIIDTA,U,15)
 I BQILTIT1="" Q
 ; Get the Individual Indicator LINE TITLE 2 and 3 (.16,.19) 
 S BQILTIT2=$P(BQIIDTA,U,16)
 S BQILTIT3=$P(BQIIDTA,U,19)
 S BQILTIT=BQILTIT1_" "_BQILTIT2_" "_BQILTIT3
 ;
 ; Get the Individual Indicator LOCAL DENOM TITLE 1, 2, and 3 (.17,.18,.21)
 S BQILDTI1=$P(BQIIDTA,U,17)
 S BQILDTI2=$P(BQIIDTA,U,18)
 S BQILDTI3=$P(BQIIDTA,U,21)
 S BQIDTIT=BQILDTI1_" "_BQILDTI2_" "_BQILDTI3
 ;
 ;  Full title is all title fields
 S BQIFTIT=BQITIT_" "_BQILTIT_" "_BQIDTIT
 S $P(@BQIGREF@(DFN,APCMIC,APCMI),"^",1)=BQIFTIT
 ;
 ;  Get the GOAL 2011 value and the GOAL 06 value
 S BQITWEN=$P(BQIDTA,U,3)
 S BQICURR=$P(BQIDTA,U,8)
 ;
 I BQITYP="N" S $P(@BQIGREF@(DFN,APCMIC,APCMI),"^",2)=$G(BQIVAL)
 ;
 I BQITYP="D" S $P(@BQIGREF@(DFN,APCMIC,APCMI),"^",3)=$G(BQIVAL)
 ;
 ;  Set the Indicator TITLE (.03)
 S $P(@BQIGREF@(DFN,APCMIC),U,1)=$P(^APCMMUM(APCMIC,0),U,3)
 S $P(@BQIGREF@(DFN,APCMIC),U,2)=$G(APCMVALU)
 I BQITWEN'="" S $P(@BQIGREF@(DFN,APCMIC),U,3)=BQITWEN
 I BQICURR'="" S $P(@BQIGREF@(DFN,APCMIC),U,4)=BQICURR
 Q
HADV(P,R,BD,ED,VSTS) ;EP - had visit of A, O, R, S with provider R in time frame BD-ED
 I '$G(P) Q ""
 I '$G(R) Q ""
 I '$G(BD) Q ""
 I '$G(ED) Q ""
 I '$D(^AUPNPAT(P,0)) Q ""
 I '$D(^VA(200,R,0)) Q ""
 NEW V,X,Y,G
 S G=""
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X!(G)  D
 .S V=$P(VSTS(X),U,5)
 .I '$D(^AUPNVSIT(V,0)) Q
 .I $P(^AUPNVSIT(V,0),U,11) Q  ;deleted
 .I "AOSM"'[$P(^AUPNVSIT(V,0),U,7) Q  ;not correct service category
 .;S Y=$$PRIMPROV^APCLV(V,"I")
 .;I 'Y Q
 .;I Y'=R Q  ;not this provider
 .S Y=0 F  S Y=$O(^AUPNVPRV("AD",V,Y)) Q:Y'=+Y!(G)  D
 ..I $P($G(^AUPNVPRV(Y,0)),U)'=R Q
 ..S G=$$VD^APCLV(V)
 Q G  ;quit on the date of the visit
 ;
HADVH(P,R,BD,ED,VSTS) ;EP - had visit H or ER A,O,S,M
 I '$G(P) Q ""
 I '$G(R) Q ""
 I '$G(BD) Q ""
 I '$G(ED) Q ""
 I '$D(^AUPNPAT(P,0)) Q ""
 I '$D(^DIC(4,R,0)) Q ""
 NEW V,X,Y,G,C
 S G=""
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X!(G)  D
 .S V=$P(VSTS(X),U,5)
 .I '$D(^AUPNVSIT(V,0)) Q
 .I $P(^AUPNVSIT(V,0),U,11) Q  ;deleted
 .I $P(^AUPNVSIT(V,0),U,6)'=R Q  ;not correct facility
 .I $P(^AUPNVSIT(V,0),U,7)="H" S G=$$VD^APCLV(V) Q
 .I $P(^AUPNVSIT(V,0),U,7)'="A" Q  ;not correct service category
 .S C=$$CLINIC^APCLV(V,"C")
 .;I C'=80,C'=30 Q
 .I C'=30 Q   ;per call on Feb. 18 (Hays)
 .S G=$$VD^APCLV(V)
 Q G  ;quit on the date of the visit
VDOD(P,R,BD,ED,VSTS) ;EP - had visit H or ER A,O,S,M
 I '$G(P) Q ""
 I '$G(R) Q ""
 I '$G(BD) Q ""
 I '$G(ED) Q ""
 I '$D(^AUPNPAT(P,0)) Q ""
 I '$D(^DIC(4,R,0)) Q ""
 NEW V,X,Y,G,C,H,D
 S G=""
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X!(G)  D
 .S V=$P(VSTS(X),U,5)
 .I '$D(^AUPNVSIT(V,0)) Q
 .I $P(^AUPNVSIT(V,0),U,11) Q  ;deleted
 .I $P(^AUPNVSIT(V,0),U,6)'=R Q  ;not correct facility
 .I $P(^AUPNVSIT(V,0),U,7)'="H" Q
 .S H=$O(^AUPNVINP("AD",V,0))
 .Q:'H
 .;get discharge type
 .S D=$$VAL^XBDIQ1(9000010.02,H,.06)
 .I D["DEATH" S G=V
 .;I $$VAL^XBDIQ1(9000010.02,H,6102)="EXPIRED"
 Q G  ;quit on the date of the visit
