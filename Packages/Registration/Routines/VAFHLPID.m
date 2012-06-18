VAFHLPID ;ALB/MLI/ESD - Create generic PID segment ; 21 Nov 2002  3:13 PM
 ;;5.3;Registration;**68,94,415**;Aug 13, 1993
 ;
 ; This routine returns the HL7 defined PID segment with its
 ; mappings to DHCP PATIENT file fields.
 ;
EN(DFN,VAFSTR,VAFNUM,PTID) ; returns PID segment
 ;  Input - DFN as internal entry number of the PATIENT file
 ;          VAFSTR as string of fields requested separated by commas
 ;          VAFNUM as sequential number for SET ID (default=1)
 ;          PTID is flag denoting which Patient ID (seq 3) to use
 ;              0 - Use DFN formatted as data type CK (default)
 ;              1 - Use ICN
 ;              2 - Use DFN formatted as data type CX
 ;              3 - Use SSN (with dashes)
 ;
 ;      ****Also assumes all HL7 variables returned from****
 ;          INIT^HLTRANS are defined
 ;
 ; Output - String containing the desired components of the PID segment
 ;          VAFPID(n) - if the string is longer than 245, the remaining
 ;                      characters will be returned in VAFPID(n) where
 ;                      n is a sequential number beginning with 1
 ;
 ; WARNING: This routine makes external calls to VADPT.  Non-namespaced
 ;          variables may be altered.
 ;
 N I,VAFY,VA,VADM,X,X1,Y,OUTPUT,DGNAME ; calls VADPT...have to NEW
 S VAFSTR=$G(VAFSTR) ; if not defined, just return required fields
 S DFN=$G(DFN)
 I DFN']"" G QUIT
 D DEM^VADPT
 S VAFSTR=","_VAFSTR_","
 K VAFY
 ;Set ID (#1)
 I VAFSTR[",1," S VAFY(1)=$S($G(VAFNUM):VAFNUM,1:1)
 ;External ID (#2)
 I VAFSTR[",2," S X=$G(VA("PID")),VAFY(2)=$S(X]"":$$M10^HLFNC(X),1:HLQ)
 ;Patient ID (#3 - req)
 S PTID=+$G(PTID)
 I 'PTID S VAFY(3)=$$M10^HLFNC(DFN)
 I PTID D
 .S X=$S(PTID=1:"NI",PTID=2:"PI",PTID=3:"SS")
 .S VAFY(3)=$$SEQ3^VAFHLPI1(DFN,X,HLECH,HLQ)
 ;Alternate ID (#4)
 I VAFSTR[",4," S X=$G(VA("BID")),VAFY(4)=$S(X]"":X,1:HLQ)
 ;Name (#5 - req)
 S DGNAME("FILE")=2,DGNAME("IENS")=DFN,DGNAME("FIELD")=.01
 S X=$$HLNAME^XLFNAME(.DGNAME,"",$E(HLECH)),VAFY(5)=$S(X]"":X,1:HLQ)
 ;Mother's maiden name (#6)
 I VAFSTR[",6," S X=$P($G(^DPT(DFN,.24)),"^",3),VAFY(6)=$S(X]"":X,1:HLQ)
 ;Date of birth (#7)
 I VAFSTR[",7," S VAFY(7)=$$HLDATE^HLFNC(+VADM(3))
 ;Sex (#8)
 I VAFSTR[",8," S X=$P(VADM(5),"^",1),VAFY(8)=$S("^M^F^"[("^"_X_"^"):X,1:"U")
 ;Race (#10)
 I VAFSTR[10 D
 .N HOW
 .S Y=$F(VAFSTR,"10")
 .S HOW=$P($E(VAFSTR,Y,$F(VAFSTR,",",Y)),",",1)
 .D SEQ10^VAFHLPI1(HOW,HLQ)
 ;Address (#11) and County (#12)
 I VAFSTR[11!(VAFSTR[12) D
 . S X=$G(^DPT(DFN,.11))
 . S X=$$ADDR^VAFHLFNC($P(X,"^",1,5)_"^"_$P(X,"^",12),$P(X,"^",7))
 . I VAFSTR[11 S Y=$P(X,HLFS,1),VAFY(11)=$S(Y]"":Y,1:HLQ)
 . I VAFSTR[12 S Y=$P(X,HLFS,2),VAFY(12)=$S(Y]"":Y,1:HLQ)
 S X=$G(^DPT(DFN,.13))
 ;Home phone (#13)
 I VAFSTR[13 S X1=$$HLPHONE^HLFNC($P(X,"^",1)),VAFY(13)=$S(X1]"":X1,1:HLQ)
 ;Business phone (#14)
 I VAFSTR[14 S X1=$$HLPHONE^HLFNC($P(X,"^",2)),VAFY(14)=$S(X1]"":X1,1:HLQ)
 ;Marital status (#16)
 I VAFSTR[16 S X=$P($G(^DIC(11,+VADM(10),0)),"^",3),VAFY(16)=$S(X="N":"S",X="U":"",X="":HLQ,1:X)
 ;Religious preference (#17) (if blank send 29 (UNKNOWN))
 I VAFSTR[17 S X=$P($G(^DIC(13,+VADM(9),0)),"^",4),VAFY(17)=$S(X]"":X,1:29)
 ;SSN (#19)
 I VAFSTR[19 S X=$P(VADM(2),"^",1),VAFY(19)=$S(X]"":X,1:HLQ)
 ;Ethnicity (#22)
 I VAFSTR[22 D
 .N HOW
 .S Y=$F(VAFSTR,"22")
 .S HOW=$P($E(VAFSTR,Y,$F(VAFSTR,",",Y)),",",1)
 .D SEQ22^VAFHLPI1(HOW,HLQ)
 ;
QUIT D KVA^VADPT
 D MAKEIT^VAFHLU("PID",.VAFY,.OUTPUT,.VAFPID)
 Q OUTPUT
