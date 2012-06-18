BARDMAN3 ; IHS/SD/LSL - A/R Debt Collection Process (3) ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 04/08/2004 - V1.8
 ;      Routine created.  Moved (modified) from BBMDC2
 ;      All entry points called from BARDMAN2.  Creates one of four
 ;      temporary globals containing records of data for that file type.
 ;
 ; ********************************************************************
 Q
 ;
SSELFILE ; EP
 ; Build temp global of self pay stops records
 ; ------------------------------------------------
 ; File layout
 ; ---------------
 ;  1 -  5     Client Number TSI Assigned Number
 ;  6 - 25     Transmittal number      (AR bill - strip dashes)
 ; 26 - 26     Code                    (5=Paid, 1=Cancel, A=adjusted)
 ; 27 - 34     New Balance             (AR Bill balance)
 ; ------------------------------------------------
 ;
 I $L(BARBLNM)<21 S BARBLNM=$$LJ(BARBLNM,20)
 E  S BARBLNM=$E(BARBLNM,1,20)
 ;
 I $L(BARBAL)<9 S BARBAL=$$PAD(BARBAL,8)
 ;
 S ^BARSSELF($J,BARBL)=BARSNUM
 S ^BARSSELF($J,BARBL)=^BARSSELF($J,BARBL)_BARBLNM
 S ^BARSSELF($J,BARBL)=^BARSSELF($J,BARBL)_BARACT
 S ^BARSSELF($J,BARBL)=^BARSSELF($J,BARBL)_BARBAL
 Q
 ; ********************************************************************
 ;
SINSFILE ; EP
 ; Build temp global of insurer stops records
 ; ------------------------------------------------
 ; File layout
 ; ---------------
 ;  1 -  5     Client Number TSI Assigned Number
 ;  6 - 25     Transmittal number      (AR bill - strip dashes)
 ; 26 - 26     Code                    (5=Paid, 1=Cancel, A=adjusted)
 ; 27 - 34     New Balance             (AR Bill balance)
 ; ------------------------------------------------
 ;
 I $L(BARBLNM)<21 S BARBLNM=$$LJ(BARBLNM,20)
 E  S BARBLNM=$E(BARBLNM,1,20)
 ;
 I $L(BARBAL)<9 S BARBAL=$$PAD(BARBAL,8)
 ;
 S ^BARSTOPS($J,BARBL)=BARINUM
 S ^BARSTOPS($J,BARBL)=^BARSTOPS($J,BARBL)_BARBLNM
 S ^BARSTOPS($J,BARBL)=^BARSTOPS($J,BARBL)_BARACT
 S ^BARSTOPS($J,BARBL)=^BARSTOPS($J,BARBL)_BARBAL
 Q
 ; ********************************************************************
 ;
