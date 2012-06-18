RA6IPST ;HIRMFO/GJC - Post-init Driver patch six ;10/20/98  08:04
VERSION ;;5.0;Radiology/Nuclear Medicine;**6**;Mar 16, 1998
 ;
 I +$$VERSION^XPDUTL("OR")<3  D  Q
 . K RAMSG
 . S RAMSG(1)="This post-init is intended for sites running version"
 . S RAMSG(2)="one of CPRS.  Since your site is not running CPRS 1.0,"
 . S RAMSG(3)="this post-init does not need to proceed."
 . D MES^XPDUTL(.RAMSG) K RAMSG
 . Q
 S RAIPST=$$NEWCP^XPDUTL("PST1","EN1^RA6IPST")
 ; Disable Rad/Nuc Med Order Dialogs from the Order Dialog file.
 ;
 S RAIPST=$$NEWCP^XPDUTL("PST2","OI^ORYRA")
 ; ORYRA will loop through the Orderable Items file for any
 ; procedure that had a duplicate created by the recent problems
 ; with the 'Common Procedure Enter/Edit' option.  It will try
 ; to find the procedure that should have been updated and repoint
 ; any entries in the Order and Order Dialog files to the correct
 ; procedure, then inactivate the duplicate in the Orderable
 ; Items file.  dbia: 2653
 ;
 S RAIPST=$$NEWCP^XPDUTL("PST3","ENALL^RAO7MFN")
 ; Whole Rad/Nuc Med Procedure file update.  Used to keep the
 ; Orderable Items and Rad/Nuc Med Procedure files in synch.
 ;
 S RAIPST=$$NEWCP^XPDUTL("PST4","EN2^RA6IPST")
 ; Enable all Rad/Nuc Med Order Dialogs in the Order Dialog file.
 Q
EN1 ; Disable Rad/Nuc Med Order Dialogs from the Order Dialog file.
 ; Possible because of DBIA: 2676
 D DISABLE^ORXD("RA","RA*5*6: place files 71 & 101.43 in synch")
 Q
EN2 ; Enable all Rad/Nuc Med Order Dialogs in the Order Dialog file.
 ; Possible because of DBIA: 2676
 D ENABLE^ORXD("RA")
 Q
