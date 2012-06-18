XTFN ;SF-ISC/RWF - MATH FUNCTIONS ;3/14/89  11:05 ;
 ;;7.1;KERNEL;;May 11, 1993
LN ;%LN=LN(%X) (log base e)
 S %T=%X,(%LN,%D)=0 Q:%X'>0
LN2 IF %T'<1 S %T=.5*%T,%D=%D+1 G LN2
LN3 IF %T<.5 S %T=2*%T,%D=%D-1 G LN3
 S %T=(%T-.707107)/(%T+.707107),%LN=%T*%T,%LN=+$J((((.598979*%LN+.961471)*%LN+2.88539)*%T+%D-.5)*.693147,1,6)
 K %D,%T Q
 ;
EXP ;%E=EXP(%X) (e to the %X power)
 S %E=0,%B=1.4427*%X\1+1 Q:%B>90
 S %E=.693147*%B-%X,%A=.00132988-(.000141316*%E),%A=((%A*%E-.00830136)*%E+.0416574)*%E,%E=(((%A-.166665)*%E+.5)*%E-1)*%E+1,%A=2
 IF %B'>0 S %A=.5,%B=-%B
 F %I=1:1:%B S %E=%A*%E
 S %E=+$J(%E,1,6) K %A,%B,%I Q
 ;
PWR ;%P=%X^%Y (uses LN and EXP)
 S %P=$S(%Y=1:%X,1:1) Q:%Y=0!(%Y=1)  S %E=0,%G=%X,%H=%Y
 IF %X<0,%Y\1=%Y S %P=1-(2*%Y)+(4*(%Y/2)\1),%X=-%X
 IF %X D LN S %X=%Y*%LN D EXP
 S %P=%P*%E,%X=%G,%Y=%H IF %Y>1,%X#1+(%Y#1)=0 S %P=$J(%P,1,0) ;INTEGERS
 K %G,%H,%E,%LN Q
LOG ;%L=LOG(%X) (log base 10) uses LN
 N %LN D LN I %LN=0 S %L=0 Q  ;error
 S %L=+$J(%LN/2.302585,1,6) Q
 ;
TAN ;%Y=TAN(%X) ;tan X = sin X/cos X
 D SIN S %TN=%Y D COS S %Y=$J(%TN/%Y,1,6) K %TN Q
SIN ;%Y=SIN(%X), %X in radians
 S %T=%X G C
COS ;%Y=COS(%X), %X in radians
 S %T=%X+1.5707963
C IF %T<-1.5707963 S %T=-3.14159265-%T
 IF %T>3.14159265 S %T=%T-6.2831853 G C
 S %T2=%T,%Y=%T,%T4=1,%T3=-1
 F %=3:2:11 S %T4=%T4*(%-1)*%,%T2=%T2*%T*%T,%Y=%T2/%T4*%T3+%Y,%T3=-%T3
 S %Y=+$J(%Y,1,6) K %,%T,%T2,%T3,%T4 Q
 ;
DTR ;DEGREES TO RADIANS
 S %X=$J(%X/57.29577951,1,7) Q
RTD ;RADIANS TO DEGREES
 S %X=$J(%X*57.29577951,1,5) Q
PI S %X=3.1415927 Q  ;%X=PIE
 ;
SQRT ;%Y=SQRT(%X)
 S %Y=0 Q:%X'>0  S %Y=%X+1/2
L S %T=%Y,%Y=%X/%T+%T/2 G L:%Y<%T
 Q
SD ;SX=SUM, SSX=SUM OF SQUARES, N=COUNT
 S SD=-1,%X=-1 Q:N<2
 S %X=N*SSX-(SX*SX)/(N*(N-1)) D SQRT S SD=%Y,%X=SX/N Q
