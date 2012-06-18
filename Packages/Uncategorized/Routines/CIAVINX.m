CIAVINX ;MSC/IND/DKM - Pretransportation routines for KIDS ;15-Feb-2008 09:25;DKM
 ;;1.1V2;VUECENTRIC FRAMEWORK;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Pre-transportation for export
EXPPRET N TGT,SUB,FIL,IEN
 S TGT=$$TGT(1),SUB=0
 Q:'TGT
 S @XPDGREF@("EXP")=$$GET1^DIQ(19930.99,TGT,.01)_U_$$GET1^DIQ(19930.99,TGT,.5)
 F  S SUB=$O(^CIAVDIST(TGT,SUB)) Q:'SUB  S FIL=+$P($G(^(SUB,0)),U,2) D:FIL
 .S FIL=+$P($P(^DD(FIL,.01,0),U,2),"P",2),IEN=0
 .Q:'FIL
 .S @XPDGREF@("EXP",SUB)=FIL
 .F  S IEN=$O(^CIAVDIST(TGT,SUB,IEN)) Q:'IEN  D
 ..S @XPDGREF@("EXP",SUB,IEN)=$$GET1^DIQ(FIL,IEN,.01)
 Q
 ; Post-init for export
EXPPOST N TGT,SUB,FIL,IEN,VAL,NEW,BLD,DIK,DA
 S TGT=$G(@XPDGREF@("EXP")),BLD=$P(TGT,U,2)
 S TGT=$$FIND1^DIC(19930.99,,"X",$P(TGT,U))
 Q:'TGT
 S BLD=$$FIND1^DIC(9.6,,"X",BLD)
 S $P(^CIAVDIST(TGT,0),U,2)=$S(BLD:BLD,1:""),SUB=0
 F  S SUB=$O(@XPDGREF@("EXP",SUB)) Q:'SUB  S FIL=^(SUB) D
 .N SAV
 .M SAV=^CIAVDIST(TGT,SUB)
 .Q:'$D(SAV(0))
 .K SAV("B")
 .K ^CIAVDIST(TGT,SUB)
 .S ^CIAVDIST(TGT,SUB,0)=SAV(0),IEN=0
 .F  S IEN=$O(@XPDGREF@("EXP",SUB,IEN)) Q:'IEN  S VAL=^(IEN) D
 ..S NEW=$$FIND1^DIC(FIL,,"X",VAL)
 ..I 'NEW W "Unable to resolve entry: ",VAL,!! Q
 ..S $P(SAV(IEN,0),U)=NEW
 ..M ^CIAVDIST(TGT,SUB,NEW)=SAV(IEN)
 S DIK="^CIAVDIST(",DA=TGT
 D IX^DIK
 Q
 ; Pre-transportation for components
