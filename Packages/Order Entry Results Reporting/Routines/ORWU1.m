ORWU1 ;SLC/GRE - General Utilities for Windows Calls [10/15/03 1:52pm]
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**149,187**;Dec 17, 1997
 ;
 Q
 ;
NP1 ; Return a set of names from the NEW PERSON file.
 ; (PKS/8/5/2003: Now called by NEWPERS^ORWU; internal mods made.)
 ; (Keep GETCOS^ORWTPN up to date with matching logic/code, too.)
 ;
 ; PARAMS from NEWPERS^ORWU call:
 ;  .ORY=returned list, ORFROM=text to $O from, ORDIR=$O direction.
 ;  ORKEY=Screen users by security key (optional).
 ;  ORDATE=Checks for an active person class on this date (optional).
 ;  ORALLUSE=If not true, screens for providers; currently that
 ;           amounts to only a check for terminated users (optional).
 ;  ORVIZ=If true, includes RDV users; otherwise not (optional).
 ;
 N OR1DIV,ORCNT,ORDD,ORDIV,ORDUP,ORGOOD,ORHOLD,ORI,ORIEN1,ORIEN2,ORIENP2,ORLAST,ORMAX,ORMRK,ORMULTI,ORNAME,ORPREV,ORSRV,ORTTL,ORVALID
 ;
 S ORI=0,ORMAX=44,(ORLAST,ORPREV)="",ORKEY=$G(ORKEY),ORDATE=$G(ORDATE)
 S ORMULTI=$$ALL^VASITE ; Do once at beginning of call.
 S ORNAME("FILE")=200,ORNAME("FIELD")=.01 ; Array for XLFNAME call.
 ;
 F  Q:ORI'<ORMAX  S ORFROM=$O(^VA(200,"B",ORFROM),ORDIR) Q:ORFROM=""  D
 .S ORVALID=0                                     ; Init each time.
 .S ORIEN1=""
 .F  S ORIEN1=$O(^VA(200,"B",ORFROM,ORIEN1),ORDIR) Q:'ORIEN1  D
 ..;
 ..; Screen out RDVs if applicable:
 ..I +$G(ORVIZ)=0,$D(^VA(200,"BB","VISITOR",ORIEN1))&'$D(^VA(200,ORIEN1,"USC1",1,0)) Q
 ..I $L(ORKEY),'$D(^XUSEC(ORKEY,+ORIEN1)) Q
 ..I +$G(ORALLUSE)=0,'$$PROVIDER^XUSER(ORIEN1) Q  ; Terminated users.
 ..I ORDATE>0,$$GET^XUA4A72(ORIEN1,ORDATE)<1 Q
 ..S ORNAME("IENS")=ORIEN1_","                    ; For DIQ calls.
 ..S ORI=ORI+1,ORY(ORI)=ORIEN1_"^"_$$NAMEFMT^XLFNAME(.ORNAME,"F","CcMP")
 ..S ORHOLD=ORY(ORI)                   ; Save in case of duplication.
 ..S ORDUP=0                           ; Init flag, check duplication.
 ..I ($P(ORPREV_" "," ")=$P(ORFROM_" "," ")) S ORDUP=1
 ..;
 ..; Append Title if not duplicated:
 ..I 'ORDUP D
 ...S ORVALID=1                        ; Valid user, set flag.
 ...S ORTTL=$$GET1^DIQ(200,ORIEN1,8)   ; Get Title.
 ...I ORTTL="" Q
 ...S ORY(ORI)=ORY(ORI)_U_"- "_ORTTL
 ..;
 ..; Get data in case of dupes:
 ..I ORDUP D
 ...S ORVALID=1                        ; Valid user(s), set flag.
 ...S ORIENP2=ORLAST                   ; Use prev IEN for call to NP2.
 ...;
 ...; Reset, use previous array element, call for extended data:
 ...S ORI=ORI-1,ORY(ORI)=$P(ORY(ORI),U)_U_$P(ORY(ORI),U,2)  D NP2
 ...;
 ...; Then return to current user for second extended data call:
 ...S ORIENP2=ORIEN1,ORI=ORI+1  D NP2
 ..S ORLAST=ORIEN1,ORPREV=ORFROM       ; Reassign vars for next pass.
 ;
 Q
 ;
