AQAOUT ; IHS/ORDC/LJF - UTILITIES FOR QAI PKG ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains various entry points for identifiers and output
 ;transforms on data fields.
 ;
 Q
CRIT ;ENTRY POINT for output transform on name field in
 ;    qi occ criteria file; code too long (>255 characters)
 N AQAOX,AQAOK
 S AQAOX=^AQAOCC(5,AQAOXX,0)
 I $P(AQAOX,U,5)'="" D  G Q
 .W ?65," >>"_$S($P(AQAOX,U,5)=1:"YES",$P(AQAOX,U,5)=0:"NO",1:"N/A")
 .W "<<"
 I $P(AQAOX,U,6)'="",$D(^AQAO1(4,$P(AQAOX,U,6),0)) D  G Q
 .W ?65," >>"_$P(^AQAO1(4,$P(AQAOX,U,6),0),U)_"<<"
 S AQAOK=$P(AQAOX,U,8)
 I AQAOK]"" D  G Q
 .W ?65," >>",$E(AQAOK,4,5),"/",$E(AQAOK,6,7),"/",$E(AQAOK,2,3),"<<"
 I $P(AQAOX,U,7)'="" W ?65," >>",$P(AQAOX,U,7),"<<"
 ;
Q ;quit
 Q
 ;
 ;
DRUG ;ENTRY POINT for identifier on drug in data entry
 ;
 N Y,C
 S Y=$P(^AQAOCC(6,AQAOXX,0),U,5)
 S C=$P(^DD(9002166.6,.05,0),U,2)
 D Y^DIQ W:Y]"" "   >>",Y,"<<"
 Q
 ;
 ;
PROV ;ENTRY POINT to print identifiers on qi occ provider entries
 N X,Y
 S X=$$VALI^XBDIQ1(9002166.7,AQAOXX,.01) Q:X=""
 I X["AUTTVNDR" D  Q  ;vendor
 . S Z=$$VAL^XBDIQ1(9999999.11,+X,1103.01)
 . S Y=$$VALI^XBDIQ1(9999999.11,+X,1103)
 . I Z]"" W "  CHS ",Z
 . E  I Y]"" W "  CHS ",$$VAL^XBDIQ1(9999999.34,Y,.02)
 . D LEVEL
 ;
 I $D(^XUSEC("PROVIDER",+X)) D  Q  ;provider
 . W "  ",$$VAL^XBDIQ1(200,+X,9999999.01)," " ;affiliation
 . W $$VAL^XBDIQ1(200,+X,53.5) ;class
 . D LEVEL
 ;
 W "  ",$$VAL^XBDIQ1(200,+X,8) ;title for person
 Q
 ;
 ;
LEVEL ; -- SUBRTN to print prov/vendor/person type & level
 W "  [",$$VALI^XBDIQ1(9002166.7,AQAOXX,.05) ;prov type
 W "/",$$VAL^XBDIQ1(9002166.7,AQAOXX,.07),"]" ;perf level
 I $$VALI^XBDIQ1(9002166.7,AQAOXX,.06) W "*" ;flagged with action
 Q
