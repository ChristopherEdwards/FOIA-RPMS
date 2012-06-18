BGPMUEPD ; IHS/MSC/MMT - EP Report Driver;02-Mar-2011 11:36;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
PROC ;EP
 D BQIKILL
 S BGPBT=$H
 D JRNL^BGPMUUTL
 S BGPJ=$J,BGPH=$H
 S BGPCHWC=0
 K ^XTMP("BGPMUEP",BGPJ,BGPH) ; not sure if I need this Timestamp stuff or if it should be Provider Specific
 D XTMP^BGPMUUTL("BGPMUEP","Meaningful Use EP Report")
 ;calculate 3 years before end of each time frame
 S BGP3YE=$$FMADD^XLFDT(BGPED,-1096)
 S BGPB3YE=$$FMADD^XLFDT(BGPBED,-1096)
 ;process each patient
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .I $G(BGPDESGP) S P=$$DP(DFN) I P'=BGPDESGP Q
 .Q:'$D(^DPT(DFN,0))
 .Q:$P($G(^DPT(DFN,0)),U)["DEMO,PATIENT"
 .I $P($G(^BGPSITE(DUZ(2),0)),U,12) Q:$D(^DIBT($P(^BGPSITE(DUZ(2),0),U,12),1,DFN))
 .D PROCCY,PROCPY,PROCBY
N ;
 S BGPET=$H
 Q
 ;
PROCCY ;EP - current time period
 Q:'$D(^DPT(DFN,0))
 Q:$P(^DPT(DFN,0),U,2)=""
 Q:"FM"'[$P(^DPT(DFN,0),U,2)
 S BGPBDATE=BGPBD,BGPEDATE=BGPED,BGPTIME=1
 S BGP365=BGPBDATE
 S BGPACTUP=$$ACTUPAP(DFN,BGP3YE,BGPEDATE,BGPBEN)
 I 'BGPACTUP,'$G(BGPXPXPX),'$G(BGPIISO) Q
 S BGPACTCL=$$ACTCL(DFN,BGP3YE,BGPEDATE) ;active clinical
 S BGPAGEB=$$AGE^AUPNPAT(DFN,BGPBDATE)
 S BGPAGEE=$$AGE^AUPNPAT(DFN,BGPEDATE)
 S BGPSEX=$P(^DPT(DFN,0),U,2)
 I $G(BGPIISO)=1 S BGPACTUP=1,BGPACTCL=1  ;if in scheduling option, everyone is user pop/active clinical
 S BGPMUTF="C"
 D CALCMEAS
 Q
PROCPY ;
 Q:'$D(^DPT(DFN,0))
 Q:$P(^DPT(DFN,0),U,2)=""
 Q:"FM"'[$P(^DPT(DFN,0),U,2)
 S BGPBDATE=BGPPBD,BGPEDATE=BGPPED,BGPTIME=2
 S BGP365=BGPBDATE
 S BGPACTUP=$$ACTUPAP(DFN,BGPB3YE,BGPEDATE,BGPBEN)
 I 'BGPACTUP Q  ;if not in user pop, don't use patient
 S BGPACTCL=$$ACTCL(DFN,BGPB3YE,BGPEDATE) ;active clinical
 S BGPAGEB=$$AGE^AUPNPAT(DFN,BGPBDATE)
 S BGPAGEE=$$AGE^AUPNPAT(DFN,BGPEDATE)
 S BGPSEX=$P(^DPT(DFN,0),U,2)
 S BGPMUTF="P"
 D CALCMEAS
 Q
PROCBY ;
 Q:'$D(^DPT(DFN,0))
 Q:$P(^DPT(DFN,0),U,2)=""
 Q:"FM"'[$P(^DPT(DFN,0),U,2)
 S BGPBDATE=BGPBBD,BGPEDATE=BGPBED,BGPTIME=3
 S BGP365=BGPBDATE
 S BGPACTUP=$$ACTUPAP(DFN,BGPB3YE,BGPEDATE,BGPBEN)
 I 'BGPACTUP Q  ;if not in user pop, don't use patient
 S BGPACTCL=$$ACTCL(DFN,BGPB3YE,BGPEDATE) ;active clinical
 S BGPAGEB=$$AGE^AUPNPAT(DFN,BGPBDATE)
 S BGPAGEE=$$AGE^AUPNPAT(DFN,BGPEDATE)
 S BGPSEX=$P(^DPT(DFN,0),U,2)
 S BGPMUTF="B"
 D CALCMEAS
 Q
CALCMEAS ;
 D CALCMEAS^BGPMUDCI
 Q
V2(P,BDATE,EDATE) ;EP
 N A,B,X,G,V
 I '$D(^AUPNVSIT("AC",P)) Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G>2)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .S G=G+1
 .Q
 Q $S(G<2:"",1:1)
 ;
ACTUPAP(P,BDATE,EDATE,B) ;EP - is this patient in user pop?
 I B=1,$$BEN^AUPNPAT(P,"C")'="01" Q 0  ;must be Indian/Alaskan Native
 I B=2,$$BEN^AUPNPAT(P,"C")="01" Q 0  ;must not be I/A
 S DOD=$$DOD^AUPNPAT(P) I DOD]"",DOD<EDATE Q 0
 Q 1
 ;
ACTCL(P,BDATE,EDATE) ;EP - clinical user
 N X,G,F,S,V,B
 S (X,G,F,S)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(F)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .S B=$$CLINIC^APCLV(V,"C")
 .Q:B=""
 .I G,S S F=1
 .Q
 Q $S(F:1,1:0)
 ;
