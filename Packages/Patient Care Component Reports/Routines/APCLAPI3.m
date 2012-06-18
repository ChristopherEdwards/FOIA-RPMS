APCLAPI3 ; IHS/CMI/LAB - visit data ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;IHS/TUCSON/LAB - added G parameter to provider call
 ;
 ;
 ;BJPC v1.0 patch 1
 ;
LASTMMR(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last MMR
 ;  Return the last recorded MMR:
 ;   - V Immunization: 3, 94
 ;   - V POV V06.4
 ;   - V Procedure 99.48
 ;   - V CPT 90707;90710
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
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E,T,G,APCLY,APCLF
 S APCLLAST=""
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"3","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"94","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V06.4","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"99.48","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTI^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"90707;90710","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
E ;
 I $P(APCLVAL,U,1)>$P(APCLLAST,U,1) S APCLLAST=APCLVAL
 Q
 ;
LASTRUB(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last RUBELLA
 ;  Return the last recorded RUBELLA:
 ;   - V Immunization: 3,4,6,38,94
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
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E,T,G,APCLY,APCLF
 S APCLLAST=""
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"3","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"94","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"6","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"4","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"38","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTEPS(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last EPSDT
 ;  Return the last recorded EPSDT:
 ;   - V CPT
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
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E,T,G,APCLY,APCLF
 S APCLLAST="",APCLVAL=""
 S APCLY=$$AGE^AUPNPAT(APCLPDFN,APCLED)
 I APCLY<1 S APCLVAL=$$LASTCPTI^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"99381;99391","A")
 D E
 I APCLY>0,APCLY<5 S APCLVAL=$$LASTCPTI^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"99382;99392","A")
 D E
 I APCLY>4,APCLY<12 S APCLVAL=$$LASTCPTI^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"99383;99393","A")
 D E
 I APCLY>11,APCLY<18 S APCLVAL=$$LASTCPTI^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"99384;99394","A")
 D E
 I APCLY>17 S APCLVAL=$$LASTCPTI^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"99385;99395","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTBRST(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last BREAST EXAM
 ;  Return the last recorded BREAST EXAM:
 ;   - V Exam 06
 ;   - V POV V76.10, V76,12, V76.19
 ;   - V Procedure 89.36
 ;   - V CPT G0101
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
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E,T,G,APCLY,APCLF
 S APCLLAST=""
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"06","EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V76.10","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V76.12","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V76.19","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"89.36","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTI^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"G0101","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTGLUC(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last GLUCOSE SCREENING
 ;  Return the last recorded GLUCOSE SCREENING:
 ;   - V Lab:  DM AUDIT GLUCOSE TESTS TAX, APCH SCREENING GLUCOSE LOINC
 ;   - V POV V77.1
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
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E,T,G,APCLY,APCLF
 S APCLLAST=""
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V77.1","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTLAB^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,,$O(^ATXLAB("B","DM AUDIT GLUCOSE TESTS TAX",0)),,$O(^ATXAX("B","APCH SCREENING GLUCOSE LOINC",0)),"A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTHEAR(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last HEARING EXAM
 ;  Return the last recorded HEARING EXAM:
 ;   - V Exam 17,23,24
 ;   - V POV V72.11, V72.19
 ;   - V MEASUREMENT 09, 10
 ;   - V CPT 92553, 92552, 92555, 92556
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
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E,T,G,APCLY,APCLF
 S APCLLAST=""
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"17","EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"23","EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"24","EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"09","MEASUREMENT",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"10","MEASUREMENT",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 ;S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V72.11","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 ;D E
 ;S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V72.19","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 S APCLVAL=$$LASTDXT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"APCH HEARING EXAM DXS","A")
 D E
 S APCLVAL=$$LASTDXT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"APCH HEARING LOSS DXS","A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"APCH HEARING SCREEN CPTS","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTFOBT(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last FOBT
 ;  Return the last recorded FOBT:
 ;   - V Lab:  BGP GPRA FOB TESTS, BGP FOBT LOINC CODES
 ;   - V CPT - BGP FOBT CPTS
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
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E,T,G,APCLY,APCLF
 S APCLLAST=""
 S APCLVAL=$$LASTLAB^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,,$O(^ATXLAB("B","BGP GPRA FOB TESTS",0)),,$O(^ATXAX("B","BGP FOBT LOINC CODES",0)),"A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP FOBT CPTS","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTCHOL(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last CHOLESTEROL
 ;  Return the last recorded CHOLESTEROL:
 ;   - V Lab:  DM AUDIT CHOLESTEROL TAX, "BGP TOTAL CHOLESTEROL LOINC
 ;   - V CPT - 82465
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
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E,T,G,APCLY,APCLF
 S APCLLAST=""
 S APCLVAL=$$LASTLAB^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,,$O(^ATXLAB("B","DM AUDIT CHOLESTEROL TAX",0)),,$O(^ATXAX("B","BGP TOTAL CHOLESTEROL LOINC",0)),"A")
 D E
 S APCLVAL=$$LASTCPTI^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"82465","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
