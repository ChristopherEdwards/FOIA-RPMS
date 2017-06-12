APCM14E6 ;IHS/CMI/LAB - IHS MU; 
 ;;1.0;IHS MU PERFORMANCE REPORTS;**5,6**;MAR 26, 2012;Build 65
 ;;;;;;Build 3
ADV ;EP - CALCULATE adv directives
 NEW APCMP,APCMZ
 S (APCMD1,APCMN1)=0
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .I $D(APCMHO65(APCMP,APCMTIME)) S F=$P(^APCM14OB(APCMIC,0),U,11) D  Q
 ..D S^APCM14E1(APCMRPT,APCMIC,"Hospital is excluded from this measure as it did not admit anyone >=65 during the EHR Reporting Period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
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
 S F=$P(^APCM14OB(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM14E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="Admission: "_$$DATE^APCM1UTL(APCMZ)_" Age: "_$$AGE^AUPNPAT(DFN,APCMZ)
 ;numerator?
 S APCMEP=$$HASADV(DFN,APCMEDAT)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCM14OB(APCMIC,0),U,9)
 D S^APCM14E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM14E1
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
 .S B=$P(^AUPNADVD(P,11,X,0),U,2)
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
 .S APCMEP=$$HASMMR(DFN,APCMBDAT,APCMEDAT,APCMP,.APCMVSTS,APCMMETH)  ;return # of visits^# w/M-MR
 .;set denominator value into field
 .S F=$P(^APCM14OB(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM14E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 .;numerator?
 .S APCMVALU="# of visits: "_$P(APCMEP,U,1)_" - # w/ M-MR: "_+$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,3)_"|||"_$S($P(APCMEP,U,1)=$P(APCMEP,U,2):1,1:0)
 .S F=$P(^APCM14OB(APCMIC,0),U,9)
 .D S^APCM14E1(APCMRPT,APCMIC,$P(APCMEP,U,2),APCMP,APCMRPTT,APCMTIME,F)
 .Q:$P(APCMEP,U,1)=0
 .D SETLIST^APCM14E1
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
HASMMR(P,BD,ED,R,VSTS,APCMMETH) ;does patient have a M-MR on each visit?
 ;
 NEW A,B,C,D,E,X,Y,V,PWH,T,W,Z,Q,EDUC
 ;LOOP THROUGH ALL VISITS AND COUNT VISIT AND M-MR'S
 S PWH="0^0"
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X  D
 .S G=0
 .S V=$P(VSTS(X),U,5)
 .I '$D(^AUPNVSIT(V,0)) Q
 .I $P(^AUPNVSIT(V,0),U,11) Q  ;deleted
 .Q:$P(^AUPNVSIT(V,0),U,6)'=R
 .I APCMMETH="E" D  Q:'G
 ..I '$$HOSER(V,R) Q  ;not correct service category/ER VISIT
 ..S G=1
 .I APCMMETH="O" Q:"OH"'[$P(^AUPNVSIT(V,0),U,7)
 .I $P(^AUPNVSIT(V,0),U,7)="H"!($P(^AUPNVSIT(V,0),U,7)="O") Q:'$$TRANS(V)
 .I $$CLINIC^APCLV(V,"C")=30 Q:'$$ERTRANS(V)
 .S $P(PWH,U,1)=$P(PWH,U,1)+1
 .;V UPDATED REVIEWED SNOMED DURING REPORT PERIOD
 .S Z="",B=""
 .S W=0 F  S W=$O(^AUPNVRUP("AC",P,W)) Q:W'=+W!(Z)  D
 ..S Y=0 F  S Y=$O(^AUPNVRUP(W,26,Y)) Q:Y'=+Y!(Z)  D
 ...I $P($G(^AUPNVRUP(W,26,Y,0)),U,1)'=428191000124101 Q
 ...;getevent date/time (1201)
 ...S E=""
 ...S D=$P($$GET1^DIQ(9000010.54,W,1201,"I"),".")
 ...I D<BD Q
 ...I D>ED Q
SN ...S Z=1
 ...S B=1 S $P(PWH,U,2)=$P(PWH,U,2)+1
 .S $P(PWH,U,3)=$P(PWH,U,3)_$$DATE^APCM1UTL($$VD^APCLV(V))_":"_$S(B:"M-MR",1:"NO M-MR")_";"
 .Q
 Q PWH
TRANS(%) ;
 NEW A
 S A=$$ADMTYPE^APCLV(%,"C")
 I A="" S A=$O(^DGPM("AVISIT",%,0)) I A S A=$$GET1^DIQ(405,A,.04,"I") I A S A=$$GET1^DIQ(405.1,A,9999999.1)
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
