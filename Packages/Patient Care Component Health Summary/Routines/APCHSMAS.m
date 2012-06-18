APCHSMAS ; IHS/CMI/LAB -- CONTINUATION OF ROUTINES ; 
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;;;
S(X) ;
 NEW %,C S (C,%)=0 F  S %=$O(APCHSTEX(%)) Q:%'=+%  S C=C+1
 S APCHSTEX(C+1)=X
 Q
W3 ;
 S APCHSTEX(1)="If this patient has asthma, consider",APCHSTEX(2)="giving this patient a flu shot,",APCHSTEX(3)="per protocol during the flu season."
 D WRITE^APCHSMU
 X APCHSURX
 Q
HMR1ST(P) ;EP - for indicator 1 is patient eligible?
 I $$PIS(P,$$FMADD^XLFDT(DT,-90)) Q 0  ;has a current perscription for inhaled steroids
 I $$LASTACLG(P,1)>1 Q 1  ;if persistent
 I $T(ATAG^BQITDUTL)]"" S X=$$ATAG^BQITDUTL(P,"Asthma") I $P(X,U),($P(X,U,2)="P"!($P(X,U,2)="A")) Q 1
 I $$NASV(P,$$FMADD^XLFDT(DT,-183))>2 Q 1  ;3 visits for asthma in past 6 months
 ;I $$NASF(P,$$FMADD^XLFDT(DT,-365))>3,$$NREL(P,$$FMADD^XLFDT(DT,-365))>0,$$BRON(P,$$FMADD^XLFDT(DT,-365))>.33 Q 1  ;at least 4 fills of any med and ratio >.33
 ;I $$NASV(P,$$FMADD^XLFDT(DT,-183))>2 Q 1  ;3 visits for asthma in past 6 months
 Q 0
HMR3ST(P) ;EP - ind 3
 I $$LASTACLG(P)>1 Q 1  ;if persistent
 I $$PIS(P,$$FMADD^XLFDT(DT,-90)) Q 1  ;is on inhaled steroids
 I $$NASV(P,$$FMADD^XLFDT(DT,183)) Q 1
 Q 0
HMR4ST(P) ;EP - ind 4
 I $T(ATAG^BQITDUTL)]"" S X=$$ATAG^BQITDUTL(P,"Asthma") I $P(X,U),($P(X,U,2)="P"!($P(X,U,2)="A")) Q 1
 I $$NASV(P,$$FMADD^XLFDT(DT,-183))>2 Q 1  ;3 visits for asthma in past 6 months
 Q 0
HMR5ST(P) ;EP
 I $$LASTACLG(P)>1 Q 1  ;if persistent
 NEW X
 I $T(ATAG^BQITDUTL)]"" S X=$$ATAG^BQITDUTL(P,"Asthma") I $P(X,U),($P(X,U,2)="P"!($P(X,U,2)="A")) Q 1
 I $$NASV(P,$$FMADD^XLFDT(DT,-183))>2 Q 1  ;3 visits for asthma in past 6 months
 Q ""
HMR6ST(P) ;EP - ind 4
 I $$LASTACLG(P)>1 Q 1  ;if any persistent
 NEW X
 I $T(ATAG^BQITDUTL)]"" S X=$$ATAG^BQITDUTL(P,"Asthma") I $P(X,U),($P(X,U,2)="P"!($P(X,U,2)="A")) Q 1
 I $$NASV(P,$$FMADD^XLFDT(DT,-183))>2 Q 1  ;3 visits for asthma in past 6 months
 Q 0
