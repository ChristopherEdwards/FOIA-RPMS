ABSPDB1E ; IHS/OIT/CASSevern/Pieran ran 1/19/2011 - Handling of outgoing NCPDP Billing "B1" Claims for D.0 (APPEND, FACILITY and NARRATIVE segments)
 ;;1.0;PHARMACY POINT OF SALE;**42**;JUN 21, 2001
 ;These are the new segments added in D.0 that never existed before.
ADDDOC ;EP CALLED FROM ABSPDB1 to set up ADDITIONAL DOCUMENTATION SEGMENT
 Q:$D(SUPRESSG("Additional Doc"))
 N FIELD
 S RECORD=$G(RECORD)
 F FIELD="111",369,374,375,373,371,370,372,376,377,378,379,380,381,382,383 D
 . Q:$D(SUPRESF(FIELD))
 . I (ACTION["CLAIM"),(FIELD'=111) D
 . . D @(FIELD_"GET")
 . . D @(FIELD_"FMT")
 . . D @(FIELD_"SET")
 . ELSE  D APPEND(FIELD)
 Q
 ;Segment identifier
111GET S ABSP("X")=14
 Q
111FMT S ABSP("X")=$$ANFF^ABSPECFM(ABSP("X"),2)
 Q
111SET ;This isn't used for the 111 Field
 Q
 ;Additioinal Documentation Type ID
369GET I '$D(SPECIAL(369)) S ABSP("X")=""
 ELSE  X SPECIAL(369)
 Q
369FMT S:ABSP("X")'="" ABSP("X")="2Q"_$$ANFF^ABSPECFM($G(ABSP("X")),3)
 Q
369SET ;Not Yet Implemented
 Q
 ;Request Period Begin Date
374GET I '$D(SPECIAL(374)) S ABSP("X")=""
 ELSE  X SPECIAL(374)
 Q
374FMT S:ABSP("X")'="" ABSP("X")="2V"_$$ANFF^ABSPECFM($G(ABSP("X")),8)
 Q
374SET ;Not Yet Implemented
 Q
 ;Request Period Recert/Revised Date
375GET I '$D(SPECIAL(375)) S ABSP("X")=""
 ELSE  X SPECIAL(375)
 Q
375FMT S:ABSP("X")'="" ABSP("X")="2W"_$$ANFF^ABSPECFM($G(ABSP("X")),8)
 Q
375SET ;Not Yet Implemented
 Q
 ;Request Status
373GET I '$D(SPECIAL(373)) S ABSP("X")=""
 ELSE  X SPECIAL(373)
 Q
373FMT S:ABSP("X")'="" ABSP("X")="2U"_$$ANFF^ABSPECFM($G(ABSP("X")),1)
 Q
373SET ;Not Yet Implemented
 Q
 ;Length of Need Qualifier
371GET I '$D(SPECIAL(371)) S ABSP("X")=""
 ELSE  X SPECIAL(371)
 Q
371FMT S:ABSP("X")'="" ABSP("X")="2S"_$$ANFF^ABSPECFM($G(ABSP("X")),2)
 Q
371SET ;Not Yet Implemented
 Q
 ;Length of Need
370GET I '$D(SPECIAL(370)) S ABSP("X")=""
 ELSE  X SPECIAL(370)
 Q
370FMT S:ABSP("X")'="" ABSP("X")="2R"_$$ANFF^ABSPECFM($G(ABSP("X")),3)
 Q
370SET ;Not Yet Implemented
 Q
 ;Prescriber/Supplier Date Signed
372GET I '$D(SPECIAL(372)) S ABSP("X")=""
 ELSE  X SPECIAL(372)
 Q
372FMT S:ABSP("X")'="" ABSP("X")="2T"_$$ANFF^ABSPECFM($G(ABSP("X")),8)
 Q
372SET ;Not Yet Implemented
 Q
 ;Supporting Documentation
376GET I '$D(SPECIAL(376)) S ABSP("X")=""
 ELSE  X SPECIAL(376)
 Q
376FMT S:ABSP("X")'="" ABSP("X")="2X"_$$ANFF^ABSPECFM($G(ABSP("X")),65)
 Q
376SET ;Not Yet Implemented
 Q
 ;Question Number/Letter Count
377GET I '$D(SPECIAL(377)) S ABSP("X")=""
 ELSE  X SPECIAL(377)
 Q
377FMT S:ABSP("X")'="" ABSP("X")="2Z"_$$ANFF^ABSPECFM($G(ABSP("X")),2)
 Q
377SET ;Not Yet Implemented
 Q
 ;Question Number/Letter
378GET I '$D(SPECIAL(378)) S ABSP("X")=""
 ELSE  X SPECIAL(378)
 Q
378FMT S:ABSP("X")'="" ABSP("X")="4B"_$$ANFF^ABSPECFM($G(ABSP("X")),3)
 Q
378SET ;Not Yet Implemented
 Q
 ;Question Percent Response
379GET I '$D(SPECIAL(379)) S ABSP("X")=""
 ELSE  X SPECIAL(379)
 Q
379FMT S:ABSP("X")'="" ABSP("X")="4D"_$$ANFF^ABSPECFM($G(ABSP("X")),3)
 Q
379SET ;Not Yet Implemented
 Q
 ;Question Date Response
380GET I '$D(SPECIAL(380)) S ABSP("X")=""
 ELSE  X SPECIAL(380)
 Q
380FMT S:ABSP("X")'="" ABSP("X")="4G"_$$ANFF^ABSPECFM($G(ABSP("X")),8)
 Q
380SET ;Not Yet Implemented
 Q
 ;Question Dollar Amount
381GET I '$D(SPECIAL(381)) S ABSP("X")=""
 ELSE  X SPECIAL(381)
 Q
381FMT S:ABSP("X")'="" ABSP("X")="4H"_$$ANFF^ABSPECFM($G(ABSP("X")),9)
 Q
381SET ;Not Yet Implemented
 Q
 ;Question Numeric Response
382GET I '$D(SPECIAL(382)) S ABSP("X")=""
 ELSE  X SPECIAL(382)
 Q
382FMT S:ABSP("X")'="" ABSP("X")="4J"_$$ANFF^ABSPECFM($G(ABSP("X")),11)
 Q
382SET ;Not Yet Implemented
 Q
 ;Question Alphanumeric Response
383GET I '$D(SPECIAL(383)) S ABSP("X")=""
 ELSE  X SPECIAL(383)
 Q
383FMT S:ABSP("X")'="" ABSP("X")="4K"_$$ANFF^ABSPECFM($G(ABSP("X")),30)
 Q
383SET ;Not Yet Implemented
 Q
FACILITY ;EP CALLED FROM ABSPDB1 to set up FACILITY SEGMENT
 Q:$D(SUPRESSG("Facility"))
 N FIELD
 S RECORD=$G(RECORD)
 F FIELD="111A",336,385,386,388,387,389 D
 . Q:$D(SUPRESF(FIELD))
 . I (ACTION["CLAIM"),(FIELD'=111) D
 . . D @(FIELD_"GET")
 . . D @(FIELD_"FMT")
 . . D @(FIELD_"SET")
 . ELSE  D APPEND(FIELD)
 Q
 ;Segment identifier
111AGET S ABSP("X")=15
 Q
111AFMT S ABSP("X")=$$ANFF^ABSPECFM(ABSP("X"),2)
 Q
111ASET ;This isn't used for the 111 Field
 Q
 ;Facility ID
336GET I '$D(SPECIAL(336)) S ABSP("X")=""
 ELSE  X SPECIAL(336)
 Q
336FMT S:ABSP("X")'="" ABSP("X")="8C"_$$ANFF^ABSPECFM($G(ABSP("X")),10)
 Q
336SET ;Not Yet Implemented
 Q
 ;Facility Name
385GET I '$D(SPECIAL(385)) S ABSP("X")=""
 ELSE  X SPECIAL(385)
 Q
385FMT S:ABSP("X")'="" ABSP("X")="3Q"_$$ANFF^ABSPECFM($G(ABSP("X")),30)
 Q
385SET ;Not Yet Implemented
 Q
 ;Facility Street Address
386GET I '$D(SPECIAL(386)) S ABSP("X")=""
 ELSE  X SPECIAL(386)
 Q
386FMT S:ABSP("X")'="" ABSP("X")="3U"_$$ANFF^ABSPECFM($G(ABSP("X")),30)
 Q
386SET ;Not Yet Implemented
 Q
 ;Facility City Address
388GET I '$D(SPECIAL(388)) S ABSP("X")=""
 ELSE  X SPECIAL(388)
 Q
388FMT S:ABSP("X")'="" ABSP("X")="5J"_$$ANFF^ABSPECFM($G(ABSP("X")),20)
 Q
388SET S $P(^ABSPC(ABSP(9002313.02),388),U,1)=ABSP("X")
 Q
 ;Facility State/Province Address
387GET I '$D(SPECIAL(387)) S ABSP("X")=""
 ELSE  X SPECIAL(387)
 Q
387FMT S:ABSP("X")'="" ABSP("X")="3V"_$$ANFF^ABSPECFM($G(ABSP("X")),2)
 Q
387SET ;Not Yet Implemented
 Q
 ;Facility Zip
389GET I '$D(SPECIAL(389)) S ABSP("X")=""
 ELSE  X SPECIAL(389)
 Q
389FMT S:ABSP("X")'="" ABSP("X")="6D"_$$ANFF^ABSPECFM($G(ABSP("X")),15)
 Q
389SET ;Not Yet Implemented
 Q
NARRATIVE ;EP CALLED FROM ABSPDB1 to set up NARRATIVE SEGMENT
 Q:$D(SUPRESSG("Narrative"))
 N FIELD
 S RECORD=$G(RECORD)
 F FIELD="111B",390 D
 . Q:$D(SUPRESF(FIELD))
 . I (ACTION["CLAIM"),(FIELD'=111) D
 . . D @(FIELD_"GET")
 . . D @(FIELD_"FMT")
 . . D @(FIELD_"SET")
 . ELSE  D APPEND(FIELD)
 Q
 ;Segment identifier
111BGET S ABSP("X")=16
 Q
111BFMT S ABSP("X")=$$ANFF^ABSPECFM(ABSP("X"),2)
 Q
111BSET ;This isn't used for the 111 Field
 Q
 ;Narrative Message
390GET I '$D(SPECIAL(390)) S ABSP("X")=""
 ELSE  X SPECIAL(390)
 Q
390FMT S:ABSP("X")'="" ABSP("X")="BM"_$$ANFF^ABSPECFM($G(ABSP("X")),200)
 Q
390SET S $P(^ABSPC(ABSP(9002313.02),390),U,1)=ABSP("X")
 Q
APPEND(FIELD) ;This is where the record is built field by field
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
