FHINI0KG	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(115,0,"GL")
	;;=^FHPT(
	;;^DIC("B","DIETETICS PATIENT",115)
	;;=
	;;^DIC(115,"%D",0)
	;;=^^4^4^2920623^^
	;;^DIC(115,"%D",1,0)
	;;=This file contains all dietetic orders for each admission of a
	;;^DIC(115,"%D",2,0)
	;;=patient. It includes diet orders, consult requests, supplemental
	;;^DIC(115,"%D",3,0)
	;;=feedings, early/late tray requests, and tubefeedings. It also
	;;^DIC(115,"%D",4,0)
	;;=contains any food allergies entered for the patient.
	;;^DD(115,0)
	;;=FIELD^^12^5
	;;^DD(115,0,"DDA")
	;;=N
	;;^DD(115,0,"DT")
	;;=2950926
	;;^DD(115,0,"IX","ADLT",115.05,.01)
	;;=
	;;^DD(115,0,"IX","ADR",115.03,.01)
	;;=
	;;^DD(115,0,"IX","ADRU",115.03,4)
	;;=
	;;^DD(115,0,"IX","ADRV",115.03,7)
	;;=
	;;^DD(115,0,"IX","ADTF",115.01,1.3)
	;;=
	;;^DD(115,0,"IX","AIS",115.01,9)
	;;=
	;;^DD(115,0,"IX","AOO",115.06,4)
	;;=
	;;^DD(115,0,"IX","ASP",115.08,1)
	;;=
	;;^DD(115,0,"IX","ASP1",115.08,5)
	;;=
	;;^DD(115,0,"IX","AW",115.01,13)
	;;=
	;;^DD(115,0,"NM","DIETETICS PATIENT")
	;;=
	;;^DD(115,0,"PT",119.8,2)
	;;=
	;;^DD(115,.01,0)
	;;=NAME^RP2'X^DPT(^0;1^K:X<1 X S:$D(X) DINUM=X
	;;^DD(115,.01,1,0)
	;;=^.1^^0
	;;^DD(115,.01,3)
	;;=
	;;^DD(115,.01,21,0)
	;;=^^2^2^2880710^
	;;^DD(115,.01,21,1,0)
	;;=This is a pointer to the main ^DPT file and has the same internal
	;;^DD(115,.01,21,2,0)
	;;=number as that file. Thus, the patient's name is the ^DPT name.
	;;^DD(115,1,0)
	;;=ADMISSION^115.01D^^A;0
	;;^DD(115,1,21,0)
	;;=^^2^2^2910708^^^^
	;;^DD(115,1,21,1,0)
	;;=This multiple contains all dietetic information pertaining
	;;^DD(115,1,21,2,0)
	;;=to this particular admission.
	;;^DD(115,1,"DT")
	;;=2920103
	;;^DD(115,10,0)
	;;=FOOD PREFERENCES^115.09PA^^P;0
	;;^DD(115,10,21,0)
	;;=^^1^1^2881201^^
	;;^DD(115,10,21,1,0)
	;;=This multiple contains the food preferences selected by the patient.
	;;^DD(115,11,0)
	;;=NUTRITION ASSESSMENT^115.011D^^N;0
	;;^DD(115,11,21,0)
	;;=^^2^2^2920520^^^^
	;;^DD(115,11,21,1,0)
	;;=This field contains Nutrition Assessments performed
	;;^DD(115,11,21,2,0)
	;;=for this patient.
	;;^DD(115,12,0)
	;;=NUTRITION STATUS^115.012D^^S;0
	;;^DD(115,12,21,0)
	;;=^^2^2^2891113^^^
	;;^DD(115,12,21,1,0)
	;;=This multiple contains the nutrition assessment
	;;^DD(115,12,21,2,0)
	;;=statuses that have been entered for this patient.
	;;^DD(115.01,0)
	;;=ADMISSION SUB-FIELD^NL^100^23
	;;^DD(115.01,0,"DT")
	;;=2950926
	;;^DD(115.01,0,"NM","ADMISSION")
	;;=
	;;^DD(115.01,0,"UP")
	;;=115
	;;^DD(115.01,.01,0)
	;;=ADMISSION^D^^0;1^S %DT="ET" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.01,.01,21,0)
	;;=^^3^3^2911204^^^^
	;;^DD(115.01,.01,21,1,0)
	;;=This is the date/time of admission. The admission has the same
	;;^DD(115.01,.01,21,2,0)
	;;=date/time and internal number as the corresponding MAS
	;;^DD(115.01,.01,21,3,0)
	;;=admission stored in ^DPT.
	;;^DD(115.01,1.1,0)
	;;=CURRENT DIET ORDER^NJ5,0I^^0;2^K:+X'=X!(X>99999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.01,1.1,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 99999
	;;^DD(115.01,1.1,9)
	;;=^
	;;^DD(115.01,1.1,21,0)
	;;=^^2^2^2950613^^^^
	;;^DD(115.01,1.1,21,1,0)
	;;=This field is actually a pointer to the current diet order
	;;^DD(115.01,1.1,21,2,0)
	;;=stored in Field 3.
	;;^DD(115.01,1.1,"DT")
	;;=2880515
	;;^DD(115.01,1.2,0)
	;;=DIET ORDER EXPIRATION^DI^^0;3^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.01,1.2,9)
	;;=^
	;;^DD(115.01,1.2,21,0)
	;;=^^3^3^2950613^^^^
	;;^DD(115.01,1.2,21,1,0)
	;;=This field contains the date/time of expiration of the current
	;;^DD(115.01,1.2,21,2,0)
	;;=diet pointed to by Field 1.1. If null, the current diet has
	;;^DD(115.01,1.2,21,3,0)
	;;=no expiration date/time.
	;;^DD(115.01,1.2,"DT")
	;;=2880515
	;;^DD(115.01,1.3,0)
	;;=CURRENT TF ORDER^NJ5,0I^^0;4^K:+X'=X!(X>99999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(115.01,1.3,1,0)
	;;=^.1
	;;^DD(115.01,1.3,1,1,0)
	;;=115^ADTF^MUMPS
	;;^DD(115.01,1.3,1,1,1)
	;;=S ^FHPT("ADTF",DA(1),DA)=""
	;;^DD(115.01,1.3,1,1,2)
	;;=K ^FHPT("ADTF",DA(1),DA)
	;;^DD(115.01,1.3,1,1,"%D",0)
	;;=^^2^2^2940824^
	;;^DD(115.01,1.3,1,1,"%D",1,0)
	;;=This is a list of Patients by Admission who have a current
	;;^DD(115.01,1.3,1,1,"%D",2,0)
	;;=Tubefeeding Order.
	;;^DD(115.01,1.3,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 99999
	;;^DD(115.01,1.3,9)
	;;=^
	;;^DD(115.01,1.3,21,0)
	;;=3^^3^3^2950613^^^
	;;^DD(115.01,1.3,21,1,0)
	;;=This field is actually a pointer to the current Tubefeeding Order
	;;^DD(115.01,1.3,21,2,0)
	;;=stored in Field 40. If null, no current tubefeeding order
	;;^DD(115.01,1.3,21,3,0)
	;;=exists.
	;;^DD(115.01,1.3,"DT")
	;;=2850718
	;;^DD(115.01,2.1,0)
	;;=CURRENT SERVICE^SI^C:CAFETERIA;T:TRAY;D:DINING ROOM;^0;5^Q
	;;^DD(115.01,2.1,21,0)
	;;=^^3^3^2920512^^^^
