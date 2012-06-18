APCM11E2 ;IHS/CMI/LAB - IHS MU; 
 ;;2.0;IHS PCC SUITE;**6**;MAY 14, 2009;Build 11
 ;;;;;;Build 3
CPOE ;EP - CALCULATE CPOE MEDICATIONS MEASURE
 ;for each provider or for the facility find out if this
 ;patient had a visit of A, O, R, S to this provider or facility
 ;if so, then check to see if they had any prescription in file 52
 ;with an issue date in the time period, if so they are in the
 ;denominator for that provider/facility and then update counter
 ;
 ;if they had any prescription that had a nature of order of electronic
 ;they are in the numerator
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..I $D(APCM100R(APCMP,APCMTIME)) S F=$P(^APCMMUM(APCMIC,0),U,11) D S^APCM11E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she had < 100 prescriptions issued during the time period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 ..Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 ..D CPOE1
 .Q
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .Q:'$D(APCMHVTP(APCMP))
 .D CPOE1
 .Q
 Q
CPOE1 ;
 S APCMHP=$$HADRX(DFN,APCMBDAT,APCMEDAT)
 Q:APCMHP=""  ;no prescriptions with an issue date in report period
 ;set denominator value into field
 S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM11E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))_" RX: "_$$DATE^APCM1UTL($P(APCMHP,U))_";"_$P(APCMHP,U,2)
 ;numerator?
 S APCMEP=$$HADNOEP(DFN,APCMBDAT,APCMEDAT)
 G:APCMEP="" CPOEL
 S APCMVALU=APCMVALU_"|||"_$$DATE^APCM1UTL($P(APCMEP,U))_";"_$P(APCMEP,U,2)_" Order #: "_$P(APCMEP,U,3)_"|||"_$S($P(APCMEP,U,2)]"":1,1:"")
 S F=$P(^APCMMUM(APCMIC,0),U,9)
 D S^APCM11E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
CPOEL D SETLIST^APCM11E1
 Q
HADRX(P,BD,ED) ;EP - did patient have a RX in file 52 with an issue date
 ;between BD and ED
 I '$G(P) Q ""
 I '$G(BD) Q ""
 I '$G(ED) Q ""
 I '$D(^AUPNPAT(P,0)) Q ""
 NEW EXDT,IFN,ID,G
 S G=""
 S EXDT=$$FMADD^XLFDT(BD,-730)
 F  S EXDT=$O(^PS(55,P,"P","A",EXDT)) Q:'EXDT!(G]"")  S IFN=0 F  S IFN=$O(^PS(55,P,"P","A",EXDT,IFN)) Q:'IFN!(G]"")  D:$D(^PSRX(IFN,0))
 .Q:$P($G(^PSRX(IFN,"STA")),"^")=13
 .S ID=$P(^PSRX(IFN,0),U,13)
 .Q:ID<BD
 .Q:ID>ED
 .S G=ID_U_$$VAL^XBDIQ1(52,IFN,.01)
 Q G
ORES(R,D) ;EP - DID PROVIDER HAVE ORES OR ORESLE ON DATE D
 I '$G(R) Q ""
 I '$D(^VA(200,R,0)) Q ""
 NEW K,J
 S K=$O(^DIC(19.1,"B","ORES",0))
 S J=$O(^DIC(19.1,"B","ORELSE",0))
 I $D(^VA(200,R,51,K,0)),$P(^VA(200,R,51,K,0),U,2)'>D Q 1
 I $D(^VA(200,R,51,J,0)),$P(^VA(200,R,51,J,0),U,2)'>D Q 1
 Q ""
