APSPMULT ;IHS/MSC/JDS - Multidivisional drug lookup support;07-Mar-2011 15:06;SM
 ;;7.0;IHS PHARMACY MODIFICATION;**1009,1010**;DEC 11, 2003
 ;
PRINT ;EP
 N PDIV
 S DIC="^PS(59,",DIC(0)="MEQA" D ^DIC Q:Y'>0  S PDIV=+Y
 S DIS(1)="I $$PRTSCRN^APSPMULT(D0,PDIV)"
 S DIC="^PSDRUG(",FLDS="[APSPMULTI]",BY=".01",DIPA("NUM")=1 D EN1^DIP
 Q
SCREEN(IEN,NEWSITE,ALWAYS) ;EP
 N DICR,DIVAL,PAT
 I '$G(ALWAYS) I $P($G(XQY0),U)="" Q 1   ;only for OR and PS options.
 ;S DFN=$G(DFN,$S($T(GETVAR^CIAVMEVT)]"":$$GETVAR^CIAVMEVT("PATIENT.ID.MRN",,"CONTEXT.PATIENT"),1:""))
 S PAT=$S($G(PSODFN):PSODFN,$G(DFN):DFN,$G(CIA("UID"))&($T(GETVAR^CIAVMEVT)]""):$$GETVAR^CIAVMEVT("PATIENT.ID.MRN",,"CONTEXT.PATIENT"),1:0)
 I $G(APSPMULT) Q 1  ;dont screen.
 I '$G(ALWAYS) I '$$GET^XPAR("ALL","APSP MULTI DRUG SCREEN OPTION",$P(XQY0,U)) Q 1
 N SITE I $G(PSOSITE) S SITE=PSOSITE
 I $G(NEWSITE) S SITE=NEWSITE
 I '$G(SITE) S SITE=$O(^PS(59,"D",+$G(DUZ(2)),"")) Q:'SITE 1
 I PAT,$P($G(^APSPCTRL(+$G(SITE,1),3)),U,21) I '$$ELIG(PAT,$P($G(^PSDRUG(IEN,9999999)),U,7)) Q 0  ;not on cost plan
 I '$$GET^XPAR("ALL","APSP RESTRICT DRUG BY OPT SITE") Q 1
 I '$O(^PSDRUG(IEN,9999999.41,0)) Q 1
 I $D(^PSDRUG(IEN,9999999.41,SITE)) Q 1
 Q 0
 ; Screen used for Division Report
PRTSCRN(DRUG,PDIV) ;EP
 Q ''$D(^PSDRUG(DRUG,9999999.41,PDIV))
