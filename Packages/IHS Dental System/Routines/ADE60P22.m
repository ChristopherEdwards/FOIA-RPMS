ADE60P22 ;IHS/OIT/ENM - ADE GENERAL PATCH MODULE P22 [ 09/17/2008  11:38 AM ]
 ;;6.0;ADE;**22**;SEP 17, 2008
 ;
 ; This patch contains calls to 3 ADE P22 routines with
 ; 2011-2012 Dental Code Updates.
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
 ; only post for patch 22 - ENM 12/01/10
 ; Add new, modify and delete ADA Codes
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Adding ADA Codes...")
 D ADDCDT5^ADE6P221
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Set ^ADEDIT(""AC"" X-Ref for codes 1352,3354,6254,6795 and 7251...")
 D AC^ADE6P221
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Mods to ADA Codes...")
 D MODCDT5^ADE6P222
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Mods to IHS ADA Codes...")
 D CHGADA^ADE6P223
 D BMES^XPDUTL("...DONE")
 Q
SORRY(X) ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
