PSIVOREN ;BIR/MLM-UTILITIES FOR IV FLUIDS - OE/RR INTERFACE ; 25 Sep 98 / 2:00 PM
 ;;5.0; INPATIENT MEDICATIONS ;**3,18,69**;16 DEC 97
 ;
 ; Reference to ^PS(55 is supported by DBIA 2191.
 ; Reference to ^VA(200 is supported by DBIA 10060.
 ; Reference to ^DIE is suppoted by DBIA 10018.
 ;
ENCPP ; Check Package Parameter
 D ORPARM I 'PSJORF W !!,"Inpatient Medications is not turned on for OE/RR.",!,"You will not be able to enter or edit IV or Unit Dose orders."
 I 'PSJIVORF W !!,"IV Medications is not turned on for OE/RR.",!,"You will not be able to enter or edit IV orders."
 I 'PSJORF!'PSJIVORF S PSJIVORF="" D DONE^PSIVORA1 Q
 S PSJORL=ORL,PSJORPF=0,P("OT")="F^",PSJORNP=ORNP
 ;; S PSJORL=ORL,PSJORPF=0,P("OT")="F^"_$O(^ORD(101,"B","PSJI OR PAT FLUID OE",0))_";ORD(101,",PSJORNP=ORNP
 Q
 ;
PS ; Check if MD is authorized to write med. orders.
 S PSJORPF=0 S:PSJORNP X=$G(^VA(200,+PSJORNP,"PS")) Q:$S('PSJORNP:0,'X:0,'$P(X,U,4):1,$P(X,U,4)>DT:1,1:0)  D
 .W !?2,"(The selected PROVIDER is NOT qualified to write MEDICATION orders.  You must",!,"select a valid provider to be able to continue with Inpatient Medications.)"
 .K DIC S DIC="^VA(200,",DIC(0)="AEMQZ",DIC("A")="Select PHARMACY PROVIDER: ",DIC("S")="S PSIV=$G(^(""PS"")) I PSIV,$S($P(PSIV,""^"",4)="""":1,DT<$P(PSIV,""^"",4):1,1:0)" F  W ! D ^DIC Q:$D(DUOUT)!$D(DTOUT)!(Y>0)  W $C(7),"  (Required.)"
 .K DIC S:Y'>0 PSJORPF=11 S:Y>0 (ORNP,PSJORNP)=+Y Q
 Q
 ;
RUPDATE(DFN,ON,NSTRT) ;
 ; Update renewal orders (called from Pharmacy options).
 N DA,DIE,DR,ND,NSTOP,ORETURN,PSIVACT,PSIVAL,PSIVALCK,PSJOSTRT S DIE="^PS(55,"_DFN_","
 ;*I ON["V" S X=$G(^PS(55,DFN,"IV",+ON,2)),OLDON=$P(X,U,5),PSJOSTRT=$P(X,U,7),OSTOP=$P($G(^(0)),U,3),DIE=DIE_"""IV"",",DR=$S(ON["V":"100///R",1:""),PSIVACT=1
 ;*I ON'["V" S OLDON=$P($G(^PS(55,DFN,5,ON,0)),U,24),X=$G(^(2)),PSJOSTRT=$P(X,U,7),OSTOP=$P(X,U,4),DIE=DIE_"5,"
 I ON["V" S OLDON=$P($G(^PS(55,DFN,"IV",+ON,2)),U,5)
 I ON'["V" S OLDON=$P($G(^PS(55,DFN,5,+ON,0)),U,25)
 I OLDON["P" S OLDON=$P($G(^PS(53.1,+OLDON,0)),U,25)
 I OLDON["V" S X=$G(^PS(55,DFN,"IV",+OLDON,2)),PSJOSTRT=$P(X,U,7),OSTOP=$P($G(^(0)),U,3),DIE=DIE_"""IV"",",DR=$S(ON["V":"100///R",1:""),PSIVACT=1
 I OLDON["U" S X=$G(^PS(55,DFN,5,+OLDON,2)),PSJOSTRT=$P(X,U,7),OSTOP=$P(X,U,4),DIE=DIE_"5,"
 S NSTOP=+$S(NSTRT>OSTOP:OSTOP,1:NSTRT),DA=+OLDON,DA(1)=DFN
 S:NSTOP'=OSTOP DR=DR_";"_$S(ON["V":.03,1:34)_"////"_NSTOP_$S('PSJOSTRT:";"_$S(ON["V":116,1:70)_"////"_OSTOP,1:"") D ^DIE
 I OLDON["V" S (ON,ON55)=OLDON,PSIVAL="",PSIVALCK="STOP",(P("FRES"),PSIVREA)="R" D LOG^PSIVORAL
 D:'$D(PSJIVORF) ORPARM Q:'PSJIVORF
 ;* K ORETURN S:NSTOP'=OSTOP ORETURN("ORSTOP")=NSTOP,ORETURN("OREVENT")=NSTOP_";E" D RUPTXT(DFN,OLDON)
 Q
 ;
RUPTXT(DFN,OLDON) ;
 ;Update ORTX( in OE/RR
 I OLDON'["V" ;; D ENUDTX^PSJOREN(DFN,OLDON,"OR") S ORIFN=$P($G(^PS(55,DFN,"IV",+OLDON,0)),U,21)
 I OLDON["V" S P("FRES")="R" D GTPC^PSIVORFB(OLDON),SORTX^PSIVORFE S ORIFN=$P($G(^PS(55,DFN,"IV",+OLDON,0)),U,21)
 ;; F X=0:0 S X=$O(ORTX(X)) Q:'X  S ORETURN("ORTX",X)=ORTX(X)
 Q
 ;
ORPARM ;Check if inpatient pkges are on.
 S (PSJORF,PSJIVORF)=1
 Q
 ;
NATURE ; Ask nature of order.
 I '+$G(PSJSYSU) S P("NAT")="W" Q
 K P("NAT") NEW X
 I $D(XQORNOD(0)) S X=$E($P(XQORNOD(0),U,3),1,1) S:X="" X="E"
 ;* S:'$D(X) X="N" S:X="A" X="E"
 S:'$D(X) X="N" S:"AF"[X X="E"
 S P("NAT")=$$ENNOO^PSJUTL5(X)
 K:P("NAT")=-1 P("NAT")
 Q
CLINIC ;Ask clinic where outpt is being seen for DSS
 K P("CLIN") NEW X1,X2,X,PSJDT,DIC,Y
 S X1=DT,X2=-7 D C^%DTC S PSJDT=X
 S DIC("S")="I $P($G(^SC(Y,0)),U,3)=""C"",$S('$P($G(^(""I"")),U):1,($P($G(^(""I"")),U)>PSJDT):1,(($P($G(^(""I"")),U)<PSJDT)&($P($G(^(""I"")),U,2)]"""")&(DT>$P($G(^(""I"")),U,2))):1,1:0)"
 S DIC=44,DIC(0)="QEAZ",DIC("A")="Select CLINIC LOCATION: " D ^DIC
 I $S($D(DTOUT):1,$D(DUOUT):1,1:0) Q
 S:+Y>0 P("CLIN")=+Y,^PS(55,DFN,"IV",+ON55,"DSS")=+Y
 Q
