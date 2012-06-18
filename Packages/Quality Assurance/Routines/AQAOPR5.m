AQAOPR5 ; IHS/ORDC/LJF - PRINT ACTIVE USERS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn prints a listing of active QAI users.  A user MUST be 
 ;entered into the QI USER file to obtain access to the QAI menu,
 ;even programmers.
 ;
LIST ;ENTRY POINT to print user listing  
 ;  called by option AQAO USER PRINT
 ;
 W @IOF W !!?20,"PRINT QI USERS LISTING",!! ;
 W !?10,"Use this option to print listing of users defined to this"
 W !?5,"QAI Mgt System.  You are given the choice of how you want to"
 W !?5,"sort the report.  Please refer to the User Manual if you"
 W !?5,"are not familiar with selecting your own sort criteria."
 W !!
 ;
 ;
PRINT ; >>> set print variables then call ^DIP
 S L="LIST QI USERS",DIC="^AQAO(9,",FLDS="[AQAO ACTIVE USERS]"
 S DIASKHD="" D EN1^DIP
 ;
 ;
END ; >>> eoj
 D KILL^AQAOUTIL Q