HADNOEP(P,BD,ED) ;EP - did patient have a RX in file 52 with an issue date
 ;between BD and ED
 I '$G(P) Q ""
 I '$G(BD) Q ""
 I '$G(ED) Q ""
 I '$D(^AUPNPAT(P,0)) Q ""
 NEW EXDT,IFN,ID,O,N,A,B
 S N=""
 S EXDT=$$FMADD^XLFDT(BD,-730)
 F  S EXDT=$O(^PS(55,P,"P","A",EXDT)) Q:'EXDT!(N]"")  S IFN=0 F  S IFN=$O(^PS(55,P,"P","A",EXDT,IFN)) Q:'IFN!(N]"")  D:$D(^PSRX(IFN,0))
 .Q:$P($G(^PSRX(IFN,"STA")),"^")=13
 .S ID=$P(^PSRX(IFN,0),U,13)
 .Q:ID<BD
 .Q:ID>ED
 .;check nature of order
 .S O=$P($G(^PSRX(IFN,"OR1")),U,2)  ;order number
 .Q:O=""
 .S B=$P($G(^OR(100,O,0)),U,6)
 .Q:B=""
 .Q:'$$ORES(B,ID)
 .S A=0 F  S A=$O(^OR(100,O,8,A)) Q:A'=+A!(N]"")  D
 ..Q:'$D(^OR(100,O,8,A,0))
 ..S B=$P(^OR(100,O,8,A,0),U,12)
 ..Q:B=1
 ..Q:B=""
 ..S N=$P($P(^OR(100,O,8,A,0),U),".")_U_$P(^ORD(100.02,B,0),U,1)_U_$P(^OR(100,O,0),U)
 Q N
DEMO ;EP - CALCULATE DEMOGRAPHICS
 ;for each provider or for the facility find out if this
 ;patient had a visit of A, O, R, S to this provider or facility
 ;if so, then check to see if they had dob, preferred language, gender, race, ethnicity recorded
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..Q:'$D(APCMHVTP(APCMP))  ;DID NOT SEE THIS PATIENT
 ..D DEMO1
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .Q:'$D(APCMHVTP(APCMP))
 .D DEMO1
 .Q
 Q
DEMO1 ;set denominator value into field
 S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM11E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 ;numerator?
 S APCMEP=$$HASDEMO(DFN,APCMBDAT,APCMEDAT,APCMRPTT,$G(APCMVDOD))
 S APCMVALU=APCMVALU_"|||"_$S($P(APCMEP,U,1)=1:"METS OBJECTIVE: ",1:"DOES NOT MEET OBJECTIVE: ")_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCMMUM(APCMIC,0),U,9)
 D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM11E1
 Q
HASDEMO(P,BD,ED,T,DODV) ;
 NEW PL,G,R,E,D,C,Y,X,B,Z
 S C=0
 S T=$G(T)
 S DODV=$G(DODV)
 S (PL,G,R,E,D)=""
 ;preferred language
 S X=0 F  S X=$O(^AUPNPAT(P,86,X)) Q:X'=+X!(PL]"")  D
 .S B=$P(^AUPNPAT(P,86,X,0),U)
 .Q:B>ED
 .S C=C+1,PL="Preferred Language"
 S G=$P(^DPT(P,0),U,2) I G]"" S C=C+1,G="Gender"
 S R=$$VAL^XBDIQ1(2,P,.06)
 I R]"" S C=C+1,R="Race"
 S Z=0 F  S Z=$O(^DPT(P,.06,Z)) Q:Z'=+Z!(E]"")  D
 .S E=$P($G(^DPT(P,.06,Z,0)),U,1)
 .Q:E=""
 .S E="Ethnicity",C=C+1
 .Q
 I $P(^DPT(P,0),U,3)]"" S D="DOB",C=C+1
 I T=2,$G(DODV) G HASDEMOH
 I C=5 Q 1_U_"Has: "_PL_";"_G_";"_R_";"_E_";"_D
 Q 0_U_"Has: "_PL_";"_G_";"_R_";"_E_";"_D
