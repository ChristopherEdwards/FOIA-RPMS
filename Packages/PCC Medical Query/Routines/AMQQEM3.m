AMQQEM3 ; IHS/CMI/THL - FINE TUNES THE HEADER LINE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
 I 'Y Q
 S AMQQEMN=Y,AMQQEM3=0
 N Y
 I '$D(AMQQEM("FIX")) N AMQQFLEN D FLEN^AMQQEM31 I $D(AMQQQUIT) Q
 I $D(AMQQSTOP) G EXIT
RUN F AMQQEM3=1:1:5 D @$P("LIST^DATE^TYPE^TUNE^LIST",U,AMQQEM3) I $D(AMQQQUIT)!($G(AMQQEMFN)>98)!($D(AMQQSTOP)) Q
EXIT I $D(AMQQSTOP) W *7 S AMQQEMFS=$P(AMQQEMFS,U,1,$L(AMQQEMFS,U)-2)_U K AMQQSTOP,@G@(AMQQEMN) D LIST
 K AMQQEM3,AMQQEMAX,AMQQEMP,DIRUT,DIROUT,DUOUT,DTOUT
 Q
 ;
LIST ; - EP -
 N T K H
 I AMQQEMFS="" Q
 S J=1
 S (I,N)=0
 S H(1)=""
 S T=0
 F AMQQEMFN=1:1 S A=$P(AMQQEMFS,U,AMQQEMFN) Q:A=""  D
 .S X=$P(@G@(A,0),U,6)
 .S Y=$P(@G@(A,0),U,7)
 .I 'Y,A=$G(AMQQEMN),$D(AMQQFLEN) S Y=AMQQFLEN
 .I 'Y,$G(AMQQEM("FIX")) S Y=AMQQEM("FIX"),$P(@G@(A,0),U,7)=AMQQEM("FIX")
 .I '$D(AMQQEM("FIX")) S Y=Y+1 ; ADD 1 SPACE FOR THE DELIMITER
 .S X=$E(X,1,Y)
 .S Z=""
 .S $P(Z," ",((Y+1)-$L(X)))=""
 .S T=T+Y
 .I (Y+N)>78 S:AMQQEMFN>1 J=J+1 S N=0,H(J)=""
 .S I=I+1
 .S N=N+Y
 .S H(J)=H(J)_X_Z_";"_Y_";"_$C(64+I)_U
 I AMQQEMFN<99 D DISP
 Q
 ;
