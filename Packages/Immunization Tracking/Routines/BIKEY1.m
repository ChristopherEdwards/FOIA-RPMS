BIKEY1 ;IHS/CMI/MWR - ALLOCATE/DEALLOCATE BI KEYS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  ALLOCATE/DEALLOCATE BI KEYS TO USERS.
 ;
 ;
 ;----------
START ;EP
 ;
 ;---> If DUZ is undefined or User does not hold BIZ MANAGER Key, quit.
 D SETVARS^BIUTL5
 D FULL^VALM1
 I '$G(DUZ) D TITLE,ERRCD^BIUTL2(106,,1),RESET^BIKEY Q
 I '$D(^XUSEC("BIZ MANAGER",DUZ)) D  Q
 .D TITLE,ERRCD^BIUTL2(631,,1),RESET^BIKEY Q
 ;
 ;---> Select Person/User loop.
 N Y
 F  D  Q:Y<0
 .D TITLE
 .W !!?5,"Select the Person to whom you wish to Allocate or Deallocate"
 .W !?5,"an Immunization (BIZ) Key.",!
 .D DIC^BIFMAN(200,"QEMA",.Y,"     Select PERSON: ")
 .Q:Y<0
 .D SELECT(+Y)
 D RESET^BIKEY
 Q
 ;
 ;
 ;----------
