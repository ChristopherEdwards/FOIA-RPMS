DGPFHLU5 ;ALB/RPM - PRF HL7 ACK PROCESSING ; 6/20/03 11:30am
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
 Q
 ;
PROCERR(DGLIEN,DGACK,DGERR) ;process errors returned from ACK
 ;
 ;  Input:
 ;    DGLIEN - IEN of PRF HL7 TRANSMISSION LOG (#26.17) file
 ;     DGACK - array of ACK parse data
 ;     DGERR - array of parsed errors (ex: DGERR(1)="UU")
 ;
 ; Output: none
 ;
 N DGPFA   ;assignment array
 N DGPFAH  ;assignment history array
 N DGPFL   ;HL7 transmission log array
 N DGTBL   ;error code array
 N DGXMTXT ;mailman msg text array 
 ;
 I +$G(DGLIEN),$D(DGACK),$D(DGERR) D
 . ;
 . ;retrieve the HL7 transmission log values
 . Q:'$$GETLOG^DGPFHLL(DGLIEN,.DGPFL)
 . ;
 . ;retrieve assignment history values
 . Q:'$$GETHIST^DGPFAAH(+$G(DGPFL("ASGNHIST")),.DGPFAH)
 . ;
 . ;retrieve assignment values
 . Q:'$$GETASGN^DGPFAA(+$G(DGPFAH("ASSIGN")),.DGPFA)
 . ;
 . S DGXMTXT=$NA(^TMP("DGPFERR",$J))
 . K @DGXMTXT
 . ;
 . ;load error code table
 . D BLDVA086^DGPFHLU3(.DGTBL)
 . ;
 . ;create message text array
 . D BLDMSG(.DGPFA,.DGACK,.DGERR,.DGTBL,DGXMTXT)
 . ;
 . ;send the notification message
 . D SEND(DGXMTXT)
 . ;
 . ;cleanup
 . K @DGXMTXT
 Q
 ;
BLDMSG(DGPFA,DGACK,DGERR,DGTBL,DGXMTXT) ;buld MailMan message array
 ;
 ;  Supported DBIA #2171:  The supported DBIA is uses to access Kernel
 ;                         APIs for retrieving Station numbers and names
 ;                         from the INSTITUTION (#4) file.
 ;  Supported DBIA #2701:  The supported DBIA is used to access MPI APIs
 ;                         for retrieving an ICN for a given DFN.
 ;
 ;  Input:
 ;    DGPFA - assignment data array
 ;    DGACK - array of ACK data
 ;    DGERR - array of parsed errors (ex: DGERR(1)="UU")
 ;    DGTBL - VA086 error code table array
 ;
 ;  Output:
 ;    DGXMTXT - array of MailMan text lines
 ;
 N DGCNT   ;error count
 N DGCOD   ;error code
 N DGDEM   ;patient demographics array
 N DGDFN   ;pointer to PATIENT (#2) file
 N DGFAC   ;facility data array from XUAF4 call
 N DGICN   ;integrated control number
 N DGLIN   ;line counter
 N DGMAX   ;maximum line length
 N DGSITE  ;results of VASITE call
 N DGSNDSTA  ;sending station number
 N DGSNDNAM  ;sending station name
 ;
 S DGDFN=+$G(DGPFA("DFN"))
 Q:(DGDFN'>0)
 ;
 ;retrieve patient demographics
 Q:'$$GETPAT^DGPFUT2(DGDFN,.DGDEM)
 S DGICN=$$GETICN^MPIF001(DGDFN)
 S DGICN=$S(+DGICN>0:DGICN,1:$P(DGICN,U,2))
 ;
 S DGLIN=0
 S DGMAX=65
 S DGSITE=$$SITE^VASITE()
 S DGSNDSTA=$G(DGACK("SNDFAC"))
 D F4^XUAF4(DGSNDSTA,.DGFAC,"","")
 S DGSNDNAM=$S(DGFAC>0:$G(DGFAC("NAME")),1:"")
 ;
 D ADDLINE("",0,DGMAX,.DGLIN,DGXMTXT)
 D ADDLINE("* * * *  P R F  H L 7  E R R O R  E N C O U N T E R E D  * * * *",0,DGMAX,.DGLIN,DGXMTXT)
 D ADDLINE("",0,DGMAX,.DGLIN,DGXMTXT)
 D ADDLINE("A facility could not process the following Patient Record Flag assignment on "_$$FMTE^XLFDT($G(DGACK("MSGDTM")))_".",0,DGMAX,.DGLIN,DGXMTXT)
 D ADDLINE("",0,DGMAX,.DGLIN,DGXMTXT)
 D ADDLINE("Receiving Facility name: "_DGSNDNAM_" ("_DGSNDSTA_")",0,DGMAX,.DGLIN,DGXMTXT)
 D ADDLINE("",0,DGMAX,.DGLIN,DGXMTXT)
 D ADDLINE("Flag Name: "_$P($G(DGPFA("FLAG")),U,2),14,DGMAX,.DGLIN,DGXMTXT)
 D ADDLINE("",0,DGMAX,.DGLIN,DGXMTXT)
 D ADDLINE("Patient Name: "_DGDEM("NAME"),11,DGMAX,.DGLIN,DGXMTXT)
 D ADDLINE("Social Security #: "_DGDEM("SSN"),6,DGMAX,.DGLIN,DGXMTXT)
 D ADDLINE("Date of Birth: "_$$FMTE^XLFDT(DGDEM("DOB"),"2D"),10,DGMAX,.DGLIN,DGXMTXT)
 D ADDLINE("Integrated Control #: "_DGICN,3,DGMAX,.DGLIN,DGXMTXT)
 D ADDLINE("",0,DGMAX,.DGLIN,DGXMTXT)
 S DGCNT=0
 F  S DGCNT=$O(DGERR(DGCNT)) Q:'DGCNT  D
 . S DGCOD=DGERR(DGCNT)
 . I DGCOD]"",$D(DGTBL(DGCOD,"DESC")) D
 . . D ADDLINE("Reason#: "_DGCNT,0,DGMAX,.DGLIN,DGXMTXT)
 . . D ADDLINE(DGTBL(DGCOD,"DESC"),12,DGMAX,.DGLIN,DGXMTXT)
 . . D ADDLINE("",0,DGMAX,.DGLIN,DGXMTXT)
 Q
 ;
ADDLINE(DGTEXT,DGINDENT,DGMAXLEN,DGCNT,DGXMTXT) ;add text line to message array
 ;
 ;  Input:
 ;     DGTEXT - text string
 ;   DGINDENT - number of spaces to insert at start of line
 ;   DGMAXLEN - maximum desired line length (default: 60)
 ;      DGCNT - line number passed by reference
 ;
 ;  Output:
 ;    DGXMTXT - array of text strings
 ;
 N DGAVAIL  ;available space for text
 N DGLINE   ;truncated text
 N DGLOC    ;location of space character
 N DGPAD    ;space indent
 ;
 S DGTEXT=$G(DGTEXT)
 S DGINDENT=+$G(DGINDENT)
 S DGMAXLEN=+$G(DGMAXLEN)
 S:'DGMAXLEN DGMAXLEN=60
 I DGINDENT>(DGMAXLEN-1) S DGINDENT=0
 S DGCNT=$G(DGCNT,0)  ;default to 0
 ;
 S DGPAD=$$REPEAT^XLFSTR(" ",DGINDENT)
 ;
 ;determine availaible space for text
 S DGAVAIL=(DGMAXLEN-DGINDENT)
 F  D  Q:('$L(DGTEXT))
 . ;
 . ;find potential line break
 . S DGLOC=$L($E(DGTEXT,1,DGAVAIL)," ")
 . ;
 . ;break a line that is too long when it has potential line breaks
 . I $L(DGTEXT)>DGAVAIL,DGLOC D
 . . S DGLINE=$P(DGTEXT," ",1,$S(DGLOC>1:DGLOC-1,1:1))
 . . S DGTEXT=$P(DGTEXT," ",$S(DGLOC>1:DGLOC,1:DGLOC+1),$L(DGTEXT," "))
 . E  D
 . . S DGLINE=DGTEXT,DGTEXT=""
 . ;
 . S DGCNT=DGCNT+1
 . S @DGXMTXT@(DGCNT)=DGPAD_DGLINE
 Q
 ;
SEND(DGXMTXT) ;send the MailMan message
 ;
 ;  Input:
 ;    DGXMTXT - name of message text array in closed format
 ;
 ;  Output:
 ;    none
 ;
 N DIFROM  ;protect FM package
 N XMDUZ   ;sender
 N XMSUB   ;message subject
 N XMTEXT  ;name of message text array in open format
 N XMY     ;recipient array
 N XMZ     ;returned message number
 ;
 S XMDUZ="Patient Record Flag Module"
 S XMSUB="PRF MESSAGE TRANSMISSION ERROR"
 S XMTEXT=$$OREF^DILF(DGXMTXT)
 S XMY("G.DGPF HL7 TRANSMISSION ERRORS")=""
 D ^XMD
 Q
