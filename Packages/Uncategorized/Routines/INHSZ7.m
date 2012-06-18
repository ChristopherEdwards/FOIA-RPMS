INHSZ7 ;JSH; 12 Oct 93 16:51;Script Compiler - STORE section handler ; 11 Nov 91   6:42 AM
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
L G L^INHSZ1
 ;
IN ;Enter code
 I REPEAT1 D ERROR^INHSZ0("STORE section not allowed when LOOKUP section used the REPEAT command.",0) Q
 D QCHK^INHSZ0 Q
 ;
OUT ;Exit code
 Q
 ;
STORE ;Handle line in STORE section
 ;Enter with LINE array set
 N COMM
 S COMM=$P($TR(LINE,"="," ")," ") I '$$CMD^INHSZ1(COMM,"ERROR^IF^ENDIF^TEMPLATE^ROUTINE^ACK^MULT^ENDMULT^MATCH^PARAM^LOOK^OTHER^ENDOTHER") D ERROR^INHSZ0("Invalid command in STORE section.",1) Q
 S X=$$CASECONV^UTIL(COMM,"U") G:$T(@X)]"" @X
 G @(X_"^INHSZ71")
 ;
TEMPLATE ;Invoke an input template
 I 'LOOKUP,'MULT D ERROR^INHSZ0("Cannot process a template without a LOOKUP section.",1) Q
 I MULT,'$D(LOOKUP(MULT)) D ERROR^INHSZ0("Cannot proceed without a lookup being performed for this multiple.",1) Q
 I OTHER,'OTHER("LOOK") D ERROR^INHSZ0("Cannot proceed without a lookup for the OTHER file.",1) Q
 Q:'$$SYNTAX^INHSZ0($P(LINE,COMM,2,99),"."" ""1""=""."" ""1.ANP")
 S DR=$$LBTB^UTIL($P(LINE,"=",2)) S:$E(DR)'="[" DR="["_DR_"]"
 S X=$TR(DR,"[]"),DIC="^DIE(",DIC(0)="",DIC("S")="I $P(^(0),U,4)="_+FILE1 D ^DIC K DIC
 I Y<0 D WARN^INHSZ0("Input Template '"_$TR(DR,"[]")_"' does not exist for file #"_+FILE1,1)
 S A=" ;"_LINE D L
 D RDIPA^INHSZ51:REPEAT,DIPA^INHSZ51:'REPEAT
 S A=" S DR="""_DR_""",DIE="""_"^"_$P(FILE1,"^",2)_""",DA=INDA"_$S('MULT:"",1:"("_MULT_")")_" K INY,Y,DIC,DO,INEXIT I DA>0,INDA>0 D ^DIE K:$G(INEXIT) Y,INY K INEXIT" D L
 S A=" I $D(Y),$D(INY) K Y S X=$O(INY("""")) S:X]"""" Y(X)=INY(X)" D L
 S A=" S I="""" F  S I=$O(Y(I)) Q:I=""""  K:I'["","" Y(I)" D L
 S A=" K INY,INFAIL S:$D(Y) INFAIL=1" D L
 S A=" K X,X1,X2 I $D(INFAIL),$O(Y(0))["","" S X1=$O(Y(0)),X=Y(X1),X2=$P(X1,"","",2),X1=+X1" D L
 S A=" I $D(INFAIL) S INFMES(1)=""Input Template '"
 S A=A_$TR(DR,"[]")_"' failed""_$S($D(X1):"" on field ""_X2_"" (""_$P(^DD(X1,X2,0),U)_"") in file ""_X1_"" (""_$O(^DD(X1,0,""NM"",""""))_$S($D(^DD(X1,0,""UP"")):"" Sub-Field"",1:"""")_"")"",1:"""")" D L
 S A=" I $D(INFAIL) S:$G(X)]"""" INFMES(2)=""Value of field = '""_$E(X,1,220)_""'"" D ERROR^INHS(.INFMES,2)" D L
 S A=" K DIPA,INFAIL,X1,X2,INFMES" D L
 Q
 ;
ROUTINE ;Call a routine
 I 'MULT,'LOOKUP D ERROR^INHSZ0("Cannot process without a LOOKUP section.",1) Q
 I MULT,'$D(LOOKUP(MULT)) D ERROR^INHSZ0("Cannot proceed without a lookup being performed for this multiple.",1) Q
 I OTHER,'OTHER("LOOK") D ERROR^INHSZ0("Cannot proceed without a lookup being performed on the OTHER file.",1) Q
 Q:'$$SYNTAX^INHSZ0($P(LINE,COMM,2,99),"."" ""1""=""."" ""1.ANP")
 ;Set DA and DIE, then call routine
 N ROU S ROU=$$LBTB^UTIL($P(LINE,"=",2,999)),ROU=$S($P(ROU,"(")["^":ROU,1:"^"_ROU) S X=$P($P(ROU,U,2),"(") X ^%ZOSF("TEST") E  D WARN^INHSZ0("Routine '"_X_"' does not exist.",1)
 S A=" ;"_LINE D L
 D RDIPA^INHSZ51:REPEAT,DIPA^INHSZ51:'REPEAT
 S A=" S DA=INDA"_$S('MULT:"",1:"("_MULT_")")_",DIE=""^"_$P(FILE1,"^",2)_""",DIE(1)=""^"_$P(FILE,U,2)_""" D:DA'=-1 "_ROU_" K DIPA" D L
 Q
 ;
