INHSZ4 ;JSH,DGH; 9 Apr 99 13:17;Script compiler REQUIRED section handler ; 11 Nov 91   6:42 AM
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 3; 17-JUL-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
L G L^INHSZ1
 ;
IN ;Enter code
 Q
 ;
REQUIRED ;Handle lines in REQUIRED section
 ;Enter here with LINE array set
 N COMM
 S COMM=$P(LINE," ") G:$$CMD^INHSZ1(COMM,"IF^ENDIF") CMD
 ;Line must be a required variable
 Q:'$$SYNTAX^INHSZ0(LINE,"1.ANP")
 N %1,%11,%2,%3,%4,%0,%5
 S %0=$$LBTB^UTIL($P(LINE,";")),%2=$P(LINE,";",2) G:%0["^" COND
 S %1=$$VEXP(%0)
 I %1=-1 D ERROR^INHSZ0("Illegal variable format: "_%0,1) Q
 S A=" I $G("_$S($E(%1)="@":"INA",1:"@INV@")_"("_%1_"))="""" D ERROR^INHS(""Required data missing: '"_$S(%2]"":%2,1:%0)_"'  Cannot proceed."",2)" D L
 Q
 ;
COND ;Conditional required check
 S %1=$$LBTB^UTIL($P(%0,U)),%3=$$LBTB^UTIL($P(%0,U,2)),%5=$$LBTB^UTIL($P(%0,U,3)) S:%5]"" %5=$$LBTB^UTIL($P(%0,U,3,99))
 G:$D(LVARS(%1)) LOOP
 S %11=$$VEXP(%1),%4=$$VEXP(%3)
 S A=" I $D("_$S($E(%3)="@":"INA",1:"@INV@")_"("_%4_"))#2,$G("_$S($E(%1)="@":"INA",1:"@INV@")_"("_%11_"))="""" "
 I %5="" S A=A_"D ERROR^INHS(""Required data missing: '"_$S(%2]"":%2,1:%1)_"'  Cannot proceed."",2)" D L Q
 S X=%5 D ^DIM I '$D(X) D ERROR^INHSZ0("Illegal MUMPS code in command.",1) Q
 S A=A_"S INREQERR=2 "_%5 D L
 Q
 ;
LOOP ;Looping check
 I '$D(LVARS(%3)) D ERROR^INHSZ0("Illegal REQUIRED syntax - Variable '"_%3_"' was not created in a loop.",1) Q
 I LVARS(%3)'=LVARS(%1) D ERROR^INHSZ0("Level incompatibility error.",1) Q
 S V1="@INV@("""_%3_"""",V2="@INV@("""_%1_""""
 F J=1:1:LVARS(%3) D
 . S V1=V1_",INI("_J_")",V2=V2_",INI("_J_")"
 . S A=$S(J=1:" K INI ",1:" ")_"S INI("_J_")=0 F  S INI("_J_")=$O("_V1_")) Q:'INI("_J_")  S INI=INI("_J_") D" D L,DOWN^INHSZ1("")
 S V1=V1_")",V2=V2_")",A=" I $G("_V2_")="""" "
 D:%5=""
 . S A=A_"D ERROR^INHS(""Required data missing: '"_$S(%2]"":%2,1:%1)_"' in loop interation #""_" F J=1:1:LVARS(%3) S A=A_"INI("_J_")" S:J'=LVARS(%3) A=A_"_"",""_"
 . S A=A_",2)" D L
 D:%5]""  Q:ER
 . S X=%5 D ^DIM I '$D(X) D ERROR^INHSZ0("Illegal MUMPS code in command.",1) Q
 . S A=A_"S INREQERR=2 "_%5 D L
 F J=1:1:LVARS(%3) D UP^INHSZ1
 Q
 ;
OUT ;Leaving REQUIRED section
 D QCHK^INHSZ0
 Q
 ;
CMD ;It is a command
 G @$$CASECONV^UTIL(COMM,"U")
 ;
IF ;IF statement
 G IF^INHSZ21
 ;
ENDIF ;ENDIF statement
 G ENDIF^INHSZ21
 ;
ERROR ;ERROR statement
 G ERROR^INHSZ21
 ;
VEXP(%V) ;Expand a variable with subscripts
 ;returns -1 if format illegal
 ;New transform to support extended subscripts for NCPDP
 ;If input contains multiple nodes such as MED,FIELDID
 ;this returns "MED","FIELDID". TRANSFORM and REQUIRED
 ;sections then use extended subscripts properly. dgh
 I %V[",",$TR(%V,"()")=%V N %V2 D  Q %V2
 .S %V2=""""_$P(%V,",")_""""
 .F I=2:1:$L(%V,",") S %V2=%V2_","_""""_$P(%V,",",I)_""""
 ;
 Q:$TR(%V,"()")=%V """"_%V_""""
 I %V["(",%V'[")" Q -1
 I %V[")",%V'["(" Q -1
 ;Need research to determine if extended logic needs to go
 ;here. DGH
 N %S
 S %S=$P(%V,"(",2,99),%S=$E(%S,1,$L(%S)-1)
 Q """"_$P(%V,"(")_""","_%S