SELECT(BIDUZ) ;EP
 ;---> Select Key and action.
 ;---> Parameters:
 ;     1 - BIDUZ  (req) Person's IEN in New Person File #200.
 ;
 I '$G(BIDUZ) S BIERR=106 Q
 I '$D(^VA(200,BIDUZ,0)) S BIERR=112 Q
 ;
 ;---> Allocate or Deallocate.
 N BIHOLDER S BIHOLDER=$$PERSON^BIUTL1(BIDUZ,1)
 W !!?5,"Do you wish to Allocate or Deallocate the Keys to "
 W BIHOLDER,"?"
 N DIR
 S DIR("?",1)="     Choose Allocate to give a Key to a user."
 S DIR("?")="     Choose Deallocate to take away a Key from a user."
 S DIR(0)="SOM^A:Allocate;D:Deallocate"
 S DIR("A")="     Enter A or D"
 D ^DIR K DIR W !
 I $D(DIRUT) D NOCHANGE Q
 ;---> BIALL=1=Allocate, BIALL=0=Deallocate.
 N BIALL S BIALL=$S(Y="A":1,1:0)
 ;
 ;---> Select Key.
 D TITLE
 W !!?5,"Select the Key(s) you wish to "
 W:'BIALL "DE" W "ALLOCATE ",$S(BIALL:"to ",1:"from "),BIHOLDER,":"
 D @$S(BIALL:"TEXT1",1:"TEXT2"),TEXT3
 ;
 N DIR
 S DIR("?")="^D HELP1^BIKEY1"
 S DIR(0)="LAO^1:4"
 S DIR("A")="     Enter 1, 2, 3, or 4: "
 D ^DIR W !
 I Y<1!($D(DIRUT)) D NOCHANGE Q
 K DIR N BIKEYS,BIPL,I S BIPL=0
 ;
 ;---> If Manager Key selected, automatically allocate all Keys.
 I BIALL,Y[3 S Y="1,2,3"
 F I=1,2,3,4 I Y[I S BIKEYS(I)="",BIPL=BIPL+1
 I '$D(BIKEYS) D NOCHANGE Q
 ;
 ;
 ;---> Confirm.
 D TITLE
 W !!?5 W:'BIALL "DE" W "ALLOCATE the Key" W:(BIPL>1) "s" W ":",!
 W:$D(BIKEYS(1)) !?10,"1 - BIZMENU"
 W:$D(BIKEYS(2)) !?10,"2 - BIZ EDIT PATIENTS"
 W:$D(BIKEYS(3)) !?10,"3 - BIZ MANAGER"
 W:$D(BIKEYS(4)) !?10,"4 - BIZ LOT ONLY"
 ;
 W !!?5,$S(BIALL:"To ",1:"From "),$$PERSON^BIUTL1(BIDUZ,1),"?",!
 ;
 N B S B(1)="     Enter YES to "_$S('BIALL:"DE",1:"")
 S B(1)=B(1)_"ALLOCATE the Key"_$S(BIPL>1:"s ",1:" ")
 S B(1)=B(1)_$S(BIALL:"to ",1:"from ")_$$PERSON^BIUTL1(BIDUZ,1)_"."
 S B(2)="     Enter NO to make no changes."
 D DIR^BIFMAN("Y",.Y,,"     Enter Yes or No","NO",B(2),B(1))
 ;
 ;---> Failed to confirm.
 I Y<1!($D(DIRUT)) D NOCHANGE Q
 ;
 ;---> Allocate/Deallocate.
 N BIERR
 F I=1,2,3,4 D:$D(BIKEYS(I))
 .D ALLOC(BIDUZ,I,BIALL,.BIERR)
 .I $G(BIERR) D ERRCD^BIUTL2(BIERR,,1) Q
 ;
 I '$G(BIERR) W !!?5,"Done." D DIRZ^BIUTL3()
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 D TEXT4,DIRZ^BIUTL3()
 D TITLE
 W !!?5,"Select the Key(s) you wish to "
 W:'BIALL "DE" W "ALLOCATE to ",BIHOLDER,":"
 D @$S(BIALL:"TEXT1",1:"TEXT2"),TEXT3
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;
 ;;Enter the number of the Key you wish to allocate.  To select more
 ;;than one key, enter the numbers separated by commas.  For example,
 ;;entering 1,2 will select the first two Keys.
 ;;
 ;;(NOTE: If you select Key #3, BIZ MANAGER, then the Keys BIZMENU and
 ;; BIZ EDIT PATIENTS will be allocated automatically.)
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;
 ;;Enter the number of the Key you wish to deallocate.  To select more
 ;;than one key, enter the numbers separated by commas.  For example,
 ;;entering 1,2 will select the first two Keys.
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;
 ;;1 - BIZMENU
 ;;2 - BIZ EDIT PATIENTS
 ;;3 - BIZ MANAGER
 ;;4 - BIZ LOT ONLY
 ;;
 D PRINTX("TEXT3",10)
 Q
 ;
 ;
 ;----------
TEXT4 ;EP
 ;;
 ;;  Enter 1 for BIZMENU, or 2 for BIZ EDIT PATIENTS, 3 for BIZ MANAGER
 ;;  MANAGER, or 4 for BIZ LOT ONLY.
 ;;  Or enter any combination of 1, 2 and 3 using commas.
 ;;
 ;;* For a more complete explanation of the Keys and the privileges
 ;;  they confer, return to the first screen listing Holders of Keys
 ;;  and choose the Action "H Help".
 ;;
 D PRINTX("TEXT4",8)
 Q
 ;
 ;
 ;----------
ALLOC(BIDUZ,BIKEY,BIALL,BIERR) ;EP
 ;---> Allocate BIZ Key to a Person.
 ;---> Parameters:
 ;     1 - BIDUZ  (req) Person's IEN in New Person File #200.
 ;     2 - BIKEY  (req) Number of Key (1,2,or3).
 ;     3 - BIALL  (req) 0=Deallocate, 1=Allocate.
 ;     4 - BIERR  (ret) Text of any error returned.
 ;
 ;
 I '$G(BIDUZ) S BIERR=106 Q
 I '$D(^VA(200,BIDUZ,0)) S BIERR=112 Q
 ;
 ;---> Quit if Key not provided.
 I '$G(BIKEY) S BIERR=635 Q
 ;
 N BIKEYNM
 D
 .I BIKEY=1 S BIKEYNM="BIZMENU" Q
 .I BIKEY=2 S BIKEYNM="BIZ EDIT PATIENTS" Q
 .I BIKEY=3 S BIKEYNM="BIZ MANAGER" Q
 .I BIKEY=4 S BIKEYNM="BIZ LOT ONLY"
 I $G(BIKEYNM)="" S BIERR=635 Q
 ;
 ;---> Set BIKIEN=Key IEN.
 N BIKIEN S BIKIEN=$O(^DIC(19.1,"B",BIKEYNM,0))
 ;---> Quit if Key does not exist.
 I 'BIKIEN S BIERR=632 Q
 ;---> Quit if there are duplicate keys.
 I $O(^DIC(19.1,"B",BIKEY,BIKIEN)) S BIERR=633 Q
 ;
 ;---> Quit if BIALL not specified.
 I ($G(BIALL)'=0)&($G(BIALL)'=1) S BIERR=634 Q
 ;
 ;---> Deallocate, quit.
 I BIALL=0 D  Q
 .N DIK,DA S DIK="^VA(200,"_BIDUZ_",51,",DA(1)=BIDUZ,DA=BIKIEN
 .D ^DIK
 ;
 ;---> Allocate.
 Q:$D(^XUSEC(BIKEYNM,BIDUZ))  ;already has new key
 N DIC,DD,DO  K DO
 S DIC(0)="NMQ",DIC("P")="200.051PA"
 S DIC="^VA(200,"_BIDUZ_",51,",DA(1)=BIDUZ,X=BIKIEN,DINUM=X
 D FILE^DICN
 I Y<0 S BIERR=636
 K DIC,DINUM,DA
 Q
 ;
 ;
 ;----------
TITLE ;EP
 ;---> Clear screen and write title.
 D TITLE^BIUTL5("ALLOCATE/DEALLOCATE IMM KEYS")
 Q
 ;
 ;
 ;----------
NOCHANGE ;EP
 W !!?5,"NO changes made." D DIRZ^BIUTL3()
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