TSELFILE ; EP
 ; Build temp global of self pay starts records
 ; ------------------------------------------------
 ; File layout
 ; ---------------
 ;   1 -   5     Client Number TSI Assigned Number
 ;   6 -  35     Patient Name            (Last, First I)
 ;  36 -  65     Optional Address        (If 2 line street addr)
 ;  66 -  95     Street Address
 ;  96 - 110     City
 ; 111 - 112     State
 ; 113 - 117     Zip Code
 ; 118 - 118     Service code          (always 1)
 ; 119 - 138     Transmittal Number    (AR bill - strip dashes)
 ; 139 - 144     Date last pay/charge  (use DOS)
 ; 145 - 152     Amount Due
 ; ------------------------------------------------
 ;
 S BARPAT=$$GET1^DIQ(90050.01,BARBL,101)
 S BARPAT=$P(BARPAT,",")_", "_$P(BARPAT,",",2)
 S BARPAT=$TR(BARPAT,".","")
 S BARPAT=$$LJ(BARPAT,30)
 ;
 S BARPTIEN=$$GET1^DIQ(90050.01,BARBL,101,"I")
 S BARADDR=$$LJ($$GET1^DIQ(2,BARPTIEN,.111),30)
 S BARADDR2=$$GET1^DIQ(2,BARPTIEN,.112)
 I BARADDR2]"" S BARADDR2=$$LJ(BARADDR2,30)
 ;
 S BARCITY=$$LJ($$GET1^DIQ(2,BARPTIEN,.114),15)
 S BARSTATE=$$GET1^DIQ(2,BARPTIEN,".115:1")
 S BARZIP=$$GET1^DIQ(2,BARPTIEN,.116)
 S:BARZIP="" BARZIP="00000"
 ;
 I $L(BARBLNM)<21 S BARBLNM=$$LJ(BARBLNM,20)
 E  S BARBLNM=$E(BARBLNM,1,20)
 ;
 I +BARDOS S BARDOS=$E(BARDOS,4,7)_$E($E(BARDOS,1,3)+1700,3,4)
 E  S BARDOS="      "
 ;
 S BARCHRG=$P($G(^BARTSELF(DUZ(2),BARBL,0)),U,13)
 S BARX=$P(BARCHRG,".")_"."_$P(BARCHRG,".",2)_"00"
 S BARCHRG=$P(BARX,".")_$E($P(BARX,".",2),1,2)
 I $L(BARCHRG)<9 S BARCHRG=$$PAD(BARCHRG,8)
 I $L(BARBAL)<9 S BARBAL=$$PAD(BARBAL,8)
 ;
 S $P(BARSP," ",31)=""
 ;
 S ^BARTSELF($J,BARBL)=BARSNUM
 S ^BARTSELF($J,BARBL)=^BARTSELF($J,BARBL)_BARPAT
 S ^BARTSELF($J,BARBL)=^BARTSELF($J,BARBL)_$S($L($TR(BARADDR2," ",""))>0:BARADDR,1:BARSP)
 S ^BARTSELF($J,BARBL)=^BARTSELF($J,BARBL)_$S($L($TR(BARADDR2," ",""))>0:BARADDR2,1:BARADDR)
 S ^BARTSELF($J,BARBL)=^BARTSELF($J,BARBL)_BARCITY
 S ^BARTSELF($J,BARBL)=^BARTSELF($J,BARBL)_BARSTATE
 S ^BARTSELF($J,BARBL)=^BARTSELF($J,BARBL)_BARZIP
 S ^BARTSELF($J,BARBL)=^BARTSELF($J,BARBL)_1
 S ^BARTSELF($J,BARBL)=^BARTSELF($J,BARBL)_BARBLNM
 S ^BARTSELF($J,BARBL)=^BARTSELF($J,BARBL)_BARDOS
 S ^BARTSELF($J,BARBL)=^BARTSELF($J,BARBL)_BARBAL
 Q
 ; ********************************************************************
 ;
