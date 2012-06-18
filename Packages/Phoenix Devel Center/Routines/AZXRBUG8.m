AZXRBUG8 ;BUGDRUG2 Report PROGRAM [ 09/23/94   9:52 AM ]
 ;Version 1
 ;"Code Print Report"
 ;10/07/92   JOHN H. LYNCH
 ;
 ;"Code Print Report" was written to provide all
 ;Organism, and Specimen codes currently entered
 ;into the system.  The user has the options of
 ;printing these reports alphabetically or
 ;numerically.
 
 ;THE ROUTINE THAT CALLS AZXRBUG8:
 ;AZXRBUG3, Reports Menu
 
 ;THE ROUTINES THAT AZXRBUG8 CALLS:
 ;None
 
 ;Variable List
 ;PG=               Current page count.
 ;LN=               Current line count.
 ;TYPE=             The type of report to print, Organism/Specimen.
 ;ORDER=            The order that the report is printed in,
 ;                  alphabetically/numerically.
 ;BORDER=           The border around heading.
 ;BORDER2=          Name then code border.
 ;BORDER3=          Code then name border.
 ;Y=                Used to convert current internal date to external.
 ;RDATE=            Report date; received from Y.
 ;FILE=             Current file being used, 1991018 (ORGANISM)/
 ;                  1991019 (SPECIMEN).
 ;CURR=             Either, current Organism or current Code.
 ;DA=               Internal entry number for cross-ref lookup.
 ;YN=               Users input on whether to print another report.
 
MAIN ;AZXRBUG8 PROGRAM CONTROL    
 ;SET LOCAL VARIABLES
 S PG=0                                  ;INITIALIZE PAGE COUNT
 S LN=0                                  ;INITIALIZE LINE COUNT
 
 D DTCNVRT
 D INPUT
 D KILL
 Q
 
INPUT ;TAKE INPUT FROM USER
 ;CHOOSE WHAT REPORT TO PRINT
 
 W @IOF                                  ;CLEAR SCREEN
 W !!!,"BugDrug2 Code Print...",!
 W !!,"Type an 'O' for Organism Code Print.",!
 W "Type an 'S' for Specimen Code Print.",!
 W "Type an '^' to quit.",!
OPTTYPE R !!,"Option: ",TYPE
 
 I (TYPE="^")!(TYPE="") Q                ;USER WANTS TO QUIT
 I (TYPE?1.3"?") D HELP G OPTTYPE
 I '((TYPE?1"o")!(TYPE?1"O")!(TYPE?1"s")!(TYPE?1"S")) D ILLEGAL G OPTTYPE 
 
ORD ;TAKE INPUT FROM USER
 ;ON WHAT ORDER REPORT SHOULD PRINT
 W @IOF                                  ;CLEAR SCREEN
 W !!!,"BugDrug2 Code Print...",!
 W !!,"Type an 'A' for Alphabetical Order.",!
 W "Type an 'N' for Numerical Order.",!
 W "Type an '^' for previous prompt.",!
OPTORDER R !!,"Option: ",ORDER
 
 I (ORDER="^")!(ORDER="") G INPUT        ;USER WANTS TO BACK UP
 I (ORDER?1.3"?") D HELP1 G OPTORDER
 I '((ORDER?1"a")!(ORDER?1"A")!(ORDER?1"n")!(ORDER?1"N")) D ILLEGAL G OPTORDER 
 
 D REPORT
 Q
 
ILLEGAL ;ILLEGAL USER INPUT
 W !!,*7,"Invalid input:  Press a '?' for help.",! H 2
 Q
 
HELP ;GIVE USER GENERAL HELP ON "Code Print"
 W !!,"O= Organism Code Print",?27,"S= Specimen Code Print",!
 Q
 
HELP1 ;GIVE USER GENERAL HELP ON "Code Print"
 W !!,"A= Alphabetical Order",?27,"N= Numerical Order",!
 Q
 
REPORT ;PRINT USERS CHOICE OF REPORT
 S BORDER="________________________________________________________________________________"
 S BORDER2="Code     Name                                                                  "
 S BORDER3="Name                            Code                                           "
 D PGSETUP
 G CONT
 Q
 
DTCNVRT ;CONVERT CURRENT DATE TO EXTERNAL FORMAT (RDATE)
 S Y=DT                                 ;CONVERT TO EXTERNAL DATE
 D DD^%DT                               ;VALUE RETURNED IN Y
 S RDATE=Y                              ;RDATE= REPORT DATE
 Q
 
PGSETUP ;SETUP FOR EACH PAGE 
 ;CHECK TYPE AND ORDER OF PRINT
 ;OPEN AND CLOSE DEVICE
 
 W !!                                    ;SKIP LINES
 D ^%ZIS U IO                            ;OPEN DEVICE
 
 I IO="" Q                               ;USER WANTS OUT
 I IO(0)=IO W !,*7,"The BugDrug2 Code Print must be printed.",! X ^%ZIS("C") G PGSETUP
 
 
 I (TYPE="O")!(TYPE="o")&(ORDER="A")!(ORDER="a") S TYPE="ORGALPH" D HEADING W BORDER3,!,BORDER,!! S LN=LN+3 D ORGALPH
 I (TYPE="O")!(TYPE="o")&(ORDER="N")!(ORDER="n") S TYPE="ORGCODE" D HEADING W BORDER2,!,BORDER,!! S LN=LN+3 D ORGCODE
 I (TYPE="S")!(TYPE="s")&(ORDER="A")!(ORDER="a") S TYPE="SPCALPH" D HEADING W BORDER3,!,BORDER,!! S LN=LN+3 D SPCALPH
 I (TYPE="S")!(TYPE="s")&(ORDER="N")!(ORDER="n") S TYPE="SPCCODE" D HEADING W BORDER2,!,BORDER,!! S LN=LN+3 D SPCCODE
 
 X ^%ZIS("C")                            ;CLOSE DEVICE
 Q
 
