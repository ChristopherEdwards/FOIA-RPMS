APCM2AE1 ; IHS/CMI/LAB - IHS MU 24 Feb 2015 10:32 AM ; 28 Jul 2016  11:41 AM
 ;;1.0;MU PERFORMANCE REPORTS;**7,8**;MAR 26, 2012;Build 22
 ;
BQI(BQIGREF,APCMPRV) ;PEP-Call from iCare
 ; input
 ; BQIGREF - Global reference
 ; APCMPRV - Array of providers
 ;
PROC ;EP
 S APCMBT=$H
 ;D JRNL^APCM1UTL
 S APCMJ=$J,APCMH=$H
 S APCMSEME=0  ;FOR SEM ERROR -1 FROM PHR
 S APCMVDTE=0  ;FOR VDT ERROR -1 FROM PHR CALL
 D XTMP^APCM1UTL("APCM1D","MU Patient List")
 ;process each patient
 ;first gather up provider exclusions
 I APCMRPTT=2 D  G PROC1  ;hospital report doesn't need this stuff for exclusions
 .K APCMOFFV
 .K APCM2AON
 .K APCMIMME
 .K APCMN565
 .K APCMHO65
 .K APCMNOEC
 .S X=APCMFAC  S APCMX=$$VSTH(APCMFAC,APCMBD,APCMED,APCMMETH) D
 ..I '$P(APCMX,U,3) S APCM2AON(X,1)=""
 ..I '$P(APCMX,U,1) S APCMOFFV(X,1)=""
 ..I '$P(APCMX,U,5) S APCMIMME(X,1)=""
 ..I '$P(APCMX,U,6) S APCMN565(X,1)=""
 ..I '$P(APCMX,U,7) S APCMHO65(X,1)=""
 ..I '$P(APCMX,U,9) S APCMNOEC(X,1)=""
 .;
 K APCM100R
 S X=0 F  S X=$O(APCMPRV(X)) Q:X'=+X  I '$$H100(X,APCMBD,APCMED) S APCM100R(X,1)=""
 K APCM2AON
 K APCMIMME
 K APCMOFFV
 S X=0 F  S X=$O(APCMPRV(X)) Q:X'=+X  S APCMX=$$VST(X,APCMBD,APCMED) D
 .I '$P(APCMX,U,3) S APCM2AON(X,1)=""  ;smk status excl
 .I '$P(APCMX,U,1) S APCMOFFV(X,1)=""  ;
 .I '$P(APCMX,U,5) S APCMIMME(X,1)=""  ;imm reg excl
N1 ;
 ;NOW GO THROUGH ALL PROVIDER'S VISIT IN 24 MONTHS BEFORE EHR REPORTING PERIOD, SEE IF ANY VISITS
 K APCM2ABR
 S X=0  F  S X=$O(APCMPRV(X)) Q:X'=+X  D
 .S APCMX=$$VST24(X,$$FMADD^XLFDT(APCMBD,-(24*30.5)),$$FMADD^XLFDT(APCMBD,-1))
 .I 'APCMX S APCM2ABR(X)=""  ;EXCL FROM PAT REMINDERS
 ;
PROC1 ;
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .Q:'$D(^DPT(DFN,0))
 .;I DUZ=2793 Q:'$D(^DIBT(4723,1,DFN))
 .;I DUZ=2793 Q:DFN'=2972
 .Q:$$DEMO^APCLUTL(DFN,$G(APCMDEMO))
 .D PROCCY
N ;
 ;NOW DO ATTESTATION MEASURES
 D PROCACY
 S APCMET=$H
 Q
 ;
PROCCY ;EP - current time period
 K ^TMP($J)
 Q:'$D(^DPT(DFN,0))
 Q:$P(^DPT(DFN,0),U,2)=""
 S APCMEDAT=APCMED,APCMTIME=1,APCMBDAT=APCMBD,APCMGBL="^APCMM25C(",APCMFILN=9001304.0311
 S APCMAGEB=$$AGE^AUPNPAT(DFN,APCMBDAT)
 S APCMAGEE=$$AGE^AUPNPAT(DFN,APCMEDAT)
 S APCMSEX=$P(^DPT(DFN,0),U,2)
 ;had visit to each provider?
 D CALCIND
 K ^TMP($J,"A")
 Q
CALCIND ;
 D CALCIND^APCM2ACI
 Q
PROCACY ;EP - current time period
 S APCMEDAT=APCMED,APCMTIME=1,APCMBDAT=APCMBD,APCMGBL="^APCMM25C(",APCMFILN=9001304.0311
 D CALCINDA^APCM2ACI
 Q
