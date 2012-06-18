INHMSR11 ;KN; 28 Nov 95 11:55; Statistical Report - Definition Screen 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME: Statistical Report - Definition Screen Utility
 ;        array (INHMSR11).   
 ; 
 ; DESCRIPTION:
 ; The processing of this routine is used to contain for Utility
 ; INA array and support for the module INHMSR1, INHMSR10. 
 ;
 Q
 ;
GATHER(INA,INCNT) ;Build INA Array.
 ;
 ; Description:  The function GATHER is used to construct 
 ;               INA array of user selected criteria.
 ;    The structure of the INA(Sub1,Sub2) array is as follow:
 ;    o Sub1 = order in which user select.
 ;      . INA(0)=0 user select field .01, no range
 ;      . INA(0)=1 user select field .01, and also set range
 ;      . INA(0)=2 user not select field .01
 ;      . Sub1=I (I = 1-7) user selected order
 ;    o Sub2 = for user selected items such as:
 ;      1 = field ien, 2 = field name, 3,4 = range from and to.
 ;      5 = line where the item is located, 6 = field type(date,number).
 ;      7 = total (yes or no), 8 = Mumps code from computed field
 ; Return: 0 = Error in processing.
 ;         n = no error, return number of selection
 ; Parameters:
 ;    INA = Name of statistical report criteria array.
 ;    INCNT = Number of fields in the current file
 ; Code begins:
 N TSEL,SEL,ERR,INSUB,INFD,IINA,ING
 K INA
 ; TSEL is number of selection, to compare if user enter repeat order
 S TSEL=0,SEL=0,ERR=0,INA(0)=0
 F ING=1:1:INCNT S:$G(DWLTXT(1,ING))'="" TSEL=$G(TSEL)+1
 F ING=1:1:INCNT  D
 .I $G(DWLTXT(1,ING))'=""  D
 ..; Set value in INA array to mark this order has been made
 ..I $D(INA($G(DWLTXT(1,ING)),1))=0  D
 ...; Increment the count and store in INA array
 ...S SEL=$G(SEL)+1,INA($G(DWLTXT(1,ING)))=""
 ...;save field ien, field name, range, and total
 ...S INSUB=$G(DWLTXT(1,ING)),INA(INSUB,1)=IN(6,ING),INA(INSUB,2)=IN(2,ING)
 ...; Get range FROM and TO
 ...S FROM=$G(DWLTXT(3,ING)),TO=$G(DWLTXT(4,ING)),INA(INSUB,5)=ING
 ...; Save field type in INA(1,6)
 ...S INA(INSUB,6)=$$GPC2^INHMSR10(INIEN,IN(6,ING)),INA(INSUB,7)=$G(DWLTXT(5,ING))
 ...; Store computed field i.e. DD piece 5 in ina(insub,8)
 ...; Get piece 5 and 6 to overcome ^ in global ^INTHU
 ...S:INA(INSUB,6)["C" INA(INSUB,8)=$P($G(^DD(INIEN,IN(6,ING),0)),U,5,6)
 ...;make sure FROM < TO before store in INA array, only when both exist
 ...I ($G(FROM)'="")&($G(TO)'="")&(INA(INSUB,6)'["D")  D
 ....; For number and date
 ....I (INA(INSUB,6)["N")  D
 .....I FROM<TO S INA(INSUB,3)=FROM,INA(INSUB,4)=TO
 .....E  S INA(INSUB,3)=TO,INA(INSUB,4)=FROM
 ....E  D
 .....; In this case of string, using operator ] to compare
 .....I TO]FROM S INA(INSUB,3)=FROM,INA(INSUB,4)=TO
 .....E  S INA(INSUB,3)=TO,INA(INSUB,4)=FROM
 ...E  S INA(INSUB,3)=FROM,INA(INSUB,4)=TO
 Q:'$G(SEL) 0
 ; Compare for repeat order
 I $G(SEL)=$G(TSEL) S ERR=$$INACHK^INHMSR10(INIEN,.INA)
 E  D MESS^DWD(5,10) W "Sort order cannot be repeated - Please try again!" S INTMP=$$CR^UTSRD,ERR=1
 ; INA(0)=2 means .01 is not selected 
 S:$G(INA(0))=2 TSEL=$G(TSEL)+1
 I ('ERR)&($G(TSEL)<2) D MESS^DWD(5,10) W "ERROR! - you enter at least one field other than the "_INF1_" field" S INTMP=$$CR^UTSRD,ERR=1
 I ('ERR)&($G(TSEL)>5) D MESS^DWD(5,10) W "ERROR! - Without the "_INF1_" field.  You may only select a maximum at four (4) fields" S INTMP=$$CR^UTSRD,ERR=1
 Q $S(ERR=1:0,1:SEL)
