APCHS7R ; IHS/CMI/LAB - PART 7 OF APCHS -- SUMMARY PRODUCTION COMPONENTS ; 
 ;;2.0;IHS PCC SUITE;**2,5**;MAY 14, 2009
 ;
SET ;
 ;S APCHCNT=APCHCNT+1
 S APCHSRX=P,APCHSREF=0 D REF
 S APCHSTAT(C,N,D,(9999999-F),M)=$S(P:$P(^PSRX(P,0),U),1:"")_U_APCHSREF
 S APCHMDSP(D,N,F)=""
 Q
MEDRCON ; ************* MEDS BY PRESCRIPTION STATUS *************
 ;
CONT ; <SETUP>
 I '$D(^AUPNVMED("AC",APCHSPAT)),'$D(^PS(52.41,"P",APCHSPAT)),'$D(^PS(55,APCHSPAT,"NVA")) Q
 X APCHSCKP Q:$D(APCHSQIT)  I 'APCHSNPG W ! X APCHSBRK
 ; <BUILD>
 NEW APCHMEDS,APCHSTAT,APCHCNT,APCHMDSP,APCHDI,APCHDT,APCHM,APCHN,APCHSSGY,APCHSIG,APCHZ,APCHSN,APCHST,APCHI,APCHD
 NEW X,F,M,V,D,N,P,C,E,S,R,J
 S APCHCNT=0
 K APCHMEDS,APCHMDSP
 D GETMEDS^APCHSMU1(APCHSPAT,$$FMADD^XLFDT(DT,-395),DT,,,,,.APCHMEDS)
 ;I '$D(APCHMEDS) D MEDX Q
 ;NOW REORDER THEM BY STATUS
 K APCHSTAT
 S X=0 F  S X=$O(APCHMEDS(X)) Q:X'=+X  D
 .S P=""
 .S F=$P(APCHMEDS(X),U,1)  ;FILL DATE
 .S M=$P(APCHMEDS(X),U,4)  ;vmed ien
 .S V=$P(APCHMEDS(X),U,5)  ;visit ien
 .S D=$P(^AUPNVMED(M,0),U)  ;drug ien
 .S N=$P(^AUPNVMED(M,0),U,4) ;non table drug name
 .I N="" S N=$P(^PSDRUG(D,0),U)  ;drug name
 .I $P($G(^AUPNVSIT(X,0)),U,7)="E" S C="OUTSIDE MEDICATIONS" D SET Q
 .;I $P($G(^AUPNVMED(X,11)),U,8)]"" Q  ;we will get EHR outside meds from the NVA multiple later S C="OUTSIDE MEDICATIONS" D SET Q
 .S P=$O(^PSRX("APCC",M,0))
 .I 'P S C="OUTSIDE MEDICATIONS" D SET Q
 .I '$D(^PSRX(P,0)) S P="",C="OUTSIDE MEDICATIONS" D SET Q
 .S S=$$VALI^XBDIQ1(52,P,100)  ;GET STATUS
 .I S=0 S C="ACTIVE MEDICATIONS" D SET Q
 .I S=3 S C="HOLD" D SET Q
 .I S=5 S C="SUSPENDED" D SET Q
 .I S=11 D  Q
 ..;get expiration date
 ..S E=$P($G(^PSRX(P,3)),U,6)
 ..S R=$$CHRONIC^APCHS72(M)  ;chronic flag
 ..I 'R D  Q
 ...;not chronic, check to see if expired in past 14 days, if not quit
 ...S J=$$FMDIFF^XLFDT(DT,E)
 ...Q:J>14  ;more than 14 days ago so don't display
 ...;check to see if same drug is already listed somewhere
 ...Q:$O(APCHMDSP(D,N,F))  ;another of same drug after this date
 ...S C="EXPIRED" D SET Q
 ..;chronic = check 120 days
 ..S J=$$FMDIFF^XLFDT(DT,E)
 ..Q:J>120  ;expired more than 120 days ago
 ..Q:$O(APCHMDSP(D,N,F))  ;another one there so don't display this one
 ..S C="EXPIRED" D SET Q
 .I S=12!(S=14) D
 ..S E=$P(^AUPNVMED(M,0),U,8)  ;discontinued date in v med
 ..I E="" S E=$P($G(^PSRX(P,3)),U,5)  ;canceled date in 52
 ..I $$FMDIFF^XLFDT(DT,E)>30 Q  ;only discontinueds in past 30 days
 ..Q:$O(APCHMDSP(D,N,F))
 ..S C="DISCONTINUED MEDICATIONS" D SET Q
