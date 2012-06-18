APCLAPI2 ; IHS/CMI/LAB - visit data ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/TUCSON/LAB - added G parameter to provider call
 ;
 ;
 ;BJPC v1.0 patch 1
 ;
LASTFRA(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last FALL RISK ASSESSMENT
 ;  Return the last recorded FALL RISK ASSESSMENT:
 ;   - V Exam - 37 Fall Risk Exam
 ;   - Diagnosis - V POV V15.88 OR BGP ABNORMAL GAIT OR MOBILITY taxonomy
 ;   - V POV: Ecode in BGP FALL RELATED E-CODES taxonomy
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,37,"EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V15.88","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"[BGP ABNORMAL GAIT OR MOBILITY","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S Y="APCLY("
 K APCLY
 S X=APCLPDFN_"^ALL DX;DURING "_$$FMADD^XLFDT(APCLED,-365)_"-"_DT S E=$$START1^APCLDF(X,Y)
 S G=""
 S T=$O(^ATXAX("B","BGP FALL RELATED E-CODES",0))
 S X=0 F  S X=$O(APCLY(X)) Q:X'=+X  D
 .S G="" S Y=+$P(APCLY(X),U,4),D=$P(^AUPNVPOV(Y,0),U)
 .I $P(^AUPNVPOV(Y,0),U,9)="",$P(^AUPNVPOV(Y,0),U,18)="",$P(^AUPNVPOV(Y,0),U,19)="" Q
 .S E=$P(^AUPNVPOV(Y,0),U,9) I E,$$ICD^ATXCHK(E,T,9) D VPVE Q
 .S E=$P(^AUPNVPOV(Y,0),U,18) I E,$$ICD^ATXCHK(E,T,9) D VPVE Q
 .S E=$P(^AUPNVPOV(Y,0),U,19) I E,$$ICD^ATXCHK(E,T,9) D VPVE Q
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
VPVE ;EP
 S APCLLAST=$$VD^APCLV($P(^AUPNVPOV(Y,0),U,3))_"^ECODE: "_$P($$ICDDX^ICDCODE(E),U,2)_"^"_$$VAL^XBDIQ1(9000010.07,Y,.04)_"^"_$P(^AUPNVPOV(X,0),U,3)_"^9000010.07^"_Y
 Q
 ;
E ;
 I $P(APCLVAL,U,1)>$P(APCLLAST,U,1) S APCLLAST=APCLVAL
 Q
 ;
LASTHC(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last head circumference
 ;  Return the last recorded HEAD CIRCUMFERENCE:
 ;   - V Measurment HC
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"HC","MEASUREMENT",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ; 
LASTDENT(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last dental exam
 ;  Return the last recorded dental exam:
 ;   - V Dental ADA code 0000 or 0190
 ;   - V Exam 30 - Dental Exam
 ;   - CHS visit with any ADA code
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"0000","ADA",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"0190","ADA",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,30,"EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 ;now check CHS visits for any ADA
 K APCLY
 S X=APCLPDFN_"^ALL ADA;DURING "_$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD)_"-"_APCLED S E=$$START1^APCLDF(X,"APCLY(")
 S X=0 F  S X=$O(APCLY(X)) Q:X'=+X  D
 .S V=$P(APCLY(X),U,4)
 .Q:$P($G(^AUPNVSIT(V,0)),U,3)'="C"
 .S APCLVAL=$P(APCLY(X),U)_"^ADA: "_$P(APCLY(X),U,2)_"^^"_$P(APCLY(X),U,5)_"^9000010.05^"_+$P(APCLY(X),U,4)
 .D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTDEYE(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last diabetic eye exam
 ;  Return the last recorded DIABETIC EYE exam:
 ;   - V Exam Diabetic Eye Exam
 ;   - V CPT 92250, 92012, 92014, 92002, 2022F, 2024F, 2026F, S3000
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"03","EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"APCH DIABETIC EYE EXAM CPTS","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ; 
LASTDFE(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last diabetic FOOT exam
 ;  Return the last recorded DIABETIC FOOT exam:
 ;   - V Exam Diabetic FOOT Exam
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"28","EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ; 
LASTRECT(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last RECTAL exam
 ;  Return the last recorded RECTAL exam:
 ;   - V Exam Rectal Exam 14
 ;   - V POV V76.41, V76.44
 ;   - V Procedure 89.34
 ;   - V CPT G0102;S0601;S0605
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"14","EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V76.41","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V76.44","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"89.34","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTI^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"G0102;S0601;S0605","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTPELV(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last PELVIC exam
 ;  Return the last recorded PELVIC exam:
 ;   - V Exam Pelvic Exam 15
 ;   - V POV V72.31, V72.32
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"15","EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V72.31","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V72.32","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTI^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"G0101","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTPHYS(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last PHYSICAL exam
 ;  Return the last recorded PHYSICAL exam:
 ;   - V Exam Physical Exam 01
 ;   - V POV [SURVEILLANCE PHYSICAL EXAM] taxonomy
 ;   - V CPT [APCH PHYSICAL EXAM CPTS] taxonomy
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"01","EXAM",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"[SURVEILLANCE PHYSICAL EXAM","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"APCH GENERAL EXAM CPTS","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
