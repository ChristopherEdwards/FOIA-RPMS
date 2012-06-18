BMCFLTR ; IHS/PHXAO/TMJ - FILTERING CRITERIA FOR REFERRAL SELECTION ;    
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;;4.0;IHS/ITSC/FCJ ADDED REFERRAL TYPE-PRIMARY OR SECONDARY
 ; This program provides the ability to use different filtering RTYP
 ; criteria when selecting referrals for close-out or modification
 ;
 ; the naked reference is provided by the calling program
 ;
 ; Input:   RTY [=] 0 if closed referrals are not wanted (C1, C2)
 ;                  1 if only closed referrals are wanted (C1, C2)
 ;                  2 if only active referrals are wanted (A)
 ;          CFY [=] 1 if only current fiscal year referrals are wanted
 ;                  0 if all fiscal years are eligible
 ;         RTYP [=] 0 Primary Referral
 ;                  1 Secondary Referral
 ;                  2 BOTH
 ; Returns: 0 if referral does not qualify
 ;          1 if referral does qualify
 ;
FILTER(RTY,CFY,RTYP) ; EP - used to select referrals for display on screen
 S RTY=$G(RTY),CFY=$G(CFY)
 I '$D(^(0)) Q 0      ; no data exists at requested node
 I RTY=0,$P(^(0),U,15)["C" Q 0   ; do not want closed referrals
 I RTY=1,$P(^(0),U,15)'["C" Q 0   ; want only closed referrals
 I RTY=2,$P(^(0),U,15)'="A" Q 0   ; want only active referrals
 I CFY,$E($P(^(0),U,2),7,8)'=BMCFY Q 0  ;not from current fiscal year
 I RTYP=0,$P($G(^(1)),U)'="" Q 0  ; NOT PRIMARY REFERRAL.....FCJ
 I RTYP=1,$P($G(^(1)),U)="" Q 0  ; NOT A SECONDARY REFERRAL.....FCJ
 Q 1   ; valid referral
