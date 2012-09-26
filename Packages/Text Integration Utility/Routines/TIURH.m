TIURH ; SLC/JER - Review Screen Header ;5/7/03
 ;;1.0;TEXT INTEGRATION UTILITIES;**113**;Jun 20, 1997
HDR ; Initialize header for clinician's review screen
 N BY,TIUI,TIUX,SCREEN,STATUS,RANGE,TIUBY,TIUDOCS,XREF
 S TIUX=$G(^TMP("TIUR",$J,0)),STATUS=$P(TIUX,U,2),SCREEN=$P(TIUX,U,3,99)
 S VALM("TITLE")=$S($L(STATUS,",")>1:$S(VALM("ENTITY")="Document":"Clinical",1:""),1:STATUS)
 I $G(XQY0)["MY UNSIGNED" S VALM("TITLE")="MY UNSIGNED"
 S:$L(VALM("TITLE")) VALM("TITLE")=VALM("TITLE")_" "
 S VALM("TITLE")=VALM("TITLE")_$S($L(VALM("ENTITY")):$$NTTNM(VALM("ENTITY")),1:"Document")_"s"
 I +TIUEDT>1 S RANGE=" from "_$$DATE^TIULS(TIUEDT,"MM/DD/YY")_" to "_$$DATE^TIULS(TIULDT,"MM/DD/YY")
 F TIUI=1:1:$L(SCREEN,";") D
 . S XREF=$P($P(SCREEN,";",TIUI),U),XREF=$O(^TIU(8925.8,"C",XREF,0))
 . I $D(TIUQUIK) D
 . . S TIUBY=$G(TIUBY)_$S($G(TIUBY)]"":" or ",1:"")
 . E  D
 . . S TIUBY=$G(TIUBY)_$S($G(TIUBY)]"":" and ",1:"")
 . S TIUBY=$G(TIUBY)_$P($G(^TIU(8925.8,+XREF,0)),U)
 . S:$P($P(SCREEN,";",TIUI),U,3)]"" TIUBY=$G(TIUBY)_" ("_$P($P(SCREEN,";",TIUI),U,3)_")"
 S BY="by "_TIUBY
 ; I BY'["ALL",(BY'["SUBJECT") S BY=BY_" for "_$P($P(SCREEN,U,3),";")
 S VALMHDR(1)=$$CENTER^TIULS(BY_$S($L(SCREEN,";")=1:$G(RANGE),1:""))
 S TIUDOCS=$J(+$G(^TMP("TIUR",$J,0)),4)_" documents"
 S VALMHDR(1)=$$SETSTR^VALM1(TIUDOCS,VALMHDR(1),(IOM-$L(TIUDOCS)),$L(TIUDOCS))
 ; I $L($G(RANGE)) S VALMHDR(2)=$$CENTER^TIULS(RANGE)
 Q
NTTNM(NAME) ; Handle plural names appropriately
 I "Yy"[$E(NAME,$L(NAME)) S NAME=$E(NAME,1,($L(NAME)-1))_"ie"
 I NAME="Discharge Summarie" S NAME="Disch Summarie"
 Q NAME
