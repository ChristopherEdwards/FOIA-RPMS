BEHODC7 ;MSC/IND/MGH -  TIU Dictation Support ;20-Mar-2007 13:48;DKM
 ;;1.1;BEH COMPONENTS;**001001**;Mar 20, 2007
 ;=================================================================
 ;This is the main processing routine of the message that was
 ;received through HL7 and is intended to be stored in TIU
 ;=================================================================
PROCESS ;EP - Get message one line at a time
 N BEHDOC,BEHDOCID,BEHTEMP,ERRTX,BEHORIFN,X,J,DTO,DATE,Y,SEP,LINE
 N BEHEXAM,%,NEXT,SET,SUCCESS,HLMG,BEHTYPE,BEHSTAT,BEHID
 N BEHLOC,BEHDATE,BEHFILER,BEHPLACE,BEHREC,BEHI,BEHCASE,BEHSTORE
 N TIUPT,TIUDOC,TITLE,SEQ
 S ERRTX=""
 S X=$G(MSG(BEHNUM)) I $E(X,1,3)'="PID" S ERRTX="PID not second record." D BOTH^BEHODC8("",EVNDT,ERRTX) G KIL^BEHODC6
 ;Get patient IEN
 D PID^BEHODC6
 I DFN>0 D
 . S BEHNUM=BEHNUM+1
 .I $E(MSG(BEHNUM),1,3)="ORC" D
 ..D ORC
 Q
ORC ; Check ORC
 ;==================================================================
 S X=$G(MSG(BEHNUM))
 I $E(X,1,3)'="ORC" S ERRTX="ORC not found when expected. Contact IRM or Proscribe" D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL^BEHODC6
 S BEHID=$P(X,HLFS,3) ;This is the unique TIU IEN sent over
 S BEHNUM=BEHNUM+1
OBR ; Check OBR
 ;====================================================================
 ;The items needed from the OBR are:
 ;1) The unique document ID
 ;2) The author and signer of the note
 ;3) The note title
 ;===================================================================
 N BEHNEW,BEHPLACE,BEHFILER,BEHSIGN,BEHSDOC,BEHUTHOR,BEHUTHID,BEHSTAT
 S BEHNEW=0
 S X=$G(MSG(BEHNUM))
 S SEG("OBR")=X
 I $E(X,1,3)'="OBR" S ERRTX="OBR not found when expected. Contact IRM or Proscribe" D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL^BEHODC6
 S BEHSTAT=$P(X,HLFS,26)
 ;Only accept final versions
 I (BEHSTAT'="F")&(BEHSTAT'="C") S ERRTX="Report send was not a final version. Please resend" D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL^BEHODC6
 S TIUDA=$P(X,HLFS,3)  ; This is the TIU IEN send over
 I TIUDA="" S ERRTX="No unique note number was sent across. Resend message" D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL^BEHODC6
 S BEHPLACE=$P(X,HLFS,3),BEHFILER=$P(X,HLFS,4)
 ;=================================================================
 ;Find the author and the signer of the note
 ;=================================================================
 S BEHSIGN=$P($G(X),HLFS,33) I BEHSIGN'="" S BEHDOCID=$P(BEHSIGN,HLSUB,1)
 I '$D(^VA(200,BEHDOCID,0)) S ERRTX="Signer ID "_BEHDOCID_" not valid in "_$$AGTEXT()_". Call IRM and check data." D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL^BEHODC6
 S BEHUTHOR=$P($G(X),HLFS,34) I BEHUTHOR'="" S BEHUTHID=$P(BEHUTHOR,HLSUB,1)
 I '$D(^VA(200,BEHUTHID,0)) S ERRTX="Author ID "_BEHUTHID_" not valid in "_$$AGTEXT()_". Call IRM and check data." D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL^BEHODC6
 S TIUX(1202)=BEHDOCID
 S TIUX(1204)=BEHUTHID
 ;====================================================================
 ;Get the title of the note
 ;===================================================================
 S (BEHEXAM,%)=$P(X,HLFS,5)
 I $P(BEHEXAM,HLCOMP,2)="TIU Note" S TIUEXAM="TIU Note"
 E  D
 .I BEHEXAM'="" S TIUTITLE=$P(%,HLCOMP,2) I BEHEXAM="" S TIUTITLE=$P(%,HLCOMP,1)
 .I TIUTITLE'="" S TIUTITLE=$$UPPER^TIULS(TIUTITLE) S TIUEXAM=$O(^TIU(8925.1,"B",TIUTITLE,0))
 .I TIUTITLE="" S ERRTX="No title given to this exam. Please resend" D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL^BEHODC6
 ;Compare with the found results
 ;=======================================================================
 ;Check the data in the note IEN against the data in the message
 ;Make sure that the patient, author and title match
 ;=======================================================================
 S TIUX(.03)=$P($G(^TIU(8925,TIUDA,0)),U,3)
 S TIUPT=$P($G(^TIU(8925,TIUDA,0)),U,2)
 ;Title from TIU document
 S TIUDOC=$P($G(^TIU(8925,TIUDA,0)),U,1)
 I TIUEXAM'="TIU Note" D
 .I TIUDOC'=TIUEXAM S ERRTX="Document titles do not match" D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL^BEHODC6
 S TIUAUTH=$P($G(^TIU(8925,TIUDA,12)),U,2)
 I TIUPT'=DFN S ERRTX="Patients do not match. resend document" D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL^BEHODC6
 I TIUAUTH'=BEHUTHID S ERRTX="The autors of the documents do not match" D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL^BEHODC6
 S BEHNUM=BEHNUM+1
 I ERRTX'="" D BOTH^BEHODC8(DFN,EVNDT,ERRTX) Q
