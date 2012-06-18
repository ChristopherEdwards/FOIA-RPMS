APCLVLU1 ; IHS/CMI/LAB - GEN RETR UTILITIES ;
 ;;2.0;IHS PCC SUITE;**2,4,5,7**;MAY 14, 2009
 ;
MCR ;MCR display all current medicare data
 NEW APCLMIFN
 I '$D(^DPT(P,0)) G MCRX
 I $P(^DPT(P,0),U,19) G MCRX
 I '$D(^AUPNPAT(P,0)) G MCRX
 I '$D(^AUPNMCR(P,11)) G MCRX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G MCRX
 S APCLMIFN=0 F  S APCLMIFN=$O(^AUPNMCR(P,11,APCLMIFN)) Q:APCLMIFN'=+APCLMIFN  D
 .Q:$P(^AUPNMCR(P,11,APCLMIFN,0),U)>D
 .I $P(^AUPNMCR(P,11,APCLMIFN,0),U,2)]"",$P(^(0),U,2)<D Q
 .S APCLPCNT=APCLPCNT+1,APCLPRNM(APCLPCNT)=$P(^AUPNMCR(DFN,0),U,3)_" ["_$S($P(^(0),U,4)]"":$P(^AUTTMCS($P(^(0),U,4),0),U),1:"-")_"]"
 .S APCLPCNT=APCLPCNT+1,Y=$P(^AUPNMCR(DFN,11,APCLMIFN,0),U),Z=$P(^(0),U,2),APCLPRNM(APCLPCNT)=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3)_"-" I Z]"" S APCLPRNM(APCLPCNT)=APCLPRNM(APCLPCNT)_$E(Z,4,5)_"/"_$E(Z,6,7)_"/"_$E(Z,2,3)
 .Q
MCRX ;
 K Y,Z
 Q
 ;
MCD ;EP
 NEW APCLMIFN,APCLNIFN
 I '$D(^DPT(P,0)) G MCDX
 I $P(^DPT(P,0),U,19) G MCDX
 I '$D(^AUPNPAT(P,0)) G MCDX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G MCDX
 S APCLMIFN=0 F  S APCLMIFN=$O(^AUPNMCD("B",P,APCLMIFN)) Q:APCLMIFN'=+APCLMIFN  D
 .Q:'$D(^AUPNMCD(APCLMIFN,11))
 .S APCLNIFN=0 F  S APCLNIFN=$O(^AUPNMCD(APCLMIFN,11,APCLNIFN)) Q:APCLNIFN'=+APCLNIFN  D
 ..Q:APCLNIFN>D
 ..I $P(^AUPNMCD(APCLMIFN,11,APCLNIFN,0),U,2)]"",$P(^(0),U,2)<D Q
 ..S APCLPCNT=APCLPCNT+1,APCLPRNM(APCLPCNT)=$P(^AUPNMCD(APCLMIFN,0),U,3)_"/"_$S($P(^AUPNMCD(APCLMIFN,0),U,2)]"":$P(^AUTNINS($P(^AUPNMCD(APCLMIFN,0),U,2),0),U),1:"<>")
 ..S APCLPCNT=APCLPCNT+1,Y=$P(^AUPNMCD(APCLMIFN,11,APCLNIFN,0),U),Z=$P(^(0),U,2),APCLPRNM(APCLPCNT)=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3)_"-" I Z]"" S APCLPRNM(APCLPCNT)=APCLPRNM(APCLPCNT)_$E(Z,4,5)_"/"_$E(Z,6,7)_"/"_$E(Z,2,3)
 ..Q
 .Q
 ;
MCDX ;
 Q
 ;
PI ;EP
 NEW APCLMIFN,APCLFLG
 I '$D(^DPT(P,0)) G PIX
 I $P(^DPT(P,0),U,19) G PIX
 I '$D(^AUPNPAT(P,0)) G PIX
 I '$D(^AUPNPRVT(P,11)) G PIX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G PIX
 S APCLMIFN=0 F  S APCLMIFN=$O(^AUPNPRVT(P,11,APCLMIFN)) Q:APCLMIFN'=+APCLMIFN  D
 .Q:$P(^AUPNPRVT(P,11,APCLMIFN,0),U)=""
 .S APCLNAME=$P(^AUPNPRVT(DFN,11,APCLMIFN,0),U) Q:APCLNAME=""
 .Q:$P(^AUTNINS(APCLNAME,0),U)["AHCCCS"
 .Q:$P(^AUPNPRVT(P,11,APCLMIFN,0),U,6)>D
 .I $P(^AUPNPRVT(P,11,APCLMIFN,0),U,7)]"",$P(^(0),U,7)<D Q
 .S APCLPCNT=APCLPCNT+1,APCLPRNM(APCLPCNT)=$P(^AUTNINS($P(^AUPNPRVT(P,11,APCLMIFN,0),U),0),U)
 .S APCLPCNT=APCLPCNT+1,Y=$P(^AUPNPRVT(DFN,11,APCLMIFN,0),U,6),Z=$P(^(0),U,7),APCLPRNM(APCLPCNT)=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3)_"-" I Z]"" S APCLPRNM(APCLPCNT)=APCLPRNM(APCLPCNT)_$E(Z,4,5)_"/"_$E(Z,6,7)_"/"_$E(Z,2,3)
 .Q
