ACHSPOS3 ; IHS/ITSC/PMF - DATA FOR DENIAL REASONS (CONT) ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 S $ZT="ERROR^"_$ZN
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,$ZN,"ENTERED")=NOW
 ;
 N A,B,C
 F A=1:2 S B=$P($T(TAG+A),";;",2) Q:B=""  S @B=$P($T(TAG+(A+1)),";;",2)
 ;
 S %H=$H D YX^%DTC S NOW=Y
 S ^ACHSINST(ACHSVERS,$ZN,"FINISHED")=NOW
 Q
 ;
ERROR S ^ACHSINST(ACHSVERS,"ERROR",$ZN,"ERROR TRAP CALLED")=NOW
 G ^%ET
 Q
 ;
TAG ;
 ;;^TMP($J,"DEN",19,0)
 ;;Lives Outside Local CHS Service Area^Lives Outside Local CHS Service Area
 ;;^TMP($J,"DEN",19,1,1,0)
 ;;You are not eligible for Contract Health Services (CHS) because you do not live on the reservation and do not maintain close economic and social ties with the local tribe(s) for which the reservation was established. Close ties include marriage, employment or tribal certification. [Per 42 Code of Federal Regulations 36.23 (1986)].
 ;;^TMP($J,"DEN",20,0)
 ;;IHS Facility Was Available^IHS Facility Was Available
 ;;^TMP($J,"DEN",20,1,1,0)
 ;;The medical care for which you request Contract Health Service (CHS) payment by the Indian Health Service (IHS) could have been provided by an IHS facility.  [Per 42 Code of Federal Regulations 36.23(a) (1986)].
 ;;^TMP($J,"DEN",21,0)
 ;;Insufficient Medical Information^Insufficient Medical Information
 ;;^TMP($J,"DEN",21,1,1,0)
 ;;You did not provide adequate written medical information to allow us to make a decision on your request for payment. [See 42 Code of Federal Regulations 36.24 (1986)].
 ;;^TMP($J,"DEN",22,0)
 ;;No Notification of Emergency Service Within 30 Days for Elderly or Disabled Patient^No Notification of Emergency Service Within 30 Days for Elderly or Disabled Patient
 ;;^TMP($J,"DEN",22,1,1,0)
 ;;You or someone acting on your behalf failed to notify an Indian Health Service official within 30 days after the beginning of your emergency treatment [see Section 406 of the Indian Health Care Improvement Act as amended by Pub. L. 102-573].
