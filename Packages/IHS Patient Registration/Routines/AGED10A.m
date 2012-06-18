AGED10A ; VNGT/HS/BEE - EDIT PG 10 - ETHNICITY/RACE/LANGUAGE/MIGRANT/HOMELESS/INTERNET/HOUSEHOLD INFO ; MAR 19, 2010   
 ;;7.1;PATIENT REGISTRATION;**7,8,9,10**;AUG 25, 2005;Build 7
 ;
VAR N AG,AGI,AGY,CLLST,DFOUT,DIR,DIROUT,DLOUT,DQOUT,DTOUT,DUOUT,DIRUT,DOTS,MYERRS,MYVARS,ROUTID,Y
 ;
 ;Initialize variables
 S ROUTID=$P($T(+1)," ")  ;SET ROUTINE ID FOR PROGRAMMER VIEW
 S $P(DOTS,".",22)="."
 ;
 ;Draw the page
 D DRAW
 ;
 ;Quit if View Mode
 Q:$D(AGSEENLY)
 ;
 ;Print Header
 W !,AGLINE("EQ")
 ;
 K AG("ER")
 ;
 ;Prompt user for input
 K DIR S DIR("A")="CHANGE which item? (1-"_AG("E")_") NONE//" D READ
 I $D(MYERRS("C","E")),(Y'?1N.N),(Y'=AGOPT("ESCAPE")) D  H 3 D KILL G VAR
 . W !,"ERRORS ON THIS PAGE. PLEASE FIX BEFORE EXITING!!"
 ;
 ;Quit on "^^" entry
 I Y=AGOPT("ESCAPE") S DIROUT=1 G END
 ;
 ;Additional exit handling
 I $D(DFOUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)!$D(DLOUT)!(Y["N") G END
 ;
 ;Loop if there is still an error
 I $D(AG("ERR")) D KILL G VAR
 ;
 ;Switch Pages
 I $D(AG("ED"))&('$D(AGXTERN)) N PAGE S PAGE=AG("ED") D KILL S AG("ED")=PAGE K PAGE G @("^AGED"_AG("ED"))
 ;
 ;Edit field(s)
 I $D(DQOUT)!(+Y<1)!(+Y>AG("E")) W !!,"You must enter a number from 1 to ",AG("E") H 2 D KILL G VAR
 S AGY=Y
 ;AG*7.1*10;Added next line to stop bad user entry errors
 I $TR(AGY,",")'?1N.N W !!,"Invalid entry - Enter a line number or line numbers separated by a ',' to edit" H 3 G VAR
 F AGI=1:1 S AG("SEL")=+$P(AGY,",",AGI) Q:AG("SEL")<1!(AG("SEL")>AG("E"))  D
 . D @(CLLST(AG("SEL")))
 D UPDATE1^AGED(DUZ(2),DFN,2,"")
 D KILL
 G VAR
END ;
 I $D(AGXTERN)!$D(DIROUT)!$D(DTOUT)!$D(DFOUT) D KILL Q
 I $D(DUOUT) D KILL G ^AGED11A
 D KILL
 Q
 ;
 ;Variable clean up
KILL K AG,AGI,AGY,CLLST,DFOUT,DIR,DIROUT,DLOUT,DQOUT,DTOUT,DUOUT,DIRUT,DOTS,MYERRS,MYVARS,ROUTID,Y
 Q
 ;
DRAW ;EP
 N CALLS
 S CALLS="ETHNIC^AGED10B,RACE^AGED10B,LANG^AGED10B,PREF^AGED10B(0),MIG,HOM,WEB^AGED1,EDEMAIL^AGED1,PERM,PREF,NIH^AGED10B,THI^AGED10B"
 S AG("PG")=10
 S AG("N")=12
 S AG("E")=12 S:AGOPT(22)="N" AG("E")=10
 S:$G(AGOPT(26))'="Y" AG("E")=AG("E")-1
 S:$G(AGOPT(27))'="Y" AG("E")=AG("E")-1
 S CLLST=0
 ;
 D ^AGED   ;Main editor routine - Print Header
 ;
 F AG=1:1:AG("N") D
 . ;
 . N AGSCRN,LBL,DIC,DR
 . S AGSCRN=$P($T(@1+AG),";;",2,17)
 . S LBL=$P(AGSCRN,U)                ;Label
 . S DIC=$P(AGSCRN,U,2)              ;File
 . S DR=$P(AGSCRN,U,3)               ;Field #
 . ;
 . ;Draw line
 . I (AG=5),($G(AGOPT(26))="Y"!($G(AGOPT(27))="Y")) W !,AGLINE("-")
 . I AG=7 W !,AGLINE("-")
 . I (AG=11),AGOPT(22)'="N" W !,AGLINE("-")
 . ;
 . I (AG=11)!(AG=12),AGOPT(22)="N" Q
 . I AG=5,$G(AGOPT(26))'="Y" Q
 . I AG=6,$G(AGOPT(27))'="Y" Q
 . ;
 . S CLLST=CLLST+1,CLLST(CLLST)=$P(CALLS,",",AG)
 . I AG=10 W ?38,CLLST,". ",LBL,": "
 . E  W !,CLLST,". ",LBL,$E(DOTS,1,22-$L(LBL)),": "
 . ;
 . ;Special code for Ethnicity
 . I AG=1 D  Q
 .. N ETHNIC S ETHNIC=$O(^DPT(DFN,.06,0))
 .. I ETHNIC S ETHNIC=$$GET1^DIQ(2.06,ETHNIC_","_DFN_",",".01","E")
 .. W $E($G(ETHNIC),1,25)
 . ;
 . ;Display Race
 . I AG=2 W $$GET1^DIQ(DIC,DFN,DR) Q
 . ;
 . ;Display Some Language Information
 . I AG=3 D  Q
 .. N LNG,OLNG
 .. S LNG=$$CLANG^AGED10B(AGPATDFN,.OLNG)
 .. W $E($P($P(LNG,U,2),":",2),1,21)
 .. ;
 .. W ?50,"Interpreter required? ",$P($P(LNG,U,3),":",2)
 .. W !,?5,"Other languages spoken: ",$P(LNG,U,5)
 . ;
 . ;Display Preferred Language
 . I AG=4 W $P($P($$CLANG^AGED10B(AGPATDFN),U,4),":",2) Q
 . ;
 . ;Display Migrant information
 . I AG=5,$G(AGOPT(26))="Y" D  Q  ;AG*7.1*9 - Added reg parameter check
 .. N MIG,UPD
 .. S MIG=$$CMIG(AGPATDFN)
 .. W $P($P(MIG,U,3),":",2)
 .. W ?32,"Type: ",$E($P($P(MIG,U,4),":",2),1,23)
 .. S UPD=$P($P(MIG,U,2),":",2) W ?63 W:UPD]"" $J("(upd "_UPD_")",17)
 . ;
 . ;Display Homeless information
 . I AG=6,$G(AGOPT(27))="Y" D  Q  ;AG*7.1*9 - Added reg parameter check
 .. N HOM,UPD
 .. S HOM=$$CHOM(AGPATDFN)
 .. W $P($P(HOM,U,3),":",2)
 .. W ?32,"Type: ",$E($P($P(HOM,U,4),":",2),1,23)
 .. S UPD=$P($P(HOM,U,2),":",2) W ?63 W:UPD]"" $J("(upd "_UPD_")",17)
 . ;
 . ;Display Internet Access
 . I AG=7 D  Q
 .. N LSTUPD,LSTREC,ACCESS,WHERE,Y,WIEN
 .. S (LSTUPD,ACCESS,WHERE)=""
 .. ;
 .. ;Pull latest entry
 .. D
 ... S LSTUPD=$O(^AUPNPAT(DFN,81,"B",""),-1)
 ... Q:LSTUPD=""
 ... S LSTREC=$O(^AUPNPAT(DFN,81,"B",LSTUPD,""),-1)
 ... Q:LSTREC=""
 ... S ACCESS=$$GET1^DIQ(9000001.81,LSTREC_","_DFN_",",.02,"E")
 ... ;
 ... ;Get list of WHERE values
 ... S WHERE="",WIEN=0 F  S WIEN=$O(^AUPNPAT(DFN,81,LSTREC,1,WIEN)) Q:'WIEN  D
 .... S WHERE=WHERE_$S(WHERE="":"",1:", ")_$$GET1^DIQ(9000001.811,WIEN_","_LSTREC_","_DFN_",",.01,"I")
 ... ;S WHERE=$$GET1^DIQ(9000001.81,LSTREC_","_DFN_",",.03)
 ... S Y=LSTUPD X ^DD("DD") S LSTUPD=Y
 .. W ?25,ACCESS
 .. W ?32,"Where: ",$E(WHERE,1,23)
 .. W ?63 W:LSTUPD]"" $J("(upd "_LSTUPD_")",17)  ;AG*7.1*8 - Disabled
 . ;
 . ;Email Address
 . I AG=8 W $$GET1^DIQ(9000001,DFN_",",1802)
 . ;
 . ;Generic Health Permission
 . I AG=9 W $$GET1^DIQ(9000001,DFN_",",4001)
 . ;
 . ;Preferred Method
 . I AG=10 W $$GET1^DIQ(9000001,DFN_",",4002)
 . ;
 . ;Number in Household/Total Household Income/Household Income Period
 . I AG=11!(AG=12),AGOPT(22)="Y" W $$GET1^DIQ(DIC,DFN_",",DR,"E")
 . I AG=12,AGOPT(22)="Y" W ?40,"/  ",$$GET1^DIQ(9000001,DFN_",",8701,"E")
 ;
 W !,AGLINE("-")
 ;
 ;Error Checking/Display
 D FETCHERR^AGEDERR(AG("PG"),.MYERRS)
 S MYVARS("DFN")=DFN,MYVARS("FINDCALL")="",MYVARS("SELECTION")=$G(AGSELECT),MYVARS("SITE")=DUZ(2)
 D EDITCHEK^AGEDERR(.MYERRS,.MYVARS,1)
 Q
 ;
