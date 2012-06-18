AMQQPOS ;IHS/CMI/THL - POST INSTALLATION ROUTINE ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;-----
 N X,Y,Z,%,%Z,A,B,I,DFN
 I '$D(^AMQQ(1,1)) W !,*7,"You must restore the QMAN globals prior to running this routine!" Q
LAB I $O(^UTILITY("AMQQ",$J,"SAVE",0)) W !! D WAIT^DICD
 F DA=0:0 S DA=$O(^UTILITY("AMQQ",$J,"SAVE",DA)) Q:'DA  D  S DIK="^AMQQ(5," D IX^DIK W "."
 .F X=0:0 S X=$O(^UTILITY("AMQQ",$J,"SAVE",DA,X)) Q:'X  S Y=$P(^(X),"|"),Z=$P(^(X),"|",2),@Y=Z
 K ^UTILITY("AMQQ",$J,"SAVE"),X,Y,Z,DIK,DA,DIC,D
GOLD ; ENTRY POINT TO SYNC-UP V FILES
 F X=0:0 S X=$O(^AMQQ(5,X)) Q:'X  S Y=^(X,0),Z=$P(Y,U,12) I Z'="" D G1
 I $G(^DD(9002226,0,"VR"))<4.2 W !!,"You must install the current version of the TAXONOMY File for QMAN to run properly!!!",!!,*7,*7
 I '$D(^DD(9000010.09,1103)) W !!,"If you want to be able to search for lab results, install a version of",!,"the V LAB file which includes field 1103",!!,*7,*7
 D BYE
EXIT K %,A,B,C,I,X,Y,Z,DFN,%Z
 Q
 ;
G1 S (%,B)=$P(Y,U,5)
 S %=$G(^AMQQ(1,%,2))
 I %="" D BAD Q
 I %["AUPNVXAM"!(%["AUPNVNTS") S %=$P(%,";",2) G G11 ;PATCH XXX
 S A="AUPNV"_$P(Z,";")_";"
 S %=+$P(%,A,2)
G11 S %Z=$P(Z,";",2)
 S Z="^AUTT"_$P(Z,";")_"(""C"","""_$P(Z,";",2)_""","""")"
 S Z=$O(@Z)
 I Z,Z=% Q
 I 'Z D BAD Q
 S DFN=%
 D RESET
 Q
 ;
MSG W !,$P(Y,U)," (",X,")"
 Q
 ;
BAD ;
 W !,$P(^AMQQ(5,X,0),U)," NOT FOUND IN YOUR DATABASE"
 S DIK="^AMQQ(5,"
 S DA=X
 D ^DIK
 K DA,DIK
 Q
 ;
RESET ; The following lines contain commands that perform hard sets
 ; of data global ^AMQQ - An exemption to SAC 6.1.2.3 has been approved
 ; by Jim McArthur per memo dated May 17, 1993.  This exemption is 
 S $P(^AMQQ(1,B,0),U,11)=Z
 I Z S $P(^(0),U,15)=Z
 S A=^AMQQ(1,B,1)
 I A'["IMM" S C=" I $D(^(AMQP(0),",%=$P(A,C,2),%="))"_$P(%,"))",2,999),%=Z_%,A=$P(A,C)_C_%,^AMQQ(1,B,1)=A
 F I=1,2 S A=^AMQQ(1,B,I),C=$P(^AMQQ(5,X,0),U,12),C=$P(C,";") S:C="EXAM" C="XAM" S C="AUPNV"_C_";",%=$P(A,C,2),%=Z_";"_$P(%,";",2,999),A=$P(A,C)_C_%,^AMQQ(1,B,I)=A
 I A["IMM" D IMM
 Q
 ;
IMM ; Check compound immunization links to see if need to change a dfn
 N %A,%B,%C,%D,%E,%F,%I,%LINK
 F %I=2:1 S %A=$P($T(IMMUN+%I),";;",2) Q:%A=""  D
 . S %C=$P(%A,U) F I=1:1 S %D=$P(%C,":",I) Q:%D=""  I %D=%Z S %LINK=$P(%A,U,2) D  Q
 ..  F I=1,2 S A=^AMQQ(1,%LINK,I),C="AUPNVIMM;",%=$P(A,C,2),%C=$P(%,";") D  S %=%C_";"_$P(%,";",2,999),A=$P(A,C)_C_%,^AMQQ(1,%LINK,I)=A
 ... F %E=1:1 S %F=$P(%C,":",%E)  Q:%F=""  I %F=DFN S $P(%C,":",%E)=Z
 Q
 ;
BYE ; EXIT MESSAGE
 W !!!,"Good news!  The installation of Q-Man has been successfully completed."
 W !!,"Bad news!  You still have some work to do: assign keys and security codes,"
 W !,"put the Q-Man options on the menu, and use the Q-Man Managers Utilities."
 W !,"If you do not have written instructions, do a Fileman Inquire on the Q-Man"
 W !,"entry of the package file.",!!!,*7,*7
 Q
 ;
IMMUN ; Table of Compound Immunizations - IHS CODE:IHS CODE^QMAN LINK ENTRY
 ; DFNs will be changed to reflect current system state
 ;;02:03:04:34^180
 ;;02:04^186
 ;;03:04:34^185
 ;;15:17^199
 ;;14:17:18^198