S(RPT,IND,VALUE,PROV,RT,T,F,NT) ;EP - set counter
 NEW N,P,Y,J,I,ID
 I VALUE="" Q  ;no value to add
 I RT=1 S I=PROV_";VA(200,"
 I RT=2 S I=PROV_";AUTTLOC("
 I T=1 D  Q
 .I $G(BQIGREF)'="" D  Q
 ..NEW ID
 ..S ID=$P(^APCM25OB(IND,0),U,1)
 ..I $P(^APCM25OB(IND,0),U,8)=F S $P(@BQIGREF@(PROV,ID,"CURR"),U,1)=$P($G(@BQIGREF@(PROV,ID,"CURR")),U,1)+VALUE
 ..I $P(^APCM25OB(IND,0),U,9)=F S $P(@BQIGREF@(PROV,ID,"CURR"),U,2)=$P($G(@BQIGREF@(PROV,ID,"CURR")),U,2)+VALUE
 ..I $P(^APCM25OB(IND,0),U,11)=F S $P(@BQIGREF@(PROV,ID,"CURR"),U,3)=VALUE
 ..S $P(@BQIGREF@(PROV,ID,"CURR"),U,4)=$G(APCMVALU)
 .S Y=$P(^DD(9001304.0311,F,0),U,4)
 .S N=$P(Y,";")
 .S P=$P(Y,";",2)
 .S J=$O(^APCMM25C(RPT,11,"B",I,0))
 .I 'J W APCMBOMB Q
 .I VALUE?.N S $P(^APCMM25C(RPT,11,J,N),U,P)=$P($G(^APCMM25C(RPT,11,J,N)),U,P)+VALUE
 .I VALUE'?.N S $P(^APCMM25C(RPT,11,J,N),U,P)=VALUE
 .Q
 Q
SETLIST ;EP
 NEW P,APCMX,APCMO
 Q:APCMTIME'=1
 Q:'$D(APCMINDL(APCMIC))  ;not a selected topic
 S APCMX=0 F  S APCMX=$O(APCMINDL(APCMIC,APCMX)) Q:APCMX'=+APCMX  D
 .X ^APCMM25L(APCMX,12) Q:'$T
 .S APCMINDL(APCMIC,APCMX,APCMP)=$G(APCMINDL(APCMIC,APCMX,APCMP))+1
 .S APCMO=$S(APCMRPTT=2:$P(^APCMM25L(APCMX,0),U,6),1:$P(^APCMM25L(APCMX,0),U,5))
 .S P=$S(APCMRPTT=2:$P(^DIC(4,APCMP,0),U),1:$P(^VA(200,APCMP,0),U))
 .S ^XTMP("APCM1D",APCMJ,APCMH,"LIST",$P(^APCM25OB(APCMIC,0),U,4),APCMIC,APCMO,APCMX,P,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),$$AGE^AUPNPAT(DFN,APCMBDAT),DFN)=$G(APCMVALU)
 Q
H100(R,BD,ED) ;
 NEW ID,C,Y,X,VMED,V
 S C=0
 S ID=$$FMADD^XLFDT(BD,-1)
 F  S ID=$O(^PSRX("AC",ID)) Q:ID'=+ID!(C>100)!(ID>ED)  D
 .S X=0 F  S X=$O(^PSRX("AC",ID,X)) Q:X'=+X!(C>100)  D
 ..Q:$P($G(^PSRX(X,0)),U,4)'=R
 ..Q:$P($G(^PSRX(X,"STA")),"^")=13
 ..;SKIP ER CLINIC OR H VISIT, GET VISIT FROM V MED
 ..S VMED=$P($G(^PSRX(X,999999911)),U,1)
 ..Q:'VMED
 ..S V=$P($G(^AUPNVMED(VMED,0)),U,3)
 ..Q:'V
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$P(^AUPNVSIT(V,0),U,7)="H"
 ..Q:$$CLINIC^APCLV(V,"C")=30
 ..S C=C+1
 Q $S(C>100:1,1:"")
