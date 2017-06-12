APCM13E9 ;IHS/CMI/LAB - IHS MU; 
 ;;1.0;IHS MU PERFORMANCE REPORTS;**2,4,5,6**;MAR 26, 2012;Build 65
 ;;;;;;Build 3
 ;IHS/CMI/LAB - PATCH 4 REMOVED CPOE KEY LOGIC
CPOE ;EP - CALCULATE EPRESCRIBING
 ;for each provider or for the facility count all prescriptions that meet criteria and if it is not written it meets numerator
 K ^TMP($J,"PATSRX")
 K APCMRXS
 D TOTRX
 K ^TMP($J,"ORDERSPROCESSED")
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $P($G(APCMRXS(APCMP)),U,1)<100 S F=$P(^APCM13OB(APCMIC,0),U,11) D  G D
 ..D S^APCM13E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she had < 100 medication orders during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1)
D .;set denominator value into field
 .S F=$P(^APCM13OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMRXS(APCMP)),U,1)  ;returns # of prescriptions^# not written by nature of order
 .D S^APCM13E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"PATSRX",APCMP,P)) Q:P'=+P  D
 ..S D=$P(^TMP($J,"PATSRX",APCMP,P),U,1),N=$P(^TMP($J,"PATSRX",APCMP,P),U,2) S APCMVALU="# Orders: "_D_"|||"_"# CPOE: "_N_" # NOT CPOE: "_(D-N)
 ..S DFN=P D SETLIST^APCM13E1
 .;numerator?
 .S F=$P(^APCM13OB(APCMIC,0),U,9)
 .S N=$P($G(APCMRXS(APCMP)),U,2)
 .D S^APCM13E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .S F=$P(^APCM13OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMRXS(APCMFAC)),U,1)  ;returns # of prescriptions^# not written by nature of order
 .D S^APCM13E1(APCMRPT,APCMIC,N,APCMFAC,APCMRPTT,APCMTIME,F)
 .;now set patient list for this FACILITY
 .S P=0 F  S P=$O(^TMP($J,"PATSRX",APCMFAC,P)) Q:P'=+P  D
 ..S D=$P(^TMP($J,"PATSRX",APCMFAC,P),U,1),N=$P(^TMP($J,"PATSRX",APCMFAC,P),U,2) S APCMVALU="# Orders: "_D_"|||"_"# CPOE: "_N_" # NOT CPOE: "_(D-N)
 ..S DFN=P D SETLIST^APCM13E1
 .;numerator?
 .S F=$P(^APCM13OB(APCMIC,0),U,9)
 .S N=$P($G(APCMRXS(APCMFAC)),U,2)
 .D S^APCM13E1(APCMRPT,APCMIC,N,APCMFAC,APCMRPTT,APCMTIME,F)
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
 ..;I ORPTST="O",ORNS="PS",$G(^OR(100,ORIEN,4))=+$G(^OR(100,ORIEN,4)),$L($T(EN^PSOTPCUL)) Q:$$EN^PSOTPCUL($G(^OR(100,ORIEN,4)))  ;196 Don't count if outpatient pharm order is a transitional pharmacy benefit order
 ..S G=0
 ..I APCMRPTT=1 D
 ...Q:ORPTST'="O"  ;Quit if patient status is not outpatient and in EP report
 ...S ORPVID=$P(ORACT0,"^",3) Q:'$D(APCMPRV(ORPVID))  ;quit if ordering provider doesn't match user selected provider
 ...S PATLOC=+$P($G(^OR(100,ORIEN,0)),U,10)
 ...S C="" I PATLOC,$D(^SC(PATLOC,0)) S C=$P(^SC(PATLOC,0),U,7) I C Q:$P($G(^DIC(40.7,C,0)),U,2)=30  ;IF ER IN HOSP LOC Q
 ...S G=1
 ..I APCMRPTT=2 D
 ...I ORPTST="I" S G=1 Q
 ...S PATLOC=+$P($G(^OR(100,ORIEN,0)),U,10)
 ...Q:'PATLOC
 ...S C="" I PATLOC,$D(^SC(PATLOC,0)) S C=$P(^SC(PATLOC,0),U,7) I C Q:$P($G(^DIC(40.7,C,0)),U,2)'=30  ;IF NOT ER IN HOSP LOC Q
 ...I PATLOC,$D(^SC(PATLOC,0)) S C=$P(^SC(PATLOC,0),U,4) I C,C'=APCMFAC Q
 ...S G=1
 ..Q:'G
 ..S ORORD=$P(ORACT0,"^",12) ;ORORD holds nature of order ien
 ..;S ORPVNM=$P($G(^VA(200,ORPVID,0)),"^") ;get provider name
 ..;Q:'$D(^XUSEC("ORES",ORPVID))  ;quit if ordering provider doesn't have ORES key DBIA # 10076 allows direct read of XUSEC  =====> PM
 ..;Q:"^1^2^3^5^8^"'[("^"_ORORD_"^")  ;quit if NATUS O=$O(^OR(100,"AF"  ====> PM REPORT BUT NOT IN IHS MU LOGIC
 ..;SET DENOM COUNT FOR THIS EP = INCREMENT BY 1
 ..;I DUZ=2793 W !,"PAT: ",$P(^DPT(PAT,0),U,1),"DATE: ",$$FMTE^XLFDT(ID)," ORDER: ",ORIEN,"  NATURE: ",ORORD
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
