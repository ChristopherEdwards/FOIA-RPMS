DGPFHLRT ;ALB/RPM - PRF HL7 MESSAGE RETRANSMIT ; 6/19/03
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;This routine provides procedures for retransmitting rejected PRF
 ;ORU~R01 HL7 messages.
 ;
 Q  ;no direct entry
 ;
REXMIT ;Retransmit all rejected PRF ORU~R01 messages
 ;This procedure scans all entries in the ASTAT index of the PRF HL7
 ;TRANSMISSION LOG (#26.17) file, looking for transmissions with a
 ;status of REJECT and that were rejected prior to the start of the
 ;scan
 ;
 Q:'$$ORUON^DGPFPARM()  ;ORU interface must be active
 ;
 N DGCODAT   ;cutoff date for scan
 N DGDAT     ;original transmission date
 N DGERR     ;error array
 N DGFAC     ;destination station number
 N DGFDA     ;FDA array
 N DGLIEN    ;pointer to PRF HL7 TRANSMISSION LOG (#26.17) file
 N DGPARAM   ;target root for PRF PARAMETERS (#26.18) file date fields
 N DGPERIOD  ;auto retransmit delay period
 N DGPFAH    ;assignment history data array
 N DGPFL     ;HL7 transmission log data array
 N DGSTAT    ;transmission status
 N DGTOT     ;total rexmit'd messages
 ;
 ;retrieve date/time of last scanned entry and retransmit period
 D GETS^DIQ(26.18,"1,","4;5","I","DGPARAM","DGERR")
 Q:$D(DGERR)
 S DGDAT=$G(DGPARAM(26.18,"1,",4,"I"))
 S DGPERIOD=$S(DGDAT>0:+$G(DGPARAM(26.18,"1,",5,"I")),1:0)
 S DGTOT=0
 ;
 ;calculate cutoff date
 S DGCODAT=$$FMADD^XLFDT($$NOW^XLFDT(),-DGPERIOD)
 ;
 ;loop through date/times
 F  S DGDAT=$O(^DGPF(26.17,"ASTAT",DGDAT)) Q:'DGDAT!(DGDAT>DGCODAT)  D
 . ;
 . ;loop through status
 . S DGSTAT=""
 . F  S DGSTAT=$O(^DGPF(26.17,"ASTAT",DGDAT,DGSTAT)) Q:DGSTAT=""  I DGSTAT="RJ" D
 . . ;
 . . ;loop through log file IEN
 . . S DGLIEN=0
 . . F  S DGLIEN=$O(^DGPF(26.17,"ASTAT",DGDAT,DGSTAT,DGLIEN)) Q:'DGLIEN  D
 . . . ;
 . . . ;retrieve assignment history file IEN
 . . . Q:'$$GETLOG^DGPFHLL(DGLIEN,.DGPFL)
 . . . Q:'+DGPFL("ASGNHIST")
 . . . ;
 . . . ;retrieve institution and convert to station#
 . . . S DGFAC(1)=$$STA^XUAF4(+DGPFL("SITE"))
 . . . Q:'DGFAC(1)
 . . . ;
 . . . ;retrieve assignment file IEN
 . . . Q:'$$GETHIST^DGPFAAH(+DGPFL("ASGNHIST"),.DGPFAH)
 . . . Q:'+DGPFAH("ASSIGN")
 . . . ;
 . . . ;build and transmit the new message
 . . . Q:'$$SNDORU^DGPFHLS(+DGPFAH("ASSIGN"),+DGPFL("ASGNHIST"),.DGFAC)
 . . . ;
 . . . ;update HL7 transmission log
 . . . D STOSTAT^DGPFHLL(DGLIEN,"RT")
 . . . ;
 . . . ;update total count
 . . . S DGTOT=DGTOT+1
 ;
 ;update PRF HL7 REXMIT TASK DATE/TIME (#4) field
 S DGFDA(26.18,"1,",4)=$O(^DGPF(26.17,"ASTAT",DGDAT),-1)
 D FILE^DIE("","DGFDA","DGERR")
 ;
 Q
