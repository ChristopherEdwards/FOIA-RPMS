APCLAPI7 ; IHS/CMI/LAB - visit data ; 15 Nov 2010  10:01 AM
 ;;2.0;IHS PCC SUITE;**5,7**;MAY 14, 2009
 ;IHS/TUCSON/LAB - added G parameter to provider call
 ;
 ;
 ;
 ;
VR ;EP
 S APCLLAST=$P(Y,U,1)_"^"_$P($$CPT^ICPTCOD(Y),U,2)_" "_$$VAL^XBDIQ1(9000010.22,.01,X)_"^^"_$P(^AUPNVRAD(X,0),U,3)_"^9000010.22^"_X
 Q
 ;
E ;
 I $P(APCLVAL,U,1)>$P(APCLLAST,U,1) S APCLLAST=APCLVAL
 Q
LASTSMOK(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last TOBACCO (SMOKING)
 ;  Return the last recorded TOBACCO SMOKING SCREENING:
 ;   - V Health Factor in Category TOBACCO (SMOKING)
 ;   - V CPT [BGP SMOKING CPTS]
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
 ; 
 I $G(APCLPDFN)="" Q ""
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(APCLPDFN)
 I $G(APCLED)="" S APCLED=DT
 I $G(APCLFORM)="" S APCLFORM="D"
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E
 S APCLLAST=""
 S APCLVAL=$$LASTHF^APCLAPIU(APCLPDFN,"TOBACCO (SMOKING)",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S R=$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD)
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,R,APCLED,"APCL TOBACCO (SMOKING) CPTS","A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"1320","ADA",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"[BGP GPRA SMOKING DXS","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTSMLE(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last TOBACCO (SMOKING)
 ;  Return the last recorded TOBACCO SMOKING SCREENING:
 ;   - V Health Factor in Category TOBACCO (SMOKLESS - CHEWING/DIP)
 ;   - V CPT [BGP SMOKELESS TOBACCO CPTS]
 ;   - V DENTAL ADA 1320
 ;     
 ;  Input:
 ;   APCLPDFN - Patient DFN
 ;   APCLBD - beginning date to begin search for value - if blank, default is DOB
 ;   APCLED - ending date of search - if blank, default is DT
 ;   APCLFORM -  APCLFORM returned:  D - return date only - example 3070801
 ;                                 A - return value:
 ;                       date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ; 
 I $G(APCLPDFN)="" Q ""
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(APCLPDFN)
 I $G(APCLED)="" S APCLED=DT
 I $G(APCLFORM)="" S APCLFORM="D"
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E
 S APCLLAST=""
 S APCLVAL=$$LASTHF^APCLAPIU(APCLPDFN,"TOBACCO (SMOKELESS - CHEWING/DIP)",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S R=$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD)
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,R,APCLED,"BGP SMOKELESS TOBACCO CPTS","A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"1320","ADA",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTSMEX(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last TOBACCO (EXPOSURE)
 ;  Return the last recorded TOBACCO SMOKING EXPOSURE SCREENING:
 ;   - V Health Factor in Category TOBACCO (EXPOSURE)
 ;     
 ;  Input:
 ;   APCLPDFN - Patient DFN
 ;   APCLBD - beginning date to begin search for value - if blank, default is DOB
 ;   APCLED - ending date of search - if blank, default is DT
 ;   APCLFORM -  APCLFORM returned:  D - return date only - example 3070801
 ;                                 A - return value:
 ;                       date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ; 
 I $G(APCLPDFN)="" Q ""
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(APCLPDFN)
 I $G(APCLED)="" S APCLED=DT
 I $G(APCLFORM)="" S APCLFORM="D"
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E
 S APCLLAST=""
 S APCLVAL=$$LASTHF^APCLAPIU(APCLPDFN,"TOBACCO (EXPOSURE)",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S R=$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD)
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
PREFLANG(P,EDATE,F) ;EP - return the patient's preferred language as of date EDATE
 I '$G(P) Q ""
 I '$D(^AUPNPAT(P)) Q ""
 I '$O(^AUPNPAT(P,86,0)) Q ""  ;no language data
 I $G(F)="" S F="I"
 I $G(EDATE)="" S EDATE=DT
 NEW X,Y,D
 S (X,Y,D)=""
 F  S D=$O(^AUPNPAT(P,86,"B",D)) Q:D'=+D!(D>EDATE)  D
 .S X=0 F  S X=$O(^AUPNPAT(P,86,"B",D,X)) Q:X'=+X  D
 ..I $P(^AUPNPAT(P,86,X,0),U,4)]"" S Y=$P(^AUPNPAT(P,86,X,0),U,4)  ;preferred language documented
 ..Q
 I F="E" Q $S(Y:$P(^AUTTLANG(Y,0),U,1),1:"")
 I F="I" Q Y
 Q Y
ETHN(P,F) ;EP
 I '$G(P) Q ""
 I $G(F)="" S F="E"
 I '$D(^DPT(P,0)) Q ""
 NEW Z,E,I
 S (E,I)=""
 S Z=0 F  S Z=$O(^DPT(P,.06,Z)) Q:Z'=+Z!(E]"")  D
 .S I=$P($G(^DPT(P,.06,Z,0)),U,1)
 .Q:I=""
 .S E=$P($G(^DIC(10.2,I,0)),U,1)
 .Q
 I F="E" Q E
 I F="I" Q I
 Q ""
LASTNAA ;EP
 ;  Return the last recorded NO ACTIVE PROBLEMS FROM V UPDATED/REVIEWED:
 ;   .09 OF V UPDATED/REVIEWED is set to 1
 ;     
 ;  Input:
 ;   APCLPDFN - Patient DFN
 ;   APCLBD - beginning date to begin search for value - if blank, default is DOB
 ;   APCLED - ending date of search - if blank, default is DT
 ;   APCLFORM -  APCLFORM returned:  D - return date only - example 3070801
 ;                                 A - return value:
 ;                       date^text of item found^provider who documented^visit ien^File found in^ien of file found in
 ;             Default if blank is D
 ;  Output:
 ;   If APCLFORM is blank or APCLFORM is D returns internal fileman date if one found otherwise returns null
 ;   If APCLFORM is A returns the string:
 ;     date^text of item found^PROVIDER^visit ien^File found in^ien of file found in
 ; 
 I $G(APCLPDFN)="" Q ""
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(APCLPDFN)
 I $G(APCLED)="" S APCLED=DT
 I $G(APCLFORM)="" S APCLFORM="D"
 NEW APCLLAST,APCLVAL,APCLX,R,X,Y,V,E,D,G,ED,BD
 S BD=9999999-APCLBD
 S ED=9999999-APCLED
 S APCLLAST=""
 S V=$O(^AUTTCRA("C","NAA",0))
 I 'V Q ""
 S D=ED-1,D=D_".999999" F  S D=$O(^AUPNVRUP("AA",APCLPDFN,V,D)) Q:D'=+D!($P(D,".")>BD)  D
 .S X=0 F  S X=$O(^AUPNVRUP("AA",APCLPDFN,V,D,X)) Q:X'=+X  D
 ..Q:'$D(^AUPNVRUP(X,0))
 ..Q:$P($G(^AUPNVRUP(X,2)),U,1)
 ..S APCLVAL=$P($P(^AUPNVRUP(X,12),U),".")_U_$$VAL^XBDIQ1(9000010.54,X,.01)_U_$P($G(^AUPNVRUP(X,12)),U,4)_U_$P(^AUPNVRUP(X,0),U,3)_U_9000010.54_U_X
 ..D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
DEFEDD(P) ;PEP - return definitive EDD Date^definitive EDD type
 I '$G(P) Q ""  ;no patient
 I '$D(^AUPNREP(P,0)) Q ""  ;NOT IN RF
 NEW X,Y
 Q:$$VALI^XBDIQ1(9000017,P,1311)
 ;I X="" Q ""  ;no definitive EDD documented
 ;I X="L" Q $$VAL^XBDIQ1(9000017,P,1302)_U_$$VAL^XBDIQ1(9000017,P,1311)
 ;I X="U" Q $$VAL^XBDIQ1(9000017,P,1305)_U_$$VAL^XBDIQ1(9000017,P,1311)
 ;I X="C" Q $$VAL^XBDIQ1(9000017,P,1308)_U_$$VAL^XBDIQ1(9000017,P,1311)
 ;Q ""
LASTEDD(P) ;PEP - LAST DOCUMENTED EDD
 I '$G(P) Q ""  ;no patient
 I '$D(^AUPNREP(P,0)) Q ""  ;NOT IN RF
 NEW X,Y,LAST,LASTDOC
 S (LAST,LASTDOC)=""
 S X=$P($G(^AUPNREP(P,13)),U,3) I X S LASTDOC=X,LAST=$P($G(^AUPNREP(P,13)),U,2)_U_"(BY LMP)"  ;LMP
 S X=$P($G(^AUPNREP(P,13)),U,6)
 I X,X'<LASTDOC S LASTDOC=X,LAST=$P($G(^AUPNREP(P,13)),U,5)_U_"(BY ULTRASOUND)"
 S X=$P($G(^AUPNREP(P,13)),U,9)
 I X,X'<LASTDOC S LASTDOC=X,LAST=$P($G(^AUPNREP(P,13)),U,8)_U_"(BY CLINICAL PARAMETERS)"
 S X=$P($G(^AUPNREP(P,13)),U,15)
 I X,X'<LASTDOC S LASTDOC=X,LAST=$P($G(^AUPNREP(P,13)),U,14)_U_"(BY METHOD UNKNOWN)"
 S X=$P($G(^AUPNREP(P,13)),U,11)
 I X,X'<LASTDOC S LASTDOC=X,LAST=$P($G(^AUPNREP(P,13)),U,11)_U_"(DEFINITIVE)"
 Q LAST
