BUD4RPTC ; IHS/CMI/LAB - UDS REPORT PROCESSOR ;
 ;;8.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 03, 2014;Build 36
 ;
 ;
PROC ;EP - called from xbdbque
 S BUDJ=$J,BUDH=$H
 K ^TMP($J)
 S ^XTMP("BUD4RPT1",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"UDS REPORT"
 K BUDTOT F X=1:1:39 S $P(BUDTOT("M"),U,X)=0,$P(BUDTOT("F"),U,X)=0,$P(BUDTOT("ALL"),U,X)=0  ;for table 3A
 K BUDRACET
 F X=1:1:35 S BUDTAB5(X)="0^0"
 F X="9A","9B","20A","20B","20C","29A" S BUDTAB5(X)="0^0"
 F X="1A","1B","1C",1,2,3,4,5,6,7,8 S BUDRACET(X)=0
 F X=1:1:26 S $P(BUDT6("V"),U,X)=0,$P(BUDT6("P"),U,X)=0
 S BUD019("M")="",BUD019("F")="",BUD019("ALL")=""
 S DFN=0 F  S DFN=$O(^DPT(DFN)) Q:DFN'=+DFN  D
 .K ^TMP($J)
 .Q:$P(^DPT(DFN,0),U,19)  ;merged away
 .S BUDAGE=$$AGE^AUPNPAT(DFN,BUDCAD)
 .S BUDSEX=$P(^DPT(DFN,0),U,2)
 .S BUDCOM=$$COMMRES^AUPNPAT(DFN,"E") I BUDCOM="" S BUDCOM="UNKNOWN"
 .D GETV  ;get visits that meet criteria
 .I BUDT35V=0 Q  ;user doesn't have any countable visits and is not considered a user
 .I $G(BUDT3A) D T3A
 .I $G(BUDT3B) D T3B
 .I $G(BUDT5) D T5
 .I $G(BUDT6) D T6
 .Q
 Q
 ;
T4 ;
 Q
T3A ;
 S G=0 F X=4:1:41 Q:G  D
 .S L=$P(^BUDFTTA(X,0),U,7),H=$P(^BUDFTTA(X,0),U,8),P=$P(^BUDFTTA(X,0),U,2)
 .I BUDAGE<0 S P=1 S $P(BUDTOT(BUDSEX),U,P)=$P(BUDTOT(BUDSEX),U,P)+1,$P(BUDTOT("ALL"),U,P)=$P(BUDTOT("ALL"),U,P)+1 D T S G=1 Q
 .I BUDAGE'<L,BUDAGE'>H S $P(BUDTOT(BUDSEX),U,P)=$P(BUDTOT(BUDSEX),U,P)+1,$P(BUDTOT("ALL"),U,P)=$P(BUDTOT("ALL"),U,P)+1 D T S G=1
 .Q
 I $G(BUDT3AL) S X=0 F  S X=$O(^TMP($J,"VISITS35",X)) Q:X'=+X  S ^XTMP("BUD4RPT1",BUDJ,BUDH,"3A",BUDAGE,BUDSEX,BUDCOM,DFN,X)=""
 Q
T ;
 S $P(BUDTOT(BUDSEX),U,39)=$P(BUDTOT(BUDSEX),U,39)+1,$P(BUDTOT("ALL"),U,39)=$P(BUDTOT("ALL"),U,39)+1
 I BUDAGE<20 S BUD019(BUDSEX)=BUD019(BUDSEX)+1,BUD019("ALL")=BUD019("ALL")+1
 Q
T3B ;
 S BUDR=$$RACE(DFN)
 I BUDR="" S BUDR="D"
 I $P(BUDR,U)="1A" S BUDRACET("1A")=BUDRACET("1A")+1
 I $P(BUDR,U)="1B" S BUDRACET("1B")=BUDRACET("1B")+1
 I $P(BUDR,U)=5 S BUDRACET("1C")=BUDRACET("1C")+1
 I $P(BUDR,U)="B" S BUDRACET(2)=BUDRACET(2)+1
 I $P(BUDR,U)=3 S BUDRACET(3)=BUDRACET(3)+1
 I $P(BUDR,U)="W" S BUDRACET(4)=BUDRACET(4)+1
 I $P(BUDR,U)="HSP" S BUDRACET(5)=BUDRACET(5)+1
 I $P(BUDR,U)="D" S BUDRACET(6)=BUDRACET(6)+1
 I $P(BUDR,U)="U" S BUDRACET(6)=BUDRACET(6)+1
 I $P(BUDR,U)=7 S BUDRACET(6)=BUDRACET(6)+1
 I $G(BUDT3BL),'$G(BUDT3AL) S X=0 F  S X=$O(^TMP($J,"VISITS35",X)) Q:X'=+X  S ^XTMP("BUD4RPT1",BUDJ,BUDH,"3A",BUDAGE,BUDSEX,BUDCOM,DFN,X)=""
 Q
T5 ;tally prim provider by discipline and by user
 S BUDV=0 F  S BUDV=$O(^TMP($J,"VISITS35",BUDV)) Q:BUDV'=+BUDV  D
 .S BUDP=$$PRIMPROV^APCLV(BUDV,"D")
 .I BUDP="" Q
 .;special case for DX of MH
 .;special case for provider code 15 and location CHS*
 .I $E($$VAL^XBDIQ1(9000010,BUDV,.06),1,3)="CHS",BUDP=15 S BUDT5LN=2 D T5SET Q
 .S BUDY=$O(^BUDFTFIV("C",BUDP,0)) I BUDY="" S BUDT5LN=35 D T5SET Q
 .;next lines for Bh stuff based on dx
 .S T=$O(^BUDFCNTL("B","BH DISCIPLINES FOR 20 AND 21",0))
 .I $D(^BUDFCNTL(T,11,"B",BUDP)) D  D T5SET Q
 ..S P=$$PRIMPOV^APCLV(BUDV,"C")
 ..I $E(P,1,3)=303!($E(P,1,3)="304")!($E(P,1,3)="305") S BUDT5LN=21 Q
 ..S BUDT5LN=$P(^BUDFCNTL(T,11,$O(^BUDFCNTL(T,11,"B",BUDP,0)),0),U,2) Q
 .S BUDT5LN=$P(^BUDFTFIV(BUDY,0),U)
 .D T5SET
 .Q
 Q
T5SET ;
 I BUDT5LN>0,BUDT5LN<8 D T5PHY
 I +BUDT5LN>8,+BUDT5LN<15 D T5NUR
 I BUDT5LN>15,BUDT5LN<19 D T5DENT
 I +BUDT5LN=20 D T520
 I BUDT5LN=21 D T521
 I BUDT5LN=22 D T522
 I BUDT5LN=23 D T523
 I BUDT5LN>23,BUDT5LN<29 D T5ENA
 I BUDT5LN="29A" D T529A
 I +BUDT5LN>29,BUDT5LN<33 D T5ADM
 I BUDT5LN=35 D T5OTH
 I $G(BUDT5L)!($G(BUDT5L2)) S ^XTMP("BUD4RPT1",BUDJ,BUDH,"T5",+BUDT5LN,$S(+BUDT5LN=BUDT5LN:0,1:$E(BUDT5LN,$L(BUDT5LN))),BUDCOM,BUDAGE,BUDSEX,DFN,BUDV)=$$PRIMPROV^APCLV(BUDV,"N")_"^"_$$PRIMPROV^APCLV(BUDV,"P")
 I $G(BUDT5L1) S ^XTMP("BUD4RPT1",BUDJ,BUDH,"T51",+BUDT5LN,$S(+BUDT5LN=BUDT5LN:0,1:$E(BUDT5LN,$L(BUDT5LN))),$$PRIMPROV^APCLV(BUDV,"N"))=$$PRIMPROV^APCLV(BUDV,"D")_" "_$$PRIMPROV^APCLV(BUDV,"E")
 Q
T5PHY ;set physcian enc total, set med serv enc and user totals
 S $P(BUDTAB5(BUDT5LN),U)=$P(BUDTAB5(BUDT5LN),U)+1  ;total encounters for this line
 S $P(BUDTAB5(8),U)=$P(BUDTAB5(8),U)+1  ;total phy encs line
 S $P(BUDTAB5(15),U)=$P(BUDTAB5(15),U)+1  ;total med services line
 I $D(^TMP($J,"PATIENTS","MED SERV",DFN)) Q
 S ^TMP($J,"PATIENTS","MED SERV",DFN)="",$P(BUDTAB5(15),U,2)=$P(BUDTAB5(15),U,2)+1
 Q
T5NUR ;
 S $P(BUDTAB5(BUDT5LN),U)=$P(BUDTAB5(BUDT5LN),U)+1  ;total encounters for this line
 I BUDT5LN=12 Q
 I BUDT5LN=13 Q
 I BUDT5LN=14 Q
 S $P(BUDTAB5(15),U)=$P(BUDTAB5(15),U)+1  ;total med services line
 I $D(^TMP($J,"PATIENTS","MED SERV",DFN)) Q
 S ^TMP($J,"PATIENTS","MED SERV",DFN)="",$P(BUDTAB5(15),U,2)=$P(BUDTAB5(15),U,2)+1
 Q
T5DENT ;
 S $P(BUDTAB5(BUDT5LN),U)=$P(BUDTAB5(BUDT5LN),U)+1  ;total encounters for this line
 I BUDT5LN=18 Q
 S $P(BUDTAB5(19),U)=$P(BUDTAB5(19),U)+1  ;total dental services line
 I $D(^TMP($J,"PATIENTS","DENT SERV",DFN)) Q
 S ^TMP($J,"PATIENTS","DENT SERV",DFN)="",$P(BUDTAB5(19),U,2)=$P(BUDTAB5(19),U,2)+1
 Q
T520 ;
 S $P(BUDTAB5(BUDT5LN),U)=$P(BUDTAB5(BUDT5LN),U)+1  ;total encounters for this line
 S $P(BUDTAB5(20),U)=$P(BUDTAB5(20),U)+1
 I $D(^TMP($J,"PATIENTS","20 SERV",DFN)) Q
 S ^TMP($J,"PATIENTS","20 SERV",DFN)="",$P(BUDTAB5(20),U,2)=$P(BUDTAB5(20),U,2)+1
 Q
T521 ;
 S $P(BUDTAB5(BUDT5LN),U)=$P(BUDTAB5(BUDT5LN),U)+1  ;total encounters for this line
 I $D(^TMP($J,"PATIENTS","21 SERV",DFN)) Q
 S ^TMP($J,"PATIENTS","21 SERV",DFN)="",$P(BUDTAB5(21),U,2)=$P(BUDTAB5(21),U,2)+1
 Q
T522 ;
 S $P(BUDTAB5(BUDT5LN),U)=$P(BUDTAB5(BUDT5LN),U)+1  ;total encounters for this line
 I $D(^TMP($J,"PATIENTS","22 SERV",DFN)) Q
 S ^TMP($J,"PATIENTS","22 SERV",DFN)="",$P(BUDTAB5(22),U,2)=$P(BUDTAB5(22),U,2)+1
 Q
T523 ;
 S $P(BUDTAB5(BUDT5LN),U)=$P(BUDTAB5(BUDT5LN),U)+1  ;total encounters for this line
 Q
T5ENA ;
 S $P(BUDTAB5(BUDT5LN),U)=$P(BUDTAB5(BUDT5LN),U)+1  ;total encounters for this line
 I BUDT5LN=23 Q
 I BUDT5LN=26 Q
 I BUDT5LN=27 Q
 I BUDT5LN=28 Q
 S $P(BUDTAB5(29),U)=$P(BUDTAB5(29),U)+1  ;total enabling services line
 I $D(^TMP($J,"PATIENTS","ENA SERV",DFN)) Q
 S ^TMP($J,"PATIENTS","ENA SERV",DFN)="",$P(BUDTAB5(29),U,2)=$P(BUDTAB5(29),U,2)+1
 Q
T529A ;
 S $P(BUDTAB5(BUDT5LN),U)=$P(BUDTAB5(BUDT5LN),U)+1  ;total encounters for this line
 Q
T5ADM ;
 S $P(BUDTAB5(BUDT5LN),U)=$P(BUDTAB5(BUDT5LN),U)+1  ;total encounters for this line
 S $P(BUDTAB5(33),U)=$P(BUDTAB5(33),U)+1  ;total adm services line
 I $D(^TMP($J,"PATIENTS","ADM SERV",DFN)) Q
 S ^TMP($J,"PATIENTS","ADM SERV",DFN)="",$P(BUDTAB5(33),U,2)=$P(BUDTAB5(33),U,2)+1
 Q
T5OTH ;
 S $P(BUDTAB5(BUDT5LN),U)=$P(BUDTAB5(BUDT5LN),U)+1
 Q
 ;
T6 ;
 D T6^BUD4RPC1
 Q
RACE(DFN) ;EP
 I $G(DFN)="" Q ""
 I $$BEN^AUPNPAT(DFN,"C")="01" Q "3^AI/AN"
 NEW X S X=$P(^DPT(DFN,0),U,6)
 S G="" I X S Y=$P(^DIC(10,X,0),U,1),X=$P(^DIC(10,X,0),U,2) D  I G]"" Q G    ;PATCH 1 FIXED
 .I X="A" S G="1A^ASIAN" Q
 .I X="H" S G="1B^NH" Q
 .I X=5 S G="5^AS/PI" Q
 .I X=4!(X="B") S G="B^BL" Q
 .I X=3 S G="3^AI/AN" Q
 .I X=6!(X="W") S G="W^WH" Q
 .I X=1 S G="HSP^HSP/W" Q
 .I X=2 S G="HSP^HSP/B" Q
 .I X="D" S G="D^DECL" Q
 .I X="7" S G="7^UNK" Q
 .I X="U" S G="U^UNK" Q
 Q "U^UNK"
