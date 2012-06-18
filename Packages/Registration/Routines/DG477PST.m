DG477PST ;BIR/DRI-DG*5.3*477 PATCH POST INSTALL ROUTINE ;9/11/02
 ;;5.3;Registration;**477**;Aug 13, 1993
 ;
 ;Reference to TRIG^DICR supported by IA #3405
 ;
POST ;Post-init functions
 D POST1,POST2
 Q
 ;
POST1 ;recompile input templates and update triggered fields
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
AFIELDS ;;,.313,
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
 ;
POST2 ;translate marital status from 'n' to 'never married'
 ;caused by dg*5.3*474 initially installed 10/31/2002
 NEW FIELD,FILE,GLO,IEN,MSCNT,PDR,VAL
 D BMES^XPDUTL(" Translating MARITAL STATUS from 'N' to 'NEVER MARRIED' in the")
 D MES^XPDUTL(" PATIENT DATA ELEMENTS (#391.99) file for PATIENT DATA REVIEWS.")
 S GLO="^DGCN(391.98,""EVT"",3021030)",FILE=2,FIELD=.05,MSCNT=0
 F  S GLO=$Q(@GLO) Q:$QS(GLO,2)'="EVT"  S PDR=$QS(GLO,4) I PDR S IEN=$O(^DGCN(391.99,"AKY",PDR,FILE,FIELD,"")) I IEN Q  ;find first possible affected pdr
 I $G(IEN) S IEN=IEN-1 F  S IEN=$O(^DGCN(391.99,"ASRT",FILE,FIELD,IEN)) Q:'IEN  S VAL=$G(^DGCN(391.99,IEN,"VAL")) I VAL="N" S MSCNT=MSCNT+1 D
 . D UPD(IEN,50,"NEVER MARRIED"),UPD(IEN,.06,"@") ;loop through subsequent marital status elements and update if necessary
 D BMES^XPDUTL(" "_MSCNT_" MARITAL STATUS entries were translated.")
 Q
 ;
UPD(DA,FLD,VAL) ;update value
 L +^DGCN(391.99,DA,0):10 I '$T D BMES^XPDUTL("Unable to lock entry "_DA_" in the PATIENT DATA ELEMENT (#391.99) file.") Q
 S DIE="^DGCN(391.99,"
 S DR=FLD_"///^S X=VAL"
 D ^DIE K DIE,DR
 L -^DGCN(391.99,DA,0)
 Q
