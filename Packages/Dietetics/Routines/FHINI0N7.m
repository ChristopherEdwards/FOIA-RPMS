FHINI0N7	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"BUL",32,0)
	;;=FHDIREQ^Dietetic Consultation Request
	;;^UTILITY(U,$J,"BUL",32,1,0)
	;;=^^3^3^2920323^^^^
	;;^UTILITY(U,$J,"BUL",32,1,1,0)
	;;=You have a |1| request.
	;;^UTILITY(U,$J,"BUL",32,1,2,0)
	;;=Patient is |3| on ward |4|, room |2|.
	;;^UTILITY(U,$J,"BUL",32,1,3,0)
	;;=|5|
	;;^UTILITY(U,$J,"BUL",32,3,0)
	;;=^^2^2^2920323^^^^
	;;^UTILITY(U,$J,"BUL",32,3,1,0)
	;;=Bulletin Ward Clinician when consult is entered on a
	;;^UTILITY(U,$J,"BUL",32,3,2,0)
	;;=patient on a ward for which the clinician is responsible.
	;;^UTILITY(U,$J,"BUL",32,4,0)
	;;=^3.64A^2^5
	;;^UTILITY(U,$J,"BUL",32,4,1,0)
	;;=1
	;;^UTILITY(U,$J,"BUL",32,4,1,1,0)
	;;=^^1^1^2850427^^
	;;^UTILITY(U,$J,"BUL",32,4,1,1,1,0)
	;;=Type of consultation requested; from file 119.52
	;;^UTILITY(U,$J,"BUL",32,4,2,0)
	;;=2
	;;^UTILITY(U,$J,"BUL",32,4,2,1,0)
	;;=^^1^1^2920323^^
	;;^UTILITY(U,$J,"BUL",32,4,2,1,1,0)
	;;=Room-Bed
	;;^UTILITY(U,$J,"BUL",32,4,3,0)
	;;=3
	;;^UTILITY(U,$J,"BUL",32,4,3,1,0)
	;;=^^1^1^2850427^^
	;;^UTILITY(U,$J,"BUL",32,4,3,1,1,0)
	;;=Patient name
	;;^UTILITY(U,$J,"BUL",32,4,4,0)
	;;=4
	;;^UTILITY(U,$J,"BUL",32,4,4,1,0)
	;;=^^1^1^2850427^^
	;;^UTILITY(U,$J,"BUL",32,4,4,1,1,0)
	;;=Current ward of patient
	;;^UTILITY(U,$J,"BUL",32,4,5,0)
	;;=5
	;;^UTILITY(U,$J,"BUL",32,4,5,1,0)
	;;=^^1^1^2891226^^^^
	;;^UTILITY(U,$J,"BUL",32,4,5,1,1,0)
	;;=Comment by person ordering
	;;^UTILITY(U,$J,"BUL",33,0)
	;;=FHDIORD^Diet Order
	;;^UTILITY(U,$J,"BUL",33,1,0)
	;;=^^3^3^2940119^^^^
	;;^UTILITY(U,$J,"BUL",33,1,1,0)
	;;=|1| on ward |2|, room |5| has been ordered
	;;^UTILITY(U,$J,"BUL",33,1,2,0)
	;;=|3|
	;;^UTILITY(U,$J,"BUL",33,1,3,0)
	;;=Effective |4|
	;;^UTILITY(U,$J,"BUL",33,3,0)
	;;=^^2^2^2940119^^^^
	;;^UTILITY(U,$J,"BUL",33,3,1,0)
	;;=Bulletin Ward Clinician when 'Bulletinized' Diet Order
	;;^UTILITY(U,$J,"BUL",33,3,2,0)
	;;=is entered.
	;;^UTILITY(U,$J,"BUL",33,4,0)
	;;=^3.64A^5^5
	;;^UTILITY(U,$J,"BUL",33,4,1,0)
	;;=1
	;;^UTILITY(U,$J,"BUL",33,4,1,1,0)
	;;=^^1^1^2940119^^
	;;^UTILITY(U,$J,"BUL",33,4,1,1,1,0)
	;;=Patient name
	;;^UTILITY(U,$J,"BUL",33,4,2,0)
	;;=2
	;;^UTILITY(U,$J,"BUL",33,4,2,1,0)
	;;=^^1^1^2940119^^
	;;^UTILITY(U,$J,"BUL",33,4,2,1,1,0)
	;;=Current ward
	;;^UTILITY(U,$J,"BUL",33,4,3,0)
	;;=3
	;;^UTILITY(U,$J,"BUL",33,4,3,1,0)
	;;=^^1^1^2940119^^
	;;^UTILITY(U,$J,"BUL",33,4,3,1,1,0)
	;;=Diet order
	;;^UTILITY(U,$J,"BUL",33,4,4,0)
	;;=4
	;;^UTILITY(U,$J,"BUL",33,4,4,1,0)
	;;=^^1^1^2940119^^^^
	;;^UTILITY(U,$J,"BUL",33,4,4,1,1,0)
	;;=Effective date of diet order
	;;^UTILITY(U,$J,"BUL",33,4,5,0)
	;;=5
	;;^UTILITY(U,$J,"BUL",33,4,5,1,0)
	;;=^^1^1^2940119^^^^
	;;^UTILITY(U,$J,"BUL",33,4,5,1,1,0)
	;;=Room-Bed
	;;^UTILITY(U,$J,"BUL",34,0)
	;;=FHDITF^Tubefeeding Order
	;;^UTILITY(U,$J,"BUL",34,1,0)
	;;=^^4^4^2930527^^^^
	;;^UTILITY(U,$J,"BUL",34,1,1,0)
	;;=You have a Tubefeeding Order for |1|  ( |2| )
	;;^UTILITY(U,$J,"BUL",34,1,2,0)
	;;=on ward |3|, room |4|
	;;^UTILITY(U,$J,"BUL",34,1,3,0)
	;;= 
	;;^UTILITY(U,$J,"BUL",34,1,4,0)
	;;=|5|
	;;^UTILITY(U,$J,"BUL",34,3,0)
	;;=^^1^1^2930527^^^^
	;;^UTILITY(U,$J,"BUL",34,3,1,0)
	;;=Bulletin to alert Ward Clinician of Tubefeeding Order.
	;;^UTILITY(U,$J,"BUL",34,4,0)
	;;=^3.64A^5^5
	;;^UTILITY(U,$J,"BUL",34,4,1,0)
	;;=1
	;;^UTILITY(U,$J,"BUL",34,4,1,1,0)
	;;=^^1^1^2850908^
	;;^UTILITY(U,$J,"BUL",34,4,1,1,1,0)
	;;=Patient Name
	;;^UTILITY(U,$J,"BUL",34,4,2,0)
	;;=2
	;;^UTILITY(U,$J,"BUL",34,4,2,1,0)
	;;=^^1^1^2850908^
	;;^UTILITY(U,$J,"BUL",34,4,2,1,1,0)
	;;=Last 4 SSN digits
	;;^UTILITY(U,$J,"BUL",34,4,3,0)
	;;=3
	;;^UTILITY(U,$J,"BUL",34,4,3,1,0)
	;;=^^1^1^2850908^^
	;;^UTILITY(U,$J,"BUL",34,4,3,1,1,0)
	;;=Ward Name
	;;^UTILITY(U,$J,"BUL",34,4,4,0)
	;;=4
	;;^UTILITY(U,$J,"BUL",34,4,4,1,0)
	;;=^^1^1^2901219^^
	;;^UTILITY(U,$J,"BUL",34,4,4,1,1,0)
	;;=Room-Bed
	;;^UTILITY(U,$J,"BUL",34,4,5,0)
	;;=5
	;;^UTILITY(U,$J,"BUL",34,4,5,1,0)
	;;=^^1^1^2930527^^^^
	;;^UTILITY(U,$J,"BUL",34,4,5,1,1,0)
	;;=Comment indicating whether tray order and SF were cancelled.
	;;^UTILITY(U,$J,"BUL",69,0)
	;;=FHDIOO^Additional Order
	;;^UTILITY(U,$J,"BUL",69,1,0)
	;;=^^5^5^2920323^^^^
	;;^UTILITY(U,$J,"BUL",69,1,1,0)
	;;=|6|  Additional Order: |1|
	;;^UTILITY(U,$J,"BUL",69,1,2,0)
	;;= 
	;;^UTILITY(U,$J,"BUL",69,1,3,0)
	;;=                   |3|, |4|, |2|
	;;^UTILITY(U,$J,"BUL",69,1,4,0)
	;;= 
	;;^UTILITY(U,$J,"BUL",69,1,5,0)
	;;=Comment: |5|
	;;^UTILITY(U,$J,"BUL",69,3,0)
	;;=^^1^1^2920323^^^
	;;^UTILITY(U,$J,"BUL",69,3,1,0)
	;;=Bulletin to alert Ward Clinician of Additional Order.
	;;^UTILITY(U,$J,"BUL",69,4,0)
	;;=^3.64A^6^1
	;;^UTILITY(U,$J,"BUL",69,4,6,0)
	;;=6
	;;^UTILITY(U,$J,"BUL",69,4,6,1,0)
	;;=^^1^1^2920323^^^
	;;^UTILITY(U,$J,"BUL",69,4,6,1,1,0)
	;;=Comment to indicate approval or disapproval for the Additional Order.
