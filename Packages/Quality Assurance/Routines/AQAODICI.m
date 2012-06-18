AQAODICI ; IHS/ORDC/LJF - INDICATOR MENU OPTIONS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains various entry points for simple data entry options
 ;which then call ^AQAODIC after setting up appropriate variables.
 ;
FUNC ;ENTRY POINT for option to describe key functions
 D FNCEDIT^AQAOHFNC ;display intro text
 S AQAODIC="^AQAO(1,",AQAODIC(0)="AEMZL",AQAODR="[AQAO FUNCTION EDIT]"
 D DIC^AQAODIC ;call dic/die driver
 D END Q
 ;
 ;
INDC ;ENTRY POINT for option to define indicators
 D INDEDIT^AQAOHIND ;display intro text
 S AQAODIC="^AQAO(2,",AQAODIC(0)="AEMZL",AQAODR="[AQAO IND EDIT-E1]"
 S AQAODIC("S")="D INDCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 D DIC^AQAODIC ;call dic/die driver
 D END Q
 ;
 ;
EXCP ;ENTRY POINT for option to define exceptions to criteria
 D EXCEDIT^AQAOHEX
 S AQAODIC="^AQAO1(2,",AQAODIC(0)="AEMZL",AQAODR="[AQAO EXCEPTION EDIT]"
 D DIC^AQAODIC ;call dic/die driver
 D END Q
 ;
 ;
INACT ;ENTRY POINT for option that activates inactive indicators
 D INACT^AQAOHIND
 S AQAODIC="^AQAO(2,",AQAODIC(0)="AEMZ",AQAODR="[AQAO INACTIVE EDIT]"
 S AQAODIC("S")="D INDCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 D DIC^AQAODIC ;call dic/die driver
 D END Q
 ;
 ;
END ; >>> eoj
 D KILL^AQAOUTIL Q
