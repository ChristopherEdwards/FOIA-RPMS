INHUT10 ; JPD ; 21 Feb 96 11:01; HL7 utilities TIME STAMP 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;NO LINETAGS IN THIS ROUTINE ARE SUPPORTED FOR EXECUTION BY ANY
 ;SOFTWARE OUTSIDE THE GIS PACKAGE (IN*)
 ;
TIMEIO(X,INP,INCV,IN24,INOUT) ;Convert time to input or output
 ;Input:
 ; X  - date/time
 ; INP(opt) - Precision Y=year, L=month, D=day, H=hour, M=minute,S=second
 ;                      1=Auto precision
 ; INCV(opt) - 1 convert, 0 don't convert, 2 convert no 2nd component
 ;             3 convert 2.3
 ;          
 ; IN24(opt) - midnight offset
 ;          outbound - INOUT flag set to 0
 ;             0 do nothing, 1 - add 1 day set time to 0000 
 ;             2 - subtract one second, 3 - subtract one minute
 ;          inbound - INOUT flag set to 1
 ;             0 - do nothing, 1 - subtract 1 day set time to 2400 
 ;             2 - add one second, 3 - add one minute
 ; INOUT - 0 or null outbound - converts from fileman to HL7
 ;         1 inbound - converts from HL7 to fileman
 ;
 ;External Input:
 ; (opt) INSUBDEL - Sub delimeter
 ;
 ;Output:
 ; INP - Precision
 ;
 ;Returns: function
 ; date/time in converted format
 ;
 ;Outbound
 Q:'$G(INOUT) $$TS(.X,.INP,.INCV,.IN24)
 ;inbound
 Q $$HDT(.X,"TS",0,.INP,.INCV,.IN24,1)
 ;