VST(R,BD,ED) ;did this provider see anyone over 2
 NEW SD,A,B,C,G,V,T
 S SD=$$FMADD^XLFDT(BD,-1)
 S SD=SD_".9999"
 S G=""
 F  S SD=$O(^AUPNVSIT("B",SD)) Q:SD'=+SD!($P(SD,".")>ED)!($$GOTALL(G))  D
 .S V=0 F  S V=$O(^AUPNVSIT("B",SD,V)) Q:V'=+V!($$GOTALL(G))  D
 ..S B=0,C=0 F  S B=$O(^AUPNVPRV("AD",V,B)) Q:B'=+B  D
 ...Q:'$D(^AUPNVPRV(B,0))
 ...Q:$P(^AUPNVPRV(B,0),U,1)'=R
 ...Q:$P(^AUPNVPRV(B,0),U,4)'="P"
 ...S C=1
 ..Q:'C  ;not to this provider
 ..S C=$$CLINIC^APCLV(V,"C")
 ..I C=30 Q  ;no ER per Carmen patch 1
 ..I C=77 Q  ;no case management clinic 77 per Chris
 ..I C=76 Q  ;no lab
 ..I C=63 Q  ;no radiology
 ..I C=39 Q  ;no pharmacy
 ..S $P(G,U,1)=1  ;has an office visit ;clinic summary excl
 ..I $$AGE^AUPNPAT($P(^AUPNVSIT(V,0),U,5),$P(BD,"."))>12 S $P(G,U,3)=1
 ..I $D(^AUPNVIMM("AD",V)) S $P(G,U,5)=1  ;not an exclusion for imm reg
 Q G
 ;
GOTALL(%) ;EP
 NEW Y
 S Y=$P(%,U,1)+$P(%,U,3)+$P(%,U,5)
 I Y=3 Q 1
 Q 0
VST24(R,BD,ED) ;did this provider see anyone over 2
 NEW SD,A,B,C,G,V,T
 S SD=$$FMADD^XLFDT(BD,-1)
 S SD=SD_".9999"
 S G=""
 F  S SD=$O(^AUPNVSIT("B",SD)) Q:SD'=+SD!($P(SD,".")>ED)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("B",SD,V)) Q:V'=+V!(G)  D
 ..S B=0,C=0 F  S B=$O(^AUPNVPRV("AD",V,B)) Q:B'=+B!(C)  D
 ...Q:'$D(^AUPNVPRV(B,0))
 ...Q:$P(^AUPNVPRV(B,0),U,1)'=R
 ...Q:$P(^AUPNVPRV(B,0),U,4)'="P"
 ...S C=1
 ..Q:'C  ;not to this provider
 ..S C=$$CLINIC^APCLV(V,"C")
 ..I C=30 Q  ;no ER per Carmen patch 1
 ..I C=77 Q  ;no case management clinic 77 per Chris
 ..I C=76 Q  ;no lab
 ..I C=63 Q  ;no radiology
 ..I C=39 Q  ;no pharmacy
 ..S G=1  ;has an office visit ;clinic summary excl
 Q G
VSTH(R,BD,ED,APCMMETH) ;did this HOSPITAL HAVE THESE VISITS
 NEW SD,A,B,C,G,V,T,O,P,Q,E,J,S
 S T=$O(^APCMMUCN("B","MODIFIED STAGE 2 2015",0))
 S SD=$$FMADD^XLFDT(BD,-1)
 S SD=SD_".9999"
 S G=""
 F  S SD=$O(^AUPNVSIT("B",SD)) Q:SD'=+SD!($P(SD,".")>ED)!($$GOTALLH(G))  D
 .S V=0 F  S V=$O(^AUPNVSIT("B",SD,V)) Q:V'=+V!($$GOTALLH(G))  D
 ..Q:$P(^AUPNVSIT(V,0),U,6)'=R
 ..I APCMMETH="E" Q:'$$HOSER^APCM25E6(V,R)
 ..I APCMMETH="O" Q:"OH"'[$P(^AUPNVSIT(V,0),U,7)
 ..S $P(G,U,1)=1
 ..S A=$$AGE^AUPNPAT($P(^AUPNVSIT(V,0),U,5),$P(BD,".")) I A>2 S $P(G,U,2)=1
 ..I A>12 S $P(G,U,3)=1
 ..S $P(G,U,4)=1
 ..I $D(^AUPNVIMM("AD",V)) S $P(G,U,5)=1  ;not an exclusion for imm reg
 ..;check age
 ..I A<6!(A>64) S $P(G,U,6)=1
 ..I $P(^AUPNVSIT(V,0),U,7)="H" S A=$$AGE^AUPNPAT($P(^AUPNVSIT(V,0),U,5),$$VD^APCLV(V)) I A>64 S $P(G,U,7)=1
 Q G
GOTALLH(%) ;EP
 NEW Y
 S Y=$P(%,U,1)+$P(%,U,2)+$P(%,U,3)+$P(%,U,4)+$P(%,U,5)+$P(%,U,6)+$P(%,U,7)+$P(%,U,8)+$P(%,U,9)
 I Y=9 Q 1
 Q 0
