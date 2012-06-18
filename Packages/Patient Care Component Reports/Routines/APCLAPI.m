APCLAPI ; IHS/CMI/LAB - visit data ; 25 Feb 2011  11:02 AM
 ;;2.0;IHS PCC SUITE;**6**;MAY 14, 2009;Build 11
 ;
LASTALC(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last alcohol screen
 ;  Return the last recorded alcohol screening value:
 ;   - V Exam 35 or Behavioral Health Module Alcohol Screening
 ;   - V measurement AUDC, AUDT, CRFT
 ;   - Health Factor with Alcohol/Drug Category (CAGE)
 ;   - Diagnosis - V POV V79.1
 ;   - Education Topics - V EDUCATION or Behavioral Health Module
 ;     AOD-SCR
 ;     CD-SCR
 ;   - Behavioral Health Module Diagnosis (POV) of 29.1
 ;   - cpts in BGP ALCOHOL SCREENING CPTS taxonomy
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
 NEW APCLLAST,APCLVAL,APCLX
 S APCLLAST=""
 S APCLVAL=$$LASTALCS(APCLPDFN,APCLBD,APCLED,"A")
 D E
 S APCLVAL=$$LASTHF^APCLAPIU(APCLPDFN,"ALCOHOL/DRUG",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V79.1","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"AUDC","MEASUREMENT",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"AUDT","MEASUREMENT",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"CRFT","MEASUREMENT",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLX=0 F  S APCLX=$O(^AUTTEDT("C","AOD-SCR",APCLX)) Q:APCLX'=+APCLX  D
 .S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"`"_APCLX,"EDUCATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 .D E
 S APCLX=0 F  S APCLX=$O(^AUTTEDT("C","CD-SCR",APCLX)) Q:APCLX'=+APCLX  D
 .S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"`"_APCLX,"EDUCATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 .D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP ALCOHOL SCREENING CPTS","A")
 D E
 S APCLVAL=$$LASTBHDX^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"29.1","A")
 D E
 S APCLVAL=$$LASTBHED^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"AOD-SCR","A")
 D E
 S APCLVAL=$$LASTBHED^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"CD-SCR","A")
 D E
 S APCLVAL=$$LASTBHME^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"AUDC","A")
 D E
 S APCLVAL=$$LASTBHME^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"AUDT","A")
 D E
 S APCLVAL=$$LASTBHME^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"CRFT","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
VE(Y,F,T) ;EP
 Q $P(Y,U,1)_"^Exam: "_$P(Y,U,3)_"^"_$$VAL^XBDIQ1(9000010.13,+$P(Y,U,4),.04)_"^"_$P(Y,U,5)_"^9000010.13^"_+$P(Y,U,4)
 ;
LASTALCS(P,BD,ED,F) ;
 ;look for last exam in v exam or bh between bd and ed
 NEW %,E,D,V,X,G
 NEW APCLG,APCLX,APCLC,APCLV
 S %=P_"^LAST EXAM 35;DURING "_BD_"-"_ED,E=$$START1^APCLDF(%,"APCLG(")
 I $D(APCLG(1)) S APCLX(9999999-$P(APCLG(1),U))=$$VE(APCLG(1))
 ;AMHREC field
 S APCLC=0,APCLV=""
 S E=(9999999-BD),D=9999999-ED-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!(APCLC)!($P(D,".")>E)  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(APCLC)  D
 .S X=$P($G(^AMHREC(V,14)),U,3)
 .I X="" Q  ;no test
 .I $E(X)="U" Q  ;don't count refusal here
 .I X="REF" Q
 .S G=9999999-$P(D,".")
 .Q:$D(APCLX($P(D,".")))  ;already have exam on this date so don't bother
 .S APCLX($P(D,"."))=G_"^BH: ALCOHOL SCREENING^"_$$VAL^XBDIQ1(9002011,V,1403)_"^^9002011^"_V
 I $O(APCLX(0)) S G=$O(APCLX(0)) Q $S(F="D":$P(APCLX(G),U,1),1:APCLX(G))
 Q ""
 ;
E ;
 I $P(APCLVAL,U,1)>$P(APCLLAST,U,1) S APCLLAST=APCLVAL
 Q
 ;
