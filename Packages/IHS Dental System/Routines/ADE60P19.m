ADE60P19 ;IHS/OIT/ENM - ADE GENERAL PATCH MODULE P19 [ 04/23/2009  11:38 AM ]
 ;;6.0;ADE;**19**;MAR 25, 1999
 ;
 ; This patch contains calls to 2 ADE P19 routines with
 ; new Dental Operative Site Updates and 1 ADA Code activation
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
 ; only post for patch 19 - ENM 04/23/09
 ; Add new Operative Site Rec's, Modify 1 ADA Code
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Adding new Operative Site Records...")
 D ADDOP^ADE6P191
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("Deleting Inactive Date from ADA record 4268...")
 D ZAPINA^ADE6P193
 D BMES^XPDUTL("...DONE")
 Q
SORRY(X) ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
