ACHS31E ;IHS/OIT/FCJ - ACHS 3.1 PATCH 13 ENV CHECK ; JUL 10,2008
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**13**;JUNE 11,2001
 ;3.1*13 12/7/2006;IHS/OIT/FCJ
 ;
 ;
 I '$G(IOM) D HOME^%ZIS
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"DUZ(0) DOES NOT CONTAIN AN '@'." D SORRY(2) Q
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 ;
 NEW IORVON,IORVOFF
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 ;
 I $$VCHK("ACHS","3.1",2,"'=")
 I '$$INSTALLD("AUT*98.1*20") D
 .W !,$$CJ^XLFSTR("AUT*98.1*20 IS REQUIRED"_IORVOFF,IOM)
 .S XPDQUIT=2
 E  W !?16,"Need atleast AUT 98.1*20.....Present"
 I $$VCHK("XU","8.0",2,"<")
 I $$VCHK("DI","22.0",2,"<")
 I $$VCHK("ATX","5.1",2,"<")
 I $$VCHK("AUPN","99.1",2,"<")
 ;
 NEW DA,DIC
 S X="ACHS",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","ACHS")) D
 .W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""ACHS"" prefix.",IOM)
 .W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 .D SORRY(2)
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR(IORVON_"You must FIX IT, Before Proceeding."_IORVOFF,IOM),!!,*7,*7,*7 Q
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","ACHS31E")
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0 D HELP^XBHELP("INTROI","ACHS31E") I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
VCHK(ACHSPRE,ACHSVER,ACHSQUIT,ACHSCOMP) ; Check versions needed.
 ;  
 NEW ACHSV
 S ACHSV=$$VERSION^XPDUTL(ACHSPRE)
 W !,$$CJ^XLFSTR("Need "_$S(ACHSCOMP="<":"at least ",1:"")_ACHSPRE_" v "_ACHSVER_"....."_ACHSPRE_" v "_ACHSV_" Present",IOM)
 I @(ACHSV_ACHSCOMP_ACHSVER) D SORRY(ACHSQUIT) Q 0
 Q 1
INSTALLD(ACHS) ;EP; Determine if patch ACHS was installed, where ACHS is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 ;
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(ACHS,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(ACHS,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(ACHS,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ; -------------------------------------------
INTROE ; Intro text during KIDS Environment check.
 ;;In this distribution:
 ;;(1)  Routine: ACHSPA0 fix undefined variable during processing EOBR.
 ;;(2)  Routine: ACHSRPU fix undefined variable during printing "C"
 ;;      for contract on PDO.
 ;;(3)  Routines: ACHSVDV and ACHSVDVA modified to allow adding and
 ;;     editing the DUNS number for a vendor.
 ;;(4)  Routine: ACHSBMC added interface with RCIS package for
 ;;     denial and appeal information, which will now be transferred
 ;;     to RCIS package if link is on.
 ;;(5)  Routines: ACHSDN,ACHSDN1 and ACHSDN2 fixed problem of not
 ;;     being able to "^" out of issuing a denial.
 ;;(6) Routines: ACHSRMVD(new) and ACHSYM added ability to delete the
 ;;    duplicate documents by fiscal year.  Located under the programmer
 ;;    options.
 ;;(7) Routines: ACHSRPU,ACHSMD0A,ACHSRP31,ACHSRP3D,ACHSRPI1,
 ;;    ACHSRPIN,ACHSTX3,ACHSTX33 and ACHSTX3C fixes problems of
 ;;    printing/displaying the correct policy number/holder and coverage
 ;;    type from Patient Registration 7.1.
 ;;       1. Printing policy number, ins address and coverage on univ form
 ;;       2. Fixed printing policy number and coverage on the MDOL Report
 ;;       3. Fixed printing policy number and coverage on the 43 and 64 forms 
 ;;       4. Fixed printing policy number and coverage on the Dental forms 
 ;;       5. Fixed print insurance for denial letters w/ alt resources 
 ;;       6. Fixed displaying a policy during entering a new PDO
 ;;       7. Fixed displaying policy during entering a denial
 ;;       8. ACHSTX3-Modified to send correct POLICY HOLDER NAME 
 ;;       9. ACHSTX33-Modified to send correct POLICY HOLDER NAME
 ;;       10. ACHSTX3C-Fixed pulling pol and cov type ;EXPORT DATA (4A/9) - RECORD 3(PATIENT FOR AO/FI)
 ;;(8) Routine: ACHSEOB6 fixes closing a slave device.
 ;;(9) Routine: ACHSCPTC fixes CPT report, variable undefined
 ;;(10) Routine: ACHSOCSQ fixes SCC report for Queue and Go to problems.
 ;;(11) Routine: ACHSFIM fixes multiple problems, exiting, looping,
    ;;     selecting blankets, etc
 ;;(12) UFMS Export
    ;;     At the facility, this option has been combined with the
    ;;     CDPE   CHS data - prepare for export option.  The option will
    ;;     now create a new UFMS type record.  The data will be sent
    ;;     to the Area office with the other record types.  A parameter
    ;;     has been added to the CHS Facility file, UFMS Export Start
    ;;     date. The field has been stuffed with an OCT 1, 2007 start
    ;;     date for IHS type facilities.  After Oct 1, the IHS
    ;;     facilites will be able to export without closing the DCR.
 ;;
    ;;     At the Area, the UFMS record count has been added, the display
    ;;     of patch 11 has been removed.  The UFMS file will auto send
    ;;     the UFMS file to the Integration Engine (IE) server.  The
    ;;     record count, date received, date sent from the IE will be
    ;;     displayed on a web page for access from sites.  If an error
    ;;     occurs with the file an e-mail message will be sent to the
    ;;     Area staff designated on the list to be notified.
 ;;
 ;;###
 ;
INTROI ; Intro text during KIDS Install.
 ;;A standard message will be produced by this update.
 ;;  
 ;;If you run interactively, results are displayed on your screen,
 ;;in the mail message and in the INSTALL file.
 ;;If you queue to TaskMan, please read the mail message for results of
 ;;this update, and remember not to Q to the HOME device.
 ;;###
 ;
