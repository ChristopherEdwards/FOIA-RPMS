APSSINI0 ;IHS/CIA/MDM - ScriptPro Interface;26-Jun-2008 15:01;DU
 ;;1.0;IHS SCRIPTPRO INTERFACE;**1**;January 11, 2006
 ; APSS COMMAND FILE (#9009033.3) Maintenance & Initialization routine
 ; Direct entry not supported
 Q
EP1 ;MDM - Main entry point
 ;
 ; File structure
 ; APSS COMMAND FILE (#9009033.3)
 ; APSS COMMAND FILE DATA TAG (Multiple-9009033.31)
 ; APSS COMMAND FILE DATA TAG DESCRIPTION (Multiple-9009033.312)
 ;
 ; Variable definitions
 ; APSSDAT = Data
 ; APSSCLC = Comment Line count
 ; APSSTAG = Data Tag (.01)
 ; APSSSEQ = Sequence (.02)
 ; APSSFLD = File/Field (.03)
 ; APSSFMT = Format (.04)
 ; APSSTRAN = Transform (1)
 ; APSSDESC = Description total line number (2)
 ; APSSCMD = Command
 ; APSSSIEN = DATA TAG Subfile IEN
 ; APSSIEN = FDA Array FDA_ROOT Construct
 ; APSSDIEN = DATA TAG DESCRIPTION Sub-Sub File Word Processing field IEN
 ; APSSLINE = Description Text line being processed (Reading data statements)
 ; APSSDEND = Description Text Ending line number (Reading data statements)
 ; APSSDBEG = Description Text Beginning line number (Reading data statements)
 ; ACTION = What action took place (ADD, EDIT, DELETE)
 ; APSSUTAG = Original value that was modified
 ;
 ; Initialize working variables and control cleanup upon routine termination
 N APSSDAT,APSSCLC,APSSTAG,APSSSEQ,APSSFLD,APSSFMT,APSSDESC,APSSTRAN,APSSUTAG
 N APSSCMD,APSSSIEN,APSSIEN,APSSDIEN,FDA,APSSDEND,APSSDBEG,APSSLINE,ACTION
 N ARY,SSEQ
 ;
 ; Grab the IEN for the FILL Command
 S APSSCMD="",APSSCMD=$O(^APSSCOMD("B","FILL",APSSCMD)) Q:'APSSCMD
 S SIEN=0 F  S SIEN=$O(^APSSCOMD(APSSCMD,1,SIEN)) Q:'SIEN  D
 .S SSEQ=$P($G(^APSSCOMD(APSSCMD,1,SIEN,0)),U,2)
 .I SSEQ S ARY(SSEQ)=$P(^APSSCOMD(APSSCMD,1,SIEN,0),U,1)
 ;
 ; MAIN PROCESSING LOOP
 ; Loop through the data statement section of this routine
 F APSSCLC=1:1 S APSSDAT=$P($T(DATA+APSSCLC),";",2) Q:APSSDAT="EOD"  D
 . ; If there is no data on that line quit processing and go get the next line
 . I APSSDAT="" Q
 . ; If the line does not have a "^" in it then it is an invalid record so quit.
 . I APSSDAT'["^" Q
 . ; Piece out the major data elements
 . S APSSTAG=$P(APSSDAT,"^",1)           ; Data Tag
 . S APSSSEQ=$P(APSSDAT,"^",2)           ; Sequence
 . ; if the sequence number is in use and the data tag does not match what is being delivered
 . ; change this sequence number
 . I $D(ARY(APSSSEQ))&($G(ARY(APSSSEQ))'=APSSTAG) S APSSSEQ=$$NEWSEQ(.ARY,APSSSEQ)
 . S APSSFLD=$P(APSSDAT,"^",3)           ; File/Field
 . S APSSFMT=$P($P(APSSDAT,"^",4),"~",1) ; Format
 . S APSSTRAN=$P(APSSDAT,"~",2)          ; Transform
 . S APSSDESC=$P(APSSDAT,"~",3)          ; Description
 . ;
 . ; Filing methods and requirements are determined in this section of code.
 . ;
 . ; *****************************DELETE**************************************
 . ; Check for delete flag and if present, perform appropriate action.
 . I APSSTAG["@",$D(^APSSCOMD(APSSCMD,1,"B",$P(APSSTAG,"@",2))) D  Q
 . . W !,"DELETE RECORD"
 . . S ACTION="DELETE"
 . . ; Grab the IEN for this Data Tag
 . . S APSSSIEN="",APSSSIEN=$O(^APSSCOMD(APSSCMD,1,"B",$P(APSSTAG,"@",2),APSSSIEN))
 . . ; Build FDA Array IEN Construct
 . . S APSSIEN=APSSSIEN_","_APSSCMD_","
 . . ; Build FDA Array to define file structure and field values
 . . S FDA(9009033.31,APSSIEN,.01)="@"
 . . ;
 . . ; Delete this record in the file
 . . D FILE^DIE("","FDA","ERR")
 . . ;
 . . I +$G(ERR("ERR")) D RESET Q
 . . ;
 . . ; Display informational message
 . . D MSG
 . . ; DEVELOPEMENT DISPLAY
 . . ;D DISP
 . . ; Reset working variables
 . . D RESET
 . . ;
 . . Q
 . ;
 . ; *****************************UPDATE***************************************
 . ; If the Umlaut is found in the APSSTAG string then,
 . ; Check for an existing entry and if present, perform appropriate action.
 . ;I APSSTAG["`",$D(^APSSCOMD(APSSCMD,1,"B",$P(APSSTAG,"`",1))) D  Q
 . I $D(^APSSCOMD(APSSCMD,1,"B",APSSTAG)) D  Q
 . . W !,"UPDATE RECORD"
 . . S ACTION="EDIT"
 . . ; Strip off the umlaut character and separate the two values
 . . ; If the DATA TAG value is changing them Piece 2 holds the new value
 . . S APSSUTAG=$P(APSSTAG,"`",2)
 . . ; Piece one holds the current value
 . . S APSSTAG=$P(APSSTAG,"`",1)
 . . ; If piece 1 has no value then
 . . ; Data in another field is changing but the DATA TAG field is not changing
 . . I APSSTAG="" S APSSTAG=APSSUTAG
 . . ; Grab the IEN for this Data Tag
 . . S APSSSIEN="",APSSSIEN=$O(^APSSCOMD(APSSCMD,1,"B",APSSTAG,APSSSIEN))
 . . ; Build FDA Array IEN Construct
 . . S APSSIEN=APSSSIEN_","_APSSCMD_","
 . . ; Build FDA Array
 . . D FDA
 . . ;
 . . ; Update the file
 . . D FILE^DIE("","FDA","ERR")
 . . ;
 . . I +$G(ERR("ERR")) D RESET Q
 . . ;
 . . ; Display informational message
 . . D MSG
 . . ; Process Description Text if defined
 . . D DESC(APSSSIEN)
 . . ; DEVELOPEMENT DISPLAY
 . . ;D DISP
 . . ; Reset working variables
 . . D RESET
 . . Q
 . ;
 . ; **************************NEW ENTRY***************************************
 . ; File a new entry
 . ; Check for an existing entry and if NOT present, perform appropriate action.
 . I '$D(^APSSCOMD(APSSCMD,1,"B",APSSTAG)) D  Q
 . . W !,"RECORD NEW ENTRY"
 . . S ACTION="ADD"
 . . S APSSSIEN="+1"
 . . ; Build FDA Array IEN Construct
 . . S APSSIEN=APSSSIEN_","_APSSCMD_","
 . . ; Build FDA Array
 . . D FDA
 . . ;
 . . ; File the Data
 . . D UPDATE^DIE("","FDA","ERR")
 . . ;
 . . I +$G(ERR("ERR")) D RESET Q
 . . ;
 . . ;Display informational message
 . . D MSG
 . . ; Process Description Text if defined
 . . D DESC(ERR(1))
 . . ; DEVELOPEMENT DISPLAY
 . . ;D DISP
 . . ; Reset working variables
 . . D RESET
 . . Q
 . Q
 ;
 ; Kill the message arrays and variables that are produced by VA FileMan.
 D CLEAN^DILF
 ; End of processing
 Q
DESC(REC) ; Process description text and put it into the file
 ; If there is no description text then quit
 I 'APSSDESC Q
 S APSSIEN=REC_","_APSSCMD_","
 ; Process Description text data statements
 S APSSDEND=APSSCLC+APSSDESC,APSSDBEG=APSSCLC+1  ; Initialize counters
 ; Loop through the description text for this data tag
 F APSSLINE=APSSDBEG:1:APSSDEND S APSSDAT=$P($T(DATA+APSSLINE),";",2) D
 . ; Set up data array t be processed by VA Fileman.
 . S TMP("WP",APSSLINE)=APSSDAT,APSSDAT=""
 . Q
 ;
 ; If Description lines were defined then adjust process looping position
 ; and send the data to VA Fileman to put into the database.
 I APSSLINE S APSSCLC=APSSLINE,APSSLINE="" D
 . ;
 . ; File the description text
 . D WP^DIE(9009033.31,APSSIEN,2,"K","TMP(""WP"")","ERR(""WP"")")
 . Q
 ;
 Q
FDA ;
 ; Build FDA Array to define file structure and field values for use by Fileman
 S FDA(9009033.31,APSSIEN,.01)=APSSTAG
 I $G(APSSUTAG)]"" S FDA(9009033.31,APSSIEN,.01)=APSSUTAG
 S FDA(9009033.31,APSSIEN,.02)=APSSSEQ
 S FDA(9009033.31,APSSIEN,.03)=APSSFLD
 S FDA(9009033.31,APSSIEN,.04)=APSSFMT
 S FDA(9009033.31,APSSIEN,1)=APSSTRAN
 Q
RESET ;
 ; Reset working variables to NULL once each record is processed
 S APSSTAG=""           ; Data Tag
 S APSSSEQ=""           ; Sequence
 S APSSFLD=""           ; File/Field
 S APSSFMT=""           ; Format
 S APSSTRAN=""          ; Transform
 S APSSDESC=""          ; Description
 K TMP,FDA,ERR,ACTION,APSSUTAG
 Q
MSG ; Set up informational messages to display to the screen
 ;
 I '$G(ERR) D
 . I ACTION="ADD" D MES("Data Record: "_APSSTAG_" has been ADDED.")
 . I ACTION="DELETE" D MES("Data Record: "_$P(APSSTAG,"@",2)_" has been DELETED.")
 . I ACTION="EDIT" D MES("Data Record: "_$P(APSSTAG,"`",1)_" has been MODIFIED.")
 . Q
 E  D MES("Data Field: "_APSSTAG_" resulted in ERROR "_ERR(1))
 Q
MES(MSG,QUIT) ; Display informational messages
 D BMES^XPDUTL("  "_$G(MSG))
 Q
 ; INPUT  ARRAY - List of current sequence numbers being used at the facility
 ;           SQ - Sequence number needing to be changed.
 ;
NEWSEQ(ARRAY,SQ) ;
 N OFFSET,QUIT,NSQ
 S QUIT=0,NSQ=SQ
 F OFFSET=.1:.1:.9 D  Q:QUIT
 .S NSQ=$P(SQ,".")+OFFSET
 .I '$D(ARRAY(NSQ)) S QUIT=1 Q
 I 'QUIT S NSQ=SQ+.01
 Q NSQ
 ; *************************************************************************
 ; Structure of data statements found below the DATA line tag.
 ;
 ; DATA TAG^SEQUENCE^FILE,FIELD^FORMAT~TRANSFORM~NUMBER OF DESC. TEXT LINES
 ; NOTE:
 ; If there is a number in the last "~" piece then, there is description text
 ; which may be multiple lines of text. That text will follow the data line
 ; and preceed the next data line. The FOR loop reading the data statements
 ; will be adjusted to skip over the description text. A secondary loop will
 ; read and process the description data.
 ;
 ; To delete a record an "@" must appear as the first character of the data
 ; string.
 ;
 ; To modify a record use the Umlaut "`" as a flag in the first piece of the
 ; data string indicating it is an update.  If the first "^" piece is to be
 ; modified then the NEW value must appear in the SECOND "`" piece.
 ;
DATA ; This module holds the data that will be put into the database.
 ;
 ;Patient Gender^3.2^2,.02^Z~S VAL=$$GET1^DIQ(2,$P(RX0,U,2),.02)~1
 ;Patient Gender Designator
 ;Patient Address^3.3^^Z~S VAL=$$PADDR^APSSLIC($P(RX0,U,2))~1
 ;Patient Address
 ;Provider Class^31^200,53.5^ZR~S VAL=$$GET1^DIQ($S(PARIEN:52.2,REFIEN:52.1,1:52),$S(PARIEN!REFIEN:RXIENS,1:$P(RXIENS,",",$L(RXIENS,",")-1)),$S(PARIEN:6,REFIEN:15,1:4),"I") S:VAL VAL=$$GET1^DIQ(200,VAL,53.5)~1
 ;Provider Class
 ;Provider DEA#^32^200,53.2^ZR~S VAL=$$GET1^DIQ($S(PARIEN:52.2,REFIEN:52.1,1:52),$S(PARIEN!REFIEN:RXIENS,1:$P(RXIENS,",",$L(RXIENS,",")-1)),$S(PARIEN:6,REFIEN:15,1:4),"I") S:VAL VAL=$$GET1^DIQ(200,VAL,53.2)~1
 ;Provider DEA#
 ;Site DEA#^33^^Z~S VAL=$$SDEA^APSSLIC($P(RX0,U,5))~1
 ;Site DEA#
 ;Site Name^34^^Z~S VAL=$$SNAME^APSSLIC($P(RX0,U,5))~1
 ;Site Name
 ;Issue Date^35^52,1^Z~S VAL=$$FMTE^XLFDT($P(RX0,U,13),"5Z")~1
 ;Issue Date
 ;Login Date^37^52,21^Z~S VAL=$$FMTE^XLFDT($P(RX2,U),"5Z")~1
 ;Login Date
 ;License Number^36^200.541,1^ZR~S VAL=$$EP1^APSSLIC($$GET1^DIQ($S(PARIEN:52.2,REFIEN:52.1,1:52),$S(PARIEN!REFIEN:RXIENS,1:$P(RXIENS,",",$L(RXIENS,",")-1)),$S(PARIEN:6,REFIEN:15,1:4),"I"),2)~17
 ;Provider License Number
 ;
 ; Parameter 1 passed to APSSLIC routine represents the Provider Internal Entry Number
 ; Paramneter 2 represents the processing method which is described below..
 ;
 ; Method 1
 ; Match it to the state the facility is in
 ; If there is no license for that state then return any valid license
 ; If no valid license found for any state then return NULL
 ;
 ; Method 2
 ; There is no license for the state the facility is in then,
 ; return NULL even if other states have a valid license defined.
 ;
 ; Method 3
 ; Return first valid license found regardless of state
 ; No valid license found, then return NULL
 ;
 ;EOD
 Q
