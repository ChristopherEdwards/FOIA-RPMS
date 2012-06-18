GMPLBLD2 ; SLC/MKB -- Bld PL Selection Lists cont ;;9-5-95 11:52am
 ;;2.0;Problem List;**3**;Aug 25, 1994
NEWGRP ; Change problem groups
 N NEWGRP D FULL^VALM1
 I $D(GMPLSAVE),$$CKSAVE D SAVE
NG1 S NEWGRP=$$GROUP("L") G:+NEWGRP'>0 NGQ G:+NEWGRP=+GMPLGRP NGQ
 L +^GMPL(125.11,+NEWGRP,0):1 I '$T D  G NG1
 . W $C(7),!!,"This category is currently being edited by another user!",!
 L -^GMPL(125.11,+GMPLGRP,0) S GMPLGRP=NEWGRP
 D GETLIST^GMPLBLDC,BUILD^GMPLBLDC("^TMP(""GMPLIST"",$J)",GMPLMODE),HDR^GMPLBLDC
NGQ S VALMBCK="R",VALMSG=$$MSG^GMPLX
 Q
 ;
GROUP(L) ; Lookup into Problem Selection Group file #125.11
 N DIC,X,Y,DLAYGO ; L = "" or "L", if LAYGO is [not] allowed
 S DIC="^GMPL(125.11,",DIC(0)="AEQMZ"_L,DIC("A")="Select CATEGORY NAME: "
 S:DIC(0)["L" DLAYGO=125.11
 D ^DIC S:Y'>0 Y="^" S:Y'="^" Y=+Y_U_Y(0)
 Q Y
 ;
NEWLST ; Change selection lists
 N NEWLST D FULL^VALM1
 I $D(GMPLSAVE),$$CKSAVE D SAVE
NL1 S NEWLST=$$LIST("L") G:+NEWLST'>0 NLQ G:+NEWLST=+GMPLSLST NLQ
 L +^GMPL(125,+NEWLST,0):1 I '$T D  G NL1
 . W $C(7),!!,"This list is currently being edited by another user!",!
 L -^GMPL(125,+GMPLSLST,0) S GMPLSLST=NEWLST
 D GETLIST^GMPLBLD,BUILD^GMPLBLD("^TMP(""GMPLIST"",$J)",GMPLMODE),HDR^GMPLBLD
NLQ S VALMBCK="R",VALMSG=$$MSG^GMPLX
 Q
 ;
LIST(L) ; Lookup into Problem Selection List file #125
 N DIC,X,Y,DLAYGO ; L="" or "L" if LAYGO [not] allowed
 S DIC="^GMPL(125,",DIC(0)="AEQMZ"_L,DIC("A")="Select LIST NAME: "
 S:DIC(0)["L" DLAYGO=125
 D ^DIC S:Y'>0 Y="^" S:Y'="^" Y=+Y_U_Y(0)
 Q Y
 ;
LAST(ROOT) ; Returns last subscript
 N I,J S (I,J)=""
 F  S I=$O(@(ROOT_"I)")) Q:I=""  S J=I
 Q J
 ;
CKSAVE() ; Save [changes] ??
 N DIR,X,Y,TEXT S TEXT=$S($D(GMPLGRP):"category",1:"list")
 S DIR("A")="Save the changes to this "_TEXT_"? ",DIR("B")="YES"
 S DIR("?",1)="Enter YES to save the changes that have been made to this "_TEXT,DIR("?")="before exiting it; NO will leave this "_TEXT_" unchanged."
 S DIR(0)="YA" D ^DIR
 Q +Y
 ;
SAVE ; Save changes to group/list
 N LABEL,DA W !!,"Saving ..."
 S DA=0,LABEL=$S($D(GMPLGRP):"SAVGRP",1:"SAVLST")
 F  S DA=$O(^TMP("GMPLIST",$J,DA)) Q:+DA'>0  D @LABEL
 K GMPLSAVE S:$D(GMPLGRP) GMPSAVED=1
 S VALMBCK="Q" W " done." H 1
 Q
SAVGRP ; Save changes to existing group
 N DIK,DIE,DR,ITEM S DIK="^GMPL(125.12,"
 I +DA'=DA D  Q
 . Q:"@"[$G(^TMP("GMPLIST",$J,DA))  ; nothing to save
 . S TMPITEM=^TMP("GMPLIST",$J,DA) D NEW(DIK,+GMPLGRP,TMPITEM)
 I "@"[$G(^TMP("GMPLIST",$J,DA)) D ^DIK Q
 S ITEM=$P($G(^GMPL(125.12,DA,0)),U,2,5)
 I ITEM'=^TMP("GMPLIST",$J,DA) D
 . S DR="",DIE=DIK
 . F I=1:1:4 S:$P(^TMP("GMPLIST",$J,DA),U,I)'=$P(ITEM,U,I) DR=DR_";"_I_"////"_$S($P(^TMP("GMPLIST",$J,DA),U,I)="":"@",1:$P(^TMP("GMPLIST",$J,DA),U,I))
 . S:$E(DR)=";" DR=$E(DR,2,999) D ^DIE
 Q
 ;
SAVLST ; Save changes to existing list
 N DIK,DIE,DR,ITEM S DIK="^GMPL(125.1,"
 I +DA'=DA D  Q  ; new link
 . Q:"@"[$G(^TMP("GMPLIST",$J,DA))  ; nothing to save
 . S TMPLST=^TMP("GMPLIST",$J,DA) D NEW(DIK,+GMPLSLST,TMPLST)
 I "@"[$G(^TMP("GMPLIST",$J,DA)) D ^DIK Q
 S ITEM=$P($G(^GMPL(125.1,DA,0)),U,2,5)
 I ITEM'=^TMP("GMPLIST",$J,DA) D
 . S DR="",DIE=DIK
 . F I=1,2,3,4 S:$P(^TMP("GMPLIST",$J,DA),U,I)'=$P(ITEM,U,I) DR=DR_";"_I_"////"_$S($P(^TMP("GMPLIST",$J,DA),U,I)="":"@",1:$P(^TMP("GMPLIST",$J,DA),U,I))
 . S:$E(DR)=";" DR=$E(DR,2,999) D ^DIE
 Q
 ;
NEW(DIK,LIST,ITEM) ; Create new entry in Contents file #125.1 or #125.12
 N I,HDR,LAST,TOTAL,DA
 S HDR=$G(@(DIK_"0)")),LAST=$P(HDR,U,3),TOTAL=$P(HDR,U,4)
 F I=(LAST+1):1 Q:'$D(@(DIK_"I,0)"))
 S DA=I,@(DIK_"DA,0)")=LIST_U_ITEM
 S $P(@(DIK_"0)"),U,3,4)=DA_U_(TOTAL+1)
 D IX1^DIK ; set Xrefs
 Q
 ;
DELETE ; Delete problem group
 N DIR,X,Y,DA,DIK,IFN S VALMBCK=$S(VALMCC:"",1:"R")
 I $D(^GMPL(125.1,"G",+GMPLGRP)) W $C(7),!!,">>>  This category belongs to at least one problem selection list!",!,"     CANNOT DELETE" H 2 Q
 S DIR(0)="YA",DIR("B")="NO",DIR("A")="Are you sure you want to delete the entire '"_$P(GMPLGRP,U,2)_"' category? "
 S DIR("?")="Enter YES to completely remove this category and all its items."
 D ^DIR Q:'Y
DEL1 ; Ok, go for it ...
 W !!,"Deleting category items ..."
 F IFN=0:0 S IFN=$O(^GMPL(125.12,"B",+GMPLGRP,IFN)) Q:IFN'>0  S DA=IFN,DIK="^GMPL(125.12," D ^DIK W "."
 S DA=+GMPLGRP,DIK="^GMPL(125.11," D ^DIK W "."
 L -^GMPL(125.11,+GMPLGRP,0) S GMPLGRP=0 K GMPLSAVE W " <done>"
 D NEWGRP S:+GMPLGRP'>0 VALMBCK="Q"
 Q