PIX ;
 Q
PIV ;EP
 NEW APCLMIFN,APCLFLG
 I '$D(^DPT(P,0)) G PIX
 I $P(^DPT(P,0),U,19) G PIX
 I '$D(^AUPNPAT(P,0)) G PIX
 I '$D(^AUPNPRVT(P,11)) G PIX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G PIX
 S APCLMIFN=0 F  S APCLMIFN=$O(^AUPNPRVT(P,11,APCLMIFN)) Q:APCLMIFN'=+APCLMIFN  D
 .Q:$P(^AUPNPRVT(P,11,APCLMIFN,0),U)=""
 .S APCLNAME=$P(^AUPNPRVT(DFN,11,APCLMIFN,0),U) Q:APCLNAME=""
 .Q:$P(^AUTNINS(APCLNAME,0),U)["AHCCCS"
 .Q:$P(^AUPNPRVT(P,11,APCLMIFN,0),U,6)>D
 .I $P(^AUPNPRVT(P,11,APCLMIFN,0),U,7)]"",$P(^(0),U,7)<D Q
 .S APCLPRNT=$P(^AUPNPRVT(P,11,APCLMIFN,0),U,9) I APCLPRNT]"" S APCLPRNT=$$FMTE^XLFDT(APCLPRNT,"2D")
 .Q
PIVX ;
 Q
 ;
ML ;EP - set up mailing address print array
 S APCLPCNT=0 K APCLPRNM
 F X=1:1:3 S Y=$P($G(^DPT(DFN,.11)),U,X) I Y]"" S APCLPCNT=APCLPCNT+1,APCLPRNM(APCLPCNT)=Y
 S X=$P($G(^DPT(DFN,.11)),U,4)_", "
 S Y="",Y=$P($G(^DPT(DFN,.11)),U,5) I Y S Y=$P(^DIC(5,Y,0),U)
 S X=X_$S(Y]"":Y,1:"  ")
 S X=X_" "_$P($G(^DPT(DFN,.11)),U,6)
 S APCLPCNT=APCLPCNT+1,APCLPRNM(APCLPCNT)=X
 Q
 ;
BILLNUM(V) ;EP - given visit ien (V), return bill # 
 ;from ABMDBILL
 I '$G(V) Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 NEW D,X,B
 S (D,X)=0,B="" F  S D=$O(^ABMDBILL(D)) Q:D'=+D  D
 .S X=0 F  S X=$O(^ABMDBILL(D,"AV",V,X)) Q:X'=+X  S B=$P(^ABMDBILL(D,X,0),"^")
 .Q
 Q B
 ;
