CIAUSTX0 ;MSC/IND/DKM - Continuation of CIAUSTX;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
CMD(CIALBL) ;
 D:CIALBL'="" @CIALBL
 Q
 ; Postconditional
PC D:$$NEXT(":") EXP()
 Q:CIAERR
 I " "'[$E(CIAM,CIAPSN) S CIAERR=2
 E  S CIAPSN=CIAPSN+1
 Q
 ; No postconditional
NPC I $$NEXT(":") S CIAERR=5
 E  I " "'[$E(CIAM,CIAPSN) S CIAERR=2
 E  S CIAPSN=CIAPSN+1
 Q
 ; Arguments optional
OPT S:" "[$E(CIAM,CIAPSN) CIARN=0
 Q
 ; Multiple arguments
ARGS(CIAEX) ;
 S CIAEX=$G(CIAEX)
 F  D EXP(CIAEX) Q:CIAERR!'$$NEXT(",")
 Q
 ; Expression
EXP(CIAEX) ;
 D EXP^CIAUSTX1(.CIAEX)
 Q
 ; Label reference
LBL(CIAA) F  D LBL1(.CIAA) Q:CIAERR!'$$NEXT(",")
 Q
LBL1(CIAA) ;
 S CIAA=+$G(CIAA)
 D LBL2
 Q:CIAERR
 D:$$NEXT("+") EXP(")")
 Q:CIAERR
 D:$$NEXT(U) LBL2
 I 'CIAERR,CIAA=2 D PARAMS(".;0-999")
 I 'CIAERR,CIAA D EXP(")"):$$NEXT(":")
 Q
LBL2 I $$NEXT("@") D
 .D EXP("=")
 E  S:$E(CIAM,CIAPSN)?.1AN.1"%" CIAPSN=$$LABEL
 Q
 ; Write command
WRITE F  D  Q:CIAERR!'$$NEXT(",")
 .I $$NEXT("!#") D  Q:'$$NEXT("?",0)
 ..F  Q:'$$NEXT("!#")
 .I $$NEXT("?*")
 .D EXP()
 Q
 ; Read command
READ N CIAZ
 F  D  Q:CIAERR!'$$NEXT(",")
 .I $$NEXT("!#") D  Q:'$$NEXT("?",0)
 ..F  Q:'$$NEXT("!#")
 .I $$NEXT("?") D EXP() Q
 .I $$NEXT(CIAQT) D QT2^CIAUSTX1 Q
 .S CIAZ=$$NEXT("*")
 .D LVAL("LGS")
 .I 'CIAERR,'CIAZ,$$NEXT("#") D EXP()
 .I 'CIAERR,$$NEXT(":") D EXP()
 Q
 ; Lock command
LOCK D LIST("LG+:","LG")
 Q
 ; Set command
SET D LIST("LGS=","LGS")
 Q
 ; New command
NEW D LIST("N","")
 Q
 ; Kill command
KILL D LIST("KGL","")
 Q
 ; Merge command
MERGE D LIST("LG=")
 Q
 ; For command
FOR D LVAL("LGS")
 I '$$NEXT("=") S CIAERR=2 Q
 F  D  Q:" "[$E(CIAM,CIAPSN)  I '$$NEXT(",") S CIAERR=2 Q
 .D EXP(),EXP():$$NEXT(":"),EXP():$$NEXT(":")
 Q
 ; Evaluate L-value
 ; CIAL: Allowed types:
 ;     L=Local array
 ;     G=Global arrays
 ;     S=Settable intrinsics/system variables
 ;     N=Newable system variables
 ;     K=Killable system variables
LVAL(CIAL) ;
 I $$NEXT("@",0) D  Q
 .S CIAL="="
 .D EXP(.CIAL)
 S CIAL=$G(CIAL)
 I CIAL["G",$$NEXT(U) D  Q
 .N CIAF
 .D GLBL^CIAUSTX1
 I $TR(CIAL,"SNK")'=CIAL,$$NEXT("$") D  Q
 .N CIAZ
 .S CIAZ=$$INT(.CIAPSN,CIAL)
 .D:'CIAERR PARAMS(CIAZ)
 S CIAPSN=$$NAME(CIAPSN,"%")
 I 'CIAERR,CIAL["L" D PARAMS()
 Q
 ; Evaluate parameters/subscripts
PARAMS(CIAX) ;
 D:$$NEXT("(") PLIST^CIAUSTX1(.CIAX)
 Q
 ; New/Kill/Set/Lock argument list
LIST(CIAL1,CIAL2) ;
 N CIAP,CIAI
 S CIAP=0
 F  D  Q:CIAERR!'$$NEXT(",")
 .I 'CIAP,CIAL1["+",$$NEXT("+-")
 .I $D(CIAL2),$$NEXT("(") D  Q:CIAERR
 ..I CIAP S CIAERR=2 Q
 ..E  S CIAP=1
 .S CIAI=$S(CIAP:CIAL2,1:CIAL1)
 .D LVAL(.CIAI)
 .Q:CIAERR
 .I $$NEXT(")") D  Q:CIAERR
 ..I CIAP S CIAP=0
 ..E  S CIAERR=2
 .I 'CIAP,CIAL1[":",$$NEXT(":") D EXP()
 .I 'CIAP,CIAL1["=" D
 ..I '$$NEXT("=") S:CIAI'["@" CIAERR=2
 ..E  D EXP():$D(CIAL2),LVAL(CIAL1):'$D(CIAL2)
 I 'CIAERR,CIAP S CIAERR=3
 Q
 ; Check for validity of label name
LABEL(CIAP) ;
 Q $$NAME(.CIAP,"L%")
 ; Check for validity of variable/label name
NAME(CIAP,CIAF) ;
 N CIAP1
 S (CIAP,CIAP1)=$G(CIAP,CIAPSN),CIAF=$G(CIAF)
 I CIAF["$",$E(CIAM,CIAP)="$" S CIAP=CIAP+1,CIAP1=CIAP
 I CIAF["%",$E(CIAM,CIAP)="%" S CIAP=CIAP+1
 F CIAP=CIAP:1 Q:$E(CIAM,CIAP)'?@$S(CIAF["L":"1AN",CIAP=CIAP1:"1A",1:"1AN")
 I CIAP=CIAP1 S CIAERR=$S(CIAF["L":11,1:1)
 E  S:CIAP-CIAP1>8 CIAERR=12
 Q CIAP
 ; Instrinsic function/system variable
INT(CIAP,CIAL) ;
 N CIAP2,CIAINT,CIANM
 S CIAP=$G(CIAP,CIAPSN),CIAP2=$$NAME(CIAP),CIAL=$G(CIAL)
 Q:CIAERR ""
 S CIANM=$E(CIAM,CIAP,CIAP2-1)
 I $E(CIAM,CIAP2)="(" S:$D(^TMP(CIAPID,$J,"FCN",CIANM)) CIAINT=^(CIANM)
 E  S:$D(^TMP(CIAPID,$J,"SYS",CIANM)) CIAINT=^(CIANM)
 I '$D(CIAINT),CIAO["Z" S CIAINT=";0-999"
 I '$D(CIAINT) S CIAERR=7
 E  I CIAL'="",$TR(CIAL,$P(CIAINT,";"))=CIAL S CIAERR=2,CIAINT=""
 E  S CIAP=CIAP2
 Q $G(CIAINT)
 ; Check next character
NEXT(CIAC,CIAI) ;
 I CIAPSN'>CIALEN,CIAC[$E(CIAM,CIAPSN) S CIAPSN=CIAPSN+$G(CIAI,1)
 Q $T
