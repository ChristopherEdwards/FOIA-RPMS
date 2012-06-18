BCHEXD21 ; IHS/TUCSON/LAB - new export format [ 08/14/02  12:49 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**10,12,14**;OCT 28, 1996
 ;IHS/CMI/LAB - added $J to ^TMP
 ;
 ;
 K BCH("POVS")
 D REC1
 D REC2
 K BCHREC,BCHY,BCHP,BCHPOV,X,BCHREC11,BCHREC12,BCHREC13,BCHREC21
 Q
 ;
REC1 ;
 S BCHREC=^BCHR(BCHR,0),BCHREC11=$G(^BCHR(BCHR,11)),BCHREC12=$G(^BCHR(BCHR,12)),BCHREC13=$G(^BCHR(BCHR,13)),BCHREC21=$G(^BCHR(BCHR,21))
 F BCHY=1:1:50 S X="" D @BCHY S $P(BCHTX,U,BCHY)=X
 Q
REC2 ;pov records
 S BCHP=0,C=0 F  S BCHP=$O(^BCHRPROB("AD",BCHR,BCHP)) Q:BCHP'=+BCHP  S BCHPOV=^BCHRPROB(BCHP,0),C=C+1 D
 .S BCH("POVS",C)=2_U_$P(^AUTTLOC(DUZ(2),0),U,10)_$$LZERO^BCHEXD2(BCHR,10)
 .S N=$P(BCHPOV,U,6) I N,$D(^AUTNPOV(N,0)) S N=$P(^AUTNPOV(N,0),U)
 .I N="" S N="NO NARRATIVE"
 .S BCH("POVS",C)=BCH("POVS",C)_U_$P(^BCHTPROB($P(BCHPOV,U),0),U,2)_U_$P(^BCHTSERV($P(BCHPOV,U,4),0),U,3)_U_$P(BCHPOV,U,5)_U_N_U_$P(BCHPOV,U,7)
 ;
 Q
1 ;record code
 S X=1
 Q
2 ;
 S X=$$UID(BCHR)_$$LZERO^BCHEXD2(BCHR,10)
 ;S X=$P(^AUTTLOC(DUZ(2),0),U,10)_$$LZERO^BCHEXD2(BCHR,10)
 Q
3 ;date of service
 S X=$$DATE($P($P(BCHREC,U),"."))
 Q
4 ;CHR Program
 I $P(BCHREC,U,2)="" S BCHE="E003" Q
 S X=$P(^BCHTPROG($P(BCHREC,U,2),0),U,5)
 Q
5 ;Chr provider name
 I $P(BCHREC,U,3)="" S BCHE="E002" Q
 S X=$P(^VA(200,$P(BCHREC,U,3),0),U)
 Q
6 ;chr provider code
 I $P(BCHREC,U,3)="" S BCHE="E022" Q
 S X=$P($G(^VA(200,$P(BCHREC,U,3),9999999)),U,9) Q
7 ;activity location
 I $P(BCHREC,U,6)="" S BCHE="E004" Q
 S X=$P(BCHREC,U,6),X=$S(X]"":$P(^BCHTACTL(X,0),U,5),1:"-") S:X="-" X="-" S:X="" X="-" S:X="--" X="-" Q
 Q
8 ;location facility
 I $P(BCHREC,U,5)]"" S X=$P(^AUTTLOC($P(BCHREC,U,5),0),U,10) Q
 Q
9 ;referred to CHR by
 I $P(BCHREC,U,7)]"" S X=$P(^BCHTREF($P(BCHREC,U,7),0),U,3) Q
 Q
10 ;referred by CHR to
 I $P(BCHREC,U,8)]"" S X=$P(^BCHTREF($P(BCHREC,U,8),0),U,3) Q
 Q
11 ;travel time
 S X=$P(BCHREC,U,11) Q
12 ;number served
 S X=$P(BCHREC,U,12) Q
13 ;LMP
 S X=$$DATE($P(BCHREC,U,13)) Q