PSCLS ;EP
 S A=0 F  S A=$O(^AUPNVPRV("AD",APCLVIEN,A)) Q:A'=+A  S P=$P(^AUPNVPRV(A,0),U),Z=$S($P(^DD(9000010.06,.01,0),U,2)[200:$$PROVCLS^XBFUNC1(P),1:$P(^DIC(7,$P(^DIC(6,P,0),U,4),0),U)) D
 .S APCLPCNT=APCLPCNT+1,APCLPRNM(APCLPCNT)=Z
 .S APCLPRNM(APCLPCNT,"I")=$S($P(^DD(9000010.06,.01,0),U,2)[200:$P($G(^VA(200,P,"PS")),U,5),1:$P(^DIC(6,P,0),U,4))
 .Q
 Q
PSAFFL ;
 S A=0 F  S A=$O(^AUPNVPRV("AD",APCLVIEN,A)) Q:A'=+A  S P=$P(^AUPNVPRV(A,0),U),Z=$S($P(^DD(9000010.06,.01,0),U,2)[200:$$PROVAFFL^XBFUNC1(P),1:$P($G(^DIC(6,P,9999999)),U)) D
 .S APCLPCNT=APCLPCNT+1,APCLPRNM(APCLPCNT)=Z
 .S APCLPRNM(APCLPCNT,"I")=$S($P(^DD(9000010.06,.01,0),U,2)[200:$P($G(^VA(200,P,9999999)),U,1),1:$P($G(^DIC(6,P,9999999)),U))
 .Q
 Q
EDPD ;EP
 N AY,P S AY=0 F  S AY=$O(^AUPNVPED("AD",APCLVIEN,AY)) Q:AY'=+AY  S P=$P(^AUPNVPED(AY,0),U,5) I P D
 .S Z=$S($P(^DD(9000010.16,.05,0),U,2)[200:$$PROVCLS^XBFUNC1(P),1:$P(^DIC(7,$P(^DIC(6,P,0),U,4),0),U)) S APCLPCNT=APCLPCNT+1,APCLPRNM(APCLPCNT)=Z
 .S APCLPRNM(APCLPCNT,"I")=$S($P(^DD(9000010.16,.05,0),U,2)[200:$P($G(^VA(200,P,"PS")),U,5),1:$P($G(^DIC(6,P,0)),U,4))
 Q
LABLOINC ;
 NEW A,B,C,D,J
 K X
 S A=0
 S APCLSPEC=""
 F  S A=$O(^AUPNVLAB("AD",APCLVIEN,A)) Q:A'=+A!$D(X)  D
 .S B=$P($G(^AUPNVLAB(A,0)),U)
 .Q:'B
 .Q:'$D(^LAB(60,B,0))
 .I $D(APCLLABT("LAB",B)) S X(1)=1,X=1 Q
 .S J=$P($G(^AUPNVLAB(B,11)),U,13) Q:J=""
 .Q:'$$LOINC(J)
 .S X(1)=1,X=1
 .Q
 Q
LOINC(Q) ;EP - is loinc code Q in apcllabt
 NEW %
 S %=$P($G(^LAB(95.3,Q,9999999)),U,2)
 I %]"",$D(APCLLABT("LOINC",%)) Q 1
 S %=$P($G(^LAB(95.3,Q,0)),U)_"-"_$P($G(^LAB(95.3,Q,0)),U,15)
 I $D(APCLLABT("LOINC",%)) Q 1
 Q ""
WC(R) ;EP - return waist circumference on this visit
 NEW %,M,V
 S %=0,V="" F  S %=$O(^AUPNVMSR("AD",R,%)) Q:%'=+%  D
 .Q:'$D(^AUPNVMSR(%,0))
 .Q:$P($G(^AUPNVMSR(%,2)),U,1)
 .S M=$P(^AUPNVMSR(%,0),U)
 .I M="" Q
 .S M=$P($G(^AUTTMSR(M,0)),U)
 .Q:M'="WC"
 .S V=$P(^AUPNVMSR(%,0),U,4)
 .Q
 Q V
PBMIG(P) ;EP - calculate BMI for VGEN/PGEN
 NEW %,H,W,D
 S %=$$PBMI^APCLV(P,DT)
 I $P(%,U)="" Q ""
 I $P(%,U,8)["WARNING" Q ""  ;ht or wt is too old
 S H=$P(%,U,3)
 S W=$P(%,U,6)
 S D=H
 I W>H S D=W
 S B=$P(%,U,1),B=$J(B,6,2),B=$$STRIP^XLFSTR(B," ")
 Q B_" as of "_$E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
FAMHXTL ;EP - called from pgen translation logic
 K R
 S Y=$O(^APCLVRPT(APCLRPT,11,APCLI,11,0)) S Z=$P($P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U),"-"),R=$P($P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U),"-",2)
 W !,"Family History diagnoses including ",$S(Z:$P(^ICD9(Z,0),U),1:"ANY DIAGNOSIS")," for the following relationships: "
 I R="" W "ANY relationship." S X="",APCLQ=1 Q
 S X=0 F  S X=$O(^APCLVRPT(APCLRPT,11,APCLI,11,X)) Q:X'=+X  S R($P($P(^APCLVRPT(APCLRPT,11,APCLI,11,X,0),U),"-",2))=""
 S X=0 F  S X=$O(R(X)) Q:X'=+X  W $P(^AUTTRLSH(X,0),U),"; "
 K R
 S X="",APCLQ=""
 Q
FAMHX ;EP - called from pgen item
 ;find all family history items that match diagnosis and relationship
 ;if 1st diagnosis is blank then select ANY diagnosis that follows null
 NEW D,R,I,G,S,Z,Y
 K X
 S X=""
 S Y=0,G="" F  S Y=$O(^AUPNFH("AC",DFN,Y)) Q:Y'=+Y!(G)  D
 .S I=$P(^AUPNFH(Y,0),U,1)
 .S R=$P(^AUPNFH(Y,0),U,9)
 .Q:R=""
 .S R=$P(^AUPNFHR(R,0),U,1)
 .;do you want this diagnosis?  if so set D=1
 .S D=0,S=0,Z=0 F  S Z=$O(^APCLVRPT(APCLRPT,11,APCLI,11,Z)) Q:Z'=+Z!(G)  D
 ..I $P($P(^APCLVRPT(APCLRPT,11,APCLI,11,Z,0),U),"-")="" S D=1
 ..I $P($P(^APCLVRPT(APCLRPT,11,APCLI,11,Z,0),U),"-")=I S D=1
 ..I $P($P(^APCLVRPT(APCLRPT,11,APCLI,11,Z,0),U),"-",2)=R S S=1
 ..I $P($P(^APCLVRPT(APCLRPT,11,APCLI,11,Z,0),U),"-",2)="" S S=1
 ..I D,S S G=1
 I G S X=1,X(1)=""
 Q
APPTS ;EP - called from pgen item
 ;find all appts for this patient that match, if have at least 1 then use the patient
 NEW D,R,I,G,S,Z,Y,B,E,C,N,P
 K C
 S G=0
 S Y=$O(^APCLVRPT(APCLRPT,11,APCLI,11,0))
 S B=$P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U),E=$P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U,2),C=$P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U,3,99999)
 F R=1:1 S Y=$P(C,U,R) Q:Y=""  S C(Y)=""
 S S=$$FMADD^XLFDT(B,-1)_".9999" F  S S=$O(^DPT(DFN,"S",S)) Q:'S!(G)!($P(S,".")>E)  D
 .S N=^DPT(DFN,"S",S,0)
 .Q:"CP"[$E($P(N,U,2)_" ")
 .Q:$P(N,U,7)=4  ;skip unscheduled
 .S P=+N
 .I $O(C(0)),'$D(C(P)) Q  ;not a clinic of interest
 .S G=1
 I G S X=1,X(1)=""
 Q
 ;
APPTPRT ;EP - called from pgen item
 ;find all pending (non walkin, non chart request) appts for this patient
 NEW D,R,I,G,S,Z,Y,B,E,C,N,P
 S S=$$FMADD^XLFDT(DT,-1)_".9999" F  S S=$O(^DPT(DFN,"S",S)) Q:'S  D
 .S N=^DPT(DFN,"S",S,0)
 .Q:"CP"[$E($P(N,U,2)_" ")
 .Q:$P(N,U,7)=4  ;skip unscheduled
 .S A="am"
 .S T=$E($P(S,".",2)_"000",1,4) S:T>1159 A="pm" S:T>1300 T=T-1200 S:$L(T)=3 T=" "_T S:$E(T)="0" T=" "_$E(T,2,4) S T=$E(T,1,2)_":"_$E(T,3,4)
 .S D=$$DATE($P(S,".",1))_" "_T_A
 .S C=$P(^SC($P(N,U),0),U)
 .S APCLPCNT=APCLPCNT+1
 .S APCLPRNM(APCLPCNT)=D_" in "_C
 Q
 ;
DATE(D) ;EP
 I $G(D)="" Q "-"
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
 ;
APPTTL ;EP - called from pgen translation logic for appointments
 NEW R,B,E,C,Y,Z
 S (R,B,E,C,Y,Z)=""
 S Y=$O(^APCLVRPT(APCLRPT,11,APCLI,11,0))
 S B=$P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U),E=$P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U,2),C=$P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U,3,99999)
 W " Date range: ",$$FMTE^XLFDT(B)," - ",$$FMTE^XLFDT(E)," for:"
 I C="" W !?15,"ANY (All) Appointment Clinics" S X="" Q
 F R=1:1 S Y=$P(C,U,R) Q:Y=""  S Z=$P(^SC(44,Y,0),U,1)_";"
 W !?5,Z
 S X=""
 Q
