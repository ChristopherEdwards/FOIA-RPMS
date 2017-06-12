APSPRCUI ;MSC/JS  QUERY APELON FOR RXNORM VALUE FOR DRUG NDC OR DRUG VUID ;11-Oct-2013 13:15;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1017**;Sep 23, 2004;Build 40
 ;
 ;     TAGS:
 ;     LIST    - List Drug file #50 entry RXNorm field
 ;     QUERY   - Query Apelon site for selected Drug file entry, defaults to NDC code, or VUID (if it exists)
 ;     UPONE   - Set Drug file entry RXCUI field with Apelon RXNorm value returned, or manually entered
 ;     UPALL   - Set All Drug file entries RXCUI field with Apelon RXNorm value returned
 ;     QRXNORM - Query Drug file entry passing parameter IEN50
 ;     SQUERY  - API called from PSSCOMMON input template to add RXNORM code for new Drug file entry
 ;     SUPALL  - Tasked Set All Drug file entries RXCUI field with Apelon RXNorm value returned
 ;     ONEUP   - Menu option - Set Drug file entry RXCUI field with Apelon RXNorm value returned, or manually entered
 ;
 Q  ; -- interactive use call tag MAIN
 ;
MAIN ;
 I $G(DUZ)="" S DUZ=.5,DUZ(0)="@"
 S U="^" D HOME^%ZIS
 S $P(LINE,"-",80)=""
 D NDC
 S NOWI=$$NOW^XLFDT S Y=NOWI X ^DD("DD") S NOWE=Y
 NEW DIR,X,Y
 K DIR,X,Y
 S DIR(0)="S^Q:Query;L:List File RXNorm Codes (STATS);O:Update One RXNorm Entry;A:Update ALL RXNorm Entries;X:Exit"
 S DIR("B")="X"
 W ! D ^DIR
 G EXIT:Y=0!($D(DIRUT))
 I Y="L" D LIST G MAIN
 I Y="Q" D QUERY G MAIN
 I Y="O" D UPONE G MAIN
 I Y="A" D UPALL G MAIN
 I Y="X" G EXIT
 G EXIT
 ;
LIST ;
 NEW DIR,X,Y
 S DIR(0)="Y",DIR("A")="List the Drug File RXNorm data",DIR("B")="Y"
 W ! D ^DIR
 G EXIT:Y=0!($D(DIRUT))
 I Y=1 D
 .W @IOF,!!,"DRUG FILE RXNORM LIST",?50,"DATE: ",NOWE,!,LINE,!,"DRUG"
 .NEW IEN50
 .S (IEN50,TOTAL,TOTRXY,TOTRXN,TOTNDCY,TOTNDCN)=0
 .F  S IEN50=$O(^PSDRUG(IEN50)) Q:IEN50=""  D
 ..Q:'$D(^PSDRUG(IEN50,0))
 ..NEW DRUGNM S DRUGNM=$$GET1^DIQ(50,IEN50,.01,"E") S DRUGNM=DRUGNM_" ("_IEN50_")"
 ..NEW NDC S NDC=$$GET1^DIQ(50,IEN50,31,"E")
 ..NEW RXNORM S RXNORM=$$GET1^DIQ(50,IEN50,9999999.27,"E")
 ..I $G(RXNORM)]"" S TOTRXY=TOTRXY+1
 ..I $G(RXNORM)="" S TOTRXN=TOTRXN+1
 ..I $G(NDC)]"" S TOTNDCY=TOTNDCY+1
 ..I $G(NDC)="" S TOTNDCN=TOTNDCN+1
 ..W !,"DRUG: ",DRUGNM
 ..W !?5,"NDC: ",NDC,?35,"RXNorm: ",RXNORM
 ..S TOTAL=TOTAL+1
 ..Q
 W !!,"TOTAL DRUG ENTRIES WITH RXNORM CODES: ",TOTRXY
 W !,"TOTAL DRUG ENTRIES WITH NO RXNORM CODES: ",TOTRXN
 W !,"TOTAL DRUG ENTRIES WITH NDC CODES: ",TOTNDCY
 W !,"TOTAL DRUG ENTRIES WITH NO NDC CODES: ",TOTNDCN
 W !!,"TOTAL DRUG ENTRIES: ",TOTAL
 Q
 ;