GBL N C,M,P,V,X,X1,Y,Z,DIST,OBJ
 S DIST=$$TGT,C=0
 ; Save pointer mappings for multiples with .01 field pointers
 ; since KIDS doesn't resolve these.  (Doesn't work with DINUM)
 D GBLX(19930.2,19930.2,19930.221,9,1)
 D GBLX(19930.21,19930.2,19930.206,2,1)
 D GBLX(19.1,19930.2,19330.204,3,1)
 D GBLX(19.1,19941.21,19941.212,20,5)
 D GBLX(19.1,19941.21,19941.2121,21,5)
 ; Save object code for selected routines
 F X=0:0 S X=$O(^CIAVDIST(DIST,6,X)) Q:'X  D
 .S Y=$$GET1^DIQ(9.8,X,.01)
 .Q:'$L(Y)
 .F X1=0:0 S X1=$O(^CIAVDIST(DIST,6,X,1,X1)) Q:'X1  S V=^(X1,0) D
 ..S M=+V,V=$P(V,U,2)
 ..M @XPDGREF@("OBJ",M,V,Y)=^CIAVDIST(DIST,6,X,1,X1,1)
 ; Save initial values for exported parameters.
 F X=0:0 S X=$O(^CIAVDIST(DIST,2,X)) Q:'X  D
 .S P=$P(^XTV(8989.51,X,0),U)
 .F Y=0:0 S Y=$O(^CIAVDIST(DIST,2,X,1,Y)) Q:'Y  K Z M Z=^(Y) D
 ..K Z(2,0)
 ..S C=C+1
 ..M @XPDGREF@("PARAM",C)=Z(2)
 ..S @XPDGREF@("PARAM",C)=P_U_Z(0)_U_$G(Z(1))
 ; Set rename flag for any object aliases and overwrite for
 ; categories, keys, and/or initializations
 F X=0:0 S X=$O(^CIAVDIST(DIST,1,X)) Q:'X  D
 .S P=$P(^CIAVOBJ(19930.2,X,0),U),Z=^CIAVDIST(DIST,1,X,0)
 .F Y=0:0 S Y=$O(^CIAVOBJ(19930.2,X,10,Y)) Q:'Y  D RENAME(^(Y,0),P)
 .F Y=2,3,4 S:$P(Z,U,Y) @XPDGREF@("OVERWRITE",P,$S(Y=4:5,1:Y))=""
 ; Additional settings
 S @XPDGREF@("INITIAL")=$G(^CIAVDIST(DIST,50))
 S @XPDGREF@("FINAL")=$G(^CIAVDIST(DIST,51))
 S @XPDGREF@("EC")=$G(^CIAVDIST(DIST,53))
 X $G(^CIAVDIST(DIST,52))
 Q
 ; EP - Export object code for routines
EXPOBJ N MSYS,GBL,OBJ,VER,RTN,X
 W "Export Object Code for Selected Routines",!!
 X ^%ZOSF("RSEL")
 W !!
 Q:$O(^UTILITY($J,$C(1)))=""
 D ^%ZIS
 Q:POP
 U IO
 S MSYS=$$UP^XLFSTR($P($$VERSION^%ZOSV(1)," "))
 S VER=$TR($$VERSION^%ZOSV()," "),RTN=$C(1)
 W MSYS_U_VER,!
 F  S RTN=$O(^UTILITY($J,RTN)) Q:'$L(RTN)  D
 .S OBJ=""
 .W RTN,!
 .D EXPC:MSYS="CACHE",EXPJ:MSYS="JUMPS",EXPG:MSYS="GTM"
 .W !
 W "**END**",!
 D ^%ZISC
 Q
 ; Export a Cache binary
EXPC S OBJ=$$ENCODE^CIAUUU(^rOBJ(RTN))
 F  Q:OBJ=""  D
 .W $E(OBJ,1,75),!
 .S OBJ=$E(OBJ,76,999999)
 Q
 ; Export a JUMPS binary
EXPJ S OBJ=^$R(RTN,"OBJECT")
 F  Q:OBJ=""  D
 .S X=$F(OBJ,$C(10))
 .S:'X X=$L(OBJ)+2
 .W $E(OBJ,1,X-2),!
 .S OBJ=$E(OBJ,X,999999)
 Q
 ; Export a GTM binary
EXPG W "GTM export not yet supported.",!!
 Q
 ; Import object code into distribution
