APCM24E9 ;IHS/CMI/LAB - IHS MU;  ; 29 Jul 2013  4:09 PM
 ;;1.0;IHS MU PERFORMANCE REPORTS;**5,6**;MAR 26, 2012;Build 65
 ;;;;;;Build 3
CPOE ;EP - CALCULATE EPRESCRIBING
 ;for each provider or for the facility count all prescriptions that meet criteria and if it is not written it meets numerator
 K ^TMP($J,"PATSRX")
 K APCMRXS
 D TOTRX
 K ^TMP($J,"ORDERSPROCESSED")
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $P($G(APCMRXS(APCMP)),U,1)<100 S F=$P(^APCM24OB(APCMIC,0),U,11) D
 ..D S^APCM24E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she had < 100 medication orders during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1)
D .;set denominator value into field
 .S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMRXS(APCMP)),U,1)  ;returns # of prescriptions^# not written by nature of order
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"PATSRX",APCMP,P)) Q:P'=+P  D
 ..S D=$P(^TMP($J,"PATSRX",APCMP,P),U,1),N=$P(^TMP($J,"PATSRX",APCMP,P),U,2) S APCMVALU="# Orders: "_D_"|||"_"# CPOE: "_N_" # NOT CPOE: "_(D-N)
 ..S DFN=P D SETLIST^APCM24E1
 .;numerator?
 .S F=$P(^APCM24OB(APCMIC,0),U,9)
 .S N=$P($G(APCMRXS(APCMP)),U,2)
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMRXS(APCMFAC)),U,1)  ;returns # of prescriptions^# not written by nature of order
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMFAC,APCMRPTT,APCMTIME,F)
 .;now set patient list for this FACILITY
 .S P=0 F  S P=$O(^TMP($J,"PATSRX",APCMFAC,P)) Q:P'=+P  D
 ..S D=$P(^TMP($J,"PATSRX",APCMFAC,P),U,1),N=$P(^TMP($J,"PATSRX",APCMFAC,P),U,2) S APCMVALU="# Orders: "_D_"|||"_"# CPOE: "_N_" # NOT CPOE: "_(D-N)
 ..S DFN=P D SETLIST^APCM24E1
 .;numerator?
 .S F=$P(^APCM24OB(APCMIC,0),U,9)
 .S N=$P($G(APCMRXS(APCMFAC)),U,2)
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMFAC,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"PATSRX")
 Q