READ ;EP
 S DIR("?")="Enter free text"
 S DIR("?",1)="You may enter the item number of the field you wish to edit,"
 S DIR("?",2)="OR you can enter 'P#' where P stands for 'page' and '#' stands for"
 S DIR("?",3)="the page you wish to jump to, OR enter '^' to go back one page"
 S DIR("?",4)="OR, enter '^^' to exit the edit screens, OR RETURN to go to the next screen."
 S DIR(0)="FO"
 D ^DIR
 Q:$D(DTOUT)
 S:Y="/.,"!(Y="^^") DFOUT=1
 S:Y="" DLOUT=""
 S:Y="^" (DUOUT,Y)=""
 S:Y?1"?".E!(Y["^") (DQOUT,Y)=""
 Q:Y="P"
 I $E(Y,1)="p" S $E(Y,1)="P"
 I $E(Y,1)="P" D
 . S AG("ED")=+$P($E(Y,2,99),".")
 . I AG("ED")<1!(AG("ED")>10) D
 .. W *7,!!,"Use only pages 1 through 10."
 .. H 2
 .. K AG("ED")
 .. S AG("ERR")=""
 . I $D(AG("ED"))  D
 .. I AG("ED")>0&(AG("ED")<11)  D
 ... I AG("ED")=4 S AG("ED")="4A"
 ... I AG("ED")=5 S AG("ED")="BEA"
 ... I AG("ED")=6 S AG("ED")=13
 ... I AG("ED")=8 S AG("ED")=11
 ... I AG("ED")=7 S AG("ED")=8
 ... I AG("ED")=9 S AG("ED")="11A"
 ... I AG("ED")=10 S AG("ED")="10A"
 Q
 ;
MIG ;EP - EDIT Migrant Worker prompts
MIG1 ;
 N DEF,DIC,DLAYGO,DIR,AMIG,MIG,MIEN,MTYP,DA,ERROR,X,Y
 ;
 ;Get current value
 S DEF=$$CMIG(AGPATDFN)
 S MTYP=$P($P(DEF,U,4),":")
 S DEF=$P($P(DEF,U,3),":",2)
 S:DEF]"" DIR("B")=DEF
 ;
 S DIR(0)="SOA^Y:YES;N:NO"
 S DIR("A")="Migrant Worker?: " D ^DIR
 I $D(DIROUT)!$D(DTOUT)!$D(DUOUT) Q
 S MIG=$G(Y)
 ;
 ;If Null/Delete and no default show warning and ask again
 ;I MIG="",DEF="" W "??  Required" K DEF,DIC,DLAYGO,DIR,AMIG,MIG,MIEN,MTYP,DA,ERROR,X,Y G MIG1
 I MIG="",DEF="" Q   ;AG*7.1*9 - No longer required
 ;
 ;Define new entry and save
 S DIC="^AUPNPAT("_AGPATDFN_",84,",DA(1)=AGPATDFN
 S DIC(0)="L"
 S X=DT
 S DLAYGO="9000001.84",DIC("P")=DLAYGO
 I '$D(^AUPNPAT(AGPATDFN,84,0)) S ^AUPNPAT(AGPATDFN,84,0)="^9000001.84D^^"
 K DO,DD D FILE^DICN
 S (MIEN,DA)=+Y,DA(1)=AGPATDFN
 S AMIG(9000001.84,DA_","_DA(1)_",",".02")=$S(MIG'="":MIG,1:"@")
 S AMIG(9000001.84,DA_","_DA(1)_",",".03")=$S(((MIG="")!(MIG="N")):"@",1:MTYP)
 D FILE^DIE("","AMIG","ERROR")
 ;
 ;If a Null/delete ask again
 I MIG="" S DEF="" K DEF,DIC,DLAYGO,DIR,AMIG,MIG,MIEN,MTYP,DA,ERROR,X,Y G MIG1
 ;
 ;Migrant Worker Type - only do if "YES"
 I MIG="Y" D MTYPE(MIEN)
 ;
 Q
 ;
MTYPE(MIEN) ;EP - EDIT Migrant Worker Type prompt
MTYPE1 ;
 ;
 N CMTYP,DA,DR,DIE,DTOUT,MTYP,Y
 ;
 ;Retrieve current value
 S CMTYP=$$GET1^DIQ(9000001.84,MIEN_","_AGPATDFN_",",".03","I")
 ;
 S DIE="^AUPNPAT("_AGPATDFN_",84,"
 S DA=MIEN
 S DR=".03Type"
 D ^DIE
 I $D(DTOUT)!$D(Y) Q
 ;
 S MTYP=$$GET1^DIQ(9000001.84,MIEN_","_AGPATDFN_",",".03","E")
 I MTYP="",CMTYP]"" K CMTYP,DA,DR,DIE,DTOUT,MTYP,Y G MTYPE1
 ;I MTYP="" K CMTYP,DA,DR,DIE,DTOUT,MTYP,Y W "??  Required" G MTYPE1  ;AG*7.1*9 - No longer required
 ;
 Q
 ;
