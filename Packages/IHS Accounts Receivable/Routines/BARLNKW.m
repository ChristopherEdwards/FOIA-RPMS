BARLNKW ; IHS/SD/LSL - THE WALKER ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
 ;
W ;
WALK ;Given BARFN add the fields and then walk the join multiples
 N BARF0,BARF2,BARFDL,BARLNK
 W !,"PROCESSING ",$P(BARPATH,":",2,99)," ",BARFN,"   ",$P(^DIC(BARFN,0),U)
 W !,"adding this files fields to the target's items"
 I '$D(^BARDD(90055.5,BARFN,1)) W *7,!!,"NO FIELDS",!! Q
 K ^TMP($J,"FLD")
 D ENPM^XBDIQ1(90055.51,"BARFN,0",".01:99","^TMP($J,""FLD"",")
 K DR,DA,DIE,DIC
 S DIC=$$DIC^XBDIQ1(90056.3)
 S DIC(0)="LX"
 I '$D(^BARRGIT(XBSRCFL,0)) S ^BARRGIT(XBSRCFL,0)="A/R ITEMS (RGEN)^90056.3I^^0"
 D DICDR
 S DIC("DR")=BARDICDR
 S BARFLD=0
 F  S BARFLD=$O(^TMP($J,"FLD",BARFLD)) Q:BARFLD'>0  D
 . S:BARPATH="" BARX1=BARFLD
 . S:BARPATH]"" BARX1=$P(BARPATH,":",2,99)_":"_BARFLD
 . S BARXNM=^TMP($J,"FLD",BARFLD,.015)
 . S BARFLDC=BARXNM_" |"_$$SHRTNM($O(^DD(BARFN,0,"NM","")))
 . S BARSFLNM=$$SHRTNM($O(^DD(BARFN,0,"NM","")))
 . S $P(BARFLPTH,":",BARLEV)=BARSFLNM,BARFLPTH=$P(BARFLPTH,":",1,BARLEV)
 . S BARFLPTH=BARFLPTH_":"_$$SHRTNM(BARXNM)
 . S BARBRF=$P(BARFLPTH,":",2,BARLEV+1)
 . W !,?(BARLEV*3),BARX1,!,?(BARLEV*3),BARFLDC,!,?(BARLEV*3),BARFLPTH,!
 . S X=BARFLDC
 . I $D(^BARRGIT(XBSRCFL,"AC",BARX1)) D  Q  ; if the item exists
 .. S DA=$O(^BARRGIT(XBSRCFL,"AC",BARX1,0))
 .. S BARDIEDR=".01///^S X=BARFLDC;"_BARDICDR
 .. S DIE=$$DIC^XBDIQ1(90056.3)
 .. S DR=BARDIEDR
 .. D ^DIE
 . K DO,DD
 . D FILE^DICN
 K ^TMP($J,"FLD")
 ; walk/process the join link files
 S DIC=$$DIC^XBDIQ1(90055.51)
 S DIC("S")="I $P(^(0),U,3)[""J"""
 K ^TMP("BARLNK",$J,BARLEV)
 D ENPM^XBDIQ1(.DIC,"BARFN,0",".01:.05","^TMP(""BARLNK"",$J,BARLEV,","I")
 S BARFDL=0
 F  S BARFDL=$O(^TMP("BARLNK",$J,BARLEV,BARFDL)) Q:BARFDL'>0  D
 . S BARF0=BARFN
 . S BARF2=^TMP("BARLNK",$J,BARLEV,BARFDL,.02,"I")
 . S BARFN=BARF2
 . S BARFDLL(BARLEV)=BARFDL
 . S BARLEV=BARLEV+1
 . S $P(BARPATH,":",BARLEV)=BARFDL
 . S BARPATH=$P(BARPATH,":",1,BARLEV)
 . D WALK ;recursion for walking join multiples
 . S BARFN=BARF0
 . S BARLEV=BARLEV-1
 . S BARFDL=BARFDLL(BARLEV)
 . S BARPATH=$P(BARPATH,":",1,BARLEV)
 Q
 ; *********************************************************************
 ;
DICDR ;build BARDICDR for stuffing fields into items
DR ;;
 ;;.02////^S X=BARFLD;
 ;;.03////^S X=BARFN;
 ;;.04////^S X=^TMP($J,"FLD",BARFLD,.03);
 ;;.05////^S X=BARX1;
 ;;.06////^S X=BARLEV;
 ;;.08////^S X=BARFLDC;
 ;;1.02////^S X=BARSFLNM;
 ;;1.03////^S X=BARFLPTH;
 ;;1.04////^S X=BARBRF;
 ;;END
 S DR=""
 F I=1:1 S X=$P($T(DR+I^BARLNKW),";;",2) Q:X="END"  S DR=DR_X
 S BARDICDR=DR
 K DR
 ;
WALKE ;
 Q
 ; *********************************************************************
 ;
SHRTNM(X)          ;EP - RETURN SHORT NAME FOR TEXT
 N I,J,K,L,Y,Z
 S L=$L(X),Y=""
 F I=1:1:L S Z=$E(X,I) D  S Y=Y_Z
 . I I=1 Q
 . I $E(X,I-1)=$C(32) Q
 . I Z=" " S Z="_" Q
 . I Z=$E(X,I-1) S Z="" Q
 . I "AEIOUaeiou"[Z S Z=""
 ;
ESHRT ;
 Q Y
