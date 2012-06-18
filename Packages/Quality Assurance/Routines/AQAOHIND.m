AQAOHIND ; IHS/ORDC/LJF - HELP TEXT FOR INDICATORS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for introductory text on options
 ;and help text on data fields for inidicator data entry.
 ;
INDEDIT ;ENTRY POINT >> intro text for indicators entry/edit
 W @IOF,!!?30,"CLINICAL INDICATORS"
 W !!?5,"Use this option to document your CLINICAL INDICATORS linked"
 W !?5,"to Key Functions or Goals.  To secure proper access to your"
 W !?5,"indicator and any occurrences, you must also link these"
 W !?5,"indicators to a QI MONITORING TEAM made up of all the QI"
 W !?5,"teams involved.",!
 Q
 ;
CODE ;ENTRY POINT >> help text for code # field; called by execute help
 W !!?5,"The indicator code number is made up of a prefix of 3 LETTERS"
 W !?5,"and/or NUMBERS followed by 4 NUMBERS, such as ICU0013 or"
 W !?5,"3EA0057.  The QAI package administrator has access to the"
 W !?5,"QI PREFIX file which contains the agreed upon prefixes and"
 W !?5,"their uses.  Grouping by a service or QI team abbreviation"
 W !?5,"is helpful.  All code numbers beginning with 'J' are reserved"
 W !?5,"for JCAHO indicators.  All code numbers beginning with 'IH' are"
 W !?5,"reserved for IHS indicators.  Code numbers in the IH1 series "
 W !?5,"were used by version 1 of the IHS QA/UR System.  See the User"
 W !?5,"Manual for more information.  For a list of defined prefixes on"
 W !?5,"your system, use the option titled DISPLAY INDICATOR PREFIXES."
 W ! Q
 ;
NAME ;ENTRY POINT >> help text for name field; called by execute help
 W !!?5,"This is a short title (up to 30 characters long) for the"
 W !,"CLINICAL INDICATOR.  A DESCRIPTION word-processing field follows"
 W !,"to expand the meaning of the indicator.",!
 Q
 ;
TYPE ;ENTRY POINT >> help text for type or threshold fields; xecutable help
 W !!?5,"For those indicators that are labeled RATE-BASED, a THRESHOLD"
 W !,"will be requested.  Please remember that a Desirable Trend"
 W !,"Indicator will have a HIGH Threshold number (for example, 95%)"
 W !,"and an Undesirable Trend Indicator should have a LOW number,"
 W !,"(such as 5%).  For the THRESHOLD field, just enter the number; "
 W !,"the computer will add the '%' to the end.",!
 Q
ACTIVE ;ENTRY POINT >> help text for active/inactive field; xecutable help
 W !!?5,"To be used by the QI Management System, an indicator must"
 W !,"be ACTIVE.  When no longer used, indicators CANNOT be DELETED."
 W !,"They must be INACTIVATED.  When inactivating an indicator, you"
 W !,"will also be asked for the INACTIVATION DATE and for a REASON."
 W ! Q
 ;
REASON ;ENTRY POINT >> help text 4 inactivation reason field; xecutable help
 W !!?5,"Enter a SHORT EXPLANATION (up to 30 characters) of why this"
 W !,"indicator is now inactive, such as 'No Longer Needed', or"
 W !,"'No Longer Applies', or 'Superseded by ICU024'.",!
 Q
 ;
METHOD ;ENTRY POINT >> help text for methodology field
 ;called by input template [AQAO IND EDIT
 W !!?30,"METHODOLOGY"
 W !,"How do you plan to COLLECT and ORGANIZE the data to evaluate"
 W " this indicator? "
 W !,"Please include     1.  Data sources"
 W !,"                   2.  Sampling strategies"
 W !,"                   3.  Frequency of data collection"
 W !,"                   4.  Any coordination required across departments/services"
 W !,"                   5.  How reliability of data collected is determined"
 W !,"                   6.  Process for comparing data with threshold"
 W !?5,"HINT:  To have each line you enter print on a separate line,"
 W !?12,"begin each line with a space.",!
 Q
 ;
QITEAM ;ENTRY POINT >> help text for qi monitoring team; xecutable help
 W !!?5,"Enter all the QI TEAMS involved with this indicator"
 W !,"that make up a Monitoring Team.  The last one entered will"
 W !,"appear as the default value.  Those listed above will be the"
 W !,"QI Teams already chosen.  Below is a listing of all the QI teams"
 W !,"from which you can choose.",!
 Q
 ;
 ;
INACT ;ENTRY POINT for intro text on option AQAO INACTIVE EDIT
 W @IOF,!?20,"ACTIVATE/INACTIVATE Clinical Indicator",!
 W !?5,"Use this option to activate an inactive indicator or to "
 W !?5,"modify an inactive one.  When activating an indicator,"
 W !?5,"please delete the inactivation date and reason.",!
 Q
 ;
 ;
PREFIX ;ENTRY POINT for intro text on option AQAO PREFIX LIST
 ;called by entry action
 W @IOF,!?20,"DISPLAY INDICATOR PREFIXES",!!
 W !?5,"Use this option to see a listing of 3-character prefixes that"
 W !?5,"can be used to create indicator code numbers.  If you need to"
 W !?5,"add a new prefix, see the QAI package administrator.  Using an"
 W !?5,"agreed upon list of prefixes helps to group similar indicators."
 W !?5,"To print the list, enter your printer name or HOME (to print to"
 W !?5,"your terminal screen) at the DEVICE prompt.  Then enter 80 at"
 W !?5,"the RIGHT MARGIN prompt, if it appears.",!!
 Q
