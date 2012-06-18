ACHSDNAP ; IHS/ITSC/PMF - ADD PROVIDER TO EXISTING DENIAL ;  [ 02/12/2002  10:27 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**3,18**;JUN 11, 2001
 ;ACHS*3.1*3 improve the denial/patient look up
 ;           the ENTIRE OLD PROGRAM is removed for this patch
 ;           and what you see here is new
 ;
 S DIWL=5,DIWR=75,DIWF="W"
PAT ; --- Select the Denial
 S ACHDOCT="denial"
 D ^ACHSDLK
 I $D(ACHDLKER) Q
 ;
 D ^ACHSDN3
 Q
