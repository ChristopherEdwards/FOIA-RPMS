APCM11E6 ;IHS/CMI/LAB - IHS MU;  ; 10 Feb 2011  2:09 PM
 ;;2.0;IHS PCC SUITE;**6**;MAY 14, 2009;Build 11
 ;;;;;;Build 3
ADV ;EP - CALCULATE adv directives
 NEW APCMP,APCMZ
 S (APCMD1,APCMN1)=0
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .I $D(APCMHO65(APCMP,APCMTIME)) S F=$P(^APCMMUM(APCMIC,0),U,11) D  Q
 ..D S^APCM11E1(APCMRPT,APCMIC,"Hospital is excluded from this measure as it did not admit anyone >=65 during the EHR Reporting Period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .S APCMZ=$$HASADM65(DFN,APCMP,.APCMVSTS)
 .Q:APCMZ=""  ;NO ADMISSION
 .D ADV1
 .Q
 Q
HASADM65(P,R,VSTS) ;
 NEW X,Y,Z,V,G
 S G=""
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X!(G)  D
 .S V=$P(VSTS(X),U,5)
 .I '$D(^AUPNVSIT(V,0)) Q
 .I $P(^AUPNVSIT(V,0),U,11) Q
 .I $P(^AUPNVSIT(V,0),U,7)'="H" Q  ;not correct service category
 .Q:$P(^AUPNVSIT(V,0),U,6)'=APCMP  ;not this facility
 .Q:$$AGE^AUPNPAT(P,$$VD^APCLV(V))<65  ;not 65 on date of admission
 .S G=$$VD^APCLV(V)
 Q G
ADV1 ;
 ;set denominator value into field
 S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM11E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="Admission: "_$$DATE^APCM1UTL(APCMZ)_" Age: "_$$AGE^AUPNPAT(DFN,APCMZ)
 ;numerator?
 S APCMEP=$$HASADV(DFN,APCMEDAT)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCMMUM(APCMIC,0),U,9)
 D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM11E1
 Q
HASADV(P,ED) ;does patient have an ADVANCE DIRECTIVE before end of report period
 ;
 NEW A,B,C,D,E,X
 ;check advance directive file
 S E=""
 S X=0 F  S X=$O(^AUPNADVD(P,11,X)) Q:X'=+X!(E)  D
 .Q:'$D(^AUPNADVD(P,11,X,0))  ;no zero node?
 .S D=$P(^AUPNADVD(P,11,X,0),U,1)
 .I D>ED Q  ;after report period
 .S B=$P(^AUPNADVD(P,11,X,0),U,2)=""
 .Q:B=""
 .S E=1_U_"Advance Directives: "_$S(B="Y":"YES",1:"NO")_" entered on "_$$DATE^APCM1UTL(D) Q
 I E]"" Q E
 ;now check for TIU Note title before ED of A
 S X=0 F  S X=$O(^AUPNVNOT("AC",P,X)) Q:X'=+X!(E)  D
 .S B=$$VAL^XBDIQ1(9000010.28,X,.01)
 .Q:$$UP^XLFSTR(B)'="ADVANCE DIRECTIVE"
 .S D=$$VD^APCLV($P(^AUPNVNOT(X,0),U,3))
 .Q:D>ED
 .S E=1_U_"Advance Directives: TIU document entered on "_$$DATE^APCM1UTL(D) Q
 Q E
MR ;EP - med reconciliation
 ;for each provider or for the facility find out if this
 ;patient had a er visit or an admission of transferred
 ;if so, then check to see if they have m-mr anytime before end of report period
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=2 S APCMP=APCMFAC  D
 .Q:'$D(APCMHVTP(APCMP))  ;no ADMISSIONS/ER TO THIS FACILITY SO SKIP THIS OBJ
 .S APCMEP=$$HASMMR(DFN,APCMBDAT,APCMEDAT,APCMP,.APCMVSTS)  ;return # of visits^# w/M-MR
 .;set denominator value into field
 .S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 .;numerator?
 .S APCMVALU="# of visits: "_$P(APCMEP,U,1)_" - # w/ M-MR: "_+$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,3)_"|||"_$S($P(APCMEP,U,1)=$P(APCMEP,U,2):1,1:0)
 .S F=$P(^APCMMUM(APCMIC,0),U,9)
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,2),APCMP,APCMRPTT,APCMTIME,F)
 .Q:$P(APCMEP,U,1)=0
 .D SETLIST^APCM11E1
 Q
HOSER(Z,R) ;EP
 I $P(^AUPNVSIT(Z,0),U,6)'=R Q 0  ;not correct facility
 I $P(^AUPNVSIT(Z,0),U,7)="H" Q 1
 NEW C
 I "A"'[$P(^AUPNVSIT(Z,0),U,7) Q 0
 S C=$$CLINIC^APCLV(Z,"C")
 I C=30 Q 1
 ;I C=80 Q 1
 Q 0
