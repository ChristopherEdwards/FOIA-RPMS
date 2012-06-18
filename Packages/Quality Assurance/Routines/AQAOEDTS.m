AQAOEDTS ; IHS/ORDC/LJF - MULTIPLE FIELDS EDITS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is called by various data entry rtns to handle file-driven
 ;user interface for the section defined before this call.
 ;
OPT ; >>> get data entry option from review type
 Q:'$D(^AQAQX(AQAOPT,0))  ;bad pointer in review type file
 ;
 ; >>> for each review, choose multiples to enter/edit
LOOP ; >>> find all screens available to work on & put in proper order
 S AQAOSC=0 ;screen's entry # in multiple
 F  S AQAOSC=$O(^AQAQX(AQAOPT,"PG","B",AQAOSC)) Q:AQAOSC=""  D
 .S AQAOSN=0 ;screen's order #
 .F  S AQAOSN=$O(^AQAQX(AQAOPT,"PG","B",AQAOSC,AQAOSN)) Q:AQAOSN=""  D
 ..Q:'$D(^AQAQX(AQAOPT,"PG",AQAOSN,0))
 ..S AQAOPTL=$P(^AQAQX(AQAOPT,"PG",AQAOSN,0),U,3) ;screen title
 ..S AQAOP(AQAOSC)=AQAOPTL_U_AQAOSN ;array with screens in order
 ..Q
 ;
 ; >>> loop thru array for each screen and allow user to edit
 S AQAOSC=0,X="" K DUOUT ;PATCH 3
 F  S AQAOSC=$O(AQAOP(AQAOSC)) Q:AQAOSC=""  Q:$D(DUOUT)  Q:X=U  D
 .S AQAOPTL=$P(AQAOP(AQAOSC),U),AQAOSN=$P(AQAOP(AQAOSC),U,2)
 .K DIR S Y=$P(^AQAQX(AQAOPT,"PG",AQAOSN,0),U,2)
 .S C=$P(^DD(9002166.11,.02,0),U,2) D Y^DIQ S DIR("A")=Y
 .;
 .; >>> display items and ask user for choice, and then edit via ^die
 .S AQAOSTR=$G(^AQAQX(AQAOPT,"PG",AQAOSN,1))
 .I ($P(AQAOSTR,U)'="") D MULTFIND Q  ;multiple entries in linked file
 .D ITEMFIND Q  ;multiple fields in occ file
 ;
END Q
 ;
 ;
ITEMFIND ; >> SUBRTN to find each items on screen and display them by number<<
 ;
 ; >>> find items for this screen
 K AQAOA S AQAOTM=0 W !!!,"<<",AQAOPTL,">>",!
 F  S AQAOTM=$O(^AQAQX(AQAOPT,"PG",AQAOSN,"IT","B",AQAOTM)) Q:AQAOTM'=+AQAOTM  D
 .S AQAOTMN=0
 .F  S AQAOTMN=$O(^AQAQX(AQAOPT,"PG",AQAOSN,"IT","B",AQAOTM,AQAOTMN)) Q:AQAOTMN=""  D
 ..Q:'$D(^AQAQX(AQAOPT,"PG",AQAOSN,"IT",AQAOTMN,0))  S AQAOMFL=^(0)
 ..;
 ..; >>> print items in order with contents and save field # in array
 ..S AQAOFLD=$P(AQAOMFL,U,2)
 ..W !,$J(+AQAOMFL,2),")  ",$P(^DD(9002167,AQAOFLD,0),U) ;# & descrpt
 ..K ^UTILITY("DIQ1",$J) K DIQ,DR
 ..S (DIC,AQAOFL)=9002167,DA=AQAOIFN,DR=AQAOFLD D EN^DIQ1
 ..I $D(^UTILITY("DIQ1",$J,AQAOFL,DA,AQAOFLD)) W ?45,^(AQAOFLD)
 ..K ^UTILITY("DIQ1",$J)
 ..S AQAOA(+AQAOMFL)=AQAOFLD ;set array with # and field
 ;
 ; >>> choose items to edit and edit via ^die
 S (AQAOTM,AQAOXX)=0 W !
 F  S AQAOXX=$O(AQAOA(AQAOXX)) Q:AQAOXX=""  S AQAOTM=AQAOXX
 S DIR("?")="Choose option from list above"
 S DIR(0)="LO^0:"_AQAOTM_"^K:X#1 X" D ^DIR Q:$D(DIRUT)  Q:Y=-1  S DR=""
 I +Y=0 F  S X=$O(AQAOA(X)) Q:X=""  D  ;user chose all
 .I AQAOA(X)[U S DR(2,$P(AQAOA(X),U,2))=$P(AQAOA(X),U,3)
 .S DR=DR_";"_$P(AQAOA(X),U)
 E  F  S X=$P(Y,",") Q:X=""  D  ;user chose range by number
 .I AQAOA(X)[U S DR(2,$P(AQAOA(X),U,3))=$P(AQAOA(X),U,2)
 .S X=$P(AQAOA(X),U),DR=DR_";"_X
 .S Y=$P(Y,",",2,99)
 I DR?1";".E S DR=$E(DR,2,99)
 K DIE S DIE=9002167,DA=AQAOIFN D ^DIE
 ;
 S AQAODIR=DIR("A") K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Do you wish to EDIT this category again" D ^DIR K DIR
 I Y=1 S AQAOTM=0,DIR("A")=AQAODIR K AQAODIR W !! G ITEMFIND
 Q
 ; >>end of ITEMFIND subrtn<<
 ;
 ;
 ;
MULTFIND ; >>SUBRTN to display multiple entries in linked files<<
 ; >>> set variables about linked file
 S AQAOFL=$P(AQAOSTR,U),AQAOFLD=$P(AQAOSTR,U,2) ;file#, fields to edit
 S AQAOGBL=^DIC(AQAOFL,0,"GL") ;global node for file
 S AQAOXX=0,AQAOXY=AQAOGBL_"""AB"",AQAOIFN,AQAOXX)" ;set global xref
 ;
 S AQAOQUIT=0 W !!!,"<<",AQAOPTL,">>",! ;print screen heading
 S X=$G(^AQAQX(AQAOPT,"PG",AQAOSN,2)) I X]"" X X ;special rtn for screen
 I AQAOQUIT=1 Q  ;special rtn found cause to quit edit of this screen
 ;
 ; >>> loop thru entries in linked file and display them by #
 S (AQAOXX,AQAOCNT)=0
 F  S AQAOXX=$O(@AQAOXY) Q:AQAOXX'=+AQAOXX  D
 .S AQAOTM=$P(@(AQAOGBL_"AQAOXX,0)"),U) ;.01 field of linked file
 .S AQAOCNT=AQAOCNT+1,AQAOA(AQAOCNT)=AQAOXX
 .S Y=AQAOTM,C=$P(^DD(AQAOFL,.01,0),U,2) D Y^DIQ
 .W !,AQAOCNT,")  ",Y
 .S X=$G(^AQAQX(AQAOPT,"PG",AQAOSN,4)) I X["" X X ;identifier code
 .Q
 ;
 ; >>> last number is choice to add new entry
 I AQAOCNT=0 D ADD G MULTFIND:$O(@AQAOXY) Q
 S AQAOCNT=AQAOCNT+1 W !,AQAOCNT,")  ADD NEW ENTRY"
 ;
CHOOSE ; >>> choose item(s) to edit
 W ! S DIR(0)="NO^1:"_AQAOCNT,DIR("?")="Choose from list above"
 D ^DIR Q:X=""  Q:$D(DIRUT)  G CHOOSE:Y=-1
 I (+Y=AQAOCNT) D ADD G MULTFIND
 E  S DA=AQAOA(+Y) D EDIT G MULTFIND
 ;
ADD ;add new entry to subfile or edit entries already there
 K DIC S DIE="^AQAOC(",DLAYGO=AQAOFL,DA=AQAOIFN
 S DR=AQAOFLD_" ADD]" D ^DIE W ! Q
 ;
EDIT ; >>> edit entries
 K DIC,DIE S DIE=AQAOGBL,DIDEL=AQAOFL
 S DR=AQAOFLD_" EDIT]" D ^DIE W ! Q
 ;
 ; >>end of MULTFIND subrtn<<
