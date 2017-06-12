APCHPWHX ; IHS/CMI/LAB - PCC HEALTH SUMMARY - MAIN DRIVER PART 2 ;  
 ;;2.0;IHS PCC SUITE;**2,5,7,8,10**;MAY 14, 2009;Build 88
 ;
MEDSACT ;EP - medications (active) component
 S APCHACTO=1
 D MEDS
 K APCHACTO
 Q
 ;
MEDS ;EP - medications component
 ;get all meds in the past year +30 days
 NEW APCHMEDS,APCHMED,X,M,I,N,D,APCHKEEP,APCHM,APCHRXN,APCHRXO,APCHRX0,APCHSREF,APCHSTAT,C,APCHN,APCHI,APCHD,APCHC
 NEW X,M,D,N,C,Z,P,I,EXPDT
 ;
 ;store each drug by inverse date
 K APCHMED,APCHALL
 ;GET ALL PRESCRIPTIONS IN PHARMACY PATIENT FILE FOR -395 TO TODAY BY EXPIRATION DATE IN PS(55
 S EXPDT=$$FMADD^XLFDT(DT,-395)
 F  S EXPDT=$O(^PS(55,APCHSDFN,"P","A",EXPDT)) Q:EXPDT'=+EXPDT  D
 .S I=0 F  S I=$O(^PS(55,APCHSDFN,"P","A",EXPDT,I)) Q:I'=+I  D
 ..Q:'$D(^PSRX(I,0))
 ..S D=$P(^PSRX(I,0),U,6)
 ..I '$D(^PSDRUG(D,0)) Q  ;no drug
 ..S N=$P(^PSDRUG(D,0),U)
 ..S P=$P(^PSRX(I,0),U,2)
 ..I P'=APCHSDFN Q  ;oops, bad data
 ..S L=$P($G(^PSRX(I,3)),U,1)  ;last dispensed date
 ..I L="" S L=$O(^PSRX(I,1,"B",9999999),-1)
 ..I L="" S L=$P($G(^PSRX(I,2)),U,2)
 ..I L="" S L=$P(^PSRX(I,0),U,13)
 ..Q:L=""
 ..S L=9999999-L
 ..S S=$P($G(^PSRX(I,"STA")),U,1)
 ..Q:S=1
 ..Q:S=4
 ..Q:S=10
 ..Q:S=12
 ..Q:S=13
 ..Q:S=14
 ..Q:S=15
 ..Q:S=16
 ..S APCHALL(N,D,L,I)=S
 ;now kill off all except the latest one
 K APCHKEEP
 S N="" F  S N=$O(APCHALL(N)) Q:N=""  D
 .S D=0 F  S D=$O(APCHALL(N,D)) Q:D=""  D
 ..Q:$D(APCHKEEP(N,D))
 ..S L=$O(APCHALL(N,D,0))
 ..S I=$O(APCHALL(N,D,L,0))
 ..S APCHKEEP(N,D,L,I)=APCHALL(N,D,L,I)
 ;now go through and group them
 S N="" F  S N=$O(APCHKEEP(N)) Q:N=""  D
 .S D=0 F  S D=$O(APCHKEEP(N,D)) Q:D=""  D
 ..S L=0 F  S L=$O(APCHKEEP(N,D,L)) Q:L=""  D
 ...S I=0 F  S I=$O(APCHKEEP(N,D,L,I)) Q:I'=+I  D
 ....S S=APCHKEEP(N,D,L,I)
 ....I S=11 D GRP2 Q
 ....D GRP1
 ;NOW GET OUTSIDE MEDS DEFINED AS ANY WITH 1108 FIELD OR EVENT VISIT SERVICE CATEGORY
 K APCHMEDS,APCHM
 D GETMEDS^APCHSMU1(APCHSDFN,$$FMADD^XLFDT(DT,-365),DT,,,,,.APCHMEDS)
 ;store each drug by inverse date
 S X=0 F  S X=$O(APCHMEDS(X)) Q:X'=+X  D
 .S M=$P(APCHMEDS(X),U,4)
 .S V=$P(^AUPNVMED(M,0),U,3)
 .I $P(^AUPNVSIT(V,0),U,7)'="E" Q
 .Q:$P($G(^AUPNVMED(M,11)),U,8)]""  ;will get this one from NVA
 .Q:$P(^AUPNVMED(M,0),U,8)  ;discontinued
 .S D=$P(^AUPNVMED(M,0),U,1)
 .S N=$S($P(^AUPNVMED(M,0),U,4)]"":$P(^AUPNVMED(M,0),U,4),1:$P(^PSDRUG(D,0),U,1))
 .S APCHM(N,D,(9999999-$P(APCHMEDS(X),U,1)))=APCHMEDS(X)
 ;now get rid of all except the latest one
 K APCHKEEP
 S N="" F  S N=$O(APCHM(N)) Q:N=""  D
 .S D=0 F  S D=$O(APCHM(N,D)) Q:D=""  D
 ..Q:$D(APCHMED(N,D))
 ..S X=$O(APCHM(N,D,0))
 ..S M=$P(APCHM(N,D,X),U,4)
 ..S APCHMED(1,N,D,X)=M_U_"M"
 ..S $P(APCHMED(1,N,D,X),U,8)=$P(^AUPNVMED(M,0),U,5)
 ;now get all NVA meds
 NEW NVA0,ORDNUM,APCHVM,SIG
 S X=0 F  S X=$O(^PS(55,APCHSDFN,"NVA",X)) Q:X'=+X  D
 .S APCHVM=""
 .;I $P($G(^PS(55,APCHSDFN,"NVA",X,999999911)),U,1),$D(^AUPNVMED($P(^PS(55,APCHSDFN,"NVA",X,999999911),U,1),0)) S APCHVM=$P(^PS(55,APCHSDFN,"NVA",X,999999911),U,1) Q  ;got this with V MED
 .S L=$P($P($G(^PS(55,APCHSDFN,"NVA",X,0)),U,10),".")
 .;S L=9999999-L
 .;I L<$$FMADD^XLFDT(DT,-365) Q
 .Q:$P(^PS(55,APCHSDFN,"NVA",X,0),U,6)=1  ;discontinued
 .I $P(^PS(55,APCHSDFN,"NVA",X,0),U,7)]"" Q  ;discontinued date
 .S D=$P(^PS(55,APCHSDFN,"NVA",X,0),U,2)
 .I D="" S D="NO DRUG IEN"
 .S N=$S(D:$P(^PSDRUG(D,0),U,1),1:$P(^PS(50.7,$P(^PS(55,APCHSDFN,"NVA",X,0),U,1),0),U,1))
 .;FIGURE OUT SIG COPIED FROM APSPPCC2
 .S NVA0=$G(^PS(55,APCHSDFN,"NVA",X,0))
 .S ORDNUM=$P(NVA0,U,8)
 .S SIG=$$SIG(ORDNUM)
 .S APCHSTAT("NVA",N,D,(9999999-L))=U_"N",$P(APCHSTAT("NVA",N,D,(9999999-L)),U,8)=$P(^PS(55,APCHSDFN,"NVA",X,0),U,4)_" "_$P(^PS(55,APCHSDFN,"NVA",X,0),U,5)_U_$P(^PS(55,APCHSDFN,"NVA",X,0),U,7)
 .S APCHMED(1,N,D,(9999999-L))=U_"N",$P(APCHMED(1,N,D,(9999999-L)),U,8)=SIG_" "_$P(^PS(55,APCHSDFN,"NVA",X,0),U,5)_U_$P(^PS(55,APCHSDFN,"NVA",X,0),U,7)
 D DISP
 Q
 ; Return SIG from Order
