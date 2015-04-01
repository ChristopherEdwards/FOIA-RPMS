ADE60P26 ;IHS/OIT/GAB - ADE6.0 PATCH 26 [ 10/17/2014  2:35 PM ]
 ;;6.0;ADE*6.0*26;;March 25, 1999;Build 13
 ;;This patch contains calls to 3 ADE PATCH 26 routines with
 ;;2015 Dental Code Updates
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
 ; only post for patch 26 - /IHS/OIT/GAB 10/30/14
 ; Add new, modify and delete ADA Codes
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Adding 2015 ADA-CDT Codes...")
 D ADDCDT5^ADE6P261
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("2015 Mods to Dental Codes...")
 D MODCDT5^ADE6P262
 D BMES^XPDUTL(" ...DONE")
 D BMES^XPDUTL("2015 Mods to Dental Codes ...")
 D DELCDT5^ADE6P263
 D BMES^XPDUTL("...DONE")
 ;IHS/OIT/GAB 12.2014 ADDED BELOW SECTION TO ADD DENTAL OBJECTIVE 9986 (BROKEN APPT)
 D BMES^XPDUTL("Creating new entry in DENTAL PROGRAM OBJECTIVE File...")
 S ADED=";;"
 S ADECNT=0
 F  D ADDRVU Q:ADEVALUE="END"
 D BMES^XPDUTL(" ...DONE")
 Q
 ; ********************************************************************
ADDRVU ;
 S ADECNT=ADECNT+1
 S ADEVALUE=$P($T(@1+ADECNT),ADED,2,7)
 Q:ADEVALUE="END"
 K DIC,DA,X,Y
 S DIC="^ADEKOB("
 S DIC(0)="LZE"
 S DINUM=$P(ADEVALUE,ADED)
 S X=$P(ADEVALUE,ADED,2)
 S DIC("DR")=".02///^S X=$P(ADEVALUE,ADED,3)"
 S DIC("DR")=DIC("DR")_";.03///^S X=$P(ADEVALUE,ADED,4)"
 S DIC("DR")=DIC("DR")_";.11///^S X=$P(ADEVALUE,ADED,5)"
 S DIC("DR")=DIC("DR")_";.22///^S X=$P(ADEVALUE,ADED,6)"
 K DD,DO
 D FILE^DICN
 Q
 ;
SORRY(X) ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
 ; *********************************************************************
 ; IEN;;OBJECTIVE;;MONITORING AGES;;COUNT AGES;;LOGIC;;LEVEL
 ; *********************************************************************
1 ;;
 ;;35;;9986 - BA (ALL);;5:19;20:34;35:44;;0:4;5:9;10:14;15:19;20:34;35:44;45:54;55:64;65:125;;D TOTAL;ADEKNT2(9986,0);;PATIENT
 ;;END
