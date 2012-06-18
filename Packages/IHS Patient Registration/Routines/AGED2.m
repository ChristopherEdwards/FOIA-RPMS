AGED2 ; IHS/ASDS/EFG - EDIT PG 2 - RELIGION/TRIBAL DATA/EMPLOYMENT DATA ; MAR 19, 2010
 ;;7.1;PATIENT REGISTRATION;**2,3,7,8,10**;AUG 25, 2005;Build 7
 ;
 ;AG*7.1*7 - Sections of this routine were re-written to accomplish the following:
 ;           1) Modified code to allow for the new page 10
 ;           2) Ethnicity, Race, Internet, and Household Information are now asked on Page 10
 ;              (Edit tags are still located in this routine however)
 ;
 ;AG*7.1*8 - Sections of thsi routine were re-written to accomplish the following:
 ;           1) Added Father/Mother Email/Cell/Alt Phone fields and prompts
 ;           2) Modified code better handle display - line #, tabs, label display/length, field call handling
 ;AG*7.1*10- Put in validity check on user field selection prompt
 N CLLST
 I "YC"[AGOPT(14) S AG("SVELIG")=""
 I $D(^AUPNPAT(DFN,11)) S AG("SVELIG")=$P($G(^AUPNPAT(DFN,11)),U,12)
VAR ;
 ;S CALLS="REL^AG8A,BENED^AG2A,TRIBE^AG2A,TQTM^AGOPT2,IQTM^AG2A,TRINUM^AGOPT2,OTHERT,FATHER,MOTHER,EMPLR,SPSEMP,FEMPL,MEMPL"  ;AG*7.1*7
 D DRAW
 W !,AGLINE("EQ")
 K AG("ER")
 D ^AGDATCK
 ;I ($D(AG("ER",13))!$D(AG("ER","TEMPHRN"))!$D(AG("ER",2))) W *7,!!,"Patient must first have a VALID/permanent HRN prior to editing !" K DIR S DIR(0)="E" D ^DIR S DUOUT=1 K AG("ER") G END
 K AG("ER")
 D:"YC"[AGOPT(14) CKELIG^AGED1 S AGWM=1 D ^AGELCHK W:$D(AG("ER",9)) *7,!,?10,"Corrections are to be made: " K DIR S DIR("A")="CHANGE which item? (1-"_AG("N")_") NONE//" D READ
 I $D(MYERRS("C","E")),(Y'?1N.N),(Y'=AGOPT("ESCAPE")) W !,"ERRORS ON THIS PAGE. PLEASE FIX BEFORE EXITING!!" H 3 G VAR
 Q:Y=AGOPT("ESCAPE")
 I $D(AG("ER",9)) I (($D(DFOUT))!($D(DLOUT))!(Y["N")!($D(DUOUT))!($D(AG("ED")))) D  G VAR
 . W !,"The corrections must be made !",*7
 G END:$D(DLOUT)!(Y["N")!$D(DUOUT)
 G VAR:$D(AG("ERR"))
 G:$D(AG("ED"))&('$D(AGXTERN)) @("^AGED"_AG("ED"))
 Q:$D(DTOUT)!$D(DFOUT)
 I $D(DQOUT)!(+Y<1)!(+Y>AG("N")) W !!,"You must enter a number from 1 to ",AG("N") H 2 G VAR
 S AGY=Y
 ;AG*7.1*8 - Replaced existing logic with next 3 lines
 S AGY=Y
 ;AG*7.1*10;Added next line to stop bad user entry errors
 I $TR(AGY,",")'?1N.N W !!,"Invalid entry - Enter a line number or line numbers separated by a ',' to edit" H 3 G VAR
 F AGI=1:1 S AG("SEL")=+$P(AGY,",",AGI) Q:AG("SEL")<1!(AG("SEL")>AG("E"))  D
 . D @(CLLST(AG("SEL")))
 D UPDATE1^AGED(DUZ(2),DFN,2,"")
 G VAR
END ;
 K AG,AGI,AGIO,AGY,CLLST,DLOUT,DQOUT,DFOUT,DTOUT,DA,AGSCRN,Y,QUAN,TRIBE
 K ROUTID
 Q:$D(AGXTERN)
 Q:$D(DIROUT)
 G VAR^AGED1:$D(DUOUT)
 G ^AGED3
ELIG ;
 I AGOPT(14)'="Y" D ELIG^AG2A Q
 W !!,"You can only change a patient's eligibility"
 W !,"by altering their Community of Residence,"
 W !,"Tribe of Membership, or Indian Quantum."
 W !,"Press return to continue"
 W *7
 D READ
 Q
DRAW ;EP
 S CLLST=0
 S CALLS="REL^AG8A,BENED^AG2A,TRIBE^AG2A,TQTM^AGOPT2,IQTM^AG2A,TRINUM^AGOPT2,OTHERT,FATHER,FCPH,FEML,FAPH,MOTHER,MCPH,MEML,MAPH,EMPLR,SPSEMP,FEMPL,MEMPL"  ;AG*7.1*7
 S AG("PG")=2
 S AG("N")=19  ;AG*7.1*8
 S ROUTID=$P($T(+1)," ")  ;SET ROUTINE ID FOR PROGRAMMER VIEW
 S DA=DFN
 D ^AGED                          ;Main editor routine
 K ^UTILITY("DIQ1",$J)
 I AGOPT(14)="Y" D
 . D ^AGBIC2C                     ;Compute eligibility status
 . S DIC=9000001
 . S DR=1124
 . S $P(AGSCRN,";;")=""
 . W !,"1.  ",$P($G(^DD(DIC,DR,0)),U)," :  "
 . W $$GET1^DIQ(DIC,DFN,DR)
 F AG=1:1:AG("N") D
 . N AGSCRN,LBL,LEN,CLM,DIC,DR,VLEN,VALUE  ;AG*7.1*8
 . S AGSCRN=$P($T(@1+AG),";;",2,17)
 . S LBL=$P(AGSCRN,U)           ;AG*7.1*8 - Added LBL,LEN,CLM
 . S LEN=$P(AGSCRN,U,2)
 . S CLM=$P(AGSCRN,U,3)
 . S DIC=$P(AGSCRN,U,4)
 . S DR=$P(AGSCRN,U,5)
 . S VLEN=$P(AGSCRN,U,6)
 . ;
 . ;Prompt position ;AG*7.1*8
 . I CLM="" W !
 . E  W ?CLM
 . ;
 . ;Display Number  ;AG*7.1*8
 . S CLLST=CLLST+1,CLLST(CLLST)=$P(CALLS,",",AG),AG("E")=CLLST
 . W CLLST,". "
 . ;
 . ;Display label  AG*7.1*8
 . W $J(LBL,LEN),": "
 . ;
 . ;D
 . ;. I AG=16,$$GET1^DIQ(9009061,DUZ(2)_",",502,"I") W $E($$GET1^DIQ(DIC,DFN,DR),1,15) Q  ;AG*7.1*8 - Changed AG value to 16
 . S VALUE=$$GET1^DIQ(DIC,DFN,DR)
 . S:VLEN>0 VALUE=$E(VALUE,1,VLEN)
 . W VALUE
 . I AG=3 D
 .. I $P($G(^AUPNPAT(DFN,11)),U,8)'=""  D
 ... S Y=$$GET1^DIQ(DIC,DFN,DR)
 ... D TRBCHK
 . I AG=7,'$D(^AUPNPAT(DFN,43)) D
 .. W ?33,"* NONE LISTED *"
 . I AG=7 D OTHER W !,AGLINE("-")
 . I AG=15 W !,AGLINE("-")  ;AG*7.1*8 - Changed AG value to 15
 ;
 W !,AGLINE("-")
 K MYERRS,MYVARS
 D FETCHERR^AGEDERR(AG("PG"),.MYERRS)
 S MYVARS("DFN")=DFN,MYVARS("FINDCALL")="",MYVARS("SELECTION")=$G(AGSELECT),MYVARS("SITE")=DUZ(2)
 D EDITCHEK^AGEDERR(.MYERRS,.MYVARS,1)
 Q
READ ;EP
 K DFOUT,DTOUT,DUOUT,DQOUT,DLOUT,AG("ED"),AG("ERR"),DIROUT
 S DIR("?")="Enter free text"
 S DIR("?",1)="You may enter the item number of the field you wish to edit,"
 S DIR("?",2)="OR you can enter 'P#' where P stands for 'page' and '#' stands for"
 S DIR("?",3)="the page you wish to jump to, OR enter '^' to go back one page"
 S DIR("?",4)="OR, enter '^^' to exit the edit screens, OR RETURN to go to the next screen."
 S DIR(0)="FO"
 D ^DIR
 Q:$D(DTOUT)
 S:Y="/.,"!(Y="^^") DFOUT=""
 S:Y="" DLOUT=""
 S:Y="^" (DUOUT,Y)=""
 S:Y?1"?".E!(Y["^") (DQOUT,Y)=""
 Q:Y="P"
 I $E(Y,1)="p" S $E(Y,1)="P"
 I $E(Y,1)="P"&($P($G(^AUPNPAT(DFN,11)),U,12)'="") D
 . S AG("ED")=+$P($E(Y,2,99),".")
 . I AG("ED")<1!(AG("ED")>10) D  ;AG*7.1*7
 .. W *7,!!,"Use only pages 1 through 10."  ;AG*7.1*7
 .. H 2
 .. K AG("ED")
 .. S AG("ERR")=""
 . I $D(AG("ED"))  D
 .. I AG("ED")>0&(AG("ED")<11)  D  ;AG*7.1*7
 ... I AG("ED")=4 S AG("ED")="4A"
 ... I AG("ED")=5 S AG("ED")="BEA"
 ... I AG("ED")=6 S AG("ED")=13
 ... I AG("ED")=8 S AG("ED")=11
 ... I AG("ED")=7 S AG("ED")=8
 ... I AG("ED")=9 S AG("ED")="11A"
 ... I AG("ED")=10 S AG("ED")="10A"  ;AG*7.1*7
 Q
TRBCHK ;
 I $P($G(^AUTTTRI($O(^AUTTTRI("B",$E(Y,1,30),0)),0)),U,4)="Y" D  Q
 . W:$X<50 ?50
 . W:$X>50 !?33
 . W $$S^AGVDF("RVN"),"(OLD UNUSED TRIBE NAME)",$$S^AGVDF("RVF")
 I $P($G(^AUTTTRI($O(^AUTTTRI("B",$E(Y,1,30),0)),0)),U,2)=999 D  Q
 . W $$S^AGVDF("RVN")," <- PLEASE SPECIFY IF KNOWN",$$S^AGVDF("RVF")
 I "YC"[AGOPT(14) D
 . S DR=1119
 . K AGRES
 . S TEMPDIC=DIC
 . S DIQ="AGRES",DIQ(0)="E" D EN^DIQ1
 . S DIC=TEMPDIC
 . W $G(AGRES(DIC,DFN,DR,"E"))
 . K AGRES,TEMPDIC,AGRES
 Q
EMPLR ;EP - Patient's Employer.
 S AGEL("ONUM")=$P($G(^AUTNEMPL(0)),U,4)
 W !
 K DIR,DIE,DR,DIC
 S DIE="^AUPNPAT("
 ;IF EMPLOYMENT STATUS FULL OR PART TIME
 I ($P($G(^AUPNPAT(DFN,0)),U,21)=1!($P($G(^AUPNPAT(DFN,0)),U,21)=2)),$$ISREQ^AGFLDREQ(9000001,.19) S DIE("NO^")="",DR=".19R"
 E  S DR=.19
 S DA=DFN
 D ^DIE
 I $P($G(^AUPNPAT(DFN,0)),U,19)="",$P($G(^(0)),U,21)]"","39"'[$P($G(^(0)),U,21) D
 . S DR=".21///@"
 . D ^DIE
 . K DIE,DIC,DR
 Q:$P($G(^AUPNPAT(DFN,0)),U,19)=""
 S AGEL("EMP")=$P($G(^AUPNPAT(DFN,0)),U,19)
 D:$P($G(^AUTNEMPL(0)),U,4)'=AGEL("ONUM") EMPL
EMST ;GET PATIENT'S EMPLOYMENT STATUS
 W !
 S DIE="^AUPNPAT("
 S DA=DFN
 S DR=.21
 D ^DIE
 K DIC,DR,DIE
 K AGEL("EMP")
 K AGEL("ONUM")
 Q
EMPL ;
 S DIE="^AUTNEMPL("
 S DA=AGEL("EMP")
 W !!,"<----------EMPLOYER DEMOGRAPHIC INFO---------->"
 S DR=".02 Street...: ;.03 City.....: ;.04 State....: ;.05 Zip......: ;.06 Phone....: ;.07 Abbrev...: "
 D ^DIE
 Q
SPSEMP ;EP - Spouse's Employer.
 S AGEL("ONUM")=$P($G(^AUTNEMPL(0)),U,4)
 W !
 S DIE="^AUPNPAT("
 S DR=.22
 S DA=DFN
 D ^DIE
 Q:$P($G(^AUPNPAT(DFN,0)),U,22)=""
 S AGEL("EMP")=$P($G(^AUPNPAT(DFN,0)),U,22)
 D:$P($G(^AUTNEMPL(0)),U,4)'=AGEL("ONUM") EMPL
 K AGEL("EMP")
 K AGEL("ONUM")
 K DIE,DIC,DR
 Q
FEMPL ;FATHER'S EMPLOYER INFO
 S AGEL("ONUM")=$P($G(^AUTNEMPL(0)),U,4) ;NUMBER OF ENTRIES IN FILE
 W !
 S DIE="^AUPNPAT("
 I $$AGE^AUPNPAT(DFN)>17 S DR=2701
 I $$AGE^AUPNPAT(DFN)<18,$P($G(^AUPNPAT(DFN,27)),U,2)="" S DR="2701R"
 E  S DR=2701
 S DA=DFN
 D ^DIE
 Q:$P($G(^AUPNPAT(DFN,27)),U)=""
 S AGEL("EMP")=$P($G(^AUPNPAT(DFN,27)),U)
 D:$P($G(^AUTNEMPL(0)),U,4)'=AGEL("ONUM") EMPL
 K AGEL("EMP")
 K AGEL("ONUM")
 K DIE,DIC,DR
 Q
MEMPL ;MOTHER'S EMPLOYER INFO
 K DIE,DIC,DR
 S AGEL("ONUM")=$P($G(^AUTNEMPL(0)),U,4) ;# OF ENTRIES IN FILE
 W !
 S DIE="^AUPNPAT("
 I $$AGE^AUPNPAT(DFN)>17 S DR=2702
 I $$AGE^AUPNPAT(DFN)<18,$P($G(^AUPNPAT(DFN,27)),U)="" S DR="2702R"
 E  S DR=2702
 S DA=DFN
 D ^DIE
 Q:$P($G(^AUPNPAT(DFN,27)),U,2)=""
 S AGEL("EMP")=$P($G(^AUPNPAT(DFN,27)),U,2)
 D:$P($G(^AUTNEMPL(0)),U,4)'=AGEL("ONUM") EMPL
 K AGEL("EMP")
 K AGEL("ONUM")
 K DIE,DIC,DR
 Q
OTHER ;DISPLAY LAST OTHER TRIBE AND QUANTUM
 S D1=0
 S TRIBE="",QUAN=""
 F  S D1=$O(^AUPNPAT(DFN,43,D1)) Q:'D1  D
 . S TRIBE=$P($G(^AUTTTRI($P($G(^AUPNPAT(DFN,43,D1,0)),U),0)),U)
 . S QUAN=$P($G(^AUPNPAT(DFN,43,D1,0)),U,2)
 W ?32,TRIBE
 W ?73,$E(QUAN,1,6)
 Q
OTHERT ;ALLOW ADD AND EDIT OF OTHER TRIBES AND QUANTUMS
 Q:AGOPT(8)'="Y"
 W !!,"OTHER TRIBES:",?50,"QUANTUM:",!
 S D1=0
 F  S D1=$O(^AUPNPAT(DFN,43,D1)) Q:'D1  D
 . S TRIPTR=$P($G(^AUPNPAT(DFN,43,D1,0)),U)
 . S OTRIBE=$P($G(^AUTTTRI(TRIPTR,0)),U)
 . S OQUAN=$P($G(^AUPNPAT(DFN,43,D1,0)),U,2)
 . W !,OTRIBE,?50,OQUAN
 W !!
 K DIC,DIE,DR
 S DIE="^AUPNPAT("
 S DR=4301
 S DA=DFN
 D ^DIE
 D UPDATE1^AGED(DUZ(2),DFN,12,"")
 I '$O(^AUPNPAT(DFN,43,0)) K ^AUPNPAT(DFN,43)
 K DIC,DIE,DR
 Q
FATHER ;GET FATHER'S NAME, CITY AND STATE OF BIRTH
 K DUOUT
 K DIE
 S DIE="^DPT("
 S DA=DFN
 W !
 S DR=.2401
 D ^DIE
 S:$D(Y) DUOUT=""
 K DIE,DIC,DR,DUOUT
 I $P($G(^DPT(DFN,.24)),U)="" D
 . I $P($G(^AUPNPAT(DFN,26)),U,2)'="" S $P(^AUPNPAT(DFN,26),U,2)=""
 . I $P($G(^AUPNPAT(DFN,26)),U,3)'="" S $P(^AUPNPAT(DFN,26),U,3)=""
 I $P($G(^DPT(DFN,.24)),U)'="" D
 . S DIE="^AUPNPAT("
 . W !
 . S DR="2602;2603"
 . D ^DIE
 . S:$D(Y) DUOUT=""
 . K DIE,DIC,DR
 Q
 ;
MOTHER ;GET MOTHER'S NAME, CITY AND STATE OF BIRTH
 K DUOUT,DIE
 S DIE="^DPT("
 S DA=DFN
 W !
 S DR=.2403
 D ^DIE
 S:$D(Y) DUOUT=""
 K DUOUT
 I $P($G(^DPT(DFN,.24)),U,3)="" D
 . I $P($G(^AUPNPAT(DFN,26)),U,5)'="" S $P(^AUPNPAT(DFN,26),U,5)=""
 . I $P($G(^AUPNPAT(DFN,26)),U,6)'="" S $P(^AUPNPAT(DFN,26),U,6)=""
 I $P($G(^DPT(DFN,.24)),U,3)'="" D
 . S DIE="^AUPNPAT("
 . W !
 . S DR="2605;2606"
 . D ^DIE
 . S:$D(Y) DUOUT=""
 . K DIE,DIC,DR
 Q
 ;
 ;AG*7.1*8 - Added FCPH, FEML, FAPH, MCPH, MEML, MAPH, and DIE tags
 ;
FCPH ;EP - Edit Father's Cell Phone
 N DR
 S DR=2903
 D DIE
 Q
 ;
FEML ;EP - Edit Father's Email Address
 N DR
 S DR=2901
 D DIE
 Q
 ;
FAPH ;EP - Edit Father's Alternate Phone
 N DR
 S DR="2902FATHER'S ALT. PHONE"
 D DIE
 Q
 ;
MCPH ;EP - Edit Mother's Cell Phone
 N DR
 S DR=3003
 D DIE
 Q
 ;
MEML ;EP - Edit Mother's Email Address
 N DR
 S DR=3001
 D DIE
 Q
 ;
MAPH ;EP - Edit Mother's Alternate Phone
 N DR
 S DR="3002MOTHER'S ALT. PHONE"
 D DIE
 Q
 ;
DIE ; Do Field Edit
 N DA,DIE,DUOUT
 S DIE="^AUPNPAT("
 S DA=DFN
 D ^DIE
 Q
 ;
 ;AG*7.1*8 - Added Father/Mother Cell phone/Email/Alt Phone
 ;
 ; ****************************************************************
 ; ON LINES BELOW:
 ; PIECE 1= FLD LBL
 ; PIECE 2= FLD LENGTH
 ; PIECE 3= POSITION ON LINE TO DISP FLD, IF BLANK NEW LINE
 ; PIECE 4= FILE #
 ; PIECE 5= FLD #
 ; PIECE 6= Length (optional)
1 ;
 ;;RELIGIOUS PREFERENCE ^27^^2^.08
 ;;CLASSIFICATION/BENEFICIARY ^27^^9000001^1111
 ;;TRIBE OF MEMBERSHIP ^27^^9000001^1108
 ;;TRIBE QUANTUM ^14^^9000001^1109
 ;;INDIAN BLOOD QUANTUM ^^40^9000001^1110
 ;;TRIBAL ENROLLMENT NO. ^27^^9000001^.07
 ;;OTHER TRIBE ^27^^9000001^4301
 ;;FATHER'S NAME ^14^^2^.2401^29
 ;;CELL PHONE^12^49^9000001^2903
 ;;EMAIL ADDRESS^12^^9000001^2901^29
 ;;ALT.PHONE^11^49^9000001^2902
 ;;MOTHER'S MAIDEN NAME ^21^^2^.2403^20
 ;;CELL PHONE^12^48^9000001^3003
 ;;EMAIL ADDRESS^12^^9000001^3001^29
 ;;ALT.PHONE^11^49^9000001^3002
 ;;EMPLOYER NAME ^27^^9000001^.19
 ;;SPOUSE'S EMPLOYER NAME ^27^^9000001^.22
 ;;FATHER'S EMPLOYER NAME ^27^^9000001^2701
 ;;MOTHER'S EMPLOYER NAME ^27^^9000001^2702
