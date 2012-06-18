ADE60P17 ;IHS/OIT/ENM - ADE GENERAL PATCH MODULE [ 03/27/2007  9:55 AM ]
 ;;6.0;ADE;**17**;JAN 29, 2007
 ;
 ; This patch contains calls to 4 ADE P17 routines with
 ; 2007-2008 Dental Code Updates.
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
 ; only post for patch 17 - ENM 02/02/07
 ; Add new, modify and delete ADA Codes
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Adding ADA Codes...")
 D ADDCDT5^ADE6P171
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Mods to ADA Codes...")
 D MODCDT5^ADE6P172
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Mods to ADA Codes...")
 D MODCDT5^ADE6P175
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Deleting ADA Codes...")
 D DELCDT5^ADE6P173
 D BMES^XPDUTL("...DONE")
 D BMES^XPDUTL("Deleting Inactive Dates from selected records...")
 D ZAPINA^ADE6P173
 D BMES^XPDUTL("...DONE")
 Q
SORRY(X) ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
