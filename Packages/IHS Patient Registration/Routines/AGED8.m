AGED8 ; IHS/ASDS/EFG - EDIT DEATH INFO/OTHER NAMES ;  
 ;;7.1;PATIENT REGISTRATION;**2**;JAN 31, 2007
 ;
 S AG("N")=5
VAR D DRAW
 Q:$D(AGSEENLY)
 W !?10,"Enter ""4"" to edit OTHER NAMES or ""5"" to edit LEGAL NAMES."
 W !,AGLINE("EQ")
 I '$D(AGSEENLY) D
 . K DIR
 . S DIR("?")="Enter your choice now."
 . S DIR("?",1)="You may enter the item number of the field you wish to edit,"
 . S DIR("?",2)="OR you can enter 'P#' where P stands for 'page' and '#' stands for"
 . S DIR("?",3)="the page you wish to jump to, OR enter '^' to go back one page"
 . S DIR("?",4)="OR, enter '^^' to exit the edit screens, OR RETURN to go to the next screen."
 . S DIR("A")="CHANGE which item? (1-"_AG("N")_") NONE// "
 D READ^AGED1
 Q:$D(DTOUT)!$D(DFOUT)
 Q:$D(DUOUT)&$D(AGXTERN)
 G ^AGED13:$D(DUOUT)&'$D(AGXTERN),VAR:$D(AG("ERR")),END:$D(DLOUT)!(Y["N") G:$D(AG("ED"))&'$D(AGXTERN) @("^AGED"_AG("ED"))
 I $D(DQOUT)!(+Y<1)!(+Y>AG("N")) W !!,"You must enter a number from 1 to ",AG("N") H 2 G VAR
 W !!
CC S AG("C")="DATE^AGED8,STATE^AGED8,CERT^AGED8,ALIAS^AG3A,NAMCHG^AGNAMCHG"
C ;EP - Edit multiple fields on a Reg edit page.
 S AGY=Y F AGI=1:1 S AG("SEL")=+$P(AGY,",",AGI) Q:AG("SEL")<1!(AG("SEL")>AG("N"))  D @($P(AG("C"),",",AG("SEL")))
 D UPDATE1^AGED(DUZ(2),DFN,8,"") K AGI,AGY
 G VAR
END K AG,DFOUT,DQOUT,DTOUT,DLOUT,DA,DIC,DIE,DR,AGSCRN,Y
 K ROUTID
 Q:$D(AGXTERN)
 Q:$D(DIROUT)
 Q:$D(AGSEENLY)
 G ^AGED13:$D(DUOUT)
 G ^AGED11
 Q
DATE ;EP (string in AGED8).
 K A S DIE="^DPT(",DR=.351,DA=DFN D ^DIE
 I $D(^DPT(DFN,.35)) S $P(^AUPNPAT(DFN,11),U,29)=DT
 ;BEGIN NEW CODE IHS/SD/TPF 5/2/2006 AG*7.1*2 PAGE 12 ITEM 3
 I $$AGE^AGUTILS(DFN)<3,($$DECEASED^AGEDERR2(AGPATDFN)) D AUTOADD^BIPATE(DFN,DUZ(2),.AGERR,$P($G(^DPT(DFN,.35)),U))
 ;END NEW CODE
 Q
STATE ;EP (string in AGED8).
 S DIE="^AUPNPAT(",DR=1115,DA=DFN D ^DIE Q
CERT ;EP (string in AGED8).
 S DIE="^AUPNPAT(",DR=1116,DA=DFN D ^DIE Q
LEGNAM ;
 N DIC,DIR,DA,X,Y
 K DTOUT,DUOUT
 I $D(^AUPNNAMC("C",DFN))  D
 . S (PTR,REC,PRFPTR)=0
 . S (DTCHG,CHGTO,PROOF)=""
 . W !,"CHANGED TO"
 . W ?32,"BY"
 . W ?38,"PROOF"
 . W ?54,"DOC. #"
 . W ?70,"DATE"
 . W !,"5. "
 . F  S PTR=$O(^AUPNNAMC("C",DFN,PTR)) Q:'PTR  D
 .. S REC=$G(^AUPNNAMC(PTR,0))
 .. S DTCHG=$P($P(REC,U),".")
 .. S CHGTO=$P(REC,U,3)
 .. S PRFPTR=$P(REC,U,4)
 .. S DOCNUM=$P(REC,U,5)
 .. S USER=$P(REC,U,6)
 .. I PRFPTR>0 S PROOF=$E($P($G(^AUPNELM(PRFPTR,0)),U),1,20)
 .. W ?4,$E(CHGTO,1,30)
 .. I USER>0 W ?32,$P($G(^VA(200,USER,0)),U,2)
 .. I PRFPTR>0 W ?38,$E(PROOF,1,15)
 .. W ?54,$E(DOCNUM,1,15)
 .. W ?70,$E(DTCHG,4,5)_"/"_$E(DTCHG,6,7)_"/"_($E(DTCHG,1,3)+1700),!
 Q
