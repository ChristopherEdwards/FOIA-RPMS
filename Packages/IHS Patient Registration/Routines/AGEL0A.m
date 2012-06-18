AGEL0A ; IHS/ASDS/EFG - Add/Edit Eligibility Information ;   
 ;;7.1;PATIENT REGISTRATION;**1,2**;JAN 31, 2007
 ;
OPT ;EP - PROMPT TO ADD MEMBER OR EDIT DATA
 NEW DIR,DLOUT
 KILL DIRUT,DIROUT,DTOUT,DUOUT
 S DIR("A")="ENTER ACTION (<E>dit Data,<A>dd Member,<D>elete Member,<V>iew/Edit PH Addr)"
 S DIR(0)="FO"
 D ^DIR
 KILL DIR
 S X=Y,Y=$$UP^XLFSTR(X)
 I $E(Y,1,1)["v" S Y="V"
 I (Y["V"&($L(Y)>1))&($E(Y,2,3)'>12)!($E(Y,2,3)>$G(AGELP("FLDS"))) D  Q
 . W !,"*** YOU MUST ENTER A NUMBER FROM 1 - ",$G(AGELP("FLDS"))
 . H 2
 Q:$G(Y)=$G(AGOPT("ESCAPE"))
 I Y["V" D ^AGPHADDR S Y="V" K:X[(U_U) AGELP("PH") Q
 Q:$D(DTOUT)
 I $E(Y)="^" S DUOUT="" Q
 I Y=""!("Nn"[$E(Y)) S Y="N",DLOUT="" Q
 I +Y>0 S Y="E"_+Y Q
 I "aA"[$E(Y) S Y="A" Q
 I "Dd"[$E(Y),'$D(^XUSEC("AGZMGR",DUZ)) D
 . W:$$DIR^XBDIR("E","Only users with ""AGZMGR"" key can [D]elete") ""
 . S Y="Z"
 .Q
 I "Dd"[$E(Y) S Y="D" Q
 I "eE"[$E(Y) S Y="E"_$S(+$E(Y,2,9):+$E(Y,2,9),1:"") Q
 W:$E(Y)'="?" *7
 W !!?5,"Enter either 'E' to Edit Data, 'A' to Add a Member, 'D' to Delete a member,",!?5  ; IHS/SD/EFG  AG*7*1  02/27/2003
 W "'V' to View/edit the Policy Holder's address info, or 'RETURN' to quit.",!  ; IHS/SD/EFG  AG*7*1  02/27/2003
 G OPT
 Q
FLDS ;EP -  Field Edit Controller
 I +$E(Y,2)>0 S Y=$E(Y,2,99) G EJ
AGN W !
 S DIR(0)="LO^1:"_AGELP("FLDS")
 S DIR(0)="LO^1:"_$G(AGELP("FLDS"))  ;IHS/SD/TPF AG*7.1*1 9/6/2005
 S DIR("A")="     Select the Desired FIELDS"
 D ^DIR
 S:Y="/.,"!(Y="^^") DFOUT=""
 S:Y="" DLOUT=""
 S:Y="^" (DUOUT,Y)=""
 S:Y?1"?".E!(Y["^") (DQOUT,Y)=""
 K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
EJ S AGELP("FLDS")=Y
 Q
DEL ;EP - DELETE MESSAGE
 I AGELP("TYPE")="MCD" D
 .W *7,!!
 .W ?5,"Sorry, this function is not available for Medicaid yet, you may"
AG .W !?5,"DELETE thru the Medicaid Page in Patient Registration though."
 .H 4 Q
 W !!?5,"------------POLICY MEMBERS------------"
 S Y=0
 F AGEL("I")=1:1 S Y=$O(AGELP(Y)) Q:'+Y  W !?10,AGEL("I"),") ",$P(^DPT(Y,0),U) S AGEL(AGEL("I"),Y)=""
 I AGEL("I")=1 W !!,*7,"No Registered Members Exist for this Policy!" Q
 K DIR S DIR(0)="NO^1:"_(AGEL("I")-1),DIR("A")="  DELETE which Member" D ^DIR K DIR
 Q:+Y<1
 S AGEL("Y")=$O(AGEL(+Y,"")) Q:AGEL("Y")<1
 I AGEL("I")=2 D  Q:'Y
 .W !!?5,*7,$P(^DPT(AGEL("Y"),0),U)," is the only registered member! Deleting this member"
 .W !?5,"will delete this entire private insurance entry from this patient's record."
 .K DIR
 .S DIR("B")="N"
 .S DIR(0)="Y",DIR("A")="Are you sure you wish to delete this entry" D ^DIR
 ;AG*7.1 ITSC/SD/TPF 9/14/2004 ADDED KILL OF AGELP("PH"),ADDCHK FOR PROPER EXIT FROM PRIVATE SCREEN WHEN DELETING LAST MEMBER
 I AGELP("TYPE")="PI" S DA(1)=AGEL("Y"),DIK="^AUPNPRVT("_DA(1)_",11,",DA=$P(AGELP(AGEL("Y")),U,2) D ^DIK K AGELP("PH"),ADDCHK
 K AGELP(AGEL("Y"))
 ;IF THIS IS THE LAST PRIVATE INSURER STORED FOR THIS PATIENT THEN
 ;CLEAN UP TOP RECORD
 I '$O(^AUPNPRVT(DFN,11,0)) D
 .S DA=DFN,DIK="^AUPNPRVT(" D ^DIK K AGELP("PH"),ADDCHK
 .;THE KILL OF AGELP("PH") ALLOWS FOR PROPER EXTING FROM PRIVATE SCREEN WHEN DELETING
 .;ENTIRE ENTRY. KILL ADDCHK BECAUSE NOTHING WAS ADDED
 Q
PKILL S AGELP("Y")=0
 S Y=0
 F  S Y=$O(AGELP(Y)) Q:'+Y  S AGEL("Y")=Y D
 .I AGELP("TYPE")="PI" D
 ..S DA(1)=AGEL("Y")
 ..S DIK="^AUPNPRVT("_DA(1)_",11,"
 ..S DA=$P(AGELP(AGEL("Y")),U,2)
 ..D ^DIK
 Q
