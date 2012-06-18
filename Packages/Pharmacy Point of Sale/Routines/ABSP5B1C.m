ABSP5B1C ; IHS/OIT/CASSevern/Pieran ran 1/19/2011 - Handling of outgoing NCPDP Billing "B1" Claims for 5.1 (COB and WORKERS COMP Segments)
 ;;1.0;PHARMACY POINT OF SALE;**42**;JUN 21, 2001
COB ;EP CALLED FROM ABSP5B1 to set up PRICING SEGMENT -- Segment not yet implemented We'll probably have to do something very similar to DURR and CLINIC segments
 Q:$D(SUPRESSG("COB"))
 N FIELD
 S RECORD=$G(RECORD)
 F FIELD="111",337,338,339,340,443,993,341,342,431,471,472 D
 . Q:$D(SUPRESF(FIELD))
 . I (ACTION["CLAIM"),(FIELD'=111) D
 . . D @(FIELD_"GET")
 . . D @(FIELD_"FMT")
 . . D @(FIELD_"SET")
 . ELSE  D APPEND(FIELD)
 Q
 ;Segment identifier
111GET S ABSP("X")="05"
 Q
111FMT S ABSP("X")=$$ANFF^ABSPECFM(ABSP("X"),2)
 Q
111SET ;This isn't used for the 111 Field
 Q
 ;Other Payments Count
337GET I '$D(SPECIAL(337)) S ABSP("X")=""
 ELSE  X SPECIAL(337)
 Q
337FMT S:ABSP("X")'="" ABSP("X")="4C"_$$NFF^ABSPECFM($G(ABSP("X")),2)
 Q
337SET ;Not Yet Implemented **
 Q
 ;Other Payer Coverage Type
338GET I '$D(SPECIAL(338)) S ABSP("X")=""
 ELSE  X SPECIAL(338)
 Q
338FMT S:ABSP("X")'="" ABSP("X")="5C"_$$ANFF^ABSPECFM($G(ABSP("X")),2)
 Q
338SET ;Not Yet Implemented **
 Q
 ;Other Payer ID Qualifer
339GET I '$D(SPECIAL(339)) S ABSP("X")=""
 ELSE  X SPECIAL(339)
 Q
339FMT S:ABSP("X")'="" ABSP("X")="6C"_$$ANFF^ABSPECFM($G(ABSP("X")),2)
 Q
339SET ;Not Yet Implemented **
 Q
 ;Other Payer ID
340GET I '$D(SPECIAL(340)) S ABSP("X")=""
 ELSE  X SPECIAL(340)
 Q
340FMT S:ABSP("X")'="" ABSP("X")="7C"_$$ANFF^ABSPECFM($G(ABSP("X")),10)
 Q
340SET ;Not Yet Implemented **
 Q
 ;Other Payer Date
443GET I '$D(SPECIAL(443)) S ABSP("X")=""
 ELSE  X SPECIAL(443)
 Q
443FMT S:ABSP("X")'="" ABSP("X")="E8"_$$ANFF^ABSPECFM($G(ABSP("X")),8)
 Q
443SET ;Not Yet Implemented **
 Q
 ;Internal Control Number
993GET I '$D(SPECIAL(993)) S ABSP("X")=""
 ELSE  X SPECIAL(993)
 Q
993FMT S:ABSP("X")'="" ABSP("X")="A7"_$$ANFF^ABSPECFM($G(ABSP("X")),30)
 Q
993SET ;Not Yet Implemented **
 Q
 ;Other Payer Amount Paid Count
341GET I '$D(SPECIAL(341)) S ABSP("X")=""
 ELSE  X SPECIAL(341)
 Q
341FMT S:ABSP("X")'="" ABSP("X")="HB"_$$ANFF^ABSPECFM($G(ABSP("X")),2)
 Q
341SET ;Not Yet Implemented **
 Q
 ;Other Payer Amount Paid Qualifier
342GET I '$D(SPECIAL(342)) S ABSP("X")=""
 ELSE  X SPECIAL(342)
 Q
342FMT S:ABSP("X")'="" ABSP("X")="HC"_$$ANFF^ABSPECFM($G(ABSP("X")),2)
 Q
342SET ;Not Yet Implemented **
 Q
 ;Other Payer Amount Paid
431GET I '$D(SPECIAL(431)) S ABSP("X")=""
 ELSE  X SPECIAL(431)
 Q
431FMT S:ABSP("X")'="" ABSP("X")="DV"_$$ANFF^ABSPECFM($G(ABSP("X")),6)
 Q
431SET ;Not Yet Implemented **
 Q
 ;Other Payer Reject Count
471GET I '$D(SPECIAL(471)) S ABSP("X")=""
 ELSE  X SPECIAL(471)
 Q
471FMT S:ABSP("X")'="" ABSP("X")="5E"_$$ANFF^ABSPECFM($G(ABSP("X")),2)
 Q
471SET ;Not Yet Implemented **
 Q
 ;Other Payer Reject Code
472GET I '$D(SPECIAL(472)) S ABSP("X")=""
 ELSE  X SPECIAL(472)
 Q
472FMT S:ABSP("X")'="" ABSP("X")="6E"_$$ANFF^ABSPECFM($G(ABSP("X")),3)
 Q
472SET ;Not Yet Implemented **
 Q
WORKCOMP ;EP CALLED FROM ABSP5B1 to set up WORKERS COMP SEGMENT -- Entire segment not implemented yet
 Q:$D(SUPRESSG("Workers Comp"))
 N FIELD
 S RECORD=$G(RECORD)
 F FIELD="111A",434,315,316,317,318,319,320,321,327,435 D
 . Q:$D(SUPRESF(FIELD))
 . I (ACTION["CLAIM"),(FIELD'=111) D
 . . D @(FIELD_"GET")
 . . D @(FIELD_"FMT")
 . . D @(FIELD_"SET")
 . ELSE  D APPEND(FIELD)
 Q
 ;Segment identifier
111AGET S ABSP("X")="06"
 Q
111AFMT S ABSP("X")=$$ANFF^ABSPECFM(ABSP("X"),2)
 Q
111ASET ;This isn't used for the 111 Field
 Q
 ;Date of Injury
434GET I '$D(SPECIAL(434)) S ABSP("X")=""
 ELSE  X SPECIAL(434)
 Q
434FMT S:ABSP("X")'="" ABSP("X")="DY"_$$ANFF^ABSPECFM($G(ABSP("X")),8)
 Q
434SET ;Not Yet Implemented
 Q
 ;Employer Name
315GET I '$D(SPECIAL(315)) S ABSP("X")=""
 ELSE  X SPECIAL(315)
 Q
315FMT S:ABSP("X")'="" ABSP("X")="CF"_$$ANFF^ABSPECFM($G(ABSP("X")),30)
 Q
315SET ;Not Yet Implemented
 Q
 ;Employer Street Address
316GET I '$D(SPECIAL(316)) S ABSP("X")=""
 ELSE  X SPECIAL(316)
 Q
316FMT S:ABSP("X")'="" ABSP("X")="CG"_$$ANFF^ABSPECFM($G(ABSP("X")),30)
 Q
316SET ;Not Yet Implemented
 Q
 ;Employer City Address
317GET I '$D(SPECIAL(317)) S ABSP("X")=""
 ELSE  X SPECIAL(317)
 Q
317FMT S:ABSP("X")'="" ABSP("X")="CH"_$$ANFF^ABSPECFM($G(ABSP("X")),20)
 Q
317SET ;Not Yet Implemented
 Q
 ;Employer State/Province Address
318GET I '$D(SPECIAL(318)) S ABSP("X")=""
 ELSE  X SPECIAL(318)
 Q
318FMT S:ABSP("X")'="" ABSP("X")="CI"_$$ANFF^ABSPECFM($G(ABSP("X")),2)
 Q
318SET ;Not Yet Implemented
 Q
 ;Employer Zip
319GET I '$D(SPECIAL(319)) S ABSP("X")=""
 ELSE  X SPECIAL(319)
 Q
319FMT S:ABSP("X")'="" ABSP("X")="CJ"_$$ANFF^ABSPECFM($G(ABSP("X")),15)
 Q
319SET ;Not Yet Implemented
 Q
 ;Employer Phone Number
320GET I '$D(SPECIAL(320)) S ABSP("X")=""
 ELSE  X SPECIAL(320)
 Q
320FMT S:ABSP("X")'="" ABSP("X")="CK"_$$ANFF^ABSPECFM($G(ABSP("X")),10)
 Q
320SET ;Not Yet Implemented
 Q
 ;Employer Contact Name
321GET I '$D(SPECIAL(321)) S ABSP("X")=""
 ELSE  X SPECIAL(321)
 Q
321FMT S:ABSP("X")'="" ABSP("X")="CL"_$$ANFF^ABSPECFM($G(ABSP("X")),30)
 Q
321SET ;Not Yet Implemented
 Q
 ;Carrier ID
327GET I '$D(SPECIAL(327)) S ABSP("X")=""
 ELSE  X SPECIAL(327)
 Q
327FMT S:ABSP("X")'="" ABSP("X")="CR"_$$ANFF^ABSPECFM($G(ABSP("X")),10)
 Q
327SET ;Not Yet Implemented
 Q
 ;Claim/Reference ID
435GET I '$D(SPECIAL(435)) S ABSP("X")=""
 ELSE  X SPECIAL(435)
 Q
435FMT S:ABSP("X")'="" ABSP("X")="DZ"_$$ANFF^ABSPECFM($G(ABSP("X")),30)
 Q
435SET ;Not Yet Implemented
 Q
APPEND(FIELD) ;This is where outgoing record is built field by field
 I FIELD["111" D
 . D @(FIELD_"GET")
 . D @(FIELD_"FMT")
 . S RECORD=RECORD_$C(30,28)_"AM"_ABSP("X")
 ELSE  D
 . I $G(ABSP(9002313.0201,IEN(9002313.01),FIELD,"I"))'="" S RECORD=RECORD_$C(28)_$G(ABSP(9002313.0201,IEN(9002313.01),FIELD,"I"))
 . ELSE  I $D(SPECIAL(FIELD)) D
 . . X SPECIAL(FIELD)
 . . D @(FIELD_"FMT")
 . . S RECORD=RECORD_$C(28)_ABSP("X")
 Q
