IBERSP1	;ALB/ARH - CREATE CHECK-OFF SHEET CPT LIST (CONTINUED) ; 11/5/91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;continuation of COS print function:   creates the preliminary forms that IBERSP then reformats and prints
	;creates partially formated files that can then be reformated to fit any TOF to save time
	;only called if these do not already exist ie. may not be called for every COS print
	;external entry pt.
CREATE	;create linear temp file of CPT's for GRP, array can be reused each time GRP is printed
	N GDATA,DC,LF,CW,PN,GPO,IFN,DATA,NAME,CODE,CD,CHG,CPO,PFN,IC,I,J,X,Y
	Q:'$D(^IBE(350.7,GRP,0))!('$D(^IBE(350.71,"AG",GRP)))
	S GDATA=^IBE(350.7,GRP,0),DC=$P(GDATA,"^",2),LF=$P(GDATA,"^",4),ADT=$S(+ADT:ADT,1:DT)
	S X=$$FORMAT^IBEFUNC2(GRP),IC=$P(X,"^",1),CW=$P(X,"^",2),PN=$P(X,"^",3)
	S ^TMP("IBRSC",$J,GRP,0)=$P(GDATA,"^",1),^TMP("IBRSC",$J,GRP)=$P(GDATA,"^",3)
	S GPO="" F I=1:1 S GPO=$O(^IBE(350.71,"AG",GRP,GPO)) Q:GPO=""  S IFN=+$O(^IBE(350.71,"AG",GRP,GPO,"")) S DATA=$G(^IBE(350.71,IFN,0)) D:DATA'="" C1
	S X="" F Y=1:1:(CW-12) S X=X_"_"
	S X="OTHER PROC: "_X,J=0 D LINE
	Q
	;
C1	;set GROUPs catigories and procedures into temp file
	S NAME=$E($P(DATA,"^",1),1,CW),CPO="",X=$J(NAME,CW/2+($L(NAME)/2)),J=0 D LINE
	F J=1:1 S CPO=$O(^IBE(350.71,"AS",IFN,CPO)) Q:CPO=""  S PFN=+$O(^IBE(350.71,"AS",IFN,CPO,"")) S DATA=$G(^IBE(350.71,PFN,0)) D:DATA'="" C2
	Q
	;
C2	;set each procedure into temp file
	S NAME=$E($P(DATA,"^",1),1,PN),NAME=NAME_$J("",(PN-$L(NAME))),CD=+$P(DATA,"^",6),CODE=$P($G(^ICPT(CD,0)),"^",1),CHG=""
	S:LF=1 X=CODE_"  "_NAME S:LF'=1 X=NAME_"  "_CODE
	I DC S CHG=$$CPTCHG^IBEFUNC1(CD,DIV,ADT),X=X_"  "_$S(CHG="":$J(CHG,8),1:$J(CHG,8,2))
	S X=X_"  (   )" D LINE
	Q
	;
LINE	;saves line in the linear temp file, padded depending on GRP format
	S ^TMP("IBRSC",$J,GRP,I,J)=$J("",IC)_X_$J("",(CW-$L(X)+IC))
	Q
	;
	;external entry pt.
BOX	;create card box and header
	N CTR,IC,HLN,VLN,I,X
	S BOX=12,CTR=(IOM/2),IC=4 S ^TMP("IBRSC",$J,"B")=CTR
	S X=CTR-IC,HLN="" F I=1:1:X S HLN=HLN_"="
	S VLN=$J("",(CTR-2))_"||",HLN=$J("",IC)_HLN_$J("",IC) F I=1:1:BOX S ^TMP("IBRSC",$J,"B",I)=VLN_$J("",IC)
	S ^TMP("IBRSC",$J,"B",I+1)=HLN
	S ^(I)=^TMP("IBRSC",$J,"B",I)_"Date:",^(4)=^TMP("IBRSC",$J,"B",4)_$J("Ambulatory Surgery Check-Off Sheet",(CTR\2)+17)
	Q
