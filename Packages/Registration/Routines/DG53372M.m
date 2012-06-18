DG53372M ;ALB/PDJ DG*5.3*372 Elig Code Cleanup Mailman Msg ; 03/30/01
 ;;5.3;Registration;**372**;Aug 13, 1993
 ;
 ; A mail message will be sent to the user when the edit process
 ; is complete.
 ;
 ;
MAIL ; Send a mailman msg to user with results
 N DIFROM,%
 N DATA,DATA1,FILE,FLD,IENX,NODE,TEXT,I,X,XMDUZ,XMSUB,XMTEXT,XMY,Y,STA,IEN
 N XTERR,XTPAT,XTENC,NAME
 N ELIGCD,SIEN,PIEN
 S XTERR="DG*5.3*372-SRCERR"
 S XTPAT="DG*5.3*372-PATREC"
 S XTENC="DG*5.3*372-ENCREC"
 K ^TMP("DG53372",$J)
 S XMSUB="ELIGIBILITY CODE Cleanup"
 S XMDUZ="DG Edit Package",XMY(DUZ)="",XMY(.5)=""
 S XMTEXT="^TMP(""DG53372"",$J,"
 D NOW^%DTC S Y=% D DD^%DT
 S ^TMP("DG53372",$J,1)="ELIGIBILITY CODE Cleanup"
 S ^TMP("DG53372",$J,2)="  "
 S NODE=2
 ;
 ;  Send no Cleanup needed message and quit
 ;
 I CLNOK D  Q
 . S NODE=NODE+1
 . S ^TMP("DG53372",$J,NODE)="   Your Site uses standard eligibility codes for NSC and"
 . S NODE=NODE+1
 . S ^TMP("DG53372",$J,NODE)=" SC LESS THAN 50% veterans, therefore no cleanup is needed. "
 . S NODE=NODE+1
 . S ^TMP("DG53372",$J,NODE)=" "
 . S NODE=5
 . D MAIL1
 ;
 ; Add text related to each Eligibility code
 ;
 F IEN=3,5 D
 . S NODE=NODE+1
 . S ^TMP("DG53372",$J,NODE)=" "
 . ; 
 . ; Standard code message
 . ;
 . I NSTD(IEN)=0 D  Q
 . . S NODE=NODE+1
 . . S ^TMP("DG53372",$J,NODE)="   Your site uses the standard Eligibility Code "_IEN_" for "_$S(IEN=3:"SC LESS THAN 50%.",1:"NSC.")
 . . S NODE=NODE+1
 . . S ^TMP("DG53372",$J,NODE)=" No report or cleanup is needed related to this code."
 . ;
 . ;  Auto-corrected message
 . ;
 . I NSTD(IEN)=1 D  Q
 . . S NODE=NODE+1
 . . S ^TMP("DG53372",$J,NODE)="    Your Site is using ELIGIBILITY CODE "_STDCDS(IEN)_" for "_$S(IEN=3:"SC LESS THAN 50%.",1:"NSC.")
 . . S NODE=NODE+1
 . . S ^TMP("DG53372",$J,NODE)=" Please review the list of records below that have been auto-corrected."
 . ;
 . ; Manual update message
 . ; 
 . S NODE=NODE+1
 . S ^TMP("DG53372",$J,NODE)="    Your Site is currently using ELIGIBILITY CODE "_IEN_" for "_$P(^DIC(8,IEN,0),"^",1)_"."
 . S NODE=NODE+1
 . S ^TMP("DG53372",$J,NODE)=" This is non-standard, as this code should be used for "_$S(IEN=3:"SC LESS THAN 50%.",1:"NSC.")
 . S NODE=NODE+1
 . S ^TMP("DG53372",$J,NODE)=" Please review the list of records below and update manually as needed."
 ;
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=" "
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=$$REPEAT^XLFSTR("=",75)
 ;
