IBCF23	;ALB/ARH - HCFA 1500 19-90 DATA (block 24, procs and charges) ; 12-JUN-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;requires IBIFN, IB(0), IB("U"), IB("U1"), returns number of line items in IBFLD(24)
	;revenue code array: IBRC("procedure^division^basc flag^bedsection^rev code^charge")=units
	;procedure array:    IBCP(initial print order)=proc date^procedure^division^basc flag^dx^pos^tos^charge
	;procedure array:    IBSS("procedure^division^basc flag^dx^pos^tos^charge")=lowest inital print order
	;print order array:  IBPO(final print order, initial print order)=""
	;print array:        IBFLD(24,I)=begin date^end date^pos^tos^procedure^dx^charge^units
	;
	;NOTE (12/1/93): DX IS NO LONGER STORED IN THE 7TH PIESE SO IT IS NO LONGER BEING USED FOR MATCHING THE CPT'S
	;THIS MEANS THAT CPT'S MAY BE MATCHED EVEN IF THEY HAVE DIFFERENT ASSOC DX'S
	;ALSO NOTICE THAT THE DX IN THE IBFLD ARRAY SHOULD REFER TO THE EXTERNAL REFERENCE NUMBER OF EACH OF THE 4 POSSIBLE ASSOCIATED DX'S
	;AND THAT THE DX IN THE OTHER ARRAYS STILL APPLIES TO THE OLD DX, PIECE 7
	;
	;THIS PROCEDURE NEEDS TO BE UPDATED FOR THE NEW CPT DX'S
	;
RVC	; charges array
	S IBI=0 F  S IBI=$O(^DGCR(399,IBIFN,"RC",IBI)) Q:'IBI  S IBLN=^(IBI,0) D
	. S IBSS="" F IBJ=6,7,0,5,1,2 S IBSS=IBSS_$P(IBLN,U,IBJ)_"^"
	. I +IBSS S $P(IBSS,U,1)=$P(IBSS,U,1)_";ICPT("
	. S $P(IBSS,U,3)=$S($D(^DGCR(399,"ASC1",+$P(IBLN,U,6),IBIFN,IBI)):1,1:"")
	. S IBRC(IBSS)=+$G(IBRC(IBSS))+$P(IBLN,U,3)
	;
PRC	; procedure array with charge
	S IBI=0 F  S IBI=$O(^DGCR(399,IBIFN,"CP",IBI)) Q:'IBI  S IBLN=^(IBI,0) D
	. S IBPO=$S(+$P(IBLN,U,4):$P(IBLN,U,4),1:IBI+1000),IBSS="",IBPDT=$P(IBLN,U,2)
	. F IBJ=1,6,5,0,9,10 S IBSS=IBSS_$P(IBLN,U,IBJ)_"^"
	. F IBJ=11:1:14 I $P(IBLN,U,IBJ) S $P(IBSS,U,4)=$P(IBSS,U,4)_$S(IBJ>11:",",1:"")_$G(IBDXI(+$P(IBLN,U,IBJ)))
	. ; charges - find charge associated with procedure, if any (match proc,div,basc)
	. S IBCHARG="",IBRV=$P(IBSS,U,1,3),IBRV=$O(IBRC(IBRV)) I $P(IBRV,U,1,3)=$P(IBSS,U,1,3),+IBRC(IBRV) D
	.. S IBCHARG=$P(IBRV,U,6),IBRC(IBRV)=IBRC(IBRV)-1
	. ; charges - find charge associated with procedure, if any (match proc,div)
	. I IBCHARG="" S IBRV=$P(IBSS,U,1,2),IBRV=$O(IBRC(IBRV)) I $P(IBRV,U,1,2)=$P(IBSS,U,1,2),+IBRC(IBRV) D
	.. S IBCHARG=$P(IBRV,U,6),IBRC(IBRV)=IBRC(IBRV)-1
	. S IBSS=IBSS_IBCHARG,IBCP(IBPO)=IBPDT_"^"_IBSS
	;
	;add charges not associated with a procedure to the first procedure with no charge
	S IBPO="" F  S IBPO=$O(IBCP(IBPO)) Q:'IBPO  I '$P(IBCP(IBPO),U,8) D
	. S IBCHARG="",IBRV="^^^" F  S IBRV=$O(IBRC(IBRV)) Q:IBRV=""  I +IBRC(IBRV) D  Q
	.. S IBCHARG=$P(IBRV,U,6),IBRC(IBRV)=IBRC(IBRV)-1
	. I +IBCHARG S IBCP(IBPO)=IBCP(IBPO)_IBCHARG
	;