GETV ;get all visits for this patient and tally in BUDTV
 ;^TMP($J,"VISITSLIST") has all visits, including orphans that will be needed for either table
 ;3, 5 or 6 dx or 6 services
 ;^TMP($J,"VISITS35") has all visits to count for tables 3,5 which excludes 2 visits to the same provider
 ;on the same day
 ;^TMP($J,"VISITSLIST") is used for table 6 services only
 ;^TMP($J,"VISITS35") is used for table 3 and 5
 ;^TMP($J,"VISITS6DX") is used for table 6 dxs and includes 2 visits on same day to same provider
 K ^TMP($J)
 S BUDTV=0,BUDT35V=0,BUDT6V=0
 S A="^TMP($J,""VISITS"",",B=DFN_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BUDBD)_"-"_$$FMTE^XLFDT(BUDED),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"VISITS",1)) Q
 S X=0 F  S X=$O(^TMP($J,"VISITS",X)) Q:X'=+X  S V=$P(^TMP($J,"VISITS",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .S L=$P(^AUPNVSIT(V,0),U,6)
 .Q:L=""
 .Q:'$D(^BUDFSITE(BUDSITE,11,L))  ;not valid location
 .Q:$P(^AUPNVSIT(V,0),U,7)="C"
 .Q:$P(^AUPNVSIT(V,0),U,7)="T"
 .Q:$P(^AUPNVSIT(V,0),U,7)="N"
 .Q:$P(^AUPNVSIT(V,0),U,7)="D"
 .Q:$P(^AUPNVSIT(V,0),U,7)="X"
 .S C=$$CLINIC^APCLV(V,"C")
 .S BUDTIEN=$O(^BUDFCNTL("B","FIRST LEVEL CLINIC EXCLUSIONS",0))
 .I C]"",$D(^BUDFCNTL(BUDTIEN,11,"B",C)) Q  ;not a clinic code we want in any table
 .S BUDTV=BUDTV+1
 .S ^TMP($J,"VISITSLIST",V)=""
 ;now set up ^TMP($J,"VISITS35")
 ;loop through all visits and eliminate all from clinics, and eliminate orphans
 S V=0 F  S V=$O(^TMP($J,"VISITSLIST",V)) Q:V'=+V  D
 .I '$D(^AUPNVPRV("AD",V)) Q
 .I $$PRIMPROV^APCLV(V,"D")="" Q  ;no prim prov disc
 .I '$D(^AUPNVPOV("AD",V)) Q
 .;must have a primary dx other than .9999
 .S Y=$$PRIMPOV^APCLV(V,"C") I Y=".9999" Q
 .S BUDTIEN=$O(^BUDFCNTL("B","CLINIC EXCLUSIONS",0))
 .S C=$$CLINIC^APCLV(V,"C")
 .I C]"",$D(^BUDFCNTL(BUDTIEN,11,"B",C)) Q  ;exclude these clinics
 .I $D(^TMP($J,"SAMEPROV",$$PRIMPROV^APCLV(V,"I"),$P($P(^AUPNVSIT(V,0),U),"."))) Q  ;already got one on this day, this provider
 .S ^TMP($J,"SAMEPROV",$$PRIMPROV^APCLV(V,"I"),$P($P(^AUPNVSIT(V,0),U),"."))=""
 .S BUDT35V=BUDT35V+1
 .S ^TMP($J,"VISITS35",V)=""
 ;NOW get all for table 6 dxs, same list but include duplicates
 S V=0 F  S V=$O(^TMP($J,"VISITSLIST",V)) Q:V'=+V  D
 .I '$D(^AUPNVPRV("AD",V)) Q
 .I $$PRIMPROV^APCLV(V,"D")="" Q  ;no prim prov disc
 .I '$D(^AUPNVPOV("AD",V)) Q
 .;must have a primary dx other than .9999
 .S Y=$$PRIMPOV^APCLV(V,"C") I Y=".9999" Q
 .S BUDTIEN=$O(^BUDFCNTL("B","CLINIC EXCLUSIONS",0))
 .S C=$$CLINIC^APCLV(V,"C")
 .I C]"",$D(^BUDFCNTL(BUDTIEN,11,"B",C)) Q  ;exclude these clinics
 .S BUDT6V=BUDT6V+1
 .S ^TMP($J,"VISITS6DX",V)=""
 .Q
 ;now get all mamms and paps in date range and count as orphans if at this facility and no mam on that date in pcc
 Q:BUDT35V=0  ;not a patient of interest
 Q:'$D(^BWP(DFN))
 S T="MAMMOGRAM SCREENING",T=$O(^BWPN("B",T,0))
 S T1="MAMMOGRAM DX BILAT",T1=$O(^BWPN("B",T1,0))
 S T2="MAMMOGRAM DX UNILAT",T2=$O(^BWPN("B",T2,0))
 S (G,V)=0 F  S V=$O(^BWPCD("C",DFN,V)) Q:V=""  D
 .Q:'$D(^BWPCD(V,0))
 .S D=$P(^BWPCD(V,0),U,12)
 .S J=$P(^BWPCD(V,0),U,4) I J=T!(J=T1)!(J=T2) D  Q
 ..Q:D<BUDBD
 ..Q:D>BUDED
 ..Q:$P($G(^BWPCD(V,"PCC")),U,1)]""  ;already in pcc
 ..S L=$P(^BWPCD(V,0),U,10)
 ..Q:L=""
 ..Q:'$D(^BUDFSITE(BUDSITE,11,L))  ;not valid location
 ..S ^TMP($J,"MAMMS",V)="WH "_$$VAL^XBDIQ1(9002086.1,V,.04)_U_$$FMTE^XLFDT(D)
 .Q
 S T="PAP SMEAR",T=$O(^BWPN("B",T,0))
 S (G,V)=0 F  S V=$O(^BWPCD("C",DFN,V)) Q:V=""  D
 .Q:'$D(^BWPCD(V,0))
 .S D=$P(^BWPCD(V,0),U,12)
 .S J=$P(^BWPCD(V,0),U,4) I J=T D  Q
 ..Q:D<BUDBD
 ..Q:D>BUDED
 ..Q:$P($G(^BWPCD(V,"PCC")),U,1)]""  ;already in pcc
 ..S L=$P(^BWPCD(V,0),U,10)
 ..Q:L=""
 ..Q:'$D(^BUDFSITE(BUDSITE,11,L))  ;not valid location
 ..S ^TMP($J,"PAPS",V)="WH PAP SMEAR"_U_$$FMTE^XLFDT(D)
 .Q
 Q
