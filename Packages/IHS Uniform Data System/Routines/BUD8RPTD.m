BUD8RPTD ; IHS/CMI/LAB - UDS REPORT PROCESSOR ;
 ;;7.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2013;Build 31
 ;
 ;
GETV ;EP - get all visits for this patient and tally in BUDTV
 ;^TMP($J,"VISITSLIST") has all visits, including orphans that will be needed for either table
 ;3, 5 or 6 dx or 6 services
 ;^TMP($J,"VISITS35") has all visits to count for tables 3,5 which excludes 2 visits to the same provider
 ;on the same day
 ;^TMP($J,"VISITSLIST") is used for table 6 services only
 ;^TMP($J,"VISITS35") is used for table 3 and 5
 ;^TMP($J,"VISITS6DX") is used for table 6 dxs and includes 2 visits on same day to same provider
 K ^TMP($J)
 S BUDTV=0,BUDT35V=0,BUDT6V=0,BUDMEDV=0,BUDMEDVI=""
 S A="^TMP($J,""VISITS"",",B=DFN_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BUDBD)_"-"_$$FMTE^XLFDT(BUDED),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"VISITS",1)) Q
 S X=0 F  S X=$O(^TMP($J,"VISITS",X)) Q:X'=+X  S V=$P(^TMP($J,"VISITS",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .S L=$P(^AUPNVSIT(V,0),U,6)
 .Q:L=""
 .Q:'$D(^BUDGSITE(BUDSITE,11,L))  ;not valid location
 .Q:$P(^AUPNVSIT(V,0),U,7)="C"
 .Q:$P(^AUPNVSIT(V,0),U,7)="T"
 .Q:$P(^AUPNVSIT(V,0),U,7)="N"
 .Q:$P(^AUPNVSIT(V,0),U,7)="D"
 .Q:$P(^AUPNVSIT(V,0),U,7)="X"
 .S C=$$CLINIC^APCLV(V,"C")
 .S BUDTIEN=$O(^BUDGCNTL("B","FIRST LEVEL CLINIC EXCLUSIONS",0))
 .I C]"",$D(^BUDGCNTL(BUDTIEN,11,"B",C)) Q  ;not a clinic code we want in any table
 .S BUDTV=BUDTV+1
 .S ^TMP($J,"VISITSLIST",V)=""
 ;now set up ^TMP($J,"VISITS35")  must have at least 1 of these to be in the report at all
 ;loop through all visits and eliminate all from clinics, and eliminate orphans
 S V=0 F  S V=$O(^TMP($J,"VISITSLIST",V)) Q:V'=+V  D
 .I '$D(^AUPNVPRV("AD",V)) Q
 .I $$PRIMPROV^APCLV(V,"D")="" Q  ;no prim prov disc
 .I '$D(^AUPNVPOV("AD",V)) Q
 .;must have a primary dx other than .9999
 .S Y=$$PRIMPOV^APCLV(V,"C") I Y=".9999" Q
 .;the above make it a "complete" visit
 .S BUDTIEN=$O(^BUDGCNTL("B","CLINIC EXCLUSIONS",0))
 .S C=$$CLINIC^APCLV(V,"C")
 .I C]"",$D(^BUDGCNTL(BUDTIEN,11,"B",C)) Q  ;exclude these clinics
 .Q:"AHSORI"'[$P(^AUPNVSIT(V,0),U,7)  ;new in 07 to exclude these from tables 3,5
 .I $D(^TMP($J,"SAMEPROV",$$PRIMPROV^APCLV(V,"I"),$P($P(^AUPNVSIT(V,0),U),"."))) Q  ;already got one on this day, this provider
 .S ^TMP($J,"SAMEPROV",$$PRIMPROV^APCLV(V,"I"),$P($P(^AUPNVSIT(V,0),U),"."))=V
 .S BUDT35V=BUDT35V+1
 .S ^TMP($J,"VISITS35",V)=""
 .;NOW CHECK FOR MEDICAL CARE
 .S BUDTIEN=$O(^BUDGCNTL("B","MEDICAL CARE PROVIDERS",0))
 .S Y=$$PRIMPROV^APCLV(V,"D") I $D(^BUDGCNTL(BUDTIEN,11,"B",Y)) S BUDMEDV=BUDMEDV+1,BUDMEDVI=V
 ;NOW get all for table 6 dxs, same list but include duplicates
 S V=0 F  S V=$O(^TMP($J,"VISITSLIST",V)) Q:V'=+V  D
 .I '$D(^AUPNVPRV("AD",V)) Q
 .I $$PRIMPROV^APCLV(V,"D")="" Q  ;no prim prov disc
 .I '$D(^AUPNVPOV("AD",V)) Q
 .;must have a primary dx other than .9999
 .S Y=$$PRIMPOV^APCLV(V,"C") I Y=".9999" Q
 .S BUDTIEN=$O(^BUDGCNTL("B","CLINIC EXCLUSIONS",0))
 .S C=$$CLINIC^APCLV(V,"C")
 .I C]"",$D(^BUDGCNTL(BUDTIEN,11,"B",C)) Q  ;exclude these clinics
 .Q:$P(^AUPNVSIT(V,0),U,7)="E"
 .S BUDT6V=BUDT6V+1
 .S ^TMP($J,"VISITS6DX",V)=""
 .Q
 ;now get all mamms and paps in date range and count as orphans if at this facility and no mam on that date in pcc
 Q:BUDT35V=0  ;not a patient of interest
 ;Q:'$D(^BWP(DFN))
 S T="MAMMOGRAM SCREENING",T=$O(^BWPN("B",T,0))
 S T1="MAMMOGRAM DX BILAT",T1=$O(^BWPN("B",T1,0))
 S T2="MAMMOGRAM DX UNILAT",T2=$O(^BWPN("B",T2,0))
 I $$VERSION^XPDUTL("BW")<3  D
 .S (G,V)=0 F  S V=$O(^BWPCD("C",DFN,V)) Q:V=""  D
 ..Q:'$D(^BWPCD(V,0))
 ..S D=$P(^BWPCD(V,0),U,12)
 ..S J=$P(^BWPCD(V,0),U,4) I J=T!(J=T1)!(J=T2) D  Q
 ...Q:D<BUDBD
 ...Q:D>BUDED
 ...Q:$P($G(^BWPCD(V,"PCC")),U,1)]""  ;already in pcc
 ...S L=$P(^BWPCD(V,0),U,10)
 ...Q:L=""
 ...Q:'$D(^BUDGSITE(BUDSITE,11,L))  ;not valid location
 ...S ^TMP($J,"MAMMS",V)="WH "_$$VAL^XBDIQ1(9002086.1,V,.04)_U_$$FMTE^XLFDT(D)
 .Q
 ;;E  D
 ;.S T="MAMMOGRAM SCREENING",T=$O(^BWVPDT("B",T,0))
 ;.S T1="MAMMOGRAM DX BILAT",T1=$O(^BWVPDT("B",T1,0))
 ;.S T2="MAMMOGRAM DX UNILAT",T2=$O(^BWVPDT("B",T2,0))
 ;.S D=$$FINDLSTD^BWVPRD(DFN,T_"^"_T1_"^"_T2,BUDBD,BUDED)
 ;.Q:D=0
 ;.Q:D=""
 ;.;check location here
 ;.S ^TMP($J,"MAMMS",1)="WH MAMMOGRAM "_U_$$FMTE^XLFDT(D)_U_D
 S T="PAP SMEAR",T=$O(^BWPN("B",T,0))
 I $$VERSION^XPDUTL("BW")<3  D
 .S (G,V)=0 F  S V=$O(^BWPCD("C",DFN,V)) Q:V=""  D
 ..Q:'$D(^BWPCD(V,0))
 ..S D=$P(^BWPCD(V,0),U,12)
 ..S J=$P(^BWPCD(V,0),U,4) I J=T D  Q
 ...Q:D<BUDBD
 ...Q:D>BUDED
 ...Q:$P($G(^BWPCD(V,"PCC")),U,1)]""  ;already in pcc
 ...S L=$P(^BWPCD(V,0),U,10)
 ...Q:L=""
 ...Q:'$D(^BUDGSITE(BUDSITE,11,L))  ;not valid location
 ...S ^TMP($J,"PAPS",V)="WH PAP SMEAR"_U_$$FMTE^XLFDT(D)
 .Q
 ;E  D
 ;.S T="PAP SMEAR",T=$O(^BWVPDT("B",T,0))
 ;.S D=$$FINDLSTD^BWVPRD(DFN,T,BUDBD,BUDED)
 ;.Q:D=0
 ;.Q:D=""
 ;.;check location here
 ;.S ^TMP($J,"PAPS",1)="WH PAP SMEAR "_U_$$FMTE^XLFDT(D)_U_D
 ;.S ^DIBT(4370,1,DFN)=""
 ;.Q
 Q