HASDEMOH ;did patient die in the hospital during report period?  if so is dod and underlying cause there?
 NEW VDOD,L,UCD
 S UCD=""
 S VDOD=$$DOD^AUPNPAT(P)
 I VDOD]"" S C=C+1,VDOD="DOD"
 S L=$$VAL^XBDIQ1(9000001,P,1114)
 I L]"" S C=C+1,UCD="UCD"
 I C=7 Q 1_U_"Has: "_PL_";"_G_";"_R_";"_E_";"_D_";"_VDOD_";"_UCD
 Q 0_U_"Has: "_PL_";"_G_";"_R_";"_E_";"_D_";"_VDOD_";"_UCD
 ;
PL ;EP - CALCULATE PROBLEM LIST
 ;for each provider or for the facility find out if this
 ;patient had a visit of A, O, R, S to this provider or facility
 ;if so, then check to see if they any problems on their problem list (skip deleted) or a NAP documented in report period
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 ..D PL1
 ..Q
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .Q:'$D(APCMHVTP(APCMP))
 .D PL1
 .Q
 Q
PL1 ;set denominator value into field
 S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM11E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 ;numerator?
 S APCMEP=$$HASPL(DFN,APCMBDAT,APCMEDAT)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCMMUM(APCMIC,0),U,9)
 D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM11E1
 Q
HASPL(P,BD,ED) ;does patient have a problem entered before end of report period
 ;
 NEW A,B,C,D,E
 S E=""
 S A=0 F  S A=$O(^AUPNPROB("AC",P,A)) Q:A'=+A!(E]"")  D
 .;if date entered is after the ED don't count it
 .Q:'$D(^AUPNPROB(A,0))
 .Q:$P(^AUPNPROB(A,0),U,8)>ED  ;after end date of report period
 .I $P(^AUPNPROB(A,0),U,12)'="D" S E=1_U_"Problem Entry: "_$$VAL^XBDIQ1(9000011,A,.01)_" entered on "_$$VAL^XBDIQ1(9000011,A,.08) Q
 .;since it's deleted, deletion date must not be before time period
 .S D=$P($P($G(^AUPNPROB(A,2)),U,2),".")  ;date deleted
 .Q:D>ED
 .Q:D<BD
 .S E="1^Problem Entry: "_$$VAL^XBDIQ1(9000011,A,.01)_" entered on "_$$VAL^XBDIQ1(9000011,A,.08)
 I E]"" Q E
 ;no problems on PL so how about a NAP before end of time period
 S C=$O(^AUTTCRA("B","NO ACTIVE PROBLEMS",0))
 I 'C Q ""
 S A=0 F  S A=$O(^AUPNVRUP("AC",P,A)) Q:A'=+A!(E]"")  D
 .Q:'$D(^AUPNVRUP(A,0))  ;oops
 .Q:$P(^AUPNVRUP(A,0),U,1)'=C  ;not NAP
 .S D=$$VD^APCLV($P(^AUPNVRUP(A,0),U,3))
 .Q:D>ED
 .S E="1^No Active Problems on "_$$DATE^APCM1UTL(D)
 Q E
MEDL ;EP - CALCULATE MEDICATION LIST
 ;for each provider or for the facility find out if this
 ;patient had a visit of A, O, R, S to this provider or facility
 ;d
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 D  Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ..Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 ..D MEDL1
 ..Q
 .Q
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .Q:'$D(APCMHVTP(APCMP))
 .D MEDL1
 .Q
 Q
MEDL1 ;set denominator value into field
 S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 D S^APCM11E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 S APCMVALU="VISIT: "_$$DATE^APCM1UTL(APCMHVTP(APCMP))
 ;numerator?
 S APCMEP=$$HASML(DFN,APCMBDAT,APCMEDAT)
 S APCMVALU=APCMVALU_"|||"_$P(APCMEP,U,2)_"|||"_$P(APCMEP,U,1)
 S F=$P(^APCMMUM(APCMIC,0),U,9)
 D S^APCM11E1(APCMRPT,APCMIC,$P(APCMEP,U,1),APCMP,APCMRPTT,APCMTIME,F)
 D SETLIST^APCM11E1
 Q
