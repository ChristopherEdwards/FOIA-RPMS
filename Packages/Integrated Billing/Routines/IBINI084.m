IBINI084	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.6,.07,0)
	;;=DATA TYPE^S^1:SINGLE VALUE;2:RECORD;3:LIST OF SINGLE VALUES;4:LIST OF RECORDS;5:WORD PROCESSING;^0;7^Q
	;;^DD(357.6,.07,.1)
	;;=WHAT FORMAT WILL THE DATA BE IN?
	;;^DD(357.6,.07,3)
	;;=What format will the data be in?
	;;^DD(357.6,.07,21,0)
	;;=^^8^8^2930527^
	;;^DD(357.6,.07,21,1,0)
	;;=This should only be defined for interfaces that transfer data. It is the
	;;^DD(357.6,.07,21,2,0)
	;;=type of format the data should be in.
	;;^DD(357.6,.07,21,3,0)
	;;= 
	;;^DD(357.6,.07,21,4,0)
	;;=A single value is a string without pieces. A record is a set of strings
	;;^DD(357.6,.07,21,5,0)
	;;=concatenated together with "^" separating the pieces. A list is an
	;;^DD(357.6,.07,21,6,0)
	;;=indefinite number of values, each numbered, each containing the same type
	;;^DD(357.6,.07,21,7,0)
	;;=of information. A word processing data type will be in FM format.
	;;^DD(357.6,.07,21,8,0)
	;;=If the ACTION TYPE is SELECTION ROUTINE then the data type must be record.
	;;^DD(357.6,.07,"DT")
	;;=2930726
	;;^DD(357.6,.08,0)
	;;=PRINT COMPLETE^S^0:NO;1:YES;^0;8^Q
	;;^DD(357.6,.08,3)
	;;=If there is insufficient room on the form to print the data, should it be re-printed in full on a separate page?
	;;^DD(357.6,.08,21,0)
	;;=^^4^4^2930527^
	;;^DD(357.6,.08,21,1,0)
	;;= 
	;;^DD(357.6,.08,21,2,0)
	;;=This field is used to determine what should happen if the data does not
	;;^DD(357.6,.08,21,3,0)
	;;=fit in the space allocated to it on the form. If answered YES the data
	;;^DD(357.6,.08,21,4,0)
	;;=will be printed on another page.
	;;^DD(357.6,.08,"DT")
	;;=2930507
	;;^DD(357.6,.09,0)
	;;=AVAILABLE? (Y/N)^RS^0:NO;1:YES;^0;9^Q
	;;^DD(357.6,.09,3)
	;;=Is this package interface now available for use?
	;;^DD(357.6,.09,21,0)
	;;=^^3^3^2930527^
	;;^DD(357.6,.09,21,1,0)
	;;= 
	;;^DD(357.6,.09,21,2,0)
	;;=This field should be set to YES if the interface is available, NO if it is
	;;^DD(357.6,.09,21,3,0)
	;;=not available. Interfaces that are not available are not called.
	;;^DD(357.6,.09,"DT")
	;;=2921213
	;;^DD(357.6,.1,0)
	;;=HEALTH SUMMARY?^S^0:NO;1:YES;^0;10^Q
	;;^DD(357.6,.1,.1)
	;;=ARE YOU REQUESTING A HEALTH SUMMARY?
	;;^DD(357.6,.1,2.1)
	;;=S:Y=+Y Y=Y+1
	;;^DD(357.6,.1,3)
	;;= Are you requesting a HEALTH SUMMARY to print?
	;;^DD(357.6,.1,21,0)
	;;=^^7^7^2930616^
	;;^DD(357.6,.1,21,1,0)
	;;= 
	;;^DD(357.6,.1,21,2,0)
	;;=This field will determine how to go about printing the report or form. It
	;;^DD(357.6,.1,21,3,0)
	;;=applies only to Package Interfaces of ACTION TYPE = PRINT REPORT. Health
	;;^DD(357.6,.1,21,4,0)
	;;=Summaries use the field HEALTH SUMMARY to determine the type of Health
	;;^DD(357.6,.1,21,5,0)
	;;=Summary to print. The process of printing Health Summaries dos not use the
	;;^DD(357.6,.1,21,6,0)
	;;=fields ENTRY POINT or ROUTINE, since all Health Summaries are printed in
	;;^DD(357.6,.1,21,7,0)
	;;=the same way.
	;;^DD(357.6,.1,"DT")
	;;=2930616
	;;^DD(357.6,.11,0)
	;;=TYPE OF HEALTH SUMMARY^*P142'^GMT(142,^0;11^S DIC("S")="I $P(^(0),U)'=""GMTS HS ADHOC OPTION""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(357.6,.11,3)
	;;=Which Health Summary do you want printed?
	;;^DD(357.6,.11,12)
	;;=EXCLUDES AD HOC HEALTH SUMMARIES
	;;^DD(357.6,.11,12.1)
	;;=S DIC("S")="I $P(^(0),U)'=""GMTS HS ADHOC OPTION"""
	;;^DD(357.6,.11,21,0)
	;;=^^4^4^2940224^
	;;^DD(357.6,.11,21,1,0)
	;;= 
	;;^DD(357.6,.11,21,2,0)
	;;=This identifies the Health Summary that should be printed when this
	;;^DD(357.6,.11,21,3,0)
	;;=Package Interface is invoked. It should be null unless the HEALTH SUMMARY?
