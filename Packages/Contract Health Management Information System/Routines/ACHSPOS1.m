ACHSPOS1 ; IHS/ITSC/PMF - DEFERRED SERVICE LETTER FORCE ENTRY DENIAL STATUS FORCE ENTRY ;   [ 10/19/2001  10:58 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**18**;JUN 11, 2001
 ;ACHS*3.1*18 7/16/2010;IHS/OIT/ABK;Change every occurrance of Deferred to Unmet Need
 ;
 S $ZT="ERROR^"_$ZN
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,$ZN,"ENTERED")=NOW
 ;
 N A,B,C
 F A=1:2 S B=$P($T(TAG+A),";;",2) Q:B=""  S @B=$P($T(TAG+(A+1)),";;",2)
 ;
 D DEF       ;ENTER 'DEFERRED SERVICE LETTER' DATA
 D DENA      ;ENTER 'DENIAL STATUS' DATA
 ;
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,$ZN,"FINISHED")=NOW
 Q
 ;
 ;
DEF ;CODE FOR FORCE ENTRY TO ^ACHSDFC HERE
 ;
 W !!
 ;
 ;
 ;
 ;{ABK,7/16/2010}I '$D(^ACHSDEF(0)) S ^ACHSDEF(0)="CHS DEFERRED SERVICE DATA^9002066P^0^0"
 I '$D(^ACHSDEF(0)) S ^ACHSDEF(0)="CHS UNMET NEED DATA^9002066P^0^0"
 ;
 ;
 S XBCFIXFL=9002066
 D XBCFIXFL^XBCFIX
 ;
 I XBCFIXC D  Q
 .S %H=$H D YX^%DTC S NOW=Y
 .;S ^ACHSINST(ACHSVERS,"DEF^"_$ZN,"CHS DEFERRED SERVICE DATA FOUND")=NOW
 .;W !?15,"'CHS DEFERRED SERVICE' data found! Not overwriting!"
 .S ^ACHSINST(ACHSVERS,"DEF^"_$ZN,"CHS UNMET NEED DATA FOUND")=NOW
 .W !?15,"'CHS UNMET NEED' data found! Not overwriting!"
 E  D
 .;W !?15,"'CHS DEFERRED SERVICE' data not found!  Loading data....."
 .;S ^ACHSINST(ACHSVERS,"DEF^"_$ZN,"CHS DEFERRED SERVICE DATA NOT FOUND")=NOW
 .W !?15,"'CHS DEFERRED SERVICE' data not found!  Loading data....."
 .S ^ACHSINST(ACHSVERS,"DEF^"_$ZN,"CHS DEFERRED SERVICE DATA NOT FOUND")=NOW
 ;
 ;get each facility listed in the CHS facility file and
 ;set up the deferred global
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,"DEF^"_$ZN,"ENTERED")=NOW
 ;
 S ACHSFAC=""
 F  S ACHSFAC=$O(^ACHSF("B",ACHSFAC)) Q:ACHSFAC=""  D DEFFAC
 ;
 Q
 ;
DEFFAC ;
 S X="^TMP("_$J_",""DEF"")"
 F  S X=$Q(@X) Q:X=""!(X'[("""DEF"""))  D
 .S GLOBAL="^ACHSDEF("_ACHSFAC_$P(X,"""DEF""",2)
 .S @GLOBAL=@X
 S DIK="^ACHSDEF(" D IXALL^DIK
 ;
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,"DEF^"_$ZN,"FINISHED")=NOW
 Q
 ;
DENA ;CODE FOR ENTRY TO ^ACHSDENA
 ;
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,"DENA^"_$ZN,"ENTERED")=NOW
 ;
 I '$D(^ACHSDENA(0)) S ^ACHSDENA(0)="CHS DENIAL STATUS^9002074^0^0"
 S XBCFIXFL=9002074
 D XBCFIXFL^XBCFIX
 ;
 ;IF FILE HAS ENTRIES LEAVE ALONE AND QUIT
 I XBCFIXC D  Q
 .S %H=$H D YX^%DTC S NOW=Y
 .S ^ACHSINST(ACHSVERS,"DENA^"_$ZN,"CHS DENIAL STATUS DATA FOUND")=NOW
 .W !?15,"'CHS DENIAL STATUS' data found! Not overwriting!'"
 E  D
 .W !?15,"'CHS DENIAL STATUS' data not found!  Loading data...."
 .S ^ACHSINST(ACHSVERS,"DENA^"_$ZN,"CHS DENIAL STATUS DATA NOT FOUND")=NOW
 ;
 S X="^TMP("_$J_",""STA"")"
 F  S X=$Q(@X) Q:X=""!(X'[("""STA"""))  D
 .S GLOBAL="^ACHSDENA("_$P($P(X,"""STA""",2),",",2,99)
 .S @GLOBAL=@X
 S DIK="^ACHSDENA(" D IXALL^DIK
 ;
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,"DENA^"_$ZN,"FINISHED")=NOW
 ;
 Q
 ;
ERROR S ^ACHSINST(ACHSVERS,"ERROR",$ZN,"ERROR TRAP CALLED")=NOW
 G ^%ET
 Q
 ;
 ;
TAG ;
 ;;^TMP($J,"DEF",2,0)
 ;;^^12^12^2940809
 ;;^TMP($J,"DEF",2,1,0)
 ;;An Indian Health Service (IHS) physician has recommended that you have
 ;;^TMP($J,"DEF",2,2,0)
 ;;the deferred service identified above.  Funds are not presently
 ;;^TMP($J,"DEF",2,3,0)
 ;;available for payment for deferred services.  This is to notify you 
 ;;^TMP($J,"DEF",2,4,0)
 ;;that your name has been put on the waiting list for scheduling and
 ;;^TMP($J,"DEF",2,5,0)
 ;;payment if funding becomes available.
 ;;^TMP($J,"DEF",2,6,0)
 ;; 
 ;;^TMP($J,"DEF",2,7,0)
 ;;If you have not been notified of the availability of funds within six to twelve months of the
 ;;^TMP($J,"DEF",2,8,0)
 ;;date of this letter, contact this office for further information.  In the meantime, please
 ;;^TMP($J,"DEF",2,9,0)
 ;;contact your health care providers for any concerns about your medical condition.
 ;;^TMP($J,"DEF",2,10,0)
 ;; 
 ;;^TMP($J,"DEF",2,11,0)
 ;;While your request for deferred services funds is pending, you may
 ;;^TMP($J,"DEF",2,12,0)
 ;;appeal this decision to:
 ;;^TMP($J,"STA",1,0)
 ;;PAYED WITH ADDITIONAL MONEY
 ;;^TMP($J,"STA",2,0)
 ;;REVERSED AFTER APPEAL
 ;;^TMP($J,"STA",3,0)
 ;;UPHELD AFTER APPEAL
 ;;^TMP($J,"STA",4,0)
 ;;APPEAL PENDING
