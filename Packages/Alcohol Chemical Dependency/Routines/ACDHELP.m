ACDHELP ;IHS/ADC/EDE/KML - HELP TEXT FOR VARIOUS FIELDS; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
RCPL ;EP
 N X
 D HELP^XBHELP("RCPL12","ACDHELP",0)
 D EOM
 Q
RCPL12 ; help text for field 12 of file 9002171
 ;;Average 1.0 - 1.9:  DETOX,PRT
 ;;Average 2.0 - 3.4:  PRT,FGH,INOPT
 ;;Average 3.5 - 4.3:  FGH,HWH,TLC,INOPT
 ;;Average 4.4 - 5.4:  OPT,GH,HWH,TLC
 ;;Average 5.5 - 6.0:  HWH/TLC,OPT,AFT,GH
 ;;###
 Q
STATUS ;EP
 N X
 D HELP^XBHELP("STAT26","ACDHELP",0)
 D EOM
 Q
STAT26 ; help text for field 26 of file 9002171
 ;;Early Full Remission - This specifier is used if, for at least
 ;;1 month, but less than 12 months, no criteria for Dependence or
 ;;Abuse have been met (but the full criteria for Dependence have 
 ;;not been met).
 ;;
 ;;Sustained Full Remission - This specifier is used if none of the
 ;;criteria for Dependence or Abuse have been met at any time during
 ;;a period of 12 months or longer.
 ;;
 ;;Sustained Partial Remission - This specifier is used if full 
 ;;criteria for Dependence have not been met for a period of 12 
 ;;months or longer, however, one or more criteria for Dependence
 ;;or Abuse have been met.
 ;;###
 Q
EOM ;
 S DIR(0)="EO",DIR("A")="Hit Return to continue" D ^DIR K DIR
 Q