CMIG(AGPATDFN) ;Return the patients most recent Migrant information
 ;
 N MDT,MDTX,MIEN,MSTS,MSTSX,MTYP,MTYPX,Y
 ;
 S (MDT,MDTX,MIEN,MSTS,MSTSX,MTYP,MTYPX)=""
 S MDT=$O(^AUPNPAT(AGPATDFN,84,"B",""),-1)
 I MDT]"" S MIEN=$O(^AUPNPAT(AGPATDFN,84,"B",MDT,""),-1)
 S Y=MDT X ^DD("DD") S MDTX=Y
 I MIEN]"" S MSTS=$$GET1^DIQ(9000001.84,MIEN_","_AGPATDFN_",",".02","I")
 I MIEN]"" S MTYP=$$GET1^DIQ(9000001.84,MIEN_","_AGPATDFN_",",".03","I")
 I MIEN]"" S MSTSX=$$GET1^DIQ(9000001.84,MIEN_","_AGPATDFN_",",".02","E")
 I MIEN]"" S MTYPX=$$GET1^DIQ(9000001.84,MIEN_","_AGPATDFN_",",".03","E")
 ;
 Q MIEN_U_MDT_":"_MDTX_U_MSTS_":"_MSTSX_U_MTYP_":"_MTYPX
 ;
