ADE60P18 ;IHS/OIT/ENM - ADE GENERAL PATCH MODULE P18 [ 09/17/2008  11:38 AM ]
 ;;6.0:ADE:**18**;SEP 17, 2008
 ;
 ; This patch contains calls to 3 ADE P18 routines with
 ; 2009-2010 Dental Code Updates.
 ;
ENV ;Environment check
 I '$G(IOM) D HOME^%ZIS
 ;
 I '$G(DUZ) W !,"YOUR DUZ VARIABLE IS UNDEFINED!! Please login with your Access & Verify." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"Your DUZ(0) VARIABLE IS UNDEFINED OR NULL." D SORRY(2) Q
 ;
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"YOUR DUZ(0) VARIABLE DOES NOT CONTAIN AN '@'." D SORRY(2)
 Q 
POST ;EP Post-Install
 ; only post for patch 18 - ENM 09/17/08
 ; Add new, modify and delete ADA Codes
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Adding ADA Codes...")
 D ADDCDT5^ADE6P181
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Set the ^ADEDIT(""AC"" X-Ref for Codes 3222/2750 & 5991/4341...")
 D AC^ADE6P181
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Mods to ADA Codes...")
 D MODCDT5^ADE6P182
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Deleting ADA Codes...")
 D DELCDT5^ADE6P183
 D BMES^XPDUTL("...DONE")
 ;D BMES^XPDUTL("Deleting Inactive Dates from selected records...")
 ;D ZAPINA^ADE6P183
 ;D BMES^XPDUTL("...DONE")
 Q
SORRY(X) ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