PLDOOTL ;EP - called from pgen translation logic for PL DOO
 NEW R,B,E,C,Y,Z
 S (R,B,E,C,Y,Z)=""
 S Y=$O(^APCLVRPT(APCLRPT,11,APCLI,11,0))
 S B=$P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U),E=$P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U,2)
 W " Date range: ",$$FMTE^XLFDT(B)," - ",$$FMTE^XLFDT(E)
 I '$D(APCLPDOO) W !?15,"for ANY (All) Diagnoses" S X="" Q
 W !?15,"for a set of diagnoses including: "
 S R=$O(APCLPDOO(R))
 W $P(^ICD9(R,0),U)
 S X=""
 Q
PLDOOPRT ;EP - called from pgen item
 NEW A,B,C,D,E
 S (A,B,C,D,E)=""
 S A=0 F  S A=$O(^AUPNPROB("AC",DFN,A)) Q:A'=+A  D
 .Q:$P(^AUPNPROB(A,0),U,12)="D"
 .S D=$$DATE($P(^AUPNPROB(A,0),U,13))
 .I $D(APCLPDOO),'$D(APCLPDOO($P(^AUPNPROB(A,0),U,1))) Q
 .S E=$$VAL^XBDIQ1(9000011,A,.01)
 .S C="",C=D,$E(C,11)=" dx: "_E
 .S APCLPCNT=APCLPCNT+1
 .S APCLPRNM(APCLPCNT)=C
 .Q
 Q
