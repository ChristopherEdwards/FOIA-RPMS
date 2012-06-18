ADE60P21 ;IHS/OIT/ENM - ADE GENERAL PATCH MODULE P21 [ 12/07/2009 11:38 AM ]
 ;;6.0;ADE;**21**;MAR 25, 1999
 ;
 ; This patch contains calls to 1 ADE P21 routine with
 ; modified 'No Opsite' data in Dental ADA Code file
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
 ; only post for patch 21 - ENM 12/04/09
 ; Modify 23 ADA Codes
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Modifying the 'No Opsite' fields for 23 ADA Code File records and more...")
 D MODADA^ADE6P21
 D BMES^XPDUTL(" ...DONE")
 Q
SORRY(X) ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
