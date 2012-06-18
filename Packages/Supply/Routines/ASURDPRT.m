ASURDPRT ; IHS/ITSC/LMH -DAILY UPDATE REPORTS DRIVER ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine controls the sequence of printing of all reports created
 ;during a daily (including monthly and yearly) update run.
 K IO("Q")
 S XBRP="ST^ASURDPRT"
 K XBRC
 S XBRX="STAT^ASUPUKIL"
 S XBIOP=ASUK("SRPT","IOP")
 S ASUK("PTR")="SRPT"
 D Q^ASUUZIS
IV ;EP; TASKMAN
 ;I $G(ASUP("RE*"))=2 S:ASUP("CKP")=6 ASUP("CKP")=7 Q
 S ASUP("CKP")=$G(ASUP("CKP")) I ASUP("CKP")]"",ASUP("CKP")'=6 Q
 S ASUK("PTR")="IRPT",ASUK("PTRSEL")=1
 S ASUK("PTR-Q")=ASUK("IRPT","Q")
 S IOP=ASUK("IRPT","IOP")
 I ASUK("PTR-Q") D
 .I $D(IOF),IOF']"" S IOP=ASUK(ASUK("PTR"),"IOF")
 E  D
 .I ASUK(ASUK("PTR"),"ION")["HOST"!(ASUK(ASUK("PTR"),"ION")["HFS") D
 ..S IOPAR=ASUK(ASUK("PTR"),"IOPAR")
 .E  D
 ..I ASUP("AIV")=0 Q
 ..W !!,"Mount 8 1/2 X 11 Paper on Printer ",ASUK("IRPT","ION")
 ..K DIR S DIR(0)="E",DTIME=2 D ^DIR S DTIME=$$DTIME^XUP(DUZ) Q:$D(DUOUT)
 ..I $D(DTOUT) K DTOUT W !,"Timed out -assumed forms were correctly mounted"
 .D O^ASUUZIS
 Q:$D(DTOUT)  Q:$D(DUOUT)  I $D(POP) Q:POP
 D PSER^ASURDINV
 Q
ST ;EP; TASKAMN DOUBLE OR SINGLE QUEING
 S ASUP("CKP")=$G(ASUP("CKP"))
 I ASUP("CKP")]"",ASUP("CKP")'=7 Q
 S ASUK("PTR")="SRPT",ASUK("PTRSEL")=1
 S ASUK("PTR-Q")=ASUK("SRPT","Q")
 S IOP=ASUK("SRPT","IOP")
 I ASUK("PTR-Q") D
 .I $D(IOF),IOF']"" S IOP=ASUK(ASUK("PTR"),"IOF")
 E  D
 .I ASUK(ASUK("PTR"),"ION")["HOST"!(ASUK(ASUK("PTR"),"ION")["HFS") D
 ..S IOPAR=ASUK(ASUK("PTR"),"IOPAR")
 .E  D
 ..I ASUP("AST")=0 Q
 ..W !!,"Mount Standard Computer Paper on Printer ",ASUK("SRPT","ION")
 ..K DIR S DIR(0)="E",DTIME=2 D ^DIR S DTIME=$$DTIME^XUP(DUZ) Q:$D(DUOUT)
 ..I $D(DTOUT) K DTOUT W !,"Timed out -assumed forms were correctly mounted"
 .D O^ASUUZIS
 Q:$D(DTOUT)  Q:$D(DUOUT)  Q:POP
 D PSER^ASURDSTD,SETSTAT^ASUCOSTS
 I ASUP("CKS")=0 S ASUP("CKP")=0 D SETSTAT^ASUCOSTS
 Q