GETNVA ;NVA from file 55
 S X=0 F  S X=$O(^PS(55,APCHSPAT,"NVA",X)) Q:X'=+X  D
 .I $P($G(^PS(55,APCHSPAT,"NVA",X,999999911)),U,1),$D(^AUPNVMED($P(^PS(55,APCHSPAT,"NVA",X,999999911),U,1),0)) Q  ;got this with V MED
 .;S L=$P(^PS(55,APCHSPAT,"NVA",X,0),U,9)
 .;:'L
 .S L=$P($P($G(^PS(55,APCHSPAT,"NVA",X,0)),U,10),".")
 .S L=9999999-L
 .;Q:$P(^PS(55,APCHSPAT,"NVA",X,0),U,6)=1  ;discontinued
 .;I $P(^PS(55,APCHSPAT,"NVA",X,0),U,7)]""  ;discontinued date
 .S D=$P(^PS(55,APCHSPAT,"NVA",X,0),U,2)
 .I D="" S D="NO DRUG IEN"
 .S N=$S(D:$P(^PSDRUG(D,0),U,1),1:$P(^PS(50.7,$P(^PS(55,APCHSPAT,"NVA",X,0),U,1),0),U,1))
 .S APCHSTAT("NVA",N,D,(9999999-L))=U_"N",$P(APCHSTAT("NVA",N,D,(9999999-L)),U,8)=$P(^PS(55,APCHSPAT,"NVA",X,0),U,4)_" "_$P(^PS(55,APCHSPAT,"NVA",X,0),U,5)_U_$P(^PS(55,APCHSPAT,"NVA",X,0),U,7)
