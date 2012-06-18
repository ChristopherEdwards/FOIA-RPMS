AMQQAV2 ; IHS/CMI/THL - MORE OVERFLOW FROM AMQQAV ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
COMPT ; ENTRY POINT FROM AMQQAV
 I AMQQNOCO>1 D COMPT2 Q
 I $D(AMQQXX) G COMPT1
 R !,?(5*$D(AMQQZNM)),"Titre: ",X:DTIME E  S AMQQQUIT="" Q
 I X?1."?" W !!,"Enter a titre to be used as the comparison value (e.g. NEGATIVE, 1:64 etc.)",!! G COMPT
 I X=U S AMQQQUIT="" Q
 I X="" Q
COMPT1 I X=0,AMQQSQBS="<" Q:$D(AMQQXX)  W "  ??",*7 G COMPT
 I X?1"1:"1.5N S X=$P(X,":",2)
 I X=1,AMQQSQBS="<",$D(AMQQSQNT) K AMQQSQNT S AMQQSQBS="=",X="POSITIVE"
 I X=1,AMQQSQBS=">",$D(AMQQSQNT) K AMQQSQNT S AMQQSQBS="<",X="POSITIVE"
 I X=+X,X>0 G CN
 I $G(AMQQSQBS)'="<",$E("NEGATIVE",1,$L(X))=X W:'$D(AMQQXX) $E("NEGATIVE",$L(X)+1,8) S X=0 G CN
 I $G(AMQQSQBS)="<"!($G(AMQQSQNM)="IS NOT"),$E("POSITIVE",1,$L(X))=X W:'$D(AMQQXX) $E("POSITIVE",$L(X)+1,8) K AMQQSQNT S X=0,AMQQSQBS="=",AMQQSQF1="EQUAL",AMQQSQF2="AMQQF",AMQQSQN=211,AMQQSQNM="IS" G CN
 I $G(AMQQSQBS)="=",$E("POSITIVE",1,$L(X))=X W:'$D(AMQQXX) $E("POSITIVE",$L(X)+1,8) S X=0,AMQQSQF1="GRT",AMQQSQF2="AMQQF",AMQQSQBS=">",AMQQSQNM="GREATER THAN",AMQQSQN=209 G CN
 I X'?1.5N Q:$D(AMQQXX)  W "  ??",*7 G COMPT
 I '$D(AMQQXX) W " (1:",X,")"
CN S AMQQCOMP=X
 Q
 ;
COMPT2 I $D(AMQQXX) N Z S Z=X,X=$P(X,";") G COMPT21
 R !,?(5*$D(AMQQZNM)),"Enter the lower titre: ",X:DTIME E  S AMQQQUIT="" Q
COMPT21 I X="" S AMQQCOMP="" Q
 I X=U S AMQQQUIT="" Q
 I X?1."?" W !,"Enter a titre (e.g. 'NEGATIVE', '1:64', etc.)",!!! G COMPT2
 I X?1"1:"1.5N S X=$P(X,":",2) G N
 I $E("NEGATIVE",1,$L(X))=X W $E("NEGATIVE",$L(X)+1,8) S X=0 G N
 I X'?1.5N W "  ??",*7 G COMPT2
 W " (1:",X,")"
N S AMQQCOMP=X_";"
 I $D(AMQQXX) S AMQQXX=$P(Z,";",2) G N21
N2 R !,?(5*$D(AMQQZNM)),"Enter the upper titre: ",X:DTIME E  S AMQQQUIT="" Q
N21 I X="" S AMQQCOMP="" Q
 I X?1."?" W !,"Enter a titre (e.g. 'NEGATIVE', '1:64', etc.)",!!! G COMPT2
 I X=U S AMQQQUIT="" Q
 I X?1"1:"1.5N S X=$P(X,":",2) I X'<+AMQQCOMP G CN2
 I X'?1.5N!(X<+AMQQCOMP) W "  ??",*7 G COMPT2
 W " (1:",X,")"
CN2 S AMQQCOMP=AMQQCOMP_X
 Q
 ;
COMPV ; ENTRY POINT FROM AMQQAV
 I AMQQNOCO=2 D COMPV2 Q
COMPV1 E  W !,"Visual acuity: 20/" R X:DTIME E  S X=U
 I $E(X)=U S AMQQQUIT="" Q
 I X="" S AMQQCOMP="" Q
 I X="BLIND" S AMQQCOMP=999 Q
 I X?1."?" W !!,"Enter a Snellen Chart acuity like '20/40' or the word 'BLIND'",!! G COMPV
 I X?1.3N,X,'(X#5) S AMQQCOMP=X Q
 W "  ??",*7 G COMPV1
 ;
COMPV2 W !!,"Enter the BEST visual acuity allowed in the range =>"
 D COMPV1
 G:AMQQCOMP="" COMPVEXT
 S AMQQCOM1=AMQQCOMP
 W !!,"Enter the WORST visual acuity allowed in the range =>"
 D COMPV1
 G:AMQQCOMP="" COMPVEXT
 S AMQQCOM2=AMQQCOMP
 I AMQQCOM1>AMQQCOM2 W "  ??",*7,!,"The 'worst' value cannot be smaller than the 'best'!" G COMPV2
 S AMQQCOMP=AMQQCOM1_";"_AMQQCOM2
COMPVEXT K AMQQCOM1,AMQQCOM2
 Q
 ;