TS(X,INP,INCV,IN24) ;Transform date to HL7 time stamp format
 ;Input:
 ; X  - date/time in any fileman or external format
 ; INP(opt) - Precision Y=year, L=month, D=day, H=hour, M=minute,S=second
 ;            1=Auto precision
 ; INCV(opt) - 1 convert, 0 don't convert
 ; IN24(opt) - 0 - do nothing, 1 - add 1 day set time to 0000 
 ;             2 - subtract one second, 3 - subtract one minute
 ;External Input:
 ; (opt) INSUBDEL - Sub delimeter
 ;Returns:
 ; function - date/time in HL7 format with or without precision
 ;
 ;Ignores +/- Zulu offsets and time zone differences
 Q:'$L(X) ""
 N Y,%DT,INSD,INP2,INSD,INPREC
 S INSD=$S($L($G(INSUBDEL)):INSUBDEL,1:$$COMP^INHUT)
 S INPREC=$G(INP)
 S %DT="ST" D ^%DT Q:Y<0 ""
 ;set piece 2 to preserve time
 S INP2=$P(Y,".",2)
 ;set date to HL7 format
 S X=$E(Y,1,3)+1700_$E(Y,4,7)
 ;if auto precision get length/position of last 0
 I INPREC S INPREC=$L(+("."_X_INP2))-1
 S X=X_$E(INP2_"000000",1,6)
 ;if precision exists
 S X=$S($L(INPREC):$$PRECO(X,INPREC,$G(INCV)),1:X)
 S INPREC=$P(X,INSD,2)
 ;if we want to change 2400 and the time is 2400
 I $G(IN24),$E(X,9,10)=24 D
 .;quit if precision on and Year or Month
 .I INPREC]"","YL"[INPREC,$G(INCV) Q
 .S Y=$$DT24($$TIMEIO(X,"","","",1),IN24)
 .S X=$$TIMEIO(Y)
 .S:$L(INPREC) X=X_INSD_INPREC
 I $G(INCV)>1 D
 .;remove subcomponent delimeter
 .S X=$P(X,INSD)
 .;version 2.3
 .I INCV=3 S X=$E(X,1,$L(+("."_X))-1)
 S INTZO=$$TZ^BHLV  ;cmi/maw get time zone offset for this time zone
 I $L(X)>8 S X=X_$G(INTZO)  ;cmi/maw attach time zone to this if time
 Q X
 ;
HDT(X,INTS,INVA,INP,INCNV,IN24,INTI) ;Transform HL7 date format to internal fileman format
 ;Input:
 ; X  - HL7 date/time
 ;      format- ( YYYYMMDDHHMM[SS[.SSSS]][+/-ZZZZ] \ precision )
 ; INTS - control variable 
 ;    used as %DT if data is validated
 ;    T - time allowed ; S - seconds allowed
 ; INVA - validate data (1 - yes ; 0 - no (def))
 ; INP(opt) - 
 ;  Precision Y=year, L=month, D=day, H=hour, M=minute,S=second
 ;            1=Auto precision, 0 or nothing=do nothing
 ; INCNV(opt) - 1 convert, 0 don't convert, 3 convert 2.3
 ; IN24(opt) - 0 - do nothing, 1 - subtract 1 day set time to 2400 
 ;             2 - add one second, 3 - add one minute
 ;
 ; INTI(opt) 1 - called from TIMEIO Function, 0 or blank not called 
 ;                                               from TIMEIO
 ;Output:
 ; function - date in internal fileman format
 ; X - date in internal fileman format (pass by reference)
 ; INVA - valid data (1 valid ; 0 - invalid))
 ;
 ;Suggested use:
 ; S OK=1,C='d/t checks' S X=$$HDT^INHUT1(X,C,.OK)  I 'OK Then Error
 ;
 N IN24H,INSD,INPC,INCV,INPSV,INSAVE,INTIO
 ;Check for non-numeric date/times
 I '$G(X) S X="" Q ""
 S IN24H=$G(IN24),INSD=$S($L($G(INSUBDEL)):INSUBDEL,1:$$COMP^INHUT)
 ;Ignores +/- Zulu offsets and time zone differences
 S INTS=$G(INTS),INVA=$G(INVA),INCV=$G(INCNV),INTIO=$G(INTI)
 ;Save second component
 S INPSV=$P(X,INSD,2)
 ;check precision flag and set date before processing
 S INPC=$G(INP),INPC=$S(INPC&(INCV'=3):$P(X,INSD,2),INPC&(INCV=3):$L($P(X,INSD)),$L(INPC):INPC,1:"")
 ;Save original time 'version 2.3 or version 2.3
 S INSAVE=$S(INCV'=3:$E($E(X,9,14)_"000000",1,6),1:$E(X,9,14))
 S X=$S($L(INPC):$$PRECO(X,.INPC,INCV),1:+X\1)
 ;Check for invalid HL7 date/time format (not completely robust)
 I 'INTIO,$L(X)<8,INCV'=3 S (INP,X)="" Q ""
 I 'INTIO,$L(X)>8,$L(X)<12,INCV'=3 S (INP,X)="" Q ""
 ;Remove possibility of terminal I/O from INTS (%DT)
 S:INVA INTS=$TR(INTS,"AEQ")
 I INTIO,$L(X)<8,'$L($G(INP)),'INCV,'IN24H Q $E(X,1,4)-1700_$E(X,5,8)
 I 'IN24H D
 .;Transforming Date (DT) data type
 .I INTS'["T"!($L(X)<9) S X=$E(X,1,4)-1700_$E(X,5,8) S:$L(X)&($L(X)<7) X=$E(X_"000000",1,7) Q
 .;Transforming time stamp (TS) data type
 .N %
 .I 'INTIO S %=$E($E(X,9,14)_"000000",1,6)
 .I INTIO S %=$E(X,9,14)
 .;if coming from TIMIO and no parameters passed act like olddata type TS
 .I INTIO,'%,'$L($G(INP)),'INCV,'IN24H S %="0001"
 .;treat midnight as one second after midnight
 .I '%,'$L($G(INP)) S %="000001"
 .;Handle midnight as one minute past midnight if no seconds allowed
 .I %,%<60,INTS'["S",'$L($G(INP)) S %="0001"
 .S %=$S(INTS'["S":$E(%,1,4),1:%)
 .;Handle imprecise dates
 .I INTS["I" S:'$E(X,5,6)!'$E(X,7,8)&'$E(X,9,14) %=""
 .;If coming in from TIMIO then act like data type if no params
 .I INTIO,'$L($G(INP)),'INCV,'IN24H S %=$E(%,1,4)
 .;set the date to fileman format for orig data type
 .I INTIO,'$L($G(INP)),'INCV S X=$E(X,1,4)-1700_$E(X,5,8)_"."_% Q
 .;set date to fileman format
 .S X=+($E(X,1,4)-1700_$E(X,5,8)_"."_%)
 ;if convert 0000 time and time is 0000
 ;if convert 
 I IN24H D
 .S X=+($E(X,1,4)-1700_$E(X,5,8)_"."_$E($E(X,9,14)_"000000",1,6))
 .;If Year Month Day precision don't convert
 .I INPC]"","YLD"[INPC,INCV Q
 .;If original time was 000000
 .I INCV'=3,'INSAVE S X=$$DT24(X,IN24H,1)
 .;version 2.3 auto precision and 0's in hours and minutes field
 .I INCV=3,($L(INSAVE)=4&($E(INSAVE,1,4)="0000"))!($L(INSAVE)=6&($E(INSAVE,1,6)="000000")) S X=$$DT24(X,IN24H,1)
 ;Validate data
 I INVA D
 .I X<0 S INVA=0,X="" Q
 .N %DT,Y S %DT=INTS D ^%DT S X=Y I Y<0 S INVA=0,X=""
 ;Set precision to second component
 S INP=INPSV
 Q X
 ;
PRECO(X,INP,INCV) ;returns date time outbound HL7 precision date
 ;Input:
 ; X  - date/time in HL7 format
 ; INP - Precision Y=year, L=month, D=day, H=hour, M=minute, S=second
 ;       1=Auto precision
 ; INCV - 1 convert, 0 don't convert
 ;External Input:
 ; (opt) INSUBDEL - Sub delimeter
 ;Returns:
 ; function - date/time in HL7 format with or without precision
 ;if we actually want to convert to the precision
 ;
 I $G(INCV) D
 .;year only
 .I INP="Y" S X=$E(X,1,4)
 .;year month
 .I INP="L" S X=$E(X,1,6)
 .;year month day
 .I INP="D" S X=$E(X,1,8)
 .;year month day hour
 .I INP="H" S X=$E(X,1,10)
 .;year month day hour minute
 .I INP="M" S X=$E(X,1,12)
 ;Auto precision
 I INP S INP=$E("YYYYLLDDMMMMSS",INP)
 ;set sub delimeter
 S INSD=$S($L($G(INSUBDEL)):INSUBDEL,1:$$COMP^INHUT)
 Q $E(X_"00000000000000",1,14)_INSD_INP
 ;
DT24(X,IN24,INOUT) ;change 2400 or 0000 time
 ;Input:
 ;X  - date/time in fileman format
 ;          outbound - INOUT=0
 ;IN24(opt)
 ;   Outbound 
 ; 0 do nothing, 1 - add 1 day set time to 0000 
 ; 2 - subtract one second, 3 - subtract one minute
 ;   Inbound - INOUT=1
 ; 0 - do nothing, 1 - subtract 1 day set time to 2400 
 ; 2 - add one second, 3 - add one minute
 ; INOUT -  0 Outbound, 1 Inbound
 ;Returns:
 ; changed date in fileman close to format
 ;
 N INIO,INUM
 S INIO=$G(INOUT),INUM=$S(INIO:1,1:-1)
 ;outbound add day make time 0000
 I IN24=1 D
 .;outbound add day make time 0000
 .I 'INIO S X=$$ADDT^%ZTFDT($P(X,"."),1)
 .;inbound subtract day and make time 2400
 .I INIO S X=$$ADDT^%ZTFDT($P(X,"."),-1)_".24"
 ;out subtract/in add second from date
 I IN24=2 S X=$$ADDT^%ZTFDT(X,0,0,0,INUM)
 ;out subtract/in add minute
 I IN24=3 S X=$$ADDT^%ZTFDT(X,0,0,INUM)
 Q X
