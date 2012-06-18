IBCSCH	;ALB/MJB - MCCR HELP ROUTINE  ;03 JUN 88 15:25
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRSCH
	;
	S IBH="" D ^IBCSCU,H^IBCSCU K IBH W !,"Enter '^' to stop the display ",$S(IBV:"",1:"and edit "),"of data,"
	W:'$D(IBPAR) " '^N' to jump to screen #N (see",!,"listing below), <RET> to continue on to the next available screen" I IBV W "." G M
	W " or enter",!,"the field group number(s) you wish to edit using commas and dashes as",!,"delimiters.  Those groups enclosed in brackets ""[]"" are editable while those",!,"enclosed in arrows ""<>"" are not."
M	G:$D(IBPAR) M1 S Z="DATA GROUPS ON SCREEN "_+IBSR W !! X IBWW D @(IBSR1_IBSR) D W D S W ! F I=$Y:1:20 W !
	S Z="PRESS <RETURN> KEY" X IBWW W " to RETURN to SCREEN ",+IBSR R X:DTIME Q
M1	S Z="DATA GROUPS ON PARAMETER SCREEN" W !! X IBWW D @(IBSR1_IBSR) D W W ! F I=$Y:1:20 W !
	S Z="PRESS <RETURN> KEY" X IBWW W " to RETURN to PARAMETER SCREEN" R X:DTIME Q
1	S X="DOB^Alias Name^Sex, Marital Status^Veteran Status, Eligibility^Address, Temporary Address^Patient Short Billing Address^SC at Time of Care" Q
2	S X="Patient Employer Name, Address^Spouse Employer Name, Address" Q
3	S X="Payer Information^Provider Numbers^Mailing Address" Q
4	S X="Admission Information^Discharge Information^Diagnosis Code(s)^Coding Method, Inpt. Pro. Code(s)^Occurrence Code(s)^Condition Code(s)^Value Code(s)" Q
5	S X="Event Date^Outpatient Diagnosis^Outpatient Visits^Coding Method, Opt. Pro. Code(s)^Occurrence Code(s)^Condtion Code(s)" Q
6	S X="Bill/Rate Type, Covered and Non-Covered Days^R.O.I., Assignment of Benefits^Statement Covers Period^Bedsection, Length of Stay^Revenue Code(s), Offset, Total" Q
7	S X="Bill/Rate Type, Covered and Non-Covered Days^R.O.I., Assignment of Benefits^Statement Covers Period^Outpatient Visits^Revenue Code(s), Offset, Total" Q
8	S X="Bill Remark^Form Locator 2^Form Locator 9^Form Locator 27^Form Locator 45^Form Locator 92^Form Locator 93^Tx Auth. Code" Q
28	S X="Bill Remark, Tx Auth. Code, Admitting Diagnosis^Attending Physician Id., Other Physician Id.^Form Locator 2 and 11^Form Locator 31 and 377^Form Locator 56, 57, and 78" Q
H8	S X="Period Unable to Work^Block 31^Tx/Prior Auth. Code" Q
PAR	S X="Fed Tax #, BC/BS #, MAS Svc Pointer^Bill Signer, Billing Supervisor^Security Parameters, Outpatient CPT parameters ^Remarks, Mailgroups^Agent Cashier Address/Phone" Q
S	W !! S Z="AVAILABLE SCREENS" X IBWW
	S X="Demographic^Employment^Payer^Inpatient Event^Outpatient Event^Inpatient Billing - General^Outpatient Billing - General^Billing - Specific"
	S C=0 F I=1:1 S J=$P(X,"^",I) Q:J=""  I '$E(IBVV,I) S C=C+1,Z="^"_I,IBW=(C#2) W:'(C#2) ?41 X IBWW S Z=$S(I?1N:" ",1:" ")_J_" Data" W Z
	Q
W	F I=1:1 S J=$P(X,"^",I) Q:J=""  S Z=I,IBW=(I#2) W:'(I#2) ?42 X IBWW W " "_J
	W:'(I-1)#2 ! Q
	;IBCSCH