GETPEND ;
 NEW PEN,ORD
 F PEN=0:0 S PEN=$O(^PS(52.41,"P",APCHSPAT,PEN)) Q:'PEN  S ORD=^PS(52.41,PEN,0),APCHI=$P(ORD,"^",8),APCHD=+$P(ORD,"^",9) D:$P(ORD,"^",3)'="DC"&($P(ORD,"^",3)'="DE")&($P(ORD,"^",3)'="HD")
 .S APCHN=$S(APCHD:$P($G(^PSDRUG(APCHD,0)),"^"),+APCHI&('APCHD):$P(^PS(50.7,APCHI,0),"^")_" "_$P(^PS(50.606,$P(^PS(50.7,APCHI,0),"^",2),0),"^"),1:"") Q:APCHN']""
 .S APCHSTAT("PENDING",APCHN,PEN)=$$VAL^XBDIQ1(52.41,PEN,13)
 .S C=0,X="" F  S C=$O(^PS(52.41,PEN,"SIG",C)) Q:'C  S X=X_$S(X]"":" ",1:"")_^PS(52.41,PEN,"SIG",C,0)
 .S $P(APCHSTAT("PENDING",APCHN,PEN),U,2)=X
DISP ;DISPLAY MEDS
 ;ACTIVE MEDS FIRST - ALL OF THEM
 X APCHSCKP Q:$D(APCHSQIT)
 I '$D(APCHSTAT("ACTIVE MEDICATIONS")) G OUT
 W "ACTIVE MEDICATIONS",!
 S APCHCNT=0
 S APCHT=1
 S APCHN="" F  S APCHN=$O(APCHSTAT("ACTIVE MEDICATIONS",APCHN)) Q:APCHN=""!($D(APCHSQIT))  D
 .S APCHDI="" F  S APCHDI=$O(APCHSTAT("ACTIVE MEDICATIONS",APCHN,APCHDI)) Q:APCHDI=""!($D(APCHSQIT))  D
 ..S APCHDT=0 F  S APCHDT=$O(APCHSTAT("ACTIVE MEDICATIONS",APCHN,APCHDI,APCHDT)) Q:APCHDT'=+APCHDT!($D(APCHSQIT))  D
 ...S APCHM=0 F  S APCHM=$O(APCHSTAT("ACTIVE MEDICATIONS",APCHN,APCHDI,APCHDT,APCHM)) Q:APCHM'=+APCHM!($D(APCHSQIT))  S APCHZ=APCHSTAT("ACTIVE MEDICATIONS",APCHN,APCHDI,APCHDT,APCHM) D MEDDSP
OUT ;OUTSIDE MEDICATIONS
 I '$D(APCHSTAT("OUTSIDE MEDICATIONS")),'$D(APCHSTAT("NVA")) G HOLD
 W "--------------------",!
 W "OUTSIDE MEDICATIONS",!
 S APCHN="" F  S APCHN=$O(APCHSTAT("OUTSIDE MEDICATIONS",APCHN)) Q:APCHN=""!($D(APCHSQIT))  D
 .S APCHDI="" F  S APCHDI=$O(APCHSTAT("OUTSIDE MEDICATIONS",APCHN,APCHDI)) Q:APCHDI=""!($D(APCHSQIT))  D
 ..S APCHDT=0 S APCHDT=$O(APCHSTAT("OUTSIDE MEDICATIONS",APCHN,APCHDI,APCHDT)) Q:APCHDT'=+APCHDT!($D(APCHSQIT))  D
 ...S APCHM=0 S APCHM=$O(APCHSTAT("OUTSIDE MEDICATIONS",APCHN,APCHDI,APCHDT,APCHM)) Q:APCHM'=+APCHM!($D(APCHSQIT))  S APCHZ=APCHSTAT("OUTSIDE MEDICATIONS",APCHN,APCHDI,APCHDT,APCHM) D MEDDSPO
 ;now display nva
 S APCHN="" F  S APCHN=$O(APCHSTAT("NVA",APCHN)) Q:APCHN=""!($D(APCHSQIT))  D
 .S APCHDI="" F  S APCHDI=$O(APCHSTAT("NVA",APCHN,APCHDI)) Q:APCHDI=""!($D(APCHSQIT))  D
 ..S APCHDT=0 S APCHDT=$O(APCHSTAT("NVA",APCHN,APCHDI,APCHDT)) Q:APCHDT'=+APCHDT!($D(APCHSQIT))  D
 ...S APCHZ=APCHSTAT("NVA",APCHN,APCHDI,APCHDT) D MEDDSPN
HOLD ;HOLD MEDICATIONS
 I '$D(APCHSTAT("HOLD MEDICATIONS")) G SUSPEND
 S APCHT=3
 W "--------------------",!
 W "ACTIVE NOT DISPENSED MEDICATIONS",!
 S APCHN="" F  S APCHN=$O(APCHSTAT("HOLD MEDICATIONS",APCHN)) Q:APCHN=""!($D(APCHSQIT))  D
 .S APCHDI="" F  S APCHDI=$O(APCHSTAT("HOLD MEDICATIONS",APCHN,APCHDI)) Q:APCHDI=""!($D(APCHSQIT))  D
 ..S APCHDT=0 F  S APCHDT=$O(APCHSTAT("HOLD MEDICATIONS",APCHN,APCHDI,APCHDT)) Q:APCHDT'=+APCHDT!($D(APCHSQIT))  D
 ...S APCHM=0 F  S APCHM=$O(APCHSTAT("HOLD MEDICATIONS",APCHN,APCHDI,APCHDT,APCHM)) Q:APCHM'=+APCHM!($D(APCHSQIT))  S APCHZ=APCHSTAT("HOLD MEDICATIONS",APCHN,APCHDI,APCHDT,APCHM) D MEDDSP
SUSPEND ;
 I '$D(APCHSTAT("SUSPEND MEDICATIONS")) G PENDING
 S APCHT=4
 W !,"--------------------",!
 W "SUSPENDED MEDICATIONS",!
 S APCHN="" F  S APCHN=$O(APCHSTAT("SUSPEND MEDICATIONS",APCHN)) Q:APCHN=""!($D(APCHSQIT))  D
 .S APCHDI="" F  S APCHDI=$O(APCHSTAT("SUSPEND MEDICATIONS",APCHN,APCHDI)) Q:APCHDI=""!($D(APCHSQIT))  D
 ..S APCHDT=0 F  S APCHDT=$O(APCHSTAT("SUSPEND MEDICATIONS",APCHN,APCHDI,APCHDT)) Q:APCHDT'=+APCHDT!($D(APCHSQIT))  D
 ...S APCHM=0 F  S APCHM=$O(APCHSTAT("SUSPEND MEDICATIONS",APCHN,APCHDI,APCHDT,APCHM)) Q:APCHM'=+APCHM!($D(APCHSQIT))  S APCHZ=APCHSTAT("SUSPEND MEDICATIONS",APCHN,APCHDI,APCHDT,APCHM) D MEDDSP
PENDING ;
 I '$D(APCHSTAT("PENDING")) G EXPIRED
 W "--------------------",!
 W "PENDING MEDICATIONS",!
 S APCHN="" F  S APCHN=$O(APCHSTAT("PENDING",APCHN)) Q:APCHN=""!($D(APCHSQIT))  D
 .S APCHDI="" F  S APCHDI=$O(APCHSTAT("PENDING",APCHN,APCHDI)) Q:APCHDI=""!($D(APCHSQIT))  D
 ..S APCHZ=APCHSTAT("PENDING",APCHN,APCHDI) D MEDDSPP
EXPIRED ;
 I '$D(APCHSTAT("EXPIRED MEDICATIONS")) G DISCONT
 S APCHT=6
 W "--------------------",!
 W "CHRONIC AND RECENTLY EXPIRED MEDICATIONS",!
 S APCHN="" F  S APCHN=$O(APCHSTAT("EXPIRED MEDICATIONS",APCHN)) Q:APCHN=""!($D(APCHSQIT))  D
 .S APCHDI="" F  S APCHDI=$O(APCHSTAT("EXPIRED MEDICATIONS",APCHN,APCHDI)) Q:APCHDI=""!($D(APCHSQIT))  D
 ..S APCHDT=0 F  S APCHDT=$O(APCHSTAT("EXPIRED MEDICATIONS",APCHN,APCHDI,APCHDT)) Q:APCHDT'=+APCHDT!($D(APCHSQIT))  D
 ...S APCHM=0 F  S APCHM=$O(APCHSTAT("EXPIRED MEDICATIONS",APCHN,APCHDI,APCHDT,APCHM)) Q:APCHM'=+APCHM!($D(APCHSQIT))  S APCHZ=APCHSTAT("EXPIRED MEDICATIONS",APCHN,APCHDI,APCHDT,APCHM) D MEDDSP
DISCONT ;
 I '$D(APCHSTAT("DISCONTINUED MEDICATIONS")) G MEDX
 S APCHT=7
 W "--------------------",!
 W "RECENTLY DISCONTINUED MEDICATIONS",!
 S APCHN="" F  S APCHN=$O(APCHSTAT("DISCONTINUED MEDICATIONS",APCHN)) Q:APCHN=""!($D(APCHSQIT))  D
 .S APCHDI="" F  S APCHDI=$O(APCHSTAT("DISCONTINUED MEDICATIONS",APCHN,APCHDI)) Q:APCHDI=""!($D(APCHSQIT))  D
 ..S APCHDT=0 F  S APCHDT=$O(APCHSTAT("DISCONTINUED MEDICATIONS",APCHN,APCHDI,APCHDT)) Q:APCHDT'=+APCHDT!($D(APCHSQIT))  D
 ...S APCHM=0 F  S APCHM=$O(APCHSTAT("DISCONTINUED MEDICATIONS",APCHN,APCHDI,APCHDT,APCHM)) Q:APCHM'=+APCHM!($D(APCHSQIT))  S APCHZ=APCHSTAT("DISCONTINUED MEDICATIONS",APCHN,APCHDI,APCHDT,APCHM) D MEDDSP
MEDX ;
 Q
MEDDSPP ;DISPLAY MEDICATION
 S APCHCNT=APCHCNT+1
 X APCHSCKP Q:$D(APCHSQIT)
 W APCHCNT,".",?6,APCHN W:$P(APCHZ,U,2) ?60,"Refills: ",$S('$P(APCHZ,U,1):"NONE",1:$P(APCHZ,U,1)) W !
 X APCHSCKP Q:$D(APCHSQIT)
 K ^UTILITY($J,"W") S X=$P(APCHZ,U,2),DIWL=0,DIWR=60 D ^DIWP
 W ?6,"Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" "),!
 I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) Q:$D(APCHSQIT)  D
 .X APCHSCKP Q:$D(APCHSQIT)
 .W ?19,$G(^UTILITY($J,"W",0,F,0)),!
 K ^UTILITY($J,"W")
 Q
MEDDSPO ;DISPLAY MEDICATION
 S APCHSN=^AUPNVMED(APCHM,0)
 S APCHCNT=APCHCNT+1
 X APCHSCKP Q:$D(APCHSQIT)
 W APCHCNT,".",?6,APCHN W:$P(APCHZ,U,2) ?60,"Refills left: ",$S('$P(APCHZ,U,2):"NONE",1:$P(APCHZ,U,2)) W !
 X APCHSCKP Q:$D(APCHSQIT)
 S APCHSIG=$P(^AUPNVMED(APCHM,0),U,5) D SIG
 S X=APCHSSGY
 K ^UTILITY($J,"W") S DIWL=0,DIWR=60 D ^DIWP
 X APCHSCKP Q:$D(APCHSQIT)
 W ?6,"Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" "),!
 I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) Q:$D(APCHSQIT)  D
 .X APCHSCKP Q:$D(APCHSQIT)
 .W ?19,$G(^UTILITY($J,"W",0,F,0)),!
 K ^UTILITY($J,"W")
 Q
MEDDSPN ;
 S APCHCNT=APCHCNT+1
 X APCHSCKP Q:$D(APCHSQIT)
 W APCHCNT,".",?6,APCHN,! ;W:$P(APCHZ,U,2) ?60,"Refills left: ",$S('$P(APCHZ,U,2):"NONE",1:$P(APCHZ,U,2)) W !
 X APCHSCKP Q:$D(APCHSQIT)
 S APCHSIG=$P(APCHZ,U,8) D SIG
 S X=APCHSSGY
 K ^UTILITY($J,"W") S DIWL=0,DIWR=60 D ^DIWP
 X APCHSCKP Q:$D(APCHSQIT)
 W ?6,"Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" "),!
 I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) Q:$D(APCHSQIT)  D
 .X APCHSCKP Q:$D(APCHSQIT)
 .W ?19,$G(^UTILITY($J,"W",0,F,0)),!
 I $P(APCHZ,U,9) W !?19,"DATE DISCONTINUED: ",$$FMTE^XLFDT($P(APCHZ,U,9))
 K ^UTILITY($J,"W")
 Q
MEDDSP ;DISPLAY MEDICATION
 S APCHSN=^AUPNVMED(APCHM,0)
 S APCHCNT=APCHCNT+1
 X APCHSCKP Q:$D(APCHSQIT)
 W APCHCNT,".",?6,APCHN,?40,"Rx #:",$P(APCHZ,U,1),?60,"Refills left: ",$S('$P(APCHZ,U,2):"NONE",1:$P(APCHZ,U,2)),!
 X APCHSCKP Q:$D(APCHSQIT)
 S APCHSIG=$P(^AUPNVMED(APCHM,0),U,5) D SIG
 S X=APCHSSGY
 K ^UTILITY($J,"W") S DIWL=0,DIWR=60 D ^DIWP
 X APCHSCKP Q:$D(APCHSQIT)
 W ?6,"Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" "),!
 I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) Q:$D(APCHSQIT)  D
 .X APCHSCKP Q:$D(APCHSQIT)
 .W ?19,$G(^UTILITY($J,"W",0,F,0)),!
 K ^UTILITY($J,"W")
 X APCHSCKP Q:$D(APCHSQIT)
 I APCHT=1!(APCHT=6) W ?6,"Last Filled: ",$$D(9999999-APCHDT) D
 .S APCHSORT="" I APCHT=1 S APCHSORT=$P($G(^AUPNVMED(APCHM,11)),U)
 .I APCHSORT["RETURNED TO STOCK" W "    ---",APCHSORT,"  ",$$FMTE^XLFDT($P(^AUPNVMED(APCHM,0),U,8),"2D")
 I APCHT=6 I $P(APCHZ,U,1) S E=$P($G(^PSRX($P(APCHZ,U,1),3)),U,6) W ?30,"Expired: ",$$D(E)
 W !
 I APCHT=3 W ?6,"Hold Reason: " I $P(APCHZ,U,1) W $P($G(^PSRX($P(APCHZ,U,1),"H")),U,1)
 I APCHT=7 W ?6,"Discontinued: " D
 .S E=$P(^AUPNVMED(APCHM,0),U,8)  ;discontinued date in v med
 .I E="",$P(APCHZ,U,1) S E=$P($G(^PSRX($P(APCHZ,U,1),3)),U,5)  ;canceled date in 52
 .W $$D(E),!
 Q
D(D) ;
 I D="" Q ""
 Q $E(D,4,5)_"-"_$E(D,6,7)_"-"_$E(D,2,3)
 ;
SIG ;CONSTRUCT THE FULL TEXT FROM THE ENCODED SIG
 S APCHSSGY="" F APCHSP=1:1:$L(APCHSIG," ") S X=$P(APCHSIG," ",APCHSP) I X]"" D
 . S Y=$O(^PS(51,"B",X,0)) I Y>0 S X=$P(^PS(51,Y,0),"^",2) I $D(^(9)) S Y=$P(APCHSIG," ",APCHSP-1),Y=$E(Y,$L(Y)) S:Y>1 X=$P(^(9),"^",1)
 . S APCHSSGY=APCHSSGY_X_" "
 Q
 ;
REF ;DETERMINE THE NUMBER OF REFILLS REMAINING
 I 'APCHSRX S APCHSREF=$P($G(^AUPNVMED(M,11)),U,7) S:APCHSREF="" APCHSREF=0 Q
 S APCHSRFL=$P(^PSRX(APCHSRX,0),U,9) S APCHSREF=0 F  S APCHSREF=$O(^PSRX(APCHSRX,1,APCHSREF)) Q:'APCHSREF  S APCHSRFL=APCHSRFL-1
 S APCHSREF=APCHSRFL
 Q
 ;
 ;
SITE ;DETERMINE IF OUTSIDE LOCATION INFO PRESENT
 S APCHSITE=""
 I $D(^AUPNVSIT(APCHSVDF,21))#2 S APCHSITE=$P(^(21),U) Q
 Q:$P(^AUPNVSIT(APCHSVDF,0),U,6)=""
 I $P(^AUPNVSIT(APCHSVDF,0),U,6)'=DUZ(2) S APCHSITE=$E($P(^DIC(4,$P(^AUPNVSIT(APCHSVDF,0),U,6),0),U),1,30)
 Q
 ;
CS(D) ;
 I $P(^PSDRUG(D,0),U,3)="" Q 0
 NEW Y S Y=$P(^PSDRUG(D,0),U,3)
 ;I Y[1 Q 1
 I Y[2 Q 1
 I Y[3 Q 1
 I Y[4 Q 1
 I Y[5 Q 1
 ;I Y["C" Q 1
 ;I Y["A" Q 1
 Q 0
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X