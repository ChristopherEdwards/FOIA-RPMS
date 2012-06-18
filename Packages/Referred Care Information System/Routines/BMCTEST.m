BMCTEST ; IHS/PHXAO/TMJ - TEST OF LAST FY REFERRAL ; 
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 S BMCSTART=60640101
 ;S BMCXLAST=$O(^BMCREF("FY",BMCSTART,"")),BMCXVDFN=$O(^BMCREF("FY",BMCSTART,BMCXLAST,""))
 ;W BMCXVDFN,!
 ;W BMCXLAST,!
 ;W BMCXLAST-1,!
 ;Q
 ;
ANOTHER ;
REFDISP ;Display if Patient has existing Referrals
 W !!,?25,"********************",!
 W ?25,"**LAST 5 REFERRALS**",!,?25,"********************",!
 I '$D(^BMCREF("FY",BMCSTART)) W !,?20,"**--NO EXISTING REFERRALS--**",! S BMCQ=1 Q
 S BMCQ=0
 S BMCIEN=""
 F I=1:1:5 S BMCIEN=$O(^BMCREF("FY",BMCSTART,BMCIEN),-1) Q:BMCIEN=""  D
 . Q:BMCIEN=""
 . ;Q:BMCRIEN=""
 . ;D START^BMCLKID1
 . ;S I=I+1 ; increment outer loop counter to limit display to 5 referrals
 . W BMCIEN,!
 . Q
 Q
