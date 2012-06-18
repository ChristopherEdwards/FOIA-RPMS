GMPLIPRE	; SLC/MKB -- Problem List pre-init rtn ;4/13/94  12:15
	;;2.0;Problem List;;Aug 25, 1994
EN	; entry point
	N %,%H,%I,X,Y
	D NOW^%DTC,YX^%DTC S GMPLSTRT=Y ; start time
	Q
