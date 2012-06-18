BDWUTIL1 ; IHS/CMI/LAB - Data Warehouse Utilities ;
 ;;1.0;IHS DATA WAREHOUSE;**1,2**;JAN 23, 2006
 ;
 ;
 ;
ORF(P) ;EP patient has ORF?
 I '$G(P) Q 0
 NEW FLAG,D
 S FLAG=0
 ;
 S D=0
 F  S D=$O(^AUPNPAT(P,41,D)) Q:+D=0  D
 . Q:$P($G(^AGFAC(D,0)),"^",21)'="Y"   ;only want ORFs
 . S FLAG=1  ;found one
 . Q
 Q FLAG
CHART(V) ;PEP - returns ASUFAC_HRN ( 12 digits, HRN is left zero filled)
 ;V = visit ien, returns asufac_hrn for this visit
 NEW L,%,C,S,P,Z
 S %=""
 I '$D(^AUPNVSIT(V,0)) Q %  ;bogus visit
 S Z=^AUPNVSIT(V,0)
 S P=$P(Z,U,5) ;get patient pointer
 I 'P Q %  ;no patient so quit
 S L=$P(Z,U,6) ;location of encounter of visit
 I 'L Q ""  ;if no loc then quit, shouldn't happen
 I $D(^AUPNPAT(P,41,L,0)) S %=$$GETCHART(P,L) I %]"" Q %  ;get hrn at loc of enc if have one use it
 S L=$P($G(^AUTTSITE(1,0)),U) S %=$$GETCHART(P,L) I %]"" Q %  ;get hrn at rpms site, if have one use it
 I $G(DUZ(2)) S L=DUZ(2) S %=$$GETCHART(P,L) I %]"" Q %  ;get hrn at logged in site, if have one use it
 S L=0 F  S L=$O(^AUPNPAT(P,41,L)) Q:L'=+L!(%]"")  S %=$$GETCHART(P,L) ;get first one in multiple that is an official reg fac
 Q %
GETCHART(P,L) ;
 NEW R,S
 S R=""
 I $P($G(^AGFAC(L,0)),U,21)'="Y" Q ""  ;not an official reg fac so quit, must be an orf
 S S=$P(^AUTTLOC(L,0),U,10) ;get asufac for this location
 I S="" Q ""
 S C=$P($G(^AUPNPAT(P,41,L,0)),U,2) ;get hrn for this location
 I C="" Q ""
 S R=S_C ;return asufac_hrn
 Q R
 ;
CHARTREG(P) ;EP
 I '$G(P) Q ""
 I '$D(^AUPNPAT(P)) Q ""
 NEW L,%,C,S
 S %=""
 S L=$P($G(^AUTTSITE(1,0)),U) S %=$$GETCHART(P,L) I %]"" Q %  ;get hrn at rpms site, if have one use it
 I $G(DUZ(2)) S L=DUZ(2) S %=$$GETCHART(P,L) I %]"" Q %  ;get hrn at logged in site, if have one use it
 S L=0 F  S L=$O(^AUPNPAT(P,41,L)) Q:L'=+L!(%]"")  S %=$$GETCHART(P,L) ;get first one in multiple that is an official reg fac
 Q %
HDL(V) ;
 Q $$LABDONE^BDWUTIL(V,"DM AUDIT HDL TAX")
HDLVALUE(V) ;
 Q $$LABRES^BDWUTIL(V,"DM AUDIT HDL TAX")
 ;
LDL(V) ;
 Q $$LABDONE^BDWUTIL(V,"DM AUDIT LDL CHOLESTEROL TAX")
 ;
LDLVALUE(V) ;
 Q $$LABRES^BDWUTIL(V,"DM AUDIT LDL CHOLESTEROL TAX")
 ;
TRI(V) ;
 Q $$LABDONE^BDWUTIL(V,"DM AUDIT TRIGLYCERIDE TAX")
 ;
TRIVALUE(V) ;
 Q $$LABRES^BDWUTIL(V,"DM AUDIT TRIGLYCERIDE TAX")
 ;