IMPOBJ N MSYS,VER,RTN,DIST,FIL,OBJ,QUIT,D1,X
 W "Import Object Code into a Distribution",!!
 S DIST=$$LOOKUP(19930.99,"Distribution")
 Q:'DIST
 R "Object code file: ",FIL,!!
 Q:U[FIL
 D CLOSEALL^CIAUOS,OPEN^CIAUOS(.FIL,"R")
 U FIL
 R X
 S MSYS=$P(X,U),VER=$P(X,U,2),OBJ=""
 S MSYS(0)=$S(MSYS="CACHE":1,MSYS="JUMPS":2,1:0)
 U IO(0)
 W "Target "_MSYS_" Version: "_VER_"// "
 R X,!
 S:$L(X) VER=X
 F  U FIL R RTN Q:RTN="**END**"  D  Q:$D(QUIT)
 .N FDA,IENS,CNT,DATA
 .U IO(0)
 .W ?5,"Importing routine ",RTN,"...",!
 .S RTN(0)=$O(^DIC(9.8,"B",RTN,0))
 .I 'RTN(0) S QUIT=1 Q
 .F D1=0:0 S D1=$O(^CIAVDIST(DIST,6,RTN(0),1,"B",MSYS(0),D1)) Q:'D1  D  Q:$L(X)
 ..S X=$P(^CIAVDIST(DIST,6,RTN(0),1,D1,0),U,2),VER(0)=X
 ..F  Q:X=VER  S X=$P(X,".",1,$L(X,".")-1) Q:'$L(X)
 .S:'D1 VER(0)=VER
 .S D1=$S(D1:D1,1:"+1")
 .S IENS=D1_","_RTN(0)_","_DIST_",",CNT=0
 .U FIL
 .F  R X Q:X=""  S CNT=CNT+1,DATA(CNT,0)=X
 .S FDA(19930.9961,IENS,.01)=MSYS(0)
 .S FDA(19930.9961,IENS,.5)=VER(0)
 .S FDA(19930.9961,IENS,1)="DATA"
 .D UPDATE^DIE(,"FDA")
 D CLOSE^CIAUOS(FIL)
 W:$D(QUIT) "Routine "_RTN_" not found.  Import aborted.",!!
 Q
 ; Lookup an entry in file #FN using prompt PM.
LOOKUP(FN,PM,FL,SC) ;
 Q:'FN -1
 N DIC,DLAYGO,X,Y
 W !
 F FL=''$G(FL):-1:0 D
 .S DIC=FN,DIC(0)=$S(FL:"E",1:"AE"),DIC("A")=PM_": ",X="??"
 .S:$L($G(SC)) DIC("S")=SC
 .D ^DIC
 W !
 Q $S(Y>0:+Y,1:0)
GBLX(TGT,SRC,SUB,NOD,TYP) ;
 N K,X,Y,Z
 S @XPDGREF@("PTRS",SUB)=NOD_U_SRC_U_TGT
 S TGT=$$ROOT^DILFD(TGT,,1),SRC=$$ROOT^DILFD(SRC,,1),X=0
 F  S X=$O(@SRC@(X)) Q:'X  S Y=$P(^(X,0),U),Z=0 D:$$SCRN(X,TYP)
 .S @XPDGREF@("PTRS",SUB,Y)=""
 .F  S Z=$O(@SRC@(X,NOD,Z)) Q:'Z  S K=+$G(^(Z,0)) D:K
 ..S K=$P($G(@TGT@(K,0)),U)
 ..S:$L(K) @XPDGREF@("PTRS",SUB,Y,K)=""
 Q
 ; Set progid's to be renamed
RENAME(OLD,NEW) ;
 S OLD=$TR(OLD," ")
 S:$L(OLD) @XPDGREF@("RENAME",OLD,NEW)=""
 Q
 ; Set target distribution (user is prompted if necessary)
 ; If NOSCN is set, selection will not be screened.
TGT(NOSCN) ;EP
 N DIC,Y
 Q:$G(XPDERR) 0
 S Y=+$G(@XPDGREF@("TGT"))
 Q:Y>0 Y
 S Y=$O(^CIAVDIST("C",XPDA,0))
 I Y,'$O(^CIAVDIST("C",XPDA,Y)) W "Target distribution: ",$P(^CIAVDIST(Y,0),U)
 E  D
 .S DIC=19930.99,DIC(0)="AEF",DIC("A")="Enter target distribution: "
 .S:'$G(NOSCN) DIC("S")="I $P(^(0),U,2)=XPDA"
 .D ^DIC
 .S Y=+Y
 W !!
 I Y<1 S XPDERR=1,Y=0
 E  S @XPDGREF@("TGT")=Y
 Q Y
 ; Screen entries
 ;   IEN = Entry to screen
 ;   TYP = 1: Object Registry
 ;         2: Parameter Definition
 ;         3: Parameter Template
 ;         4: Template Registry
 ;         5: Event Type
 ;         6: Routine
 ;         7: Object Category
 ;   Returns true if entry is to be included.
SCRN(IEN,TYP) ;
 Q:'$G(TYP) 1
 Q $D(^CIAVDIST($$TGT,TYP,IEN))