PO	; print order array w/ charges
	;attempt to combine multiple entries of same procedure onto on line item via print order
	;if both have print orders defined then they should not be combined onto one line item
	;"procedure^division^basc^dx^pos^tos^charge" must all be the same
	S IBPO="" F  S IBPO=$O(IBCP(IBPO)) Q:'IBPO  S IBCP=IBCP(IBPO),IBSS=$P(IBCP,U,2,999) D
	. I $D(IBSS(IBSS)) S IBPO1=IBSS(IBSS),IBPO(IBPO1,IBPO)="" Q
	. S IBSS(IBSS)=IBPO,IBPO(IBPO,IBPO)=""
	;
PRTARR	;print procedure array
	S IBREV="",IBPO1="",IBI=0 F  S IBPO1=$O(IBPO(IBPO1)) Q:IBPO1=""  D  I +IBUNIT D B24
	. S IBDT1=99999999,IBDT2="",IBUNIT=0,IBCHARG=""
	. S IBPO2="" F  S IBPO2=$O(IBPO(IBPO1,IBPO2)) Q:IBPO2=""  D
	.. S IBUNIT=IBUNIT+1,IBSS=IBCP(IBPO2),IBCHARG=$P(IBSS,U,8)
	.. S:IBDT1>+IBSS IBDT1=+IBSS S:IBDT2<+IBSS IBDT2=+IBSS
	;
	;print any charges not associated with a procedure (ie. not enough procedures or procedure not in "CP" level)
	S IBRV="" F  S IBRV=$O(IBRC(IBRV)) Q:IBRV=""  I +IBRC(IBRV) D  D B24
	. S IBUNIT=+IBRC(IBRV),IBCHARG=$P(IBRV,U,6),IBDT1=+IB("U"),IBDT2=$P(IB("U"),U,2),IBREV=$P(IBRV,U,5)
	. S IBSS="^"_$S(+IBRV:$P(IBRV,U,1),1:$P($G(^DGCR(399.1,+$P(IBRV,U,4),0)),U,1))
	;
OFFSET	;add offset to print array
	I +$P(IB("U1"),U,2) D
	. S IBI=IBI+1,$P(IBFLD(24,IBI),U,5)=$P(IB("U1"),U,3),$P(IBFLD(24,IBI),U,7)=-$P(IB("U1"),U,2)
	;
	S IBFLD(24)=IBI ;count of line items
	;
	K IBRC,IBCP,IBSS,IBPO,IBPO1,IBPO2,IBLN,IBRV,IBPDT,IBDT1,IBDT2,IBCHARG,IBUNIT,IBREV
	Q
	;
B24	; set individual enrties in print array, external format
	N IBX S IBI=IBI+1,IBPROC=$P(IBSS,U,2)
	S IBFLD(24,IBI)=$$DATE(IBDT1)_"^"_$S(IBDT1=IBDT2:"",1:$$DATE(IBDT2))
	S IBFLD(24,IBI)=IBFLD(24,IBI)_"^"_$P($G(^IBE(353.1,+$P(IBSS,U,6),0)),U,1)_"^"_$P($G(^IBE(353.2,+$P(IBSS,U,7),0)),U,1)
	I +IBPROC S IBFLD(24,IBI)=IBFLD(24,IBI)_"^"_$P($G(@("^"_$P(IBPROC,";",2)_+IBPROC_",0)")),U,1)
	I 'IBPROC S IBFLD(24,IBI)=IBFLD(24,IBI)_"^"_IBPROC,IBFLD(24,IBI_"A")=$P($G(^DGCR(399.2,+IBREV,0)),U,2)
	S IBFLD(24,IBI)=IBFLD(24,IBI)_"^"_$P(IBSS,U,5)_"^"_IBCHARG_"^"_IBUNIT
	K IBPROC
	Q
DATE(X)	;
	Q ($E(X,4,5)_" "_$E(X,6,7)_" "_$E(X,2,3))
