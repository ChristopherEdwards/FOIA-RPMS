BDMP110 ; IHS/CMI/LAB -IHS -GETS DATA FOR DIABETES QA REPORT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**4**;JUN 14, 2007
 ;
 ;
EN ; - ENTRY POINT - from ^BDMASK
 K ^BDMDATA("BDMEPI",$J)
 S ^XTMP("BDMP11",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^PRE DM AUDIT 2011"
 S BDMEPIN=0
 S BDMPD=0 F  S BDMPD=$O(^XTMP("BDMP11",BDMJOB,BDMBTH,"PATS",BDMPD)) Q:'BDMPD  D
 .I BDMTYPE'="P",BDMTYPE'="S" Q:$$DEMO^BDMUTL(BDMPD,$G(BDMDEMO))
 .;I BDMPREP=2 D EPIREC Q
 .D GATHER
 ;I BDMPREP=2 D WRITEF^BDMP11 Q
 I BDMPREP=2!(BDMPREP=3) D CUML^BDMP115
 Q
S(P,I,V) ;
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",P,I)=V
 Q
GATHER ;gather data for 1 patient
 S BDMER=0
HEADER ; Set node with report header info
 ;set report dates
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,1)=$S($G(BDMFISC)]"":BDMFISC,1:BDMRBD_" - "_BDMRED)
 ;set audit date to DT
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,2)=$$FMTE^XLFDT(DT)
 ;set area, su, facility code and name
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,4)=$P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U)
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,6)=$E($P(^AUTTLOC($S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U,10),1,2)
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,8)=$E($P(^AUTTLOC($S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U,10),3,4)
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,10)=$E($P(^AUTTLOC($S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U,10),5,6)
 ;# pats in register
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,12)=$S(BDMDMRG:$$RSTAT^BDMDM6(BDMDMRG,"A"),1:"")
 ;reviewer
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,14)=$P(^VA(200,DUZ,0),U,2)
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,15)=$$VAL^XBDIQ1(9000001,BDMPD,.14)
DEMO ;pat demographics
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,16)=$$HRN^AUPNPAT(BDMPD,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)))
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,18)=$$DOB^AUPNPAT(BDMPD,"E")
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,20)=$$VAL^XBDIQ1(2,BDMPD,.02)
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,120)=$$TRIBE(BDMPD)
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,121)=$$COMM(BDMPD)
DXDT ;dates of and dm dxs
 K BDMDATA D IFG^BDMP113(BDMPD,.BDMDATA)
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,200)=$S($D(BDMDATA):"Yes",1:"No")
 S X=0 F  S X=$O(BDMDATA(X)) Q:X'=+X  D
 .S Y=200_"."_X
 .S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,Y)=BDMDATA(X)
 K BDMDATA D IGT^BDMP113(BDMPD,.BDMDATA)
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,210)=$S($D(BDMDATA):"Yes",1:"No")
 S X=0 F  S X=$O(BDMDATA(X)) Q:X'=+X  D
 .S Y=210_"."_X
 .S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,Y)=BDMDATA(X)
 K BDMDATA D MS^BDMP113(BDMPD,.BDMDATA)
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,220)=$S($D(BDMDATA):"Yes",1:"No")
 S X=0 F  S X=$O(BDMDATA(X)) Q:X'=+X  D
 .S Y=220_"."_X
 .S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,Y)=BDMDATA(X)
 K BDMDATA D ABNG^BDMP113(BDMPD,.BDMDATA)
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,230)=$S($D(BDMDATA):"Yes",1:"No")
 S X=0 F  S X=$O(BDMDATA(X)) Q:X'=+X  D
 .S Y=230_"."_X
 .S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,Y)=BDMDATA(X)
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,22)=$S(BDMDMRG:$$CMSFDX^BDMP113(BDMPD,BDMDMRG,"D"),1:"")
 S ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,24)=$S(BDMDMRG:$$CMSFDX^BDMP113(BDMPD,BDMDMRG,"DX"),1:"")
 I $$PLDMDXS^BDMP113(BDMPD)]"" D S(BDMPD,25,"PLEASE NOTE:  Diabetes is on the Problem list for this patient")
 S X=$$FRSTDMDX^BDMP113(BDMPD,"E") I X]"" D S(BDMPD,26,"PLEASE NOTE:  Diabetes has been used as a diagnosis in PCC: "_X)
 D S(BDMPD,27,$$TOBACCO^BDMP116(BDMPD,BDMRED))
 D S(BDMPD,28,$$CESS^BDMP111(BDMPD,BDMRBD,BDMRED))
