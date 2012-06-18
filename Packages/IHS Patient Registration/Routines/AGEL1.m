AGEL1 ; IHS/ASDS/EFG - Add/Edit Eligibility Information ;    
 ;;7.1;PATIENT REGISTRATION;**1,2,4**;JAN 31, 2007
 ;
ADD ;EP - PROMPT TO ADD DATA TO FLDS
 ;BEGIN NEW CODE IHS/SD/TPF AG*7.1*1 ITEM 12
 I '$D(AGELP("PDFN")) D  Q:+Y<0
 .K DIC,DIE,DIR
 .S DIC(0)="AEMQ"
 .S DIC="^AUPNPAT("
 .D ^DIC
 .I Y S AGELP("PDFN")=+Y
 ;END NEW CODE
 ;W ! I $D(AGELP("PDFN")),'AGELP("SAME") S DIC="^AUTTRLSH(",DIC(0)="AQEM",DIC("S")="I $P(^(0),U,2)]""""",DIC("A")="Select RELATIONSHIP to the POLICY HOLDER: " D ^DIC G ADD:+Y<1 S AGELP("RELSH")=+Y
 S Y=AGELP("Y"),AGV("X2")=AGELP("PH")_";"_$P(^AUPN3PPH(AGELP("PH"),0),U),AGEL("X3")="" D ^AGELE2X2
 S DIE="^AUPN3PPH(",DA=AGELP("PH"),DR=".02////^S X=AGELP(""PDFN"")" D ^DIE
 S:$D(AG("PH9")) $P(^AUPN3PPH(AGELP("PH"),0),U,9)=AG("PH9")
 S:$D(AG("PH11")) $P(^AUPN3PPH(AGELP("PH"),0),U,11)=AG("PH11")
 S:$D(AG("PH12")) $P(^AUPN3PPH(AGELP("PH"),0),U,12)=AG("PH12")
 S:$D(AG("PH13")) $P(^AUPN3PPH(AGELP("PH"),0),U,13)=AG("PH13")
 S:$D(AG("PH14")) $P(^AUPN3PPH(AGELP("PH"),0),U,14)=AG("PH14")
 K AG("PH9"),AG("PH11"),AG("PH12"),AG("PH13"),AG("PH14")
 I AGELP("MODE")="A" W ! S AGELP("FLDS")="1,2,3,4,5,6,7,8,9,10,11" D EDLOOP^AGEL0
 I '$D(AGELP("PDFN")) S AGELP("SAME")=1
 S Y=$S($D(AGELP("PDFN")):AGELP("PDFN"),1:$P(^AUPN3PPH(AGELP("PH"),0),U,2)) D @($S($P($G(AGELP("TYPE")),U)="PI":"VENT^AGEL3",1:"DENT^AGEL2"))
 I '$D(AGELP("PDFN"))!(AGELP("MODE")="E") S AGELP("SAME")=0 K AGELP("RELSH") Q
 I $P($G(^AUPN3PPH(AGELP("PH"),0)),U,2)]"",AGELP("PDFN")'=$P(^(0),U,2) S AGELP("SAME")=1,Y=$P(^(0),U,2) D @($S($P(AGELP("TYPE"),U)="PI":"VENT^AGEL3",1:"DENT^AGEL2"))
 S AGELP("SAME")=0,AGELP("MODE")="E" K AGELP("RELSH")
 Q
