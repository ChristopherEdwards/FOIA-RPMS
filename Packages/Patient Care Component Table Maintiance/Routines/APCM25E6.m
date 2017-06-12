APCM25E6 ;IHS/CMI/LAB - IHS MU; 
 ;;1.0;MU PERFORMANCE REPORTS;**7**;MAR 26, 2012;Build 15
 ;;;;;;Build 3
ADV ;EP - CALCULATE adv directives
 NEW APCMP,APCMZ
 S (APCMD1,APCMN1)=0
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .I $D(APCMHO65(APCMP,APCMTIME)) S F=$P(^APCM25OB(APCMIC,0),U,11) D  Q
 ..D S^APCM25E1(APCMRPT,APCMIC,"Hospital is excluded from this measure as it did not admit anyone >=65 during the EHR Reporting Period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
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
 S F=$P(^APCM25OB(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM25E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="Admission: "_$$DATE^APCM1UTL(APCMZ)_" Age: "_$$AGE^AUPNPAT(DFN,APCMZ)
 ;numerator?
 S APCMEP=$$HASADV(DFN,APCMEDAT)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCM25OB(APCMIC,0),U,9)
 D S^APCM25E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM25E1
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
 .S F=$P(^APCM25OB(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM25E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 .;numerator?
 .S APCMVALU="# of visits: "_$P(APCMEP,U,1)_" - # w/ M-MR: "_+$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,3)_"|||"_$S($P(APCMEP,U,1)=$P(APCMEP,U,2):1,1:0)
 .S F=$P(^APCM25OB(APCMIC,0),U,9)
 .D S^APCM25E1(APCMRPT,APCMIC,$P(APCMEP,U,2),APCMP,APCMRPTT,APCMTIME,F)
 .Q:$P(APCMEP,U,1)=0
 .D SETLIST^APCM25E1
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
 NEW A,B,C,D,E,X,Y,V,PWH,T,W,Z,Q,EDUC,G,BDD,EDD
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
PVCL(N) ;
 I '$G(N) Q ""
 I '$D(^VA(200,N,0)) Q ""
 NEW C,T
 S C=$$GET1^DIQ(200,N,53.5,"I")
 I C="" Q ""
 S C=$P($G(^DIC(7,C,9999999)),U,1)
 I C="" Q ""
 S T=$O(^APCMMUCN("B","MODIFIED STAGE 2 2015",0))
 I 'T Q ""
 I '$D(^APCMMUCN(T,19,"B",C)) Q ""
 Q 1
EN ;EP - CALCULATE ELECTRONIC NOTES
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..Q:'$$PVCL(APCMP)  ;PROVIDER ISN'T THE RIGHT CLASS CODE
 ..Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 ..D EN1
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .Q:'$D(APCMHVTP(APCMP))
 .D EN1
 .Q
 Q
EN1 ;set denominator value into field
 S F=$P(^APCM25OB(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM25E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 ;numerator?
 S APCMEP=$$HASEN(DFN,APCMBDAT,APCMEDAT,APCMP)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCM25OB(APCMIC,0),U,9)
 D S^APCM25E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM25E1
 Q
HASEN(P,BD,ED,R) ;does patient have a AN ELECTRONIC NOTE?
 ;
 NEW A,B,C,D,E,T,N,X,Y,G,X
 S G=""
 ;$o through TIU document file AA xref for this patient
 ;find first one with ep as author/signer
 ;or ep is co signer and author/signor is a student
 ;skip notes with report text ="VistA Imaging - Scanned Document
 S T=0 F  S T=$O(^TIU(8925,"AA",P,T)) Q:T'=+T!(G)  D
 .S D=0 F  S D=$O(^TIU(8925,"AA",P,T,D)) Q:D'=+D!(G)  D
 ..S X=0 F  S X=$O(^TIU(8925,"AA",P,T,D,X)) Q:X'=+X!(G)  D
 ...;check report text
 ...Q:$$SCAN(X)
 ...;ADDED LOGIC PER DONNA AND JOANNE 9/3/2014 TO MAKE SURE NOTE IS WITHIN REPORT PERIOD
 ...S Z=$P($$GET1^DIQ(8925,X,1201,"I"),".")
 ...Q:Z<BD
 ...Q:Z>ED
 ...Q:'$$PRVD(X)  ;not on of this providers
 ...S G=1_U_"Note: "_$$GET1^DIQ(8925,X,1201)
 Q G
SCAN(%) ;
 NEW A,B,C
 S A=0,B="" F  S A=$O(^TIU(8925,%,"TEXT",A)) Q:A'=+A  S B=B_^TIU(8925,%,"TEXT",A,0)
 I $$UP^XLFSTR(B)["VISTA IMAGING - SCANNED DOCUMENT" Q 1
 Q 0
PRVD(%) ;
 NEW A,S,C,D
 S A=$$GET1^DIQ(8925,%,1202,"I")  ;AUTHOR
 S S=$$GET1^DIQ(8925,%,1502,"I")  ;SIGNED BY
 ;I A=R,S=R Q 1
 I A=S,$$PVCL(A) Q 1
 S C=$$GET1^DIQ(8925,%,1508,"I")  ;CO SIGNER
 I '$$PVCL(C) Q 0
 ;I C'=R Q 0
 I '$$ISA^USRLM(A,"STUDENT","",$P($$GET1^DIQ(8925,%,1201,"I"),".",1)) Q 0
 I '$$ISA^USRLM(S,"STUDENT","",$P($$GET1^DIQ(8925,%,1201,"I"),".",1)) Q 0
 Q 1
 ;
IMGR ;EP - IMAGING RESULTS
 ;for each provider or for the facility count all rad EXAM that meet criteria 
 K ^TMP($J,"PATSRAD")
 K APCMRADS
 D IMGR1
 K ^TMP($J,"ORDERSPROCESSED")
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $P($G(APCMRADS(APCMP)),U,1)<100 S F=$P(^APCM25OB(APCMIC,0),U,11) D
 ..D S^APCM25E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she had < 100 Radiology EXAMS during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1)
DR .;set denominator value into field
 .S F=$P(^APCM25OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMRADS(APCMP)),U,1)  ;returns # of prescriptions^# not written by nature of order
 .D S^APCM25E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"PATSRAD",APCMP,P)) Q:P'=+P  D
 ..S D=$P(^TMP($J,"PATSRAD",APCMP,P),U,1),N=$P(^TMP($J,"PATSRAD",APCMP,P),U,2) S APCMVALU="# Orders: "_D_"|||"_"# IMAGE: "_N_" # NO IMAGE: "_(D-N)
 ..S DFN=P D SETLIST^APCM25E1
 .;numerator?
 .S F=$P(^APCM25OB(APCMIC,0),U,9)
 .S N=$P($G(APCMRADS(APCMP)),U,2)
 .D S^APCM25E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .S F=$P(^APCM25OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMRADS(APCMFAC)),U,1)  ;returns # of prescriptions^# not written by nature of order
 .D S^APCM25E1(APCMRPT,APCMIC,N,APCMFAC,APCMRPTT,APCMTIME,F)
 .;now set patient list for this FACILITY
 .S P=0 F  S P=$O(^TMP($J,"PATSRAD",APCMFAC,P)) Q:P'=+P  D
 ..S D=$P(^TMP($J,"PATSRAD",APCMFAC,P),U,1),N=$P(^TMP($J,"PATSRAD",APCMFAC,P),U,2) S APCMVALU="# Orders: "_D_"|||"_"# IMAGE: "_N_" # NO IMAGE: "_(D-N)
 ..S DFN=P D SETLIST^APCM25E1
 .;numerator?
 .S F=$P(^APCM25OB(APCMIC,0),U,9)
 .S N=$P($G(APCMRADS(APCMFAC)),U,2)
 .D S^APCM25E1(APCMRPT,APCMIC,N,APCMFAC,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"PATSRAD"),^TMP($J,"ORDERSPROCESSED"),APCMRADS
 Q
