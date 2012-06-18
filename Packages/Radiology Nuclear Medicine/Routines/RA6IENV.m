RA6IENV ;HIRMFO/GJC - Environment Check for patch six ;10/20/98  08:04
VERSION ;;5.0;Radiology/Nuclear Medicine;**6**;Mar 16, 1998
 ;
 ; If the site is running OE 2.5 or not running OE/CPRS at all,
 ; we will pass from the environment check to the post-init.
 ; Once in the post-init, we issue a message that informs the
 ; user that the post-init only operates on sites running CPRS.
 I +$$VERSION^XPDUTL("OR")<3 Q
 ; Now check for required patches on the CPRS end of the operation.
 S XPDABORT=2 ; kill XPDABORT if OR*3.0*4 is installed!
 I +$$VERSION^XPDUTL("OR")=3 D
 . I $$PATCH^XPDUTL("OR*3.0*4") K XPDABORT ; OR*3.0*4 installed, proceed
 . E  D  ; OR*3.0*4 not installed, abort install, leave transport global
 .. K RAMSG
 .. S RAMSG(1)="**WARNING** patch OR*3.0*4 is required to install"
 .. S RAMSG(2)="RA*5.0*6." D MES^XPDUTL(.RAMSG) K RAMSG
 .. Q
 . Q
 Q
