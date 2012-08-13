VENPCCC1 ; IHS/OIT/GIS - CHECK LIST EDITING AND VIEWING ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ;
AIC ; EP-ATTACH AN ITEM TO A CHECKLIST
 N IIEN,DIC,LIEN,DA,X,Y
 W !,"Select an ITEM to assign to a checklist ->"
 S IIEN=$$SI I 'IIEN Q
 D ATI(IIEN)
 S DIC="^VEN(7.9,",DIC(0)="AEQL",DLAYGO=19707.9
 S DIC("A")="Select a CHECKLIST: "
 D ^DIC I Y=-1 Q
 S LIEN=+Y
 I $D(^VEN(7.91,IIEN,2,"B",LIEN)) W !,"This item is already in this checklist.  Try again..." Q
 S DA(1)=IIEN S DIC="^VEN(7.91,"_DA(1)_",2,"
 S DIC("P")="19707.912P" S DIC(0)="L",DLAYGO=19707.912
 S X="`"_LIEN
 D ^DIC
 W !,"OK, this item will now appear on the checklist!"
 D ^XBFMK
 Q
 ;
DIC ; EP-DELETE AN ITEM FROM A CHECKLIST
 N DIK,DA,X,Y,%,IIEN,DICS,LIEN,STG,CNT,ARR,CNAME,PCE,CKIEN
 W !,"Select the ITEM to be deleted ->"
 N %
 S %=$$SI I '% Q
 D AT(%)
 S IIEN=% S STG="" S LIEN=0
 F  S LIEN=$O(^VEN(7.91,IIEN,2,"B",LIEN)) Q:'LIEN  S STG=STG_LIEN_"|"_$O(^VEN(7.91,IIEN,2,"B",LIEN,0))_U
 I '$L(STG) W !,"This item is not currently assigned to any checklists!" Q
 I $L(STG,U)=2 D  Q  ; IF THERE IS ONLY ONE CHECKLIST
 . S %=$P(STG,U) I '$L(%) Q
 . S LIEN=+% I 'LIEN Q
 . S CKIEN=$P(%,"|",2) I 'CKIEN Q
 . S CNAME=$P($G(^VEN(7.9,LIEN,0)),U) I '$L(CNAME) Q
 . W !,"This item is currently assigned to the "_CNAME_" checklist",!,"Sure you want to delete it"
 . S %="" D YN^DICN I %'=1 Q
 . S DA=$O(^VEN(7.91,IIEN,2,"B",LIEN,0)) I 'DA Q  ; PATCHED BY GIS/OIT 1/15/06 ; PCC+ 2.5 PATCH 2
 . D DICD
 . Q
 W !,"This item is currently assigned to the following checklists ->" ; MULTIPLE CHECKLISTS
 S CNT=0
 F PCE=1:1:($L(STG,U)-1) S %=$P(STG,U,PCE) I $L(%) D
 . S LIEN=+% I 'LIEN Q
 . S CKIEN=$P(%,"|",2) I 'CKIEN Q
 . S CNAME=$P($G(^VEN(7.9,LIEN,0)),U) I '$L(CNAME) Q
 . S CNT=CNT+1
 . S ARR(CNT)=CKIEN
 . W !?3,CNT,?6,CNAME
 . Q
 S DIR("A")="The item will be deleted from which checklist"
 S DIR(0)="N^1:"_CNT_":0" D ^DIR
 I $G(DUOUT)!($G(DTOUT)) G DICX
 I 'Y G DICX
 S DA=$G(ARR(Y)) I 'DA G DICX
DICD S DA(1)=IIEN S DIK="^VEN(7.91,"_DA(1)_",2," ; DELETE THE SUBFILE ENTRY
 D ^DIK
 W !,"OK, this item has been removed from the checklist..."
DICX D ^XBFMK ; CLEANUP
 Q
 ;