DRAW ;EP
 S AG("PG")=7
 S ROUTID=$P($T(+1)," ")
 D ^AGED
 K ^UTILITY("DIQ1",$J)
 F AG=1:1 D  Q:$G(AGSCRN)[("*END*")
 . S AGSCRN=$P($T(@1+AG),";;",2,4)
 . Q:AGSCRN[("*END*")
 . S CAPTION=$P(AGSCRN,U)
 . S DIC=$P(AGSCRN,U,3)
 . S DR=$P(AGSCRN,U,4)
 . S NEWLINE=$P(AGSCRN,U,5)
 . S CAPDENT=$P(AGSCRN,U,2)
 . W @NEWLINE,AG,".",@CAPDENT,$S($G(CAPTION)'="":CAPTION,1:$P($G(^DD(DIC,DR,0)),U))_" : "
 . W $$GET1^DIQ(DIC,DFN,DR)
 . I AG=1 D
 .. I $P($G(^DPT(DFN,.35)),U,2)'="" D
 ... W ?45,"Edited by "_$P($G(^VA(200,$P($G(^DPT(DFN,.35)),U,2),0)),U,2)
 .. I $P($G(^AUPNPAT(DFN,11)),U,29)'="" S Y=$P($G(^AUPNPAT(DFN,11)),U,29) D DD^%DT D
 ... W " on "_Y
 W !,$E(AGLINE("-"),1,33) W ?33," Other Names ",$E(AGLINE("-"),1,34)
 W !,"4. "
 I $D(^DPT(DFN,.01,0)) D
 .S DIC=2
 .S DR(2.01)=.01
 .S DR=1
 .S DA=DFN
 .S DAIEN=0
 .F  S DAIEN=$O(^DPT(DFN,.01,DAIEN)) Q:+DAIEN=0  D
 .. S DA(2.01)=DAIEN
 .. K AGRES
 .. S DIQ="AGRES",DIQ(0)="E" D EN^DIQ1
 .. W:$G(AGRES(2.01,DAIEN,.01,"E"))'="" ?4,$G(AGRES(2.01,DAIEN,.01,"E")),!
 .. K AGRES,TEMPDIC,AGRES
 W !,$E(AGLINE("-"),1,33) W ?33," Legal Names ",$E(AGLINE("-"),1,34)
 D LEGNAM
 Q
 ; ****************************************************************
 ; ON LINES BELOW:
 ; U "^" DELIMITED
 ; PIECE 1= FLD LBL
 ; PIECE 2= POSITION ON LINE TO DISP ITEM #
 ; PIECE 3= FILE #
 ; PIECE 4= FLD #
 ; PIECE 5= NEW LINE OR NOT (MUST BE EITHER A '!' OR '?#') USE THIS TO INDENT THE CAP
 ; PIECE 6= ITEM # OVERIDE. USE THIS TO ASSIGN THE ITEM # USED TO CHOOSE THIS
 ;          FLD ON THE SCREEN
 ; PIECE 7= TAG TO CALL WHEN THIS FLD IS CHOSEN TO EDIT
 ; 
 ; BAR "|" DELIMITED
 ; PIECE 2= EXECUTE CODE TO GET FLD THAT ANOTHER IS POINTING TO. EXECUTED AFT FLD PRINT
 ; PIECE 3= EXECUTE CODE TO DO BEF FLD DATA PRINTS. USE TO SCREEN OUT PRINTING A FLDS DATA
 ; PIECE 4= EXECUTE CODE TO DO BEF PRINTING THE CAP OR FLD LBL. USE TO SCREEN OUT PRINTING A CAP/FLD LBL
 ; PIECE 5= EXECUTE CODE TO DO AFT PRINTING THE FLD DATA
1 ;
 ;;^?11^2^.351^!^1
 ;;^?10^9000001^1115^!^2
 ;;^?3^9000001^1116^!^3
 ;;*END*
