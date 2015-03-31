ABSPICPY ; IHS/OIT/CASSevern/Pieran ran 9/19/2011 - Copy Insurance default Profiles
 ;;1.0;PHARMACY POINT OF SALE;**42,46**;JUN 21, 2001
 ;
 ; This routine will be called when creating a new ABSP INSURER so that a "sane" set of defaults can be loaded for a good chance at working without modification.
 ; Basically we will prompt the user as to whether it's a Medicaid, Medicare or Commercial insurer...go to the appropriate table and add the defaults stored in that table.
 ; We'll start out with a default table that is applicable to all of the above and then go from there. 
EN(ABSPINS) ;EP
 N OK,TYP
 S OK=0
 ;NEXT 5 LINES FOR PROMPTING USER...NO LONGER NEEDED
 ;F  Q:OK  D
 ;. W !,"Is this Insurer a 1.) Medicaid, 2.) Medicare or 3.) Private Insurer?"
 ;. R !,"Enter 1, 2, 3, or ""^"" to exit. ",INP
 ;. I ((+INP>0)&&(+INP<4))||(INP="^") S OK=1	;They must enter a 1, 2, 3 or "^" otherwise prompt again. 
 ;. ELSE  W !,"That is not a valid choice, please enter ""1"", ""2"", ""3"", or ""^"""
 ;Instead of prompting them...we'll get the insurance type off the main insurer file
 ;M and R are Medicare
 ;D is Medicaid
 ;P is private, but for the purposes of this copy program, we'll treat any value that isn't M, R or D as private
 S TYP=$P(^AUTNINS(ABSPINS,2),"^")
 S TYP=$S(TYP="D":1,TYP="M":2,TYP="R":2,TYP="MD":2,TYP="HM":2,1:3)
 D PROCESS(ABSPINS,TYP)
 Q
PROCESS(ABSPINS,TYP) ;Process the INSURER here
 N INS,ABSPSPEC,ABSPSPSG,ABSPSPFL
 D DEFCOPY(ABSPINS) ;The defaults get loaded regardless of insurance type
 D:TYP=1 CAIDCOPY(ABSPINS)
 D:TYP=2 CARECOPY(ABSPINS)
 D:TYP=3 PRIVCOPY(ABSPINS)
 D:$D(INS(1)) UPDATE^DIE("E","INS(1)")
 D:$D(ABSPSPEC) POPSPEC(ABSPINS,.ABSPSPEC)
 D:$D(ABSPSPSG) POPSEG(ABSPINS,.ABSPSPSG)
 D:$D(ABSPSPFL) POPFLD(ABSPINS,.ABSPSPFL)
 Q
DEFCOPY(ABSPINS) ;Read through the DEFTAB table and load those settings
 N L,LINE
 F L=1:1  Q:$P($T(DEFTAB+L),";",3)="***"  D
 . S LINE=$T(DEFTAB+L)
 . D RDLINE(LINE,ABSPINS)
 Q
CAIDCOPY(ABSPINS) ;Read through the CAIDTAB table and load those settings
 N L,LINE
 F L=1:1  Q:$P($T(CAIDTAB+L),";",3)="***"  D
 . S LINE=$T(CAIDTAB+L)
 . D RDLINE(LINE,ABSPINS)
 Q
CARECOPY(ABSPINS) ;Read through the CARETAB table and load those settings
 N L,LINE
 F L=1:1  Q:$P($T(CARETAB+L),";",3)="***"  D
 . S LINE=$T(CARETAB+L)
 . D RDLINE(LINE,ABSPINS)
 Q
PRIVCOPY(ABSPINS) ;Read through the PRIVTAB table and load those settings
 N L,LINE
 F L=1:1  Q:$P($T(PRIVTAB+L),";",3)="***"  D
 . S LINE=$T(PRIVTAB+L)
 . D RDLINE(LINE,ABSPINS)
 Q
