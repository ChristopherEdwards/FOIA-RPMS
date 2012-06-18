FHASM7	; HISC/REL - KCAL Distribution ;8/18/93  11:05
	;;5.0;Dietetics;;Oct 11, 1995
	S PRT=0,(ASN,NB)="" D ^FHASMR1
E31	R !!,"Do you want to do a NITROGEN BALANCE? NO// ",X:DTIME G:'$T!(X["^") KIL S:X="" X="N" D TR^FHASM1 I $P("YES",X,1)'="",$P("NO",X,1)'="" W *7," Answer YES or NO" G E31
	I $E(X,1)="N" G KIL:'DFN,E4
E32	R !!,"Enter Protein Intake (gm/24hr): ",X1:DTIME G KIL:'$T!(X1["^"),E35:X1=""
	I X1'?.N.1".".N!(X1<0)!(X1>200) W !?5,"Enter 0-200 grams of protein intake" G E32
E33	R !,"Enter Urinary Nitrogen Output (gm/24hr): ",X2:DTIME G KIL:'$T!(X2["^"),E35:X2=""
	I X2'?.N.1".".N!(X2<0)!(X2>30) W !?5,"Enter 0-30 gms of Urinary Nitrogen output (24 hr UUN)" G E33
E34	R !,"Enter Insensible Nitrogen Output (gm/24hr): 4// ",X3:DTIME S:X3="" X3=4 G:'$T!(X3["^") KIL
	I X3'?.N.1".".N!(X3<0)!(X3>10) W !?5,"Insensible Nitrogen output should be between 0-10 grams" G E34
	S NB=X1/6.25-(X2+X3),NB=$J(NB,0,0) W !,"Nitrogen Balance: ",NB
E35	G:'DFN KIL
E4	R !!,"Appearance: ",APP:DTIME G KIL^FHASM1:'$T!(APP["^")
	I APP["?"!(APP'?.ANP)!($L(APP)>60) W *7,!,"Enter Physical Appearance of patient; cannot exceed 60 characters." G E4
	W ! S DIC="^FH(115.3,",DIC(0)="AEQMZ" D ^DIC K DIC G KIL^FHASM1:X["^"!$D(DTOUT) S XD=$S(Y>0:+Y,1:"")
E5	W ! S DIC="^FH(115.4,",DIC(0)="AEQMZ",DIC("S")="I $P(^(0),U,2)'=""""" D ^DIC K DIC G KIL^FHASM1:X["^"!$D(DTOUT) S RC=$S(Y>0:+Y,1:"")
	W !!,"Comments:" K ^TMP("FH",$J) S DIC="^TMP(""FH"",$J,",DWPK=1 D EN^DIWE
E6	R !!,"Do you wish to FILE this Assessment Y// ",X:DTIME G:'$T!(X["^") KIL^FHASM1 S:X="" X="Y" D TR^FHASM1 I $P("YES",X,1)'="",$P("NO",X,1)'="" W *7,"  Answer YES or NO" G E6
	I X'?1"Y".E G KIL
	I '$D(^FHPT(DFN,0)) S ^(0)=DFN
	I '$D(^FHPT(DFN,"N",0)) S ^FHPT(DFN,"N",0)="^115.011D^^"
	K DIC,DD,DO S DIC="^FHPT(DFN,""N"",",DIC(0)="L",DLAYGO=115,DA(1)=DFN,X=ADT,DINUM=9999999-ADT D FILE^DICN S ASN=+Y
	D NOW^%DTC S NOW=%
	S Y=ADT_"^"_SEX_"^"_AGE_"^"_HGT_"^"_HGP_"^"_WGT_"^"_WGP_"^"_DWGT_"^"_UWGT_"^"_IBW_"^"_FRM_"^"_AMP_"^^^^"_KCAL_"^"_PRO_"^"_FLD_"^"_RC_"^"_XD_"^"_BMI_"^"_BMIP_"^"_DUZ_"^"_NOW_"^"_NB
	S ^FHPT(DFN,"N",ASN,0)=Y
	S:EXT="Y" ^FHPT(DFN,"N",ASN,1)=TSF_"^"_TSFP_"^"_SCA_"^"_SCAP_"^"_ACIR_"^"_ACIRP_"^"_CCIR_"^"_CCIRP_"^"_BFAMA_"^"_BFAMAP
	S:APP'="" ^FHPT(DFN,"N",ASN,2)=APP G:'$D(LRTST) E7
	S N1=0 F K=0:0 S K=$O(LRTST(K)) Q:K=""  S ^FHPT(DFN,"N",ASN,"L",K,0)=LRTST(K),N1=N1+1
	I N1,'$D(^FHPT(DFN,"N",ASN,"L",0)) S ^(0)="^115.021^^"
E7	G:'$D(^TMP("FH",$J)) E8
	S ^FHPT(DFN,"N",ASN,"X",0)=^TMP("FH",$J,0)
	S N1=0 F K=0:0 S K=$O(^TMP("FH",$J,K)) Q:K'>0  S N1=N1+1,^FHPT(DFN,"N",ASN,"X",N1,0)=^TMP("FH",$J,K,0)
E8	S DTE=ADT,S1=1,S2="I",S3=$S('RC:"",1:"Nutrition Status: "_$P(^FH(115.4,RC,0),"^",2))
	D FIL^FHASE3 I 'RC G E9
	I '$D(^FHPT(DFN,"S",0)) S ^(0)="^115.012D^^"
	K DIC,DD,DO S DIC="^FHPT(DFN,""S"",",DIC(0)="L",DLAYGO=115,DA(1)=DFN,X=ADT,DINUM=9999999-ADT D FILE^DICN S ASE=+Y
	D DID^FHDPA S $P(^FHPT(DFN,"S",ASE,0),"^",2,3)=RC_"^"_DUZ S:FHWRD $P(^(0),"^",6)=FHWRD
E9	G P0^FHASMR
KIL	G KIL^FHASMR