HMR2ST(P) ;EP - candidate for indicator 2?
 NEW APCHSX
 S APCHSX=$$LASTACLG(P,2)
 I $P(APCHSX,U)>1 Q 1_U_"Asthma Severity "_$P(APCHSX,U,2)  ;if persistent
 I $T(ATAG^BQITDUTL)]"" S X=$$ATAG^BQITDUTL(P,"Asthma") I $P(X,U),($P(X,U,2)="P"!($P(X,U,2)="A")) Q 1_U_"Asthma Diagnostic Tag: "_$S($P(X,U,2)="A":"Accepted",1:"Proposed")_" as of "_$$FMTE^XLFDT($P($P(X,U,3),".",1))
 S APCHSX=$$NASV(P,$$FMADD^XLFDT(DT,-183),2) I $P(APCHSX,U,1)>2 Q 1_U_"Asthma POVs on "_$$FMTE^XLFDT($P(APCHSX,U,2))_", "_$$FMTE^XLFDT($P(APCHSX,U,3))_" and "_$$FMTE^XLFDT($P(APCHSX,U,4))
 I $$LASTACON(P,1)="N"!($$LASTACON(P,1)="V") Q 1_U_"Most Recent Asthma Control "_$$LASTACON(P,6)
 S APCHSX=$$AEXAC(P,$$FMADD^XLFDT(DT,-365),2) I $P(APCHSX,U) Q 1_U_"History of Asthma Exacerbation POV: "_$P(APCHSX,U,2)
 S APCHSX=$$ASERV(P,$$FMADD^XLFDT(DT,-365),2) I $P(APCHSX,U) Q 1_U_$P(APCHSX,U,2)
 Q 0
HMR7ST(P,R) ;EP - candidate for tp uncontrolled asthma
 K R
 NEW X
 S X=$$ERPAST(P,$$FMADD^XLFDT(DT,-365))
 I $P(X,U)>1 Q X
 I $$LASTACLG(P,1)=1 S X=$$ORAL1(P,$$FMADD^XLFDT(DT,-365)) I X Q X
 I $$LASTACLG(P,1)>1 S X=$$ORAL2(P,$$FMADD^XLFDT(DT,-365)) I $P(X,U)>1 Q X
 S X=$$ERORAL(P,$$FMADD^XLFDT(DT,-365)) I X Q X
 Q ""
 ;
AS3PV(P,BD) ;EP
 NEW APCH,%,G,C,APCHD,D
 S (G,C)=0
 S %=P_"^ALL DX [BGP ASTHMA DXS;DURING "_BD_"-"_DT,E=$$START1^APCLDF(%,"APCH(")
 I '$D(APCH) Q ""
 ;reorder by date
 S (G,X)=0 F  S X=$O(APCH(X)) Q:X'=+X  S D=$P(APCH(X),U,1) S APCHD(D)=""
 S X=0 F  S X=$O(APCHD(X)) Q:X'=+X  S C=C+1
 I C>2 Q 1
 Q ""
 ;
