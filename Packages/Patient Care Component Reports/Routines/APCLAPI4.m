APCLAPI4 ; IHS/CMI/LAB - visit data ; 
 ;;2.0;IHS PCC SUITE;**2,5,7**;MAY 14, 2009
 ;IHS/TUCSON/LAB - added G parameter to provider call
 ;
 ;
 ;BJPC v1.0 patch 1
 ;
LASTTD(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last TD
 ;  Return the last recorded TD:
 ;   - V Immunization: 1, 9, 20, 22, 28, 35, 50, 106, 107, 110, 112, 113, 115
 ;   - V CPT [APCH TD CPTS]
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"1","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"9","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"20","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"22","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"28","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"35","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"50","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"106","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"107","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"110","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"112","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"113","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"115","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"120","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"130","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"132","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"138","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"139","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"142","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"APCH TD CPTS","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
E ;
 I $P(APCLVAL,U,1)>$P(APCLLAST,U,1) S APCLLAST=APCLVAL
 Q
 ;
 ;
LASTPNEU(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last PNEUMOVAX
 ;  Return the last recorded PNEUMOVAX:
 ;   - V Immunization: 33, 100, 109
 ;   - V POV V06.6, V03.82
 ;   - V PROCEDURE 99.55
 ;   - V CPT [BGP PNEUMO IZ CPTS]
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"33","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"100","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"109","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"133","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V06.6","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V03.82","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"99.55","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP PNEUMO IZ CPTS","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTFLU(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last FLU
 ;  Return the last recorded FLU:
 ;   - V Immunization: 15, 16, 88, 111
 ;   - V POV V06.6, V04.81
 ;   - V PROCEDURE 99.52
 ;   - V CPT [BGP CPT FLU]
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"88","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"15","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"16","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"111","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"135","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"140","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"141","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"144","IMMUNIZATION",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V06.6","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V04.81","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"99.52","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP CPT FLU","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTBE(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last BARIUM ENEMA
 ;  Return the last recorded BARIUM ENEMA:
 ;   - V Radiology [BGP BE CPTS]
 ;   - V CPT [BGP BE CPTS]
 ;   - V PROCEDURE 87.64
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"87.64","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP BE CPTS","A")
 D E
 S APCLVAL=$$LASTRADT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP BE CPTS","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTOST(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last OSTEOPOROSIS SCREENING
 ;  Return the last recorded OSTEOPOROSIS SCREENING:
 ;   - V POV V82.81
 ;   - V PROCEDURE 88.98
 ;   - V CPT [BGP OSTEO SCREEN CPTS]
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
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"V82.81","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTITEM^APCLAPIU(APCLPDFN,"88.98","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"A")
 D E
 S APCLVAL=$$LASTCPTT^APCLAPIU(APCLPDFN,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:APCLBD),APCLED,"BGP OSTEO SCREEN CPTS","A")
 D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
LASTAOF(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last ASSESSMENT FUNCTION
 ;  Return the last recorded ASSESSMENT OF FUNCTION:
 ;   - V ELDER ENTRY
 ;
 ;  Input:
 ;   APCLPDFN - Patient DFN
 ;   APCLBD - beginning date to begin search for value - if blank, default is DOB
 ;   APCLED - ending date of search - if blank, default is DT
 ;   APCLFORM -  APCLFORM returned:  D - return date only - example 3070801
 ;                                 A - return value:
 ; date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
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
 S APCLVAL=0 F  S APCLVAL=$O(^AUPNVELD("AA",APCLPDFN,APCLVAL)) Q:APCLVAL'=+APCLVAL!(APCLLAST)  D
 .S APCLX=0 F  S APCLX=$O(^AUPNVELD("AA",APCLPDFN,APCLVAL,APCLX)) Q:APCLX'=+APCLX!(APCLLAST)  D
 ..;Q:$P($G(^AUPNVELD(APCLX,0)),U,17)=""  ;no change in functional status
 ..Q:'$D(^AUPNVELD(APCLX,0))
 ..S G=0 F X=1:1:18 I $P(^AUPNVELD(APCLX,0),U,X)]"" S G=1
 ..Q:'G
 ..S APCLLAST=(9999999-APCLVAL)_"^Elder Care entry^"_$P(^AUPNVELD(APCLX,0),U,17)_"^"_$P(^AUPNVELD(APCLX,0),U,3)_"^9000010.35^"_APCLX
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
 ;
INRDX(P,V,BD,ED) ;PEP - does patient P have a dx in BJPC AC THRPY INDIC DXS taxonomy
 ; P - DFN
 ; V - VISIT IEN
 ; BD - Beginning date for dx search
 ; ED - ending date for dx search
 ; caller can pass in V and just that visit will be examined for a diagnosis
 ; called can pass in BD and ED to determine what date range will be used for dx search
 ; V overrides BD and ED so if V is passed and BD and ED are passed, BD and ED will be ignored
 ; If V is null and BD and ED are null then DOB and DT are used
 ; return value= 1^date of dx^ien of dx^dx code
 ;
 NEW T,R
 S T=$O(^ATXAX("B","BJPC AC THRPY INDIC DXS",0))
 I 'T Q ""
 I $G(P)="" Q ""
 S R=""
 I $G(V),$D(^AUPNVSIT(V,0)) G INRDXV
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 S R=$$LASTDXT^APCLAPIU(P,BD,ED,"BJPC AC THRPY INDIC DXS","A")
 I R]"" Q 1_"^"_$P(R,U,1)_"^"_$P(^AUPNVPOV($P(R,U,6),0),U)_"^"_$$VAL^XBDIQ1(9000010.07,$P(R,U,6),.01)
 Q ""
INRDXV ;
 NEW A,B
 S A=0 F  S A=$O(^AUPNVPOV("AD",V,A)) Q:A'=+A!(R]"")  D
 .Q:'$D(^AUPNVPOV(A,0))
 .S B=$P(^AUPNVPOV(A,0),U)
 .Q:'$$ICD^ATXCHK(B,T,9)
 .S R=1_"^"_$$VD^APCLV(V)_"^"_$P(^AUPNVPOV(A,0),U)_"^"_$$VAL^XBDIQ1(9000010.07,A,.01)
 Q R