LASTDEPS(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - return last depression screen
 ;  Return the last recorded depression screening value:
 ;   - V Exam 36 or Behavioral Health Module Depression Screening
 ;   - Diagnosis - V POV V79.0
 ;   - Education Topics - V EDUCATION or Behavioral Health Module
 ;     DEP-SCR
 ;   - V Measurement PHQ2, PHQ9
 ;   - Behavioral Health Module Diagnosis (POV) of 14.1
 ;   - Diagnosis in BGP MOOD DISORDERS taxonomy in V POV
 ;   - Diagnosis in BGP MOOD DISORDERS taxonomy in BH
 ;   - Problem Code of 14 or 15 in BH
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
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(APCLPDFN)
 I $G(APCLED)="" S APCLED=DT
 I $G(APCLFORM)="" S APCLFORM="D"
 NEW APCLLAST,APCLVAL,APCLX
 S APCLLAST=""
 S APCLVAL=$$LASTDEP(APCLPDFN,APCLBD,APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V79.0","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"PHQ2","MEASUREMENT",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"PHQ9","MEASUREMENT",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLX=0 F  S APCLX=$O(^AUTTEDT("C","DEP-SCR",APCLX)) Q:APCLX'=+APCLX  D
 .S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"`"_APCLX,"EDUCATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 .D E
 S APCLVAL=$$LASTBHDX^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"14.1","A")
 D E
 S APCLVAL=$$LASTBHED^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"DEP-SCR","A")
 D E
 ;now check for mood disorders
 S APCLVAL=$$LASTDXT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP MOOD DISORDERS","A")
 D E
 S APCLVAL=$$LASTBHDT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP MOOD DISORDERS","A")
 D E
 S APCLVAL=$$LASTBHDX^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"14","A")
 D E
 S APCLVAL=$$LASTBHDX^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"15","A")
 D E
 S APCLVAL=$$LASTBHME^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"PHQ2","A")
 D E
 S APCLVAL=$$LASTBHME^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"PHQ9","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTDEP(P,BD,ED,F) ;
 NEW %,E,D,V,X,G
 NEW APCLG,APCLX,APCLC,APCLV
 S %=P_"^LAST EXAM 36;DURING "_BD_"-"_ED,E=$$START1^APCLDF(%,"APCLG(")
 I $D(APCLG(1)) S APCLX(9999999-$P(APCLG(1),U))=$$VE(APCLG(1))
 ;now look at AMHREC
 S APCLC=0,APCLV=""
 S E=(9999999-BD),D=9999999-ED-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!(APCLC)!($P(D,".")>E)  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(APCLC)  D
 .S X=$P($G(^AMHREC(V,14)),U,5)
 .I X="" Q  ;no test
 .I $E(X)="U" Q  ;don't count refusal here
 .I X="REF" Q
 .S G=9999999-$P(D,".")
 .Q:$D(APCLX($P(D,".")))  ;already have exam on this date so don't bother
 .S APCLX($P(D,"."))=G_"^BH: DEPRESSION SCREENING^"_$$VAL^XBDIQ1(9002011,V,1405)_"^^9002011^"_V
 I $O(APCLX(0)) S G=$O(APCLX(0)) Q $S(F="D":$P(APCLX(G),U,1),1:APCLX(G))
 Q ""
 ;
LASTIPVS(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last ipv screen
 ;   - V Exam 34 or Behavioral Health IPV Screening
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
 NEW APCLLAST,APCLVAL,APCLX
 S APCLLAST=""
 S APCLVAL=$$LASTIPV(APCLPDFN,APCLBD,APCLED,"A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTIPV(P,BD,ED,APCLF) ;
 NEW %,E,D,V,X,G
 NEW APCLG,APCLX,APCLC,APCLV
 S %=P_"^LAST EXAM 34;DURING "_BD_"-"_ED,E=$$START1^APCLDF(%,"APCLG(")
 I $D(APCLG(1)) S APCLX(9999999-$P(APCLG(1),U))=$$VE(APCLG(1))
 ;now look at AMHREC field
 S APCLC=0,APCLV=""
 S E=(9999999-BD),D=9999999-ED-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!(APCLC)!($P(D,".")>E)  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(APCLC)  D
 .S X=$P($G(^AMHREC(V,14)),U,1)
 .I X="" Q  ;no test
 .I $E(X)="U" Q  ;don't count refusal here
 .I X="REF" Q
 .S G=9999999-$P(D,".")
 .Q:$D(APCLX($P(D,".")))
 .S APCLX($P(D,"."))=G_"^BH: IPV SCREENING^"_$$VAL^XBDIQ1(9002011,V,1401)_"^^9002011^"_V
 I $O(APCLX(0)) S G=$O(APCLX(0)) Q $S(APCLFORM="D":$P(APCLX(G),U,1),1:APCLX(G))
 Q ""
 ;
LASTCOLO(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - return last Colonoscopy
 ;  Return the last recorded colonoscopy
 ;   - V Procedure: 45.43, 45.22, 45.23, 45.25
 ;   - V CPT : BGP COLO CPTS taxonomy
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
 I '$G(APCLPDFN) Q ""
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(APCLPDFN)
 I $G(APCLED)="" S APCLED=DT
 I $G(APCLFORM)="" S APCLFORM="D"
 NEW APCLLAST,APCLVAL,APCLX,E,%,T
 S APCLVAL="",APCLLAST=""
 S APCLVAL=$$LASTPRCT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP COLO PROCS","A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP COLO CPTS","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTFSIG(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - return last sigmoidoscopy
 ;  Return the last recorded flexible sigmoidoscopy
 ;   - V Procedure: 45.24, 45.42
 ;   - V CPT : BGP SIG CPTS taxonomy
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
 I '$G(APCLPDFN) Q ""
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(APCLPDFN)
 I $G(APCLED)="" S APCLED=DT
 I $G(APCLFORM)="" S APCLFORM="D"
 NEW APCLLAST,APCLVAL,APCLX,E,%,T
 S APCLVAL="",APCLLAST=""
 S APCLVAL=$$LASTPRCT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP SIG PROCS","A")
 D E
 ;S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"45.24","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 ;D E
 ;S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"45.42","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 ;D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP SIG CPTS","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
REMDEPS(P,APCLBD,APCLED) ;PEP - called from reminders to get data on last depression screening exam
 ;  Input:
 ;   APCLPDFN - Patient DFN
 ;   APCLBD - beginning date to begin search for value - if blank, default is DOB
 ;   APCLED - ending date of search - if blank, default is DT
 ;
 ;  Output:
 ;returns the string:
 ;    1 or 0^date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ; piece 1:  1 if item found, 0 if no depression screening found in the date range
 ;       2:  date of last depression screening
 ;       3:  text of item found
 ;       4:  value - result
 ;       5:  visit ien on which item found
 ;       6:  file item found in (usually a V File #)
 ;       7:  ien of V File entry found
 ;       
 I '$G(P) Q 0
 I $G(APCLBD)="" S APCLBD=$$DOB^AUPNPAT(P)
 I $G(APCLED)="" S APCLED=DT
 NEW APCLR
 S APCLR=$$LASTDEPS(P,APCLBD,APCLED,"A")
 I APCLR]"" Q 1_"^"_APCLR
 Q 0
