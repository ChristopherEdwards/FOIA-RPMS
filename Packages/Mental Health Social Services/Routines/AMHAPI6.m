AMHAPI6 ; IHS/CMI/LAB - visit data ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**2**;JUN 18, 2010;Build 23
 ;IHS/TUCSON/LAB - added G parameter to provider call
 ;
 ;
 ;
LASTPLR(AMHPDFN,AMHBD,AMHED,AMHFORM) ;PEP - date of last PROBLEM LIST REVIEWED
 ;  Return the last recorded PROBLEM LIST REVIEWED FROM MHSS UPDATED/REVIEWED:
 ;   .04 OF MHSS UPDATED/REVIEWED is set to 1
 ;     
 ;  Input:
 ;   AMHPDFN - Patient DFN
 ;   AMHBD - beginning date to begin search for value - if blank, default is DOB
 ;   AMHED - ending date of search - if blank, default is DT
 ;   AMHFORM -  AMHFORM returned:  D - return date only - example 3070801
 ;                                 A - return value:
 ;                       date^text of item found^provider who documented^visit ien^File found in^ien of file found in
 ;             Default if blank is D
 ;  Output:
 ;   If AMHFORM is blank or AMHFORM is D returns internal fileman date if one found otherwise returns null
 ;   If AMHFORM is A returns the string:
 ;     date^text of item found^PROVIDER^visit ien^File found in^ien of file found in
 ; 
 I $G(AMHPDFN)="" Q ""
 I $G(AMHBD)="" S AMHBD=$$DOB^AUPNPAT(AMHPDFN)
 I $G(AMHED)="" S AMHED=DT
 I $G(AMHFORM)="" S AMHFORM="D"
 NEW AMHLAST,AMHVAL,AMHX,R,X,Y,V,E,D,G,ED,BD
 S BD=9999999-AMHBD
 S ED=9999999-AMHED
 S AMHLAST=""
 S V=$O(^AUTTCRA("C","PLR",0))
 I 'V Q ""
 S D=ED-1,D=D_".999999" F  S D=$O(^AMHRRUP("AA",AMHPDFN,V,D)) Q:D'=+D!($P(D,".")>BD)  D
 .S X=0 F  S X=$O(^AMHRRUP("AA",AMHPDFN,V,D,X)) Q:X'=+X  D
 ..Q:'$D(^AMHRRUP(X,0))
 ..Q:$P($G(^AMHRRUP(X,2)),U,1)
 ..S AMHVAL=$P($P(^AMHRRUP(X,12),U),".")_U_$$VAL^XBDIQ1(9000010.54,X,.01)_U_$P($G(^AMHRRUP(X,12)),U,4)_U_$P(^AMHRRUP(X,0),U,3)_U_9000010.54_U_X
 ..D E
 I AMHFORM="D" Q $P(AMHLAST,U)
 Q AMHLAST
 ;
E ;
 I $P(AMHVAL,U,1)'<$P(AMHLAST,U,1) S AMHLAST=AMHVAL
 Q
LASTPLU(AMHPDFN,AMHBD,AMHED,AMHFORM) ;PEP - date of last PROBLEM LIST UPDATE
 ;  Return the last recorded PROBLEM LIST UPDATED FROM MHSS UPDATED/REVIEWED:
 ;   .11 OF MHSS UPDATED/REVIEWED is set to 1
 ;     
 ;  Input:
 ;   AMHPDFN - Patient DFN
 ;   AMHBD - beginning date to begin search for value - if blank, default is DOB
 ;   AMHED - ending date of search - if blank, default is DT
 ;   AMHFORM -  AMHFORM returned:  D - return date only - example 3070801
 ;                                 A - return value:
 ;                       date^text of item found^provider who documented^visit ien^File found in^ien of file found in
 ;             Default if blank is D
 ;  Output:
 ;   If AMHFORM is blank or AMHFORM is D returns internal fileman date if one found otherwise returns null
 ;   If AMHFORM is A returns the string:
 ;     date^text of item found^PROVIDER^visit ien^File found in^ien of file found in
 ; 
 I $G(AMHPDFN)="" Q ""
 I $G(AMHBD)="" S AMHBD=$$DOB^AUPNPAT(AMHPDFN)
 I $G(AMHED)="" S AMHED=DT
 I $G(AMHFORM)="" S AMHFORM="D"
 NEW AMHLAST,AMHVAL,AMHX,R,X,Y,V,E,D,G,ED,BD
 S BD=9999999-AMHBD
 S ED=9999999-AMHED
 S AMHLAST=""
 S V=$O(^AUTTCRA("C","PLU",0))
 I 'V Q ""
 S D=ED-1,D=D_".999999" F  S D=$O(^AMHRRUP("AA",AMHPDFN,V,D)) Q:D'=+D!($P(D,".")>BD)  D
 .S X=0 F  S X=$O(^AMHRRUP("AA",AMHPDFN,V,D,X)) Q:X'=+X  D
 ..Q:'$D(^AMHRRUP(X,0))
 ..Q:$P($G(^AMHRRUP(X,2)),U,1)
 ..S AMHVAL=$P($P(^AMHRRUP(X,12),U),".")_U_$$VAL^XBDIQ1(9000010.54,X,.01)_U_$P($G(^AMHRRUP(X,12)),U,4)_U_$P(^AMHRRUP(X,0),U,3)_U_9000010.54_U_X
 ..D E
 I AMHFORM="D" Q $P(AMHLAST,U)
 Q AMHLAST
 ;