TOTRX ;EP - did patient have a RX in file 52 with an issue date
 ;between BD and ED
 ;SET ARRAY APCMRXS to APCMRXS(prov ien)=denom^numer
 K ^TMP($J,"ORDERSPROCESSED")
 NEW ID,C,Y,X,D,S,N,A,B,R,PAT,G,ORIEN,ORPFILE,ORPTST,ORNS,PATLOC,ORACT0,ORORD,ORDEB
 S ID=$$FMADD^XLFDT(APCMBDAT,-1),ID=ID_".9999"
 F  S ID=$O(^OR(100,"AF",ID)) Q:ID'=+ID!($P(ID,".")>APCMEDAT)  D
 .S ORIEN=0 F  S ORIEN=$O(^OR(100,"AF",ID,ORIEN)) Q:ORIEN'=+ORIEN  D
 ..Q:$D(^TMP($J,"ORDERSPROCESSED",ORIEN))
 ..S ^TMP($J,"ORDERSPROCESSED",ORIEN)=""
 ..S ORPFILE=$P($G(^OR(100,ORIEN,0)),"^",2) Q:ORPFILE=""  ;Quit if no object of order
 ..Q:$P(ORPFILE,";",2)'["DPT"  ;only patient orders
 ..S PAT=+$P($G(^OR(100,ORIEN,0)),U,2) ;GET Patient DFN
 ..Q:$$DEMO^APCLUTL(PAT,APCMDEMO)  ;Quit if demo patient
 ..Q:+$P($G(^OR(100,ORIEN,3)),"^",11)'=0  ;190 quit if order type not standard
 ..S ORPTST=$P($G(^OR(100,ORIEN,0)),"^",12) ;patient status (in/out)
 ..S ORNS=$$NMSP($P($G(^OR(100,ORIEN,0)),"^",14))  ;get package namespace
 ..I ORNS'="PS" Q  ;if not getting all types of orders then quit if order is not from pharmacy
 ..S ORACT0=$G(^OR(100,ORIEN,8,1,0))
 ..Q:$P(ORACT0,U,1)'=ID
 ..S ORORD=$P(ORACT0,"^",12) ;ORORD holds nature of order ien
 ..Q:ORORD=4  ;skip service corrections
 ..S ORPVID=$P(ORACT0,"^",3)
 ..S G=0
 ..I APCMRPTT=1 D
 ...Q:ORPTST'="O"  ;Quit if patient status is not outpatient and in EP report
 ...S ORPVID=$P(ORACT0,"^",3) Q:'$D(APCMPRV(ORPVID))  ;quit if ordering provider doesn't match user selected provider
 ...S PATLOC=+$P($G(^OR(100,ORIEN,0)),U,10)
 ...S C="" I PATLOC,$D(^SC(PATLOC,0)) S C=$P(^SC(PATLOC,0),U,7) I C Q:$P($G(^DIC(40.7,C,0)),U,2)=30  ;IF ER IN HOSP LOC Q
 ...S G=1
 ..I APCMRPTT=2 D
 ...I ORPTST="I" S G=1 Q
 ...Q:APCMMETH="O"
 ...S PATLOC=+$P($G(^OR(100,ORIEN,0)),U,10)
 ...Q:'PATLOC
 ...S C="" I PATLOC,$D(^SC(PATLOC,0)) S C=$P(^SC(PATLOC,0),U,7) I C Q:$P($G(^DIC(40.7,C,0)),U,2)'=30  ;IF NOT ER IN HOSP LOC Q
 ...I PATLOC,$D(^SC(PATLOC,0)) S C=$P(^SC(PATLOC,0),U,4) I C,C'=APCMFAC Q
 ...S G=1
 ..Q:'G
 ..S ORORD=$P(ORACT0,"^",12) ;ORORD holds nature of order ien
 ..;SET DENOM COUNT FOR THIS EP = INCREMENT BY 1
 ..I APCMRPTT=1 S $P(APCMRXS(ORPVID),U,1)=$P($G(APCMRXS(ORPVID)),U,1)+1,$P(^TMP($J,"PATSRX",ORPVID,PAT),U,1)=$P($G(^TMP($J,"PATSRX",ORPVID,PAT)),U,1)+1
 ..I APCMRPTT=2 S $P(APCMRXS(APCMFAC),U,1)=$P($G(APCMRXS(APCMFAC)),U,1)+1,$P(^TMP($J,"PATSRX",APCMFAC,PAT),U,1)=$P($G(^TMP($J,"PATSRX",APCMFAC,PAT)),U,1)+1
 ..;
 ..;now check to see if it has a nature of order IS equal to 1-written if so, quit and don't set numerator
 ..I ORORD=1 Q  ;this is a written order so do not put in numerator 
 ..S ORDEB=$P(^OR(100,ORIEN,8,1,0),"^",13)  ;this is the person who entered the order (ENTERED BY)
 ..;Q:'$$ORES(ORDEB,$P(ID,".",1))  ;quit if this person does not have ORES or ORESLE on date of order so don't count in numerator
 ..; DUZ=2793 W "  NUMER"
 ..I APCMRPTT=1 S $P(APCMRXS(ORPVID),U,2)=$P(APCMRXS(ORPVID),U,2)+1,$P(^TMP($J,"PATSRX",ORPVID,PAT),U,2)=$P($G(^TMP($J,"PATSRX",ORPVID,PAT)),U,2)+1
 ..I APCMRPTT=2 S $P(APCMRXS(APCMFAC),U,2)=$P($G(APCMRXS(APCMFAC)),U,2)+1,$P(^TMP($J,"PATSRX",APCMFAC,PAT),U,2)=$P($G(^TMP($J,"PATSRX",APCMFAC,PAT)),U,2)+1
 Q
NMSP(PKG) ; -- Returns package namespace from pointer
 N Y S Y=$$GET1^DIQ(9.4,+PKG_",",1)
 S:$E(Y,1,2)="PS" Y="PS" S:Y="GMRV" Y="OR"
 Q Y
 ;