QUERY ;
 NEW DIR,X,Y,IEN50
 S DIR(0)="P^50:EMZ",DIR("A")="Enter DRUG file entry"
 W ! D ^DIR
 Q:$D(DIRUT)
 S IEN50=+Y
 Q:'$D(^PSDRUG(IEN50,0))
 NEW DRUGNM S DRUGNM=$$GET1^DIQ(50,IEN50,.01,"E") S DRUGNM=DRUGNM_" ("_IEN50_")"
 NEW NDC S NDC=$$GET1^DIQ(50,IEN50,31,"E") S:NDC="" NDC="NONE"
 NEW RXNORM S RXNORM=$$GET1^DIQ(50,IEN50,9999999.27,"E") S:RXNORM="" RXNORM="NONE"
 W !,"DRUG: ",DRUGNM,!,?30,"NDC:",?40,NDC,!?30,"RXNorm:",?40,RXNORM
 Q
 ; -- if APSPDIS parameter set, make a 'quiet' call
SQUERY(IEN50,APSPDIS) ;
 N RXNORM,NDC,NDCPAR
 S RXNORM=""
 I '$D(^PSDRUG(IEN50,0))="" Q ""
 D NDC
 I NDCPAR="P" S NDC=$$NDC^APSPES4(IEN50)
 E  S NDC=$$GET1^DIQ(50,IEN50,31,"E") S:NDC="" NDC="NONE"
 I NDCPAR="L" I NDC="NONE" D  ; alternate lookup NDC code from VA PRODUCT file when local NDC field #31 is null
 .S NDC=$$NDC^APSPES4(IEN50)
 .S:NDC="" NDC="NONE"
 I NDC="NONE" Q "-1^NDC not found for DRUG entry"
 NEW DRUGNM S DRUGNM=$$GET1^DIQ(50,IEN50,.01,"E") S DRUGNM=DRUGNM_" ("_IEN50_")"
 NEW NDCAP S NDCAP=NDC
 S RXNORM=$$GET1^DIQ(50,IEN50,9999999.27,"E")
 D APELON(.RXNORM)
 Q RXNORM
 ;
 ; -- KIDS Post-Install Update - Queued update for all Drug file entries
SUPALL ;
 N APSPARR
 S APSPARR(1)=""
 S APSPARR(2)="Checking the Apelon utility installation..."
 S APSPARR(3)=""
 D MES^XPDUTL(.APSPARR) K APSPARR
 ;
 NEW APELYES S APELYES=$$TEST^CIAUOS("DI2RX^BSTSAPI")
 ;
 N APSPARR
 S APSPARR(1)=""
 I APELYES S APSPARR(2)="Tasking DRUG File #50 RXCUI field update..."
 E  S APSPARR(2)="The Apelon utility has not been installed, aborting update..."
 S APSPARR(3)=""
 D MES^XPDUTL(.APSPARR) K APSPARR
 Q:APELYES=0
 ;-- schedule TM job to run 'NOW' --
 S ZTIO=""
 ;S ZTDTH=$H
 S ZTRTN="DQ^APSPRCUI"
 S ZTDESC="Tasked Update FILE #50 'RXCUI' field from KIDs build "_$G(XPDNM)
 I $G(XPDNM)]"" S ZTSAVE("XPDNM")=""
 D ^%ZTLOAD K IO("Q")
 D HOME^%ZIS
 N APSPARR
 S APSPARR(1)=""
 S APSPARR(2)="The update for DRUG file field RXCUI"_$S($G(ZTSK)]"":" is tasked #"_ZTSK,1:" has NOT been tasked")
 S APSPARR(3)=""
 D MES^XPDUTL(.APSPARR) K APSPARR
 K ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 Q
 ;
