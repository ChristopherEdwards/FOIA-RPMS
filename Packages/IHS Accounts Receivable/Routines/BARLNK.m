BARLNK ; IHS/SD/LSL - LINK FILES ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
EN ; EP
SELECT ;
 ; Select links, hits, sorts, prints
 ; Select a file
 D HOME^%ZIS
 K DIC
 S DIC=$$DIC^XBDIQ1(90055.5)
 S DIC(0)="AEQML"
 D ^DIC
 Q:Y'>0
 S BARFN=+Y
 S $P(^BARDD(90055.5,BARFN,1,0),U,2)="90055.51A"
 K DIR
 ;
PICK ; EP
 ; SELECT
 S DIR(0)="SO^J:Join;S:Sorts;P:Prints;W:Walk;E:Edit Items;L:List Items"
 S BARTYP("J")="Join(s)"
 S BARTYP("H")="Pick(s)"
 S BARTYP("S")="Sort(s)"
 S BARTYP("P")="Print(s)"
 D ^DIR
 I (Y="")!(Y="^") G SELECT
 D @Y
 G PICK
 ; *********************************************************************
 ;
L ; EP
 I '$D(^BARRGIT(BARFN)) W !,"NOT BUILT YET !",! H 2 Q
 D LIST^BARLNRPT(BARFN)
 Q
 ; *********************************************************************
 ;
PICKQ ;
 Q
 ; *********************************************************************
 ;
DDPULL(BARFN) ;
 ; build array of pointers  from DD using truth test in BART
 K BARDD
 S BARDD=BARFN
 D PULLDD
 Q
 ; *********************************************************************
 ;
PULLDD ; EP
 ; PULL DD
 K ^TMP("BARDD",$J)
 S BARFD=.001
 S BARFDC=0
 F  S BARFD=$O(^DD(BARFN,BARFD)) Q:BARFD'>0  X BART I $T D
 . I BARTYP="J" S X=$P(@X,U,2)
 . S BARFDC=BARFDC+1
 . S ^TMP("BARDD",$J,BARFDC)=BARFD_"^"_+X
 . S ^TMP("BARDD",$J,"B",BARFD)=BARFDC
 Q
 ; *********************************************************************
 ;
E ; EP
 ; Edit Items       
 S XBSRCFL=+BARFN
 K DIC,DR,DA
 S DIC=$$DIC^XBDIQ1(90056.3)
 S DIC(0)="AEQML"
 D ^DIC
 I Y'>0 Q
 K ITM
 S ITMDA=+Y
 D DSPITM
 S DIE=DIC
 S DA=ITMDA
 S DR=".01;.04;.05;1.04"
 D ^DIE
 D DSPITM
 G E
 ; *********************************************************************
 ;
DSPITM ; EP
 D ENP^XBDIQ1(90056.3,ITMDA,".01:1.04","ITM(")
 W !,"Field |File",?15,ITM(.01)
 W !,"Attribute",?15,ITM(.04)
 W !,"FM Path",?15,ITM(.05)
 W !,"Data Path",?15,ITM(1.04)
 W !
 Q
 ; *********************************************************************
 ;