ACT ; EP-ASSIGN A CHECKLIST TO A TEMPLATE
 W !,"Select a checklist to assign to a PCC+ template ->"
 N LIEN,DA,DIC,X,Y,%,%Y
 S LIEN=$$SC I 'LIEN Q
 W ! D AT(LIEN,1)
 W !
 S DIC("A")="Assign this checklist to what PCC+ template: "
 S DIC="^VEN(7.41,",DIC(0)="AEQL",DLAYGO=19707.41
 D ^DIC I Y=-1 Q
 I $D(^VEN(7.41,+Y,17,"B",LIEN)) W !,"This checklist is already on the template! Request cancelled..." D ^XBFMK Q
 W !,"Are you sure" S %="" D YN^DICN I %'=1 Q
 S DA(1)=+Y
 S DIC="^VEN(7.41,"_DA(1)_",17,",DIC(0)="L"
 S DIC("P")="19707.4117P",DLAYGO=19707.4117
 S X="`"_LIEN
 D ^DIC I Y=-1 Q
 D ^XBFMK
 W !,"OK, this checklist will now appear on the template!"
 Q
 ; 
DCT ; EP-DELETE A CHECKLIST FROM A PCC+ TEMPLATE
 N DIC,X,Y,DA,CNAME,CKIEN,LIEN,TNAME
 S DIC("A")="PCC+ Template: "
 S DIC="^VEN(7.41,",DIC(0)="AEQM"
 D ^DIC I Y=-1 G DCTX
 S DA(1)=+Y S TNAME=$P(Y,U,2)
 S DIC="^VEN(7.41,"_DA(1)_",17,",DIC(0)="AEQM"
 S DIC("A")="Which CHECKLIST do you want to delete: "
 D ^DIC I Y=-1 G DCTX
 S CKIEN=+Y I 'CKIEN Q
 S LIEN=$P($G(^VEN(7.41,DA(1),17,CKIEN,0)),U) I 'LIEN Q
 S CNAME=$P($G(^VEN(7.9,LIEN,0)),U)
 W !!,"The ",CNAME," checklist has been deleted from",!,"the ",TNAME," template..."
DCTX D ^XBFMK
 Q
 ; 
VI ; EP-VIEW AN ITEM
 N %
 S %=$$SI I '% Q
 D ATI(%)
 Q
 ;
VC ; EP-VIEW CHECLIST PROPERTIES
 N %
 S %=$$SC I '% Q
 D AT(%,1)
 Q
 ;
AC ; EP-ADD A CHECKLIST
 N DA,DIR,DIC,DIE,DR,%,NAME,OGIEN,PMN,X,Y
AC1 S DIR(0)="FO^1:25",DIR("A")="Name of new CHECKLIST"
 D ^DIR
 I X?1."^"!(X="") G ACFIN
 I $G(DIRUT)!($G(DTOUT)) G ACFIN
 I $D(^VEN(7.9,"B",X)) W !,"This name has already been used.  Try again..." G AC1
 S NAME=X
 S DIC="^VEN(7.98,",DIC(0)="AEQM",DIC("A")="Checklist content: "
 D ^DIC I Y=-1 Q
 S OGIEN=+Y
 S PMN=$P($G(^VEN(7.98,OGIEN,0)),U,2) I '$L(PMN) Q
 S %=(" ("_PMN_")") I NAME'[% S NAME=NAME_%
 I $D(^VEN(7.9,"B",NAME)) W !,"The name '"_NAME_"' has already been used." W !,"Try again..." G AC1
 S DIC="^VEN(7.9,",DIC(0)="L",DLAYGO=19707.9,X=NAME
 D ^DIC I Y=-1 Q
 S DIE=DIC,DA=+Y,DR=".02////^S X=OGIEN;.03;.04"
 D ^DIE
 W !,"OK, "_NAME_" has been added as a new checklist..."
ACFIN D ^XBFMK
 Q
 ; 
