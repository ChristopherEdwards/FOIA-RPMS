APCM24E8 ;IHS/CMI/LAB - IHS MU; 
 ;;1.0;IHS MU PERFORMANCE REPORTS;**5,6**;MAR 26, 2012;Build 65
 ;;;;;;Build 3
LAB ;EP - CALCULATE LAB
 ;for each provider count each lab in the time period, loop through patients for visits in time period
 K ^TMP($J,"PATSRX")
 K APCMLABS
 D TOTLAB
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I '$P($G(APCMLABS(APCMP)),U,1) D  Q
 ..S F=$P(^APCM24OB(APCMIC,0),U,11) D S^APCM24E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not order any lab tests with results during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .;set denominator value
 .S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field
 .S N=$P($G(APCMLABS(APCMP)),U,1)  ;returns # of LABS^# not Structured data
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"PATSRX",APCMP,P)) Q:P'=+P  D
 ..;Q:'$P(^TMP($J,"PATSRX",APCMP,P),U,1)
 ..I $P(^TMP($J,"PATSRX",APCMP,P),U,1)=$P(^TMP($J,"PATSRX",APCMP,P),U,2) S APCMVALU="# Labs: "_$P(^TMP($J,"PATSRX",APCMP,P),U,1)_"|||"_" # w/structured result: "_+$P(^TMP($J,"PATSRX",APCMP,P),U,2)_"|||1" D  Q
 ...S DFN=P D SETLIST^APCM24E1 Q
 ..S S="",APCMVALU="No Structured Result: "
 ..F  S S=$O(^TMP($J,"PATSRX",APCMP,P,"SCRIPTS",S)) Q:S=""  D
 ...I '$D(^TMP($J,"PATSRX",APCMP,P,"ELEC",S)) D
 ....S APCMVALU=APCMVALU_S_";"
 ..S DFN=P,APCMVALU="# of Labs: "_$P(^TMP($J,"PATSRX",APCMP,P),U,1)_" # w/structured results: "_+$P(^TMP($J,"PATSRX",APCMP,P),U,2)_"|||"_APCMVALU,$P(APCMVALU,"|||",3)=0 D SETLIST^APCM24E1
 .;numerator?
 .S F=$P(^APCM24OB(APCMIC,0),U,9)
 .S N=$P($G(APCMLABS(APCMP)),U,2)
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"PATSRX")
 Q
TOTLAB ;EP - ep LAB
 ;SET ARRAY APCMLABS to APCMLABS(prov ien)=denom^numer
 ;IF DENOM =0 THEN PROVIDER EXCLUSION
 NEW ID,C,Y,X,D,S,N,A,B,R,PAT,ED,APCMLAB,APCMX,APCML,PAR
 S ED=9999999-APCMBDAT,ED=ED_".9999"
 S SD=9999999-APCMEDAT
 S C=0,N=0,PAT=""
 S LABSNO=""
 S T=$O(^ATXLAB("B","BGP PAP SMEAR TAX",0))
 S PAT="" F  S PAT=$O(^AUPNVSIT("AA",PAT)) Q:PAT'=+PAT  D TOTLAB1
 Q
