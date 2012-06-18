DG53361P ;SF/CMC POST INSTALL FOR DG*5.3*361 ; 2/12/01
        ;;5.3;Registration;**361**;Aug 13, 1993
 ;
 ;
EN ; entry point for Post Init
 D PTXFR
 D COMPILE
 Q
 ;
PTXFR ; Create new x-ref in Patient file for NAME .01 field
 D BMES^XPDUTL(">>> Creating new cross reference on PATIENT (#2) file, field NAME (#.01) -- AMPIZZ")
 I $D(^DD("IX","IX","AMPIZZ")) D BMES^XPDUTL("X-Reference Already Exists") Q
 ; Get next ien for ^DD("IX" to place cross-reference
 N DIK,DA,ZZFDA,ZZIEN
 S ZZFDA(.11,"+1,",.01)=2
 S ZZFDA(.11,"+1,",.02)="AMPIZZ"
 D UPDATE^DIE("","ZZFDA","ZZIEN")
 S DA=ZZIEN(1)
 I $D(DIERR) D BMES^XPDUTL(">>Problem getting Entry IEN in INDEX FILE") K DIERR Q
 ;
 S ^DD("IX",DA,0)="2^AMPIZZ^Inactivate ICN when patient is ZZ'd or deleted^MU^^F^IR^I^2^^^^^A"
 S ^DD("IX",DA,.1,0)="^^12^12^3000824^"
 S ^DD("IX",DA,.1,1,0)="The set of this cross reference is to inactivate a patient with an ICN"
 S ^DD("IX",DA,.1,2,0)="(991.01) that have been ZZ'd.  The rules for inactivation will be"
 S ^DD("IX",DA,.1,3,0)="enforced."
 S ^DD("IX",DA,.1,4,0)=" "
 S ^DD("IX",DA,.1,5,0)="The kill of this cross reference is to inactivate a patient with"
 S ^DD("IX",DA,.1,6,0)="an ICN (991.01) that has been deleted (@ entered on the.01). "
 S ^DD("IX",DA,.1,7,0)=" "
 S ^DD("IX",DA,.1,8,0)="The rules for Inactivtion will be enforced. If in either situation, the"
 S ^DD("IX",DA,.1,9,0)="rules don't allow for automatically inactivating the ICN, an exception"
 S ^DD("IX",DA,.1,10,0)="message will be generated."
 S ^DD("IX",DA,.1,11,0)=" "
 S ^DD("IX",DA,.1,12,0)="Inactivating an ICN deletes fields 991.01, 991.02, 991.03 and 991.04"
 S ^DD("IX",DA,1)="I $T(ZZSET^MPIFDEL)'="""",$E(X2(1),1,2)=""ZZ"" D ZZSET^MPIFDEL(DA,X2(1))"
 S ^DD("IX",DA,2)="I $T(ZZKILL^MPIFDEL)'="""",X2(1)="""" D ZZKILL^MPIFDEL(DA,X2(1))"
 S ^DD("IX",DA,11.1,0)="^.114IA^1^1"
 S ^DD("IX",DA,11.1,1,0)="1^F^2^.01^^^F"
 S ^DD("IX",DA,11.1,"B",1,1)=""
 S ^DD("IX",DA,11.1,"BB",1,1)=""
 S DIK="^DD(""IX""," D IX1^DIK  ;eindex the Index file entry.
 Q
 ;
COMPILE ; Compile print and input templates
 N GLOBAL,FIELD,CFIELD,NFIELD,TEMPLATP,TEMPLATN
 ;
 D BMES^XPDUTL("Beginning to compile templates on the patient file.")
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
AFIELDS ;;,.01,
 Q
