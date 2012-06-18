ADE6E1 ; IHS/HQT/MJL - DENTAL TABLE UPDATES;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
 ;Data for new data entry screens
 ;^#.01 CODE
 ;^#1 EDIT TYPE 2=TIME LIMIT 3=AGE
 ;^#3 EDIT TIME
 ;^#4 RESOLUTION TYPE 1 = REJECT CODE
 ;^#2 CONFLICT CODE
 ;^#2.4 AGE EDIT
 ;^RESOLUTION MESSAGE
ADDEDIT ;;EP
 ;;^IH70^2^FY|1^1^IH70^^W *7,"This patient has already been assessed during this fiscal year"
 ;;^IH71^2^FY|1^1^IH71^^W *7,"This patient already has a IH71 code this fiscal year"
 ;;^IH71^3^^1^IH71^((X>4)&(X<20))^W *7,"Patient must be between 5 and 19 years old"
 ;;^IH72^2^FY|1^1^IH72^^W *7,"This patient already has a IH72 code this fiscal year"
 ;;^IH72^3^^1^IH72^X<20^W *7,"Patient must be 19 years old or younger"
 ;;^IH73^2^FY|1^1^IH73^^W *7,"This patient already has a IH73 code this fiscal year"
 ;;^IH73^3^^1^IH73^((X>4)&(X<20))^W *7,"Patient must be between 5 and 19 years old"
 ;;^IH74^2^FY|1^1^IH74^^W *7,"This patient already has a IH74 code this fiscal year"
 ;;^IH74^3^^1^IH74^((X>14)&(X<46))^W *7,"Patient must be between 15 and 45 years old"
 ;;^IH75^2^FY|1^1^IH75^^W *7,"This patient already has a IH75 code this fiscal year"
 ;;^IH75^3^^1^IH75^((X>14)&(X<46))^W *7,"Patient must be between 15 and 45 years old"
 ;;^IH76^2^FY|1^1^IH76^^W *7,"This patient already has a IH76 code this fiscal year"
 ;;^IH77^2^99999|1^1^IH77^^W *7,"This patient already has a IH77 code at this facility"
 ;;^IH77^3^^1^IH77^(X>14)^W *7,"Patient must be age 15 years or older"
 ;;END
