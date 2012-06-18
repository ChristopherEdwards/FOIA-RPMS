ABSPOSS9 ; IHS/FCS/DRS - ANY CRITICAL MISSING ITEMS ;  
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ; Make sure that Point of Sale has all the necessary data in place.
 ; * incomplete *  much more to be added
 Q
REPORT ;EP
 I $P($G(^ABSP(9002313.99,1,"A/R INTERFACE")),U)="" D
 . D PROBLEM
 . W "A/R PACKAGE field in File 9002313.99 must have a value.",!
 I '$O(^ABSPEI("AFormat",0)) D
 . D PROBLEM
 . W "No insurers are set up for Pharmacy Electronic claims.",!
 I '$O(^ABSP(9002313.53,0)) D
 . D PROBLEM
 . W "There are no entries in the Pricing Table",!
 I '$$OPSITE(0) D
 . D PROBLEM
 . W "Not all OUTPATIENT SITEs are associated with a pharmacy.",!
 . D OPSITE(1)
 ;N X S X=$$TESTNULL I 'X D
 ;. D PROBLEM
 ;. W "Failed test of the NULL device: ",X,!
 Q
OPSITE(ECHO) ; is every outpatient site associated with a pharmacy?
 N RET S RET=1
 N A S A=0 F  S A=$O(^PS(59,A)) Q:'A  D
 . I ECHO W "`",A," ",$P(^PS(59,A,0),U)," <--> "
 . N P S P=$O(^ABSP(9002313.56,"C",A,0))
 . I P D
 . . I ECHO W $P(^ABSP(9002313.56,P,0),U),!
 . E  D
 . . S RET=0
 . . I ECHO W "** no associated POS pharmacy!! **",!
 Q:$Q RET Q
PROBLEM W !,"***  PROBLEM FOUND:",! Q
