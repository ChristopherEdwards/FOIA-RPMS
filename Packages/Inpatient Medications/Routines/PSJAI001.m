PSJAI001 ; ; 20-MAR-1996
 ;;4.5;Inpatient Medications;**27**;OCT 07, 1994
 Q:'DIFQ(59.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(59.5,0,"GL")
 ;;=^PS(59.5,
 ;;^DIC("B","IV ROOM",59.5)
 ;;=
 ;;^DIC(59.5,"%D",0)
 ;;=^^2^2^2940714^^^^
 ;;^DIC(59.5,"%D",1,0)
 ;;=This file is the location of the IV ROOM site parameters.
 ;;^DIC(59.5,"%D",2,0)
 ;;= 
 ;;^DD(59.5,0)
 ;;=FIELD^^.02^32
 ;;^DD(59.5,0,"DDA")
 ;;=N
 ;;^DD(59.5,0,"DT")
 ;;=2960319
 ;;^DD(59.5,0,"IX","B",59.5,.01)
 ;;=
 ;;^DD(59.5,0,"NM","IV ROOM")
 ;;=
 ;;^DD(59.5,0,"PT",50.8,.01)
 ;;=
 ;;^DD(59.5,0,"PT",53.1,62)
 ;;=
 ;;^DD(59.5,0,"PT",55.01,.22)
 ;;=
 ;;^DD(59.5,.01,0)
 ;;=NAME^RF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<1)!'(X'?1P.E)!(X'?.ANP) X
 ;;^DD(59.5,.01,1,0)
 ;;=^.1
 ;;^DD(59.5,.01,1,1,0)
 ;;=59.5^B
 ;;^DD(59.5,.01,1,1,1)
 ;;=S ^PS(59.5,"B",$E(X,1,30),DA)=""
 ;;^DD(59.5,.01,1,1,2)
 ;;=K ^PS(59.5,"B",$E(X,1,30),DA)
 ;;^DD(59.5,.01,3)
 ;;=Answer must be 1-30 characters in length, identifying an IV distribution area.  Each satellite (area) must be named separately.
 ;;^DD(59.5,.01,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,.01,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,.01,21,0)
 ;;=^^2^2^2920518^^^^
 ;;^DD(59.5,.01,21,1,0)
 ;;=Each IV order belongs to the IV room that input the order.  An IV room
 ;;^DD(59.5,.01,21,2,0)
 ;;=may process ONLY those orders that belong to that IV room.
 ;;^DD(59.5,.01,"DEL",1,0)
 ;;=I 1 W *7,!,"IV ROOMS CANNOT BE DELETED!!"
 ;;^DD(59.5,.01,"DT")
 ;;=2860730
 ;;^DD(59.5,.02,0)
 ;;=DIVISION^P40.8'^DG(40.8,^0;4^Q
 ;;^DD(59.5,.02,.1)
 ;;=
 ;;^DD(59.5,.02,3)
 ;;=Enter the Medical Center Division where this IV Room is located.
 ;;^DD(59.5,.02,21,0)
 ;;=^^2^2^2960319^^^
 ;;^DD(59.5,.02,21,1,0)
 ;;=This field contains the pointer to the MEDICAL CENTER DIVISION file (#40.8).
 ;;^DD(59.5,.02,21,2,0)
 ;;=The division should be the one where the IV Room is located.
 ;;^DD(59.5,.02,23,0)
 ;;=^^2^2^2960319^^
 ;;^DD(59.5,.02,23,1,0)
 ;;=This field is populated by an option on the DSS menu.  It is solely for use
 ;;^DD(59.5,.02,23,2,0)
 ;;=by the DSS software and has no impact on Pharmacy at this time.
 ;;^DD(59.5,.02,"DT")
 ;;=2960319
 ;;^DD(59.5,.101,0)
 ;;=LENGTH OF LABEL^RNJ2,0^^1;1^K:+X'=X!(X>66)!(X<12)!(X?.E1"."1N.N) X
 ;;^DD(59.5,.101,3)
 ;;=Type a whole number between 12 and 66.
 ;;^DD(59.5,.101,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,.101,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,.101,21,0)
 ;;=^^9^9^2860403^^^^
 ;;^DD(59.5,.101,21,1,0)
 ;;=The labels that you use may vary in height from 12 to 66 lines.
 ;;^DD(59.5,.101,21,2,0)
 ;;=Measure the height of your label and multiply that height by the
 ;;^DD(59.5,.101,21,3,0)
 ;;=number of lines per inch that your printer is configured for.
 ;;^DD(59.5,.101,21,4,0)
 ;;=NOTE: If all lines of print cannot fit within the length that
 ;;^DD(59.5,.101,21,5,0)
 ;;=      is defined here, they will continue to the next label.
 ;;^DD(59.5,.101,21,6,0)
 ;;=EXAMPLE:
 ;;^DD(59.5,.101,21,7,0)
 ;;=    The average piggyback label is 3 inches high.  If you print
 ;;^DD(59.5,.101,21,8,0)
 ;;=    6 lines per inch, you should enter an '18' as the answer to
 ;;^DD(59.5,.101,21,9,0)
 ;;=    this parameter.
 ;;^DD(59.5,.101,"DT")
 ;;=2860302
 ;;^DD(59.5,.102,0)
 ;;=USE SUSPENSE FUNCTIONS^S^0:NO;1:YES;^1;2^Q
 ;;^DD(59.5,.102,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,.102,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,.102,21,0)
 ;;=^^3^3^2860403^^^^
 ;;^DD(59.5,.102,21,1,0)
 ;;=If you want the 'SUSPEND LABELS' as a valid choice at the 'ACTION:'
 ;;^DD(59.5,.102,21,2,0)
 ;;=prompt after order entry, answer '1'.  If you do not want any labels
 ;;^DD(59.5,.102,21,3,0)
 ;;=suspended after order entry, but rather have them printed, answer '0'.
 ;;^DD(59.5,.102,"DT")
 ;;=2860212
 ;;^DD(59.5,.103,0)
 ;;=DOSE DUE LINE^S^0:NO DOSE DUE LINE;1:IVPB'S ONLY;2:LVP'S ONLY;3:BOTH IVPB'S AND LVP'S;^1;3^Q
 ;;^DD(59.5,.103,3)
 ;;=
 ;;^DD(59.5,.103,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,.103,20,1,0)
 ;;=PSJI
 ;;^DD(59.5,.103,21,0)
 ;;=^^5^5^2860221^^^^
 ;;^DD(59.5,.103,21,1,0)
 ;;=This parameter affects the printing of the dose due line on the IV LABEL.
 ;;^DD(59.5,.103,21,2,0)
 ;;=If a '0' is entered, the time the dose is due will not be printed on the
 ;;^DD(59.5,.103,21,3,0)
 ;;=IV LABEL at all.  The dose due line will be printed on: IVPB's only if
 ;;^DD(59.5,.103,21,4,0)
 ;;=you select '1', LVP's if you select '2', and both IVPB's and LVP's if you
 ;;^DD(59.5,.103,21,5,0)
 ;;=choose '3'.  NOTE: LVP's include HYPERAL type orders.
 ;;^DD(59.5,.103,"DT")
 ;;=2860212
 ;;^DD(59.5,.104,0)
 ;;=LVP'S GOOD FOR HOW MANY DAYS^NJ5,2^^1;4^K:+X'=X!(X>31)!(X<1)!(X?.E1"."3N.N) X
 ;;^DD(59.5,.104,3)
 ;;=Type a Number between 1 and 31, 2 Decimal Digits
 ;;^DD(59.5,.104,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.5,.104,20,1,0)
 ;;=PSJI
