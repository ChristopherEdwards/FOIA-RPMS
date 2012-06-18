BQIAGE ;PRXM/HC/ALA - Age Function calls ; 06 Nov 2006  1:23 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
AGE(D0,PDATE,QUAL) ;EP
 ; Description
 ;   This program is copied from the computed AGE field (2,.033) which
 ;   calculates the AGE of a person based on their DOB (date of birth)
 ;   and either the current date (DT) or their DOD (date of death)
 ;   
 ;   It has been modified to use another date passed into this function
 ;   instead of just the previous two dates, DT and DOD.
 ; 
 ; Input
 ;   D0    - Patient IEN
 ;   PDATE - Other date to compare patient's date of birth with
 ;   QUAL  - Include qualifier (YRS, DYS, MOS)
 ;
 ; Assumes variables U,DT
 ;
 S PDATE=$G(PDATE,""),QUAL=$G(QUAL,"")
 Q $$AGE^AUPNPAT(D0,PDATE,QUAL)
 ;
 NEW X,Y,AUX,QFLR
 S QUAL=$G(QUAL,0)
 I 'QUAL D
 . S Y(2,.033,5)=$S($D(^DPT(D0,0)):^(0),1:""),X=$S($G(PDATE)<+$G(^DPT(D0,.35))&$G(PDATE):PDATE,$G(^DPT(D0,.35)):+^(.35),$G(PDATE)'="":PDATE,1:DT)
 . S X=X,Y(2,.033,1)=X
 . S X=1,Y(2,.033,2)=X
 . S X=3,X=$E(Y(2,.033,1),Y(2,.033,2),X),Y(2,.033,3)=X,Y(2,.033,4)=X
 . S X=$P(Y(2,.033,5),U,3),X=X
 . S X=X,Y(2,.033,6)=X
 . S X=1,Y(2,.033,7)=X
 . S X=3,X=$E(Y(2,.033,6),Y(2,.033,7),X)
 . S Y=X,X=Y(2,.033,3),X=X-Y
 . S Y(2,.033,8)=X,Y(2,.033,9)=X,Y(2,.033,10)=X,X=$S($G(PDATE)<+$G(^DPT(D0,.35))&$G(PDATE):PDATE,$G(^DPT(D0,.35)):+^(.35),$G(PDATE)'="":PDATE,1:DT)
 . S X=X,Y(2,.033,11)=X
 . S X=4,Y(2,.033,12)=X
 . S X=7,X=$E(Y(2,.033,11),Y(2,.033,12),X)
 . S Y(2,.033,13)=X,Y(2,.033,14)=X
 . S X=$P(Y(2,.033,5),U,3),X=X
 . S X=X,Y(2,.033,15)=X
 . S X=4,Y(2,.033,16)=X
 . S X=7
 . S X=$E(Y(2,.033,15),Y(2,.033,16),X)
 . S Y=X,X=Y(2,.033,13),X=X<Y,Y=X,X=Y(2,.033,8),X=X-Y
 ;
 ;  if the qualifier flag is set, then the returned value is the same
 ;  as the PRINTED AGE value which includes YRS, DYS, or MOS.
 I QUAL D
 . S X=$$FMDIFF^XLFDT($S($G(PDATE)<+$G(^DPT(D0,.35))&$G(PDATE):PDATE,$G(^DPT(D0,.35)):+^(.35),$G(PDATE)'="":PDATE,1:DT),$P(^DPT(D0,0),U,3))
 . S AUX=X\365.25
 . S QFLR=$S(AUX>2:AUX_" YRS",X<31:X_" DYS",1:X\30_" MOS")
 Q $S(QUAL=1:QFLR,1:X)