OBX ; Process OBX
 S BEHI=0
 S X=$G(MSG(BEHNUM))
 S SEG("OBX")=X
 I $E(X,1,3)'="OBX" S ERRTX="OBX not found when expected. Contact IRM" D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL^BEHODC6
 S BEHI=1
 D GETOBX
 Q
NEXT S BEHNUM=BEHNUM+1
 I '$D(MSG(BEHNUM)) G UPDATE
 I $E(MSG(BEHNUM),1,3)="OBX" G GETOBX^BEHODC7
 E  S ERRTX="UNKNOWN MESSAGE SEGMENT" D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL^BEHODC6
 Q
GETOBX ;EP - Get the OBX data to store
 S SEQ=$P(MSG(BEHNUM),HLFS,2)
 S LINE=$P(MSG(BEHNUM),HLFS,6)
 I BEHI=SEQ D
 .I LINE="" S LINE=" "
 .S TIUX("TEXT",BEHI,0)=LINE
 .S BEHI=BEHI+1
 G NEXT
 Q
UPDATE ;End of text; call routine to file data
 ;Since the stub of the note was already created in the EHR
 ;this is only an update.  The text of the note will be replaced
 ;if the note is unsigned.  If the note was signed, the text will become an addendum
 ;======================================================================
 D UPDATE^TIUSRVP(.SUCCESS,TIUDA,.TIUX,"")
 I $P(SUCCESS,"^",1)>0 D
 .S HLMG=SUCCESS
 .S TIUD0=$G(^TIU(8925,SUCCESS,0))
 .I +$P(TIUD0,U,5)<5 D UPDSTAT^TIUSRVP(SUCCESS,+$G(TIUD0))
 .D SEND^TIUALRT(SUCCESS)
 E  S ERRTX=$P(SUCCESS,"^",2) D BOTH^BEHODC8(DFN,EVNDT,ERRTX) G KIL^BEHODC6
 D GENACK^BEHODC8
 D KIL
 Q
KIL ; Kill Variables
 G KIL^BEHODC6
 ; Return Agency specific text
AGTEXT() ; EP
 Q $S($P($G(^XTV(8989.3,1,0)),U,8)="I":"RPMS",1:"VISTA")
