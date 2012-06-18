IBCCPT	;ALB/LDB/AAS - MCCR OUTPATIENT VISITS LISTING CONT. ; 29 MAY 90
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRCPT
	;
	K DIR
EN	D:$D(DIR) HLP W @IOF S DGU=0 K DGCPT,^UTILITY($J) D VST
	D CHDR,WRNO
	S (DGCNT,DGCNT1)=0 F  S DGCNT=$O(^UTILITY($J,"CPT-CNT",DGCNT)) Q:'DGCNT  S DGNOD=^(DGCNT),DGCPT=+DGNOD,DGDAT=$P(DGNOD,"^",2),DGBIL=$P(DGNOD,"^",3),DGASC=$P(DGNOD,"^",4),DGDIV=$P(DGNOD,"^",5),DGCNT1=DGCNT1+1 D CPRT I DGU="^" S DGCNT=DGCNT-1 Q
	I DGU'="^" F Y=$Y:1:IOSL-6 W !
OK1	K Y Q:'$D(^UTILITY($J,"CPT-CNT"))!($D(DIR))
	;OKS DIR(0)="LAO^1:"_DGCNT_"^Q:DGU=""^""",DIR("?")="^D EN^IBCCPT",DIR("A")="SELECT CPT CODE(S) TO INCLUDE IN THIS BILL: "
OK	S DIR(0)="LAO^1:"_DGCNT1_"^K:X[""."" X",DIR("?")="^D EN^IBCCPT",DIR("A")="SELECT CPT CODE(S) TO INCLUDE IN THIS BILL: "
	D ^DIR I 'Y D Q1^IBCOPV1 Q
	S IBFT=+$P(^DGCR(399,IBIFN,0),"^",19)
OK2	W !,"YOU HAVE SELECTED CPT CODE(S) NUMBERED-",$E(Y,1,$L(Y)-1),!,"IS THIS CORRECT" S %=1 D YN^DICN I %=-1 S IBOUT=1 D Q^IBCOPV1 Q
	I +Y,'% W !,"Respond 'Y'es to include these codes in the bill.",!,"Respond 'N'o to reselect." G OK2
	I +Y,%=2 G OK
	;
FILE	S DGCPT1=Y,(DGCNT,DGCNT2)=0
	S DIE="^DGCR(399,",DA=IBIFN,DR=".09///4" D ^DIE K DR,DA,DIE
	S:'$D(^DGCR(399,IBIFN,"CP",0)) ^DGCR(399,IBIFN,"CP",0)="^399.0304AVI"
	F I9=1:1 S I1=$P(DGCPT1,",",I9) Q:'I1  I $D(^UTILITY($J,"CPT-CNT",I1)) S DGNOD=^(I1) D FILE1
	D Q1^IBCOPV1 Q
	;