HOM ;EP - EDIT Homeless prompts
HOM1 ;
 N DIC,DLAYGO,DIR,AHOM,HOM,HIEN,HTYP,DA,ERROR,X,Y
 ;
 ;Get current value
 S DEF=$$CHOM(AGPATDFN)
 S HTYP=$P($P(DEF,U,4),":")
 S DEF=$P($P(DEF,U,3),":",2)
 S:DEF]"" DIR("B")=DEF
 ;
 S DIR(0)="SOA^Y:YES;N:NO"
 S DIR("A")="Homeless?: " D ^DIR
 I $D(DIROUT)!$D(DTOUT)!$D(DUOUT) Q
 S HOM=$G(Y)
 ;
 ;If Null/Delete and no default show warning and ask again
 ;I HOM="",DEF="" W "??  Required" K DIC,DLAYGO,DIR,AHOM,HOM,HIEN,HTYP,DA,ERROR,X,Y G HOM1
 I HOM="",DEF="" Q   ;AG*7.1*9 - No longer required
 ;
 ;Define new entry and save
 S DIC="^AUPNPAT("_AGPATDFN_",85,",DA(1)=AGPATDFN
 S DIC(0)="L"
 S X=DT
 S DLAYGO="9000001.85",DIC("P")=DLAYGO
 I '$D(^AUPNPAT(AGPATDFN,85,0)) S ^AUPNPAT(AGPATDFN,85,0)="^9000001.85D^^"
 K DO,DD D FILE^DICN
 S (HIEN,DA)=+Y,DA(1)=AGPATDFN
 S AHOM(9000001.85,DA_","_DA(1)_",",".02")=$S(HOM'="":HOM,1:"@")
 S AHOM(9000001.85,DA_","_DA(1)_",",".03")=$S(((HOM="")!(HOM="N")):"@",1:HTYP)
 D FILE^DIE("","AHOM","ERROR")
 ;
 ;If a Null/delete ask again
 I HOM="" S DEF="" K DIC,DLAYGO,DIR,AHOM,HOM,HIEN,HTYP,DA,ERROR,X,Y G HOM1
 ;
 ;Homeless Type - only do if "YES"
 I HOM="Y" D HTYPE(HIEN)
 ;
 Q
 ;
HTYPE(HIEN) ;EP - EDIT Homeless Type prompt
HTYPE1 ;
 N CHTYP,DA,DR,DIE,DTOUT,HTYP,Y
 ;
 ;Retrieve current value
 S CHTYP=$$GET1^DIQ(9000001.85,HIEN_","_AGPATDFN_",",".03","I")
 ;
 S DIE="^AUPNPAT("_AGPATDFN_",85,"
 S DA=HIEN
 S DR=".03Type"
 D ^DIE
 I $D(DTOUT)!$D(Y) Q
 ;
 S HTYP=$$GET1^DIQ(9000001.85,HIEN_","_AGPATDFN_",",".03","E")
 I HTYP="",CHTYP]"" K CHTYP,DA,DR,DIE,DTOUT,HTYP,Y G HTYPE1
 ;I HTYP="" K CMTYP,DA,DR,DIE,DTOUT,HTYP,Y W "?? Required" G HTYPE1  ;AG*7.1*9 - No longer required
 ;
 Q
 ;
