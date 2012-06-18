ADEGRL4 ; IHS/HQT/MJL - DENTAL ENTRY PART 6 ;09:35 PM  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
VSTAT ;EP
 N ADEJ
 S ADEJ=$$FYVIS(ADEPAT,ADEVDATE)
 I ADEJ S ADEV($P(ADEJ,U,2))="1^" G VSTAT2
 ;
VSTAT1 D LIST^ADEGRL3
 W !,"Visit Status Codes:",!,?8,"1  First Visit of the Fiscal Year",?52,"(0000)",!,?8,"2  Revisit (for any reason)",?52,"(0190)"
 W:ADEDIR !,?8,"3  Broken Appointment",?52,"(9130)",!,?8,"4  Cancelled Appointment",?52,"(9140)"
 W !!,"Select Visit Status: "
 R X:DTIME I $T<1 S Y=-1 Q
 I X?4N S X=$S(X="0000":1,X="0190":2,(X=9130)&ADEDIR:3,(X=9140)&ADEDIR:4,1:"^")
 S X=$E(X_"^")
 I X="^" S Y=-1 Q
 I X["?" S XQH="ADE-DVIS-VCODE" D EN^XQH K XQH D ^ADECLS,^ADEHELP,LIST^ADEGRL3 G VSTAT1
 I ADEDIR,("1234FRCBfrbc"'[X) W *7,"??" G VSTAT1
 I ADECON,("12FRfr"'[X) W *7,"??" G VSTAT1
 S ADEV($S((X="F")!(X="f")!(X=1):"0000",(X=2)!(X="R")!(X="r"):"0190",(X=3)!(X="B")!(X="b"):"9130",(X=4)!(X="C")!(X="c"):"9140"))="1^"
VSTAT2 S ADEDES("0000")="FIRST VISIT",ADEDES("0190")="REVISIT",ADEDES("9130")="BROKEN APPT",ADEDES("9140")="CANCELLED APPT",Y=1
 Q
 ;
FAC K DIC,Y S DIC="^ADEPARAM(DUZ(2),1,",DA(1)=DUZ(2),DIC(0)="AEZMQ",DIC("A")="Select Location of Encounter: " S:$D(ADELOE) DIC("B")=ADELOE D ^DIC Q:Y=-1
 S ADELOED=Y(0),ADELOE=Y(0,0)
 Q
PROV ;EP
 N DIR
 K DIC,Y S DIC=6,DIC(0)="MEZ"
 S DIC("S")="D SCRN2^ADEGRL1"
 W !,"Select HYGIENIST/THERAPIST: ",$S(ADEPVNM]"":ADEPVNM_"// ",1:"") R X:DTIME
 Q:'$T
 D ^DIC
 I Y=-1,X="@" S (ADEPVNM,ADEPVNMD)="" D PROV2 K DIC,ADEDICS,Y Q
 I Y=-1,X="" K DIC,ADEDICS,Y Q
 I Y=-1 G PROV
 S ADEPVNMD=$P(Y,U),ADEPVNM=Y(0,0)
 K DIC,ADEDICS
PROV2 S DIR(0)="YA"
 ;S DIR("A")=""
 W !!,"Do you want to use this same HYGIENIST/THERAPIST for subsequent",!,"visits in this data entry session?"
 S DIR("B")="YES"
 D ^DIR
 I Y=1 S ADEPROD=ADEPVNMD,ADEPRO=ADEPVNM
 Q
REPD ;EP
 N DIR
 K DIC,Y S DIC=6,DIC(0)="MEZ"
 S DIC("S")="D SCRN1^ADEGRL1"
 W !,"Select ATTENDING DENTIST: ",$S(ADERDNM]"":ADERDNM_"// ",1:"") R X:DTIME
 Q:'$T
 D ^DIC
 I Y=-1,X="@" S (ADERDNM,ADERDNMD)="" D REPD2 K DIC,ADEDICS,Y Q
 I Y=-1,X="" K DIC,ADEDICS,Y Q
 I Y=-1 G REPD
 S ADERDNMD=$P(Y,U),ADERDNM=Y(0,0)
 K DIC,ADEDICS
REPD2 S DIR(0)="YA"
 W !!,"Do you want to use this same ATTENDING DENTIST for subsequent",!,"visits in this data entry session?"
 S DIR("B")="YES"
 D ^DIR
 I Y=1 S ADEREPD=ADERDNMD,ADEREP=ADERDNM
 Q
NOTE ;EP
 W !,"Dental Note: ",$S(ADENOTE]""&(ADENOTE'="@"):ADENOTE_"//",1:"")
 R X:DTIME I '$T W *7 Q
 I X=""!(X["^") Q
 I X="@" S ADENOTE="@" Q
 X $P(^DD(9002007,6,0),U,5,99) I '$D(X) W *7," ??" G NOTE
 S ADENOTE=X Q
 ;
FYVIS(ADEPAT,ADEVDATE) ;EP - Returns "1/0^Visit Status"
 ;where 1 if able to compute first visit or revisit, otw 0
 ;and, if 1, where Visit Status=0000 or 0190
 ;Requires visit date and patient dfn
 ;
 ;Get FY of visit
 N ADEVFM,ADEFY,ADEJ,ADEK,ADECNT,ADENDFY,ADEFV,ADERV
 S %DT="T",X=ADEVDATE D ^%DT S ADEVFM=Y ;IHS/HMW **2**
 ;begin Y2K fix
 ;S ADEFY=1000
 ;S ADEFY="2"_$S($E(ADEVFM,4,5)<10:$E(ADEVFM,2,3)-1,1:$E(ADEVFM,2,3))_ADEFY
 ;S ADENDFY=ADEFY,$E(ADENDFY,2,3)=$E(ADENDFY,2,3)+1
 Q:ADEVFM=-1 0  ;Y2000
 S ADEFY=$E($P($$FISCAL^XBDT(ADEVFM),U,2),1,5)_"00" ;Y2000
 S ADENDFY=ADEFY,$E(ADENDFY,1,3)=$E(ADENDFY,1,3)+1  ;Y2000
 ;Are there more than 5 visits in Oct of the fiscal year?
 S ADEJ=ADEFY,ADECNT=0
 ;F  S ADEJ=$O(^ADEPCD("AC",ADEJ)) Q:'+ADEJ  Q:$E(ADEJ,2,5)'=$E(ADEFY,2,5)  D  Q:ADECNT>5
 F  S ADEJ=$O(^ADEPCD("AC",ADEJ)) Q:'+ADEJ  Q:$E(ADEJ,1,5)'=$E(ADEFY,1,5)  D  Q:ADECNT>5  ;Y2000
 . S ADEK=0 F  S ADEK=$O(^ADEPCD("AC",ADEJ,ADEK)) Q:'+ADEK  S ADECNT=ADECNT+1 Q:ADECNT>5
 ;end Y2K fix block
 I ADECNT<6 Q 0
 ;Ok then, does this patient have a visit for this fy?
 I '$D(^ADEPCD("DATE",ADEPAT)) Q "1^0000^FIRST VISIT"
 S ADEJ=ADEFY
 S ADEJ=$O(^ADEPCD("DATE",ADEPAT,ADEFY))
 I ADEJ=""!(ADEJ>ADENDFY) Q "1^0000^FIRST VISIT"
 ;Check for a non-failed appt visit
 S ADEFLG=0
 S ADEJ=ADEFY
 S ADEFV=$O(^AUTTADA("B","0000",0))
 S ADERV=$O(^AUTTADA("B","0190",0))
 F  S ADEJ=$O(^ADEPCD("DATE",ADEPAT,ADEJ)) Q:'+ADEJ  Q:ADEFLG  D
 . S ADEK=0 F  S ADEK=$O(^ADEPCD("DATE",ADEPAT,ADEJ,ADEK)) Q:'+ADEK  Q:ADEFLG  D
 . . I $D(^ADEPCD(ADEK,"ADA","B",ADEFV)) S ADEFLG=1 Q
 . . I $D(^ADEPCD(ADEK,"ADA","B",ADERV)) S ADEFLG=1 Q
 Q:ADEFLG "1^0190^REVISIT"
 Q "1^0000^FIRST VISIT"
 K ADEFY,ADENDFY ;*NE