TOTLAB1 ;
 NEW APCMLAB,APCMLAB1
 S APCMLAB="APCMLAB"
 D ALLLAB^APCM24EB(PAT,APCMBDAT,APCMEDAT,,,,.APCMLAB)
 ;reorder by IEN of v lab
 K APCMLAB1
 S APCMX=0 F  S APCMX=$O(APCMLAB(APCMX)) Q:APCMX'=+APCMX  D
 .S V=$P(APCMLAB(APCMX),U,5)  ;VISIT IEN
 .S Y=$P(APCMLAB(APCMX),U,4)  ;V LAB IEN
 .Q:'$D(^AUPNVSIT(V,0))  ;NO VISIT??
 .Q:"AOSM"'[$P(^AUPNVSIT(V,0),U,7)
 .S C=$$CLINIC^APCLV(V,"C")
 .Q:C=30  ;ER
 .S R=$P($G(^AUPNVLAB(Y,12)),U,2)  ;ORDERING PROVIDER
 .Q:'R  ;no ordering provider - CAN'T ASSIGN TO AN EP
 .I '$D(APCMPRV(R)) Q  ;not a provider of interest FOR THIS REPROT
 .;Q:$P($P($G(^AUPNVLAB(Y,12)),U,1),".")>APCMEDAT  ;collection date after time period
 .;Q:$P($P($G(^AUPNVLAB(Y,12)),U,1),".")<APCMBDAT  ;collection date before time period
 .S A=$P(^AUPNVLAB(Y,0),U,1)  ;test pointer
 .I T,$D(^ATXLAB(T,21,"B",A)) Q   ;it's a pap smear
 .I $$UP^XLFSTR($$VAL^XBDIQ1(9000010.09,Y,.01))="PAP SMEAR" Q  ;it's a pap smear
 .I $$UP^XLFSTR($P(^AUPNVLAB(Y,0),U,4))="CANC" Q
 .I $O(^LAB(60,A,2,0)) Q  ;this is the v lab for the panel
 .I '$D(APCMLABS(R)) S APCMLABS(R)=""
 .S $P(APCMLABS(R),U,1)=$P(APCMLABS(R),U,1)+1,$P(^TMP($J,"PATSRX",R,PAT),U,1)=$P($G(^TMP($J,"PATSRX",R,PAT)),U,1)+1,^TMP($J,"PATSRX",R,PAT,"SCRIPTS",$$VAL^XBDIQ1(9000010.09,Y,1201)_" "_$$VAL^XBDIQ1(9000010.09,Y,.01))=""
 .;now check numerator
 .Q:$P($G(^AUPNVLAB(Y,11)),U,9)'="R"  ;if status not resulted it doesn't make the numerator
 .I $$UP^XLFSTR($P(^AUPNVLAB(Y,0),U,4))="COMMENT",'$$HASCOM(Y) Q
 .S $P(APCMLABS(R),U,2)=$P(APCMLABS(R),U,2)+1,$P(^TMP($J,"PATSRX",R,PAT),U,2)=$P($G(^TMP($J,"PATSRX",R,PAT)),U,2)+1 S ^TMP($J,"PATSRX",R,PAT,"ELEC",$$VAL^XBDIQ1(9000010.09,Y,1201)_" "_$$VAL^XBDIQ1(9000010.09,Y,.01))=""  ;S N=N+G Q  ;S N=N+G
 Q
 ;
HASCOM(L) ;ARE THERE ANY COMMENTS
 I '$D(^AUPNVLAB(L,21)) Q 0
 NEW B,G
 S G=0
 S B=0 F  S B=$O(^AUPNVLAB(L,21,B)) Q:B'=+B  I ^AUPNVLAB(L,21,B,0)]"" S G=1  ;has comment
 Q G
CPOELAB ;EP - CALCULATE cpoelab
 ;for each provider or for the facility count all lab orders that meet criteria and if it is not written it meets numerator
 K ^TMP($J,"PATSLAB")
 K APCMLABS
 D LABCPOE
 K ^TMP($J,"ORDERSPROCESSED")
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $P($G(APCMLABS(APCMP)),U,1)<100 S F=$P(^APCM24OB(APCMIC,0),U,11) D
 ..D S^APCM24E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she had < 100 LAB orders during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1)
D .;set denominator value into field
 .S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMLABS(APCMP)),U,1)  ;returns # of lab orders^# not written by nature of order
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"PATSLAB",APCMP,P)) Q:P'=+P  D
 ..S D=$P(^TMP($J,"PATSLAB",APCMP,P),U,1),N=$P(^TMP($J,"PATSLAB",APCMP,P),U,2) S APCMVALU="# Orders: "_D_"|||"_"# CPOE: "_N_" # NOT CPOE: "_(D-N)
 ..S DFN=P D SETLIST^APCM24E1
 .;numerator?
 .S F=$P(^APCM24OB(APCMIC,0),U,9)
 .S N=$P($G(APCMLABS(APCMP)),U,2)
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMLABS(APCMFAC)),U,1)  ;returns # of lab orders^# not written by nature of order
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMFAC,APCMRPTT,APCMTIME,F)
 .;now set patient list for this FACILITY
 .S P=0 F  S P=$O(^TMP($J,"PATSLAB",APCMFAC,P)) Q:P'=+P  D
 ..S D=$P(^TMP($J,"PATSLAB",APCMFAC,P),U,1),N=$P(^TMP($J,"PATSLAB",APCMFAC,P),U,2) S APCMVALU="# Orders: "_D_"|||"_"# CPOE: "_N_" # NOT CPOE: "_(D-N)
 ..S DFN=P D SETLIST^APCM24E1
 .;numerator?
 .S F=$P(^APCM24OB(APCMIC,0),U,9)
 .S N=$P($G(APCMLABS(APCMFAC)),U,2)
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMFAC,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"PATSLAB"),^TMP($J,"ORDERSPROCESSED")
 Q
