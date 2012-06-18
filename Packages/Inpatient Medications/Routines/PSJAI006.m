PSJAI006 ; ; 20-MAR-1996
 ;;4.5;Inpatient Medications;**27**;OCT 07, 1994
 Q:'DIFQ(59.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(59.51,.03,"DT")
 ;;=2840613
 ;;^DD(59.51,.04,0)
 ;;=END OF COVERAGE^RFX^^0;4^K:$L(X)>4!($L(X)<4)!'(X?1N.N)!(+X>2400)!(X#100>59) X
 ;;^DD(59.51,.04,3)
 ;;=You must enter 4 numbers for time (i.e., MILITARY TIME)!
 ;;^DD(59.51,.04,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.51,.04,20,1,0)
 ;;=PSJI
 ;;^DD(59.51,.04,21,0)
 ;;=^^6^6^2940714^^^^
 ;;^DD(59.51,.04,21,1,0)
 ;;= 
 ;;^DD(59.51,.04,21,2,0)
 ;;= 
 ;;^DD(59.51,.04,21,3,0)
 ;;=Enter the military time that designates the last administration time
 ;;^DD(59.51,.04,21,4,0)
 ;;=covered by this manufacturing run.  Enter midnight as 2400.
 ;;^DD(59.51,.04,21,5,0)
 ;;= 
 ;;^DD(59.51,.04,21,6,0)
 ;;= 
 ;;^DD(59.51,.04,"DT")
 ;;=2860131
 ;;^DD(59.51,.05,0)
 ;;=MANUFACTURING TIME^FX^^0;5^K:$L(X)>4!($L(X)<4)!'(X?1N.N)!(+X>2400)!(X#100>59) X
 ;;^DD(59.51,.05,3)
 ;;=Enter time as 4 numbers (i.e., '1700' for 5PM)!
 ;;^DD(59.51,.05,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.51,.05,20,1,0)
 ;;=PSJI
 ;;^DD(59.51,.05,21,0)
 ;;=^^4^4^2940714^^^^
 ;;^DD(59.51,.05,21,1,0)
 ;;=Enter the military time that designates the general time when the
 ;;^DD(59.51,.05,21,2,0)
 ;;=manufacturing list will be run and the orders prepared.  This is for
 ;;^DD(59.51,.05,21,3,0)
 ;;=documentation and does not affect IV processing.  Enter midnight as 2400.
 ;;^DD(59.51,.05,21,4,0)
 ;;= 
 ;;^DD(59.51,.05,"DT")
 ;;=2850320
 ;;^DD(59.51,.06,0)
 ;;=DATE/TIME LAST RUN^D^^0;6^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
 ;;^DD(59.51,.06,3)
 ;;=
 ;;^DD(59.51,.06,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.51,.06,20,1,0)
 ;;=PSJI
 ;;^DD(59.51,.06,21,0)
 ;;=^^3^3^2880708^^^^
 ;;^DD(59.51,.06,21,1,0)
 ;;=This date/time signals the end of the 'MANUFACTURING QUEUE'.
 ;;^DD(59.51,.06,21,2,0)
 ;;=Orders due up to and including this date/time will appear in
 ;;^DD(59.51,.06,21,3,0)
 ;;=this 'MANUFACTURING QUEUE' .
 ;;^DD(59.51,.06,"DT")
 ;;=2880708
 ;;^DD(59.52,0)
 ;;=DELIVERY TIME SUB-FIELD^NL^.01^1
 ;;^DD(59.52,0,"IX","AT",59.52,.01)
 ;;=
 ;;^DD(59.52,0,"IX","B",59.52,.01)
 ;;=
 ;;^DD(59.52,0,"NM","DELIVERY TIME")
 ;;=
 ;;^DD(59.52,0,"UP")
 ;;=59.5
 ;;^DD(59.52,.01,0)
 ;;=DELIVERY TIME^MFX^^0;1^K:$L(X)>4!($L(X)<4)!(+X<1)!(+X>2400)!(X#100>59)!(X'?1N.N) X
 ;;^DD(59.52,.01,1,0)
 ;;=^.1
 ;;^DD(59.52,.01,1,1,0)
 ;;=59.52^B
 ;;^DD(59.52,.01,1,1,1)
 ;;=S ^PS(59.5,DA(1),3,"B",$E(X,1,30),DA)=""
 ;;^DD(59.52,.01,1,1,2)
 ;;=K ^PS(59.5,DA(1),3,"B",$E(X,1,30),DA)
 ;;^DD(59.52,.01,1,2,0)
 ;;=59.52^AT^MUMPS
 ;;^DD(59.52,.01,1,2,1)
 ;;=S ^PS(59.5,DA(1),3,"AT",+("."_X),DA)=""
 ;;^DD(59.52,.01,1,2,2)
 ;;=K ^PS(59.5,DA(1),3,"AT",+("."_X),DA)
 ;;^DD(59.52,.01,1,2,"%D",0)
 ;;=^^1^2920901^
 ;;^DD(59.52,.01,1,2,"%D",1,0)
 ;;=Used by Inpatient Package.
 ;;^DD(59.52,.01,3)
 ;;=Answer must be 4 characters in length.
 ;;^DD(59.52,.01,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.52,.01,20,1,0)
 ;;=PSJI
 ;;^DD(59.52,.01,21,0)
 ;;=^^5^5^2940714^^^^
 ;;^DD(59.52,.01,21,1,0)
 ;;= 
 ;;^DD(59.52,.01,21,2,0)
 ;;=Delivery times must be entered using a 24-hour clock (i.e., 9AM is
 ;;^DD(59.52,.01,21,3,0)
 ;;=entered as 0900).  Delivery times are used as default start times
 ;;^DD(59.52,.01,21,4,0)
 ;;=for admixtures and hyperalimentations.  Enter midnight as 2400.
 ;;^DD(59.52,.01,21,5,0)
 ;;= 
 ;;^DD(59.52,.01,"DT")
 ;;=2860724
