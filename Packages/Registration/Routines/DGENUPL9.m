DGENUPL9 ;ISA/KWP,JAN - CD CONSISTENCY CHECKS ;5/7/99;4/19/01
 ;;5.3;REGISTRATION;**232,378**;Aug 13,1993
 ;
CDCHECK() ;
 ;Description: Does the consistency checks on the CATASTROPHIC DISABILITY objects.
 ;Input:
 ;  MSGS -Error messages
 ;  DGPAT -Patient array
 ;  MSGID -HL7 Message ID
 ;  OLDCDIS -CD array with data from file
 ;  DGCDIS -CD Array
 ;  ERRCOUNT -number of errors
 ;Output:
 ;  1 if consistency checks passed, 0 otherwise
 ;
 ;Phase II (SRS 6.5.1.4 a)
 ;If CD is Y on VISTA and update is No or null send error
 I OLDCDIS("VCD")="Y",DGCDIS("VCD")'="Y" D  Q 0
 .D ADDERROR^DGENUPL(MSGID,DGPAT("SSN"),"CD Error: VET is CD at site. However, upload from HEC does not reflect CD.",.ERRCOUNT)
 ;Phase II (SRS 6.5.1.4 b)
 ;If CD is Yes and method of determination is 3 on VISTA and update is Yes and the method of determination is 1 or 2 send error
 I OLDCDIS("VCD")="Y",OLDCDIS("METDET")=3,DGCDIS("VCD")="Y",DGCDIS("METDET")=1!(DGCDIS("METDET")=2) D  Q 0
 .D ADDERROR^DGENUPL(MSGID,DGPAT("SSN"),"CD Error: Phys Exam at site",.ERRCOUNT)
 ;Phase II (SRS 6.5.1.4 c)
 ;If CD is Yes and determination of 3 on VISTA and update is Yes and determination is 3
 ; If the date of decision on update is not greater than the VISTA date of decision send error
 I OLDCDIS("VCD")="Y",OLDCDIS("METDET")=3,DGCDIS("VCD")="Y",DGCDIS("METDET")=3,DGCDIS("DATE")<OLDCDIS("DATE") D  Q 0
 .D ADDERROR^DGENUPL(MSGID,DGPAT("SSN"),"CD Error: Phys Exam date more recent at site",.ERRCOUNT)
 ;Phase II (SRS6.5.1.4 d)
 ;If CD is Yes or No on VISTA and update is null then send error
 I OLDCDIS("VCD")="Y"!(OLDCDIS("VCD")="N"),DGCDIS("VCD")="" D  Q 0
 .D ADDERROR^DGENUPL(MSGID,DGPAT("SSN"),"CD Error: CD Status is determined at site",.ERRCOUNT)
 ;
 Q 1
