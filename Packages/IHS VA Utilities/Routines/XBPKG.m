XBPKG ;IHS/SET/GTH - MOVE FILES INTO PACKAGE ENTRY ; [ 04/18/2003  9:06 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;IHS/SET/GTH XB*3*9 10/29/2002 New Routine.
 ;  Move selected files into the selected entry in the PACKAGE
 ;  file.  The entry in the PACKAGE file can then be DIFROM'd, and
 ;  the resulting routines searched for routine or global references
 ;  or lines of code of interest.
 ;  
 ;  The IENs in the PACKAGE multiple will be equal to the FILE number.
 ;  Data will not be included with files.
 ;  
 ;  User will be asked if all entries in the selected entry in PACKAGE
 ;  should be KILL'd before the move.  If the FILE multiple is not
 ;  KILL'd, the selected files will be added (possibly overwrite) to
 ;  the existing entries in the FILE multiple.
 ;
 ;
START ;
 W !,"Select the files that you want to copy into the entry in PACKAGE",!
 D ^XBDSET
 Q:'$D(^UTILITY("XBDSET",$J))
 NEW DA
 S DA=$$SELPKG
 Q:+DA<1
 S X=$$ASKKILL($P(^DIC(9.4,DA,0),"^",1))
 Q:X="^"
 I X KILL ^DIC(9.4,DA,4)
 D MOVEFILS(DA)
 D EOJ
 Q
 ;
 ;
SELPKG() ;-- Select the entry in PACKAGE into which to move the files.
 W !!,"Select the entry in PACKAGE into which to move the files"
 NEW DIC
 S DIC=9.4,DIC(0)="AEL"
 D ^DIC
 Q +Y
 ;
ASKKILL(P) ;-- Ask the user if KILL multiple in PACKAGE prior to move.
 Q $$DIR^XBDIR("Y","KILL the FILE multiple in PACKAGE for "_P,"N")
 ;
MOVEFILS(DA) ;-- Move the selected files into the selected entry in PACKAGE.
 Q:'(DA=+DA)
 Q:'$D(^DIC(9.4,DA))
 NEW C,I
 S (C,I)=0
 F  S I=$O(^UTILITY("XBDSET",$J,I)) Q:'(I=+I)  D
 . S ^DIC(9.4,DA,4,I,0)=I
 . S ^DIC(9.4,DA,4,I,222)="y^y^^n^^^n^m^y"
 . S ^DIC(9.4,DA,4,"B",I,I)=""
 . S C=C+1
 .Q
 S ^DIC(9.4,DA,4,0)="^9.44PA^"_$O(^UTILITY("XBDSET",$J,99999999),-1)_"^"_C
 W !!,C_" files set into Package "_$P(^DIC(9.4,DA,0),U)_".",!
 Q
 ;
EOJ ;
 KILL XBDSC,XBDSFF,XBDSFILE,XBDSHI,XBDSL,XBDSLO,XBDSND,XBDSP,XBDSQ,XBDSTF,XBDSX
 KILL DIC,DIR,DIRUT,DTOUT,DUOUT,X,Y
 Q
 ;
