AQAOHPRV ; IHS/ORDC/LJF - HELP TEXT FOR PROVIDER REPORTS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for introductory text on options
 ;for provider code reports found on the Pkg Admin Menu.
 ;
CODELST ;ENTRY POINT for intro help text on option to print prov codes
 ;called by entry action of option AQAO PKGLIST PROVIDER
 W @IOF,!!?20,"PROVIDER QI CODES LISTING by CLASS",!!
 W !!?5,"Use this option to print lists of provider names with their"
 W !?5,"cooresponding QI code numbers.  The report sorts by provider"
 W !?5,"class, e.g. PEDIATRICIAN or REGISTERED NURSE.  This listing"
 W !?5,"also includes the providers' PCC code as an additional check."
 W !! Q
 ;
BYCLASS ;ENTRY POINT for intro help text on option to print prov codes
 ;called by entry action of option AQAO PKGLIST PROVIDER
 W @IOF,!!?15,"PROVIDER QI CODES LISTING by CLASS or TYPE",!!
 W !!?5,"Use this option to print lists of provider names with their"
 W !?5,"corresponding QI code numbers. You are asked to select IHS"
 W !?5,"providers or CHS providers. IHS providers are listed by class"
 W !?5,"(PEDIATRICIAN or REGISTERED NURSE). CHS providers are listed"
 W !?5,"by CHS provider type (HOSPITAL GM&S or LABORATORY).",!
 W !! Q
 ;
 ;
BYNUM ;ENTRY POINT for intro help text on option to print prov codes
 ;called by entry action of option AQAO PKGLIST PROV BY NUMBER
 W @IOF,!!?20,"PROVIDER QI CODES LISTING by NUMBER",!!
 W !!?5,"Use this option to print lists of provider names with their"
 W !?5,"corresponding QI code numbers.  The report sorts by provider"
 W !?5,"code number and displays the provider's PCC code as an"
 W !?5,"additional check."
 W !! Q
 ;
 ;
BYNUM2 ;EP; intro text on option to print qi codes by number;ENHANCE #1
 ;called by ^AQAOPV22
 W @IOF,!!?20,"QI CODES LISTING by NUMBER",!!
 W !!?5,"Use this option to print lists of IHS and CHS providers and"
 W !?5,"IHS employees in order by their QI code number. CHS providers"
 W !?5,"list first followed by all IHS entries. This listing screens"
 W !?5,"out any inactive entries. Use the 'Lookup INDIVIDUAL QI Codes'"
 W !?5,"option to view the QI code for an inactive entry."
 W !! Q
 ;
 ;
SINGLE ;ENTRY POINT for intro text  for single provider code lookup
 ;called by rtn ^AQAOPV2
 W @IOF,!!?20,"LOOKUP INDIVIDUAL PROVIDER CODES",!!
 W !!?5,"Use this option to look up QI PROVIDER CODES for individual"
 W !?5,"providers.  You may ask for as many as you want.  To print a"
 W !?5,"list by provider class, use the 'List PROVIDER CODES by Class'"
 W !?5,"option.",!!
 Q
 ;
 ;
LOOKUP ;ENTRY POINT for intro text for lookup qi codes option;ENHANCE #1
 ;called by rtn ^AQAOPV21
 W @IOF,!!?20,"LOOKUP INDIVIDUAL QI CODES",!!
 W !!?5,"Use this option to look up QI CODES for individual IHS OR CHS"
 W !?5,"providers or IHS employees. You can look them up by name or by"
 W !?5,"QI code depending on what you have available. To print a list"
 W !?5,"of all entries use the 'List QI Codes BY NUMBER' option. For "
 W !?5,"IHS providers by class or CHS providers by type use the 'List"
 W !?5,"PROVIDER CODES by Class' option.",!!
 Q
