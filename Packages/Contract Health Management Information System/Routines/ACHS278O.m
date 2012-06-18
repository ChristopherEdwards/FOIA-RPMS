ACHS278O ;IHS/SET/GTH - 278 OUTBOUND PROCESSING ; [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - New routine.
 ;
 I '$L($T(278^BHLEVENT)) W !,"The '278^BHLEVENT()' entry point is not present.",$$DIR^XBDIR("E","Press RETURN") Q
 ;
 NEW ACHSDIEN,ACHSTIEN
 ;
 ; --- Select Document.
 D ^ACHSUD
 ;
 ; --- Q if no Document selected.
 Q:'$D(ACHSDIEN)
 ;
 ; --- Select Transaction.
 S ACHSTIEN=$$SELTRANS^ACHSUD(ACHSDIEN)
 ;
 ; --- Q if no Transaction selected.
 Q:'ACHSTIEN
 ; W !,ACHSDIEN,!,ACHSTIEN
 ;
 ; --- Determine if msg previously sent.
 S %=$$GET1^DIQ(9002080.02,ACHSTIEN_","_ACHSDIEN_","_DUZ(2)_",",.01)
 ; --- Get IEN in 4001, display date/time sent.
 I % S %=+$$IXDIC(4001,"","C","IHS-"_%) I % W !,"278 Outbound sent for this Transaction on ",$$GET1^DIQ(4001,%,.01),"."
 ;
 Q:'$$DIR^XBDIR("Y","Proceed with the send of the Outbound 278","Y")
 ;
 ; --- Compute the 278O fields.
 NEW ACHS
 S ACHS=""
 D GEN278^ACHS278(ACHSDIEN,ACHSTIEN,.ACHS)
 ;
 ; --- Let GIS know the destination, PROVIDER (VENDOR), external.
 S ACHS("DEST")=$$GET1^DIQ(9002080.01,ACHSDIEN_","_DUZ(2)_",",7)
 ;
 ; --- Send the message.
 S ACHSMSG=$$278^BHLEVENT(DUZ(2),ACHSDIEN,.ACHS)
 ;
 ; --- Error message?
 I 'ACHSMSG D  Q
 . W !,"**-->> ",ACHSMSG
 . I $$DIR^XBDIR("E","Press RETURN")
 .Q
 ;
 ; --- If IEN returned, store in Transaction.
 NEW DA,DIE,DR
 S DA=ACHSTIEN,DA(1)=ACHSDIEN,DA(2)=DUZ(2),DIE="^ACHSF("_DUZ(2)_",""D"","_ACHSDIEN_",""T"",",DR="31///"_ACHSMSG
 D ^DIE
 ;
 ; --- Record action in Document entry.
 D ACT^ACHSACT(ACHSDIEN,$$NOW^XLFDT,"<278 Outbound Message sent for "_$$GET1^DIQ(9002080.02,ACHSTIEN_","_ACHSDIEN_","_DUZ(2)_",",1)_" Transaction>")
 ;
 Q
 ;
IXDIC(DIC,DIC0,D,X,DLAYGO) ; 
 S DIC(0)=DIC0
 KILL DIC0
 I '$G(DLAYGO) KILL DLAYGO
 D IX^DIC
 Q Y
 ;