ORES(R,D) ;EP - DID PROVIDER HAVE ORES OR ORESLE ON DATE D
 I '$G(R) Q ""
 I '$D(^VA(200,R,0)) Q ""
 NEW K,J
 S K=$O(^DIC(19.1,"B","ORES",0))
 S J=$O(^DIC(19.1,"B","ORELSE",0))
 I $D(^VA(200,R,51,K,0)),$P(^VA(200,R,51,K,0),U,3)'>D Q 1
 I $D(^VA(200,R,51,J,0)),$P(^VA(200,R,51,J,0),U,3)'>D Q 1
 Q ""
PEA ;EP - PATIENT ELECTRONIC ACCESS
 ;does visit have AF-PHR or HIE logged for that visit
 NEW APCMP
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .Q:'$D(APCMHVTP(APCMP))  ;no visits to this provider for this patient so don't bother, the patient is not in the denominator
 .;numerator?
 .S APCMEP=$$HASPEA(DFN,APCMBDAT,APCMEDAT,APCMP,1,.APCMVSTS)  ;return # of visits^# w/AF-PHR or logged in HIE log
 .;set denominator value into field
 .S APCMTV=$P(APCMEP,U),APCMTE=$P(APCMEP,U,2)
 .S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM24E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 .;numerator?
 .S APCMVALU="# visits: "_$P(APCMEP,U,1)_" # elec access: "_+$P(APCMEP,U,2)_" |||"_$P(APCMEP,U,3)_" "_$P(APCMEP,U,4)_"|||"_$S($P(APCMEP,U,2):1,1:0)
 .S F=$P(^APCM24OB(APCMIC,0),U,9)
 .D S^APCM24E1(APCMRPT,APCMIC,$S(APCMTE:1,1:0),APCMP,APCMRPTT,APCMTIME,F)
 .;measure b - did they access in ehr report period
 .I $G(APCMATTE("S2.020.EP.1",APCMP))="Yes" S F=$P(^APCM24OB($O(^APCM24OB("B","S2.020.EP.1",0)),0),U,11) D
 ..D S^APCM24E1(APCMRPT,$O(^APCM24OB("B","S2.020.EP.1",0)),"Yes",APCMP,APCMRPTT,APCMTIME,F,1)
 .S V="" I $T(PHR^BPHRMUPM)]"" D PHR^BPHRMUPM(DFN,APCMBDAT,DT,.V)
 .;I DUZ=2793 S V="1^3130812^1^3130812^1^3130812"
 .S APCMVALU="# visits: "_$P(APCMEP,U,1)_" # elec access: "_+$P(APCMEP,U,2)_" |||"_$P(APCMEP,U,3)_" "_$P(APCMEP,U,4)_" accessed PHR: "_$$DATE^APCM1UTL($P(V,U,4))_"|||"_$S($P(APCMEP,U,2):1,1:0)_"|||"_$P(V,U,3)
 .;set measure B
 .S Y=$O(^APCM24OB("B","S2.020.EP.1",0))
 .S F=$P(^APCM24OB(Y,0),U,8)
 .D S^APCM24E1(APCMRPT,Y,1,APCMP,APCMRPTT,APCMTIME,F)
 .S F=$P(^APCM24OB(Y,0),U,9)
 .D S^APCM24E1(APCMRPT,Y,$P(V,U,3),APCMP,APCMRPTT,APCMTIME,F)
 .;Q:$P(APCMEP,U,1)=0
 .D SETLIST^APCM24E1
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .;GET ARRAY OF DISCHARGES/ER VISITS
 .NEW APCMHERL,CNT,APCMHER
 .K APCMHER
 .S CNT=0
 .S X=0 F  S X=$O(^AUPNVINP("AC",DFN,X)) Q:X'=+X  D
 ..Q:'$D(^AUPNVINP(X,0))
 ..S D=$P($P(^AUPNVINP(X,0),U,1),".")
 ..Q:D<APCMBDAT
 ..Q:D>APCMEDAT
 ..Q:$$LOCENC^APCLV($P(^AUPNVINP(X,0),U,3))'=APCMFAC
 ..Q:$$SC^APCLV($P(^AUPNVINP(X,0),U,3))'="H"  ;don't count Events
 ..S CNT=CNT+1
 ..S $P(APCMHER(CNT),U,5)=$P(^AUPNVINP(X,0),U,3) ;visit array
 .;IF ED METHOD ;NOW GET ALL ER VISITS
 .I APCMMETH="E" D
 ..S X=0 F  S X=$O(APCMVSTS(X)) Q:X'=+X  D
 ...S V=$P(APCMVSTS(X),U,5)
 ...Q:$$CLINIC^APCLV(V,"C")'=30
 ...Q:$$LOCENC^APCLV(V)'=APCMFAC
 ...Q:$$SC^APCLV(V)'="A"
 ...S CNT=CNT+1
 ...S $P(APCMHER(CNT),U,5)=V
 .I APCMMETH="O" D
 ..S X=0 F  S X=$O(APCMVSTS(X)) Q:X'=+X  D
 ...S V=$P(APCMVSTS(X),U,5)
 ...Q:$$SC^APCLV(V)'="O"
 ...S CNT=CNT+1
 ...S $P(APCMHER(CNT),U,5)=V
 .I '$D(APCMHER) Q  ;no visits
 .S APCMEP=$$HASPEA(DFN,APCMBDAT,APCMEDAT,APCMP,2,.APCMHER)  ;return # of visits^# w/AF-PHR or logged in HIE log
 .;set denominator value into field
 .S APCMTV=$P(APCMEP,U),APCMTE=$P(APCMEP,U,2)
 .S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 .D S^APCM24E1(APCMRPT,APCMIC,1,APCMP,APCMRPTT,APCMTIME,F)
 .;numerator?
 .S APCMVALU="# visits: "_$P(APCMEP,U,1)_" # elec access: "_+$P(APCMEP,U,2)_" |||"_$P(APCMEP,U,3)_" "_$P(APCMEP,U,4)_"|||"_$S($P(APCMEP,U,2):1,1:0)
 .S F=$P(^APCM24OB(APCMIC,0),U,9)
 .D S^APCM24E1(APCMRPT,APCMIC,$S(APCMTE:1,1:0),APCMP,APCMRPTT,APCMTIME,F)
 .;measure b - did they access in ehr report period
 .I $G(APCMATTE("S2.025.H.1",APCMP))="Yes" S F=$P(^APCM24OB($O(^APCM24OB("B","S2.025.H.1",0)),0),U,11) D
 ..D S^APCM24E1(APCMRPT,$O(^APCM24OB("B","S2.025.H.1",0)),"Yes",APCMP,APCMRPTT,APCMTIME,F,1)
 .S V="" I $T(PHR^BPHRMUPM)]"" D PHR^BPHRMUPM(DFN,APCMBDAT,DT,.V)
 .S APCMVALU="# visits: "_$P(APCMEP,U,1)_" # elec access: "_+$P(APCMEP,U,2)_" |||"_$P(APCMEP,U,3)_" "_$P(APCMEP,U,4)_" accessed PHR: "_$$DATE^APCM1UTL($P(V,U,4))_"|||"_$S($P(APCMEP,U,2):1,1:0)_"|||"_$P(V,U,3)
 .;set measure B
 .S Y=$O(^APCM24OB("B","S2.025.H.1",0))
 .S F=$P(^APCM24OB(Y,0),U,8)
 .D S^APCM24E1(APCMRPT,Y,1,APCMP,APCMRPTT,APCMTIME,F)
 .S F=$P(^APCM24OB(Y,0),U,9)
 .D S^APCM24E1(APCMRPT,Y,$P(V,U,3),APCMP,APCMRPTT,APCMTIME,F)
 .;Q:$P(APCMEP,U,1)=0
 .D SETLIST^APCM24E1
 .Q
 Q
