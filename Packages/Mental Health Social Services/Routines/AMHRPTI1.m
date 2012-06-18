AMHRPTI1 ; IHS/CMI/LAB - cont. of amhrpti ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
BDRL ;EP - CALLED FROM AMHRPTI
 W:$D(IOF) @IOF
 W !,"*************** Behavioral Health Record List ****************"
 W !,"This report will produce either a detailed, or brief listing of Mental Health",!,"and Social Services visits.  The list of visits will be for a date range"
 W !,"specified by the user and visits can be selected based on any of the ",!,"following items:  Provider, Program, Provider Discipline, Problem Code,",!,"Activity Type, Type of Contact, Patient Age, Patient Sex, Patient Tribe"
 W !,"Patient Community, Community of Service, or Location of Encounter.",!,"The user can select any number of these screens.",!
 ;
 ;
 D DBHUSR^AMHUTIL
 ;
GENR ;EP - CALLED FROM AMHRPTI
 NEW X
 W:$D(IOF) @IOF
 S X="RECORD/ENCOUNTER GENERAL RETRIEVAL"
 W ?((80-$L(X))/2),X
 W !!!,"This report will produce a listing of visits in a date range selected by the",!,"user.  The visits printed can be selected based on any combination of items."
 W !,"The user will select these criteria.  The items printed on the report",!
 W "are also selected by the user.",!!,"Be sure to have a printer available that has 132-column print capability.",!!
 D DBHUSR^AMHUTIL
 Q