CHOM(AGPATDFN) ;Return the patients most recent Homeless information
 ;
 N HDT,HDTX,HIEN,HSTS,HSTSX,HTYP,HTYPX,Y
 ;
 S (HDT,HDTX,HIEN,HSTS,HSTSX,HTYP,HTYPX)=""
 S HDT=$O(^AUPNPAT(AGPATDFN,85,"B",""),-1)
 I HDT]"" S HIEN=$O(^AUPNPAT(AGPATDFN,85,"B",HDT,""),-1)
 S Y=HDT X ^DD("DD") S HDTX=Y
 I HIEN]"" S HSTS=$$GET1^DIQ(9000001.85,HIEN_","_AGPATDFN_",",".02","I")
 I HIEN]"" S HTYP=$$GET1^DIQ(9000001.85,HIEN_","_AGPATDFN_",",".03","I")
 I HIEN]"" S HSTSX=$$GET1^DIQ(9000001.85,HIEN_","_AGPATDFN_",",".02","E")
 I HIEN]"" S HTYPX=$$GET1^DIQ(9000001.85,HIEN_","_AGPATDFN_",",".03","E")
 ;
 Q HIEN_U_HDT_":"_HDTX_U_HSTS_":"_HSTSX_U_HTYP_":"_HTYPX
 ;
PERM ; EP - Edit GENERIC HEALTH PERMISSION prompt
 ;
 N DIE,DA,DR
 S DIE="^AUPNPAT("
 S DA=DFN
 S DR="4001Do we have permission to send generic health information to your email address?"
 D ^DIE
 ;
 Q
 ;
PREF ; EP - Edit PREFERRED METHOD prompt
 ;
 N DIE,DA,DR
 S DIE="^AUPNPAT("
 S DA=DFN
 S DR="4002WHAT IS YOUR PREFERRED METHOD TO RECEIVE REMINDERS?"
 D ^DIE
 ;
 Q
 ;
 ; ****************************************************************
 ; ON LINES BELOW:
 ; PIECE 1= FLD LBL
 ; PIECE 2= FILE #
 ; PIECE 3= FLD #
1 ;
 ;;Ethnicity^2^6
 ;;Race^2^.06
 ;;Primary Language
 ;;Preferred Language
 ;;Migrant Worker?
 ;;Homeless?
 ;;Internet Access^9000001.81^.01
 ;;EMAIL ADDRESS^9000001^1802
 ;;GENERIC HEALTH PERMISSION^9000001^4001
 ;;PREFERRED METHOD^9000001^4002
 ;;Number in Household^9000001^.35
 ;;Total Household Income^9000001^.36
