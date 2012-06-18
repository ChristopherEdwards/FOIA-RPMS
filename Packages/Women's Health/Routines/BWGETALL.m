BWGETALL ;IHS/ANMC/MWR - AUTOLOAD FEMALE PATIENTS;15-Feb-2003 21:51;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  AUTOMATICALLY LOADS WOMENS PATIENTS FROM THE MAIN PATIENT FILE,
 ;;  LIMITED BY AGE AND CURRENT COMMUNITY.
 ;
 D SETVARS^BWUTL5
 D INTRO  G:BWPOP EXIT
 D SELECT G:BWPOP EXIT
 D DEVICE G:BWPOP EXIT
 D LOAD
 ;
EXIT ;EP
 D KILLALL^BWUTL8
 Q
 ;
 ;
INTRO ;EP
 ;---> INTRODUCTORY SCREENS.
 S BWTITLE="AUTOLOAD PATIENTS"
 D TITLE^BWUTL5(BWTITLE)
 D TEXT1,DIRZ^BWUTL3
 Q:BWPOP
 D TITLE^BWUTL5(BWTITLE)
 D TEXT2,DIRZ^BWUTL3
 Q
 ;
SELECT ;EP
 ;---> SELECT AGE AND CURRENT COMMUNITY(S).
 D TITLE^BWUTL5(BWTITLE)
 ;---> SELECT AGE.
 K DIR
 W !?5,"Select the age below which patients should NOT be added:"
 S DIR("A")="     Enter AGE: ",DIR("B")=15
 S DIR(0)="NOA^10:99:2" D HELP1
 D ^DIR K DIR
 I Y=-1!($D(DIRUT)) S BWPOP=1 Q
 S BWAGE=+Y
 ;
 ;---> SELECT CURRENT COMMUNITY(S).
 I $$AGENCY^BWUTL5(DUZ(2))'="i" S BWCC("ALL")="" Q   ;VAMOD
 D SELECT^BWSELECT("Current Community",9999999.05,"BWCC","","",.BWPOP)
 Q
 ;
DEVICE ;EP
 ;---> GET DEVICE AND POSSIBLY QUEUE TO TASKMAN.
 S ZTRTN="LOAD^BWGETALL"
 S ZTSAVE("BWAGE")=""
 ;---> SAVE CURRENT COMMUNITY ARRAY.
 I $D(BWCC) N N S N=0 F  S N=$O(BWCC(N)) Q:N=""  D
 .S ZTSAVE("BWCC("""_N_""")")=""
 D ZIS^BWUTL2(.BWPOP,1)
 Q
 ;
LOAD ;EP
 ;---> AUTOLOAD OF PATIENTS
 N BWCOUNT,BWERROR,N,X,Y D SETVARS^BWUTL5
 D TOPHEAD^BWUTL7 S BWCONF=1
 S BWTITLE="* AUTOLOAD OF WOMEN PATIENTS *"
 D CENTERT^BWUTL5(.BWTITLE)
 U IO
 W:BWCRT @IOF D HEADER7^BWUTL7
 S (BWCOUNT,N)=0
 F  S N=$O(^DPT(N)) Q:'N  Q:BWPOP  D
 .S Y=^DPT(N,0)
 .;---> QUIT IF NOT FEMALE.
 .Q:$P(Y,U,2)'="F"
 .;---> QUIT IF DECEASED OR LESS THAN BWAGE.
 .Q:+$$AGE^BWUTL1(N)<BWAGE
 .Q:$D(^BWP(N,0))
 .;---> QUIT IF NOT SELECTING ALL CURRENT COMMUNITIES AND IF THIS IS
 .;---> NOT ONE OF THE SELECTED.
 .I '$D(BWCC("ALL")) S X=$$CURCOM^BWUTL1(N) Q:'X  Q:'$D(BWCC(X))
 .I $Y+8>IOSL D:BWCRT DIRZ^BWUTL3 Q:BWPOP  D HEADER7^BWUTL7
 .W !?3,$$NAME^BWUTL1(N),?30,$$HRCN^BWUTL1(N)
 .W ?45,$$SLDT2^BWUTL5($$DOB^BWUTL1(N))
 .D AUTOADD^BWPATE(N,DUZ(2),.BWERROR)
 .I BWERROR<0 W ?60,"FAILED" Q
 .S BWCOUNT=BWCOUNT+1 W ?60,"ADDED"
 W !!?5,"TOTAL: ",BWCOUNT," PATIENT",$S(BWCOUNT=1:"",1:"S")
 W " ADDED TO THE WOMEN'S HEALTH DATABASE.",!
 D:BWCRT DIRZ^BWUTL3 W @IOF
 D ^%ZISC
 Q
 ;
 ;
TEXT1 ;EP
 ;;This utility will examine the main RPMS Patient Database for ALL
 ;;women over a given age and add them to the Women's Health Database.
 ;;
 ;;You will be asked to select a cutoff age (e.g., 40 and over), and you
 ;;will have an opportunity to select for specific Current Communities
 ;;(based on the RPMS Patient Registration Current Community field).
 ;;NOTE: Current Community for patients in RPMS Patient Registration
 ;;must be accurate in order for this utility to be effective.
 ;;(VA sites will not be prompted for Current Community.)
 ;;
 ;;Women already in the Women's Health Database will not be added twice.
 ;;Women who are deceased will not be added.  Women added to the Women's
 ;;Health Database will be given Breast and Cervical Treatment Needs of
 ;;"Undetermined", with no due dates.
 ;;
 ;;This utility may be run at any time, as often as desired.  It may be
 ;;useful to run it on a monthly basis in order to pick up new women who
 ;;are added to the RPMS Patient Database.
 S BWTAB=5,BWLINL="TEXT1" D PRINTX
 Q
 ;
 ;
TEXT2 ;EP
 ;;Before the program begins, you will be prompted for a "DEVICE:".
 ;;The name, chart#, and date of birth of each patient added to the
 ;;Women's Health Database will be displayed on the DEVICE.
 ;;This DEVICE may be a printer, or you may enter "HOME" to have the
 ;;information simply display on your screen.
 ;;
 ;;If the DEVICE you select is a printer, it may be preferable
 ;;to "queue" the job, in order to free up your terminal.
 ;;See your computer sitemanager for assistance with queuing jobs.
 ;;
 ;;WARNING: The first time this utility is run, it may add several
 ;;thousand patients to the Women's Health Database.  It may take
 ;;several minutes or even hours to run, depending on the size of the
 ;;database and speed of the computer.  Subsequent runs should be much
 ;;quicker.
 ;;
 ;;You may type "^" at anytime to quit before the program begins.
 S BWTAB=5,BWLINL="TEXT2" D PRINTX
 Q
 ;
HELP1 ;EP
 ;;Enter a two-digit number that will be the lowest age of patients
 ;;added to the Women's Health Database.  For example, if you enter 15,
 ;;all women age 15 and older will be included, 14 and under will not.
 S BWTAB=5,BWLINL="HELP1" D HELPTX
 Q
 ;
 ;
PRINTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
HELPTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