RDLINE(LINE,ABSPINS) ;Go through the line and populate the array
 N TYPE,FLDNUM,VAL,FILE
 S FILE=1 I $D(^ABSPEI(ABSPINS,210))!($D(^ABSPEI(ABSPINS,221)))!($D(^ABSPEI(ABSPINS,220))) S FILE=0
 S TYPE=$P(LINE,";",3)
 S NCPDPCD=$P(LINE,";",4)
 S VAL=$P(LINE,";",6)
 I TYPE="SPEC" S ABSPSPEC(NCPDPCD)=VAL
 I TYPE="SEG" S ABSPSPSG(VAL)=""
 I TYPE="FLD" S ABSPSPFL(NCPDPCD)=""
 I TYPE="TOP",FILE S INS(1,9002313.4,ABSPINS_",",NCPDPCD)=VAL
 Q
 ;Tables use following setup:
 ;;TYPE;NCPDP FIELD #;COMMENT;VALUE   
 ;    If TYPE="SPEC" put the actual special code you want to put into the NCPDP code in "VALUE"
 ;       I.e. ;;SPEC;302;FIELD 302;S ABSP("X")="01" (Puts the special code `S ABSP(X)=1` into NCPDP field 302
 ;    If TYPE="SEG" put the Segment # in Value...
 ;		I.e. ;;SEG;;CompounD Segment;10   (suppresses the compound segment....piece 5 is just to make it easier to debug)
 ;	    Segment #s are:
 ;		2 = Suppress Provider Segment
 ;       5 = Suppress COB Segment
 ;       6 = Suppress Workers Comp Segment
 ;       8 = Suppress DURR/PPS Segment
 ;       9 = Suppress Coupon Segment
 ;       10= Suppress Compound Segment
 ;       12= Suppress Prior Auth Segment
 ;       13= Suppress Clinical Segment
 ;       14= Suppress Additional Doc Segment
 ;       15= Suppress Facility Segment
 ;       16= Suppress Narrative Segment
 ;    If TYPE="FLD" the correct NCPDP field number needs to be in piece 4
 ;       I.e. ;;FLD;308;Field 308;     (Suppresses field 308...Again piece 5 is not required but makes it easier to debug)
 ;    If TYPE="TOP" put the Fileman field number in instead of NCPDP #
 ;       I.e. ;;TOP;100.18;Medicare Part D?;Y   (Put's "Y" in the field Medicare Part D?)
 ;       Field numbers are: 
 ;       100.18="Medicare Part D?"
 ;       100.19="Maximum number of RXs per claim"
 ;       100.2="Add Dispensing fee to ingredeant cost"
 ;       100.3="Contract required"
 ;       100.4="Total exclusive of Patient Amount"
 ;       (Values are all either "Y" or "N" except for "Maximum number of RXs per claim")
DEFTAB ;;TYPE;NCPDP FIELD #;FIELD NAME;VALUE
 ;;FLD;354;SUPPRESS FIELD 354;
 ;;FLD;357;SUPPRESS FIELD 357;
 ;;FLD;391;SUPPRESS FIELD 391;
 ;;FLD;995;SUPPRESS FIELD 995;
 ;;FLD;996;SUPPRESS FIELD 996;
 ;;FLD;420;SUPPRESS FIELD 420;
 ;;FLD;458;SUPPRESS FIELD 458;
 ;;FLD;459;SUPPRESS FIELD 459;
 ;;FLD;494;SUPPRESS FIELD 494;
 ;;FLD;495;SUPPRESS FIELD 495;
 ;;FLD;496;SUPPRESS FIELD 496;
 ;;FLD;497;SUPPRESS FIELD 497;
 ;;FLD;499;SUPPRESS FIELD 499;
 ;;FLD;524;SUPPRESS FIELD 524;
 ;;FLD;359;SUPPRESS FIELD 359;
 ;;FLD;360;SUPPRESS FIELD 360;
 ;;FLD;361;SUPPRESS FIELD 361;
 ;;FLD;997;SUPPRESS FIELD 997;
 ;;FLD;115;SUPPRESS FIELD 115;
 ;;FLD;350;SUPPRESS FIELD 350;
 ;;FLD;334;SUPPRESS FIELD 334;
 ;;FLD;498;SUPPRESS FIELD 498;
 ;;FLD;364;SUPPRESS FIELD 364;
 ;;FLD;365;SUPPRESS FIELD 365;
 ;;FLD;366;SUPPRESS FIELD 366;
 ;;FLD;367;SUPPRESS FIELD 367;
 ;;FLD;368;SUPPRESS FIELD 368;
 ;;SEG;;COB Segment;5
 ;;SEG;;Workers Comp Segment;6
 ;;SEG;;Durr/PPS Segment;8
 ;;SEG;;Coupon Segment;9
 ;;SEG;;Compound Segment;10
 ;;SEG;;Prior Auth Segment;12
 ;;SEG;;Clinical Segment;13
 ;;SEG;;Additional Doc Segment;14
 ;;SEG;;Facility Segment;15
 ;;SEG;;Narrative Segment;16
 ;;SPEC;436;PUT SPECIAL CODE IN FIELD 436;S ABSP("X")="03"
 ;;SPEC;455;PUT SPECIAL CODE IN FIELD 455;S ABSP("X")=1
 ;;TOP;100.2;Add Dispensing fee to ingredeant cost;N
 ;;TOP;100.3;Contract required;N
 ;;TOP;100.4;Total exclusive of Patient Amount;N
 ;;TOP;100.07;DIAL OUT TO;ENVOY DIRECT VIA T1 LINE
 ;;TOP;100.14;Insurer NPI Flag;BOTH
 ;;TOP;100.06;RX-Pricing Method;STANDARD
 ;;***
 Q
CAIDTAB ;;TYPE;NCPDP FIELD #;COMMENT;VALUE
 ;;FLD;147;SUPPRESS FIELD 147;
 ;;FLD;384;SUPPRESS FIELD 384;
 ;;SPEC;304;PUT SPECIAL CODE IN FIELD 304;S ABSP("X")=$G(ABSP("Patient","Medicaid DOB")) S:ABSP("X")="" ABSP("X")=$G(ABSP("Patient","DOB")) S ABSP("X")=$$DTF1|ABSPECFM(ABSP("X"))
 ;;TOP;100.18;Medicare Part D?;N
 ;;TOP;100.19;Maximum RXs per claim;4
 ;;TOP;104.01;RX-Priority;5
 ;;***
 Q
CARETAB ;;TYPE;NCPDP FIELD #;COMMENT;VALUE
 ;;SPEC;304;PUT SPECIAL CODE IN FIELD 304;S ABSP("X")=$G(ABSP("Patient","Medicare DOB")) S:ABSP("X")="" ABSP("X")=$G(ABSP("Patient","DOB")) S ABSP("X")=$$DTF1|ABSPECFM(ABSP("X"))
 ;;TOP;100.18;Medicare Part D?;Y
 ;;TOP;100.19;Maximum RXs per claim;1
 ;;TOP;104.01;RX-Prioriry;650
 ;;***
 Q
PRIVTAB ;;TYPE;NCPDP FIELD #;COMMENT;VALUE
 ;;FLD;147;SUPPRESS FIELD 147;
 ;;FLD;384;SUPPRESS FIELD 384;
 ;;TOP;100.18;Medicare Part D?;N
 ;;TOP;100.19;Maximum RXs per claim;4
 ;;TOP;104.01;RX-Priority;20
 ;;***
 Q
POPSPEC(ABSPINS,ABSPSPEC) ;Now populate the Special Code stuff
 ;This has already been run...don't add duplicate entries.
 Q:$D(^ABSPEI(ABSPINS,210))
 N NCPDPCD,INS,STRING
 S NCPDPCD=""
 F  S NCPDPCD=$O(ABSPSPEC(NCPDPCD)) Q:NCPDPCD=""  D
 . ;These are the fields that can't be overriden
 . Q:(NCPDPCD=111)!(NCPDPCD=103)
 . S STRING=$TR(ABSPSPEC(NCPDPCD),"^","|") ;Fileman won't store this string with a ^ (caret) in it
 . S INS(1,9002313.42,"+1,"_ABSPINS_",",.01)=NCPDPCD
 . S INS(1,9002313.42,"+1,"_ABSPINS_",",.02)=STRING
 . D UPDATE^DIE("E","INS(1)")
 Q
POPSEG(ABSPINS,ABSPSPSG) ;Next we populate the suppressed segments
 ;This has already been run...don't add duplicate entries.
 Q:$D(^ABSPEI(ABSPINS,221))
 N SEGCD,INS
 S SEGCD=""
 F  S SEGCD=$O(ABSPSPSG(SEGCD)) Q:SEGCD=""  D
 . S INS(1,9002313.48,"+1,"_ABSPINS_",",.01)=SEGCD
 . D UPDATE^DIE("","INS(1)") ;On this one we are using the Internal value
 Q
POPFLD(ABSPINS,ABSPSPFL) ;Next we populate the suppressed fields
 ;This has already been run...don't add duplicate entries.
 Q:$D(^ABSPEI(ABSPINS,220))
 N NCPDPCD
 S NCPDPCD=""
 F  S NCPDPCD=$O(ABSPSPFL(NCPDPCD)) Q:NCPDPCD=""  D
 . S INS(1,9002313.46,"+1,"_ABSPINS_",",.01)=NCPDPCD
 . D UPDATE^DIE("E","INS(1)")
 Q
