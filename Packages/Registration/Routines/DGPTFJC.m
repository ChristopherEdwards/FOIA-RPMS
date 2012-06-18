DGPTFJC ;ALB/JDS - CLOSED PTF ; 3/14/85
 ;;5.3;Registration;**158**;Aug 13, 1993
101 W !,"Enter '^N' for Screen N, RETURN for <MAS>,'^' to Abort: <MAS>//"
 D READ G Q^DGPTF:X=U,^DGPTFM:X="",^DGPTFJ:X?1"^".E D H G 101
 ;
H D HELP^DGPTFJ W ! Q
 ;
MAS W !!,"Enter '^N' for Screen N, RETURN for <",DGNUM,">,'^' to Abort: <",DGNUM,">//"
 D READ G Q^DGPTF:X=U,^DGPTFJ:X?1"^".E
 I X="" S (ST,ST1)=J+2 G @($S($D(DGZDIAG):"NDG",$D(DGZSER):"NSR",$D(DGZPRO):"NPR",1:"DONE")_"^DGPTFM")
 D H G MAS
 ;
401 S DGNUM=$S($D(S(DGZS0+1)):401_"-"_(DGZS0+1),1:"MAS")
 W !,"Enter '^N' for Screen N, RETURN for <",DGNUM,">,'^' to Abort: <",DGNUM,">//"
 D READ G Q^DGPTF:X=U,NEXM^DGPTFM5:X="",^DGPTFJ:X?1"^".E D H G 401
 ;
501 W !,"Enter '^N' for Screen N, RETURN for <",DGNUM,">,'^' to Abort: <",DGNUM,">//"
 D READ G Q^DGPTF:X=U,NEXM^DGPTFM4:X="",^DGPTFJ:X?1"^".E D H G 501
 ;
601 W !,"Enter '^N' for Screen N, RETURN for <",DGNUM,">,'^' to Abort: <",DGNUM,">//"
 D READ G Q^DGPTF:X=U,NEXP^DGPTFM6:X="",^DGPTFJ:X?1"^".E D H G 601
 ;
701 ;
 G ACT1^DGPTF41 ; new code
 ;
READ ; -- read X
 R X:DTIME S:'$T X="^",DGPTOUT=""
 Q
 ;
EN S K=$S($D(K):K,1:1),DGER=0 I $P(^ICD9(+Y,0),U,9) S DGER=1 Q
 I $P(^(0),U,10)]""&($P(^(0),U,10)'=$S($D(^DPT(+^DGPT(DA(1),0),0)):$P(^(0),U,2),1:"M")) W:K<24 !,$P(^ICD9(+Y,0),U)," can only be used with ",$S($P(^(0),U,10)="F":"FEMALES",1:"MALES") S K=K+1,DGER=1 Q
 S %=$P(^DGPT(DA(1),"M",DA,0),U,DGI) I $D(^DGPT(DA(1),"M","AC",Y,DA)),%'=Y S DGER=1 Q
 F I=0:0 S I=$O(^ICD9(+Y,"N",I)) Q:I'>0  I $D(^DGPT(DA(1),"M","AC",I,DA)),%'=I W !,"Cannot use ",$S($D(^ICD9(+Y,0)):$P(^(0),U),1:""),"  with ",$S($D(^ICD9(I,0)):$P(^(0),U),1:"") S DGER=1 Q
 Q:DGER  S DG1=1 F I=0:0 S I=$O(^ICD9(+Y,"R",I)) Q:I'>0  S DG1=0 I $D(^DGPT(DA(1),"M","AC",I,DA)),%'=I S DG1=1 Q
 I 'DG1 W !,$S($D(^ICD9(+Y,0)):$P(^(0),U),1:"")," requires additional code."
 Q
EN1 S K=$S($D(K):K,1:1),DGER=0,DGICD0=^ICD0(+Y,0) I $P(DGICD0,U,9) S DGER=1 Q
 I $P(DGICD0,U,10)]""&($P(DGICD0,U,10)'=$S($D(^DPT(+^DGPT(DA(1),0),0)):$P(^(0),U,2),1:"M")) W:K<24 !,$P(DGICD0,U)," can only be used with ",$S($P(DGICD0,U,10)="F":"FEMALES",1:"MALES") S K=K+1,DGER=1 Q
 S %=$P(^DGPT(DA(1),DGSB,DA,0),U,DGI) I $D(^DGPT(DA(1),DGSB,DGCR,Y,DA)),%'=Y S DGER=1 W !,"Cannot enter the same code more than once within a ",$S(DGSB="S":"401",1:"601")," transaction" Q
 F I=0:0 S I=$O(^ICD0(+Y,"N",I)) Q:I'>0  I $D(^DGPT(DA(1),DGSB,DGCR,I,DA)),%'=I W !,"Cannot use ",$P(DGICD0,U),"  with ",$S($D(^ICD0(I,0)):$P(^(0),U),1:"") S DGER=1 Q
 Q:DGER  S DG1=1 F I=0:0 S I=$O(^ICD0(+Y,"R",I)) Q:I'>0  S DG1=0 I $D(^DGPT(DA(1),DGSB,DGCR,I,DA)),%'=I S DG1=1 Q
 I 'DG1 W !,$P(DGICD0,U)," requires additional code."
 Q
EN2 S K=$S($D(K):K,1:1),DGER=0 I $P(^ICD0(+Y,0),U,9) S DGER=1 Q
 I $P(^(0),U,10)]""&($P(^(0),U,10)'=$S($D(^DPT(+^DGPT(DA,0),0)):$P(^(0),U,2),1:"M")) W:K<24 !,$P(^ICD0(+Y,0),U)," can only be used with ",$S($P(^(0),U,10)="F":"FEMALES",1:"MALES") S K=K+1,DGER=1 Q
 S L=$P($S($D(^DGPT((DA),"401P")):^("401P"),1:0),U,1,5),%=$P(L,U,DGI),L=$P(L,U,1,DGI-1)_U_$P(L,U,DGI+1,5) I L[Y S DGER=1 Q
 Q
EN3 S K=$S($D(K):K,1:1),DGER=0 I $P(^ICD9(+Y,0),U,9) S DGER=1 Q
 I DGI=1,$P(^(0),U,4) S DGER=1 Q
 I $P(^(0),U,10)]""&($P(^(0),U,10)'=$S($D(^DPT(+^DGPT(DA,0),0)):$P(^(0),U,2),1:"M")) W:K<24 !,$P(^ICD9(+Y,0),U)," can only be used with ",$S($P(^(0),U,10)="F":"FEMALES",1:"MALES") S K=K+1,DGER=1 Q
 S %=$S($D(^DGPT(DA,70)):^(70),1:""),%=U_$P(%,U,10)_U_$P(%,U,16,24)_U,$P(%,U,DGI+1)=U I %[(U_+Y_U) S DGER=1 Q
 F I=0:0 S I=$O(^ICD9(+Y,"N",I)) Q:I'>0  I %[(U_I_U) W !,"Cannot use ",$S($D(^ICD9(+Y,0)):$P(^(0),U),1:""),"  with ",$S($D(^ICD9(I,0)):$P(^(0),U),1:"") S DGER=1 Q
 Q:DGER  S DG1=1 F I=0:0 S I=$O(^ICD9(+Y,"R",I)) Q:I'>0  S DG1=0 I %[(U_I_U) S DG1=1 Q
 I 'DG1 W !,$S($D(^ICD9(+Y,0)):$P(^(0),U),1:"")," requires additional code."