LASTVD(P,BDATE,EDATE) ;
 N A,B,V,X,G
 I '$D(^AUPNVSIT("AC",P)) Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .S G=1
 .Q
 Q G
 ;
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
DP(P) ;
 I $P(^AUPNPAT(P,0),U,14) Q $P(^AUPNPAT(P,0),U,14)
 I $T(ALLDP^BDPAPI)="" Q ""
 NEW X
 D ALLDP^BDPAPI(P,"DESIGNATED PRIMARY PROVIDER",.X)
 Q $P($G(X("DESIGNATED PRIMARY PROVIDER")),U,2)
 ;
BQI(BQIGREF,BGPPROV) ;PEP - iCARE
 ; Input parameters
 ; BQIGREF = Global reference to store data
 ; BGPPROV = Provider IEN
 Q:BQIGREF=""
 N BGPICARE,BGPIMEAS,BGPUMTF,BGPIIEN,BGPIDATA
 S BGPBT=$H
 D JRNL^BGPMUUTL
 S BGPJ=$J,BGPH=$H
 S BGPCHWC=0
 K ^XTMP("BGPMUEP",BGPJ,BGPH) ; not sure if I need this Timestamp stuff or if it should be Provider Specific
 D XTMP^BGPMUUTL("BGPMUEP","Meaningful Use EP Report")
 ;calculate 3 years before end of each time frame
 S BGP3YE=$$FMADD^XLFDT(BGPED,-1096)
 S BGPB3YE=$$FMADD^XLFDT(BGPBED,-1096)
 ;process each patient
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .Q:'$D(^DPT(DFN,0))
 .Q:$P($G(^DPT(DFN,0)),U)["DEMO,PATIENT"
 .I $P($G(^BGPSITE(DUZ(2),0)),U,12) Q:$D(^DIBT($P(^BGPSITE(DUZ(2),0),U,12),1,DFN))
 .K BGPICARE
 .D PROCCY
 .I $G(BGPPBD)'="" D PROCPY
 .;Move patient data for all requested measures from array to the passed in global reference
 .;  BGPICARE(INDICATOR_ID,Timeframe)=Denom Flag ^ Num Flag ^ Excl Flag ^ Denom disp ; Num disp ^ Excl disp
 .S BGPIMEAS=""
 .F  S BGPIMEAS=$O(BGPICARE(BGPIMEAS)) Q:BGPIMEAS=""  D
 ..S BGPMUTF=""
 ..F  S BGPMUTF=$O(BGPICARE(BGPIMEAS,BGPMUTF)) Q:BGPMUTF=""  D
 ...S BGPIDATA=$G(BGPICARE(BGPIMEAS,BGPMUTF))
 ...;Lookup indicator ID
 ...S BGPIIEN=$O(^BGPMUIND(90596.11,"C",BGPIMEAS,0))
 ...;Store into global - ONLY if measure ID exists
 ...I BGPIIEN'="" S @BQIGREF@(BGPPROV,DFN,BGPMUTF,BGPIIEN)=BGPIDATA
 D BQIKILL
 K BGPICARE,BGPIMEAS,BGPUMTF,BGPIIEN,BGPIDATA
 Q
BQIKILL ; TEMPORARY Subroutine to kill off ^TMP globals created by running measure evals without printing
 ;This routine should be removed once a better system for killing off ^TMP globals has been implemented
 K ^TMP("BGPMU0001",$J)
 K ^TMP("BGPMU0002",$J)
 K ^TMP("BGPMU0004",$J)
 K ^TMP("BGPMU0012",$J)
 K ^TMP("BGPMU0013",$J)
 K ^TMP("BGPMU0014",$J)
 K ^TMP("BGPMU0018",$J)
 K ^TMP("BGPMU0024",$J)
 K ^TMP("BGPMU0027",$J)
 K ^TMP("BGPMU0028A",$J)
 K ^TMP("BGPMU0028B",$J)
 K ^TMP("BGPMU0031",$J)
 K ^TMP("BGPMU0032",$J)
 K ^TMP("BGPMU0033",$J)
 K ^TMP("BGPMU0034",$J)
 K ^TMP("BGPMU0036",$J)
 K ^TMP("BGPMU0038",$J)
 K ^TMP("BGPMU0041",$J)
 K ^TMP("BGPMU0043",$J)
 K ^TMP("BGPMU0047",$J)
 K ^TMP("BGPMU0052",$J)
 K ^TMP("BGPMU0055",$J)
 K ^TMP("BGPMU0056",$J)
 K ^TMP("BGPMU0059",$J)
 K ^TMP("BGPMU0061",$J)
 K ^TMP("BGPMU0062",$J)
 K ^TMP("BGPMU0064",$J)
 K ^TMP("BGPMU0067",$J)
 K ^TMP("BGPMU0068",$J)
 K ^TMP("BGPMU0070",$J)
 K ^TMP("BGPMU0073",$J)
 K ^TMP("BGPMU0074",$J)
 K ^TMP("BGPMU0075",$J)
 K ^TMP("BGPMU0081",$J)
 K ^TMP("BGPMU0083",$J)
 K ^TMP("BGPMU0084",$J)
 K ^TMP("BGPMU0086",$J)
 K ^TMP("BGPMU0088",$J)
 K ^TMP("BGPMU0089",$J)
 K ^TMP("BGPMU0105",$J)
 K ^TMP("BGPMU0385",$J)
 K ^TMP("BGPMU0387",$J)
 K ^TMP("BGPMU0389",$J)
 K ^TMP("BGPMU0421",$J)
 K ^TMP("BGPMU0575",$J)
 Q
