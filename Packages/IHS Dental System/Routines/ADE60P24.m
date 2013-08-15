ADE60P24 ;IHS/OIT/GAB - ADE GENERAL PATCH MODULE P24 [ 11/21/2012  11:38 AM ]
 ;;6.0;ADE;**24**;NOV 25, 2012
 ;
 ; This patch contains calls to 3 ADE P24 routines with
 ; 2013 Dental Code Updates.
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
 ; only post for patch 24 - /IHS/OIT/GAB 11/21/2012
 ; Add new, modify and delete ADA Codes
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Adding 2013 ADA Codes...")
 D ADDCDT5^ADE6P241
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Set ^ADEDIT(""AC"" X-Ref for 2013 ADA Codes...")
 D AC^ADE6P241
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Mods to ADA Codes...")
 D MODCDT5^ADE6P242
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Mods to IHS ADA Codes...")
 D DELCDT5^ADE6P243
 D BMES^XPDUTL("...DONE")
 D BMES^XPDUTL("Reactivating ADA Codes ...")
 D ZAPINA^ADE6P243
 D BMES^XPDUTL("...DONE")
 Q
SORRY(X) ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
