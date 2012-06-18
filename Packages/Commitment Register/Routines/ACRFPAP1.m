ACRFPAP1 ;IHS/OIRM/DSD/THL,AEF - PRINT APPROVALS ON REQUESTS;  [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;;ACRFPAPV CON'T
EN ;EP;
 I ACRCT=40 D
 .W !,"| Telephone calls were made in the interest of the Government.  Traveler"
 .W ?79,"|"
 .W !,"| certifies that use of Government phone system was not practical."
 .W ?79,"|"
 .W !,"| I certify that this Voucher is true and correct to the best of my knowledge"
 .W ?79,"|"
 .W !,"| belief, and that payment or credit has not been received by me."
 .W ?79,"|"
 .W !,"| Per diem claimed is based on the average cost of lodging incurred during"
 .W ?79,"|"
 .W !,"| the period covered by this voucher."
 .W ?79,"|"
 .I $P($G(^ACRDOC(ACRDOCDA,"TOSA")),U,3)="Y" D
 ..W !,"| I certify that the Rental vehicle was used for official business only."
 ..W ?79,"|"
 I ACRCT=45 D
 .W !,"| Travel completed as authorized & directed by supervisor recommending travel. |"
 I ACRCT=37 D
 .W !,"| This voucher is approved.  Long distance calls are certified as necessary    |"
 .W !,"| in the interest of the Government."
 .W ?79,"|"
 Q
CONSOL ;EP;TO DETERMINE IF ITEM FROM REQUISITION CONSOLIDATED ON ANOTHER PO
 N X,Y,Z,ACRX,I
 S X=0
 F  S X=$O(^ACRSS("C",ACRDOCDA,X)) Q:'X  I $D(^ACRSS(X,"PO")),+^("PO")'=ACRDOCDA S (Y,I)=+^("PO") D
 .S Y=$S($P(^ACRDOC(Y,0),U,2)]"":$P(^(0),U,2),1:$P(^(0),U)),Z=$P($G(^AUTTPRG(+$P(^ACRDOC(I,"PO"),U,7)),0),U)
 .S:Z="" Z="NOT STATED"
 .S ACRX(Y,Z)=$G(ACRX(Y,Z))_+^ACRSS(X,0)_","
 .S $P(ACRX(Y,Z),U,2)=I
 .S $P(ACRX(Y,Z),U,3)=$P(^ACRDOC(I,0),U,6)
 Q:'$D(ACRX)
 S ACRDOCXX=ACRDOCDA
 S X=""
 F  S X=$O(ACRX(X)) Q:X=""  D
 .S Y=""
 .F  S Y=$O(ACRX(X,Y)) Q:Y=""  D
 ..S Z=$P(ACRX(X,Y),U)
 ..S Z=$E(Z,1,$L(Z)-1)
 ..W !!,"ITEM",$S($L(Z,",")>1:"(S): ",1:": "),Z," FROM THIS REQUEST"
 ..W !,$S($L(Z,",")>1:"HAVE",1:"HAS")," BEEN CONSOLIDATED TO THE FOLLOWING PURCHASE ORDER:"
 ..W !,"--------------------------------------------------------------------------------"
 ..W !,"DEPT ID: ",$P(ACRX(X,Y),U,3)
 ..W ?15,"DOC: (",$P(ACRX(X,Y),U,2),")"
 ..W ?30,X
 ..W ?50,Y
 ..N ACRDOCDA,ACRREFDA,ACRREF,ACRREFX
 ..S ACRDOCDA=$P(ACRX(X,Y),U,2)
 ..S ACRREFDA=$P(^ACRDOC(ACRDOCDA,0),U,13)
 ..S (ACRREF,ACRREFX)=$P(^AUTTDOCR(ACRREFDA,0),U)
 ..N X,Y,Z
 ..D EN^ACRFPAPV
 S ACRDOCDA=ACRDOCXX
 K ACRDOCXX
 Q
TAIL ;EP;TO PRINT FORM TRAILER
 I ACRREFX'=600,ACRREFX'=148 D
 .W !
 .D B1
 .W "------------------------------------------------------------------------------"
 .D B1
 I ACRREFX=103,'$P($G(^ACRDOC(ACRDOCDA,3)),U,13),$E(IOST,1,2)="P-" D
 .W !,"IHS 532 (6/94) Computerized Mod of Optional Form 347 (10/83) (OMB NO. 0990-0115)"
 .W !,"--------------------------------------------------------------------------------"
 I ACRREFX=103,$P($G(^ACRDOC(ACRDOCDA,3)),U,13),$E(IOST,1,2)="P-" D
 .W !,"--------------------------------------------------------------------------------"
 I ACRREFX=116,$E(IOST,1,2)="P-" D
 .W !,"IHS 534 (10/94) Computerized Mod of Purchase/Service/Stock Requisition HHS 393)"
 Q
B1 W $S(ACRREFX'=103:"|",1:"-")
 Q