IMGR1 ;EP - 
 ;between BD and ED
 ;SET ARRAY APCMRADS to APCMRADS(prov ien)=denom^numer
 NEW ID,C,Y,X,D,S,N,A,B,R,PAT,G,IEN,ORPFILE,ORPTST,PATLOC,ORDEB,PATSTA,CN
 S ID=$$FMADD^XLFDT(APCMBDAT,-1),ID=ID_".9999"
 F  S ID=$O(^RADPT("AR",ID)) Q:ID'=+ID!($P(ID,".")>APCMEDAT)  D
 .S PAT=0 F  S PAT=$O(^RADPT("AR",ID,PAT)) Q:PAT'=+PAT  D
 ..Q:$$DEMO^APCLUTL(PAT,APCMDEMO)  ;Quit if demo patient
 ..S IEN=0 F  S IEN=$O(^RADPT("AR",ID,PAT,IEN)) Q:IEN'=+IEN  D
 ...S EIEN=0 F  S EIEN=$O(^RADPT(PAT,"DT",IEN,"P",EIEN)) Q:EIEN'=+EIEN  D
 ....;CHECK STATUS, MUST BE EXAMINED OR COMPLETE
 ....S S=$$GET1^DIQ(70.03,EIEN_","_IEN_","_PAT,3)
 ....I S'="EXAMINED",S'="COMPLETE" Q
 ....S G=0
 ....I APCMRPTT=1 D
 .....S ORPVID=$$GET1^DIQ(70.03,EIEN_","_IEN_","_PAT,14,"I") Q:'$D(APCMPRV(ORPVID))  ;quit if ordering provider doesn't match user selected provider
 .....S PATSTA=$$GET1^DIQ(70.03,EIEN_","_IEN_","_PAT,4,"I")
 .....Q:PATSTA'="O"
 .....S C=""
 .....S PATLOC=$$GET1^DIQ(70.03,EIEN_","_IEN_","_PAT,8,"I")
 .....I PATLOC,$D(^SC(PATLOC,0)) S C=$P(^SC(PATLOC,0),U,7) I C Q:$P($G(^DIC(40.7,C,0)),U,2)=30  ;IF ER IN HOSP LOC Q
 .....S G=1
 ....I APCMRPTT=2 D
 .....;is provider authorized?
 .....S ORPVID=$$GET1^DIQ(70.03,EIEN_","_IEN_","_PAT,14,"I")
 .....;Q:'$$ORES^APCM25E9(ORPVID,ID)
 .....S PATSTA=$$GET1^DIQ(70.03,EIEN_","_IEN_","_PAT,4,"I")
 .....I PATSTA="I" S G=1 Q
 .....Q:APCMMETH="O"
 .....Q:PATSTA'="O"
 .....S C=""
 .....S PATLOC=$$GET1^DIQ(70.03,EIEN_","_IEN_","_PAT,8,"I")
 .....I PATLOC,$D(^SC(PATLOC,0)) S C=$P(^SC(PATLOC,0),U,7) I C Q:$P($G(^DIC(40.7,C,0)),U,2)'=30  ;IF ER IN HOSP LOC Q
 .....S G=1
 ....Q:'G
 ....;I DUZ=2793 W !,"PAT: ",$P(^DPT(PAT,0),U,1),"DATE: ",$$FMTE^XLFDT(ID)," ORDER: ",ORIEN,"  NATURE: ",ORORD
 ....I APCMRPTT=1 S $P(APCMRADS(ORPVID),U,1)=$P($G(APCMRADS(ORPVID)),U,1)+1,$P(^TMP($J,"PATSRAD",ORPVID,PAT),U,1)=$P($G(^TMP($J,"PATSRAD",ORPVID,PAT)),U,1)+1
 ....I APCMRPTT=2 S $P(APCMRADS(APCMFAC),U,1)=$P($G(APCMRADS(APCMFAC)),U,1)+1,$P(^TMP($J,"PATSRAD",APCMFAC,PAT),U,1)=$P($G(^TMP($J,"PATSRAD",APCMFAC,PAT)),U,1)+1
 ....;now check to see if it has REPORT TEXT
 ....S CN=$$GET1^DIQ(70.03,EIEN_","_IEN_","_PAT,17,"I")
 ....I 'CN Q  ;no entry in report text file
 ....I '$O(^RARPT(CN,2005,0)) Q   ;no image
 ....I APCMRPTT=1 S $P(APCMRADS(ORPVID),U,2)=$P(APCMRADS(ORPVID),U,2)+1,$P(^TMP($J,"PATSRAD",ORPVID,PAT),U,2)=$P($G(^TMP($J,"PATSRAD",ORPVID,PAT)),U,2)+1
 ....I APCMRPTT=2 S $P(APCMRADS(APCMFAC),U,2)=$P($G(APCMRADS(APCMFAC)),U,2)+1,$P(^TMP($J,"PATSRAD",APCMFAC,PAT),U,2)=$P($G(^TMP($J,"PATSRAD",APCMFAC,PAT)),U,2)+1
 Q