HASPEA(P,BD,ED,R,RPT,VSTS) ;did a ccda get transmitted for each visit?  return #visits^#w/ccda
 ;
 NEW A,B,C,D,E,X,Y,V,PWH,T,W,Z,Q,PED,EDUC
 ;LOOP THROUGH ALL VISITS AND COUNT VISIT AND ccda'S
 S PWH="0^0"
 ;check 89 multiple in AUPNPAT for a YES in .02 field
 S Z=0 F  S Z=$O(^AUPNPAT(P,89,Z)) Q:Z'=+Z  I $P($G(^AUPNPAT(P,89,Z,0)),U,2) D
 .Q:$P(^AUPNPAT(P,89,Z,0),U,1)>ED  ;after report period
 .S $P(PWH,U,3)="PT REG HANDOUT on "_$$DATE^APCM1UTL($P(^AUPNPAT(P,89,Z,0),U,1))
 ;if no handout, check education for AF-PHR
 I $P(PWH,U,3)="" D
 .K EDUC
 .S Y="EDUC("
 .S Z=P_"^ALL EDUC AF-PHR;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(ED) S E=$$START1^APCLDF(Z,Y)
 .I $D(EDUC(1)) D
 ..S $P(PWH,U,3)="AF-PHR on "_$$DATE^APCM1UTL($P(EDUC(1),U,1))
 .Q
 S X=0 F  S X=$O(VSTS(X)) Q:X'=+X!($P(PWH,U,2))  D
 .S G=0
 .S V=$P(VSTS(X),U,5)
 .I '$D(^AUPNVSIT(V,0)) Q
 .I $P(^AUPNVSIT(V,0),U,11) Q  ;deleted
 .I RPT=2 G SETD
 .I "AOSM"'[$P(^AUPNVSIT(V,0),U,7) Q  ;not correct service category/OFFICE VISIT
 .S Y=0 F  S Y=$O(^AUPNVPRV("AD",V,Y)) Q:Y'=+Y!(G)  D
 ..I $P($G(^AUPNVPRV(Y,0)),U)'=R Q
 ..Q:$P(^AUPNVPRV(Y,0),U,4)'="P"
 ..S G=1
 .Q:'G  ;not a visit to this provider
 .S C=$$CLINIC^APCLV(V,"C")
 .Q:C=30  ;NO ER
 .Q:C=77  ;NO CASE MANAGEMENT
 .Q:C=76  ;no lab
 .Q:C=63  ;NO RAD
 .Q:C=39  ;NO PHARMACY
