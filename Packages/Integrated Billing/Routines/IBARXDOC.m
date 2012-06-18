IBARXDOC	;ALB/AAS - INTEGRATED BILLING, PHARMACY COPAY INTERFACE DOCUMENTATION ; 14-FEB-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
XTYPE	; - tag XTYPE - returns array of billable action types for service
	;       input x=service^dfn
	;      output y= 1 if successful, -1^error code in not successful
	;             y(action type,n) = action type^unit cost^service
	;
	;              action type is internal number in file 350.1
	;              n=0 not billable, n=1 billable, n=2 additional data needed
	;
	;
NEW	;
	;  - process new/renew/refill rx for charges
	;  - input  x=service^dfn^action type^user duz
	;  -        x(n)=softlink^units
	;
	;  - output y= 1^sum of total charges of y(n)'s if success, or -1^error code if error
	;           y(n)=IBnumber^total charge this entry^AR bill number
	;
	;
CANCEL	;  - cancel charges for a rx
	;  - input  x   = service^dfn^^user duz
	;           x(n)=IBnumber^Cancellation reason
	;
	;  - output y   = 1 if sucess, -1^error code if error
	;           y(n)= IBnumber^total charge^AR bill number
	;   if y  =  -1^error code then one or more
	;      y(n)'s will =-1^error code
	;
	;
UPDATE	;  - will cancel current open charge and create updated entry
	;  - input x    = service^dfn^action type^user duz
	;          x(n) = softlink^units^IBnumber of parent to cancel^cancellation reason
	;
	;  - output y    = 1 if success, -1^error code if err
	;  -        y(n) = IBnumber^total charge^AR bill number