SIG(ORIFN) ;EP
 N ID,LP,SIG
 Q:'$G(ORIFN) ""
 S ID=$$PTR(ORIFN,"SIG")
 Q:'ID ""
 S SIG=""
 S LP=0 F  S LP=$O(^OR(100,ORIFN,4.5,ID,2,LP)) Q:'LP  D
 .S SIG=SIG_$S($L(SIG):" ",1:"")_^OR(100,ORIFN,4.5,ID,2,LP,0)
 Q SIG
PTR(ORIFN,ID) S ID=$O(^OR(100,ORIFN,4.5,"ID",ID,0))
 Q ID
 ;
GRP2 ;
 Q:'$D(^PS(55,APCHSDFN,"P","CP",I))  ;CHRONIC ONLY
 S C=$S(I:$D(^PS(55,APCHSDFN,"P","CP",I)),1:0)
 S Y=$S(C:120,1:14)
 Q:$$FMDIFF^XLFDT(DT,$P($G(^PSRX(I,2)),U,6))>Y
 S APCHMED(2,N,D,L)=I_U_"P"
 S $P(APCHMED(2,N,D,L),U,6)=$P(^PSRX(I,0),U)
 ;S $P(APCHMED(Z,N,D,X),U,8)=$P(^AUPNVMED(M,0),U,5)  ;SET SIG
 I $O(^PSRX(I,"SIG1",0)) D
 .S S="" S APCHP=0 F  S APCHP=$O(^PSRX(I,"SIG1",APCHP)) Q:APCHP'=+APCHP  S S=S_^PSRX(I,"SIG1",APCHP,0)_" "
 I S="" S S=$P($G(^PSRX(I,"SIG")),U,1)
 S $P(APCHMED(2,N,D,L),U,8)=S
 S APCHSRX=I,APCHSREF=0 D REF^APCHS7O S $P(APCHMED(2,N,D,L),U,7)=APCHSREF
 S $P(APCHMED(2,N,D,L),U,10)=$P($G(^PSRX(I,2)),U,6)  ;expiration date
 Q