TINSFILE ; EP
 ; Build temp global of insurer starts records
 ; ------------------------------------------------
 ; File layout
 ; ---------------
 ;   1 -   5     Client Number TSI Assigned Number
 ;   6 -  35     Insurance Company Name  (AR Account)
 ;  36 -  65     Optional Address
 ;  66 -  95     Street Address
 ;  96 - 110     City
 ; 111 - 112     State
 ; 113 - 117     Zip Code
 ; 118 - 121     Zip Code Extension
 ; 122 - 151     Policy Number
 ; 152 - 171     Claim Number    (AR Bill - with dashes)
 ; 172 - 201     Insured's Name
 ; 202 - 210     Insured's SS #
 ; 211 - 240     Patient Name
 ; 241 - 260     Transmittal Number   (AR Bill - strip dashes)
 ; 261 - 261     Service Code (1)
 ; 262 - 267     Date of Service    (MMDDYY)
 ; 268 - 275     Charges
 ; 276 - 281     Date of Service 2  (MMDDYY)
 ; 282 - 289     Charges 2
 ; 290 - 295     Date of Service 3  (MMDDYY)
 ; 296 - 303     Charges 3
 ; 304 - 309     Date of Service 4  (MMDDYY)
 ; 310 - 317     Charges 4
 ; 318 - 323     Date of Service 5  (MMDDYY)
 ; 324 - 331     Charges 5
 ;
 ; Dates of service 2-5 are not sent, zero fill
 ; Charges 2-5 are not sent, zero fill
 ; ------------------------------------------------
 ;
 K ABMP
 S BARINSN=$$LJ($$GET1^DIQ(90050.01,BARBL,3),30)
 S BARIIEN=$$GET1^DIQ(90050.01,BARBL,"3:1.001")
 S BARIADDR=$$LJ($$GET1^DIQ(9999999.18,BARIIEN,.02),30)
 S BARICITY=$$LJ($$GET1^DIQ(9999999.18,BARIIEN,.03),15)
 S BARIST=$$GET1^DIQ(9999999.18,BARIIEN,".04:1")
 S BARIZIP=$$GET1^DIQ(9999999.18,BARIIEN,.05)
 I BARIZIP["-" S BARZEXT=$P(BARIZIP,"-",2)
 S BARIZIP=$P(BARIZIP,"-")
 S:$G(BARZEXT)="" BARZEXT="0000"
 S:BARIZIP="" BARIZIP="00000"
 ;
 D SBR^BARUTL(DUZ(2),BARBL)             ; Get policy holder info
 S BARPOLN=$G(ABMP("PNUM"))
 S:BARPOLN="" BARPOLN=$$GET1^DIQ(90050.01,BARBL,702)
 S BARPOLN=$$LJ(BARPOLN,30)
 S BARPLNM=$$LNM^ABMUTLN($P(BARSBR,"-"),$P(BARSBR,"-",2))
 S BARPFNM=$$FNM^ABMUTLN($P(BARSBR,"-"),$P(BARSBR,"-",2))
 S BARPMI=$$MI^ABMUTLN($P(BARSBR,"-"),$P(BARSBR,"-",2))
 I BARPLNM]"" S BARPNAM=BARPLNM_", "_BARPFNM_" "_BARPMI
 E  S BARPNAM=$$GET1^DIQ(90050.01,BARBL,701)
 S BARPNAM=$$LJ(BARPNAM,30)
 ;
 S BARPAT=$$GET1^DIQ(90050.01,BARBL,101)
 S BARPAT=$P(BARPAT,",")_", "_$P(BARPAT,",",2)
 S BARPAT=$TR(BARPAT,".","")
 S BARPAT=$$LJ(BARPAT,30)
 ;
 ;bill number with dashes - claim number
 I $L(BARBLNMD)<21 S BARBLNMD=$$LJ(BARBLNMD,20)
 E  S BARBLNMD=$E(BARBLNMD,1,20)
 ;
 ;bill number strip dashes - transmittal number
 I $L(BARBLNM)<21 S BARBLNM=$$LJ(BARBLNM,20)
 E  S BARBLNM=$E(BARBLNM,1,20)
 ;
 I +BARDOS S BARDOS=$E(BARDOS,4,7)_$E($E(BARDOS,1,3)+1700,3,4)
 E  S BARDOS="000000"
 ;
 S BARCHRG=$P($G(^BARBL(DUZ(2),BARBL,0)),U,13)
 S BARX=$P(BARCHRG,".")_"."_$P(BARCHRG,".",2)_"00"
 S BARCHRG=$P(BARX,".")_$E($P(BARX,".",2),1,2)
 I $L(BARCHRG)<9 S BARCHRG=$$PAD(BARCHRG,8)
 ;
 S $P(BARSP," ",31)=""
 S $P(BARDOSFL,"0",7)=""
 S $P(BARCHGFL,"0",9)=""
 ;
 S ^BARSTART($J,BARBL)=BARINUM
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARINSN
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARSP
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARIADDR
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARICITY
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARIST
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARIZIP
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARZEXT
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARPOLN
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARBLNMD
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARPNAM
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_"         "
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARPAT
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARBLNM
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_1
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARDOS
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARCHRG
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARDOSFL
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARCHGFL
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARDOSFL
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARCHGFL
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARDOSFL
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARCHGFL
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARDOSFL
 S ^BARSTART($J,BARBL)=^BARSTART($J,BARBL)_BARCHGFL
 Q
 ; ********************************************************************
 ;
PAD(BARVAR,BARLNG) ; EP
 ; Right justify, zero fill value BARVAR for length BARLNG
 K BARZERO
 S $P(BARZERO,"0",BARLNG+1)=""
 S BARVAR=BARZERO_BARVAR
 S BARVAR=$E(BARVAR,$L(BARVAR)-(BARLNG-1),$L(BARVAR))
 Q BARVAR
 ; ********************************************************************
 ;
LJ(BARVAR,BARLNG) ; EP
 ; Left justify, space fill value BARVAR for length BARLNG
 I $L(BARVAR)>(BARLNG-1) D  Q BARVAR
 . S BARVAR=$E(BARVAR,1,BARLNG)
 S $P(BARSPACE," ",BARLNG+1)=""
 S BARVAR=BARVAR_BARSPACE
 S BARVAR=$E(BARVAR,1,BARLNG)
 Q BARVAR
