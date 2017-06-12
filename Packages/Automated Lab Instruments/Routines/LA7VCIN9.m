LA7VCIN9 ;ihs/cmi/maw - Process Incoming UI Msgs, continued ; 22-Oct-2013 09:22 ; MAW
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**1033**;NOV 01, 1997
 ; This routine is a continuation of LA7CVIN1 and is only called from there.
 ; It is called to process TQ1 and SPM segments for "CH" subscript tests.
 Q
 ;
TQ1 ;-- process the TQ1 segment
 ; timing start time
 S LA7STT=$$HL7TFM^XLFDT($$P^LA7VHLU(.LA7SEG,8,LA7FS),"L")
 ; timing stop time
 S LA7STP=$$HL7TFM^XLFDT($$P^LA7VHLU(.LA7SEG,9,LA7FS),"L")
 S ^LAH(LA7LWL,1,LA7ISQN,"IHSTQ1")=LA7STT_U_LA7STP
 Q
 ;
SPM ;-- process the SPM segment
 ; specimen type
 S LA7SPTYP=$$P^LA7VHLU(.LA7SEG,5,LA7FS)  ;specimen type
 S LA7SPTSN=$P(LA7SPTYP,LA7CS)  ;snomed code
 S LA7SPTHL=$P(LA7SPTYP,LA7CS,2)
 S LA7SPTYI=$O(^LAB(61,"C",LA7SPTSN,0))  ;get the ien of the topography field file
 I '$G(LA7SPTYI) S LA7SPTYI=$O(^LAB(61,"AHL7",LA7SPTHL,0))  ;get ien from HL7 code
 ; specimen collection date/time
 S LA7SPCDT=$$P^LA7VHLU(.LA7SEG,18,LA7FS)
 S LA7SPCST=$$HL7TFM^XLFDT($P(LA7SPCDT,LA7CS),"L")
 ; specimen reject reason
 S LA7SPRJR=$P($$P^LA7VHLU(.LA7SEG,22,LA7FS),LA7CS,2)
 S ^LAH(LA7LWL,1,LA7ISQN,"IHSSPM")=$G(LA7SPTYI)_U_LA7SPCST_U_LA7SPRJR
 I LA7RSTAT="X" D  ;MU this is a cancelled test lets call auto cancellation
 . D NOTPERF^BLRRLTDR(LA7UID,LA7SPRJR)
 ; specimen condition
 S LA7SPCND=$$P^LA7VHLU(.LA7SEG,25,LA7FS)  ;specimen condition
 Q:$G(LA7SPCND)=""
 S LA7SPCSN=$P(LA7SPCND,LA7CS)  ;code
 S LA7SPCNI=$O(^LAHM(62.93,"ABB",LA7SPCSN,0))  ;get the ien based on code passed in
 S $P(^LAH(LA7LWL,1,LA7ISQN,"IHSSPM"),U,4)=LA7SPCNI
 Q
