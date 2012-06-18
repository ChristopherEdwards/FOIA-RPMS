AQAOUSP ; IHS/ORDC/LJF - PRINT USER PROFILE (KEYS) ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains an entry point for the user interface and DIP call
 ;to print a user's QAI access profile.  It also contains an entry
 ;point called by the print template to list the security keys
 ;assigned to the user.
 ;
KEYS ;ENTRY POINT to print security key portion of qi user profile
 ;called by print template [AQAO USER PROFILE]
 W !!,"SECURITY KEYS:"
 S AQAOX="AQAO"
 F  S AQAOX=$O(^DIC(19.1,"B",AQAOX)) Q:AQAOX=""  Q:$E(AQAOX,1,4)'="AQAO"  D
 .S AQAOY=$O(^DIC(19.1,"B",AQAOX,0)) Q:AQAOY=""
 .I $D(^XUSEC(AQAOX,AQAOUSR)) D  Q  ; if user has key
 ..W !,AQAOX,": ",$E(^DIC(19.1,AQAOY,1,1,0),1,47) ;key & descript
 ..Q:'$D(AQAOARR)  Q:$D(AQAOARR(AQAOX))  ;okay to keep key
 ..W ?60,"REMOVE KEY FROM USER"
 .E  D  ;else user doesn't have key
 ..Q:'$D(AQAOARR(AQAOX))  ;don't assign key
 ..W !,AQAOX,": ",$E(^DIC(19.1,AQAOY,1,1,0),1,47) ;key&descript
 ..W ?60,"ASSIGN KEY TO USER"
 ;
 F AQAOX="AMQQZMENU","ATSZMENU" D
 .S AQAOY=$O(^DIC(19.1,"B",AQAOX,0)) Q:AQAOY=""  I $D(^XUSEC(AQAOX,AQAOUSR)) D  Q  ;if user has key
 ..W !,AQAOX,": ",$E(^DIC(19.1,AQAOY,1,1,0),1,47) ;key & descript
 ..Q:'$D(AQAOARR)  Q:$D(AQAOARR(AQAOX))  ;okay to keep key
 ..W ?60,"REMOVE KEY FROM USER"
 .E  D  ;else user doesn't have key
 ..Q:'$D(AQAOARR(AQAOX))  ;don't assign key
 ..W !,AQAOX,": ",$E(^DIC(19.1,AQAOY,1,1,0),1,47) ;key&descript
 ..W ?60,"ASSIGN KEY TO USER"
 W !
 K AQAOX,AQAOY Q
 ;
 ;
DISPLAY ;ENTRY POINT to print user profile from menu
 ;called by option AQAO USER DISPLAY
 D DISPLAY^AQAOHUSR ;intro text
NAME ; >>> ask for user name
 W ! K DIC S DIC="^AQAO(9,",DIC(0)="AEMZQ"
 S DIC("A")="Select QI USER NAME:  "
 D ^DIC G END:$D(DTOUT),END:$D(DUOUT),END:X="",NAME:Y=-1
 S AQAOUSR=+Y ;user ifn
 ;
PRINT ; >>> set variables and call dip
 W !!,"Enter PRINTER NAME or 'HOME' to print to your screen"
 S DIC="^AQAO(9,",L=0,FLDS="[AQAO USER PROFILE]",(TO,FR)=AQAOUSR
 S BY="@NUMBER" D EN1^DIP ;print profile
 ;
END ; >>> eoj
 D KILL^AQAOUTIL Q
