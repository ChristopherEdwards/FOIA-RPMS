AZXRBUG1 ;BUGDRUG2 Entry/Edit PROGRAM [ 09/23/94   9:50 AM ]
 ;Version 1
 ;08/04/92   JOHN H. LYNCH
 ;
 ;ALLOWS THE DATA ENTRY PERSON TO ENTER OR
 ;EDIT INFORMATION IN THE BUGDRUG2 DATABASE.
 
 ;THE ROUTINES THAT CALL AZXRBUG2:        
 ;AZXRBUG, Main
 
 ;THE ROUTINES THAT AZXRBUG2 CALLS:
 ;EN^DIK       (FILEMAN RE-CROSS-REF ROUTINE)
 ;^DIE         (FILEMAN EDIT ROUTINE)
 ;^DIC         (FILEMAN LOOKUP ROUTINE)
 
 ;SET LOCAL VARIABLES OUTSIDE OF MAIN
 S FLAG=-1                               ;FLAG= A CHECK FOR NEW ENTRIES
                                         ;WHICH RUN DEFAULT SUB-ROUTINE
                                         ;THE DEFAULT SUB-ROUTINE WILL
                                         ;ONLY BE RUN AFTER THE FIRST
                                         ;NEW ENTRY.
 
 ;Variable List
 ;FLAG=         A flag which alerts program to run DEFAULT sub-routine.
 ;DIE("NO^")=   Keeps user from exiting once in; allows jumping though.
 ;DIE=          BUGDRUG2 database global.
 ;INUM=         The current internal entry number.
 ;TCOUNT=       The total count of current entries in the file.
 ;SNUM=         The users input of the record number.
 ;PIEC=         Starting point of lookup for users SNUM entry.
 ;DA=           Internal entry number used during lookup.
 ;DR=           Used as entry/edit setup in calling Fileman.
 ;X=            Used in setting the default values for Entry/Edit
 ;DIK=          Global root of file for re-indexing.
 ;DIK(1)=       Specifies which field and cross-ref. to re-index.
 ;DIC(0)=       Setup values for Fileman lookup.
 ;DDA=          Default Internal Entry Number.
 ;DFAC=         Default Facility.
 ;DIC=          Global root of file for Fileman lookup.
 ;DDATE=        Default Date.
 ;Y=            The returned value from Fileman lookup.
 ;DORG=         Default Organism_Name.
 ;DSPEC=        Default Specimen_Name.
 
MAIN ;AZXRBUG1 PROGRAM CONTROL    
 ;SET LOCAL VARIABLES
 S DIE("NO^")="BACK"                     ;KEEP USER FROM EXITING
                                         ;ALLOW JUMPING
 S DIE="1991020"                         ;^BUGDRUG2 (DATABASE GLOBAL)
 
 W @IOF                                  ;CLEAR SCREEN
 
 W !!!,"BugDrug2 Entry/Edit...",!!
 
