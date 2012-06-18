ORKCHK ; slc/CLA - Main routine called by OE/RR to initiate order checks ;29-Nov-2007 17:31;DKM
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**6,32,94,105,123,1005**;Dec 17, 1997
EN(ORKY,ORKDFN,ORKA,ORKMODE) ;initiate order checking
 ;ORKY: array of returned msgs in format: ornum^orderchk ien^clin danger^msg
 ;ORKDFN: patient dfn
 ;ORKA: array of order information in the format:
 ; orderable item ien|
 ; display group-filler app|
 ; nat'l id^nat'l text^nat'l code sys^local id^local text^local code sys|
 ; effective d/t|
 ; order number|
 ; filler data (LR: specimen ien, PS: meds prev ordered during this session in format med1^med2^...)
 ;ORKMODE: mode/event trigger (DISPLAY,SELECT,ACCEPT,SESSION,ALL,NOTIF)
 ; PS: meds previously ordered during this session med1^med2^...
 ;
 N ORKQ,ORKN S ORKQ=0,ORKN=1
 S:+$G(ORKDFN)<1 ORKY(ORKN)="^^^Order Checking Unavailable - invalid patient id",ORKQ=1,ORKN=ORKN+1
 S:'$L($G(ORKMODE)) ORKY(ORKN)="^^^Order Checking Unavailable - invalid mode/event",ORKQ=1,ORKN=ORKN+1
 Q:$G(ORKQ)=1
 Q:+$G(ORKA)<1
 N ORKX,ORKS,DNGR,ORENT,ORKENT,ORKNENT,ORNUM,ORKOFF,ORKTMODE
 N ORKADUZ,ORKNDUZ,ORKI,ORKPRIM,ORKNMSG,ORKMSG,ORKLOG,ORKLD,ORKLI,ORKOI
 N ORKDG,ORKLPS,ORKPSA,ORKCNT,ORKDGI
 ;
 ;save array of orders for use in session processing:
 M ^TMP("ORKA",$J)=ORKA
 ;
 ;get patient's location flag (INPATIENT ONLY - outpt locations cannot be
 ;reliably determined, and many simultaneous outpt locations can occur):
 N DFN,ORKLOC
 S DFN=ORKDFN,VA200="" D OERR^VADPT
 S ORKLOC=+$G(^DIC(42,+VAIN(4),44))
 K VA200,VAIN
 ;
 ;get user's service/section flag:
 N ORKSRV
 S ORKSRV=$G(^VA(200,DUZ,5)) I +ORKSRV>0 S ORKSRV=$P(ORKSRV,U)
 ;
 ;log order check debug messages (or not)
 S ORKLOG=$$GET^XPAR("DIV^SYS^PKG","ORK DEBUG ENABLE/DISABLE",1,"I")
 I $G(ORKLOG)="D" K ^XTMP("ORKLOG") S ^XTMP("ORKLOG",0)=""
 I +$P($G(^XTMP("ORKLOG",0)),U,3)>5000 K ^XTMP("ORKLOG")
 ;
 ;if SESSION mode & pharmacy order occurred in session get unsigned med orders
 I ORKMODE="SESSION" D
 .S ORKDG=$P(ORKA(1),"|",2)
 .I $E($G(ORKDG),1,2)="PS" D
 ..S ORKDGI=0,ORKDGI=$O(^ORD(100.98,"B","PHARMACY",ORKDGI))
 ..K ^TMP("ORR",$J)
 ..D EN^ORQ1(DFN_";DPT(",ORKDGI,11,"","","",0,0)
 ..;store unsigned med orders in ^TMP("ORR",$J for processing in ORKPS
 ;
 ;main processing loop:
 S ORKX="" F  S ORKX=$O(ORKA(ORKX)) Q:ORKX=""  D
 .S ORKOI=$P(ORKA(ORKX),"|")
 .;
 .;log debug msgs if parameter is enabled:
 .I $G(ORKLOG)="E" D
 ..S ORKLD=$$NOW^XLFDT
 ..S ORKLI=0
 ..I +$P($G(^XTMP("ORKLOG",0)),U,3)<1 S $P(^XTMP("ORKLOG",0),U,3)=0
 ..S ORKCNT=$P(^XTMP("ORKLOG",0),U,3)+1
 ..S ^XTMP("ORKLOG",0)=$$FMADD^XLFDT(ORKLD,3,"","","")_U_ORKLD_U_ORKCNT
 ..S ^XTMP("ORKLOG",ORKLD,ORKDFN,+$G(ORKOI),ORKMODE,DUZ,ORKLI)=ORKA(ORKX)
 .;
 .S ORKDG=$P(ORKA(ORKX),"|",2),ORKTMODE=""
 .S ORKENT="USR^LOC.`"_+$G(ORKLOC)_"^SRV.`"_+$G(ORKSRV)_"^DIV^SYS^PKG"
 .Q:'$L($G(ORKDG))
 .;
 .;if pharmacy order and multiple pharmacy orders in session add data node:
 .I $E(ORKDG,1,2)="PS",($L($G(ORKPSA))) D
 ..S $P(ORKA(ORKX),"|",6)=ORKPSA
 .;
 .S ORNUM=$P(ORKA(ORKX),"|",5)
 .; get correct DUZ for notification processing if in NOTIF mode:
 .I ORKMODE="NOTIF" D
 ..S:+$G(ORNUM)>0 ORKNDUZ=$$ORDERER^ORQOR2(ORNUM) ;ordering provider
 ..S:+$G(ORNUM)<1 ORKNDUZ=$P($$PRIM^ORQPTQ4(ORKDFN),U) ;prim provider
 ..I +$G(ORKNDUZ)>0 D
 ...S ORKSRV=$G(^VA(200,ORKNDUZ,5)) I +ORKSRV>0 S ORKSRV=$P(ORKSRV,U)
 ...S ORKNENT="USR.`"_+ORKNDUZ_"^LOC.`"_+$G(ORKLOC)_"^SRV.`"_+$G(ORKSRV)_"^DIV^SYS^PKG"
 ..S:+$G(ORKNDUZ)<1 ORKNENT="LOC.`"_+$G(ORKLOC)_"^DIV^SYS^PKG"
 .S ORENT=$S(ORKMODE="NOTIF":ORKNENT,1:ORKENT)
 .;
 .;If the order is a delayed release order (NOTIF) process all nodes.
 .;If it is a renewal, edit or delayed signature order (ALL) process all
 .;modes except SESSION which gets processed just before signature:
 .I ORKMODE="NOTIF"!(ORKMODE="ALL") S ORKTMODE=ORKMODE D
 ..D EN^ORKCHK3(.ORKS,ORKDFN,ORKA(ORKX),ORENT,ORKTMODE)  ;DISPLAY
 ..D EN^ORKCHK4(.ORKS,ORKDFN,ORKA(ORKX),ORENT,ORKTMODE)  ;SELECT
 ..D EN^ORKCHK5(.ORKS,ORKDFN,ORKA(ORKX),ORENT,ORKTMODE)  ;ACCEPT
 ..I ORKMODE="NOTIF" D EN^ORKCHK6(.ORKS,ORKDFN,ORKA(ORKX),ORENT,ORKTMODE)  ;SESSION
 ..S ORKMODE=ORKTMODE
 .;
 .;Process regular orders/modes:
 .I '$L($G(ORKTMODE)) D
 ..I ORKMODE="DISPLAY" D EN^ORKCHK3(.ORKS,ORKDFN,ORKA(ORKX),ORENT,ORKTMODE)
 ..I ORKMODE="SELECT" D EN^ORKCHK4(.ORKS,ORKDFN,ORKA(ORKX),ORENT,ORKTMODE)
 ..I ORKMODE="ACCEPT" D EN^ORKCHK5(.ORKS,ORKDFN,ORKA(ORKX),ORENT,ORKTMODE)
 ..I ORKMODE="SESSION" D EN^ORKCHK6(.ORKS,ORKDFN,ORKA(ORKX),ORENT,ORKTMODE)
 ..I ORKMODE="MANUAL" D EN^ORKCHKM(.ORKS,ORKDFN,ORKA(ORKX),ORENT,ORKTMODE) ;IHS/MSC/DKM - Support for manual checks
 ;
 ;set messages into sorting array then into ORKY ORKS("ORK",clinical danger level,oi,msg)=ornum^order check ien^clin danger level^message
 S ORKX="",ORKI=1
 F  S ORKX=$O(ORKS("ORK",ORKX)) Q:ORKX=""  D
 .S ORKY(ORKI)=$E(ORKS("ORK",ORKX),1,250)
 .;
 .;log debug msgs if parameter is enabled:
 .I $G(ORKLOG)="E" D
 ..S ORKLI=$G(ORKLI)+1
 ..S ^XTMP("ORKLOG",$$NOW^XLFDT,ORKDFN,+$G(ORKOI),ORKMODE,DUZ,ORKLI)=ORKY(ORKI)
 ..S $P(^XTMP("ORKLOG",0),U,3)=$P($G(^XTMP("ORKLOG",0)),U,3)+1
 .;
 .;send moderate and high danger order checks for delayed orders as notifications:
 .I ORKMODE="NOTIF" S DNGR=$P(ORKY(ORKI),U,3) I $G(DNGR)<3 D
 ..S ORKADUZ="",ORNUM=$P(ORKY(ORKI),U)
 ..S:+$G(ORKNDUZ)>0 ORKADUZ(ORKNDUZ)=""
 ..S ORKNMSG="Order check: "_$P(ORKY(ORKI),U,4)
 ..D EN^ORB3(54,ORKDFN,$G(ORNUM),.ORKADUZ,ORKNMSG,"")
 .S ORKI=ORKI+1
 ;
 K ^TMP("ORKA",$J),^TMP("ORR",$J)
 I $G(ORKLOG)="E" D
 .S ORKLI=$G(ORKLI)+1
 .S ^XTMP("ORKLOG",$$NOW^XLFDT,ORKDFN,+$G(ORKOI),ORKMODE,DUZ,ORKLI)="LEAVING ORDER CHECKING"
 .S $P(^XTMP("ORKLOG",0),U,3)=$P($G(^XTMP("ORKLOG",0)),U,3)+1
 Q
 ;
OI2DD(ORPSA,OROI,ORPSPKG) ;rtn dispense drugs for a PS OI
 N PSOI
 Q:'$D(^ORD(101.43,OROI,0))
 S PSOI=$P($P(^ORD(101.43,OROI,0),U,2),";")
 Q:+$G(PSOI)<1
 D DRG^PSSUTIL1(.ORPSA,PSOI,ORPSPKG)
 Q