DSCHDATE(V) ;EP
 I 'V Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 NEW Y,Z,D
 S D=""
 I $P(^AUPNVSIT(V,0),U,7)="H" D  Q D
 .S Z=$O(^AUPNVINP("AD",V,0))
 .I 'Z S D=$$VD^APCLV(V) Q
 .S Y=$P($P(^AUPNVINP(Z,0),U),".")
 .S D=Y
 S Z=$O(^AUPNVER("AD",V,0))
 I 'Z Q $$VD^APCLV(V)
 I '$D(^AUPNVER(Z,0)) Q $$VD^APCLV(V)
 S Y=$P($P(^AUPNVER(Z,0),U,13),".")
 I Y="" Q $$VD^APCLV(V)
 Q $P(Y,".")
HASMMR(P,BD,ED,R,VSTS) ;does patient have a M-MR on each visit?
 ;
 NEW A,B,C,D,E,X,Y,V,PWH,T,W,Z,Q,EDUC
 ;LOOP THROUGH ALL VISITS AND COUNT VISIT AND M-MR'S
 S PWH="0^0"
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X  D
 .S G=0
 .S V=$P(VSTS(X),U,5)
 .I '$D(^AUPNVSIT(V,0)) Q
 .I $P(^AUPNVSIT(V,0),U,11) Q  ;deleted
 .I '$$HOSER(V,R) Q  ;not correct service category/ER VISIT
 .I $P(^AUPNVSIT(V,0),U,7)="H" Q:'$$TRANS(V)
 .I $$CLINIC^APCLV(V,"C")=30 Q:'$$ERTRANS(V)
 .S $P(PWH,U,1)=$P(PWH,U,1)+1
 .;was there a PAT ED M-MR on the date of the visit through 1 day after the visit
 .S Y="EDUC("
 .S Z=P_"^ALL EDUC;DURING "_$$FMTE^XLFDT($$VD^APCLV(V))_"-"_$$FMTE^XLFDT($$VD^APCLV(V),1) S E=$$START1^APCLDF(Z,Y)
 .I '$D(EDUC(1)) S $P(PWH,U,3)=$P(PWH,U,3)_$$DATE^APCM1UTL($$VD^APCLV(V))_":NO M-MR" Q
 .S (Z,B,D)=0,%="",T="" F  S Z=$O(EDUC(Z)) Q:Z'=+Z!(B)  D
 ..S A=$P(^AUPNVPED(+$P(EDUC(Z),U,4),0),U)
 ..Q:'A
 ..Q:'$D(^AUTTEDT(A,0))
 ..S T=$P(^AUTTEDT(A,0),U,2)
 ..Q:T'="M-MR"
 ..S B=1 S $P(PWH,U,2)=$P(PWH,U,2)+1
 .S $P(PWH,U,3)=$P(PWH,U,3)_$$DATE^APCM1UTL($$VD^APCLV(V))_":"_$S(B:"M-MR",1:"NO M-MR")_";"
 .Q
 Q PWH
TRANS(%) ;
 NEW A
 S A=$$ADMTYPE^APCLV(%,"C")
 I A=2 Q 1
 I A=3 Q 1
 I A=4 Q 1
 Q 0
 ;
ERTRANS(%) ;
 NEW E
 S E=$O(^AMERVSIT("AD",%,0))
 I 'E Q 0  ;no visit in ER Visit
 I '$P($G(^AMERVSIT(E,17)),U,1) Q 0
 Q 1
ECHI ;EP - electronic copy of HI
 NEW APCMP,APCMECV
 K APCMECV
 S (APCMD1,APCMN1)=0
 I APCMRPTT=2 S APCMP=APCMFAC  D
 .I $D(APCMECHI(APCMP,APCMTIME)) S F=$P(^APCMMUM(APCMIC,0),U,11) D  Q
 ..D S^APCM11E1(APCMRPT,APCMIC,"Facility is excluded from this measure no patients seen during the reporting period requested a copy of their health information during the report period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .D ALLV^APCLAPIU(DFN,$$FMADD^XLFDT(APCMEDAT,-365),APCMEDAT,"APCMECV")
 .S APCMHV=$$HADVH^APCM11CI(DFN,APCMP,$$FMADD^XLFDT(APCMEDAT,-365),APCMEDAT,.APCMECV)
 .I 'APCMHV Q  ;no visits to this FACILITY THAT ARE H/30/80 for this patient so don't bother, the patient is not in the denominator
 .;set denominator value into field
 .S APCMEP=$$HASECHI^APCM11E4(DFN,APCMBDAT,$$BDB^APCM11E4(APCMEDAT,-4))  ;"" if no requests so not in denom
 .Q:APCMEP=""
 .S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U),APCMP,APCMRPTT,APCMTIME,F)
 .S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHV)
 .;numerator?
 .S APCMVALU=APCMVALU_"|||"_$S($P(APCMEP,U,2):"MET: ",1:"NOT MET: ")_$P(APCMEP,U,3)_"|||"_$P(APCMEP,U,2)
 .S F=$P(^APCMMUM(APCMIC,0),U,9)
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,2),APCMP,APCMRPTT,APCMTIME,F)
 .D SETLIST^APCM11E1
 K APCMECV
 Q
