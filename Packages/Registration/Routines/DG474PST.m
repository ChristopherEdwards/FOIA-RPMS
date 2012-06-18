DG474PST ;BIR/PTD-PATCH DG*5.3*474 POST INSTALLATION ROUTINE ;10/10/02
 ;;5.3;Registration;**474**;Aug 13, 1993
 ;
 ;Reference to TRIG^DICR supported by IA #3405
 ;
POST ;Post-init functions
 ;Recompile input templates
 D COMPILE
 ;Update triggered fields
 D TRIG
 Q
 ;
COMPILE N GLOBAL,FIELD,CFIELD,NFIELD,TEMPLATP,TEMPLATN
 D BMES^XPDUTL("Beginning to compile templates on the PATIENT (#2) file.")
 ;
 S NFIELD=$P($T(AFIELDS),";;",2) ;get the fields that have new xref
 ;
 F GLOBAL="^DIE","^DIPT" DO
 .I GLOBAL="^DIE" D BMES^XPDUTL("   Compiling Input Templates")
 .I GLOBAL="^DIPT" DO
 . . D BMES^XPDUTL(" ")
 . . D BMES^XPDUTL("   Compiling Print Templates")
 .;
 .S FIELD=0
 .; go find templates on fields that have added cross-ref
 .F  S FIELD=$O(@GLOBAL@("AF",2,FIELD)) Q:'FIELD  DO
 . .;
 . .S CFIELD=","_FIELD_","
 . .;if we didn't add the cross reference, quit
 . .I NFIELD'[CFIELD Q
 . .;
 . .S TEMPLATP=0
 . .F  S TEMPLATP=$O(@GLOBAL@("AF",2,FIELD,TEMPLATP)) Q:'TEMPLATP  DO
 . . . S TEMPLATN=$P($G(@GLOBAL@(TEMPLATP,0)),"^",1)
 . . . I TEMPLATN="" DO  Q
 . . . . D BMES^XPDUTL("Could not compile template "_TEMPLATN_$C(13,10)_"Please review!")
 . . . .;
 . . . S X=$P($G(@GLOBAL@(TEMPLATP,"ROUOLD")),"^")
 . . . I X=""&($D(@GLOBAL@(TEMPLATP,"ROU"))'=0) DO  Q
 . . . . D BMES^XPDUTL("Could not find routine for template "_TEMPLATN_$C(13,10)_"Please review!")
 . . . I X=""&($D(@GLOBAL@(TEMPLATP,"ROU"))=0) Q
 . . . I $D(FIELD(X)) Q  ;already compiled
 . . .;
 . . . S FIELD(X)="" ;                remember the template was compiled
 . . . S Y=TEMPLATP ;                 set up the call for fman
 . . . S DMAX=$$ROUSIZE^DILF
 . . . I GLOBAL="^DIE" D EN^DIEZ Q
 . . . I GLOBAL="^DIPT" D EN^DIPZ Q
 .;
 W !!!
 S (X,Y)=""
 D BMES^XPDUTL("The following routine namespace was compiled:")
 F  S X=$O(FIELD(X)) Q:X=""  DO
 . S Y=$G(Y)+1 S PRINT(Y)=" "_X_"*"
 ;
 D MES^XPDUTL(.PRINT)
 K X,Y,DMAX,PRINT
 Q
 ;
 ;these are the fields that have a new cross-ref
AFIELDS ;;,.092,.093,
 Q
 ;
TRIG ;Update trigger definitions
 N DGFLD
 D BMES^XPDUTL("Updating trigger field definitions...")
 F DGFLD=.092,.093 S DGFLD(2,DGFLD)=""
 D T1(.DGFLD)
 Q
 ;
T1(DGFLD) ;Check/update triggering field definitions
 ;Input: DGFLD=array of fields to update
 N DGOUT,DGFILE
 D TRIG^DICR(.DGFLD,.DGOUT)
 S DGFILE=0 F  S DGFILE=$O(DGOUT(DGFILE)) Q:'DGFILE  D
 .S DGFLD=0 F  S DGFLD=$O(DGOUT(DGFILE,DGFLD)) Q:'DGFLD  D
 ..D MES^XPDUTL("         Field #"_DGFLD_" of file #"_DGFILE_" updated.")
 ..Q
 .Q
 Q
