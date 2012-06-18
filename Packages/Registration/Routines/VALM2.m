VALM2 ;ALB/MJK - List Manager Utilities;08:52 PM  17 Jan 1993
 ;;1;List Manager;;Aug 13, 1993
 ;
SEL ; -- select w/XQORNOD(0) defined
 D EN(XQORNOD(0)) Q
 ;
EN(VALMNOD,VALMDIR) ; -- generic selector
 ; input passed: VALMNOD := var in XQORNOD(0) format
 K VALMY
 I '$D(VALMDIR) N VALMDIR S VALMDIR=""
 S BG=+$O(@VALMAR@("IDX",VALMBG,0))
 S LST=+$O(@VALMAR@("IDX",VALMLST,0))
 I BG,BG=LST,$P($P(VALMNOD,U,4),"=",2)="",VALMDIR'["O" S VALMY(BG)="" G ENQ ; -- only one entry
 I 'BG W !!,*7,"There are no '",VALM("ENTITY"),"s' to select.",! S DIR(0)="E" D ^DIR K DIR D OUT G ENQ
 S Y=$$PARSE(.VALMNOD,.BG,.LST)
 I 'Y S DIR(0)=$S(VALMDIR'["S":"L",1:"N")_$S(VALMDIR["O":"O",1:"")_"^"_BG_":"_LST,DIR("A")="Select "_VALM("ENTITY")_$S(VALMDIR["S":"",1:"(s)") D ^DIR K DIR I $D(DIRUT) D OUT G ENQ
 ;
 ; -- check was valid entries
 S VALMERR=0
 F I=1:1 S X=$P(Y,",",I) Q:'X  D
 .I '$O(@VALMAR@("IDX",X,0))!(X<BG)!(X>LST) D
 ..W !,*7,">>> Selection '",X,"' is not a valid choice."
 ..S VALMERR=1
 I VALMERR D PAUSE^VALM1 G ENQ
 ;
 F I=1:1 S X=$P(Y,",",I) Q:'X  S VALMY(X)=""
ENQ K Y,X,BG,VALMERR,LST,DIRUT,DTOUT,DUOUT,DIROUT Q
 ;
PARSE(VALMNOD,BEG,END) ; -- split out pre-answers from user
 N Y,J,L,X
 S Y=$TR($P($P(VALMNOD,U,4),"=",2),"/\; .",",,,,,")
 I Y["-" S X=Y,Y="" F I=1:1 S J=$P(X,",",I) Q:J']""  I +J>(BEG-1),+J<(END+1) S:J'["-" Y=Y_J_"," I J["-",+J,+J<+$P(J,"-",2) F L=+J:1:+$P(J,"-",2) I L>(BEG-1),L<(END+1) S Y=Y_L_","
 Q Y
 ;
OUT ; -- set variables to quit
 S VALMBCK=$S(VALMCC:"",1:"R")
 Q
 ;
MENU ; -- entry point for 'turn' protocol
 N VALMX
 S VALMX=$G(^DISV($S($D(DUZ)#2:DUZ,1:0),"VALMMENU",VALM("PROTOCOL"))) S:VALMX="" (VALMX,^(VALM("PROTOCOL")))=1
 W ! S DIR(0)="Y",DIR("A")="Do you wish to turn auto-display "_$S(VALMX:"'OFF'",1:"'ON'")_" for this menu",DIR("B")="NO" D ^DIR K DIR
 I Y S (VALMMENU,^DISV($S($D(DUZ)#2:DUZ,1:0),"VALMMENU",VALM("PROTOCOL")))='VALMX
 D FINISH^VALM4
 Q
 ;
HELP ; -- help entry point
 N VALMANS,VALMHLP
 S VALMANS=X N X ; save answer
 S VALMHLP=$G(^TMP("VALM DATA",$J,VALMEVL,"HLP")),X=VALMANS
 I VALMHLP]"" X VALMHLP
 I VALMHLP="",VALM("TYPE")=2 S VALMANS="??"
 I VALMHLP="",VALM("TYPE")'=2 S X="?" D DISP^XQORM1,PAUSE^VALM1
 I $P($G(VALMKEY),U,2)]"",VALMANS["??" D FULL^VALM1,KEYS,PAUSE^VALM1 S VALMBCK="R"
 D:$G(VALMBCK)="R" REFRESH^VALM K VALMBCK
 D:VALMCC RESET^VALM4
 D SHOW^VALM W !
 Q
 ;
KEYS ; -- hidden key help
 W !,"The following actions are also available:"
 N XQORM,ORULT S XQORM=$O(^ORD(101,"B",$P(VALMKEY,U,2),0))_";ORD(101,"
 I '$D(^XUTL("XQORM",XQORM)) D XREF^XQORM K ORULT ; build ^XUTL nodes
 D DISP^XQORM1:XQORM
 Q