DISP N A,D,I,X,Y,Z,%,J,N,K,T S (T,K)=0
 S D=$G(AMQQEM("DEL"))
 S:D="TAB" D="t"
 S:D="UP ARROW" D=U
 W @IOF
 F J=1:1 Q:'$D(H(J))  S N=0 W:J>1 ! D
 .F I=1:1 S X=$P(H(J),U,I) Q:X=""  W $P(X,";") S N=N+$P(X,";",2)
 .W !
 .F I=1:1 S X=$P(H(J),U,I) Q:X=""  S K=K+1,Y=$P(X,";",2),T=T+Y,Z=$P(X,";",3) S:$P(AMQQEMFS,U,K)=AMQQEMN&(AMQQEM3'=5) Z=U S %="",$P(%,Z,Y+$D(AMQQEM("FIX")))="" W %,D
 .I $D(H(J+1)) Q
 .S A=78-N
 .S:N>78 A=78-(N#78)
 .S:(AMQQEM("LEN")-T)<A A=AMQQEM("LEN")-T
 .S %=""
 .S $P(%,".",A+1)=""
 .W %
 .W:(AMQQEM("LEN")-T)>A ">"
 S %=""
 S $P(%,"-",78)=""
 W !,%
 Q
 ;
TUNE I $D(AMQQEMKL) D T21 W !!,"This field cancelled..." H 2 K AMQQEMKL Q
 W @IOF
 D LIST
 W !
 S %=$P(@G@(AMQQEMN,0),U,6)
 I %="" S %=$P(^(0),U,3)
 W "Edit field/variable = """,%,""""
 S DIR(0)="SO^0:NO ADDITIONAL CHANGES;1:DATA TYPE;2:DELETE;3:MOVE;4:RENAME;5:TRANSFORM (MUMPS code, programmers only)"
 S DIR(0)=DIR(0)_";6:"_$S($D(AMQQEM("FIX")):"WIDTH OF FIELD",1:"SUBSTITUTE DELIMITER CHARACTER")
 S DIR(0)=DIR(0)_";7:PUT VALUE IN QUOTES"
 I '$D(AMQQEM("FIX")) S DIR(0)=DIR(0)_";8:CHANGE FIELD WIDTH"
 S DIR("A")="     Your choice"
 S DIR("B")="NO ADDITIONAL CHANGES"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I Y?1."^" S AMQQQUIT="" Q
 I 'Y Q
 I Y=2 D T2 Q
 I Y=8 S Y=9
 I Y=7 S Y=8
 I Y=6,'$D(AMQQEM("FIX")) S Y=7
 D MARK^AMQQEMAN,@("T"_Y)
 I $D(AMQQQUIT) Q
 D LIST
 G TUNE
 Q
 ;
DATE I $P(@G@(AMQQEMN,0),U,4)="D",'$D(AMQQEM("DATE TRANS")) K DIR D  Q
 .D ^AMQQEM21
 .I $D(AMQQQUIT) Q
 .I $D(AMQQEMNO) K AMQQEMNO S AMQQEMKL="" Q
 .F %=0:0 S %=$O(@G@(%)) Q:'%  I $P(^(%,0),U,4)="D" S ^(2)=AMQQEM("DATE TRANS")
 D MARK^AMQQEMAN
 Q
 ;
TYPE I $G(AMQQEM("DATA"))'=2!($D(AMQQEMKL)) Q
 W "DATA TYPE",!
TYPE1 S %=$P(@G@(AMQQEMN,0),U,4)
 S DIR("B")=$S(%="D":"D",%="N":"N",1:"F")
 S DIR(0)="S^N:NUMBER;D:DATE;F:FREE TEXT;M:MONEY($dollars.cents)"
 S DIR("A")="Data type"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X?1."^" S AMQQQUIT="" Q
 S $P(@G@(AMQQEMN,0),U,4)=Y
 Q
 ;
T1 W "VIEW/EDIT DATA TYPE",!
 D TYPE1
 Q
 ;
T2 W "DELETE",!
 S DIR(0)="YO",DIR("A")="Are you sure that you want to delete this segment"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X?1."^" S AMQQQUIT="" Q
 I 'Y Q
T21 F %=1:1 S X=$P(AMQQEMFS,U,%) Q:X=""  I X=AMQQEMN S AMQQEMFS=$P(AMQQEMFS,U,1,%-1)_U_$P(AMQQEMFS,U,%+1,99) S:$P(AMQQEMFS,U)="" AMQQEMFS=$P(AMQQEMFS,U,2,99) Q
 I AMQQEMFS="" W @IOF
 Q
 ;
T3 W "MOVE",!
 I $L(AMQQEMFS,U)=2 W *7,"Whoops, you have only defined one segment.  Request denied..." H 3 Q
 S X=0
 F %=1:1 S Y=$P(AMQQEMFS,U,%) Q:Y=""  I Y S X=X+1 I Y=AMQQEMN S AMQQEMP=%
 S %(1)=$S(AMQQEMP=1:"B",1:"A")
 S %(2)=$S(AMQQEMP=X:$C(64+X-1),1:$C(64+X))
 S AMQQEMAX=X
 I 'X W "  ??",*7 Q
 I X=2 S AMQQEMFS=$P(AMQQEMFS,U,2)_U_$P(AMQQEMFS,U)_U Q
 S DIR("B")="("_%(1)_"-"_%(2)_")"
 S DIR(0)="FO^:"
 S DIR("A")="Move to which segment"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I "^"[X Q
 I X?2."^" S AMQQQUIT="" Q
 I X'?1U W "  ??",*7 D MARK^AMQQEMAN G T3
 I ($A(X)-64)>AMQQEMAX W "  ??",*7 G T3
 I $P(AMQQEMFS,U,$A(X)-64)=AMQQEMN W "  ??",*7 G T3
 S Z=$P(AMQQEMFS,U,AMQQEMP)
 S $P(AMQQEMFS,U,AMQQEMP)=""
 I $E(AMQQEMFS)=U S AMQQEMFS=$E(AMQQEMFS,2,999)
 I AMQQEMFS["^^" S AMQQEMFS=$P(AMQQEMFS,"^^")_U_$P(AMQQEMFS,"^^",2)
 S $P(AMQQEMFS,U,$A(X)-64)=Z_U_$P(AMQQEMFS,U,$A(X)-64)
 Q
 ;
T4 W "RENAME FIELD",!
 I $P(@G@(AMQQEMN,0),U,6)="" S $P(^(0),U,6)=$P(^(0),U,3) W "Current field name: ",$P(^(0),U,6)
 S DIR(0)="FO^1:"_AMQQEM("HLEN")
 S DIR("A")="Enter new name"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I "^"[X Q
 I "^^"=X S AMQQQUIT="" Q
 S $P(@G@(AMQQEMN,0),U,6)=Y
 Q
 ;
T5 D T5^AMQQEM31
 Q
 ;
T6 D T6^AMQQEM31
 Q
 ;
T7 D T7^AMQQEM31
 Q
 ;
T8 D T8^AMQQEM31
 Q
 ;
T9 D T6^AMQQEM31
 Q
 ;
