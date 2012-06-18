APCLAPI1 ; IHS/CMI/LAB - visit data ; 02 Sep 2010  7:04 AM
 ;;2.0;IHS PCC SUITE;**2,5,7**;MAY 14, 2009
 ;IHS/TUCSON/LAB - added G parameter to provider call
 ;
 ;
 ;BJPC v1.0 patch 1
 ;
LASTMAM(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last MAMMOGRAM
 ;  Return the last recorded MAMMOGRAM:
 ;   - V Radiology with CPT in BGP CPT MAMMOGRAM taxonomy
 ;   - Diagnosis - V POV V76.11, V76.12
 ;   - Procedures: 87.36, 87.37
 ;   - V CPT:  BGP CPT MAMMOGRAM taxonomy
 ;   - Women's Health Procedures: MAMMOGRAM SCREENING, MAMMOGRAM DX UNILAT, MAMMOGRAM DX BILAT
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
 S APCLVAL=$$LASTRADT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP CPT MAMMOGRAM","A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V76.11","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V76.12","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"87.36","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"87.37","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP CPT MAMMOGRAM","A")
 D E
 ;if wh v3.0 get date for last mammogram
 ;I $$VERSION^XPDUTL("BW")>2.9 F X="MAMMOGRAM SCREENING","MAMMOGRAM DX UNILATERAL","MAMMOGRAM DX BILATERAL","MAMMOGRAM, UNSPECIFIED" D
 ;.S T=$O(^BWVPDT("B",X,0))
 ;.S V=$$WHAPI^BWVPAT1(APCLPDFN,T)
 ;.I $P(V,U)=0 S $P(V,U)=""
 ;.Q:$P(APCLLAST,U)>$P(V,U)
 ;.S APCLLAST=$P(V,U)_"^WH: "_X_"^^^90515^"
 ;now check wh package directly
 F X="MAMMOGRAM SCREENING","MAMMOGRAM DX UNILAT","MAMMOGRAM DX BILAT" D
 .S T=$O(^BWPN("B",X,0))
 .I T D
 ..S (G,V)=0 F  S V=$O(^BWPCD("C",APCLPDFN,V)) Q:V=""!(G)  D
 ...Q:'$D(^BWPCD(V,0))
 ...I $P(^BWPCD(V,0),U,4)'=T Q
 ...S D=$P(^BWPCD(V,0),U,12)
 ...Q:$P(APCLLAST,U)>D
 ...Q:D>APCLED
 ...Q:$$VAL^XBDIQ1(9002086.1,V,.05)="Error/disregard"
 ...S APCLLAST=D_"^WH: "_X_"^^^9002086.1^"_V
 .Q
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
 ;
LASTPAP(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last PAP SMEAR
 ;  Return the last recorded PAP SMEAR:
 ;   - V Lab "PAP SMEAR" or in BGP PAP SMEAR TAX taxonomy
 ;   - Diagnosis - in BGP PAP SMEAR DXS taxonomy
 ;   - Procedures: 91.46
 ;   - V CPT:  BGP CPT PAP taxonomy
 ;   - Women's Health Procedures: PAP SMEAR
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"[BGP PAP SMEAR TAX","LAB",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"PAP SMEAR","LAB",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"[BGP PAP SMEAR DX","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"91.46","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP CPT PAP","A")
 D E
 ;if wh v3.0 get date for last mammogram
 ;I $$VERSION^XPDUTL("BW")>2 F X="PAP SMEAR" D
 ;.S T=$O(^BWVPDT("B",X,0))
 ;.S V=$$WHAPI^BWVPAT1(APCLPDFN,T)
 ;.I $P(V,U)=0 S $P(V,U)=""
 ;.Q:$P(APCLLAST,U)>$P(V,U)
 ;.S APCLLAST=$P(V,U)_"^WH: "_X_"^^^90515^"
 ;now check wh package directly
 F X="PAP SMEAR" D
 .S T=$O(^BWPN("B",X,0))
 .I T D
 ..S (G,V)=0 F  S V=$O(^BWPCD("C",APCLPDFN,V)) Q:V=""!(G)  D
 ...Q:'$D(^BWPCD(V,0))
 ...I $P(^BWPCD(V,0),U,4)'=T Q
 ...S D=$P(^BWPCD(V,0),U,12)
 ...Q:$P(APCLLAST,U)>D
 ...Q:D>APCLED
 ...Q:$$VAL^XBDIQ1(9002086.1,V,.05)="Error/disregard"
 ...S APCLLAST=D_"^WH: "_X_"^^^9002086.1^"_V
 .Q
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTTOBS(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last TOBACCO USE SCREENING
 ;THIS HAS BEEN UPDATED TO LOOK AT 3 CATEGORIES OF TOBACCO HEALTH FACTORS, IF YOU JUST WANT
 ;SMOKING USE API LASTSMOK, IF YOU WANT LAST SMOKELESS USE LASTSMLE IF YOU WANT EXPOSURE USE
 ;LASTSMEX
 ;  Return the last recorded TOBACCO USE SCREENING:
 ;   - V Health Factor in Category TOBACCO (SMOKING), TOBACCO (SMOKELESS - CHEWING/DIP), TOBACCO (EXPOSURE)
 ;   - V CPT 1034F, 1035F, 1036F
 ;   - V POV [BGP GPRA SMOKING DXS]
 ;   - V DENTAL ADA 1320
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
 S APCLVAL=$$LASTHF^APCLAPIU(APCLPDFN,"TOBACCO (SMOKING)",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTHF^APCLAPIU(APCLPDFN,"TOBACCO (SMOKELESS - CHEWING/DIP)",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTHF^APCLAPIU(APCLPDFN,"TOBACCO (EXPOSURE)",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S R=$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD)
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,R,APCLED,"BGP TOBACCO SCREEN CPTS","A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"1320","ADA",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"[BGP GPRA SMOKING DXS","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTTON(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last TONOMETRY
 ;  Return the last recorded TONOMETRY:
 ;   - V Exam - 26 TONOMETRY
 ;   - V Measurement - TON
 ;   - Procedures: 89.11, 95.26
 ;   - V CPT:  S0620, S0621, 92100, 92120, 92499
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,26,"EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"TON","MEASUREMENT",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"89.11","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"95.26","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTI^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"S0620;S0621;92100;92120;92499","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTVAE(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last VISUAL ACUITY EXAM
 ;  Return the last recorded VISUAL ACUITY EXAM:
 ;   - V Exam - 19 VISION EXAM
 ;   - V Measurement - VU - VISION UNCORRECTED or VC - VISION CORRECTED
 ;   - Procedures: 95.09, 95.05
 ;   - V CPT:  99172, 99173
 ;   - V POV: V72.0
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,26,"EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"07","MEASUREMENT",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"08","MEASUREMENT",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V72.0","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"95.05","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"95.09","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTI^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"99172;99173","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
