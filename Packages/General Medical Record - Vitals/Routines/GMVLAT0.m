GMVLAT0 ;HOIFO/YH,FT-DISPLAY LATEST VITALS/MEASUREMENTS FOR A PATIENT ;4/14/03  13:56
 ;;5.0;GEN. MED. REC. - VITALS;**1**;Oct 31, 2002
 ;
 ; This routine uses the following IAs:
 ; #10104 - ^XLFSTR calls          (supported)
 ;
EN1(DFN) ; ENTRY TO EXTRACT THE LATEST VITALS/MEASUREMENT FOR A PATIENT
 ;CALLED BY GETLAT^GMVGETD
 N GJ,GBLANK,GAPICAL,GRADIAL,GBRACH,GMVUSER
 S GJ=0,GBLANK=""
 S GAPICAL=$O(^GMRD(120.52,"B","APICAL",0)),GRADIAL=$O(^GMRD(120.52,"B","RADIAL",0)),GBRACH=$O(^GMRD(120.52,"B","BRACHIAL",0))
 F X="T","P","R","PO2","BP","HT","WT","CVP","CG","PN" I $D(^GMRD(120.51,"C",X))  S GMR(X)=$O(^GMRD(120.51,"C",X,"")),Y=$P($G(^GMRD(120.51,GMR(X),0)),"^") Q:Y=""
 K GMRDT,GMRVWT,GMRVHT
 S X=""
 F  S X=$O(GMR(X)) Q:X=""  S GMRDATS="" I GMR(X)>0 F GMRDAT=0:0 S GMRDAT=$O(^GMR(120.5,"AA",DFN,+GMR(X),GMRDAT)) Q:$S(GMRDAT'>0:1,GMRDATS>0:1,1:0)  D SETDATAR
 I '($D(GMRDATA)\10) S GJ=GJ+1,^TMP($J,"GRPC",GJ)="There are no results to report " G Q
 F X="T","P","R","PO2","BP","HT","WT","CVP","CG","PN" I $D(GMRDATA(X)) S GMRVDT="",(GMRVDT(1),GMVD)=0 F  S GMVD=$O(GMRDATA(X,GMVD)) Q:GMVD'>0  D WRTDT S GMVD(1)=0 F  S GMVD(1)=$O(GMRDATA(X,GMVD,GMVD(1))) Q:GMVD(1)'>0  D
 . S GMVUSER=$P($G(^GMR(120.5,+GMVD(1),0)),U,6) ;user ien
 . S GMVUSER=$$PERSON^GMVUTL1(GMVUSER) ;user name
 . S GJ=GJ+1,^TMP($J,"GRPC",GJ)="",GMRVX(0)=GMRDATA(X,GMVD,GMVD(1)) S GMRVX=X D EN1^GMVSAS0
  . S:GMRVDT(1)=0 ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_$S(X="BP":"B/P",X="P":"Pulse",X="R":"Resp.",X="T":"Temp.",X="HT":"Ht.",X="CG":"Circ/Girth",X="WT":"Wt.",X="PO2":"Pulse Ox",X="PN":"Pain",1:X)_":"
 . I GMRVDT(1)=0 S GBLANK=$$REPEAT^XLFSTR(" ",13-$L(^TMP($J,"GRPC",GJ))),^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_GBLANK_"("_GMRVDT_") " S GMRVDT(1)=1
 . S GBLANK=$$REPEAT^XLFSTR(" ",31-$L(^TMP($J,"GRPC",GJ))),^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_GBLANK
 . I X="T" S ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_GMRVX(0)_" F  ("_$J(+GMRVX(0)-32*5/9,0,1)_" C)"
 . I X="WT" S ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_GMRVX(0)_" lb  ("_$J(GMRVX(0)/2.2,0,2)_" kg)" S GMRVWT=GMRVX(0)/2.2
 . I X="HT" S ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_$S(GMRVX(0)\12:GMRVX(0)\12_" ft ",1:"")_$S(GMRVX(0)#12:GMRVX(0)#12_" in",1:"")_" ("_$J(GMRVX(0)*2.54,0,2)_" cm)" S GMRVHT=(GMRVX(0)*2.54)/100
 . I X="CG" S ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_GMRVX(0)_" in ("_$J(+GMRVX(0)/.3937,0,2)_" cm)"
 . I X="CVP" S ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_GMRVX(0)_" cmH2O ("_$J(GMRVX(0)/1.36,0,1)_" mmHg)"
 . I X="PO2" S ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_GMRVX(0)_"% "
 . I X="P"!(X="R")!(X="BP") S ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_GMRVX(0)
 . I X="PN" D  S ^TMP($J,"GRPC",GJ)=^(GJ)_GMRVX(0)
 . . I GMRVX(0)=0 S GMRVX(0)="0 - No pain" Q
 . . I GMRVX(0)=99 S GMRVX(0)="99 - Unable to respond" Q
 . . I GMRVX(0)=10 S GMRVX(0)="Pain class - 10 Worst imaginable pain" Q
 . . S GMVVX(0)="Pain class "_GMRVX(0) Q
 . S ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_$S('$D(GMRVX(1)):"",'GMRVX(1):"",1:"*") K GMRVX
 . D CHAR
 . I X="WT",$G(GMRVWT)>0,$G(GMRVHT)>0 D
 . . S ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_"  _"_GMVUSER
 . . S GJ=GJ+1,GMRVHT(1)=$J(GMRVWT/(GMRVHT*GMRVHT),0,0),^TMP($J,"GRPC",GJ)="Body Mass Index:",GMVUSER="" D
 . . .S GBLANK=$$REPEAT^XLFSTR(" ",29-$L(^TMP($J,"GRPC",GJ))),^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_GBLANK_GMRVHT(1)_$S(GMRVHT(1)>27:"*",1:"")
 . . . Q
 . . Q
 .S ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_"  "_$S(GMVUSER]"":"_",1:"")_GMVUSER
 . Q
Q K GMRVWT,GMRVHT,GMR,GMVD,GBP,GMRVARY,GMRVDA,GMRDATA,GMVDM,GLIN,GMRZZ
 K GMRVDT,GMROUT,%Y,GMRL,GMRDT,DIC,GMRDAT,GMRDATS,GMRSTR,GMRX,GMRVX,POP
 Q
SETDATAR ;
 S Y=0 F  S Y=$O(^GMR(120.5,"AA",DFN,GMR(X),GMRDAT,Y)) Q:Y'>0!GMRDATS  I '$D(^GMR(120.5,Y,2)),$P(^GMR(120.5,Y,0),"^",8)'="" D SETNODE
 D:X="BP"!(X="P") SETBP
 Q
SETNODE ;
 N G S GMRL=$S($D(^GMR(120.5,Y,0)):^(0),1:"")
 I X'="P" S G=$P(GMRL,"^",8) Q:"REFUSEDPASSUNAVAILABLE"[$$UP^XLFSTR(G)
 I X="P" S OK=0,G=$P(GMRL,"^",8) D  Q:'OK
 . I "REFUSEDPASSUNAVAILABLE"[$$UP^XLFSTR(G) Q
 . I '$D(^GMR(120.5,Y,5,"B")) S OK=1 Q
 . I $D(^GMR(120.5,Y,5,"B",GAPICAL)) S OK=1 Q
 . I $D(^GMR(120.5,Y,5,"B",GRADIAL)) S OK=1 Q
 . I $D(^GMR(120.5,Y,5,"B",GBRACH)) S OK=1 Q
 S GMRL1=$P(GMRL,"^") ;adding trailing zeros to time if necessary
 S $P(GMRL1,".",2)=$P(GMRL1,".",2)_"0000"
 S $P(GMRL1,".",2)=$E($P(GMRL1,".",2),1,4)
 S $P(GMRL,"^")=GMRL1
 K GMRL1
 I GMRL'="" S GMRDATA(X,$P(GMRL,"^"),Y)=$P(GMRL,"^",8),GMRDATS=1 I $P($G(^GMR(120.5,Y,5,0)),"^",4)>0 D CHAR^GMVCHAR(Y,.GMRVARY,GMR(X))
 Q
WRTDT ;
 S GMRVDT=$E(GMVD,4,5)_"/"_$E(GMVD,6,7)_"/"_$E(GMVD,2,3)_"@"_$E($P(GMVD,".",2),1,2)_$S($E($P(GMVD,".",2),3,4)'="":":"_$E($P(GMVD,".",2),3,4),1:"")
 Q
CHAR ;
 S GMRZZ=$$WRITECH(GMVD(1),.GMRVARY,5) S:GMRZZ'=""&(X'="PO2") GMRZZ="("_GMRZZ_")"
 I X="PO2",$P(^GMR(120.5,GMVD(1),0),"^",10)'="" S ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_"with supplemental O2" D
 . S GPO2=$P(^GMR(120.5,GMVD(1),0),"^",10)
 . S ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_" "_$S(GPO2["l/min":$P(GPO2," l/min")_" L/min",1:"")_$S(GPO2["l/min":$P(GPO2," l/min",2),1:GPO2)
 . K GPO2
 S:GMRZZ'="" ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_" "_GMRZZ K GMRZZ Q
 S:$G(GMRZZ)'="" ^TMP($J,"GRPC",GJ)=^TMP($J,"GRPC",GJ)_"  "_GMRZZ K GMRZZ
 Q
SETBP ;
 D SETBP^GMVLATS
 Q
WRITECH(GDA,GARRY,GN)   ;
 ; Input data:
 ; GDA - Pointer to the patient vitals/measurements data file #120.5
 ; GARRY - qualifier data array for a measurement
 ;         GARRY(GDA,Print order,qualifier data)
 ; GN - Number of print order to print
 N GMRVDA,GDATA
 S GDATA="",GMRVDA(1)=0
 F  S GMRVDA(1)=$O(GARRY(GDA,GMRVDA(1))) Q:GMRVDA(1)'>0!(GMRVDA(1)>GN)  S GMRVDA(2)="" F  S GMRVDA(2)=$O(GARRY(GDA,GMRVDA(1),GMRVDA(2))) Q:GMRVDA(2)=""  D
 . S GDATA=GDATA_","_GMRVDA(2)
 . Q
 I $E(GDATA,1)="," S GDATA=$E(GDATA,2,$L(GDATA)) ;strip off leading comma
 Q GDATA
