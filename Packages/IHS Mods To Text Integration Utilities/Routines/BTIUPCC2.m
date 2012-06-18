BTIUPCC2 ;IHS/CIA/MGH - TIU Object Support ;30-Jul-2010 08:33;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1003,1004,1005,1006**;NOV 04,2004
 ;New routine for objects added for TIU use
 ;Patch 1004 fixed logic for medications with different doses
 ;Patch 1005 added last dispensed date
 ;Patch 1005 fixed a problem with the med lookup
 ;Patch 1006 added a counter for the number of meds to return and added meds on hold
PRIMPROV() ;Return primary provider name for visit from V Provider file
 N VSIT,PRVNAME,PIEN
 S PRVNAME="Unknown"
 S VSIT=$P($$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID","","CONTEXT.ENCOUNTER"),";",4)
 Q:'VSIT "Invalid visit"
 S PIEN=0
 F  S PIEN=$O(^AUPNVPRV("AD",VSIT,PIEN)) Q:'PIEN  D  Q:PRVNAME'="Unknown"
 .I $P(^AUPNVPRV(PIEN,0),U,4)="P" D
 ..S PRVNAME=$P(^VA(200,+^AUPNVPRV(PIEN,0),0),U,1)
 Q PRVNAME
 ;
ALLPROV(TARGET) ;Return all provider's names for visit from V Provider File
 N VSIT,CNT,PIEN
 K @TARGET
 S VSIT=$P($$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID","","CONTEXT.ENCOUNTER"),";",4)
 I 'VSIT D
 .S @TARGET@(1,0)="Visit undefined"
 E  D
 .S CNT=0
 .S PIEN=0
 .F  S PIEN=$O(^AUPNVPRV("AD",VSIT,PIEN)) Q:'PIEN  D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)=$P(^VA(200,+^AUPNVPRV(PIEN,0),0),U,1)
 .I CNT=0 S @TARGET@(1,0)="No provider for visit"
 Q "~@"_$NA(@TARGET)
 ;
LASTMED(DFN,BTIUMED,TARGET,VDC,CNT) ;Return Last Rx for drug or class selected.
 ;VDC is a flag, if 1 use VA drug class, if 0 or null use drug name
 ;BTIUMED is either drug name or VA drug class depending on VDC.
 ;does not have to be exact match with .01 field of file.  Uses all lookup X-ref's on file
 ;For example a look up on aspirin will return all dosage forms for that drug.
 ;TARGET is the name of the array to store the results in
 N BTIUDRG,BTIUERR,FILE,INDX,DA,DRUG,SIG,RXIEN,IEN,IENS,INVDATE,N,I,EVENT,ARRAY
 N CHRONIC,COUNTER,DRUGIEN,EXDATE,LDATE,LINE,REASON,STATUS,X1,X2,X,CANDATE
 K @TARGET
 I '$D(CNT) S CNT=1
 S FILE=$S($G(VDC):50.605,1:50)
 I FILE=50 D FIND^DIC(FILE,"",".01;@","M",BTIUMED,"","","","","BTIUDRG","BTIUERR")
 I FILE=50.605 D
 .S BTIUDRG("DILIST",2,1)=$$FIND1^DIC(FILE,"","M",BTIUMED,"","","BTIUERR")
 .S $P(BTIUDRG("DILIST",0),U)=1
 I $D(BTIUERR("DIERR")) D
 .;Process the error
 .I $D(BTIUERR("DIERR","E",202)) D
 ..S @TARGET@(1,0)="Missing or invalid drug "_$S($G(VDC):"class",1:"name")
 .E  S @TARGET@(1,0)=$G(BTIUERR("DIERR",1,"TEXT",1))
 E  D
 .S INDX=0
 .F  S INDX=$O(BTIUDRG("DILIST",2,INDX)) Q:'INDX  D
 ..I FILE=50.605 D            ;Get the list of drug ien's corresponding to the drug classes
 ...S DA=0
 ...F  S DA=$O(^PSDRUG("VAC",BTIUDRG("DILIST",2,INDX),DA)) Q:'DA  D
 ....S BTIUDRG(DA)=""
 ..E  I FILE=50 D             ;Just copy  the drug ien's
 ...S BTIUDRG(BTIUDRG("DILIST",2,INDX))=""
 .I $G(VDC)=1 D
 ..S N="" S N=$O(^PS(50.605,"B",BTIUMED,N)) Q:N=""  D
 ...S BTIUMED=N
 .S @TARGET@(1,0)="No Rx found for: "_BTIUMED
 .I $P(BTIUDRG("DILIST",0),U)=0 Q
 .S DRUG=""
 .S INVDATE=0
 .F  S INVDATE=$O(^AUPNVMED("AA",DFN,INVDATE)) Q:'INVDATE  D  ;Q:DRUG]""
 ..S DA=0
 ..F  S DA=$O(^AUPNVMED("AA",DFN,INVDATE,DA)) Q:'DA  D  ;Q:DRUG]""
 ...S DRUGIEN=+^AUPNVMED(DA,0)
 ...S IEN=0
 ...F  S IEN=$O(BTIUDRG(IEN)) Q:'IEN  D  ;Q:DRUG]""
 ....I IEN=DRUGIEN D
 .....S DRUG=$P(^PSDRUG(IEN,0),U)
 .....S EVENT=$$GET1^DIQ(9000010.14,DA_",",1201,"","","BTIUERR")
 .....S ARRAY(INVDATE,DA)=DRUG_"^"_EVENT
 .;after you get all the drugs into the array take number requested
 .S COUNTER=1,LINE=0
 .S I="" F  S I=$O(ARRAY(I)) Q:I=""!(COUNTER>CNT)  D
 ..S DA="" F  S DA=$O(ARRAY(I,DA)) Q:DA=""  D
 ...S COUNTER=COUNTER+1
 ...S DRUG=$P(ARRAY(I,DA),U,1),EVENT=$P(ARRAY(I,DA),U,2)
 ...S SIG=$P(^AUPNVMED(DA,0),U,5)
 ...S RXIEN=$O(^PSRX("APCC",DA,""))
 ...I 'RXIEN D  Q
 ....S LINE=LINE+1
 ....S @TARGET@(LINE,0)="Last Rx for: "_DRUG
 ....S LINE=LINE+1
 ....S @TARGET@(LINE,0)="Sig: "_SIG
 ....S LINE=LINE+1
 ....S @TARGET@(LINE,0)="Event date: "_EVENT
 ...S IENS=RXIEN_","
 ...K BTIUERR,BTIUDAT
 ...D GETS^DIQ(52,IENS,"1;22;100;101;9999999.02","","BTIUDAT","BTIUERR")
 ...I $D(BTIUERR("DIERR")) D  Q
 ....;Process the error
 ....S LINE=LINE+1
 ....S @TARGET@(LINE,0)=$G(BTIUERR("DIERR",1,"TEXT",1))
 ...S STATUS=BTIUDAT(52,IENS,100)
 ...S CHRONIC=BTIUDAT(52,IENS,9999999.02)
 ...I STATUS="EXPIRED" D  Q:LDATE>EXDATE
 ....S EXDATE=$$GET1^DIQ(52,IENS,26,"I")
 ....I CHRONIC S X1=DT,X2=-120 D C^%DTC S LDATE=X
 ....E  S X1=DT,X2=-14 D C^%DTC S LDATE=X
 ...I STATUS="DISCONTINUED" D  Q:LDATE>CANDATE
 ....S CANDATE=$$GET1^DIQ(52,IENS,26.1,"I")
 ....S X1=DT,X2=-30 D C^%DTC S LDATE=X
 ...S LINE=LINE+1
 ...S @TARGET@(LINE,0)="Last Rx for: "_DRUG
 ...S LINE=LINE+1
 ...S @TARGET@(LINE,0)="Sig: "_SIG
 ...;issue date #1, 0;13
 ...;fill date #22, 2;2
 ...;status #100, STA;1
 ...S LINE=LINE+1
 ...S @TARGET@(LINE,0)="Issue date: "_BTIUDAT(52,IENS,1)
 ...S LINE=LINE+1
 ...S @TARGET@(LINE,0)="Fill date: "_BTIUDAT(52,IENS,22)
 ...S LINE=LINE+1
 ...S @TARGET@(LINE,0)="Last Dispensed date: "_BTIUDAT(52,IENS,101)
 ...S LINE=LINE+1
 ...S @TARGET@(LINE,0)="Status: "_BTIUDAT(52,IENS,100)
 ...I STATUS="HOLD" D
 ....S REASON=$$GET1^DIQ(52,IENS,99,"E")
 ....S LINE=LINE+1 S @TARGET@(LINE,0)="Reason for hold: "_REASON
 ...S LINE=LINE+1 S @TARGET@(LINE,0)="  "
 Q "~@"_$NA(@TARGET)
 ;
FNAME(DFN) ;Patient First name
 N FULNAME,FIRSTN
 S FULNAME=$$NAME^TIULO(DFN)
 S FIRSTN=$P($P(FULNAME,",",2)," ",1)
 I FIRSTN="" S FIRSTN="UNKNOWN"
 Q FIRSTN
LNAME(DFN) ;Patient Last Name
 N FULNAME,LASTN
 S FULNAME=$$NAME^TIULO(DFN)
 S LASTN=$P(FULNAME,",",1)
 Q LASTN
