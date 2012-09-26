TIULA1 ; SLC/JER - More interactive functions ;01-Aug-2011 11:30;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**75,113,1009**;Jun 20, 1997;Build 22
 ;IHS/MSC/MGH Changes made to correspond with IHS division setup
TRAVERSE(DA,RETURN,PARM,TYPE) ; Select Document Type(s)
 N C,I,XQORM,Y N:'$D(LEVEL) LEVEL S LEVEL=+$G(LEVEL)+1
 S:$G(TYPE)']"" TYPE="D"
 S XQORM=DA_";TIU(8925.1,",XQORM(0)=$S($L($G(PARM)):PARM,1:"AD")
 I XQORM(0)["D" S XQORM("H")="W !!,$$CENTER^TIULS(""--- ""_$P(^TIU(8925.1,+DA,0),U,3)_"" ---""),!"
 S XQORM("B")=$G(^DISV(DUZ,"XQORM",DA_";TIU(8925.1,",1))
 S XQORM("A")="Select "_$S(XQORM(0)["D":"Document",1:$P(^TIU(8925.1,+DA,0),U,3))_$S("CD"[$P(^TIU(8925.1,+DA,0),U,4):" Component",1:" Type")_$S(+XQORM(0)'=1:"(s)",1:"")_": "
 D EN^XQORM
 M RETURN(LEVEL)=Y
 S I=0 F  S I=$O(Y(I)) Q:+I'>0  D
 . S J=+$P(Y(I),U,2)
 . I $P(^TIU(8925.1,+J,0),U,4)'=TYPE,$D(^TIU(8925.1,+J,10))'<10 D TRAVERSE(+J,.RETURN,$G(PARM))
 Q
ASKSIG() ; Prompt for ES, return encrypted data
 N ESNAME,ESTITLE,Y S Y=0
 D SIG^XUSESIG I X1']"" S:'$D(X) X=0 D BADSIG^TIULG(X) G ASKX
 S ESNAME=$P($G(^VA(200,DUZ,20)),U,2),ESTITLE=$P($G(^(20)),U,3)
 S Y=1_U_ESNAME_U_ESTITLE
ASKX Q Y
ASKSUBJ() ; Handle query by subject
 N Y
 S Y=$$READ^TIUU("FO","Where SUBJECT CONTAINS")
 Q $$UPPER^TIULS(Y)
ASKLOC() ; Handle query by location
 N Y
 S Y=$$READ^TIUU("P^44:AEMQ","Select HOSPITAL LOCATION")
 Q Y
TYPMATCH(TYPE,CURTYP) ; Check for type match
 N TIUI,TIUY S TIUY=0
 I $L(TYPE,"!")=1,TYPE=CURTYP S TIUY=1
 E  F TIUI=1:1:$L(TYPE,"!") I $P(TYPE,"!",TIUI)=CURTYP S TIUY=1 Q
 Q TIUY
DOCLIST(CLASS,Y,PARM,DFLT) ; Get preferred documents for user
 N TIUDA,XQORM,X
 S TIUDA=+$O(^TIU(8925.98,"AC",DUZ,CLASS,0)),XQORM=TIUDA_";TIU(8925.98,"
 I +TIUDA'>0!(+$O(^XUTL("XQORM",XQORM,0))'>0) S Y=-1 Q
 I $G(DFLT)="LAST" D
 . S DFLT=$O(^DISV(DUZ,"XQORM",XQORM,0))
 . S DFLT=$S(+DFLT:$G(^DISV(DUZ,"XQORM",XQORM,DFLT)),1:"")
 S XQORM(0)=$S(+$P($G(^TIU(8925.98,+TIUDA,10,0)),U,3)=1:"F",1:PARM)
 S XQORM("B")=$S(+$P($G(^TIU(8925.98,+TIUDA,10,0)),U,3)=1:$P($G(^(0)),U,3),1:DFLT)
 I XQORM(0)'["A" S X=XQORM("B")
 S XQORM("A")=$S(CLASS=3:"",1:"Select ")_$S(CLASS=3:"TITLE",1:"Document")_$S(+XQORM(0)'=1:"(s)",1:"")_": "
 I XQORM(0)["D" D
 . N LISTNAME,PERSNAME S LISTNAME=$$PNAME^TIULC1(CLASS)
 . I $E(LISTNAME,$L(LISTNAME))="Y" D
 . . S LISTNAME=$E(LISTNAME,1,($L(LISTNAME)-1))_"IES"
 . I $E(LISTNAME,$L(LISTNAME))="y" D
 . . S LISTNAME=$E(LISTNAME,1,($L(LISTNAME)-1))_"ies"
 . S PERSNAME=$$PERSNAME^TIULC1(DUZ)
 . S LISTNAME=""""_"--- "_LISTNAME_" for "_PERSNAME_" ---"_""""
 . S XQORM("H")="W !!,$$CENTER^TIULS("_LISTNAME_"),!"
 S XQORM("S")="I $$CANPICK^TIULP(+$G(^TIU(8925.98,+DA(1),10,+DA,0)))"
 D EN^XQORM
 Q
SELCAT(Y,PARM,DFLT) ; Get preferred documents for user
 N TIUI,TIUDA,CATREC,CATLOOK,CATSCRN,CATVAL,XQORM,X ;P75 newed CATVAL
 S TIUI=0
 S XQORM="1;TIU(8925.8,"
 I $G(DFLT)="LAST" D
 . S DFLT=$O(^DISV(DUZ,"XQORM",XQORM,0))
 . S DFLT=$S(+DFLT:$G(^DISV(DUZ,"XQORM",XQORM,DFLT)),1:"")
 S XQORM(0)=$G(PARM,"1A")
 S XQORM("B")=$G(DFLT,"AUTHOR")
 I +$G(ORVP) S XQORM("S")="I $G(^XUTL(""XQORM"",XQORM,+$O(^XUTL(""XQORM"",XQORM,""B"",DA,0)),0))'[""Patient"""
 I XQORM(0)'["A" S X=XQORM("B")
 S XQORM("A")="Select SEARCH CATEGOR"_$S(+XQORM(0)'=1:"IES",1:"Y")_": "
 I XQORM(0)["D" S XQORM("H")="W !!,$$CENTER^TIULS(""--- Search Categories ---""),!"
 D EN^XQORM
 F  S TIUI=$O(Y(TIUI)) Q:+TIUI'>0  D
 . S TIUDA=+$P(Y(TIUI),U,2)
 . S CATREC=$G(^TIU(8925.8,TIUDA,0))
 . S CATSCRN=$G(^TIU(8925.8,TIUDA,1))
 . S CATLOOK=$G(^TIU(8925.8,TIUDA,2))
 . S CATVAL=-1 ;P75
 . I CATLOOK']"",+$P(CATREC,U,4) S CATVAL=$$DICLOOK(CATREC,CATSCRN)
 . I CATLOOK]"" S CATVAL=$$LOOK(CATLOOK)
 . I +CATVAL'=-1,$L(CATVAL) S Y(TIUI)=$P(CATREC,U,2)_U_CATVAL
 . E  K Y(TIUI) S Y=+$G(Y)-1
 Q
DICLOOK(CATEGORY,SCREEN) ; Call ^DIC to get category value
 N DIC,X,Y
 S DIC=+$P(CATEGORY,U,4),DIC(0)="AEMQZ"
 S DIC("A")="Select "_$P(CATEGORY,U)_": "
 I SCREEN]"" X SCREEN
 D ^DIC I +$G(DUOUT),(X="^^") S DIROUT=1
 Q Y
LOOK(LOOKUP) ; Execute LOOKUP CODE
 N X,Y
 X LOOKUP
 Q Y
GETVSIT(DFN) ; Visit selection code
 N X,Y
 I +$G(ORVP),'+$G(DFN) S DFN=+$G(ORVP)
 D MAIN^TIUVISIT(.Y,$G(DFN))
 S Y=$G(Y("VISIT"))
 I +Y,+$P(Y,U,2) S $P(Y,U,2)=$$DATE^TIULS($P(Y,U,2),"MM/DD/YY HR:MIN")
 Q Y
GETTERM(X) ; Get Lexicon term
 N DIC,USEX,Y
 S DIC=757.01,DIC(0)="AEMQZ",DIC("A")="Select PROBLEM: "
 D ^DIC
 I +Y'>0,(X]""),(X'=" "),(X'["^") D
 . S USEX=$$READ^TIUU("Y",">>>  Use "_X,"Yes")
 . I +USEX S Y=1_U_X
 Q Y
GETDIV() ; Get Institution Number and Name
 N TIUDIV,TIUSTN,Y,IHSDIV
 ;IHS/MSC/MGH Division changes to be in line with IHS
 ;S TIUDIV=$S($P($G(^DG(43,1,"GL")),U,2):$$MULTDIV,1:$$PRIM^VASITE)
 D DIVGET^XUSRB2(.IHSDIV,DUZ)
 I IHSDIV(2)>1 S TIUDIV=$$MULTDIV
 E  S TIUDIV=$$PRIM^VASITE
 S TIUSTN=$$SITE^VASITE(,TIUDIV)
 ; end of IHS mod
 I $P(TIUSTN,U)>0,($P(TIUSTN,U,2)]"") D
 . S Y=$P(TIUSTN,U)_U_$P(TIUSTN,U,2)
 E  D
 . S Y=-1
 Q Y
MULTDIV() ; User selects from active divisions
 N DIR,X,Y
 S DIR(0)="PA^40.8:EM"
 S DIR("A")="Select DIVISION: "
 S DIR("S")="I $$SITE^VASITE(,+Y)>0"
 D ^DIR
 Q +Y