NDC ; -- check XPAR parameter APSP RXNORM NDC LOOKUP for NDC lookup method, default value is 'P' - VA PRODUCT NDC lookup
 S NDCDIV=$$GET^XPAR("DIV","APSP RXNORM NDC LOOKUP")
 S NDCSYS=$$GET^XPAR("SYS","APSP RXNORM NDC LOOKUP")
 I NDCDIV="" S NDCPAR=NDCSYS S:NDCPAR="" NDCPAR="P" Q
 I NDCDIV]"" D
 .I $G(DUZ(2))="" S NDCPAR=NDCSYS S:NDCPAR="" NDCPAR="P" Q
 .NEW XPIEN
 .S XPIEN="",XPIEN=$O(^XTV(8989.51,"B","APSP RXNORM NDC LOOKUP",XPIEN))
 .I XPIEN="" S NDCPAR="P" Q
 .NEW XPAC,FLG
 .S XPAC=""
 .S FLG=0
 .F  S XPAC=$O(^XTV(8989.5,"AC",XPIEN,XPAC)) Q:XPAC=""!(FLG=1)  D
 ..I XPAC[";DIC(4," I XPAC[$G(DUZ(2)) S NDCPAR=NDCDIV,FLG=1 Q
 .S:$G(NDCPAR)="" NDCPAR=NDCSYS S:NDCPAR="" NDCPAR="P"
 Q
 ;
TMPGBL(X) ;EP
 K ^TMP("APSPRCUI",$J) Q $NA(^($J))
 ;
DQ ; -- tasked update from KIDs Post-Install for ALL Drug file entries job starts here
 S APSPDIS=1 ; -- skip the Apelon call dialog
 D NDC
 NEW IEN50,RXNORM
 S IEN50=0,RXNORM=""
 F  S IEN50=$O(^PSDRUG(IEN50)) Q:IEN50=""  D
 .Q:'$D(^PSDRUG(IEN50,0))
 .I NDCPAR="P" S NDC=$$NDC^APSPES4(IEN50)
 .E  S NDC=$$GET1^DIQ(50,IEN50,31,"E") S:NDC="" NDC="NONE"
 .I NDCPAR="L" I NDC="NONE" D  ; alternate lookup NDC code from VA PRODUCT file when local NDC field #31 is null
 ..S NDC=$$NDC^APSPES4(IEN50)
 ..S:NDC="" NDC="NONE"
 .I NDC="NONE" Q
 .NEW NDCAP S NDCAP=NDC
 .D APELON(RXNORM)
 K APSPDIS,NDC,NDCDIV,NDCPAR,NDCSYS
 Q
 ;
UPONE ;
 W @IOF,!!
 W !,"This option will update a DRUG file entry RXNorm field using the Apelon Tool",!,"or alternatively by data entry.",!
 NEW DIR,X,Y
 K DIR,X,Y
 S DIR(0)="Y",DIR("A")="Do you want to update the Drug File RXNorm data using the Apelon Tool",DIR("B")="Y"
 S DIR("?")="Enter 'NO' to manually enter the RXNorm data, or '^' to quit."
 W ! D ^DIR
 Q:$D(DIRUT)
 S USEAP=Y
 I USEAP I '$$TEST^CIAUOS("DI2RX^BSTSAPI") W !!,"The Apelon utility has not been installed on this account, aborting update." Q
 K DIR,X,Y
 S DIR(0)="P^50:EMZ",DIR("A")="Enter DRUG file entry"
 W ! D ^DIR
 Q:$D(DIRUT)
 K IEN50 S IEN50=+Y
 Q:'$D(^PSDRUG(IEN50,0))
 D NDC
 W:'USEAP !!,$S(NDCPAR="L":"Using local DRUG file NDC data...",1:"Using VA PRODUCT file NDC data...")
 W:USEAP !!,$S(NDCPAR="L":"Using local DRUG file NDC data for Apelon query...",1:"Using VA PRODUCT file NDC value used for Apelon query...")
 NEW DRUGNM S DRUGNM=$$GET1^DIQ(50,IEN50,.01,"E") S DRUGNM=DRUGNM_" ("_IEN50_")"
 NEW NDC
 I NDCPAR="P" S NDC=$$NDC^APSPES4(IEN50)
 E  S NDC=$$GET1^DIQ(50,IEN50,31,"E") S:NDC="" NDC="NONE"
 I NDCPAR="L" I NDC="NONE" D  ; alternate lookup NDC code from VA PRODUCT file when local NDC field #31 is null
 .W !,"Local NDC field not set, alternately using NDC code from VA PRODUCT file...",!
 .S NDC=$$NDC^APSPES4(IEN50)
 S:NDC="" NDC="NONE"
 NEW RXNORM S RXNORM=$$GET1^DIQ(50,IEN50,9999999.27,"E") S:RXNORM="" RXNORM="NONE"
 W !,DRUGNM,?55,NDC
 I USEAP I NDC="NONE" W !!,"No NDC code found for this entry, cannot query Apelon for update.",! Q
 NEW NDCAP S NDCAP=NDC
 I 'USEAP D FLDEDIT(IEN50)
 I USEAP D APELON(RXNORM)
 Q
 ;
UPALL ;
 I '$$TEST^CIAUOS("DI2RX^BSTSAPI") W !!,"The Apelon utility has not been installed on this account, aborting update." Q
 NEW DIR,X,Y
 K DIR,X,Y
 S DIR(0)="Y",DIR("A")="Update the Drug File RXNorm data for ALL entries",DIR("B")="Y"
 W ! D ^DIR
 G EXIT:Y=0!($D(DIRUT))
 D NDC
 NEW IEN50
 S IEN50=0
 F  S IEN50=$O(^PSDRUG(IEN50)) Q:IEN50=""  D
 .Q:'$D(^PSDRUG(IEN50,0))
 .NEW DRUGNM S DRUGNM=$$GET1^DIQ(50,IEN50,.01,"E") S DRUGNM=DRUGNM_" ("_IEN50_")"
 .W !!,$S(NDCPAR="L":"Checking local DRUG file NDC data for Apelon query...",1:"VA PRODUCT file NDC value used for Apelon query...")
 .NEW NDC
 .I NDCPAR="P" S NDC=$$NDC^APSPES4(IEN50)
 .E  S NDC=$$GET1^DIQ(50,IEN50,31,"E") S:NDC="" NDC="NONE"
 .I NDCPAR="L" I NDC="NONE" D  ; alternate lookup NDC code from VA PRODUCT file when local NDC field #31 is null
 ..W !,"Local NDC field not set, alternately using NDC code from VA PRODUCT file...",!
 ..S NDC=$$NDC^APSPES4(IEN50)
 .S:NDC="" NDC="NONE"
 .NEW RXNORM S RXNORM=$$GET1^DIQ(50,IEN50,9999999.27,"E") S:RXNORM="" RXNORM="NONE"
 .I NDC="NONE" W !,"Skipping entry ",DRUGNM," no NDC code",! Q
 .W !,DRUGNM,?55,NDC
 .NEW NDCAP S NDCAP=NDC
 .D APELON(RXNORM)
 Q
 ; Query DRUG file entry, returns IEN ^ Drug Name ^ NDC Code ^ RXNorm
 ; Input = DRUG file #50 IEN
QRXNORM(RET,IEN50) ;
 I $G(IEN50)="" Q "-1^Missing Drug file #50 IEN parameter"
 I '$D(^PSDRUG(IEN50,0))="" Q ""
 NEW INFO50
 S INFO50=0
 D NDC
 I NDCPAR="P" S NDC=$$NDC^APSPES4(IEN50)
 E  S NDC=$$GET1^DIQ(50,IEN50,31,"E") S:NDC="" NDC="NONE"
 I NDCPAR="L" I NDC="NONE" D  ; alternate lookup NDC code from VA PRODUCT file when local NDC field #31 is null
 .S NDC=$$NDC^APSPES4(IEN50)
 .S:NDC="" NDC="NONE"
 NEW DRUGNM S DRUGNM=$$GET1^DIQ(50,IEN50,.01,"E") S DRUGNM=DRUGNM_" ("_IEN50_")"
 NEW RXNORM S RXNORM=$$GET1^DIQ(50,IEN50,9999999.27,"E") S:RXNORM="" RXNORM="NONE"
 S INFO50=$G(IEN50)_U_$G(DRUGNM)_U_$G(NDC)_U_$G(RXNORM)
 Q INFO50
 ;
FLDEDIT(IEN50) ; -- update RXCUI field with data entry
 NEW DIR,X,Y,RXCUI
 K DIR,X,Y
 S DIR(0)="N^1:9999999",DIR("A")="Enter the RXNorm numeric code"
 W ! D ^DIR
 Q:$D(DIRUT)
 S RXCUI=Y
 NEW DA,DIE,DR,X,Y
 K DA,DIE,DR,X,Y
 S DA=IEN50
 S DIE="^PSDRUG("
 S DR="9999999.27///^S X=RXCUI"
 D ^DIE
 S RXNORM=$$GET1^DIQ(50,IEN50,9999999.27,"E") S:RXNORM="" RXNORM="NONE"
 W !,$S(RXNORM=RXCUI:"ENTRY UPDATED",1:"ENTRY *NOT* UPDATED")
 I RXNORM=RXCUI W " - RXCUI field set to:    ",RXNORM
 Q
 ;
APELON(RXNORM) ; -- query Apelon site for drug NDC code, if RXCUI data returned updated DRUG file entry(s)
 ;               -- if $G(APSPDIS)="", display dialog
 N NDCAPL,RXCUI,IN,ZDATA,UPOK,VUID,VUIDOK
 S RXNORM=""
 Q:$G(NDCAP)=""
 S UPOK=0
 S NDCAP=$$STRIP^XLFSTR(NDCAP,"-")
 S NDCAPL=$L(NDCAP) I NDCAPL>11 I $E(NDCAP,1)=0 S NDCAP=$E(NDCAP,2,999) ; strip off leading 0
 W:$G(APSPDIS)="" !,"Querying Apelon site..."
 S IN=NDCAP_"^N" S ZDATA=$$DI2RX^BSTSAPI(IN)
 I ZDATA="" D
 .W:$G(APSPDIS)="" "NDC query failed, trying VUID query..."
 .D VUID
 .I VUIDOK=0 W:$G(APSPDIS)="" !,"VUID code not onfile, skipping entry"
 .I VUIDOK=1 D
 ..;Input (from DI2RX^BSTSAPIF)
 ..;  IN - P1 - The exact term to lookup
 ..;     - P2 - Lookup Type (N-NDC,V-VUID)
 ..S IN=VUID_"^V" S ZDATA=$$DI2RX^BSTSAPI(IN)
 ;First try for trade name (3rd piece), if not there use the data in field 1
 S RXCUI=$P(ZDATA,U,3)
 S TTY=$P(ZDATA,U,5)
 I RXCUI="" S RXCUI=$P(ZDATA,U,1)
 I $G(RXCUI)]"" S UPOK=1
 I UPOK=0 Q
 I UPOK=1 D
 .NEW DA,DIE,DR,X,Y
 .S DA=IEN50
 .S DIE="^PSDRUG("
 .S DR="9999999.27///^S X=RXCUI"
 .D ^DIE
 .S RXNORM=$$GET1^DIQ(50,IEN50,9999999.27,"E") S:RXNORM="" RXNORM="NONE"
 .W:$G(APSPDIS)="" $S(RXNORM=RXCUI:"ENTRY UPDATED",1:"ENTRY *NOT* UPDATED")
 .I RXNORM=RXCUI W:$G(APSPDIS)="" " - RXCUI field set to:    ",RXNORM
 .S RXNORM=RXCUI_U_TTY
 Q
 ;
VUID ; -- alternate Drug VUID lkup here if no NDC available
 S VUIDOK=0
 N VAPNAME,NDNODE,PSNF
 S NDNODE=$G(^PSDRUG(IEN50,"ND")),VAPNAME=$P(NDNODE,U,2)
 Q:VAPNAME=""
 S PSNF="",PSNF=$O(^PSNDF(50.68,"B",VAPNAME,PSNF))
 Q:PSNF=""
 N VUIDND,VUIDMSTR
 S VUIDND=$G(^PSNDF(50.68,PSNF,"VUID"))
 Q:VUIDND=""
 S VUID=$P(VUIDND,U,1),VUIDMSTR=$P(VUIDND,U,2)
 Q:VUID=""!(VUIDMSTR="")
 I VUIDMSTR=1 I $L(VUID)=7 S VUIDOK=1
 Q
 ;
ONEUP ; -- XQ menu option to update RXNorm field for DRUG file entry
 S U="^" D HOME^%ZIS
 NEW USEAP,IEN50,NDC,NDCDIV,NDCSYS,NDCPAR,DRUGNM
 W @IOF,!!
 W !,"This option will update a DRUG file entry RXNorm field using the Apelon Tool",!,"or alternatively by data entry.",!
 NEW DIR,X,Y
 K DIR,X,Y
 S DIR(0)="Y",DIR("A")="Do you want to update the Drug File RXNorm data using the Apelon Tool",DIR("B")="Y"
 S DIR("?")="Enter 'NO' to manually enter the RXNorm data, or '^' to quit."
 W ! D ^DIR
 G EXIT:$D(DIRUT)
 S USEAP=Y
 I USEAP I '$$TEST^CIAUOS("DI2RX^BSTSAPI") W !!,"The Apelon utility has not been installed on this account, aborting update." G EXIT
 K DIR,X,Y
 S DIR(0)="P^50:EMZ",DIR("A")="Enter DRUG file entry"
 W ! D ^DIR
 G EXIT:$D(DIRUT)
 K IEN50 S IEN50=+Y
 I '$D(^PSDRUG(IEN50,0)) W !!,"DRUG file entry not available for editing",! G ONEUP
 D NDC
 W:'USEAP !!,$S(NDCPAR="L":"Using local DRUG file NDC data...",1:"Using VA PRODUCT file NDC data...")
 W:USEAP !!,$S(NDCPAR="L":"Using local DRUG file NDC data for Apelon query...",1:"Using VA PRODUCT file NDC value used for Apelon query...")
 NEW DRUGNM S DRUGNM=$$GET1^DIQ(50,IEN50,.01,"E") S DRUGNM=DRUGNM_" ("_IEN50_")"
 NEW NDC
 I NDCPAR="P" S NDC=$$NDC^APSPES4(IEN50)
 E  S NDC=$$GET1^DIQ(50,IEN50,31,"E") S:NDC="" NDC="NONE"
 I NDCPAR="L" I NDC="NONE" D  ; alternate lookup NDC code from VA PRODUCT file when local NDC field #31 is null
 .W !,"Local NDC field not set, alternately using NDC code from VA PRODUCT file...",!
 .S NDC=$$NDC^APSPES4(IEN50)
 S:NDC="" NDC="NONE"
 NEW RXNORM S RXNORM=$$GET1^DIQ(50,IEN50,9999999.27,"E") S:RXNORM="" RXNORM="NONE"
 W !,DRUGNM,?55,NDC
 I USEAP I NDC="NONE" W !!,"No NDC code found for this entry, cannot query Apelon for update.",! G ONEUP
 NEW NDCAP S NDCAP=NDC
 I 'USEAP D FLDEDIT(IEN50)
 I USEAP D APELON(RXNORM)
 NEW DIR,X,Y
 S DIR(0)="E",DIR("A")="Press RETURN to continue" W !! D ^DIR
 G ONEUP
 ;
EXIT ;
 K DIRUT,IN,LINE,NOWE,NOWI,TOTAL,TOTNDCY,TOTNDCN,TOTRXN,TOTRXY,VUIDOK,IEN50,ZDATA
 K APSPDIS,NDC,NDCAPL,UPOK,RXCUI,NDCDIV,NDCSYS,NDCPAR,USEAP
 Q
ROUTES ;Enter old SNOMED medication routes
 N ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK,DIR
 S ZTRTN="UPROUTE^APSPRCUI",ZTIO="",ZTSAVE("DUZ")=""
 W !,"Tasking MEDICATION ROUTE #51.2 SNOMED CODE Update"
 S ZTDESC="Store SNOMED on med routes mapped to standard route file"
 D ^%ZTLOAD
 I $G(ZTSK) D
 .W !!,"A task has been queued in the background."
 .W !,"  The task number is "_$G(ZTSK)_"."
 Q
UPROUTE ;Update local medication routes that are mapped
 N MEDIEN,PSSDMRNW,PSSMRNM,SNOMED,ZDATA,IN,ERR,FDA,IENS,FNUM
 S MEDIEN=0  F  S MEDIEN=$O(^PS(51.2,MEDIEN)) Q:'+MEDIEN  D
 .S PSSDMRNW=$P($G(^PS(51.2,MEDIEN,1)),"^")
 .Q:PSSDMRNW=""
 .S PSSMRNM=$P($G(^PS(51.23,PSSDMRNW,0)),"^")
 .S IN=PSSMRNM_"^32774" S ZDATA=$$ASSOC^BSTSAPI(IN)
 .S SNOMED=$P(ZDATA,U,1)
 .S FNUM=51.2
 .S IENS=MEDIEN_","
 .S FDA=$NA(FDA(FNUM,IENS))
 .S @FDA@(9999999.01)=SNOMED
 .D FILE^DIE("E","FDA","ERR")
 Q