JDDSP ;
 ; display BARDD for joins field and file pointer
 D DDPULL(BARFN)
 W @IOF
 S X=$P(^DIC(BARDD,0),U)_" FILE Fields"
 W !,?10,X
 S BARFC=$O(^TMP("BARDD",$J,"A"),-1)
 S BARFCH=(BARFC\2)+(BARFC#2)
 F I=1:1:BARFCH D
 . S BARFD=$P(^TMP("BARDD",$J,I),U)
 . S BARFN0=$P(^TMP("BARDD",$J,I),U,2)
 . W !,$J(I,3),?5,$E($P(^DD(BARDD,BARFD,0),U),1,16)
 . W ?23,$E($P(^DIC(BARFN0,0),U),1,16)
 . S J=I+BARFCH
 . Q:'$D(^TMP("BARDD",$J,J))
 . S BARFD=$P(^TMP("BARDD",$J,J),U)
 . S BARFN0=$P(^TMP("BARDD",$J,J),U,2)
 . W ?40,$J(J,3),?45,$E($P(^DD(BARDD,BARFD,0),U),1,16)
 . W ?63,$E($P(^DIC(BARFN0,0),U),1,16)
 Q
 ; *********************************************************************
 ;
GDDSP ;
 ; display BARDD general 3 columns
 D DDPULL(BARFN)
 W @IOF
 S X=$P(^DIC(BARDD,0),U)_" FILE Fields"
 W !,?10,X
 S BARFC=$O(^TMP("BARDD",$J,"A"),-1)
 S BARFCH=BARFC\3
 S:(BARFC#3) BARFCH=BARFCH+1
 F I=1:1:BARFCH D
 . S BARFD=$P(^TMP("BARDD",$J,I),U)
 . W !,$J(I,3),?5,$E($P(^DD(BARDD,BARFD,0),U),1,16)
 . S J=I+BARFCH
 . Q:'$D(^TMP("BARDD",$J,J))
 . S BARFD=$P(^TMP("BARDD",$J,J),U)
 . W ?26,$J(J,3),?31,$E($P(^DD(BARDD,BARFD,0),U),1,16)
 . S J=2*BARFCH+I
 . Q:'$D(^TMP("BARDD",$J,J))
 . S BARFD=$P(^TMP("BARDD",$J,J),U)
 . W ?55,$J(J,3),?60,$E($P(^DD(BARDD,BARFD,0),U),1,16)
 Q
 ; *********************************************************************
 ;
LDDDSP ;
 ; display fields already tagged in with BARTYP in the link file
 D DDPULL(BARFN)
 K BAR,BARLNK,BARLDD
 S BARDD=BARFN
 S BARLDD=BARDD
 I '$D(^BARDD(90055.5,BARLDD)) Q
 K DIC
 S DIC=$$DIC^XBDIQ1(90055.51)
 S DIC("S")="I $P(^(0),U,3)[BARTYP"
 K ^TMP("BARLN",$J)
 D ENPM^XBDIQ1(.DIC,"BARDD,0",".01:99","^TMP(""BARLN"",$J,","I")
 S BARFD=0
 F BARFDC=1:1 S BARFD=$O(^TMP("BARLN",$J,BARFD)) Q:BARFD'>0  S BARLDD(BARFDC)=BARFD_"^"_^TMP("BARLN",$J,BARFD,.02,"I"),BARLDD("B",BARFD)=BARFDC
 S X=$P(^DIC(BARDD,0),U)_" FILE "_BARTYP(BARTYP)
 W ?10,X,!
 S BARFC=$O(BARLDD("A"),-1)
 S BARFCH=(BARFC\3)
 S:(BARFC#3) BARFCH=BARFCH+1
 F I=1:1:BARFCH D
 . S BARFD=$P(BARLDD(I),U),BARFN0=$P(BARLDD(I),U,2)
 . W !,$J(^TMP("BARDD",$J,"B",BARFD),3),?5,$E($P(^DD(BARLDD,BARFD,0),U),1,16)
 . S J=I+BARFCH
 . Q:'$D(BARLDD(J))
 . S BARFD=$P(BARLDD(J),U)
 . S BARFN0=$P(BARLDD(J),U,2)
 . W ?26,$J(^TMP("BARDD",$J,"B",BARFD),3),?31,$E($P(^DD(BARLDD,BARFD,0),U),1,16)
 . S J=I+(2*BARFCH)
 . Q:'$D(BARLDD(J))
 . S BARFD=$P(BARLDD(J),U)
 . S BARFN0=$P(BARLDD(J),U,2)
 . W ?55,$J(^TMP("BARDD",$J,"B",BARFD),3),?60,$E($P(^DD(BARLDD,BARFD,0),U),1,16)
 W !
 Q
 ; *********************************************************************
 ;
ADD ;
 ; add pointer to link file entry
 ; for back pointers
 K DIC
 I '$D(^BARDD(90055.5,BARDD)) D
 . W !,"file not in join file"
 . K DIR
 . S DIR(0)="Y"
 . S DIR("B")="Y"
 . S DIR("A")="ADD File to link file "
 . D ^DIR
 . K DIR
 . Q:'Y
 . S DIC=90055.5
 . S X=$P(^DIC(BARDD,0),U)
 . S DIC(0)="XL"
 . D ^DIC
 I '$D(^BARDD(90055.5,BARDD)) W !,"FILE NOT AVAILABLE",! H 3 Q
 S $P(^BARDD(90055.5,BARDD,1,0),U,2)="90055.51A" ;add header
 S BARFC=$O(^TMP("BARDD",$J,"A"),-1)
 W !
 K DIR
 S DIR(0)="LO^1:"_BARFC
 S DIR("A")="Add field(s) to File "_BARTYP(BARTYP)_" entries: "
 D ^DIR
 K DIR
 S BARY=Y
 Q:(+Y'>0)
 S DIC=$$DIC^XBDIQ1(90055.51)
 S DIC("P")=$P(^DD(90055.5,1,0),"^",2)
 S DA(1)=BARDD
 S DIC(0)="XL"
 F BARI=1:1 S BARFDC=$P(BARY,",",BARI) Q:'BARFDC  D
 . S X=$P(^TMP("BARDD",$J,BARFDC),U)
 . D ^DIC
 . S DA=+Y
 . S DA(1)=BARDD
 . S BARX=$$VAL^XBDIQ1(90055.51,.DA,.03)
 . I BARX[BARTYP Q
 . K DR
 . I BARTYP="J" S BARFP=$P(^TMP("BARDD",$J,BARFDC),U,2) D
 .. S X="`"_BARFP
 .. S DIC=$$DIC^XBDIQ1(90055.5)
 .. S DIC(0)="NXL"
 .. N DR
 .. D ^DIC
 . S DIE=$$DIC^XBDIQ1(90055.51)
 . S DR=".03////"_BARX_BARTYP
 . I BARTYP="J" S DR=DR_";.02////^S X=BARFP"
 . D ^DIE
 ;
ADDQ ;
 Q
 ; *********************************************************************
 ;
DELL ;del entries from link file
 Q
 K BAR,BARLNK,BARLDD
 S BARLDD=BARDD
 I '$D(^BARDD(90055.5,BARLDD)) Q
 K DIC
 S DIC=$$DIC^XBDIQ1(90055.51)
 S DIC("S")="I $P(^(0),U,3)[BARTYP"
 D ENPM^XBDIQ1(.DIC,"BARDD,0",".01:99","^TMP(""BARLNK"",$J,","I")
 S BARFD=0
 F BARFDC=1:1 S BARFD=$O(^TMP("BARLNK",$J,BARFD)) Q:BARFD'>0  S BARLDD(BARFDC)=BARFD_"^"_^TMP("BARLNK",$J,BARFD,.02,"I")
 S X=$P(^DIC(BARDD,0),U)_" FILE "_BARTYP(BARTYP)
 W !!,?10,X,!
 S BARFC=$O(BARLDD("A"),-1)
 S BARFCH=(BARFC\3)
 S:(BARFC#3) BARFCH=BARFCH+1
 F I=1:1:BARFCH D
 . S J=I
 . S BARFD=$P(BARLDD(I),U)
 . S BARFN0=$P(BARLDD(I),U,2)
 . W !,$J(J,3),?5,$E($P(^DD(BARLDD,BARFD,0),U),1,16)
 . S J=I+BARFCH
 . Q:'$D(BARLDD(J))
 . S BARFD=$P(BARLDD(J),U)
 . S BARFN0=$P(BARLDD(J),U,2)
 . W ?26,$J(J,3),?31,$E($P(^DD(BARLDD,BARFD,0),U),1,16)
 . S J=I+(2*BARFCH)
 . Q:'$D(BARLDD(J))
 . S BARFD=$P(BARLDD(J),U)
 . S BARFN0=$P(BARLDD(J),U,2)
 . W ?55,$J(J,3),?60,$E($P(^DD(BARLDD,BARFD,0),U),1,16)
 S BARFC=$O(BARLDD("A"),-1)
 Q
 ; *********************************************************************
 ;
QDELL ;EP - DELL ENTRIES
 ; for back pointers ;I BARTYP="B" D DELL^BARLNKB Q
 K DIR
 S DIR(0)="LO^1:"_BARFC
 S DIR("A")="Delete File "_BARTYP(BARTYP)_" Entries: "
 D ^DIR
 K DIR
 Q:+Y'>0
 S BARY=Y
 S DIE=$$DIC^XBDIQ1(90055.51)
 S DA(1)=BARLDD
 F BARI=1:1 S BARX=$P(BARY,",",BARI) Q:BARX'>0  S BARFD=+^TMP("BARDD",$J,BARX) I $D(BARLDD("B",BARFD)) S DA=BARFD D
 . S BARE=$$VAL^XBDIQ1(DIE,.DA,.03)
 . S BARE=$TR(BARE,BARTYP,"")
 . S:BARE="" BARE="-"
 . S DR=".03////^S X=BARE"
 . D ^DIE
 Q
 ; *********************************************************************
 ;
B ;EP - Back pointers
 S BARTYP="B"
 S XBROU="DISPLAY^BARLNKB"
 D EN^BARLN0
 Q
 ; *********************************************************************
 ;
J ;JOINS
JOIN ;;S X=$P(^(BARFD,0),U,3) I ($P(^(0),U)'["*"),X]"",X'[":" S X="^"_X_"0)" I $D(@X)
 ;logic to select valid pointer fields only
 S BARTYP="J"
 S BART=$P($T(JOIN^BARLNK),";;",2)
 S XBROU="JLM^BARLNK"
 D EN^BARLN0
 Q
 ; *********************************************************************
 ;
JLM ;sequence to generate Join list
 D LDDDSP,JDDSP
 Q
 ; *********************************************************************
 ;
HSPLM ;sequence to generate hits,sorts,prints list
 D LDDDSP,GDDSP
 Q
 ; *********************************************************************
 ;
H ;HITS  (pointers and sets of codes) for selection
HITS ;;S X=$P(^(BARFD,0),U,3) I X]"",($P(^(0),U)'["*")
 S BARTYP="H"
 S BART=$P($T(HITS^BARLNK),";;",2)
 S XBROU="HSPLM^BARLNK"
 D EN^BARLN0
 Q
 ; *********************************************************************
 ;
S ;SORTS (almost all fields , not multiples)
SORTS ;;S X=$P(^(BARFD,0),U,2) I (BARFD=.01)!((X'["A")&(X'["K")&(X'["M")&(X'["W")&(X'=+X)&(X'["F")&($P(^(0),U)'["*"))
 S BARTYP="S"
 S BART=$P($T(SORTS^BARLNK),";;",2)
 S XBROU="HSPLM^BARLNK"
 D EN^BARLN0
 Q
 ; *********************************************************************
 ;
P ;PRINTS (almost all fields .. not multiples at this time)
 S BARTYP="P"
 S BART="S X=$P(^(BARFD,0),U) I ($P(^(0),U)'[""*"")"
 S XBROU="HSPLM^BARLNK"
 D EN^BARLN0
 Q
 ; *********************************************************************
 ;
W ;Walk from this file and build item entries
TOP ;
 S BARTGDA1=BARFN,BARLEV=1
 S XBSRCFL=BARFN
 S BARPATH="",BARFLPTH=""
 D WALK
 Q
 ; *********************************************************************
 ;
WALK ;Given BARFN add the fields and then walk the join multiples
 D ^BARLNKW
 Q
LMFUN ;
