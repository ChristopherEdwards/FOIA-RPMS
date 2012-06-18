PSDP346 ; BAY/KAM - Patch PSD*3*46 Install Utility Routine ;5/3/04 12:17pm
 ;;3.0; CONTROLLED SUBSTANCES;**46**;AUG 13, 1993
 ;
ENV ;Main Entry point for Environment Check
 S XPDABORT=""
 D PROGCHK(.XPDABORT) ;checks programmer variables
 I XPDABORT="" K XPDABORT Q
 D COREFLS
 Q
PROGCHK(XPDABORT) ; checks for necessary programmer variables
 ;
 I '$G(DUZ)!($G(DUZ(0))'="@")!('$G(DT))!($G(U)'="^")  D
 . D BMES^XPDUTL("****")
 . D MES^XPDUTL("Your programming variables are not set up properly.")
 . D MES^XPDUTL("Installation aborted.")
 . D MES^XPDUTL("*****")
 . S XPDABORT=2
 Q
COREFLS ; this is the environment check for CoreFLS
 I $$PATCH^XPDUTL("PSD*3.0*38")!($$PATCH^XPDUTL("PSA*3.0*32")) D
 . W !,"You are a test site for a CoreFLS version (Patch PSD*3*38 and/or PSA*3*32)",!,"of Controlled Substance or Drug Accountability"
 . W !,"Instructions are in PSD*3*38 and PSA*3*32 on how to flip the switch to CoreFLS."
 . W !,"This patch has a conflict with the FB-CoreFLS test software."
 . W !,"It must NOT be installed unless an accompanying update is made to the"
 . W !,"FB-CoreFLS software immediately after installation of this patch."
 . W !
 . K DIR S DIR(0)="YA"
 . S DIR("A")="Do you have the corresponding update to the FB-CoreFLS software that is         associated with this patch? (Note:Entering ""No"" here will stop the installation of this patch) Y/N//"
 . D ^DIR K DIR
 . I $D(DTOUT)!$D(DUOUT)!(Y'=1) W !,"Installation of this patch has been stopped!" S XPDABORT=2 Q
 . W !,"OK to install"
 Q
