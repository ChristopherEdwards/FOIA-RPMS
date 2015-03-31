AGMPIPID ;IHS/SD/TPF - Patient Registration MPI HLO Interface
 ;;7.2;IHS PATIENT REGISTRATION;**1**;JAN 07, 2011
 ;BLDPID^VAFCQRY WAS USED AS A TEMPLATE
 Q
BLDPID(DFN,CNT,SEQ,PID,HL,ERR)  ;build PID from File #2
 N VAFCMN,VAFCMMN,SITE,VAFCZN,SSN,SITE,APID,PDOD,HIST,HISTDT,VAFCHMN,LVL,LVL1,NXT,LNGTH,NXTC,COMP,REP,SUBCOMP,LVL2,X,STATE,CITY,CLAIM,HLECH,HLFS,HLQ,X,STATEIEN
 S HLECH=HL("ECH"),HLFS=HL("FS"),HLQ=HL("Q")
 S COMP=$E(HL("ECH"),1)
 S SUBCOMP=$E(HL("ECH"),4)
 S REP=$E(HL("ECH"),2)
 ;get Patient File MPI node
 S VAFCMN=$$MPINODE(DFN)
 I +VAFCMN<0 S VAFCMN=""
 S VAFCZN=^DPT(DFN,0)
 S SSN=$P(^DPT(DFN,0),"^",9)
 S SITE=$$SITE^VASITE
 S APID(2)=CNT
 ;repeat patient ID list including ICN (NI),SSN (SS),CLAIM# (PN) AND DFN (PI)
 S APID(4)=""
 ;National Identifier (ICN)
 ;I VAFCMN'="" I +VAFCMN>0 S APID(4)=$P(VAFCMN,"^")_"V"_$P(VAFCMN,"^",2)_COMP_COMP_COMP_"USVHA"_SUBCOMP_SUBCOMP_"0363"_COMP_"NI"_COMP_"VA FACILITY ID"_SUBCOMP_$$STA^XUAF4(+SITE)_SUBCOMP_"L" D
 ;. ;Assumption that if this is a local ICN at this point send the message with an expiration date of today, so that it will be treated as a deprecated ID and stored on the MPI as such
 ;. I $E($P(VAFCMN,"^"),1,3)=$P($$SITE^VASITE,"^",3) S APID(4)=APID(4)_COMP_COMP_$$HLDATE^HLFNC(DT)
 S APID(4)=$P(VAFCMN,"^")_"V"_$P(VAFCMN,"^",2)_COMP_COMP_COMP_"USVHA"_SUBCOMP_SUBCOMP_"0363"_COMP_"NI"_COMP_"VA FACILITY ID"_SUBCOMP_$$STA^XUAF4(+SITE)_SUBCOMP_"L"  ;IHS/SD/TPF 7/22/2009 AG*7.1*MPI NEEDED FOR SUN MPI
 I $E($P(VAFCMN,"^"),1,3)=$P($$SITE^VASITE,"^",3) S APID(4)=APID(4)_COMP_COMP_$$HLDATE^HLFNC(DT)  ;IHS/SD/TPF 7/22/2009 AG*7.1*MPI NEEED FOR SUN MPI
 ;IHS/SD/TPF 7/22/2009 AG*7.2*MPI NEEDED TO COMPLETE PID PROPERLY FOR SUN MPI
 S:'$D(SSN) SSN="" S APID(4)=APID(4)_$S(APID(4)'="":REP,1:"")_SSN_COMP_COMP_COMP_"USSSA"_SUBCOMP_SUBCOMP_"0363"_COMP_"SS"_COMP_"VA FACILITY ID"_SUBCOMP_$$STA^XUAF4(+SITE)_SUBCOMP_"L"
 I $G(DFN)'="" S APID(4)=APID(4)_$S(APID(4)'="":REP,1:"")_DFN_COMP_COMP_COMP_"USVHA"_SUBCOMP_SUBCOMP_"0363"_COMP_"PI"_COMP_"VA FACILITY ID"_SUBCOMP_$$STA^XUAF4(+SITE)_SUBCOMP_"L" D
 .;CLAIM#
 .;IHS WILL NOT HAVE AN ICN HISTORY
 ;patient name (last^first^middle^suffix^prefix^^"L" for legal)
 S APID(6)=$$HLNAME^XLFNAME($P(VAFCZN,"^"),"",$E(HL("ECH"),1)) I $P(APID(6),$E(HL("ECH"),1),7)'="L" S $P(APID(6),$E(HL("ECH"),1),7)="L"
 ;mother's maiden name  (last^first^middle^suffix^prefix^^"M" for maiden name)
 S APID(7)=HL("Q")
 I $D(^DPT(DFN,.24)) S VAFCMMN=$P(^DPT(DFN,.24),"^",3) D
 . S APID(7)=$$HLNAME^XLFNAME(VAFCMMN,"",$E(HL("ECH"),1)) I APID(7)="" S APID(7)=HL("Q")
 . I $P(APID(7),$E(HL("ECH"),1),7)'="M" S $P(APID(7),$E(HL("ECH"),1),7)="M"
 S APID(8)=$$HLDATE^HLFNC($P(VAFCZN,"^",3))  ;date/time of birth
 S APID(9)=$P(VAFCZN,"^",2)  ;sex
 ;place of birth city and state
