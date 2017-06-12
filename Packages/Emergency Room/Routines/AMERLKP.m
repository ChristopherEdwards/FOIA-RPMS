AMERLKP ;GDIT/HS/ALA-Patient Lookup ; 16 Oct 2013  7:49 AM
 ;;3.0;ER VISIT SYSTEM;**5**;MAR 03, 2009;Build 14
 ;
SCAN ;EP
 ;
 NEW DIR,X,Y,TEXT,TYPE,II,BN,QFL,%H,%I
 ;
 S DIR("A")="Enter patient NAME, DOB, or LOCAL CHART NUMBER"
 S DIR(0)="F^3:30"
 D ^DIR
 ;
 ;NOTE: Since "DILIST" is used by the DIC calls it must use $J and not UID.
 K ^TMP("DILIST",$J)
 S TEXT=Y
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AMERLKP D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S TYPE=""
 ;
 ;Look for a DOB
 I $$DATE(TEXT)'="" S TEXT=$$DATE(TEXT),TYPE="D"
 ;
 ;If no type of search was passed, the lookup will have to be through all cross-references
 I TYPE="" D
 . ;Change text to all uppercase
 . NEW FILE,FIELD,XREF,FLAGS
 . S TEXT=$$UP^XLFSTR(TEXT)
 . S FILE=9000001,FIELD=".01",XREF="",FLAGS="PM"
 . D LKUP
 ;
 ;If the type is 'D', do a date of birth lookup
 I TYPE="D" D
 . S FILE=2,FIELD=.03,XREF="ADOB",FLAGS="P"
 . D LKUP
 ;
 ; For each patient found in the search, get the list data
 S BN=0,QFL=0,II=0
 F  S BN=$O(^TMP("DILIST",$J,BN)) Q:'BN  D  Q:(QFL'=0)
 . NEW DFN,NAME,AUPDICW,ALIAS,AMXX,DIC
 . S DFN=$P(^TMP("DILIST",$J,BN,0),"^",1)
 . S NAME=$$GET1^DIQ(9000001,DFN_",",.01,"E")
 . S AUPDICW="D IHSDUPE^AUPNLKID D ^AUPNLKID"
 . S Y=DFN,II=II+1
 . ;
 . ;Perform audit log call
 . D LOG^AMERBUSA("P","Q","AMERLKP","AMER: Scan Patient Names or Chart Numbers",DFN)
 . ;
 . ;Display the patient information
 . I TEXT?1A.E,$E(NAME,1,$L(TEXT))'=TEXT S ALIAS=$$ALIAS(DFN,TEXT)
 . S AMXX=^DPT(DFN,0),DIC="^DPT("
 . W !,II_".  "_$S($G(ALIAS)'="":ALIAS_"  "_NAME,1:NAME) X AUPDICW
 . I II#5=0 S QFL=$$ASK(II)
 ;
 ;Display the item
 I QFL>0 D
 . NEW DFN,NAME,AMXX,Y,AUPDICW,DIC,DIR,X,Y
 . S DFN=$P(^TMP("DILIST",$J,QFL,0),U,1),NAME=$P(^DPT(DFN,0),U,1)
 . S AMXX=^DPT(DFN,0),DIC="^DPT(",Y=DFN
 . S AUPDICW="D IHSDUPE^AUPNLKID D ^AUPNLKID"
 . W !!,NAME X AUPDICW
 ;
 ;Display prompt to continue
 W !! S DIR(0)="E",DIR("A")="Press 'Return to continue"
 D ^DIR
 ;
DONE ;
 K ^TMP("DILIST",$J)
 Q
 ;
LKUP D FIND^DIC(FILE,"",FIELD,FLAGS,TEXT,"",XREF,"","","","ERROR")
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 Q
 ;
ASK(II) ;Patient Prompt
 NEW DA,DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 S DIR(0)="FAO^0:5",DIR("A")="CHOOSE 1-"_II_": "
 D ^DIR
 I Y="^" S Y="-1" Q Y
 I Y'?1N.N S Y="0"
 Q Y
 ;
ALIAS(PTIEN,TEXT) ;EP
 ; Does this patient's alias match the TEXT?
 N IEN,ALIAS,ALFND
 S IEN=0,ALFND=""
 F  S IEN=$O(^DPT(PTIEN,.01,IEN)) Q:'IEN!ALFND  D
 . S ALIAS=$$GET1^DIQ(2.01,IEN_","_PTIEN_",",.01,"E")
 . I $E(ALIAS,1,$L(TEXT))=TEXT S ALFND=ALIAS
 Q ALFND
 ;
DATE(DATE) ;EP - Convert standard date/time to a FileMan date/time
 ;Input
 ;  DATE - In a standard format
 ;Output
 ;  -1 is if it couldn't convert to a FileMan date
 ;  otherwise a standard FileMan date
 NEW %DT,X,Y
 I DATE[":" D
 . I DATE["/",$L(DATE," ")=3 S DATE=$P(DATE," ",1)_"@"_$P(DATE," ",2)_$P(DATE," ",3) Q
 . I $L(DATE," ")=3 S DATE=$P(DATE," ",1,2)_"@"_$P(DATE," ",3)
 . I $L(DATE," ")>3 S DATE=$P(DATE," ",1,3)_"@"_$P(DATE," ",4,99)
 S %DT="TS",X=DATE D ^%DT
 I Y=-1 S Y=""
 ;
 Q Y