HASML(P,BDT,EDT) ;EP
 N RXIEN,ACTIEN,RTSDT,FILLDT,A0,FDTLP,IEN,G,DC,EXP,SDT,X,I,DRG,L,V,EXDT,IFN,ID,D365
 ;between BD and ED
 I '$G(P) Q ""
 I '$G(BDT) Q ""
 I '$G(EDT) Q ""
 I '$D(^AUPNPAT(P,0)) Q ""
 S G=""
NAM ;look for "No Active Medications" anytime during the report period
 S C=$O(^AUTTCRA("B","NO ACTIVE MEDICATIONS",0))
 I 'C G RXS
 ;GET most recent visit date
 S A=0 F  S A=$O(^AUPNVRUP("AC",P,A)) Q:A'=+A!(G]"")  D
 .Q:'$D(^AUPNVRUP(A,0))  ;oops
 .Q:$P(^AUPNVRUP(A,0),U,1)'=C  ;not NAM
 .S D=$$VD^APCLV($P(^AUPNVRUP(A,0),U,3))
 .Q:D<BDT  ;before beg date
 .Q:D>EDT  ;after end date
 .S G="1^No Active Medications on "_$$DATE^APCM1UTL(D)
 I G Q G
RXS ;
 S G=""
 S D365=$$FMADD^XLFDT(BDT,-365)
 S EXDT=$$FMADD^XLFDT(BDT,-(365*3))
 F  S EXDT=$O(^PS(55,P,"P","A",EXDT)) Q:'EXDT!(G]"")  S IFN=0 F  S IFN=$O(^PS(55,P,"P","A",EXDT,IFN)) Q:'IFN!(G]"")  D:$D(^PSRX(IFN,0))
 .Q:$P($G(^PSRX(IFN,"STA")),"^")=13  ;deleted
 .Q:'$P(^PSRX(IFN,0),U,6)   ; Prescription must have a drug
 .S ID=$P(^PSRX(IFN,0),U,13)  ;issue date
 .Q:ID<D365
 .Q:ID>EDT
 .S DC=$P($G(^PSRX(IFN,3)),U,5)  ;dc date
 .I DC]"" Q:DC<BDT  ;IF DC'ED DATE IF MUST BE ON OR AFTER 1ST DATE OF TIME PERIOD
 .S G=1_U_$$DATE^APCM1UTL(ID)_" Rx: "_$P(^PSRX(IFN,0),U,1) Q
 I G]"" Q G
 ;now check NVA meds
NVA ; Set Non-VA Med Orders in the ^TMP Global
 S G=""
 F I=0:0 S I=$O(^PS(55,P,"NVA",I)) Q:'I!(G]"")  S X=$G(^PS(55,P,"NVA",I,0)) D
 .Q:'$P(X,"^")
 .S DRG=$S($P(X,"^",2):$P($G(^PSDRUG($P(X,"^",2),0)),"^"),1:$P(^PS(50.7,$P(X,"^"),0),"^")_" "_$P(^PS(50.606,$P(^PS(50.7,$P(X,"^"),0),"^",2),0),"^"))
 .I $P(X,"^",7),$P(X,"^",7)<BDT Q  ;DC'ED
 .S SDT=$P(X,"^",10) I 'SDT Q  ;NO documented date
 .I SDT>EDT Q  ;documented date after end date
 .Q:$P(X,U,6)]""
 .S G=1_U_"NVA: "_$$DATE^APCM1UTL($P(X,U,10))_" Item: "_DRG
 I G]"" Q G
 Q G
 ; Return boolean flag indicating valid patient
PATVRY(RX,PAT) ;EP
 Q:PAT="*" 1
 Q +$P($G(^PSRX(RX,0)),U,2)=PAT
 ; Return release date for dispense
DSPRDT(RX,TYP,SIEN) ;EP
 Q $S($G(SIEN):+$P($G(^PSRX(RX,$S(TYP="ADP":"P",1:1),SIEN,0)),U,$S(TYP="ADP":19,1:18)),1:+$P(^PSRX(RX,2),U,13))
