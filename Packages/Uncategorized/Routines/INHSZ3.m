INHSZ3 ;JSH; 16 Mar 92 08:36;Script compiler TRANSFORM section handler ; 11 Nov 91   6:42 AM
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
L G L^INHSZ1
 ;
IN ;Enter code
 Q
 ;
OUT ;Exit code
 Q
 ;
TRANS ;Handle lines in TRANSFORM section
 ;Enter here with LINE array set to current line
 ;Get command
 N COMM
 S COMM=$P(LINE," ") G:$$CMD^INHSZ1(COMM,"IF^ENDIF^ERROR^") CMD
 ;Line must be a <var>$<expression> line
 Q:'$$SYNTAX^INHSZ0(LINE,"1.ANP."" ""1.2""$""."" "".1""^""1.E")
 N V,E,V1,INR,TRC,REQ
 S REQ=$P(LINE,"$",2)=""
 S V=$P($TR(LINE,"$"," ")," "),E=$$LBTB^UTIL($P(LINE,"$",2+REQ,999))
 S V1=$$VEXP^INHSZ4(V) I V1=-1 D ERROR^INHSZ0("Illegal variable format: "_V,1) Q
 S INR=$D(LVARS(V)),INM=$E(E)="^"
 I 'INM D  Q:ER
 . S DIC=.5,DIC(0)="",X=$P(E,"(") D ^DIC K DIC
 . I Y<0 D ERROR^INHSZ0("Function not found for transform.",1) Q
 . S TRC=$G(^DD("FUNC",+Y,1))
 . I E["(" S X=E D  Q:ER
 .. I INR N DICOMPX S DICOMPX(V)="@INV@("""_V_""",INI)"
 .. D DICOMP^INHSZ21(.X) I '$D(X) D ERROR^INHSZ0("Illegal function call: '"_E_"'") Q
 .. S TRC=X
 I INM D  Q:ER
 . ;Function is MUMPS code
 . S X=$E(E,2,999) ;D ^DIM I '$D(X) D ERROR^INHSZ0("Invalid MUMPS code in transform function.",1) Q
 . S TRC=X
 I 'INR S A=" S (INX,X)=$G(@INV@("_V1_"))" D L S A=" "_TRC D L S A=" S @INV@("_V1_")=$G(X)" D L D  G Q
 . S A=" I '$D(X) D ERROR^INHS(""Variable '"_V_"' failed input transform. "_$S('REQ:"Processing continues.",1:"Cannot Proceed.")_""","_(REQ*2)_"),ERROR^INHS(""  Value = '""_INX_""'"",0)" D L
 S V1="@INV@("""_V_""""
 F J=1:1:LVARS(V) D
 . S V1=V1_",INI("_J_")"
 . S A=" S INI("_J_")=0 F  S INI("_J_")=$O("_V1_")) Q:'INI("_J_")  S INI=INI("_J_") D" D L,DOWN^INHSZ1("")
 S V1=V1_")",A=" S (INX,X)="_V1 D L S A=" "_TRC D L S A=" S "_V1_"=$G(X) I '$D(X) D ERROR^INHS(""Variable '"_V_"' failed input transform in iteration #""_" F J=1:1:LVARS(V) S A=A_"INI("_J_")" S:J'=LVARS(V) A=A_"_"",""_"
 S A=A_"_"". "_$S('REQ:"Processing continues.",1:"Cannot Proceed.")_""","_(REQ*2)_"),ERROR^INHS(""  Value = '""_INX_""'"",0)" D L
 F J=1:1:LVARS(V) D UP^INHSZ1
 ;
Q S A=" K DXS" D L
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
ERROR ;ERROR command
 G ERROR^INHSZ21
 ;