HEADING ;PRINT OUT THE HEADING FOR EACH NEW PAGE
 
 I PG>0 W #                              ;SEND FORMFEED
 S PG=PG+1                               ;INCREMENT PAGE COUNTER
 
 W !,BORDER,!
 W !,"BugDrug2"
 W ?59,"Date: ",RDATE,!
 I TYPE="ORGALPH" W !,"Organism Code Print by Name"
 I TYPE="ORGCODE" W !,"Organism Code Print by Code"
 I TYPE="SPCALPH" W !,"Specimen Code Print by Name"
 I TYPE="SPCCODE" W !,"Specimen Code Print by Code"
 W ?59,"Page: ",PG,!
 W BORDER,!!
 
 S LN=8                                  ;INITIALIZE LINE COUNTER
                                         ;HEADER USES 8 LINES
 Q
 
ORGALPH ;ORGANISM IN ALPHABETICAL ORDER
 ;SET LOCAL VARIABLES
 S FILE="1991018"
 S CURR=""                               ;CURR= INITIAL ORGANISM
 F  S CURR=$O(^DIZ(FILE,"B",CURR)) Q:CURR=""  S DA=0  F  S DA=$O(^DIZ(FILE,"B",CURR,DA)) Q:'DA  D PRTALPH
 Q
 
ORGCODE ;ORGANISM IN CODE ORDER
 ;SET LOCAL VARIABLES
 S FILE="1991018"
 S CURR=999                              ;CURR= INITIAL CODE
 F  S CURR=$O(^DIZ(FILE,"C",CURR)) Q:CURR=""  S DA=0  F  S DA=$O(^DIZ(FILE,"C",CURR,DA)) Q:'DA  D PRTCODE
                                         ;DO CODES 001-099 FIRST
 
 S CURR=99                               ;CURR= INITIAL CODE
 F  S CURR=$O(^DIZ(FILE,"C",CURR)) Q:(CURR<99)!(CURR="")  S DA=0  F  S DA=$O(^DIZ(FILE,"C",CURR,DA)) Q:'DA  D PRTCODE
                                         ;DO CODES 100-999 LAST
 Q
 
SPCALPH ;SPECIMEN IN ALPHABETICAL ORDER
 ;SET LOCAL VARIABLES
 S FILE="1991019"
 S CURR=""                               ;CURR= INITIAL ORGANISM
 F  S CURR=$O(^DIZ(FILE,"B",CURR)) Q:CURR=""  S DA=0  F  S DA=$O(^DIZ(FILE,"B",CURR,DA)) Q:'DA  D PRTALPH
 Q
 
SPCCODE ;SPECIMEN IN CODE ORDER
 ;SET LOCAL VARIABLES
 S FILE="1991019"
 S CURR=999                              ;CURR= INITIAL CODE
 F  S CURR=$O(^DIZ(FILE,"C",CURR)) Q:CURR=""  S DA=0  F  S DA=$O(^DIZ(FILE,"C",CURR,DA)) Q:'DA  D PRTCODE
                                         ;DO CODES 001-099 FIRST
 
 S CURR=99                               ;CURR= INITIAL CODE
 F  S CURR=$O(^DIZ(FILE,"C",CURR)) Q:(CURR<99)!(CURR="")  S DA=0  F  S DA=$O(^DIZ(FILE,"C",CURR,DA)) Q:'DA  D PRTCODE
                                         ;DO CODES 100-999 LAST
 Q
 
PRTALPH ;PRINT SUB-ROUTINE FOR ALPHABETICAL ORDER BY ORG NAME
 I LN+3>IOSL D HEADING W BORDER3,!,BORDER,!! S LN=LN+3         
                                         ;CHECK IF NEW PAGE NEEDED 
                                         ;WRITE PROPER BORDER
 W CURR,?32,$P(^DIZ(FILE,DA,0),U,2),! S LN=LN+1
                                         ;WRITE ALPHA, CODE
                                         ;INCREMENT LINE COUNT
 Q
 
PRTCODE ;PRINT SUB-ROUTINE FOR NUMERICAL ORDER BY CODE
 I LN+3>IOSL D HEADING W BORDER2,!,BORDER,!! S LN=LN+3
                                         ;CHECK IF NEW PAGE NEEDED 
                                         ;WRITE PROPER BORDER
 W CURR,?9,$P(^DIZ(FILE,DA,0),U,1),! S LN=LN+1
                                         ;WRITE CODE, ALPHA
                                         ;INCREMENT LINE COUNT
 Q
 
CONT ;ASK USER WHETHER TO CONTINUE WITH REPORT PRINT
 ;SET LOCAL VARIABLES
 S PG=0                                  ;INITIALIZE PAGE COUNTER
 S LN=0                                  ;INITIALIZE LINE COUNTER
 
 W !!!!!!!,"Do you want to print another"
 R " 'Code Print' report? N//",YN
                                         ;ASK USER WHETHER TO CONTINUE?
 
 I YN?1.3"?" W !!,"Answer with:  Y= Yes, N= No" G CONT
                                         ;USER WANTS HELP
 I (YN?1"Y")!(YN?1"y")!(YN?1"YES")!(YN?1"yes") G INPUT G CONT
 Q
 
KILL ;KILL LOCAL VARIABLES AND EXIT ROUTINE AZXRBUG8
 K PG,LN,TYPE,ORDER,BORDER,BORDER2,BORDER3
 K Y,RDATE,FILE,CURR,DA,YN
 Q