ELIG(DFN,DRUGELIG) ;
 ;is this patient eligible for alternate cost plan.
 N ELIG
 I DRUGELIG="" Q 1
 S ELIG=$P($G(^AUPNPAT(+$G(DFN),11)),U,12) I ELIG="" Q 0
 I "I"=ELIG,DRUGELIG=1 Q 1
 I (DRUGELIG=0)&("DCP"[ELIG) Q 1
 Q 0
ALL ;postinit make all drugs alternate care plan
 K ^TMP("MSCPS",$J)
 F I=0:0 S I=$O(^PSDRUG(I)) Q:'I  S ^TMP("MSCPS",$J,50,I_",",9999999.07)=1
 D FILE^DIE("","^TMP(""MSCPS"",$J)")
 K ^TMP("MSCPS",$J)
 Q
TRANSFER ;Transfer from one division to other
 N DIC,TO,FROM,I,DINUM,%,CNT
 S DIC="^PS(59,",DIC(0)="MEQA",DIC("A")="Select FROM-> Site: " D ^DIC Q:Y'>0  S FROM=+Y
 S DIC="^PS(59,",DIC(0)="MEQA",DIC("A")="Select ->TO Site: ",DIC("S")="I FROM'=+Y" D ^DIC Q:Y'>0
 S TO=+Y,CNT=0
 W !,"Ok to continue" D YN^DICN Q:%'=1
 F I=0:0 S I=$O(^PSDRUG(I)) Q:'I  D
 .I '$D(^PSDRUG(I,9999999.41,FROM)) Q
 .I $D(^PSDRUG(I,9999999.41,TO)) Q
 .S DIC="^PSDRUG("_I_",9999999.41,",DIC(0)="LMN",X=TO,DA(1)=I,DINUM=TO N I D FILE^DICN S CNT=CNT+1
 W !,CNT," Drugs put in outpatient site"
 Q
PRATL(TRUE) ;ALTERNATE LIST
 N DHD
 S DIS(1)="I $P($G(^PSDRUG(+Y,9999999)),U,7)"_$S(TRUE:"=0",1:"=1")
 S DHD="Drugs Designated for Patients with "_$S(TRUE:"",1:"In")_"Eligible Status"
 S DIC="^PSDRUG(",FLDS="[APSPALT]",BY=".01",DIPA("NUM")=1,L=0 D EN1^DIP
 Q
REPT ;
 N DHD
 S %DT="AE",%DT("A")="Enter Report Month: " D ^%DT Q:Y'>0  S STDT=$E(Y,1,5)_"00",ENDT=$E(Y,1,5)_32
 S X=STDT X ^DD("DD") S MONTH=Y
 S DIR(0)="S^0:Eligible;1:InEligible",DIR("A")="Select Eligible/Ineligible" D ^DIR Q:X[U  S ELIG=+$G(Y)
 S DIC="^PSDRUG(",BY="@NUMBER",(FR,TO)=$O(^PSDRUG(0)),FLDS="D DEQUE^APSPMULT",DHD="[APSPMULTI HDR]" D EN1^DIP
 Q
DEQUE D PRINTM
 D PRINT1
 Q
PRINTM ;
 ;go through log for date range
 K ^TMP("PSMULTI",$J)
 F I=STDT:0 S I=$O(^PS(55,"AUDS",I)) Q:('I)!(I>ENDT)  F J=0:0 S J=$O(^PS(55,"AUDS",I,J)) Q:'J   F K=0:0 S K=$O(^PS(55,"AUDS",I,J,K)) Q:'K  D
 .S ZERO=$G(^PS(55,I,5,J,0)),OI=+$G(^(.2)),END=$P($G(^(2)),U,4),DATE=$P(ZERO,U,14) I END<ENDT D
 ..N T F L=0:0 S L=$O(^PS(55,J,5,K,11,L)) Q:'L  S ZERO=$G(^(L,0)) D
 ...I (ZERO<STDT)!(ZERO>ENDT) Q
 ...S DRIEN=+$P(ZERO,U,2) Q:($P($G(^PSDRUG(+DRIEN,9999999)),U,7)'=ELIG)  S DRUG=$P($G(^PSDRUG(DRIEN,0)),U),^TMP("PSMULTI",$J,"B",DRUG,DRIEN)=""
 ...S T=$G(^TMP("PSMULTI",$J,DRIEN))
 ...I '$G(T(DRIEN,K)) S $P(^(DRIEN),U,1)=T+1,T(DRIEN,K)=1
 ...S $P(^(DRIEN),U,2)=$P(T,U,2)+$P(ZERO,U,3)
 ;now go through prescriptions
 F I=STDT:0 S I=$O(^PSRX("AC",I)) Q:(('I)!(I>ENDT))  F J=0:0 S J=$O(^PSRX("AC",I,J)) Q:'J  D
 .S ZERO=$G(^PSRX(J,0)),TWO=$G(^(2)) Q:ZERO=""
 .S DRIEN=$P(ZERO,U,6) Q:($P($G(^PSDRUG(+DRIEN,9999999)),U,7)'=ELIG)
 .S D=$P(TWO,U,5) Q:'D  I D<STDT!(D>ENDT) Q
 .S DRUG=$P($G(^PSDRUG(DRIEN,0)),U),^TMP("PSMULTI",$J,"B",DRUG,DRIEN)=""
 .S T=$G(^TMP("PSMULTI",$J,DRIEN)),^(DRIEN)=(1+T)_U_($P(T,U,2)+$P(ZERO,U,7))
 Q
PRINT1 ;
 S A=""
 F  S A=$O(^TMP("PSMULTI",$J,"B",A)) Q:A=""  F I=0:0 S I=$O(^TMP("PSMULTI",$J,"B",A,I)) Q:'I  D
 .D N^DIO2 W:$X ! W A,?42,$J($P($G(^TMP("PSMULTI",$J,I)),U),6),?58,$J($P($G(^(I)),U,2),6)
 .;D N^DIO2
 I '$L($O(^TMP("PSMULTI",$J,"B",""))) D N^DIO2 W !,"No Activity During this Period",!
 Q
ADDIV ;Add/Remove from Division
 N DIC S DIC="^PS(59,",DIC(0)="MEQA" D ^DIC Q:Y'>0  S DIV=+Y
 N DIC S DIC="^PSDRUG(",DIC(0)="MEQA",DIC("W")="D W^APSPMULT" D ^DIC Q:Y'>0
 I $D(^PSDRUG(+Y,9999999.41,DIV)) W !,"This Drug is already in this division",!,"Do you wish to Delete"
 E  W !,"Add this Drug to the Divsion"
 D YN^DICN Q:%=-1  G ADDIV:%'=1
 S (DIC,DIK)="^PSDRUG("_(+Y)_",9999999.41,",DA=DIV,DA(1)=+Y
 I '$D(^PSDRUG(+Y,9999999.41,DIV)) D  G ADDIV
 .I '$D(^PSDRUG(+Y,9999999.41,0)) S ^(0)="50.999999941PA^^"
 .S (DINUM,X)=DIV S DIC(0)="L" D FILE^DICN
 D ^DIK
 G ADDIV
W ;
 N I F I=0:0 S I=$O(^PSDRUG(+Y,9999999.41,I)) Q:'I  W:$X>45 ! W ?45," ",$P($G(^PS(59,+I,0)),U)
 Q
EDITP ;Edit the parameter
 N MSC,DICR,DIVAL,DIR,X,Y
 S MSC=$$GET^XPAR("ALL","APSP RESTRICT DRUG BY OPT SITE"),MSC=$S(MSC:"Yes",1:"No")
 S DIR="Restrict Drug Selection Based on Outpatient Site"
 S DIR(0)="Y^",DIR("B")=MSC
 S DIR("A")="Restrict Drug Selection Based on Outpatient Site"
 D ^DIR Q:$G(DIRUT)
 D PUT^XPAR("SYS","APSP RESTRICT DRUG BY OPT SITE",1,Y)
 Q
SITE() ; return outpatient site
 N SITE
 I $G(PSOSITE) Q PSOSITE
 S SITE=$O(^PS(59,"D",+$G(DUZ(2)),"")) Q $S(SITE:SITE,1:+$O(^APSPCTRL(0)))
 Q
OI(OI,DFN) ;screen orderable item
 N DRUG,POI
 S POI=$P($G(^ORD(101.43,+OI,0)),U,2)
 I POI'[";99PSP" Q 1
 ;check if order has specific drug
 I $G(^OR(100,+$G(IFN),0)) D  I DRUG Q $$SCREEN(DRUG,,1)
 .S DRUG=0 N I F I=0:0 S I=$O(^OR(100,+$G(IFN),4.5,I)) Q:'I  I $P($G(^(I,0)),U,4)="DRUG" S DRUG=$G(^(1)) Q
 F DRUG=0:0 S DRUG=$O(^PSDRUG("ASP",+$G(POI),DRUG)) Q:'DRUG  I $$SCREEN(DRUG,,1) Q
 I 'DRUG Q 0
 Q 1
QUICK(IEN) ;EP-validate quick order
 N OI,DRUG
 S DRUG=+$O(^ORD(101.41,"B","OR GTX DISPENSE DRUG",0))
 S OI=+$O(^ORD(101.41,"B","OR GTX ORDERABLE ITEM",0))
 S DRUG=+$O(^ORD(101.41,IEN,6,"D",DRUG,0)) I DRUG D  I DRUG Q $$SCREEN(DRUG,,1)
 .S DRUG=+$G(^ORD(101.41,IEN,6,DRUG,1))
 S OI=+$O(^ORD(101.41,IEN,6,"D",OI,0)),OI=+$G(^ORD(101.41,IEN,6,+OI,1))
 Q $$OI(OI,$G(DFN))
