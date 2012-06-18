AMQQEM31 ; IHS/CMI/THL - AMQQEM3 OVERFLOW ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
T5 ; EP FROM AMQQEM3 ; THIS SUBROUTINE HAS BEEN MOVED FROM AMQQEM3
 S %=$$KEYCHECK^AMQQUTIL("AMQQZPROG")
 I '% W !,"Sorry.  This option requires a Q-Man Programmer Access Key.  Check with your site manager.",!!,*7 H 2 Q
 W "MUMPS TRANSFORM",!
 I '$D(@G@(AMQQEMN,3)) G T51
 W *7,"This field already has the following transform: "
 W !,@G@(AMQQEMN,3)
 S DIR(0)="S^R:REPLACE THE OLD TRANSFORM WITH A NEW ONE;D:DELETE THE TRANSFORM"
 S DIR("A")="     Your choice"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I "^"[X Q
 I X?2."?" S AMQQQUIT="" Q
 I Y="D" K @G@(AMQQEMN,3) Q
T51 D DIR^AMQQEM31
 S DIR(0)="FO^:"
 S DIR("A")="Enter MUMPS code"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I "^"[X Q
 I X="^^" S AMQQQUIT="" Q
 D ^DIM
 I '$D(X) W "  ??",*7 Q
 S @G@(AMQQEMN,3)=X
 Q
 ;
T6 ; EP FROM AMQQEM3
 W "CHANGE FIELD LENGTH",!
 W "Current field length: ",$S($D(AMQQFLEN):AMQQFLEN,'$P(@G@(AMQQEMN,0),U,7):AMQQEM("FIX"),1:$P(@G@(AMQQEMN,0),U,7))
 S DIR(0)="NO"
 S DIR("A")="New field length"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I "^"[X Q
 I X?2."^" S AMQQQUIT="" Q
 I $D(AMQQFLEN) S AMQQFLEN=Y
 S $P(@G@(AMQQEMN,0),U,7)=Y
 Q
 ;
T8 ; EP FROM AMQQEM3
 W "USE QUOTATION MARKS",!
 S DIR(0)="Y"
 S DIR("A")="Sure you want to put quotation marks around each entry in the field"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U!('Y) Q
 I X?2.U S AMQQQUIT="" Q
 S %=$G(@G@(1,2))
 S:%'="" %=%_" "
 S %=%_"S X=$C(34)_X_$C(34)"
 S @G@(1,2)=%
 Q
 ;
T7 ; EP FROM AMQQEM3
 W "SUBSTITUTE FOR DELIMITER CHARACTER",!
S1 S DIR(0)="F^:"
 S DIR("A")="Enter the substitute character for the PATIENT NAME field"
 S DIR("?")="Must be 1 'punctuation' character such as '_' or ';'"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT)!$D(DTOUT) K DTOUT,DIRUT,DIROUT,DUOUT
 I X=U Q
 I X?2."^" S AMQQQUIT="" Q
 I Y'?1P!(Y=",") W "  ??",*7 G S1
 S %=$G(@G@(1,2))
 S:%'="" %=%_" "
 S %=%_"S X=$P(X,"","")_"""_Y_"""_$P(X,"","",2)"
 S @G@(1,2)=%
 Q
 ;
DIR ; -ENTRY POINT - DIR SETUP FROM T51^AMQQEM3 (OVERFLOW FROM THAT RTN)
 S DIR("?")="Enter the MUMPS code which will transform the value of the field/variable.  When the MUMPS code is executed, the variable ""X"" will contain the value to be transformed; e.g., S X=$P(X,"","",1)"
 Q
 ;
FLEN ; EP FROM AMQQEM3 ; FIELD LENGTH
 I $D(AMQQFEDT) Q
 N Y,I,N,%,T,A,B,C
 S %=$P(AMQQEMFS,(U_AMQQEMN_U))
 S A=0
 F I=1:1 S B=$P(%,U,I) Q:B=""  S A=A+$P(^UTILITY("AMQQ",$J,"FLAT",B,0),U,7)+1
 S %=AMQQEM("LEN")-A
 S C=$S(%>AMQQEM("MLEN"):AMQQEM("MLEN"),1:%)
 I C<1 W !!,"Sorry, no more room!  You must edit a previously selected field or quit",*7,!! S AMQQSTOP=U H 3 Q
FLEN1 W !!
 S DIR(0)="NO^1:"_C
 S DIR("A")="Enter the length of this field"
 S DIR("?")="Must not exceed maximum field length"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I Y?2."^" S AMQQQUIT="" Q
 I Y=U S AMQQSTOP="" Q
 I 'Y W "  ??",*7 G FLEN
 S T=Y
 S N=0
 F  S N=$O(H(N)) Q:'N  F I=1:1 S %=$P(H(N),U,I) Q:%=""  S T=$P(%,";",2)+T
 I T>AMQQEM("LEN") W "  ??",*7,!!,"Sorry, you have exceeded the maximum field length...Try again!",!! K AMQQFLEN G FLEN1
 S AMQQFLEN=+Y
 S $P(@G@(AMQQEMN,0),U,7)=AMQQFLEN
 Q
 ;
