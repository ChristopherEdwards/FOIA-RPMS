AGVAR    ; IHS/ASDS/EFG - SET REGISTRATION VARIABLES ;
         ;;7.1;PATIENT REGISTRATION;**1,2,8,9,10**;AUG 25, 2005;Build 7
         ;
         ;ADDED UNDOCUMENTED ESCAPE FEATURE FOR EDIT CHECKS.
         ;IF ERRORS APPEAR SPECS REQUIRE FIELD TO BE FIXED BEFORE ALLOWING
         ;EXIT VARIABLE AGOPT("ESCAPE") CONTAINS THE STRING TO ESCAPE THIS
         ;
         N X,DPTFLAG
         I $D(^DIC(9.4,"C","DPT")) D
         . S X=$$VERSION^XPDUTL("DPT")
         . I X>5 S DPTFLAG=""
         S AG("QUIT")=""
         I '$D(^AGFAC(DUZ(2))) G BAD
         K AGOPT
         ;AG*7.1*8 - Changed from 25 to 26 to include new LINK AOB TO ROI FIELD parameter
         ;AG*7.1*9 - Changed from 26 to 28 to include Disp MIGRANT WORKER and Disp HOMELESS parameter
         F AG=2:1:28 G:$P($G(^AGFAC(DUZ(2),0)),U,AG)="" BAD S AGOPT(AG-1)=$P(^(0),U,AG)
         I '$D(DTIME) S DTIME=300
         I '$D(DT) D
         . S %DT=""
         . S X="T"
         . D ^%DT
         . S DT=Y
         ;D VIDEO^AG  ;IHS/SD/SDR 4/7/11 HEAT31913
         I $G(IOST(0))'="" D VIDEO^AG  ;IHS/SD/SDR 4/7/11 HEAT31913
         S AGOPT("ESCAPE")="+++"
         S AGOPT("AGE OF MINOR")=18  ;IHS/SD/TPF AG*7.1*1 ITEM 18
         S AGOPT("VERSION")=$$VERSION^XPDUTL("AG")  ;GET CURRENT VERSION EDIT CHECKS WILL BE PERFORMED DIFFERENTLY ON SOME FIELDS BECAUSE VERSION 7.1 CHANGED THEIR LOCATION
END      ;
         Q
BAD      ;
         W *7,!,"The REGISTRATION PARAMETERS file has not been completed for this facility."
         W !!,"Please contact your system support person.",!!
         S (XQUIT,AG("QUIT"))=1
         K DIR
         S DIR("A")="Press RETURN..."
         S DIR(0)="E"
         D ^DIR
         K DIR
         G END
