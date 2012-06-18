APCDEFL ; IHS/CMI/LAB - EDIT VISIT LIST TEMP ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;; ;
 ; -- PUBLIC ENTRY POINT to edit visit
 ; -- calling routine must pass visit ien in APCDVSIT
 ; -- calling routine responsible for killing APCDVSIT
 ; -- calling routine responsible for killing APCD vars - D ^APCDEKL
 ;
EN ;PEP -- main entry point for APCDEF VISIT DISPLAY
 NEW DFN,APCDPARM,APCDOVRR
 K ^TMP("APCDEFG",$J)
 Q:'$G(APCDVSIT)
 D EP^APCDEFG(APCDVSIT)
 S DFN=$$VALI^XBDIQ1(9000010,APCDVSIT,.05)
 S Y=DFN D ^AUPNPAT ; pcc needs the AUPN variables set
 I '$D(^APCDSITE(DUZ(2),0)) W !!,"The DATA ENTRY Site Parameters have not been",!,"established for this facility.  PLEASE NOTIFY YOUR SUPERVISOR!",$C(7),$C(7) D DEFAULT^APCDVAR Q
 D ^APCDEIN
 D EN^VALM("APCDEF VISIT DISPLAY")
 D CLEAR^VALM1
 K ^TMP("APCDEFG",$J),APCDBROW,APCDOVRR
 Q
 ;
EN1 ;EP - called from input templates
 D EN^XBNEW("EN^APCDEFL","APCDVSIT")
 K Y
 Q
HDR ; -- header code
 ;S VALMHDR(1)="This is a test header for APCD VISIT DISPLAY."
 ;S VALMHDR(2)="This is the second line"
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=$O(^TMP("APCDEFG",$J,"IDX"),-1)
 S VALMSG="-  Prev Screen     Q  Quit     ?? for More Actions"
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K AUPNVSIT,APCDNUM,VALMCNT,VALMSG
 Q
 ;
EXPND ; -- expand code
 Q
 ;
GETITEM ; -- select item from list
 K APCDDR
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !!,"No item selected!" Q
 S APCDDR=$O(VALMY(0))
 D CLEAR^VALM1,FULL^VALM1
 Q
RESET ;
 K ^TMP("APCDEFG",$J)
 S VALMBCK="R" D EP^APCDEFG(APCDVSIT) D INIT Q
 ;
PAUSE ;
 N DIR S DIR(0)="E",DIR("A")="Press ENTER to continue" D ^DIR Q
 ;
EDIT ;EP; called by edit/delete action
 NEW APCDDR,APCDMNE,APCDPAT,APCDCAT,APCDTYPE,APCDLOC,APCDVLK,APCDDATE,APCDMODE,APCDCLN,APCDOVRR
 D GETITEM I '$D(APCDDR) S VALMBCK="R" W !!,$C(7),$C(7),"That is not an editable item, please see your supervisor for assistance.",! H 3 D INIT Q
 S APCDDR=$G(^TMP("APCDEFG",$J,"MNE",APCDDR))
 I '$G(APCDDR) S VALMBCK="R" W !!,$C(7),$C(7),"That is not an editable item, please see your supervisor for assistance.",! H 3 D INIT Q
 S APCDMNE=APCDDR,APCDMNE("NAME")=$P(^APCDTKW(APCDDR,0),U)
 S APCDMODE="M",APCDVLK=APCDVSIT D VINIT(APCDMNE)
 D ^APCDEA3
 D RESET Q
 ;
ADD(M,APCDVSIT) ;EP; called by actions to add v file entries
 NEW APCDMNE,APCDPAT,APCDCAT,APCDTYPE,APCDLOC,APCDVLK,APCDDATE,APCDMODE
 D CLEAR^VALM1,FULL^VALM1
 S APCDMNE=$O(^APCDTKW("B",M,0)) Q:APCDMNE=""
 W !!,"Adding ",$P(^APCDTKW(APCDMNE,0),U,12),!!
 S APCDMODE="A" D VINIT(APCDMNE)
 D ^APCDEA3
 D RESET Q
 ;
ADD2(F,APCDVSIT) ;EP; called by actions where type has to be selected
 NEW APCDMNE,APCDPAT,APCDCAT,APCDMODE,APCDTYPE,APCDLOC,APCDVLK,DIC,APCDDATE,APCDMODE
 D CLEAR^VALM1,FULL^VALM1
 W !!,"Adding ",$P(^DIC(F,0),U),!
 S Y=1 F  Q:Y<1  D
 . S DIC=F,DIC(0)="MQZ",X="??" D ^DIC
 . S DIC(0)="AEMQZ" D ^DIC Q:Y<1
 . S APCDMNE=$O(^APCDTKW("B",$P(Y,U,2),0)) Q:APCDMNE=""
 . S APCDMODE="A" D VINIT(APCDMNE),^APCDEA3 S Y=1
 D RESET Q
 ;
VINIT(M) ; -- initialize visit variables; M=mnemonic
 NEW APCDX
 D ENP^XBDIQ1(9000010,APCDVSIT,".01;.03;.05:.07;.08","APCDX(","I")
 S APCDDATE=APCDX(.01,"I"),APCDPAT=APCDX(.05,"I")
 S APCDTYPE=APCDX(.03,"I"),APCDVLK=APCDVSIT
 S APCDCAT=APCDX(.07,"I"),APCDLOC=APCDX(.06,"I"),APCDCLN=APCDX(.08,"I")
 S APCDOVRR="" ;need this for provider narrative lookup
 Q
 ;
 ;
MNE ;EP - called from protocol entry
 D FULL^VALM1
 S APCDPAT=DFN
 D EN^APCDEL
 D RESET
 Q
VSIT ;;
VPOV ;;
