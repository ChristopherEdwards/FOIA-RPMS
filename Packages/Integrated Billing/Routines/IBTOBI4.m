IBTOBI4	;ALB/AAS - CLAIMS TRACKING BILLING INFORMATION PRINT ; 27-OCT-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
CLIN	; -- output clinical information
	N IBOE,DGPM
	Q:$D(IBCTHDR)
	;
	I $P(IBETYP,"^",3)=1 S DGPM=$P(^IBT(356,+IBTRN,0),"^",5) I 'DGPM Q
	I $P(IBETYP,"^",3)=2 S IBOE=$P(^IBT(356,+IBTRN,0),"^",4)
	F IBTAG="DIAG","PROC","PROV" D @IBTAG Q:IBQUIT
	Q
	;
DIAG	; -- print diagnosis information
	I '$G(DGPM),('$G(IBOE)) Q
	Q:$P(IBETYP,"^",3)>2
	I ($Y+9)>IOSL D HDR^IBTOBI Q:IBQUIT
DIAG1	W !,"  Diagnosis Information "
	N IBXY,SDDXY
	I $G(DGPM) D SET^IBTRE3(+IBTRN) W:'$D(IBXY) !?6,"Nothing on File" D:$D(IBXY) LIST^IBTRE3(.IBXY)
	I $G(IBOE) D SET^SDCO4(IBOE) W:'$D(SDDXY) !?6,"Nothing on File" D:$D(SDDXY) LIST^SDCO4(.SDDXY)
	; 
	D:$G(DGPM) DRG
	W:'IBQUIT !?4,$TR($J(" ",IOM-8)," ","-"),!
	Q
	;
PROC	; -- print procedure information
	Q:$P(IBETYP,"^",3)>2
	I ($Y+9)>IOSL D HDR^IBTOBI Q:IBQUIT
PROC1	W !,"  Procedure Information "
	;
	N IBXY,IBCNT S IBCNT=0
	I $G(DGPM) D SET^IBTRE4(+IBTRN) W:'$D(IBXY) !?6,"Nothing on File" D:$D(IBXY) LIST^IBTRE4(.IBXY)
	I '$G(DGPM) D  W:'$D(IBXY) !?6,"Nothing on File" D:$D(IBXY) LIST(.IBXY)
	.S IBDT=$P($P(IBTRND,"^",6),"."),IBI=IBDT-.000001
	.F  S IBI=$O(^SDV("C",DFN,IBI)) Q:'IBI!(IBI>(IBDT+.25))  D
	..S IBCS=0 F  S IBCS=$O(^SDV(IBI,"CS",IBCS)) Q:'IBCS  I $D(^SDV(IBI,"CS",IBCS,"PR")) S IBPR=^("PR") D
	...F IBJ=1:1:5 I $P(IBPR,"^",IBJ) S IBCNT=IBCNT+1,IBXY(IBCNT)=$P(IBPR,"^",IBJ)_"^"_IBI
	W:'IBQUIT !?4,$TR($J(" ",IOM-8)," ","-"),!
	Q
	;
PROV	; -- print provider information
	I '$G(DGPM),('$G(IBOE)) Q
	Q:$P(IBETYP,"^",3)>2
	I ($Y+9)>IOSL D HDR^IBTOBI Q:IBQUIT
PROV1	W !,"  Provider Information "
	N IBXY,SDPRY
	I $G(DGPM) D SET^IBTRE5(+IBTRN) W:'$D(IBXY) !?6,"Nothing on File" D:$D(IBXY) LIST^IBTRE5(.IBXY)
	I $G(IBOE) D SET^SDCO3(IBOE) W:'$D(SDPRY) !?6,"Nothing on File" D:$D(SDPRY) LIST^SDCO3(.SDPRY)
	W:'IBQUIT !?4,$TR($J(" ",IOM-8)," ","-"),!
	Q
	;
LIST(IBXY)	; -- list procedures array
	; Input  -- IBXY     Diagnosis Array Subscripted by a Number
	; Output -- List Diagnosis Array
	N I,IBXD
	W !
	S I=0 F  S I=$O(IBXY(I)) Q:'I  S IBXD=$G(^ICPT(+IBXY(I),0)) D
	.W !?2,I,"  ",$P(IBXD,"^"),?15,$E($P(IBXD,"^",2),1,40),?60,$$DAT1^IBOUTL($P(IBXY(I),"^",2),"2P")
	Q
	;
DRG	; -- print drgs.
	I '$G(DGPM) Q
	Q:$P(IBETYP,"^",3)>1
	I ($Y+9)>IOSL D HDR^IBTOBI Q:IBQUIT
DRG1	W !!,"  Associated Interim DRG Information "
	N IBX,IBDTE,IBDRG
	I $G(DGPM) D
	.I '$O(^IBT(356.93,"AMVD",DGPM,0)) W !?6,"Nothing on File" Q
	.S IBDTE=0 F  S IBDTE=$O(^IBT(356.93,"AMVD",DGPM,IBDTE)) Q:'IBDTE  S IBDRG=0 F  S IBDRG=$O(^IBT(356.93,"AMVD",DGPM,IBDTE,IBDRG)) Q:'IBDRG  D
	..S IBX=$G(^IBT(356.93,IBDRG,0)) Q:IBX=""
	..W !?5,$$DAT1^IBOUTL($P(IBX,"^",3)),?16,+IBX," - ",$G(^ICD(+IBX,1,1,0))
	..W !?21," Estimate ALOS: "_$J($P(IBX,"^",4),4,1)
	..W ?45," Days Remaining: "_$J($P(IBX,"^",5),2)
	Q
	;
4	; -- Visit region for prosthetics
	N IBDA,IBRMPR S IBDA=$P(IBTRND,"^",9) D PRODATA^IBTUTL1(IBDA)
	S IBD(2,1)="          Item: "_$G(IBRMPR(660,+IBDA,4,"E"))
	S IBD(3,1)="   Description: "_$G(IBRMPR(660,+IBDA,24,"E"))
	S IBD(4,1)="      Quantity: "_$J($G(IBRMPR(660,+IBDA,5,"E")),4)
	S IBD(5,1)="    Total Cost: $"_$G(IBRMPR(660,+IBDA,14,"E"))
	S IBD(6,1)="   Transaction: "_$G(IBRMPR(660,+IBDA,2,"E"))
	S IBD(7,1)="        Vendor: "_$G(IBRMPR(660,+IBDA,7,"E"))
	S IBD(8,1)="        Source: "_$G(IBRMPR(660,+IBDA,12,"E"))
	S IBD(9,1)=" Delivery Date: "_$G(IBRMPR(660,+IBDA,10,"E"))
	S IBD(10,1)="       Remarks: "_$G(IBRMPR(660,+IBDA,16,"E"))
	S IBD(11,1)=" Return Status: "_$G(IBRMPR(660,+IBDA,17,"E"))
	Q
