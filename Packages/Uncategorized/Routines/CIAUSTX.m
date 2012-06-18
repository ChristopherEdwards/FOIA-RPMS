CIAUSTX ;MSC/IND/DKM - M syntax analyzer;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Perform syntactic analysis of a line of M code.
 ; Inputs:
 ;   CIAM = M statement(s)
 ;   CIAO = Options:
 ;      L = Line label allowed
 ;      . = Dotted syntax allowed
 ;      N = Do not init parsing tables
 ;      D = Do not delete parsing tables
 ;      Z = Process all Z-extensions as valid
 ; Outputs:
 ;   Returns 0 if successfully parsed.  Otherwise returns E^P^M
 ;   where E is an error code (see ERRORS label), P is the
 ;   character position where the error occurred, and M is the
 ;   error message.
 ;=================================================================
ENTRY(CIAM,CIAO) ;
 N CIAPSN,CIALEN,CIAERR,CIARN,CIAQT,CIAF,CIAPID,CIACMD
 S CIAM=$$UP^XLFSTR(CIAM),CIAO=$$UP^XLFSTR($G(CIAO)),CIAPSN=1,CIALEN=$L(CIAM),CIAERR=0,CIAQT="""",CIAF=0,CIAPID="CIAUSTX",U="^"
 D LOAD:CIAO'["N",PARSE:CIALEN
 K:CIAO'["D" ^TMP(CIAPID,$J)
 Q $S(CIAERR:CIAERR_U_$S(CIAPSN>CIALEN:CIALEN,1:CIAPSN)_U_$S(CIAERR<0:$$EC^%ZOSV,1:$P($T(ERRORS+CIAERR),";;",2)),1:0)
PARSE N CIAZ,CIAZ1
 S @$$TRAP^CIAUOS("ERROR^CIAUSTX")
 I CIAO["L" D  Q:CIAERR
 .S:$E(CIAM)'=" " CIAPSN=$$LABEL^CIAUSTX0
 .I $$NEXT^CIAUSTX0("("),'$$NEXT^CIAUSTX0(")") D
 ..F CIAPSN=CIAPSN:1 D  Q:$E(CIAM,CIAPSN)'=","!CIAERR
 ...S CIAPSN=$$NAME^CIAUSTX0(CIAPSN,"L%")
 ..Q:CIAERR
 ..S:'$$NEXT^CIAUSTX0(")") CIAERR=3
 .S:" "'[$E(CIAM,CIAPSN) CIAERR=2
 I CIAO["." F CIAPSN=CIAPSN:1:CIALEN+1 Q:". "'[$E(CIAM,CIAPSN)
 F  Q:CIAERR  D SKPSPC Q:";"[$E(CIAM,CIAPSN)  D
 .S CIACMD=""
 .F CIAPSN=CIAPSN:1 S CIAZ=$E(CIAM,CIAPSN) Q:CIAZ'?1A  S CIACMD=CIACMD_CIAZ
 .I CIACMD="" S CIAERR=4 Q
 .I $D(^TMP(CIAPID,$J,"CMD",CIACMD)) S CIACMD=^(CIACMD)
 .E  I CIAO["Z" S CIACMD="PC;OPT;ARGS("":M"")"
 .E  S CIAERR=4 Q
 .F CIARN=1:1:$L(CIACMD,";") D CMD^CIAUSTX0($P(CIACMD,";",CIARN)) Q:CIAERR!'CIARN
 .I 'CIAERR," "'[$E(CIAM,CIAPSN) S CIAERR=2
 .E  S CIAPSN=CIAPSN+1
 Q
 ; Skip over blanks
SKPSPC F  Q:'$$NEXT^CIAUSTX0(" ")
 Q
 ; Load tables
LOAD N CIAZ,CIAZ1,CIAZ2,CIAL
 K ^TMP(CIAPID,$J)
 F CIAL="CMD","FCN","SYS" D
 .F CIAZ=1:1 S CIAZ1=$P($T(@CIAL+CIAZ),";;",2,999) Q:CIAZ1=""  D
 ..S CIAZ2=$P(CIAZ1,";"),CIAZ1=$P(CIAZ1,";",2,999)
 ..F  Q:CIAZ2=""  D
 ...S ^TMP(CIAPID,$J,CIAL,$P(CIAZ2,","))=CIAZ1,CIAZ2=$P(CIAZ2,",",2,999)
 Q
ERROR S CIAERR=-1
 Q
CMD ;;*Commands*
 ;;B,BREAK;PC;OPT;ARGS()
 ;;C,CLOSE;PC;ARGS(":M")
 ;;D,DO;PC;OPT;LBL(2)
 ;;E,ELSE;NPC;OPT;ARGS()
 ;;F,FOR;NPC;OPT;FOR
 ;;G,GOTO;PC;LBL(1)
 ;;H,HALT,HANG;PC;OPT;EXP()
 ;;I,IF;NPC;OPT;ARGS()
 ;;J,JOB;PC;LBL(2)
 ;;K,KILL;PC;OPT;KILL
 ;;L,LOCK;PC;OPT;LOCK
 ;;M,MERGE;PC;MERGE
 ;;N,NEW;PC;OPT;NEW
 ;;O,OPEN;PC;ARGS(":M")
 ;;Q,QUIT;PC;OPT;EXP()
 ;;R,READ;PC;READ
 ;;S,SET;PC;SET
 ;;U,USE;PC;ARGS(":M")
 ;;V,VIEW;PC;ARGS(":M")
 ;;W,WRITE;PC;WRITE
 ;;X,XECUTE;PC;ARGS(":")
 ;;ZT,ZTRAP;PC;OPT;EXP()
 ;;ZS,ZSAVE;PC;OPT;EXP()
 ;;ZR,ZREMOVE;PC;OPT;LBL(1)
 ;;ZP,ZPRINT
 ;;
FCN ;;*Intrinsic functions*
 ;;A,ASCII;;1-2
 ;;C,CHAR;;1-999
 ;;D,DATA;;1-1;V
 ;;E,EXTRACT;S;1-3
 ;;F,FIND;;2-3
 ;;FN,FNUMBER;;2-3
 ;;G,GET;;1-2;V
 ;;J,JUSTIFY;;1-3
 ;;L,LENGTH;;1-2
 ;;N,NEXT;;1-2
 ;;NA,NAME;;1-2;V
 ;;O,ORDER;;1-2;V
 ;;P,PIECE;S;2-4
 ;;Q,QUERY;;1-2;V
 ;;R,RANDOM;;1-1
 ;;S,SELECT;:;1-999
 ;;T,TEXT;;1-1;L
 ;;TR,TRANSLATE;;2-3
 ;;V,VIEW;;1-999
 ;;
SYS ;;*System variables*
 ;;D,DEVICE
 ;;ET,ETRAP;SN
 ;;H,HOROLOG
 ;;I,IO
 ;;J,JOB
 ;;K,KEY
 ;;P,PRINCIPAL
 ;;S,STORAGE
 ;;SY,SYSTEM
 ;;T,TEST
 ;;TL,TLEVEL
 ;;TR,TRESTART
 ;;X;S
 ;;Y;S
 ;;ZT,ZTRAP;S
 ;;ZE,ZERROR;S
 ;;ES,ESTACK;N
 ;;EC,ECODE;S
ERRORS ;;*Error messages*
 ;;Bad variable name
 ;;Syntax error
 ;;Unbalanced parentheses
 ;;Unrecognized command
 ;;Postconditional not allowed
 ;;Missing operand
 ;;Unrecognized intrinsic function/variable
 ;;Incorrect number of arguments
 ;;Missing closing quote
 ;;Illegal pattern
 ;;Bad label name
 ;;Name too long
 ;;13
