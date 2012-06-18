PXRMEXCF ; SLC/PKR - Utilities for computed findings/routines. ;24-Sep-2009 15:55;MGH
 ;;1.5;CLINICAL REMINDERS;**5,1007**;Jun 19, 2000
 ;======================================================================
EXISTS(ROUTINE) ;Return true if routine ROUTINE exists.
 I ROUTINE="" Q 0
 N X
 S X=ROUTINE
 X ^%ZOSF("TEST")
 I $T Q 1
 Q 0
 ;
 ;======================================================================
GETRACT(ATTR,NEWNAME,NAMECHG,RTN,EXISTS) ;Get the action for a routine.
 N ACTION,CHOICES,ECS,IND,MSG,PCS,ROUTINE,SAME,TEXT,X,Y
 ;
 S CHOICES="CIQS"
 S NEWNAME=""
 ;If the routine exists compare the existing routine checksum with the
 ;the checksum of the routine in the packed definition.
 S ROUTINE=ATTR("NAME")
 I EXISTS="" S EXISTS=$$EXISTS^PXRMEXCF(ROUTINE)
 I EXISTS D
 . S SAME=$$SAME(.ATTR,.RTN)
 . S TEXT(1)="Routine "_ROUTINE_" already EXISTS,"
 . I SAME S TEXT(2)="unless documented, skip the install?"
 . I 'SAME S TEXT(2)="but packed routine is different, unless instructed in notes, skip"
 . W !,TEXT(1),!,TEXT(2)
 . S DIR("B")="S"
 . S ACTION=$$GETACT^PXRMEXIU(CHOICES)
 E  D
 . W !!,"Routine "_ROUTINE_" is NEW, what do you want to do?"
 . S DIR("B")="I"
 . S ACTION=$$GETACT^PXRMEXIU(CHOICES)
 ;
 I ACTION="Q" Q ACTION
 ;
 I ACTION="C" D
 . N CDONE
 . S CDONE=0
 . F  Q:CDONE  D
 .. S NEWNAME=$$GETNAME^PXRMEXIU(ATTR("MIN FIELD LENGTH"),ATTR("FIELD LENGTH"))
 .. I NEWNAME="" S ACTION="S",CDONE=1 Q
 .. S EXISTS=$$EXISTS^PXRMEXCF(NEWNAME)
 .. I EXISTS W !,"Routine ",NEWNAME," already exits, try again."
 .. E  D  Q
 ... S CDONE=1
 ... S NAMECHG(ATTR("FILE NUMBER"),ROUTINE)=NEWNAME
 ;
 I (ACTION="I")&(EXISTS) D
 .;If the action is overwrite double check that overwrite is what the
 .;user really wants to do.
 . K X,Y
 . S DIR(0)="Y"_U_"A"
 . S DIR("A")="Are you sure you want to overwrite"
 . S DIR("B")="N"
 . D ^DIR K DIR
 . I 'Y S ACTION="S"
 . S NAMECHG(ATTR("FILE NUMBER"),ROUTINE)=NEWNAME
 Q ACTION
 ;
 ;======================================================================
SAME(ATTR,RTN) ;Compare the existing routine and the new version
 ;in RTN to see if they are the same.
 N ECS,DIF,NEWCS,RT,SAME,X,XCNP
 S XCNP=0
 S DIF="RT("
 S X=ATTR("NAME")
 X ^%ZOSF("LOAD")
 S ECS=$$ROUTINE^PXRMEXCS(.RT)
 K RT
 S NEWCS=$$ROUTINE^PXRMEXCS(.RTN)
 I ECS=NEWCS S SAME=1
 E  S SAME=0
 Q SAME
 ;
