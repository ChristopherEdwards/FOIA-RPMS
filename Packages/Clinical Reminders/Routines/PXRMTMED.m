PXRMTMED ; SLC/PKR/PJH - Edit a reminder term. ;05/03/2001
 ;;1.5;CLINICAL REMINDERS;**5**;Jun 19, 2000
 ;
 ;=======================================================================
 N CS1,CS2,DA,DIC,DLAYGO,DTOUT,DUOUT,Y
GETNAME ;Get the name of the term to edit.
 K DA,DIC,DLAYGO,DTOUT,DUOUT,Y
 S DIC="^PXRMD(811.5,"
 S DIC(0)="AEMQL"
 S DIC("A")="Select Reminder Term: "
 S DLAYGO=811.5
 ;Set the starting place for additions.
 D SETSTART^PXRMCOPY(DIC)
 W !
 D ^DIC
 I ($D(DTOUT))!($D(DUOUT)) Q
 I Y=-1 G END
 S DA=$P(Y,U,1)
 S CS1=$$FILE^PXRMEXCS(811.5,DA)
 D EDIT(DIC,DA)
 S CS2=$$FILE^PXRMEXCS(811.5,DA)
 I CS2=0 Q
 I CS2'=CS1 D SEHIST^PXRMUTIL(811.5,DIC,DA)
 G GETNAME
END ;
 Q
 ;
 ;=======================================================================
EDIT(ROOT,DA) ;
 N CLASS,DIE,DR,DIDEL
 S CLASS=$P($G(^PXRMD(811.5,DA,100)),U,1)
 S DIE=ROOT,DR="[PXRM EDIT REMINDER TERM]",DIDEL=811.5
 I CLASS="N" S DR="[PXRM EDIT NATIONAL TERM]"
 D ^DIE
 Q
 ;