GRP1 ;
 S APCHMED(1,N,D,L)=I_U_"P"
 S $P(APCHMED(1,N,D,L),U,6)=$P(^PSRX(I,0),U)
 ;S $P(APCHMED(Z,N,D,X),U,8)=$P(^AUPNVMED(M,0),U,5)  ;SET SIG
 I $O(^PSRX(I,"SIG1",0)) D
 .S S="" S APCHP=0 F  S APCHP=$O(^PSRX(I,"SIG1",APCHP)) Q:APCHP'=+APCHP  S S=S_^PSRX(I,"SIG1",APCHP,0)_" "
 I S="" S S=$P($G(^PSRX(I,"SIG")),U,1)
 S $P(APCHMED(1,N,D,L),U,8)=S
 S APCHSRX=I,APCHSREF=0 D REF^APCHS7O S $P(APCHMED(1,N,D,L),U,7)=APCHSREF
 Q
DISP ;display them now, this was a pain
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("MEDICATIONS - This is a list of medications and other items you are")
 D S^APCHPWH1("taking including non-prescription medications, herbal, dietary, and")
 D S^APCHPWH1("traditional supplements.  Please let us know if this list is not ")
 D S^APCHPWH1("complete.  If you have other medications at home or are not sure if")
 D S^APCHPWH1("you should be taking them, call your health care provider to be safe.")
 I '$D(APCHMED) D S^APCHPWH1("No medications are on file.  Please tell us if there are any that we missed.",1) Q
 S APCHC=0
 S APCHN=""
 F  S APCHN=$O(APCHMED(1,APCHN)) Q:APCHN=""  D
 .S APCHI=0 F  S APCHI=$O(APCHMED(1,APCHN,APCHI)) Q:APCHI=""  D
 ..S APCHD=0 F  S APCHD=$O(APCHMED(1,APCHN,APCHI,APCHD)) Q:APCHD=""  D
 ...S APCHZ=APCHMED(1,APCHN,APCHI,APCHD)
 ...S APCHC=APCHC+1
 ...S X="",$E(X,1)=APCHC_"."
 ...S $E(X,7)=APCHN,$E(X,47)=$S($P(APCHZ,U,2)="P":"Rx#: "_$P(^PSRX($P(APCHZ,U,1),0),U,1),$P(APCHZ,U,2)="M":$P($G(^AUPNVMED($P(APCHZ,U,1),11)),U,2),1:"")
 ...S $E(X,61)=$S($P(APCHZ,U,7)]"":"Refills left: "_$P(APCHZ,U,7),1:"") D S^APCHPWH1(X,1)
 ...;attempt to wrap directions 58 characters
 ...K ^UTILITY($J,"W") S X=$P(APCHZ,U,8),DIWL=0,DIWR=58 D ^DIWP
 ...S X="",$E(X,7)="Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S^APCHPWH1(X)
 ...I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,19)=$G(^UTILITY($J,"W",0,F,0)) D S^APCHPWH1(X)
 ...K ^UTILITY($J,"W")
 ...;I $P(Z,U,11)]"" D S^APCHPWH1("      Ordered but not dispensed: "_$P(Z,U,11))
 I '$G(APCHACTO),$D(APCHMED(2)) D
 .D S^APCHPWH1("==========",1)
 .D S^APCHPWH1("Your prescription for these medications has expired.  You need to talk")
 .D S^APCHPWH1("with your prescriber to get a new prescription for these medications.")
 .D S^APCHPWH1(" ")
 .S APCHN="" F  S APCHN=$O(APCHMED(2,APCHN)) Q:APCHN=""  D
 ..S APCHI=0 F  S APCHI=$O(APCHMED(2,APCHN,APCHI)) Q:APCHI'=+APCHI  D
 ...S APCHD=0 F  S APCHD=$O(APCHMED(2,APCHN,APCHI,APCHD)) Q:APCHD'=+APCHD  D
 ....S APCHZ=APCHMED(2,APCHN,APCHI,APCHD)
 ....S APCHC=APCHC+1
 ....S X="",$E(X,1)=APCHC_".",$E(X,7)=APCHN,$E(X,47)=$S($P(APCHZ,U,6)]"":"Rx#: "_$P(APCHZ,U,6),1:""),$E(X,61)=$S($P(APCHZ,U,7)]"":"Refills left: "_$P(APCHZ,U,7),1:"") D S^APCHPWH1(X,1)
 ....;S X="",$E(X,7)="Directions: "_$P(Z,U,8) D S^APCHPWH1(X)
 ....K ^UTILITY($J,"W") S X=$P(APCHZ,U,8),DIWL=0,DIWR=58 D ^DIWP
 ....S X="",$E(X,7)="Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S^APCHPWH1(X)
 ....I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,19)=$G(^UTILITY($J,"W",0,F,0)) D S^APCHPWH1(X)
 ....K ^UTILITY($J,"W")
 ....S X="",$E(X,7)="Last date filled: "_$$FMTE^XLFDT((9999999-APCHD))_"     Expired on: "_$$FMTE^XLFDT($P(APCHZ,U,10)) D S^APCHPWH1(X)
 ;I $D(APCHMED(3)) D
 ;.D S^APCHPWH1("==========",1)
 ;.D S^APCHPWH1("These medications have been stopped.  You should not take these")
 ;.D S^APCHPWH1("medications.  Talk to your pharmacist about ways to safely get rid")
 ;.D S^APCHPWH1("of these medications if you have them at home.")
 ;.D S^APCHPWH1(" ")
 ;.S APCHN="" F  S APCHN=$O(APCHMED(3,APCHN)) Q:APCHN=""  D
 ;..S APCHI=0 F  S APCHI=$O(APCHMED(3,APCHN,APCHI)) Q:APCHI'=+APCHI  D
 ;...S APCHD=0 F  S APCHD=$O(APCHMED(3,APCHN,APCHI,APCHD)) Q:APCHD'=+APCHD  D
 ;....S Z=APCHMED(3,APCHN,APCHI,APCHD)
 ;....S APCHC=APCHC+1
 ;....S X="",$E(X,1)=APCHC_".",$E(X,7)=APCHN,$E(X,47)=$S($P(Z,U,6)]"":"Rx#: "_$P(Z,U,6),1:""),$E(X,61)=$S($P(Z,U,7)]"":"Refills left: "_$P(Z,U,7),1:"") D S^APCHPWH1(X,1)
 ;....;S X="",$E(X,7)="Directions: "_$P(Z,U,8) D S^APCHPWH1(X)
 ;....K ^UTILITY($J,"W") S X=$P(Z,U,8),DIWL=0,DIWR=58 D ^DIWP
 ;....S X="",$E(X,7)="Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S^APCHPWH1(X)
 ;....I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,19)=$G(^UTILITY($J,"W",0,F,0)) D S^APCHPWH1(X)
 ;....K ^UTILITY($J,"W")
 ;....S X="",$E(X,7)="Discontinued on: "_$$FMTE^XLFDT($P(Z,U,12)) D S^APCHPWH1(X)
 Q
 ;
SET1 ;
 S $P(APCHMED(Z,N,D,X),U,6)=$P($G(^AUPNVMED(M,11)),U,2)
 S $P(APCHMED(Z,N,D,X),U,8)=$P(^AUPNVMED(M,0),U,5)
 S $P(APCHMED(Z,N,D,X),U,7)=$P($G(^AUPNVMED(M,11)),U,7)
 Q
SET ;
 S $P(APCHMED(Z,N,D,X),U,6)=$P(^PSRX(APCHRXN,0),U)
 S $P(APCHMED(Z,N,D,X),U,8)=$P(^AUPNVMED(M,0),U,5)
 S APCHSRX=APCHRXN,APCHSREF=0 D REF^APCHS7O S $P(APCHMED(Z,N,D,X),U,7)=APCHSREF
 Q
HOLD(S) ;EP - is this prescription on hold?
 NEW X
 S X=$P($G(^PSRX(S,"STA")),U,1)
 I X=3 Q 1
 ;I X=5 Q 1
 ;I X=16 Q 1
 ;version 6
 S X=$P($G(^PSRX(S,0)),U,15)
 I X=3 Q 1
 ;I X=5 Q 1
 ;I X=16 Q 1
 Q 0
