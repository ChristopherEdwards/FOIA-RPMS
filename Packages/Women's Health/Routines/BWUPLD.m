BWUPLD ;IHS/ANMC/MWR - UPLOAD: UPLOAD LAB FILES;11-Feb-2003 18:09;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  CALLED BY OPTION: "BW UPLD LOAD LAB FILES" TO UPLOAD FROM HFS
 ;;  COMMERCIAL LAB ABBREVIATION TABLES AND RESULTS.
 ;
 ;---> THIS ROUTINE UPLOADS THE SELECTED HOST FILE: EITHER A
 ;---> TABLE OF RESULTS ABBREVIATIONS FROM A COMMERCIAL LAB,
 ;---> OR A FILE OF LAB TEST RESULTS FROM A COMMERCIAL.
 ;---> THE HOST FILE IS FIRST READ INTO A TEMPORARY "HOLDING" FILE,
 ;---> CONVERTED FROM FIXED LENGTH IF NECESSARY DURING THE READ.
 ;---> THEN A SECOND ROUTINE IS CALLED TO MOVE DATA FROM THE
 ;---> TEMPORARY FILE INTO THE APPROPRIATE PERMANENT FILE.
 ;
START ;EP
 N BWHNDL
 S BWHNDL="WHEALTH"
 D SETVARS^BWUTL5
 D TITLE^BWUTL5("UTILITY TO IMPORT LAB RESULTS")
 W !!?3,"NOTE: THIS UTILITY IS FOR USE ONLY WITH CORNING CLINICAL"
 W " LABORATORIES."
 S BWHFS=$P(^BWSITE(DUZ(2),0),U,14)
 I BWHFS']"" D  Q
 .W !!?5,"No Host File Path has been specified in the Site Parameters."
 .W !?5,"Edit the Site Parameters or contact your site manager.",!
 .D DIRZ^BWUTL3
 ;
MENU ;EP
 ;---> CHOOSE FILE TO UPLOAD.
 N DIR,DIRUT,Y
 W !!!?3,"Choose lab name and type of file to upload."
 W !?3,"(Note: The Corning Table must be loaded before the Corning "
 W "Results.)"
 S DIR("A")="     Select file name and type"
 S DIR(0)="SMO^CT:Corning Table;CR:Corning Results"
 D HELP1
 D ^DIR
 I Y=-1!($D(DIRUT)) S BWPOP=1 G EXIT
 S BWA=Y
 ;---> BELOW, BWGBL IDENTIFIES THE TEMPORARY FILE, BWRTN IDENTIFIES
 ;---> THE ROUTINE FOR CONVERTING THE DATA (FROM FIXED LENGTH, ETC.)
 ;---> AND FOR TRANSFERING THE DATA FROM THE TEMPORARY FILE TO THE
 ;---> PERMANENT FILE.
 D
 .I BWA="CT" S BWRTN="^BWUPTNI",BWGBL="^BWTNI(" Q
 .I BWA="CR" S BWRTN="^BWUPRNI",BWGBL="^BWRNI(" Q
 I '$D(@(BWGBL_"0)")) W !,"Receiving global does not exist." Q
 S BWGBLN=$P(@(BWGBL_"0)"),U)
 ;
 ;---> ASK FOR HOST FILE NAME.
 K DIR
 W !!?5,"Enter the name of the file you wish to import."
 W !?5,"Do not include any slashes in the filename.",!
 S DIR(0)="FOA",DIR("A")="     Enter filename: "
 S DIR("?")="     Enter the filename without any path "
 S DIR("?")=DIR("?")_"--just the filename itself."
 D ^DIR
 I $D(DIRUT) S BWPOP=1 Q
 S BWFLNM=Y
 ;
 ;---> KILL OFF EXISTING TEMPORARY FILE GLOBAL.
 D ZGBL^BWUTL8(BWGBL)
 ;
READ ;EP
 ;---> READ LINES OF HOST FILE TEXT AND STUFF AS NODES IN ^BWTNI
 S Y=$$OPEN^%ZISH(BWHNDL,BWHFS,BWFLNM,"R")
 I Y D  Q
 .W !?10,"* FAILURE TO OPEN HOST FILE: ",BWHFS,BWFLNM," (",Y,")"
 .W !?10,"  CHECK FILENAME AND PATH IN SITE PARAMETERS.",!
 .D DIRZ^BWUTL3
 ;
 W !!?5,"Uploading Host File to ",BWGBLN," file..."
 U IO
 F BWI=1:1 R BWLINE:DTIME Q:'$L(BWLINE)  D
 .Q:$P(BWLINE,U)?1C.C
 .;---> CONVERT FIXED LENGTH FIELDS TO VARIABLE, DELIMITED BY "^", ETC.
 .N Y
 .D @("CVT"_BWRTN_"(.BWLINE,.Y)")
 .Q:BWLINE=""
 .I 'Y S @(BWGBL_BWI_",0)")=BWLINE Q
 .S @(BWGBL_BWI_",0)")=$P(BWLINE,U,1,12)
 .S @(BWGBL_BWI_",1)")=$P(BWLINE,U,13,18)
 .S @(BWGBL_BWI_",2)")=$P(BWLINE,U,19,25)
 D ^%ZISC
 ;
INDEX ;EP
 ;---> NOW INDEX THE FILE.
 W !?5,"Indexing ",BWGBLN," file..."
 S DIK=BWGBL D IXALL^DIK
 ;
TRANSFER ;EP
 ;---> TRANSFER TEMPORARY TABLE ENTRIES TO PERMANENT FILE.
 D @("TRANS"_BWRTN)
 ;
 W !?5,"Deleting ",BWGBLN," data..."
 ;---> CLEANUP: KILL OFF EXISTING TEMPORARY FILE GLOBAL.
 D ZGBL^BWUTL8(BWGBL)
 W !?5,"Complete.",! D DIRZ^BWUTL3
 ;
EXIT ;EP
 D KILLALL^BWUTL8
 Q
 ;
HELPTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
 ;
HELP1 ;EP
 ;;Table files contain the Abbreviations Table for the selected lab.
 ;;Results files contain the coded results of patients' tests for
 ;;the selected lab.
 S BWTAB=5,BWLINL="HELP1" D HELPTX
 Q