14 ;FMP
 I $P(BCHREC,U,14)]"" S X=$P(^BCHTFPM($P(BCHREC,U,14),0),U,2) Q
 Q
15 ;who entered record
 I $P(BCHREC,U,16)]"" S X=$P(^VA(200,$P(BCHREC,U,16),0),U) Q
 Q
16 ;date last updated
 S X=$$DATE($P(BCHREC,U,17)) Q
17 ;posting date
 S X=$$DATE($P(BCHREC,U,22)) Q
18 ;system of origin
 S X=$P(BCHREC,U,26) Q
19 ;total service time
 S X=$P(BCHREC,U,27) Q
20 ;temp res
 S X=$P(BCHREC11,U,8) Q
21 ;blood pressure
 S X=$P(BCHREC12,U) Q
22 ;weight
 S X=$P(BCHREC12,U,2) Q
23 ;height
 S X=$P(BCHREC12,U,3) Q
24 ;head
 S X=$P(BCHREC12,U,4) Q
25 ;vision corrected
 S X=$P(BCHREC12,U,6) Q
26 ;vision uncorrected
 S X=$P(BCHREC12,U,5) Q
27 ;tmp
 S X=$P(BCHREC12,U,7) Q
28 ;PULSE
 S X=$P(BCHREC12,U,8) Q
29 ;RESP
 S X=$P(BCHREC12,U,9) Q
30 ;PPD
 S X=$P(BCHREC12,U,10) Q
31 ;BS
 S X=$$DATE($P(BCHREC13,U,1)) Q
32 ;BS
 S X=$P(BCHREC13,U,2) Q
33 ;
 S X=$$DATE($P(BCHREC13,U,3)) Q
34 ;TC
 S X=$P(BCHREC13,U,4) Q
35 ;
 S X=$$DATE($P(BCHREC13,U,5)) Q
36 ;UA
 S X=$P(BCHREC13,U,6) Q
37 ;
 S X=$$DATE($P(BCHREC13,U,7)) Q
38 ;
 S X=$P(BCHREC13,U,8) Q
39 ;
 S X=$P(BCHREC21,U) Q
40 ;
 S X=$P(BCHREC21,U,2) Q
41 ;
 S X=$P(BCHREC11,U) Q
42 ;
 S X=$P(BCHREC11,U,3) Q
43 ;
 S X=$$DATE($P(BCHREC11,U,2)) Q
44 ;
 S X=$P(BCHREC11,U,4) Q
45 ;tribe
 I $P(BCHREC11,U,5)]"" S X=$P(^AUTTTRI($P(BCHREC11,U,5),0),U,2) Q
 Q
46 ;community
 I $P(BCHREC11,U,6)]"" S X=$P(^AUTTCOM($P(BCHREC11,U,6),0),U,8) Q
 Q
47 ;evaluation
 S X=$P(BCHREC,U,9) Q
48 ;
 I $P(BCHREC11,U,9)]"",$P(BCHREC11,U,11)]"" S X=$P(^AUTTLOC($P(BCHREC11,U,9),0),U,10)_$$LZERO^BCHEXD2($P(BCHREC11,U,11),6) Q
49 ;unique id 1
 S X=$P($G(^BCHR(BCHR,14)),U)
 Q
50 ;unique id2
 S X=$P($G(^BCHR(BCHR,14)),U,2)
 Q
DATE(X) ;EP
 I X="" Q ""
 Q $E(X,4,5)_$E(X,6,7)_(1700+($E(X,1,3)))
UID(REC) ;EP - generate unique ID for record
 I '$G(REC) Q REC
 NEW X
 ;I '$P($G(^AUTTSITE(1,1)),"^",3) S $P(^AUTTSITE(1,1),"^",3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),"^",1),0),"^",10)
 ;Q $P(^AUTTSITE(1,1),"^",3)
 Q $P($G(^AUTTLOC(DUZ(2),0)),U,10)
