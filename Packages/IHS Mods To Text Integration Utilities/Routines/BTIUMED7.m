BTIUMED7 ; SLC/JM - Active/Recent Med Objects Routine ;03-Oct-2012 14:44;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1010**;Jun 20, 1997;Build 24
 Q
VMED(TARGET,FILLS) ;EP; returns medications for current vuecentric visit context
 ; If SIG is set to 1, include medication sig
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 NEW VST,I,X,CNT,RESULT
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 Q
 D GETMED(.RESULT,VST)
 ;
 K @TARGET S CNT=0
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Medications Found for Visit"
 Q "~@"_$NA(@TARGET)
 ;
GETMED(RETURN,VIEN) ;EP returns all medications given for a visit
 NEW TIUX,TIUY,COUNT,TIUIS,TIULF,TIUPRV,TIURE,TIURF,RXNO,RX,TRM
 K RETURN
 S COUNT=0
 S TIUX=0,TIUY="" F  S TIUX=$O(^AUPNVMED("AD",VIEN,TIUX)) Q:'TIUX  D
 . S TIUY=$$GET1^DIQ(9000010.14,TIUX,.01)
 . S RXNO=$$GET1^DIQ(9000010.14,TIUX,1102)
 . S RX="" S RX=$O(^PSRX("B",RXNO,RX))
 . I +RX D
 ..Q:+$$GET1^DIQ(52,RX,9999999.23)        ;Quit if autofinished
 ..S TIUIS=$$GET1^DIQ(52,RX,1)
 ..S TIULF=$$GET1^DIQ(52,RX,101)
 ..S TIUPRV=$$GET1^DIQ(52,RX,4)
 ..S TRM=0
 ..F I=0:0 S I=$O(^PSRX(RX,1,I)) Q:'I  S TRM=TRM+1
 ..S TIURF=$P($G(^PSRX(RX,0)),"^",9)-TRM
 ..I COUNT>0 S COUNT=COUNT+1 S RETURN(COUNT)=""
 ..S COUNT=COUNT+1
 ..S RETURN(COUNT)=TIUY
 ..S COUNT=COUNT+1
 ..S RETURN(COUNT)="Issue: "_TIUIS_" Last Fill: "_TIULF
 ..S COUNT=COUNT+1
 ..S RETURN(COUNT)="Refills Left: "_TIURF_" Provider: "_TIUPRV
 ..I $G(FILLS) D FILLS(.RETURN,VIEN)
 Q
FILLS(RETURN,VIEN) ;Create and add nodes for fills and past fills.
 ;$G(^TMP("PS",$J,INDEX,0))
 K FILL
 N RFS,RF,RX2,RFL,FILL,II,PSIII,X,Y,Z,NRXN
 S RX2=$S($D(^PSRX(RX,2)):^PSRX(RX,2),1:"")
 S RFL=1
 D FILOOP(RX,RX2)
 S Y=""
 F PSIII=0:0 S PSIII=$O(FILL(PSIII)) Q:'PSIII  D
 .S X=$P($G(FILL(PSIII)),U,1)
 .I X=0 Q
 .S Z=$$FMTE^XLFDT(X)
 .I Y="" S Y=Z
 .E  S Y=Y_", "_Z
 I Y'="" D
 .S COUNT=COUNT+1
 .S RETURN(COUNT)="Previous fills:"
 .S COUNT=COUNT+1
 .S RETURN(COUNT)=" "_Y
 I RFL<6 D
 .K FILL
 .S Y=""
 .S NRXN=$P($G(^PSRX(RX,"OR1")),U,3)
 .I NRXN'="" D
 ..S RX2=$S($D(^PSRX(NRXN,2)):^PSRX(NRXN,2),1:"")
 ..D FILOOP(NRXN,RX2)
 ..F PSIII=0:0 S PSIII=$O(FILL(PSIII)) Q:'PSIII  D
 ...S X=$P($G(FILL(PSIII)),U,1)
 ...I X=0 Q
 ...S Z=$$FMTE^XLFDT(X)
 ...I Y="" S Y=Z
 ...E  S Y=Y_", "_Z
 I Y'="" D
 .S COUNT=COUNT+1
 .S RETURN(COUNT)="Past fills:"
 .S COUNT=COUNT+1
 .S RETURN(COUNT)=" "_Y
 Q
FILOOP(RX,RX2) ;
 S FILL(9999999-$P(RX2,"^",2))=+$P(RX2,"^",2)_"^"_$S($P(RX2,"^",15):"(R)",1:""),FILLS=+$P($G(^PSRX(RX,0)),"^",9)
 F II=0:0 S II=$O(^PSRX(RX,1,II)) Q:'II  S FILL(9999999-^PSRX(RX,1,II,0))=+^PSRX(RX,1,II,0)_"^"_$S($P(^(0),"^",16):"(R)",1:"") S RFL=RFL+1
 Q
 ;
