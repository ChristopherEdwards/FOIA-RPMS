BDMDD1B ; IHS/CMI/LAB - get dm audit values ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**9**;JUN 14, 2007;Build 78
 ;
TD(P,EDATE) ;EP
 ;
 NEW BDM1
 S BDM1=$$TD^BDMS9B3(P,$$DOB^AUPNPAT(P),EDATE)
 NEW D,X S D=$P(BDM1,"  ",2),X=""
 I D]"" NEW X S X=D D ^%DT S X=$$DATE^BDMS9B1(Y)
 I $E(BDM1)="Y" Q "1  "_$P(BDM1,"  ",1)_"  "_X
 I $E(BDM1)="N" Q "2  "_$P(BDM1,"  ",1)_"  "_X
 I $E(BDM1)="R" Q "3  "_$P(BDM1,"  ",1)_"  "_X
 Q ""
TDAP(P,BDMSED,F) ;EP
 NEW BDMY,X,E,B,%DT,Y,TDD
 S TDD=$$LASTTDAP(P,BDMSED)
 I TDD Q "1  Yes  "_$S($G(F)="A":$$DATE^BDMS9B1(TDD),1:$$DATE^BDMS9B1(TDD))
 S R="",G="" F R=115 Q:R=""!(G)  D
 .S G=$$REFUSAL^BDMDD17(P,9999999.14,$O(^AUTTIMM("C",R,0)),$$FMADD^XLFDT(DT,-365),DT,"R")
 I G Q "3  Refused "_$P(G,U,3)
 ;; BI REFUSALS
 S G="" F Z=115 Q:G  S X=0,Y=$O(^AUTTIMM("C",Z,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:D<$$FMADD^XLFDT(DT,-365)
 .S G=1_U_D
 I G Q "3  Refused "_$S($G(F)="A":$$DATE^BDMS9B1($P(G,U,2)),1:$$DATE^BDMS9B1($P(G,U,2)))
 Q "2  No  "_$S($G(F)="A":$$DATE^BDMS9B1(TDD),1:$$DATE^BDMS9B1(TDD))
LASTTDAP(BDMPDFN,BDMED) ;PEP - date of last TD
 ; 
 I $G(BDMPDFN)="" Q ""
 S BDMBD=$$DOB^AUPNPAT(BDMPDFN)
 I $G(BDMED)="" S BDMED=DT
 NEW BDMLAST,BDMVAL,BDMX,R,X,Y,V,E,T,G,BDMY,BDMF
 S BDMLAST=""
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"115","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 S BDMF=$$LASTCPTI^BDMSMU2(BDMPDFN,90715,BDMBD,BDMED)
 I BDMF,$P(BDMF,U,3)>$P(BDMVAL,U,1) Q $P(BDMF,U,3)
 Q $P(BDMVAL,U,1)
PREG(P,BDATE,EDATE,NORXCHR,NORX) ;EP
 NEW BDMDX,B,CNT,BDMD,BDMG,Y,X,D,C,T,G,%
 I $P(^DPT(P,0),U,2)'="F" Q ""
 S B=0,CNT=0,BDMD=""  ;if there is one before time frame set this to 1
 S NORXCHR=$G(NORXCHR)
 S NORX=$G(NORX)
 K BDMG
 S Y="BDMG("
 S X=P_"^ALL DX [BGP PREGNANCY DIAGNOSES 2;DURING "_$$DATE^BDMS9B1(BDATE)_"-"_$$DATE^BDMS9B1(EDATE) S E=$$START1^APCLDF(X,Y)
 ;now reorder by date of diagnosis and eliminate all chr and rx if necessary
 I '$D(BDMG) G PROB  ;no diagnoses
 S B=0,X=0 F  S X=$O(BDMG(X)) Q:X'=+X  D
 .;get date
 .S D=$P(BDMG(X),U,1)
 .S C=$$CLINIC^APCLV($P(BDMG(X),U,5),"C")
 .I NORXCHR,C=39 Q
 .I NORX,C=39 Q
 .S C=$$PRIMPROV^APCLV($P(BDMG(X),U,5),"D")
 .I NORXCHR,C=53 Q  ;no chr as primary provider
 .S BDMDX(D)="",CNT=CNT+1 I CNT=2 S BDMD=D
 .Q
 I CNT>1 Q 1
PROB ;
 I '$G(B) Q ""  ;no pregnancy visit during time period  ;-Lori fix in 09
 S T=$O(^ATXAX("B","BGP PREGNANCY DIAGNOSES 2",0))
 S (X,G)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .Q:$P(^AUPNPROB(X,0),U,12)="I"
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE
 .Q:$P(^AUPNPROB(X,0),U,8)<BDATE
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^BDMUTL(Y,"BGP PREGNANCY DIAGNOSES 2",9)
 .S G=$P(^AUPNPROB(X,0),U,8)
 .Q
 I G Q 1
 Q 0
STATE(P) ;EP - STATE OF PATIENT1)
 I '$G(P) Q ""
 NEW X,C
 S X=$$GET1^DIQ(2,P,.115,"I")
 I 'X Q ""
 I +$$GET1^DIQ(5,X,2)>69 Q ""
 Q $$GET1^DIQ(5,X,1)