LABCPOE ;EP - 
 ;between BD and ED
 ;SET ARRAY APCMLABS to APCMLABS(prov ien)=denom^numer
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
 ..I ORNS'="LR" Q  ;if not getting all types of orders then quit if order is not from LAB
 ..S ORACT0=$G(^OR(100,ORIEN,8,1,0))
 ..Q:$P(ORACT0,U,1)'=ID
 ..S ORORD=$P(ORACT0,"^",12) ;ORORD holds nature of order ien
 ..;Q:ORORD=4  ;skip service corrections
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
 ...Q:APCMMETH="O"  ;DON'T COUNT ER VISITS IN OBS METHOD
 ...S PATLOC=+$P($G(^OR(100,ORIEN,0)),U,10)
 ...Q:'PATLOC
 ...S C="" I PATLOC,$D(^SC(PATLOC,0)) S C=$P(^SC(PATLOC,0),U,7) I C Q:$P($G(^DIC(40.7,C,0)),U,2)'=30  ;IF NOT ER IN HOSP LOC Q
 ...I PATLOC,$D(^SC(PATLOC,0)) S C=$P(^SC(PATLOC,0),U,4) I C,C'=APCMFAC Q
 ...S G=1
 ..Q:'G
 ..S ORORD=$P(ORACT0,"^",12) ;ORORD holds nature of order ien
 ..;SET DENOM COUNT FOR THIS EP = INCREMENT BY 1
 ..;I DUZ=2793 W !,"PAT: ",$P(^DPT(PAT,0),U,1),"DATE: ",$$FMTE^XLFDT(ID)," ORDER: ",ORIEN,"  NATURE: ",ORORD
 ..I APCMRPTT=1 S $P(APCMLABS(ORPVID),U,1)=$P($G(APCMLABS(ORPVID)),U,1)+1,$P(^TMP($J,"PATSLAB",ORPVID,PAT),U,1)=$P($G(^TMP($J,"PATSLAB",ORPVID,PAT)),U,1)+1
 ..I APCMRPTT=2 S $P(APCMLABS(APCMFAC),U,1)=$P($G(APCMLABS(APCMFAC)),U,1)+1,$P(^TMP($J,"PATSLAB",APCMFAC,PAT),U,1)=$P($G(^TMP($J,"PATSLAB",APCMFAC,PAT)),U,1)+1
 ..;
 ..;now check to see if it has a nature of order IS equal to 1-written if so, quit and don't set numerator
 ..I ORORD=1 Q  ;this is a written order so do not put in numerator 
 ..S ORDEB=$P(^OR(100,ORIEN,8,1,0),"^",13)  ;this is the person who entered the order (ENTERED BY)
 ..;Q:'$$ORES^APCM24E9(ORDEB,$P(ID,".",1))  ;quit if this person does not have ORES or ORESLE on date of order so don't count in numerator
 ..I APCMRPTT=1 S $P(APCMLABS(ORPVID),U,2)=$P(APCMLABS(ORPVID),U,2)+1,$P(^TMP($J,"PATSLAB",ORPVID,PAT),U,2)=$P($G(^TMP($J,"PATSLAB",ORPVID,PAT)),U,2)+1
 ..I APCMRPTT=2 S $P(APCMLABS(APCMFAC),U,2)=$P($G(APCMLABS(APCMFAC)),U,2)+1,$P(^TMP($J,"PATSLAB",APCMFAC,PAT),U,2)=$P($G(^TMP($J,"PATSLAB",APCMFAC,PAT)),U,2)+1
 Q
NMSP(PKG) ; -- Returns package namespace from pointer
 N Y S Y=$$GET1^DIQ(9.4,+PKG_",",1)
 S:$E(Y,1,2)="PS" Y="PS" S:Y="GMRV" Y="OR"
 Q Y
 ;
CPOERAD ;EP - CALCULATE EPRESCRIBING
 ;for each provider or for the facility count all rad orders that meet criteria and if it is not written it meets numerator
 K ^TMP($J,"PATSRAD")
 K APCMRADS
 D RADCPOE
 K ^TMP($J,"ORDERSPROCESSED")
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 I APCMRPTT=1 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 .I $P($G(APCMRADS(APCMP)),U,1)<100 S F=$P(^APCM24OB(APCMIC,0),U,11) D
 ..D S^APCM24E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she had < 100 Radiology orders during the EHR reporting period.",APCMP,APCMRPTT,APCMTIME,F,1)
