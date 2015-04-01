APCLSIL4 ; IHS/CMI/LAB - ILI surveillance export ; 
 ;;3.0;IHS PCC REPORTS;**28,29**;FEB 05, 1997;Build 35
 ;
HASPVAC(V) ;EP - get flu iz
 NEW C,X,Y,Z,T
 S T=$O(^ATXAX("B","SURVEILLANCE PCV CVX CODES",0))
 S C=0,X=0 F  S X=$O(^AUPNVIMM("AD",V,X)) Q:X'=+X  S Y=$P($G(^AUPNVIMM(X,0)),U) D
 .Q:'Y
 .Q:'$D(^AUTTIMM(Y,0))
 .S Z=$P(^AUTTIMM(Y,0),U,3)
 .Q:'$D(^ATXAX(T,21,"B",Z))
 .;get lot and manufacturer added in patch 27
 .S C=1_U_Z_U_$$VAL^XBDIQ1(9000010.11,X,.05) I $P(^AUPNVIMM(X,0),U,5),$D(^AUTTIML($P(^AUPNVIMM(X,0),U,5),0)) S C=C_U_$$VAL^XBDIQ1(9999999.41,$P(^AUPNVIMM(X,0),U,5),.02)
 .S Z=$$VALI^XBDIQ1(9000010.11,X,1201)
 .S $P(C,U,5)=$S(Z:$P(Z,".",1),1:$$VD^APCLV(V))
 .Q
 Q C
 ;