SETD .S $P(PWH,U,1)=$P(PWH,U,1)+1
 .;RIGHT HERE CHECK DAVID'S API, if date returned was within 4 business days count it and go on to check for patient ed - IT IS HOSP USE 3 DAYS AFTER DISCHARGE
 .S B=""
 .I RPT=1 S D=$$GET1^DIQ(9000010,V,1109,"I")
 .I RPT=2 D
 ..I $P(^AUPNVSIT(V,0),U,7)="H" S D=$$DDTM^APCLV(V) Q
 ..S D=$$ERDDT(V)
 ..I D="" S D=$$GET1^DIQ(9000010,V,1109,"I")
 .;I DUZ=2793 S B=$$VDTM^APCLV(V)  ;LORI
 .I $T(AUDITHIE^BCCDUTIL)]"" S B=$$AUDITHIE^BCCDUTIL(V,D)
 .;I DUZ=2793 S B=3130725.111
 .I B="" Q  ;doesn't fit numerator as it was never transmitted
 .;now check date B against date D to see if it is 4 business days FOR RPT 1, 36 hours for rpt 2
 .I RPT=1 S E=$$BD^APCM24E4(D,4)  ;get date that is 4 business days from D
 .I RPT=2 S E=$$FMDIFF^XLFDT(B,D,2),E=E/60,E=E/60
 .I RPT=1,B>E Q  ;more that 4 business days/36 HOURS
 .I RPT=2,E>36 Q
 .Q:$P(PWH,U,3)=""  ;doesn't have other stuff so don't count in numerator
 .S $P(PWH,U,4)="Visit "_$$DATE^APCM1UTL($$VD^APCLV(V))_" w/HIE Date "_$$DATE^APCM1UTL(B)
 .S $P(PWH,U,2)=$P(PWH,U,2)+1
 Q PWH
ERDDT(V) ;EP - get ER departure date/time
 I '$G(V) Q ""
 NEW X,Y
 S X=$O(^AUPNVER("AD",V,0))
 I 'X Q ""
 Q $$GET1^DIQ(9000010.29,X,.13,"I")
