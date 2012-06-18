BDGIPL31 ; IHS/ANMC/LJF - CALCULATE LIST BY WARD/ROOM ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 NEW DGWST
 K ^TMP("BDGIPL1",$J)
 S DGWST=$P(BDGSRT,U)
 ;
 ; do all wards or just one
 D AWD:'DGWST,OWD:DGWST
 ;
 ; pending surgery patients that have not been released from OR yet
 I $O(^SRF("AC",DT-.0001))[DT D PEND
 ;
 Q  ;return to INIT^BDGIPL3
 ;
AWD ; -- all wards
 NEW WD,WARD,DFN
 ; loop thru room file to set up ward/room/bed array
 S WD=0 F  S WD=$O(^DG(405.4,"W",WD)) Q:'WD  D
 . I $$ACTWD^BDGPAR(WD) D ROOMS(WD)
 ;
 ; loop thru inpatients
 S WARD="" F  S WARD=$O(^DPT("CN",WARD)) Q:WARD=""  D
 . S DFN=0 F  S DFN=$O(^DPT("CN",WARD,DFN)) Q:'DFN  D PAT
 Q
 ;
OWD ; -- one ward
 NEW WD,WARD,DFN
 S WD=DGWST D ROOMS(WD)
 S WARD=$$GET1^DIQ(42,WD,.01)
 S DFN=0 F  S DFN=$O(^DPT("CN",WARD,DFN)) Q:'DFN  D PAT
 Q
 ;
ROOMS(WD) ; loop thru rooms in a ward
 NEW RB,WARD,RMBD,ORDER
 S RB=0 F  S RB=$O(^DG(405.4,"W",WD,RB)) Q:'RB  D:'$$OOSB(RB)
 . S WARD=$$GET1^DIQ(42,WD,.01),ORDER=$$GET1^DIQ(42,WD,400)
 . S RMBD=$$GET1^DIQ(405.4,RB,.01)  ;names
 . Q:'$$MULTUSE(WARD,+RB)
 . S ^TMP("BDGIPL1",$J,"BED",ORDER,WARD,RMBD)=""
 Q
 ;
PAT ; set inpatients into array by ward/room
 NEW RM
 S RM=$G(^DPT(DFN,.1))_";"_$G(^DPT(DFN,.101))
 ;
 ;--no room-bed
 I $P(RM,";",2)="" D  Q
 . S ^TMP("BDGIPL1",$J,"PAT",RM,DFN)=DFN
 ;
 ;--with room-bed
 S ^TMP("BDGIPL1",$J,"PAT",RM)=DFN
 Q
 ;
 ;
OOSB(Y) ; -- bed out of service
 Q:'$D(^DG(405.4,Y,"I","AINV")) 0
 N X S X=$G(^DG(405.4,Y,"I",+$O(^($O(^("AINV",0)),0)),0)) Q:'X 0
 Q $S($P(X,U,4)=DT:0,$P(X,U,4)&($P(X,U,4)<DT):0,X=DT:0,X<DT:1,1:0)
 ;
INACT(Y) ; -- ward inactive?
 Q '$$ACTWD^BDGPAR(Y)
 ;
MULTUSE(W,R) ; -- don't print if room-bed used by other wards
 ;
 ; is there more than one entry in ward multiple, if no quit 1
 I '$O(^DG(405.4,R,"W",+$O(^DG(405.4,R,"W",0)))) Q 1
 ;
 ; is the room currently occupied?  if no, quit 0
 NEW X S X=$O(^DPT("RM",$P(^DG(405.4,R,0),U),0)) I 'X Q 0
 ;
 ; is this patient in this ward? if no, quit 0
 I '$D(^DPT("CN",W,X)) Q 0
 ;
 ;quit yes because this multi-use room is occupied by pt. on this ward
 Q 1
 ;
PEND ;EP; -- pending SDA/DSO/DSU patients for ward
 NEW SDT,END,IEN,SRV,X,WARD,STAT,AGE,DFN
 S SDT=DT-.0001,END=DT+.2400
 F  S SDT=$O(^SRF("AC",SDT)) Q:'SDT!(SDT>END)  D
 . S IEN=0 F  S IEN=$O(^SRF("AC",SDT,IEN)) Q:'IEN  D
 .. ;
 .. ;  only include SDA/SDO/DSU who are scheduled or checked-in
 .. Q:$$GET1^DIQ(130,IEN,17)]""  ;has cancel date
 .. S STAT=$$GET1^DIQ(130,IEN,.011,"I")  ;patient status
 .. I (STAT'="DSO"),(STAT'="DSU"),(STAT'="SDA") Q
 .. S X=$$GET1^DIQ(130,IEN,9999999.06,"I") I (X'="SC"),(X'="CI") Q
 .. ;
 .. ;  only keep those for appropriate ward
 .. S DFN=$$GET1^DIQ(130,IEN,.01,"I"),AGE=$$GET1^DIQ(2,DFN,.033)
 .. S SRV=$$GET1^DIQ(130,IEN,.04,"I")
 .. S WARD=$$GET1^DIQ(137.45,SRV,$S(AGE<15:9999999.03,1:9999999.02),"I")
 .. I SRV,DGWST,WARD Q:WARD'=DGWST  ;surgery not associated with ward
 .. S WARD=$$GET1^DIQ(137.45,SRV,$S(AGE<15:9999999.03,1:9999999.02))_";"
 .. ;
 .. NEW DGRR D ENP^XBDIQ1(130,IEN,".01;.04;.14;10;26","DGRR(","I")
 .. S X="P"_$P(DGRR(10),"@",2)_";"_DFN  ;p+time+dfn
 .. S ^TMP("BDGIPL1",$J,"PAT",WARD,X)=DFN_U_DGRR(.01)_U_STAT_U_DGRR(.04)_U_DGRR(26)_U_DGRR(.14)_U_DGRR(10,"I")
 Q
