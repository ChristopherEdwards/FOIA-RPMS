AZXZSUP1 ;SUPPDB SUPPORT LOG NUMBER DELETE PROGRAM [ 05/01/95   1:25 PM ]
 ;04/03/92  JOHN H. LYNCH
 ;
 ;THIS ROUTINE WILL ALLOW A USER TO PULL UP
 ;A SUPPORT LOG NUMBER'S (IF IT EXISTS) DATA 
 ;AND DELETE IT IF THEY SO CHOOSE.
 
PASSWD ;CHECK FOR SECURITY ACCESS
 W @IOF
 R !!!!,"Please enter password: ",PASS
 I PASS="AaBbCc" D MAIN
 K PASS
 Q
 
MAIN ;AZXZSUP1 PROGRAM CONTROL
 W @IOF                     ;CLEAR SCREEN
 ;SET LOCAL VARIABLES
 S DIE="1991012"            ;SET EDIT FILE NUMBER
 S DIC="^DIZ(1991012,"      ;SET LOOK-UP FILE NUMBER
 S INUM=$P(^DIZ(DIE,0),U,3) ;CURRENT INTERNAL NUMBER
 
 D SUPPNUM
 K DIE,DIC,INUM,DNUM,PIEC,DA,DR,YN
 Q
 
SUPPNUM R !!,"Select Support Number to Delete: ",DNUM
 
 ;CHECK FOR "^" TO QUIT OR "?" FOR HELP
 I (DNUM="^")!(DNUM="") Q
 I DNUM="?" W !!,"Please enter the support number you would like to delete." G SUPPNUM
 
 ;CHECK TO SEE IF INPUT IS GREATER THAN CURRENT ENTRY NUMBER
 I DNUM>INUM W !!,"Support Number, ",DNUM,", Does Not Exist!" H 3 G MAIN        
 W !              ;SKIP LINE
 ;CHECK TO SEE IF SUPPORT NUMBER HAS ALREADY BEEN DELETED
 S PIEC=0
 I '$O(^DIZ(DIE,"B",DNUM,PIEC)) W !!,"Support Number, ",DNUM,", Has already been deleted!" H 3 G MAIN
 
 S DA=DNUM        ;SET INTERNAL NUMBER TO USER INPUT
 S DR=".01:7"     ;SET SUBSCRIPTS TO BE VIEWED
 
 L ^DIZ(DIE,DA):0 I '$T W !!,"Record has been locked, try again later!" H 3 G MAIN 
 D EN^DIQ         ;DO DATA DISPLAY OF GIVEN SUPPORT NUMBER
 
 W !!,"Do you want to continue to delete Support Number, ",DNUM,"? N//"
 R YN
 
 I YN'="Y"  L  G MAIN  ;IF "N" UNLOCK RECORD AND GOTO MAIN
 
 R !,"Are you sure? N//",YN
 I YN'="Y"  L  G MAIN  ;IF "N" UNLOCK RECORD AND GOTO MAIN
 
 W !!,"Deleting Support Number, ",DA,", one moment please..." H 1
 S DR=".01///@"    ;SET TO DELETE SUPPORT NUMBER (.01 FIELD)
 D ^DIE            ;CALL EDIT IN FILEMAN FOR DELETE
 L                 ;UNLOCK RECORD
 G MAIN            ;RUN DELETE PROGRAM AGAIN
 Q