PSA(V) ;
 Q $$LABDONE^BDWUTIL(V,"BDW PSA TESTS TAX")
 ;
FECAL(V) ;
 Q $$LABDONE^BDWUTIL(V,"APCH FECAL OCCULT BLOOD")
 ;
NLAB(V) ;
 NEW X,Y
 S (X,Y)=0 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X  S Y=Y+1
 Q Y
CHSPO(V) ;EP return vendor type from VCHS
 I '$G(V) Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 NEW C S C=$O(^AUPNVCHS("AD",V,0))
 I 'C Q ""
 I '$D(^AUPNVCHS(C,0)) Q ""
 NEW A
 S A=$P(^AUPNVCHS(C,0),U)
 S A=$P($G(^AUTTLOC(A,0)),U,10)
 Q $P(^AUPNVCHS(C,0),U,4)_"^"_A
ST(RETVAL,BDWV) ;EP - 
 K RETVAL
 I '$G(BDWV) Q
 I '$D(^AUPNVSIT(BDWV)) Q
 NEW BDWI,BDWC,BDWE
 S (BDWI,BDWC)=0
 F  S BDWI=$O(^AUPNVSK("AD",BDWV,BDWI)) Q:BDWI'=+BDWI  D
 .Q:'$D(^AUPNVSK(BDWI,0))
 .S BDWE=$P(^AUPNVSK(BDWI,0),"^")
 .I '$D(^AUTTSK(BDWE,0)) Q
 .S BDWE=$P(^AUTTSK(BDWE,0),"^",2)
 .S BDWC=BDWC+1,RETVAL(BDWC)=BDWE_"^"_$P(^AUPNVSK(BDWI,0),"^",4)_"^"_$P(^AUPNVSK(BDWI,0),"^",5)
 .Q
 Q
 ;
PROV(RETVAL,BDWV) ;EP
 NEW BDWP,BDWS,BDWC,BDWPIEN,BDWCS,BDWAD,X,Y,G,D
 K RETVAL
 I '$D(^AUPNVPRV("AD",BDWV)) Q
 S BDWP="",BDWCS=1
 F  S BDWP=$O(^AUPNVPRV("AD",BDWV,BDWP)) Q:BDWP'=+BDWP  D
 .Q:'$D(^AUPNVPRV(BDWP,0))
 .I $P(^AUPNVPRV(BDWP,0),"^",4)="P" S BDWC=1
 .I $P(^AUPNVPRV(BDWP,0),"^",4)'="P" S BDWCS=BDWCS+1,BDWC=BDWCS
 .S BDWPIEN=$P(^AUPNVPRV(BDWP,0),"^")
 .S BDWAD=$$O(BDWPIEN)
 .S RETVAL(BDWC)=$P(^AUPNVPRV(BDWP,0),"^")_"^"_$S($P(^DD(9000010.06,.01,0),"^",2)[200:200,1:6)_"^"_BDWAD_"^"_$$C(BDWPIEN)_"^"_$S($E(BDWAD,2,3)=17:1,1:"")
 .;6th is classification
 .;7th is specialty
 .;8th is type
 .S Y=BDWPIEN ;ien in file 200 should be in Y
 .I $P(^DD(9000010.06,.01,0),U,2)[6 S Y=$G(^DIC(16,BDWPIEN,"A3"))
 .I Y="" Q
 .;get USC1 node value
 .S D=$P(^AUPNVPRV(BDWP,0),"^",3) Q:D=""
 .S D=$P($G(^AUPNVSIT(D,0)),"^"),D=$P(D,".",1)
 .I D="" Q
 .S G=$$PCC(Y,D)
 .S $P(RETVAL(BDWC),"^",6)=G
 .Q
 Q
PCC(P,D) ;EP - RETURN CLASS^SPEC^TYPE for provider P on date D
 I $G(P)="" Q ""
 I $G(D)="" Q ""
 I '$D(^VA(200,P,0)) Q ""
 I '$O(^VA(200,P,"USC1",0)) Q ""
 NEW X,Y,Z
 S (X,Z)=0 F  S X=$O(^VA(200,P,"USC1",X)) Q:X'=+X!(Z)  D
 .S Y=$G(^VA(200,P,"USC1",0))
 .I $P(Y,U,2)]"",$P(Y,U,3)]"",D'<$P(Y,U,2),D'>$P(Y,U,3) S Z=X Q  ;both dates and a match
 .I $P(Y,U,2)]"",$P(Y,U,3)="",D'<$P(Y,U,2) S Z=X Q  ;beg date, no expire visit after beg
 .Q
 I 'Z S Z=$O(^VA(200,P,"USC1",0))
 S Z=$P(^VA(200,P,"USC1",Z,0),U)
 I 'Z Q ""
 I '$D(^USC(8932.1,Z,0)) Q ""
 S Z=$P(^USC(8932.1,Z,0),U,7)
 Q $E(Z,3,4)_"^"_$E(Z,5,9)_"^"_$E(Z,1,2)