GCPT ; EP-GLOBAL EDIT OF CPT CODE
 N DIR,DA,%,%Y,IIEN,C1,C2,X
 S DIR(0)="F^1:9",DIR("A")="Change code from" S DIR("?")="Enter the CPT code to be changed."
 D ^DIR
 I $G(DUOUT)!$G(DTOUT) G GCPTX
 I '$L(Y) G GCPTX
 S FROM=Y
 S DIR(0)="F^1:9",DIR("A")="Change code to" S DIR("?")="Enter the new CPT code."
 D ^DIR
 I $G(DUOUT)!$G(DTOUT) G GCPTX
 I '$L(Y) G GCPTX
 S TO=Y
 W !,"Sure you want to change every instance of a CPT code from ",FROM," to ",TO
 S %="" D YN^DICN
 I %'=1 G GCPTX
 S IIEN=0
 F  S IIEN=$O(^VEN(7.91,IIEN)) Q:'IIEN  D  ; GLOBAL SUBSTITUTION
 . S X=$G(^VEN(7.91,IIEN,0)) I '$L(X) Q
 . S Y=0
 . S C1=$P(X,U,7) I C1=FROM S $P(X,U,7)=TO,Y=1
 . S C2=$P(X,U,8) I C2=FROM S $P(X,U,8)=TO,Y=1
 . I 'Y Q
 . S ^VEN(7.91,IIEN,0)=X
 . W !,"The code for ",$P(X,U)," has been changed!"
 . Q
GCPTX D ^XBFMK
 Q
 ;
AI ;EP- ADD AN ITEM
 N DIC,DIE,DA,DR,X,Y
 S DIC="^VEN(7.91," S DLAYGO=19707.91
 S DIE=DIC S DIC(0)="AEQMLX"
 S DIC("A")="Name of NEW ITEM: "
 D ^DIC I Y=-1 Q
 S DA=+Y
 S DR=".03:.1"
 D ^DIE
 D ^XBFMK K DDER
 Q
 ;
DI ; EP-DELETE AN ITEM
 N IIEN,DIK,DA,%,%Y
 W !!,"Select an item to DELETE ->"
 S IIEN=$$IASK I 'IIEN Q
 D ATI(IIEN)
 W !!,"Are you sure you want to DELETE this item"
 S %=""  D YN^DICN I %'=1 Q
 S DIK="^VEN(7.91,",DA=IIEN
 D ^DIK
 D ^XBFMK
 Q
 ;
EI ; EP-EDIT AN ITEM
 N IIEN,DIE,DR,DA,X,Y
 W !!,"Select an item to EDIT ->"
 S IIEN=$$IASK I 'IIEN Q
 D ATI(IIEN)
 S DIE="^VEN(7.91,",DA=IIEN
 S DR=".01;.03:.1"
 D ^DIE
 D ^XBFMK
 Q
 ;
SC() ; EP-SELECT A CHECKLIST
 N ARR,CNT,NAME,LIEN,OGIEN,MN,PCE,SEL,%
 S CNT=0 S NAME=""
 F  S NAME=$O(^VEN(7.9,"B",NAME)) Q:NAME=""  D
 . S LIEN=$O(^VEN(7.9,"B",NAME,0)) I 'LIEN Q
 . S %=$G(^VEN(7.9,LIEN,0)) I '$L(%) Q
 . S OGIEN=$P(%,U,2) I 'OGIEN Q
 . S PRE=$P(%,U,3) S POST=$P(%,U,4)
 . S MN=$P($G(^VEN(7.98,OGIEN,0)),U,3) I MN="" Q
 . S CNT=CNT+1
 . S ARR(CNT)=CNT_"|0^"_NAME_"|4^"_MN_"|35^"_PRE_"|50^"_POST_"|60"
 . S ARR(CNT,0)=LIEN
 . Q
CLIST W !!,$E($T(CHDR),8,999),!,$E($T(CSEP),8,999)
 G LIST
 ;
IASK(DICS) ; EP - ASK FOR AN ITEM
 N DIC,X,Y
 I $L($G(DICS)) S DIC("S")=DICS
 S DIC="^VEN(7.91,",DIC(0)="AEQM"
 S DIC("A")="Checklist ITEM: "
 D ^DIC I Y=-1 Q ""
 Q +Y
 ; 