ADDR S APID(12)="" D
 . I $D(^DPT(DFN,0)) D
 .. ;address info
 .. S $P(APID(12),COMP)=$$GET1^DIQ(2,DFN_",",.111) I $P(APID(12),COMP)="" S $P(APID(12),COMP)=HL("Q")
 .. N LINE2 S LINE2=$$GET1^DIQ(2,DFN_",",.112) N LINE3 S LINE3=$$GET1^DIQ(2,DFN_",",.113)
 .. S $P(APID(12),COMP,2)=LINE2 I $P(APID(12),COMP,2)="" S $P(APID(12),COMP,2)=HL("Q")
 .. S $P(APID(12),COMP,8)=LINE3 I $P(APID(12),COMP,8)="" S $P(APID(12),COMP,8)=HL("Q")
 .. S $P(APID(12),COMP,3)=$$GET1^DIQ(2,DFN_",",.114) I $P(APID(12),COMP,3)="" S $P(APID(12),COMP,3)=HL("Q")
 .. S STATEIEN=$$GET1^DIQ(2,DFN_",",.115,"I") S STATE=$$GET1^DIQ(5,+STATEIEN_",",1) S $P(APID(12),COMP,4)=$G(STATE) I $P(APID(12),COMP,4)="" S $P(APID(12),COMP,4)=HL("Q")
 .. S $P(APID(12),COMP,5)=$$GET1^DIQ(2,DFN_",",.1112) I $P(APID(12),COMP,5)="" S $P(APID(12),COMP,5)=HL("Q")
 .. S $P(APID(12),COMP,7)="P"
 .. ;place of birth information
 .. S CITY=$$GET1^DIQ(2,DFN_",",.092) D
 ... I $G(CITY)'="" S $P(X,COMP,3)=CITY
 ... I $G(CITY)="" S $P(X,COMP,3)=HL("Q")
 ... S STATEIEN=$$GET1^DIQ(2,DFN_",",.093,"I") S STATE=$$GET1^DIQ(5,+STATEIEN_",",1) D
 .... I $G(STATE)'="" S $P(X,COMP,4)=STATE
 .... I $G(STATE)="" S $P(X,COMP,4)=HL("Q")
 ... S $P(X,COMP,7)="N"
 ... S APID(12)=$G(APID(12))_REP_X
 S APID(13)=$$GET1^DIQ(2,DFN_",",.117) I APID(13)="" S APID(13)=HL("Q")  ;county code
 N PHONEN,HNUM,WNUM S PHONEN=$G(^DPT(DFN,.13)) S HNUM=$P(PHONEN,"^",1),WNUM=$P(PHONEN,"^",2)
 S APID(14)=$$HLPHONE^HLFNC(HNUM)
 S APID(15)=$$HLPHONE^HLFNC(WNUM)
 S:APID(14)'="" APID(14)=APID(14)_"~PRN~PH"
 S:APID(15)'="" APID(15)=APID(15)_"~WPH~PH"
 D DEM^VADPT
 ;S APID(17)="" I +VADM(10)>0 S X=$P($G(^DIC(11,+VADM(10),0)),"^",3),APID(17)=$S(X="N":"S",X="U":"",X="":HLQ,1:X) ;marital status (DHCP N=HL7 S, U="") ;**477
 S APID(17)="" I +VADM(10)>0 S APID(17)=+VADM(10)
 S APID(18)="" I +VADM(9)>0 S APID(18)=$P($G(^DIC(13,+VADM(9),0)),"^",4) I APID(18)="" S APID(18)=29  ;religious pref (if blank send 29 (UNKNOWN))
 S APID(30)="" I $D(^DPT(DFN,.35)) S PDOD=$P(^DPT(DFN,.35),"^")  ;date of death
 I $G(PDOD) S APID(30)=$$CONDT^AGMPHLU(PDOD)
 N X F X=6,7,8,9,13,14,15,17,18,30 I APID(X)="" S APID(X)=HL("Q")
 ;list of fields used for backwards compatibility with HDR
 S APID(3)=$P(VAFCMN,"^")_"V"_$P(VAFCMN,"^",2)  ;Patient ID
 S APID(20)=SSN  ;ssn passed in PID-3
 S APID(24)=CITY_" "_STATE  ;place of birth (not used) use PID-11 with an 'N' instead
 ;list of fields not currently used or supported (# is 1 more than seq)
 S APID(5)=""  ;Alternate Patient Identifier
 S APID(10)=""  ;patient alias
 S APID(11)="" I +$G(VADM(8)) S APID(11)=$P($G(^DIC(10,+VADM(8),0)),U,3) ;race
 S APID(16)=""  ;primary language
 S APID(19)=""  ;patient account #
 S APID(21)=""  ;drivers lic #
 S APID(22)=""  ;mother's id
 S APID(23)=""  I +$G(VADM(11,1)) S APID(23)=$P($G(^DIC(10.2,+VADM(11,1),0)),U,2) ;ethnic group
 S APID(26)=""  S APID(26)=$P($G(^AUPNPAT(DFN,18)),U)      ;OTHER PHONE
 S APID(26)=$$HLPHONE^HLFNC(APID(26))
 S:APID(26)'="" APID(26)=APID(26)_"~ORN~CP"
 S APID(27)=""  S APID(27)=$P($G(^AUPNPAT(DFN,18)),U,2)      ;CURRENT EMAIL ADDRESS
 S:APID(27)'="" APID(27)=APID(27)_"~NET~INTERNET"
 S APID(28)=$$GET1^DIQ(2,DFN_",",1901,"I")
 S APID(29)=""
 S APID(31)=""
 S PID(1)="PID"_HL("FS")
 S LVL=1,X=1 F  S X=$O(APID(X)) Q:'X  D
 . S PID(LVL)=$G(PID(LVL))
 . S NXT=APID(X) D
 .. I '$O(APID(X,0)) S NXT=NXT_HL("FS")
 .. I $L($G(PID(LVL))_NXT)>245 S LNGTH=245-$L(PID(LVL)),PID(LVL)=PID(LVL)_$E(NXT,1,LNGTH) S LNGTH=LNGTH+1,NXT=$E(NXT,LNGTH,$L(NXT)),LVL=LVL+1
 .. I $L($G(PID(LVL))_NXT)'>245 S PID(LVL)=$G(PID(LVL))_NXT
 . S LVL2=0 F  S LVL2=$O(APID(X,LVL2)) Q:'LVL2  D
 .. S NXT=APID(X,LVL2) D
 ... I $L($G(PID(LVL))_NXT)>245 S LNGTH=245-$L(PID(LVL)),PID(LVL)=PID(LVL)_$E(NXT,1,LNGTH) S LNGTH=LNGTH+1,NXT=$E(NXT,LNGTH,$L(NXT)),LVL=LVL+1
 ... I $L($G(PID(LVL))_NXT)'>245 S PID(LVL)=$G(PID(LVL))_NXT
 ... I '$O(APID(X,LVL2)) S PID(LVL)=PID(LVL)_HL("FS")
 D KVA^VADPT
 Q
 ;
MPINODE(DFN) ; returns MPI node for given DFN
 ; DFN - patient file ien
 ; returns:  -1^error message or MPI node from patient file
 N TMP
 I '$D(DFN) Q "-1^DFN not defined"
 I '$D(^DPT(DFN)) Q "-1^DFN doesn't exist"
 I '$D(^DPT(DFN,"MPI")) Q "-1^No MPI node for DFN "_DFN
 L +^DPT("MPI",DFN):10 ;**45 added lock check for getting ICN data back
 N NODE S NODE=$G(^DPT(DFN,"MPI"))
 I NODE=""!(NODE?."^") S NODE="-1^No MPI data for DFN "_DFN
 L -^DPT("MPI",DFN)
 Q NODE
