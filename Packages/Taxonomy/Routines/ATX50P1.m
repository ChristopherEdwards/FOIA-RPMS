ATX50P1 ; IHS/OHPRD/TMJ - UPDATE SURVEILLANCE TB TAXONOMY WITH NEW ICD9 CODE ; [ 02/04/97  11:29 AM ]
 ;;5.1;TAXONOMY;;FEB 04, 1997
 ;
 ;
 ;add new icd diagnosis codes to SURV TAXONOMY
 ;add new ATX ADR NOTIFICATION BULLETIN AND TAXONOMY
 ;
EP ;
 ;fix taxonomy 21 nodes
 S X=0 F  S X=$O(^ATXAX(X)) Q:X'=+X  I $G(^ATXAX(X,21,0))["02102" S Y=^ATXAX(X,21,0),^ATXAX(X,21,0)="^9002226.2101A^"_$P(Y,U,3)_"^"_$P(Y,U,4)
SURVTB ;
 W !,"Editing SURVEILLANCE TUBERCULOSIS Taxonomy..."
 S ATXTX=$O(^ATXAX("B","SURVEILLANCE TUBERCULOSIS",0)) I ATXTX="" W !,"Taxonomy does not exist.",!! Q
 S ^ATXAX(ATXTX,21,0)="^9002226.02101^4^4"
 S ^ATXAX(ATXTX,21,4,0)="V12.01^V12.01"
 S DA=ATXTX,DIK="^ATXAX(" D IX1^DIK
 S ATXX=ATXTX D ZTM^ATXAX ;update all these codes in icd9 file
 W !!,"All Done."
 K ATXTX,DIK,DA
ADR ;adr notification taxonomy
BULL ;add bulletin
 G:$D(^XMB(3.6,"B","ATX ADR NOTIFICATION")) ADRTAX
 K DA,DR,DIC S X="ATX ADR NOTIFICATION",DIADD=1,DLAYGO=3.6,DIC(0)="L",DIC="^XMB(3.6," D ^DIC
 I Y=-1 W !,$C(7),$C(7),"Creating bulletin failed..." G ADRTAX
 S ATXIEN=+Y
 S $P(^XMB(3.6,ATXIEN,0),U,2)="PATIENT SEEN FOR AN ENTRY WITHIN A TAXONOMY"
 S ^XMB(3.6,ATXIEN,1,0)="9^^11^11^"_$S($G(DT)]"":DT,1:"2950430")
 S ^XMB(3.6,ATXIEN,1,1,0)="Patient Name: |2|      Chart No.: |99|"
 S ^XMB(3.6,ATXIEN,1,2,0)="Visit Date: |3|"
 S ^XMB(3.6,ATXIEN,1,3,0)="Location: |15|"
 S ^XMB(3.6,ATXIEN,1,4,0)="ICD9 Code: |1|"
 S ^XMB(3.6,ATXIEN,1,5,0)="ICD9 Description: |8|"
 S ^XMB(3.6,ATXIEN,1,6,0)="Provider Stated: |4|"
 S ^XMB(3.6,ATXIEN,1,7,0)="Taxonomy: |20|"
 S ^XMB(3.6,ATXIEN,1,8,0)=" "
 S ^XMB(3.6,ATXIEN,1,9,0)="This may be an adverse drug reaction which requires you investigation."
 S ^XMB(3.6,ATXIEN,1,10,0)="Please review the client's medical record at your earliest convenience."
 S ^XMB(3.6,ATXIEN,1,11,0)="for further information on this visit."
 S DIK="^XMB(3.6,",DA=ATXIEN D IX1^DIK
ADRTAX ;
 S ATXFLG="" W !,"Creating Adverse Drug Reaction Taxonomy..."
 G:$D(^ATXAX("B","ATX ADR NOTIFICATION")) EXIT
 S X="ATX ADR NOTIFICATION",DIC="^ATXAX(",DIC(0)="L",DIADD=1,DLAYGO=9002226 D ^DIC K DIC,DA,DR,DIADD,DLAYGO,D0
 I Y=-1 W !!,"ERROR IN CREATING ATX ADR NOTIFICATION TAX" Q
 S ATXTX=+Y,$P(^ATXAX(ATXTX,0),U,2)="Adverse Drug Reaction Taxonomy",$P(^(0),U,5)=DUZ,$P(^(0),U,8)=1,$P(^(0),U,9)=DT,$P(^(0),U,11)="B",$P(^(0),U,12)=31,$P(^(0),U,13)=1,$P(^(0),U,15)=80,$P(^(0),U,14)="BA",$P(^(0),U,16)=1
 S ^ATXAX(ATXTX,21,0)="^9002226.02101A^3^3",^ATXAX(ATXTX,21,1,0)="960.0^979.9",^ATXAX(ATXTX,21,2,0)="V14.0^V14.9",^ATXAX(ATXTX,21,3,0)="995.0^995.4"
 S DA=ATXTX,DIK="^ATXAX(" D IX1^DIK
 S DIE="^ATXAX(",DA=ATXTX,DR=".07///ATX ADR NOTIFICATION" D ^DIE K DIE,DA,DR,DIU,DIY,DIW,DIV
 I $D(Y) W !!,"ERROR IN UPDATING BULLETIN OF ADR NOTIFICATION TAX"
 S ATXX=ATXTX D ZTM^ATXAX ;update all these codes in icd9 file
EXIT ;
 W !!,$C(7),$C(7),"If your site wants to utilize the Adverse drug Reaction notification bulletin,",!,"you must do the following:"
 W !?5,"- create a mail group for adverse drug reaction (you could use the  ",!?5,"PHARM MGR group if it exists)"
 W !?5,"- add members to the group"
 W !?5,"- add this group to the bulletin entry called 'ATX ADR NOTIFICATION'"
 K ATXIEN,ATXTX,ATXX,X,Y,ATXFLG
 Q
