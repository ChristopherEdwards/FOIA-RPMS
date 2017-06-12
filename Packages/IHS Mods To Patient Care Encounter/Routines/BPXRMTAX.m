BPXRMTAX ; IHS/MSC/MGH - Version 2.0 Patch 3. ;20-Nov-2014 15:49;du
 ;;2.0;CLINICAL REMINDERS;**1003**;Feb 04, 2005;Build 21
 ;
BUILD ;Rebuild taxonomy
 N DA,DIC,DLAYGO,DTOUT,DUOUT,Y,TERM
 S DIC="^PXD(811.2,"
 S DIC(0)="AEMQ"
 S DIC("A")="Select Reminder Taxonomy: "
 S DIC("S")="I $$VEDIT^PXRMUTIL(DIC,Y)"
 S DLAYGO=811.2
 D ^DIC
 I ($D(DTOUT))!($D(DUOUT)) Q
 I Y=-1 G END
 S DA=$P(Y,U,1)
 S TERM=$P(Y,U,2)
 D RTAXEXP(TERM)
 Q
RTAXEXP(TERM) ;Rebuild taxonomy expansions.
 N IEN,IND,TEXT,TNAME
 D BMES^XPDUTL("Rebuilding taxonomy expansions.")
 S IEN=$O(^PXD(811.2,"B",TERM,""))
 I IEN="" Q
 S TEXT=" Working on taxonomy "_IEN
 D BMES^XPDUTL(TEXT)
 D DELEXTL^PXRMBXTL(IEN)
 D EXPAND^PXRMBXTL(IEN,"")
 Q