SC ;EP - REFERRAL, SUMMARY OF CARE
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=2 S APCMP=APCMFAC  D
 .I $D(APCMRCIS(APCMP,APCMTIME)) S F=$P(^APCMMUM(APCMIC,0),U,11) D  Q
 ..D S^APCM11E1(APCMRPT,APCMIC,"Hospital is excluded from this measure as they did not make any referrals for patients they saw during the report period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 .;set denominator value into field
 .S APCMEP=$$HASC32H(DFN,APCMBDAT,$$FMADD^XLFDT(APCMEDAT),APCMFAC,.APCMVSTS)  ;# referrals^# w/c32 documentation
 .Q:'$P(APCMEP,U,1)
 .S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 .;S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 .S APCMVALU="# ref: "_$P(APCMEP,U,1)_" - # w/C32: "_+$P(APCMEP,U,2)_" "_$P(APCMEP,U,4)_"|||"_$P(APCMEP,U,3)_"|||"_$S('(+$P(APCMEP,U,1)):0,+$P(APCMEP,U,1)=+$P(APCMEP,U,2):1,1:0)
 .;numerator?
 .S F=$P(^APCMMUM(APCMIC,0),U,9)
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,2),APCMP,APCMRPTT,APCMTIME,F)
 .D SETLIST^APCM11E1
 Q
HASC32H(P,BD,ED,R,VSTS) ;does patient have a referral with c32
 ;
 NEW A,B,C,D,E,ROI,X,ROII,VDS
 S ROI=""  ;set to 1 if had a good request
 S ROII="" ;set to date of reques
 S VDS=""
 S D=$$FMADD^XLFDT(BD,-1)
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X  D
 .S V=$P(VSTS(X),U,5)
 .Q:$P(^AUPNVSIT(V,0),U,6)'=R
 .Q:'$$HOSER^APCM11E6(V,R)
 .I $P(^AUPNVSIT(V,0),U,7)="H" Q:'$$TRANSOUT(V)
 .I $$CLINIC^APCLV(V,"C")=30 Q:'$$ERTRANSO(V)
 .S O=$$FMADD^XLFDT($$VD^APCLV(V),-1),E=$$DSCHDATE^APCM11E6(V)
 .I VDS="" S VDS="Visits: "
 .S VDS=VDS_$$DATE^APCM1UTL($$VD^APCLV(V))_";"
 .F  S O=$O(^BMCREF("AA",P,O)) Q:O'=+O!(O>E)  D
 ..S Q=0 F  S Q=$O(^BMCREF("AA",P,O,Q)) Q:Q'=+Q  D
 ...S S=$P(^BMCREF(Q,0),U,15)
 ...I S'="A",S'="C1" Q  ;not a A or C1
 ...Q:$P(^BMCREF(Q,0),U,4)="N"
 ...Q:$P(^BMCREF(Q,0),U,5)'=R
 ...S $P(ROI,U,1)=$P(ROI,U,1)+1
 ...;now check to see if a C32 was printed
 ...S Y=0 F  S Y=$O(^BMCREF(Q,6,"B",Y)) Q:Y'=+Y  D
 ....I $P(^AUPNVSIT(V,0),U,7)="H" D  Q
 .....I $P(Y,".")'<$$FMADD^XLFDT($$DSCHDATE^APCM11E6(V),-1),$P(Y,".")'>$$DSCHDATE^APCM11E6(V) D  Q
 ......S $P(ROI,U,2)=$P(ROI,U,2)+1,ROII=ROII_"RI "_$$DATE^APCM1UTL(O)_" C32 "_$$DATE^APCM1UTL(Y)_";" Q
 ....D  Q
 .....I $P(Y,".")'<$$VD^APCLV(V),$P(Y,".")'>$$DSCHDATE^APCM11E6(V) D
 ......S $P(ROI,U,2)=$P(ROI,U,2)+1,ROII=ROII_"RI "_$$DATE^APCM1UTL(O)_" C32 "_$$DATE^APCM1UTL(Y)_";" Q
 ....S ROII=ROII_"RI "_$$DATE^APCM1UTL(O)_" C32 None;"
 S $P(ROI,U,3)=ROII
 Q ROI_U_VDS
