BGPMUUT6 ;IHS/MSC/MGH - Find is med is active on date ;02-Mar-2011 16:47;DU
 ;;11.0;IHS CLINICAL REPORTING;**4**;JAN 06, 2011;Build 84
 Q
FIND(DFN,TAX,BDATE,MEDTYPE,EDATE) ; EP
 ;This function is designed to see if the patient has any INPT ONLY
 ;in the given taxonomy that were active on the date(s) in question
 ;
 N BGPYR,BGPIND,BGPINDIC,BGPNODE,BGPRX,BGPTYPE,BGPIDX,BGPMED,BGPEND,FOUND
 K ^TMP("PS",$J)
 ;Start by getting the patients drugs from admit to discharge
 D OCL^PSOORRL(DFN,BDATE,EDATE)
 S BGPIND=0,BGPINDIC="",FOUND=0
 F  S BGPIND=$O(^TMP("PS",$J,BGPIND))  Q:'+BGPIND!(+FOUND)  D
 .S BGPNODE=$G(^TMP("PS",$J,BGPIND,0))
 .S BGPRX=+($P(BGPNODE,U,1))
 .Q:$L($P(BGPNODE,U,2))=0   ;Discard Blank Meds
 .;Only use the type of meds chosen (OP,UD,IV)
 .S BGPTYPE=$P($P(BGPNODE,U),";",2)
 .S BGPTYPE=$S(BGPTYPE="O":"OP",BGPTYPE="I":"UD",1:"")
 .I $O(^TMP("PS",$J,BGPIND,"A",0))>0 S BGPTYPE="IV"
 .E  I $O(^TMP("PS",$J,BGPIND,"B",0))>0 S BGPTYPE="IV"
 .I BGPTYPE=MEDTYPE!(MEDTYPE="ALL") D
 ..S BGPMED=$P(BGPNODE,U,2)
 ..N IDX,ID
 ..S ID=$P(BGPNODE,U),IDX=+ID,ID=$E(ID,$L(IDX)+1,$L(ID))
 ..;Check date on unit dose
 ..I ID="U;I" S FOUND=$$INPAT(DFN,IDX,ID,BDATE,EDATE,TAX) Q:+FOUND
 ..;Check dates on IVs
 ..I ID="V;I" S FOUND=$$IV(DFN,IDX,ID,BDATE,EDATE,TAX) Q:+FOUND
 Q FOUND
INPAT(DFN,IDX,ID,BDATE,BGPEND,TAX) ;EP
 N RESULT,NODE,NODE2,DISP,NDC,X
 S RESULT=0
 S NODE=$G(^PS(55,DFN,5,IDX,0))
 S NODE2=$G(^PS(55,DFN,5,IDX,2))
 I $P($P(NODE2,U,2),".",1)=BDATE!($P(NODE2,U,2)<BDATE) D      ;Med started
 .I ($P($P(NODE2,U,4),".",1)=$P(BGPEND,".",1))!($P(NODE2,U,4)>BGPEND) D
 ..;Med was active in range suggested
 ..;Now find the dispense drug(s) and see if they are in the taxonomy
 ..S X=0 F  S X=$O(^PS(55,DFN,5,IDX,1,X)) Q:'+X!(+RESULT)  D
 ...S DISP=$G(^PS(55,DFN,5,IDX,1,X,0))
 ...S DRUG=$P(DISP,U,1)
 ...S RESULT=$$NDC^BGPMUUT4(DRUG,TAX)
 Q RESULT
 Q
IV(DFN,IDX,ID,BDATE,BGPEND,TAX) ;EP
 N RESULT,NODE,ADD,SOL,DRUG,GDRUG
 S RESULT=0
 S NODE=$G(^PS(55,DFN,"IV",IDX,0))
 I ($P($P(NODE,U,2),".",1)=BDATE)!($P(NODE,U,2)<BDATE) D     ;Med started
 .I ($P($P(NODE,U,3),".",1)=$P(BGPEND,".",1))!($P(NODE,U,3)>BGPEND) D
 ..;Med was active, now find the dispense drug and see if in taxonomy
 ..S ADD=0 F  S ADD=$O(^PS(55,DFN,"IV",IDX,"AD",ADD)) Q:ADD=""!(+RESULT)  D
 ...S DRUG=$P($G(^PS(55,DFN,"IV",IDX,"AD",ADD,0)),U,1)
 ...I +DRUG S GDRUG=$P($G(^PS(52.6,DRUG,0)),U,2)
 ...S RESULT=$$NDC^BGPMUUT4(GDRUG,TAX)
 ..I '+RESULT D
 ...S SOL=0 F  S SOL=$O(^PS(55,DFN,"IV",IDX,"SOL",SOL)) Q:SOL=""!(+RESULT)  D
 ....S DRUG=$P($G(^PS(55,DFN,"IV",IDX,"SOL",SOL,0)),U,1)
 ....I +DRUG S GDRUG=$P($G(^PS(52.7,DRUG,0)),U,2)
 ....S RESULT=$$NDC^BGPMUUT4(GDRUG,TAX)
 Q RESULT