RECORD ;Select Record Number:                  ;SUB-ROUTINE
 ;SET LOCAL VARIABLES
 S INUM=$P(^DIZ(DIE,0),U,3)              ;INUM= CURR. INTERNAL NUMBER
 S TCOUNT=$P(^DIZ(DIE,0),U,4)            ;TCOUNT= TOTAL COUNT CURRENT
                                         ;IN FILE
 
 W !,"Select Record Number: ",INUM+1,"//"
 R SNUM
 
 I (SNUM'="")&(SNUM'?1.3"?")&(SNUM'="^")&'((SNUM>0)&(SNUM<1000000))&(SNUM'?1.6N) W !!,"Illegal Record Number.",!!,"     Enter a Record Number between [1..999999], or",!,"     Enter a ""?"" for help, or",!,"     Enter a ""^"" to quit.",!,*7  G RECORD
                                         ;CHECK FOR VALID USER INPUT
 
 I SNUM="" S SNUM=INUM+1                 ;DEFAULT (NEW ENTRY)
 I SNUM="^" D KILL Q                     ;"^"= QUIT/RETURN TO AZXRBUG
 I SNUM?1.3"?" W !!,"Please enter your Record Number or",!,"press return and accept the default for a new entry.",! G RECORD
 
 I (SNUM=(INUM+1)) S $P(^DIZ(DIE,0),U,3)=INUM+1,$P(^DIZ(DIE,0),U,4)=TCOUNT+1 S FLAG=FLAG+1 I FLAG D DEFAULT              ;SNUM= NEW ENTRY
                                         ;INCREMENT COUNTERS IN
                                         ;^DIZ(DIE,0)
                                         ;FLAG= SET DEFAULT VALUES FOR
                                         ;ENTRY SCREEN (AFTER 1ST ENTRY)
 
 I SNUM>(INUM+1) W !!,"SKIPPING RECORD NUMBERS IS NOT ALLOWED!",*7 H 3 G MAIN                                            ;USER TRYING TO ENTER NUMBER
                                         ;OUT OF SEQUENCE
 
 S PIEC=0
 I (SNUM<(INUM+1))&('$O(^DIZ(DIE,"B",SNUM,PIEC))) W !!,"RECORD NUMBER, ",SNUM,", HAS ALREADY BEEN DELETED!",!,*7 H 3 G RECORD
                                         ;LOOK UP USER INPUT TO SEE IF
                                         ;IT ALREADY EXISTS, IF NOT SAY
                                         ;IT HAS BEEN ALREADY DELETED
 
 S PIEC=0
 S DA=SNUM                               ;DA= INTERNAL ENTRY NUMBER
 I (SNUM<(INUM+1))&($O(^DIZ(DIE,"B",SNUM,PIEC))) K ^DIZ(DIE,"FOD",$P(^DIZ(DIE,DA,0),U,2),$P(^DIZ(DIE,DA,0),U,4),$P(^DIZ(DIE,DA,0),U,3),DA),^DIZ(DIE,"FDSO",$P(^DIZ(DIE,DA,0),U,2),$P(^DIZ(DIE,DA,0),U,3),$P(^DIZ(DIE,DA,0),U,5),$P(^DIZ(DIE,DA,0),U,4),DA)
                                         ;LOOK UP USER INPUT TO SEE IF
                                         ;IT ALREADY EXISTS, IF IT DOES
                                         ;DELETE "FOD" & "FDSO"
                                         ;CROSS-REFERENCE
 
 L ^DIZ(DIE,DA):0 I '$T  W !!,"RECORD HAS BEEN LOCKED, TRY AGAIN LATER!",!  H 3 G RECORD                                 ;LOCK RECORD
                                         ;INTO ^BUGDRUG2 DATABASE
 
 I (SNUM'=(INUM+1))!('FLAG) S DR=".01///^S X=DA;1;2;3;4;15;16;18;21;7;12;13;20;17;23;24;8;19;14;10;26;6;11;25;22;5;9" D ^DIE G UNLOCK
                                         ;SETUP FOR CALL TO FILEMAN
                                         ;--EDIT AN ENTRY or
                                         ;--FLAG NOT SET YET
                                         ;DR= STUFF .01 (Record Number)
                                         ;CALL FILEMAN EDIT
        
 S DR=".01///^S X=DA"                    ;SETUP FOR CALL TO FILEMAN
                                         ;--NEW ENTRY and
                                         ;--FLAG IS SET
                                         ;DR= STUFF .01 (Record Number)
 D ^DIE                                  ;CALL FILEMAN ENTRY
 
 S DR="1//^S X=DFAC"                     ;SET DEFAULT (DFAC) FACILITY
 D ^DIE                                  ;CALL FILEMAN ENTRY
 
 S DR="2//^S X=DDATE"                    ;SET DEFAULT (DDATE) DATE
 D ^DIE                                  ;CALL FILEMAN ENTRY
 
 S DR="3//^S X=DORG"                     ;SET DEFAULT (DORG) Organism
 D ^DIE                                  ;CALL FILEMAN ENTRY
 
 S DR="4//^S X=DSPEC;15;16;18;21;7;12;13;20;17;23;24;8;19;14;10;26;6;11;25;22;5;9"
                                         ;SET DEFAULT (DSPEC) Specimen
                                         ;ENTER IN SPECIFIC ORDER
 D ^DIE                                  ;CALL FILEMAN ENTRY
 
UNLOCK D INDEX L                               ;CALL FILEMAN FOR ENTRY/EDIT
                                         ;CALL INDEX (RE-CROSS-REF.)
                                         ;UNLOCK RECORD
 
 G MAIN                                  ;SET UP FOR NEXT ENTRY/EDIT
 Q
 
INDEX ;RE-INDEX "FOD" AND "FDSO" CROSS-REFS.
 ;SET LOCAL VARIABLES
 S DA=SNUM                               ;DA= INTERNAL ENTRY NUMBER
 S DIK="^DIZ(1991020,"                   ;GLOBAL ROOT (^BUGDRUG2)
 
 S DIK(1)="3^FOD"                        ;Organism_Name, "FOD" CR-REF
 D EN^DIK                                ;RE-INDEX "FOD"
 
 S DIK(1)="4^FDSO"                       ;Specimen_Name, "FDSO" CR-REF
 D EN^DIK                                ;RE-INDEX "FDSO"
 Q
 
DEFAULT ;SET UP NEW DEFAULT VALUES FOR
 ;Facility, Date, Organism_Name, Specimen_Name
 ;SET LOCAL VARIABLES
 S DIC(0)="NXZ"                          ;N= INTERNAL NUMBER LOOKUP
                                         ;X= EXACT MATCH REQUIRED
                                         ;Z= VALUES RETURNED IN Y=N^S
                                         ;   N= INTERNAL ENTRY NUMBER
                                         ;   S= VALUE OF .01 FIELD
 
 S DDA=SNUM-1                            ;DDA= DEFAULT INTERNAL NUMBER
 
 S DFAC=$P(^DIZ(1991020,DDA,0),U,2)      ;DFAC= DEFAULT Facility CODE
 S DIC="^DIZ(1991010,"                   ;DIC= SITES FILE
 S X=DFAC                                ;X= LOOKUP VALUE (DFAC)
 D ^DIC                                  ;DO FILEMAN LOOKUP
 S DFAC=$P(^DIZ(1991010,$P(Y,U,1),0),U,1)
                                         ;DFAC= DEFAULT Facility NAME
 
 S DDATE=$P(^DIZ(1991020,DDA,0),U,3)     ;DDATE= DEFAULT Date (Fileman)
 S Y=DDATE D DD^%DT S DDATE=Y            ;DDATE= DEFAULT External Date
 
 S DORG=$P(^DIZ(1991020,DDA,0),U,4)      ;DORG= DEFAULT Organism_Code
 S DIC="^DIZ(1991018,"                   ;DIC= ORGANISM FILE
 S X=DORG                                ;X= LOOKUP VALUE (DORG)
 D ^DIC                                  ;DO FILEMAN LOOKUP
 S DORG=$P(^DIZ(1991018,$P(Y,U,1),0),U,1)
                                         ;DORG= DEFAULT Organism_Name
 
 S DSPEC=$P(^DIZ(1991020,DDA,0),U,5)     ;DSPEC= DEFAULT Specimen_Code
 S DIC="^DIZ(1991019,"                   ;DIC= SPECIMEN FILE
 S X=DSPEC                               ;X= LOOKUP VALUE (DSPEC)
 D ^DIC                                  ;DO FILEMAN LOOKUP
 S DSPEC=$P(^DIZ(1991019,$P(Y,U,1),0),U,1) 
                                         ;DSPEC= DEFAULT Specimen_Name
 Q
 
KILL ;KILL ALL LOCAL VARIABLES TO AZXRBUG1
 K FLAG,DIE("NO^"),DIE,INUM,TCOUNT,SNUM,PIEC,DA,DR,X,DIK
 K DIK(1),DIC(0),DDA,DFAC,DIC,DDATE,Y,DORG,DSPEC
 Q