PRTRECS ; Print List of records
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=" "
 S TEXT="    Total Patient Records: "
 S TEXT=$$BLDSTR($J(+$G(^XTMP(XTPAT,1)),8,0),TEXT,30,8)
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=TEXT
 S TEXT="    Total Secondary Elig: "
 S TEXT=$$BLDSTR($J(+$G(^XTMP(XTPAT,1,1)),8,0),TEXT,30,8)
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=TEXT
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=" "
 ;
 S TEXT=" "
 S TEXT=$$BLDSTR("Elig",TEXT,7,4)
 S TEXT=$$BLDSTR("Pat IEN",TEXT,12,7)
 S TEXT=$$BLDSTR("SIEN",TEXT,23,4)
 S TEXT=$$BLDSTR("Name",TEXT,28,4)
 S TEXT=$$BLDSTR("SubEligCD",TEXT,50,9)
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=TEXT
 S (ELIGCD,PIEN,SIEN)=""
 F  S ELIGCD=$O(^XTMP(XTPAT,ELIGCD)) Q:ELIGCD=""  D
 . F  S PIEN=$O(^XTMP(XTPAT,ELIGCD,PIEN)) Q:PIEN=""  D
 . . F  S SIEN=$O(^XTMP(XTPAT,ELIGCD,PIEN,SIEN)) Q:SIEN=""  D
 . . . D BLDPAT
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=$$REPEAT^XLFSTR("=",75)
 ;
PRTENC ; Print Encounter Records
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=" "
 S TEXT="    Total Patient Encounter Records: "
 S TEXT=$$BLDSTR($J(+$G(^XTMP(XTENC,1)),8,0),TEXT,40,8)
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=TEXT
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=" "
 ;
 S TEXT=" "
 S TEXT=$$BLDSTR("Elig",TEXT,1,4)
 S TEXT=$$BLDSTR("Pat IEN",TEXT,6,7)
 S TEXT=$$BLDSTR("SIEN",TEXT,15,4)
 S TEXT=$$BLDSTR("Name",TEXT,28,4)
 S TEXT=$$BLDSTR("Enc DT",TEXT,54,6)
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=TEXT
 S (ELIGCD,PIEN,SIEN)=""
 F  S ELIGCD=$O(^XTMP(XTENC,ELIGCD)) Q:ELIGCD=""  D
 . F  S PIEN=$O(^XTMP(XTENC,ELIGCD,PIEN)) Q:PIEN=""  D
 . . F  S SIEN=$O(^XTMP(XTENC,ELIGCD,PIEN,SIEN)) Q:SIEN=""  D
 . . . D BLDENC
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=$$REPEAT^XLFSTR("=",75)
 ;
FILERRS ; Print Filing errors
 ;
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=" "
 S TEXT="    Total Filing Errors: "
 S TEXT=$$BLDSTR($J(+$G(^XTMP(XTERR,1)),8,0),TEXT,30,8)
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=TEXT
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=" "
 ;
 I +$G(^XTMP(XTERR,1)) D
 . S TEXT="File #"
 . S TEXT=$$BLDSTR("Elig",TEXT,8,4)
 . S TEXT=$$BLDSTR("PatIEN",TEXT,13,6)
 . S TEXT=$$BLDSTR("SIEN",TEXT,23,4)
 . S TEXT=$$BLDSTR("Name",TEXT,30,4)
 . S TEXT=$$BLDSTR("Dt/EligCD",TEXT,50,9)
 . S TEXT=$$BLDSTR("Error Message",TEXT,71,13)
 . S NODE=NODE+1
 . S ^TMP("DG53372",$J,NODE)=TEXT
 ;
 S (FILE,ELIGCD,PIEN,SIEN)=""
 F  S FILE=$O(^XTMP(XTERR,FILE)) Q:FILE=""  D
 . F  S ELIGCD=$O(^XTMP(XTERR,FILE,ELIGCD)) Q:ELIGCD=""  D
 . . F  S PIEN=$O(^XTMP(XTERR,FILE,ELIGCD,PIEN)) Q:PIEN=""  D
 . . . F  S SIEN=$O(^XTMP(XTERR,FILE,ELIGCD,PIEN,SIEN)) Q:SIEN=""  D
 . . . . D BLDERR
 ;