ENDIF ;End of IF block
 G ENDIF^INHSZ21
 ;
IF ;Start of IF block
 G IF^INHSZ21
 ;
ACK ;Handle the processing of an acknowledge message
 Q:'$$SYNTAX^INHSZ0($P(LINE,COMM,2,99),"."" ""1""=""."" ""1.ANP."" ""1""^""."" ""1.ANP")
 N %V,%S,%M
 S %M=$P(LINE,"=",2)
 S %V=$$LBTB^UTIL($P(%M,"^")),%S=$$LBTB^UTIL($P(%M,"^",2)),%M=$$LBTB^UTIL($P(%M,"^",3))
 I $E(%V)'="@",'$D(DICOMPX(%V)) D ERROR^INHSZ0("Variable '"_%V_"' was not defined.",1) Q
 I %M]"",$E(%M'="@"),'$D(DICOMPX(%M)) D ERROR^INHSZ0("Variable '"_%M_"' was not defined.",1) Q
 I %S'=0,%S'=1 D ERROR^INHSZ0("Illegal acknowledge status '"_%S_"'",1) Q
 S A=" D ACKLOG^INHU(UIF,"_$S($E(%V)'="@":"$G(@INV@("""_%V_"""))",1:"$G(INA("""_$E(%V,2,999)_"""))")_","_%S
 I '%S,%M]"" S A=A_","_$S($E(%M)'="@":"$G(@INV@("""_%M_"""))",1:"$G(INA("""_$E(%M,2,999)_"""))")_")"
 E  S A=A_")"
 D L
 Q
 ;
ERROR ;ERROR statement
 G ERROR^INHSZ21
 ;
MATCH ;MATCH statement - only allowed in a MULT block
 I 'MULT,'OTHER D ERROR^INHSZ0("MATCH only allowed in a MULT or OTHER block in the STORE section.",1) Q
 G MATCH^INHSZ5
 ;
PARAM ;PARAM for multiple lookup - only allowed in a MULT block
 I 'MULT,'OTHER D ERROR^INHSZ0("PARAM only allowed in a MULT or OTHER block in the STORE section.",1) Q
 G PARAM^INHSZ5
 ;
LOOK ;Perform a lookup in a multiple - only allowed in a MULT or OTHER block
 N %2
 I 'MULT,'OTHER D ERROR^INHSZ0("LOOK only allowed in a MULT or OTHER block.",1) Q
 I MULT,$D(LOOKUP(MULT)) D ERROR^INHSZ0("The lookup was already performed at this level.",1) Q
 I OTHER,'MULT,OTHER("LOOK") D ERROR^INHSZ0("The lookup was already performed for the OTHER file.",1) Q
 D DOIT^INHSZ5 S:MULT LOOKUP(MULT)="" S:OTHER OTHER("LOOK")=1
 S %2=$$LBTB^UTIL($P(LINE,COMM,2)) Q:%2=""
 S A=" S "_$$VEXP^INHSZ51(%2)_"=INDA" D L S:'REPEAT DICOMPX(%2)="$G(INV("""_%2_"""))" I REPEAT S A=" S @INV@("""_%2_""")=INDA" D L
 Q
