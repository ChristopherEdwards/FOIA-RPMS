PXRMP12I ; SLC/PKR - Inits for PXRM*1.5*12. ;10/15/2002
 ;;1.5;CLINICAL REMINDERS;**12**;Jun 19, 2000
 ;
 Q
 ;===============================================================
DCERRMSG(MSG,XREF) ;Display cross-reference creation error message.
 W !,"Cross-reference could not be created!"
 W !,"Error message:"
 D AWRITE^PXRMUTIL("MSG")
 W !!,"Cross-reference information:"
 D AWRITE^PXRMUTIL("XREF")
 Q
 ;
 ;===============================================================
POST ;Post-init
 S ^PXRM(800,1,"MIERR")=200
 Q
 ;