MAIL1 ;  Send message 
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=" "
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=" ******** END OF MESSAGE ********"
 ;
 D ^XMD
 K ^TMP("DG53372",$J)
 Q
 ;
BLDERR ; Format error line for printing
 N DATA,NAME,DTECD,ERRTXT
 S DATA=^XTMP(XTERR,FILE,ELIGCD,PIEN,SIEN)
 S NAME=$P(DATA,"^",1),DTECD=$P(DATA,"^",2),ERRTXT=$P(DATA,"^",3)
 S TEXT=FILE
 S TEXT=$$BLDSTR(ELIGCD,TEXT,10,$L(ELIGCD))
 S TEXT=$$BLDSTR(PIEN,TEXT,12,$L(PIEN))
 I SIEN S TEXT=$$BLDSTR(SIEN,TEXT,24,$L(SIEN))
 S TEXT=$$BLDSTR($E(NAME,1,20),TEXT,30,20)
 I $L(DTECD)>5 S Y=DTECD D DD^%DT S DTECD=Y
 S TEXT=$$BLDSTR(DTECD,TEXT,50,$L(DTECD))
 S TEXT=$$BLDSTR(ERRTXT,TEXT,71,20)
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=TEXT
 Q
 ;
BLDPAT ; Format Patient line for printing
 N DATA,NAME,DTECD,ERRTXT,SELIGCD
 S DATA=^XTMP(XTPAT,ELIGCD,PIEN,SIEN)
 S NAME=$P(DATA,"^",1),SELIGCD=$P(DATA,"^",2)
 S TEXT=" "
 S TEXT=$$BLDSTR(ELIGCD,TEXT,9,$L(ELIGCD))
 S TEXT=$$BLDSTR(PIEN,TEXT,12,$L(PIEN))
 I SIEN S TEXT=$$BLDSTR(SIEN,TEXT,24,$L(SIEN))
 S TEXT=$$BLDSTR($E(NAME,1,20),TEXT,28,20)
 S TEXT=$$BLDSTR(SELIGCD,TEXT,54,$L(SELIGCD))
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=TEXT
 Q
 ;
BLDENC ; Format Patient Encounter line for printing
 N DATA,NAME,ENCDT,ERRTXT,Y
 S DATA=^XTMP(XTENC,ELIGCD,PIEN,SIEN)
 S NAME=$P(DATA,"^",1),ENCDT=$P(DATA,"^",2)
 S TEXT=" "
 S TEXT=$$BLDSTR(ELIGCD,TEXT,2,$L(ELIGCD))
 S TEXT=$$BLDSTR(PIEN,TEXT,6,$L(PIEN))
 I SIEN S TEXT=$$BLDSTR(SIEN,TEXT,15,$L(SIEN))
 S TEXT=$$BLDSTR($E(NAME,1,20),TEXT,28,20)
 S Y=ENCDT D DD^%DT
 S TEXT=$$BLDSTR(Y,TEXT,54,$L(Y))
 S NODE=NODE+1
 S ^TMP("DG53372",$J,NODE)=TEXT
 Q
 ;
BLDSTR(NSTR,STR,COL,NSL) ; build a string
 ; Input:
 ;   NSTR = a string to be added to STR
 ;   STR  = an existing string to which NSTR will be added
 ;   COL  = column location at which NSTR will be added to STR
 ;   NSL  = length of new string
 ; Output:
 ;   returns STR with NSTR appended at the specified COL
 ;
 Q $E(STR_$J("",COL-1),1,COL-1)_$E(NSTR_$J("",NSL),1,NSL)_$E(STR,COL+NSL,999)
