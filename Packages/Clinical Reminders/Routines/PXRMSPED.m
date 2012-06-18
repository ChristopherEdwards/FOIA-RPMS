PXRMSPED ; SLC/PKR - Edit a reminder sponsor. ;08/30/2001
 ;;1.5;CLINICAL REMINDERS;**5,7**;Jun 19, 2000
 ;
 ;=======================================================================
 N DA,DIC,DLAYGO,DTOUT,DUOUT,FILEA,IENA,NUM,Y
GETNAME ;Get the name of the computed finding to edit.
 K CLASS,DA,DIC,DLAYGO,DTOUT,DUOUT,INUSE,PXRMEDOK,Y
 S PXRMEDOK=1
 S DIC="^PXRMD(811.6,"
 S DIC(0)="AEMQL"
 S DIC("A")="Select Reminder Sponsor: "
 S DLAYGO=811.6
 ;Set the starting place for additions.
 D SETSTART^PXRMCOPY(DIC)
 W !
 D ^DIC
 I ($D(DTOUT))!($D(DUOUT)) Q
 I Y=-1 G END
 S DA=$P(Y,U,1)
 S CLASS=$P($G(^PXRMD(811.6,DA,0)),U,2)
 I (CLASS="N")&('$G(PXRMINST)) D  G GETNAME
 . W !,"You cannot edit National Class Sponsors!"
 D EDIT(DIC,DA)
 G GETNAME
END ;
 Q
 ;
 ;=======================================================================
EDIT(ROOT,DA) ;
 N DIE,DR,DIDEL
 S DIE=ROOT,DIDEL=811.6
 S DR=".01;.02"
 D ^DIE
 ;
 S DR="1"
 D ^DIE
 ;
 S DR="2"
 D ^DIE
 Q
 ;
 ;=======================================================================
INUSE(SIEN) ;This is used by ^DD(811.6,.01,"DEL",1,0) to determine if it
 ;is ok to delete a sponsor.
 N FILE,FILEA,IEN,IENA,IENT,IND,LIST,NUM,SP
 D EN^DDIOL("Checking usage ...")
 S NUM=0
 ;First check for use as an associated sponsor.
 S SP=""
 F  S SP=$O(^PXRMD(811.6,"C",SIEN,SP)) Q:SP=""  D
 . S NUM=NUM+1
 . S FILEA(NUM)=811.6
 . S IENA(NUM)=SP
 F FILE=801.41,811.2,811.4,811.5,811.9 D
 . K LIST
 . D LIST^DIC(FILE,"","@","","","","","","","","LIST")
 . S IENT=$P(LIST("DILIST",0),U,1)
 . F IND=1:1:IENT D
 .. S IEN=LIST("DILIST",2,IND)
 .. S SP=+$$GET1^DIQ(FILE,IEN,101,"I")
 .. I SP=SIEN D
 ... S NUM=NUM+1
 ... S FILEA(NUM)=FILE
 ... S IENA(NUM)=IEN
 I NUM>0 D
 . D EN^DDIOL("This Sponsor cannot be deleted, it is in use by the following:")
 . D EN^DDIOL("FILE","","!!")
 . D EN^DDIOL("ENTRY","","?35")
 . D EN^DDIOL("----")
 . D EN^DDIOL("-----","","?35")
 . F IND=1:1:NUM D
 .. S IENA(IND)=$$GET1^DIQ(FILEA(IND),IENA(IND),.01)
 .. S FILEA(IND)=$$GET1^DID(FILEA(IND),"","","NAME")
 .. D EN^DDIOL(FILEA(IND))
 .. D EN^DDIOL(IENA(IND),"","?35")
 . D EN^DDIOL("","","!!")
 Q NUM
 ;
