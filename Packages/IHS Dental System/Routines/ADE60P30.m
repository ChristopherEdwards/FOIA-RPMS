ADE60P30 ;IHS/OIT/GAB - ADE 6.0 PATCH 30 [ 11/02/2015  2:35 PM ]
 ;;6.0;ADE*6.0*30;;March 25, 1999;Build 19
 ;;This patch contains calls to 3 ADE PATCH 30 routines with
 ;;2016 Dental Code Updates
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
 ; only post for patch 30 - /IHS/OIT/GAB 11/02/15
 ; Add new, modify and delete ADA Codes
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Adding 2016 ADA-CDT Codes...")
 D ADDCDT5^ADE6P301
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("2016 Mods to Dental Codes...")
 D MODCDT5^ADE6P302
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("2016 Mods to Dental Codes ...")
 D DELCDT5^ADE6P303
 D BMES^XPDUTL("...DONE")
 Q
 ; ********************************************************************
SORRY(X) ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
