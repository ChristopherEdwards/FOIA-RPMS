AZHWTEST ; IHS/SD/EFG - TEST ROUTINE at 7/17/2003 11:13:08 AM
 ;
 ;Q
PRVT ; FIND ANY PRIVATE ELIG MISSING INSURER POINTER
 W !,"If you answer ""NO"" or ""YES"" to ""Deleting"" the records, you will "
 W !,"             see the records displayed on the screen.",!!
 K DIR,ANSWER
 S DIR(0)="Y"
 S DIR("A")="DO YOU WANT TO DELETE THE BAD RECORDS IN AUPNPRVT "
 S DIR("B")="NO"
 D ^DIR S ANSWER=Y
 Q:$D(DIRUT)
 S RECNO=0
 F  S RECNO=$O(^AUPNPRVT(RECNO)) Q:'RECNO  D
 . S D1=0
 . F  S D1=$O(^AUPNPRVT(RECNO,11,D1)) Q:'D1  D
 .. I $P($G(^AUPNPRVT(RECNO,11,D1,0)),U,1)=""  D
 ... W !,"NO INSURER POINTER AT ","^AUPNPRVT(",RECNO,",11,",D1,",0)=",$G(^AUPNPRVT(RECNO,11,D1,0))
 ... I ANSWER=1 K ^AUPNPRVT(RECNO,11,D1,0)
 Q
INS ; FIND INSURER RECORDS MISSING ZERO NODE
 W !,"If you answer ""NO"" or ""YES"" to ""Deleting"" the records, you will "
 W !,"             see the records displayed on the screen.",!!
 K DIR,ANSWER
 S DIR(0)="Y"
 S DIR("A")="DO YOU WANT TO DELETE THE BAD RECORDS IN AUTNINS "
 S DIR("B")="NO"
 D ^DIR S ANSWER=Y
 Q:$D(DIRUT)
 S RECNO=0
 F  S RECNO=$O(^AUTNINS(RECNO)) Q:'RECNO  D
 . I '$D(^AUTNINS(RECNO,0))  D
 .. W !,"AUTNINS ENTRY MISSING ZERO NODE = ",RECNO
 .. I ANSWER=1 S DIK="^AUTNINS(",DA=RECNO D ^DIK
 .. S BNAME=""
 .. F  S BNAME=$O(^AUTNINS("B",BNAME)) Q:BNAME=""  D
 ... I $D(^AUTNINS("B",BNAME,RECNO))  D
 .... I ANSWER=1 K ^AUTNINS("B",BNAME,RECNO)
 Q