PLDOOS ;EP - called from pgen item
 ;find all DOO for this patient that match, if have at least 1 then use the patient
 NEW D,R,I,G,S,Z,Y,B,E,C,N,P
 K C
 S G=0
 S Y=$O(^APCLVRPT(APCLRPT,11,APCLI,11,0))
 S B=$P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U),E=$P(^APCLVRPT(APCLRPT,11,APCLI,11,Y,0),U,2)
 S S=0 F  S S=$O(^AUPNPROB("AC",DFN,S)) Q:'S!(G)  D
 .Q:'$D(^AUPNPROB(S,0))
 .Q:$P(^AUPNPROB(S,0),U,12)="D"
 .S D=$P($G(^AUPNPROB(S,0)),U,13)
 .Q:D=""
 .I $D(APCLPDOO),'$D(APCLPDOO($P(^AUPNPROB(S,0),U))) Q  ;not a DX of interest
 .Q:D<B
 .Q:D>E
 .S G=1
 I G S X=1,X(1)=""
 Q
 ;
ADMPROV(V,F) ;EP - called from vgen
 I '$G(V) Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 I $P(^AUPNVSIT(V,0),U,7)'="H" Q ""
 S F=$G(F)
 I F="" S F="I"
 NEW A,M,X
 S A=$O(^DGPM("AVISIT",V,0))
 I A="" Q ""
 S M=0,X="" F  S M=$O(^DGPM("CA",A,M)) Q:M'=+M!(X)  D
 .Q:$P(^DGPM(M,0),U,2)'=6
 .S X=$P($G(^DGPM(M,"IHS")),U,2)
 .Q
 Q $S(X="":"",F="I":X,1:$P(^VA(200,X,0),U))
IMMREGS(P,D,F) ;EP - called to get imm reg status on date D
 I '$G(P) Q ""
 I '$G(D) S D=DT
 I '$D(^BIP(P,0)) Q ""  ;not on imm reg
 S F=$G(F)
 I F="" S F="I"
 NEW S
 S S=$P(^BIP(P,0),"^",8)
 I S="" Q $S(F="I":"A",1:"ACTIVE")
 I S>D Q $S(F="I":"A",1:"ACTIVE")
 Q $S(F="I":"I",1:"INACTIVE")
VAUDITOR(V,F) ;EP - returns the last person who marked the visit as reviewed/complete
 ;if visit is not reviewed/complete returns a null
 I $G(V)=""
 S F=$G(F)
 I F="" S F="I"
 I '$D(^AUPNVSIT(V,0)) Q ""
 I $P(^AUPNVSIT(V,0),U,11) Q ""  ;deleted
 I $P($G(^AUPNVSIT(V,11)),U,11)'="R" Q ""  ;visit was not reviewed/audited
 NEW X,Y,A,L
 K Y
 S A=""
 S X=0 F  S X=$O(^AUPNVCA("AD",V,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVCA(X,0))
 .Q:$P(^AUPNVCA(X,0),U,4)'="R"
 .S Y($P(^AUPNVCA(X,0),U,1))=X
 I '$D(Y) Q ""
 ;get last one
 S X=0 F  S X=$O(Y(X)) Q:X'=+X  S L=Y(X)
 S Y=$P(^AUPNVCA(L,0),U,5)
 I F="I" Q Y
 I F="E" Q $P(^VA(200,Y,0),U)