LASTNAP(AMHPDFN,AMHBD,AMHED,AMHFORM) ;PEP - date of last NO ACTIVE PROBLEMS
 ;  Return the last recorded NO ACTIVE PROBLEMS FROM MHSS UPDATED/REVIEWED:
 ;   .09 OF MHSS UPDATED/REVIEWED is set to 1
 ;     
 ;  Input:
 ;   AMHPDFN - Patient DFN
 ;   AMHBD - beginning date to begin search for value - if blank, default is DOB
 ;   AMHED - ending date of search - if blank, default is DT
 ;   AMHFORM -  AMHFORM returned:  D - return date only - example 3070801
 ;                                 A - return value:
 ;                       date^text of item found^provider who documented^visit ien^File found in^ien of file found in
 ;             Default if blank is D
 ;  Output:
 ;   If AMHFORM is blank or AMHFORM is D returns internal fileman date if one found otherwise returns null
 ;   If AMHFORM is A returns the string:
 ;     date^text of item found^PROVIDER^visit ien^File found in^ien of file found in
 ; 
 I $G(AMHPDFN)="" Q ""
 I $G(AMHBD)="" S AMHBD=$$DOB^AUPNPAT(AMHPDFN)
 I $G(AMHED)="" S AMHED=DT
 I $G(AMHFORM)="" S AMHFORM="D"
 NEW AMHLAST,AMHVAL,AMHX,R,X,Y,V,E,D,G,ED,BD
 S BD=9999999-AMHBD
 S ED=9999999-AMHED
 S AMHLAST=""
 S V=$O(^AUTTCRA("C","NAP",0))
 I 'V Q ""
 S D=ED-1,D=D_".999999" F  S D=$O(^AMHRRUP("AA",AMHPDFN,V,D)) Q:D'=+D!($P(D,".")>BD)  D
 .S X=0 F  S X=$O(^AMHRRUP("AA",AMHPDFN,V,D,X)) Q:X'=+X  D
 ..Q:'$D(^AMHRRUP(X,0))
 ..Q:$P($G(^AMHRRUP(X,2)),U,1)
 ..S AMHVAL=$P($P(^AMHRRUP(X,12),U),".")_U_$$VAL^XBDIQ1(9000010.54,X,.01)_U_$P($G(^AMHRRUP(X,12)),U,4)_U_$P(^AMHRRUP(X,0),U,3)_U_9000010.54_U_X
 ..D E
 I AMHFORM="D" Q $P(AMHLAST,U)
 Q AMHLAST
UPREV(V,I) ;EP - IS UPDATE/REVIEWED I ON VISIT V?
 I '$G(V) Q ""
 I $G(I)="" Q ""
 NEW X,Y,Z
 S Z=0
 S Y=$O(^AUTTCRA("C",I,0))
 I Y="" Q ""
 S X=0 F  S X=$O(^AMHRRUP("AD",V,X)) Q:X'=+X  D
 .Q:$P($G(^AMHRRUP(X,2)),U,1)  ;error
 .Q:'$D(^AMHRRUP(X,0))
 .Q:$P(^AMHRRUP(X,0),U,1)'=Y
 .S Z=1
 Q Z
PRREV ;EP = set
 NEW X,Y,Z
 S Z=0
 S Y=$O(^AUTTCRA("C",AMHVAL,0))
 I Y="" Q ""
 S X=0 F  S X=$O(^AMHRRUP("AD",AMHVIEN,X)) Q:X'=+X  D
 .Q:$P($G(^AMHRRUP(X,2)),U,1)  ;error
 .Q:'$D(^AMHRRUP(X,0))
 .Q:$P(^AMHRRUP(X,0),U,1)'=Y
 .S AMHPCNT=AMHPCNT+1,AMHPRNM(AMHPCNT)=$$VAL^XBDIQ1(9000010.54,X,.01)
 .Q
 Q
UPREVP ;EP - IS UPDATE/REVIEWED I ON VISIT V?
 NEW Y,Z
 S Z=0
 S Y=$O(^AUTTCRA("C",AMHVAL,0))
 I Y="" Q ""
 S X=0 F  S X=$O(^AMHRRUP("AD",AMHVIEN,X)) Q:X'=+X  D
 .Q:$P($G(^AMHRRUP(X,2)),U,1)  ;error
 .Q:'$D(^AMHRRUP(X,0))
 .Q:$P(^AMHRRUP(X,0),U,1)'=Y
 .S Z=$P($G(^AMHRRUP(X,12)),U,4) I Z S X(Z)=""
 Q
UPREVPP ;EP = set
 NEW X,Y,Z
 S Z=0
 S Y=$O(^AUTTCRA("C",AMHVAL,0))
 I Y="" Q ""
 S X=0 F  S X=$O(^AMHRRUP("AD",AMHVIEN,X)) Q:X'=+X  D
 .Q:$P($G(^AMHRRUP(X,2)),U,1)  ;error
 .Q:'$D(^AMHRRUP(X,0))
 .Q:$P(^AMHRRUP(X,0),U,1)'=Y
 .Q:$P($G(^AMHRRUP(X,12)),U,4)=""
 .S AMHPCNT=AMHPCNT+1,AMHPRNM(AMHPCNT)=$$VAL^XBDIQ1(9000010.54,X,1204)
 .Q
 Q