DR .;set denominator value into field
 .S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMRADS(APCMP)),U,1)  ;returns # of prescriptions^# not written by nature of order
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"PATSRAD",APCMP,P)) Q:P'=+P  D
 ..S D=$P(^TMP($J,"PATSRAD",APCMP,P),U,1),N=$P(^TMP($J,"PATSRAD",APCMP,P),U,2) S APCMVALU="# Orders: "_D_"|||"_"# CPOE: "_N_" # NOT CPOE: "_(D-N)
 ..S DFN=P D SETLIST^APCM24E1
 .;numerator?
 .S F=$P(^APCM24OB(APCMIC,0),U,9)
 .S N=$P($G(APCMRADS(APCMP)),U,2)
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMP,APCMRPTT,APCMTIME,F)
 I APCMRPTT=2 D
 .S APCMP=APCMFAC
 .S F=$P(^APCM24OB(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMRADS(APCMFAC)),U,1)  ;returns # of prescriptions^# not written by nature of order
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMFAC,APCMRPTT,APCMTIME,F)
 .;now set patient list for this FACILITY
 .S P=0 F  S P=$O(^TMP($J,"PATSRAD",APCMFAC,P)) Q:P'=+P  D
 ..S D=$P(^TMP($J,"PATSRAD",APCMFAC,P),U,1),N=$P(^TMP($J,"PATSRAD",APCMFAC,P),U,2) S APCMVALU="# Orders: "_D_"|||"_"# CPOE: "_N_" # NOT CPOE: "_(D-N)
 ..S DFN=P D SETLIST^APCM24E1
 .;numerator?
 .S F=$P(^APCM24OB(APCMIC,0),U,9)
 .S N=$P($G(APCMRADS(APCMFAC)),U,2)
 .D S^APCM24E1(APCMRPT,APCMIC,N,APCMFAC,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"PATSRAD"),^TMP($J,"ORDERSPROCESSED"),APCMRADS
 Q
RADCPOE ;EP - 
 ;between BD and ED
 ;SET ARRAY APCMRADS to APCMRADS(prov ien)=denom^numer
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
 ..I ORNS'="RA" Q  ;if not getting all types of orders then quit if order is not from RAD
 ..S ORACT0=$G(^OR(100,ORIEN,8,1,0))
 ..Q:$P(ORACT0,U,1)'=ID
 ..S ORORD=$P(ORACT0,"^",12) ;ORORD holds nature of order ien
 ..;Q:ORORD=4  ;skip service corrections
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
 ...Q:APCMMETH="O"  ;DON'T COUNT ER VISITS IN OBS METHOD
 ...S PATLOC=+$P($G(^OR(100,ORIEN,0)),U,10)
 ...Q:'PATLOC
 ...S C="" I PATLOC,$D(^SC(PATLOC,0)) S C=$P(^SC(PATLOC,0),U,7) I C Q:$P($G(^DIC(40.7,C,0)),U,2)'=30  ;IF NOT ER IN HOSP LOC Q
 ...I PATLOC,$D(^SC(PATLOC,0)) S C=$P(^SC(PATLOC,0),U,4) I C,C'=APCMFAC Q
 ...S G=1
 ..Q:'G
 ..S ORORD=$P(ORACT0,"^",12) ;ORORD holds nature of order ien
 ..;SET DENOM COUNT FOR THIS EP = INCREMENT BY 1
 ..;I DUZ=2793 W !,"PAT: ",$P(^DPT(PAT,0),U,1),"DATE: ",$$FMTE^XLFDT(ID)," ORDER: ",ORIEN,"  NATURE: ",ORORD
 ..I APCMRPTT=1 S $P(APCMRADS(ORPVID),U,1)=$P($G(APCMRADS(ORPVID)),U,1)+1,$P(^TMP($J,"PATSRAD",ORPVID,PAT),U,1)=$P($G(^TMP($J,"PATSRAD",ORPVID,PAT)),U,1)+1
 ..I APCMRPTT=2 S $P(APCMRADS(APCMFAC),U,1)=$P($G(APCMRADS(APCMFAC)),U,1)+1,$P(^TMP($J,"PATSRAD",APCMFAC,PAT),U,1)=$P($G(^TMP($J,"PATSRAD",APCMFAC,PAT)),U,1)+1
 ..;
 ..;now check to see if it has a nature of order IS equal to 1-written if so, quit and don't set numerator
 ..I ORORD=1 Q  ;this is a written order so do not put in numerator 
 ..S ORDEB=$P(^OR(100,ORIEN,8,1,0),"^",13)  ;this is the person who entered the order (ENTERED BY)
 ..;Q:'$$ORES^APCM24E9(ORDEB,$P(ID,".",1))  ;quit if this person does not have ORES or ORESLE on date of order so don't count in numerator
 ..I APCMRPTT=1 S $P(APCMRADS(ORPVID),U,2)=$P(APCMRADS(ORPVID),U,2)+1,$P(^TMP($J,"PATSRAD",ORPVID,PAT),U,2)=$P($G(^TMP($J,"PATSRAD",ORPVID,PAT)),U,2)+1
 ..I APCMRPTT=2 S $P(APCMRADS(APCMFAC),U,2)=$P($G(APCMRADS(APCMFAC)),U,2)+1,$P(^TMP($J,"PATSRAD",APCMFAC,PAT),U,2)=$P($G(^TMP($J,"PATSRAD",APCMFAC,PAT)),U,2)+1
 Q
