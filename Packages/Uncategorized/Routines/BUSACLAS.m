BUSACLAS ;GDIT/HS/BEE-IHS USER SECURITY AUDIT Cache Class Compiler ; 31 Jan 2013  9:53 AM
 ;;1.0;IHS USER SECURITY AUDIT;;Nov 05, 2013;Build 65
 ;
 Q
 ;
EN Q
 ;
 ; Main entry point - interactive
EXPORT ;
 N CNT,ERR,EXEC,I,MASK,STREAM,XML,NAME,B64
 K CLASSES
 S MASK="" F  D  Q:$G(MASK)=""
 . NEW DIR,X,Y
 . S DIR(0)="F"
 . S DIR("A")="Class"
 . D ^DIR
 . S MASK=$S(X="^":"",1:X)
 . Q:MASK=""
 . S:MASK'?1.E1".CLS"&(MASK'?1.E1".cls") MASK=MASK_".CLS"
 . S CLASSES(MASK)=""
 ;
 Q:'$D(CLASSES)
 ; Create a new global-based character stream
EXPGO ;
 ; Create new record in 9002319.05 with IEN of REC
 ; Populate Name (not sure what it should be), Date/Time, and set status to I
 K DO,DA S DIC=9002319.05,DLAYGO=9002319.05,DIC(0)="L",X=$S($G(NAME)'="":NAME,1:"New Record for "_$H)
 S DIC("DR")=".01////"_X_";1.02////I"
 ; Do we need date on the Export?
 ;Set DIC("DR")=DIC("DR")_";1.03////"_$G(DT)
 D ^DIC
 I Y=-1 S ERR=1,ERR(1)="Failed to create a record" D ERROR Q
 S REC=+Y
 ; populate the new record
 S ERR=0,U="^"
 S EXEC="SET STREAM=##class(%Stream.GlobalCharacter).%New()"
 X EXEC
 ; Export a list of classes/routines/etc to the stream as XML
 S EXEC="DO $system.OBJ.ExportToStream(.CLASSES,.STREAM,.qlist,.ERR)"
 X EXEC
 ; ADD ERROR LOG
 I ERR D ERROR Q
 F  S EXEC="S STR=STREAM.Read(1000000)" X EXEC Q:STR=""  D  Q:ERR
 . S EXEC="S COMP=$system.Util.Compress(STR)" X EXEC
 . S EXEC="S B64=$system.Encryption.Base64Encode(COMP)" X EXEC
 . I $L(B64)="" S ERR=1,ERR(1)="Failed to create encrypted stream" D ERROR Q
 . S B64=$TR(B64,$C(10))
 . F I=1:1 SET XML=$P(B64,$C(13),I) Q:XML=""  D POPULATE^BUSACLAS(REC,XML) Q:ERR
 . I ERR D ERROR
 . D POPULATE^BUSACLAS(REC,"------------------------- SEGMENT END ------------------------")
 S DIE="^BUSACLS("
 K DA S DA=REC
 ; Set Status to READY
 S DR="1.02////R"
 D ^DIE
 W !,"Record ",REC," created"
 Q
 ;
IMPORT(REC,ERR) ;
 ; Returns ERR if there are any errors.
 NEW EXEC,I,STREAM,STRING,B64,COMP,LOADED
 NEW %,DIE,DA,CLASS,DIWF,DIWL,DIWR,DLAYGO,DR,ERRTEXT,ERRTXT
 NEW J,MASK,NAME,STR,X,Y
 S ERR=0
 I $G(REC)="" Q
 I '$D(^BUSACLS(REC)) Q
 I $G(DT)'?7N.E S DT=$$DT^XLFDT
 ; Change the value of field RPMS STATUS in 9002319.05 to "I"
 K DA S DA=REC,DIE="^BUSACLS(",DR="1.02////I" D ^DIE
 ;
 ; Create a new global-based character stream
 SET EXEC="S STREAM=##class(%Stream.GlobalCharacter).%New()"
 X EXEC
 ;
 ; Copy the XML from the distribution global to a stream
 S I=0
 F  D  Q:B64=""
 . S B64=""
 . F  S I=$O(^BUSACLS(REC,10,I)) Q:'I  S STR=^BUSACLS(REC,10,I,0) Q:STR["SEGMENT END"  S B64=B64_STR_$C(13,10)
 . I B64="" Q
 . S EXEC="S COMP=$system.Encryption.Base64Decode(B64)" X EXEC
 . S EXEC="S STRING=$system.Util.Decompress(COMP)" X EXEC
 . S EXEC="D STREAM.Write(STRING)" X EXEC
 ;
 ; First check that the received classes are OK. Pass "1" in the 5th parameter
 ; so that the import won't actualy happen. Then analyze the value of "ERR"
 S EXEC="D $system.OBJ.LoadStream(STREAM,""ck/lock=0"",.ERR,.LOADED,1)"
 X EXEC
 ; Error processing after the dry run
 I ERR D BGERROR G EXIT
 ;
 ; Actually load and compile the classes.
 ; "c" means "compile" and "k" means "keep source code"
 S EXEC="D $system.OBJ.LoadStream(STREAM,""ck/lock=0"",.ERR,.LOADED)"
 X EXEC
 ; Error processing after the actual load
 I ERR D BGERROR G EXIT
 ;
 S CLASS="" F  S CLASS=$O(LOADED(CLASS)) Q:CLASS=""  D
 . S DIC="^BUSACLS("_REC_",11,",DIC(0)="L",DLAYGO=1
 . S DA(1)=REC
 . S X=CLASS
 . D ^DIC
 ; Change the value of the field RPMS STATUS in 9002319.05 to "R"
 ; and populate RPMS DATE/TIME INSTALLED
 S DIE="^BUSACLS("
 K DA S DA=REC
 ; Set Status to READY
 W !,"Updating 9002319.05 Record"
 D NOW^%DTC
 S DR="1.02////C;1.03////"_%
 D ^DIE
EXIT ;
 Q
 ;
POPULATE(REC,XML) ;
 S DA(1)=REC
 K DIC S DIC="^BUSACLS("_DA(1)_",10," ;XML Subfile
 S DIC(0)="L",DLAYGO=1 ;LAYGO to the subfile
 S X=XML
 ; S X=$$ENCODE(XML)
 ; Add XML Data as the .01 field
 D FILE^DICN
 I Y=-1 S ERR="Failed to create XML subfield entry" Q
 Q
ERROR ;
 S ERRTEXT=""
 I $D(ERR)=1,ERR'=0 S ERRTXT=ERR
 I $D(ERR)>10 S I="",ERRTXT="" F  S I=$O(ERR(I)) Q:'I  S ERRTXT=ERRTXT_$G(ERR(I))_" "
 W !,!,ERRTXT
 Q
BGERROR ;
 ;W !,"Class import process errored out with error ",$G(ERR)
 ;W !,"Please contact IHS National."
 ; Change the value of the field RPMS STATUS in 9002319.05 to "E"
 ; S ERRTEXT=""
 I $D(ERR)=1 S I=ERR K ERR S ERR=1,ERR(1)=I
 I $D(ERR)>10 S I="" D
 . F  S I=$O(ERR(I)) Q:'I  S ERR(I)=$TR(ERR(I),$C(10,13),"  ")
 S DIE="^BUSACLS("
 I '$G(REC) Q
 I '$D(^BUSACLS(REC)) Q
 K DA S DA=REC
 ; Set Status to ERROR
 S DR="1.02////E"
 D ^DIE
 K ^UTILITY($J,"W")
 S DIWF="C80",DIWL=1,DIWR=80,I=""
 F  S I=$O(ERR(I)) Q:'I  S X=ERR(I) D ^DIWP
 S I="" K ERR1 S ERR1=0
 F  S I=$O(^UTILITY($J,"W",I)) Q:'I  S J="" F  S J=$O(^UTILITY($J,"W",I,J)) Q:'J  S ERR1=ERR1+1,ERR1(ERR1)=$G(^UTILITY($J,"W",I,J,0))
 Q