PCVFEB(APCLV,D) ;EP
 NEW X,P,Y,Z,T,G,C,APCL,E,S,V
 S G=""
 S P=$P(^AUPNVSIT(APCLV,0),U,5)
 ;S D=$$VD^APCLV(APCLV)
 S E=$$FMADD^XLFDT(D,7)
 ;get all visits from D to D+7
 D ALLV^APCLAPIU(P,D,E,"APCL")
 I '$D(APCL) Q ""
 ;now get rid of non 30/80, non-H visits, and those whose primary dx is not FEBRILE SEIZURE
 S X=0 F  S X=$O(APCL(X)) Q:X'=+X!(G]"")  D
 .S V=$P(APCL(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=0
 .I "AORSHI"'[$P(^AUPNVSIT(V,0),U,7) Q  ;no chart reviews or Telephone calls
 .I $P(^AUPNVSIT(V,0),U,7)="H" S Z=1  ;h
 .I $P(^AUPNVSIT(V,0),U,7)="I" S Z=1
 .I $$CLINIC^APCLV(V,"C")=30 S Z=1
 .I $$CLINIC^APCLV(V,"C")=80 S Z=1
 .Q:'Z  ;not an H or 30/80
 .;does it have a febrile seizure dx?
 .S T=$O(^ATXAX("B","SURVEILLANCE FEBRILE SEIZURE",0))
 .Q:'T
 .S Z="",Y=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(Z]"")  D
 ..S Q=$P($G(^AUPNVPOV(Y,0)),U)
 ..Q:Q=""
 ..Q:'$$ICD^ATXCHK(Q,T,9)  ;not in taxonomy
 ..S Z=$$VAL^XBDIQ1(9000010.07,Y,.01)  ;code
 ..Q
 .I Z="" Q  ;NO SEIZURE
 .;IF HAD SEIZURE IS THERE A EPILEPSY ON THE SAME DAY, IF SO QUIT
 .S S=$$LASTDXT^APCLAPIU(P,$$VD^APCLV(X),$$VD^APCLV(X),"SURVEILLANCE EPILEPSY","A ")
 .I S Q  ;had epilepsy on this day also
 .S G=Z_","_$$VD^APCLV(V)  ;code and date of febrile seizure
 Q G
PCVECPEH(APCLV,D) ;EP
 NEW X,P,Y,Z,T,G,C,APCL,E,S,V,CLNTAX,APCLCLIN,APCLX
 S G=""
 S P=$P(^AUPNVSIT(APCLV,0),U,5)
 ;S D=$$VD^APCLV(APCLV),D=$$FMADD^XLFDT(D,1)
 S E=$$FMADD^XLFDT(D,28)
 ;get all visits from D to D+28
 D ALLV^APCLAPIU(P,D,E,"APCL")
 I '$D(APCL) Q ""
 ;S CLNTAX=$O(^ATXAX("B","SURVEILLANCE ILI CLINICS",0))
 ;now get rid of non ILI CLINIC VISITS OR PHN
 S APCLX=0 F  S APCLX=$O(APCL(APCLX)) Q:APCLX'=+APCLX!(G]"")  D
 .S V=$P(APCL(APCLX),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .I "AORSHI"'[$P(^AUPNVSIT(V,0),U,7) Q
 .;S APCLCLIN=$$CLINIC^APCLV(V,"I")  ;get clinic code
 .;is there a PHN
 .;S X=0,S=0 F  S X=$O(^AUPNVPRV("AD",APCLV,X)) Q:X'=+X!(P)  D
 .;.Q:'$D(^AUPNVPRV(X,0))
 .;.S Y=$P(^AUPNVPRV(X,0),U)
 .;.S Z=$$VALI^XBDIQ1(200,Y,53.5)
 .;.Q:'Z
 .;.I $P($G(^DIC(7,Z,9999999)),U,1)=13 S S=1
 .;I S G PCVE
 .;I $P(^AUPNVSIT(V,0),U,7)'="H" I APCLCLIN="" Q ""
 .;I $P(^AUPNVSIT(V,0),U,7)'="H" I '$D(^ATXAX(CLNTAX,21,"B",APCLCLIN)) Q ""  ;not in clinic taxonomy
PCVE .;
 .;does it have a ENCEPHALOPATHY dx?
 .S T=$O(^ATXAX("B","SURVEILLANCE ENCEPHALOPATHY",0))
 .Q:'T
 .S Z="",Y=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(Z]"")  D
 ..S Q=$P($G(^AUPNVPOV(Y,0)),U)
 ..Q:Q=""
 ..Q:'$$ICD^ATXCHK(Q,T,9)  ;not in taxonomy
 ..S Z=$$VAL^XBDIQ1(9000010.07,Y,.01)  ;code
 ..Q
 .I Z="" Q  ;NO enceph
 .S G=Z_","_$$VD^APCLV(V)  ;code and date of febrile seizure
 Q G
PCVANGIO(APCLV,D) ;EP
 NEW X,P,Y,Z,T,G,C,APCL,E,S,V,CLNTAX,APCLCLIN,APCLX
 S G=""
 S P=$P(^AUPNVSIT(APCLV,0),U,5)
 ;S D=$$VD^APCLV(APCLV)
 S E=$$FMADD^XLFDT(D,7)
 ;get all visits from D to D+7
 D ALLV^APCLAPIU(P,D,E,"APCL")
 I '$D(APCL) Q ""
 ;S CLNTAX=$O(^ATXAX("B","SURVEILLANCE ILI CLINICS",0))
 ;now get rid of non ILI CLINIC VISITS OR PHN
 S APCLX=0 F  S APCLX=$O(APCL(APCLX)) Q:APCLX'=+APCLX!(G]"")  D
 .S V=$P(APCL(APCLX),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .I "AORSH"'[$P(^AUPNVSIT(V,0),U,7) Q
 .;S APCLCLIN=$$CLINIC^APCLV(V,"I")  ;get clinic code
 .;is there a PHN
 .;S X=0,S=0 F  S X=$O(^AUPNVPRV("AD",APCLV,X)) Q:X'=+X!(P)  D
 .;.Q:'$D(^AUPNVPRV(X,0))
 .;.S Y=$P(^AUPNVPRV(X,0),U)
 .;.S Z=$$VALI^XBDIQ1(200,Y,53.5)
 .;.Q:'Z
 .;.I $P($G(^DIC(7,Z,9999999)),U,1)=13 S S=1
 .;I S G PCVE
 .;I $P(^AUPNVSIT(V,0),U,7)'="H" I APCLCLIN="" Q ""
 .;I $P(^AUPNVSIT(V,0),U,7)'="H" I '$D(^ATXAX(CLNTAX,21,"B",APCLCLIN)) Q ""  ;not in clinic taxonomy
ANGIO1 .;
 .;does it have a ANGIO dx?
 .S T=$O(^ATXAX("B","SURVEILLANCE ANGIOEDEMA",0))
 .Q:'T
 .S Z="",Y=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(Z]"")  D
 ..S Q=$P($G(^AUPNVPOV(Y,0)),U)
 ..Q:Q=""
 ..Q:'$$ICD^ATXCHK(Q,T,9)  ;not in taxonomy
 ..S Z=$$VAL^XBDIQ1(9000010.07,Y,.01)  ;code
 ..Q
 .I Z="" Q  ;NO ANGIO
 .S G=Z_","_$$VD^APCLV(V)  ;code and date of ANGIOEDEMA
 Q G
PCVASTH(APCLV,D) ;EP
 NEW X,P,Y,Z,T,G,C,APCL,E,S,V
 S G=""
 S P=$P(^AUPNVSIT(APCLV,0),U,5)
 ;S D=$$VD^APCLV(APCLV)
 S E=$$FMADD^XLFDT(D,7)
 ;get all visits from D to D+7
 D ALLV^APCLAPIU(P,D,E,"APCL")
 I '$D(APCL) Q ""
 ;now get rid of non 30/80, non-H visits, and those whose primary dx is not ASTHMA
 S X=0 F  S X=$O(APCL(X)) Q:X'=+X!(G]"")  D
 .S V=$P(APCL(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=0
 .I "AORSHI"'[$P(^AUPNVSIT(V,0),U,7) Q  ;no chart reviews or Telephone calls or events
 .I $P(^AUPNVSIT(V,0),U,7)="H" S Z=1  ;h
 .I $$CLINIC^APCLV(V,"C")=30 S Z=1
 .I $$CLINIC^APCLV(V,"C")=80 S Z=1
 .Q:'Z  ;not an H or 30/80
 .;does it have an asthma dx?
 .S T=$O(^ATXAX("B","SURVEILLANCE ADV EVENTS ASTHMA",0))
 .Q:'T
 .S Z="",Y=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(Z]"")  D
 ..S Q=$P($G(^AUPNVPOV(Y,0)),U)
 ..Q:Q=""
 ..Q:'$$ICD^ATXCHK(Q,T,9)  ;not in taxonomy
 ..S Z=$$VAL^XBDIQ1(9000010.07,Y,.01)  ;code
 ..Q
 .I Z="" Q  ;NO ASTHMA
 .S G=Z_","_$$VD^APCLV(V)  ;code and date of ASTHMA
 Q G
PCVIMMUN(APCLV,D) ;EP
 NEW X,P,Y,Z,T,G,C,APCL,E,S,V
 S G=""
 S P=$P(^AUPNVSIT(APCLV,0),U,5)
 ;S D=$$VD^APCLV(APCLV)
 S E=$$FMADD^XLFDT(D,7)
 ;get all visits from D to D+7
 D ALLV^APCLAPIU(P,D,E,"APCL")
 I '$D(APCL) Q ""
 S X=0 F  S X=$O(APCL(X)) Q:X'=+X!(G]"")  D
 .S V=$P(APCL(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .I "AORSH"'[$P(^AUPNVSIT(V,0),U,7) Q  ;no chart reviews or Telephone calls
 .;does it have a IMMUNIOLOGICAL dx?
 .S T=$O(^ATXAX("B","SURVEILLANCE IMMUNOLOGICAL",0))
 .Q:'T
 .S Z="",Y=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(Z]"")  D
 ..S Q=$P($G(^AUPNVPOV(Y,0)),U)
 ..Q:Q=""
 ..Q:'$$ICD^ATXCHK(Q,T,9)  ;not in taxonomy
 ..S Z=$$VAL^XBDIQ1(9000010.07,Y,.01)  ;code
 ..Q
 .I Z="" Q  ;NO IMMUNO
 .S G=Z_","_$$VD^APCLV(V)  ;code and date of IMMUNIOLOGICAL
 Q G
SET ;EP
 ;create entry with start date of DT
 S APCLET=$H
 N APCLFDA,APCLIENS,APCLERR
 S APCLIENS="+2,"_1_","
 S APCLFDA(9001003.312,APCLIENS,.01)=DT
 ;is this a test system?
 NEW TST,F
 S TST=0
 I '$$PROD^XUPROD() S TST=1
 I $P($G(^APCLILIC(1,0)),U,5)="T" S TST=1
 S F=$S(TST:"FLZ",$G(APCLFLF):"FLF",1:"FLU")_"_"_APCLASU_"_"_$$DATE^APCLSILI(DT)_".txt"
 S APCLFDA(9001003.312,APCLIENS,.02)=F
 S APCLFDA(9001003.312,APCLIENS,.05)=$S(XBFLG:0,1:1)
 S APCLFDA(9001003.312,APCLIENS,.04)=APCLVTOT
 S APCLFDA(9001003.312,APCLIENS,.06)=$$HTFM^XLFDT(APCLBT)
 S APCLFDA(9001003.312,APCLIENS,.07)=$$HTFM^XLFDT(APCLET)
 S APCLFDA(9001003.312,APCLIENS,.08)=$$RUNTIME(APCLBT,APCLET)
 D UPDATE^DIE("","APCLFDA","APCLIENS","APCLERR(1)")
 Q
RUNTIME(B,E) ;
 NEW S,H,M,SEC,RT
 S RT=""
 S S=(86400*($P(E,",")-$P(B,",")))+($P(E,",",2)-$P(B,",",2)),H=$P(S/3600,".") S:H="" H=0 D
 .S S=S-(H*3600),M=$P(S/60,".") S:M="" M=0 S S=S-(M*60),SEC=S S RT="RUN TIME (H.M.S): "_H_"."_M_"."_SEC
 Q RT
HASADVN6(APCLV,D1,D2) ;EP - PATCH 27 - if return 1 then count visit and put pieces 2 through n in columns 66 through 75
 NEW X,P,Y,Z,T,G,C,APCL,E,S,V,PAT,P1,P2,APCLVDAT,APCLHAS
 S G=""
 ;S D=$$VD^APCLV(APCLV) ;VISIT DATE
 ;S E=$$FMADD^XLFDT(D,60) ;END DATE TO LOOK
 S PAT=$P(^AUPNVSIT(APCLV,0),U,5)
 S (C,P1,P2)=0
 S (D,E)=""
 K APCLHAS
 I D1="" G D2
 D ALLV^APCLAPIU(PAT,D1,$$FMADD^XLFDT(D1,60),"APCL")
 S APCLVDAT=D1
 D D
 I D1=D2 Q 1_U_D_U_E
D2 ;
 K APCL
 D ALLV^APCLAPIU(PAT,D2,$$FMADD^XLFDT(D2,60),"APCL")
 S APCLVDAT=D2
 D D
 I 'C Q ""
 Q 1_U_D_U_E
D ;
 I '$D(APCL) Q
 ;NOW GET RID OF ALL NON PHN/ILI CLINIC VISITS
 S APCLX=0 F  S APCLX=$O(APCL(APCLX)) Q:APCLX'=+APCLX!(C>4)  D
 .S V=$P(APCL(APCLX),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=0
 .;
 .I "AORSH"'[$P(^AUPNVSIT(V,0),U,7) Q  ;no chart reviews or Telephone calls
 .S CLNTAX=$O(^ATXAX("B","SURVEILLANCE ILI CLINICS",0))
 .S APCLCLIN=$$CLINIC^APCLV(V,"I")  ;get clinic code
 .;is there a PHN
 .S X=0,P=0 F  S X=$O(^AUPNVPRV("AD",V,X)) Q:X'=+X!(P)  D
 ..Q:'$D(^AUPNVPRV(X,0))
 ..S Y=$P(^AUPNVPRV(X,0),U)
 ..S Z=$$VALI^XBDIQ1(200,Y,53.5)
 ..Q:'Z
 ..I $P($G(^DIC(7,Z,9999999)),U,1)=13 S P=1
 .I P G HASADN61
 .I $P(^AUPNVSIT(V,0),U,7)'="H" I APCLCLIN="" Q
 .I $P(^AUPNVSIT(V,0),U,7)'="H" I '$D(^ATXAX(CLNTAX,21,"B",APCLCLIN)) Q  ;not in clinic taxonomy
 .S P=1
 .;does it have aN ADVERSE EVENT
HASADN61 .;
 .S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X!(C>4)  D
 ..S T=$P(^AUPNVPOV(X,0),U)
 ..I $$ICD^ATXCHK(T,$O(^ATXAX("B","SURVEILLANCE ADV EVENTS DXS",0)),9) D
 ...Q:$$VD^APCLV(V)=APCLVDAT  ;$$VD^APCLV(APCLV)  ;NOT SAME DATE AS VACCINE
 ...;Q:$$VD^APCLV(V)>$$FMADD^XLFDT($$VD^APCLV(APCLV),14)
 ...D SET6 Q
 ..I $$ICD^ATXCHK(T,$O(^ATXAX("B","SURVEILLANCE ADV EVENTS LIVE",0)),9) D  Q
 ...S A=$$AGE^APCLSILU(PAT,2,$$VD^APCLV(V))
 ...Q:A<24
 ...Q:A>59
 ...Q:$$VD^APCLV(V)=APCLVDAT  ;$$VD^APCLV(APCLV)  ;NOT SAME DATE AS VACCINE
 ...Q:$$VD^APCLV(V)>$$FMADD^XLFDT(APCLVDAT,14)
 ...D SET6
 ...Q
 ..I $$ICD^ATXCHK(T,$O(^ATXAX("B","SURVEILLANCE ADV EVENT FEBRILE",0)),9) D  Q
 ...S A=$$AGE^APCLSILU(PAT,2,$$VD^APCLV(V))
 ...Q:A>59
 ...Q:$$VD^APCLV(V)>$$FMADD^XLFDT(APCLVDAT,15)
 ...D SET6
 I 'C Q   ;""  ;no diagnosis
 Q  ;
SET6 ;
 Q:$D(APCLHAS(X))  ;ALREADY HAVE THIS ONE
 S APCLHAS(X)=""
 S C=C+1,P1=P1+1,P2=P2+1
 S $P(D,",",P1)=$$VAL^XBDIQ1(9000010.07,X,.01)
 S $P(E,",",P1)=$$VD^APCLV(V)
 Q