NP2 ; Retrieve subset of data for dupes in NP1.
 ; (Assumes certain vars already set/new'd.)
 ;
 S (ORDIV,ORSRV,ORTTL)=""              ; Reset.
 S ORIEN2=ORIENP2_","                  ; IEN + comma for DIQ calls.
 S ORTTL=$$GET1^DIQ(200,ORIEN2,8)      ; Get Title.
 S ORSRV=$$GET1^DIQ(200,ORIEN2,29)     ; Get Service/Section.
 ;
 ; For multi-divisional site, get Division if determinable:
 I ORMULTI D
 .; ^TMP("DILIST" is written by the API call: LIST^DIC below:
 .K ^TMP("DILIST",$J)                  ; Cleanup.
 .D LIST^DIC(200.02,","_ORIENP2_",",".01;1","Q",,,,,,,)
 .S OR1DIV="",(ORDD,ORGOOD,ORCNT)=0
 .F  S ORDD=$O(^TMP("DILIST",$J,"ID",ORDD)) Q:+ORDD=0!'($L(ORDD))  D  Q:ORGOOD
 ..S ORCNT=ORCNT+1                     ; Increment counter.
 ..I ORCNT=1 D
 ...I $D(^TMP("DILIST",$J,"ID",ORDD,01)) D
 ....S OR1DIV=$G(^TMP("DILIST",$J,"ID",ORDD,.01))
 ..I $G(^TMP("DILIST",$J,"ID",ORDD,1))="Yes" S ORDIV=$G(^TMP("DILIST",$J,"ID",ORDD,.01)),ORGOOD=1  Q        ; Division text.
 .K ^TMP("DILIST",$J)                  ; Cleanup.
 .I ((ORCNT=1)&(ORDIV="")) D
 ..I OR1DIV'="" S ORDIV=OR1DIV         ; Only one? - use it.
 ;
 ; Append new pieces to array string.
 S ORMRK=""
 I (ORTTL="")&(ORSRV="")&(ORDIV="")  Q  ; Nothing to append.
 S ORY(ORI)=ORY(ORI)_U_"- "             ; At least something exists.
 I (ORTTL'="") S ORY(ORI)=ORY(ORI)_ORTTL,ORMRK=", "       ; Title.
 I (ORSRV'="") S ORY(ORI)=ORY(ORI)_ORMRK_ORSRV,ORMRK=", " ; Service.
 I (ORDIV'="") S ORY(ORI)=ORY(ORI)_ORMRK_ORDIV            ; Division.
 ;
 Q
 ;
NAMECVT(Y,IEN) ; Returns text name(mixed-case) derived from IEN xref.
 ; GRE/2002
 ; PKS-12/20/2002 Tag not presently used.
 ; Y=Returned value, IEN=Internal number
 N ORNAME
 S IEN=IEN_","
 S ORNAME=$$GET1^DIQ(200,IEN,20.2)
 S Y=$$NAMEFMT^XLFNAME(.ORNAME,"F","DcMP")
 Q
 ;
DEFDIV(Y) ; Return user's default division, if specified.
 ;
 ; Variables used:
 ;   ORDD   = Default division.
 ;   ORDIV  = Division holder variable.
 ;   ORGOOD = Flag for successful default division found.
 ;   ORIEN  = IEN of user.
 ;   Y      = Returned value.
 ;
 N ORDD,ORDIV,ORGOOD
 ;
 S ORIEN=DUZ,ORDIV=""
 K ^TMP("DILIST",$J) ; Cleanup.
 S Y=0,(ORDD,ORGOOD)=0             ; Initialize variables.
 ;
 ; Get list of divisions from NEW PERSON file multiple:
 D LIST^DIC(200.02,","_ORIEN_",",".01;1","Q",,,,,,,)
 ;
 ; Iterate through list:
 F  S ORDD=$O(^TMP("DILIST",$J,"ID",ORDD)) Q:+ORDD=0!'($L(ORDD))  D  Q:ORGOOD
 .I $G(^TMP("DILIST",$J,"ID",ORDD,1))="Yes" S ORDIV=$G(^TMP("DILIST",$J,"ID",ORDD,.01)),ORGOOD=1  Q     ; Division text.
 K ^TMP("DILIST",$J)               ; Cleanup.
 I (ORDIV="") Q                    ; Punt if no default division.
 I $$UP^XLFSTR(ORDIV)="SALT LAKE CITY OIFO" S Y=1
 ;
 Q
 ;
NEWLOC(Y,ORFROM,DIR) ; Return "CZ" locations from HOSPITAL LOCATION file.
 ; C=Clinics, Z=Other, screened by $$ACTLOC^ORWU.
 ; .Y=returned list, ORFROM=text to $O from, DIR=$O direction.
 N I,IEN,CNT S I=0,CNT=44
 F  Q:I'<CNT  S ORFROM=$O(^SC("B",ORFROM),DIR) Q:ORFROM=""  D  ; IA# 10040.
 . S IEN="" F  S IEN=$O(^SC("B",ORFROM,IEN),DIR) Q:'IEN  D
 . . Q:("CZ"'[$P($G(^SC(IEN,0)),U,3)!('$$ACTLOC^ORWU(IEN)))
 . . S I=I+1,Y(I)=IEN_"^"_ORFROM
 Q
 ;