ERPAST(P,BD) ; - 2 or more visits?
 ;return #^event 1 text^event 1 date^event 2 text^event 2 date
 NEW C,X,V,Z,APCHX,APCHD,%,E,G,P1,P2
 K APCHX,APCHD
 S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BD)_"-"_$$FMTE^XLFDT(DT),E=$$START1^APCLDF(%,"APCHX(")
 K E
 S C=0,X=0,V="" F  S X=$O(APCHX(X)) Q:X'=+X  D
 .S V=$P(APCHX(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .S G=0
 .S Z=$$CLINIC^APCLV(V,"C")
 .I Z=30!(Z=80)!($P(^AUPNVSIT(V,0),U,7)="H") S G=1
 .Q:'G
 .S Z=$$PRIMPOV^APCLV(V,"I")
 .Q:'$$ICD^ATXCHK(Z,$O(^ATXAX("B","BGP ASTHMA DXS",0)),9)
 .I '$D(E(9999999-$$VD^APCLV(V,"I"))) S C=C+1 S E((9999999-$$VD^APCLV(V,"I")))=V
 .Q
 I C<2 Q ""
 S Z="",G=0
 S Z=C
 S D=0 F  S D=$O(E(D)) Q:D'=+D!(G>1)  D
 .S G=G+1
 .S V=E(D)
 .I G=1 S P1=2
 .I G=2 S P1=3
 .S X=$S($P(^AUPNVSIT(V,0),U,7)="H":"Inpatient Admission with ",1:$$CLINIC^APCLV(V,"E")_" clinic visit with ")
 .S X=X_$$PRIMPOV^APCLV(V,"N")_" ("_$$PRIMPOV^APCLV(V,"C")_") on "_$$FMTE^XLFDT($$VD^APCLV(V,"I"))
 .S $P(Z,U,P1)=X
 .Q
 Q Z
 ;
ERORAL(P,BD) ;EP
 ;return 1^event 1 text^event 1 date^event 2 text^event 2 date
 NEW C,X,V,Z,APCHX,APCHD,%,E,G,APCHMEDS
 K APCHX,APCHD
 S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BD)_"-"_$$FMTE^XLFDT(DT),E=$$START1^APCLDF(%,"APCHX(")
 K E
 S E=""
 S C=0,X=0,V="" F  S X=$O(APCHX(X)) Q:X'=+X!(E]"")  D
 .S V=$P(APCHX(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .S G=0
 .S Z=$$CLINIC^APCLV(V,"C")
 .I Z=30!(Z=80)!($P(^AUPNVSIT(V,0),U,7)="H") S G=1
 .Q:'G
 .S Z=$$PRIMPOV^APCLV(V,"I")
 .Q:'$$ICD^ATXCHK(Z,$O(^ATXAX("B","BGP ASTHMA DXS",0)),9)
 .;NOW CHECK FOR ORAL MEDS 14 DAYS +/- VISIT DATE
 .K APCHMEDS
 .D GETMEDS^APCHSMU1(P,BD,$$FMADD^XLFDT($$VD^APCLV(V,"I"),-14),"BGP RA GLUCOCORTICOIDS",,"BGP RA GLUCOCORTICOIDS CLASS",,.APCHMEDS)
 .I '$D(APCHMEDS) Q
 .S Z=0,%="" F  S Z=$O(APCHMEDS(Z)) Q:Z'=+Z  S %=Z
 .S Y=$S($P(^AUPNVSIT(V,0),U,7)="H":"Inpatient Admission with ",1:$$CLINIC^APCLV(V,"E")_" clinic visit with ")
 .S Y=Y_$$PRIMPOV^APCLV(V,"N")_" ("_$$PRIMPOV^APCLV(V,"C")_") on "_$$FMTE^XLFDT($$VD^APCLV(V,"I"))
 .S E=1_U_Y
 .S Y="Oral Corticosteroid Therapy "_$P(APCHMEDS(%),U,2)_" on "_$$FMTE^XLFDT($P(APCHMEDS(%),U))
 .S E=E_U_Y
 Q E
 ;
AEXAC(P,BD,F) ;EP
 NEW APCH,%,G,C,APCHD,D,E
 S F=$G(F)
 I F="" S F=1
 S (G,C)=0
 S %=P_"^ALL DX [APCH ASTHMA EXACERBATION DXS;DURING "_BD_"-"_DT,E=$$START1^APCLDF(%,"APCH(")
 I '$D(APCH) Q ""
 ;A and H only
 S E=0 F  S E=$O(APCH(E)) Q:E'=+E  I "AH"'[$P(^AUPNVSIT($P(APCH(E),U,5),0),U,7) K APCH(E)
 I '$D(APCH) Q ""
 I F=1 Q 1
 S C=$O(APCH(0))
 Q 1_U_$$VAL^XBDIQ1(9000010.07,+$P(APCH(C),U,4),.04)_" on "_$$FMTE^XLFDT($P(APCH(C),U))
 ;
BRON(P,BDATE) ;
 I $G(P)="" Q
 NEW REL,TOT,Y,X,Z
 S REL=$$NREL(P,$$FMADD^XLFDT(DT,-365))
 S TOT=$$NASF(P,$$FMADD^XLFDT(DT,-365))
 S Y="" I TOT>0 S Y=(REL/(REL+TOT))
 Q Y
 ;
PIS(P,BDATE) ;EP - is patient on inhaled steriods since this date BDATE
 I '$G(P) Q ""
 NEW APCHMEDS
 K APCHMEDS
 D GETMEDS^APCHSMU1(P,BDATE,DT,"BAT ASTHMA INHALED STEROIDS","BAT ASTHMA INHLD STEROIDS NDC",,,.APCHMEDS)
 I '$D(APCHMEDS) Q 0
 Q 1
 ;
ORAL1(P,BDATE) ;EP - is patient on inhaled steriods since this date BDATE
 I '$G(P) Q ""
 NEW APCHMEDS,R,G,A,B,C,APCHX,E,%,APCHD
 K APCHMEDS
 D GETMEDS^APCHSMU1(P,BDATE,DT,"BGP RA GLUCOCORTICOIDS",,"BGP RA GLUCOCORTICOIDS CLASS",,.APCHMEDS)
 I '$D(APCHMEDS) Q ""
 S G=""
 S X=0 F  S X=$O(APCHMEDS(X)) Q:X'=+X!(G)  D
 .S D=$P(APCHMEDS(X),U,1)
 .K APCHX,APCHD
 .S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(D)_"-"_$$FMTE^XLFDT(D),E=$$START1^APCLDF(%,"APCHX(")
 .S A=0 F  S A=$O(APCHX(A)) Q:A'=+A  D
 ..S C=$$PRIMPOV^APCLV($P(APCHX(A),U,5),"I") Q:'$$ICD^ATXCHK(C,$O(^ATXAX("B","BGP ASTHMA DXS",0)),9)
 ..S G=1_U_"Oral Corticosteroid therapy "_$P(APCHMEDS(X),U,2)_" associated with "_$$PRIMPOV^APCLV($P(APCHX(A),U,5),"N")_" ("_$$PRIMPOV^APCLV($P(APCHX(A),U,5),"C")_") on "_$$FMTE^XLFDT($P(APCHMEDS(X),U))
 Q G
 ;
ORAL2(P,BDATE) ;EP - is patient on inhaled steriods since this date BDATE
 I '$G(P) Q ""
 NEW APCHMEDS,R,G,A,B,C,APCHX,E,%,APCHD
 K APCHMEDS
 D GETMEDS^APCHSMU1(P,BDATE,DT,"BGP RA GLUCOCORTICOIDS",,"BGP RA GLUCOCORTICOIDS CLASS",,.APCHMEDS)
 I '$D(APCHMEDS) Q ""
 I '$D(APCHMEDS(2)) Q ""  ;doesn't have at least 2 prescriptions
 ;reorder by date and count 1 per date
 K APCHD
 S X=0 F  S X=$O(APCHMEDS(X)) Q:X'=+X  S APCHD($P(APCHMEDS(X),U,1))=APCHMEDS(X)
 S G=0,B=1,E=""
 S D=0 F  S D=$O(APCHD(D)) Q:D'=+D  D
 .K APCHX
 .S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(D)_"-"_$$FMTE^XLFDT(D),R=$$START1^APCLDF(%,"APCHX(")
 .S A=0 F  S A=$O(APCHX(A)) Q:A'=+A  D
 ..S C=$$PRIMPOV^APCLV($P(APCHX(A),U,5),"I") Q:'$$ICD^ATXCHK(C,$O(^ATXAX("B","BGP ASTHMA DXS",0)),9)
 ..S G=G+1,B=B+1 S $P(E,U)=G,$P(E,U,B)="Oral Corticosteroid therapy "_$P(APCHD(D),U,2)_" associated with "_$$PRIMPOV^APCLV($P(APCHX(A),U,5),"N")_" ("_$$PRIMPOV^APCLV($P(APCHX(A),U,5),"C")_") on "_$$FMTE^XLFDT($P(APCHD(D),U))
 Q E
NREL(P,BDATE) ;EP - reliever?
 ;number of reliever meds between BDATE and EDATE
 NEW X,APCHX,E
 S X=P_"^ALL MEDS [BAT ASTHMA RELIEVER MEDS"_";DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(DT) S E=$$START1^APCLDF(X,"BATL(")
 I '$D(APCHX(1)) Q 0
 NEW C,X S (X,C)=0 F  S X=$O(APCHX(X)) Q:X'=+X  S C=C+1
 Q C
 ;
ASERV(P,BDATE,F) ;EP - ER ASTHMA visits since BDATE
 I '$G(P) Q 0
 S F=$G(F)
 I F="" S F=1
 NEW C,X,V,Z,APCHX,APCHD,%,E,G
 K APCHX,APCHD
 S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(DT),E=$$START1^APCLDF(%,"APCHX(")
 S C=0,X=0,V="" F  S X=$O(APCHX(X)) Q:X'=+X!(C)  D
 .S V=$P(APCHX(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .S Z=$$CLINIC^APCLV(V,"C")
 .I Z'=30,Z'=80 Q  ;urgent and er only
 .S Z=$$PRIMPOV^APCLV(V,"I")
 .Q:'$$ICD^ATXCHK(Z,$O(^ATXAX("B","BGP ASTHMA DXS",0)),9)
 .S C=1,G=V
 I 'C Q ""
 I F=1 Q C
 Q 1_U_$$PRIMPOV^APCLV(V,"N")_" at "_$$CLINIC^APCLV(V,"E")_" clinic on "_$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),"."))
 ;
NASV(P,BDATE,F) ;EP - number of asthma visits since BDATE
 ;count only A, H and any pov
 ;different dates, not visits
 I '$G(P) Q 0
 I '$G(F) S F=1
 NEW C,X,V,Z,APCHX,APCHD,Y,G
 K APCHX,APCHD
 S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(DT),E=$$START1^APCLDF(%,"APCHX(")
 S C=0,X=0,V="" F  S X=$O(APCHX(X)) Q:X'=+X  D
 .S V=$P(APCHX(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:"AH"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .S Z=$$PRIMPOV^APCLV(V,"I")
 .Q:'$$ICD^ATXCHK(Z,$O(^ATXAX("B","BGP ASTHMA DXS",0)),9)
 .S APCHD((9999999-$P($P(^AUPNVSIT(V,0),U,1),".")))=""
 S X=0 F  S X=$O(APCHD(X)) Q:X'=+X  S C=C+1
 I F=1 Q C
 NEW R
 S R=C
 S X=0,V=1 F  S X=$O(APCHD(X)) Q:X'=+X  S V=V+1,$P(R,U,V)=(9999999-X)
 Q R
NASF(P,BDATE) ;EP - number of asthma fill dates since BDATE
 I '$G(P) Q ""
 NEW APCHX,X,Y,C,E,EDATE K APCHX
 S EDATE=$$FMTE^XLFDT(DT),BDATE=$$FMTE^XLFDT(BDATE)
 S X=P_"^ALL MEDS [BAT ASTHMA RELIEVER MEDS "_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCHX(")
 S (C,X)=0 F  S X=$O(APCHX(X)) Q:X'=+X  S C=C+1
 K APCHX S X=P_"^ALL MEDS [BAT ASTHMA INHALED STEROIDS "_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCHX(")
 S (C,X)=0 F  S X=$O(APCHX(X)) Q:X'=+X  S C=C+1
 K APCHX S X=P_"^ALL MEDS [BAT ASTHMA CONTROLLER MEDS "_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCHX(")
 S (C,X)=0 F  S X=$O(APCHX(X)) Q:X'=+X  S C=C+1
 Q C
LASTAM(P,F) ;EP - return date of last asthma management plan = yes
 I '$G(P) Q ""
 I '$G(F) S F=1
 NEW D S D=$O(^AUPNVAST("AM",P,0))
 I 'D Q ""
 I F=1 Q 9999999-D
 I F=2 Q $$FMTE^XLFDT(9999999-D)
 Q ""
LASTSEV(P,F) ;EP - return last severity recorded
 ;1 - internal set of codes
 ;2 - internal date
 ;3 - external date
 ;4 - external name
 ;5 - code and external name
 NEW D,LAST,E,S
 I '$G(P) Q ""
 I '$G(F) S F=1
 S D=$O(^AUPNVAST("AS",P,0))
 I 'D Q ""
 S LAST="",E=0 F  S E=$O(^AUPNVAST("AS",P,D,E)) Q:E'=+E  S LAST=E
 I 'LAST Q ""
 S S=^AUPNVAST("AS",P,D,LAST)
 I F=1 Q S
 I F=2 Q 9999999-D
 I F=3 Q $$FMTE^XLFDT(9999999-D)
 I F=4 Q $$EXTSET^XBFUNC(9000010.41,.04,S)
 I F=5 Q S_"-"_$$EXTSET^XBFUNC(9000010.41,.04,S)
 Q ""
 ;
LASTACLG(P,F) ;EP - return last CLASSIFICATION recorded
 NEW D,LAST,E,S,X,T
 I '$G(P) Q ""
 I '$G(F) S F=1
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 I 'T Q ""
 S S=""
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .S C=$P($G(^AUPNPROB(X,0)),U)
 .Q:C=""
 .Q:'$$ICD^ATXCHK(C,T,9)  ;not asthma dx
 .Q:$P(^AUPNPROB(X,0),U,15)=""  ;no classification
 .S E=$P(^AUPNPROB(X,0),U,15)
 .I E'>$P(S,U,1) Q
 .S S=E_U_$$VAL^XBDIQ1(9000011,X,.15)
 I F=1 Q $P(S,U)
 I F=2 Q S
 ;
LASTASCL(P,F) ;EP - return last CLASSIFICATION recorded
 NEW D,LAST,E,S,X,T
 I '$G(P) Q ""
 I '$G(F) S F=1
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 I 'T Q ""
 S S=""
 K LAST
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .S C=$P($G(^AUPNPROB(X,0)),U)
 .Q:C=""
 .Q:'$$ICD^ATXCHK(C,T,9)  ;not asthma dx
 .Q:$P(^AUPNPROB(X,0),U,15)=""  ;no classification
 .S E=$P(^AUPNPROB(X,0),U,15)
 .S D=$P(^AUPNPROB(X,0),U,3)  ;date last modified
 .S LAST(D)=E_U_$$VAL^XBDIQ1(9000011,X,.15)
 S S=$O(LAST(0))
 I S="" Q ""
 I F=1 Q $P(LAST(S),U,1)
 Q $P(LAST(S),U,2)
 ;
LASTACON(P,F) ;EP - return last ASTHMA CONTROL recorded
 NEW D,LAST,E,S
 I '$G(P) Q ""
 I '$G(F) S F=1
 S D=$O(^AUPNVAST("AAC",P,0))
 I 'D Q ""
 S LAST="",E=0 F  S E=$O(^AUPNVAST("AAC",P,D,E)) Q:E'=+E  S LAST=E
 I 'LAST Q ""
 S S=^AUPNVAST("AAC",P,D,LAST)
 I F=1 Q S
 I F=2 Q 9999999-D
 I F=3 Q $$FMTE^XLFDT(9999999-D)
 I F=4 Q $$VAL^XBDIQ1(9000010.41,LAST,.14)
 I F=5 Q S_"-"_$$EXTSET^XBFUNC(9000010.41,.14,S)
 I F=6 Q $$VAL^XBDIQ1(9000010.41,LAST,.14)_" documented on "_$$FMTE^XLFDT((9999999-D))
 I F=7 Q $$FMTE^XLFDT((9999999-D))_" "_$$VAL^XBDIQ1(9000010.41,LAST,.14)
 Q ""
 ;