SI() ; EP - SELECT AN ITEM
 N CNT,IIEN,X,Y,Z,%,NAME,GRP,CODE1,CODE2,PRE,POST,PCE,SEL,ARR,CFLG
 S CNT=0,NAME="",CFLG=1
 F  S NAME=$O(^VEN(7.91,"B",NAME)) Q:NAME=""  D  ; MAKE DISPLAAY ARRAY
 . S IIEN=$O(^VEN(7.91,"B",NAME,0)) I 'IIEN Q
 . S X=$G(^VEN(7.91,IIEN,0)) I '$L(X) Q
 . S CNT=CNT+1
 . S GRP=""
 . I $P(X,U,3) S GRP=GRP_"I"
 . I $P(X,U,4) S GRP=GRP_"C"
 . I $P(X,U,5) S GRP=GRP_"M"
 . I $P(X,U,6) S GRP=GRP_"W"
 . S CODE1=$P(X,U,7)
 . S CODE2=$P(X,U,8)
 . S ARR(CNT)=CNT_"|0^"_NAME_"|4^"_GRP_"|34^"_CODE1_"|39^"_CODE2_"|49^"
 . S ARR(CNT,0)=IIEN
 . Q
ILIST W !!,$E($T(IHDR),8,999),!,$E($T(ISEP),8,999)
LIST S CNT=0 S SEL=""
 F  S CNT=$O(ARR(CNT)) Q:'CNT  D  I $L(SEL) Q
 . W !
 . I (CNT#16)=0 D  I $L(SEL) Q
 .. W "Enter 1-"_(CNT-1)_" or press <Enter> to see more: "
 .. K % R %:$G(DTIME,60)
 .. I $G(%)!(%?1."^") S SEL=% Q
 .. W $C(13),?78,$C(13)
 .. Q
 . F PCE=1:1:$L(ARR(CNT),U) S X=$P(ARR(CNT),U,PCE) D
 .. S Y=$P(X,"|"),Z=$P(X,"|",2)
 .. W ?Z,Y
 .. Q
 . Q
 I SEL="" W !,"Enter 1-"_$O(ARR(999),-1)_" or press '^' to quit: " R SEL:$G(DT,60) E  Q ""
 I SEL?1."^"!(SEL="") Q ""
 I '$D(ARR(SEL)) W "  ??" G ILIST
 I $G(CFLG) W " (",$P($G(^VEN(7.91,ARR(SEL,0),0)),U),")" ; CONFIRM SELECTION
 W !
 Q ARR(SEL,0)
 ;
ATI(IIEN) ; EP-ASSOCIATED TEMPLATES FOR ITEMS
 I '$O(^VEN(7.91,+$G(IIEN),2,0)) W !,"This item is not associated with any checklists or templates!" Q
 N CKIEN,LIEN
 W !,"This item is associated with the following checklists and PCC+ templates: "
 S CKIEN=0 F  S CKIEN=$O(^VEN(7.91,IIEN,2,CKIEN)) Q:'CKIEN  D
 . S LIEN=$P($G(^VEN(7.91,IIEN,2,CKIEN,0)),U) I 'LIEN Q
 . D AT(LIEN)
 . Q
 Q
 ; 
AT(LIEN,MODE) ; EP-LIST TEMPLATES ASSOCIATED WITH A CHECKLIST
 N NAME,STG,TIEN,I,%,TAB
 S MODE=+$G(MODE)
 S TAB=3 I MODE S TAB=0
 S NAME=$P($G(^VEN(7.9,LIEN,0)),U) I '$L(NAME) Q
 W !,?TAB W:MODE "PCC+ templates associated with " W NAME
 S STG="",TIEN=0
 S TAB=6 I MODE S TAB=3
 F  S TIEN=$O(^VEN(7.41,TIEN)) Q:'TIEN  I $O(^VEN(7.41,TIEN,17,"B",LIEN,0)) S STG=STG_TIEN_U
 I STG="" W !,?TAB,"No PCC+ templates are associated with this checklist!" Q
 F I=1:1:($L(STG,U)-1) S TIEN=$P(STG,U,I) S %=$P($G(^VEN(7.41,TIEN,0)),U) I $L(%) W !,?TAB,%
 Q
 ; 
IHDR ; #   ITEM                          GRP  CODE1     CODE2    
ISEP ; --- ----------------------------- ---- --------- ---------
CHDR ; #   NAME                           MAIL MERGE FLD PRE       POST
CSEP ; --- ------------------------------ -------------- --------- ---------