FILE1	;  file procedures, if BASC, only for 1 visit date
	K DGNOADD S (X,DINUM)=$P(DGNOD,"^",2) D VFILE1^IBCOPV1 K DINUM,X
	I $D(DGNOADD) W !?10,"Can't add Amb. Surg. ",$P(^ICPT(+DGNOD,0),"^")," without visit date!" Q  ;don't add cpt for date that can't go on bill
	I IBFT'=2,+$P(DGNOD,"^",4),$$TOMANY($P(DGNOD,"^",2)) W !?10,"Can't add Billable Amb. Surg. ",$P(^ICPT(+DGNOD,0),"^")," when more than one visit date!",*7 Q
	W !?4,"Adding CPT Procedure: ",$P(^ICPT(+DGNOD,0),"^")
	S DA(1)=IBIFN,DIC="^DGCR(399,"_DA(1)_",""CP"",",DIC(0)="L",X=+DGNOD_";ICPT(" K DD,DO D FILE^DICN S DA=+Y
	S DR="1///"_$P(DGNOD,"^",2)_$S('$P(DGNOD,"^",4):"",1:";5////"_$P(DGNOD,"^",5))
	S:IBFT=2 DR=DR_";8;9;D DISP1^IBCSC4D("_IBIFN_");10;S:X="""" Y=""@99"";11;S:X="""" Y=""@99"";12;S:X="""" Y=""@99"";13;@99"
	S DIE=DIC D ^DIE
	L ^DGCR(399,IBIFN):1
	K DIE,DIC,DR,DA
	Q
CPRT	D:$Y+6>IOSL SCR Q:DGU="^"
	I $D(^ICPT(DGCPT,0)) W !,DGCNT,")",?5,$P(^(0),"^"),?13,$S(DGASC:"YES",1:""),?20,$E($P(^(0),"^",2),1,28),?50 S Y=DGDAT D DT^DIQ I DGBIL W ?64,"  *ON THIS BILL*"
	Q
CHDR	W @IOF,!,?15,"<<CURRENT PROCEDURAL TERMINOLOGY CODES>>",!!,?10,"LISTING FROM VISIT DATES WITH ASSOCIATED CPT CODES",!,?22,"IN SCHEDULING VISITS FILE",!
	S L="",$P(L,"=",80)="" W !,L,!,"NO.",?5,"CODE",?13,"BASC",?20,"SHORT NAME",?50,"PROCEDURE DATE",!,L,! K L Q
VST	S DGCNT=0 I $O(^DGCR(399,IBIFN,"OP",0)) F V=0:0 S V=$O(^DGCR(399,IBIFN,"OP",V)) Q:'V  S (IBOPV1,IBOPV2)=V D ASC
	Q:$O(^DGCR(399,IBIFN,"OP",0))
	S IBOPV1=$P(^DGCR(399,IBIFN,"U"),"^"),IBOPV2=$P(^("U"),"^",2)
	D ASC
	Q
WRNO	W:'$O(^UTILITY($J,"CPT-CNT",0)) !,"NO CPT CODES IN SCHEDULING VISITS FILE FOR THE ",$S($O(^DGCR(399,IBIFN,"OP",0)):"VISIT DATES ON THIS BILL",1:"PERIOD THAT THIS STATEMENT COVERS")
	Q
SCR	Q:DGU="^"  I $E(IOST,1,2)["C-",$Y+6>IOSL F Y=$Y:1:IOSL-5 W !
	I  R !,"Press return to continue or ""^"" to exit display ",DGU:DTIME D:DGU'="^" CHDR
	Q
HLP	W !!,"Enter a number between 1 and ",DGCNT1," or a range of numbers separated with commas",!,"or dashes, e.g., 1,3,5 or 2-4,8"
	W !,"The number(s) must appear as a selectable number in the sequential list." R H:5 K H Q
CPT	S DA(1)=IBIFN,IBCCPTZ=$P(^DGCR(399,DA(1),0),U,9),IBCCPTX=$S($D(^DGCR(399,DA(1),"C"))&IBCCPTZ:1,1:0)
	K DIK,DGTE,I1 Q
	;
ASC	;  -find ambulatory procedures, flag if billable
	;  -  ^utility($j,cpt-cnt,count)=code^date^already on bill^is BASC^divis
	;
	F I=IBOPV1:0 S I=$O(^SDV("C",DFN,I)) Q:'I!(I>(IBOPV2+.99))  I $D(^SDV(I,0)) S DGDIV=$P(^(0),"^",3) D
	.F I1=0:0 S I1=$O(^SDV(I,"CS",I1)) Q:'I1  I $D(^(I1,0)) S DGNOD=^(0) I $D(^("PR")),$$DSP^IBEFUNC($P(DGNOD,"^",5),I) S DGCPTS=^SDV(I,"CS",I1,"PR"),I7=$P(I,".") I DGCPTS'="" D
	..S:'$D(^UTILITY($J,"CPT",I,0)) ^(0)="Y"
	..F I2=1:1:5 S DGCPT=$P(DGCPTS,"^",I2) I DGCPT'="" S DGCNT=DGCNT+1 S ^UTILITY($J,"CPT-CNT",DGCNT)=DGCPT_"^"_I7_"^"_$S($D(^DGCR(399,IBIFN,"CP","B",DGCPT_";ICPT(")):1,1:"")_"^"_$S(+$$CPTCHG^IBEFUNC1(DGCPT,DGDIV,I7):1,1:0)_"^"_DGDIV
	Q
TOMANY(DATE)	;  - returns 1 if more than 1 visit date on bill (for basc)
	G TOMANYQ:'$D(DATE)
	S DGVCNT=+$P($G(^DGCR(399,IBIFN,"OP",0)),"^",4)
	I DGVCNT>1!(DGVCNT=1&('$D(^DGCR(399,IBIFN,"OP",DATE)))) K DGVCNT Q 1
TOMANYQ	Q 0
