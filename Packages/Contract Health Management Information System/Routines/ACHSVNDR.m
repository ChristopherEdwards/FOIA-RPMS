ACHSVNDR ; IHS/ITSC/PMF - extract standard vars from the vender file   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;standard call to retrieve and piece out vendor info
 ;
 ;INPUT:
 ;  VNDPTR       pointer to the vender file
 ;
 ;OUTPUT:
 ;
 ;  VLSTUPD      date of last update
 ;  VLSTTRN      date of last transmission
 ;
 ;  VNDEIN       ein number
 ;  VNDEINSF     ein suffix
 ;  VNDRNAM      name
 ;  VNDTYPE      type code
 ;  VNDFNFC      federal non federal code
 ;  VNDLUPD      date of last update
 ;  VNDTXDT      date this vendor was translated
 ;  VNDSTRET     street address
 ;  VNDCITY      city
 ;  VNDSTATE     state
 ;  VNDZIP       zip
 ;
 ;
 S OK=0
 I '$G(VNDPTR) Q
 ;
 S VNDNAM=$P($G(^AUTTVNDR(VNDPTR,0)),U,1)
 I VNDNAM="" Q
 N DATA
 S DATA=$G(^AUTTVNDR(VNDPTR,11))
 ;
 ;the vendor number is supposed to be prescreened and
 ;be exactly 10 chars long.  However, sometimes it is not.
 ;for that reason, we are cutting it off at 10
 S VNDEIN=$E($P(DATA,U,1),1,10)
 S VNDEINSF=$P(DATA,U,2)
 S VNDTYPE=$P(DATA,U,3)
 S VNDFNFC=$P(DATA,U,10) I VNDFNFC'=2 S VNDFNFC=1
 S VNDLUPD=$P(DATA,U,11)
 S VNDTXDT=$P(DATA,U,12)
 ;
 ;
 S DATA=$G(^AUTTVNDR(VNDPTR,13))
 S VNDSTRET=$P(DATA,U,1)
 S VNDCITY=$P(DATA,U,2)
 S VNDSTATE=$P(DATA,U,3)
 S VNDZIP=$P(DATA,U,4)
 ;
 S OK=1
 Q
 ;
INIT ;
 S (VNDEIN,VNDEINSF,VNDTYPE,VNDFNFC,VNDLUPD,VNDTXDT,VNDSTRET,VNDCITY,VNDSTATE,VNDZIP)=""
 Q
 ;
KLL ;EP from ACHSTX11
 K VNDEIN,VNDEINSF,VNDTYPE,VNDFNFC,VNDLUPD,VNDTXDT,VNDSTRET,VNDCITY,VNDSTATE,VNDZIP
 Q
 ;