FH ;EP - FAMILY HX
 ;for each provider or for the facility find out if this
 ;patient had a visit of A, O, R, S to this provider or facility
 ;if so, then check to see if they have FAMILY HX documented anytime before end of report period
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 ..D FH1
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .Q:'$D(APCMHVTP(APCMP))
 .D FH1
 .Q
 Q
FH1 ;set denominator value into field
 S F=$P(^APCM25OB(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM25E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 ;numerator?
 S APCMEP=$$HASFH(DFN,$$DOB^AUPNPAT(DFN),APCMEDAT)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCM25OB(APCMIC,0),U,9)
 D S^APCM25E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM25E1
 Q
HASFH(P,BD,ED) ;does patient have a SMOKING STATUS
 ;
 NEW A,B,C,D,E,HF
 S C=0
 S HF=""
 ;CHECK AUPNFH
 S A=0 F  S A=$O(^AUPNFH("AC",P,A)) Q:A'=+A!(HF)  D
 .Q:'$D(^AUPNFH(A,0))
 .Q:$$GET1^DIQ(9000014,A,.03)>ED  ;documentd after time period
 .S B=$$GET1^DIQ(9000014,A,.03)
 .I B'["NATURAL",B'["UNKNOWN" Q
 .S HF=1_U_B
 I HF Q HF
 S A=0 F  S A=$O(^AUPNFHR("AA",P,A)) Q:A'=+A!(HF)  D
 .S B=$P($G(^AUTTRLSH(A,0)),U,1)
 .I B'["NATURAL",B'["UNKNOWN" Q
 .S HF=1_U_B
 Q HF