PROC(RETVAL,BDWV) ;EP
 NEW BDWP,BDWC
 S (BDWP,BDWC)=0 F  S BDWP=$O(^AUPNVPRC("AD",BDWV,BDWP)) Q:BDWP'=+BDWP  D
 .S BDWC=BDWC+1
 .S RETVAL(BDWC)=$$VAL^XBDIQ1(9000010.08,BDWP,.01)_"^"_$P(^AUPNVPRC(BDWP,0),"^",6)_"^"_$P(^AUPNVPRC(BDWP,0),"^",8)_"^"_$$O($P(^AUPNVPRC(BDWP,0),"^",11))_"^"_$$X(BDWP)_"^"_$$VAL^XBDIQ1(9000010.08,BDWP,.16)
 .S Y=$P(^AUPNVPRC(BDWP,0),"^",11) ;ien in file 200 should be in Y
 .Q:'Y
 .I $P(^DD(9000010.08,.11,0),U,2)[6 S Y=$G(^DIC(16,$P(^AUPNVPRC(BDWP,0),"^",11),"A3"))
 .I Y="" Q
 .;get USC1 node value
 .S D=$P(^AUPNVPRC(BDWP,0),"^",3) Q:BDWP=""
 .S D=$P($G(^AUPNVSIT(D,0)),"^"),D=$P(D,".",1)
 .I D="" Q
 .S G=$$PCC(Y,D)
 .S $P(RETVAL(BDWC),"^",7)=G
 .Q
 .Q
 Q
IMM(RETVAL,BDWV) ;EP
 I '$D(^AUPNVSIT(BDWV)) Q
 NEW BDWI,BDWC
 K RETVAL S BDWC=0
 S BDWI=0 F  S BDWI=$O(^AUPNVIMM("AD",BDWV,BDWI)) Q:BDWI'=+BDWI  S BDWC=BDWC+1 D
 .S I=$P($G(^AUPNVIMM(BDWI,0)),"^")
 .Q:'I
 .Q:'$D(^AUTTIMM(I,0))
 .S $P(RETVAL(BDWC),"^",4)=$P(^AUTTIMM(I,0),"^",$S($$BI:20,1:3)) ;IHS OLD CODE
 .S $P(RETVAL(BDWC),"^",3)=$S('$$BI:"",1:$P(^AUTTIMM(I,0),"^",3))
 .S $P(RETVAL(BDWC),"^",5)=$P(^AUPNVIMM(BDWI,0),"^",4)
 Q
BI() ;IHS/CMI/LAB - new subroutine patch 4 1/5/1999
 Q $S($O(^AUTTIMM(0))<100:0,1:1)
 ;
C(P) ;EP
 NEW %
 S %=$S($P(^DD(9000010.06,.01,0),"^",2)[200:$P($G(^VA(200,P,9999999)),"^",2),1:$P($G(^DIC(6,P,9999999)),"^",2))
 Q %
A ;EP
 S %=$S($P(^DD(9000010.06,.01,0),"^",2)[200:$P($G(^VA(200,P,9999999)),"^"),1:$P($G(^DIC(6,P,9999999)),"^")) Q
 Q
F ;EP
 S %=$$VALI^XBDIQ1($S($P(^DD(9000010.06,.01,0),"^",2)[200:200,1:6),P,$S($P(^DD(9000010.06,.01,0),"^",2)[200:53.5,1:2))
 Q
D ;EP
 D F
 Q:%=""
 S %=$P($G(^DIC(7,%,9999999)),"^")
 Q
 ;
X(Z) ; ;diagnosis done for
 NEW % S %=""
 NEW M S M=$P(^AUPNVPRC(Z,0),"^",5)
 NEW V S V=$P(^AUPNVPRC(Z,0),"^",3)
 S I=$$PRIMPOV^APCLV(V,"I") I M=I S %=1 Q %
 F I=1:1:25 Q:%   S J=$$SECPOV^APCLV(V,"I",I) I J]"",J=M S %=I+1
 Q %
O(P) ;EP
 I $G(P)="" Q ""
 NEW A,%
 D A
 I %="" Q ""
 S A=%,%=""
 D D
 I %="" Q ""
 S %=A_%
 Q %
 ;
MCD(BDWV) ;EP
 NEW P,%
 S P=$P(^AUPNVSIT(BDWV,0),"^",5)
 I 'P Q ""
 S %=$$MCD^AUPNPAT(DFN,$P($P(^AUPNVSIT(BDWV,0),"^"),".")) S %=$S(%=1:"Y",%=0:"N",1:"")
 Q %
MCR(BDWV) ;
 NEW P,%
 S P=$P(^AUPNVSIT(BDWV,0),"^",5)
 I 'P Q ""
 S %=$$MCR^AUPNPAT(DFN,$P($P(^AUPNVSIT(BDWV,0),"^"),".")) S %=$S(%=1:"Y",%=0:"N",1:"")
 Q %
 ;
PI(BDWV) ;EP
 NEW P,%
 S P=$P(^AUPNVSIT(BDWV,0),"^",5)
 I 'P Q ""
 S %=$$PI^AUPNPAT(DFN,$P($P(^AUPNVSIT(BDWV,0),"^"),".")) S %=$S(%=1:"Y",%=0:"N",1:"")
 Q %
HTN(BDWV,F) ;EP - is htn documented for this patient ever?  Y or N retured
 NEW R,X,E,BDWG,P
 S P=$P(^AUPNVSIT(BDWV,0),"^",5)
 I 'P Q ""
 S R=""
 I '$D(^DPT(P)) Q R
 I $P(^DPT(P,0),"^",19) Q R
 I '$D(^AUPNVPOV("AC",P)) Q R  ;no povs on file
 NEW X,E S X=P_"^LAST DX [SURVEILLANCE HYPERTENSION" S E=$$START1^APCLDF(X,"BDWG(")
 I $D(BDWG(1)) Q $S(F="Y":"Y",1:$P(BDWG(1),"^"))
 Q $S(F="Y":"N",1:"")
 ;
MED(RETVAL,BDWV) ;EP
 K RETVAL
 I $P($G(^BDWSITE(1,11)),U,1) Q
 I '$G(BDWV) Q
 I '$D(^AUPNVSIT(BDWV)) Q
 NEW BDWI,BDWC,BDWD,BDWQ,BDWNDC,BDWCLS
 S (BDWI,BDWC)=0 F  S BDWI=$O(^AUPNVMED("AD",BDWV,BDWI)) Q:BDWI'=+BDWI  D
 .Q:'$D(^AUPNVMED(BDWI,0))  ;cmi/anch/maw 9/11/2007 patch 2
 .S BDWD=$P(^AUPNVMED(BDWI,0),"^") Q:'$D(^PSDRUG(BDWD,0))
 .S BDWC=BDWC+1
 .S BDWQ=$P(^AUPNVMED(BDWI,0),"^",6)
 .S BDWNDC=$P($G(^PSDRUG($P(^AUPNVMED(BDWI,0),"^"),2)),"^",4)
 .S BDWCLS=$P(^PSDRUG($P(^AUPNVMED(BDWI,0),"^"),0),"^",2)
 .S RETVAL(BDWC)=$P(^PSDRUG(BDWD,0),"^")_"^"_BDWQ_"^"_BDWNDC_"^"_BDWCLS
 .Q
 Q
PAP(V) ;EP - was pap performed Y/N
 I '$G(V) Q ""
 I $P($G(^BDWSITE(1,11)),U,1) Q ""
 NEW T S T=$O(^ATXLAB("B","BDW PAP SMEAR LAB TESTS",0))
 I 'T Q ""
 NEW X,Y,Z S Y="N",X=0 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X!(Y="Y")  S Z=$P(^AUPNVLAB(X,0),U) I $D(^ATXLAB(T,21,"B",Z)) S Y="Y"
 Q Y
GLUCOSE(V) ;EP - return glucose test value on this visit
 I '$G(V) Q ""
 I $P($G(^BDWSITE(1,11)),U,1) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT GLUCOSE TESTS TAX",0))
 I 'T Q ""
 NEW X,Y,Z S Y="",X=0 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X!(Y]"")  S Z=$P(^AUPNVLAB(X,0),U) I $D(^ATXLAB(T,21,"B",Z)) S Y=$P(^AUPNVLAB(X,0),U,4)
 Q Y
HGBA1C(V) ;EP - called to return value of HGBA1C if done on this visit
 ;V is visit ien
 NEW R
 S R=""
 I '$D(^AUPNVSIT(V)) Q R
 I '$D(^AUPNVLAB("AD",V)) Q R  ;no v labs to check
 I '$D(^ATXLAB("B","DM AUDIT HGB A1C TAX")) Q R
 NEW Y S Y=$O(^ATXLAB("B","DM AUDIT HGB A1C TAX",0))
 I 'Y Q R  ;no taxonomy to look at
 NEW X,Z
 S X=0 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X  S Z=$P(^AUPNVLAB(X,0),U) I Z,$D(^ATXLAB(Y,21,"B",Z)) S R=$P(^AUPNVLAB(X,0),U,4)
 Q R
 ;
ACE(V) ;EP - ace inhibitor filled this visit
 ;V is visit ien
 I '$D(^AUPNVSIT(V)) Q ""
 I '$D(^AUPNVMED("AD",V)) Q "N"  ;no v meds to check
 NEW Y S Y=$O(^ATXAX("B","DM AUDIT ACE INHIBITORS",0))
 I 'Y Q ""
 NEW X,Z,R
 S R=""
 S X=0 F  S X=$O(^AUPNVMED("AD",V,X)) Q:X'=+X  S Z=$P(^AUPNVMED(X,0),U) I $D(^ATXAX(Y,21,"B",Z)) S R=1
 Q $S($G(R):"Y",1:"N")
 ;
MC(RETVAL,BDWV) ;EP
 ;medical condition, at this time health factors only
 K RETVAL
 I $P($G(^BDWSITE(1,11)),U,1) Q
 I '$G(BDWV) Q
 I '$D(^AUPNVSIT(BDWV)) Q
 NEW BDWI,BDWH,BDWC
 S (BDWC,BDWI)=0
 F  S BDWI=$O(^AUPNVHF("AD",BDWV,BDWI)) Q:BDWI'=+BDWI  D
 .S BDWH=$P($G(^AUPNVHF(BDWI,0)),"^")
 .Q:BDWH=""
 .Q:'$D(^AUTTHF(BDWH,0))
 .S BDWC=BDWC+1
 .S RETVAL(BDWC)="HF"_"^"_$P(^AUTTHF(BDWH,0),"^")_"^"_$P(^AUTTHF(BDWH,0),"^",2)_"^"_$$VAL^XBDIQ1(9999999.64,BDWH,.03)_"^"_$S($P(^AUTTHF(BDWH,0),"^",3)]"":$P(^AUTTHF($P(^AUTTHF(BDWH,0),"^",3),0),"^",2),1:"")
 .Q
 Q