SCAN K DIC S DIC(0)="QZEAM",DIC="^DPT(" D ^DIC
 Q:Y<0
 I $D(DUOUT)!$D(DTOUT) S Y=-1 Q
 I +Y<0 S X=AGEL("X") G CHK
 S AGEL("Y")=Y
 W ! K DIR S DIR(0)="Y",DIR("B")="Y",DIR("A")="Is "_Y(0,0)_" the Policy Holder (Y/N)" D ^DIR K DIR
 G SCAN:$D(DUOUT)!$D(DTOUT)!(Y'=1)
 S Y=AGEL("Y"),(AGEL("X"),X)=$P(^DPT(+Y,0),U) D HIT G PADD2
PCHK ;EP - LOOK FOR NAME IN POLICY HOLDER FILE
 I AGELP("SAME") S Y=AGELP("PDFN")_U_$P(^DPT(DFN,0),U) D HIT G PADD2
 W !!,"No Hit Found in POLICY HOLDER file",!!,"Searching PATIENT file ...."
 K DIC S DIC="^DPT(",DIC(0)="EM" D ^DIC
 S AGEL("DR")="",X=AGEL("X")
 I Y=-1 W !!,"No Hit Found in PATIENT File for ",AGEL("X"),"!" W ! K DIR S DIR(0)="Y",DIR("A")="Want to SCAN the PATIENT DATA BASE using Different Names" D ^DIR K DIR G SCAN:Y=1 S X=AGEL("X") G CHK
 W "   ",$P(Y,U,2)
PAT ;
 ;BEGIN NEW CODE IHS/SD/TPF AG*7.1*1 ITEM 18
 N NOADD
 I $$ISMINOR^AGUTILS(DFN) D  I NOADD K NOADD Q
 .;IS IT SPECIFIC TO TYPE OF INSURER?
 .N INSNM,INSTYP
 .S NOADD=0
 .S INSNM=$P($G(^AUTNINS(AGELP("INS"),0)),U)
 .S INSTYP=$P($G(^AUTNINS(AGELP("INS"),2)),U)
 .I INSNM[("MEDICARE")!(INSNM[("RAILROAD RETIREMENT")) S NOADD=1
 .I INSTYP'="R" S NOADD=1
 .I AGELP("INS")=1 S NOADD=1
 .I NOADD W !,"A MINOR CANNOT BE THE POLICY HOLDER FOR "_$G(INSNM) H 3 Q
 K NOADD
 ;END NEW CODE
 S AGEL("Y")=Y W !!,"Is ",$P(Y,U,2)," the correct insured policy holder"
 S %=1 D YN^DICN I %<1 W *7 G PAT
 ;I %=1 S Y=AGEL("Y"),(AGEL("X"),X)=$P(^DPT(+Y,0),U) D HIT G PADD2
 I %=1 S Y=AGEL("Y"),(AGEL("X"),X)=$P($G(^DPT(+Y,0)),U) D HIT G PADD2  ;IHS/SD/TPF AG*7.1*4 NO IM
CHK K:X[""""!(X'?1U.UNP)!(X'[",")!(X?.E1","." ")!(X?.E1","." "1",".E)!($L(X,",")>3)!($L(X)>30)!($L(X)<3) X I $D(X) F L=1:0 S L=$F(X," ",L) Q:L=0  S:$E(X,L-2)?1P!($E(X,L)?1P)!(L>$L(X)) X=$E(X,1,L-2)_$E(X,L,99),L=L-1
 I '$D(X) W !!?10,"No Lookup Match Found, or Improper Format for New Entry" S Y=-1 Q
PADD W !!,"Do you wish to add ",X," as the Insured Policy Holder"
 S %=1 D YN^DICN I %'=1 K X S Y=-1 Q
PADD2 S DIC="^AUPN3PPH(",DIC(0)="L" K DD,DO D FILE^DICN Q:+Y<1
 S AGEL("Y")=Y,AGEL("X")=$P(Y,U,2)
 S DIE="^AUPN3PPH(",DR=AGEL("DR")_".03////"_AGELP("INS"),DA=+Y D ^DIE
 S X=AGEL("X"),Y=AGEL("Y")
 Q
HIT I $D(^DPT(+Y,0)) S X=$P(^(0),U),AGEL("DR")=+Y,AGEL("DR")=".02////"_AGEL("DR")_";.08////"_$P(^(0),U,2)_";.19////"_$P(^(0),U,3)_";"
 Q
