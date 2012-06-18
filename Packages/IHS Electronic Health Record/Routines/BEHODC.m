BEHODC ;MSC/IND/PLS - TIU Dictation Support ;29-Oct-2007 12:58;DKM
 ;;1.1;BEH COMPONENTS;**040001**;Mar 20, 2007
 ;=================================================================
 ; Return the list of titles defined in the Parameter File and
 ; accessible to the user.
GDTITLES(DATA) ;
 N ARY,PARAM,CNT,LP,TITLEIEN,ENT
 K DATA
 S CNT=0,LP=0
 S PARAM="BEHODC DICTATION NOTE TITLES"
 S ENT=$$ENT^CIAVMRPC(PARAM,.ENT)
 D GETLST^XPAR(.ARY,ENT,PARAM,.FMT,.ERR)
 I $G(ERR) K ARY S DATA=ERR
 E  D
 .S DATA=$$TMPGBL^CIAVMRPC
 .F  S LP=$O(ARY(LP)) Q:LP<1  D
 ..S TITLEIEN=+$P(ARY(LP),U,2)
 ..I $$CANENTR^TIULP(TITLEIEN)&($$CANPICK^TIULP(TITLEIEN)) D
 ...S CNT=CNT+1,@DATA@(CNT)="s"_TITLEIEN_U_$$DOCNAME^TIUPLST(TITLEIEN)
 Q
 ; Returns true if Title is part of the Dictated Documents class
ISDTITL(IEN) ;
 Q $P($G(^TIU(8925.1,IEN,0)),U,4)="DOC"
 ;Q $$UP^XLFSTR($$DOCNAME^TIUPLST(+$$DOCCLASS^TIULC1(IEN)))="DICTATED DOCUMENTS"
 ; EP: Entry point for the tasked background processor to loop thru files
 ; in a system directory
BATCH N SRCD,ARCD,PRBD,FILE,MAXLN
 S SRCD=$$GET^XPAR("ALL","BEHODC SOURCE FOLDER")  ; source directory
 S ARCD=$$GET^XPAR("ALL","BEHODC ARCHIVE FOLDER")  ; archive directory
 S PRBD=$$GET^XPAR("ALL","BEHODC PROBLEM FOLDER")  ; problem directory
 S MAXLN=+$$GET^XPAR("ALL","BEHODC MAXIMUM LINES")  ; maximum lines for document
 S MAXLN=$S(MAXLN:MAXLN,1:500)   ;(default to 500)
 S FILE="*.txt"  ;file extension
 D DIR^CIAUOS(SRCD_FILE,100)
 F  S FILE=$O(^UTILITY("DIR",$J,FILE)) Q:FILE=""  D
 .Q:FILE=".profile"
 .D IMPORT(SRCD,FILE),RENAME^CIAUOS(SRCD_FILE,ARCD_$P(FILE,";")):ARCD'="",DELETE^CIAUOS(SRCD_FILE):ARCD=""
 Q
IMPORT(SRCD,FN) ;
 N FILE
 S FILE=SRCD_FN  ;build full filename
 D GETFILE(FILE)  ; put report text into TIU file
 Q
 ; EP: Used by background processor to file a document
GETFILE(FILE) ;
 ; CODE TAKEN FROM TIUUPLD
 ;API will open FILE in read-only state
 ;Uses 'Captioned Headers'
 N EOM,BUFIEN,TIUERR,TIUHDR,TIULN,TIUSRC,X
 I '$D(TIUPRM0)!'$D(TIUPRM1) D SETPARM^TIULE
 S TIUSRC=$P($G(TIUPRM0),U,9),EOM=$P($G(TIUPRM0),U,11)
 S TIUSRC="H"   ;DEFAULT TO HFS
 S TIUHDR=$P(TIUPRM0,U,10)
 S BUFIEN=$$MAKEBUF^TIUUPLD
 D HFS(FILE,BUFIEN)
 I +$O(^TIU(8925.2,BUFIEN,"TEXT",0))>0,'+$G(TIUERR) D FILE(BUFIEN)
 I +$O(^TIU(8925.2,BUFIEN,"TEXT",0))'>0!+$G(TIUERR) D BUFPURGE^TIUPUTC(BUFIEN)
GETFILEX Q
HFS(FILE,DA) ;Read HFS File and Store in Buffer
 N TIUI,X,$ET,XQA,XQAMSG
 S $ET="",@$$TRAP^CIAUOS("HFSERR^BEHODC"),TIUI=0
 D OPEN^CIAUOS(.FILE,"R")
 F  Q:$$READ^CIAUOS(.X,FILE)  Q:$E(X,1,$L(EOM))=EOM!(X="^")!(X="^^")  Q:TIUI>MAXLN  D
 .S TIUI=TIUI+1
 .S ^TIU(8925.2,DA,"TEXT",TIUI,0)=$$STRIP^TIUUPLD(X)
 S ^TIU(8925.2,DA,"TEXT",0)="^^"_$G(TIUI)_"^"_$G(TIUI)_"^"_DT_"^^^^"
 I TIUI>MAXLN D
 .K ^TIU(8925.2,DA,"TEXT")
 .S XQA("G.BEHODC PROBLEM FILE")=""
 .S XQAMSG="The "_FILE_" has exceeded the line limit for an uploaded TIU document."
 .D SETUP^XQALERT
HFSERR D CLOSE^CIAUOS(.FILE)
 ; Move problem file to problem directory if defined
 D:TIUI>MAXLN&(PRBD'="") RENAME^CIAUOS(SRCD_FILE,PRBD_$P(FILE,";"))
 Q
 ; File the document
FILE(DA) ;
 ; Completes upload transaction, invokes filer/router
 N DIE,DR,ZTIO,ZTDTH,ZTSAVE,ZTRTN,ZTDESC
 I '$D(^TIU(8925.2,+DA,0)) G FILEX
 S DIE="^TIU(8925.2,",DR=".04////"_$$NOW^TIULC D ^DIE
 ; Task background filer/router to process buffer record
 S ZTIO="",ZTDTH=$H,ZTSAVE("DA")=""
 S ZTRTN=$S($P(TIUPRM0,U,16)="D":"MAIN^TIUPUTD",1:"MAIN^TIUPUTC")
 S ZTDESC="TIU Document Filer"
 ; If filer is NOT designated to run in the foreground, queue it
 I '+$P(TIUPRM0,U,18) D  G FILEX
 . D ^%ZTLOAD
 . ;W !,$S($D(ZTSK):"Filer/Router Queued!",1:"Filer/Router Cancelled!")
 ; Otherwise, run the filer in the foreground
 W !!,"File Transfer Complete--Now Filing Records..."
 D @ZTRTN
FILEX Q
