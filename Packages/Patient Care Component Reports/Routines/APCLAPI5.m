APCLAPI5 ; IHS/CMI/LAB - visit data ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;IHS/TUCSON/LAB - added G parameter to provider call
 ;
 ;
 ;
LASTCHLA(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last CHLAMYDIA SCREENING
 ;  Return the last recorded CHLAMYDIA SCREENING:
 ;   - Diagnosis - V POV V73.88, V73.98
 ;   - V CPT:  BGP CHLAMYDIA CPTS taxonomy
 ;   - V LAB : BGP CHLAMYDIA TESTS TAX, BGP CHLAMYDIA LOINC CODES
 ;     
 ;  Input:
 ;   APCLPDFN - Patient DFN
 ;   APCLBD - beginning date to begin search for value - if blank, default is DOB
 ;   APCLED - ending date of search - if blank, default is DT
 ;   APCLFORM -  APCLFORM returned:  D - return date only - example 3070801
 ;                                 A - return value:
 ;                       date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ;             Default if blank is D
 ;  Output:
 ;   If APCLFORM is blank or APCLFORM is D returns internal fileman date if one found otherwise returns null
 ;   If APCLFORM is A returns the string:
 ;     date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ; 
 I $G(APCLPDFN)="" Q ""
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(APCLPDFN)
 I $G(APCLED)="" S APCLED=DT
 I $G(APCLFORM)="" S APCLFORM="D"
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E
 S APCLLAST=""
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V73.88","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V73.98","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP CHLAMYDIA CPTS","A")
 D E
 S APCLVAL=$$LASTLAB^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,,$O(^ATXLAB("B","BGP CHLAMYDIA TESTS TAX",0)),,$O(^ATXAX("B","BGP CHLAMYDIA LOINC CODES",0)),"A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
VR ;EP
 S APCLLAST=$P(Y,U,1)_"^"_$P($$CPT^ICPTCOD(Y),U,2)_" "_$$VAL^XBDIQ1(9000010.22,.01,X)_"^^"_$P(^AUPNVRAD(X,0),U,3)_"^9000010.22^"_X
 Q
 ;
E ;
 I $P(APCLVAL,U,1)>$P(APCLLAST,U,1) S APCLLAST=APCLVAL
 Q
LASTHIVS(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - LAST HIV SCREENING
 ;
 ;  Return the last recorded HIV SCREENING:
 ;   
 ;   - V CPT:  BGP CPT HIV TESTS taxonomy
 ;   - V LAB : BGP HIV TEST TAX, BGP HIV TEST LOINC CODES
 ;     
 ;  Input:
 ;   APCLPDFN - Patient DFN
 ;   APCLBD - beginning date to begin search for value - if blank, default is DOB
 ;   APCLED - ending date of search - if blank, default is DT
 ;   APCLFORM -  APCLFORM returned:  D - return date only - example 3070801
 ;                                 A - return value:
 ;                       date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ;             Default if blank is D
 ;  Output:
 ;   If APCLFORM is blank or APCLFORM is D returns internal fileman date if one found otherwise returns null
 ;   If APCLFORM is A returns the string:
 ;     date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ; 
 I $G(APCLPDFN)="" Q ""
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(APCLPDFN)
 I $G(APCLED)="" S APCLED=DT
 I $G(APCLFORM)="" S APCLFORM="D"
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E
 S APCLLAST=""
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP CPT HIV TESTS","A")
 D E
 S APCLVAL=$$LASTLAB^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,,$O(^ATXLAB("B","BGP HIV TEST TAX",0)),,$O(^ATXAX("B","BGP HIV TEST LOINC CODES",0)),"A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
LASTNBHS(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last HEARING EXAM
 ;  Return the last recorded HEARING EXAM:
 ;   - V Exam 38&39
 ;   - V POV V72.1
 ;   - V CPT [APCH NEWBORN HEAR SCRN CPTS]
 ;   - V CPT [APCH HEARING SCREEN CPTS]
 ;   - V POV [APCH HEARLING LOSS DXS]
 ;  
 ;
 ;  Input:
 ;   APCLPDFN - Patient DFN
 ;   APCLBD - beginning date to begin search for value - if blank, default is DOB
 ;   APCLED - ending date of search - if blank, default is DT
 ;   APCLFORM -  APCLFORM returned:  D - return date only - example 3070801
 ;                                 A - return value:
 ;                       date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ;             Default if blank is D
 ;  Output:
 ;   If APCLFORM is blank or APCLFORM is D returns internal fileman date if one found otherwise returns null
 ;   If APCLFORM is A returns the string:
 ;     date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ; 
 I $G(APCLPDFN)="" Q ""
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(APCLPDFN)
 I $G(APCLED)="" S APCLED=DT
 I $G(APCLFORM)="" S APCLFORM="D"
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E,T,G,APCLY,APCLF,APCLRE,APCLLE
 S APCLLAST=""
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"38","EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A") I APCLVAL S APCLRE=1
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"39","EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A") I APCLVAL S APCLLE=1
 D E
 I '$G(APCLRE) S APCLLAST=""
 I '$G(APCLLE) S APCLLAST=""
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"APCH NEWBORN HEAR SCRN CPTS","A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"[APCH HEARING EXAM DXS","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTDXT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"APCH HEARING LOSS DXS","A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"APCH HEARING SCREEN CPTS","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
LASTNUTR(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last NUTRITION SCRFEENING
 ;  Return the last recorded NUTRITION SCREENING EXAM:
 ;   - V Nutrition Screening
 ;
 ;  Input:
 ;   APCLPDFN - Patient DFN
 ;   APCLBD - beginning date to begin search for value - if blank, default is DOB
 ;   APCLED - ending date of search - if blank, default is DT
 ;   APCLFORM -  APCLFORM returned:  D - return date only - example 3070801
 ;                                 A - return value:
 ;                       date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ;             Default if blank is D
 ;  Output:
 ;   If APCLFORM is blank or APCLFORM is D returns internal fileman date if one found otherwise returns null
 ;   If APCLFORM is A returns the string:
 ;     date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ; 
 I $G(APCLPDFN)="" Q ""
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(APCLPDFN)
 I $G(APCLED)="" S APCLED=DT
 I $G(APCLFORM)="" S APCLFORM="D"
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E,T,G,APCLY,APCLF,APCLRE,APCLLE
 S APCLLAST=""
 S X=0 F  S X=$O(^AUPNVNTS("AC",APCLPDFN,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVNTS(X))
 .S V=$P(^AUPNVNTS(X,0),U,3)
 .Q:'X
 .Q:'$D(^AUPNVSIT(V,0))
 .S V=$$VD^APCLV(V)
 .Q:V<APCLBD
 .Q:V>APCLED
 .I V>$P(APCLLAST,U,1) S APCLLAST=V_U_"NUTRITION SCREENING EXAM"_U_U_$P(^AUPNVNTS(X,0),U,3)_U_9000010.49_U_X
 I APCLFORM="D" Q $P(APCLLAST,U,1)
 Q APCLLAST
