BGOHOS ; IHS/BAO/TMD - Hospital associated with problems  ;14-Aug-2014 10:56;DU
 ;;1.1;BGO COMPONENTS;**13**;Mar 20, 2007;Build 16
 ;---------------------------------------------
HOSP(RET,PROB,VIEN,DEL) ;EP
 ;Add POV to the problem multiple
 N PRIEN,FDA,IEN,ERR,X,VFNEW
 S RET="",VFNEW=0
 Q:PROB=""
 I $P($G(^AUPNVSIT(VIEN,0)),U,7)'="H"&($P($G(^AUPNVSIT(VIEN,0)),U,7)'="O") D  Q
 .S RET="Visit selected is not an inpt visit"
 I $G(DEL)=1 D DELH(.RET,PROB,VIEN) Q
 I $D(^AUPNPROB(PROB,15,"B",VIEN))=0 D
 .S PRIEN="+1,"_PROB_","
 .S FDA(9000011.15,PRIEN,.01)=VIEN
 .D UPDATE^DIE(,"FDA","IEN","ERR")
 .I $D(ERR) S RET=ERR
 .E  S RET=IEN(1)
 Q
 ; Delete a Hospital visit entry
DELH(RET,PROB,VIEN) ;EP
 N IEN,FDA,OKAY,ERR
 I $G(PROB) D
 .Q:'+VIEN
 .S IEN="" S IEN=$O(^AUPNPROB(PROB,15,"B",VIEN,IEN)) Q:'+IEN  D
 ..S FDA(9000011.15,IEN_","_PROB_",",.01)="@"
 ..D UPDATE^DIE("","FDA","OKAY","ERR")
 Q
