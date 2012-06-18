ADE60P20 ;IHS/OIT/ENM - ADE GENERAL PATCH MODULE P20 [ 10/07/2009  11:38 AM ]
 ;;6.0;ADE;**20**;MAR 25, 1999
 ;
 ; This patch contains calls to 1 ADE P20 routine with
 ; new Dental ADA Code Updates
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
 ; only post for patch 20 - ENM 04/23/09
 ; Modify 3 ADA Codes
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Modifying 3 records in the ADA Code File...")
 D MODCDT5^ADE6P202
 D BMES^XPDUTL(" ...DONE")
 Q
SORRY(X) ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
