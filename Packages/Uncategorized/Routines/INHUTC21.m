INHUTC21 ;bar,DS; 28 Aug 97 16:14; Interface Criteria date functions
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;COPYRIGHT 1997 SAIC
 Q
 ;
RELDT(INSTR,INFMT,INPMT) ; convert a relative date text string to a FM
 ; date/time format
 ;
 ; input:   INSTR = string consisting of a relative date/time designation
 ;                 and optionally add/subtract modifiers or @time.
 ;          INFMT = formating options similar to %DT options.
 ;                = "A" Ask for input
 ;                = "E", Echo the answer
 ;                = "F", future dates are assumed
 ;                = "L", for space bar return lookup
 ;                = "N" Pure numeric input is not allowed
 ;                = "P", past dates are assumed
 ;                = "S", allow seconds in input and output
 ;                = "T", allow time in input and output
 ;                = "U", for readable date/time format
 ;          
 ;          INPMT = Prompt to display (Default is 'Date: ')
 ;
 ; returns: date/time in FM format
 ;
 N INA,INB,INCY,IND,INDT,INOUT,INUM,INI,INNOW,INTIME,INX,INY,X
 S INSTR=$$UPCASE^%ZTF($G(INSTR)),INFMT=$$UPCASE^%ZTF($G(INFMT))
 S INPMT=$G(INPMT,"Date: "),INNOW=$$NOW^%ZTFDT
 ;
 ; if asked to prompt for input, get input and call back recursively
 I INFMT["A" D  Q:X="^" "User aborted or timed out"  Q $$RELDT(X,INFMT,INPMT)
 . S INFMT=$TR(INFMT,"A","L")
 . D ^UTSRD(INPMT_";;;;"_INSTR,"^D HELP^INHUTC22")
 . I $D(DTOUT)!$D(DUOUT) S X="^" Q
 . ; if help is requested, display help and quit
 . S:$L(INSTR)&'$L(X) X=INSTR
 . I X=" ",$L($G(^DIJUSV(+$G(DUZ),"RELDT^INHUTC21"))) S X=^("RELDT^INHUTC21")
 ;
 ; check for pure numeric input if not allowed
 I INFMT["N",INSTR?.N,+INSTR=INSTR D  Q INOUT
 . S INOUT="Pure numeric input is not allowed."
 . W:INFMT["E" $C(7)_" "_INOUT
 ;
 ; assume past dates - assume nothing we just want to eval the date
 ; I INFMT'["F",INFMT'["P" S INFMT=INFMT_"P"
 ; create logical pieces of input string into INY
 S INY=$TR(INSTR,"+-@","^^^"),INA=1,INB=0,INDT=""
 ; set INB to each piece and evaluate
 F INI=1:1 S INB=$F(INY,"^",INB) D  Q:'INB!('INDT)
 . S INX=$E(INSTR,INA,$S(INB:INB-2,1:$L(INSTR))),INA=INA+$L(INX) Q:'$L(INX)
 . ; ------------------ process base date ------------------------
 . I INI=1 D  Q
 .. ; set default for base to NOW
 .. S:'$L(INX) INX="NOW"
 .. I INX=$E("TODAY",1,$L(INX)) S INDT=$$CDATH2F^%ZTFDT(+$H) Q
 .. I INX="NOW"!(INX="N") S INDT=INNOW Q
 .. ; process begin/end entries
 .. I "BE"[$E(INX) D  Q
 ... ; set flag IND, true if BEGIN, false if END
 ... N IND,INT S IND=($E(INX)="B")
 ... ; get date type
 ... F I=2:1 I "YMD"[$E(INX,I) S INT=$E(INX,I) Q
 ... Q:'$L(INT)
 ... ; process current year
 ... I $E(INT)="Y" S INDT=$$CDATA2F^%ZTFDT($S(IND:"JAN 01",1:"DEC 31")) Q
 ... ; process current month
 ... I $E(INT)="M" D  Q
 .... N INE
 .... S INDT=$$CDATH2F^%ZTFDT(+$H)
 .... ; set day of the month based on begin or end
 .... S INE=$S(IND:"01",1:$P("31 28 31 30 31 30 31 31 30 31 30 31"," ",$E(INDT,4,5)))
 .... ; leap year is every 4, except on a century
 .... ; every 400 years the century keeps the leap year
 .... I INE=28,'(I#4),'('$E(I,3,4)&(I#400)) S INE=29
 .... S $E(INDT,6,7)=INE
 ... ; process current day
 ... I $E(INT)="D" S INDT=$$DT^%ZTFDT_$S(IND:"",1:".24") Q
 .. ; process days of the week with last and next
 .. I "NL"[$E(INX),$E(INX,2)'="O" D  Q
 ... N IND,INH
 ... S INH=$H,IND=$F("TH,FR,SA,SU,MO,TU,WE",$E(INX,2,3)) Q:'IND
 ... S IND=IND/3+6-(INH#7)#7 S:$E(INX)="L" IND=IND-7 S:'IND IND=7
 ... S INDT=$$ADDT^%ZTFDT(INNOW,IND)
 .. ; check for specific date
 .. S INDT=$$CDATA2F^%ZTFDT(INX)
 . ; --------------- process modifiers -------------------------------
 . ; process @time input
 . I $E(INX)="@" D  Q
 .. S IND=$$CDATA2F^%ZTFDT(INX,"T") I 'IND S INDT="" Q
 .. S INDT=$P(INDT,".",1)_"."_$P(IND,".",2)
 . ; parse number and modifier, no-op if no value, default is DAYS
 . S INUM=+INX,IND=$P(INX,INUM,2) Q:'INUM  S:'$L(IND) IND="D"
 . ; check for Day, Hour, Minites, Seconds
 . I $F(",WEEKS,DAYS,HOURS,MINUTES,SECONDS",","_IND) D  Q
 .. N D,H,M,S
 .. ;calculate weeks into days
 .. S IND=$E(IND) S:IND="W" IND="D",INUM=INUM*7
 .. S @IND=INUM,INDT=$$ADDT^%ZTFDT(INDT,$G(D),$G(H),$G(M),$G(S))
 . ; check for Year, Month
 . I $F(",MONTHS,YEARS",","_IND) D  Q
 .. ; if years, calc number of months. Add months to current date
 .. S:$E(IND)="Y" INUM=INUM*12 S INDT=$$ADDM^%ZTFDT(INDT,INUM)
 . ; if it doesn't pass any formats, it must be bad
 . S INDT=""
 ;
 ; loop back if asked to prompt and user input is invalid
 I 'INDT D  Q INOUT
 . S INOUT="value "_INSTR_" is invalid"
 . W:INFMT["E" $C(7)_" ("_INOUT_")"
 ;
 ; check if time input is required
 I INFMT["R",'$F(INDT,".") D  Q INOUT
 . S INOUT="Time input is required."
 . W:INFMT["E" $C(7)_" "_INOUT
 ;
 ; if INFMT does not contain 'T' to remove the time portion
 S:INFMT'["T" INDT=$P(INDT,".")
 ;
 ; if INFMT does not contain 'S' to remove the seconds portion,
 ; remove the seconds
 S:INFMT'["S" INDT=$P(INDT,".")_"."_$E($P(INDT,".",2),1,4)
 ;
 ; check for past or future date assumptions and increment
 ; or decrement CYY.
 I INFMT["F"!(INFMT["P")&($$CHKDT($P(INSTR,"@"))) D
 . S INDAT=$$PASFUT^INHUTC21($P(INDT,"."),INFMT)
 . S:$L($P(INDT,".",2)) INDAT=INDAT_"."_$P(INDT,".",2)
 . S INDT=INDAT
 ;
 ; check if past date was assumed and entered a date in the future
 I INFMT["P",INDT>INNOW D  Q INOUT
 . S INOUT="Enter a date no later than today"
 . W:INFMT["E" $C(7)_" "_INOUT
 ;
 ; check if future date was assumed and entered a date in the past
 I INFMT["F",INDT<INNOW D  Q INOUT
 . S INOUT="Enter a date greater than today"
 . W:INFMT["E" $C(7)_" "_INOUT
 ;
 ; save input string for space bar return lookup
 S:INFMT["L" ^DIJUSV(+$G(DUZ),"RELDT^INHUTC21")=INSTR
 ;
 ; if requested for readable date/time format
 I INFMT["U" D  Q INOUT
 . S INOUT=$$CDATASC^%ZTFDT(INDT,1,$S(INDT[".":1,1:""))
 . W:INFMT["E" " ("_INOUT_")"
 W:INFMT["E" " ("_+INDT_")"
 Q +INDT
 ;
PASFUT(CYYMMDD,INFMT) ; check for Past or Future date assumptions and
 ; increment or decrement CYY appropriately.
 ;
 ; Input: CYYMMDD (req) = FileMan date format
 ;        INFMT   (req) = like %DT string, holds F or P
 ;
 ; Output: CYY+1_MMDD if future dates are assumed and MMDD is > today
 ;         CYY-1_MMDD if past dates are assumed and MMDD is > today
 ;
 N CYY,DD,INDELTA,INHDT,INHMMDD,MM
 S INFMT=$G(INFMT)
 ; assume past dates
 I INFMT'["F",INFMT'["P" S INFMT=INFMT_"P"
 S INHDT=$$DT^%ZTFDT,INHMMDD=$E(INHDT,4,7),INDELTA=-1,INOPER=">"
 S:INFMT["F" INDELTA=1,INOPER="<"
 S CYY=$E(CYYMMDD,1,3),MM=$E(CYYMMDD,4,5),DD=$E(CYYMMDD,6,7),MD=MM*100+DD
 I @(MD_INOPER_INHMMDD) S CYY=CYY+INDELTA
 Q CYY_MM_DD
 ;
CHKDT(INSTR) ; check the format of the input date string
 ;
 ; Output: 1, if the input date string is in MM/DD or MM-DD format and
 ;            year has not been supplied.
 ;         null, otherwise.
 ;
 S INSTR=$G(INSTR)
 ; check for MM/DD/YYYY, MM-DD-YYYY, MM.DD.YYYY formats
 Q:INSTR?1.2N1"/"1.2N1"/"1.4N ""
 Q:INSTR?1.2N1"-"1.2N1"-"1.4N ""
 Q:INSTR?1.2N1"."1.2N1"."1.4N ""
 Q:INSTR?1.2N1" "1.2N1" "1.4N ""
 ; MMM DD YYYY or DD MMM YYYY formats
 Q:INSTR?3U1" "1.2N1" "1.4N ""
 Q:INSTR?1.2N1" "3U1" "1.4N ""
 ; MMDDYY or MMDDYYYY
 Q:INSTR?6.8N ""
 Q:INSTR["TODAY"!(INSTR["T")!(INSTR["NOW") ""
 ; chech for MM/DD or MM-DD formats, year is not supplied
 Q:INSTR?1.2N1"/"1.2N 1
 Q:INSTR?1.2N1"-"1.2N 1
 Q:INSTR?1.2N1"."1.2N 1
 Q:INSTR?1.2N1" "1.2N 1
 Q ""
