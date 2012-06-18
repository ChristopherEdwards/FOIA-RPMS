APCLAPI6 ; IHS/CMI/LAB - visit data ;
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;IHS/TUCSON/LAB - added G parameter to provider call
 ;
 ;
 ;
LASTPLR(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last PROBLEM LIST REVIEWED
 ;  Return the last recorded PROBLEM LIST REVIEWED FROM V UPDATED/REVIEWED:
 ;   .04 OF V UPDATED/REVIEWED is set to 1
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
 S V=$O(^AUTTCRA("C","PLR",0))
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
E ;
 I $P(APCLVAL,U,1)'<$P(APCLLAST,U,1) S APCLLAST=APCLVAL
 Q
LASTPLU(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last PROBLEM LIST UPDATE
 ;  Return the last recorded PROBLEM LIST UPDATED FROM V UPDATED/REVIEWED:
 ;   .11 OF V UPDATED/REVIEWED is set to 1
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
 S V=$O(^AUTTCRA("C","PLU",0))
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
LASTNAP(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last NO ACTIVE PROBLEMS
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
 S V=$O(^AUTTCRA("C","NAP",0))
 I 'V Q ""
 S D=ED-1,D=D_".999999" F  S D=$O(^AUPNVRUP("AA",APCLPDFN,V,D)) Q:D'=+D!($P(D,".")>BD)  D
 .S X=0 F  S X=$O(^AUPNVRUP("AA",APCLPDFN,V,D,X)) Q:X'=+X  D
 ..Q:'$D(^AUPNVRUP(X,0))
 ..Q:$P($G(^AUPNVRUP(X,2)),U,1)
 ..S APCLVAL=$P($P(^AUPNVRUP(X,12),U),".")_U_$$VAL^XBDIQ1(9000010.54,X,.01)_U_$P($G(^AUPNVRUP(X,12)),U,4)_U_$P(^AUPNVRUP(X,0),U,3)_U_9000010.54_U_X
 ..D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
UPREV(V,I) ;EP - IS UPDATE/REVIEWED I ON VISIT V?
 I '$G(V) Q ""
 I $G(I)="" Q ""
 NEW X,Y,Z
 S Z=0
 S Y=$O(^AUTTCRA("C",I,0))
 I Y="" Q ""
 S X=0 F  S X=$O(^AUPNVRUP("AD",V,X)) Q:X'=+X  D
 .Q:$P($G(^AUPNVRUP(X,2)),U,1)  ;error
 .Q:'$D(^AUPNVRUP(X,0))
 .Q:$P(^AUPNVRUP(X,0),U,1)'=Y
 .S Z=1
 Q Z
PRREV ;EP = set
 NEW X,Y,Z
 S Z=0
 S Y=$O(^AUTTCRA("C",APCLVAL,0))
 I Y="" Q ""
 S X=0 F  S X=$O(^AUPNVRUP("AD",APCLVIEN,X)) Q:X'=+X  D
 .Q:$P($G(^AUPNVRUP(X,2)),U,1)  ;error
 .Q:'$D(^AUPNVRUP(X,0))
 .Q:$P(^AUPNVRUP(X,0),U,1)'=Y
 .S APCLPCNT=APCLPCNT+1,APCLPRNM(APCLPCNT)=$$VAL^XBDIQ1(9000010.54,X,.01)
 .Q
 Q
UPREVP ;EP - IS UPDATE/REVIEWED I ON VISIT V?
 NEW Y,Z
 S Z=0
 S Y=$O(^AUTTCRA("C",APCLVAL,0))
 I Y="" Q ""
 S X=0 F  S X=$O(^AUPNVRUP("AD",APCLVIEN,X)) Q:X'=+X  D
 .Q:$P($G(^AUPNVRUP(X,2)),U,1)  ;error
 .Q:'$D(^AUPNVRUP(X,0))
 .Q:$P(^AUPNVRUP(X,0),U,1)'=Y
 .S Z=$P($G(^AUPNVRUP(X,12)),U,4) I Z S X(Z)=""
 Q
UPREVPP ;EP = set
 NEW X,Y,Z
 S Z=0
 S Y=$O(^AUTTCRA("C",APCLVAL,0))
 I Y="" Q ""
 S X=0 F  S X=$O(^AUPNVRUP("AD",APCLVIEN,X)) Q:X'=+X  D
 .Q:$P($G(^AUPNVRUP(X,2)),U,1)  ;error
 .Q:'$D(^AUPNVRUP(X,0))
 .Q:$P(^AUPNVRUP(X,0),U,1)'=Y
 .Q:$P($G(^AUPNVRUP(X,12)),U,4)=""
 .S APCLPCNT=APCLPCNT+1,APCLPRNM(APCLPCNT)=$$VAL^XBDIQ1(9000010.54,X,1204)
 .Q
 Q
 ;
LASTALR(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last ALLERGY LIST REVIEWED
 ;  Return the last recorded ALLERGY LIST REVIEWED FROM V UPDATED/REVIEWED:
 ;   .04 OF V UPDATED/REVIEWED is set to 1
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
 S V=$O(^AUTTCRA("C","ALR",0))
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
LASTMLR(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last MEDICATION LIST REVIEWED
 ;  Return the last recorded MEDICATION LIST REVIEWED FROM V UPDATED/REVIEWED:
 ;   .04 OF V UPDATED/REVIEWED is set to 1
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
 S V=$O(^AUTTCRA("C","MLR",0))
 I 'V Q ""
 S D=ED-1,D=D_".999999" F  S D=$O(^AUPNVRUP("AA",APCLPDFN,V,D)) Q:D'=+D!($P(D,".")>BD)  D
 .S X=0 F  S X=$O(^AUPNVRUP("AA",APCLPDFN,V,D,X)) Q:X'=+X  D
 ..Q:'$D(^AUPNVRUP(X,0))
 ..Q:$P($G(^AUPNVRUP(X,2)),U,1)
 ..S APCLVAL=$P($P(^AUPNVRUP(X,12),U),".")_U_$$VAL^XBDIQ1(9000010.54,X,.01)_U_$P($G(^AUPNVRUP(X,12)),U,4)_U_$P(^AUPNVRUP(X,0),U,3)_U_9000010.54_U_X
 ..D E
 I APCLFORM="D" Q $P(APCLLAST,U)
 Q APCLLAST
LASTMLU(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last PROBLEM LIST UPDATE
 ;  Return the last recorded PROBLEM LIST UPDATED FROM V UPDATED/REVIEWED:
 ;   .11 OF V UPDATED/REVIEWED is set to 1
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
 S V=$O(^AUTTCRA("C","MLU",0))
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
LASTNAM(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last NO ACTIVE PROBLEMS
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
 S V=$O(^AUTTCRA("C","NAM",0))
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
LASTALU(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last ALLERGY UPDATE
 ;  Return the last recorded ALLERGY UPDATED FROM V UPDATED/REVIEWED:
 ;   .11 OF V UPDATED/REVIEWED is set to 1
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
 S V=$O(^AUTTCRA("C","ALU",0))
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
LASTNAA(APCLPDFN,APCLBD,APCLED,APCLFORM) ;PEP - date of last NO ACTIVE ALLERGIES
 G LASTNAA^APCLAPI7