ECDI ;EP - electronic copy of discharge instructions
 NEW APCMP,APCMZ,APCMEP
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .I $D(APCMNOEC(APCMP,APCMTIME)) S F=$P(^APCMMUM(APCMIC,0),U,11) D  Q
 ..D S^APCM11E1(APCMRPT,APCMIC,"Facility is excluded from this measure as it did not have any requests for electronic copy of discharge instructions during the EHR Reporting Period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .S APCMEP=$$HASECDI(DFN,APCMBDAT,APCMEDAT,APCMP,.APCMVSTS)  ;return # of visits^# w/M-MR
 .;set denominator value into field
 .I APCMEP="" Q
 .S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM11E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 .S APCMVALU=$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,3)_"|||"_$S($P(APCMEP,U,1):1,1:0)
 .;numerator?
 .S F=$P(^APCMMUM(APCMIC,0),U,9)
 .D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 .D SETLIST^APCM11E1
 Q
HASECDI(P,BD,ED,R,VSTS) ;does patient have a M-MR on each visit?
 ;
 NEW A,B,C,D,E,X,Y,V,PWH,T,W,Z,Q,ECDI
 ;LOOP THROUGH ALL VISITS AND FIND AT LEAST ONE WITH ECDI TUI NOTES
 S PWH="",ECDI=""
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X!(PWH)  D
 .S G=0
 .S V=$P(VSTS(X),U,5)
 .I '$D(^AUPNVSIT(V,0)) Q
 .I $P(^AUPNVSIT(V,0),U,11) Q  ;deleted
 .I '$$HOSER(V,R) Q  ;not correct service category/ER VISIT
 .I $P(^AUPNVSIT(V,0),U,7)="H" Q:'$$DISCHOUT(V)
 .I $P(^AUPNVSIT(V,0),U,7)="H" S Q="" D  Q:'Q
 ..S Z=$O(^AUPNVINP("AD",V,0)) I 'Z Q
 ..Q:'$D(^AUPNVINP(Z,0))
 ..Q:$P($P(^AUPNVINP(Z,0),U),".")>ED  ;discharged after report period
 ..S Q=1
 .S T=$$TIUDCEL(V) Q:T=""  ;no tiu notes for discharge instructions
 .;set denominator
 .I $$UP^XLFSTR($P(T,U))="E-COPY DISCHARGE INSTR RECEIVED" S PWH=1_U_"Adm/Visit Date: "_$$DATE^APCM1UTL($$VD^APCLV(V))_U_"Electronic Copy: "_$P(T,U)_" on "_$$DATE^APCM1UTL($P(T,U,2)) Q
 .S ECDI=0_U_$$DATE^APCM1UTL($$VD^APCLV(V))_U_"Electronic Copy: "_$P(T,U)_" on "_$$DATE^APCM1UTL($P(T,U,2))
 .Q
 I PWH Q PWH
 Q ECDI
DISCHOUT(%) ;
 NEW A
 S A=$$DSCHTYPE^APCLV(%,"C")
 I A=1 Q 1
 I A=2 Q 1
 I A=3 Q 1
 Q 0
 ;
TIUDCEL(%) ;any electronic dc instruction TIU Notes
 NEW A,B,C,VD,DSC,DSC1,P,D
 S VD=$$VD^APCLV(%)  ;admission date
 S DSC=$$DSCHDATE(%)
 S DSC1=$$FMADD^XLFDT(DSC,1)  ;day after discharge
 S P=$P(^AUPNVSIT(%,0),U,5)
 S A=0,B="" F  S A=$O(^AUPNVNOT("AC",P,A)) Q:A'=+A!(B]"")  D
 .Q:'$D(^AUPNVNOT(A,0))
 .Q:$P(^AUPNVNOT(A,0),U,4)  ;retracted
 .S D=$P($P($G(^AUPNVNOT(A,12)),U,1),".")  ;event date
 .Q:D>DSC1  ;after day after discharge
 .Q:D<DSC  ;before discharge date
 .S C=$$VAL^XBDIQ1(9000010.28,A,.01)
 .I $$UP^XLFSTR(C)="E-COPY DISCHARGE INSTR RECEIVED" S B=C_U_D Q
 .I $$UP^XLFSTR(C)="E-COPY DISCHARGE INSTR NOT RECEIVED" S B=C_U_D Q
 Q B
TRANSOUT(%) ;
 NEW A
 S A=$$DSCHTYPE^APCLV(%,"C")
 I A=2 Q 1
 Q 0
 ;
ERTRANSO(%) ;
 NEW E,J
 S E=$O(^AMERVSIT("AD",%,0))
 I 'E Q 0  ;no visit in ER Visit
 S J=$$VAL^XBDIQ1(9009080,E,6.1)
 I J="REFERRED TO ANOTHER SERVICE" Q 1
 I J="TRANSFER TO ANOTHER FACILITY" Q 1
 Q 0
