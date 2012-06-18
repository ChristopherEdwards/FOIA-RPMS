DG53440P ;SF/CMC-POST INSTALL FOR DG*5.3*440 ;2/11/02
 ;;5.3;Registration;**440**;Aug 13, 1993
 ;
PTXFR ; Create new x-ref in Patient file for SSN .09 field
 D BMES^XPDUTL(">>> Creating new cross reference on PATIENT (#2) file, field SOCIAL SECURITY NUMBER (#.09) --> 'ATSSN'")
 ; Get next ien for ^DD("IX" to place cross-reference
 N IEN,TIEN
 S IEN=0
 I $D(^DD("IX","IX","ATSSN")) D BMES^XPDUTL("X-Reference Already Exists") Q
 F  S IEN=$O(^DD("IX",IEN)) Q:IEN=""  S TIEN=IEN
 I TIEN="" S TIEN=1
CHK I $D(^DD("IX",TIEN)) S TIEN=TIEN+1 G CHK
 S ^DD("IX",TIEN,0)="2^ATSSN^Inactivates Pts that have 5 leading zeros for SSN^MU^^F^IR^I^2^^^^^A"
 S ^DD("IX",TIEN,.1,0)="^^5^5^3020111^"
 S ^DD("IX",TIEN,.1,1,0)="The set of this cross reference is to inactivate a patient with an ICN"
 S ^DD("IX",TIEN,.1,2,0)="(991.01) that have the SSN field value changed to a SSN with 5 leading "
 S ^DD("IX",TIEN,.1,3,0)="zeros. The rules for inactivation will be enforced."
 S ^DD("IX",TIEN,.1,4,0)=""
 S ^DD("IX",TIEN,.1,5,0)="There is not a kill of this cross reference since SSN is a required field."
 S ^DD("IX",TIEN,1)="I $T(SSET^MPIFDEL)'="""",$E(X2(1),1,5)=""00000"" D SSET^MPIFDEL(DA,X2(1))"
 S ^DD("IX",TIEN,2)="Q"
 S ^DD("IX",TIEN,11.1,0)="^.114IA^1^1"
 S ^DD("IX",TIEN,11.1,1,0)="1^F^2^.09^^^F"
 S ^DD("IX",TIEN,11.1,"B",1,1)=""
 S ^DD("IX",TIEN,11.1,"BB",1,1)=""
 S ^DD("IX","IX","ATSSN",TIEN)=""
 S ^DD("IX","BB",2,"ATSSN",TIEN)=""
 S ^DD("IX","B",2,TIEN)=""
 S ^DD("IX","AC",2,TIEN)=""
 S ^DD("IX","F",2,.09,TIEN,1)=""
 ;
COMPILE N GLOBAL,FIELD,CFIELD,NFIELD,TEMPLATP,TEMPLATN
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
AFIELDS ;;,.09,
 Q
