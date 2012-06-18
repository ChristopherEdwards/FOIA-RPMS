ACHSTX22 ; IHS/ITSC/PMF - export data (?/??) - RECORD 2(DHR) 
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;;ACHS*3*4 PATCH TO PATCH #3 & HAS TO CORE CONVERSION
 ;;ACHS*3*7 FIX THE RETRANSMISSION PROBLEM
 ;
 ;This program will create a type 2 record for ACHSDIEN, or
 ;    tell us why not.
 ;
 ;To get a type 2 record:
 ;       NOT be both 638 AND parm209=true. either is ok, neither
 ;                                         is ok.
 ;       I, C, and S types only.  Not P, ZA, IP, or others.
 ;                                Note:  ZA and IP are already
 ;                                       filtered out by now
 ;
 ;
 ;default
 I ACHSF638="Y",ACHSF209 S RET=2 Q
 I ACHSTY="P" S RET=3 Q
 ;
 ;gonna do a type 2 record
 S (ACHSX,X1)=FSCLYR
 D FYCVT^ACHSFU
 ;
 S ACHSEFDT=$E(DT,4,5)_$E(DT,6,7)_$E(DT,2,3),ACHSCDE=$S(ACHSCTY="I":"05013",ACHSCTY="F":"05024",ACHSCTY="P":"05025",ACHSTY="S":"05015",1:"")
 ;
 S ACHSRCT=ACHSRCT+1,ACHSRTYP(2)=ACHSRTYP(2)+1
 ;
 S ^ACHSDATA(ACHSRCT)="2"_ACHSEFDT_ACHSCDE_$S(TYPSERV=1:323,TYPSERV=2:324,TYPSERV=3:325,1:"")_ACHSDOCN_$J("",13)_"1"_X1_CAN_OCC_ACHSIPA_VNDFNFC_$J("",16)
 ;
 S PMFF=^ACHSDATA(ACHSRCT) D ^ACHSTX99
 ;
 I $L(^ACHSDATA(ACHSRCT))'=80 S STOP=5 Q
 ;
 ;
 ;remove these lines for test
 ;I ACHSRCT=1 S ACHSFDT=ACHSBDT W !!,"NUMBER OF RECORDS PROCESSED = ",!!
 ;I ACHSRCT#25=0 W $J(ACHSRCT,8)
 ;
 ;
 ;now the 2b and 2c records
 ;
 S ACHSCAN="IHS/AP:"_$E(CAN,2,3)_"/SU:"_$E(CAN,4)_"/YR:"_$E(CAN,5)_"/CC:"_$E(CAN,6,7)
 S ACHSCAN=ACHSCAN_$J("",30-$L(ACHSCAN))
 ;
 S ACHSOBJC=$E($P($G(^ACHSOCC(OCCPTR,0)),U,2),1,20)
 S ACHSOBJC=ACHSOBJC_$J("",20-$L(ACHSOBJC))
 ;
 S ACHSDR3=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,3))
 S ACHSABD=$E($P(ACHSDR3,U,1),4,7)
 S ACHSAED=$E($P(ACHSDR3,U,2),4,7)
 K ACHSDR3
 ;
 S %="2B"_ACHSFC_"."_ACHSCAN_ACHSOBJC_ACHSY_ACHSABD_ACHSAED ;ACHS
 D SET(%)
 ; 2C
 ; Vendor EIN
 S %=$E(VNDEIN_$J("",10),1,10)_$E(VNDEINSF_"  ",1,2)
 ;
 ; Vendor Name
 S %=%_$E(VNDNAM,1,30)
 S %=%_$J("",42-$L(%))
 ;
 ; Vendor CityStZip
 S STATE=$P($G(^DIC(5,VNDSTATE,0)),U,2)
 S %=%_VNDCITY_","_STATE_","_VNDZIP
 S %=$E(%,1,72),%=%_$J("",72-$L(%))
 K STATE
 ;
 S %="2C"_%
 D SET(%)
 S RET=0
 ;
 Q
 ;
SET(%)  ; 
 S %=%_$J("",80-$L(%))
 S ACHSRCT=ACHSRCT+1,^ACHSDATA(ACHSRCT)=%
 ;
 ;remove next line for test
 ;I ACHSRCT#25=0 W $J(ACHSRCT,8)
 ;
 S PMFF=^ACHSDATA(ACHSRCT) D ^ACHSTX99
 Q
