AQAOHOCC ; IHS/ORDC/LJF - HELP TEXT FOR OCCURRENCES ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for introductory text on options
 ;and help text on data fields for occurrence data entry.
 ;
INTRO ;ENTRY POINT to print intro text to occurrence data entry
 ;  called by entry action for option AQAO PRIMARY REVIEW
 W @IOF,!!?20,"ENTER/EDIT OCCURRENCE RECORD",!!
 W !?5,"Use this option to ADD NEW OCCURRENCES, to EDIT AN OPEN"
 W !?5,"OCCURRENCE you have already entered, or to CREATE occurrences"
 W !?5,"from a VISIT file SEARCH TEMPLATE.  For an new entry, you are"
 W !?5,"asked to enter the patient's name, occurrence date, and the"
 W !?5,"indicator linked to this occurrence.  Other BASIC DATA ITEMS "
 W !?5,"include the patient's visit date, a case summary, diagnosis, "
 W !?5,"procedures, providers, and review criteria.  Enter ONLY what is"
 W !?5,"useful for your review.  Once basic data has been entered, you"
 W !?5,"can enter the INITIAL REVIEW of this occurrence.  This is the"
 W !?5,"clinical review or the first peer review.  For all subsequent"
 W !?5,"reviews, choose the 'Enter/Edit Occurrence REVIEWS' option."
 W !! Q
 ;
 ;
VISIT ;ENTRY POINT for visit field help text; called by xecute help
 W !!,"Enter the VISIT DATE related to this occurrence.  For an "
 W !,"inpatient stay, enter the ADMISSION DATE.  If unknown, you can"
 W !,"just hit <return> BUT the occurrence will not be linked to PCC.",!
 Q
 ;
 ;
CSUM ;ENTRY POINT for case summary field; called by xecute help
 W !!,"Enter a SUMMARY of this occurrence case.  You can be as BRIEF"
 W !,"or as DETAILED as your needs require.  Remember, this is for"
 W !,"information only; you cannot search on data in this summary."
 W ! Q
 ;
 ;
REVR ;ENTRY POINT for initial reviewer field; called by xecute help
 W !!,"Enter the person who PERFORMED this review.  The person CANNOT"
 W !,"be listed as a provider for this occurrence."
 W !! Q
 ;
 ;
EXC ;ENTRY POINT for exception field; called by xecute help
 W !!,"If this occurrence does NOT need to be reviewed based on"
 W !,"DEFINED CRITERIA, please enter the exception here.  This"
 W !,"will be used most often for occurrences automatically entered"
 W !,"by the computer, such as Readmissions with an exception perhaps"
 W !,"of 'Scheduled Readmission'.  Be sure to enter the appropriate"
 W !,"finding, such as 'Exception to Criteria'."
 W ! Q
 ;
 ;
STAGES ;ENTRY POINT for intro text on option List Review Stages
 ;called by entry action of AQAO 
 W @IOF,!!?20,"DESCRIPTIONS OF EACH REVIEW STAGE",!!
 W !!?5,"Use this option to familiarize yourself with the various"
 W !?5,"Review Stages in the Occurrence Review Process.  This report"
 W !?5,"list each stage and give you a brief definition of the stage."
 W !! Q
 ;
 ;
RISK ;ENTRY POINT for help text on Risk of Adverse Outcome fields
 ;  called by xecute help
 W !!?5,"This is the expected RISK LEVEL of the activity associated"
 W !?5,"with this occurrence.  The levels as defined by your facility"
 W !?5,"are as follows:",!
 N X,Y S X=0 F  S X=$O(^AQAO1(3,X)) Q:X'=+X  D
 .Q:'$D(^AQAO1(3,X,0))  S Y=^(0)
 .W !?5,$P(Y,U),?15,$P(Y,U,2)
 W !! Q
 ;
 ;
OUTCOME ;ENTRY POINT for help text on occ outcome fields
 ;called by xecute help
 W !!?5,"This is the actual SEVERITY LEVEL associated with this"
 W !?5,"occurrence.  The levels as defined by your facility are as"
 W !?5,"follows:",!
 N X,Y S X=0 F  S X=$O(^AQAO1(3,X)) Q:X'=+X  D
 .Q:'$D(^AQAO1(3,X,0))  S Y=^(0)
 .W !?5,$P(Y,U),?15,$P(Y,U,4)
 W !! Q
 ;
 ;
ULTIMATE ;ENTRY POINT for help text on ultimate outcome level fields
 ;  called by xecute help
 W !!?5,"This is the patient's ULTIMATE OUTCOME, which may or may not"
 W !?5,"have been affected by this occurrence.  The levels as defined"
 W !?5,"by your facility are as follows:",!
 N X,Y S X=0 F  S X=$O(^AQAO1(3,X)) Q:X'=+X  D
 .Q:'$D(^AQAO1(3,X,0))  S Y=^(0)
 .W !?5,$P(Y,U),?15,$P(Y,U,5)
 W !! Q
 ;
 ;
PRVLVL ;ENTRY POINT for help text on provider's performance level
 ;  called by xecute help
 W !!?5,"Please enter this provider's PERFORMANCE LEVEL for this"
 W !?5,"occurrence.  The levels as defined by your facility are as"
 W !?5,"follows:",!
 N X,Y S X=0 F  S X=$O(^AQAO1(3,X)) Q:X'=+X  D
 .Q:'$D(^AQAO1(3,X,0))  S Y=^(0)
 .W !?5,$P(Y,U),?15,$P(Y,U,6)
 W !! Q
 ;
 ;
VHELP ;EP; visit help called by DIR("?") in AQAOENTR
 ;lists up to the last 15 visits for a patient
 N AQAOARV,AQAO9DT,AQAOCNT,Y
 S (AQAOCNT,AQAO9DT)=0
 F  S AQAO9DT=$O(^AUPNVSIT("AA",AQAOPAT,AQAO9DT)) Q:AQAO9DT=""  Q:AQAOCNT=15  D
 .S Y=9999999-$P(AQAO9DT,".") X ^DD("DD")
 .S AQAOCNT=AQAOCNT+1,AQAOARV(AQAOCNT)=Y
 W !!,"Please type in the VISIT DATE that corresponds to this occurrence."
 W !,"Here is a list of this patient's last ",AQAOCNT," visits:"
 W "  (15 maximum)",!
 S Y=0 F  S Y=$O(AQAOARV(Y)) Q:Y=""  W !?5,AQAOARV(Y)
 Q