VITAL ;
 D S(BDMPD,30,$$LASTHT^BDMP113(BDMPD,BDMRED))
 D S(BDMPD,32,$$LASTWT^BDMP113(BDMPD,BDMRED))
 D S(BDMPD,33,$$LASTWC^BDMP113(BDMPD,BDMRED))
 ;htn dx
 D S(BDMPD,34,$$HTNDX^BDMP113(BDMPD,BDMRED))
 ;last 3 BPs
 D S(BDMPD,36,$$BPS^BDMP113(BDMPD,BDMRBD,BDMRED))
EXAMS ;
 D S(BDMPD,44,$$DIETEDUC^BDMP117(BDMPD,BDMRBD,BDMRED))
 D S(BDMPD,46,$$EXEDUC^BDMP117(BDMPD,BDMRBD,BDMRED))
THERAPY ;
 S BDM6MBD=$$FMADD^XLFDT(BDMADAT,-(6*31)),BDM6MBD=$$FMTE^XLFDT(BDM6MBD)
 D S(BDMPD,53,$$SULF^BDMP112(BDMPD,BDM6MBD,BDMRED))
 D S(BDMPD,54,$$MET^BDMP112(BDMPD,BDM6MBD,BDMRED))
 D S(BDMPD,55,$$ACAR^BDMP112(BDMPD,BDM6MBD,BDMRED))
 D S(BDMPD,56,$$TROG^BDMP112(BDMPD,BDM6MBD,BDMRED))
 S Y="" F X=53:1:56 I ^XTMP("BDMP11",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)="X" S Y=1
 D S(BDMPD,51,$S(Y:"",1:"X"))
 D S(BDMPD,60,$$ACE^BDMP116(BDMPD,BDM6MBD,BDMRED))
IMM ;
 D S(BDMPD,62,$$ASPIRIN^BDMP116(BDMPD,BDMRBD,BDMRED))
 D S(BDMPD,61,$$LIPID^BDMP116(BDMPD,BDM6MBD,BDMRED))
 D S(BDMPD,76,$$EKG^BDMP112(BDMPD,BDMRED))
LABS ;
 D S(BDMPD,90,$$FGLUCOSE^BDMD718(BDMPD,$P(^DPT(BDMPD,0),U,3),BDMADAT))
 D S(BDMPD,91,$$G75^BDMD718(BDMPD,$P(^DPT(BDMPD,0),U,3),BDMADAT))
 D S(BDMPD,86,$$CHOL^BDMD718(BDMPD,BDMBDAT,BDMADAT))
 D S(BDMPD,88,$$LDL^BDMD718(BDMPD,BDMBDAT,BDMADAT))
 D S(BDMPD,89,$$HDL^BDMD718(BDMPD,BDMBDAT,BDMADAT))
 D S(BDMPD,90,$$TRIG^BDMD718(BDMPD,BDMBDAT,BDMADAT))
 ;
 D S(BDMPD,112,$$BMI^BDMD718(BDMPD,BDMRBD,BDMRED))
 Q
DATE(D) ;EP
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+($E(D,1,3)))
TRIBE(P) ;EP
 I '$G(P) Q ""
 I '$D(^AUPNPAT(P,11)) Q ""
 Q $$TRIBE^AUPNPAT(P,"C")_"^"_$$TRIBE^AUPNPAT(P,"E")
COMM(P) ;EP
 I '$G(P) Q ""
 I '$D(^AUPNPAT(P,11)) Q ""
 Q $$COMMRES^AUPNPAT(P,"C")_"^"_$$COMMRES^AUPNPAT(P,"E")