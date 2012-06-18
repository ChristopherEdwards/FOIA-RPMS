AUPNLKI ; IHS/CMI/LAB - IHS PATIENT LOOKUP, MAIN ROUTINE INITIALIZATION ; [ 12/05/00  8:56 AM ]
 ;;99.1;IHS DICTIONARIES (PATIENT);**5**;MAR 09, 1999
 ;patch 5 fm v22
 ;
START ; INITIALIZATION
 S AUPQF=0,AUPDIC=DIC
 K AUPX,AUPDFN
 ;
 I '$D(DIC(0)) S AUPQF=1 Q
 I DIC(0)'["A"&('$D(X)) S AUPQF=1 Q
 I '$D(^DD("VERSION")) D:DIC(0)["E" EN^DDIOL("Unable to proceed. Fileman version node ^DD(""VERSION"") is undefined.","","!!?3") S AUPQF=1 Q
 I ^DD("VERSION")<17.2 D:DIC(0)["E" EN^DDIOL("Unable to proceed.  Fileman version must be at least 17.2.","","!!?3") S AUPQF=1 Q
 I '$D(^DPT(0)) D:DIC(0)["E" EN^DDIOL("Unable to proceed.  0th node of ^DPT missing.","","!!?3") S AUPQF=1 Q
 I '$D(^AUPNPAT(0)) D:DIC(0)["E" EN^DDIOL("Unable to proceed.  0th node of ^AUPNPAT missing.","","!!?3") S AUPQF=1 Q
 I '$D(DUZ(2)) D:DIC(0)["E" EN^DDIOL("Unable to proceed.  DUZ(2) is undefined.","","!!?3") S AUPQF=1 Q
 I DUZ(2)="" D:DIC(0)["E" EN^DDIOL("Unable to proceed.  DUZ(2) is NULL.","","!!?3") S AUPQF=1 Q
 I DUZ(2),'$D(^DIC(4,DUZ(2))) D:DIC(0)["E" EN^DDIOL("Unable to proceed.  DUZ(2) is not a valid Location.","","!!?3") S AUPQF=1 Q
 D:$D(AUPNLK("ALL")) SET^AUPNLKZ ; Undocumented feature
 ;
 ; - - - - - CHART # SCREEN - - - - -
 S:$D(DIC("S"))#2 AUPDICS=DIC("S")
 I DUZ(2) D SETDICS
 ; - - - - - SETUP DIC("W") - - - - -
 ; ** AUPNLKW overrides identifiers.  Must be set & killed by caller **
 K DUOUT,DTOUT S DIC="^DPT(" D DO^DIC1 S DIC("W")=$S($D(DIC("W")):DIC("W"),1:"") S:DIC("W")="W ""   "" D ^AUPNLKID"!(DIC("W")="") DIC("W")=$S($D(AUPNLKW):AUPNLKW,1:"D ^AUPNLKID")
 K AUPNLK("DICW")
 S:$L(DIC("W"))>110 AUPNLK("DICW")=DIC("W")
 S DIC("W")="D IHSDUPE^AUPNLKID "_$S($D(AUPNLK("DICW")):"X AUPNLK(""DICW"")",1:DIC("W"))
 S DIC("W")=DIC("W")_" N DA,X S DA=Y X $P(^DD(2,.081,0),U,5,99) D:X EN^DDIOL(""<Unresolved potential duplicate>"","""",""!?10"") W @(""$E(""_DIC_""Y,0),0)"")"
 S DIC("W")=DIC("W")_" I $D(AUPMAPY) S Y=AUPMAPY K AUPMAPY"
 S AUPDICW=DIC("W")
 Q
 ;
SETDICS ;SET DIC("S") NODES
 ;S DIC("S","IHSORIG")=$S($D(DIC("S")):DIC("S"),1:"I 1")
 S AUPNORIG=$S($D(DIC("S")):DIC("S"),1:"I 1")  ;IHS/ANMC/CLS 09/13/2000 fm v22
 ;S DIC("S","IHSLOOK")="I $D(^AUPNPAT(Y,41,DUZ(2),0))"_$S('$D(AUPNLK("INAC")):","_"$P(^(0),U,3)=""""",1:""),DIC("S")="X DIC(""S"",""IHSORIG"") I $T X DIC(""S"",""IHSLOOK"")"
 S AUPNLOOK="I $D(^AUPNPAT(Y,41,DUZ(2),0))"_$S('$D(AUPNLK("INAC")):","_"$P(^(0),U,3)=""""",1:""),DIC("S")="X AUPNORIG I $T X AUPNLOOK"  ;IHS/ANMC/CLS 09/13/2000 fm v22
 Q
