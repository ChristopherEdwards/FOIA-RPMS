PXRMTEDT ; SLC/PKR - Edit a taxonomy item. ;05/03/2001
 ;;1.5;CLINICAL REMINDERS;**2,5**;Jun 19, 2000
 ;
 ;=======================================================================
 N CS1,CS2,DA,DIC,DLAYGO,DTOUT,DUOUT,Y
GETNAME ;Get the name of the reminder taxonomy to edit.
 K DA,DIC,DLAYGO,DTOUT,DUOUT,Y
 S DIC="^PXD(811.2,"
 S DIC(0)="AEMQL"
 S DIC("A")="Select Reminder Taxonomy: "
 S DIC("S")="I $$VEDIT^PXRMUTIL(DIC,Y)"
 S DLAYGO=811.2
 ;Set the starting place for additions.
 D SETSTART^PXRMCOPY(DIC)
 W !
 D ^DIC
 I ($D(DTOUT))!($D(DUOUT)) Q
 I Y=-1 G END
 S DA=$P(Y,U,1)
 I $$LOCKXTL^PXRMBXTL(DA) D
 . S CS1=$$FILE^PXRMEXCS(811.2,DA)
 . D EDIT(DIC,DA)
 .;See if any changes have been made, if so do the edit history.
 . S CS2=$$FILE^PXRMEXCS(811.2,DA)
 . I CS2'=0,CS2'=CS1 D SEHIST^PXRMUTIL(811.2,DIC,DA)
 D ULOCKXTL^PXRMBXTL(DA)
 G GETNAME
END ;
 Q
 ;
 ;=======================================================================
EDIT(ROOT,DA) ;
 N DIE,DR,DIDEL
 S DIE=ROOT,DIDEL=811.2
 W !!,"General Taxonomy Data"
 S DR=".01"
 D ^DIE
 ;If DA is undefined that the entry was deleted.
 I '$D(DA) Q
 I $D(Y) Q
 ;
 S DR=".02"
 D ^DIE
 I '$D(DA) Q
 I $D(Y) Q
 ;
 ;Class, sponsor, review date
 W !!
 S DR="100;101;102"
 D ^DIE
 I $D(Y) Q
 ;
 W !!
 S DR="4"
 D ^DIE
 I '$D(DA) Q
 I $D(Y) Q
 ;
 S DR="10"
 D ^DIE
 I '$D(DA) Q
 I $D(Y) Q
 ;
 S DR="1.6"
 D ^DIE
 I '$D(DA) Q
 I $D(Y) Q
 ;
 W !!,"ICD0 Range of Coded Values"
 S DR="2103"
 D ^DIE
 I $D(Y) Q
 ;
 W !!,"ICD9 Range of Coded Values"
 S DR="2102"
 D ^DIE
 I $D(Y) Q
 ;
 W !!,"CPT Range of Coded Values"
 S DR="2104"
 D ^DIE
 I $D(Y) Q
 Q
